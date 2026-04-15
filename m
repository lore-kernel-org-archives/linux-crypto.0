Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B643CB2EA
	for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 08:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776242768; cv=fail; b=tooPUraVGyEye/8E65T+TC84nYbsMqxg+dBVc9mzFkNRH3S4RQ0rncriw/4VjN+4SFSu5F4+5lzxO3IKbYc/Z2ZB/0G6CXDwhD4qHZtAzTwaIyWgmCisMaB7vtyWK4QPX0VNvX5HYlKuQQYvICttj8fUBcmDrkmnFOzJ950L6iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776242768; c=relaxed/simple;
	bh=yskwqddrTOnbfugJeyxPW3rm+b2xfuZaj0OgKYUS5NQ=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Ar1l/9vUhnK4hte0ATiw7bl6/o9d7OFWWLSYQPKiSdacxig60Lb9Ovv/x2K2UytaAQjJzU5qod346LrjA20vJfu8LhytRylqB4jpPluEbElg4sHqv4WlIMaw6mhQnxtOTGdXGGQXIgWyk0GuYP8mBlQ67Ed4XVVUdzYKHvjCX4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSmf9VbM; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSmf9VbM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776242766; x=1807778766;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=yskwqddrTOnbfugJeyxPW3rm+b2xfuZaj0OgKYUS5NQ=;
  b=lSmf9VbMxsblJ8kW7lU7rehbUsgl4sNWRuIhZgsvmuYN3B+Df5CWjPsl
   gR/7W7uckg4KOOZ2vO4Xo06eaOw96kLtQsrBBK+yOBO4ycHTKYD8g5Y3G
   suKeo/4gTuERfbCP2fNsgZwyLITvBRewrzU2DVOs5az1+XCXfA8s7ogn2
   h/HSDH1TaHPXrEJCnX1KSgvbcpmfIS5BrzGqcNsJkXKBEzGKvB4UjaztW
   YBqfAw7AMn0WtQKtHd03efwaM+h78yo3uSbSAIJ3JjwH3FJhhxkeztBJE
   6jgrbJS9vTBCNyPCyCLysSkpAQLRfSwiaU38E3AGK2RYfBcDvgd8j2jVE
   w==;
X-CSE-ConnectionGUID: 1XvBG0WZQKCQ9ET+W1TB8Q==
X-CSE-MsgGUID: 1RB3fQNpR/OUouxultJg2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="94783934"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="94783934"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 01:46:05 -0700
X-CSE-ConnectionGUID: Pm4UBOoNR7qAr/NHtGMb0Q==
X-CSE-MsgGUID: bIeU/bTRRa2BP9dIevYR1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="230580149"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 01:46:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 01:46:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 15 Apr 2026 01:46:04 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.48) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 01:46:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LMJX3H1QG3kaCBgN3HTutncpGgmOFaNoShEmT2dpmLZyscGGI/sBi6fjbbr0Xic9UT8fyYrQ1sWYUoGPj6JYKNOHjYtWm+LLwfc0SzkOEG7laXw5BHjw5ZJ9eECvxSVVIm2FOZD2fuxfZN5L7A4UBRcqRV06WN42RiwZYKA7s37tolbTCaTzCUD3i7+WbPlTXoi29If/l83mnhycDjOBu+uALglrXk67GjCUUdw4L20bY0bOgfqIfYT5pw1u8Gdx2bD4lQR6EmUMUA71aaVowTfNtrR72Y0UHlvUgdsMcl4VYin+1E+kkTmc0aTSVYFAg37+QNFsmy4yFbVumCrgkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/ekBIvkmVeqhjFC+STG+BS1brpOTvDEeAMozhsseW8=;
 b=hYlu/Znjl3JSyaHVNkhYb8C6nKVfk1mc+fh0lgNC+r+FhB+BZH+2D67C5nO/um/p/3B9HWcWo2qwGmypa1LbUQr3wz1ysyxnxBBo3ikFJDeyXtgBE97fuPG/t5md9YUYGV4peIGutpHtHZ43bZaNzfF8uAHI5ehvc485iqv0Jm+ElChDfPlJiIe6glUV/KdQzmb2wnMky1qtgAqJy/4CXohlOTsgJl7hqH+gOoQ1gSZKvBRyazLC7elWfrrpWvBfKn7xliq+NJ/0SOJyq+7gAwGYiHvyjUE62Hz9RKb/6jzrpqOf/kYGU+4BN6jasvYYE9U1+V4LfebZOaGZSfFM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 08:45:57 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 08:45:57 +0000
