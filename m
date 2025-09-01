Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1920417C203;
	Mon,  1 Sep 2025 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742689; cv=fail; b=pvOWufB58U+qDTneV0MDgpTMkxJnR5V2Af2gROjCzVPwpuHktoQbQpR56bsG0Jx9HLeoCQj/0seMnWrmgx+V0jMRUX+40bEg/zE2qu115zKgnx+J3atSnTN5qLesRY17Y1uRJsnEnxKjgv2l4rbNgq0/pERM8Aw2b9GX5s9rEG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742689; c=relaxed/simple;
	bh=Wr5FDwWUndXyFWY32rd5uKy92FjlKk+tg98cBLaSawY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ci//MeJ2VJmKUYinJwuXO/doCdpioKuimeaFshRDUKZAHQaN18pHBH4lyRAZ2bjgu9wJy3sv6rwgUBEpdRlxXzw8ZogmheO44o6eIIsTHy7KLKiAveTTiLpJuBELLFQC5YVgbrr+P4r4rPnrqf9PHOd4frofDZOQZ13lA9BRwAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JbBSDBq1; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JbBSDBq1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756742688; x=1788278688;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Wr5FDwWUndXyFWY32rd5uKy92FjlKk+tg98cBLaSawY=;
  b=JbBSDBq1b7qVOC9YVs1d0r9a2YGdCo3polU/cMu6UTYw/j68IwqnM5Xt
   SJrAVgWvOWI2RsVeqR2wrsRy9Hadxl+5lJjpQiKRxC7fznMoJbmMtjWLe
   XcOLsVKFwfpPUyavWHx1rWiTHB1yuRoRBGYzC1u2LBSNVTs/yBp8/tw9R
   9d1jZl3gEKO6hTyEAvuPTv8k3Qu+tA2oBvx+lJ2l1995aaA07EzjcEbdu
   L/lfre0TdSdn5wvShzZdK50RbipFOyhcaCQ1ULO98MDmcLpt2ZIJ0PfsS
   8KMl6P3CWvjf4DB6NBlmS4n2bzuH+X8IpEUo/2wXFIp0ehJAb/guTfuFC
   Q==;
X-CSE-ConnectionGUID: veEsgIdeRbW6ZfsEHMh5Yw==
X-CSE-MsgGUID: haZsaTcbSq6a8tk+CHBFBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="59111803"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="59111803"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 09:04:47 -0700
X-CSE-ConnectionGUID: vTCceAplSXeXntuYrsQT8w==
X-CSE-MsgGUID: 6FLNeUR9RLiqT0dJliGqVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171908173"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 09:04:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 1 Sep 2025 09:04:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 1 Sep 2025 09:04:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.68)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 1 Sep 2025 09:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtmZk/0w2PBlO2HiDgrPUACTg3EMEZg0Ma2xB0nx0vcE4ucbJ4as/aPIlmccOssns8Loywt+yazku+5p5X2ADfAZWTHDYyqZFuOHembIKKX/RVeHAnldsMKxq2Cx/dhk5WcUIwEyQ63XkgvNVWyb5A3HWIUkIoWisAXfnPTWG2a61G/KfXuSSSxx/H/jkBD+xVP8uxdEjg8pjllByV9pGzJfqgKoHCPlauYOkHcoZVz05sgSpURJDjkcHaeLDmu7h9LcBMc9XQJxz6fuilFhevelNlPyylvApAjxMechBNWUIkvK0PAUQzIijQFgXwlAcmDsw3zPL3EztdQrMVAOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upqgGT6dIE8XrlqeL8baoCIbalUsdiedGNPOAijXkDc=;
 b=F1pJV87SPpwfYctja9xQkaHoU3C7GHSvERQipE5NVJztT3wxicbwfGpGuMFs8kN1PMESJlmMMDNglVWDUyOsKJ1cEUtYrDHoTz0/g6kAOFmvGkeH/Mtoydpm+z6SUscPUjRRrISHM/l2wDNXqFaygkj+G3KsIaNdKQHmHO56MEI2AFsTITxoeV5QHRzEmp7vRhrmqCcGVkKyIZeZsue8LEFWejT59H9Pz0jnv7EGqDPxWUSubqE2RQ98SVzu3NnW4pQpGYCkL8lIaaNxIV/YrmkEVuxAcqH4AY9P9wU1xUpJBaNP+DXo7GZe1k8MnQlLZibM57k0YWjQV0cvsmtbjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB7333.namprd11.prod.outlook.com (2603:10b6:8:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 16:04:44 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 16:04:44 +0000
Date: Mon, 1 Sep 2025 17:04:37 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
	<linux-kernel@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Jason A .
 Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] crypto: qat: Use library to prepare HMAC keys
