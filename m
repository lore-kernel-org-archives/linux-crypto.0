Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C392222CB
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747294906; cv=fail; b=QzTtTFjmGdLiayUFuDscIuB6oi29u1NfhdCl/bd62qAf+rM+LK9J1z9D/0bpUkfbDJqaqiy6LfncI+D6KpY4HgviSyeI2n41/dQaPkrPZYH7hhFde8UyFbEca9k84Wm2i6W2rAzJir/XXkkHs7PdTA4gVED3OjEvi5GcXlEkNiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747294906; c=relaxed/simple;
	bh=esdjUBbbR9mecdaFAoFSBOBUVCzx35Y5Gz8rMyLxwWA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=fJEWRVlZ6QPgI6vBMkbu16TOTSk5+fRSUR61mHfGk08QblrInbnjuSTTAP+74MlP1tzlxedlQCziCJahktYcRb63hv4DwlPZSmbz89O2aJkx1vTLzo7kzzoot87QOeibjZeTzCT/irZ7ldSkQ3FBFJx+Rhafiv30lHDB/NBw3uI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ikbhlidL; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ikbhlidL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747294904; x=1778830904;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=esdjUBbbR9mecdaFAoFSBOBUVCzx35Y5Gz8rMyLxwWA=;
  b=ikbhlidL8sZiLyw8l5HRtpTYAmKCJANJu4Ct8XhBj9S6/jNrdn/z+iX9
   r9j+MsuTadN6qSJ4FkC0ACsk9WR89+yyh83/Pjyb62TcLzSA7dPLM61KL
   r5UYuu2obdptFwGV1evZLnGegR9hu5QlnK0TKHHL/jHTN1MP/cIW6ymGJ
   TQa8s22Nl8Jy3D7zAhJAexX+2iib6Jk1PIBcbHi0MpBq6+MZD5/szx2mT
   yvXb2AF9+BHaY3bRKFnHVP33o9Z05Dl1FRqOhpZXOZSTRuJfdohaL0pc4
   WnPMK6qZW8HodOLcETB9MZdq2egIxWZKEXZqLNYWkM90O+QhQ4PV5EVoe
   Q==;
