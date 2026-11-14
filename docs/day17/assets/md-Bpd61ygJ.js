import{t as e}from"./slidev/CodeBlockWrapper-C0YmSSt7.js";import{I as t,J as n,b as r,ft as i,g as a,h as o,mt as s,w as c,y as l}from"./modules/shiki-C_MmXx-G.js";import{t as u}from"./slidev/default-CQgcJG33.js";import{nt as d,rt as f}from"./index-BhqLE1Ob.js";var p={__name:`day17.md__slidev_4`,setup(p){let{$slidev:m,$nav:h,$clicksContext:g,$clicks:_,$page:v,$renderContext:y,$frontmatter:b}=f();return g.setup(),(f,p)=>{let m=e;return t(),a(u,s(c(i(d)(i(b),3))),{default:n(()=>[p[1]||=o(`div`,{class:`eyebrow`},`// dvdrental Schema`,-1),p[2]||=o(`h2`,null,`Dataset Reminder`,-1),r(m,{title:``,ranges:[]},{default:n(()=>[...p[0]||=[o(`pre`,{class:`shiki shiki-themes vitesse-dark vitesse-light slidev-code`,style:{"--shiki-dark":`#dbd7caee`,"--shiki-light":`#393a34`,"--shiki-dark-bg":`#121212`,"--shiki-light-bg":`#ffffff`}},[o(`code`,{class:`language-text`},[o(`span`,{class:`line`},[o(`span`,null,`customer ──< rental >── inventory >── film >── film_category >── category`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`    │            │`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`    └──< payment │`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`                 └── (return_date IS NULL = masih dipinjam)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`Key tables:`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  rental      (rental_id, customer_id, inventory_id, rental_date, return_date)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  payment     (payment_id, customer_id, amount, payment_date)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  film        (film_id, title, length, rating, rental_rate)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  inventory   (inventory_id, film_id, store_id)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  customer    (customer_id, first_name, last_name, address_id)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  category    (category_id, name)`)]),l(`
`),o(`span`,{class:`line`},[o(`span`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`Connect:`)]),l(`
`),o(`span`,{class:`line`},[o(`span`,null,`  psql "postgresql://user:password@localhost:5432/dvdrental"`)])])],-1)]]),_:1})]),_:1},16)}}};export{p as default};