Message-ID: <aLXEFW/YF4LyukGp@gcabiddu-mobl.ger.corp.intel.com>
References: <20250831205457.36143-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250831205457.36143-1-ebiggers@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P194CA0002.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:10:553::33) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: cd55a508-4a38-4c7f-4345-08dde971441f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ttBsguoBxzGsx+jSlxnrBbQV3a5W56UB7xPZ/a+DoM+8lWkp7455Rl66lgu7?=
 =?us-ascii?Q?BAEr5FUyOfNNU9NCQPJLvNt+b7b0iCyzJ6SLlmJ6NSfS9Uzg6p1CBAXJtPCI?=
 =?us-ascii?Q?nBBxHDvKUH/fTGGsHEGDgwSUAUJliaqCz9Nthtxvs4IIxabm+PKubrn6Usw1?=
 =?us-ascii?Q?tQD/K99Evny3bMIFsoGevd3qeObYGbmYaXhlHvhyADJ//b8gxNOl44H3hzeQ?=
 =?us-ascii?Q?ZhYlexGGSzaO8KyKbIzYTJMSyvGbcDA64Oc3DumNJ7+zAmZn91T25TGkgeRg?=
 =?us-ascii?Q?ZuZA59dY5ydrNQpk4Pu/+tMVzTJDxUDhgbwvbgmNZRlMuggrv5Z4XXvhrSG2?=
 =?us-ascii?Q?xL1Tfgs7Gq/ZCy03Jonlc0fCKf+nqi8ROkzn/7lbZ8Kmvf7IHMIimbH62FqJ?=
 =?us-ascii?Q?WuSPc3ubcNjm6MZH5xvWNMBHBmAZr2E/mGSEMGJsLX/Yu7htxD4J/nQ2cGDG?=
 =?us-ascii?Q?ZOXYwJszPz0HaNZx/nDphFiqs2o/syUccn9/S7ACbQSydSVtjeuGgd9TWKbW?=
 =?us-ascii?Q?wWhElvw35PRCsoijI/pw37jVjMpBqMVn7G0yUwH/onuRZHqsV88W0XcRXeG3?=
 =?us-ascii?Q?5yt7zf25zxqLNI1Uzkb+k1HGPWnSinLbvXgQtVZRzn7WU34hPtPtTWMQQyFu?=
 =?us-ascii?Q?lRGlAVsJsjbLdezLb7OUhOjjgtFenlC+s6TetyPhAm5z7pv7W8rvOZRMP9Ts?=
 =?us-ascii?Q?P0+sdz6sAIrXGtN/s5EvSdMF6mG+ZBy/Ug1Dw+bCG/3+Tz8qUbntbnZVRat+?=
 =?us-ascii?Q?bHlR43nw3pZAGiH8X0MQa2rVMpwMcnhoD3GWkpMzhsKe8VCnc9ecLLMSB8aa?=
 =?us-ascii?Q?QiqkGKA46rgaZvU2u5hcTpVMjvIZS7pXbfzf4+1ZPpIXIn8GvOaISdwErC0C?=
 =?us-ascii?Q?StmdBQjWOKsopsOFbXcIKmm9LqyklqXDxSvGXXI1AYyRr5t9q+sko2VdDv70?=
 =?us-ascii?Q?0is67qg3/Q8TUP/97Hx61wkOvcbpzMfeeSSQIl95hb27Mqpfk1jeIB0UXzDy?=
 =?us-ascii?Q?qA+16R88Oj6dnpmvpK+AascEwPjKxITcy41d7X6iliwGgQpgiMIUXgPTdl5b?=
 =?us-ascii?Q?YoGScqvVJoU9/3LjDhjVS+CNsFSGutzkNVb07t7lDM9UTyGwH8qfDG9MjRj0?=
 =?us-ascii?Q?frHuxdtZfxd1hAW1XurfTEuYCkvJLZSgtOsCuWitm2algZ1rdJ0gqqyoaL/v?=
 =?us-ascii?Q?+ogx88L1XFh90yqPier5+kS4GFbuwHWG90lHB1hkTr6+p/PKm4NFWrhIY9Bg?=
 =?us-ascii?Q?i7eYaHG2GUrIFlxIe8dCvlCqflZq+wjUgQ0daQ7vLd7xR/RyqEYmCw7Dqy8G?=
 =?us-ascii?Q?zf/FClJUXFgvVKhN5+c9k7VudyAwpetwXQxIAKwVFuN9bVxV6r0Jzw0n6owh?=
 =?us-ascii?Q?gXc8mr8S0pEgkHd/fLDwZuXvjtsVcG1Gr76y60x559ykdonBynCWoFWeUTRC?=
 =?us-ascii?Q?RShDG290qCg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4UKWRqJt5WJv9Q2xjk3V9EjGrWmjV54WEKeBtA4FtsqRayUd0BdXVUYbphb?=
 =?us-ascii?Q?f3fWvebtbfqE45NAMe5oI2oFnDRJ9oWRPpWqUeZWDMWfB/WbCSZUnZL40R7w?=
 =?us-ascii?Q?Lj6HTTZcClR1vFdER2t+3jfOfbCBhwsK4ltvneUUHIg5HV4GeIblCIqWuGcC?=
 =?us-ascii?Q?5ouWWcgHLM7IsOyC+lUzWL5a+7vbK/mEsUL5p0pvIbyJxIFERVU+EfJbnORw?=
 =?us-ascii?Q?YpqrUyYdPyrrV7OxWPJCYYdcvwCzlenfjuU7Kwfxr5rRa8TlzQzen1jA6QzC?=
 =?us-ascii?Q?XPursKAQwinSvLTdogHJG+9dlLxzFgImtc1NWsH507hTlS1gLPMeKkYD4mQL?=
 =?us-ascii?Q?tYG0h4EPLxmWAMVAks8a6a5bxaXQTz0MZ5t4AlSTiuFc7v/L3CLqW7zSc/+4?=
 =?us-ascii?Q?7W8hRKO0/62Q9iDN57EOoMLggL4nu/IIkmgfinhx3qS5UZBkU/OivxLazL0J?=
 =?us-ascii?Q?EgdmmjJJups4NDyUUulN/EaUnCpFlWtvCwH77/1fktJh4BK3K7dUb90cRwEj?=
 =?us-ascii?Q?RjMaiEOQV+onKjsjKxXfBo1ZYXsQ/jbklMtmorOeuw913+WZTjZ6MMz3nV4b?=
 =?us-ascii?Q?N0MhaKkdiW2Ip/M7Qb2EYujjRKImJa1c1STY/k5l8kgB04Uddya14/l7UkLs?=
 =?us-ascii?Q?RfeNxDYVXLA9gCVuiD2Kpcs6smb0LDuw7kCVk2OXGectQZDpTH4PJIPfz45B?=
 =?us-ascii?Q?eLd17hvZKNA8bahHDbAbkiD0F775SBNw41gCXOd+9F73Dv/vWeuE7n0S3nJV?=
 =?us-ascii?Q?tmMTWUIWMxA/dPxs65H4EUCfflgDCN62bpdf2J/S6cm7wueHTuyOY12HEqcO?=
 =?us-ascii?Q?8XcmJ0EJ8t+/SDoTDLk+M4YN7tjcbvyK8pLu8XmbPNOmKmxNxfhyh5Hww4uu?=
 =?us-ascii?Q?FO8L+aS6Mb/6Mk8SkJHuCPl+ile5kyvVNh25sODmno3pQwE32QHS56zKeJkP?=
 =?us-ascii?Q?Cm0V7JfQd3KF5YqhQGKsks7Lg2sRovnVHXA+eJvMjL8XmZUavv10ocngAKkk?=
 =?us-ascii?Q?2R0DK8NISo5egPWFFl29u7m3c5291N7+YG65KcSl2SE+jLo+3LqrUNY9iQD9?=
 =?us-ascii?Q?x4gQ6nBu9Edht0zaj594Pisk08R2hpCHywAu4flM0S5xsRTvzkVIukG8jkyF?=
 =?us-ascii?Q?4KEGn3FnzHaDbliLhsWkyp7/5ffGs4owHghoua/dkMYcJMtIQyAPN9BiVySf?=
 =?us-ascii?Q?SRM3XYOQP4OBYUs239bM9IFPsDmMIwahLBOhtFr+l34MTev0FftvL1KTv4U5?=
 =?us-ascii?Q?pVK2pR7HWeR2mzUn2Tm9sujjPSRjjuY3Xh8hcWoINcOWNbPV3Xb4C77gKjjv?=
 =?us-ascii?Q?UknKyrYKa81E64UJ3lmmwt2I7mX4yzqeC2oYoxKv3P2a0BYRm8Ccuw9WqV9B?=
 =?us-ascii?Q?9ac2SH6IxJdrBDhvzdaJobrL5VoCNaFi6K1Ibog9elI6HfCkyvP40dkVoadD?=
 =?us-ascii?Q?wHtJjRARx6UGORssYk32OfS4lKQxmTNX5Ok9520PhAL86rQ2sr87BbHrOih/?=
 =?us-ascii?Q?pp/D/Cq0TBkJ66JdDsIicJJMiyyJJ2R1ww7T2IWhfMZYh4v4tIN/1CtUJUO0?=
 =?us-ascii?Q?Ve8zSisXpyTzUrqBmwvCoaDLpz9ec0iC5NZynTc9jIMq/VD3vjHW6uQcHs/t?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd55a508-4a38-4c7f-4345-08dde971441f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 16:04:44.1682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zok9ZIhT/DyaQR9suO4n3CZniz+2SY7BYHIakj3C7fuT+Y+eksQKwkdSx5vqa+mVCbG1z3h7fkaVoxmg7Qp/xjSXZ0+WfU7NMh184uogYe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7333
X-OriginatorOrg: intel.com

On Sun, Aug 31, 2025 at 01:54:57PM -0700, Eric Biggers wrote:
> Reimplementing the sha1, sha256, and sha512 crypto_shash algorithms on
> top of the library APIs caused the recently-added function
> crypto_shash_export_core() to no longer be supported.  Meanwhile, the
> QAT driver was updated to use crypto_shash_export_core().  But it's not
> actually necessary.  Instead, just do the HMAC key preparation using the
> library functions instead of crypto_shash.  This fixes the QAT driver
> and greatly simplifies the code.  Additional benefits include stronger
> typing, and improved performance due to reduced overhead.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
> Fixes: ccafe2821cfa ("crypto: qat - Use crypto_shash_export_core")
> Fixes: 8bc79ab67d78 ("crypto: sha1 - Wrap library and add HMAC support")
> Fixes: e0cd37169103 ("crypto: sha256 - Wrap library and add HMAC support")
> Fixes: 469acaa12502 ("crypto: sha512 - Replace sha512_generic with wrapper around SHA-512 library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
Thanks.

One NIT on the headline, for consistency with the other patches:
"crypto: qat -".

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
