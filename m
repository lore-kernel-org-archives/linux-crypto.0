Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3BE2AEE0;
	Wed, 26 Mar 2025 06:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742970844; cv=fail; b=iXmDSG3FRaAGbAEeHsiPJIOXTk4OWwmNuKajG8rKSv9BqQx3dzWJv7WMIGReZTy6bZ6lWPyFbHZzKYZhNDjUXItFvTSUCZWdQf+K0yGT/bjFguuamNOwyUNcYRycSTd30MPVwwddcJbNXR1t1JKNFCbYEb9briwKx22lQw3osyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742970844; c=relaxed/simple;
	bh=1RGesaocTqs64SKiUjG//RsnLZrGIGtpP6ZHh7zoLWA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=adVYl4abbK6xJNAFMlWCweQLqbgrRhMzWV3YZJ65xfLNXgixv68EYiUF6DeOebfz5yz5SS8E57H4tTzgskcN0QbVIco1unrPdxh6eUU+eUgd652A7xuSJt6zLLoMhoUXD/xmZz0I2QIZKLDC6fmy7XALyUTe1UbfdfUnQLyp08U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXpvcgdX; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXpvcgdX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742970843; x=1774506843;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1RGesaocTqs64SKiUjG//RsnLZrGIGtpP6ZHh7zoLWA=;
  b=IXpvcgdXyWrcY+LbdKVIA5H0pZv5gY6fG4y5FM5xe9bgIIzuYDR+xqhh
   bnsZMzAao8ZvSbcoXweOx6iU8mVMrNSkHEvPzfv/8d/HxiX9vJal0qXR1
   CNvCahw9GOcndHjjq5D1NDPVj2Vmx++d+qdpCgcKP8uVfy7pERyUcAtzy
   6j6yJKlM4foOhs9ud+Mgv4VEPmEs8LKpA35LUTIcJSTi8+xWjPhVDKArK
   AH4/vwAiG81RWWgmjD1C/eRRQl5rhLhToWMldygrohnITjI7nphyAggL4
   Ydo9zU5BC8bYMspxhqX5DpbTbWlN/hf/qNmlrrbv3nyYoVgoQUuLdGLH+
   Q==;
X-CSE-ConnectionGUID: 9ehbolBfRmmcq6BmCQWrdw==
X-CSE-MsgGUID: 7SkXpw9wRLaST9LHfGoLJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11384"; a="69605929"
X-IronPort-AV: E=Sophos;i="6.14,277,1736841600"; 
   d="scan'208";a="69605929"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP; 25 Mar 2025 23:33:47 -0700
