Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C89154433;
	Tue, 31 Dec 2024 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735622668; cv=fail; b=Yx4W2HxpPqdvhcrhjWZ+iysYbIW8ZCsoBmsJCEaKrh4we3nRoqcDGZLiOOFqSutFukj4xfEWBABz4BHmaut95Dq7fK7zFLpvq8XQkbcwxamU0p16yfUxFd7ouP0sE3RI3SvgsxR6S3z1ueUZCOyeZMWCPCcKgiKcnYtpg5Kv6bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735622668; c=relaxed/simple;
	bh=e8Cfrt2G3J5pXexME0RwcVBtbFdb3NQGcUoq/IIH/ao=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=SoRKe7oyrzj9tBif9eeYsjkbflL8q/u5E7Pq3HOuhdeWAG3s6p1DvifCoEhUvCNCusN7Ye0MbSVK9jGD9Tw5P7jSRX2N/d7VYZK1+Ub3hSQcNNn8MsOR46YdJ6ox8P7uBZjMlnLJMakfe/srT4zRLuLOFHtc6XO+8FF907c1BNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lLcJtwmM; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lLcJtwmM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735622665; x=1767158665;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=e8Cfrt2G3J5pXexME0RwcVBtbFdb3NQGcUoq/IIH/ao=;
  b=lLcJtwmMnZOTmMaNbOKq0xy1OM13YHkfBSDEzk3woLBXfAUfN/653T4Q
   RiXUIe8r4iBbL6MgNcP9bWBGovuwPTLkYiAfN+FwicZrFLBbWtOznETg9
   ADFhHr+MbpLz7vBlDFAx3S1JaOvB8+wxivTudMg2KJ87cS5lO3IICYKtd
   k3SysmYTEMDYJem3XVzWv5PPpdWp6UK7SO9lZTNPHZL1e/VWoDDT93IN9
   FDsj+XWzMVBIsM1En82rNyWXQ5Q9g5GSJ+wOWr02G02FgHMvyLTL5j1H/
   RNpN+r24WvyOU4ef0l/EvhiaYRkn48kB7gK7zxXeaUxIF26nkQikfM8/W
   g==;
X-CSE-ConnectionGUID: 8tdnLObYRhe3snfp8kGmrw==
X-CSE-MsgGUID: +w16MixhREitb1fOnUHgPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11301"; a="35787465"
X-IronPort-AV: E=Sophos;i="6.12,278,1728975600"; 
   d="scan'208";a="35787465"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2024 21:24:25 -0800
