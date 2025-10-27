Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B933191A8;
	Mon, 27 Oct 2025 08:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761554862; cv=fail; b=qPdyf/HeKpDgNL8fNt3VrGyh7lLigX7LVTv8yZcxonS1FMMmmsvMjizujNyXYfl48fTaMDZ/qsP6ka7x4KjDkBKYg0KgD0gCAYuBhs4rr3ELQyNY/NmhzKPJ7XGZgF2zHVl1HNCnJHMDgbOVUeRTDKinUpb91rPkf2UHfDINrx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761554862; c=relaxed/simple;
	bh=nPIx2jr7LhR/R1e3tQCHJvGXZ8R1gRzWpvR7MSkfnLA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kp8wXg9qvmNCoeTCkskhkVZ/ZQp0K1+Pfn6GEmjfS+xupwve8Yn8FYourR+cyCfvG5kYP3u2M608KQI7Fz52xuL4CHd492WUQt3PgoR6nMXZInxClzBsNb2NsiJqBs32GjI1YFC39QDIOv9gQUAnoYmZRY5IbGLVE3DddOZT4EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sk+UJJ/u; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sk+UJJ/u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761554861; x=1793090861;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nPIx2jr7LhR/R1e3tQCHJvGXZ8R1gRzWpvR7MSkfnLA=;
  b=Sk+UJJ/uienYVn7Ckk1IGhcN0o1NwwALN3BpXWqqyk0XeFyjL6U2LJRc
   AAmac80RboXK5fpwhlIZq1MKf4MOijxaYV70YV85ZrZO8/7t2ekq2WzKd
   W3mjpQQZumKvV1N2yZympLwVQA3vFROK3CXXmvYkCF8JrnxkpX2pr+nS2
   EzYrIW2EOEy1+cMzmsB9liyMfha2Ly3tgPBGr5Bpe49aHv+qzduxqwOw1
   K/QrNk5g+TjZAMevO0B+rfRS0U94Vzb7yk1/hkivct1gvZtnfmDD63fZS
   9O0AwQ63E+uT6S9KKo9rxaKblakNmnJl1b12d3Cs3LTDdbMtf2SmXO9CE
   A==;
