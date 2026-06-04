Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCEE3DE429;
	Thu,  4 Jun 2026 21:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780607626; cv=fail; b=t7E7LfcTzUv5+ggqilN4OLeFQCPkWRTOqiu+tpR7TkbPu7Fl5zbiuNpWQdSaJCW0QmnFi3tolylvj6sf3sQ5MeMB4EMqpC95Eczr+rDxPyT22nXBLDskmgg7oRucVNNfV7eHPUdGGby9m/HhI4KKjaUuUIPGQc824rdvqBp2JVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780607626; c=relaxed/simple;
	bh=U2xhobYtjQfndwJIL/tEgdBGNSBye8Gaha+DFRbSQf4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j5WmwQpWAIRxwPDUfAq429/SXaZSpppTNHv30SkUR0/lqepX/6TNtSCbwvHVh0V6sfpG7SviD8jFWNVwC55HKfHwdkzE6/nV6YmBmLbCvkijJ1sWyLLtozvOGag0NGpxRa/MRZac8zcyf8RWxu+ft/C/FBMnnQPwUW/VAjV8JsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwmIzGDK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwmIzGDK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780607623; x=1812143623;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U2xhobYtjQfndwJIL/tEgdBGNSBye8Gaha+DFRbSQf4=;
  b=bwmIzGDK855N5GC7YD1hfVjIrQE1R0br5QOejIxqEO5RSvUKZJphhVF7
   2vR28yPW3Kg3qJtOuv8s47pdroc2e/503nQh028UNzuNrLluZms+GSnsf
   wsgGYG8WX6aeqlvbCfqMGz8xirxqn3trGC0OkXiAeQawz0jyTKHmeZNkj
   kDpLlTm/6Iw9sbM+1CNn2EuooIJx8hSJ08m3NZQy0R2WmX3GSKVb1SpGI
   WC4v19Y1MaD4StdMguL8v+QJZT7bUWl9scut9grQvedB54dZ0239Q+Fiy
   GEkHm3hlFJxgwOFBtrolhyX4yXqn+Fg2j2xLCrjgHBO6HanCnlc4C/j4+
   w==;