X-CSE-ConnectionGUID: 4WFU/UvcRZO8YJjcnaTeKg==
X-CSE-MsgGUID: KIVV49WqRaefhQct4mvz+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60228252"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="60228252"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 00:41:44 -0700
X-CSE-ConnectionGUID: BfJtflPCQ3GAYVKmh0xrPg==
X-CSE-MsgGUID: 3LVyBs04Rxix3BtggAXhXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="175415952"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 00:41:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 00:41:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 00:41:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 00:41:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwn0yliLaILjK5VXjSPy0yIPUf19I0Ba+iXEu1FrRR+493aDgdYhNeUIikqww7Pfs2L+1QL0HZBdlfa5EIrPShmieWYTtjxxUvy8LE4DfBe5a0dev33ax/WKF3jbj0UcdxEjmaHRt6aJ5zqeRXhOxVBswoTf2uDCgCVFu1WV+3Lx7YqgQSZfvxezqbAc9pGzkIaCgLCstdc1GJD6bcL59AJ7g1Jbih/WxH+pM9iWdOrrpyZZ30ahuazlmC66NZZl4Y75elvdh/wVH4L8VjUrjMfwph+l0iJpmYJmqO0Ne+6sEMLecyCsDM+ZKwGaLTKqLWRk+91qWl1O2Atg3Kb7jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cs9nggWRiB0sqWtd6r+P7Ex9Sc2OYL1urLOxCW/hmNI=;
 b=nrhjdt6nojwxpOzvkrtKke2s9KiLSVE1EzUMl9sA5rzl0/ykY4k7hKyPgJScp8JqrRo849hBiKUbNtMRp3pnpEqIigqNkiHiVVHjWwXkkRGjEGt3Kb5qEf0shcTfZEthifo7V8XaXJ2j5OrhiuVLAuwNuIFm/rFoXyl2QFsz5QQyTC+OjgESZ/1Y+NHT3qURaM5PN2BQ3HAGsMOmAdOFB1L3XdbBYbD2B/DfqU0GV79jcsQpB8T6Fc0W7fqVtb36fp2X7eD0baryzemX6wmqzuS5mwfxNrA9FqidbI7GNTxqxp0bbsXhCZ9OJWZwkbkz4qKhPOR+Q5MEwWPFK8T0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB6418.namprd11.prod.outlook.com (2603:10b6:208:3aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 07:41:13 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 07:41:13 +0000
Date: Thu, 15 May 2025 15:41:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [crypto]  698de82278:
 WARNING:at_crypto/testmgr.c:#alg_test
Message-ID: <202505151503.d8a6cf10-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0197.apcprd04.prod.outlook.com
 (2603:1096:4:14::35) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1f9bc8-031b-4f44-acba-08dd9383de23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4/lATpT4GLpYXr8Ex8pwad/AIGSzGcrAdFXSHN6PfbigB2xhJzBSD8MXAfV/?=
 =?us-ascii?Q?XUXm5ui2KZHO3RrHEcAWFr/7vbgMDwDiqvfFDfieTYxrKaNCAV4UA2NqBoN+?=
 =?us-ascii?Q?UsR0nGqX/TSfo7qKIoEGlWdngHW+kR/OfQpx+hbSYcjKn/D3uLb8Los2QEaE?=
 =?us-ascii?Q?1SeHwsMnC3vh2VOk2nnd0S7Ku+jMZUziD2o1f7mrVp6Rc2860wCIl1+C7VjD?=
 =?us-ascii?Q?Pa2d7kRMsrEC3YkG7BFnn6tV6Vmvn0maV2h6umE8XpQZ87LfbCR039OYwxBq?=
 =?us-ascii?Q?Bl759LTAtV1HdFiiMaY/rXZ08uylHKA9YhZrGQDp5lzv1inVBfUTI4ojJP4W?=
 =?us-ascii?Q?aKal1+ut2jC0NMQmA+nHz7C5MxkTOF+9DAIWs7ADT2IJo35cbe3C6V7R7x5y?=
 =?us-ascii?Q?BcxoLWpvnR37PiypQoAdhArqFhlQODWrHS5FkAIt3tGYEnPZAX0l9ZMsg3Fi?=
 =?us-ascii?Q?p/ZXCtdTsiTidcvj6IPMpYErYyRUsS/MTfvQ3hxRn95BamCpA37YuTQut3nH?=
 =?us-ascii?Q?VywkQk3JzIy66kxicuukcJhdWRrgD/TzLV/2WZWl3h1v5zA61FQuOoWC46E0?=
 =?us-ascii?Q?sFF4lRjGsvtpHQzW8JBTYd7P967nIT90rgZBgp6rdWOtgnuXUP31evbHdmtR?=
 =?us-ascii?Q?7CyA3tw3mKU4AnjhZXLSMsG9GZRgdPAkf6255eGOE38RuvS/6u3h/0aEl+Ez?=
 =?us-ascii?Q?+uQJRvZX9TduGAHNR/q7HHP7SbPCERu3gmtKgWaprkkyS7Nd9PJ6C2yTQNrF?=
 =?us-ascii?Q?7ZRN4wFExzkxR6WTMCZLFG7507Mwqhk0UqorZdxY6CgptdtJT8GpMoqheULn?=
 =?us-ascii?Q?tf6qkpO8rlNRCd2XaH0Ch4du7QxMqHSFhAfCBskuKS6dgVK5NUb3bp9Sdgo4?=
 =?us-ascii?Q?5vEahIaX7YLXvlNPUqBZ5PvFaecx+JzntambiNfzR9730YIBrLupMn+HpReU?=
 =?us-ascii?Q?bDl06qGxNMqMCV08VXpjKCx0bGddp/QM4zPZXOjoO6hjpCurBjC12+8+c3Xn?=
 =?us-ascii?Q?GOhD2GCHz1h8tqIFexsf2fsnkTsSb02z1OeT5gkg/dsE6qvqExtMvW45ivUY?=
 =?us-ascii?Q?bf0ZPRQvHIqfYaE63yVL76ETw7qd84Uo3yOsoukvlYr+vPAp/G4ir14tBG1M?=
 =?us-ascii?Q?PiDYj7TisLu+4xYkVnNKLl3XJedx+1CpKhyUF33NmpFhr7+ohl/FqbwrNci9?=
 =?us-ascii?Q?0bnOUubLJUULm4TzFNwk8a/05NYkgpD+2GsjnJQbGtZVDztCTnps6Y+PcN6w?=
 =?us-ascii?Q?3uxVsxEliia4iG1B+xBPn1GuZlGoNKFBs6WIZOXe0qFJz5oIBFCAlb0e/H5O?=
 =?us-ascii?Q?uUuFk2KTixzVZizzTkH6QSaEho3os0Btw5/vw/TwVrMWyAMSq4TI3PoZVCqR?=
 =?us-ascii?Q?84dBEUxIViA8tBEhm2KSoGHfo+GT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nXW+/QipBT+vtdT+jgW1ljO2SzpeLwTnmg5/U3jtJWWEj1K9mtaW+P/r/Ka?=
 =?us-ascii?Q?1uq0EpFZ4Htjf88e0DcdSEUSi290y9wANcPtuheoV4zUNcGdj+RqZX//EZ+D?=
 =?us-ascii?Q?9GDqDva2S81H1Xi4QsPI7GxmeXXU5lOYohuqMJPzA8fLpXYYTxN8tP9ORhcB?=
 =?us-ascii?Q?6jkEQvXiz0Btr3pCSsqLQQZHvjfRVk3TaAOeiYvkNWJtS9E0Gbxez7uMoTDm?=
 =?us-ascii?Q?vn6bKgZ0t8o0EqqqisA+VvWKWSKzoeBBJKv9TxsBWeSS8up2C+4AoUDAPQ64?=
 =?us-ascii?Q?dGWbBpuZnXyIURoxFtE3egtHWWJES/zMyO+x2wd0+T7hdDwR7GEAmvYGSI8H?=
 =?us-ascii?Q?Qy293kKk3fgwUbKr0XapOb3bSmqI2x8SW25mwXRLaP3NKKYLnYmAk9r9e9JM?=
 =?us-ascii?Q?THxcoiwJPcm2+QMT8akvIjWzpqLb5hoDky3C4Egscb4nF5L/fB24zkJ2kXtJ?=
 =?us-ascii?Q?3XJAqC7WI0lYs8f8qgMtAKNOH0q+dO5uvYdNyy/bYYX0kqZgX3eQOS0Z6j1P?=
 =?us-ascii?Q?MV/BVNA/ezJwYe1xhUJ3uSHyL/LoJyZghy/EteQOoQAXTNF8RNZZLXi2T5gP?=
 =?us-ascii?Q?5+ZylOxgF+yCbiO4ihiFZTfzK1S0MAIfQG5vi++Yn38t3fEcQfXSvjSEeAT/?=
 =?us-ascii?Q?F3T7XvkkF0Ia6zzLb2sTlY/8ailKFsZ7fh9lJ0Yiqle+ZWbXxtD8KGoPMlmu?=
 =?us-ascii?Q?TTpoy9sVSbrTc8oO1mWJ8TPCMS1/kMe9CU/UKt3nB3yONHvMHOCeVybxW5pW?=
 =?us-ascii?Q?6ljLKucYYmAdkgsaAXLDQTD8/1y6gmf2fITudfoD36e8YWnFW7qQioR/T64a?=
 =?us-ascii?Q?JAe6Po1oSZgNmV06qHeTOxtT1XHdstehw7ol2c9EwBK2CxPfa5fe+XV8GiKm?=
 =?us-ascii?Q?QUPno47OK7vUmoxe0JVcyNjnhdvIWdxLAvNKJpkOxYRQ4Rud7YYgQ25DfLMA?=
 =?us-ascii?Q?QrdhYCanu4EqW8wZI93cyyS+VBFo3mROndiP3R/elPVTu9OF8WGfNKKtyoJQ?=
 =?us-ascii?Q?fDyMy9XtsNfk/5HK3m7egetycGczUDgVZwt9ZSlUBglxJBYYbDNkGmNjwVgm?=
 =?us-ascii?Q?btOx/aFFLXO6VLQT078h/bKcI1Blw7Mg+wx/Ymj7srV/yRCkLfgVi7T5TNbq?=
 =?us-ascii?Q?oDC/k/tqpRnHGh2Fat/H8tfDLLjeyusQ0UwC8Vhxv5AVzphkWCoEufbGXKp3?=
 =?us-ascii?Q?vUbwK2Ryu9TP5dJ4Er+g525rojX7HPA9YcIUP7tPrTu3mZAU0a43ZsQ8NkMN?=
 =?us-ascii?Q?H++6pSQLZKBC85oX0oP+cshE772yoFw2Fm5OrhOgsUsW+bKt7sSVcF21SZq4?=
 =?us-ascii?Q?cgQAyXJcQmkIQ4shkJqukeVha/Am+z1DAi4HK25V0zAF1ZIoVXGiQsZ6xxS7?=
 =?us-ascii?Q?0eYc6C3+/m+Slu3v0/xqRR0esCdQT00yql78aoJ69sMzvkWLs4qNeZooCSQf?=
 =?us-ascii?Q?44pBkM1pZCIyIUrBiiz0dFPMXiLjuULb0HOsFmJBmZXcGudznxLKfqsQ9rAM?=
 =?us-ascii?Q?p7x2U5GJOaQQcFrL+k6kjfXFx+c1IrC2ot4Z5UODKBokIE7LybjBg5CCIOZ+?=
 =?us-ascii?Q?RT+pR0PZf7x6Gywvc9ryw3DofjEUnRNyYscJKVxIZpKJUs4QeStA4FF9cc0/?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1f9bc8-031b-4f44-acba-08dd9383de23
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 07:41:13.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hl5Gvi8L1o0pHyJOgkusydYSzD8MdrlXTPyAwubgBq0t4Ux2Nt0eEjozly+5G0qT85w6YEaG7KwhS0JliBRAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6418
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_crypto/testmgr.c:#alg_test" on:

commit: 698de822780fbae79b11e5d749863c1aa64a0a55 ("crypto: testmgr - make it easier to enable the full set of tests")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master bdd609656ff5573db9ba1d26496a528bdd297cf2]

