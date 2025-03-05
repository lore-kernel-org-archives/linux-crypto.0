Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405D2571B1
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741210679; cv=fail; b=LyTQGmsF45Yde5QaGPC1oD80tLa3EtoZZ6HZMFUy5qaxlmQKhfQ9tjQ7pr13s23V32eUKsoGZaGqZF7+uQw7ugm3/Us6E1F9ZMT6/ZGmt/RaUozBGFn2XaPgMQd2Hv2NjDRQfp6ddAaj1buXoGKBFcTWhuXva8j+ZkYQ1g52gdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741210679; c=relaxed/simple;
	bh=fFdmhjzizYI0Yp2jMybbXl1yPTFLKFy9XuNDAlPRAlo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IFLo8nWgzVJyw/DiTtsA1ehDMyEB5Jt9vuPqR0mzRKZFaK5tflOeTntVby80FRF4xyFZylMjH4Nu7aBHvkQ2WgTQF6GqVnZOvKQe6Jsok5QJOiG5TDEXqHPS/Ug8hrWYV314GZstsFWGkrVVf00s4p0wmHXwWT1NT7s72uZ5ZUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUnf1Bbr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUnf1Bbr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741210678; x=1772746678;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fFdmhjzizYI0Yp2jMybbXl1yPTFLKFy9XuNDAlPRAlo=;
  b=KUnf1Bbrtrz7gzGJCnWXDdNC6wADHtecJnLMtdynNNxHTUWqvS5bk2n4
   jmQMlmpMIV5JJf7641LDOwS/I25Qc8+wd6KHACKFMbZKMU2/YL+dXgcgj
   S/xUpHnQuD7eASLdddqQHz7qoztjDY2HQM+8GBXPIlqzPj6oLpmq/zwL7
   jFwQC1IydycybhFqsANI4mwJiAi0w3jUDuvteqH2fQ/MnuE3iSHpeZ/XY
   XnrxPzOp7r6goscBetCVQ/qqYV67jfQN30xCqOUSXWeEbwMT8LGr/XTD7
   LQrFJ/jXUZVnYBrBx8NRCZrxCKz4ymJ9hLtsb/VbOHQgqtr0rJBK5/wpp
   A==;
