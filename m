Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA26C3A9605;
	Wed, 15 Jul 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127671; cv=fail; b=G3SdB7F7iZSMdhd0zbR5sEhlls3GNubQItRi4Yovgz/0ETLc1KlUV1M/rPgh4YY0yflJCP68ndtcgaV1bPWBbxpnOQQ2y5SsEWJOBoe5rBTJW2hQx8Zg4WbT3EMEdtYL4yct2K6Rd18/8skAEgBxTkxf0tIi+QAIOsASUzH7RPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127671; c=relaxed/simple;
	bh=6Uet6feZ5MwYSCAJzny+q+65PdMVjWnMl0DYnQuk18k=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=svFut7iDvT4aNL/wypXWk8MrDudWmgjLo/Mae28XtIfQhyX2S8yayXX55GxIsdOGWt4BWHYUMYKbmWXuBUQXTrJfJJviBD992g5wRR3V7FOZt6lDMyeNoWKRVpdYqtOrUSyOmCs6isEJL4NBoyuX+zZsFbp6ACVdKpLJgN+IKYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HhYIZNvS; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HhYIZNvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784127664; x=1815663664;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=6Uet6feZ5MwYSCAJzny+q+65PdMVjWnMl0DYnQuk18k=;
  b=HhYIZNvSQohpsOMlxmpQiT2K2AcXJbjiZfcMPROXFfR9UcY/tODe3nA3
   jmbfF0Lmdz7J1knjo2e1b9IlZGrNFA1yxYxG0Sm/+tWMPht/1KE6XrXJV
   ge1lXJ0QJ5uXPki6L1ugoBdzczE3E/OozsQ7bz+G2bRy+z44s95j6ohhV
   4eVa5Xbg5Fbu49wci1/95zOfAqtSO31W5Djuce7dg1/nLXKT8Pwwx92vq
   dAGFAhwaOOJyn6G04dr7dwrw3wnpUIgg5nEMRXpzWBzp0HUbhJfeA8EEU
   1lpkBv24xObaVV5QAdWocBCWwYPwvtV/MZG0CXc+blXuuSJZ6U1YDDAfn
   A==;
X-CSE-ConnectionGUID: HyTECdVJSaikuEqf2axzCQ==
X-CSE-MsgGUID: bSaCtXmPSbKpJeIJ9iJglg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87311095"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="87311095"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 08:01:02 -0700
X-CSE-ConnectionGUID: ObJ0DfmkRXW22+/Zn0ujLw==
X-CSE-MsgGUID: lB6EHI/fQ5mMoGu879qaWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="252810124"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 08:01:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 15 Jul 2026 08:01:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 15 Jul 2026 08:01:01 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.39) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 15 Jul 2026 08:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YxHcCdNIrRl+6fjM8Br+rgRBe97X9YGGevUjJU18Bo6aj1gNXBl6ZIsSD3YpGci7j4a59LAlSDtcvunaua1UPx+oT9UJNAwaqhEBOv65ntAZqz4DR0kNeUwe/F7GxhDrSBefuPN8IlPhXniFvuCPnvwAZHcpT6HtzqwHj3j34bn//ts9lmeDxibCFavlsvJ8MJZzHV9nb/mI0arUINtg/MGfy1PKIkrrR5QmkjMOe/yOxd5Wq0GTu1eExfjx6/oZHomWCc6xtiv56cUe9RFkgievaE1FWCwBRTN5m9ll+n3xJIRFbAiaYGBHknSHmHr9u+r8ek9FGC3XM9dhypPojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muYoSsBT58wyCtiMGZL7C44TP5naF5BwcjzNSQQOU4Q=;
 b=PjXXUY8wdDswFoQQc/+LBndsS/P7HNnT9BEcQo6VeNBEYsjD34lzduiu/jPmWpO/w19zvjrh8HPkHK3uSTHT71OHrZBTY2rQ2F+s25A47n5W9hu7q8pi4ZyPHC3lgirmSYmYo5x2+cB9AO61NlP80lRUTd2VR2ic1qX7dY4l5tFeWmr/YDaFSJKgr++iEyAv30jchDD056hDxBdZAbB2wnz8ALZ7wmGK0coeEHxBoUl4Nr9Br2tpWnCN6b0TAwChmM5GRKws5wUYdh1xnmckSJxbENBgmA899jmA9POGtrrar6O4zWOgGzEhuvwlZIZq6OpyrQLBVSCAX+P61lxzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 15:00:57 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 15:00:57 +0000
Date: Wed, 15 Jul 2026 23:00:46 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, <linux-doc@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [crypto]  2f204fe718:
 stress-ng.af-alg.ops_per_sec 113.7% improvement
Message-ID: <202607152204.a0a3bf98-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e472a71-eac0-4a6a-f2e3-08dee281e011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|3023799007|18002099003|10067099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: ynVaVyIX9/sC9OIwIWRNChgADL46km4tM+xUVMwkA+MsoKP7Cfcafm8YSdgrAKckOVcYr4UV6eMDQpAEtNis9UkgJjc+P2we8FV5sfB9aLMfrSBXL++ERlrbif/jFBM3h/5KB/Ta+SeQ1ZHRzgXzSM0/OQulV0jXg/g8j1mK2e6im0zxSvs+bYHUYHDLF+YPTeiVINXcTaTjMu195p0BL2fdDnw6UP3Ev2M4GG4rI+jhE4GcN7smHzQOMxfvcMoFj3xLwi5Sjb6fVOeNcF0OTrdNO9jL/dTu8+unl2gbQPL9dvt8KstrE/N6lYC8Xq17HOTZQtD6IwVikFS+GHaHybyzExucSHYJ5kbuTCpCJrq70SoDF2xeqDILn+XlI5JIKbWw+G3zhI2/MyCpit7EbJO95DFyvHG60qjkKKcMfcZABzG7n27jIbtjGQ2WME92psRH5/ck77uOej0YHJzTY9p0xCUg7rTH5G02aGWyQM0gL6cw0HnFGqGb+zVfGfWEVtrbgT6x66oacEDAZ5AMEeo0d6luUg1Ns1CTGdNXBdFBPj8fCUapP4gwPNp+uVG8DkFQ58YhzC8pl82UB6p7v8BkRuo8PqCD/SWj0BkXpAvr0cRxuOGQRJqdDRN5/d4G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(3023799007)(18002099003)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AjH6oxwbWafPOJ8OGcjnk1+Sx97x/eN9L3wdGY13cA+2Rcn/gMn+Go0lYm?=
 =?iso-8859-1?Q?evdLTEoFxzdRHsM31OmqKAWKC933FJnM6WqlycuDV/TKdDX6Q+mg3Y0njT?=
 =?iso-8859-1?Q?skjZaqFUHR97uIiRtJt3TUMAb4XeYEFUu8eGaKB7NvBf8DmXhs+oI2cErw?=
 =?iso-8859-1?Q?MznWu5zUyfVEw6I4zdXUtlZ5DLsQwnU1wYvLu4xvFB2kv8VRPe1yOvI8EL?=
 =?iso-8859-1?Q?KcSjaO7ndBF13IOusvVhwOYfHQmSI43DhGuMXBJ1PMUPq8vNDdsmOK7QRI?=
 =?iso-8859-1?Q?YWx5ZSZkAq36h7sMGkrewlcMoN9GBIiYl0RJmTezLrdjih+TFjU6UAoQm/?=
 =?iso-8859-1?Q?WLUBDTgRX3xVi9bKBZv6n16/VMEsVJX+yP9WQNw/yq+5iL8Ob7m2zDqAYK?=
 =?iso-8859-1?Q?tgKiO7dbx1+Sggz5fqxRAa100dqoRxq5Vos4/KzQpWOEGT3b+EQgOyASly?=
 =?iso-8859-1?Q?Vcdpo8h7Z5m1m0zU5KXtF8cC4H1IiocZP+6splWnBITGqsWgv4Gh0kTRmt?=
 =?iso-8859-1?Q?qN48h5k9T+jQLPVGcMK7IEv37Ld5GXkBmh+EZYker8vBo+x7okYeRbf/vb?=
 =?iso-8859-1?Q?1RYqTUfcYoB36RnwqfeYnusQdxlN5F8YdS7FMw20Pukmx8yvvNbW34DS6M?=
 =?iso-8859-1?Q?kuVbTC50CZMjToLI0e62VAdZ1vJ5YaTA2ztdnf5s3ztVjqdr8pVyks3YRm?=
 =?iso-8859-1?Q?IMZoHE3or98HeBW3QDgEqIqeA9Z6KYsE0dB2i9eyWrAFuNXBpw/0jCzZeD?=
 =?iso-8859-1?Q?ccVphWnrLzZD9jkVYXdNGLI9WRbdO2Qe9rVm+FOeMJEbgfxibYkp7TgyWk?=
 =?iso-8859-1?Q?KWV1BpFcbxP/Y4ZZB9iZfVOhkdzJViCuowFqxXD0wmRTcaqG7fWdnKZrlE?=
 =?iso-8859-1?Q?HQAN0wdn+KrMOj/46iG1cLssDdhtNl2swQ9Ph4UFjB/1xjtr+0cJ4QsOmg?=
 =?iso-8859-1?Q?w3En+aW+NUSPmgjPR1596LfZkGk3gkVzCSdiE8eeFbaHEbeFfr+4qfHrKu?=
 =?iso-8859-1?Q?UkYOfh3nz2PrTHZXeAna8aDdiAf4eoY7CEcqkfpA2Ckuk6mW3Cde/JCV3D?=
 =?iso-8859-1?Q?q5IM3NxEVod/QTZqKCqMs4gww8URIRNjEHiOkeSLh75jebAjObgl40Ub0z?=
 =?iso-8859-1?Q?ddYGmauYv7h2iGA4vyM1yZhD1MceJ6WtDJg6EvJvNA2pku/OsEHpOSaFPX?=
 =?iso-8859-1?Q?doccWdiunUYVXs/vwph0nGQhZe5SBrBK8Fck2v1yiQVk+34kkmjVY8fnNO?=
 =?iso-8859-1?Q?zmhzyuwpgKamljpSuvPui9CSqkww4ezmYW9PAmyzB7lnsHMlAccCpdjXAl?=
 =?iso-8859-1?Q?nmeuAGYWTlmd085SCJ0SlmEYt05qyfiYLng30uOrIL+AG4uXpgTCyDr8vX?=
 =?iso-8859-1?Q?NrKaGtKzQ0UbAp3Sz8FMjLFAf8laFlhuncDDuEx5qjGSuFBtv/qZZ44Sbb?=
 =?iso-8859-1?Q?g+pfJ3I3wu90L0mARPHYtbIPbny89u6nvw4+6UM11sLsJ6H0Pslhgn3z6d?=
 =?iso-8859-1?Q?sS8lbkNHho52BkD905DhU1RycU/YBovMPNbM2IVvC01Sq1sI8U6SliQQN8?=
 =?iso-8859-1?Q?b1kQRW/Sx3nhnuQ3irkoG79ayx81DfKKe/0+20wAnJYs5b46/Ey+HHeiUt?=
 =?iso-8859-1?Q?fLWl+2c5uCYSmcy4SPRHDlX89/XDaTdyFTHVZFY4aNjrmxt6umxe04DmIB?=
 =?iso-8859-1?Q?V9qfmOH3Tcz0Vg2HPvj3V1PVIHCve39nL8V/i8atoahca9Tp5OCeW6VZDE?=
 =?iso-8859-1?Q?CzUE8Q9w8+8FCerhQORiwK0KBSLTF+gxIaytaruBL2rZbVsrPEhKQ+R7uy?=
 =?iso-8859-1?Q?BqGn6rkABw=3D=3D?=
