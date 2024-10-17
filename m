Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B4F33997;
	Thu, 17 Oct 2024 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195709; cv=fail; b=dGWJSByGduDRVunoshu1ao/gT/Lkquxpj+m/UjtNpgPV5o+gJrqDd29yhlf0FHuRCYpg1c7JW0Y8n5v8IJNHTb8dTpeO9vca7VW3q3TaS6UfLJBSjfxODpICjl41O/DO++25o2x4YRexJV/LvElmFawrX6rCyiLClTnf/d+GWaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195709; c=relaxed/simple;
	bh=PJdZ6MAFeKqlf9/wkqj7ohvFhcz67BE34e49K/8nesY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hs5nI+nKN6rzyWZe/tsvAe02WdnldNKCo6d5X8+HQUQMeijR4nJDOWc4ibpOnyBJiWpfKO1Gp0QWXqsDzIVZQMZ4onSmfom5ycK/CAIFb4LagZWfh5Z3SU1U/UYO8G5I7Sf+pdkoHQRy4CG2VwE8Qu3x6rpxTWwJRmr36hCdwi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqD2K2EJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqD2K2EJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729195704; x=1760731704;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PJdZ6MAFeKqlf9/wkqj7ohvFhcz67BE34e49K/8nesY=;
  b=gqD2K2EJf5GqUoeOQsRpggtItYwDFlZzt6JsgItMkZ/hvcyX1lLrzNR6
   TAabz7ccSCqkVWK2uauZumfClX5j4AHSyUWESiwMlDVSDJ1z7j7VgrF0d
   8DeRKjIE+88u08QOTUt3h25CpQzuKy3GLr0TRCc4LjmHczSRxfWJSB5Ce
   vJhWzjNWhZT6hJG8Ckh3+c1n6466ngqOn1OdzMJ4BHjGOv4rTjjvOQ1FV
   VeY5/Y5Hm647Kd5+66weuBJG4gX5LAURzpxD+mxLqwK5ZmAek0RntWSot
   RlEo8/F87E4qTmLAKviwoLWv8YJ2TcL+L1un/AcNm/6/H79AFe6tGmmuy
   g==;
