Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013000.outbound.protection.outlook.com [52.101.72.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D553093AE;
	Tue, 30 Sep 2025 16:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759248594; cv=fail; b=NX+k2jUU+BR73OPWi3mJ36igI0J3isgwIpmoLfGY0O/dy5B50co8eaO5efBCFiiXpq7XJH6q5R31ZQs1JCT98hu9rSItHvU6mfBi1Nbt/h5upmdoDahYx3wnEhLl/+lcWX1+GI++y0NfC2b+UOapBPzQnzp+CKGN+aIpT9V35lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759248594; c=relaxed/simple;
	bh=x2rDT4Qpoc0P4StR0JI/Oemo0Ft/nGSN06eGfC+zoT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KP46UW0z2E2AxuKLg5uG/XdkWo1/1K9dLpCPfZmolXNfHP8k0M0ZMruDhSAPQVpfaBf3ErETiiJk++b7KrbU67VNMMTnFZQaHW3LalqicdIg1vlCcq1gRZaLxH+q01vzARkuEfdffCSldLpDTFxSu4HgKENp+4/KGdA4gMrInQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=CRv7ScZP; arc=fail smtp.client-ip=52.101.72.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="CRv7ScZP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/g83bpkTiA5rUfZy/o2hesIlk7QaM5Jkjmt9iERp87RzUmhFD0FIEMzKM7QA+UDU9+2gyQzv0774/Bvpn26sNEirGRMD4Npd53Xc//RA9V8RvPl0Q8Z0fssLamMPTBbnqEJo3G5aAk+DSdrHp4BUPrRHXwdeaAJAywwMeXSYRC2xDaoJcCk2QAmn/+e3sAkmInZfFKzKyMDCt1vhNnwoOSebdh7eqk/E1SmE/8X0/9ikCKonHc3ezzGrDP3wCIXJd3woQuNqX9o365X71Xw5ZiXkYQvd32NbwO/wN8TLqIGXaMc4BCQYPdeCjxdal1cAm+AW+efD5LzYnI2kzHYKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0wzLEd5AL/qs7MBvF9S/zChyqfpqwk3t+iRRRkcWpk=;
 b=YSMNPmsUvN2LJOR1FRiFuXW7/57yXg7sD5xmvZ9CjQhBbAG24ndDEhGt2OvcyBY3Eek7duWZLd1MW2aIZFc8U9fYwkJD01g3Mw9u0WtO6IT/Qw63EnpsbJFeLMpq9a8/J404dmcxnlHAKYZXlVtmt+Sp3rFtc7nOaErh8JqwVWbk0E6CA42xQBJ+xsxsGiYivlcot3ldq4tFt8/D8AD4wLVRCjaTOW1RA1ofY+UQrv8SLJraAKJWJn4qTyMe9wze8g4CwGVUyP566siN83+MrQhInn7A7fIZDi+07dDE4ZO7V5gtzi5MtqtrOe5ItJe4AiaL8KggJ2OwMllEPsxtyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0wzLEd5AL/qs7MBvF9S/zChyqfpqwk3t+iRRRkcWpk=;
 b=CRv7ScZPdWBQjrkD1DUGK85k0Rf2QR0DYpDgycR77/23F2YUKAhSO9xciCQqaqT3T7H/xKqKZ1iDsSIA+7G2bixgeu8GBvtIOXJM5yq3CJnSff8Yj5tKpP+jG/bo74R02d78tXv3jfK3hQCsIjY00Rvz6TP0/1npmnkuxNzQ4zbupI5uhUeCcUh1keiNhSt5VIhQ9UjeUF0lDbqc13WtU4nEQ0NDX3sm6hOGoHKLKcuGUBQyCppqyJXGdEnPIPsSBOi75xp1+50T8w0sa/7yukRfQ93GUfrbSSqsUgKi9TpQjoH45qwFw2+v3JzF621FKtD9vSqZdt2NpSqwJIxBPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9071.eurprd04.prod.outlook.com (2603:10a6:150:22::11)
 by VI0PR04MB10567.eurprd04.prod.outlook.com (2603:10a6:800:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 16:09:48 +0000
Received: from GV1PR04MB9071.eurprd04.prod.outlook.com
 ([fe80::b7f2:1d0:6b6a:ba58]) by GV1PR04MB9071.eurprd04.prod.outlook.com
 ([fe80::b7f2:1d0:6b6a:ba58%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 16:09:48 +0000
Date: Tue, 30 Sep 2025 11:09:40 -0500
From: Han Xu <han.xu@nxp.com>
To: David Sterba <dsterba@suse.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"suman.kumar.chakraborty@intel.com" <suman.kumar.chakraborty@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"terrelln@fb.com" <terrelln@fb.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Richard Weinberger <richard@nod.at>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY TECHNOLOGY DEVICES (MTD)" <linux-mtd@lists.infradead.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [PATCH] crypto: zstd - Fix compression bug caused by truncation
Message-ID: <20250930160940.rfb2ed4ekal4ptid@cozumel>
References: <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>
 <aNuQAr79Hdky3WII@gondor.apana.org.au>
 <20250930133220.GB4052@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930133220.GB4052@suse.cz>
X-ClientProxiedBy: SJ0PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:334::17) To GV1PR04MB9071.eurprd04.prod.outlook.com
 (2603:10a6:150:22::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9071:EE_|VI0PR04MB10567:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e354ad-2dd5-4e58-0385-08de003bc769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|19092799006|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?otNoqgnLi/73PC5ft6+YjqQGX811Oc72y56b4QLP07yssSNFrzgQJKj6ZsGs?=
 =?us-ascii?Q?mwXrORNgdzF4i1Zp1gHzHkfwMNZdaqP/eJYTusak9wIiF6zbE/ueOPtSBv0h?=
 =?us-ascii?Q?e4GVSuDqhVgSw7evxIiaDxDmDXZIVnD5+kCUyGW3D/jFbvj5JzzbMMVRTMpn?=
 =?us-ascii?Q?pDbFe1NbExtGBK2gLPY6ZkG6UCfm3KW4Hus0ZfgxpN7ngU76KqSDXlcFMjcI?=
 =?us-ascii?Q?RmtrflZKNByJ1eFQT0XlSo4bqtyrH3yaHe74mRDdAMw/ALcrBjvHW6cOahXe?=
 =?us-ascii?Q?cQcGUd33nqR067wJ9+myGg35Bw8pE6tucPlk/s3QK0iaphXM36MfG0OnJhKq?=
 =?us-ascii?Q?9aKDWQYEtIPaDIBUAHKRaL/8iyzcGQ154fzCXbEGrrXstRozNPf+txiRl4Mp?=
 =?us-ascii?Q?HddPKu0yN0TcCI9kxYq+5YpGnqI+iC1fwteVQqLGYUdd57QV1ajrocc4AoAn?=
 =?us-ascii?Q?RZhNw5/sUrV2lBcPdTIvzRdvxRR/ZS5AZctskg//PWIGZkDB9odMN3go1Cm8?=
 =?us-ascii?Q?U0L5unnUGx8FL0u4Oo6IDso+ZXA8JBqrEKUrmejymJxrbHT1Q2HVUP+dJ+U/?=
 =?us-ascii?Q?mdt+jvxP5mMww8J8QjwjBaM5s8EynI3qtttm+EYNwjj/uRCF5fpyukS+O4R4?=
 =?us-ascii?Q?IlU7oj5tlDK3IpTrcbt770SLSWK/ZksLAVqTOcqhcGpj5WFf39pGlzjF1A7E?=
 =?us-ascii?Q?QhkXLb8HcFvwswhx3Q8PdTjAyOIB8gotjaEoXMGxggvgh37KU6Q60CWidi2H?=
 =?us-ascii?Q?brDBmTKGQBBgPCyIjta8gcMEtEQno99H4a6+mNcHEktyOITS0q54QO8Y7lO8?=
 =?us-ascii?Q?xBCwiimz21FMy5MJuFkuDZCHFmq64tbf520SGvlX+ZHmr2rhwF1Rx5eUSPN2?=
 =?us-ascii?Q?jjf0JCHruoEAlO2NJdydjwATkROBuCtES6LfkAxRhi/5hnrBh3S42YYiomVF?=
 =?us-ascii?Q?NWZFOP/usC3VrkbRFDNuB3UY9Wz07LRAiqNEdgcpo2XHohc7n4aQigTL6XsQ?=
 =?us-ascii?Q?hJzoiM2gF2nC8OsvKUX+HvHr/norKLQbz62kDZgWY+N2GbING7qW8HJinebz?=
 =?us-ascii?Q?uFheH3ARWkwYvJeDfJFdBdFbUkcqm/wtnPkzn2lJvcgHaYQlfEjFhnI9NhSf?=
 =?us-ascii?Q?FF3M+igFWGwSSoKLapwIq/jpL9HevigsC+KYQS0Bq+uYBU3S9RVF8Ham/AYq?=
 =?us-ascii?Q?hcUm4aoxF3qdw0su0FHEyOkx1CJVgjCxIrwZ9EqH9cLm0cvyXkFpx0n100ws?=
 =?us-ascii?Q?aO9E6sdnyX4b5Makv1f8GtOJ4eHxcveESnZ/Bl5yTjkWHYsctd8eGQ/jbscP?=
 =?us-ascii?Q?5GmF2sIL90ZTMuooSHPW8mpNwiWmuJMw8aR0aspZr6dLgYIU+j7aoQMo+4OU?=
 =?us-ascii?Q?FV2361qK1nzUS2pBshQSj2SgJeuIxATHJPwCX3l7MiMHO2vLueDL93P7zcX0?=
 =?us-ascii?Q?DLMcPDNd63wWlMEzci9o2dC6ejpyzAnJUCaFkv7J+kVJ7WgxraKJp95s7+/R?=
 =?us-ascii?Q?205mOQl0Q2QNXvkO/4epPwHT1z4Iy1ohef74?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9071.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(19092799006)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5bz12f+aeEhP9ZZZjmmrwhAqedx7EtXZ+FvrOtO0UrZek7kizpuBExdTvoeL?=
 =?us-ascii?Q?QbLmKbxJuIVNsQWnvDdmtyM2uxOkUsAsmcYM6IoDSzm/8a7txCOXuv7pznDC?=
 =?us-ascii?Q?IFKZno3IYc/cHcSuAueA6hTA27JNqpJ11J6DCxsFvmHunPDEDrN2MThVenqB?=
 =?us-ascii?Q?89NPSr68+z2rNTQRVea1iNja8LuuqFkrG9feS+Xthdp4PHXjxTizGFFrzl1F?=
 =?us-ascii?Q?kodnG+NAv/bOLoB+ybcuiPwYTWNmCvcqCxZI7twSVXF09UJTHxbwA1DH3LpA?=
 =?us-ascii?Q?/re3cq2OC+RmL/ChHRAqe/RhvXDCKvN8MGDUXsXtEY2DdjCWnot1nAArzvZi?=
 =?us-ascii?Q?Byu3neg2GNIbUEVrUf/T91LonbmVsgQCNJIbL8lm3wa0EaWVfHeuIIRcluyy?=
 =?us-ascii?Q?kbZ5nKmeZJZ3sYJwaqHTXW7yVqPxhGZFabrvMungsTy90zW+sw8+bmzidn9n?=
 =?us-ascii?Q?91Er4tsY0WkSQ9IInWvnjipWsqXuOBiViURrO1X6HuKy3pDkcKJsQK4laBf3?=
 =?us-ascii?Q?tUaGhXTmYK2nnXSPNx0vxgS7AsLnij2S+9SxDQuGLG1SJIGTXOLc6aGpzzlf?=
 =?us-ascii?Q?9aQC34Ebq5aH9KKZBFnczixLeq9HgtZJGX/lxSCSetPNOqO5/dmB0O3UMRWi?=
 =?us-ascii?Q?vJf+akD1IiWH/YTDYAFfIGxi2k5OHIo3vg1y4NmEQ15n8ORwiH8BXpt4SGXp?=
 =?us-ascii?Q?uybjpllF4MCcWdMf/ORXWFwMeASDYazOSw9XSx8qx58rArMV2j91J/X/zt6I?=
 =?us-ascii?Q?j0zu3iFmw5WggTsZFrV92LATRt9m4EoLspC/i9FPXBcrt5hfK9Khx3NvlQ5M?=
 =?us-ascii?Q?zt2Om6bssYT8+vmxaO/1mM+eQw8uvIBSq2NEJjfpTHoRIBOnY6eCiu2yuGyP?=
 =?us-ascii?Q?wtHa0FpzfrW3GSMZr4X0zWiTZO6qN+EkAkSUfHaS/HC3Ety6CAWg9LjSZ9ON?=
 =?us-ascii?Q?EWN4IlGHA+StMXWJxuyIrJu4K2Wli0Imk/u/CyoB1plzUsQVSTmfIrBoAw8q?=
 =?us-ascii?Q?Vd3VbyzwTYAjspop2AhIfIckkIA8U0NF23U92wescM/7uRVX9zscDTrQBl2L?=
 =?us-ascii?Q?nY9YRMJGDIJONentbwVqdiLA/QZ6PQ/hMJPODz5LygAmljmPs7muEOk8fazr?=
 =?us-ascii?Q?l8ZneNopvntbzKVJDYemXsuarvFq/xAFjkOmONjJmVnQl1U1Le8MDfE7rbb1?=
 =?us-ascii?Q?kDI55xhOvz+23VsWlbd4O/YrTZxQIv3vUjFifaD3rFaoZAA16h9IDX9DmJSn?=
 =?us-ascii?Q?t2YEwssQREOYe73kwhmgOdn+9Cydiy/YCyXc+4ANtc7/XmwNLJw0pLQs59oM?=
 =?us-ascii?Q?73wwF1ROliddbhSgBdrE2OJDcB2LZs402DQkxqVNDdckTXz80sc9VQzexkAy?=
 =?us-ascii?Q?jrMDQF6EREzbDjZFbX131j7WjmNFZzfTqmJrdUdRYBJ7PXi/9YyBPUd/8VIi?=
 =?us-ascii?Q?90fEn1q80bQWzHVX1YP8ATtX1EjYIeRlMhxLhfADyrM2pkwnz/Y2OULpkzxT?=
 =?us-ascii?Q?oigbBbWoaV17U94Ei3FdmHjYKyTQ+Gy7Rl6OsHNxf9gLmPLHgceRftMM7i/N?=
 =?us-ascii?Q?B7BpWr7JwQipZvx3fXA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e354ad-2dd5-4e58-0385-08de003bc769
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9071.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 16:09:48.4647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFXVQE/bY06L6jmskCEJ+e34R6Lsvubgndwy7RadfSHLNuYOMOCI3xYyYgS18ApR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10567

On 25/09/30 03:32PM, David Sterba wrote:
> 
> On Tue, Sep 30, 2025 at 04:08:34PM +0800, Herbert Xu wrote:
> > On Mon, Sep 29, 2025 at 11:51:36PM +0000, Han Xu wrote:
> > > Hi Suman,
> > >
> > > The patch f5ad93ffb5411 "crypto: zstd - convert to acomp"
> > > leads to the following kernel dump during UBIFS write back.
> >
> > Thanks for the detailed report and instructions!
> >
> > Please let me know if you still get the crash with this patch:
> >
> > ---8<---
> > Use size_t for the return value of zstd_compress_cctx as otherwise
> > negative errors will be truncated to a positive value.
> >
> > Reported-by: Han Xu <han.xu@nxp.com>
> > Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

It works well now. Thanks for the quick fix.

Tested-by: Han Xu <han.xu@nxp.com>

> 
> >
> > diff --git a/crypto/zstd.c b/crypto/zstd.c
> > index c2a19cb0879d..ac318d333b68 100644
> > --- a/crypto/zstd.c
> > +++ b/crypto/zstd.c
> > @@ -83,7 +83,7 @@ static void zstd_exit(struct crypto_acomp *acomp_tfm)
> >  static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
> >                            const void *src, void *dst, unsigned int *dlen)
> >  {
> > -     unsigned int out_len;
> > +     size_t out_len;
> >
> >       ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
> >       if (!ctx->cctx)
> > --
