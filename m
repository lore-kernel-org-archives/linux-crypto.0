Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5458B3EAC77;
	Tue, 24 Mar 2026 12:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774355673; cv=fail; b=M52/3AMojphA6YhPVofnOOnWqiSHi9qvlsTgOH6WVkevtZXt5ax8c7Z0CzWTOk8Eup9hatH3ZLS9dP2ljjhzJm/l+dVeTOnW4IwH0vxlk4Sh6tVFfmBEJZcADg28PMCdh/SWkFrF/ChMrxgCdM9CCOe+eJhIbSOfI3eNWkyGPXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774355673; c=relaxed/simple;
	bh=k0q3KoRX6QvEPhr/N5TR/SEfY8AxiE6oxULFByPEWoA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WLJdxjkZCbpWKO2UQgR/2E+qVrY91bIQyA6tgPJjZ/Y76czHwzmrHqCBuTxscgVB4bY3NuWA0CSOHFdXdt06v1T+ifMhk+OLLFe5VITCQjDbBjEKiBVSAGwQLG//dAA5/zjs3uFd3E1Vrj94O8ftyBvP7ZZjlxQt0vOyxCTAi3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l8bft4Mp; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l8bft4Mp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774355673; x=1805891673;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k0q3KoRX6QvEPhr/N5TR/SEfY8AxiE6oxULFByPEWoA=;
  b=l8bft4Mpne6Wbl0DN9q8b0WfMX1wWj/ZsaXPdYo2XCiaNOS9qkNB9YTM
   208tNLuAx8AK3luhO33ROl97k6FI8VvCFZWGD7Wc3YSxbSA0kado2Z4tm
   0pe3Js7Ku4pEiNStkb34VXEs8q2/VAlJdKLSMIpxkpL56E5xbLkrVtzNL
   yW8zwFNJ/ghrl7cSMMe1fENZcotlLpBs7+vv0mhKuB0jI47Jr7ZblF37g
   nahSFXXVwzRHmy7DA/hrMlSLrNClcOKhgKt/f94eTJ1kqwqrXk32QaC4v
   5M5O0yVsYRnftdYuDjSPuTNNveJIBCLE8mqFq0sGXw4wSFadhumAIdzuW
   g==;