Date: Wed, 15 Apr 2026 16:45:48 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Ard Biesheuvel
	<ardb@kernel.org>, <linux-crypto@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [lib/crypto]  e5046823f8:
 stress-ng.urandom.ops_per_sec 4.3% regression
Message-ID: <202604151657.8e26ef70-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::7) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SN7PR11MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: 40dcd72c-02af-43e9-d0d6-08de9acb6946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: rV+h8uljP1z8Z2mhkdH53MJ+NI7Z0GxNRktydwe26+ymaDXi9E7UA/VO330iEgmCdB5xYUat9weUoPp5hAgzJNblvOBq8uckjCIx3C9bErGDyRbnrsbApF64WC7IUbtbbb1O172c+pkB8EySY0LFp6EslXfHBeMw0lwVMsLq91EJJ/VjShLMpD5ldNsJFkoMxqWe/rUKtr4fwkR6kBzEUrxpDI5v/rtTXnxcb/j/Rg/KFcB8pWa4Ch45A5Ea8yNM+RgZvS1YmgHDs2dlid+mvoEt0P6WnTEkMp2GbcS+3VFvC1F4hTvBJ16C24Vjot1TjJlIuEgNLgqY8VSK+ANjnPMaY5wtVXNutg9EH5XbXjQPLcpAiGrFFQJEXLaNnup+w4jNyQ+jnQ+2deh/77XdfehbGOW7FzAnY6QlloZFPiCl8OyR5R2SAT+24BGiBiAeWOeXMTZBOIPd9hXdFej5UuQ8uTPmOBfU+TevMloLdLEMMyK5qmU3t5rQch/Z9GxkzkxLq/rZ+7MFLndoPQEjhtczKKM0o2HpBs01byOW+P248yCbCvp8/6oY8rBZOEFa/0du9sMasFs7E015tbHYZhu9vSZVS+YNq+q/8qrtAbb95iqICs6D2bSsRXPa3Tcr6zy1CZ7NTYANLiQBa35lBTbOERBbJOUta+0l4N3EcE/8i9DHstQd5Ey45pia02D9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?m39Ozj6YMA2h4tsYgo1BSixbqIsxoE8RvUHiguWUnyOyiWRnoz8Vjdh0ch?=
 =?iso-8859-1?Q?o/7mzsfxJ31B5mAYXNJxZciaxyGGrFnOVH8n1ax0RBCZx9gvxP9htsaE9J?=
 =?iso-8859-1?Q?GqqX4ZiESaE8E6mdZz6UhG1ESLkbow1mVRJ3zu++6IvCMHgp/EHKaxzT+U?=
 =?iso-8859-1?Q?2XGxZRDjeWBRzln+d0faRqlUCBkKvQmfWWrzWvM8peodGz0ycMuWCd2FgS?=
 =?iso-8859-1?Q?cdZHyAV8YX7nJ7sqIvzodSaqBDSJZSJStuoHQcxkNuWjFOOvgSN0OWa8e2?=
 =?iso-8859-1?Q?SRgrNFUuvFJ71beTiKJCxL/So+3LQtdbdNAxeo74MERG6y0mpmkMdQKefw?=
 =?iso-8859-1?Q?fn7QCsWqe60A+JN6dzzdYlBPCYSNnDMizZguDezXhXDzTmqeVIPDm4uDrw?=
 =?iso-8859-1?Q?29r0ZUyJB2oQtsTUmBIbGI3ZfsEAOGOght0aIItiSwY3ovf8sAnjytClU/?=
 =?iso-8859-1?Q?n35XmVSpHvYynehYOzgONd8Zz7Py1RzkJcAl19j4t75nWyvGj5yqCsrh99?=
 =?iso-8859-1?Q?T1gFybXS+MhCmLrqoXNK//0WXhKcFpjMJNCjOqKJt/qgFbTm+D78AkewcA?=
 =?iso-8859-1?Q?4dTNiwhJWQzDgGvKFDv8JwGtV17NabmCgHRhNft6ZMSVgcetUoyOrBmEA9?=
 =?iso-8859-1?Q?2TCONmaTePCdvRtNahV2vQKDtbnLExSi1v7N70vwTESDZ4YcxOb11JGjAp?=
 =?iso-8859-1?Q?t2X9sW/gdpEPwUjyLH+GEx7RNB7s7cRUXyHBHKnAmbHw9HCZtN8qSKrRWU?=
 =?iso-8859-1?Q?EFwPBVxXcwEYyXExuBlKW6BuKo8FjGSnGw9p+Pye8tBuMsF5mnheeS7FMG?=
 =?iso-8859-1?Q?mgeaMaB/As5UJGadwl+0GbLbCuDnhppssMkWDlqiuYRYKOHaan0NIqb+Yb?=
 =?iso-8859-1?Q?38reiSsgeF6EyyE09QcxEqlILM87Y8ePCZS7tOt5BjSOQIZmj2NUDAydWu?=
 =?iso-8859-1?Q?8rZVUUV8bhg3eTMX3xRmHjmCytoKK7+v3fgO3C3WUPxdKqxS001jP/E626?=
 =?iso-8859-1?Q?ckAtDuQ0xqDF0Lg6xXNOeZZuI4RblDsDUJ5M8ZHXJ5EeM3i3TmQ8o034n4?=
 =?iso-8859-1?Q?i/5hiU0ksQV8EVgpzqsXIroSJ1tD84mnv0eTDq+WbZvqcaIqS5Jwbh/raI?=
 =?iso-8859-1?Q?/x8kaVnQIxgJcXtXhb7/TrSGl0syE/NDXNuJWhW9INI053VIE5RtpAo7zW?=
 =?iso-8859-1?Q?iYhoKSMvKj2dTgo+dmvupZooerVPeNP+m6Sj9PCSI1uxlQjBi1xEZGGcON?=
 =?iso-8859-1?Q?BN4nPyqIg8Y1WVSHrCCnToK1fatCAEkZdZpqTRXjrvYccNYD1pbbWgLhrL?=
 =?iso-8859-1?Q?B1kzeuz0g5MY3btXPkxRjexj7PIx5VaksFAmw5a3ing1aihtJ9tTtKKqr7?=
 =?iso-8859-1?Q?X+HQX4RBP1l8yl5iySyrZdP9HNJJyx6La2EnsvLXRe6Z0q0aRrcOeZMynR?=
 =?iso-8859-1?Q?osHfP76HTavGAuTJHRorH39VwdhSIpSSoW3OV8wdThUIPw3KhxM6bY9Pre?=
 =?iso-8859-1?Q?S66rPHvhEO4HfPJKChex130+OsmFO6MKFiQn7hG/a4yfGOH6p6xCkg7iZA?=
 =?iso-8859-1?Q?ktgcvAPl9q0vMf0f/LARFVZl+rGdiAYW3zfIRIvpHabtcZ+DV+WD373lGU?=
 =?iso-8859-1?Q?Ip/BbqyhXuajPLwFllWbz7j4si3ZY3dqD3YQACxp8QSSKTygeDjXz4XlIO?=
 =?iso-8859-1?Q?SyJXOPZyfJqBK1eBO3S/KKXOTfjChz1kooEVYcZ6IG2F8BtroA6FtTrZn0?=
 =?iso-8859-1?Q?QNErngFotpfAdEn9li0jbD54vThVImK9bsut/E5CHTSrksWyPxN6Q4lcWf?=
 =?iso-8859-1?Q?4WhJshqz6Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: PI4TInr/BJZTLQk4aoe8+svpWaArwvXyHVQmr5zMAgY2Ni5sARgY4Qr6vFojlJmwZCYdBTvhl+tukUqBttTsX4p0kVZfOYxCIdT4orJifMZGf48c/o5mjEKIZOsi17soK4BnovMSQgy1N9zqZf+U/K529PdNnvA5ip4TrsdwRdTzJrCIpaASeDVM2gFgrqLl0J5t2F6YRs1393v0KERTg6eRsGuTfy9maq9jhyW59RNh/IviG1GH1OFh7c2cfcKRxZmVyVzwR1VcTysjWzmE9tcvODUbTSdpCMgLx4mCAw0RN1jE0WaBN5iI5p4SQlnw8zay89qaRvrTqwVMr5kdAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dcd72c-02af-43e9-d0d6-08de9acb6946
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 08:45:56.9856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: os8O+/+tUJp3yxWAg0OrPoN8Ss2Mk1a4Rm+p+Qcbk6bzE+sbn2jhVb+5GOI77MT6o8h/xcXc64TfOtXqfXuByw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 4.3% regression of stress-ng.urandom.ops_per_sec on:


