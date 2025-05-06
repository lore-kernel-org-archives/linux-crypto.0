Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951BD27FD6F
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547304; cv=fail; b=pZRXSEc50VK5lqFeUAgWSQ/r/fiiDlJhlg1bUiVfZIq+jIRpNZmld8b5OGQeVvr3eC0zHCxmnKSraCOklbF9LiYpYfh8FnDoFxq/ORANuOXqruLbyJsRdYzB4Jr8f+3o/XJ1OnFRokADEqqmJuuw8yjbmwzoS6zuji6wlEX0W4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547304; c=relaxed/simple;
	bh=iWBExpzqJwNWdIAj4TDcfiLfAvfTHhutCemt1p0p/0o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=THuBRnws1q+9rDKkbQctUyh1g4rV8kXAPsVUC6L2EteUl/J/xYIvaNDdfDtL2oPFF2fnyVdqje+WkB23ye98xZKv9vijtF76h9h3ZTjFaPcZVI7pcUJvRKYmPfQuknd1uMURvtLbRFMmrT92OX1c23IWtKRvAVhRQ2kfzFavkis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JH83ySjC; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JH83ySjC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746547303; x=1778083303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iWBExpzqJwNWdIAj4TDcfiLfAvfTHhutCemt1p0p/0o=;
  b=JH83ySjCXduPV2xGvzhL6XRjDOQx5F/YShERgpS7Fx/n0VfKZsdqV+Ne
   B49Al7k3OIJIhxvL3jnHFXQgvWHoyRP3cIm9p7uqf8+6/VyvGt7XOTp2k
   PnAFxITinbGWQa3zKgRcg4R/OXwiwdYrVxsapWyYc4I3DJUIO8A4aptmw
   YVMq1kRCNmXc07qPI+qJZ4RUYofbbgTHy6JVwClqkr9uJtR3dOGv6o0Xs
   RKomKK+9S/A0pVmbuC7LiTesIuC7FQkU703LJxtp9QEQareG0UFxPIhEL
   w2R7WgU7l7tygVnOWYoj7rdSfbdHuLb77/u2O00O5Du7UMq/P+yGWSSdA
   A==;