X-CSE-ConnectionGUID: Ea0jT+rCRTiInx3Xd1SVmw==
X-CSE-MsgGUID: wTUZXp34QxqIBx9gO57eQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="98862936"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="98862936"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 14:13:42 -0700
X-CSE-ConnectionGUID: h2pszDENQzqe1i9LQHvPvw==
X-CSE-MsgGUID: i4tS9qKJT2KLXJeijHrikw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="243816494"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 14:13:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 14:13:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 14:13:42 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 14:13:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpmKXDahT+4HHRWgxQzLaLpqAKM4yoBDGV/U/oUsaBy1JZ6PZva0q20/GgWiHNc4zHd7cOxFaKo241sfIXGvtgVLis22Khw+A7GdfBqTfNXVrNn9WNo6/mBU6RteO+4F+mNAViMMVQyEE6Gfqm9K8ZUkqMZk50+KG0yb8vbPyG57sbjpx7ds4dBQ8M8AN5ohSZLmN4xMgQXKGzmNwGiGkUOyofwmMBHWtwAqqZC5zCwHxmisRm4nLG9llxEh8BAhMxDsd66BdUPwxDNNlDhY8dmjTW8kCOd6Kbyt/FhAbESli0tP6PAfkoEc/kPU4WC5xDXbHadiwjNFPbANIFf0og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L16u2mavfnugSbsXXpWJT9gypQK1X7jX7IqM3okQ7qk=;
 b=ZHXxzZ2xaY6dxzf+TNuAY4HGol8FA23yph6PiGdzbVp34v0XeLQI/mGZmrxkw3Q5Kg/R5HELsWUWbYn5sD4m+VvelEvnMZCmfJlM7pakFCvgcBQLB7c9Qacgmyq+HaMFeWUXXti93fDfNpbifq+d3TaIN50PRE6Nvs/26StooksEoYeCbE/ANxtqHKfchCWiryu2DqVyZjGWnAuPXzINdHvYF5xVKHl11Qp2mziXoBinWeNgnD8QK3mtCIQw9WUSTY59mea7BHewtUGRtzP8r3nsa6OTyh9NyUwZHvOm2YfFDoUy3pteh53uXWa/MGP1v8MK1uORJ/iD9gQWtcE56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 IA1PR11MB8247.namprd11.prod.outlook.com (2603:10b6:208:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 21:13:33 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 21:13:33 +0000
Date: Thu, 4 Jun 2026 22:12:58 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Tom Lendacky <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>, Weili Qian <qianweili@huawei.com>, Zhou Wang
	<wangzhou1@hisilicon.com>, Srujana Challa <schalla@marvell.com>, "Bharat
 Bhushan" <bbhushan2@marvell.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: use two-argument strscpy where destination size
 is known
Message-ID: <aiHqWlph5YGO/s+J@gcabiddu-mobl.ger.corp.intel.com>
References: <20260525103038.825690-4-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260525103038.825690-4-thorsten.blum@linux.dev>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::14) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|IA1PR11MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: f2674e6a-759b-40c6-3b94-08dec27e227c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: UoAW9SkbF3zLYh3nEXEZ93yHEQ9DOfjyv/we7xb8c/yAU6a3EjWSvI+r+fKsfyjZZZKR6UYVrSUlquft9njGfu4ia4DipwtgNAVRX/C7nwN3qOUh+qMgdSvU65zhth6eaxIiZ9CnvEyWIkjGjaXMSbe9siLiDN1CUXShQQtEzrxZUiogcX+ecgGfE7lgJCa7ciiBvUen1eLn9FI6Mrry6RYgVZsyCynSKwVBnl1KZKs1JbntN2k0jiuEnlWddz4GzJQgaFXVDqXOObcwEgJwkpjK/dEB4gvyu0svzKkoNmJWO6xGnP2Tk4GxiNk6flotVDQVpZdrQ9Nbh4oLVQrORWOSPhka6Ddwp/MzSRl9UQ0HpbkycS5RPbF3lX0xKo86IZaIKN1mfS5PZX/fYIFk7Fx0XLb3Ze/7uMghgT5mCx4EAY/4un0R4YIzErhv4iTrFRqk1rMEodayH7dXszcRe7E0oDGtMpNC0iiKq8puYB/67HQplJm1fV+ltqtn//38OiTI0r+TrkeK/DneagaKVnstGGPOX0RyNOurYOtOaPNCS8L7ScdxhVAQIz/5TodXYxIpBsR0u3p7nG3DhLIFQuLxiaSorxnq+Qn4vLtlpnrLtzDhxrNv3BbQV0tfdS5M3m+j0LIb36H7xCMGl73v3m+OCHwi/Zs/8J57u9K0S6mFLKkqucPVFz5O9L/OMr8w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4bj2XFUkAe0E21gH90XqEr1YILA3+qfJbSy8o+eZu7gX5w5BuquGb7wALhH?=
 =?us-ascii?Q?djn5gaRp5VUjmK7Hax2itd0H11fUC8rOKnlBjUoSbRI4LYRgk1PVTJ7X/ySu?=
 =?us-ascii?Q?dWFG7tSsLdbrm1pyqfwxR2QYTgo9GYHGKCA2CI6eKoKSZNaPSl7w3Ga4vfN6?=
 =?us-ascii?Q?yXVKhr0oaCx/+OoBuXjDPZyUsyt79NVrV13NRmAmwxG7c/l29/pe7e2Yr9y2?=
 =?us-ascii?Q?AyZv4+s9MxRTfOgmZrFjACQyI7BDu0C+6gwz1MCi2wocv/u9/JAyRUeIgOJy?=
 =?us-ascii?Q?heEUrP0vGDnrnXE9qqo3r0VK7shny8utNCf+JGZr4R6TZB87tJT5tKotpl8l?=
 =?us-ascii?Q?XhakNRROxMdjaAG6Fho/ew6eq1vamxoXdIuYdNcskqIPCP7LZtTVSlpb98/A?=
 =?us-ascii?Q?IqpI3yGwSoWnyjpxFDbUXRIw6T3iiRuJJ4+QS4USPCr+6VtjnxZVIAUJwrXn?=
 =?us-ascii?Q?gE84xwAIuwk5BLtjHbMlBvktQsJHMy9NlM0+6/AZSfUAB6JYee/p2LgGqvLk?=
 =?us-ascii?Q?QGMjbbSIZYgLcSSdOWtUQGXRu1gxx9EPDovh+/SvCKjLQ3V0EYQTBvkob1W9?=
 =?us-ascii?Q?NC7yD5isvmil+4BVf222b0ArDWuK+nsWiSrVM7PqObJP0Ygj9hnFMAcm4nDk?=
 =?us-ascii?Q?TAyhObAB25LFRj9b8BRityOsOgSO7dnF8PJFa9a+7EZV9L5XRiiOmWMiv53W?=
 =?us-ascii?Q?KWNQSkQc24B9Y+vxJ7Mnl7dR1d6OAUrZNZzPJ+P2SOshwAcYcXrvQEzEwxrZ?=
 =?us-ascii?Q?CcmjxcQoXvTryR2uYd4Kbe35pB4bIZIh6QWplrbzvDe/rjsmUKisxRz4Ti/4?=
 =?us-ascii?Q?jnq8zNdPWQa66G87gHlf7TqVowToMv/HrnOXEUL+PEIfEDMmM9tdBQS8hw0e?=
 =?us-ascii?Q?amr8KkgcQ/Hie9a2irGiuDLaP/1mk01dOL5wpOPQzeDa8VkZ1GYPXdQJZb9v?=
 =?us-ascii?Q?7DTGyBxgx3yceLMimmPbIjwUAebn5TgTl30ZgkRVyP0QJ3k2z4Hwz8eEs9jZ?=
 =?us-ascii?Q?fpiRdbGRaKoAV5agX0eSu5ityxLzdMHbQlnjd1jUWqlKe/9jjH09REV4DlLE?=
 =?us-ascii?Q?vrwvfcLjj69Pg1HJOOWBm345MFeOXeeSl7V3FYSNR8ldFDxQsdVxotJklWWT?=
 =?us-ascii?Q?ctKcZuU6evXORlidpLfP3cw4djHII//uFgGdyrxrB5VHchLCecCMx+sWDFEp?=
 =?us-ascii?Q?KqW+aOyHKF+6fZEj9hZRiFtTrnHlUPjetXpDhrDUphpMTCjca+QPxNZWPVmh?=
 =?us-ascii?Q?wgK0Bua72E7N3OQAI+YsGPGMttR7viU/zlvlRb4E3agcwvRdtfyoXzz8yWs0?=
 =?us-ascii?Q?1XpcsMVDXqGlB+zRz+jUOETip9DY0yHEYefRclx2pBDp3xID7Dxdl0Bi09Ld?=
 =?us-ascii?Q?j/rBVW3eC/ZsBDUo5YQ+ob60LMRicmU5xX+JYok7sR4eZC4bXPGh9G312i3t?=
 =?us-ascii?Q?iNnoAMSEvjD2yFn3KoxMM11hdFusljBdGUpP/CU5hhd5bTpaJjZnt5OHMxTd?=
 =?us-ascii?Q?Fl4AkjS1W+mFqwk/D0PbVELLudsrFJdUDVr8xP0vpJpVEe/5EDXLSQwGA91g?=
 =?us-ascii?Q?zv/YTI5rk5ONkvsUWmbdP0KtCaU6iF66jDV8JGzHUKknUocEvNJhrsGHRAFm?=
 =?us-ascii?Q?9iwmjnqtXs+K+64CgvGpBsZ8onQt5hN5gVcrISgGTGqVMmc5DU8VjoXlxyD6?=
 =?us-ascii?Q?Yal6mD737Yz5fkOIaKORVWTgJQp7rKkP2bPd9h9vXx7IWFYQrkU9+SuVRBDG?=
 =?us-ascii?Q?usoqhSr+f4NDPgU0qqT/rwcKGITf+VU=3D?=