X-CSE-ConnectionGUID: Z+r6uWwASwaHUmpknVzMAw==
X-CSE-MsgGUID: qbDBr5QcQNaexrgrEjrB3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,277,1736841600"; 
   d="scan'208";a="129822355"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2025 23:33:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 25 Mar 2025 23:33:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 25 Mar 2025 23:33:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Mar 2025 23:33:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+RYgr+/XxnZtSYH378j5gfdrg14AZCmIMJWUtcB3T+QB8hjVmsJT8HTXchbGw7WQypm/K+801cVoKld+MDfL3L+PGsWl3cMbs4OJAtiTmSjO54SOlToZAcDWXlYc61Q0wisOYX7L/2hXP6yfWPDMWL/iZMN/uaahyxu64rN2xTGM3IUCl+hRXfYkZcOd8Ff1Ax+SRjSx4bgC7rwVyibyx+kpDtI0wa4DdQWXbeaL33HAVmQQaK2bi4kQoxpWZI8K50buJ3+RB8eMwqbyeyV4aYareIOUZC50Cdguc0XZxCDlp6mxumcV5DD+5I97VgnlnHatqaxB8x6a5Wbazwynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2U79Ta8HDpUBYQjwwgry/XTXGZLGUeal4E3TY0nRBg=;
 b=rZ742T1Lw0G6DJJfBgdpfqFUs891mFLNBWqJqg44vuya6Vq3ov1OATnAhhvMeoxOQxf5Zo5GdplzRuYQVYvNf2BeMY23uCSAKu+QcOWNoC2ZxHaoOxpPJDZXHINTGlnNd62vpjeVGQJTmOx47wDdaHOZc5VeElg34lH7N+iN0RGWhcGOhXBmYGwKPhfZd+P9rUKlPW4iFIxrtmy+Oeg7Fvs5GXFohineDAfCxbypvt+O9p9omsh0aOouGHZA+5sW8V2Ej5+PZF2aSlGuQvp3QfrRypkhDaZ2tsLzZQupHu2U1VoP6Amlw8nDukXOHnq58TeAcAjjgZi5zc9vjdwxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM3PPF213267FEE.namprd11.prod.outlook.com (2603:10b6:f:fc00::f14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.43; Wed, 26 Mar
 2025 06:33:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 06:33:37 +0000
Date: Wed, 26 Mar 2025 14:33:27 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Guangwu Zhang <guazhang@redhat.com>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [hwrng]  fb10c7a846:
 WARNING:at_drivers/char/hw_random/core.c:#hwrng_fillfn
Message-ID: <202503261331.d388f82a-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SGXP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::13)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM3PPF213267FEE:EE_
X-MS-Office365-Filtering-Correlation-Id: 39583d87-e5df-443c-0645-08dd6c3023f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HbCW3Aee9P5nkz+Q08c15bAgymvCrpi0RLbKx8Xqwhh7bP0VOq55wHXeHK7U?=
 =?us-ascii?Q?0ywHOpaiDWzFLaUshEp1ZvgXEf/eK7uIRBV8TeWdFlOsSAFBNmIPRibGGUNI?=
 =?us-ascii?Q?GmDJS6TlVrbaB3vDFrh6JTqCdRhVtXp5d4P2SpdwmziM57Gf4s+zqVq8aph/?=
 =?us-ascii?Q?8PDiQs6XnPoz5h7Kt4P3W/mREi5tn73hlhocHiNc+yBn1d9eDTgcCEoetV1T?=
 =?us-ascii?Q?faQ/O7VqC1jSdGcDSKTQ2ZygsLdh68OrOyZlqfmUIGiA06l5wdRVauhY/KoX?=
 =?us-ascii?Q?lx0EqnhC5HKumOlDz03/2t+tqDSY3l7OliUanCBSZs7UySQIrcDqZHa728eo?=
 =?us-ascii?Q?pgI0SbDv5SqFV2ZFPF4QjplCJinCRpS9MEq0YVpaERjbow/mbI2VUhkbq7ZT?=
 =?us-ascii?Q?wNAN3sXBecKhjnydId5F8UgQA9gIc4C4e1Ayb/Qmb5LrNLnlqNSu0jFvO5oW?=
 =?us-ascii?Q?naK8WOVZsqSNoEAO+mQGej1Q1ibpM7l2ZwnwaEitZSDpXED+rc2wEhE/MIsC?=
 =?us-ascii?Q?bItSAcRa9ytT1pjQXnsdtj2UEIIPzW+Rt2RVBQ77t9nRflCchJ/0AGkTPJRr?=
 =?us-ascii?Q?0qPdbJVcN13yEC0KVQBHBLgSljNhg1ISBBoN2aatGbEtaR3jDH4p7fNumxCA?=
 =?us-ascii?Q?GZX1mJb/fBvYjrZfdSKyCGjeJEMHuN1b48AQN4fk1YMIbiXPmExujvihai9L?=
 =?us-ascii?Q?wBYYrz9iYYHN+6ATSmwcKOjisUsqmGP4aORuHmrB8Mt1lQVvZmJj1O8WLLfs?=
 =?us-ascii?Q?nvLzBRnbZppd7f+3mOmAqCBAeypG72X4nSL6H58bevDS1dR6MTjVlKSVLv6a?=
 =?us-ascii?Q?U4ptBfpX42rFaS+MKKilKRFZ2OU0rmLwEUrkbQXxlZl6F5IC7QEoMTU8LWsI?=
 =?us-ascii?Q?s+WQD+QKllhRcjLYut4cmpA9dEAWCFqAabgtTdfS75+QBNaIg19h3ACVKZG1?=
 =?us-ascii?Q?ZZzGRsnJdRScgEOpyQ94Ec0rbJzJqQ3Dl3A2YMc+Br3pducVbTG0MMbXivH3?=
 =?us-ascii?Q?peN67AKbKdMqGkAwR6KBLeWTedwpnEHs3LsrW2BNOSLoLwfSJbRc6ugpa8ZK?=
 =?us-ascii?Q?Zh1BCGkZOaqtUlHDzP5syIZSC4hIulOs4OJ63nBtMOLSb7+5lgbBM26cBVOn?=
 =?us-ascii?Q?RmUtyEoJTOFSSWuInIX93J+5mse8v3VrME4BDjSy/mgkzOp6MTo9AjLu45zQ?=
 =?us-ascii?Q?f0xTG3OfrRcJ91t6LvEMSvMBDCi485D4Y4PKo1DBqqbVfkt29ajh80QXs6Eu?=
 =?us-ascii?Q?YLN1azkoGzIvaajf7igF9TWvjQBOBDn+LQiu/4Gm3VgLIb44t/kE/sK4j6uw?=
 =?us-ascii?Q?ZhmYe4z5yD28U79+PL0WiliUBVJOsyILNp3doGTnFQZh+gHxCVW8upNl7Y6m?=
 =?us-ascii?Q?o9alNuTTTOG0e6fRSirxOYv7Uy9b?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r7jMIcA2inr9eV/FMx/Tv3pgDEsqA51SthikwrLsSmI0PjFRnpP+a/MFm3EI?=
 =?us-ascii?Q?bbKFAiOrXz5D+2CinCJbPLWRaXX5ummw7yXjk022rEcum5wXeGW13RXJccMQ?=
 =?us-ascii?Q?xjWLBMDXzcAy6rGZgH85Uf4/2/0p6M8eXcotrGhqVMejv5Lm0Q9JRMoSlDYT?=
 =?us-ascii?Q?TYdWrmrIiUYRvrWypoDAtzvVKrlB0bcyz5P67rdoEIMA3YkTY/diZSvsvZ70?=
 =?us-ascii?Q?gGeIc5ekVabQ1Pe960G8a9TrBF8AmU0waq00k4+OOYDhQIJTl+gk9V/q/k41?=
 =?us-ascii?Q?Z6t1ucwYPa1i91yyJ164yuC8scn5e+sckVrCbkndauO1Nf9pgtxycxR4lzkp?=
 =?us-ascii?Q?zRTDeY/QkIOIcb744J6+A0dttbPp6GFX6pNL1PMtcSJlzsqv02yA+CZoTpge?=
 =?us-ascii?Q?54T4CCC7znsyLOj8XcMiuMWTWdVKaeQ9si+6XELVF7PrS4Y+l3g/7sZI+0Ah?=
 =?us-ascii?Q?TxiRkZ+u8VJL1Ao37+MsB6MSYgvOVMHE2YvtVQhbQppxetg8YNWvD4sXkLds?=
 =?us-ascii?Q?I1GvUzzIo07z9YYyrXs2ooY+MAL/d26wQM9oFLV4xF5WQJ09wzBihNLE2KN6?=
 =?us-ascii?Q?8WT6v+7LPxalUlsCQYbRfRU3zf0ooFda02utrnjT2EXhT4MkVTjLG4iKFUJX?=
 =?us-ascii?Q?kNB/s3zVyxpBDuBh7Kb0e/un036Du4buIkA1eicy4IJO7ozTuplUNk8aGt5g?=
 =?us-ascii?Q?2gyftYYZyCeVT1y6dyn+HuiJXhOg/z+J5mNPKDRxLUtRcn5QdXzMTtQW03xW?=
 =?us-ascii?Q?ZXPxWIBxVXYs08OOHtwAaE/MjGIE9/LRicDasb/Jm0PQbtEu3z3YTpA4HD53?=
 =?us-ascii?Q?/g808GwsA+xIqgkSFLQlQN4XlX4CYcsmH1qheyZ8F63WrErXc+hs33Sg2Ohm?=
 =?us-ascii?Q?kFmUTvvpUn68zhBEs47eDDAhGWIZbUrcIPF1hEb1HvNIEnNmrON3UsN0weG4?=
 =?us-ascii?Q?VgFXjZw6ZiqgcSE3xQRQOnnMLdtzIzgjdWk7X3wFHtXVofR8hyhp1v3no1bT?=
 =?us-ascii?Q?IXLXw2wLOy3fAqQHJKuB1C1s2/6aI8thhzPkqyS7d6G6CoEQS3l21dbESb7F?=
 =?us-ascii?Q?wxflyjYqQa7PXgpePt9gh2yF4HFWH7pSVgll/vqMMd3EMPWJ+1Rn5lWqw1gg?=
 =?us-ascii?Q?sdkyL8lMMiUGI8vkrRLKW19+LWq93ekZT2D/DllXSiUXkrrwYzwKA//+UiKW?=
 =?us-ascii?Q?p1rTSnH94cNtJFbFswHiFg8Z26tJ3Wbl173M2tP49zJEt9Jlw9DLO9oRElie?=
 =?us-ascii?Q?ToLqiBC3pz+8U4Nq3cYjyXa13cgBzhr0l0EfSCZ//t9lDgMPI4aTn8qVpPSp?=
 =?us-ascii?Q?vNmWnbtq2ZOrS8RY9rBHFcxHtlG7+0+MVTFhTgNo9dcZIAqm4aAVifMPRsY9?=
 =?us-ascii?Q?YiaEjBeCBo+q1olXvNRthNhiISGGciT7Qj0T/3ykNM1mVFa65jQmhWrJ71HT?=
 =?us-ascii?Q?nS2n31g4mJckQT0rjJYWE4xwCg5ZcOLgqk0sJpbd7HFgoqLSWsF3WEq5zCxr?=
 =?us-ascii?Q?nrRW5M/yN3bllWKoMeMvXzgEoUYbvCu14so+8eeCZ6bM4HCp2Kngr2801pT4?=
 =?us-ascii?Q?Nh7e1gikPhLBuYcstGIo5XMLO2jHisuKq8txOHdOQdcUYqxtcPprA/e8lQ+y?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39583d87-e5df-443c-0645-08dd6c3023f1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 06:33:37.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnxWdgCABRittdgRH64zXHdnh1KqiA9poTOJvHWUUWMHgZhjQwHLYDPQpz3gDpG49d9mBDm+4EGybx8jdrNgLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF213267FEE
