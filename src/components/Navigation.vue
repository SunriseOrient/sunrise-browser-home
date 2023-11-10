<template>
  <div id="navigation">
    <el-row :gutter="10">
      <el-col :xs="8" :sm="6" :md="4" :lg="3" :xl="3" v-for="item in navigations" :key="item.title" @click="handleGo(item)">
        <div class="navigation-item">
          <img :src="getIcon(item)">
          <span>{{item.title}}</span>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
const LOCA_NAVIGATIONS = "LOCA_NAVIGATIONS";

export default {
  name: "navigation",
  data() {
    return {
      navigations: [],
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      this.loadLocaNavigations();
      if (!this.navigations.length) await this.loadNavigations();
    },
    loadNavigations() {
      return fetch("./navigations.json")
        .then((response) => response.json())
        .then((data) => {
          if (Array.isArray(data)) {
            this.navigations = data;
          }
        });
    },
    loadLocaNavigations() {
      const navigationsString = localStorage.getItem(LOCA_NAVIGATIONS);
      if (!navigationsString) return;
      try {
        this.navigations = JSON.parse(navigationsString);
      } catch (error) {
        localStorage.removeItem(LOCA_NAVIGATIONS);
      }
    },
    handleGo(navigation) {
      if (!navigation.url) return;
      window.location.href = navigation.url;
    },
    getIcon(navigation) {
      const url = new URL(navigation.url);
      return `${url.origin}/favicon.ico`;
    },
  },
};
</script>

<style lang="scss">
#navigation {
  width: 80%;
  max-width: 1116px;

  .navigation-item {
    height: 84px;
    margin-bottom: 10px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.12), 0 0 6px rgba(0, 0, 0, 0.04);
    border-radius: 2px;
    transition: all 0.3s;
    cursor: pointer;
    font-size: 12px;
    background-color: #fff;
    &:hover {
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      transform: scale(1.05);
    }
    img {
      margin-bottom: 4px;
      width: 32px;
      height: 32px;
    }
  }
}
</style>