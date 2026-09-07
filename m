Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6B503BC0
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795010; cv=fail; b=nO06QrR9FOouc62sZ+a+d4ZGHdUakSpgceK8aNqYU6cSvtuL8gKbkL678yrTJ26uGex3a5fWOcN+fYtrI9Cwin5rFn8u/A5dI3pyQUqCiHhnVDoWknyBnbuvuQnT9cneuOMAEHVfK6K1pMAlNOQONZMVwGjKzY3ngco0Eri+5Vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795010; c=relaxed/simple;
	bh=4sPrkwDghNSnzlRBU9K8wl0PVeq8W5Ywnsp9f+n0Jrk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WOSr/4qapnGmd/G5KL0JrdlcPa65fYjv87O+KRipAEtK+1Rqv8RlXvQbNJPGwzIv18W7hQpEHcQ/P2n0iLHkErmf2fCyj3sWcDOL1dzML8fnaWrs1YVaOGKCahgC0A30d4UY960yrws4kOdGIPwdZ35wJB/wlelvM9QEGe+TBm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HT7r3tBO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HT7r3tBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788795007; x=1820331007;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4sPrkwDghNSnzlRBU9K8wl0PVeq8W5Ywnsp9f+n0Jrk=;
  b=HT7r3tBOOMaTmUIa0zN9qOCJxeOnrzloeNfsW+Fb7nbA9RogIqhykXaW
   ih5MoAXkbLQB+2w+7W3dBiXqVGsMwkDVZPf4Ymw429bS/aZbgLJTF3UdZ
   1KU3OhFItaCiXSkRVAcuSp4kBnjPQxN9Rn/HgHXbrCQGrGlNAbLbQsq8U
   7dPWCpVR+BcGz3JZYxb+9IAONysx6fTQ3bAic+lw5/hJNzv/LNmY6y+CA
   r8S5U28QJxGBWNrW0n3KsuLreS/sLNH+l+4kimMjPnXYOnqti07JiXvKA
   a+rkYY1pJ5mfVgCZNCJvZyQQI5mVZpCaFZ7VinNc+gGr7W6wZSZ4kosAC
   Q==;