X-CSE-ConnectionGUID: Y2l3mfHKRfe+zpqDdAk1Vg==
X-CSE-MsgGUID: lCocapkUSl63h/exxGNyTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42222246"
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="42222246"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 13:37:54 -0800
X-CSE-ConnectionGUID: ulcJpj+7TaGBoVwVXNmJTQ==
X-CSE-MsgGUID: FDZ9uM4jR3CYCHlxheAMRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119736211"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2025 13:37:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 5 Mar 2025 13:37:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 13:37:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 13:37:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWPKV+qhftycRhLB4cHekqP+tyWVOE/1TP25HBMNQno6pGE+rgebmtXG9Fcbajel+4yA4gi4hmI9/JEaGMOrao70kADdkXJSx9F5kolsthI70IWpr1uVusAoQXWa3IRhtjhFIIY29JcdB3yJBoGlXerK94MBzUNQNUcWM+yztD+lZL7Yro6DvZF0c8ardrh/jyAH/Wcwqi+14w+UWdR1dlIadnyBQrupIRcpGw6Xju63OMDHy00X80ctelyNe/E05nJSO26zeDr2QpBItUkVgsUEeF2BgW2r1TjJ4a5U4ep767AObgomVe+Wyd9SiuN8opbisgcJoyY2ynGAdpaQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gerw5QWdzqFj3eA8wyBvvGyuoREH1emkThgci9fRXGQ=;
 b=FeF4Lc349wsMRtjHDNhhm0t0caDdSANHK6hRb0eSBjpj7hT8olOab5+FwhYnY+UPelh+PkAbkVs03RCDSWYWXOfM62XUZog9aesIC28Uy3ItLERbvnYKr7Sq56fBDWSy+xS8Om9lOPoPg51UCXYlRYy+5pQGGmuKG1Ko1K9gZ5dFrgK7mYOtVhEvhnGRXJqPw/S4EGicXFmfyCN+7ed4jxOf5alLwYsLWQ1c/fxObSRHOb2Q1gG7RRvkMqKfLtRk/SOAOGdPp2zWqrl+i4coMD5Nq8WRhun2IcOh8xOymPsgQuKBKSPNZi8MDAM0kj7P+LMVOMONwE+l8y55a2JdsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY5PR11MB6235.namprd11.prod.outlook.com (2603:10b6:930:24::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Wed, 5 Mar
 2025 21:37:51 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 21:37:51 +0000
Date: Wed, 5 Mar 2025 21:37:43 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	<linux-mm@kvack.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar
	<kanchana.p.sridhar@intel.com>
Subject: Re: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <Z8jEJ1YVRU0K1N8/@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::33) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY5PR11MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 9410516b-cc0f-4c2b-ef69-08dd5c2dfb33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dOc/oA6tuXHGMSREGEraQ8e/NCLjVJGqbmnF/PebdQyece2rtXmRR+6kluzN?=
 =?us-ascii?Q?vGP6kZci1bgAypGDujjNUeAJXjgK2TJ3UGu1pcsD6N5ghTakblZvGkw9FWVW?=
 =?us-ascii?Q?+UUim0x0Pi/yo5PMIHeL+w9O6MfCvZNAO36AYiSmceYh5uzGk3DX/vLyf99v?=
 =?us-ascii?Q?ZexDndtkJOlRGhq7IYVTG6cdJlrR6AVVlYLmYB8W9sHZ42Ho2voufiNONI4X?=
 =?us-ascii?Q?gqAf8F/wCbMTrPaFtecIfhhvsdv4nnk9IP+IZOJqeUGj8LjZpKIYKUPCNXdB?=
 =?us-ascii?Q?U6F4v8QM8Pz6dmPDzM4NvZPUTYCw+myW6jR8GN2q9W6FEW/FBxDt96Z5kCf1?=
 =?us-ascii?Q?PFZqCVTbEI8PYHPisDN7+qZ2p1KfI8FCj7TnXlvgmlE49p+yJX5KAibLQLgd?=
 =?us-ascii?Q?J+IOV8sf8+YmMK2ZzlmA2wB6VOi5dCqtRtQzsSPT1LE/GT8f4xXqFOuoLe1/?=
 =?us-ascii?Q?c7fMGgSsj/jnFDpHjLebs3BlswNq9Tl4n0OooRRy74n6toi/jYCYULfRjBrc?=
 =?us-ascii?Q?XbvqAJc8jcNVfC6CXGmDcm/sACadnWFQ2Yr/GWBPswSVAm5byqcBEzJlI2X9?=
 =?us-ascii?Q?4EoBaDfgUKXTduzwHxyp91c090nabSWI8S/dhAs5dULZtNwRbqYwd1ZieNpJ?=
 =?us-ascii?Q?i8ZeqOxPt/Unf5+jDCOaMFnoScca2qSrkr0DuXt0YTD9i27N4Lez5VGsIiLV?=
 =?us-ascii?Q?zqdFqxHMSqIJoypk3JWs373Ta6MBH60qohnm16sPEB0mEzuYDtw43/GXorEm?=
 =?us-ascii?Q?6FEgAe7eKxgOi/P+Ka8XXd/dADdynhLpXxBkisFs4ouV4LKy6fD3IYqzZKPG?=
 =?us-ascii?Q?N6kcB66cl40EB+aOAV+WcPdC/YXuLsvgRkfqlk+TVAejwZnyUeVrILXLhlPH?=
 =?us-ascii?Q?iw2MT6nVOXjZl5hE2srIM9pqC/rOL+pxFi6uwDu4DQ/W9ZUeAwkC/SU7TR8h?=
 =?us-ascii?Q?UldEIxIQabLhRvqFLCm7HuDmWo/tMhzKiLZtT76jUW2UFk0lPl20ethSRoel?=
 =?us-ascii?Q?IDxhUbwnmNxErZyebl0nSk+AwYYyVpd32Z28O3AlID+FleJcVpUkIeQIJy2C?=
 =?us-ascii?Q?6w49pt59M7faOtGwYKGJjaAorS9b9+pRKkUhKjBIqMpwY6lHQPASzvs1gjsC?=
 =?us-ascii?Q?bxuq9bOr8dQlTXPwZPuvmGLaJj3xtmVTdfGLfBQ8YhzT1vD3mWkJ1I3L2tKj?=
 =?us-ascii?Q?yO5zLOjYp83ZS3qFY4LoD4seCpfPUZzneKlEY+Qkbez0+XGxN+aCk8rUgROg?=
 =?us-ascii?Q?fDle3XAy8oJtMwWOr/ru4tdPxPGRZIlaPD6RUibpE1wMP4EHXApKvNrYkulT?=
 =?us-ascii?Q?3Qht9RaR/mh0KnQttAKOatsOr3clqUwWcfbFZogY5dTiE7fjlwIqgNXuVJql?=
 =?us-ascii?Q?PkCfgUfDy7DA/YEMvOv2mLnpfk7U?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u8RS0WSom2iRBbUzJk/yW3pCK9fgjh2iBo7DQSKIbDJWrPuQdUaosxMPMqr5?=
 =?us-ascii?Q?uG9DvKHN3F9JKl6G8qKK9wfJ2dYxqDAl0TTECi2C2WXH7DDWM3sBVkWX9gFX?=
 =?us-ascii?Q?lQQom/Z8sJqVDff7S3qD7MxGSM/jPbdAZOPoRBBTuTLJGXDcPzNzxqHdPKsD?=
 =?us-ascii?Q?UWkVHSBcDlVvzy44faQqhnYHsObWq3S40iZzJD040Tvzp6uXK01d2ifqMh0r?=
 =?us-ascii?Q?Zb0/qL4yDLfpB1OK4f4Q93isB331jiI7qHFQG0ewPc4mCGTZ0TZQZ2LtUoVJ?=
 =?us-ascii?Q?jQtf/u0GjG3THZVjsMmocXa2XRiZsETwaaqYMjeFBzvNCfAajDf20dWx6H7M?=
 =?us-ascii?Q?NLKWSlcwxDXOmLoOHhX19MeU/dy8O2M5diWRiafjxw8/LfjiFE8Y+Prh0Hty?=
 =?us-ascii?Q?hE+VVXMCvbmXicVZxVdAljrX4xDJ44Tdk1h1YxJzCfOv/A2FROc+WLKQpN0h?=
 =?us-ascii?Q?0SkpI4sfbTddfNk9ruV6JsFVoH6iWh6CPf8Q8Tiu1Rg6SIMgV3QJtZqUcV7G?=
 =?us-ascii?Q?mFZQg5cJAXARMktFEcQLzSwCDRLzl5gU5kf/plceRGIuz1IRZAFPWUKRTSk9?=
 =?us-ascii?Q?hxFggaO41pM5SrYZE1KzE2aL9d6iait4n8LTkpDvtrFofNFSSa3BQp3K4a+Y?=
 =?us-ascii?Q?s9l2KMp2bf8YsNS4+Qzta/wZMd6cTK9ZHPEGIkuorUvoW3XrpUjSCQWLdhzK?=
 =?us-ascii?Q?NCg5Fcr++9xDZ1ulpaa/i0ZXVjPV+XubwikADa6VR/O2uSkgpNgVad8EA7HR?=
 =?us-ascii?Q?VhBvUHL/lvU4oguISAJFzjrLgo7eoqNpnR0tDe6RfHtW5P1L0jv2fec4WDUf?=
 =?us-ascii?Q?nd8nBWi8nNRN8JoDp9oovcXl5yieXg/f+SBIElp+TDp3WxAtUpsJOfwuswmh?=
 =?us-ascii?Q?G5EDBch9saHtysNtLZ8uwEzpnigImTvMffjpQkLRGGX43mvoYPPoq/N3nG8+?=
 =?us-ascii?Q?MJGymLDXndMXGRTBK24EkrS3Fm0Pv4m7fFT3fGfwKtYy69a4zzvhsJ9eiz8L?=
 =?us-ascii?Q?WGGI8eEntnAn4wajiI+7n7TTjwMazt/rtA9qQ/fIHSEB3Ilo89j7pJtB1rtW?=
 =?us-ascii?Q?/oWgAdTzGMnx8st4fPlcGEF74gn+QxcCuNn3L1ftkOYDUyMp18PouTV22cxJ?=
 =?us-ascii?Q?8FZ59fwP/7m5e+TbRU+zMW6g0xvykvW4cGV+UV4P7/W0mmjMfc8vA8YR06lO?=
 =?us-ascii?Q?KjMyPeb2rzWjObXz+OsYPrSxpxy6mMuEKwLSdN/hqpZFD9e3CdGuBPMymVcX?=
 =?us-ascii?Q?2sq8AdgcU0t850gLkiwE+OB6UJiOYUFrjr74xMl1PrdH0mIlqRAnmA/So7qh?=
 =?us-ascii?Q?8FCUrsPetX5CbCLcWwVa+kXbMxuqZhUoA3rw6k9QAhk0omMM3u3iF0mjhgbM?=
 =?us-ascii?Q?WJVbjQyVeJoIByJWcXsnguRQDHIfQw86arM3bE0UVW181MwSgMwgJo6vndq8?=
 =?us-ascii?Q?hnMutkAreAj5m7VPynJFwxdKiJUztzyCgWu78XTMXB+zyIjNj+WCyIyRnfvX?=
 =?us-ascii?Q?lLzAJFYwAZ2kupZNvrN6KWagMlkmQ62Z6yMmEJ6XWP1bCj1s3E3NEvQkeulp?=
 =?us-ascii?Q?/Yff5LcHnUVIc6u2W+MfNXYxekCiD+As63BhHBVWZfmXq9YDN2Zh+j7eSIMk?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9410516b-cc0f-4c2b-ef69-08dd5c2dfb33
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 21:37:51.5388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZREr+TgCSzBJz9ZhJrCmCRFcyGPYzK2nyIeD/q44eKmeTp6tJfUUtHXEO2+dzLdf8Fg7OHHUhil1MAFnT4v1bXUiRd5Oy+cOh8zdSJGAsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6235
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 05:25:01PM +0800, Herbert Xu wrote:
> This patch series adds reqeust chaining and virtual address support
> to the crypto_acomp interface.

What is the target tree for this set? It doesn't cleanly apply to
cryptodev.

Thanks,

-- 
Giovanni