X-Exchange-RoutingPolicyChecked: R9vHlU2NAnf8hwRbFgCWmSyvyceVIwtYxA4L3406uJ5BB2dFIu7W6qMGIlizr5g0ntTWQB5Zk/1iA6Sfnf9VDIOZxn2OaHUt69AjWW+E0MDWhsF03oX02pJ4w6Ue2Ox98KivoyB9JGP29Jmx+bT20xuq7BYzrMj8TMSEzaLhqKduq5IqWnY427SUFuiu7aWjnbhkjgzHWVPMJRGtKUD2ueXohS2DmTBQ/WlKXciCEDeu9+Uu1X9MSYyYRJZDV9XoNuau8qCfkXf2cIyKsMAdLjsAoH6NN4NYFJ86Qt3TcFQdFXr6/unJMe5bCFrRLs3RwikM49ntUifsZNe0FNBvpg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2674e6a-759b-40c6-3b94-08dec27e227c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 21:13:33.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfA9Q6OivrFzx+jYoOtgx2rogMkLE0SQbcRwbjt82h5Uu4fXc85PnTDLwGQkMGuQSYAZ5V0bDqJt/Qq+8pD6eM8Hey1dtY4CbmMjHfJiZo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8247
X-OriginatorOrg: intel.com

On Mon, May 25, 2026 at 12:30:41PM +0200, Thorsten Blum wrote:
> To simplify the code, drop explicit and hard-coded size arguments from
> strscpy() where the destination buffer has a fixed size and strscpy()
> can automatically determine it using sizeof().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/api.c                                             | 2 +-
>  crypto/crypto_user.c                                     | 9 ++++-----
>  crypto/hctr2.c                                           | 3 +--
>  crypto/lrw.c                                             | 2 +-
>  crypto/lskcipher.c                                       | 3 +--
>  crypto/xts.c                                             | 3 ++-
>  drivers/crypto/cavium/nitrox/nitrox_hal.c                | 3 ++-
>  drivers/crypto/ccp/ccp-crypto-sha.c                      | 2 +-
>  drivers/crypto/hisilicon/qm.c                            | 5 +----
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c            | 7 ++++---
>  drivers/crypto/intel/qat/qat_common/adf_cfg_services.c   | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c        | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c     | 3 ++-
>  .../crypto/intel/qat/qat_common/adf_transport_debug.c    | 3 ++-
>  drivers/crypto/intel/qat/qat_common/qat_compression.c    | 3 ++-
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c        | 6 +++---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c      | 4 ++--
>  17 files changed, 32 insertions(+), 31 deletions(-)

