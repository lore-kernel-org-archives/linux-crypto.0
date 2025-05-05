Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66E324BD03
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746452629; cv=fail; b=egzydSDbCr56MiKg+p/9UM7Rc8d+lXLfbfunWnYf6e/YRx+QqnTZVaOdU3l6aJG9fOFPYVK5NJptddTDzW6XTydPMpsp+agNQx39K50gSaGMMAkp4U8sRq/a3AEjFPuIt08t5S1RNiRbOB5BZg6nC8R4FOHgw567djEG8XkNAwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746452629; c=relaxed/simple;
	bh=Bsq+tuwt3rbz8jPnWvmWoNv6eTtA5dU92MqDCexkxro=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qYlmqlM578SihxQMTyKArtPsxOncWPJ4T0kBgNws6KMY9IwAwdLDGz9VBjBYFNJ07Ay/LCB8QQHJrE2wCd3HTKly0mvmNdgj54lFjPuTGrnh5k5siw1bl20L7Ms3SvBA+DmHjpM15HTJl4ulvpCIFxMQ1FEhAf8matD8HJihN8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkagsGl6; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkagsGl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746452627; x=1777988627;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Bsq+tuwt3rbz8jPnWvmWoNv6eTtA5dU92MqDCexkxro=;
  b=EkagsGl6vto6ws3zHBjIukfH8bqbLQ9DBtHC10e9zDNzDpQ+VXcnxACj
   FZsKPvf2ttwRV2xRdBTuJgMtAHe1uDHSr1V5X2QUjK4zd4+/1DezNFGcf
   dpFfMNISuJtj2z6QHW3C66fl8YOUGsUYMNmjmEcFbLa3ckWvoa5gf/eL0
   qELtGld94MxFq8/gEB/NaU6FybVXBunmoXUhG4JFOIXvmJPVKP6HIcC9s
   jhe+vJq+FP7KMDY7JWRt+iQuJbhgsX/LuE/P3k9b5TY8tS7RGPlBeXnvL
   QdKYS6Fkeg2SLqucGayBKQdHqwiHY7RCFTg+9ikeOb3aLKgMVJYhcNSMU
   A==;
X-CSE-ConnectionGUID: ommWo1/qT/yqxpxJZizV9Q==
X-CSE-MsgGUID: qfX8yzqeTVOswqgiFGJn7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11423"; a="59049293"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="59049293"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 06:43:47 -0700
X-CSE-ConnectionGUID: E//5/vfCStOnjGJUd0xCQg==
X-CSE-MsgGUID: oGJc+/S9S72eM0FlF/MKcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="140411612"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 06:43:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 06:43:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 06:43:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 06:43:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNsfxnhrLzXBLZezcU+/h/HW7fwSHdJSNi0mUiwW1gGn4qBzzXK/tEreajpkmf0lKyo//DqPWqMZhI11t9/I0vgYQ/AMq6GDYY5ydYex2IVbxP9pUziuVBQDaxqw7il4Tlvj8eXjHlTfi8l0zBosrthdo7oIg5EjM6vDT+r7JIhIxoyE69lFfDSqD1UwRktERyK3YFBxH2v7+G8JXmPjpQv6ZebqgrKRF15gNS3ZMcHXRYDyaGWFhTctvTNUt37EpJaXkdphmLBEWGaSNhUDbL8Qj/+REz8o3hraO9HokhQ6mqoyXWkprket4Xs9Ht02mzFbFCJSCa08pHyQYUSWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDuC1rA9Nx+0R573smQrlUNLhJoFcE7AiHSz1SpFApM=;
 b=mC16eJ0rELsSWTN4KfUb0GYwjjpVMqL4GsYGd6gjv3TyYkuIkMa+nqHPyAZhpy0ycTjtZttdqQUGhMStdOh8AlzoZcLxrTs3OiahWv+v2S9ob49Uz0SDMYNjhgTxxrEY65d2ER6u4HjN8e02SLmC8gIakzTaIx98MpyNRFOhw72/BXxZByMQc4VFtXxqHxSNRRImGIDLa6uH56+PMtpLHkTdQoKcceuCp9eHiWo1Vw1chorjE6CdXXpdHMy6g5KrgshP2WzwP91WhMiMqQtCkOp910slwz73TfXOWw7SR4revgZCBSDINrwfqMqnzUUaPWCGW6cp+H3gVCX38rNXKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB8549.namprd11.prod.outlook.com (2603:10b6:510:308::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Mon, 5 May
 2025 13:43:42 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Mon, 5 May 2025
 13:43:42 +0000
Date: Mon, 5 May 2025 14:41:40 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 08/11] crypto: chacha20poly1305 - Use lib/crypto
 poly1305
