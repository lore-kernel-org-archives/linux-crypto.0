Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A67D21147C
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743151918; cv=fail; b=hxk7lGZ/aWwcae28Lktf3hXbzlGsWalDNQkesCoPPNCT8pA7UyblxJoiapFcbmKmyOWz8jntHQpEIphLEo4yn8HOVZj98pgbakLg+FC56nlwdutcr7ccLDjpKNMfqVX+yRrVcPEgW+H7xeCcUWtM5c/kv+Eh7RTaAnCwVeIVmbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743151918; c=relaxed/simple;
	bh=beDjSOOl6xtHCY23PztphOyY0PO+hSZcsQ0rSp30qLY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=pOqS6O3Zw02wOr0Jrx5zLeCWR2+SKkU6O+j3tJSPuC/70CGRh4ROMO1DHpKHxPCxJ6wwzlGeE2XWslGNIy8yulPb4URRQyhMmYQnqv/Oe3vwEerRIMyU4wWMADIifXLqY+AcyHDLm3qIeDLnpCzVkoOEhuPq67EyOjUnaPcmjwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCR7is7P; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCR7is7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743151916; x=1774687916;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=beDjSOOl6xtHCY23PztphOyY0PO+hSZcsQ0rSp30qLY=;
  b=eCR7is7PX5HTi6BKj80RgUMRkuIVfZOAlMinLQJjhNocsy+0sa9boVIN
   1LxcDUoFc/g1gUG4un6RNozlvfaSnWYtBfzuepxev8hqiDPniPR234On5
   7DyNh/GTwfTcfvDbvaJXixwBpvRhlvIDAcdcYHs1kwyCnEC4laW4U6Ykd
   sp+bk3YlStUzvg7l2sFZRPKIDB4TlAc7kcXXJRdq9RkgIifLoUsX/k81+
   JZegij20v8jvoywNfOW4GuXVLD6EDXaNZnNGDEip01URUcEb1hXBO2xM3
   RU7JybcK123PtF5vGe1A4kRj5f4EYIDXJ9JdnnmkNgMLFewkTY+/4DQTg
   A==;