X-CSE-ConnectionGUID: ehOC1AbJQQqXD8XmgDCyCA==
X-CSE-MsgGUID: +paZhlDvTee+Og6bXXJWfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67494330"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="67494330"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:47:40 -0700
X-CSE-ConnectionGUID: Oyv0ozFlRtmj6K1JhTEdOA==
X-CSE-MsgGUID: aboyGFWpSnul001me95wrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="215885239"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:47:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 01:47:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 01:47:39 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 01:47:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QyuHn3W8usb7Ybab/1iDQsgFNFWPRWTVtj0KzUTSo8j+Aa0JHoYR5qfA5SVwLgjrunOpI9OcZB2Z61WqN7hEwtqDMryljuqHUXkDEEekDwBkL910QGJ0ee/ij7azlTZm1RIug1T/C7Il6PIy33nO/4gXa66DynOPGoG5diyd5Te0NcFmvkMCmJaQsQxHtCFFCuYpRMBwysLl+vDpTgE54NqGZ/lGVQx2zEcXtgmy5FwrTo8EPcu5m92q6niel7K4W0+TeqJMO0tYuBLpIxBxU8ztDQNxXsGiuxOTuJgeKPaK7LEy9vja41dibKvdm9HRxhJYgiNUv9LSJQ0DpW+w1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTOzGAKQ77jzAxOyl1O7BK+sbqQqNj96LxnkVXYIqXA=;
 b=PVzovvyanRx/0aLEsi0oe5RMGvBhQiZQR4U5uc5FvDEf7A5Z/xmA24tBIGPCucGGrlZgLpFzBs65XCTlG4gX32ZYShh7YPUdeXyucSmfdXQ/bmnCupomDNqg2VM0ZMBKjCAl4/KWoeXYu698RPVXqGmBjjKSf+dbbRY7Agcx+oKaGRTQ/QJ4MqR9MgiZRklIB/6DusGfnThGCgwkII0MzarplIhznIrd7Rvj+RKLSQF9zILg4q4b63cSH0eL3jBiKdvbyUTOHMXUg7ElDRQ3My/Y90oRgQmrRlgvcO8SR+72a6waRvAcF2s/l4r1AlEgJRWw3QU1A1Y7Cw/S0nmLgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB7769.namprd11.prod.outlook.com (2603:10b6:610:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 08:47:37 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 08:47:36 +0000
Date: Mon, 27 Oct 2025 08:47:29 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Qianfeng Rong <rongqianfeng@vivo.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aP8xocba5k3fAyaB@gcabiddu-mobl.ger.corp.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026015710.1368-1-thorsten.blum@linux.dev>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7PR01CA0045.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::18) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b90b77-c2b0-443a-8060-08de15357a7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IP9yzMZWi12XCRiuD73iLSM4HtmJTtc0xY3qzlaUbmJsGotEo8cQdmK/78Mj?=
 =?us-ascii?Q?4HJwENBikqMfJBHEjCwJnT+EmgAX3YSRSiAOUcgMxYTddxxyTN+arZC+3pXt?=
 =?us-ascii?Q?hLtVsVhDmMMgiyLH1XQ6bi3YHk/Q9eTYpnw60+LeJMbkWI7DUv6ZIQqxEDpp?=
 =?us-ascii?Q?ncnpzkjkB5Dr4DV0WeSu+/ys3ahFZoPMvSENvz+NEs1pd8E5XhBMj/qHQCVp?=
 =?us-ascii?Q?C1IDjAE9odCLRrZT1GWtUlAo6akdocD/qIv+l1pJAGwC6B3d7aVN70rmrwvu?=
 =?us-ascii?Q?10jANFtoKX2s2/FeK4u57p4BzobOCIFJMKjcsppYMseoUhrt0BQUDnI6Ut1T?=
 =?us-ascii?Q?FWCgI2VZ0RbUqlclU1a5JV6kfF5YmCmOz2gB49WnMjyh7tzPShkkwRHzZJle?=
 =?us-ascii?Q?xAHytMUB7bfs/Zl4YSakUGmG3xVjpmGt2dZ+NC5sdM5nzbdHGpYywQZhhb/1?=
 =?us-ascii?Q?iq0Y7eRXAaePXm4OTOkotOwQbnXEGIVnmySNMefJWTahgAR7AZlDEIUm4x4v?=
 =?us-ascii?Q?jsjT/0nifj8iyx1N2i6tDRVJ3xSXyXEfCana1cWWGktUguIcsjxITSS+Mk3H?=
 =?us-ascii?Q?bvy7F3EhSpRQ9wcseHnrwoKBLErXgRUjmcBFGL3MZFJom+j7XtuuLYka3Ex2?=
 =?us-ascii?Q?jH/SXC7PzfH0Gfj0F0AB5bolP/Le66MnVyN6HB1YqUIGNwqQX2EH1SiTZMM4?=
 =?us-ascii?Q?GkQyjma/Hmo/V8FVxN8f3SvkoMe4mSe+jZ0MGsbEMRfQmGvbW66xcu4REhZS?=
 =?us-ascii?Q?gmiQsQ+5v4TpXioMIVsjyaBw7pV3FW17DJWm2msyof0Xt9fbIZMhrM7jCMs2?=
 =?us-ascii?Q?SSmjVl81ng1VMp00/Y1AdD7TeN0lUDzI2sbsYR1RutwmAQ44i8He+EQMi0iB?=
 =?us-ascii?Q?uKzGcJTTI4erc4iFxERvDjRx//2DyxVoBgRL3qVbsrkxYKCfv3Uh3x/veX3/?=
 =?us-ascii?Q?5dnXiRMXMm56w/+j4AuZJNUaKnDQRVPJk/3x2yrCI5ruU3BVJgkaiA0RFW2B?=
 =?us-ascii?Q?GxQZ9sGJunl9en0+yysGH7L7zxAMnST1HkbBZphVrCZDa/vck8C+3WAdapjQ?=
 =?us-ascii?Q?EbzEe+gNQOqLxDV4xzpMkbhnwyTHg7VaSzIwcPpH6p54dlO2HOOTMvY1PS7/?=
 =?us-ascii?Q?u5imyRcQR/4eY2nGBe7ft1c1LALSefhlxpPGYFh/X4/hpdddVGIKrU3HPyxo?=
 =?us-ascii?Q?g0rh9m0M5X5wQaiY8WnopDyyXrFUQFj4t3P2WMiKvac96WeA6KtVKCna5xjh?=
 =?us-ascii?Q?VT571jSAKcAPZvmF26+0QEjxYIxrkdizEKuzcvYLT329LEf6L3LDXIH+boj9?=
 =?us-ascii?Q?VNEoV0MSnjJp5DV9XVFEjVzVwLmMi3FRcVuBZNeYcIYQ4QNYldn2jNRTG78k?=
 =?us-ascii?Q?mesWwPIdF1xD/EYkGS+XAwCIFTAvKWwE8U60I8MOIINWnfpzlsDoLLt+O4jo?=
 =?us-ascii?Q?/36ye4xR85Bhfc6HG7BG9JGMSlWwA4mw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?30etvy+E8TBNYR7rQcmVguGkvKh3obWUA4duDD385vJeCmrdjTkWCmL5URjg?=
 =?us-ascii?Q?aATpAt9RoOCTobk01HtvckssdX+L5pV3B1DiZpgiSTLzfkjI1NHqbzhPLD6D?=
 =?us-ascii?Q?yWDNOyFTVxL6OBtP4/JGHINv9C75NcH5zTcmplAHanwFF/ghBpERqFpnwzfN?=
 =?us-ascii?Q?LBUoMIwphSBuIj31C4hC+q5YdKFh4Pt863b1NZtAuLcpKup6OhdJC/OfZc2B?=
 =?us-ascii?Q?iv2p6VJYBVEp2Tbxpua+qmEJLcxiv9Mb26FzQUSibtokd5WLBjn/8dneyD51?=
 =?us-ascii?Q?w7LrxpxRLKX42QBK3BCjYmZniQFfooT9fwBwiXxwGj020qS+Uwz2RRel2F8I?=
 =?us-ascii?Q?56ZrarQe8HsLL3xNyIaG3cWkrywhov20jMK+Y/eou/p6qvDApdgw+mb96KD2?=
 =?us-ascii?Q?+MkAzUxm0PhtkZZ/5rG27Ftgi8Npjt5k16exA4nbDD4RF58XkY6YG5oq1WJZ?=
 =?us-ascii?Q?FqFzfrmMvJthD6iHrAQpOIqOCZcY3XMe1oVqlkdwSGoruwJg4CddF39D75Ne?=
 =?us-ascii?Q?KAhbWc+ggc6z9bCn+KkqkErKWkw1mlqRAihhwD6PK6IZyA6b85dGYN/T7tPv?=
 =?us-ascii?Q?Zxf3sDmZCm/LYLhpJ6YyqfQ1UWNFZEyF8ezGCznM+yg9S70knMEDVs6pkSFL?=
 =?us-ascii?Q?+G35vMDpqFCCb3UeDLvdUTWPrae6R77wNuMDemMkvlDNF1K04nhX6gujMU7R?=
 =?us-ascii?Q?SouKI/OqDnNsrDiRq0pTmeuGK62XkBFniVlSWn5oscRbHHtMdf5++HHy8fiZ?=
 =?us-ascii?Q?zTIneDFAJPnf1CSUOnSgKInIIddkuoofGf+JfZqAnHrFvXhJ2/PAXKfi3YXT?=
 =?us-ascii?Q?H6IK+PPFdF61dJeGwFMe86F25bQr2viuMYQsKa8YzkgKvzRWOap3gE8VuSl4?=
 =?us-ascii?Q?2F/Rs4fuSb2qyV8XsxIBap7EsizxyTXtO0aRnny2ZEe6KMg/j8cOZYVA7B73?=
 =?us-ascii?Q?Q/w7XQXy50tR80Jea8zMBJdsQjit3+0Jx87wRovemzEkaoA2hQWWtYTVDkTe?=
 =?us-ascii?Q?Amv+dAO34sghjORgyN4c2zowTYpfmxFJmGxoX0bOKPjxTJJUmRrIPskNHQS9?=
 =?us-ascii?Q?y5Xe2DkpIfpz4RBAopHqk9d2cohvkMUVboctbvWgpvh/sH8iOfQ42Y8dGeMi?=
 =?us-ascii?Q?joPytC7GqBXU8JgM9Tdnkd74+enpS5+XjEu5xSSKZFvgP0eD0deBXCkmg2ZB?=
 =?us-ascii?Q?fIS2IcsMP2Hlds8vLYohCT6jENAaEuUxq2Bthl6T96KHTwQRcuUO7xEA5gCt?=
 =?us-ascii?Q?RaG9k5cvZiZZG0YgtDkvMWPPmKsvoZ9JwVsZ8MzVUyzfqXNch3xurvaUisaa?=
 =?us-ascii?Q?4r7/FCAONq7RKAJyiS4gpIEuchOMceZu8Vjplx5/oukMmr0GqOPDqv2oV2KD?=
 =?us-ascii?Q?pIAUymVPbeZSQVfLq0E2YwvOi1CKVZ1TSK/me9J/t8aMzubsMDR4cybFgMoK?=
 =?us-ascii?Q?UUvhxXiHLSdk8IGhrNLdmt5CFw0tZnEXfU5v0hCYtbDP3uBS+uThpBYFMywI?=
 =?us-ascii?Q?5VWUOF0RrtFtU55zl0MT8fwjnQJepacSdBcmtAkU0aYkm1AdI6I3F+svbysl?=
 =?us-ascii?Q?HCUF39wFUPmTjJyZHeNPeEufdNRR6PO3N6S5Ip6BumBgy/aFTfAGln04M49o?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b90b77-c2b0-443a-8060-08de15357a7c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 08:47:36.8187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6Ug+Xg9or/xNmDXRKwL4HaZZe7soEOflHGPQlRD29xhZUQYBDYil3zBD5kAniStWAUvmzrHC/rf2oGTtHLQaqlAhyy4xNJ847LHq2+AzSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7769
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> Replace the manual string copying and parsing logic with a call to
> simple_strtoull() to simplify and improve qat_uclo_parse_num().
> 
> Ensure that the parsed number does not exceed UINT_MAX, and add an
> approximate upper-bound check (no more than 19 digits) to guard against
> overflow.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Thanks,

-- 
Giovanni
