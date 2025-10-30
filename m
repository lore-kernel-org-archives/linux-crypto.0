Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B67E354AEF;
	Thu, 30 Oct 2025 11:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761823670; cv=fail; b=N+u8Obl5YOpdO6LgHs/94ba2d+EozZysL0dvkxzVV1b5GNgpooUo6fotJE8bh4qethiWofVBOaLJ765ITnM3CFI13wHeWmlJd6GCI+TkVjnOcdjD8Vj+VFdYj/k+t39mKpXA9eKC1aZG5pL4PVZt1wl68P0BDTfya2n380/mQtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761823670; c=relaxed/simple;
	bh=EVUKmpovX8rSE78uUjgo8+JstJgyZ4IKlE0N8j0JPis=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l9MdHWXVerk8bkQeix8YL9o2izXoTtROL+2mAAtl3kHaFeIfEvCLWMaeYuqekCG52ruCUlq5f7NI7nu6OakH+SZvcvi3XDs1YUSVTRedENrO28PlCbgS+AExQJ/9UDSbPyJ0Xlg6FQoxH/s/yELyPzg4lF+50QqWIoIO7skWfiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GDfOU+ac; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GDfOU+ac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761823669; x=1793359669;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EVUKmpovX8rSE78uUjgo8+JstJgyZ4IKlE0N8j0JPis=;
  b=GDfOU+ackHwWhaqWubL+HXLos6wu8JI4wZyhkJh3MTEAZuF3TiH4eDJL
   M5jSZrHTc4oOqlxPwLQY4m1wRsRB0r1K9RZzSogvVOFidSX/pNcoQ6UII
   JHiqwi/1sg4j21f/rYHPEMwQK32dKO1OL1DctkYIehkNf+ceUfLi4KPb7
   H1n5E58kBsok7MifWoy5a9U2yta27Z7Uli92JNVKs27gL/PLT85NLSiFj
   W1LB8X2yK5y7iRaeTTqg7garwj7i5F+k/shfVcAaGqDfAtNxekU5X1J85
   9vP+02yI0AaSzhVNaWOofaF609oDRa++mBx+aivVvMg/MYQ26Mqgo6w9I
   Q==;
X-CSE-ConnectionGUID: RHkJpSmWQ8uFTuKFdWkGYw==
X-CSE-MsgGUID: OJy4VOTTS/aKnqJs1uIXbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63870843"
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="63870843"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 04:27:49 -0700
X-CSE-ConnectionGUID: jPvC/92pSqCnB+sCliP3Bg==
X-CSE-MsgGUID: tlgiXSDLTnWaFFM2qL8dGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="185626268"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 04:27:48 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 04:27:48 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 04:27:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 04:27:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbU1UNGzUJZoo+KemsKvmFUswTyBfTdp8/Za7qr78ghCWOBEnPLpovvJ47rYLY6WGyM9HGp1u/r1qeZw521c7ZkSMesQ3dXdIDRKosAO3bY5LJkob8F5u+gpO3WUuIeeQw7J9CuAZFA/GkSOYQf4Odmi7HPlSRU3CJuvGnUlpU3Cxk4bbE2QEsQUN16RACTsf5q/hax3WXMWAxQC23lI+Da9NMECEI3vaY0zTbFpdlClAQfaVCgbg2RrrgJx/XXT3POvDT+YrJlYhpLWkdhUsKnNg2aZzEyTtuHOe3/OFlNS5XlfypJUO4x7S6Vk/bmtFeW3RbQC4Ws0UQyNcaNmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPc5l7L/MQyf6bxw19GgJhY/zmTs9LkxM4Qg08LQVZ8=;
 b=H4S0ZxEVRHsjHiRc0BjQ8xAiRxJNMTi03w8wMXv5ZCZzH+rz4EubIE/w1rnAUM3hqgPe9/94lzyys1EekGfVI/zBdbzThC681LCUH9LEMlHmKsmB10MemrVZI2oDoZhT4ghvneranMSYWG0F89Cu3DY9cRT+wPftDF+zGY1lFhQbjw/Hyyr0Gr+jQRcvKTGy3xHzM6FTk0ec3ogMYFM0yqtLz8XfA9bU8MZGD9IUx6OnIBFnkoQ4uDYHUp+cKfiflM7/U7I+UMH+3WUQojp4R8ppIgwkRAvZQzrAM6+/FVdGxgALS+6OEY7wC8JiksOaKgN3mfIxWHHLZUEeSPH0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA2PR11MB4922.namprd11.prod.outlook.com (2603:10b6:806:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 11:27:45 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%4]) with mapi id 15.20.9253.017; Thu, 30 Oct 2025
 11:27:45 +0000
