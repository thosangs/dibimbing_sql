import{t as e}from"./slidev/CodeBlockWrapper-F0bqF9vy.js";import{I as t,J as n,b as r,ft as i,g as a,h as o,mt as s,w as c,y as l}from"./modules/shiki-C_MmXx-G.js";import{t as u}from"./slidev/default-Cf_ZWqtX.js";import{nt as d,rt as f}from"./index-aubstBOZ.js";var p={__name:`day14.md__slidev_9`,setup(p){let{$slidev:m,$nav:h,$clicksContext:g,$clicks:_,$page:v,$renderContext:y,$frontmatter:b}=f();return g.setup(),(f,p)=>{let m=e;return t(),a(u,s(c(i(d)(i(b),8))),{default:n(()=>[p[1]||=o(`div`,{class:`eyebrow`},`// JOIN — Diagram`,-1),p[2]||=o(`h2`,null,`JOIN Types`,-1),r(m,{title:``,ranges:[]},{default:n(()=>[...p[0]||=[o(`pre`,{class:`shiki shiki-themes vitesse-dark vitesse-light slidev-code`,style:{"--shiki-dark":`#dbd7caee`,"--shiki-light":`#393a34`,"--shiki-dark-bg":`#121212`,"--shiki-light-bg":`#ffffff`}},[o(`code`,{class:`language-text`},[o(`span`,{class:`line`},[o(`span`,null,`customer (c)          payment (p)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`┌────────────┐        ┌─────────────┐`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`│ customer_id│        │ customer_id │`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`│ first_name │        │ amount      │`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`└─────┬──────┘        └──────┬──────┘`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`      │                      │`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`      └──────── JOIN ─────────┘`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`                ON c.customer_id = p.customer_id`)]),l(`
`),o(`span`,{class:`line`},[o(`span`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`INNER JOIN  → hanya baris yang match di keduanya`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`LEFT JOIN   → semua dari kiri, NULL jika tidak ada di kanan`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`RIGHT JOIN  → semua dari kanan, NULL jika tidak ada di kiri`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`FULL OUTER  → semua baris dari keduanya, NULL di sisi yang kosong`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`CROSS JOIN  → cartesian product (setiap kombinasi)`)])])],-1)]]),_:1})]),_:1},16)}}};export{p as default};