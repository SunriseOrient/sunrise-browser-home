<template>
  <div id="search">
    <div class="name">
      <i class="iconfont" :class="engine.alIcon"></i>
    </div>
    <div class="engine-switcher">
      <button
        v-for="item in engines"
        :key="item.name"
        :class="['engine-btn', { active: engine.name === item.name }]"
        @click="engineChange(item)"
      >
        <i class="iconfont" :class="item.alIcon"></i>
        {{ item.name }}
      </button>
    </div>
    <div class="input">
      <input
        class="search-input"
        v-model="query"
        :placeholder="engine.placeholder"
        @keyup.enter="handleQuery"
      />
      <div class="search-btn" @click="handleQuery">
        <i-ep-search />
      </div>
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
      return fetch("./engines.json")
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
    text-align: center;
    margin-bottom: 24px;

    .iconfont {
      display: inline-flex;
      font-size: 48px;
      color: var(--text-primary);
    }
  }

  .engine-switcher {
    display: flex;
    gap: 4px;
    padding: 4px;
    background-color: var(--bg-surface-high);
    border-radius: 9999px;
    margin-bottom: 40px;
    width: fit-content;
    margin-left: auto;
    margin-right: auto;
  }

  .engine-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 16px;
    border-radius: 9999px;
    border: none;
    background: transparent;
    color: var(--text-secondary);
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;

    .iconfont {
      display: inline-flex;
      font-size: 16px;

      @media (max-width: 768px) {
        display: none;
      }
    }

    &.active {
      background-color: var(--text-primary);
      color: var(--bg-primary);
    }

    &:not(.active):hover {
      color: var(--text-primary);
    }
  }

  .input {
    position: relative;
    display: flex;
    align-items: stretch;
    background-color: var(--bg-surface);
    border: 1px solid var(--border-subtle);
    border-radius: 12px;
    overflow: visible;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);

    &:focus-within {
      border-color: var(--accent-blue);
    }

    .search-input {
      flex: 1;
      padding: 16px 50px 16px 20px;
      border: none;
      background: transparent;
      color: var(--text-primary);
      font-size: 16px;
      outline: none;
      border-radius: 12px;

      &::placeholder {
        color: var(--text-muted);
      }
    }

    .search-btn {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: transparent;
      color: #fff;
      cursor: pointer;
      font-size: 20px;
      border-radius: 50%;
      transition: all 0.2s;

      &:hover {
        background-color: var(--bg-surface-high);
        color: var(--text-primary);
      }
    }
  }
}
</style>
