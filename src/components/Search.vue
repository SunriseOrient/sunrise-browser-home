<template>
  <div id="search">
    <div class="name">
      <i class="iconfont" :class="engine.alIcon"></i>
      {{engine.name}}
    </div>
    <div class="input">
      <el-input size="large" v-model="query" :placeholder="engine.placeholder">
        <template #append>
          <div class="search-append">
            <el-dropdown size="large" trigger="click" @command="engineChange">
              <div class="search-engine">
                <span>.{{engine.name}}</span>
                <i-ep-arrow-down class="icon" />
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item v-for="item in engines" :key="item.name" :command="item">{{item.name}}</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
            <div class="search-btn" @click="handleQuery">
              <i-ep-search />
            </div>
          </div>
        </template>
      </el-input>
    </div>
  </div>
</template>

<script>
const LAST_ENGINE_NAME = "LAST_ENGINE_NAME";

export default {
  name: "search",
  data() {
    return {
      query: "",
      engine: {},
      engines: [],
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      await this.loadEngines();
      this.loadCache();
    },
    loadEngines() {
      return fetch("/engines.json")
        .then((response) => response.json())
        .then((data) => {
          if (Array.isArray(data)) {
            this.engines = data;
          }
        });
    },
    loadCache() {
      if (!this.engines.length) return;
      const lastEngineName = localStorage.getItem(LAST_ENGINE_NAME);

      if (!lastEngineName) {
        this.engine = this.engines[0];
        return;
      }

      const engine = this.engines.find((item) => item.name === lastEngineName);
      if (!engine) {
        this.engine = this.engines[0];
        return;
      }

      this.engine = engine;
    },
    engineChange(command) {
      this.engine = command;
      localStorage.setItem(LAST_ENGINE_NAME, command.name);
    },
    handleQuery() {
      if (!this.engine) return;
      window.location.href = this.engine.api.replace("${query}", this.query);
    },
  },
};
</script>

<style lang="scss">
#search {
  width: 80%;
  max-width: 760px;
  .name {
    margin-bottom: 80px;

    text-align: center;
    font-size: 42px;
    height: 50px;
    line-height: 50px;
    font-family: "微软雅黑,Helvetica";

    .iconfont {
      font-size: 48px;
      margin-right: 5px;
    }
  }
  .input {
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.12), 0 0 6px rgba(0, 0, 0, 0.04);
    .el-input-group__append {
      padding: 0;
      background-color: #fff;
    }
    .search-append {
      display: flex;
      height: 100%;

      .search-engine {
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 10px;
        cursor: pointer;
        .icon {
          margin-left: 10px;
        }
      }

      .search-btn {
        width: 80px;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        border-top-right-radius: 4px;
        border-bottom-right-radius: 4px;

        background-color: #0078d4;
        color: #fff;

        font-size: 21px;
      }
    }
  }
}
</style>