X-CSE-ConnectionGUID: Xt+I89mgQPaNrqW+rS4ITQ==
X-CSE-MsgGUID: TqlF25vgS76YM2fqnjSe2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28857860"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28857860"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 13:08:24 -0700
X-CSE-ConnectionGUID: uenyo32rQM284VyySjLUTQ==
X-CSE-MsgGUID: 1MCqi7ZhSquXtD9LvocWGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="83214726"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2024 13:08:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 13:08:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 13:08:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 17 Oct 2024 13:08:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 17 Oct 2024 13:08:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lh56LwspOMhnJ3pi9iFZrHcESIDIpql1I9bzZkzPg787jFN+GeMdLxo8Ag7iuu4x68zrAvOY7GH9k6UYlo1725K84Fd9uxzDKKzlTzBSSDzFQ2QFCgPL1SbUVIdZA3Ix1+BkYxZFs2KS4AHG6zKPy9cVmwzW5zP+jKvck96cB1Ri6iyqt7NB6NO4YHfxjItELpVHSWM7B6tIaRg4apjNhNNFu4vjZ/tOE9PqGaNQamhJYTE5w1JY4H7AOxg8i1MTWQgtZsOLrH5n3tfxCwQ8s81Ow8bfrh4M0jJTJolG92INo2D0k0fI+5ov8/F2tqHZny0D8KRlNYSxTMfyFpOZsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WI1u5PcQMawnx4P0mMkniX120R4MHu9K9f87PK27OXI=;
 b=tq7p9Tdh80sgJFdnnjao8mQ4qeUZGwg+vh2ykQbR57kPNZN/CsOGpT61XLZJqR3qGKlByQpxLR07wuYClNOzuqK/+yWO4ehe146Ti4QXdLFhtmRGZtBJeY26qrs2eQmq2RUXUlG5uq0kEZzqMiXcWvrrGeDTRqYFKxxfCZBiYOZ3w2Jlh/s/YMHQvaS+Lj3r+SbV86ei8uY+hV7PCI4xgs3xbPYS1crVRLm9NtNxRqABu8FLJap/wtQKQv642tlONt5JF3yTmpFUucKE4+6Onlx8UQmzp79kPID9yhm4c671H5MmRAQ7Lls+XAJpZWgFTQwiT4zgBYVEt+ashR+caQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MN0PR11MB5961.namprd11.prod.outlook.com (2603:10b6:208:381::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Thu, 17 Oct
 2024 20:08:17 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8069.016; Thu, 17 Oct 2024
 20:08:17 +0000
Date: Thu, 17 Oct 2024 21:08:11 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Constify struct pm_status_row
Message-ID: <ZxFuq6itT2KylMQg@gcabiddu-mobl.ger.corp.intel.com>
References: <ab26d264baec1f3233e832c0c2fa723e3be21a04.1728935687.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ab26d264baec1f3233e832c0c2fa723e3be21a04.1728935687.git.christophe.jaillet@wanadoo.fr>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: MI1P293CA0016.ITAP293.PROD.OUTLOOK.COM (2603:10a6:290:3::8)
 To CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MN0PR11MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c45e5bf-ea7b-4de1-0020-08dceee770a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?m6yktQOp8rk3qDOKdP+CY6TJxSx4lu+egWPhTUZxft2cZDA/AMZ8Qf158S0o?=
 =?us-ascii?Q?E3MCWLnRad5L8RbCYzK8L8vf7dhzpMv3AZMC20L7k6EXiVq1rLUw26vRscZl?=
 =?us-ascii?Q?32Rn2cwj3uCLDUYMcN558p8kEAiQ3mctG2zxM6oEn3wzB1M2hhmFlJWF9pwH?=
 =?us-ascii?Q?CwqRb/gbFMv/FkO1H+v8ZWwRbGryqlvByEDLn8UdlZI3fNnTzu7OtCb3vW1u?=
 =?us-ascii?Q?Aq3VCSfzr+IEsWWghsupmwtZK82SAQqUL7neF2xlYs37a4+8AM35bkVqrkl9?=
 =?us-ascii?Q?NWl421cagkqfn92NjJjoFUSdpkEheRV7t7FAeg3U7sxTbu6z+kfG9npW9Y9P?=
 =?us-ascii?Q?RcwuydvJBgTPPJI/nWFQBsDq+p+K2MFIC3FYGcxkx47J9JKGAcOTQhTiNOAo?=
 =?us-ascii?Q?0ruUkFbm0dWciy2RqIj+gPZEsGydoV+UilehVY+YpRjJKvbxNyKdy2Pe1uF4?=
 =?us-ascii?Q?dmQwkw78VMFGNda/Dv3Lt71ejY1IPkkL4QaK8giP5gsxNQcm0VKTurVyaNE6?=
 =?us-ascii?Q?M4TuQJ3MPPBa3h/cVxJDVnTtpZ62fu9rxxbqU6S8E9RijBv6Vk+gBYJLy65d?=
 =?us-ascii?Q?1mFnz5dN7pqAkZCQcqtRy6yLO2K5v+tFIOwZVOMp8nhArgBnI+uFd0JmJzqQ?=
 =?us-ascii?Q?5kBw+CzmAZU8rpYNGv5xO+mV3ccWrp4aoJwMET3btHfVvDHaaII7w3Nwp4vy?=
 =?us-ascii?Q?kMhO0Tp++mEJ4M/QfQK9eUsz7J+I3Z7VUonXCWoSsbvY3TBpdxn9Ne4/A5G8?=
 =?us-ascii?Q?eapl52zPvmI5OIt+vletfEY9jTjkFcetkLyC0nf0WnHsnbMBGcKf3g0f0qxb?=
 =?us-ascii?Q?EfuD/01KrLVo/4nHaGVjKvB+AQhcTLVwWr/0EsGfobjS6pWq3AKSr8WJ9heL?=
 =?us-ascii?Q?f2ERJ8KJoW5D11U3KkqRk2ssPAY1qQYwx4zzrYvuiTQCnBEpGHtlbXoG6Zy6?=
 =?us-ascii?Q?O0LEg2whJ0S2Zs6388bGcgvPlTx3NXR9bz4ZCWelwEkq8fMW1Bt8kdf1cM3w?=
 =?us-ascii?Q?b3NSYZL/BcWwV1nGoDTq7t1j7aV/YVZMrduaMbEnzSJLpgg12lLgCh85ed9Y?=
 =?us-ascii?Q?4ZzxQMyUBQU35J0TTu7OrRBMW6KME90PCibVNac4otp/3y3KTckWqF4qLKbM?=
 =?us-ascii?Q?jF+lhvMY+Kl0CldjoOVsDDkd2C1s2U1IyLq3ghKvq6tt+A27eGLb9OkdwOyy?=
 =?us-ascii?Q?SfS/B3E3oTkQpSBGHcHSpvDrmfOe1ger+vBwOLPwostKyy5IdbaMSknqaPbg?=
 =?us-ascii?Q?u41VDy2g90Heojky/yHHkaaLGKqdydhAyHzq1INJaWrB+CPrZQN60TGN5zcY?=
 =?us-ascii?Q?FQGwjG71mrTD/5elPSTi/zC+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iU3wk7yIDtgTBGPcxxviGf5EFMgN9sH1FByQOsk2T66OyqqgVyTqGr79wPdy?=
 =?us-ascii?Q?7ZBUZd2c8AwBXnH0R8cqEREyB9xyS/MWLhepKiv/nKPNzraOXE/qNxOPofS2?=
 =?us-ascii?Q?kZ38geixeRfQY1rtcrO3emaDAG6ja0DvzUGO6znZl0HuGkNSZr22ZhVTnv5G?=
 =?us-ascii?Q?OuGIC1ID5sZvmTfHrohMVsbjsgsi1HmTWck4LDnTu2/ork5+FyHTUoX/ojLX?=
 =?us-ascii?Q?WKgvR0l5qKrAPJQIBKU70scvgPZ3TEDtEcpLm/mnhXWe2quZ4pF4VhDyyg1Z?=
 =?us-ascii?Q?0ce8PmOdArnTtww8bleV3OwVqvGz5PzT6QuodQ5Biye0IFjDfui2QsWYym62?=
 =?us-ascii?Q?uNt4QQdeHEIsFuK4H4SJLWsfS8k5jFUK9A4tdZOCmge2ax3WuyFsiew5piTc?=
 =?us-ascii?Q?Rt3oLArENCxA6k9Ex/6FYyIlwbsBArlS9oSfIrluN7FAuZxEVbjedI6mABlQ?=
 =?us-ascii?Q?U3OMlmaX01yEeCJ6BmdG4j+yCiBctXeOMGBYIbR8dzJagzPHGBZM7u0R7wLR?=
 =?us-ascii?Q?kOma4GrjrbPZExA9yQ4nZEIqNfsQWROv9C+SYtGggSX0ynY3HAocn/X8aORY?=
 =?us-ascii?Q?glok5yHN2McQdwhMGjulqZisNaVmZ4JcppK/dVRRygBqAZM4T6FVCsLxH2TY?=
 =?us-ascii?Q?c3v73aA27AP7bl47o4aO2l8FLbs12jChELHSm30Y4Sa+fyRcXLnXZ4YPd6KX?=
 =?us-ascii?Q?tdZj1nGXXVvAmYQbnB77JhIAr1Z8d88Z1kRaOcMWTxA0cSR8xqjFQzs/N4wA?=
 =?us-ascii?Q?BZeQTZgRxLVflPevjlU2u3a/vzo+h7tyFgNhfBZ8MQsLESfopF5rjZf28FlR?=
 =?us-ascii?Q?vNXXq+P0ROFAYgv2f8s+d9h2Lx+Oc5kV5OhIE9XV3GtkS3ONh1fse48u2Dwt?=
 =?us-ascii?Q?V7i3JU21uHsbB8Wy3GEnPYZxqGtTH03NftC0NUdGgY6iqB4oZL1TyRXht8hi?=
 =?us-ascii?Q?fEriutnypsIG8t6fQFeP5P/OYh19LYoWVv7VC0/zrfVk/nGOQACIzKj8H8AZ?=
 =?us-ascii?Q?Ccp5ks37i82X2UDrpsGl8wrvdsKW8qZXEQyYnzL3Z+L5j29VXkHq0b2pyNUN?=
 =?us-ascii?Q?Uq15nF92jMRtnoUs7hZmDitFI2GXhHFTFceti/vanYXtoGUkzWzhkhonNNac?=
 =?us-ascii?Q?7nBB6XltDh5OnvJO7de5qJNs/Sgt0GMCtvPsUQcOyjwaj4IvBsFLT46BxHAY?=
 =?us-ascii?Q?KtD5jr3CkBHYxcqG98MTyQVnwjlu5CVLpglHBKrIB4iGP2LiaitRS5cEAtdo?=
 =?us-ascii?Q?XKJEHr22RWxZlGRAf+MqmkDHe4YxKAXpNfKdb/BBRq/6BFTZhLW+3QEC7zwZ?=
 =?us-ascii?Q?XZyfJgO7KZEhqix9FCv+fY9hFQSwdnATiOAjA1O9bp3hLoGlbo9G3uQ3Sy3t?=
 =?us-ascii?Q?Sj8SF+6cKRhCA/zvB8aSUN2ZGKs6uZkF0CoItGBXBwaShxGCQx4s0tCtGRxL?=
 =?us-ascii?Q?4ObD9va1MEHKUi6ZHuUff2nvo/cpgqO+hMR/62Q+hha3IoCpvdgNiZDFDynf?=
 =?us-ascii?Q?Bq7uAaWdXPiov7/sZLVoGlUKC0ONqwcLlnI/suKZ6pMRCB1zSv3wH/24xYnR?=
 =?us-ascii?Q?Nem5xuCEdNfE6OvxTl0yLZR8QehkOhCUardrJktwp/1ZWuj9wn+pOdpoLhkP?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c45e5bf-ea7b-4de1-0020-08dceee770a5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 20:08:17.5481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lQfwjuT2SUbjTPkrMWINEPL9J5EL0MmiwleseQY4GyGKu14iE+X29U4D/tuX3ba6q1bE/aocxg87v5gxyuYtSBVDe516Yh6QpsLlTFOga8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5961
X-OriginatorOrg: intel.com

On Mon, Oct 14, 2024 at 09:55:17PM +0200, Christophe JAILLET wrote:
> 'struct pm_status_row' are not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security.
> 
> Update the prototype of some functions accordingly.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>    4400	   1059	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o
> 
> After:
> =====
>    text	   data	    bss	    dec	    hex	filename
>    5216	    243	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Thanks,

-- 
Giovanni