in testcase: boot

config: i386-randconfig-002-20250513
compiler: clang-20
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------+------------+------------+
|                                       | 40b9969796 | 698de82278 |
+---------------------------------------+------------+------------+
| WARNING:at_crypto/testmgr.c:#alg_test | 0          | 12         |
| EIP:alg_test                          | 0          | 12         |
+---------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505151503.d8a6cf10-lkp@intel.com


[   16.077514][  T327] ------------[ cut here ]------------
[   16.079451][  T327] alg: self-tests for lrw(twofish) using lrw(ecb(twofish-asm)) failed (rc=-22)
[ 16.079491][ T327] WARNING: CPU: 0 PID: 327 at crypto/testmgr.c:5811 alg_test (kbuild/obj/consumer/i386-randconfig-002-20250513/crypto/testmgr.c:5809) 
[   16.081769][  T327] Modules linked in:
[   16.082303][  T327] CPU: 0 UID: 0 PID: 327 Comm: cryptomgr_test Tainted: G S                  6.15.0-rc5-00343-g698de822780f #1 PREEMPTLAZY  36427eb4e2823c0186d3f8e85f01fa19b8e4ee5b
[   16.084257][  T327] Tainted: [S]=CPU_OUT_OF_SPEC
[   16.084897][  T327] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 16.086245][ T327] EIP: alg_test (kbuild/obj/consumer/i386-randconfig-002-20250513/crypto/testmgr.c:5809) 
[ 16.086824][ T327] Code: 89 c7 e8 3d a7 79 ff 83 c4 10 b8 fe ff ff ff 83 ff fe 0f 84 54 ff ff ff 89 f9 51 56 53 68 a4 c9 6f 56 e8 f5 90 79 ff 83 c4 10 <0f> 0b 89 f8 e9 39 ff ff ff 8d 83 74 0d ec 55 8b 78 10 8b 58 14 89
All code
========
   0:	89 c7                	mov    %eax,%edi
   2:	e8 3d a7 79 ff       	call   0xffffffffff79a744
   7:	83 c4 10             	add    $0x10,%esp
   a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
   f:	83 ff fe             	cmp    $0xfffffffe,%edi
  12:	0f 84 54 ff ff ff    	je     0xffffffffffffff6c
  18:	89 f9                	mov    %edi,%ecx
  1a:	51                   	push   %rcx
  1b:	56                   	push   %rsi
  1c:	53                   	push   %rbx
  1d:	68 a4 c9 6f 56       	push   $0x566fc9a4
  22:	e8 f5 90 79 ff       	call   0xffffffffff79911c
  27:	83 c4 10             	add    $0x10,%esp
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	89 f8                	mov    %edi,%eax
  2e:	e9 39 ff ff ff       	jmp    0xffffffffffffff6c
  33:	8d 83 74 0d ec 55    	lea    0x55ec0d74(%rbx),%eax
  39:	8b 78 10             	mov    0x10(%rax),%edi
  3c:	8b 58 14             	mov    0x14(%rax),%ebx
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	89 f8                	mov    %edi,%eax
   4:	e9 39 ff ff ff       	jmp    0xffffffffffffff42
   9:	8d 83 74 0d ec 55    	lea    0x55ec0d74(%rbx),%eax
   f:	8b 78 10             	mov    0x10(%rax),%edi
  12:	8b 58 14             	mov    0x14(%rax),%ebx
  15:	89                   	.byte 0x89
