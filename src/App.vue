<template>
  <div class="head">
    <span class="logo">J.</span>
    <el-icon class="setting">
      <i-ep-more-filled />
    </el-icon>
  </div>

  <Search class="search-component"></Search>
  <Navigation></Navigation>

  <div class="foot">
    <p>© 2021 简语</p>
    <p>{{speech}}</p>
    <div class="icons"><i class="iconfont ali-github"></i></div>
  </div>
</template>

<script>
import Search from "./components/Search.vue";
import Navigation from "./components/Navigation.vue";

export default {
  name: "app",
  components: {
    Search,
    Navigation,
  },
  data() {
    return {
      speech: "",
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
      this.loadSpeech();
    },
    loadSpeech() {
      fetch("https://v1.hitokoto.cn")
        .then((response) => response.json())
        .then((data) => {
          let _speech = data.hitokoto;
          if (data.from_who) {
            _speech += ` -- ${data.from_who}`;
          }
          if (data.from) {
            if (!data.from_who) {
              _speech += ` -- `;
            }
            _speech += `《${data.from}》`;
          }
          this.speech = _speech;
        })
        .catch(console.error);
    },
  },
};
</script>

<style lang="scss">
.head {
  position: absolute;
  top: 0;
  width: 100%;
  padding: 30px 60px;
  box-sizing: border-box;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 28px;

  .logo {
    font-family: "微软雅黑,Helvetica";
    font-weight: 700;
  }
}

.search-component {
  margin-bottom: 80px;
}

.foot {
  position: absolute;
  bottom: 0;
  width: 100%;
  color: #666;
  font-size: 14px;
  text-align: center;
  padding: 40px 0 60px 0;

  .icons {
    margin-top: 20px;
  }

  & > p {
    margin: 10px 0;
  }
}
</style>