X-CSE-ConnectionGUID: mksZ+TXtRl2O7r2/LItygQ==
X-CSE-MsgGUID: vEadxljIQkCJyXXSZgpAag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,278,1728975600"; 
   d="scan'208";a="100828335"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Dec 2024 21:24:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 30 Dec 2024 21:24:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 30 Dec 2024 21:24:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 30 Dec 2024 21:24:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzlCOih16VAtSNfAxj3IkVDMVfEJdjBQ8fbP1JchgsSyplIGs5mv1K90pOxBkC58dTjierB9phVIynyUR5o+xwm7z/I4cwR8cKP1rOEVVgyY4MxyOJ9ci7SSqJf2sD1ZLSbZ7ps7GaoGeMAjE87kcC7nHmkQ8kZ5qENcPrJH4zZdZu64DI0YSzUk/8OlJEhKJTYbHDQSZXX4AASLal5pu+q8rZ1NAuEiGw0blTptk8TeI0UFvzItm0eox46tjHUELfRUGmSjKzn1nQpkvQ0HJxll0d5YxXKoKXqKcTt6o0hQeSfXvHY4lDUtDAOOEKEvkSumQZPiiamvAFo/eDgHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UfXDXxLUauwPA5ny6xSjqzEbPzOqRxrtKji4i/lahBI=;
 b=O79wDi2DNxJDO+wlssKiuOs83RU+XSZ02uGO3hOJdL42EQpRUgsBZpNxHdoHr1RnT4lhjL6UGGQNfq+W3mrGKdxHK4Qg+shNd5uix4OtXhL7iQ4p4zPhKuZHg1JiGOnBF6tEWU9pfYiEr15ggb55TRrsjuNLIsiQASnsZao+cUhQaG45zL6Z91pKeJ9vmiqsCgUVAWKuciYJQSId/5jZEO6uxYa8wGF9WsvOojeRaT3emAG8eCYJaEb1C8+J+KsWH62kD5maKMlVVstmloNLKSRWX0qE/LmZJ1xKFeqosdFDOL4c+d0oS3CpR66OovGdOFZVtvchJ+uqSeHFmkHJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB8667.namprd11.prod.outlook.com (2603:10b6:8:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.18; Tue, 31 Dec
 2024 05:24:16 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 05:24:15 +0000
Date: Tue, 31 Dec 2024 13:24:06 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Breno Leitao <leitao@debian.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>,
	<netdev@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [herbert-cryptodev-2.6:master] [rhashtable] e1d3422c95:
 WARNING:at_mm/util.c:#__kvmalloc_node_noprof
Message-ID: <202412311213.4e69877e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB8667:EE_
X-MS-Office365-Filtering-Correlation-Id: de0a18ca-c5a6-44be-b03e-08dd295b5e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?32V8qMUqMIob23KTVe544zbqncBbAVKm5hvtEYkWJ8/XrdpRyEoT9p0+2BzG?=
 =?us-ascii?Q?6fEuzFpGn534CFDqx3rQWehLM2TohTsz3OW4SjzncB7S5/9pO4IQslyiL7PY?=
 =?us-ascii?Q?llc0rjtPxou7ChsuV+ptjKLbK2kwipX1wRv0aNNFXqnibErdQzaCvUSROJre?=
 =?us-ascii?Q?LG8oiz1Vyx+TQ+EVRTr7bBfbcFigH0nD33NZMmd++06fy+PfdQhMtmUOT7q0?=
 =?us-ascii?Q?g4/NddnlOiduEOietGtl8NWC3fDqNztTgcPkLhor98Zx1//l1p4yFXvWVFVf?=
 =?us-ascii?Q?3WUcGzxTHwd0EpW2o4jxLwuP5VDsZzdGLCrdCaVncDC3bnXyPpZ8jjzDkWtS?=
 =?us-ascii?Q?4/JLaOCTUNxUDOrFYrGR9Z8eCjk9bY//YgNriKi7vatu3tjU1RDvsLG4jcwm?=
 =?us-ascii?Q?KhiGDcxSDL/5sDnooSGGKuvUe4wbJUVzKsabDBKT+7/6FGbM8yRrMU+qIcYN?=
 =?us-ascii?Q?ycGkcK+cKY3zLvuWWnlrmi6HI4fHxY6xn7d6YeJiGVp4OKpFNN0dC6jo23zd?=
 =?us-ascii?Q?7BnSHWDQWeai8JGkMq6PBPMKLw30G2PSfAJOPXsMPBab9yYKFA32FwwACsll?=
 =?us-ascii?Q?6wBzYLjRdIty911v9/rMjzhAlXA9DUtPhIVch5F8SFSINnkQvh8oB4+0dxfs?=
 =?us-ascii?Q?OGvzrAuZuAgo6KDgoQg4CnHZzbDmJzkBx4dDhjazf4NCxKsbT0Ja6efJwyXC?=
 =?us-ascii?Q?JzcmvdJF469SkJ+l7ngKW8S33zxkrUX2B5tuKYt0ankEM955nTE+8KRV5rGk?=
 =?us-ascii?Q?GhJvMbLW2ZMTAJtSvGXG6Jn08Za8C1tLFKhJUOKxfEPF+OF3TWISutX9lIow?=
 =?us-ascii?Q?elhkM/LIHo2vHp2n9WP5bpsBeXymDtjq26nKVmEk1KxXhh+zg6jZ4FDbefxx?=
 =?us-ascii?Q?fDMsm2QpaLJ/NKOKad0GJ4iONysmjIL+IJLZCeGuh+trk9XK7c7shOvbKcEw?=
 =?us-ascii?Q?8kMiKq5ob4/fVrhc7hN2hAwy3jrle8+X20zQJwZskBn9jZHT645Y76V0Fq+m?=
 =?us-ascii?Q?4UaFrovNUnn9AAWwYDm0p8zaZ3yEdjmFCslUNjeqsagDZb6kWs96IxoSajTX?=
 =?us-ascii?Q?CPwhF1cX0aR0bfAKfGRVi5l3OUEVC8u9RD5k+mesj67gtM9VLWHiDBuJBo7x?=
 =?us-ascii?Q?0mZILpT/iH3MwibidkVGCwatmRidCpOsVQsSoWNTM294ueIBn9aD8VfSYRBa?=
 =?us-ascii?Q?sUOq4/hvRYW4jlvAm7cFXReI7fBI77Yh2wInItgQa8O50cUydjncSfUMtgOw?=
 =?us-ascii?Q?yCcN4qDmEj2frLaq8nlmnpE4/xdI40dLrcDslQHN3tE+Wb1PbUYyNRy34+81?=
 =?us-ascii?Q?jqr90E6l0nKbMLUoNWb7s+oBqkm2VpbmWkyqgbYzvveo2w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SkWjux20Aomed6DK6DVx/SQoDDtP/4EgcXVwr1srCiUu2cP1Xn94Jtw+N+S5?=
 =?us-ascii?Q?Yg/rXmdgr2kU3Wjfxck5IZxKIIy1Uexv382mGGvGPmXKMeEHuur3vdPqaMcC?=
 =?us-ascii?Q?QJuvvX8QC3rnjUwSYcJi/VQebP5jvywIG3vYdDvEDDE8nziQVX4SuB67xnXY?=
 =?us-ascii?Q?BxQxBiZhiZ5SwHDX756vny9TIyU3C1LFmI6CxZbvQn6B+alrz4okZGjMNgd3?=
 =?us-ascii?Q?2kx8xDxoGxh1BBW2pJAAT6exutNggTL9c1ikMxu/3oWnd4ep/XMvCzVuPjUR?=
 =?us-ascii?Q?lTskcp7skrEQ4Oz38qLQnfrXWm4yiv3XYRX5Lxb8WsHRd/TxPxSXy3sIJozj?=
 =?us-ascii?Q?BWazK8UH5zOlLicljUIwvt3Upsqn79sZVjdtVEQfV10CDtapey7PYbC49Xpl?=
 =?us-ascii?Q?qguGsYbVwi/kTfvF69YFgvZFTyKAmuWAlrQ/cxHVFEGA+IzxdfrYJo3pMaYp?=
 =?us-ascii?Q?dFdOPi3amElUDfwSXQ5xe7s5Pk7rIAhDkE+FEtJ2ktXZDmBbBfd3N/GPTjSA?=
 =?us-ascii?Q?fKViSbCkXfzPNxtM6j18h1pSrSevj34oOjJqehL4kGMlbDyhpD8+LCpKsfR4?=
 =?us-ascii?Q?riIhd8Ir19WOF67NJJ4yLJq8eLZGfRgklPWkKpv6M/Tn6LQ1Agfz+KSa98L9?=
 =?us-ascii?Q?GV++tHMDv7jsKEtC1klWK6KN2RweTVK9QE5FRYhlq82RPXL5FbHaW6WA8CTh?=
 =?us-ascii?Q?QYKOfVqygZ2cmEKc3mqR9rN9Wo3yQ7/PHmuC96wpQH6TnSygLiNb+C3Fj9+X?=
 =?us-ascii?Q?SEr2EA5NiNrB5VBsBXrTtgjJ1NZGOLQ9dIouBom8rmJHG4b5DGSnmoorvWPV?=
 =?us-ascii?Q?uldtOvGSJ+YCVRxsRcUhL+yRw1mVQvE5Y3KtvFOc3LAjmK4uVMziyQaAjKq0?=
 =?us-ascii?Q?I9Ox0rfli0A0DnoUlloM5D2bCsU7OVKzAbD8/5hsQntqyBAN/rsfQRNO4lnB?=
 =?us-ascii?Q?+WGc0JxSAGXSIEKvL/pBTXtL0kSs3Ts/0eY3C4hQa/+rv9c1OOeA0pGSxeFe?=
 =?us-ascii?Q?bqR3ZnVj57caWyEoR6TNFmlWx5x1AtCYDADJJqU8+OAE/LP0hAcIENZq5M/v?=
 =?us-ascii?Q?ZL6jmcWOf9QSdGbwXOd1YoXXxuLl4u/tctFudz+5keclXN9GUCLXJ1aO+y22?=
 =?us-ascii?Q?mIfLHtRWR+d+fj/QMEImYoKbCR2rxGFYERWLNaSWu0VJmsSYU9Z327aSTOfJ?=
 =?us-ascii?Q?Y5JUh1Wnzj2nPlcDkAdmOGkQpG/I4m4MDthW53WCmkxtQYHxRMxMKXchLzpC?=
 =?us-ascii?Q?k9SVAw32nkKUWDvchkKunmXWsnzax4CYC90R+bCnceBHEi/53URrc1xCQxte?=
 =?us-ascii?Q?ycNp1I598S2r6yM0+LJtfAO7IFQqtjn8I21twmisr5JZ6BvCKaVAanASTfae?=
 =?us-ascii?Q?SU8AdY8aeJV/8H+KWjz/hrCMI2NBkfiPMuP3TVUOcuXp32ut4M9AHwX2K3Wp?=
 =?us-ascii?Q?vUd97flNB4pyOigfdXopzpEOw7IUs9VV87QdFsXL8UNKwd88hTsbM4+ivgZ7?=
 =?us-ascii?Q?4odYXAzXX/yrZ0IlE+a4txdsyEl0grT0UXN/M5zLkisj5BTf+KFU800RvCao?=
 =?us-ascii?Q?3li14+pCMma0xK5Nb1G+K+Lt4IDUotknalaamU+TdGpwiguL5/YPUhbnMk9g?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de0a18ca-c5a6-44be-b03e-08dd295b5e5c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2024 05:24:15.9280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJcp0LoBEdWLokgS2QqB83h7qNjgdEb7QSnscYSlBwSSN+PnDRwxnwfm09TostQn0HvCgnLYqhHDJ7xBwrGMxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8667
X-OriginatorOrg: intel.com



Hello,


we reported
"[herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95: stress-ng.syscall.ops_per_sec 98.9% regression"
in
https://lore.kernel.org/all/202412271017.cad7675-lkp@intel.com/

now we observed below WARNING in another tests. it doesn't always happen.
11 out of 20 runs as below. but keeps clean on parent.


f916e44487f56df4 e1d3422c95f003eba241c176adf
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :20          55%          11:20    dmesg.RIP:__kvmalloc_node_noprof
           :20          55%          11:20    dmesg.WARNING:at_mm/util.c:#__kvmalloc_node_noprof

below full report FYI.


kernel test robot noticed "WARNING:at_mm/util.c:#__kvmalloc_node_noprof" on:

commit: e1d3422c95f003eba241c176adfe593c33e8a8f6 ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master

in testcase: reaim
version: reaim-x86_64-7.0.1.13-1_20240229
with following parameters:

	runtime: 300s
	nr_task: 100%
	test: short
	cpufreq_governor: performance



config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202412311213.4e69877e-lkp@intel.com


kern  :warn  : [   45.855882] ------------[ cut here ]------------
kern :warn : [   45.861844] WARNING: CPU: 5 PID: 379 at mm/util.c:662 __kvmalloc_node_noprof (mm/util.c:662 (discriminator 1))
kern  :warn  : [   45.871496] Modules linked in: btrfs blake2b_generic xor raid6_pq libcrc32c sr_mod sd_mod cdrom sg intel_rapl_msr intel_rapl_common binfmt_misc sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul isci crc32c_intel ghash_clmulni_intel snd_pcm libsas ahci mgag200 ipmi_si libahci scsi_transport_sas rapl snd_timer drm_client_lib snd intel_cstate mei_me drm_shmem_helper ipmi_devintf i2c_i801 soundcore ioatdma libata mei intel_uncore drm_kms_helper ipmi_msghandler lpc_ich pcspkr i2c_smbus dca wmi joydev drm fuse loop dm_mod ip_tables
kern  :warn  : [   45.927716] CPU: 5 UID: 0 PID: 379 Comm: kworker/5:1 Not tainted 6.13.0-rc2-00035-ge1d3422c95f0 #1
kern  :warn  : [   45.938497] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.99.99.x069.071520130923 07/15/2013
kern  :warn  : [   45.950732] Workqueue: events rht_deferred_worker
kern :warn : [   45.956775] RIP: 0010:__kvmalloc_node_noprof (mm/util.c:662 (discriminator 1))
kern :warn : [ 45.963290] Code: 00 00 48 8d 4c 0a ff e8 1d 54 05 00 48 83 c4 18 5b 5d 41 5c c3 cc cc cc cc 48 b9 00 00 00 00 00 20 00 00 eb c3 80 e7 20 75 e6 <0f> 0b eb e2 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 2e 0f 1f 84 00
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	48 8d 4c 0a ff       	lea    -0x1(%rdx,%rcx,1),%rcx
   7:	e8 1d 54 05 00       	call   0x55429
   c:	48 83 c4 18          	add    $0x18,%rsp
  10:	5b                   	pop    %rbx
  11:	5d                   	pop    %rbp
  12:	41 5c                	pop    %r12
  14:	c3                   	ret
  15:	cc                   	int3
  16:	cc                   	int3
  17:	cc                   	int3
  18:	cc                   	int3
  19:	48 b9 00 00 00 00 00 	movabs $0x200000000000,%rcx
  20:	20 00 00 
  23:	eb c3                	jmp    0xffffffffffffffe8
  25:	80 e7 20             	and    $0x20,%bh
  28:	75 e6                	jne    0x10
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	eb e2                	jmp    0x10
  2e:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  35:	00 00 00 00 
  39:	66                   	data16
  3a:	66                   	data16
  3b:	2e                   	cs
  3c:	0f                   	.byte 0xf
  3d:	1f                   	(bad)
  3e:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	eb e2                	jmp    0xffffffffffffffe6
   4:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   b:	00 00 00 00 
   f:	66                   	data16
  10:	66                   	data16
  11:	2e                   	cs
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
kern  :warn  : [   45.985030] RSP: 0018:ffffc9000726bdf8 EFLAGS: 00010246
kern  :warn  : [   45.991655] RAX: 0000000000000000 RBX: 00000000000000c0 RCX: 0000000000000013
kern  :warn  : [   46.000399] RDX: 0000000000000013 RSI: ffffffff8143fb29 RDI: 0000000000052dc0
kern  :warn  : [   46.009144] RBP: 0000000080000040 R08: ffff888100050ec0 R09: 00000000000003bf
kern  :warn  : [   46.017889] R10: ffffc9000726bdf8 R11: 0000000000000000 R12: 00000000ffffffff
kern  :warn  : [   46.026632] R13: 0000000000000dc0 R14: ffffffff832bdb78 R15: ffffc9003f200000
kern  :warn  : [   46.035377] FS:  0000000000000000(0000) GS:ffff88881f480000(0000) knlGS:0000000000000000
kern  :warn  : [   46.045189] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [   46.052381] CR2: 00007fb81ab04010 CR3: 00000001ddf98002 CR4: 00000000001706f0
kern  :warn  : [   46.061140] Call Trace:
kern  :warn  : [   46.064650]  <TASK>
kern :warn : [   46.067773] ? __warn (kernel/panic.c:748)
kern :warn : [   46.072169] ? __kvmalloc_node_noprof (mm/util.c:662 (discriminator 1))
kern :warn : [   46.078004] ? report_bug (lib/bug.c:180 lib/bug.c:219)
kern :warn : [   46.082885] ? handle_bug (arch/x86/kernel/traps.c:285)
kern :warn : [   46.087570] ? exc_invalid_op (arch/x86/kernel/traps.c:309 (discriminator 1))
kern :warn : [   46.092640] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621)
kern :warn : [   46.098091] ? __kmalloc_node_noprof (arch/x86/include/asm/bitops.h:417 include/asm-generic/getorder.h:46 mm/slub.c:4273 mm/slub.c:4289)
kern :warn : [   46.104039] ? __kvmalloc_node_noprof (mm/util.c:662 (discriminator 1))
kern :warn : [   46.109874] ? __kvmalloc_node_noprof (mm/util.c:653)
kern :warn : [   46.115710] bucket_table_alloc+0x49/0x170
kern :warn : [   46.121753] rht_deferred_worker (lib/rhashtable.c:367 lib/rhashtable.c:427)
kern :warn : [   46.127216] process_one_work (kernel/workqueue.c:3234)
kern :warn : [   46.132492] worker_thread (kernel/workqueue.c:3304 kernel/workqueue.c:3391)
kern :warn : [   46.137471] ? __pfx_worker_thread (kernel/workqueue.c:3337)
kern :warn : [   46.143031] ? __pfx_worker_thread (kernel/workqueue.c:3337)
kern :warn : [   46.148587] kthread (kernel/kthread.c:389)
kern :warn : [   46.152789] ? __pfx_kthread (kernel/kthread.c:342)
kern :warn : [   46.157765] ret_from_fork (arch/x86/kernel/process.c:153)
kern :warn : [   46.162551] ? __pfx_kthread (kernel/kthread.c:342)
kern :warn : [   46.167527] ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
kern  :warn  : [   46.172691]  </TASK>
kern  :warn  : [   46.175920] ---[ end trace 0000000000000000 ]---
user  :err   : [   48.391965] create_shared_memory(): can't create semaphore, pausing...

user  :err   : [   48.404021] create_shared_memory(): can't create semaphore, pausing...

user  :err   : [   48.415885] create_shared_memory(): can't create semaphore, pausing...

user  :err   : [   48.427763] create_shared_memory(): can't create semaphore, pausing...

user  :err   : [   48.439628] create_shared_memory(): can't create semaphore, pausing...

user  :err   : [   48.451489] create_shared_memory(): can't create semaphore, pausing...




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241231/202412311213.4e69877e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

