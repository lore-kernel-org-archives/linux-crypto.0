Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B80718D65E
	for <linux-crypto@vger.kernel.org>; Tue, 15 Apr 2025 08:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744706647; cv=fail; b=tDxd5XjkwvObghyY+hb8p9jWSrx5DCz7znNwWL0wAxf2bq5gY9Wn5mhObg0ukW3UnMM2AFOTzjR8tkVpVqLA06zT3gGkHJDju060aOg1wnlHQ78UFQbMm7RQDND99cHs2LL5Fdjgod3AQSLkNMiBI612IDNJSwqU0KG+pEnwbig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744706647; c=relaxed/simple;
	bh=4kby0UlWeohDz+iqe8FjsXSDsABQEH7k5SpndTk26YM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=WWfkP6A9ppe4b4NCmefpSeqDV8hEW/IdrDKkuVi/hzXVnbifAVtTw5ETPVxcnqtwrrsavC4dcKkgGbyKniE3+OPE616O2YL/WXdrfUSFlAbLotc2rjLi0Z1SliTyF9zxUsw0PLjoMFXCF0UU9UEeD0BmJ1sd3JxxXmoQfnVsZ2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JgNG7buu; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgNG7buu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744706646; x=1776242646;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4kby0UlWeohDz+iqe8FjsXSDsABQEH7k5SpndTk26YM=;
  b=JgNG7buuIAxznH/o94VNZvm6h+Txe72ny82lZLuCDN2q7Ihj8RMyjjzk
   L0tBO84er6rddpPTeLLceD8oxQlcfAkTUkfCmJGU3ZUs1gqWxNdl3dQMo
   k0eMiiDyJMvXgxvuPSlvV7LZx5I0Ap/Vo5GZIWGQ/ZiYV6O59Be5yQ3J+
   BQ/GnoE5M3ujEk2sxzzF9MYqhKi1ymkcOq+C/anUjAcKPp2Id6YIti7Ru
   ricq7jp+jeWvIt45DXxSPMusKFwhHyQMJKHQQ7k07Ms0LAHYU+1LRDbEn
   Gsr18/Abqjc8MOWem/0Nc46RQOIJhJmXgYm9CEmMofCFttIqK2Cw1L7Ai
   w==;
X-CSE-ConnectionGUID: RJQAodnTTVO9P8QabVhRog==
X-CSE-MsgGUID: bMlKRAZCSJO2yqbdm3ySJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="48902862"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="48902862"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 01:44:05 -0700
X-CSE-ConnectionGUID: HQVqnBFcQuqLXx6ldSwvfA==
X-CSE-MsgGUID: XJCFT/3yRqu5foYwlPXlsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="153255363"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 01:44:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 01:44:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 01:44:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 01:44:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XfO4bMvfoDDbjo8J1wYBhX4llQd6wIoPwobt6a7TccRF+MoNFLr+HXI8fPwjSZZs657i+q6WUn96Z2yfSmPeJutt0Fu8yNiQhiGBntdnqGsKQ57+3pceoclg/HHytZVQGCNHDIbyIr4qDekZUGkr356oVBabVLrVNxSxA+s2hpPYrcksCozW1YEj4IA5Im1Ci9HTRtMPGgd5GHFxPGImeyDrpGfSugQUcwimccgJK5vu3MqKcZqRRK3ifpjjgU5BdnbI23zXRTW6rZ6HkladQvRAw5jdxsvQLQ6BdwsUIiCUXf0z/yjorybgz69QDwjsHcK1dH48eqirtdRyoGIWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sjx5OZdhlPVNEBxWzuTaUyCRVH5z4a0OoYbP5oF2B7M=;
 b=jC4JTrZCybxyj0HFsrlxEB6oEG/c5/ADHOg3pat1a6J1Oyd908ZNoYJxc2vRt6gJ/WbJppCBDvFyf4Ybpml+R/QBn2J34SJV2Ibh7Chsz5k4ZrMVTJnerGxOCwro2LaRdaa4Snwdl1aq9WgxLY0/tdIeaER2K3wBuEQZCr0R8B3IQW+foOI8/sa1VSJ1wlrWyvgXYH/cDxyWqFc//wANm0KTFhzOMUSpPsyfCSvx67x0R760A4Ykxn0ZYncLF7+97XXB6n3odUquw5nQ25ZqKNOiOMF1NMq9JXXI1dYu/Vtxslxq32IcWb/bXWBHthGQPd0vyrt6fYqcUkptQZnSQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB5925.namprd11.prod.outlook.com (2603:10b6:510:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 08:43:59 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8632.035; Tue, 15 Apr 2025
 08:43:59 +0000
Date: Tue, 15 Apr 2025 16:43:51 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [crypto]  08cabc7d3c:
 BUG:sleeping_function_called_from_invalid_context_at_crypto/acompress.c