For the QAT driver:
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com> # QAT

Note that this needs to be re-generated as adf_ctl_drv.c has been
removed.

Regards,

-- 
Giovanni

> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 74e17d5049c9..040b7a965c2f 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -116,7 +116,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
>  	larval->alg.cra_priority = -1;
>  	larval->alg.cra_destroy = crypto_larval_destroy;
>  
> -	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
> +	strscpy(larval->alg.cra_name, name);
>  	init_completion(&larval->completion);
>  
>  	return larval;
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index e8b6ae75f31f..d3ccb507153b 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -11,6 +11,7 @@
>  #include <linux/cryptouser.h>
>  #include <linux/sched.h>
>  #include <linux/security.h>
> +#include <linux/string.h>
>  #include <net/netlink.h>
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
> @@ -87,11 +88,9 @@ static int crypto_report_one(struct crypto_alg *alg,
>  {
>  	memset(ualg, 0, sizeof(*ualg));
>  
> -	strscpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
> -	strscpy(ualg->cru_driver_name, alg->cra_driver_name,
> -		sizeof(ualg->cru_driver_name));
> -	strscpy(ualg->cru_module_name, module_name(alg->cra_module),
> -		sizeof(ualg->cru_module_name));
> +	strscpy(ualg->cru_name, alg->cra_name);
> +	strscpy(ualg->cru_driver_name, alg->cra_driver_name);
> +	strscpy(ualg->cru_module_name, module_name(alg->cra_module));
>  
>  	ualg->cru_type = 0;
>  	ualg->cru_mask = 0;
> diff --git a/crypto/hctr2.c b/crypto/hctr2.c
> index ad5edf9366ac..cfc2343bcc1c 100644
> --- a/crypto/hctr2.c
> +++ b/crypto/hctr2.c
> @@ -354,8 +354,7 @@ static int hctr2_create_common(struct crypto_template *tmpl, struct rtattr **tb,
>  	err = -EINVAL;
>  	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
>  		goto err_free_inst;
> -	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5,
> -		      sizeof(blockcipher_name));
> +	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5);
>  	if (len < 1)
>  		goto err_free_inst;
>  	if (blockcipher_name[len - 1] != ')')
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index aa31ab03a597..e306e85d7ced 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -359,7 +359,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	if (!memcmp(cipher_name, "ecb(", 4)) {
>  		int len;
>  
> -		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> +		len = strscpy(ecb_name, cipher_name + 4);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> index e4328df6e26c..d7ec215e2b3a 100644
> --- a/crypto/lskcipher.c
> +++ b/crypto/lskcipher.c
> @@ -528,8 +528,7 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
>  		int len;
>  
>  		err = -EINVAL;
> -		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4],
> -			      sizeof(ecb_name));
> +		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4]);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/crypto/xts.c b/crypto/xts.c
> index ad97c8091582..1dc948745444 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  
>  #include <crypto/xts.h>
>  #include <crypto/b128ops.h>
> @@ -400,7 +401,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	if (!memcmp(cipher_name, "ecb(", 4)) {
>  		int len;
>  
> -		len = strscpy(name, cipher_name + 4, sizeof(name));
> +		len = strscpy(name, cipher_name + 4);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
> index 1b5abdb6cc5e..e36c1741bb78 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/delay.h>
> +#include <linux/string.h>
>  
>  #include "nitrox_dev.h"
>  #include "nitrox_csr.h"
> @@ -647,7 +648,7 @@ void nitrox_get_hwinfo(struct nitrox_device *ndev)
>  		 ndev->hw.revision_id);
>  
>  	/* copy partname */
> -	strscpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
> +	strscpy(ndev->hw.partname, name);
>  }
>  
>  void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
> index 85058a89f35b..ff9bb253dbb2 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -426,7 +426,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
>  	*ccp_alg = *base_alg;
>  	INIT_LIST_HEAD(&ccp_alg->entry);
>  
> -	strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
> +	strscpy(ccp_alg->child_alg, def->name);
>  
>  	alg = &ccp_alg->alg;
>  	alg->setkey = ccp_sha_setkey;
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 3ca47e2a9719..0c8cc0d7a82a 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -2870,11 +2870,8 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
>  		.flags = UACCE_DEV_SVA,
>  		.ops = &uacce_qm_ops,
>  	};
> -	int ret;
>  
> -	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
> -		      sizeof(interface.name));
> -	if (ret < 0)
> +	if (strscpy(interface.name, dev_driver_string(&pdev->dev)) < 0)
>  		return -ENAMETOOLONG;
>  
>  	uacce = uacce_alloc(&pdev->dev, &interface);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> index c202209f17d5..24c2618af68d 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2014 - 2020 Intel Corporation */
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/list.h>
>  #include <linux/seq_file.h>
>  #include "adf_accel_devices.h"
> @@ -294,13 +295,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
>  		return -ENOMEM;
>  
>  	INIT_LIST_HEAD(&key_val->list);
> -	strscpy(key_val->key, key, sizeof(key_val->key));
> +	strscpy(key_val->key, key);
>  
>  	if (type == ADF_DEC) {
>  		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
>  			 "%ld", (*((long *)val)));
>  	} else if (type == ADF_STR) {
> -		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
> +		strscpy(key_val->val, (char *)val);
>  	} else if (type == ADF_HEX) {
>  		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
>  			 "0x%lx", (unsigned long)val);
> @@ -360,7 +361,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
>  	if (!sec)
>  		return -ENOMEM;
>  
> -	strscpy(sec->name, name, sizeof(sec->name));
> +	strscpy(sec->name, name);
>  	INIT_LIST_HEAD(&sec->param_head);
>  	down_write(&cfg->lock);
>  	list_add_tail(&sec->list, &cfg->sec_list);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> index 7d00bcb41ce7..11cba347d12d 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> @@ -60,7 +60,7 @@ static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const cha
>  	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
>  		return -EINVAL;
>  
> -	strscpy(services, buf, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
> +	strscpy(services, buf);
>  	substr = services;
>  
>  	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> index c2e6f0cb7480..ae10b91da5ba 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> @@ -5,6 +5,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/fs.h>
>  #include <linux/bitops.h>
>  #include <linux/pci.h>
> @@ -350,7 +351,7 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
>  	dev_info.num_logical_accel = hw_data->num_logical_accel;
>  	dev_info.banks_per_accel = hw_data->num_banks
>  					/ hw_data->num_logical_accel;
> -	strscpy(dev_info.name, hw_data->dev_class->name, sizeof(dev_info.name));
> +	strscpy(dev_info.name, hw_data->dev_class->name);
>  	dev_info.instance_id = hw_data->instance_id;
>  	dev_info.type = hw_data->dev_class->type;
>  	dev_info.bus = accel_to_pci_dev(accel_dev)->bus->number;
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> index f9017e03ec0f..32aeb795cc03 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2024 Intel Corporation */
>  
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/types.h>
>  #include "adf_mstate_mgr.h"
>  
> @@ -158,7 +159,7 @@ static struct adf_mstate_sect_h *adf_mstate_sect_add_header(struct adf_mstate_mg
>  		return NULL;
>  	}
>  
> -	strscpy(sect->id, id, sizeof(sect->id));
> +	strscpy(sect->id, id);
>  	sect->size = 0;
>  	sect->sub_sects = 0;
>  	mgr->state += sizeof(*sect);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> index a8f853516a3f..fc5d88a2bb17 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2014 - 2020 Intel Corporation */
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/seq_file.h>
>  #include "adf_accel_devices.h"
>  #include "adf_transport_internal.h"
> @@ -103,7 +104,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
>  	if (!ring_debug)
>  		return -ENOMEM;
>  
> -	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
> +	strscpy(ring_debug->ring_name, name);
>  	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
>  		 ring->ring_number);
>  
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
> index 1424d7a9bcd3..8129ad0c32d8 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2022 Intel Corporation */
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include "adf_accel_devices.h"
>  #include "adf_common_drv.h"
>  #include "adf_transport.h"
> @@ -144,7 +145,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
>  	int i;
>  
>  	INIT_LIST_HEAD(&accel_dev->compression_list);
> -	strscpy(key, ADF_NUM_DC, sizeof(key));
> +	strscpy(key, ADF_NUM_DC);
>  	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> index e0f38d32bc93..5c3636080757 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> @@ -99,7 +99,7 @@ static int dev_supports_eng_type(struct otx_cpt_eng_grps *eng_grps,
>  static void set_ucode_filename(struct otx_cpt_ucode *ucode,
>  			       const char *filename)
>  {
> -	strscpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
> +	strscpy(ucode->filename, filename);
>  }
>  
>  static char *get_eng_type_str(int eng_type)
> @@ -140,7 +140,7 @@ static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
>  	u32 i, val = 0;
>  	u8 nn;
>  
> -	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
> +	strscpy(tmp_ver_str, ucode_hdr->ver_str);
>  	for (i = 0; i < strlen(tmp_ver_str); i++)
>  		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
>  
> @@ -1331,7 +1331,7 @@ static ssize_t ucode_load_store(struct device *dev,
>  
>  	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
>  	err_msg = "Invalid engine group format";
> -	strscpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
> +	strscpy(tmp_buf, buf);
>  	start = tmp_buf;
>  
>  	has_se = has_ie = has_ae = false;
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> index 9b0887d7e62c..465f00e74623 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> @@ -74,7 +74,7 @@ static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
>  static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
>  			       const char *filename)
>  {
> -	strscpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
> +	strscpy(ucode->filename, filename);
>  }
>  
>  static char *get_eng_type_str(int eng_type)
> @@ -130,7 +130,7 @@ static int get_ucode_type(struct device *dev,
>  	int i, val = 0;
>  	u8 nn;
>  
> -	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
> +	strscpy(tmp_ver_str, ucode_hdr->ver_str);
>  	for (i = 0; i < strlen(tmp_ver_str); i++)
>  		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
>  