X-CSE-ConnectionGUID: 1pYGjL7zT3enuZLX5Gjwug==
X-CSE-MsgGUID: WIZXrs28Qn2iRPefYflXrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="43755823"
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="43755823"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 01:51:55 -0700
X-CSE-ConnectionGUID: n5j3JAU1SCWoUnA2nuII6Q==
X-CSE-MsgGUID: VriCJoMkQjuNd713kp4QCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="130107002"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2025 01:51:55 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 28 Mar 2025 01:51:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Mar 2025 01:51:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Mar 2025 01:51:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKEhpZD1MPazNH/dOXVvoNKZpDQxUU4xRwT3D1CZ19kNPn9cLloDBqUd6pkNiSrWpkbBCmRGCihkGFecvtz0Yv/wCblajg8Zhn+aH3lRH+ZXbjCRhkPlxjbZT0inYbZDorDRB9NWWLoGDK9FQfUpqXgnxBTjWm/+H2zWf9m1Qso1EeyoGbwPKXdEDOiGhJKe1B2q8ZkA9vudgDCgxjdhzY0vINKSSPNaV9/guf+CBHSoHARE/J24VYJMmYMacAeNz5Cj0bk24qkO+2oOfNraxQh+aXi/xJL7VLYpOePTmWbGuZtLV40k666bfetaeFszYDEYFn7WFEjeHYUcue23ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zvhRet3TPTAXiJpN2BoaAYKqggDTTlJHIdOm8Izcd0=;
 b=guqfN0aaEfCvnMrH3fXfyrNZahsdCutS5WGLDkxJqzyU0Q58kX1lJJtFjgQzuSKK65Nu1ZwM67nwmKo32dZ7qDyf7YXXc1ROFAciWaFJpwDk2LcJKnsV+Ic4MrNrBgz3SEdzWi/cX0vAxtidKhzVfOJO39xaYsCvWXX3An/yRXPyEvRKIjNcmjSUyeFqpHAHr/Fw/kWMR4Wt/SQ3APCwoOvF+5rrZpfNr9njwqAt7Ky3KBtKFI8xhpdZpKtZ37Xhh4QZU5OrWPX3Q++jd/nrmLoGHa3U0SEswHz8HRMRHE54jpZ8Whw7AVt+UKCxFHs5CHvfoyACnfJ/v2+TjlWwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB6471.namprd11.prod.outlook.com (2603:10b6:8:c1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 08:51:47 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 08:51:47 +0000
Date: Fri, 28 Mar 2025 16:51:38 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [crypto]  8b54e6a8f4:
 WARNING:at_crypto/testmgr.c:#alg_test
Message-ID: <202503281658.7a078821-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB6471:EE_
X-MS-Office365-Filtering-Correlation-Id: d34fd215-44cf-48c9-c62c-08dd6dd5c5cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bV4m+BpVlLD7K+qWzuUCc9ivmwiSBuCNyQ/DGnj+DmxA+TU6WHRXR7/nlp1C?=
 =?us-ascii?Q?bzrSuXEEYuyAcgsNieB8EVW7/g9z0rzqd6NOF+ay83RlduT0klM8Tm8S03JD?=
 =?us-ascii?Q?XAURoAoYRjcZpBDPcxXu/O/H2weDfKCoeG/tSfo3JKU9c5++A8FPRgANvkw3?=
 =?us-ascii?Q?RaE7nUbIqaNqI4oid1HAiZIZlwHezFKxYAcJXnGuDDFyv7ayO3u9QCM8WFlA?=
 =?us-ascii?Q?f9ckQi3L/k2TSwpZysux004/wVQUvMVZfUKZQwc/t0K4BMi1TQVFrPLJt1/A?=
 =?us-ascii?Q?UONpyVMyGo8iTay8G0zMrbL/BEZXDmV1ZcbbfUjH8gE+IrLjgnW1hu5DdMFq?=
 =?us-ascii?Q?BAztVCNN0qCIshkcuREtUvdqjHsMNg10h8EP9mAlonC16i47ItkiWqYu/6lv?=
 =?us-ascii?Q?yz5PjuBd9AUUpkQoW2QK2Dvtpfyu5kGcWJJHG30dMGVU+RWE46KU7U78F7FY?=
 =?us-ascii?Q?pWIkLTPh7FfO+JTCK/CzOPaShUSRcj4Z9TU4CvdENeOMyVy3ikpg4mW8omyq?=
 =?us-ascii?Q?uJ5ySYqvwO77rEnZf3hXs0/Kqi9PVdviBOQkTc4uU1vk049AVg25870nPNda?=
 =?us-ascii?Q?ZiLTt/nLfPFQhCEsOX9eQ/pEp5flBdIWdkAVlMeg+dCKOvb/+6wPa9gICbkR?=
 =?us-ascii?Q?xuH2vnGVdqrirDodBIHFvch6kfIWUIGL/s9JcvJwXtpsyl+4Zc/ulOvZWuTE?=
 =?us-ascii?Q?cY2KCuqeDViPkh3yMgJ0buSh19gQR5UWizkeLMqkfnRzFeoEhnbh3+P0H/tR?=
 =?us-ascii?Q?cikLeRPsiYRjPC0GFdjZrPt1B6Bso/sDoSejrkGbVCmbJkNixbrrQm/5waFR?=
 =?us-ascii?Q?ncuKJTmnfjIeaWEs051Bcx+Sz8PiSdKEUKXF3RaTv2Pw5ysUvXUfYPhKZBz1?=
 =?us-ascii?Q?nyDV0tRGvI4+xzv54URRxWJKkWdZJnTsXXW9RYvnYcgfBc1MDFANwrILrJbK?=
 =?us-ascii?Q?fnGVds4Rn1h32KXuwInhQXTOIkv2YndqQbDLftJg0jSE0q1XgOhOrm3nnNBj?=
 =?us-ascii?Q?43X3nXtU2XrJZUU/Pgs1s5rO9Dv+ff5PB6X96+5DImhmSpLCtzhK0+ybNR7J?=
 =?us-ascii?Q?a3ZrrO9XZ6QVILGbLPQgNwUytzjFiGRDJeGuxVmw64XifWCe1aH3zqfsloJR?=
 =?us-ascii?Q?2uP5TsreqgLrpMTjg2u5mXu8yNM54PWzZJS5OSehIUMFCCL2Ht0s/AsV5o9z?=
 =?us-ascii?Q?tDb3SgH8Pd3g6Rap4xnp5VwjY+Irg+mc30Ld2ZUYOv6yIo+sIsJPuC9pw4yR?=
 =?us-ascii?Q?fTSeOeMr4qi8BdY3V/f4QHwYRX2NInHJxUTW1INJqQdarFvaZBAQCGgsudAq?=
 =?us-ascii?Q?02zosK9iXjOP7ZDOVdzOsjqe+zdBT6bhq2jNxzTJPpfkvw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?al7ahFllPngTdT58SDZEu+r0iQ60Aw+z8f1UdmHIoS5QYLm7lnSmQabm0CJs?=
 =?us-ascii?Q?U0ssKd/Quag4g2Hpk7nRW+DLKGs+0d+Ti7+PBRlNu/KVZzqBKwN98z3e7dK1?=
 =?us-ascii?Q?cpfcOx+jbY4wiCdcYKAJ6wJeXpGsVSRuvqg5b6pJE3uPvXgl3t9DiUU5AuVP?=
 =?us-ascii?Q?irlYJ/HBsl0k9iyo4nkNAMlEGEZo5csRMiOCEq3Di7VAFotayyrGIdMT/Q0D?=
 =?us-ascii?Q?1p/9KhswW7x3ZbkGFl2owUkvqoJaviTvF39bodVYKziKmkAMTjvjXSvWm+QY?=
 =?us-ascii?Q?W319rfgo/ngTnsd1jJwOUHzzd/COti0SYxN6PyQ6MSp38qxddAdxML4z00fP?=
 =?us-ascii?Q?kLRZlfd3XFGJyW+M0nUClMPuwCIuFGuv8VGZb1RJ854bTJOR7QH3RuLH0edf?=
 =?us-ascii?Q?TYU+zuBgtSIIT3gJrewJE0PgyYu31niQ2/gGa6bYD1ciQmWMFdRqmNRM7Nc4?=
 =?us-ascii?Q?JZnMR/aAHZ//E9RwjAPlc1Qdpb/ced8GU0NyGb8foJFjF1c4GgUVXFqqoc6g?=
 =?us-ascii?Q?XexO6B5Grj0CP7tQT9izf7xe1b+qQWWWQ3WpF8zxHwD0NxaNANblkdUdKB8L?=
 =?us-ascii?Q?Xzb/2Jnc2tELhUKPYYTAILei4tKKKOBp0eCK5fuH5GKWYrNLgfkfMzTFqDOu?=
 =?us-ascii?Q?0kVZbmzqNpAkQ5lETwvcPw+/TVisanEpDwV7zsB1/EYh8QvPGzQWNby+Kscl?=
 =?us-ascii?Q?OMyXY1AeF7gKsVZwKPsnPQem/U68GsmM8rVtjvYqklRp4IpWy8Itbwsv5/Yg?=
 =?us-ascii?Q?7Hd5ruK9A//YhUIb5Xf014Vn91cbEFNctCIBiRpNLwTs9Z1lhPR8eFtEXJaf?=
 =?us-ascii?Q?hPj3WCZ1OqOOjl8ujLeI3CuEkfygRFJ9ACz5w0M2VYJ3xn5elOBT1M39EbgK?=
 =?us-ascii?Q?I/UKTpGYrlD6Z8hOo8lfSQcp5DxP4Wy8SJMI0g8cxiL8LvtOxm71nyFV0Gwy?=
 =?us-ascii?Q?4I6dPaB4ScPlsvZccQ3o2Ge0Qtf6cVUQ9eWYkYql114uW6+WwdUmN1gZq9c+?=
 =?us-ascii?Q?PZppATR7INTvm0LqsT29J6xXtAtEyzK1GDK73AMv9L0yrk2F24gk1Efz7JQ1?=
 =?us-ascii?Q?x+MREhKQTaD5MyYSEo1V9ebFaJ6uXh+9XqPpjuVMFfEbTXz7lvdt5faoziyf?=
 =?us-ascii?Q?x5RYSQVQIS2jW2+8X2C0fh2CH2sVqSGM1jn6awE4pfGanWDuuLwPtBL3wDPZ?=
 =?us-ascii?Q?iFEsjHVCajYVXUZTzaAOnEF7dadw9v4eRK0Gj4vCU9tvm+IStzgjD0+lQV4Z?=
 =?us-ascii?Q?7rRh2S1H7rHCMBBDtL1qv9RJNzZPJvNi02xbCuho7w3N6NuBYTl0XBytk7yX?=
 =?us-ascii?Q?z/IXPBagmZgAn2v3xJuvIENy/oRvOYEQ+zdEXwXGDdu+rU+5DU43Oid/beC9?=
 =?us-ascii?Q?A2/Jl2dWtx0vhJ0484OMWlqUXk8xyRdOdMEmR9kwllVcbuQc+BSY5OXkfXxD?=
 =?us-ascii?Q?DtCmXR59wJZ7/7w2iNaBlc+cWZIX3QmNiQmgfbPo1MAhSp36ENmrVHzqR3g5?=
 =?us-ascii?Q?LwyOmhReDxnfJyNb/XJXaNSyj3WdLbI0tG1ERoCniKP6CT4HS61lWE7ilyuY?=
 =?us-ascii?Q?//cizxQUz3j947KexrjLUTdIvPZH36nu+humVCpXS+vR3X+V/QVpKdGyxaC0?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d34fd215-44cf-48c9-c62c-08dd6dd5c5cd
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 08:51:47.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPFjcLn0GyPdWWxHj/pX/KZYDbqXbk/KajmmzRRo5vXaxkDIr3RrL39lqgye/Ig3AvLhOiVqd6K3tsHfkc5qfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6471
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_crypto/testmgr.c:#alg_test" on:

commit: 8b54e6a8f4156ed43627f40300b0711dc977fbc1 ("crypto: testmgr - Add multibuffer hash testing")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master db8da9da41bced445077925f8a886c776a47440c]

