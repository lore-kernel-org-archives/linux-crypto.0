Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E881221FD8;
	Wed, 21 May 2025 04:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747803389; cv=fail; b=V3rbpE+xj77F24mpPXxBdu+m3Gofqvabzwyx+VQzSbSINrMmbHaQ5TRHPIDqJv1zvjDtaFMmwYzueX5uMmEyky9OqrVWd5pZFS8NaQH+6aiyXvBfPXXdd8KNdrshgL8p7J2NKkY8YmTw5TbUUyYSTCKAlM14bW6u1AWiK2+JfWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747803389; c=relaxed/simple;
	bh=SPh5lG7/Btb3fu2rEFzNPJOfRe9X5yZeTYcx1BJJ/WA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b3PmxIPf5X1kqMWmQv48RszznEKfVWrImaA6E1y+8CG/xvwna0x2rTaxHhGAoM+Z1V8+ZAW5v/ujVANZczpLXjzl42AoRNBirWjO7muburUxVMkQtrsApWDqf4S2PWaaVsabTYMjdGTOIgKBYtFyolN7hsJVs7ak/42obLGMXUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbL1zMfb; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbL1zMfb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747803387; x=1779339387;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SPh5lG7/Btb3fu2rEFzNPJOfRe9X5yZeTYcx1BJJ/WA=;
  b=lbL1zMfbC+KGApfJrYL1SNPgVjkbaxW8zBwo3FqJJbPV2OME+/R3HoE4
   s491LlGOZFL9aPXDj7obZc6HAwdvgJkJsMsbrUrFXHoG/MePJ0gkqbo9+
   nai8Wx/+l80XIZemQwMCiFXUdVFwS5yPFacZgga9hJMhlYF/Xif9J8HSE
   KWRagNNJTEDWHJvwNcpOxbF8oMnFwXJhh6TL+c28iPS1u/3VWvBAvw+V/
   UCHqkd5mkXfCAUNsCRS0TwZrUi4UbcbvyQd68RMH3vH4DX/DMopVYrObt
   l1OEAa2QT9Xhi5v4a4pKrDu+dukTJcnZxZ7EV7iz1hlCsAi1UcB3bJlD0
   g==;