Message-ID: <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0088.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB8549:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c50e7a3-93d5-4661-323c-08dd8bdad986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nRHMFjTYovVNNcxpzR4nj3s+6k9kG957fp6Mgp6TGKZGNoZ7ytKljLBBN2Fl?=
 =?us-ascii?Q?PQl+KWjqde37c2mYLtwFLxM1O90XSthkmGDiincUrCyu3eE7T0gWHQswm7ud?=
 =?us-ascii?Q?SNA1aYACeIG5HzWYhmwjMf0Ao64YyETEb5KTKj6W25Rprj1z3tg9pcmRe3kX?=
 =?us-ascii?Q?Ddukv3ubghdA/YQnnZ5w/hUoOHsy/TrWeZWj7z+HeG7f6CFMxE1yIwDg78Y4?=
 =?us-ascii?Q?hsCkBC5dL2Uv2J0G1qMeZLc0q8WaW54r6gZ0xrsP4JdYIUx5QcbKY98iv6zR?=
 =?us-ascii?Q?/8nHDbSp1KOyWT6M3TLphOWwqH6dOrL10kAUl4At+B3NRhVpf5U0620Casrq?=
 =?us-ascii?Q?Zd34P+mNpmJ6uIdnb4LoukKhNxODSsDeHw7paTuEjScdAIigRQqoYg5IYOx9?=
 =?us-ascii?Q?5kzqoIXS8sWNx6i2NyDyepavLsJkcpXk3LW92SJxCkPXrRdKU/ehdTvnKEoO?=
 =?us-ascii?Q?UIHs6vNOHO8k2YezAI6Rzulm3hrnLWSzYAV9owvccroJyM0JQ3uc6bkzSbGP?=
 =?us-ascii?Q?ZBdfkgOpzOSo13KbrfFRlVoOkX16XA3GEFgWbTsFTyyecgg0pghubr14qhEY?=
 =?us-ascii?Q?hGszccyyiEhKVUwyDUIpNl9JYUVoflOI3aOl2rTjljnjbARj7BWKVDPI6bXk?=
 =?us-ascii?Q?pv7Gwv7E+O10Veg6P8XRg4EElkdPpfqLDmsXoP3BoY9yVLibrdPvhApBczgZ?=
 =?us-ascii?Q?rlhYi1MwDzrLPCjmtmAc/RkWIVrp7bfgMiIOG146/xU/Z5NfCpgx8oBwcION?=
 =?us-ascii?Q?4JSNJpRyyqAS5CZdKjWfk/3V3TxWLCyk0f5vpSGa+pzaDqt8M16W8+Vg9bO3?=
 =?us-ascii?Q?baJ6UQug+aT9Ja2OoJ8WyeH66vFO3FcnbB0lSNZF+PDiqvbwWHfRG1qnOZ13?=
 =?us-ascii?Q?7S+9jBrSWjG3UOn3AQXTXNu8lt5MnE1xhebqHOZqfyNc0x2owPvgM44TDkvK?=
 =?us-ascii?Q?tYIa4gIpCpLWB3Rb1snaXEi/o2boUBepXPel9Yfvnb9SOGh6l2vAvVomVoOJ?=
 =?us-ascii?Q?9NMMiNIe2KEEO1GZl7VKD8rr5GEqo5nGvv7B5dQvPWz9xNPzpodJRvgV9glq?=
 =?us-ascii?Q?BHavBiSSnYekpqbg8leVAfBlZYsJ82lDYFJzd09s3QskLDIIX18qu6UvA8uE?=
 =?us-ascii?Q?Ug55DQkpAUmEjFcs8COYWxUZ0XByLBn+SW1r6b/LEffdjqjVTblRktL7VWy9?=
 =?us-ascii?Q?hWdRMtszNUKYmz/yAZ5Fi7hGRYjiI5jAMtk5Lzv3XS7V2U55qn9vgObiiphg?=
 =?us-ascii?Q?jRHto/g8Qd+mFHsCWEjB42ebvYwZqe98VAYtGWc9DSc0fuDBNbMnKHfFkD9b?=
 =?us-ascii?Q?i8ptv1frvZCulyi3WGokn1yV32JKSp6k9/2N+bd8Dc6bla5NaxiAnwG2WWQm?=
 =?us-ascii?Q?7aUCZO/MgHlVO8fZp9ziMGr76AY9Vj8rMKctYCE0LJwhl7dI4GERqkufzeH3?=
 =?us-ascii?Q?kA1kMaKBGj4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJZBY8Zf1Yiz6NfUXCjTfFS+OEtJTGU7Q267JJwHSd9XFy7Eb+QHGuRPPbJu?=
 =?us-ascii?Q?P8akKTyeJVVuZKRV+wDsSgjzfOO6o8TYnWU7q9esgOTaCk+sKf3XwqDICFLo?=
 =?us-ascii?Q?i76S0uyZi5dry+YS2NoCKPHvAwg8HgFhRFYC2JW1N5cqHExdaoxTzVzla1G/?=
 =?us-ascii?Q?FWtvC5j4Bg0o6fPfMvEeD5lbCaL7M/NTu84M+xX/Tlc2XVHLAEUkknBXVLA+?=
 =?us-ascii?Q?wpF6EX+Go7T6mWJxLAtwwmFWk5ZNYyzMeAQD1ZBf+m0m9oMMBSb2EodVQHC1?=
 =?us-ascii?Q?UVYVY5hsEOY/427E5j3FMRyiJAmi07Qy4y8UxQQ9f5VMvkYQF5U4VwprIFEn?=
 =?us-ascii?Q?gjG8rUK7rzv+gh+7D/Hh9nWJBvuFH24DlTBwsvGwWqa1sEeUz2/hBfERrMau?=
 =?us-ascii?Q?QsErMiBOHcxgBNo34W3xb4vji8mT30LPHeAEu1RERkQ5Ftw9KPrdO5lv8Nt5?=
 =?us-ascii?Q?mAdfT1U4FJYxDcAzCaFJUKQJA7HOYKG7k8TquYPdRSfpXaK1/RbE5hA1VV/z?=
 =?us-ascii?Q?RIJbFl1yXgAru1vZRfIb5tZw1dQm8F7YuHr4BRvRwje4TD9cyiIh3RNOMDC9?=
 =?us-ascii?Q?LFlr33S+7zwYWD9aIudZ5zNUTJKfeogt8WpsCXFQ5/1gRrNRg88dhdYer/3K?=
 =?us-ascii?Q?q3QpwNsjEa5mr3+TtHEYKB+vlqdDUmHo0nFhxZUeA+BPdBTWaTq4lbEVsN9m?=
 =?us-ascii?Q?3JPe0max1enGmClflnPDLcxPcXkyVBwHvKWEMc4UI698ahvpbH6pp7Ap1Lux?=
 =?us-ascii?Q?dKBSkIAW6a4KsXx/Vce9Peus3Yy1BMSYYMEMYXdgQ+rp9XHnGZjKkAdhn/mV?=
 =?us-ascii?Q?6QiJttv7Sf/B3FMoKVpiv3rkyFdoT9L9+AKKKjKgPaonjQaQB27WFIN/tA0S?=
 =?us-ascii?Q?Geug3qh9OjctYhH4+Kc838l5OsrgdnHkFXG3zG+Im4ZVCJUvYZ6h1DVH9gRJ?=
 =?us-ascii?Q?WCKo2bCnN+3s0Sm85kfdifVArMJq9fH6zvdnsVltVXn/hdHo+qUptsxR5qD1?=
 =?us-ascii?Q?k5J0oBhIbmURnUeUqh19XIRWxv5MQ/7JFuXxdwt9OyjgdpeiEJjv/n2rswfp?=
 =?us-ascii?Q?jDZAo1hxu+ITYhKtsEthcb0nlFvQCsQcrA+AxVJ3Z9GIVhaw+ZIv9n+FzECn?=
 =?us-ascii?Q?2iT6Q6n/Rg6dBAHp2oJCEVCeiU0QSWCJMZkqziER4FCQZzZTmURhHH8XXd0P?=
 =?us-ascii?Q?kl2uZVM5s3dBDQeJZ4fvyMDdURx5km4QnJSiETI8Ij3VQ8oPkjy0JAwyLPUi?=
 =?us-ascii?Q?esV6M0BY94uRa9JiCpLNekatbWlA/HOfdEq+yHg8s1Heo15RbjHTIh7nWZHK?=
 =?us-ascii?Q?8qlUbWPAlLxPttpfmEm32E6V+IszBb9abna2g47UxuGw10ScRyjOzDPBi8b/?=
 =?us-ascii?Q?ShrN8SXMD0RoFumrda5c3bbcCbX2kEyUiVzw5tTUrsKlryhK2TW4YOb6m+YT?=
 =?us-ascii?Q?ca4uc+uXUEAgwA8IyW4brKM2RI9o0E29T3H5xDg2dlNVbO6N2W6+xPQCVuML?=
 =?us-ascii?Q?xsIXiaRqb614MF75MZOxGX+wdW86kYLudTpaI+YMOMAshuhWoe2EPXWzwz14?=
 =?us-ascii?Q?v3gBrXDmGXzpfbGw8jIEBFV6hm31TLO8jU3TRZqPzrySyU6J/NoZ0cDnIPDW?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c50e7a3-93d5-4661-323c-08dd8bdad986
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 13:43:42.6288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JW0NMYVIUr6B/p/9wtkboYYKEjKWWeHN6j7SpTDLOq9nhhFFpSUwbTn8qqaC+cF5XAiW0TMhHMyy5WkBdMhXpn6Hg/QOZOIVhQwHpy+o4Iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8549
X-OriginatorOrg: intel.com