X-Exchange-RoutingPolicyChecked: DsG150F6hoWzHYF+SOxOnzMQ0yybjI86V1TVCt22vcjJGjZDo3UJbCV9FXhV4sp2bzAd/9Fvi+xzVwS6PiBkqqsLrcpsRnpaDNJMz0D7HdKkTQdph1XGtQ1U0L+2/uL8z6r96kXxUrSpXOaysZXKE/pIiitmzGRBHq9oiSk1W5mzMBQKQoGaNkcdOqXSJSQ+7jzFa2gVEP1INXvpPgFHRnwFZnvm1mFP7wDszVvglDEtt6oEvhEaaCOl0rmKlmoqkgPrZnDgZdSM03HBqz+GanSqSmCI+qlsIIt4OHuVDlE7P+k3MEIQY7g4lUjyfrm3R/mgGUMit45Qb1TMJc75tg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e472a71-eac0-4a6a-f2e3-08dee281e011
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 15:00:57.6728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4upsOkKXmFOjH+L4O2upT6lYmgP+gvE0czEQK3ZgN3TIlqJD6SChQbPRM+sWR5WtD8J5r9d/2PCqE6csDr5lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com



Hello,


we don't have enough knowledge to deeply analyze the impact of this commit
to stress-ng.af-alg performance tests.

along with the major kpi improvement:

   7756377          +113.7%   16578454        stress-ng.af-alg.ops_per_sec

we also noticed lots of misc tests seem have changes, e.g.

    697423            -9.5%     630908 ±  2%  stress-ng.af-alg.aes_cipher_ops/sec
    245103          -100.0%       0.00        stress-ng.af-alg.blowfish_cipher_ops/sec
    369646          -100.0%       0.00        stress-ng.af-alg.camellia_cipher_ops/sec
    162192          -100.0%       0.00        stress-ng.af-alg.cast5_cipher_ops/sec
    115113          -100.0%       0.00        stress-ng.af-alg.cast6_cipher_ops/sec

we don't know if these are expected behavior upon 2f204fe718.
so this report is just FYI what we observed in our tests.



kernel test robot noticed a 113.7% improvement of stress-ng.af-alg.ops_per_sec on:


commit: 2f204fe718f5bf519013cc2536ad7bb2cbb51661 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: af-alg
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+-----------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.af-alg.ops_per_sec 94.8% improvement |
| test parameters  | cpufreq_governor=performance                              |
|                  | nr_threads=100%                                           |
|                  | test=af-alg                                               |
|                  | testtime=60s                                              |
+------------------+-----------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260715/202607152204.a0a3bf98-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/af-alg/stress-ng/60s

commit: 
  7e28b0a5c4 ("crypto: qce - Remove unsafe/deprecated algorithms")
  2f204fe718 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")

