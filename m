Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DA03A1BA;
	Mon, 27 May 2024 08:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797387; cv=fail; b=fdLZUUyn3vundtOZIN/7jtAmVlEGlQODuoYPBKkbMwmifTD6IcrRN2zTnwHIHK3WpX62Q7mNIq2k4kpa/i5ydeE8U/Dc7330TacOiqJCb5qWRfJRWKxzZ5ryexKmdZ1mMVOEvbWwApjeF1ry2VbyliOW0Q5HuzlxKsOEDbipUbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797387; c=relaxed/simple;
	bh=jHtcg2Hh9iWzPNT7JV7ScTHm9+lHemptRbC66qxnYdg=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=HlWb0pTFCpv35X6gDQ5UZH63D69WsQK5G7E8VQK+Au+Fh1XPzcbUcp80x/DBvRSLXyGdkHzsLHp3OUVxNYbPW0fBHwdwlMs34d+SlKDOoQstSMKIU3GsiOS3C8Oya4QEnTrVvOEeIuvj3ZIPsZ5roQ5C8/ooBvt9gaS6mrFe+44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/KZ+m8+; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/KZ+m8+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716797384; x=1748333384;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=jHtcg2Hh9iWzPNT7JV7ScTHm9+lHemptRbC66qxnYdg=;
  b=g/KZ+m8+WfBLmn7UteW7Lc5YgM5GVju8VA38m3khm7syN1SnPc+17DhD
   BAF+GVL3ZeJMHGBM8lQVbI/L7LqtcBcOvRMjRsL3lMwk8bDblZe/u9nLC
   fDAf3YoQJ9NeUAqfr7YjliWXe0B7Td8ii+d48G3RsUrELXfYAdmONVdAW
   bfgl2TSJ1VbLT1YNrqirVDcNecVezRA1W8LOckFCD28AEGJh2bEsdt2jd
   zv7/laoakzO8/d7W4Y9dX22+uN7pR2dPTAVcMy1wKwuNsAwmIHXOtUQ82
   ejXDMNMcKcZV+1DFglixnfdAFx6nBAtRveNJEoZWvbBZn7RWakzfuZ0tv
   g==;
X-CSE-ConnectionGUID: Cw/MQaYWQ9+ywIo96F2+pg==
X-CSE-MsgGUID: GwjD0yUtQB291dXTcs4bNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="12923979"
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="12923979"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 01:09:43 -0700
X-CSE-ConnectionGUID: 91gGvaNLQR2TIC4WY18PPw==
X-CSE-MsgGUID: XgaSdPCSSHWLXsh23uXQ8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="34691305"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 01:09:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 01:09:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 01:09:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 01:09:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 01:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L91pfQ6WO0k71u3iFfIHmcUuNTRBVBWxVkZO034DUUtYztgyG/IIBAGV2uWm5LMNvIAuiemimZdFSudMCIE6O88HAZ0okHI/2UdW9Z4QemLvasvHdm6ASXmMouVBC491ltpCPYk72Lbfik649qA2QI63rGhCQfXFU/cwiWXOnBnz1uFntE4JchxbogyuK5i6MHHbHLOnnMjNHG4TlG1csvE/Z6kf+r4mZpgOeMWAm+jMJNY0UBXnzBqGDhkQOgjuR7FD7/7Wlc35etCgQPptfB1FTx3lzfunMMv5kKDDvcsI4oeloxtmfjqkNbsFF6GupZEAWoSElTUzcLjNX4TIPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgzylRTnflbcQojCxTqB8yWvDsTtD4tToIDGsmp72qE=;
 b=hkymKyFp4rkPR3U5LJIxxWtrd8fL3lundIgA1q5HlhXmB48xr8NefsJFuHNos1OPBG++RSYPoRSAYD98KMUyKeFJDnbjpRDQ/2WMVKwfdoF76M4zwVS2soDCEoW+DNm8tzbxLAUc9Iz8Tzngcq4VN3KKG8gGivkwej/Zz5N348mWnLQjD9/jJakKbZSeVroc6sXWhteVPP6r2wmzEouR8I57A0izifukxuF9JT/EReCTr+3gdPmGlz9EDwWq+nZH74Id1Z7M5P4SCDKO9IO0M14B/9jRfmmnkIdSl+TNdfuKw1soX5WrNgSXbRUiRqPqDY1IdAmo3nVq81BqIvY2Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 08:09:40 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 08:09:40 +0000
