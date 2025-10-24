Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1DA3064B1;
	Fri, 24 Oct 2025 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295831; cv=fail; b=ZPBjkVxXfmBe0kx3HlZ/lqI/gf2G8UaceMQrFtxeCnVyxESqm6klzjXp/goUya4gD8EjWCfeDWDS4A6y2UxQs47Rmty+fVYRfa2mIXZnZzceJMapiD+u36Mct8Zr+7/4oX4LJEwy1gso+qq7aVQXXtTyYY36ozTwOaUxtzDR7B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295831; c=relaxed/simple;
	bh=Nn8THTKWO7yRgyTOj0LIhmbfE89psSan3VUXXysQECI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pnCocVh9RUbb3Ucxo/cE/snnunipWL61UBE64YYEt6teShl6co6QJC95z9oWamMVZzQwak9q9eni2sJjUKq+4FEaPWdb9SWab934bAfsbQ5WFnPxt+YR8QQ5/9tzCWRDN0ru763mD0oH+HWx6SCfuhre387pCBbaMslSZxvgYMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BufR9GwO; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BufR9GwO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761295830; x=1792831830;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Nn8THTKWO7yRgyTOj0LIhmbfE89psSan3VUXXysQECI=;
  b=BufR9GwOQ2L7aGGlb/zLvGYv01ooPXK/3dACdlLoXOY/hXQThgn7yj/w
   +DDBEg/fQroLZU72UYdaC8S7ahdb4HSr5OB3BHjs0XckSmvRO2NNsyXuC
   sG8OwYHwZcn2vLxrmqYXvz63cK0bClJMGePDQuiOrR64QotW2xbPULMs7
   6paNjk3xNkV21X+9D3VQvK55OwwxtgeSKSGV1ZQgYwZ+M8wGvY4igPxIM
   SqQN/57MXUKIifzJm+UFEfZnr/MZWNjm2N33luYuCzMQTLdhLPfr56pe9
   uNuVi+2NS8T7rR+pAonuUxhNXLHiOPRM2sIa8lWcz7ULKopZEOu6pkfnD
   A==;
