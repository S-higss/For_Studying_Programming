# Reactの導入

## 目次

- [What is React.js](#what-is-reactjs)
- [Reactの特徴](#reactの特徴)
- [JSX記法について](#jsx記法について)
- [コンポーネントの種類について](#コンポーネントの種類について)
- [About Component’s lifecycle](#about-components-lifecycle)
- [About Hooks](#about-hooks)
- [Tips](#tips)

[HOME に戻る](../README.md)

## What is React.js

UIを作ることに特化したJavaScriptのフレームワーク(要チェックライブラリ: react-gradient-timepicker)．  
MetaのFB/Instagramを始め，多くの大手企業がReactを採用している．  
コミュニティサポートも活発で，Redux，React Router，Next.jsなど多くの関連ライブラリ・フレームワークがある．  
ReactNativeの登場によって，Reactのコンポーネントをモバイルアプリにも応用できるようになったり，  
React16.0のリリースに伴い，Fiberと呼ばれる新しい再レンダリングエンジンが導入され，パフォーマンスが更に向上している．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## Reactの特徴

- コンポーネントベース
    UIを再利用可能なコンポーネントとして構築するアプローチによって開発がモジュール化でき，管理が容易．
- 宣言的プログラミング
    宣言的なコードスタイルにより，UIの状態管理と表示ロジックがシンプルかつ直感的に．
- JSX記法
    JavaScript内にHTMLライクな独自記法を記述する．

    ```bash
    {props.items.map((item) => <li>{item}</li>)}
    ```

    のように，`<>`内に変数や関数の計算結果を表示するために`{}`を記述．  
    (勿論JavaScriptのみの記述が可能だが，難易度が記述量の多さに比例するため非推奨)  
- リアクティブなプログラミング
    データ更新をするだけで自動的にHTMLがレンダリングされ，リアルタイムに変更が反映できる．
- 仮想DOM
    上記自動更新の際に必要な部分だけを効率的に更新し，パフォーマンスの向上が図れる．  
    → jQueryのaddClassやppend，attrなどほとんどのメソッドの使用機会が無くなる．  
    (jQueryはデータ更新作業とHTML書き換え作業を同時に行う必要があり，判読性の低いコードになりがち)

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## JSX記法について

Reactの理解に際して一番の鬼門であるJSXについて，HTMLとの違いを述べておく．

- className
    JSのclassと区別するためにHTMLタグのclassを`className`と記述する．
- htmlFor
    上と同様に，labelタグなどに用いるfor属性をJSのfor文と区別するために`htmlFor`を代わりに用いる．
- {}による代入
    文字列以外の値(数字/boolean/変数など)をHTMLタグの属性に代入する際には`{}`を用いる．
- リストの表示方法
    ulやolなどリスト内にアイテムをループして表示させる際には，

    ```bash
    {props.items.map((item) => <li>{item}</li>)}
    ```

    のように，`Array`のmethodである`map`を用いてタグ付き配列に変換できる．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## コンポーネントの種類について

1. classコンポーネント
    ES6のクラス構文を使用して定義．  
    **特徴**
    - 状態管理：
    `state`オブジェクトにより内部状態の管理ができる．  
    `state`オブジェクトは，変数のhashのようなものだと私は理解している．  
    つまり，

        ```bash
        class MyClassComponent extends Component {
        constructor(props) {
            super(props);
            this.state = {
            count: 0,
            name: "Shawn",
            };
        }
        ...
        ```

        のような場合，`MyClassComponent`というコンポーネント内では，`state.count`と参照することでcount変数の取得ができるというわけである．  
    - ライフサイクルメソッド
    これに関してはまだ正直あまり理解できていない．  
    「componentDidMountやcomponentDidUpdateなどのライフサイクルメソッドを使用して，コンポーネントの特定の段階での処理を実行できる」とのこと．
2. functionコンポーネント
    関数として定義されるコンポーネントで，以前は状態やライフサイクルメソッドを持たなかったが，  
    React16.8でHooksが導入されてからどちらも使用できるようになり，現在ではclassコンポーネントより一般的に使用されている．  
    が，もちろん両者ともに有用な場面もある．  
    **特徴**
    - シンプルな構文
    シンプルで読みやすい関数として定義される
    - Hooksの利用
    useStateやuseEffectなどのフックを使用して，状態管理や副作用の処理を行える．  

3. JSのアロー関数について
    React内でもよくみるので，一応．従来の無名関数(下述)の省略形の関数．  

    ```bash
    var fn = function (a, b) {
    return a + b;
    };
    アロー関数
    const fn = (a, b) => {
    return a + b;
    };
    // 単一式の場合はブラケットやreturnを省略できる
    const fn = (a, b) => a + b;
    // ブラケットやreturnを省略してオブジェクトを返したい場合は`()`で囲む
    const fn = (a, b) => ({ sum: a + b });
    ```

    ※アロー関数では，関数が定義されたスコープ内の`this`を参照する．  
    (ちなみに，class内での`this`はpythonで言うところのselfのようなもの．違いは，明示的に宣言[python]されるか，暗黙的に宣言[JS]されているかにある．)

4. props and state

    propsは外部から注入される変数である．以下のコードでは，RenderListコンポーネントに文字列配列をitemsとして渡し，渡されたitemsはRenderListがclassの場合はthis.props.itemsという形で取得できる．

    ```bash
    class RenderList extends React.Component {
    render() {
        const items = this.props.items;
        return (<ul className="shiritori">
        {items.map(item => <li>{item}</li>)}
        </ul>);
    }
    }
    ReactDOM.render(<RenderList items={['コアラ', 'ラッパ', 'パンダ', 'ダチョウ', 'ウリ']} />,
    document.querySelector('#app'));
    ```

    ちなみに，RenderListが関数の場合は，以下のようになる．

    ```bash
    const RenderList = (props) => {
    const { items } = props;
    return (<ul className="shiritori">
        {items.map(item => <li>{item}</li>)}
    </ul>);
    }
    ReactDOM.render(<RenderList items={['コアラ', 'ラッパ', 'パンダ', 'ダチョウ', 'ウリ']} />,
    document.querySelector('#app'));
    ```

    ここでReact18からは，以前とは異なるレンダリング方法を取ることに注意．

    ```bash
    ReactDOM.render(<RenderList items={['コアラ', 'ラッパ', 'パンダ', 'ダチョウ', 'ウリ']} />,
    document.querySelector('#app'));
    ↓
    const rootElement = document.querySelector('#app');
    const root = createRoot(rootElement);
    root.render(<RenderList items={['コアラ', 'ラッパ', 'パリ', 'リンゴ']} />);
    ```

    stateは，コンポーネントが内部的に持っている状態のことである．  
    この状態はpropsとは異なり外部から注入できない．

    ```bash
    class SelectItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
        selected: ''
        };
        this.onChange.bind(this);
    }
    onChange(e) {
        this.setState({ selected: e.target.value });
    }
    render() {
        const { selected } = this.state;
        return(<div>
        <p>現在 {selected} が選択されています．</p>
        <label>
            <input type="radio" value="コアラ" onChange={this.onChange}/>
            コアラ
        </label>
        <label>
            <input type="radio" value="ラッパ" onChange={this.onChange} />
            ラッパ
        </label>
        <label>
            <input type="radio" value="パリ" onChange={this.onChange} />
            パリ
        </label>
        </div>);
    }
    }
    ReactDOM.render(<SelectedItem />, document.querySelector('#app'));
    ```

    のように実装することとなる．ここでひとつ疑問を抱くかも知れない(少なくとも私は抱いた)．

    ```bash
    this.state = {
        selected: this.props.count
    };
    ```

    のようにするのはどうなのだろうかと．このコードによってpropsという外部からの入力を内部のstateに受け渡せるのだが，React の推奨される方法ではないらしい(考えてみればそもそも必要ないわけだが)．  
    というのも，propsが更新されたとしてもstateは同期されないためである．  
    それはそうで，stateの初期化はclassのライフサイクルの中で1度キリであり，  
    propsの更新が反映されるわけがない．  
    もちろんそのように実装はできるが，コストが高くあまり見合わない．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## About Component’s lifecycle

ライフサイクルとはコンポーネントが生成されてkら削除までの一連の流れを指す．  
Reactでは，このライフサイクル間のあるタイミングで処理を挟み込むための一連のメソッドが用意されている．  

それぞれの説明

＜コンポーネント生成時＞  

- constructor：classの初期化メソッドで，コンポーネントの呼び出しの際に呼ばれるmethod．
- getDerivedStateFromProps：親コンポーネントから渡されたpropsを計算して自身のstateを導き出すmethod．内部のstateがpropsの値に依存する際に使用される．
- componentDidMount：仮装DOMを更新するためのrender methodが実行され，実際にコンポーネントのDOMが生成された後に実行されるmethod．

＜コンポーネント更新時/コンポーネント消滅時＞

- componentWillUnmount：仮想DOMからコンポーネントが消滅したタイミングで実行され，その後実際のDOMからも削除される．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## About Hooks

React 16.8以降導入され，classコンポーネントを書かずにstateやlifecycleの機能をfunctionコンポーネントで使用できるようになった．

**!! 通常のJS関数内では使用しない !!**

- useState  
関数コンポーネントにlocal状態を追加することを可能にする．  
状態の現在値とそれを更新するための関数をペアとして返す．

    ```bash
    // countを0で初期化し，
    // 更新するための関数としてsetCountを用意
    const [count, setCount] = useState(0);
    console.log(count); // 0
    setCount(8);
    console.log(count); // 8
    ```

- useEffect  
コンポーネントのレンダリング後に何かを実行するために使用される．  
(つまり，classコンポーネントのlifecycle methodであるcomponentDidMount，componentDidUpdate，componentWillUnmountに相当)  

    ```bash
    useEffect(() => {
        // ブラウザのタイトルを更新
        document.title = `You clicked ${count} times`;
    });
    ```

- useContext  
コンテキストの現在値をfunctionコンポーネントで読み取ることを可能にする．  
→ プロップスを介さずに近くのコンテキストプロバイダから値が取得できる．  

**!!! Caution !!!**  

- Hooksはfunctionのtoplevelのみで呼び出すこと(ループ，条件分岐，ネストされた関数内では呼び出さない)．
- 通常のJS関数内では使用しない．
- 複数のコンポーネント間で同じlogicを共有する場合，Custom Hooksを作成して再利用する．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)

## Tips

- コード分割
React.lazyとダイナミックインポートを使用し，必要時のみコンポーネントをロードすることで，アプリケーションの初期ロード時間を短縮．  

    ```bash
    const OtherComponent = React.lazy(() => import('./OtherComponent'));
    ```

- 不要なレンダリングの回避
`React.memo`，`shouldComponentUpdate`等を利用してコンポーネントが不要な際のレンダリングを回避．  

    ```bash
    export default React.memo(function MyComponent(props) {
        // コンポーネントの実装
    });
    ```

- useMemoとuseCallback
計算コストの高い処理はuseMemoでメモ化し，callback関数はuseCallbackでラップして再利用．

[TOP に戻る](#目次)  
[HOME に戻る](../README.md)