Date: Mon, 27 May 2024 16:09:31 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: [linus:master] [crypto]  996f4dcbd2:  stress-ng.sockfd.ops_per_sec
 11.0% improvement
Message-ID: <202405271558.f424aa27-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: e70390f8-6604-4bee-2fa0-08dc7e245bbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?lxk/rm0+92xIsy3zY5JyODNof3poOSrWBIuXlahf3fTMCPJkN/umlRBI8E?=
 =?iso-8859-1?Q?BuU89ZCr/VRZeG3ELYa6pkprFE+pYrOWiwHjXKl1LZ6dCc3yIDhEN+U+Fd?=
 =?iso-8859-1?Q?X2NLIi/p/vXoQ1TzrCM/VdQMZJlJMMumrVTMsHV8JDaYAL2+b0loFg2oCD?=
 =?iso-8859-1?Q?xMyMKNuxhZgTK13aZ5s6ItAC/1loJ9TBwusVJ2k8nQqgwS7F3+gHGCAJnA?=
 =?iso-8859-1?Q?6X8YpY4pJk2Yg7aXTDycAlKwFgej0hSc8ZCuiQjpxW+MInFkho476STx24?=
 =?iso-8859-1?Q?bezKgk5FlH6pqfx+iPfwcu9E847CRuZFSMxvZ+hJBRUnCYac4/pQhbToY/?=
 =?iso-8859-1?Q?1FHUKDu3AXaIsIaYmHzxyNSNFhRvwrFaHH5qKFwjQf6iuaSt/o/0cbYtSk?=
 =?iso-8859-1?Q?MmEA8fzxSVSD82pk6DWvL2R7iiSKBimzc0T4wmymPSr/ygttwCZuXMRujv?=
 =?iso-8859-1?Q?tzgP+4q70msCsA9thQAsXAEURO6P55QU0ZTHZ/AcVE403Hc+2XKQl1KWCR?=
 =?iso-8859-1?Q?qWJw1VMY7jFaU+ZvuidgelsHS5birHCAmW8GeoTzsAAvaHxrypw+9xRfk5?=
 =?iso-8859-1?Q?wMWIlxI/hatFYzjYl1/Sgw9NlTk+kzIJ/Wig7bfmnC4s+c0ynD37yFE9u3?=
 =?iso-8859-1?Q?jVWYRRjqXUrSWkXpwFvlU9EAblCbiGj4V4xiOFkPd4TmQKxHz4SFEpuIq5?=
 =?iso-8859-1?Q?ZB2ksrc1BFIR4x8vIlaiS93At9007SHy3MtmKY8lVDoskmh0DooahXp7FQ?=
 =?iso-8859-1?Q?raaaf7AnSlTsInxhdodNIEwG/Llyk4Bggs/a266+VSrGUC4rLdBLic1nHp?=
 =?iso-8859-1?Q?+UB+Mg4AmZ/flSvIwalV7ct2GdL+7Fy5m/MU9xTfCBjqzPqr9ZUiiEKIY6?=
 =?iso-8859-1?Q?TWOjTYieRFUapToM9FR1oCZ2Zo7InXvJCDERr+ZocYdXyPIwvaFK44wfc5?=
 =?iso-8859-1?Q?7sjdUowrEXgmpLtE+NndAz8GIUMLcTSzNtd4S4uS0IM56tyWWrlRtxL1WJ?=
 =?iso-8859-1?Q?Z4GwSvEHbO2c32fHQSbgWFsEx8t3AKpeZRd+2lB8kjKeybVMi/1N2ugvuo?=
 =?iso-8859-1?Q?j6qxRCYY/pKd9/p63e+E8Hictgb08lbLTAk+zmL9HjEe6r37nf2xNF3s9N?=
 =?iso-8859-1?Q?IEex8r2jL4H9FyxtUUYwM+PU0Y4VTiJLd5nonuI18IlXXgm3cYGzBdjydr?=
 =?iso-8859-1?Q?3aW/wMqqlVCSOG0OnwowhKHmOOxbFY7E9zzPgB26h74WB8V6aTYmUwB2bd?=
 =?iso-8859-1?Q?6zWvQBEABj8SS4Y39DL6v1+oYovVTgIu6j25Wdfg0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cD83qDAXNovrV8mkvVcBiyq3Rwq0bJUwWFlfw/bKZILDRkulu8DpGgFieB?=
 =?iso-8859-1?Q?knvUUdb0Om/iq6TlQWXvOfqWRZI47da06q0sFJ5tSmV2cxXVU0ck12s8sL?=
 =?iso-8859-1?Q?x/5yEhfLRnzLPfUvw3BdM2YpBWqX5pVr9/mf5FlJhS80JLIYiln6Ukio6e?=
 =?iso-8859-1?Q?iDYc8G6chL+58F0/spxbA6+Bmcs6hIxGeG5n2ajSXQEYvehIM0rl5NloFG?=
 =?iso-8859-1?Q?MRc1qt7O5wYNniYe9P7C4GpYtzr1MZUD+KOSSs7B55bEeTCTw8trWq9AX8?=
 =?iso-8859-1?Q?UN+8USAtEhYobg5Xoqk1uIE0yym5FpPGeLjX63n0DhjiJjFsGjiKRQMLSQ?=
 =?iso-8859-1?Q?Q9GTnW64cFt1lxdbiBOBgFyOZciPW+MwZ7kOTJDDUFKsMXLe/DRtE9hYml?=
 =?iso-8859-1?Q?UJFxPMDrq/x5PDlSdqbEse7q3Qseo+TOVXqufi8Kp9KmYMkMJrNQNYoRFN?=
 =?iso-8859-1?Q?+rnUErUWANVz1k1oBkOI+GrsnJ7e+x21W02kL+one7n4Z6Y9MG+j1fUdW/?=
 =?iso-8859-1?Q?ymCA7rBrUi+F9Bwx3wJxKbS1g27UK0+cnq6MK0GMlfaFY9VF5yZlhZ8eb8?=
 =?iso-8859-1?Q?6hkk1z9dc4phy6xSrQNL1RxaiNTbkiZHdcLRWlOuoBtdsBPvgJaUTzeAnJ?=
 =?iso-8859-1?Q?96/vrNTsjOPOr61lzx1oy8jtNVkoCvNYmNPbIMSV0kS56ic/hgUaFVIxxz?=
 =?iso-8859-1?Q?zZ/f65vvnL1GOObWBNefsEu3apO6QjkAoO9PQ9KioeNPI4olmpcgQXXTrC?=
 =?iso-8859-1?Q?oBY8DoqhhAVja2OYICbzSUPtIvU9oCZQGAu08BBvidKT8FNZfuaUKk6EYD?=
 =?iso-8859-1?Q?zKlGczEGFTV3TdEslB2DC8W1CzjtQ1BulxZK4Y4vqPv9ZOwSta6JcIEl8v?=
 =?iso-8859-1?Q?xCDej4rQ/dralWLxj0+49GBEMDnPkTBZzjjjnMosLAn2fq0iMmVLo6bZl/?=
 =?iso-8859-1?Q?73AU1RYRb8LZL0EVZwJ4ycVGi58FHbPtjDO9PQpJ5fzKEOCFV3d3Bn7FVe?=
 =?iso-8859-1?Q?vlcAeaEhcdjbHYpQnYbVtpivy/uFgjZ8PcXi7QJ/8oKi43/r377MkRixy1?=
 =?iso-8859-1?Q?AvGc1PJ5ucGdoARuJlSPe3JG4vRSxdPB9rie41fRXpSJfzq80YAytKEg7I?=
 =?iso-8859-1?Q?R6qv18KD6Bt5XKOv2VtndCqK7UOz2NFho8yYo2oZq6yIGlzedl7wea2Urr?=
 =?iso-8859-1?Q?D0YLGTuyhxu0EKnM/DLNFVrMEYXtkYE5FwTbT3vH57vzRtQE+R1PxP9Zis?=
 =?iso-8859-1?Q?TdstV6wENtfVCWmSfDhzSasZuFZEGgn8PrIXdvxnKXIMIuL8ZzTU148eUu?=
 =?iso-8859-1?Q?0nbG1CBHvURiESfIyMB27L5lNSF1UpRQVWpkIcGCmObXfzSJ1yu3lJVqgi?=
 =?iso-8859-1?Q?+eGuVku3ZX1dXBYIAI86zcqMI81945E1u31VL0cVu7NEhOl+QaTBLGZusW?=
 =?iso-8859-1?Q?E7nJOkzKiY7elL5OPvQA4KDchGe6GIUcswqK/6o+5tDCj7nZwz0kxVkX3F?=
 =?iso-8859-1?Q?ycJDU9xG7BBVD5JvkyZwm+3tknVyfkkQRdUpa10ai+ivWQaCvVxGgMSMKS?=
 =?iso-8859-1?Q?DQ/Rsp9791mQoXluFzySLtDf64keGe1efmzXg/l9Sbk0oOE2mKh9R3dmPy?=
 =?iso-8859-1?Q?bWMQEM6kKubRrNxP5upV6yOacwKtZaFntPsgnOCV6dC5Kp63p0xkZnow?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e70390f8-6604-4bee-2fa0-08dc7e245bbf
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 08:09:40.6210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdICaZO2Vjh7iIhKa3HWlxpUqKkpFQ3JY7s/fxlPNL9v1CcM/jiCnR9Z1WHi63myUpfiHhiOxxvcWjZB043XQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 11.0% improvement of stress-ng.sockfd.ops_per_sec on:


commit: 996f4dcbd231ec022f38a3c27e7fc45727e4e875 ("crypto: x86/aes-xts - wire up AESNI + AVX implementation")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: sockfd
	cpufreq_governor: performance






Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240527/202405271558.f424aa27-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-13/performance/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-spr-r02/sockfd/stress-ng/60s

commit: 
  d637168810 ("crypto: x86/aes-xts - add AES-XTS assembly macro for modern CPUs")
  996f4dcbd2 ("crypto: x86/aes-xts - wire up AESNI + AVX implementation")

d6371688101223a3 996f4dcbd231ec022f38a3c27e7 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    730290 ± 11%     +26.2%     921636 ± 13%  meminfo.Mapped
     24673 ±  2%      +8.1%      26682 ±  3%  perf-c2c.HITM.total
     61893            +3.6%      64151        vmstat.system.cs
      0.28 ±  8%     -11.6%       0.25 ±  9%  sched_debug.cfs_rq:/.h_nr_running.stddev
    196.71 ±  6%     -11.8%     173.53 ± 11%  sched_debug.cfs_rq:/.util_est.stddev
  46304617           +11.0%   51404735        stress-ng.sockfd.ops
    771591           +11.0%     856468        stress-ng.sockfd.ops_per_sec
   2336146            -3.1%    2263883        stress-ng.time.involuntary_context_switches
   1365039 ±  2%     +15.8%    1580362        stress-ng.time.voluntary_context_switches
    183309 ± 11%     +26.1%     231069 ± 13%  proc-vmstat.nr_mapped
   1843540            +2.4%    1888288        proc-vmstat.numa_hit
   1611479            +2.8%    1656095        proc-vmstat.numa_local
   2952001 ±  3%      +5.1%    3103307        proc-vmstat.pgalloc_normal
   2282989 ±  4%      +7.5%    2454018 ±  2%  proc-vmstat.pgfree
      0.42 ±  2%      +6.2%       0.44        perf-stat.i.MPKI
 1.487e+10            +1.8%  1.513e+10        perf-stat.i.branch-instructions
  25452853            +9.2%   27794083        perf-stat.i.cache-misses
  85628078            +8.2%   92619680        perf-stat.i.cache-references
     63603 ±  2%      +4.2%      66264        perf-stat.i.context-switches
     10.03            -1.7%       9.86        perf-stat.i.cpi
     26278            -9.1%      23887        perf-stat.i.cycles-between-cache-misses
  6.35e+10            +2.2%  6.488e+10        perf-stat.i.instructions
      0.10            +1.5%       0.10        perf-stat.i.ipc
      0.06 ± 46%    +140.8%       0.14 ± 40%  perf-stat.i.major-faults
      0.40            +7.8%       0.43        perf-stat.overall.MPKI
     10.18            -2.0%       9.97        perf-stat.overall.cpi
     25755            -9.1%      23420        perf-stat.overall.cycles-between-cache-misses
      0.10            +2.0%       0.10        perf-stat.overall.ipc
 1.423e+10            +1.3%  1.442e+10        perf-stat.ps.branch-instructions
  49502972        +8.1e+05%  3.998e+11 ±223%  perf-stat.ps.branch-misses
  23994964            +9.7%   26326983        perf-stat.ps.cache-misses
  82930036            +8.2%   89756764        perf-stat.ps.cache-references
     61357            +3.3%      63381        perf-stat.ps.context-switches
 6.072e+10            +1.8%   6.18e+10        perf-stat.ps.instructions
      0.04 ± 46%    +137.6%       0.11 ± 37%  perf-stat.ps.major-faults
 3.653e+12            +1.6%  3.712e+12        perf-stat.total.instructions
     48.81            -0.2       48.59        perf-profile.calltrace.cycles-pp.unix_inflight.unix_scm_to_skb.unix_stream_sendmsg.____sys_sendmsg.___sys_sendmsg
     48.45            -0.2       48.29        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.unix_notinflight.unix_stream_read_generic.unix_stream_recvmsg
     48.57            -0.2       48.42        perf-profile.calltrace.cycles-pp.unix_notinflight.unix_stream_read_generic.unix_stream_recvmsg.sock_recvmsg.____sys_recvmsg
     48.53            -0.2       48.38        perf-profile.calltrace.cycles-pp._raw_spin_lock.unix_notinflight.unix_stream_read_generic.unix_stream_recvmsg.sock_recvmsg
     49.02            -0.1       48.88        perf-profile.calltrace.cycles-pp.unix_stream_recvmsg.sock_recvmsg.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg
     49.01            -0.1       48.87        perf-profile.calltrace.cycles-pp.unix_stream_read_generic.unix_stream_recvmsg.sock_recvmsg.____sys_recvmsg.___sys_recvmsg
     49.02            -0.1       48.88        perf-profile.calltrace.cycles-pp.sock_recvmsg.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg.do_syscall_64
     49.04            -0.1       48.90        perf-profile.calltrace.cycles-pp.____sys_recvmsg.___sys_recvmsg.__sys_recvmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe
     49.11            -0.1       48.97        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.recvmsg.stress_sockfd
     49.14            -0.1       49.00        perf-profile.calltrace.cycles-pp.recvmsg.stress_sockfd
     49.08            -0.1       48.95        perf-profile.calltrace.cycles-pp.__sys_recvmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe.recvmsg.stress_sockfd
     49.07            -0.1       48.94        perf-profile.calltrace.cycles-pp.___sys_recvmsg.__sys_recvmsg.do_syscall_64.entry_SYSCALL_64_after_hwframe.recvmsg
     49.11            -0.1       48.98        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.recvmsg.stress_sockfd
      0.56 ±  3%      +0.1        0.65 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.open64
      0.56 ±  3%      +0.1        0.65 ±  3%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
      0.58 ±  2%      +0.1        0.67 ±  3%  perf-profile.calltrace.cycles-pp.open64
      0.55 ±  3%      +0.1        0.64 ±  3%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
      0.56 ±  3%      +0.1        0.65 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
      0.17 ±141%      +0.4        0.57 ±  3%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
      0.17 ±141%      +0.4        0.58 ±  4%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     97.19            -0.4       96.83        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     97.49            -0.4       97.13        perf-profile.children.cycles-pp._raw_spin_lock
     48.81            -0.2       48.59        perf-profile.children.cycles-pp.unix_inflight
     48.57            -0.2       48.42        perf-profile.children.cycles-pp.unix_notinflight
     49.02            -0.1       48.88        perf-profile.children.cycles-pp.unix_stream_read_generic
     49.02            -0.1       48.88        perf-profile.children.cycles-pp.unix_stream_recvmsg
     49.03            -0.1       48.89        perf-profile.children.cycles-pp.sock_recvmsg
     49.04            -0.1       48.90        perf-profile.children.cycles-pp.____sys_recvmsg
     49.09            -0.1       48.95        perf-profile.children.cycles-pp.__sys_recvmsg
     49.07            -0.1       48.94        perf-profile.children.cycles-pp.___sys_recvmsg
     49.15            -0.1       49.02        perf-profile.children.cycles-pp.recvmsg
      0.09            +0.0        0.10        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.sock_alloc_send_pskb
      0.12 ±  3%      +0.0        0.14 ±  2%  perf-profile.children.cycles-pp.alloc_empty_file
      0.07 ±  8%      +0.0        0.09 ± 11%  perf-profile.children.cycles-pp.dput
      0.07 ± 11%      +0.0        0.09 ± 12%  perf-profile.children.cycles-pp.lockref_put_return
      0.12 ±  3%      +0.0        0.15 ±  7%  perf-profile.children.cycles-pp.__fput
      0.22 ±  2%      +0.0        0.24 ±  5%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.17 ±  2%      +0.0        0.20 ±  6%  perf-profile.children.cycles-pp.task_work_run
      0.18 ±  3%      +0.0        0.21 ±  6%  perf-profile.children.cycles-pp.syscall
      0.17 ±  6%      +0.0        0.21 ±  7%  perf-profile.children.cycles-pp.do_dentry_open
      0.02 ±141%      +0.0        0.06 ± 28%  perf-profile.children.cycles-pp.generic_perform_write
      0.09 ±  5%      +0.0        0.14 ± 37%  perf-profile.children.cycles-pp.cmd_record
      0.09 ±  5%      +0.0        0.14 ± 37%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.26 ±  5%      +0.0        0.31 ±  6%  perf-profile.children.cycles-pp.do_open
      0.08 ±  8%      +0.0        0.13 ± 34%  perf-profile.children.cycles-pp.perf_mmap__push
      0.09 ±  5%      +0.1        0.14 ± 35%  perf-profile.children.cycles-pp.main
      0.09 ±  5%      +0.1        0.14 ± 35%  perf-profile.children.cycles-pp.run_builtin
      0.50 ±  3%      +0.1        0.58 ±  3%  perf-profile.children.cycles-pp.do_filp_open
      0.49 ±  3%      +0.1        0.57 ±  4%  perf-profile.children.cycles-pp.path_openat
      0.56 ±  3%      +0.1        0.64 ±  3%  perf-profile.children.cycles-pp.do_sys_openat2
      0.56 ±  3%      +0.1        0.65 ±  3%  perf-profile.children.cycles-pp.__x64_sys_openat
      0.59 ±  2%      +0.1        0.69 ±  3%  perf-profile.children.cycles-pp.open64
     96.75            -0.3       96.40        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.07 ± 11%      +0.0        0.09 ± 12%  perf-profile.self.cycles-pp.lockref_put_return




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