[   16.089318][  T327] EAX: 0000004c EBX: bad01080 ECX: 00000000 EDX: 00000000
[   16.090193][  T327] ESI: bad01000 EDI: ffffffea EBP: ba399f54 ESP: ba399eb0
[   16.091085][  T327] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010282
[   16.092098][  T327] CR0: 80050033 CR2: ffd9a000 CR3: 16f05000 CR4: 00040690
[   16.092992][  T327] Call Trace:
[ 16.093406][ T327] ? lock_acquire (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/locking/lockdep.c:5866) 
[ 16.094001][ T327] ? __kthread_parkme (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/kthread.c:290) 
[ 16.094662][ T327] ? trace_hardirqs_on (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/trace/trace_preemptirq.c:80) 
[ 16.095313][ T327] cryptomgr_test (kbuild/obj/consumer/i386-randconfig-002-20250513/crypto/algboss.c:179) 
[ 16.095890][ T327] kthread (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/kthread.c:466) 
[ 16.096412][ T327] ? crypto_alg_put (kbuild/obj/consumer/i386-randconfig-002-20250513/crypto/algboss.c:174) 
[ 16.097000][ T327] ? kthread_blkcg (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/kthread.c:413) 
[ 16.097584][ T327] ? kthread_blkcg (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/kthread.c:413) 
[ 16.098186][ T327] ret_from_fork (kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/kernel/process.c:159) 
[ 16.098745][ T327] ret_from_fork_asm (kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/entry/entry_32.S:737) 
[ 16.099349][ T327] entry_INT80_32 (kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/entry/entry_32.S:945) 
[   16.099958][  T327] irq event stamp: 30685
[ 16.100499][ T327] hardirqs last enabled at (30693): __console_unlock (kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/include/asm/irqflags.h:19 kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/include/asm/irqflags.h:109 kbuild/obj/consumer/i386-randconfig-002-20250513/arch/x86/include/asm/irqflags.h:151 kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/printk/printk.c:344 kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/printk/printk.c:2885) 
[ 16.101680][ T327] hardirqs last disabled at (30702): __console_unlock (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/printk/printk.c:342) 
[ 16.102859][ T327] softirqs last enabled at (22314): __do_softirq (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/softirq.c:614) 
[ 16.103928][ T327] softirqs last disabled at (22303): __do_softirq (kbuild/obj/consumer/i386-randconfig-002-20250513/kernel/softirq.c:614) 
[   16.105018][  T327] ---[ end trace 0000000000000000 ]---
[   16.105779][    T1] alg: skcipher: failed to allocate transform for lrw(twofish): -80
[   16.106818][    T1] alg: self-tests for lrw(twofish) using lrw(twofish) failed (rc=-80)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250515/202505151503.d8a6cf10-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