7e28b0a5c4b7d075 2f204fe718f5bf519013cc2536a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    697423            -9.5%     630908 ±  2%  stress-ng.af-alg.aes_cipher_ops/sec
    245103          -100.0%       0.00        stress-ng.af-alg.blowfish_cipher_ops/sec
    369646          -100.0%       0.00        stress-ng.af-alg.camellia_cipher_ops/sec
    162192          -100.0%       0.00        stress-ng.af-alg.cast5_cipher_ops/sec
    115113          -100.0%       0.00        stress-ng.af-alg.cast6_cipher_ops/sec
    695785            -4.5%     664436 ±  2%  stress-ng.af-alg.cbc_aes_skcipher_ops/sec
    238486          -100.0%       0.00        stress-ng.af-alg.cbc_blowfish_skcipher_ops/sec
    360669          -100.0%       0.00        stress-ng.af-alg.cbc_camellia_skcipher_ops/sec
    164699          -100.0%       0.00        stress-ng.af-alg.cbc_cast5_skcipher_ops/sec
    116735          -100.0%       0.00        stress-ng.af-alg.cbc_cast6_skcipher_ops/sec
     65406           -17.9%      53687        stress-ng.af-alg.cbc_des_skcipher_ops/sec
    320814          -100.0%       0.00        stress-ng.af-alg.cbc_serpent_skcipher_ops/sec
     69021          -100.0%       0.00        stress-ng.af-alg.cbc_sm4_skcipher_ops/sec
    214626          -100.0%       0.00        stress-ng.af-alg.cbc_twofish_skcipher_ops/sec
    642571          -100.0%       0.00        stress-ng.af-alg.chacha20_skcipher_ops/sec
    891131          -100.0%       0.00        stress-ng.af-alg.cipher_null_cipher_ops/sec
   1337159          -100.0%       0.00        stress-ng.af-alg.crc32_shash_ops/sec
   1501487          -100.0%       0.00        stress-ng.af-alg.crc32c_shash_ops/sec
    761754            -8.9%     694046 ±  2%  stress-ng.af-alg.ctr_aes_skcipher_ops/sec
     91060          -100.0%       0.00        stress-ng.af-alg.ctr_blowfish_skcipher_ops/sec
    104238          -100.0%       0.00        stress-ng.af-alg.ctr_camellia_skcipher_ops/sec
    115937          -100.0%       0.00        stress-ng.af-alg.ctr_cast5_skcipher_ops/sec
     89670          -100.0%       0.00        stress-ng.af-alg.ctr_cast6_skcipher_ops/sec
     28897          -100.0%       0.00        stress-ng.af-alg.ctr_des3_ede_skcipher_ops/sec
     72715          -100.0%       0.00        stress-ng.af-alg.ctr_des_skcipher_ops/sec
     74812          -100.0%       0.00        stress-ng.af-alg.ctr_serpent_skcipher_ops/sec
     79546          -100.0%       0.00        stress-ng.af-alg.ctr_sm4_skcipher_ops/sec
    145591          -100.0%       0.00        stress-ng.af-alg.ctr_twofish_skcipher_ops/sec
    671291          -100.0%       0.00        stress-ng.af-alg.cts_cbc_aes_skcipher_ops/sec
     68084          -100.0%       0.00        stress-ng.af-alg.cts_cbc_sm4_skcipher_ops/sec
     29465          -100.0%       0.00        stress-ng.af-alg.des3_ede_cipher_ops/sec
     75277            -4.0%      72278        stress-ng.af-alg.des_cipher_ops/sec
    699558            -9.3%     634761        stress-ng.af-alg.ecb_aes_skcipher_ops/sec
    246967          -100.0%       0.00        stress-ng.af-alg.ecb_blowfish_skcipher_ops/sec
    369920          -100.0%       0.00        stress-ng.af-alg.ecb_camellia_skcipher_ops/sec
    163784          -100.0%       0.00        stress-ng.af-alg.ecb_cast5_skcipher_ops/sec
    115786          -100.0%       0.00        stress-ng.af-alg.ecb_cast6_skcipher_ops/sec
    896443          -100.0%       0.00        stress-ng.af-alg.ecb_cipher_null_skcipher_ops/sec
     29501          -100.0%       0.00        stress-ng.af-alg.ecb_des3_ede_skcipher_ops/sec
     75654            -2.8%      73539        stress-ng.af-alg.ecb_des_skcipher_ops/sec
    326245          -100.0%       0.00        stress-ng.af-alg.ecb_serpent_skcipher_ops/sec
     81526          -100.0%       0.00        stress-ng.af-alg.ecb_sm4_skcipher_ops/sec
    215554          -100.0%       0.00        stress-ng.af-alg.ecb_twofish_skcipher_ops/sec
    720125 ±  3%    -100.0%       0.00        stress-ng.af-alg.gcm_aes_aead_ops/sec
     72857          -100.0%       0.00        stress-ng.af-alg.gcm_sm4_aead_ops/sec
    532.66          -100.0%       0.00        stress-ng.af-alg.jitterentropy_rng_rng_ops/sec
    527374          -100.0%       0.00        stress-ng.af-alg.lrw_aes_skcipher_ops/sec
    315024          -100.0%       0.00        stress-ng.af-alg.lrw_camellia_skcipher_ops/sec
    109568          -100.0%       0.00        stress-ng.af-alg.lrw_cast6_skcipher_ops/sec
    283462          -100.0%       0.00        stress-ng.af-alg.lrw_serpent_skcipher_ops/sec
    194288          -100.0%       0.00        stress-ng.af-alg.lrw_twofish_skcipher_ops/sec
    867883           -11.8%     765839 ±  2%  stress-ng.af-alg.md4_shash_ops/sec
    673309            -2.8%     654759        stress-ng.af-alg.md5_shash_ops/sec
 4.651e+08          +113.8%  9.941e+08        stress-ng.af-alg.ops
   7756377          +113.7%   16578454        stress-ng.af-alg.ops_per_sec
    735183          -100.0%       0.00        stress-ng.af-alg.rfc3686_ctr_aes_skcipher_ops/sec
    360499          -100.0%       0.00        stress-ng.af-alg.rmd160_shash_ops/sec
    328809          -100.0%       0.00        stress-ng.af-alg.serpent_cipher_ops/sec
    887090            -4.6%     846645 ±  2%  stress-ng.af-alg.sha1_shash_ops/sec
    910035            -3.3%     879831        stress-ng.af-alg.sha224_shash_ops/sec
    913992            -3.4%     883116        stress-ng.af-alg.sha256_shash_ops/sec
    221685          -100.0%       0.00        stress-ng.af-alg.sha3-384_shash_ops/sec
    165917          -100.0%       0.00        stress-ng.af-alg.sha3-512_shash_ops/sec
     81712          -100.0%       0.00        stress-ng.af-alg.sm4_cipher_ops/sec
   3919240          -100.0%       0.00        stress-ng.af-alg.stdrng_rng_ops/sec
    217563          -100.0%       0.00        stress-ng.af-alg.twofish_cipher_ops/sec
    197101          -100.0%       0.00        stress-ng.af-alg.wp256_shash_ops/sec
    198136          -100.0%       0.00        stress-ng.af-alg.wp384_shash_ops/sec
    198629          -100.0%       0.00        stress-ng.af-alg.wp512_shash_ops/sec
    650714          -100.0%       0.00        stress-ng.af-alg.xchacha12_skcipher_ops/sec
    591703          -100.0%       0.00        stress-ng.af-alg.xchacha20_skcipher_ops/sec
    767692          -100.0%       0.00        stress-ng.af-alg.xctr_aes_skcipher_ops/sec
    308770          -100.0%       0.00        stress-ng.af-alg.xts_camellia_skcipher_ops/sec
    108533          -100.0%       0.00        stress-ng.af-alg.xts_cast6_skcipher_ops/sec
    275830          -100.0%       0.00        stress-ng.af-alg.xts_serpent_skcipher_ops/sec
     77237          -100.0%       0.00        stress-ng.af-alg.xts_sm4_skcipher_ops/sec
    194950          -100.0%       0.00        stress-ng.af-alg.xts_twofish_skcipher_ops/sec
   1563672          -100.0%       0.00        stress-ng.af-alg.xxhash64_shash_ops/sec
     68461          +126.8%     155291 ±  4%  stress-ng.time.involuntary_context_switches
     55906 ±  3%     -19.3%      45105 ±  7%  stress-ng.time.minor_page_faults
     22639           +11.3%      25205        stress-ng.time.percent_of_cpu_this_job_got
     12857            +7.3%      13801        stress-ng.time.system_time
    769.06           +76.6%       1357        stress-ng.time.user_time
    122787           -96.3%       4579 ± 11%  stress-ng.time.voluntary_context_switches
 1.917e+09 ± 16%     -64.2%  6.864e+08 ±  9%  cpuidle..time
   1480040 ±  2%     -93.2%     100145 ± 10%  cpuidle..usage
     15.13 ±  8%     -56.3%       6.62        vmstat.cpu.id
    219.34            +9.8%     240.79        vmstat.procs.r
     17547 ±  2%     -63.5%       6412 ±  4%  vmstat.system.cs
 3.861e+08           +65.9%  6.405e+08        numa-numastat.node0.local_node
 3.862e+08           +65.9%  6.407e+08        numa-numastat.node0.numa_hit
 3.744e+08           +71.4%  6.417e+08        numa-numastat.node1.local_node
 3.746e+08           +71.3%  6.418e+08        numa-numastat.node1.numa_hit
    189.17 ± 11%     -18.9%     153.33 ±  8%  perf-c2c.DRAM.local
      1905 ± 12%     +20.5%       2297 ±  6%  perf-c2c.DRAM.remote
      3226 ± 13%     +61.9%       5225 ±  5%  perf-c2c.HITM.local
    965.33 ± 13%     +56.6%       1512 ±  7%  perf-c2c.HITM.remote
      4192 ± 13%     +60.7%       6737 ±  5%  perf-c2c.HITM.total
     12.25 ± 12%      -8.8        3.49        mpstat.cpu.all.idle%
      0.71 ±  2%      -0.2        0.49 ±  2%  mpstat.cpu.all.irq%
      0.17            +0.0        0.19 ±  2%  mpstat.cpu.all.soft%
     81.59            +5.5       87.06        mpstat.cpu.all.sys%
      5.28            +3.5        8.77        mpstat.cpu.all.usr%
      9.00           -55.6%       4.00 ± 20%  mpstat.max_utilization.seconds
  1.95e+08 ±  3%    +198.7%  5.825e+08 ± 26%  numa-vmstat.node0.nr_foll_pin_acquired
  1.95e+08 ±  3%    +198.7%  5.825e+08 ± 26%  numa-vmstat.node0.nr_foll_pin_released
 3.862e+08           +65.9%  6.407e+08        numa-vmstat.node0.numa_hit
 3.861e+08           +65.9%  6.405e+08        numa-vmstat.node0.numa_local
   1.9e+08 ±  5%    +201.7%  5.732e+08 ± 30%  numa-vmstat.node1.nr_foll_pin_acquired
   1.9e+08 ±  5%    +201.7%  5.732e+08 ± 30%  numa-vmstat.node1.nr_foll_pin_released
 3.746e+08           +71.3%  6.418e+08        numa-vmstat.node1.numa_hit
 3.744e+08           +71.4%  6.417e+08        numa-vmstat.node1.numa_local
   1411517 ±  3%      -8.9%    1286468        meminfo.Active
   1411517 ±  3%      -8.9%    1286468        meminfo.Active(anon)
  56168126            +6.8%   59960507 ±  3%  meminfo.DirectMap1G
  13462615 ±  7%     -27.5%    9764268 ± 20%  meminfo.DirectMap2M
    387026 ±  3%     -24.3%     292992 ±  6%  meminfo.DirectMap4k
    175544            +6.7%     187261        meminfo.KReclaimable
    315400 ±  4%     -17.9%     258792 ±  7%  meminfo.Mapped
   8955634            -5.5%    8462157        meminfo.Memused
    175544            +6.7%     187261        meminfo.SReclaimable
    646847 ±  6%     -15.9%     543994 ±  2%  meminfo.Shmem
     19437 ±  2%     -68.0%       6220 ±  4%  perf-stat.i.context-switches
      1657           -71.4%     474.53        perf-stat.i.cpu-migrations
     49.18 ±  4%     -97.0%       1.50 ± 13%  perf-stat.i.major-faults
    229800 ±  2%     -93.4%      15108 ±  5%  perf-stat.i.minor-faults
    229849 ±  2%     -93.4%      15109 ±  5%  perf-stat.i.page-faults
     17689 ±  2%     -65.4%       6120 ±  4%  perf-stat.ps.context-switches
      1518           -69.3%     465.63        perf-stat.ps.cpu-migrations
     44.10 ±  4%     -96.8%       1.42 ± 13%  perf-stat.ps.major-faults
    206237 ±  2%     -92.8%      14868 ±  5%  perf-stat.ps.minor-faults
    206281 ±  2%     -92.8%      14869 ±  5%  perf-stat.ps.page-faults
     35935 ±  3%     +12.9%      40575 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.avg
     27019 ±  5%     +19.2%      32216 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.min
     28.22 ± 12%     +74.0%      49.12 ± 42%  sched_debug.cfs_rq:/.util_est.avg
     35935 ±  3%     +12.9%      40575 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.avg
     27019 ±  5%     +19.2%      32216 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.min
    328465 ± 40%     -62.5%     123124 ± 43%  sched_debug.cpu.avg_idle.min
     47.33 ± 17%     -39.6%      28.58 ± 13%  sched_debug.cpu.clock.stddev
      5757            -8.8%       5250 ±  2%  sched_debug.cpu.curr->pid.avg
     35667           -67.3%      11660        sched_debug.cpu.curr->pid.max
      4038           +11.7%       4509 ± 10%  sched_debug.cpu.curr->pid.min
      2546 ± 14%     -64.2%     910.96 ±  8%  sched_debug.cpu.curr->pid.stddev
      0.00 ± 12%     -36.2%       0.00 ± 15%  sched_debug.cpu.next_balance.stddev
      3715 ±  2%     -35.4%       2400 ±  9%  sched_debug.cpu.nr_switches.avg
      2104 ±  6%     -55.4%     938.83 ± 16%  sched_debug.cpu.nr_switches.min
    352445 ±  3%      -8.7%     321795        proc-vmstat.nr_active_anon
    192458            -3.0%     186632        proc-vmstat.nr_anon_pages
   1186421            -2.1%    1161291        proc-vmstat.nr_file_pages
 3.845e+08 ±  3%    +200.2%  1.154e+09 ± 28%  proc-vmstat.nr_foll_pin_acquired
 3.845e+08 ±  3%    +200.2%  1.154e+09 ± 28%  proc-vmstat.nr_foll_pin_released
     50743            -2.6%      49426        proc-vmstat.nr_kernel_stack
     78630 ±  4%     -17.6%      64812 ±  7%  proc-vmstat.nr_mapped
    161287 ±  6%     -15.6%     136166 ±  2%  proc-vmstat.nr_shmem
     43884            +6.7%      46816        proc-vmstat.nr_slab_reclaimable
    131569            -1.8%     129253        proc-vmstat.nr_slab_unreclaimable
    352445 ±  3%      -8.7%     321795        proc-vmstat.nr_zone_active_anon
 7.608e+08           +68.6%  1.282e+09        proc-vmstat.numa_hit
 7.605e+08           +68.6%  1.282e+09        proc-vmstat.numa_local
      3520 ±  9%     -22.5%       2727 ±  9%  proc-vmstat.numa_pages_migrated
 7.608e+08           +68.5%  1.282e+09        proc-vmstat.pgalloc_normal
  12990982           -91.9%    1046211 ±  4%  proc-vmstat.pgfault
   7.6e+08           +68.6%  1.282e+09        proc-vmstat.pgfree
      3520 ±  9%     -22.5%       2727 ±  9%  proc-vmstat.pgmigrate_success
     37787            +4.1%      39342        proc-vmstat.pgreuse
      0.38 ± 18%     +53.1%       0.59 ± 16%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      0.31 ± 16%     -77.6%       0.07 ± 32%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.13 ± 12%     -80.7%       0.02 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.07 ± 31%     -80.2%       0.01 ± 35%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.74 ± 52%    -100.0%       0.00 ±223%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.13 ± 56%     -84.2%       0.02 ± 27%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
      0.15 ± 18%     -82.6%       0.03 ± 26%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.03 ± 53%     -67.2%       0.01 ± 69%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].stress_af_alg
      0.04 ± 47%     -65.3%       0.01 ± 38%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.stress_rndbuf.stress_af_alg
      0.22 ±121%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__blowfish_dec_blk_4way
      0.27 ± 43%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__serpent_encrypt
      0.16 ± 73%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.04 ± 71%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_get_nstime
      0.16 ± 65%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      0.12 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      0.19 ± 15%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.20 ± 75%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      0.16 ±  6%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.25 ± 87%     -72.7%       0.07 ±150%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt._skcipher_recvmsg
      0.80 ±130%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      0.53 ± 49%     -89.6%       0.05 ±114%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt._skcipher_recvmsg
      0.39 ± 63%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      0.36 ±  6%     -84.5%       0.06 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ±223%   +4091.7%       0.34 ±102%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.sock_kfree_s.af_alg_free_resources
      0.30 ± 14%     -93.2%       0.02 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.24 ±  7%     -90.0%       0.02 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.78 ±  9%     -39.6%       0.47 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.32 ±  3%     -90.8%       0.03 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     14.84 ± 23%     -77.4%       3.36 ± 10%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      2.49 ± 18%     -42.0%       1.45 ± 65%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      1.09 ± 77%    -100.0%       0.00 ±223%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.01 ±141%    +108.7%       0.02 ± 79%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.bind.stress_af_alg
      0.52 ±126%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__blowfish_dec_blk_4way
      2.14 ± 44%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__serpent_encrypt
      1.50 ± 64%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.49 ±183%    +312.3%       2.01 ± 46%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_decrypt2
      1.21 ± 13%     -54.4%       0.55 ± 67%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.fold_vm_zone_numa_events
      0.07 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_get_nstime
      1.95 ± 43%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      1.57 ± 74%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      3.69 ± 12%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      2.12 ± 68%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      4.71 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      1.36 ± 86%     -85.2%       0.20 ±151%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt._skcipher_recvmsg
      1.70 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      2.43 ± 33%     -91.0%       0.22 ±157%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt._skcipher_recvmsg
      1.82 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      0.01 ±223%   +7690.0%       0.78 ±131%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.sock_kfree_s.af_alg_free_resources
      1.01           -94.6%       0.05 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.25 ± 11%     -80.7%       0.05 ± 19%  perf-sched.total_sch_delay.average.ms
    166.36 ±  2%     -35.2%     107.80 ±  9%  perf-sched.total_wait_and_delay.average.ms
     13558 ±  2%    +143.0%      32951 ±  9%  perf-sched.total_wait_and_delay.count.ms
    166.11 ±  2%     -35.1%     107.75 ±  9%  perf-sched.total_wait_time.average.ms
     41.96 ± 23%     +86.9%      78.40 ±  7%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
     10.39 ± 96%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      1.64 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.05 ± 36%     -80.0%       0.41 ± 23%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.14 ± 30%     -80.4%       0.03 ± 35%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.30 ± 18%     -82.7%       0.05 ± 26%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.39 ± 15%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.33 ±  6%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
    380.25 ±  9%     +27.8%     485.92 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
      3.21 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
    586.14           -66.7%     195.29 ± 11%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1007 ± 24%     -47.3%     531.33 ±  7%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    124.00          -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
    105.17 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3807 ±  4%    +235.5%      12773 ±  9%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    149.33 ±  3%    +368.2%     699.17 ± 16%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
    202.17 ±  3%    +432.0%       1075 ± 14%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
    211.83 ±  6%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      1048 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
     32.17 ±  9%     -22.8%      24.83 ±  3%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
      1083            -7.7%       1000 ±  2%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
     87.00          -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      1866          +554.9%      12223 ± 12%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1135            -9.6%       1027        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      1021 ±115%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      6.91 ± 22%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.98 ± 18%     -42.0%       2.89 ± 65%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      7.39 ± 12%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      9.42 ± 29%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
     43.37 ± 67%     -77.1%       9.94 ± 29%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      8.56 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      3458 ± 27%     -51.5%       1678 ± 30%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     41.84 ± 23%     +87.1%      78.28 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      1.33 ±  6%     -46.6%       0.71 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.93 ± 39%     -79.9%       0.39 ± 25%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.07 ± 31%     -80.2%       0.01 ± 35%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.13 ± 56%     -84.2%       0.02 ± 27%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
      0.15 ± 18%     -82.6%       0.03 ± 26%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.03 ± 53%     -67.2%       0.01 ± 69%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].stress_af_alg
      0.04 ± 47%     -65.3%       0.01 ± 38%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.stress_rndbuf.stress_af_alg
      0.22 ±121%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__blowfish_dec_blk_4way
      0.27 ± 43%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__serpent_encrypt
      0.16 ± 73%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.04 ± 71%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_get_nstime
      0.16 ± 65%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      0.12 ± 55%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      0.19 ± 15%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.20 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      0.16 ±  6%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.25 ± 87%     -72.7%       0.07 ±150%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt._skcipher_recvmsg
      0.80 ±130%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      0.53 ± 49%     -89.6%       0.05 ±114%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt._skcipher_recvmsg
      0.39 ± 63%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      0.01 ±223%   +4091.7%       0.34 ±102%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.sock_kfree_s.af_alg_free_resources
    378.01 ±  9%     +28.2%     484.79 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
      4.64            +8.5%       5.04        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    586.12           -66.7%     195.27 ± 11%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1134            -9.5%       1027        perf-sched.wait_time.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      2.49 ± 18%     -42.0%       1.45 ± 65%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.01 ±141%    +108.7%       0.02 ± 79%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.bind.stress_af_alg
      0.52 ±126%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__blowfish_dec_blk_4way
      2.14 ± 44%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__serpent_encrypt
      1.50 ± 64%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.49 ±183%    +312.3%       2.01 ± 46%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_decrypt2
      0.07 ± 67%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_get_nstime
      1.95 ± 43%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      1.57 ± 74%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      3.69 ± 12%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      2.12 ± 68%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      4.71 ± 29%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      1.36 ± 86%     -85.2%       0.20 ±151%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt._skcipher_recvmsg
      1.70 ± 76%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      2.43 ± 33%     -91.0%       0.22 ±157%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt._skcipher_recvmsg
      1.82 ± 54%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      0.01 ±223%   +7690.0%       0.78 ±131%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.sock_kfree_s.af_alg_free_resources
     30.48 ± 42%     -72.7%       8.31 ± 22%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      8.14 ±  6%     -23.1%       6.26 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      3458 ± 27%     -51.5%       1678 ± 30%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp1/af-alg/stress-ng/60s