X-CSE-ConnectionGUID: YBmDZ+SlTEin2VrCqUShDg==
X-CSE-MsgGUID: iT6vvNBhTPam1jcnfHW8OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="58857511"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="58857511"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 09:01:42 -0700
X-CSE-ConnectionGUID: dOmSvja7RgqbAHl6zeyoBw==
X-CSE-MsgGUID: FK7taNyhTrqmcT7oXRbI+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="136661870"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 09:01:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 09:01:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 09:01:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 09:01:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s1rH5+L/BXhQseakUsvj7bAQ3jBN2QRzBR3DJeJ+094q2yGlxb5VksLdDNZ+qwz4NSkNdwVnZYlwVNDdNoHBdtBTpUJpjhz64Y19docqeEJYuw40VCwTQKNX39o3hTOmr9GYcVPx/1ii1xZaqIo/Og4rK4To7x18a4gqqmfrOmNE6yy5ai2gyckSxrYU4kjQp097vKFfN97RV/eHTIrOLMhzciK/BAQKoTyTDGrVMK3qJVq88nhfqSJdrSFgUbFL49ZX38jzj6BcYVKKE/5iASywQnbtg4Nb0x3+8HCvly/Nh4Rn3WhaGg/fjlX9sukAkg09nXEKQePJxmj5i3lmsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WiB3ej6+Q/GhYDw5hZF6rnBnnzqK/MAfaZl09ofe2wQ=;
 b=t9TT25BiqhtNstshR+d6mnK6GEqXD5gkIWJOw1j/juDA5nJ1k8Kf4c+WNHxuHUvzlLg7gaLzWFrg9L0QHRiUuftK9CHHMHPLzHrP4HR1OyW+xXDkXtBsWz2T9RCOnmkotUkPwXwGNp2xitd/Y11A5IEChlDDdMrlOTmVQKVAs0C0nRtZ3cpoBE3PcVltwXc5Rarg4xD+lbVjbtEQ4284hEGD927LFFbSE44YVMDLOo0bTpB1ze6ZQMNd70P/ioujsVqVd8dDPB2j5L0flmiH07X6tqL5lbNxOodTdnedNNxJV5H6cY1WFKj+q1oj4cHqNb6yoTThN10+JDVzyDykww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB5277.namprd11.prod.outlook.com (2603:10b6:5:388::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 6 May
 2025 16:01:31 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Tue, 6 May 2025
 16:01:30 +0000
Date: Tue, 6 May 2025 17:01:27 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "Sergey
 Senozhatsky" <senozhatsky@chromium.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0246.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: caa453a9-a048-4f32-0159-08dd8cb74416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J4AzeInZK5VUjfEcXYX53YTcSvLj0KuDZk5XzxoUVJ7kfn4wpwhgvmLamGDV?=
 =?us-ascii?Q?TvI4FSRdIUolVrTWgx3fEKG9XwjNKL/xB4/Rd4boycXgxx5qLjyjz8WtMpGW?=
 =?us-ascii?Q?OKqozgzdvAvUX5fUm6JRFo45zLg7XoSonHt4BnmLIIEGiXxnk6tYbccWWUaL?=
 =?us-ascii?Q?cXNMpH3FtfMQo+Qc5FbqOvA1jEhIP5TjdY4zLMAZk6Blc4sKZcF5AzuA1nzU?=
 =?us-ascii?Q?a9lhYpu1mZkBUquzgCy44v7r5eIjArAfJJZ7Yug+zv5sFhy8wTs3gPCE80b8?=
 =?us-ascii?Q?3grVEEH4QXXd1xUmTQNHwb5Z/nEj5B7k5Kbb8djrxiy60pwU33T1FtqqbDF6?=
 =?us-ascii?Q?Z2JyAk/P1B19t4qLSeZ0eSfDuDk2RIe3v1mtX8d0Ehdgh8TP20bND+YLL1bN?=
 =?us-ascii?Q?Z2x5eY0/xbiaYWyKiN0uST+IcL8cLIntyG6FDJyDUoRAc3fUhQSm7cIvUypZ?=
 =?us-ascii?Q?cSX6ibVQrPfodZtGGxj+cVYcDIbsE6OEnw/UWxLYKBgs4Oci7cSOno352Ba5?=
 =?us-ascii?Q?ot/kxEkoFQL3GLOmdCIqV6wC9di/q89Z5eASENZxUnzrw2xWuEhwYFaJSCrQ?=
 =?us-ascii?Q?Tygw+IZtc3H8YFGpuAzy44Siiz9dW8JfM3DcJf6Ghzq7TwCKsZq01v4BeZhy?=
 =?us-ascii?Q?LXsTbdW8CXGLlNE0Enu9EiLv4/alkbx3ZI8mjDtOh9yfTvAnAN6fQJU+WEgW?=
 =?us-ascii?Q?OCt2+RO/WD8bAIwqRQuvtrRRowgVHPQQu/8smyipre27jKlHq8qL2o/kfbdQ?=
 =?us-ascii?Q?IX+bfhqZ6WtA3rfH7a1DSiwvcshgLF4tpQQtnDSvWGaBT4ShNDW90cn2HzxD?=
 =?us-ascii?Q?olkAqmaKmzVyl3yTcFA3488l8ex/kq72DGx54MRFbyN5RwH92UJ+BcgMqd3e?=
 =?us-ascii?Q?wq38WX0lxuhhezyqYI3vR6oE4ZEvgC4pDnDjBXxeTfnLeelSFpbF3YB71o5M?=
 =?us-ascii?Q?uYixKPYyRQ6Fpde4akRFWqNvMXj0J2Ggr5Zvkl7+HNorLRyamafjLQapn7nB?=
 =?us-ascii?Q?67iwl4jRgg/oOOmJ0delgrZGIuOKvGqwkE2nVt+oc5fM9sVSazm6ZuU3gDsf?=
 =?us-ascii?Q?qvHHvZ4Flq6N04DcBlhIU8To1defn41uqQtyYhQ8skEsq2WNHbhKcWy28F/5?=
 =?us-ascii?Q?A3ak2LoxkwpkXZhhphH3Sn7CjDevhtHJcMGbxDGu+WC2sd2RVAL34eZlgYkE?=
 =?us-ascii?Q?WykU6zClNkK5CN0Brf3LUM297XdFiFI3Ljb8fUvrfx8U64t2lRWQC5Go6rte?=
 =?us-ascii?Q?k/7tCv/kBUemytk5q1inB9tYfJdkTgK5c7/yf8t+RIBU8R52I6a1IwFrld3h?=
 =?us-ascii?Q?FZTSEfGZHNupPqgzzj4885Dj8P4fM5sF4oObhMfvRRXw7Fu+zMsgQGaeNLH4?=
 =?us-ascii?Q?HuAL5b2Ec7rzx8Zt9FwYi4gK3klD2QOCce9fkZDYVQWRv1X0nCzEDK40NJlE?=
 =?us-ascii?Q?2MtgK11yq08=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4T0hZ7rotbCxrqCPNPEPhqMkUbu09hM056nsDWU5iGPUQwe0EFcXNkbmNHOl?=
 =?us-ascii?Q?AcyDgZ3KsLNSecMzBFk8gBfLuT/Faz2gnFWFEiXbqfCFq2AWn3h7tKda4aBq?=
 =?us-ascii?Q?H+v77sUZ8MtD1X4T/Aw0HekS3pD2AA5zOF9GkmevoGtocWgWp5m/CcZqZVQZ?=
 =?us-ascii?Q?gDqkC5w//LdWV4RZ4y6HpiIEmqW+pKl6Z/m4RnoXw8cd9y2b6KZIWoaSu0V0?=
 =?us-ascii?Q?oh5wjIiTefuZhlOe4KTpT04V7YtboqdB4Ny56/3y/S5pCj4Gf72Glp9a8/Bm?=
 =?us-ascii?Q?jtcL+zVGAoBRRpTuR4Be/y9RBnVPpiP//0UCOCT0wv7uAFW7s2ZkbXCH6HRr?=
 =?us-ascii?Q?dbM6CJoaWFAsuUY+PqEO60wy5lhySJY/DCLGpCXvkoDiZLDuTRXvLcLQiD6W?=
 =?us-ascii?Q?1QHPT31A4uKfNUi7y/qBP9GtJ3tzTWVeDcexRiEN7SsWeEK8D7HkU30NbVkh?=
 =?us-ascii?Q?8oVFBvuumgS32VWbnOebdPsbS8xoOmOjtM7DhzRiWySHHzTQeY+hqOdon0f1?=
 =?us-ascii?Q?NrAbeXUMXDuYjqio4yaj1CF3jEWiG8Vh1s/pQBuIG/AUp2CSQLqVVH7QSykl?=
 =?us-ascii?Q?JYOXa62hN46WAhNqt1LBaw9DIl1ZKPZY1888QtKENifCFqSIDEN3vK80YW1e?=
 =?us-ascii?Q?rEvSLuy8hH/pFo3iGI99SLelqEJHZMQtCYLlpt8Zwzrp9eXssjVD8SDablTW?=
 =?us-ascii?Q?LT11+nQPixUkHv4McPXdIro2Wy08GbrQQl+Hh8HDOqL4yySwJbmgw2YUmCnC?=
 =?us-ascii?Q?b7uPaX1GL/6AOL9wBgk4b2XxxPauk2Z3VBs9ug+bkMZIPl5Bhzeu006xPH+E?=
 =?us-ascii?Q?IYbSVv+XkG0TJ4ddqLM37ADBb2/lby/hc8ZfsDW6dTqn78+6rjTXWcKFOU99?=
 =?us-ascii?Q?tpHAwwnVpOmUX3YpKKvLam9jE5tHrzQFr0RwrMxt5n7AUr5t5ySI3Jsyjy6A?=
 =?us-ascii?Q?WhxAeyKYdiDxYVwKkaZXBFIPETUHtqyEj8+tIE0b7LzYKD8L/R5Qo0vdfpM6?=
 =?us-ascii?Q?SIGifCRMNYdKZ2SD4xeQxZKwg+nytu1W+1vIg1kAka3u0ifhxRcybJV6FBXZ?=
 =?us-ascii?Q?3c5G8rEEBC9AWRPzzoMIgvFAamCc9Cmct3eAtZ83sA3tt8BiukoPz9rOWj9R?=
 =?us-ascii?Q?pp4R+PIqnEGTfThZg5de0zqsWY0mUY2Z+1ANCbXm8CcKkv+QxKUAz3JzDA09?=
 =?us-ascii?Q?85m4PhuqjrQqCwmhSYyzLTwDpeXzjV8GikdmoBsxnTo6bpduzRqOG5gmYmFj?=
 =?us-ascii?Q?fulaC+z0vUy5vv64IAAbCg7wVswhWDZb9T6He0T84QGQUMgzIcb1kZyyvm1m?=
 =?us-ascii?Q?p1qIJfkhASt3DJo2xXIYs5TVpualaMDlVs4s2JdbUhk6b7tKDRyMsQ+6gyoA?=
 =?us-ascii?Q?sDGZdyLi3Spxjx14XmIrzSDh5tktHLKpIR5t0Qzw5whuv1Yuec3V0Ki131M3?=
 =?us-ascii?Q?MJvpcXVZQ3rjtmhBqkItlDRnYGdSQo6tBVe85TMSGF18Dgq1Eu9WClbwckbr?=
 =?us-ascii?Q?j67L9c0shoJWG0nfaHEcwwd3MdbPMYDpfjuxN9soMTZVbkrpwsILeOSt4SYV?=
 =?us-ascii?Q?SS9V7soyuYwRgxjJsz6LOvcqnp7KeeEG6GIb+ICjv9Q71O5BaggHL/qblwVG?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caa453a9-a048-4f32-0159-08dd8cb74416
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 16:01:30.7181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqay9kgeJ1wc8Jgwma+nyGYa/Y2PzpiAoAYDrk5BmY4w3VPtmEE+0w2XQyTmPIimTBiqbdOIip4lWZR0IqDtZOuu7QRf6jKSD0zEqmEenkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5277
X-OriginatorOrg: intel.com

Hi Herbert,

I'm resuming this as I would like to send an updated version of the
patch that converts BTRFS to use the acomp APIs [1].

On Mon, May 20, 2024 at 07:04:48PM +0800, Herbert Xu wrote:
> Add the acompress plubming for setparam.  This is modelled after
> setkey for ahash.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/acompress.c                  | 70 ++++++++++++++++++++++++++---
>  crypto/compress.h                   |  9 +++-
>  crypto/scompress.c                  |  9 +---
>  include/crypto/acompress.h          | 32 ++++++++++++-
>  include/crypto/internal/acompress.h |  3 ++
>  5 files changed, 106 insertions(+), 17 deletions(-)
> 
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 6fdf0ff9f3c0..cf37243a2a3c 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
...
> +int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
> +			  unsigned int len)
Is the intent here to use strings to identify parameters? In such case,
`len` should be called `value`.
Or, is `param` a pointer to a structure?