X-CSE-ConnectionGUID: 6EVggfYLT7qrFa1E/59FFQ==
X-CSE-MsgGUID: /i9zX6JNQHG4h/LvDoN1xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73764337"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="73764337"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:50:30 -0700
X-CSE-ConnectionGUID: 96pgbvfbT+mQasAkfEGwEQ==
X-CSE-MsgGUID: t73PYLyAQi+DY7KPNEIstA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="188768636"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:50:28 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 01:50:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 24 Oct 2025 01:50:27 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.10) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 01:50:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPLkiXkoU8thdjx5kV4/toqvqDYgmizAYxpsi5dDi7VSzDTJeoIrk7UA82mxPTg01euYfzx6V9ZiRTl/rhVL1c3x+XOmUQt0cVhbYi1BIpoCxxjjgsGfdYwnfCMFlLT7e+0zNMsvtIKeCbPOVE3TN2a6T+W3OQuNPLETNmyrBjcNnl07PfwiiS+d1yZEDxxB00N25miyxU3okhZzUKFZHYmYjQkZZFWrv5JYiWBvzJNzi0WfS2PX57eU/C6XmFOvdk4/GpO14YiXy5pUoEoD5Va86RyIjqiyOScnvxAbchMIym+Pd6/g8S4CE3O10Hutyibre8ICOCJHFP43aL8w4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6kmKH4Xt1J91P/wxOAtuvotCTITyPXA0C8guaj77Vs=;
 b=UzTcAn/kbHqXXvkZc20MlHmrL7V8QzUBNIQ/43Uq1zTZPJ3sAgpsCiGsbLTmuRV+8iskWcma7I+x7Ap314dayw5GO/bVh4AYb2XzkAMZgC/G0tSwWT6cA5tXvFLTA/iuvMHF2qBNdWsmDIjepK8G2tbsk0Sda8AK/jg5sT9AntjZoUSg/2Dz9PuvhHIku6JOxu1zE5HYBvGC4L12w/BNQFc+zbxoxRN+jAoZ9+AmUIi+D0gYxTn0ETWrNIktzyXMGOupVucg+/6m5YiVfz/Nt2pGQh6vPPnwLiWK0OEVOjXPi9X3KLgWA1wQJekZ5gu2OER2LcmgjRwM5aYgR6oufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH3PPF5AF05F6D9.namprd11.prod.outlook.com (2603:10b6:518:1::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 08:50:19 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 08:50:19 +0000
Date: Fri, 24 Oct 2025 09:50:11 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Thorsten Blum <thorsten.blum@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Jack
 Xu" <jack.xu@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Qianfeng Rong <rongqianfeng@vivo.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify buffer
 initialization
Message-ID: <aPs9w2su33uXfD09@gcabiddu-mobl.ger.corp.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
 <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR06CA0044.eurprd06.prod.outlook.com
 (2603:10a6:10:120::18) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH3PPF5AF05F6D9:EE_
X-MS-Office365-Filtering-Correlation-Id: 0481da71-6147-44ac-9e93-08de12da5c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZRQ2uyd2E/RjLtTzYDfX9YjsRwfI+0iVYl61qSaCJkRKog/6B0LhN7u9/mYO?=
 =?us-ascii?Q?HI8ot6hRTF5f16xSFjiLYytqCxRJddUaXbaie+XZmsl4wyjX3SkJKVrazjYF?=
 =?us-ascii?Q?RVWCbzklW1JJbu+vjJ0/l6LNZUP9HVXp7JLi7Txv6yFqz8ypK9XFiBAhxy7e?=
 =?us-ascii?Q?RauNYChANDYlGf4yuYAzhg/pza6EH8nRx4gBEE439mhjIumU336X6pCPAYE8?=
 =?us-ascii?Q?pt7sytANMZ+cTbWCiJFsQwr5iMXgLiQIGt6wwdn4a+QmnK3NJiQ1ugu8BOk6?=
 =?us-ascii?Q?gxskH5Fb7HVtl3MqBpiUhld6Dp/JIJ/xlY4uDSFZ+MFhrTFYsR5UU87KV8iU?=
 =?us-ascii?Q?6bFuXqwN7CAspXUD7My4ZavyQw75ARG56UIFOXPUx8kujgF440SA4vNxlU4D?=
 =?us-ascii?Q?MqLfNcqBPrDN8aMVTt/UCkR6ryj8yV91T2XxOET/PUQ66zFzGygxdNRGGfxB?=
 =?us-ascii?Q?3pIkGo7LhizBGiXIlUbGs55aB/QxT4NukhiHSbjP8PCBWZxLCseWOi4ojqsD?=
 =?us-ascii?Q?UDmc+hLFJ01wQhEpFo+ML7mTKCqnPmc4/CB3YuS69eQiY8ZY5AnmgJ1ESJ8q?=
 =?us-ascii?Q?NdzFd0wL4o+dthAiU8QordZl6HaIGPCaFUvuRMW6amvn2WAX9WdkOVAcazbW?=
 =?us-ascii?Q?SZddNgcvn8F41JYGZdgLDRURdy8JqSdXviD9GC2lM97N4ZrcKw57eYIxiksj?=
 =?us-ascii?Q?6VbnZ/QMCfUYpQujM0JZs4asL/nx82LBumW/P7Bi7oDQhVf5W7dnC7aUvYX2?=
 =?us-ascii?Q?S0onfKjwENYARNnm/qMnKTLtPiTI0npQrzJCJHYvwb/8XYhJ2ojZ5aOKzJFI?=
 =?us-ascii?Q?uziL80Agd8F7uYVBOe9+WP3ORES66R4Hzty3kXdCZu4vuyDc8qTTcIBMY8Oa?=
 =?us-ascii?Q?eqj6kBknr+e9G8N/J1d854uvFTehu6XXR+FJXih+v5RD9QmK1LizMaCRvIrB?=
 =?us-ascii?Q?4bI+DAySQsJeuwgbP3aU8/yE8BTDqCMCV42oNPhqIqI0swnkMwb0uvlvLHys?=
 =?us-ascii?Q?wO2rufiTNcRDrakDy+tT5nvniKdDZxRY5SK/igvc8m2xP32p/3DGHoet8X42?=
 =?us-ascii?Q?dNzCusJTc2yZvACpEDUz/k0lyVcqhmnTQ95eFEyFPXR91KGwhd0RlL+7+ge8?=
 =?us-ascii?Q?4VI0pp1e8yb+uHkpl69LCnx2jLUmDFrW3FpnGa/mU37wDTVUE0Qz0YzekyWC?=
 =?us-ascii?Q?BdpO79CwVWvFxxHVMBgIeHqlYH4TkY986UEdaEXKkvqdDP06cYQ8zu39DFfS?=
 =?us-ascii?Q?XlAI/Q2gyoxxJRr/SqHCzy+tCaCtUpFqmRt2YS4jege7JjGe6SzQlZmg64jG?=
 =?us-ascii?Q?gStuFHDJmtqu13kPEnvqSvQ1xWXvSNPe1QKiQN1YZUOTsOguQPfNZALY7vgV?=
 =?us-ascii?Q?6ymgwuZXEgYMw4Wvc4lUqtMBmlLLwPvTRnkHPEYI34If7Nc3NVvvZJWHCxuK?=
 =?us-ascii?Q?qFU8wMx4cMU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kd04qJ8YPYZntBkVn9JmRANAZLuftrS7HiE6pzcC5JGWlsYKYzA1XpqRHn4J?=
 =?us-ascii?Q?E/QJFtJUbUdyYLoSopex2BS66YGeTYHQVr1g1/F0yrne+40R3pcbKGG5X/yZ?=
 =?us-ascii?Q?wWOk4gONGJHj6M4gSDvD73uZNkjhSkTznb+DIR4p5AdEvh4yxNfdr+BfsOOo?=
 =?us-ascii?Q?N0NhmxcVRj+AN6Fv6kaH7uBT8ZBDpADKIGSvRAVYLAzcNVEL7dBn79M2G+dd?=
 =?us-ascii?Q?NlCkHnP3b18btO3ulvizX5F1n775FSTTA0k3D/0OhmLfbeV3VgVubbrk1gfT?=
 =?us-ascii?Q?V6WRdF+SpG8FlCNZ84dmqiWwByAgMlm2wdS4b0Qq+atAvyFCBjDSrs/rq20v?=
 =?us-ascii?Q?HMttyFGFkeBZm2m9+M8yKHFMSQL3bgJIRXtASFysBg6JTk0e1nPnFVaBOsX1?=
 =?us-ascii?Q?X3U4BuQT/clg9QyYjtM3yT9CuR5xWQKZaNgp5cdk+R9JHDwVGY/822jOT4kc?=
 =?us-ascii?Q?Efe9gqt1fZPocDiknOwWb8/JtqvKWlWSjFWTPFu5s9c9zIYo9BwpFfv04Gd8?=
 =?us-ascii?Q?OeLuUldGvXAbF+3pLZE0arV4UKSC/pc+NCMffJ6KpDUHnlbgh7zOkBOeH4Dq?=
 =?us-ascii?Q?d8VhIjt0Ire7Z3uzIEgC4AiVLTNRzk7m2rCecQ9W4vVtZpqm00EoqAJBfk3F?=
 =?us-ascii?Q?dbR7jf9z1KUNBaKhU4ddEsltFW/pd0YyM49oq5YFYXkVJYI6cT33MaMyoX2v?=
 =?us-ascii?Q?taNLCQZureKEcBUtOO/ZMtoWs4DNChSDxy0DTdFp7JDRLp6peqymLDnHz72s?=
 =?us-ascii?Q?1bJeRQRbZrTclv0bBxK2Shs7uZDCLN2wuJLN57uuHJV1KgMKmwVLEk2j/03K?=
 =?us-ascii?Q?E5BY0nUMnQ0gCaZdEkbgmlURC58WesrSYOxz4Hkp2ufOIQ9I5srGzYiFSa+o?=
 =?us-ascii?Q?G9Fsio75VfTH2gnKiowDlkBbP2R9BLjyw/JSmUKCNyFqlYlWD0c2e10jto+p?=
 =?us-ascii?Q?h4vvRr6Hz07lknMno7d7jTLSCNPZcbQ4t2Tz3bY6LJN/zQbuQQnQruc9Iesu?=
 =?us-ascii?Q?8hV0+sl4ART6MelBvxPh40nMbhZBhwemNAh6FdNuRtaqfEuBgtvnVBkJTfpL?=
 =?us-ascii?Q?w5KnWmY5C2bECsqZrQ62m1TxE3HIVhjLaxR9MMrjdnoGn4BEFSbgEGFatnVa?=
 =?us-ascii?Q?OpReV+dz1kc7DUWNkgkilYqRNcyLyoK1aV3F1nMjNueSh0IumBipWMGwOa8y?=
 =?us-ascii?Q?WQEZPfDQoyhwFfWxCUQVKYmQRaO96YLPTtS3nvk1m7XKPLWIXS1uJOV9vlL9?=
 =?us-ascii?Q?9F0M4HbBYy315XRqZUKcgzBrwS84vtjN03Hc4DmZBVLDV+Jye4S4EGJFCf6j?=
 =?us-ascii?Q?KoisH6yadsoDvuOYCbY9Ur+y118lSplijJ1U0en9qhzbYtHylmg9XF1LKweg?=
 =?us-ascii?Q?lhabnB23F8bOK3OhsWZSiduczpPxCi7q9qEy8tF32gzAonWUSMPUdULH5PuN?=
 =?us-ascii?Q?zlqaZp0Sf7T01mrTcqQqb0U8/0bGU92TRVn9urKrQ3y5g5i/kVp6qgrJvf2r?=
 =?us-ascii?Q?VsQbKeJqBRfCEQyGCOdwrk3JjXMSKpSyLKk2942s6CqrVRDlNe1uQQrqb4aL?=
 =?us-ascii?Q?d4wpK4iPcYDUhCG0FwglbHcXyGQA3arWooZcNXWQCNZe9vJ/nWUzSyp45NwE?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0481da71-6147-44ac-9e93-08de12da5c0b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 08:50:19.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDCsxsVnn5D2uJjvIutwwegNFcj/5LUkQF5PiQ3DEjsWM7UOR5P0o1XRuTFovvnBuRQbGRfNBaZUl3hVIgqqxHw7AUrbKHq4spIOMHDe4i4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5AF05F6D9
X-OriginatorOrg: intel.com

On Thu, Oct 23, 2025 at 09:44:01PM +0300, Andy Shevchenko wrote:
> On Thu, Oct 23, 2025 at 05:35:00PM +0200, Thorsten Blum wrote:
> > On 22. Oct 2025, at 20:17, Andy Shevchenko wrote:
> > > On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:
> 
> ...
> 
> > How about this?
> 
> LGTM, and that's what I had in mind, but please double check the behaviour of
> kstrtox() on an empty strings.

LGTM as well.

I checked the behaviour of kstrtoul() when given an empty string. It
returns -EINVAL (-22). The result variable (the third parameter) is only
modified if the conversion is succesful.

Anyway, the caller will not provide a NULL string to this function [1].

> > diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> > index 18c3e4416dc5..04628dc01456 100644
> > --- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> > +++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> > @@ -200,20 +200,12 @@ qat_uclo_cleanup_batch_init_list(struct icp_qat_fw_loader_handle *handle,
> >  
> >  static int qat_uclo_parse_num(char *str, unsigned int *num)
> >  {
> > -	char buf[16] = {0};
> > -	unsigned long ae = 0;
> > -	int i;
> > -
> > -	strscpy(buf, str, sizeof(buf));
> > -	for (i = 0; i < 16; i++) {
> > -		if (!isdigit(buf[i])) {
> > -			buf[i] = '\0';
> > -			break;
> > -		}
> > -	}
> > -	if ((kstrtoul(buf, 10, &ae)))
> > -		return -EFAULT;
> > +	unsigned long long ae;
> > +	char *end;
> >  
> > +	ae = simple_strtoull(str, &end, 10);
> > +	if (ae > UINT_MAX || str == end || (end - str) > 20)
> 
> I would go with >= 20, the 64-bit value is approx. 1 * 10^19.

Just an insight into the type of strings being parsed here. If they are
well-formed, the format looks like:

    <AE_NUMBER>!<...>

Example:

    11!l0000!lm_thread_ctrl_struct_base

This function just extract the first number. Currently, that is 2 digits [2],
and I believe it is unlikely to exceed 3 in future gens.

[1] https://elixir.bootlin.com/linux/v6.17.4/source/drivers/crypto/intel/qat/qat_common/qat_uclo.c#L237
[2] https://elixir.bootlin.com/linux/v6.17.4/source/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h#L11

Regards,

-- 
Giovanni