commit: 
  7e28b0a5c4 ("crypto: qce - Remove unsafe/deprecated algorithms")
  2f204fe718 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")

7e28b0a5c4b7d075 2f204fe718f5bf519013cc2536a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    216855          -100.0%       0.00        stress-ng.af-alg.blowfish_cipher_ops/sec
    209524 ±  6%    -100.0%       0.00        stress-ng.af-alg.camellia_cipher_ops/sec
    190546 ±  4%    -100.0%       0.00        stress-ng.af-alg.cast5_cipher_ops/sec
    135294 ±  3%    -100.0%       0.00        stress-ng.af-alg.cast6_cipher_ops/sec
    479356            -4.0%     460371        stress-ng.af-alg.cbc_aes_skcipher_ops/sec
    217326          -100.0%       0.00        stress-ng.af-alg.cbc_blowfish_skcipher_ops/sec
    207506 ±  6%    -100.0%       0.00        stress-ng.af-alg.cbc_camellia_skcipher_ops/sec
    193783 ±  4%    -100.0%       0.00        stress-ng.af-alg.cbc_cast5_skcipher_ops/sec
    137997 ±  3%    -100.0%       0.00        stress-ng.af-alg.cbc_cast6_skcipher_ops/sec
     59293           -13.2%      51441        stress-ng.af-alg.cbc_des_skcipher_ops/sec
    184573 ±  7%    -100.0%       0.00        stress-ng.af-alg.cbc_serpent_skcipher_ops/sec
     65374          -100.0%       0.00        stress-ng.af-alg.cbc_sm4_skcipher_ops/sec
    224719 ±  2%    -100.0%       0.00        stress-ng.af-alg.cbc_twofish_skcipher_ops/sec
    378937 ±  3%    -100.0%       0.00        stress-ng.af-alg.chacha20_skcipher_ops/sec
    701429 ±  3%    -100.0%       0.00        stress-ng.af-alg.cipher_null_cipher_ops/sec
    805125 ±  2%    -100.0%       0.00        stress-ng.af-alg.crc32_shash_ops/sec
   1012208 ±  2%    -100.0%       0.00        stress-ng.af-alg.crc32c_shash_ops/sec
     88666          -100.0%       0.00        stress-ng.af-alg.ctr_blowfish_skcipher_ops/sec
    103288          -100.0%       0.00        stress-ng.af-alg.ctr_camellia_skcipher_ops/sec
     96558          -100.0%       0.00        stress-ng.af-alg.ctr_cast5_skcipher_ops/sec
     83138          -100.0%       0.00        stress-ng.af-alg.ctr_cast6_skcipher_ops/sec
     24949          -100.0%       0.00        stress-ng.af-alg.ctr_des3_ede_skcipher_ops/sec
     64739          -100.0%       0.00        stress-ng.af-alg.ctr_des_skcipher_ops/sec
     63942          -100.0%       0.00        stress-ng.af-alg.ctr_serpent_skcipher_ops/sec
     69264          -100.0%       0.00        stress-ng.af-alg.ctr_sm4_skcipher_ops/sec
    136885          -100.0%       0.00        stress-ng.af-alg.ctr_twofish_skcipher_ops/sec
    457005          -100.0%       0.00        stress-ng.af-alg.cts_cbc_aes_skcipher_ops/sec
     64293          -100.0%       0.00        stress-ng.af-alg.cts_cbc_sm4_skcipher_ops/sec
     25458          -100.0%       0.00        stress-ng.af-alg.des3_ede_cipher_ops/sec
    216965          -100.0%       0.00        stress-ng.af-alg.ecb_blowfish_skcipher_ops/sec
    209313 ±  6%    -100.0%       0.00        stress-ng.af-alg.ecb_camellia_skcipher_ops/sec
    190769 ±  4%    -100.0%       0.00        stress-ng.af-alg.ecb_cast5_skcipher_ops/sec
    135248 ±  3%    -100.0%       0.00        stress-ng.af-alg.ecb_cast6_skcipher_ops/sec
    702104 ±  3%    -100.0%       0.00        stress-ng.af-alg.ecb_cipher_null_skcipher_ops/sec
     25448          -100.0%       0.00        stress-ng.af-alg.ecb_des3_ede_skcipher_ops/sec
    182596 ±  7%    -100.0%       0.00        stress-ng.af-alg.ecb_serpent_skcipher_ops/sec
     70347          -100.0%       0.00        stress-ng.af-alg.ecb_sm4_skcipher_ops/sec
    219007 ±  2%    -100.0%       0.00        stress-ng.af-alg.ecb_twofish_skcipher_ops/sec
    457398          -100.0%       0.00        stress-ng.af-alg.gcm_aes_aead_ops/sec
     62426          -100.0%       0.00        stress-ng.af-alg.gcm_sm4_aead_ops/sec
    553.77          -100.0%       0.00        stress-ng.af-alg.jitterentropy_rng_rng_ops/sec
    397336          -100.0%       0.00        stress-ng.af-alg.lrw_aes_skcipher_ops/sec
    193284 ±  6%    -100.0%       0.00        stress-ng.af-alg.lrw_camellia_skcipher_ops/sec
    128008 ±  3%    -100.0%       0.00        stress-ng.af-alg.lrw_cast6_skcipher_ops/sec
    170053 ±  7%    -100.0%       0.00        stress-ng.af-alg.lrw_serpent_skcipher_ops/sec
    200877 ±  2%    -100.0%       0.00        stress-ng.af-alg.lrw_twofish_skcipher_ops/sec
    684836 ±  3%      -8.8%     624898 ±  2%  stress-ng.af-alg.md4_shash_ops/sec
 4.649e+08           +94.3%  9.035e+08        stress-ng.af-alg.ops
   7731460           +94.8%   15059678        stress-ng.af-alg.ops_per_sec
    482644          -100.0%       0.00        stress-ng.af-alg.rfc3686_ctr_aes_skcipher_ops/sec
    277551          -100.0%       0.00        stress-ng.af-alg.rmd160_shash_ops/sec
    183019 ±  7%    -100.0%       0.00        stress-ng.af-alg.serpent_cipher_ops/sec
    242936          -100.0%       0.00        stress-ng.af-alg.sha3-384_shash_ops/sec
    183762          -100.0%       0.00        stress-ng.af-alg.sha3-512_shash_ops/sec
     70335          -100.0%       0.00        stress-ng.af-alg.sm4_cipher_ops/sec
   3962546          -100.0%       0.00        stress-ng.af-alg.stdrng_rng_ops/sec
    219095 ±  2%    -100.0%       0.00        stress-ng.af-alg.twofish_cipher_ops/sec
    230665          -100.0%       0.00        stress-ng.af-alg.wp256_shash_ops/sec
    231679          -100.0%       0.00        stress-ng.af-alg.wp384_shash_ops/sec
    232469          -100.0%       0.00        stress-ng.af-alg.wp512_shash_ops/sec
    410669 ±  3%    -100.0%       0.00        stress-ng.af-alg.xchacha12_skcipher_ops/sec
    360829 ±  3%    -100.0%       0.00        stress-ng.af-alg.xchacha20_skcipher_ops/sec
    491724          -100.0%       0.00        stress-ng.af-alg.xctr_aes_skcipher_ops/sec
    167510 ±  5%    -100.0%       0.00        stress-ng.af-alg.xts_camellia_skcipher_ops/sec
    117726 ±  3%    -100.0%       0.00        stress-ng.af-alg.xts_cast6_skcipher_ops/sec
    150916 ±  6%    -100.0%       0.00        stress-ng.af-alg.xts_serpent_skcipher_ops/sec
     65448          -100.0%       0.00        stress-ng.af-alg.xts_sm4_skcipher_ops/sec
    177065 ±  2%    -100.0%       0.00        stress-ng.af-alg.xts_twofish_skcipher_ops/sec
   1276683 ±  5%    -100.0%       0.00        stress-ng.af-alg.xxhash64_shash_ops/sec
     76318 ±  3%    +204.7%     232555 ±  7%  stress-ng.time.involuntary_context_switches
     91019           -35.6%      58616 ±  6%  stress-ng.time.minor_page_faults
     23417            +7.6%      25203        stress-ng.time.percent_of_cpu_this_job_got
     13227            +3.7%      13723        stress-ng.time.system_time
    916.14           +59.1%       1457        stress-ng.time.user_time
    120751           -96.3%       4444 ±  8%  stress-ng.time.voluntary_context_switches
   1708577 ±  3%     -87.9%     206193 ± 13%  cpuidle..usage
      0.06 ±  3%      +0.0        0.08        mpstat.cpu.all.soft%
      6.27            +2.8        9.03 ±  4%  mpstat.cpu.all.usr%
  60031341 ±  2%      +3.5%   62149354 ±  2%  numa-meminfo.node0.MemFree
   5669438 ± 23%     -37.4%    3551425 ± 50%  numa-meminfo.node0.MemUsed
    487.50 ±  5%     -23.6%     372.50 ± 13%  perf-c2c.DRAM.remote
    297.17 ±  7%     -12.7%     259.33 ± 11%  perf-c2c.HITM.remote
     18714           -55.2%       8375 ±  4%  vmstat.system.cs
    651936            -7.9%     600609 ±  4%  vmstat.system.in
 3.811e+08           +53.3%  5.842e+08        numa-numastat.node0.local_node
 3.812e+08           +53.3%  5.844e+08        numa-numastat.node0.numa_hit
 3.795e+08           +53.2%  5.812e+08        numa-numastat.node1.local_node
 3.796e+08           +53.1%  5.813e+08        numa-numastat.node1.numa_hit
 2.252e+08 ± 28%    +123.8%  5.041e+08 ± 35%  numa-vmstat.node0.nr_foll_pin_acquired
 2.252e+08 ± 28%    +123.8%  5.041e+08 ± 35%  numa-vmstat.node0.nr_foll_pin_released
  15007558 ±  2%      +3.5%   15536798 ±  2%  numa-vmstat.node0.nr_free_pages
 3.812e+08           +53.3%  5.844e+08        numa-vmstat.node0.numa_hit
 3.811e+08           +53.3%  5.842e+08        numa-vmstat.node0.numa_local
 2.313e+08 ± 30%    +118.9%  5.062e+08 ± 32%  numa-vmstat.node1.nr_foll_pin_acquired
 2.313e+08 ± 30%    +118.9%  5.062e+08 ± 32%  numa-vmstat.node1.nr_foll_pin_released
 3.796e+08           +53.1%  5.813e+08        numa-vmstat.node1.numa_hit
 3.795e+08           +53.2%  5.812e+08        numa-vmstat.node1.numa_local
      6024 ±  7%     -13.3%       5222 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.stddev
     28.15 ±  5%    +108.4%      58.64 ± 23%  sched_debug.cfs_rq:/.util_est.avg
      6024 ±  7%     -13.3%       5222 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.stddev
      5785 ±  2%      -7.6%       5347        sched_debug.cpu.curr->pid.avg
     36539           -67.8%      11768        sched_debug.cpu.curr->pid.max
      2446 ±  2%     -57.9%       1030 ±  3%  sched_debug.cpu.curr->pid.stddev
      3548 ±  2%     -37.0%       2236 ±  4%  sched_debug.cpu.nr_switches.avg
     18448 ±  6%     -11.1%      16403 ±  4%  sched_debug.cpu.nr_switches.max
      2190 ±  3%     -52.0%       1050 ± 16%  sched_debug.cpu.nr_switches.min
      0.01            -0.0        0.00        turbostat.C1%
      3.54            -3.3        0.28 ±  5%  turbostat.C1E%
      2.25 ±  2%      -2.0        0.26 ±  9%  turbostat.C6S%
      3.56           -92.0%       0.28 ±  5%  turbostat.CPU%c1
      2.87           -25.9%       2.13        turbostat.IPC
   9876648            -8.0%    9090571        turbostat.NMI
      0.00 ±223%  +26800.0%       0.45 ± 61%  turbostat.Pkg%pc2
     55.33 ± 11%     -16.0%      46.50 ±  2%  turbostat.PkgTmp
    435.70           -13.7%     376.19 ±  2%  turbostat.PkgWatt
   1868796            -6.8%    1742616 ±  2%  meminfo.Active
   1868796            -6.8%    1742616 ±  2%  meminfo.Active(anon)
  13873747 ±  6%     -22.3%   10778257 ± 13%  meminfo.DirectMap2M
    371335 ±  2%     -24.2%     281423 ±  5%  meminfo.DirectMap4k
    180632            +6.1%     191567        meminfo.KReclaimable
    406906 ±  6%     -16.5%     339717 ±  7%  meminfo.Mapped
   9491571            -4.9%    9030449        meminfo.Memused
     36225           -12.0%      31879 ±  2%  meminfo.PageTables
    180632            +6.1%     191567        meminfo.SReclaimable
   1090073            -9.9%     982056 ±  5%  meminfo.Shmem
     22727           -62.4%       8551 ±  5%  perf-stat.i.context-switches
      2333           -80.7%     449.78 ±  2%  perf-stat.i.cpu-migrations
    175.57 ±  3%     -97.4%       4.63 ±  7%  perf-stat.i.major-faults
    267773           -93.7%      16776 ±  4%  perf-stat.i.minor-faults
    267949           -93.7%      16780 ±  4%  perf-stat.i.page-faults
     19001           -56.8%       8200 ±  5%  perf-stat.ps.context-switches
      1952           -78.8%     414.65 ±  2%  perf-stat.ps.cpu-migrations
    142.75 ±  3%     -97.3%       3.81 ±  9%  perf-stat.ps.major-faults
    218341           -93.3%      14704 ±  4%  perf-stat.ps.minor-faults
    218484           -93.3%      14708 ±  4%  perf-stat.ps.page-faults
    467477            -6.8%     435805 ±  3%  proc-vmstat.nr_active_anon
    195424            -2.4%     190648        proc-vmstat.nr_anon_pages
   1297860            -2.1%    1270763        proc-vmstat.nr_file_pages
 4.573e+08 ± 29%    +121.4%  1.012e+09 ± 33%  proc-vmstat.nr_foll_pin_acquired
 4.573e+08 ± 29%    +121.4%  1.012e+09 ± 33%  proc-vmstat.nr_foll_pin_released
     53202            -4.1%      51028        proc-vmstat.nr_kernel_stack
    101975 ±  6%     -16.8%      84803 ±  8%  proc-vmstat.nr_mapped
      9052           -12.0%       7969 ±  2%  proc-vmstat.nr_page_table_pages
    272763            -9.9%     245676 ±  5%  proc-vmstat.nr_shmem
     45164            +6.1%      47897        proc-vmstat.nr_slab_reclaimable
    125864            -2.4%     122785        proc-vmstat.nr_slab_unreclaimable
    467477            -6.8%     435805 ±  3%  proc-vmstat.nr_zone_active_anon
 7.609e+08           +53.2%  1.166e+09        proc-vmstat.numa_hit
 7.606e+08           +53.2%  1.165e+09        proc-vmstat.numa_local
 7.609e+08           +53.2%  1.166e+09        proc-vmstat.pgalloc_normal
  13568843           -92.1%    1074388 ±  2%  proc-vmstat.pgfault
 7.599e+08           +53.3%  1.165e+09        proc-vmstat.pgfree
     25.00 ± 29%     -56.0%      11.00 ± 53%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.74 ±112%     -97.8%       0.02 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.39 ± 14%    +102.6%       0.79 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      0.30 ±  7%     -39.9%       0.18 ± 22%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.13 ± 10%     -82.4%       0.02 ± 32%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.05 ± 59%     -72.9%       0.01 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.08 ± 65%     -88.6%       0.01 ± 45%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsockopt
      0.13 ± 51%     -86.9%       0.02 ± 41%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
      0.12 ± 33%     -81.5%       0.02 ± 44%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.00 ±223%    +820.0%       0.01 ± 57%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now.stress_af_alg
      0.30 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__cast5_encrypt
      0.12 ± 46%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.00 ±141%   +7715.0%       0.26 ±116%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.af_alg_pull_tsgl
      8.59 ± 38%     -71.3%       2.46 ±102%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_folio_from_iter_atomic
      0.01 ±174%   +2979.6%       0.25 ± 58%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_encrypt2
      0.10 ± 61%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      0.12 ± 68%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      0.12 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.11 ± 51%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      0.13 ± 14%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.25 ±102%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.xts_xor_tweak
      0.00 ±223%  +14966.7%       0.15 ±143%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.cbc_encrypt._skcipher_recvmsg
      0.34 ±102%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.chacha_crypt.chacha_stream_xor
      0.32 ± 99%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      0.37 ±139%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      0.33 ± 16%     -77.3%       0.07 ± 30%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      1.09 ±  9%     -85.3%       0.16 ±184%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.29 ± 48%     -93.0%       0.02 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.16 ± 20%     -85.2%       0.02 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.78 ± 12%     -25.8%       0.58 ± 11%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      0.31 ±  4%     -90.8%       0.03 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     12.84 ± 33%     -59.6%       5.19 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
     49.68 ± 30%     -55.8%      21.97 ± 53%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      3.14 ±142%     -99.1%       0.03 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      1.05 ± 87%     -96.2%       0.04 ± 83%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsockopt
      0.00 ±223%   +2220.0%       0.02 ± 93%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now.stress_af_alg
      1.54 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__cast5_encrypt
      1.53 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      6.62 ±119%     -73.7%       1.74 ± 48%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.00 ±141%  +17850.0%       0.60 ±102%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.af_alg_pull_tsgl
     69.63 ± 40%     -81.6%      12.82 ±145%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_folio_from_iter_atomic
      0.01 ±174%  +21434.7%       1.76 ± 41%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_encrypt2
      1.67 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      1.73 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      3.59 ± 53%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      2.15 ± 49%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      4.86 ± 42%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.65 ± 95%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.xts_xor_tweak
      0.00 ±223%  +39633.3%       0.40 ±133%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.cbc_encrypt._skcipher_recvmsg
      0.63 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.chacha_crypt.chacha_stream_xor
      1.00 ± 98%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      1.79 ±150%    -100.0%       0.00        perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
     41.71 ±121%     -89.5%       4.40 ± 98%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     12.21 ±  5%     -84.7%       1.86 ±207%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.97 ±  6%     -95.1%       0.05 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.22 ± 16%     -77.5%       0.05 ± 45%  perf-sched.total_sch_delay.average.ms
    183.40 ±  3%     -42.9%     104.76 ± 10%  perf-sched.total_wait_and_delay.average.ms
     13126 ±  2%    +170.9%      35557 ± 10%  perf-sched.total_wait_and_delay.count.ms
      4251 ±  4%     +15.1%       4894        perf-sched.total_wait_and_delay.max.ms
    183.18 ±  3%     -42.8%     104.71 ± 10%  perf-sched.total_wait_time.average.ms
      4251 ±  4%     +15.1%       4894        perf-sched.total_wait_time.max.ms
     56.31 ± 18%     +76.8%      99.58 ± 17%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    454.97 ±  4%     +26.2%     574.25 ±  9%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.78 ± 14%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      1.63 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.51 ± 27%     -76.8%       0.35 ± 58%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.09 ± 59%     -73.2%       0.02 ± 19%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.26 ± 51%     -86.9%       0.03 ± 42%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
      0.25 ± 33%     -81.5%       0.05 ± 44%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.25 ± 33%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.27 ± 14%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      2.74 ±  5%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
    590.52 ±  2%     -68.5%     186.05 ± 14%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    743.00 ± 18%     -45.7%     403.67 ± 21%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
     61.00 ±  6%     -23.2%      46.83 ±  8%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
    120.67 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
    103.67 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3679 ±  4%    +282.5%      14076 ± 11%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     97.50 ± 10%    +218.3%     310.33 ± 23%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
     80.67 ± 10%    +509.9%     492.00 ± 11%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
    178.00 ±  6%    +537.5%       1134 ± 13%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
    231.67 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
    828.83 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
     85.17 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      2074 ±  2%    +557.6%      13639 ± 14%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1115            -7.3%       1034        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      7.50          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      5.56 ± 20%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.18 ± 53%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      9.71 ± 42%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      7.75 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
     64.72 ±141%    +105.5%     132.96 ± 70%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     56.19 ± 18%     +76.9%      99.39 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    451.19 ±  4%     +26.4%     570.38 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.39 ± 14%    +462.3%       2.19 ±139%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group
      1.33 ±  2%     -15.4%       1.13 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.38 ± 29%     -76.3%       0.33 ± 61%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.05 ± 59%     -72.9%       0.01 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.08 ± 65%     -88.6%       0.01 ± 45%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsockopt
      0.13 ± 51%     -86.9%       0.02 ± 41%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].stress_af_alg
      0.12 ± 33%     -81.5%       0.02 ± 44%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_rndbuf.stress_af_alg
      0.00 ±223%    +820.0%       0.01 ± 57%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now.stress_af_alg
      0.30 ± 55%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__cast5_encrypt
      0.12 ± 46%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      0.00 ±141%   +7715.0%       0.26 ±116%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.af_alg_pull_tsgl
      0.01 ±174%   +2979.6%       0.25 ± 58%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_encrypt2
      0.10 ± 61%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      0.12 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      0.12 ± 33%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      0.11 ± 51%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      0.13 ± 14%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.25 ±102%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.xts_xor_tweak
      0.00 ±223%  +14966.7%       0.15 ±143%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.cbc_encrypt._skcipher_recvmsg
      0.34 ±102%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.chacha_crypt.chacha_stream_xor
      0.32 ± 99%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      0.37 ±139%    -100.0%       0.00        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
      2.49 ±  4%     +11.3%       2.77 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
    590.50 ±  2%     -68.5%     186.03 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    323.08 ±141%    +105.8%     664.78 ± 70%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1114            -7.3%       1033        perf-sched.wait_time.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      1.05 ± 87%     -96.2%       0.04 ± 83%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsockopt
      0.00 ±223%   +2220.0%       0.02 ± 93%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now.stress_af_alg
      1.54 ± 58%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__cast5_encrypt
      1.53 ± 59%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__sha3_update
      6.62 ±119%     -77.8%       1.47 ± 79%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.00 ±141%  +17850.0%       0.60 ±102%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.af_alg_pull_tsgl
      0.01 ±174%  +21434.7%       1.76 ± 41%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.crypto_ecb_encrypt2
      1.67 ± 67%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_hash_time
      1.73 ± 79%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_loop_shuffle
      3.59 ± 53%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.jent_memaccess
      2.15 ± 49%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_final
      4.86 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.sha3_keccakf_one_round_generic
      0.65 ± 95%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.xts_xor_tweak
      0.00 ±223%  +39633.3%       0.40 ±133%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.cbc_encrypt._skcipher_recvmsg
      0.63 ± 77%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.chacha_crypt.chacha_stream_xor
      1.00 ± 98%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_decrypt.xts_decrypt
      1.79 ±150%    -100.0%       0.00        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__local_bh_enable_ip.ecb_encrypt.xts_encrypt
     43.79 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_run
     43.79 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.stress_run
     43.78 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_run
     43.78 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_run
     43.78 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp._rng_recvmsg.sock_recvmsg.sock_read_iter.vfs_read.ksys_read
     43.77 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.jent_kcapi_random._rng_recvmsg.sock_recvmsg.sock_read_iter.vfs_read
     43.77 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.jent_read_entropy.jent_kcapi_random._rng_recvmsg.sock_recvmsg.sock_read_iter
     43.76 ± 10%     -43.8        0.00        perf-profile.calltrace.cycles-pp.jent_gen_entropy.jent_read_entropy.jent_kcapi_random._rng_recvmsg.sock_recvmsg
     43.72 ± 10%     -43.7        0.00        perf-profile.calltrace.cycles-pp.jent_measure_jitter.jent_gen_entropy.jent_read_entropy.jent_kcapi_random._rng_recvmsg
     34.52 ± 10%     -34.5        0.00        perf-profile.calltrace.cycles-pp.jent_condition_data.jent_measure_jitter.jent_gen_entropy.jent_read_entropy.jent_kcapi_random
     34.43 ± 10%     -34.4        0.00        perf-profile.calltrace.cycles-pp.jent_hash_time.jent_condition_data.jent_measure_jitter.jent_gen_entropy.jent_read_entropy
     32.96 ± 10%     -33.0        0.00        perf-profile.calltrace.cycles-pp.sha3_final.jent_hash_time.jent_condition_data.jent_measure_jitter.jent_gen_entropy
     30.36 ± 10%     -30.4        0.00        perf-profile.calltrace.cycles-pp.sha3_keccakf_one_round_generic.sha3_final.jent_hash_time.jent_condition_data.jent_measure_jitter
     63.01 ±  3%     -24.0       39.06        perf-profile.calltrace.cycles-pp.sock_recvmsg.sock_read_iter.vfs_read.ksys_read.do_syscall_64
     63.08 ±  3%     -23.9       39.14        perf-profile.calltrace.cycles-pp.sock_read_iter.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.06 ±  9%      -9.1        0.00        perf-profile.calltrace.cycles-pp.jent_memaccess.jent_measure_jitter.jent_gen_entropy.jent_read_entropy.jent_kcapi_random
      4.35 ± 22%      -4.4        0.00        perf-profile.calltrace.cycles-pp.crypto_ctr_crypt._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.__sys_recvfrom
      4.35 ± 22%      -4.3        0.00        perf-profile.calltrace.cycles-pp.crypto_ctr_crypt._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.sock_read_iter
      3.82 ± 10%      -2.1        1.71 ± 16%  perf-profile.calltrace.cycles-pp.alg_bind.__sys_bind.__x64_sys_bind.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.84 ± 10%      -2.1        1.74 ± 16%  perf-profile.calltrace.cycles-pp.__sys_bind.__x64_sys_bind.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind
      0.68 ± 10%      +0.2        0.88        perf-profile.calltrace.cycles-pp.__pi_memset.sg_init_table.af_alg_sendmsg.____sys_sendmsg.___sys_sendmsg
      0.70 ± 10%      +0.2        0.91        perf-profile.calltrace.cycles-pp.sg_init_table.af_alg_sendmsg.____sys_sendmsg.___sys_sendmsg.__sys_sendmsg
      0.65 ± 10%      +0.4        1.05 ± 22%  perf-profile.calltrace.cycles-pp.crypto_alg_lookup.crypto_alg_mod_lookup.crypto_alloc_tfm_node.alg_bind.__sys_bind
      0.65 ± 10%      +0.4        1.07 ± 22%  perf-profile.calltrace.cycles-pp.crypto_alg_mod_lookup.crypto_alloc_tfm_node.alg_bind.__sys_bind.__x64_sys_bind
      0.09 ±223%      +0.5        0.58        perf-profile.calltrace.cycles-pp.copy_msghdr_from_user.___sys_sendmsg.__sys_sendmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.86 ± 10%      +0.5        1.37        perf-profile.calltrace.cycles-pp.restore_fpregs_from_fpstate.switch_fpu_return.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.5        0.51        perf-profile.calltrace.cycles-pp.__crypto_xor.crypto_cbc_decrypt_segment.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg
      0.82 ±  9%      +0.5        1.35 ± 19%  perf-profile.calltrace.cycles-pp.crypto_alloc_tfm_node.alg_bind.__sys_bind.__x64_sys_bind.do_syscall_64
      0.95 ± 10%      +0.6        1.52        perf-profile.calltrace.cycles-pp.switch_fpu_return.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg
      0.96 ± 10%      +0.6        1.52        perf-profile.calltrace.cycles-pp.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
      2.14 ± 10%      +0.6        2.78        perf-profile.calltrace.cycles-pp.af_alg_sendmsg.____sys_sendmsg.___sys_sendmsg.__sys_sendmsg.do_syscall_64
      1.10 ± 10%      +0.6        1.74 ± 16%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind.stress_af_alg.stress_run
      1.10 ± 10%      +0.6        1.74 ± 16%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.bind.stress_af_alg.stress_run
      1.10 ± 10%      +0.6        1.74 ± 16%  perf-profile.calltrace.cycles-pp.__x64_sys_bind.do_syscall_64.entry_SYSCALL_64_after_hwframe.bind.stress_af_alg
      1.12 ± 10%      +0.6        1.76 ± 16%  perf-profile.calltrace.cycles-pp.bind.stress_af_alg.stress_run
      2.82 ± 10%      +0.8        3.62        perf-profile.calltrace.cycles-pp.____sys_sendmsg.___sys_sendmsg.__sys_sendmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.9        0.92 ± 11%  perf-profile.calltrace.cycles-pp.__pi_memcpy.crypto_cbc_encrypt_segment.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg
      3.36 ± 10%      +0.9        4.30        perf-profile.calltrace.cycles-pp.__sys_sendmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
      3.30 ± 10%      +0.9        4.24        perf-profile.calltrace.cycles-pp.___sys_sendmsg.__sys_sendmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg
      1.03 ± 21%      +1.2        2.20 ±  4%  perf-profile.calltrace.cycles-pp.hash_sendmsg.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.09 ± 19%      +1.3        2.38 ±  4%  perf-profile.calltrace.cycles-pp.__sys_sendto.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg
      1.09 ± 19%      +1.3        2.38 ±  4%  perf-profile.calltrace.cycles-pp.__x64_sys_sendto.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
      4.51 ± 10%      +1.5        5.98        perf-profile.calltrace.cycles-pp.stress_rndbuf.stress_af_alg.stress_run
      0.64 ±  8%      +5.1        5.73        perf-profile.calltrace.cycles-pp.des_decrypt.crypto_ecb_decrypt2.crypto_cbc_decrypt_segment.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg
      0.57 ± 45%      +5.4        6.00        perf-profile.calltrace.cycles-pp.des_encrypt.crypto_ecb_encrypt2.crypto_cbc_encrypt_segment.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg
      5.92 ±  7%      +6.1       12.03        perf-profile.calltrace.cycles-pp.crypto_ecb_encrypt2.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg
      5.89 ±  7%      +6.2       12.06        perf-profile.calltrace.cycles-pp.crypto_ecb_decrypt2.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg
      1.30 ±  8%     +10.3       11.64        perf-profile.calltrace.cycles-pp.des_decrypt.crypto_ecb_decrypt2.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg
      1.25 ± 15%     +10.4       11.62        perf-profile.calltrace.cycles-pp.des_encrypt.crypto_ecb_encrypt2.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg
      1.46 ±  9%     +11.9       13.38 ± 17%  perf-profile.calltrace.cycles-pp.des3_ede_decrypt.crypto_ecb_decrypt2.crypto_cbc_decrypt_segment.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg
      1.77 ±  7%     +14.1       15.92 ±  2%  perf-profile.calltrace.cycles-pp.des3_ede_encrypt.crypto_ecb_encrypt2.crypto_cbc_encrypt_segment.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg
     19.35 ± 12%     +19.8       39.20        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg
     19.37 ± 12%     +19.8       39.22        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
      2.99 ±  7%     +20.2       23.20        perf-profile.calltrace.cycles-pp.crypto_ecb_decrypt2.crypto_cbc_decrypt_segment.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg
     18.47 ± 12%     +20.4       38.89        perf-profile.calltrace.cycles-pp._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.sock_read_iter.vfs_read
     18.59 ± 12%     +20.5       39.04        perf-profile.calltrace.cycles-pp.skcipher_recvmsg.sock_recvmsg.sock_read_iter.vfs_read.ksys_read
      3.09 ±  7%     +20.8       23.88        perf-profile.calltrace.cycles-pp.crypto_cbc_decrypt_segment.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg
      3.10 ±  7%     +20.8       23.91        perf-profile.calltrace.cycles-pp.crypto_cbc_decrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg
     20.48 ± 15%     +21.0       41.45        perf-profile.calltrace.cycles-pp.sock_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     20.63 ± 15%     +21.1       41.69        perf-profile.calltrace.cycles-pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg
     20.63 ± 15%     +21.1       41.70        perf-profile.calltrace.cycles-pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
      3.10 ±  7%     +21.1       24.21        perf-profile.calltrace.cycles-pp.crypto_ecb_encrypt2.crypto_cbc_encrypt_segment.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg
     19.63 ± 15%     +21.4       41.00        perf-profile.calltrace.cycles-pp._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.__sys_recvfrom.__x64_sys_recvfrom
     19.74 ± 15%     +21.4       41.15        perf-profile.calltrace.cycles-pp.skcipher_recvmsg.sock_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64
      3.31 ±  7%     +22.3       25.62        perf-profile.calltrace.cycles-pp.crypto_cbc_encrypt_segment.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg
      3.31 ±  7%     +22.3       25.65        perf-profile.calltrace.cycles-pp.crypto_cbc_encrypt.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg
      9.04 ±  7%     +27.1       36.17        perf-profile.calltrace.cycles-pp.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.sock_read_iter
      9.29 ±  7%     +28.6       37.88        perf-profile.calltrace.cycles-pp.crypto_lskcipher_crypt_sg._skcipher_recvmsg.skcipher_recvmsg.sock_recvmsg.__sys_recvfrom
     45.82 ± 11%     +44.0       89.81        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
     45.90 ± 11%     +44.0       89.92        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.stress_af_alg.stress_run
     52.97 ±  9%     +47.2      100.15        perf-profile.calltrace.cycles-pp.stress_af_alg.stress_run
     46.48 ± 10%     -46.5        0.00        perf-profile.children.cycles-pp.jent_gen_entropy
     46.45 ± 10%     -46.5        0.00        perf-profile.children.cycles-pp.jent_measure_jitter
     43.78 ± 10%     -43.8        0.00        perf-profile.children.cycles-pp._rng_recvmsg
     43.77 ± 10%     -43.8        0.00        perf-profile.children.cycles-pp.jent_kcapi_random
     43.77 ± 10%     -43.8        0.00        perf-profile.children.cycles-pp.jent_read_entropy
     36.69 ± 10%     -36.7        0.00        perf-profile.children.cycles-pp.jent_condition_data
     36.66 ± 10%     -36.7        0.00        perf-profile.children.cycles-pp.jent_hash_time
     33.20 ± 10%     -33.2        0.00        perf-profile.children.cycles-pp.sha3_final
     31.96 ± 10%     -32.0        0.00        perf-profile.children.cycles-pp.sha3_keccakf_one_round_generic
     63.08 ±  3%     -23.9       39.14        perf-profile.children.cycles-pp.sock_read_iter
     63.14 ±  3%     -23.9       39.20        perf-profile.children.cycles-pp.vfs_read
     63.16 ±  3%     -23.9       39.23        perf-profile.children.cycles-pp.ksys_read
      9.75 ± 22%      -9.8        0.00        perf-profile.children.cycles-pp.crypto_ctr_crypt
      9.61 ±  9%      -9.6        0.00        perf-profile.children.cycles-pp.jent_memaccess
     83.50            -3.0       80.51        perf-profile.children.cycles-pp.sock_recvmsg
      2.90 ± 10%      -2.6        0.28 ±  7%  perf-profile.children.cycles-pp.crypto_create_tfm_node
      3.56 ± 10%      -2.2        1.35 ± 19%  perf-profile.children.cycles-pp.crypto_alloc_tfm_node
      3.82 ± 10%      -2.1        1.71 ± 16%  perf-profile.children.cycles-pp.alg_bind
      3.84 ± 10%      -2.1        1.74 ± 16%  perf-profile.children.cycles-pp.__sys_bind
      3.84 ± 10%      -2.1        1.74 ± 16%  perf-profile.children.cycles-pp.__x64_sys_bind
      3.86 ± 10%      -2.1        1.77 ± 16%  perf-profile.children.cycles-pp.bind
     93.79            -2.1       91.71        perf-profile.children.cycles-pp.do_syscall_64
     93.86            -2.0       91.82        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.32 ± 14%      -0.3        0.04 ± 73%  perf-profile.children.cycles-pp.process_simple
      0.31 ± 14%      -0.3        0.04 ± 73%  perf-profile.children.cycles-pp.ordered_events__queue
      0.31 ± 14%      -0.3        0.04 ± 73%  perf-profile.children.cycles-pp.queue_event
      0.25 ± 40%      -0.2        0.07 ±  5%  perf-profile.children.cycles-pp.alg_setsockopt
      0.22 ± 44%      -0.2        0.05        perf-profile.children.cycles-pp.crypto_skcipher_setkey
      0.25 ± 39%      -0.2        0.08 ±  4%  perf-profile.children.cycles-pp.do_sock_setsockopt
      0.25 ± 39%      -0.2        0.08        perf-profile.children.cycles-pp.__sys_setsockopt
      0.25 ± 39%      -0.2        0.08        perf-profile.children.cycles-pp.__x64_sys_setsockopt
      0.28 ± 34%      -0.2        0.12        perf-profile.children.cycles-pp.setsockopt
      0.09 ± 17%      -0.0        0.04 ± 45%  perf-profile.children.cycles-pp.handle_internal_command
      0.09 ± 17%      -0.0        0.04 ± 45%  perf-profile.children.cycles-pp.main
      0.07 ± 11%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.14 ± 11%      -0.0        0.12 ± 14%  perf-profile.children.cycles-pp.strcmp
      0.06 ±  7%      +0.0        0.08        perf-profile.children.cycles-pp.__virt_addr_valid
      0.06 ±  9%      +0.0        0.07        perf-profile.children.cycles-pp.af_alg_wmem_wakeup
      0.06 ±  9%      +0.0        0.08        perf-profile.children.cycles-pp.handle_softirqs
      0.12 ± 10%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.10 ± 13%      +0.0        0.13 ±  2%  perf-profile.children.cycles-pp.fdget
      0.12 ± 11%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.06 ± 14%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.13 ±  8%      +0.0        0.16        perf-profile.children.cycles-pp.check_heap_object
      0.04 ± 45%      +0.0        0.08        perf-profile.children.cycles-pp.x64_sys_call
      0.12 ±  8%      +0.0        0.16 ±  6%  perf-profile.children.cycles-pp.crypto_spawn_alg
      0.14 ± 11%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.07 ± 11%      +0.0        0.10 ±  7%  perf-profile.children.cycles-pp.crypto_spawn_tfm
      0.08 ± 16%      +0.0        0.12 ±  6%  perf-profile.children.cycles-pp.get_jiffies_update
      0.12 ± 11%      +0.0        0.16 ± 10%  perf-profile.children.cycles-pp.crypto_mod_put
      0.08 ± 20%      +0.0        0.13 ±  5%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.21 ±  8%      +0.0        0.25 ±  5%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.03 ±100%      +0.0        0.07        perf-profile.children.cycles-pp.__check_heap_object
      0.02 ± 99%      +0.0        0.07        perf-profile.children.cycles-pp.rcu_core
      0.06 ±  7%      +0.0        0.11        perf-profile.children.cycles-pp.stress_time_now_timespec
      0.08 ± 13%      +0.0        0.13        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.09 ± 10%      +0.1        0.14 ±  2%  perf-profile.children.cycles-pp.__fput
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.prandom_u32_state
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      0.02 ±141%      +0.1        0.07        perf-profile.children.cycles-pp.dentry_kill
      0.02 ±141%      +0.1        0.07        perf-profile.children.cycles-pp.finish_dput
      0.03 ±100%      +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.af_alg_accept
      0.27 ±  8%      +0.1        0.32 ±  4%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.02 ± 99%      +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.sock_alloc
      0.24 ±  9%      +0.1        0.30        perf-profile.children.cycles-pp.kfree
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__sha256_final
      0.20 ± 11%      +0.1        0.26        perf-profile.children.cycles-pp.copy_iovec_from_user
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.__md5_final
      0.10 ±  9%      +0.1        0.16 ±  2%  perf-profile.children.cycles-pp.__x64_sys_close
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.alloc_file_pseudo
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.hash_alloc_result
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.import_ubuf
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.kmem_cache_free
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.rcu_do_batch
      0.02 ±141%      +0.1        0.08        perf-profile.children.cycles-pp.alloc_inode
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.sock_alloc_file
      0.32 ±  8%      +0.1        0.38 ±  3%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.map_symbol__exit
      0.43 ±  9%      +0.1        0.49 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.22 ±  8%      +0.1        0.29        perf-profile.children.cycles-pp.__check_object_size
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.crypto_lskcipher_decrypt
      0.34 ±  9%      +0.1        0.41 ±  2%  perf-profile.children.cycles-pp.alloc_pages_noprof
      0.24 ± 10%      +0.1        0.31        perf-profile.children.cycles-pp.__import_iovec
      0.27 ± 10%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.af_alg_pull_tsgl
      0.07 ± 11%      +0.1        0.14 ± 12%  perf-profile.children.cycles-pp.alg_get_type
      0.00            +0.1        0.07 ± 18%  perf-profile.children.cycles-pp.crypto_ahash_init_tfm
      0.24 ± 10%      +0.1        0.32        perf-profile.children.cycles-pp.import_iovec
      0.13 ± 11%      +0.1        0.21        perf-profile.children.cycles-pp.lock_sock_nested
      0.13 ±  9%      +0.1        0.21        perf-profile.children.cycles-pp._raw_spin_lock_bh
      0.00            +0.1        0.08        perf-profile.children.cycles-pp._copy_to_iter
      0.00            +0.1        0.08 ±  8%  perf-profile.children.cycles-pp.crypto_lskcipher_encrypt
      0.02 ± 99%      +0.1        0.11        perf-profile.children.cycles-pp.sock_kzfree_s
      0.00            +0.1        0.09 ± 15%  perf-profile.children.cycles-pp.lskcipher_init_tfm_simple
      0.34 ± 10%      +0.1        0.42        perf-profile.children.cycles-pp.af_alg_alloc_areq
      0.15 ± 11%      +0.1        0.24        perf-profile.children.cycles-pp.release_sock
      0.14 ± 10%      +0.1        0.24 ±  7%  perf-profile.children.cycles-pp.__local_bh_enable_ip
      0.13 ± 10%      +0.1        0.23        perf-profile.children.cycles-pp.do_accept
      0.14 ±  8%      +0.1        0.24        perf-profile.children.cycles-pp.__sys_accept4
      0.14 ±  8%      +0.1        0.24 ±  2%  perf-profile.children.cycles-pp.__x64_sys_accept
      0.01 ±223%      +0.1        0.12 ±  4%  perf-profile.children.cycles-pp.hash_check_key
      0.00            +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.lskcipher_init_tfm_simple2
      0.42 ±  9%      +0.1        0.53        perf-profile.children.cycles-pp.sock_kfree_s
      0.00            +0.1        0.11 ±  7%  perf-profile.children.cycles-pp.aes_xts_decrypt_vaes_avx2
      0.00            +0.1        0.11 ±  5%  perf-profile.children.cycles-pp.aes_xts_encrypt_vaes_avx2
      0.00            +0.1        0.11        perf-profile.children.cycles-pp.aesni_cbc_dec
      0.01 ±223%      +0.1        0.12 ±  3%  perf-profile.children.cycles-pp.hash_sendmsg_nokey
      0.39 ± 10%      +0.1        0.50        perf-profile.children.cycles-pp._copy_from_iter
      0.42 ± 11%      +0.1        0.54        perf-profile.children.cycles-pp.sock_kmalloc
      0.00            +0.1        0.12        perf-profile.children.cycles-pp.sha1_ni_transform
      0.03 ±100%      +0.1        0.15 ±  5%  perf-profile.children.cycles-pp.crypto_init_lskcipher_ops_sg
      0.40 ±  9%      +0.1        0.52        perf-profile.children.cycles-pp._copy_from_user
      0.45 ± 10%      +0.1        0.58        perf-profile.children.cycles-pp.copy_msghdr_from_user
      0.03 ±102%      +0.2        0.19 ± 10%  perf-profile.children.cycles-pp.thread__resolve_callchain_sample
      0.02 ±142%      +0.2        0.18 ± 10%  perf-profile.children.cycles-pp.add_callchain_ip
      0.00            +0.2        0.17 ± 28%  perf-profile.children.cycles-pp.xts_decrypt_vaes_avx2
      0.02 ±141%      +0.2        0.19 ±  5%  perf-profile.children.cycles-pp.aes_ctr64_crypt_vaes_avx2
      0.00            +0.2        0.17 ± 29%  perf-profile.children.cycles-pp.xts_encrypt_vaes_avx2
      0.31 ± 11%      +0.2        0.49        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.09 ±  8%      +0.2        0.27        perf-profile.children.cycles-pp.hash_recvmsg
      0.04 ±104%      +0.2        0.23 ±  9%  perf-profile.children.cycles-pp.__thread__resolve_callchain
      0.04 ±104%      +0.2        0.23 ±  9%  perf-profile.children.cycles-pp.sample__for_each_callchain_node
      0.00            +0.2        0.20 ±  2%  perf-profile.children.cycles-pp._aesni_enc4
      0.00            +0.2        0.20        perf-profile.children.cycles-pp.sha1_update
      0.04 ±102%      +0.2        0.24 ±  8%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
      0.64 ± 12%      +0.2        0.84 ±  5%  perf-profile.children.cycles-pp.af_alg_free_resources
      0.00            +0.2        0.21        perf-profile.children.cycles-pp.aesni_ecb_dec
      0.00            +0.2        0.21        perf-profile.children.cycles-pp.sha1_blocks_ni
      0.11 ±  8%      +0.2        0.32 ± 12%  perf-profile.children.cycles-pp.skcipher_walk_virt
      0.00            +0.2        0.22        perf-profile.children.cycles-pp.aesni_ecb_enc
      0.04 ±102%      +0.2        0.27 ± 11%  perf-profile.children.cycles-pp.ordered_events__deliver_event
      0.04 ±102%      +0.2        0.27 ± 11%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.04 ±102%      +0.2        0.28 ± 11%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.05 ±  8%      +0.2        0.29        perf-profile.children.cycles-pp._aesni_dec4
      0.00            +0.3        0.26        perf-profile.children.cycles-pp.md4_update
      0.49 ± 10%      +0.3        0.76        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.00            +0.3        0.27        perf-profile.children.cycles-pp.md4_transform
      0.09 ±  8%      +0.3        0.36 ± 24%  perf-profile.children.cycles-pp.up_read
      0.00            +0.3        0.29        perf-profile.children.cycles-pp.sha256_ni_transform
      0.12 ±  9%      +0.3        0.41 ± 23%  perf-profile.children.cycles-pp.down_read
      1.00 ± 10%      +0.3        1.30        perf-profile.children.cycles-pp.sg_init_table
      0.10 ± 11%      +0.3        0.45        perf-profile.children.cycles-pp._aesni_enc1
      1.25 ± 10%      +0.4        1.61        perf-profile.children.cycles-pp.__pi_memset
      0.11 ±  6%      +0.4        0.48        perf-profile.children.cycles-pp.aesni_cbc_enc
      0.09 ± 10%      +0.4        0.46 ±  3%  perf-profile.children.cycles-pp.ctr_crypt_vaes_avx2
      0.65 ± 10%      +0.4        1.04        perf-profile.children.cycles-pp.os_xsave
      0.66 ± 10%      +0.4        1.05        perf-profile.children.cycles-pp.save_fpregs_to_fpstate
      0.66 ± 10%      +0.4        1.05 ± 22%  perf-profile.children.cycles-pp.crypto_alg_lookup
      0.03 ±100%      +0.4        0.43 ±  2%  perf-profile.children.cycles-pp.md5_update
      0.66 ±  9%      +0.4        1.07 ± 22%  perf-profile.children.cycles-pp.crypto_alg_mod_lookup
      0.03 ±100%      +0.4        0.44        perf-profile.children.cycles-pp.__sha256_update
      0.06 ±  9%      +0.4        0.47        perf-profile.children.cycles-pp.sha256_blocks_ni
      0.06 ±  9%      +0.4        0.48        perf-profile.children.cycles-pp.md5_block
      0.71 ±  9%      +0.4        1.14        perf-profile.children.cycles-pp.kernel_fpu_begin_mask
      1.08 ± 10%      +0.5        1.56 ±  7%  perf-profile.children.cycles-pp.__pi_memcpy
      0.87 ± 10%      +0.5        1.40        perf-profile.children.cycles-pp.restore_fpregs_from_fpstate
      0.96 ± 10%      +0.6        1.54        perf-profile.children.cycles-pp.switch_fpu_return
      0.97 ± 10%      +0.6        1.56        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      2.14 ± 10%      +0.6        2.78        perf-profile.children.cycles-pp.af_alg_sendmsg
      2.82 ± 10%      +0.8        3.62        perf-profile.children.cycles-pp.____sys_sendmsg
      3.30 ± 10%      +0.9        4.24        perf-profile.children.cycles-pp.___sys_sendmsg
      3.36 ± 10%      +0.9        4.30        perf-profile.children.cycles-pp.__sys_sendmsg
      1.03 ± 21%      +1.2        2.20 ±  4%  perf-profile.children.cycles-pp.hash_sendmsg
      1.09 ± 19%      +1.3        2.38 ±  4%  perf-profile.children.cycles-pp.__sys_sendto
      1.09 ± 19%      +1.3        2.38 ±  4%  perf-profile.children.cycles-pp.__x64_sys_sendto
      4.53 ± 10%      +1.5        6.00        perf-profile.children.cycles-pp.stress_rndbuf
      9.01 ± 10%      +7.3       16.35        perf-profile.children.cycles-pp.des3_ede_encrypt
      5.33 ± 10%     +10.4       15.77        perf-profile.children.cycles-pp.des3_ede_decrypt
      3.13 ± 16%     +14.8       17.93        perf-profile.children.cycles-pp.des_encrypt
      1.98 ± 10%     +15.7       17.68        perf-profile.children.cycles-pp.des_decrypt
      3.64 ±  9%     +20.3       23.91        perf-profile.children.cycles-pp.crypto_cbc_decrypt
      3.63 ±  9%     +20.3       23.90        perf-profile.children.cycles-pp.crypto_cbc_decrypt_segment
     20.63 ± 15%     +21.1       41.69        perf-profile.children.cycles-pp.__sys_recvfrom
     20.63 ± 15%     +21.1       41.70        perf-profile.children.cycles-pp.__x64_sys_recvfrom
      3.89 ±  9%     +21.8       25.65        perf-profile.children.cycles-pp.crypto_cbc_encrypt
      3.88 ±  9%     +21.8       25.64        perf-profile.children.cycles-pp.crypto_cbc_encrypt_segment
      9.89 ±  9%     +25.4       35.28        perf-profile.children.cycles-pp.crypto_ecb_decrypt2
     10.05 ±  8%     +26.2       36.25        perf-profile.children.cycles-pp.crypto_ecb_encrypt2
     38.11 ± 14%     +41.8       79.89        perf-profile.children.cycles-pp._skcipher_recvmsg
     38.32 ± 14%     +41.9       80.19        perf-profile.children.cycles-pp.skcipher_recvmsg
     52.97 ±  9%     +46.6       99.59        perf-profile.children.cycles-pp.stress_af_alg
     20.45 ±  8%     +53.6       74.06        perf-profile.children.cycles-pp.crypto_lskcipher_crypt_sg
     31.66 ± 10%     -31.7        0.00        perf-profile.self.cycles-pp.sha3_keccakf_one_round_generic
      8.76 ±  9%      -8.8        0.00        perf-profile.self.cycles-pp.jent_memaccess
      0.31 ± 14%      -0.3        0.04 ± 73%  perf-profile.self.cycles-pp.queue_event
      0.14 ±  8%      -0.0        0.11 ± 14%  perf-profile.self.cycles-pp.strcmp
      0.07 ± 11%      -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.ktime_get_update_offsets_now
      0.06 ± 11%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.__virt_addr_valid
      0.06 ±  9%      +0.0        0.07        perf-profile.self.cycles-pp.af_alg_wmem_wakeup
      0.06 ± 11%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.check_heap_object
      0.07 ± 11%      +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.sock_read_iter
      0.06 ± 13%      +0.0        0.08        perf-profile.self.cycles-pp.____sys_sendmsg
      0.06 ±  9%      +0.0        0.08 ±  8%  perf-profile.self.cycles-pp.kernel_fpu_begin_mask
      0.10 ± 11%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.fdget
      0.08 ±  9%      +0.0        0.11 ±  7%  perf-profile.self.cycles-pp.sg_init_table
      0.10 ± 13%      +0.0        0.14 ±  5%  perf-profile.self.cycles-pp.af_alg_get_rsgl
      0.07 ± 11%      +0.0        0.10        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.02 ± 99%      +0.0        0.06        perf-profile.self.cycles-pp._skcipher_recvmsg
      0.06 ± 11%      +0.0        0.10        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.11 ± 10%      +0.0        0.15        perf-profile.self.cycles-pp._raw_spin_trylock
      0.08 ± 16%      +0.0        0.12 ±  6%  perf-profile.self.cycles-pp.get_jiffies_update
      0.11 ± 14%      +0.0        0.15 ± 11%  perf-profile.self.cycles-pp.gup_fast_pgd_range
      0.04 ± 71%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.x64_sys_call
      0.20 ± 12%      +0.0        0.24        perf-profile.self.cycles-pp.__kmalloc_noprof
      0.03 ±100%      +0.0        0.07        perf-profile.self.cycles-pp.__check_heap_object
      0.06 ±  9%      +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.stress_time_now_timespec
      0.12 ±  9%      +0.0        0.16 ± 10%  perf-profile.self.cycles-pp.crypto_mod_put
      0.03 ±100%      +0.0        0.07 ±  6%  perf-profile.self.cycles-pp.extract_iter_to_sg
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__check_object_size
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__free_frozen_pages
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.import_ubuf
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.prandom_u32_state
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.rmqueue
      0.10 ±  9%      +0.1        0.15        perf-profile.self.cycles-pp.do_syscall_64
      0.02 ± 99%      +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.gup_fast
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.crypto_lskcipher_decrypt
      0.01 ±223%      +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.iov_iter_extract_pages
      0.17 ± 10%      +0.1        0.23 ±  2%  perf-profile.self.cycles-pp.af_alg_pull_tsgl
      0.09 ± 11%      +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.switch_fpu_return
      0.10 ± 11%      +0.1        0.16        perf-profile.self.cycles-pp.__sys_recvfrom
      0.20 ± 11%      +0.1        0.26        perf-profile.self.cycles-pp.copy_iovec_from_user
      0.20 ± 10%      +0.1        0.26        perf-profile.self.cycles-pp.af_alg_sendmsg
      0.23 ±  9%      +0.1        0.30        perf-profile.self.cycles-pp.kfree
      0.22 ± 10%      +0.1        0.29        perf-profile.self.cycles-pp.sock_kfree_s
      0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp._copy_to_iter
      0.14 ± 11%      +0.1        0.21 ±  4%  perf-profile.self.cycles-pp.af_alg_free_resources
      0.22 ± 11%      +0.1        0.30        perf-profile.self.cycles-pp.sock_kmalloc
      0.13 ±  9%      +0.1        0.21        perf-profile.self.cycles-pp.lock_sock_nested
      0.13 ± 10%      +0.1        0.21        perf-profile.self.cycles-pp._raw_spin_lock_bh
      0.00            +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.crypto_lskcipher_encrypt
      0.13 ± 11%      +0.1        0.23 ±  7%  perf-profile.self.cycles-pp.__local_bh_enable_ip
      0.00            +0.1        0.11 ±  4%  perf-profile.self.cycles-pp.aes_xts_encrypt_vaes_avx2
      0.00            +0.1        0.11 ±  8%  perf-profile.self.cycles-pp.aes_xts_decrypt_vaes_avx2
      0.00            +0.1        0.11 ± 10%  perf-profile.self.cycles-pp.crypto_cbc_encrypt_segment
      0.38 ±  9%      +0.1        0.49        perf-profile.self.cycles-pp._copy_from_iter
      0.00            +0.1        0.11 ±  4%  perf-profile.self.cycles-pp.crypto_cbc_decrypt_segment
      0.00            +0.1        0.12        perf-profile.self.cycles-pp.sha1_ni_transform
      0.40 ± 10%      +0.1        0.52        perf-profile.self.cycles-pp._copy_from_user
      0.02 ±141%      +0.2        0.19 ±  5%  perf-profile.self.cycles-pp.aes_ctr64_crypt_vaes_avx2
      0.31 ± 10%      +0.2        0.48        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.00            +0.2        0.20 ±  2%  perf-profile.self.cycles-pp._aesni_enc4
      0.11 ± 10%      +0.2        0.32 ± 12%  perf-profile.self.cycles-pp.skcipher_walk_virt
      0.05 ±  8%      +0.2        0.28        perf-profile.self.cycles-pp._aesni_dec4
      0.49 ± 10%      +0.3        0.75        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.00            +0.3        0.27        perf-profile.self.cycles-pp.md4_transform
      0.09 ±  8%      +0.3        0.36 ± 24%  perf-profile.self.cycles-pp.up_read
      0.00            +0.3        0.29        perf-profile.self.cycles-pp.sha256_ni_transform
      0.12 ±  9%      +0.3        0.41 ± 24%  perf-profile.self.cycles-pp.down_read
      0.10 ± 11%      +0.3        0.45        perf-profile.self.cycles-pp._aesni_enc1
      1.24 ± 10%      +0.4        1.60        perf-profile.self.cycles-pp.__pi_memset
      0.65 ± 10%      +0.4        1.04        perf-profile.self.cycles-pp.os_xsave
      0.06 ±  9%      +0.4        0.48        perf-profile.self.cycles-pp.md5_block
      1.07 ± 10%      +0.5        1.53 ±  7%  perf-profile.self.cycles-pp.__pi_memcpy
      0.87 ± 10%      +0.5        1.40        perf-profile.self.cycles-pp.restore_fpregs_from_fpstate
      4.50 ± 10%      +1.5        5.96        perf-profile.self.cycles-pp.stress_rndbuf
      0.17 ± 13%      +1.6        1.79 ±  5%  perf-profile.self.cycles-pp.crypto_ecb_decrypt2
      0.17 ± 13%      +1.8        1.92 ±  6%  perf-profile.self.cycles-pp.crypto_ecb_encrypt2
      8.96 ± 10%      +7.3       16.25        perf-profile.self.cycles-pp.des3_ede_encrypt
      5.30 ± 10%     +10.4       15.69        perf-profile.self.cycles-pp.des3_ede_decrypt
      3.10 ± 17%     +14.7       17.81        perf-profile.self.cycles-pp.des_encrypt
      1.96 ± 10%     +15.6       17.55        perf-profile.self.cycles-pp.des_decrypt





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