X-OriginatorOrg: intel.com


hi, Herbert Xu,

we noticed the WARN added in this commit was hit in our tests.
below full report FYI.


Hello,

kernel test robot noticed "WARNING:at_drivers/char/hw_random/core.c:#hwrng_fillfn" on:

commit: fb10c7a84661471cdcc8998d63703211b873c126 ("hwrng: core - Add WARN_ON for buggy read return values")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

in testcase: stress-ng
version: stress-ng-x86_64-1c71921fd-1_20250212
with following parameters:

	nr_threads: 100%
	testtime: 60s
	test: memcpy
	cpufreq_governor: performance



config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202503261331.d388f82a-lkp@intel.com


kern  :warn  : [   28.777572] ------------[ cut here ]------------
kern  :info  : [   28.780433] resctrl: MB allocation detected
kern :warn : [   28.785745] WARNING: CPU: 46 PID: 576 at drivers/char/hw_random/core.c:188 hwrng_fillfn (drivers/char/hw_random/core.c:188 drivers/char/hw_random/core.c:492) 
kern  :info  : [   28.790623] resctrl: L3 monitoring detected
kern  :info  : [   28.790753] IPI shorthand broadcast: enabled
kern  :warn  : [   28.800354] Modules linked in:
kern  :info  : [   28.805292] ... APIC ID:      00000000 (0)