X-CSE-ConnectionGUID: k0mAKAnsTMeJGnyPRGbjFA==
X-CSE-MsgGUID: 6FDSNBxoQvyWrkOUxKpwfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="92945124"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="92945124"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 05:34:32 -0700
X-CSE-ConnectionGUID: X+azofy5Tau/4mhU2L23Bg==
X-CSE-MsgGUID: WN8F3h56SvmeJjCfGCBzWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="228818524"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 05:34:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 05:34:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 05:34:31 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 05:34:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxrTNGgTk2k+RQKsveyBHvAuUcDEntaZ9ogMTLamVu8BwWmeX+TWGj+scKmaXdmpP9h1BqAy0PV2IWJup2wdnMsD4PMN75oHChrlTNb3yaILcyA+LqAMryJYhkSvjuoBT04yMdi6VKZmYsq+jg4+qXbUhgrGDdRmrgQFTZOOZumXF8CtAzyfa42DuyuVNL/lYG8ZnR4hFzP0cNUUTqPXqcmx6qe61I2i5qw0OQ4c+N7xOdAIrJyPWVMVXwdBfRhQd19z9IKBYQeAuGe9mHuhl/gP6RpRPN18fsJ0ZH1LXODQ4Xn5B3B0WHNeydu1MsFSRCsAy+KsCJr2P9NznO9wtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHKbvJlYJHet0g61UiPBt9ag9eJpHpH7CJD1CWwTteg=;
 b=PdiOZM6wxw0s42wS8ecQUUkFFWNB27ZMgXhH5JdKb9TjP85KBGKta1DE7QpST5bDQ+c67W6SzSnOwZ4ufXRG/oG1RT2zc1kP7mjngd53WsArN6MtcVc7R3pCF9dG5mTHk+yDsjmt60AG6QnnQ0omcRea8o5KVSLRdQ6sq3hsjJJs1d9E0doX06QPV7a/MgVVxGII7snpsj7WwWC/V3uOGDoOTSVa8fvB9pJdptNl5QHF4fIX+SH0ZSKJGvx7FCtL5kU30505prtALyvjk50aHTOjwc4pKD+4g7bbOtzDBxDUK3J1pIgvuDHyVY5b47UprTWLg7yTnbCHg47sbEoM1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 SJ0PR11MB6696.namprd11.prod.outlook.com (2603:10b6:a03:44f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 12:34:22 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 12:34:22 +0000
Date: Tue, 24 Mar 2026 12:34:14 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Atharv Dubey <atharvd440@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: qat - replace scnprintf() with sysfs_emit()
Message-ID: <acKExvXz111N1zNt@gcabiddu-mobl.ger.corp.intel.com>
References: <20260321-sysfs-v2-1-27ad91b89910@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260321-sysfs-v2-1-27ad91b89910@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0032.eurprd04.prod.outlook.com
 (2603:10a6:10:234::7) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|SJ0PR11MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 356d990c-66f0-4d58-7982-08de89a1ad3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: 8B8+tq1KZnSs/D+iP7odFnMJYyHl+nUdwsynZL5YJe3B4tuWv+1FM0usjlzorpAE9s3IYOklYSm9oLeiOMIqaVQgHCU5u1gnjf9sW13orwC83hIqzI/3iU+DLL/RMtw5VZRNRpsDNFWFRq81efAw3CBIGVY6gRSWbuY1PwOXDeXrHFnv4vPd3Ld92B4kz2CRi7tk1pi+H4pwWEzOq0GESRM8khxI5/+cw0Di82muHLotBgNSc21+pZ5A3Jx3qFXVoPX/jDeTWplciPWsxDX1OsoEB6Fp0CxQPk7tIDAgThrIJ9Nnz8rxgY1Pfxl82b8TqsbW+Se12DxxdbHtDachP/fyjyr6t0Vh+5ERxpq7pEoIq1KvJ78qftMNH46okvAmTOUlFQkQGRe4fIoGyD3w/GkRZURl3swGx0fCp7J4io1stTMGBK8vHuS/+nEPQYZCsZGUWy8QSSDTV7t1w+/gVffLmv5nX/9cihyoKGvDlR0zOf+ZbXUr3nSHNewW5V3X9z9q3oGg7j50T98PLqValNGFK1Pl48mGhxkvvdZDoa1oSwckuQOnW5ic4EgZq04mZqUoiaRqT4rm+QW9s+mT4ktjUlX8esr+9qr5Ja8Pg1tS2Hji6VT+6GbQ0AbVy/5cYb7QPlENLX2CqvRSEkRQvg6NmUdM4kE1yfB6UrBhuqZvMn9uxYYJablvVavN7JtJLCORajfjTKYBORrUTzold50psZ3ZexOSUDtk9AoM/8Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AoxeFIR9f4iajO4uTlSx1H/ODhUkc1KTo1JbISzOg+Gn+MmeAIVQjcPUAbnw?=
 =?us-ascii?Q?DZjifvn72/TYYXHOnaO12Ckm/12ZWVmn7tbEulRIwdo2na2RsvBP8zCTZ2y0?=
 =?us-ascii?Q?sMcXAHEnybhS/V7pLXou/6ESiJbzbLntqGqE7tfh0hD0o8+HWXK2vGr0TtSU?=
 =?us-ascii?Q?7L46glxHbqoO5WbjMO13Z+XrxKEkJJHm/7/ZQtO/DOz089jBHJHDCvKkrqAK?=
 =?us-ascii?Q?607ONWWjMRvZ/HadgM4ECWINXR4JwA49ENykT97halaZiBoWr6C4u1K5CY9z?=
 =?us-ascii?Q?oo2LYceBjDArKFhJrM86odighFeRULKhGjaJWITivDG2L7qZFr25NEKtS0jo?=
 =?us-ascii?Q?3LyBFIyJitr/OivNnExKAmLKzRiijh1An1NMkNTQwv8kC0rbohYL0f78VT3d?=
 =?us-ascii?Q?ciXvgjhF/mS5zGY5ehOfvrPhuYDzHklIg097mfGTppH2xwSUStZXVPK848q4?=
 =?us-ascii?Q?iYZCa0wtudihFm1JJpwfATpks9BuK5ax4KvTWXdD0E6RRmwF0+PoeC92B2yv?=
 =?us-ascii?Q?IFa4F8oC5sU4yHIdgWS9pHOhcmcTvl2oblVrlilCexRJKQn1KYFYCpJRCIsy?=
 =?us-ascii?Q?eoyL58L2Knjm320TWI2MAOsNX/VAW0devPmwAmgNCxeGjD7sAI/urd7F7Ndg?=
 =?us-ascii?Q?907l8VKdsxjCLu9aw1Ur2sJ5tL51y5ABGOKJmD0sAKRWLohLcx3pTBT+K7QP?=
 =?us-ascii?Q?W15RcseAIaDCum3d8WNlSeDxQ34P/DJdoofZHiLFTkc7tKjIbpl9r68s5SO2?=
 =?us-ascii?Q?3HdB7ixaI+wK3YINhYyrXnsuvWo1akz19JsC3x3D0i9mEwDnGXOMl/x7GVU2?=
 =?us-ascii?Q?maxZEVa66+l+Olt+8Cd9hX7/I62tf+tjyeRVO8vjK22WDUyTD1o0CMaXEb95?=
 =?us-ascii?Q?m5kJL0XbidWzslGutcm7Uom9czxtCgw+VJuGe7FbfZZbK/NVyV8tourwQMMb?=
 =?us-ascii?Q?cXKKIWrweF4dIxS+8Hr8oLlsAw4fAChRgWlkPHNU5de1fVsz1Vxu5yu9Q4ZX?=
 =?us-ascii?Q?Z3gMhgSbZbNVrGOFlwoN5I1fBoCBjI0ORNL1rLdlM7IG9P35Es4LA4Up3BRX?=
 =?us-ascii?Q?/KNLQq8eHWxMWeYp+TzI31G189tnT+hhiuH10uhWnPK3GxCmxgDjC+WujIip?=
 =?us-ascii?Q?FW9yuK+TGWty3lwjqkHin4k/tIdzxZtLXVEnRvquJ9M5XRUTMHdTSHjDIlZa?=
 =?us-ascii?Q?AEpJuTkKJidukk1AFhfIIeXFAxuLfJ+vtnaTewKzb4ND1tm3cPnt0nuxmW1M?=
 =?us-ascii?Q?6QG6So8ZBx8HFIuBvI7TyimYFyVAftJKA9/rvK74/yOPkWwxNeOvl2F4o83D?=
 =?us-ascii?Q?to/ripKkSHZbEdFdTXpjLlH9uLERDduDL5miglFypvOVObNK6+4Y3PP1ti9F?=
 =?us-ascii?Q?CwX7ThU0PEHwkJ3zeSkkxJGshw/1+Hse56YysnwsUQSXnFf5xOAyxVIq8zlk?=
 =?us-ascii?Q?rCt75KsxQ1VyrrTeDHth2qVcr8IS/8xrV0VGxBza0doG3MPniw4GpY3eUZL5?=
 =?us-ascii?Q?uirv8ENi6Ib6Fmt+pyFmLbjkAn7R6LW1RIxPN3P3UICbhGEjS8RN5rdUhXBw?=
 =?us-ascii?Q?wdO79Aq3oLwHuEm2El6g1T7wpgikqeFTv+XlFEJV611pI02Tima9dBLB3zQc?=
 =?us-ascii?Q?BOxjMxrWWqZmRrPNbAn5csLkxrGTm5+7a9v+ItrKiFRMp35dSfftrEi/+qVG?=
 =?us-ascii?Q?GB9eMBAeTh4y6khjxHH7y+RW/ivQh+XK85Uejrtt9im7KzgazdD8+z7qAO8v?=
 =?us-ascii?Q?njfKoEw+dH0x8eD8/V4DP3fLoTeRqcI=3D?=
X-Exchange-RoutingPolicyChecked: uPlIlYD/JTT5MYO27VuA0fJba1FIjx5RM6Ldg/8lwPiLoZF5oOb1B2xSwiQ4SZhWiAfKM+Uvv34gGJoFN1ZJvt7OuAozHgc4oCvVlOIfyX//RZigAGANPj2MzbecAsiT9ptmSNkmhPkzjiFW+yZmy5stqFSleC2h99+37X9K4G+M4v83AheDjgmKOE8bwpQJibis4ymSFEtXC45VNbGO+g1MkcewojkZpmiSUeITDj1VIWXW7nHtesAA8fNw6dCRxOhWOA23NwjN9bWSE5WFj277IR/tHal/+XTgqMsBISWWTeD3uYL5gjdKmbLCGJQP+UXn8y3xiRHVRytc0lvOww==
X-MS-Exchange-CrossTenant-Network-Message-Id: 356d990c-66f0-4d58-7982-08de89a1ad3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 12:34:22.3955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtzCJyUSWKws7+KZM8afqBRjmrmxXutK5ELpuFTHzaE7J2PL9bXmZk3cjM5Dl43tBUndZcawZ3pd1we/CxxwqqpJP9N+DOzJegvhrnbWumg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6696
X-OriginatorOrg: intel.com

On Sat, Mar 21, 2026 at 10:17:45AM +0530, Atharv Dubey wrote:
> Replace 3 sysfs functions in the Intel Qat Driver
> to use sysfs_emit() instead of scnprintf().
> 
> - erros_correctable_show(): Replace scnprint() with sysfs_emit()
/s/erros/errors

/s/scnprint/scnprintf/g

> - errors_nonfatal_show(): Replace scnprint() with sysfs_emit()
> - errors_fatal_show(): Replace scnprint() with sysfs_emit()

...

>  static ssize_t errors_fatal_show(struct device *dev,
> @@ -50,7 +50,7 @@ static ssize_t errors_fatal_show(struct device *dev,
>  		return -EINVAL;
>  
>  	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
> -	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
> +	return sysfs_emit(buf,  "%ld\n", counter);
Remove spurious double space after "buf,".

Anyway, I just noticed that counter is declared as `unsigned long` and
scnprintf() is using %d.
As ADF_RAS_ERR_CTR_READ() expands to atomic_read() which returns an int,
I'm going to convert `unsigned long counter` in an interger.

I'm going to send a fix for the above and your patch on top (with fixes)
in a small series. No action required for you. :-)

Thanks,

-- 
Giovanni