in testcase: boot

config: x86_64-rhel-9.4-kunit
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------+------------+------------+
|                                       | 108ce629cf | 8b54e6a8f4 |
+---------------------------------------+------------+------------+
| WARNING:at_crypto/testmgr.c:#alg_test | 0          | 12         |
| RIP:alg_test                          | 0          | 12         |
+---------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202503281658.7a078821-lkp@intel.com


[   71.838087][ T2596] ------------[ cut here ]------------
[   71.840212][ T2596] alg: self-tests for poly1305 using poly1305-simd failed (rc=-126)
[ 71.840238][ T2596] WARNING: CPU: 0 PID: 2596 at crypto/testmgr.c:5997 alg_test (crypto/testmgr.c:5997 (discriminator 1)) 
[   71.842804][ T2596] Modules linked in:
[   71.843503][ T2596] CPU: 0 UID: 0 PID: 2596 Comm: cryptomgr_test Not tainted 6.14.0-rc1-00186-g8b54e6a8f415 #1
[   71.845159][ T2596] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 71.846781][ T2596] RIP: 0010:alg_test (crypto/testmgr.c:5997 (discriminator 1)) 
[ 71.847651][ T2596] Code: cc f7 ff ff 45 89 fd 44 39 ed 0f 8c fe f8 ff ff e9 de fc ff ff 44 89 c1 4c 89 ea 4c 89 f6 48 c7 c7 60 61 90 b7 e8 ac a6 01 ff <0f> 0b 44 8b 04 24 e9 66 fc ff ff 41 8d 6f 01 eb cc 48 8b 6c 24 18
All code
========
   0:	cc                   	int3
   1:	f7 ff                	idiv   %edi
   3:	ff 45 89             	incl   -0x77(%rbp)
   6:	fd                   	std
   7:	44 39 ed             	cmp    %r13d,%ebp
   a:	0f 8c fe f8 ff ff    	jl     0xfffffffffffff90e
  10:	e9 de fc ff ff       	jmp    0xfffffffffffffcf3
  15:	44 89 c1             	mov    %r8d,%ecx
  18:	4c 89 ea             	mov    %r13,%rdx
  1b:	4c 89 f6             	mov    %r14,%rsi
  1e:	48 c7 c7 60 61 90 b7 	mov    $0xffffffffb7906160,%rdi
  25:	e8 ac a6 01 ff       	call   0xffffffffff01a6d6
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	44 8b 04 24          	mov    (%rsp),%r8d
  30:	e9 66 fc ff ff       	jmp    0xfffffffffffffc9b
  35:	41 8d 6f 01          	lea    0x1(%r15),%ebp
  39:	eb cc                	jmp    0x7
  3b:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	44 8b 04 24          	mov    (%rsp),%r8d
   6:	e9 66 fc ff ff       	jmp    0xfffffffffffffc71
   b:	41 8d 6f 01          	lea    0x1(%r15),%ebp
   f:	eb cc                	jmp    0xffffffffffffffdd
  11:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