kern  :info  : [   28.806287] ... APIC VERSION: 01060015

kern  :warn  : [   28.818747] CPU: 46 UID: 0 PID: 576 Comm: hwrng Not tainted 6.12.0-rc1-00031-gfb10c7a84661 #1
kern  :warn  : [   28.806287] 0000000000000000
kern  :warn  : [   28.825377] Hardware name: Inspur NF5180M6/NF5180M6, BIOS 06.00.04 04/12/2022
kern  :warn  : [   28.806287] 0000000000000000000000000000000000000000
kern :warn : [   28.836782] RIP: 0010:hwrng_fillfn (drivers/char/hw_random/core.c:188 drivers/char/hw_random/core.c:492) 
kern  :warn  : [   28.806287] 00000000
kern  :debug : [   28.806287] 00000000000000000000000000000000
kern :warn : [ 28.848190] Code: 11 27 00 00 e8 45 a7 6f 00 48 89 df e8 fd f4 ff ff e9 8c fe ff ff 48 8b 43 20 48 89 ee 48 89 df ff d0 0f 1f 00 e9 15 ff ff ff <0f> 0b 44 0f b7 2d ea d6 70 02 66 44 39 6b 38 74 23 66 44 89 6b 38
All code
========
   0:	11 27                	adc    %esp,(%rdi)
   2:	00 00                	add    %al,(%rax)
   4:	e8 45 a7 6f 00       	call   0x6fa74e
   9:	48 89 df             	mov    %rbx,%rdi
   c:	e8 fd f4 ff ff       	call   0xfffffffffffff50e
  11:	e9 8c fe ff ff       	jmp    0xfffffffffffffea2
  16:	48 8b 43 20          	mov    0x20(%rbx),%rax
  1a:	48 89 ee             	mov    %rbp,%rsi
  1d:	48 89 df             	mov    %rbx,%rdi
  20:	ff d0                	call   *%rax
  22:	0f 1f 00             	nopl   (%rax)
  25:	e9 15 ff ff ff       	jmp    0xffffffffffffff3f
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	44 0f b7 2d ea d6 70 	movzwl 0x270d6ea(%rip),%r13d        # 0x270d71e
  33:	02 
  34:	66 44 39 6b 38       	cmp    %r13w,0x38(%rbx)
  39:	74 23                	je     0x5e
  3b:	66 44 89 6b 38       	mov    %r13w,0x38(%rbx)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	44 0f b7 2d ea d6 70 	movzwl 0x270d6ea(%rip),%r13d        # 0x270d6f4
   9:	02 
   a:	66 44 39 6b 38       	cmp    %r13w,0x38(%rbx)
   f:	74 23                	je     0x34
  11:	66 44 89 6b 38       	mov    %r13w,0x38(%rbx)