Hi Herbert,

On Mon, Apr 28, 2025 at 12:56:21PM +0800, Herbert Xu wrote:
> Since the poly1305 algorithm is fixed, there is no point in going
> through the Crypto API for it.  Use the lib/crypto poly1305 interface
> instead.
> 
> For compatiblity keep the poly1305 parameter in the algorithm name.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/Kconfig            |   2 +-
>  crypto/chacha20poly1305.c | 323 ++++++++------------------------------
>  2 files changed, 67 insertions(+), 258 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 9878286d1d68..f87e2a26d2dd 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -784,8 +784,8 @@ config CRYPTO_AEGIS128_SIMD
>  config CRYPTO_CHACHA20POLY1305
>  	tristate "ChaCha20-Poly1305"
>  	select CRYPTO_CHACHA20
> -	select CRYPTO_POLY1305
>  	select CRYPTO_AEAD
> +	select CRYPTO_LIB_POLY1305
Should this be `select CRYPTO_LIB_POLY1305_GENERIC`, instead?

I'm getting a build failure using the latest HEAD of cryptodev-2.6:
64745a9ca890 ("crypto: s390/sha512 - Initialise upper counter to zero
for sha384"):

    ld: vmlinux.o: in function `poly_hash':
    /devel/cryptodev-2.6/crypto/chacha20poly1305.c:155:(.text+0x751bee): undefined reference to `poly1305_init'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:162:(.text+0x751c5e): undefined reference to `poly1305_update'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:168:(.text+0x751cd5): undefined reference to `poly1305_update'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:176:(.text+0x751d4f): undefined reference to `poly1305_update'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:182:(.text+0x751da6): undefined reference to `poly1305_update'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:186:(.text+0x751dd1): undefined reference to `poly1305_update'
    ld: /devel/cryptodev-2.6/crypto/chacha20poly1305.c:188:(.text+0x751df9): undefined reference to `poly1305_final'
    ...

I have CONFIG_CRYPTO_CHACHA20POLY1305=y but CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m.
Looking at lib/crypto/Makefile, I see that poly1305.o, which exports
poly1305_init() (and the other dependencies missing) is enabled by
CONFIG_CRYPTO_LIB_POLY1305_GENERIC:

    obj-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC)	+= libpoly1305.o
    libpoly1305-y				:= poly1305-donna32.o
    libpoly1305-$(CONFIG_ARCH_SUPPORTS_INT128)	:= poly1305-donna64.o
    libpoly1305-y				+= poly1305.o

Thanks,

-- 
Giovanni