Message-ID: <202504151654.4c3b6393-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 24b80975-cbfa-41e1-60bc-08dd7bf9aa95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tcc32EH3DlwzronGtFmbhXz0Q20yB+8AplOIbbrRRw3boJBuEkI+kBEmiH1A?=
 =?us-ascii?Q?5SvLb9w2SeVyByVwYXiWP8G4vt6YymJvMmQpeYzi5WzQPztlr5d68NOV5RJt?=
 =?us-ascii?Q?nWnpV9I6/knzeLUqxj2ovVuNbIQco6XY/yhUlOI7weSs0CjxI/O19zSAdRyY?=
 =?us-ascii?Q?pKx4JHDcE4fLYC+137EUnWuqceHrXReR2EvbwMCpjutBSXjO2aamCbTxu4uX?=
 =?us-ascii?Q?wtJYNpEkGQ/5x3LL2F4ze2vNM6xRxXDQXQ0gfiAokF6QvQsuksW2CRE/VfLO?=
 =?us-ascii?Q?dmGMHHWu/IwWRk/bHICI82pZIJARe5pKmZ8AwP5YgdHZomrmahEUTc+Ex1I1?=
 =?us-ascii?Q?KDDtyypBrtyhIRRzNX6fXiZMZB1JxpO1YKKSPsWJyvhFix856sSy+BQ6u22F?=
 =?us-ascii?Q?YdluYCdzF4nzaiHRfWI1JcUbBSsqqhODh58tz2Yp6RSXnl0WV6U0SJr/fMW5?=
 =?us-ascii?Q?M1wK9rCgvQs08VRCJWGtbbBifdEiRT79wZphRdgPH+QnjyY0UC0NHoqT8htT?=
 =?us-ascii?Q?/FgsbdjJsZRlxKHVPNmc/fbhia9xdwaLu8AS7mvHY9qQEiXaqXYVzAq9UoQo?=
 =?us-ascii?Q?94s9cxiygDLzpgs6dO6snZRBfqemVOcQ40iNCuODFS+FXvimxeKsOZZqlICs?=
 =?us-ascii?Q?Avq94dZKb8dWIZfd3hgyxZfs+v7QKkvH+0TjGZHOlRZWZNUAGJpiLdSW1VyN?=
 =?us-ascii?Q?v8v7f0xSRYKG6Vw8ap1fi09BAMHpY1XL4hnP7S5lROHbKyeA1lesr3C+RNRz?=
 =?us-ascii?Q?ZaSY8UwH/3OvGaC9ThUmxWHdR6hGBR9d+bawbex/f3jvOrArWmHBR+JzadiX?=
 =?us-ascii?Q?yuDNEwD3y7Db+JWlF0aPR5dJCeOr4Fyf6xKZnT5h9vG03kp1gZsnmeFlHPht?=
 =?us-ascii?Q?nvKdoLALJPNZBmHco4nyOgfv3TWckJpRGLaBiFypPJAJjbdCcSARl9X42lDF?=
 =?us-ascii?Q?j6Skl4l8vUSJD2mVlvJK7tbFnJCVLEW+93AfbLj3Tbe7Ubr9GLrHIZENkoxx?=
 =?us-ascii?Q?W77vwm2XjWqgqRO1ccg1EJZyhw88hlgs35F1MYoCaUl4KcRrLZ39U33fpKzT?=
 =?us-ascii?Q?wVUnFn1tXdob9gYMzNugT6f0yZj4ral4CNpsVmePU73MeGfNU32cr5EX7VeN?=
 =?us-ascii?Q?rqfZc3Zjhm7IdwblZpGDZS/VviyK1uyHDZeFLRtplndzcWszqLm8qtESGnLR?=
 =?us-ascii?Q?mbeJ2G5Mrc1gAo7EcUvbM4GcP08TzDHr+/TB5qSvwd0bYHsORzyqsIapQxFQ?=
 =?us-ascii?Q?kPM8RGK/tqKXjWnN0coR7ssa3PWpglVSoXorT9a33LOEndhAC/k+SWta+c3V?=
 =?us-ascii?Q?WN84WrBV8MFCG08+TFSVoP7gkWNkUaOXl6DjaZTzey4J4igF5SwKs9C/Ajl3?=
 =?us-ascii?Q?ErOMl632cdXVm/Ddr1b2ZO+vG18f?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+brNbr+NKdimcTNIIN3Sts8BVeVWHds28esDGZX1PEZyY5LcFpEHVi0r/kC?=
 =?us-ascii?Q?GvDJfO3yZSBmSOIRCndiHIBvpYrl9/Ipli0fCDQLUFWfEzrR4JRGkuULaucw?=
 =?us-ascii?Q?IZH/Q0YEG46ZV3LgDy+oHuPqmUaIxAdvDY5Jtng7MqVoupk44IhYD80fI6f/?=
 =?us-ascii?Q?HtnFs90LYCtnOGnmI1iVjpq7akr7zxspMgtgf5pGX1zpcZfIsRofwA7sAd2H?=
 =?us-ascii?Q?Pwft4A+jdacL9GFZBPWQZlD0nh+5/gk4HfQfA35uF6zP8TJtQEGxoIamJTSl?=
 =?us-ascii?Q?1RK3DRL4FCY/WmhT/hHhsdokPx2rMSBzhoTe9RbnAlhZPkjwuwZL+APK2wL6?=
 =?us-ascii?Q?lVxoiYFlvquzAFdrDcSxjLzGwdPl2uSKajeJfsySgqTpF0EDUarohjWIVCRU?=
 =?us-ascii?Q?qClgZwpw3059HDQrXTJPVJU4IobmB+ixGs4G2TIhWko20SNXGbjsgi+p+ysi?=
 =?us-ascii?Q?7gLTovuh2aqpc0KKQujPMSe4KsbvTwYepvkzBcOTeCozg/euxDGVjedev0B7?=
 =?us-ascii?Q?G05BTyAnKbNGdBZaY7FsDqV+U1roHCmaA1MbzkNUZfqcDfRwZwfqORhPUXAn?=
 =?us-ascii?Q?zEUVrSN15NAaGyF0DJUAW0NO568B4Zdr/XIhmDf10EHBGdB+3tU+BLLU9KNf?=
 =?us-ascii?Q?AJ26Oig5E4r9luEksLKLtMD5vKBd18qVpxp1I6/tcLxmPhJNgY7NyJV6e9mt?=
 =?us-ascii?Q?obr5EcecTmpbMTzS6JG//UNmojnj+gRq54iAtKVjlVgZgF7jBgph8WJNlcue?=
 =?us-ascii?Q?LnqKQfSxYcnK3pkr7sDPaacs7UhKIVWuADQKk8yOx2nS+b6HWEEeA2aKhvW/?=
 =?us-ascii?Q?DdM/ojTq1bu13YYsmX6iZKbMSvNav9kKTeke9xyqi87F5e6Y/chqjmIrTILB?=
 =?us-ascii?Q?t38R6FuAHSZMpG1Iai9icCCJc+uBgN21W5+IYUdccdp3kvp2HWTbCxE+rv98?=
 =?us-ascii?Q?za50deBaFs14CkAz4s9RzeOTZahy1VONTeoeoQNK75TUjzVwDJEscUoC0wS1?=
 =?us-ascii?Q?f/a7JFVFtOJHEAWro4MdjWMCBa+SxK3O46aJlalGqkCQADS8R4i/gyX5DG4Y?=
 =?us-ascii?Q?8v4e6G/wG5aeg1wc+9wb6wf7ZDgQO+x9uKuyHXsEbXRsxkHAZLsCoErgU5uK?=
 =?us-ascii?Q?wWdI3wejwath1BZ0OBZHZ1wj1UDnS1nc5LMcSdsDVK1Ef613FSPJ1tFJ9h5L?=
 =?us-ascii?Q?sKcUZiqsjK4xorqBE7w6eWNSmtvvENV1NH2LRMRctug/ifQlAeyeCBUkUUpg?=
 =?us-ascii?Q?2s6GhdUuQMcm4fdnb14VbsCiWJdlKEqtf2CThjP/caUQZarhqmJD0lQqkHkv?=
 =?us-ascii?Q?5/6bqfBWU9HTT42WdvYC0YILK5vs/Fs3tBRZdGlDtKpxlLi6nvs0NuCCg5fP?=
 =?us-ascii?Q?dtirM0EfOBKlThJvlr66xAsPBxQqwJ3DfJekequZYoK0jsvPnqGGur0dOda7?=
 =?us-ascii?Q?knm1hBDZbxJxqW5CNpg0m+/9Kp9+2huN1VjDEaWO82jxsYiILumQCNTmYpIc?=
 =?us-ascii?Q?mp+ijy/G35RKtAJIFGRzZjDx9L0gVfqyZuaTKTLh5aTzCvr8WZdy2N0XqsFp?=
 =?us-ascii?Q?LvAwNDxI7LFYAsySxHLRh0FkdO8QgNykC3YCWX+ZPouecUx9Jz+PMq+0mZ3y?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b80975-cbfa-41e1-60bc-08dd7bf9aa95
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 08:43:59.7048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QL39AZI9Nm1czZUR+5yOtpZ4f0gs6mnm++dhBcrm5tOryPGfQa6Vq7nHUCawVlbgJhsjisVzMxejue/7duHNhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5925
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_crypto/acompress.c" on:

commit: 08cabc7d3c8638b078e0ac2f755cead1defafe91 ("crypto: deflate - Convert to acomp")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 01c6df60d5d4ae00cd5c1648818744838bba7763]

in testcase: boot

config: x86_64-rhel-9.4-kunit
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-------------------------------------------------------------------------+------------+------------+
|                                                                         | 9c8cf58262 | 08cabc7d3c |
+-------------------------------------------------------------------------+------------+------------+
| BUG:sleeping_function_called_from_invalid_context_at_crypto/acompress.c | 0          | 18         |
+-------------------------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202504151654.4c3b6393-lkp@intel.com


[   58.372824][ T2699] BUG: sleeping function called from invalid context at crypto/acompress.c:569
[   58.373859][ T2699] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2699, name: cryptomgr_test
[   58.374847][ T2699] preempt_count: 201, expected: 0
[   58.375398][ T2699] RCU nest depth: 0, expected: 0
[   58.375942][ T2699] CPU: 0 UID: 0 PID: 2699 Comm: cryptomgr_test Not tainted 6.15.0-rc1-00008-g08cabc7d3c86 #1 PREEMPT(voluntary)
[   58.375948][ T2699] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   58.375951][ T2699] Call Trace:
[   58.375953][ T2699]  <TASK>
[ 58.375956][ T2699] dump_stack_lvl (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/lib/dump_stack.c:123 (discriminator 1)) 
[ 58.375965][ T2699] __might_resched (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/sched/core.c:8819) 
[ 58.375972][ T2699] acomp_walk_done_src (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/acompress.c:570) 
[ 58.375978][ T2699] deflate_compress_one (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/deflate.c:98) 
[ 58.375985][ T2699] ? __pfx_deflate_compress_one (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/deflate.c:58) 
[ 58.375990][ T2699] ? __asan_memset (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/mm/kasan/shadow.c:84) 
[ 58.375996][ T2699] deflate_compress (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/deflate.c:129) 
[ 58.376001][ T2699] test_acomp (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/testmgr.c:3390) 
[ 58.376007][ T2699] ? __pfx_test_acomp (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/testmgr.c:3330) 
[ 58.376011][ T2699] ? ___kmalloc_large_node (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/include/asm/irqflags.h:158 (discriminator 1) kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/vmstat.h:546 (discriminator 1) kbuild/obj/consumer/x86_64-rhel-9.4-kunit/mm/slub.c:4278 (discriminator 1)) 
[ 58.376022][ T2699] ? crypto_alloc_tfm_node (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/api.c:634) 
[ 58.376027][ T2699] alg_test_comp (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/crypto/acompress.h:182 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/crypto/acompress.h:233 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/testmgr.c:3615) 
[ 58.376030][ T2699] ? __switch_to (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/include/asm/bitops.h:55 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/asm-generic/bitops/instrumented-atomic.h:29 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/thread_info.h:97 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/sched.h:2036 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/include/asm/fpu/sched.h:68 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/kernel/process_64.c:674) 
[ 58.376035][ T2699] alg_test (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/testmgr.c:5876) 
[ 58.376040][ T2699] ? __pfx_alg_test (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/testmgr.c:5829) 
[ 58.376043][ T2699] ? __pfx___schedule (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/sched/core.c:6646) 
[ 58.376047][ T2699] ? try_to_wake_up (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/sched/core.c:4332) 
[ 58.376052][ T2699] ? _raw_spin_lock_irqsave (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/include/asm/atomic.h:107 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/atomic/atomic-arch-fallback.h:2170 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/atomic/atomic-instrumented.h:1302 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/asm-generic/qspinlock.h:111 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/spinlock.h:187 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/include/linux/spinlock_api_smp.h:111 kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/locking/spinlock.c:162) 
[ 58.376056][ T2699] ? __pfx__raw_spin_lock_irqsave (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/locking/spinlock.c:161) 
[ 58.376060][ T2699] ? __pfx_cryptomgr_test (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/algboss.c:174) 
[ 58.376065][ T2699] cryptomgr_test (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/crypto/algboss.c:181) 
[ 58.376069][ T2699] kthread (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/kthread.c:464) 
[ 58.376074][ T2699] ? __pfx_kthread (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/kthread.c:413) 
[ 58.376078][ T2699] ? __pfx__raw_spin_lock_irq (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/locking/spinlock.c:169) 
[ 58.376082][ T2699] ? __pfx_kthread (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/kthread.c:413) 
[ 58.376086][ T2699] ret_from_fork (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/kernel/process.c:159) 
[ 58.376092][ T2699] ? __pfx_kthread (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/kernel/kthread.c:413) 
[ 58.376096][ T2699] ret_from_fork_asm (kbuild/obj/consumer/x86_64-rhel-9.4-kunit/arch/x86/entry/entry_64.S:258) 
[   58.376103][ T2699]  </TASK>


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250415/202504151654.4c3b6393-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