X-CSE-ConnectionGUID: ze5dct1fRQmhv/3ufMno/Q==
X-CSE-MsgGUID: 1vOan1azQQ6m08zhnzZVCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99857718"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="99857718"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 08:30:06 -0700
X-CSE-ConnectionGUID: m4mXwN6aR6WN8DwvmHASFA==
X-CSE-MsgGUID: +HHRRNKAQhSebEsuk4+E9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="274251389"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 08:30:07 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 7 Sep 2026 08:30:05 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 7 Sep 2026 08:30:05 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.24)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 7 Sep 2026 08:30:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qX6/psIoFYKLX3kd/3fo+1wTz74klEF+krRsW1+lq1OyFkhVKAeHQ7Ta5AHTfzE2gNV9Tm10qL1BnpWITOYAa3wt0d8oEBc5TkCW/ekymVyjXk0lOcApBvgzOioyJErB1PQ/ugHorUZYlfMGPLmxhMPlFKE1epbF98BVXkg1onXjHOWQRMjJYjAYX8Kfun/Fp92y1MvI0PWMddp4xLVq6VMSq6q+sS5V82si7vGEzQvXt5cNJuoJY8xLpO3Z+mJeQugKirhsPoopHq0v3wEUErmVTHmgRA9DZrlvEPzamev0w16JQ3dVnEHQWMYyFU2rZx3s7LQYHfIwsSUyBaq+UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNL2+svyNVdZxJJktn2ul5x1CAVJ9x+IAwx8uMXCYzU=;
 b=SYHkY28wGHQgl8rG0nD2cvD7eBW05q61/LfSkroQO3y4oR/gFtIB9Ys9lW74qkmiNM7v1AyYS1x0ouaOi6MoHtgh+ldoJWk4TbkyezF+ACrlWKuOmJHcE5lJ2el0SCT9JN4TTMec9havtMVJZYFFJyse3MJN58/zav/5XRTBu+nZzcS2yF/1hu9QQQ/+pQzhw0SaAnb3EUqXVv2vd7mGQx79gme9viTxok6kr7t4dGngyjsnWuy/eou+NFW6iwNxym+ls6l9A+yckov5ggSCR1j9VxEHWcCwPR78L6Kt2/ZHy+XVNDWDa/5LvZ/3r3R73mTpWdixH+iU6hH79C68FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7960.namprd11.prod.outlook.com (2603:10b6:8:fe::22) by
 IA3PR11MB8987.namprd11.prod.outlook.com (2603:10b6:208:574::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:30:01 +0000
Received: from DS0PR11MB7960.namprd11.prod.outlook.com
 ([fe80::db04:2d0e:9ecd:e9c4]) by DS0PR11MB7960.namprd11.prod.outlook.com
 ([fe80::db04:2d0e:9ecd:e9c4%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:30:01 +0000
Date: Mon, 7 Sep 2026 16:29:56 +0100
From: Ahsan Atta <ahsan.atta@intel.com>
To: Thomas Huth <thuth@redhat.com>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - fix active_devs leak on crypto alg
 registration failure
Message-ID: <ap7YdIh7r9JtjYPu@soc-PF5467PW.clients.intel.com>
References: <20260902101216.1226292-1-ahsan.atta@intel.com>
 <2cd6e3c2-bd01-47df-b58c-f1f207f856c6@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2cd6e3c2-bd01-47df-b58c-f1f207f856c6@redhat.com>
X-ClientProxiedBy: DB9PR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::14) To DS0PR11MB7960.namprd11.prod.outlook.com
 (2603:10b6:8:fe::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7960:EE_|IA3PR11MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 01b08de5-2b81-40fa-fb1c-08df0cf4e1f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|1800799024|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: f/zQI+W/iMdTRL4JUF6nDaIlgaZN/zgiyNtooVdcZDJhf9uv7r3tcIiW4QxmYMB1PcAV/oc9W8cY0Nq5N2HCTGEAd1goV6hudB9dSff6s/pUVY1l9hfi/K+vsXPCqIT5D8g7SLRdr3JaEQPe61SCQq1yAbFslgl+p5uW2i2sZRcv4cNW2LIASQUJMmM1XUjZxwpnDf+Wv/BWefY2ci5WEyoetyIEO7jBd3UOPSmSIhxH/jdUD2Rc5UUZfrUWnX8gYKVWiSbJ0JUBoDHsFAzY6/7sdUmQwIVWHm9kmgk/UoZ7/uKtuRhdqPCeaGqS6coAebzfh2iTxjKRrWCbASfPynTGx6LfHaCbOXKN19/mxEmgZyJr9TXiTqKDcUxgJMBbqmwShtvd3efaJWo7ioiPQjGY018/oS/J/B1tZDu5pfc10OWGT10YU127jrIP2O/2BpQF5vej+dd3VnR5UG/fg4otBkCVH116rhwzH7WnSZaBD2qfIRfFk6zcuWdE7cE4KsvNUCXvFNAKddJNwwZ2AOfl5oi52maaliVMqRp9opairROzjtRKkIvEXyA7VBEO+KjJolg8NjOLCJaIBW/YC6ttWmMYhww1vC8lr8oJazmJMF2iEifhJeGFlT6/u1OgutvTlMWnswLJrGYe+C9j1R8auE4e7bibXVfqvMKoASQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7960.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IrMcb2Ahg4Mx4+edLSNNTSDA0eIm8zN411GMEgZvZJMAkbJ0VZ1cxR5ftdGK?=
 =?us-ascii?Q?nMWuM7RAEDbXAfpH1/pe+SDW1SOtRBNQZpWaJ2HJxoCFHxWhUeJBaXCH4vB3?=
 =?us-ascii?Q?pWP3DYiH7yUw9VW/GtUgXcQpUxOzETGQo/RBp/IYmJmw5hE8m6w6nF9H92eZ?=
 =?us-ascii?Q?AFSodVbjsuuvJcq+HcewSIblOpW/vReepaMgxBx5S98/zqNb6Sdop8xAscZS?=
 =?us-ascii?Q?9i8YdaFAMvaLHxW3OiLswugiOoFMNT2VMzbLUfgG1O2lq9P108GEnI5u7FJS?=
 =?us-ascii?Q?Sb5PODtaL7VMZKgkkA+R9qf4iXeIhVBtQbKu62VV9pbK6NhXDYvxENI1MDWq?=
 =?us-ascii?Q?cOUkfmMN/WN9Q2SErir53RAUAyPPXugRPR0wbR+ehbXclR6cyy5UpVZ6kyUy?=
 =?us-ascii?Q?DleV5Xs3wm8sZQvyRTN6RyRtDeovh4PmjNWpQ2Gw9scWcjs4hMZd2ryj37SE?=
 =?us-ascii?Q?OSiJ44RuQxPOCFsnQvVWuU4m8Y4NDXcatFskYaZ4McdIAUnIwYRxQtW+f0tV?=
 =?us-ascii?Q?SOmwVQhUBE59jcpmehO70wFP9t9iHSbbbqw/EAmj3GzMHsJz5pGXdMV1sayU?=
 =?us-ascii?Q?MvF4N3tbsJlodmIxAaMC7fwLbhYdN49V/Rtt8HInmZ3GpJZVPpjreIj3rsuC?=
 =?us-ascii?Q?THMh2CpVW6J4W6aitjTILduwGZxTWGO71Br/YUUWgqQhrEA7iWC1dAcqWA5f?=
 =?us-ascii?Q?1Q/vyGTYJ18TdeK9ErsECJf0mDTaL2CuO1JUzB59pY8nOljRPgy5FlJOzMDr?=
 =?us-ascii?Q?xXFsO3B0FbccmXsadZ+xdqhhu4UACC18i6WtLhulUaoadI8T4RcNI3TxQho5?=
 =?us-ascii?Q?OiTi7z3yoHbBm47HyyIq/rfTdouHtjS0kkLsTFLJEBwv63zG0St+3GHehFTb?=
 =?us-ascii?Q?m6qBFhziQTfCCMJm92tl+Zx0fRgtbAacZWjJoWOavy954RQXvxlwMPycFCkc?=
 =?us-ascii?Q?Ls+Nnew6iDbppg2YA7go0dVmjoghi0U+lTWdFt2ZGXRf/Px55Wa0UVufzFXB?=
 =?us-ascii?Q?XV22gFgIdtTwFLg25yHjCOnBOFVnSLBrR6nHAJFJQ+EMNuUodmQApxLIBXH4?=
 =?us-ascii?Q?tKygG8OmqBFfCGjiI3xjkAPi1PUX+hmgoIQv3AVQt2FFnKRKHAu3X4OY4txe?=
 =?us-ascii?Q?keKtOyC2dutm9lsxmTHkDMioFmGd9oKE2v7aVyPtIjV9Bga/oks9y1e9sAy8?=
 =?us-ascii?Q?yEPffhW4ePSVWhg2yGd/iJxz6X9LH6htei52UC5/GKEMdGkxD8Eo/vmfqtgM?=
 =?us-ascii?Q?ultdCvaf2N9zrjRzsklsz1ROgkDDRuwunBraWX5Umrt2oWd6d6bQrnJqomNO?=
 =?us-ascii?Q?bkjWFO7nwXMTBzXmtRdrWTaKGBHbw0WRwgmpEjatq3L+65bBb1sFQOlBhROW?=
 =?us-ascii?Q?FLTFQet9aZ32+x2Q5hRhbWylAtJcW+EzlAZz+S/9FdwQR1kVuC6tY7/HwnsT?=
 =?us-ascii?Q?jjevA5DqwPAtpFqgewpplNzAVCxkaq3rsb+h2vswg1obS99ZCY2s2K+v/ONc?=
 =?us-ascii?Q?gBlEs6zfwM08nuyw7Qhhs+eHU9vOBoMsqdWBQrgJa0fivoEqj416o/+uXQB1?=
 =?us-ascii?Q?dpaiUAhgi57ea++tG6cljeJ/lo+JUQ5vquGBUoO2LW9rg5rfUxl+jGN7S/kU?=
 =?us-ascii?Q?n4LJNqwcAjBY71xJLOsRxZECBuXetmxDvpYFMI4iy2h0DMIPXTefZsdBoqnS?=
 =?us-ascii?Q?tXts+2dygEyRkedgOfNUhalH/18Ucu0xeX9JeCuLfPlZvL/4ALqJmb0U5S59?=
 =?us-ascii?Q?XT9JtEHjYjab9MymngMsL7KMSAGITkMP3ngPRd0yR/q77zA7CZ51ZZ6/lo92?=
X-MS-Exchange-AntiSpam-MessageData-1: tzgRvJcEQIhcYQ==
X-Exchange-RoutingPolicyChecked: EIVX0rh9wrwj+D70vUr7/AJL5Omr5ZDnGfXvHAczqfTb4X8rdCwqRUVwmV0856IYpMIJkL4hg/CWpPdQGO/sBeKAa2XtAJcefgUcnwcaPxQAYxMGWNm3uYcYhqoUCnMAHHeP1tPaWpJezSv5L/zm2aOZ0H4BUTN/P2NmsuJZyG7YP5+YjlIKKFxefpAFwBtsi+xUNH+941H3msh3Xdj0qKHVBUisIrQo/Y6D9rVAci8gF4r3zqX68WoMemkeRTe33GKJiPwu5AavqgByKPqwMenzCcntT0y0jm8Qp4Ul/W0+W4fTE7JEPo/g229N8zmFGVtUOEhIoM0FcFmJi0UXZg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b08de5-2b81-40fa-fb1c-08df0cf4e1f7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7960.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:30:01.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3g0qeijckcKUu70tJEekB7ijdNq1ftNaGVxk1ci1K9vfItgI1Ioqo8qs0FPqhLvrgFHsHTtsxq7S9dGSitf18w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8987
X-OriginatorOrg: intel.com

On Mon, Sep 07, 2026 at 03:51:19PM +0200, Thomas Huth wrote:
> On 02/09/2026 12.12, Ahsan Atta wrote:
> > adf_dev_start() registered both alg sets in a single condition.
> > If qat_algs_register() succeeds but qat_asym_algs_register() fails,
> > ADF_STATUS_CRYPTO_ALGS_REGISTERED is left clear, so adf_dev_stop() skips
> > qat_algs_unregister(): the skciphers and aeads stay registered with
> > active_devs stuck at 1, pinning the module.
> > 
> > Both helpers leak active_devs internally as well - they increment it and
> > return without decrementing when a crypto_register_*() call fails, and
> > the asym path also leaves the already-registered akcipher behind.
> > 
> > Split the registration in adf_dev_start() so that an asym failure
> > unregisters qat_algs, and unwind active_devs (and the akcipher) on the
> > error paths of both register helpers.
> > 
> > Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
> > Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> > Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >   .../crypto/intel/qat/qat_common/adf_init.c    | 22 +++++++++++-----
> >   .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
> >   .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
> >   3 files changed, 43 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
> > index 3e39c53814de..558467dea1a5 100644
> > --- a/drivers/crypto/intel/qat/qat_common/adf_init.c
> > +++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
> > @@ -260,13 +260,21 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
> >   	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
> >   	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
> > -	if (!list_empty(&accel_dev->crypto_list) &&
> > -	    (qat_algs_register() || qat_asym_algs_register())) {
> > -		dev_err(&GET_DEV(accel_dev),
> > -			"Failed to register crypto algs\n");
> > -		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> > -		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> > -		return -EFAULT;
> > +	if (!list_empty(&accel_dev->crypto_list)) {
> > +		if (qat_algs_register()) {
> > +			dev_err(&GET_DEV(accel_dev), "Failed to register crypto algs\n");
> > +			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> > +			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> > +			return -EFAULT;
> > +		}
> > +
> > +		if (qat_asym_algs_register()) {
> > +			dev_err(&GET_DEV(accel_dev), "Failed to register crypto asym algs\n");
> > +			qat_algs_unregister();
> > +			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
> > +			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
> > +			return -EFAULT;
> 
> EFAULT is the error code that should be used if accessing memory failed,
> it's a very bad choice for an error code in this case here.
> So while you're at it, could you maybe change this to return a more sane
> value here? I think the best option is likely to pass along the return value
> from qat_algs_register / qat_asym_algs_register.

Hi,
Thanks for your feedback. I'll send a v2.

Regards,
Ahsan
--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