[   71.854667][ T2596] RSP: 0018:ffffc9000072fd18 EFLAGS: 00010286
[   71.855664][ T2596] RAX: 0000000000000000 RBX: ffffffffbacc4900 RCX: 1ffffffff70eba78
[   71.856951][ T2596] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
[   71.858195][ T2596] RBP: 1ffff920000e5faa R08: 0000000000000000 R09: fffffbfff70eba78
[   71.859419][ T2596] R10: 0000000000000003 R11: 0000000000000001 R12: 00000000000000b7
[   71.860650][ T2596] R13: ffff8881ab234000 R14: ffff8881ab234080 R15: 0000000000002dc0
[   71.861880][ T2596] FS:  0000000000000000(0000) GS:ffff8883aee00000(0000) knlGS:0000000000000000
[   71.863262][ T2596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   71.864318][ T2596] CR2: 00007f68c26a3160 CR3: 000000000e66c000 CR4: 00000000000406f0
[   71.865581][ T2596] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   71.866912][ T2596] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   71.868210][ T2596] Call Trace:
[   71.868795][ T2596]  <TASK>
[ 71.869314][ T2596] ? __warn (kernel/panic.c:748) 
[ 71.869972][ T2596] ? alg_test (crypto/testmgr.c:5997 (discriminator 1)) 
[ 71.870752][ T2596] ? report_bug (lib/bug.c:180 lib/bug.c:219) 
[ 71.871522][ T2596] ? handle_bug (arch/x86/kernel/traps.c:285) 
[ 71.872255][ T2596] ? exc_invalid_op (arch/x86/kernel/traps.c:309 (discriminator 1)) 
[ 71.873050][ T2596] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:574) 
[ 71.873884][ T2596] ? alg_test (crypto/testmgr.c:5997 (discriminator 1)) 
[ 71.874597][ T2596] ? alg_test (crypto/testmgr.c:5997 (discriminator 1)) 
[ 71.875322][ T2596] ? __pfx_alg_test (crypto/testmgr.c:5936) 
[ 71.876084][ T2596] ? __pfx___schedule (kernel/sched/core.c:6645) 
[ 71.876894][ T2596] ? try_to_wake_up (kernel/sched/core.c:4332) 
[ 71.877689][ T2596] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 71.878561][ T2596] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
[ 71.879484][ T2596] ? __pfx_cryptomgr_test (crypto/algboss.c:174) 
[ 71.880305][ T2596] cryptomgr_test (crypto/algboss.c:181) 
[ 71.881035][ T2596] kthread (kernel/kthread.c:464) 
[ 71.881699][ T2596] ? __pfx_kthread (kernel/kthread.c:413) 
[ 71.882452][ T2596] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 71.883322][ T2596] ? __pfx_kthread (kernel/kthread.c:413) 
[ 71.884067][ T2596] ret_from_fork (arch/x86/kernel/process.c:154) 
[ 71.884800][ T2596] ? __pfx_kthread (kernel/kthread.c:413) 
[ 71.885569][ T2596] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
[   71.886338][ T2596]  </TASK>
[   71.886876][ T2596] ---[ end trace 0000000000000000 ]---



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250328/202503281658.7a078821-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