commit: e5046823f8fa3677341b541a25af2fcb99a5b1e0 ("lib/crypto: chacha: Zeroize permuted_state before it leaves scope")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      e774d5f1bc27a85f858bce7688509e866f8e8a4e]
[still regression on linux-next/master 66672af7a095d89f082c5327f3b15bc2f93d558e]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: urandom
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202604151657.8e26ef70-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260415/202604151657.8e26ef70-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/urandom/stress-ng/60s

commit: 
  v7.0-rc5
  e5046823f8 ("lib/crypto: chacha: Zeroize permuted_state before it leaves scope")

        v7.0-rc5 e5046823f8fa3677341b541a25a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  92086428            -4.3%   88086482        stress-ng.time.minor_page_faults
      1869            -5.2%       1773        stress-ng.urandom.million_random_bits_per_sec
     94288            -4.3%      90188        stress-ng.urandom.million_random_bits_read
  92078928            -4.3%   88078900        stress-ng.urandom.ops
   1534939            -4.3%    1468337        stress-ng.urandom.ops_per_sec
 1.198e+08 ±  2%     +14.2%  1.368e+08 ± 12%  cpuidle..time
    177224            -1.8%     173977        vmstat.system.in
      1.87 ± 29%      +1.3        3.14        mpstat.cpu.all.idle%
      0.43 ±  2%      -0.0        0.41 ±  2%  mpstat.cpu.all.soft%
      2.99 ±  2%      +0.4        3.40 ± 11%  turbostat.C1%
      2.86 ±  2%     +14.3%       3.26 ± 12%  turbostat.CPU%c1
 2.114e+10            -4.4%  2.021e+10        perf-stat.i.branch-instructions
      0.34            +0.0        0.35        perf-stat.i.branch-miss-rate%
  68731688            -3.1%   66627770        perf-stat.i.cache-references
      0.62            +4.1%       0.65        perf-stat.i.cpi
 3.538e+11            -4.2%   3.39e+11        perf-stat.i.instructions
      1.61            -4.0%       1.54        perf-stat.i.ipc
     70.83            -4.4%      67.69        perf-stat.i.metric.K/sec
   1510879            -4.4%    1443951        perf-stat.i.minor-faults
   3020690            -4.4%    2886892        perf-stat.i.page-faults
      0.30            +0.0        0.30        perf-stat.overall.branch-miss-rate%
      0.62            +4.1%       0.65        perf-stat.overall.cpi
      1.61            -4.0%       1.54        perf-stat.overall.ipc
 2.081e+10            -4.4%   1.99e+10        perf-stat.ps.branch-instructions
  68408155            -3.2%   66202291        perf-stat.ps.cache-references
 3.483e+11            -4.2%  3.337e+11        perf-stat.ps.instructions
   1487270            -4.4%    1421509        perf-stat.ps.minor-faults
   2973479            -4.4%    2842012        perf-stat.ps.page-faults
 2.135e+13            -3.8%  2.053e+13        perf-stat.total.instructions
     57.02            -2.9       54.15        perf-profile.calltrace.cycles-pp.chacha_permute.chacha_block_generic.get_random_bytes_user.vfs_read.ksys_read
     13.65            -0.5       13.12        perf-profile.calltrace.cycles-pp._copy_to_iter.get_random_bytes_user.vfs_read.ksys_read.do_syscall_64
      4.78            -0.1        4.65        perf-profile.calltrace.cycles-pp.__mmap
      4.25            -0.1        4.13        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      4.30            -0.1        4.17        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
      5.35            -0.1        5.26        perf-profile.calltrace.cycles-pp.__munmap
      5.11            -0.1        5.02        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      5.08            -0.1        5.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      5.01            -0.1        4.92        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      4.82            -0.1        4.73        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      4.93            -0.1        4.84        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.02            -0.1        4.93        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      3.06            -0.1        2.98        perf-profile.calltrace.cycles-pp.__mprotect
      2.75            -0.1        2.68        perf-profile.calltrace.cycles-pp.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mprotect
      2.84            -0.1        2.77        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mprotect
      2.86            -0.1        2.79        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mprotect
      2.77            -0.1        2.70        perf-profile.calltrace.cycles-pp.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mprotect
      2.15            -0.1        2.08        perf-profile.calltrace.cycles-pp.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33            -0.0        1.28        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap
      1.14            -0.0        1.10        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      1.28            -0.0        1.24        perf-profile.calltrace.cycles-pp.vma_modify.vma_modify_flags.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect
      1.33            -0.0        1.29        perf-profile.calltrace.cycles-pp.vma_modify_flags.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      1.04            -0.0        1.00        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      1.35            -0.0        1.31        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.12            -0.0        1.09        perf-profile.calltrace.cycles-pp.__split_vma.vma_modify.vma_modify_flags.mprotect_fixup.do_mprotect_pkey
      0.83            -0.0        0.80        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.78            -0.0        0.76        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.37            -0.0        1.35        perf-profile.calltrace.cycles-pp.chacha_permute.chacha_block_generic.crng_fast_key_erasure.crng_make_state.get_random_bytes_user
      0.59            -0.0        0.57        perf-profile.calltrace.cycles-pp.__x64_sys_pselect6.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.82            +0.1        1.88        perf-profile.calltrace.cycles-pp.crng_make_state.get_random_bytes_user.vfs_read.ksys_read.do_syscall_64
      1.73            +0.1        1.79        perf-profile.calltrace.cycles-pp.crng_fast_key_erasure.crng_make_state.get_random_bytes_user.vfs_read.ksys_read
      1.54            +0.1        1.60        perf-profile.calltrace.cycles-pp.chacha_block_generic.crng_fast_key_erasure.crng_make_state.get_random_bytes_user.vfs_read
     83.26            +0.4       83.62        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     84.30            +0.4       84.66        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     84.21            +0.4       84.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     83.12            +0.4       83.48        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     82.09            +0.4       82.49        perf-profile.calltrace.cycles-pp.get_random_bytes_user.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     64.23            +0.9       65.16        perf-profile.calltrace.cycles-pp.chacha_block_generic.get_random_bytes_user.vfs_read.ksys_read.do_syscall_64
     58.57            -2.9       55.67        perf-profile.children.cycles-pp.chacha_permute
     15.25            -0.6       14.69        perf-profile.children.cycles-pp._copy_to_iter
      4.91            -0.1        4.78        perf-profile.children.cycles-pp.__mmap
      4.00            -0.1        3.89        perf-profile.children.cycles-pp.vm_mmap_pgoff
      3.76            -0.1        3.66        perf-profile.children.cycles-pp.do_mmap
      5.42            -0.1        5.32        perf-profile.children.cycles-pp.__munmap
      5.02            -0.1        4.93        perf-profile.children.cycles-pp.__vm_munmap
      5.02            -0.1        4.93        perf-profile.children.cycles-pp.__x64_sys_munmap
      4.93            -0.1        4.84        perf-profile.children.cycles-pp.do_vmi_munmap
      4.82            -0.1        4.73        perf-profile.children.cycles-pp.do_vmi_align_munmap
      3.13            -0.1        3.05        perf-profile.children.cycles-pp.__mprotect
      2.77            -0.1        2.70        perf-profile.children.cycles-pp.do_mprotect_pkey
      2.78            -0.1        2.70        perf-profile.children.cycles-pp.__x64_sys_mprotect
      2.16            -0.1        2.10        perf-profile.children.cycles-pp.mprotect_fixup
      1.34            -0.0        1.30        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.50            -0.0        1.46        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.59            -0.0        1.55        perf-profile.children.cycles-pp.__get_unmapped_area
      1.15            -0.0        1.11        perf-profile.children.cycles-pp.ksys_mmap_pgoff
      1.35            -0.0        1.32        perf-profile.children.cycles-pp.vm_unmapped_area
      1.28            -0.0        1.25        perf-profile.children.cycles-pp.vma_modify
      1.33            -0.0        1.30        perf-profile.children.cycles-pp.vma_modify_flags
      1.14            -0.0        1.11        perf-profile.children.cycles-pp.__split_vma
      0.82 ±  2%      -0.0        0.80        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.06            -0.0        1.04        perf-profile.children.cycles-pp.mas_find
      1.02            -0.0        1.00        perf-profile.children.cycles-pp.clear_bhb_loop
      0.38            -0.0        0.36 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.60            -0.0        0.58        perf-profile.children.cycles-pp.__x64_sys_pselect6
      0.50            -0.0        0.48        perf-profile.children.cycles-pp.ioctl
      0.63            -0.0        0.61        perf-profile.children.cycles-pp.mas_next_slot
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.vma_set_page_prot
      1.83            +0.1        1.89        perf-profile.children.cycles-pp.crng_make_state
      1.74            +0.1        1.80        perf-profile.children.cycles-pp.crng_fast_key_erasure
     83.14            +0.4       83.50        perf-profile.children.cycles-pp.vfs_read
     83.27            +0.4       83.64        perf-profile.children.cycles-pp.ksys_read
     82.61            +0.4       82.99        perf-profile.children.cycles-pp.get_random_bytes_user
     66.11            +1.0       67.10        perf-profile.children.cycles-pp.chacha_block_generic
     57.97            -2.9       55.10        perf-profile.self.cycles-pp.chacha_permute
     10.80            -0.5       10.27        perf-profile.self.cycles-pp._copy_to_iter
      1.31            -0.1        1.26        perf-profile.self.cycles-pp.get_random_bytes_user
      1.01            -0.0        0.98        perf-profile.self.cycles-pp.clear_bhb_loop
      0.49            -0.0        0.47        perf-profile.self.cycles-pp.mas_rev_awalk
      0.22 ±  2%      -0.0        0.21        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      7.32            +3.9       11.18        perf-profile.self.cycles-pp.chacha_block_generic




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