In case `param` is a string, this would work ok with parameters that
just take a value, example of usage:

	tfm = crypto_alloc_acomp("deflate", 0, 0);
	crypto_acomp_setparam(tfm, COMP_ALG_COMPRESSION_LEVEL, 9);


Logic in algorithm:

#define COMP_ALG_COMPRESSION_LEVEL      "compression-level"
#define COMP_ALG_HISTORY_SIZE           "history-size"

enum {
	COMP_LEVEL,
	COMP_HISTORY_SIZE,
};

static const char * const param_type[] = {
	[COMP_LEVEL] = COMP_ALG_COMPRESSION_LEVEL,
	[COMP_HISTORY_SIZE] = COMP_ALG_HISTORY_SIZE,
};
static int deflate_setparam(struct crypto_acomp *tfm, const u8 *param,
			    unsigned int val)
{
	int ret;

	ret = sysfs_match_string(param_type, param);
	if (ret < 0)
		return ret;

	switch (ret) {
		case COMP_LEVEL:
			/* Set compression level */
			break;
		case COMP_HISTORY_SIZE:
			/* Set history size*/
			break;
		default:
			break;
	}

	return 0;
}

static struct acomp_alg acomp = {
	.compress		= deflate_compress,
	.decompress		= deflate_decompress,
	.setparam		= deflate_setparam,

Thanks,

-- 
Giovanni

[1] https://lore.kernel.org/all/20240426110941.5456-7-giovanni.cabiddu@intel.com/