kern  :warn  : [   28.850350] 00000000000000000000000000000000
kern  :debug : [   28.850350] 0000000000000000
kern  :warn  : [   28.858987] RSP: 0000:ffa000000ecb7ed0 EFLAGS: 00010206
kern  :warn  : [   28.850350] 000000000000000000000000000000000000000008001000



kern  :debug : [   28.886279] number of MP IRQ sources: 15.
kern  :warn  : [   28.891243] RAX: 0000000000000903 RBX: ff110001077f6760 RCX: ffa000000ecb7e57
kern  :debug : [   28.894823] number of IO-APIC #8 registers: 120.
kern  :warn  : [   28.900743] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff110001077f6038
kern  :info  : [   28.907093] testing the IO APIC.......................
kern  :debug : [   28.907113] IO APIC #8......
kern  :warn  : [   28.909286] RBP: ff11000109247c40 R08: 0000000000000000 R09: 0000000000000000
kern  :debug : [   28.911481] .... register #00: 0E000000
kern  :warn  : [   28.913673] R10: 00000000000007e0 R11: ff110020001340e4 R12: 0000000000000000
kern  :debug : [   28.918379] .......    : physical APIC id: 0E
kern  :warn  : [   28.926205] R13: ff11000200313a00 R14: 0000000000000000 R15: ffffffff819ce3d0
kern  :debug : [   28.931517] .......    : Delivery Type: 0
kern  :warn  : [   28.939345] FS:  0000000000000000(0000) GS:ff11002000100000(0000) knlGS:0000000000000000
kern  :debug : [   28.945175] .......    : LTS          : 0
kern  :warn  : [   28.948756] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :debug : [   28.956581] .... register #01: 00770020
kern  :warn  : [   28.961118] CR2: 0000000000000000 CR3: 000000407dc22001 CR4: 0000000000771ef0
kern  :debug : [   28.968939] .......     : max redirection entries: 77
kern  :debug : [   28.968940] .......     : PRQ implemented: 0
kern  :warn  : [   28.973996] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kern  :debug : [   28.981818] .......     : IO APIC version: 20
kern  :warn  : [   28.986525] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kern  :debug : [   28.995304] .... register #02: 00000000
kern  :warn  : [   29.000012] PKRU: 55555554
kern  :debug : [   29.006450] .......     : arbitration: 00
kern  :warn  : [   29.010984] Call Trace:
kern  :debug : [   29.018809] .... IRQ redirection table:
kern  :debug : [   29.018810] IOAPIC 0:
kern  :debug : [   29.018819]  pin00, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern  :warn  : [   29.024563]  <TASK>
kern  :debug : [   29.029528]  pin01, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.037352] ? __warn (kernel/panic.c:748) 
kern  :debug : [   29.042408]  pin02, enabled , edge , high, V(30), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.050225] ? hwrng_fillfn (drivers/char/hw_random/core.c:188 drivers/char/hw_random/core.c:492) 
kern  :debug : [   29.054766]  pin03, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.058165] ? report_bug (lib/bug.c:180 lib/bug.c:219) 
kern  :debug : [   29.062876]  pin04, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.066017] ? handle_bug (arch/x86/kernel/traps.c:285) 
kern  :debug : [   29.070556]  pin05, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.073520] ? exc_invalid_op (arch/x86/kernel/traps.c:309 (discriminator 1)) 
kern  :debug : [   29.082309]  pin06, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.085099] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621) 
kern  :debug : [   29.093888]  pin07, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.097807] ? __pfx_hwrng_fillfn (drivers/char/hw_random/core.c:480) 
kern  :debug : [   29.106593]  pin08, enabled , edge , high, V(20), IRR(0), S(0), physic	al, D(0003), M(0)
kern :warn : [   29.111118] ? hwrng_fillfn (drivers/char/hw_random/core.c:188 drivers/char/hw_random/core.c:492) 
kern  :debug : [   29.119906]  pin09, enabled , level, high, V(20), IRR(0), S(0), physic	al, D(0002), M(0)
kern :warn : [   29.124255] kthread (kernel/kthread.c:389) 
kern  :debug : [   29.133043]  pin0a, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.137223] ? __pfx_kthread (kernel/kthread.c:342) 
kern  :debug : [   29.146009]  pin0b, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.150534] ret_from_fork (arch/x86/kernel/process.c:147) 
kern  :debug : [   29.159320]  pin0c, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.164193] ? __pfx_kthread (kernel/kthread.c:342) 
kern  :debug : [   29.172979]  pin0d, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern :warn : [   29.177851] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
kern  :debug : [   29.186640]  pin0e, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern  :warn  : [   29.191166]  </TASK>
kern  :debug : [   29.199952]  pin0f, disabled, edge , high, V(00), IRR(0), S(0), physic	al, D(0000), M(0)
kern  :warn  : [   29.203697] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250326/202503261331.d388f82a-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

