Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012017.outbound.protection.outlook.com [52.101.66.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A124E4BD;
	Mon,  9 Jun 2025 09:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749461756; cv=fail; b=SwNBhu8pPwVnTHcxmJNy7ONbTmaRHBauiyseF2JidB5GOBnjymYPd+I4Q6bhpeTOpQLnzI5OIOkrRuVZlxen9MQ8iJ7cImmSn63rl2HEXCcg7xthEjYLCtFfXmbuSDCWH3ZBbMMB/8FYtRHPkdMxIeX13MKoJerJyyd+Q4VV77A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749461756; c=relaxed/simple;
	bh=AfmcSzUfElr7euNfm5ZoDnG1bgOw7QnOhZEETwpcckk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GRuN9UpNyl/16xHh8p4OA1WYjpUqclApCmMxdVqAi62tYPDVpqjx1IDayKo3Ta/S4aoXuZG/lgavQUndD+qlhNCPe8lSINxeIt3wms5s6S9NsKsN3vSniu14nOnb7TqkWhHRoMzP8wORa0N2mAGYA/DFuQaqJsyVJEKMSjDDvtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Tei0+dPP; arc=fail smtp.client-ip=52.101.66.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Tei0+dPP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hh3x/vlFgGkCJdoaEsOstdRDineBgHWI7Laq4gGGDYIo735aareoiNfXKuXeyjPoxG06xLk57Q3f7fmexJ6CKG428lMRKh4wuP7PnZzP/eJE8jO0EkuAJetg9NZXJPTO0qSGlVANsqLjVElaBuxQ0IJUMZfigNtafBr9DkmfzaNoSK7EOZgN/capXZISbm2wfgMboTImBFCJOiF2ST028B0yuTa8NRBrkYCjE7fNghZzrAhKPBU3EAoqWcgu9aoSvosGmt8S+rhHYjh1xL5VeKeZHv84bbOb3D49bx16Zztzo8Y45RYOeqq7sWflfeaK1dX8nt322mhTXiyhulyMEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdLpB+iTWF8kFTlH0oOz/8lHJ6hWIfl/MTOWrZrQ4kI=;
 b=Vq3MCjQZx7ooqmdjZxauHV7o7M2psccpZnrlU5yz2c+Xm+KNknD4ZtH9dPtotpnBY5lw3z0v9PmUQyq3NjHdJVcSGYOaF7AplrujB7MyXc2mblJIrnRRg04J3XtvDpbdn8Ch2i1kNN/dw3czdrPzE5kXSfvB0DxOOhVFSWq2uxXr56/ebrjxL6mtzduqeYF8COc5QqrwDQUb4IE8H0MwFa7jIgJWERlYtKjv2mOlp0Q5dUKzDUDd9lgexiNKjaXEgz7yayd0pcbjNOm53J9ucoZ4bQC9fqfRci40kKuM8iKkhaEPwzis8OJ1E+3l3pFaFHEyPh9YCEfC/J5QE38TeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdLpB+iTWF8kFTlH0oOz/8lHJ6hWIfl/MTOWrZrQ4kI=;
 b=Tei0+dPPBhhy9QWQIFWshw8Xt2NlBpYQ9KoLaKBQ/g2PVcGJfih/6TK6GU2wt/xfLb0nUIZivPguw0ZEm0/T7ry0o96VFG6+hSy2KkGvWb5n9cNhDM6KgQCbAa1bjSNMAucC2eha2buPcvJUc/UghgyoQJWUdRdFfScj94OLf2Wj8Tp9INLdJTGTGOVEA9GoDDsWa1FJlfeyTEKCWuHInrFSmaWYNoBkjk/j9N71mz/EON4k1aZWA+gtLZTv4eIzTQ6riNySVaiWe/Yg6qYsLxN6qheE1WxGxec4b7BgVWgX7nCIXPh127VhkoS6KHJ5/Dg0uJV+KV+kW6Kcr234+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by AM9PR04MB8243.eurprd04.prod.outlook.com (2603:10a6:20b:3b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Mon, 9 Jun
 2025 09:35:50 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 09:35:50 +0000
Date: Mon, 9 Jun 2025 18:45:54 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v4 1/4] crypto: caam - Prevent crash on suspend with
 iMX8QM / iMX8ULP
Message-ID: <20250609104554.GP13113@nxa18884-linux>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-2-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605132754.1771368-2-john.ernberg@actia.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SI2PR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:4:197::13) To PAXPR04MB8459.eurprd04.prod.outlook.com
 (2603:10a6:102:1da::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8459:EE_|AM9PR04MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 30137589-8080-408b-c638-08dda7390554
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7416014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5qJKaEWzrWIfnS+kPGn6YBNxBkgBi9V+Lbt5ff08rNHoUPhuhtdc5sEPyi67?=
 =?us-ascii?Q?r4sg79p1obb1WT6ytM4BHzwG4TQW/AhdD3CT4BPMyodJDCjD/+935PaLY2QB?=
 =?us-ascii?Q?45jIVD0qNEbYKiG/0L7RbRVhUZROA3KKH9rhM8rU/YX12F3Z0EfrxvT3bp1T?=
 =?us-ascii?Q?H4BR2wEFfdUBWTC9cA6zQfQE0uweGXuguNnRDQ3E26u7MBeIYrkAfpK7vvHs?=
 =?us-ascii?Q?5ybB38cnreR534xOgWvZSRGxi0YQiWrN+SPvx/amNl/8bZidFcpLBGa5bl4n?=
 =?us-ascii?Q?7G3OyeJ5trNh+z6hAEJY3+JbQ3UW66OrXms8QRk0sjlsu089Hp0oVBypyn6H?=
 =?us-ascii?Q?xt5m3CJ1jhGDOTJ7Gy+hHIH/XhPSMW0ENxpEqTXT7XBDo6O+wwfXiM6h5ZPM?=
 =?us-ascii?Q?cICSUTxOz5nJRUwx844OAnduaxqbc3TR7hV3HH0L13lZsxhT5/mYXEfJlmiR?=
 =?us-ascii?Q?zvXpAqte8eyrU6j85xw6Z1pibv/3MUlyQPJKpNuP84CMnBEpRnmrcYFn0GJx?=
 =?us-ascii?Q?foM2LW+T6cZt/KO1VQ2sz48u/D6DeM9ZEW4MG4gevg+R4qb4I/sAyV5XaqT5?=
 =?us-ascii?Q?Ju4UDyylHW8i7U5F7xJFEP5D80xphpzS92i+q5mL7LWEW3h3iADa0wXYi/ov?=
 =?us-ascii?Q?wgKe2DVqpqAnRwa5dKXmW9YVjvdHzzMA1yfPQvXl1wAbvOjEnOoUiUZpRB99?=
 =?us-ascii?Q?6t/d64E+ZcMxbLxMNFafpJ6SuhN79/exb4MV55sH1zaiCSBQgiuKEcCmT+e3?=
 =?us-ascii?Q?mNoHHrc13MKwP4fGK6HZeQ3HebuFMC67+AhfhOaxTvKqT2MHWCNpZVEWi3Gy?=
 =?us-ascii?Q?P1ONICki9owSes0SDdGTV0Ry+ZCt0gZNGu8vPQP7PQmvrRMLUcMuj15zhN0u?=
 =?us-ascii?Q?E3xVjxnoGO7op07b4AtclDm8YK2pLJdC5kY3Q03b8dQ+fKe+LsTFo5TrNSRN?=
 =?us-ascii?Q?XYhK9XkM8DNBhJWC352Tf47TPJ+Spwd/u0K+sue/ruBqldbWh4wo2LjSHRi/?=
 =?us-ascii?Q?dW0ADogUV9VpIEnAvTRaz6Url9ZLC5LI+ZHHMLXcwhK53uFuokWmaJ/lEgtP?=
 =?us-ascii?Q?6vo1eh5yixWVxuuZpcoffTnU56uFncjSVRDHrPWUqrPkKSbn5m9v3smMRFOv?=
 =?us-ascii?Q?ie3CDwOT9Mn3uOettBeb25ureP/MscIskPldbputHIIfVVTqcT/k7lcgHz2U?=
 =?us-ascii?Q?WLSyEC/j6bW1C8dwLsC+SUypC2Vm2i+63sL4/uu5ggD9iOR5YPWoOnEjqLxR?=
 =?us-ascii?Q?1G24q4zRXnkNXqQABuA9JiEitgh/Blhzq4XN3vQ26COtGSLP2ddcxrW+AU3I?=
 =?us-ascii?Q?/JCd2yf+w4ghwOQqJSCHuwZ4N4ovoVEBsa1nnGetekMu6NaaNybOUkUbCQG9?=
 =?us-ascii?Q?yN1EQIwWz4PTh2WnzVcYaGdW6XBnZ+HDunbVPnJCrmQavu6wzD5gR6hjlxUm?=
 =?us-ascii?Q?5K9OqIbTGo16ZOQqxisiGZJNLl9pZMstPF0dNtBNnccTag4AKz85Kw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7416014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bCqFnm+KslvTcOI7SrnlMwsAoQUodFk9ojlFWqcb99KTxwzrYGf08qssLvB5?=
 =?us-ascii?Q?2UIanR1yYQm4KQNe/8QjeX3nXHabbuMp+TVPGefCMJql9+3Ql+UhY98Sc0vQ?=
 =?us-ascii?Q?hTZIKGyLmsuewXcu7g3Z5kJUrf4HYZsf0Z43QcZ7V4fSGWkYF9a0RihBKGRo?=
 =?us-ascii?Q?5Xvwle04LpWEE/UdkVwVD+Yf+g+C/+ZtLPKLjZN4y0S8tpD/9SQx1jj2H/AU?=
 =?us-ascii?Q?pWSA56xR4Xz0KHP9js1JWFt2kqkpmfghf6DK3aQ+1WfSKYSyvgZ1SxksYKl7?=
 =?us-ascii?Q?HXOliEBRCysnAfWjtwMO86NowaWovUpP+8aHbWlksi2eDYtLMR6PGfuYIENG?=
 =?us-ascii?Q?DYr1ZiMXobQCD+87Qyqur/YrAp4RLSod1/SDACPP2YoiP0whMW8uljs972jL?=
 =?us-ascii?Q?tkQ8g6jcdkhtU4g07E9BFMnYQLfEKZl5FQWPPzmLrWHShJkurFi0VThciSAS?=
 =?us-ascii?Q?ZRYNpWn+Xx7SxNpdGO7B5JLEA72DaEAtmkaqLY2JlGhuCcukc/XaYVNaoP+Q?=
 =?us-ascii?Q?07EXXKcuATxWdc2nTKqGWwmV0wkF0MnwuNCODZ5nuc46eI2YQl7ScqMe4ECo?=
 =?us-ascii?Q?UfpE6/bgLDD6uIZkXKj0LLx1ioGlyYsfwM6rcURvWJqpnMcArjS0pHYg8YSq?=
 =?us-ascii?Q?q8ifxeQJ1QV53BSZrSz9sZer9kN6Tne8oOeCH56VmT3uDjznDzgGtY/VgsXs?=
 =?us-ascii?Q?XdFiLbOBS1XLxNoswEaMeVEePD6YBwEe9cQ0ImbJ/hTgikHO+Hr2AXH57aoj?=
 =?us-ascii?Q?hZ4Di2lm2Hf2FSa1BVcMhwrqQmOBoDXsi2BlrkQc7G6iC0EPD/rCWwXlGKEp?=
 =?us-ascii?Q?/WgE4zUoCR7R/leMXYRB3s5+11TOkEfdv/IzQvVVXiBU3yzWFcL1UPPZU/gh?=
 =?us-ascii?Q?fSUUon0a5jaejFB//gjh4POXyzICQX0LZDaXMnTFzke17FsY0NcALMlPyXmZ?=
 =?us-ascii?Q?YT0KnP+a/oXbb3WFihpRxXpG1x4A1VQvnz+NKSSRAdGwoyVRI7xcjvUFyC+N?=
 =?us-ascii?Q?P0fzker+kcU8drdMd/DZHutuRgSr1VEIQurIK/VFbY/Nzl4IeXsSXy+Yllzs?=
 =?us-ascii?Q?IgDbKkd9f7lRs7kQ9AamdShqttyAlz/fttkOKKujzNrm53QIUzSvrvCJisQI?=
 =?us-ascii?Q?6k0jzHhoaA0ogsUnduKy/j7kcBXgpnAw56XI8PLwlcW+xRTvckq/hYNoODhL?=
 =?us-ascii?Q?PbjejOIX71EuzIuMq06Ck2p4UiisHtrBRBP+GqEQqz+nr+KXuqSbSP7lf7lX?=
 =?us-ascii?Q?ocQMR7XZwIR4oMGT1pxUeaUuZJn2vH8n8X8xkMFxeJCTGWNI/0MtYNKeGXo1?=
 =?us-ascii?Q?yh5GTaITAOV8vod4OyOH45tylfGbPnfLl2FRjQBVAPVP34AOCqlfa+O5tqGX?=
 =?us-ascii?Q?F/RKt1Cko9cZaHgWPpGI1LSkAJuB+lBMmH1HBQOLy6zr0I/SU8OsfOTO+gLJ?=
 =?us-ascii?Q?m2IMwIWuxOZnXASCI08IDOtQo8STQDNTJoBPgUx4m/gzavSUSXDzVrSehJSS?=
 =?us-ascii?Q?/Hd7deg3Yur2WarQMkNE7MuUngarezzXK6C+Uf32ERrSpycg+TwcNWmctvI3?=
 =?us-ascii?Q?mPaZghY0ahgaK3w7ubguTAextXwuXFE+/nRnigZe?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30137589-8080-408b-c638-08dda7390554
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 09:35:50.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiWm+3gvzeoUkkygsBAzcwrHL0UjGyy3YgaUSkcvQ3j9Xyf6UdFpVbST77P1ytn1GJpAz2MKvodtSFfdlw7CiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8243

On Thu, Jun 05, 2025 at 01:28:01PM +0000, John Ernberg wrote:
>Since the CAAM on these SoCs is managed by another ARM core, called the
>SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, which
>also reserves access to register page 0 suspend operations cannot touch
>this page.
>
>This is similar to when running OPTEE, where OPTEE will reserve page 0.
>
>Track this situation using a new state variable no_page0, reflecting if
>page 0 is reserved elsewhere, either by other management cores in SoC or
>by OPTEE.
>
>Replace the optee_en check in suspend/resume with the new check.
>
>optee_en cannot go away as it's needed elsewhere to gate OPTEE specific
>situations.
>
>Fixes the following splat at suspend:
>
>    Internal error: synchronous external abort: 0000000096000010 [#1] SMP
>    Hardware name: Freescale i.MX8QXP ACU6C (DT)
>    pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>    pc : readl+0x0/0x18
>    lr : rd_reg32+0x18/0x3c
>    sp : ffffffc08192ba20
>    x29: ffffffc08192ba20 x28: ffffff8025190000 x27: 0000000000000000
>    x26: ffffffc0808ae808 x25: ffffffc080922338 x24: ffffff8020e89090
>    x23: 0000000000000000 x22: ffffffc080922000 x21: ffffff8020e89010
>    x20: ffffffc080387ef8 x19: ffffff8020e89010 x18: 000000005d8000d5
>    x17: 0000000030f35963 x16: 000000008f785f3f x15: 000000003b8ef57c
>    x14: 00000000c418aef8 x13: 00000000f5fea526 x12: 0000000000000001
>    x11: 0000000000000002 x10: 0000000000000001 x9 : 0000000000000000
>    x8 : ffffff8025190870 x7 : ffffff8021726880 x6 : 0000000000000002
>    x5 : ffffff80217268f0 x4 : ffffff8021726880 x3 : ffffffc081200000
>    x2 : 0000000000000001 x1 : ffffff8020e89010 x0 : ffffffc081200004
>    Call trace:
>     readl+0x0/0x18
>     caam_ctrl_suspend+0x30/0xdc
>     dpm_run_callback.constprop.0+0x24/0x5c
>     device_suspend+0x170/0x2e8
>     dpm_suspend+0xa0/0x104
>     dpm_suspend_start+0x48/0x50
>     suspend_devices_and_enter+0x7c/0x45c
>     pm_suspend+0x148/0x160
>     state_store+0xb4/0xf8
>     kobj_attr_store+0x14/0x24
>     sysfs_kf_write+0x38/0x48
>     kernfs_fop_write_iter+0xb4/0x178
>     vfs_write+0x118/0x178
>     ksys_write+0x6c/0xd0
>     __arm64_sys_write+0x14/0x1c
>     invoke_syscall.constprop.0+0x64/0xb0
>     do_el0_svc+0x90/0xb0
>     el0_svc+0x18/0x44
>     el0t_64_sync_handler+0x88/0x124
>     el0t_64_sync+0x150/0x154
>    Code: 88dffc21 88dffc21 5ac00800 d65f03c0 (b9400000)
>
>Fixes: d2835701d93c ("crypto: caam - i.MX8ULP donot have CAAM page0 access")
>Cc: stable@kernel.org # v6.10+
>Signed-off-by: John Ernberg <john.ernberg@actia.se>
>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