X-CSE-ConnectionGUID: dD4P/YHhTKKYx7uJBxLfPg==
X-CSE-MsgGUID: x/Vh4xnlSl6xP+p/eV8Sxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="59992727"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="59992727"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 21:56:27 -0700
X-CSE-ConnectionGUID: tYt9KKcpR2yiJ0ONj3oFCA==
X-CSE-MsgGUID: DvB/eXLMSCqptPvy7ml+Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="140318363"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 21:56:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 21:56:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 21:56:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 21:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UuIBET+54v9Vj6qHt+11Tgz5wXv7agvm3HrxxXm2g1ig/E/UCUtpUvkvhZg4iodZ2zz1sBUpUY7R69qgdPLio2cAlbKm5pGURhCV+zlPFuRu338RI9jzE9tqrJUeA6vV1BBk9pBQkybP8IZ74eTx90L5/ebbdIyvDBhoXLpHx5II/QT4OUshfC12FYiaMXlb5JCWEpvpYENM0jzgeF1ipH2M18qr4JS8TMSV48r+nmmCc35DlusBvavUEbRZaO1cgxkMsQzsRPbPfVQn8MLR1sgpLl114FAKONmfWeakcyUjBpD0yVIFuGDVHfDA18FeV50x6KJwG9TzBoo/o0hVSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPBf9j1JWaQIyL7E653aqeaCN8jcJnTZTc7qDLaZQUk=;
 b=Rgmo1izTOu0Of3D57/ICL+/l77b+zrhR6t9lW4HLjl0yZ4uFkhpjtYDfQCE+iJw9OyqsEkKThVsTg+jY+AC8RY0oCJTAf8aSNOVDYmsw2+xBuyR5Vyi0/qru2DI7+5XcuuHBOter3Q6XwXTuxeRAGkuFkQV3huA7oYlKMlWh8To+2Hd5+VJMKRJA2Y6HQC+/mXumPmlKF9w1DwGBUaud9Lbz5Z50gxyd2E9oNR2dWb1QKMhZXFnb39BKCba5UGd5T6FnA77oI3IE9hHNOXJqyT3i1/xPG1dq89AGvinNB030rjhzBl/xM4JPiC1MXGLcZCoVfeh2vtCm2YkGTZrQ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by LV1PR11MB8792.namprd11.prod.outlook.com (2603:10b6:408:2b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 04:56:23 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 04:56:23 +0000
Date: Wed, 21 May 2025 05:56:15 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Arnd Bergmann <arnd@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Arnd Bergmann <arnd@arndb.de>, "George
 Abraham P" <george.abraham.p@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - add missing header inclusion
Message-ID: <aC1c7+PQZN++5mgf@gcabiddu-mobl.ger.corp.intel.com>
References: <20250520161148.3562622-1-arnd@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250520161148.3562622-1-arnd@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR05CA0070.eurprd05.prod.outlook.com
 (2603:10a6:10:2e::47) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|LV1PR11MB8792:EE_
X-MS-Office365-Filtering-Correlation-Id: f65f8c48-c61a-4212-1f82-08dd9823d5a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/k2a4bA4wecPBP2MYtdnBvRS1cZFbwGk/srgideUdR2GQ5dCAP/V8T63nVxb?=
 =?us-ascii?Q?T5AULcankMi4fSgY1nvAAWKdsMvpkZ4xF0OvP71wbbqyw5IDQml7pnf4qhh/?=
 =?us-ascii?Q?qaO2/+eiwDk6wNNISP3w9Vh94H5fUCoBEd/oA4NYZBc2wNewG/liKdtH51M1?=
 =?us-ascii?Q?6Vt7gD61ILLrecqE+7e2S3JTW+17UVsaXFvg+K9sDLxVdWOCjtSk4BSbuaGT?=
 =?us-ascii?Q?yawItKWxmyAZEU6KqBM8nEBGQCcPfuorkt7qb+IGYkCCQnSrUpeaIyVEsjqz?=
 =?us-ascii?Q?eOKPeus/USbNYv7edC8vcKZj5SDFR1SfvpnLiBfhBZQIbdaHdEROR3FbBK2X?=
 =?us-ascii?Q?GhQot4wGh1GGP1M9YPfSenMzrPChJ0sHGJgF6+Y2KhANJ4j0kTIZUlB41dFi?=
 =?us-ascii?Q?zGQoFETVFyXmYBfnl80oJpWrR/nmVXkiOCckrvDuUolAUdtn00oBBqqkubyF?=
 =?us-ascii?Q?7WReeMPhXmr71nQTV4B/iQieAskdnagmhX1LpUho/QzvhS/uePeY9wZ+zulh?=
 =?us-ascii?Q?CAgI31i1BEAFROxlkNkW1PBcB4A9Gav04/YL2/Dm+DHmHx+V0ZQuXPBvMWML?=
 =?us-ascii?Q?khrP2R1axZGQn0oQhoz9O3ebZTzk/2msHwzTEB7sa6hIXxZ7pRfVGkDwqRzo?=
 =?us-ascii?Q?ytrc/j7KCjuk8Z0zjCqtQVbKUOpy/fpqRwljxIalgN8FL5P5LorZPZTNz3mo?=
 =?us-ascii?Q?YgLeBc0Q8JaCg8tFnAFhb0iKeG8PLUX/3x//JpSZ+w4qyrwYuH/YiQAwSKbi?=
 =?us-ascii?Q?reGTLJRnvunsLA8SMuqbssbNTSEOSkHPMMWfMF1KHVo0wBjEon0uyMoTWs++?=
 =?us-ascii?Q?wuUNfq1qG8zJq45jVLxk2St00eTN6h+kKDQjP59X9ued7drpFQwmoxgsMiRy?=
 =?us-ascii?Q?+oK+QNBDqqdpcsZsqARZtsSfP/SHLLRjwiVQaFTlQPmb+CWvz9N6r4LlpjVU?=
 =?us-ascii?Q?756Qq4LwaRsd+gzBgHzkG/rW7ks7kntnIK3URi0YfYh8OK30dGjCwDeJvuNG?=
 =?us-ascii?Q?yfT/JRTcJyf8JWX67CyBocQagz0TWVcZuJEIqzalpKPyWgmDD/KAg/jsamLW?=
 =?us-ascii?Q?QT5FE0HRihpQf9EsTsJC1tq3qxmRxQ6gMlQ059OupiENbs9GnhNE/bswvBFu?=
 =?us-ascii?Q?Af73nbqwKsQyCgR6C/7XruOY7KSZnKtrCpKIpdafaIdjV5jtFBFnTo4E075r?=
 =?us-ascii?Q?QvqS8PapVt3ykb2+GF57VHaIwtML9mBLRUkfl2kwCOa4ckk1+wkUShuwvEGO?=
 =?us-ascii?Q?MUCzlWdOgYMEj9p63baEAk8q8Jo1+EcfdTRJqNb1tTpDXvs5wE2HEHlRqND1?=
 =?us-ascii?Q?A4w2qWnzs/1ZSCLdCXtPljWUJkr+3tsZ8K53SkgX86LA3LGZwXz7TrpRg3A6?=
 =?us-ascii?Q?v9Q0ICsZxbYFWlCksX/H6r6BFMH8gLCTYAiHW8qJR5PIinlm8z+GjKX9dnop?=
 =?us-ascii?Q?Dnd73EBqzwU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbuQ4f/WXAAchSwf7jRC6rww775ao11iY1+cJfzAGjPvaDAD9t4Gqjs2EP4m?=
 =?us-ascii?Q?UgGLHxeerFEh4K/A+plBGpV3g/pPjGQAGd0kOts9DX9YHD+Ppl/k6a0tfEU0?=
 =?us-ascii?Q?2TBA6ONx7aFVw3RLC1gFNiods4fmikzjALCa/Qrk7h90tsIPls2CQtX53WaZ?=
 =?us-ascii?Q?Wt4eRz3/WsaRIRroUUTaKhYSQqyu0nNmJLKoChtIoLju3ZCfXFj/NrpogsXB?=
 =?us-ascii?Q?UWlkGiuQahi+3W9KnLASKwch3ez05+/KPJXUb3HcP4bcwG6kj+2GM5RXygUS?=
 =?us-ascii?Q?1Uv5/SH6A1EMA+rXS3YUndJYWugk9UZm83KTRojb2+8XO48Wu4hAgeU5lB4M?=
 =?us-ascii?Q?jEaN/MOSSQ8DE9xGuzYnMWyk9W81zsYnEc8aoafZWZq2DL11oeqKEzM+dE3J?=
 =?us-ascii?Q?rButkQo9Xgun13P6ZI4+TL3aFxW4fBp8uu+a6ZBI4Lb/3OIM89hohnuWp8mW?=
 =?us-ascii?Q?kceGLSZw1Ql66j5qDSPwGZUZoeK79RxBTwxJ64IUz+01RT2tgjhn/b100Sv+?=
 =?us-ascii?Q?na2QqURwIwy/7/mAa8Eg6MakfWhC6+6XZwhu/Q0cSJvCohx8ZeY/vl3EH339?=
 =?us-ascii?Q?N6xVQ+lPst56d+rF82fK21Z/mB6XeZ8NN4OErifWVQW80+BINcbBOkm5lFiw?=
 =?us-ascii?Q?Qbn0ubn0g0U+VqVyuMfBE/lSYdfO6woorKJ+lNpRpMbm3rxxGNYZHCqH8iWk?=
 =?us-ascii?Q?ge35M2nBbOHbS9QBfhVU+IoLXQ5SCKUWOpnGU+cMSfZdZyoj7ItNMHJofgo8?=
 =?us-ascii?Q?NCRD45L6exR7zdJpQiuMy1Dg4VFsoGKInrCUOoPph4jMIUhsQ1qZLCA4/kCo?=
 =?us-ascii?Q?LNAHhFPm+DfG95hXcm053OITYPT71Cq4HHP6s3b88qB2eUd6YS/vDXpOcoAz?=
 =?us-ascii?Q?8sHBgiGBkL1iRWNZxqGu+hMz/ZJiIssyhZQNalOpJosEcn4IgyCNO/ylJrmm?=
 =?us-ascii?Q?JpwrwfbiXg7g+d/zrc0KtVufKlT+v3siUlJ8JPY19rK5v+oXv4NZkPcS9cX6?=
 =?us-ascii?Q?NyFjxiAO54vrPpKkAYnPqjY9kDlSVNORVjaDJEQMZBrZwi2Ch/zJb1scKJzL?=
 =?us-ascii?Q?XaKrhgkN3vhqJvABVtZ28HjZQv3Y6/cl2p3JDJie5tlAQzl8a8SCi6ue+HoW?=
 =?us-ascii?Q?34YqaywmsKYAWfYRjIuv0rd0P9v2dbnsyMIfcTDdZulpLKbGXYuAnDxLghwW?=
 =?us-ascii?Q?9ccKIeT30iFv+F6bb7q6GymhqOktuxEvWlh8/yaAfL0IoVNNDniubp0uPC0g?=
 =?us-ascii?Q?JeStdVQWikLGOkvKPbWd8px078/roe0+5+e4MoMiT3ShtG2MJfTLnom2syMQ?=
 =?us-ascii?Q?BqQicJxDQHPvK9yCco1pDQnY1Q03tvXVXYpK1n9VmnFBj/K9y9UnzLoxBZMT?=
 =?us-ascii?Q?HYqiGhnEJSCXA3vn9NjcrgwwumajlGmDfFZK+h+JwZIeONA8ZSJj5eQDqvEN?=
 =?us-ascii?Q?6gG/ecaT8EjXvJ85jnZogBmLM6OHjeDMihlmAJnUXC0dobal7UW7lsyxjTaQ?=
 =?us-ascii?Q?B5kk0gFMcIQ/s+AAyn7criA+k7NuCyPAoUiDTe6dx1LLqGO3ttmcfAw3OH5R?=
 =?us-ascii?Q?URZC7FEcBgx10LqvoQm64RFUtoxZOwuCwqxyhzCXJs4c4bYqoLX8PQ1Le1uv?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f65f8c48-c61a-4212-1f82-08dd9823d5a9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 04:56:23.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ht6Zb9qSPCe4aO+DOqXEK/G/wFFx0KzmvvNRRCk63E/05txyRG+EUZgvNpaOmSrT0YaMD6orF9apmU5XH1tvG/s4FLX7ZqzebLOgzGFy+1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8792
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 06:11:36PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without this header, building the new driver fails with:
> 
> In file included from drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c:7:
> drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h: In function 'adf_gen4_init_pf_pfvf_ops':
> drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h:13:34: error: 'adf_pfvf_comms_disabled' undeclared (first use in this function)
>    13 |         pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
>       |                                  ^~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Thanks Arnd. This occurs with CONFIG_PCI_IOV not set. Can this be added
to the commit message?

> ---
>  drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h | 1 +
>  drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> index a716545a764c..9efee0053f3a 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> +++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> @@ -4,6 +4,7 @@
>  #define ADF_GEN2_PFVF_H
>  
>  #include <linux/types.h>
> +#include "adf_common_drv.h"
>  #include "adf_accel_devices.h"
NIT. Can this be in alphabetical order?

>  
>  #define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
> index 17d1b774d4a8..2c8708117f70 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
> +++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
> @@ -4,6 +4,7 @@
>  #define ADF_GEN4_PFVF_H
>  
>  #include "adf_accel_devices.h"
> +#include "adf_common_drv.h"
>  
>  #ifdef CONFIG_PCI_IOV
>  void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);

Thanks,

-- 
Giovanni