Date: Thu, 30 Oct 2025 11:27:37 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Thorsten Blum <thorsten.blum@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Jack
 Xu" <jack.xu@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Qianfeng Rong <rongqianfeng@vivo.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aQNLqclwOpEhMcaT@gcabiddu-mobl.ger.corp.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
 <aP81GIlKmMv4pW-8@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aP81GIlKmMv4pW-8@smile.fi.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0046.eurprd04.prod.outlook.com
 (2603:10a6:10:234::21) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA2PR11MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f13753b-9deb-4316-21c9-08de17a758fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mx5YnZMovzmifMRte7khUMmnB+SYjsAQ1GvSuQMa35gp4MhMunSc0dsadLO7?=
 =?us-ascii?Q?kddxbwGYjxosefN/3EaCjBU0LtTonsf/EI9KbtjLRwgdIpsYsYMqOGmZ9Bk+?=
 =?us-ascii?Q?1AfH57cpofh+yz0Y2a/lnB8xp+5YlafRXn5xrPGh/tn3569qABcvvEYxn64W?=
 =?us-ascii?Q?Ci6bw1D3zQcC7WG7zt8LCTlqm6Bff72UK+/9XlNYiQxIdAlXhV0Mv0B82rw5?=
 =?us-ascii?Q?koaifeIcNIZqde5EbinSFG2kIqWqjP1/eVoHDs5esjUsxFl0ITAEJ/BZozOw?=
 =?us-ascii?Q?u6H3xXCpnjagHmWXO9d8MA30c9z0Gb06eb/Qd+onK0cfJs7zJdyrD8zlLrWm?=
 =?us-ascii?Q?a8CMSTAGrXVAJavWfr0MdjOagGBXmYNC8gCUH2/ovSs6Xxs2EajcSC5mMiu7?=
 =?us-ascii?Q?9tooMgMmgC5LiHX7YWunmMbckLH+N7ab7J5L6l/RHlytLuOr68U8H4ekYnrC?=
 =?us-ascii?Q?279YIpVzKTFlwtOYGVcjmsb6zExnzKhf7sCnTCGMLQXytqKjCQNp1md6I16c?=
 =?us-ascii?Q?Njm4tPTnZYRAQzdMwFDdBRzrisKgD/5UkYXYlJmodX2auiBimPQiwn6+kPMD?=
 =?us-ascii?Q?SGLjf/sX28DgBSJ+lTsfiftzzEaQAfGySTW8YmGLJjQ1Z8TYyx36LUwSmYpu?=
 =?us-ascii?Q?K69h8GAAAgXTWnK7vgbvsCy7BEyCS1dFoPKGkYDfkOr3BaDGc8Qo5cadTTtq?=
 =?us-ascii?Q?XNbIZdnUBT/5h9nMbbBN0SEQgVsqPBg3SlOTfMQppQWqMa9ooBNZWONLzCpY?=
 =?us-ascii?Q?Mxts1iQfWCQAA2pTVub3NG5g/1G7PIbsvgfOs9TAz2K3DFYOXgdBsq4yKl5Q?=
 =?us-ascii?Q?5qGbobJugBNV+UWohqXKzpg/AtsWL2oqcNbIiRanLwn/72iMDMkBfHObDaYS?=
 =?us-ascii?Q?Tym3sFFzy0Qj8xIwGD11VZZWprU3x1E1DjGIoKgu5ShpRfl4sSPIcph+jl6d?=
 =?us-ascii?Q?e2A5bPU2G3mBwmk1wW5PT8jXI++1Ewf/jet5oitytBKKFe6cffrjBYryZ+Pv?=
 =?us-ascii?Q?DHGO1PDFlSayinegQjtHL1IMBOSaR5xiz65qsioYENFD8IGC7IMf2G9U+Emp?=
 =?us-ascii?Q?ZP/kB+rCc/qa5s/kkqXYm+StenrWswoywTHMFaSroHssfOco1de/o3lZ42zb?=
 =?us-ascii?Q?1e1G9yH5KO+XEag1z/hBTJZJgfgPkNuBBPjwYBegODSEKaCcLakx7niN+yj8?=
 =?us-ascii?Q?lxvp7JMVUxRZMKZzlGNaoX/ulWgL6DMnvWKePP0rhuHqqknvW9L15FHROOTU?=
 =?us-ascii?Q?SVdUbbTds5rPi8PhjY9TyA4r18UYesQbwUqC6pwuynPcf8Pz5NF/2AReFGSR?=
 =?us-ascii?Q?6Gvp7ocZIkwO2phjCrWSVOsLVHn7le9A7gUu8v5QO5J+zpwmFOhQpUrDOjju?=
 =?us-ascii?Q?DxUlBhaAYqoB1tmzgUyEs5AavFyQ6VEHacQvoluIjbBe0ZCFdg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QZJti0jfD/jbLXgIt2H0yp6noa+kMRA6IPU9gVs4jdasIN1YvVZIcQw8Li+4?=
 =?us-ascii?Q?UR+zFL2arTRA8vAxqfz+/WiNZQeMC4MDPXvlncPft6r5eO7FRYSeddrbqnT+?=
 =?us-ascii?Q?Z9piGgymZB2+zPyxhRCVMllcBtEf2U/GoaRJ2esRrz5cQLJVLoUMMnUULhjC?=
 =?us-ascii?Q?BMucH2g1IqBTGyEGERY8aLjry7VVkCHFw+pVfFj9Apq1EukYt+676oXIKC+h?=
 =?us-ascii?Q?ahTp/Famzh8Ec0x0SSwS6cWKRFoGKrLbwfvzZCStymLy3LWtZZMll6++Qd0L?=
 =?us-ascii?Q?EiLIyWXWewx9+p8q2+0D4So8Z3J5vQXNh6SMJMxq6xVQuRxYM8zQOdoIeWQi?=
 =?us-ascii?Q?RGtSOi9Ixpd4ZIygcMngQX8UYaH71SBLpwNDqAmZPVfpJ1njDFQg9JoYDVP3?=
 =?us-ascii?Q?HMXmgkiE96P4xOAI3wjq6/D4uBVoYjCAnbyMmhMkLRA1wtQ1PqzljZmQW+GT?=
 =?us-ascii?Q?/H74Tb4BvNMY85Ls7zI3JcopcPYF8NOuLqRaq1VrxyDtvrCqaWz8DH8swT+i?=
 =?us-ascii?Q?AtUGRQ3y0lV60TIbOMIfsCxwGoXOYsPrVxwOMp5RZ5BnSQg2visxDZN59Cs0?=
 =?us-ascii?Q?Yt55gbtSI+efYOVHcwixIjWfWJMVjMzvjQuYKw4lPeL0FvQ9Av1KUv8rwEi9?=
 =?us-ascii?Q?DQouQlexI4SeWJGqHua1viEwHK3MSOvrbKIpyT5AJ5pNRpPayEjsy1uJ6Tfl?=
 =?us-ascii?Q?yWdMIEe3SouCz708QyA/TKReMPcWxaezGRhGon45FJYEpnNbQkmA8cNrMjtp?=
 =?us-ascii?Q?NaKhz3kETKhlvFFjuqoNuP1uNNyCoHk8PQHOBygYYTFz7+gvfUo7fO491FlN?=
 =?us-ascii?Q?TGlrTBnxLpkg2sJ7LsRGyYD9u8dXV+mVvjc6MjxSRQBritIM2ms26BzpkkYd?=
 =?us-ascii?Q?xy+QeTruSR6OuHynwvQlLkNlxRtyVtzBh2Bhl6+HHnw2kTr0QmfK+oaYJ2Vb?=
 =?us-ascii?Q?SrrWne0xNFiPnQHuq+MlxwHe0Jiw8nl5iZiNYy0TW3IfG6ll+ymKKVQ0yqkn?=
 =?us-ascii?Q?GedO6SAWON2Qg/YGeXDaUwcKeQUNIsLd3DcE6l7n4SUkB7XuHyzSkhTkyzcQ?=
 =?us-ascii?Q?H2vqn/DbTwRvEOS+I3mgDQcOlJ8Etsqf3KUDF94cdGbQtTAFW8Xp5Ge7S79d?=
 =?us-ascii?Q?y7LpWm76cZUCun2JMHeod2hHwlPSzIfVZy+3wVVxcgKb+u2+JjyRT+uO9JyU?=
 =?us-ascii?Q?YVO1mr066/BTLeWrv95HeKuXg+aru0F3dfa76etskJxZOHW8j4HdD534fjoU?=
 =?us-ascii?Q?pQlVG+Wr4ggi8uJwv0Lt5Lcl3UP6aqDcuwPG01CS82uqd9a/N9LnfVS71xau?=
 =?us-ascii?Q?ddXCYzACnMhgkfq5RlTMbPePGPRKWA4w8uElrI5OwLLRnUFQx/r4xDOejPPD?=
 =?us-ascii?Q?j/LVvO6VMiD9RT0wraJsV2kJq/DsVExrKu0XVf9+5iG+wUjpcMQJ2J/eVdtS?=
 =?us-ascii?Q?nMEcAcVqMUgpw8al/sHWmYAcHgytJsMnbvd2RaEXUW7IufyhuLQsarYg37mV?=
 =?us-ascii?Q?7tMj17WQGjBd7brqMtlXCVM4qt+6HQzkcyZ5VjFj0wPWQsokf9i6howKzpCv?=
 =?us-ascii?Q?92REdU9DKc2E2s0BTICUwS2uTj6dMHSaCkiRuSggWm0q32ffAaQhz0G2z4Dm?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f13753b-9deb-4316-21c9-08de17a758fc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 11:27:45.5885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FS7BmNbWQtHBwZqQ2s/1aM41D31sVvzeM2RtAYW9Mi6SQPXB2JjX00wUvam0nUI1DE02hwYDQJbAlpdm3Q9lSySvREWXxJzyOeRiukLPAMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4922
X-OriginatorOrg: intel.com

On Mon, Oct 27, 2025 at 11:02:16AM +0200, Andy Shevchenko wrote:
> On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> > Replace the manual string copying and parsing logic with a call to
> > simple_strtoull() to simplify and improve qat_uclo_parse_num().
> > 
> > Ensure that the parsed number does not exceed UINT_MAX, and add an
> > approximate upper-bound check (no more than 19 digits) to guard against
> > overflow.
> 
> Reviewed-by; Andy Shevchenko <andriy.shevchenko@linux.intel.com>
s/;/:

I just noticed this while applying the patch to my local tree.

Due to the typo, patchwork is not applying your tag [1].

[1] https://patchwork.kernel.org/project/linux-crypto/patch/20251026015710.1368-1-thorsten.blum@linux.dev/mbox/

Regards,

-- 
Giovanni
