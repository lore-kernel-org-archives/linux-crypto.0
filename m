Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478A2F9984;
	Thu, 21 May 2026 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779350998; cv=fail; b=gHDfHpgebGGsuA55UBB7aXZTPIJWGNWNoquUOeK10piD8+G2vuec7Scxa5ZewcYwoPO+n2thyoww2ut3WzRJxdxT/gqafNClRwfF2QpwU6Mz/jyzMhha8/J9zEuL7HwmoQD98F4hIIG2stFUIKKmJFO+2Kf81CyNL/TRKhFhCE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779350998; c=relaxed/simple;
	bh=+2/1J+ak9RnWnMlf4hbvfaHJKJhz1FTbjV29j6PsdlE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=uq2FSwsvit0KjgdZbirmFSx+pGH7FV3pEX2/e5gJnzSp4dzzWMQXgv4nyP3AhDQidTsPIJvVnOdLJu2NIp54mNrd3LovPjhA9NVVEh3Nj25X5JMRBE6oSE5EXl5exJRlTmiC6ZKM5xlCzCeQ2k9JKxIwlX1LAwSU5aK1IApsKDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g70KqNXY; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g70KqNXY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779350995; x=1810886995;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=+2/1J+ak9RnWnMlf4hbvfaHJKJhz1FTbjV29j6PsdlE=;
  b=g70KqNXYoSkI40lUMcg8WyQ1oTALA3nCP4/SEJ1SN0cln5mIAtIy6YBK
   VHekbYnrldHg3LmEB5cMHowmVaayasBl/M3SZD27rAIMuKehbsqOOJUhQ
   BpFoX5d1V+0cD/Jue1ofG+6LyxOOlrRQSX6z0rHLxp3S6H9Qnb2X1gAn8
   gPQL4zYxjpOowH9k+cStUcIKtgHI8K3aHeKoKt4jW5HFR9eDazHkXMqWQ
   YlInBvsliTMGj+dXzpjUIJBov++ts+iUx2Gh+9UYCQkLPxA4OEWU+J5+0
   WpvRgKv/WiTQ2FykyvRD1RZfEXV03+zVr39PWkd9eD3H6a1QzRrony4sQ
   w==;
X-CSE-ConnectionGUID: N9d1wRrfTzCBFYC8A1gasw==
X-CSE-MsgGUID: HlgAVxJkSW+abGdR5lsuEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="83882808"
X-IronPort-AV: E=Sophos;i="6.23,245,1770624000"; 
   d="scan'208";a="83882808"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 01:09:55 -0700
X-CSE-ConnectionGUID: ZpCaVPj8Q+y1/5Rg+1Dydw==
X-CSE-MsgGUID: ZOry0fO9SbauDxybr4CZGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,245,1770624000"; 
   d="scan'208";a="242262739"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 01:09:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 01:09:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 21 May 2026 01:09:53 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 01:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SevwVbS8RvvWiF+fb8fHJM9j6evRjzd0KWxxgiY/DQ+8GMA7wIvofDPKh2/NxZlUnEWc6h/BL9SPuqdD0dZVSc4MV4cpNRoWWyrPs11IkQYD9K7Cd6KnoymwkjziKonlfX2qPVEO35/tr5ojMYt0zGplIuLSyudi/+uJ2Wd2psRZnq3K1AaRuZTCxBHJ8JBN7IV1SSwkAVyQUAuCdP5Y5eDF2qpQqE0mg0Sdxvy3zxj7ryqJDBdoAxm4gT4717PYpAECVsoGfhKLwVR4NLS5ZHSWkab1Qk3JONN3fxMmTM6l/AmhC1UUg8LNIkDMo86UVX9V2qPVDtmznNNszmEYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JwT3rdGGJpEMO9OO8gt+Kimg1wGCVmz6XwQCO1EpR0=;
 b=MjpD9Bg3yTTEVCUMnrpep+rvXV5iV/jFUYqxkMF6cMUzog4YXFABLkFewqbvA7eSdD7kaDLyYCD90PFbwclDt7LkhO0AX9xSO8rYbgCjyT0eJCQgKYlEImmhgkUMGtyCiaEsEVIjdcpRJvjH+W+kAUMF48WsM92USSVtPOb7sLJEn2rcnH2Ioj7lGC8Xa2e1LlbOso9Vh2b6SMA3/gV8HFUo0TI7HZ2iWl41TR4sMNJLpKw5DN8v1FfVuNuLcWX/R97MqYpVAa1iCm0Nx38bqKfnqtqFVTjzLUnAJm00UIubB4k0z07tIGbQBZnXz/jjtC0OQHWKU4D6qnT2flUnoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH0PR11MB4888.namprd11.prod.outlook.com (2603:10b6:510:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 08:09:48 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0025.020; Thu, 21 May 2026
 08:09:48 +0000
Date: Thu, 21 May 2026 16:09:40 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [rhashtable]  4fe9852927: stress-ng.msg.ops_per_sec
 29.1% regression
Message-ID: <202605211540.d9ef9555-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR01CA0111.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::27) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH0PR11MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a85c7e-f9fc-41bc-417e-08deb710536e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|6133799003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info: kOmail1i9klkxmZDbKIRtvIYFJupIkR6INtOIax5td6dAt+FG8Hk8spb9jzQMm6dgUKujJmls95PFzt0HY2ZQJuMTf+QUMTVWGPEpvgzrMn8pwZnWeezB5arAvSOaE2JTGR3bz0N7prW0Zg4FKCFmCUDnLNmmxpaIFdgbLsqB47UlkxP7lav7EGkUQ1AiQM2/jdTb7ft/sGkTdJxiC/bWZA7p8qLYomVu9gEQzlHA9yrS5607BDT3o228L1fIiIjSB40HU1fpolWU+2nvp2IJ5Z2qrdPVrWPq5ln/9cWp2NUq/vUZsnqxFTXSEP52PclOcE6dpgs+q1g/rZpuf4rO9o4NHH+KTXxRuPya60MDz5VoCvQid/s1z1YOrDzKnqIqGfthx4feogQapLhgfM58dBGEC4xIj9nO/vTuWVe2ZxNWPV9wIFPqowXC/yUuncGXW/QMhPi3BbRGz69W3tsMdPfXv+i90aWw/nhBT8lxZ5oQOxsb1MpOI6e3qdJOl8UamJlFvwCovDfqNSGX/kcWU0Fbx1TiamN9jdw/Ls1MieUYffSUiXUM3RJBznU0AEvrbmUDZEPHO/nnUKh+uB0rS04VKOmoPa4H5jKGoX8S129XvcCydyOduttm1bdiky586oVIJMJUWyWyacvErW2XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(6133799003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?GJqB6wkJIWnKV9fjk07n4l3InwLrUEevotHOan9HtEpMLtMZaLjMOh2x0/?=
 =?iso-8859-1?Q?P4iCaefjCv2OkPr0TVSpd3n6rQH1yIvDlsBEzehXMXuM8bW2x7bz88hGwO?=
 =?iso-8859-1?Q?+siijVeHMFkNn+IaDqq2zhaPXx16ja16ALx3dSB77S34X3Yh9VgSDxFz4f?=
 =?iso-8859-1?Q?P87UPEp8zYyckS9lixtrVNiAIDVsvnbP9EDjBv0Cm8OBHN6YEY8FC44hZI?=
 =?iso-8859-1?Q?OrebqsAeQpdCgnvMpEkJR96aYU4vYqEHs7LmBuXBGcc8GKarP8F3wHdyZL?=
 =?iso-8859-1?Q?XRCPYv8eW91ak+rq48ZvvBnQ712o9Wko0L68TiH08cyPDvUNBmcpZnREOD?=
 =?iso-8859-1?Q?QuBij8GGGxz8ybg1hqmoHgrH28jh6pwa4yRvT4heNESWx1OV4ywmURSI2t?=
 =?iso-8859-1?Q?//2ecSNHfS5YzcJhE8Ek6t7bsjW9HDnElHv06/FIkAIPeyaQ1WTIqmhDFy?=
 =?iso-8859-1?Q?0eDMMWNX0lAk40y1LemIN28m5UdDrujrNbK4bcQF85sp8etVhqIA2WrzL8?=
 =?iso-8859-1?Q?trfLGamn68dQrsmh8vEdnFRIRxeSNo4izHZsuFCqb9FP4SGf9mCK7JNVN4?=
 =?iso-8859-1?Q?RRwMCxZmCaW+cce2enKjV6qRk4xiRay9Fr6LgEmIVSFC5O36He2qhQrv1U?=
 =?iso-8859-1?Q?mSZsRCCDmzOa8ek+FXP6KV84YlZlRd2QBwqKV+tWF9r5I+CpszlKf3WiCs?=
 =?iso-8859-1?Q?B8t/J/SxyPv91UjOqR0iMzDox1ygHDKmpGx/F/VB/5A7a70mZcbkdsVk9Z?=
 =?iso-8859-1?Q?nHyrKFwz1HBwF3XTqbyPQqkNH8uHeQMAKPmYmrUIGMcJMZDsDYHkTMQqMU?=
 =?iso-8859-1?Q?Z48fZ2EgaA/nDP051GHVMC0OV2QtmQxro7wl9G8GIpNb0r3riUNoipHGCF?=
 =?iso-8859-1?Q?fjol+R6WPl9kYB6rA67xUWtBGa+94LQQ5NPwZi3jcvIlD15mEGa8oNRshu?=
 =?iso-8859-1?Q?uBTLciRliz5QNTkxnwjRV272AAQqbZODQY2zess9PNK1ZhRbRVhg7jCUdw?=
 =?iso-8859-1?Q?ZZcoTJh3gXIlmkUR7jydyfYCRiLxoYBCCiMV5FVVQuKTjQ4jGKvbfrSjzm?=
 =?iso-8859-1?Q?92E4xUI26IaRLm1/1XPeTNsrRsCMy9cwBl0qeAHr2tzKaEEJUjK14HG9nB?=
 =?iso-8859-1?Q?0FJqVcnNUCLDJBHYbvzt19DX311A9tf/4QtZ0roaU3X2xwDuIEWcY6wx9P?=
 =?iso-8859-1?Q?OY6e7spM2CPC6y1xMtTVbBOWpa0gjnl7cDK4zlUiV+R6ky8TEfYWS+fGHX?=
 =?iso-8859-1?Q?iU4odqXDAKKbgpLZ9eoRIXjrlK0e6+l1AQ1xBPzoL55B5E2SKR/bPsYbd4?=
 =?iso-8859-1?Q?DxEbxrYiEWo6wClBjCcRkE9bt3izPurMTagPRTCyBeU7K8ttdAXdRXi89J?=
 =?iso-8859-1?Q?Ofb9LJo0vD8OBXcEVo7Pz/Fhv39d0qm3vQQoMw8PpP52niGKmWPQ0SQ9WP?=
 =?iso-8859-1?Q?RTJUbRjAY9T2NafM4n4AfL8eIvtK62jV0JyRzkpTDeEAblx7O0RxONaMp5?=
 =?iso-8859-1?Q?dRGvQmG6jMw8YnDE3Zc4APehBiAHlc0+4rbJk+seXaYVkQiqv6ObU2/kTO?=
 =?iso-8859-1?Q?aG3vd97wMnXr5usihj+UtcmigpSF0XAf0I0MDRSD7D5lik1B9xnU6j3SrX?=
 =?iso-8859-1?Q?xdIYNTYP4hOD/O8gyJEoDcFHEml4XpKxvwWcKzTeGGeJPw5qYUy2nApFuN?=
 =?iso-8859-1?Q?wJ+InG6m7oRu6syokQNzkNyGUNjEku/kFPxpdntNxgFWucd8OgAEfBYHu7?=
 =?iso-8859-1?Q?/3Kr6Ac8EJ1mHvnmZYsJZicl1/C4ExBzul2I/emV1V3CccspdYAUp3V4/I?=
 =?iso-8859-1?Q?ydslEzB+vQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: CR0eVoxfnQ/gdBEPwC6gwGfOfkX4+zmQiMQfcM5tchIBy1qoW6Vi48AFnYa/CrmCgo7BtKzIYA4On5N7H3nRqKbPZNiaZw5Yy0OEOIaf5pZPkcaUP4DckeOyaZLL5XjZAUkp+yLfU3Nt8BGRW2zsOlDeOAKFQShBn1Yp2Z1KJDNNksvuTUb4H8Y6xIQUK9EhNbQDb4tP/tJ2xCXPje5NiyvWks68aRZdebvxMWyMHRGkHTHyDQIDFgW+VxWWmAOVp3ZEr5+cmt1l1CiWee7pzBUU99mqIv0gVAhE3HWrFfoOfrMckdhUKn4nyBk8TECi746SwMbdSZnmjayG5duvvg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a85c7e-f9fc-41bc-417e-08deb710536e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 08:09:48.4382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oSuZEOhPNk8JyfzLkniqmUThasnjA9lkgT77AlihCT8FwM5Vl3NqLC2V9YbSNOAQqI2RXBfJ87csXus3Ma2sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4888
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed a 29.1% regression of stress-ng.msg.ops_per_sec on:


commit: 4fe985292709eeb6a4653c71660f893e26c2f2dd ("rhashtable: Bounce deferred worker kick through irq_work")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      d458a240344c4369bf6f3da203f2779515177738]
[still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: msg
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605211540.d9ef9555-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260521/202605211540.d9ef9555-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-emr-2sp1/msg/stress-ng/60s

commit: 
  5897ca15d2 ("selftests/sched_ext: Add non_scx_kfunc_deny test")
  4fe9852927 ("rhashtable: Bounce deferred worker kick through irq_work")

5897ca15d2c444af 4fe985292709eeb6a4653c71660 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 1.152e+09           -29.1%  8.168e+08        stress-ng.msg.ops
  19204952           -29.1%   13619234        stress-ng.msg.ops_per_sec
     14063           -11.6%      12434 ±  2%  stress-ng.time.involuntary_context_switches
      2876           -12.9%       2506        stress-ng.time.percent_of_cpu_this_job_got
      1536           -10.3%       1378        stress-ng.time.system_time
    192.04           -33.3%     128.15        stress-ng.time.user_time
   5338409 ±  4%      +9.7%    5858239 ±  3%  cpuidle..usage
    208311 ±  3%     -15.9%     175134 ±  3%  numa-meminfo.node3.Shmem
     52091 ±  3%     -15.9%      43797 ±  3%  numa-vmstat.node3.nr_shmem
     94334 ± 11%     -31.0%      65055 ± 14%  perf-c2c.HITM.remote
    147112 ±  2%     -14.6%     125569 ±  2%  vmstat.system.in
      9.74            -1.1        8.69        mpstat.cpu.all.sys%
      1.39            -0.4        0.98        mpstat.cpu.all.usr%
     53.91           -26.7%      39.53        mpstat.max_utilization_pct
    986061            -5.1%     936129        meminfo.Active
    986045            -5.1%     936112        meminfo.Active(anon)
    128200            -7.7%     118344        meminfo.Mapped
    276789 ±  2%     -17.8%     227423        meminfo.Shmem
     22.07 ±  3%     +15.6%      25.50        perf-sched.total_wait_and_delay.average.ms
    220780 ±  3%     -13.1%     191816        perf-sched.total_wait_and_delay.count.ms
     21.90 ±  3%     +15.6%      25.31        perf-sched.total_wait_time.average.ms
     22.07 ±  3%     +15.6%      25.50        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    220780 ±  3%     -13.1%     191816        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     21.90 ±  3%     +15.6%      25.31        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      3343 ±  3%      -9.8%       3015        sched_debug.cfs_rq:/.avg_vruntime.min
      2.67 ± 23%    +137.5%       6.33 ± 14%  sched_debug.cfs_rq:/.load_avg.min
      2.67 ± 23%    +140.6%       6.42 ± 15%  sched_debug.cfs_rq:/.runnable_avg.min
      2.67 ± 23%    +140.6%       6.42 ± 15%  sched_debug.cfs_rq:/.util_avg.min
      3343 ±  3%      -9.8%       3015        sched_debug.cfs_rq:/.zero_vruntime.min
    157311 ± 10%     -14.5%     134477 ±  6%  sched_debug.cpu.avg_idle.stddev
    137.50 ±  7%     +18.9%     163.50 ± 13%  sched_debug.cpu.nr_uninterruptible.max
    246513            -5.1%     234040        proc-vmstat.nr_active_anon
   1018888            -1.2%    1006555        proc-vmstat.nr_file_pages
     32061            -7.7%      29594        proc-vmstat.nr_mapped
     69201 ±  2%     -17.8%      56871        proc-vmstat.nr_shmem
    246513            -5.1%     234040        proc-vmstat.nr_zone_active_anon
   1253740            -5.8%    1180805        proc-vmstat.numa_hit
    857018            -8.6%     783537        proc-vmstat.numa_local
   1345499            -5.2%    1275814        proc-vmstat.pgalloc_normal
    397.00           -16.9%     330.00        turbostat.Avg_MHz
     11.56            -1.3       10.25        turbostat.Busy%
      3431            -6.1%       3221        turbostat.Bzy_MHz
      0.18 ± 42%      -0.1        0.05        turbostat.C1%
      3.09            +0.6        3.65        turbostat.C1E%
      2.85 ±  6%     +15.3%       3.29        turbostat.CPU%c1
      0.56           -11.7%       0.49        turbostat.IPC
   9050091 ±  2%     -16.4%    7567003        turbostat.IRQ
   2892774 ±  2%     -22.7%    2235774        turbostat.NMI
      0.34 ± 12%    +314.9%       1.39 ±  2%  turbostat.Pkg%pc2
    413.45            -6.0%     388.84        turbostat.PkgWatt
     18.81            -3.9%      18.08        turbostat.RAMWatt
      4.10            +9.3%       4.48        perf-stat.i.MPKI
 1.092e+10           -26.1%   8.07e+09        perf-stat.i.branch-instructions
      0.59 ±  2%      +0.2        0.75        perf-stat.i.branch-miss-rate%
  64835624            -6.6%   60546789        perf-stat.i.branch-misses
     44.45            -3.2       41.27        perf-stat.i.cache-miss-rate%
 2.394e+08           -20.0%  1.916e+08        perf-stat.i.cache-misses
 5.409e+08           -13.9%  4.657e+08        perf-stat.i.cache-references
      1.61           +14.5%       1.84        perf-stat.i.cpi
 9.683e+10           -16.0%  8.132e+10        perf-stat.i.cpu-cycles
     12795           +13.0%      14464        perf-stat.i.cpu-migrations
    396.20            +5.0%     415.99        perf-stat.i.cycles-between-cache-misses
 5.885e+10           -26.6%   4.32e+10        perf-stat.i.instructions
      0.63           -12.6%       0.55        perf-stat.i.ipc
      4.04            +8.8%       4.40        perf-stat.overall.MPKI
      0.58 ±  2%      +0.1        0.73        perf-stat.overall.branch-miss-rate%
     44.02            -3.0       41.00        perf-stat.overall.cache-miss-rate%
      1.70           +13.6%       1.93        perf-stat.overall.cpi
    420.78            +4.4%     439.25        perf-stat.overall.cycles-between-cache-misses
      0.59           -12.0%       0.52        perf-stat.overall.ipc
 1.094e+10           -26.2%   8.07e+09        perf-stat.ps.branch-instructions
  63709128            -7.4%   59001476        perf-stat.ps.branch-misses
 2.377e+08           -20.2%  1.898e+08        perf-stat.ps.cache-misses
   5.4e+08           -14.3%  4.629e+08        perf-stat.ps.cache-references
     1e+11           -16.6%  8.337e+10        perf-stat.ps.cpu-cycles
     15166            +2.4%      15525        perf-stat.ps.cpu-migrations
 5.881e+10           -26.6%  4.314e+10        perf-stat.ps.instructions
 3.592e+12           -27.0%  2.621e+12        perf-stat.total.instructions
     32.87 ± 33%     -11.6       21.22 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     32.52 ± 33%     -11.5       21.00 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.53 ±  2%      -6.7       18.80 ±  4%  perf-profile.calltrace.cycles-pp.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.40            -2.4        3.97        perf-profile.calltrace.cycles-pp.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.33 ±  8%      -2.4        1.90        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.80            -2.3        2.46        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.do_msgsnd.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.88 ±  7%      -2.3        1.61 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.96 ±  5%      -2.2        4.78        perf-profile.calltrace.cycles-pp.kfree.free_msg.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.60 ±  7%      -2.2        3.43 ±  4%  perf-profile.calltrace.cycles-pp.free_msg.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.86 ± 20%      -2.0        2.89 ±  4%  perf-profile.calltrace.cycles-pp.store_msg.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.53 ± 32%      -1.6        2.98        perf-profile.calltrace.cycles-pp._copy_to_user.store_msg.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.25 ±  4%      -1.5        1.74 ±  4%  perf-profile.calltrace.cycles-pp.stress_msg_receiver
      2.53 ±  2%      -1.4        1.10 ±  3%  perf-profile.calltrace.cycles-pp.percpu_counter_add_batch.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.73 ±  2%      -1.4        1.37        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      2.50 ±  2%      -1.3        1.17 ±  2%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.__kmalloc_node_noprof.load_msg.do_msgsnd
      2.29 ±  2%      -1.2        1.04 ±  2%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.__kmalloc_node_noprof.load_msg
      4.07 ±  2%      -1.1        2.99        perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kfree.free_msg.do_msgrcv.do_syscall_64
      1.75 ± 74%      -0.8        0.92        perf-profile.calltrace.cycles-pp._copy_from_user.load_msg.do_msgsnd.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.35 ±  3%      -0.7        1.64        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      1.41 ±  8%      -0.5        0.94 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      0.93 ±  9%      -0.3        0.64 ±  6%  perf-profile.calltrace.cycles-pp.percpu_counter_add_batch.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      1.18 ±  6%      -0.2        1.03 ±  6%  perf-profile.calltrace.cycles-pp.stress_msg_receiver.stress_msg
      0.79 ± 13%      +0.3        1.13        perf-profile.calltrace.cycles-pp.down_read.sysvipc_proc_start.seq_read_iter.seq_read.vfs_read
      0.83 ± 13%      +0.4        1.19        perf-profile.calltrace.cycles-pp.sysvipc_proc_start.seq_read_iter.seq_read.vfs_read.ksys_read
      0.77 ± 13%      +0.4        1.13        perf-profile.calltrace.cycles-pp.rwsem_down_read_slowpath.down_read.sysvipc_proc_start.seq_read_iter.seq_read
      0.95            +0.4        1.33        perf-profile.calltrace.cycles-pp.intel_idle_xstate.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      0.54 ± 44%      +0.4        0.93        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.sysvipc_proc_start
      0.55 ± 44%      +0.4        0.95        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.sysvipc_proc_start.seq_read_iter
      0.25 ±100%      +0.4        0.69        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.24 ±  2%      +0.5        1.71        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      1.26 ±  2%      +0.5        1.75        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.x86_64_start_kernel.common_startup_64
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +0.5        0.55        perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.00            +0.6        0.57        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary
      0.00            +0.6        0.64        perf-profile.calltrace.cycles-pp.sysvipc_proc_next.seq_read_iter.seq_read.vfs_read.ksys_read
      1.96 ± 12%      +0.6        2.60        perf-profile.calltrace.cycles-pp.seq_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.96 ± 12%      +0.6        2.60        perf-profile.calltrace.cycles-pp.seq_read_iter.seq_read.vfs_read.ksys_read.do_syscall_64
      1.95            +0.8        2.73        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.75 ± 44%      +0.9        2.62        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      1.74 ± 44%      +0.9        2.61        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      0.72 ±  9%      +0.9        1.61        perf-profile.calltrace.cycles-pp.msgctl_down.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.msgctl
      0.00            +0.9        0.94        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.msgctl_down.ksys_msgctl.do_syscall_64
      0.00            +1.0        0.98        perf-profile.calltrace.cycles-pp.down_write.msgctl_down.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.1        1.11        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.ksys_msgctl
      0.00            +1.3        1.25        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.ksys_msgctl.do_syscall_64
      3.25            +1.3        4.56        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      3.25            +1.3        4.57        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      3.25            +1.3        4.57        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      3.70            +1.4        5.12        perf-profile.calltrace.cycles-pp.common_startup_64
      9.28 ±  6%      +1.8       11.06 ±  6%  perf-profile.calltrace.cycles-pp.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      0.00            +1.9        1.86        perf-profile.calltrace.cycles-pp.rwsem_down_read_slowpath.down_read.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.9        1.89        perf-profile.calltrace.cycles-pp.down_read.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.msgctl
      1.40 ±  5%      +2.5        3.90 ±  6%  perf-profile.calltrace.cycles-pp.ipc_obtain_object_check.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      3.85 ±  2%      +2.8        6.64 ±  3%  perf-profile.calltrace.cycles-pp.ipc_obtain_object_check.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.24 ± 32%      +5.0        9.22        perf-profile.calltrace.cycles-pp.ipc_obtain_object_check.do_msgsnd.do_syscall_64.entry_SYSCALL_64_after_hwframe.stress_msg
      0.00            +6.2        6.17        perf-profile.calltrace.cycles-pp.idr_find.ipc_obtain_object_check.do_msgsnd.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +7.2        7.16        perf-profile.calltrace.cycles-pp.idr_find.ipc_obtain_object_check.do_msgrcv.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.85 ±  6%     +10.8       17.67        perf-profile.calltrace.cycles-pp.__percpu_counter_sum.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.msgctl
      5.17 ±  7%     +11.0       16.20        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__percpu_counter_sum.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.98 ±  8%     +11.0       16.02        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__percpu_counter_sum.ksys_msgctl.do_syscall_64
     57.21 ± 26%     +13.1       70.26        perf-profile.calltrace.cycles-pp.stress_msg
      7.58 ± 33%     +13.7       21.27        perf-profile.calltrace.cycles-pp.ksys_msgctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.msgctl.stress_msg
      7.65 ± 33%     +13.7       21.38        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.msgctl.stress_msg
      7.66 ± 33%     +13.7       21.38        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.msgctl.stress_msg
      7.78 ± 33%     +13.8       21.54        perf-profile.calltrace.cycles-pp.msgctl.stress_msg
     33.29 ±  2%      -6.4       26.92        perf-profile.children.cycles-pp.do_msgsnd
     13.12 ±  4%      -6.1        7.03        perf-profile.children.cycles-pp._raw_spin_lock
     35.20            -5.0       30.19        perf-profile.children.cycles-pp.do_msgrcv
     12.46 ± 10%      -4.8        7.64        perf-profile.children.cycles-pp.load_msg
      6.60 ±  2%      -2.8        3.79        perf-profile.children.cycles-pp.percpu_counter_add_batch
      6.62            -2.4        4.22        perf-profile.children.cycles-pp.__kmalloc_node_noprof
      7.40 ±  6%      -2.2        5.19        perf-profile.children.cycles-pp.kfree
      7.70 ±  6%      -2.2        5.52        perf-profile.children.cycles-pp.free_msg
      6.70 ± 21%      -2.0        4.66        perf-profile.children.cycles-pp.store_msg
      4.48 ±  2%      -1.7        2.81        perf-profile.children.cycles-pp.stress_msg_receiver
      4.74 ± 30%      -1.6        3.14        perf-profile.children.cycles-pp._copy_to_user
      3.93            -1.5        2.46        perf-profile.children.cycles-pp.stress_msg_sender
      2.81 ±  2%      -1.4        1.45        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      2.56 ±  3%      -1.3        1.24 ±  2%  perf-profile.children.cycles-pp.refill_objects
      2.52 ±  3%      -1.3        1.22 ±  2%  perf-profile.children.cycles-pp.__refill_objects_node
      4.16 ±  2%      -1.1        3.07        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      1.73 ± 12%      -1.0        0.74 ±  3%  perf-profile.children.cycles-pp.__slab_free
      1.93 ± 72%      -0.9        1.04        perf-profile.children.cycles-pp._copy_from_user
      2.76 ±  2%      -0.9        1.89        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      3.23            -0.7        2.54        perf-profile.children.cycles-pp.__check_object_size
      1.84            -0.5        1.37        perf-profile.children.cycles-pp.check_heap_object
      1.99 ±  2%      -0.3        1.64        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.94 ±  2%      -0.3        0.64 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
      1.05 ±  4%      -0.2        0.86        perf-profile.children.cycles-pp.__x64_sys_msgsnd
      0.96 ±  5%      -0.2        0.78        perf-profile.children.cycles-pp.__get_user_8
      1.06 ±  2%      -0.2        0.90        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.87 ±  3%      -0.1        0.72        perf-profile.children.cycles-pp.sysvipc_msg_proc_show
      0.88            -0.1        0.73        perf-profile.children.cycles-pp.__put_user_8
      0.79 ±  3%      -0.1        0.65        perf-profile.children.cycles-pp.seq_printf
      0.78            -0.1        0.64        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.78 ±  3%      -0.1        0.64        perf-profile.children.cycles-pp.vsnprintf
      0.37 ±  2%      -0.1        0.24        perf-profile.children.cycles-pp.ss_wakeup
      0.40 ±  3%      -0.1        0.29 ±  2%  perf-profile.children.cycles-pp.trylock_stock
      0.63            -0.1        0.54 ±  2%  perf-profile.children.cycles-pp.__check_heap_object
      0.62 ±  3%      -0.1        0.53        perf-profile.children.cycles-pp.ipcperms
      0.65            -0.1        0.57        perf-profile.children.cycles-pp.prandom_u32_state
      0.60 ±  2%      -0.1        0.52 ±  2%  perf-profile.children.cycles-pp.__virt_addr_valid
      0.29 ±  4%      -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.number
      0.44 ±  2%      -0.1        0.38        perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.29            -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.check_stack_object
      0.34 ±  3%      -0.1        0.29        perf-profile.children.cycles-pp._find_next_or_bit
      0.18 ± 15%      -0.1        0.12 ±  6%  perf-profile.children.cycles-pp.__refill_objects_any
      0.22 ±  3%      -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.28 ±  3%      -0.0        0.24 ±  2%  perf-profile.children.cycles-pp.security_ipc_permission
      0.23 ±  3%      -0.0        0.20 ±  2%  perf-profile.children.cycles-pp.format_decode
      0.19 ±  5%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.security_msg_msg_alloc
      0.10 ±  6%      -0.0        0.07 ±  8%  perf-profile.children.cycles-pp.mod_memcg_lruvec_state
      0.12 ±  3%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.__libc_msgrcv
      0.26 ±  2%      -0.0        0.23        perf-profile.children.cycles-pp.__refill_obj_stock
      0.28 ±  3%      -0.0        0.26 ±  4%  perf-profile.children.cycles-pp.x64_sys_call
      0.17 ±  2%      -0.0        0.15        perf-profile.children.cycles-pp.is_vmalloc_addr
      0.19 ±  2%      -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.security_msg_queue_msgrcv
      0.22 ±  3%      -0.0        0.20        perf-profile.children.cycles-pp._raw_spin_unlock
      0.15 ±  2%      -0.0        0.13 ±  4%  perf-profile.children.cycles-pp.barn_replace_full_sheaf
      0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.security_msg_queue_msgsnd
      0.08 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.msgrcv@plt
      0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.wake_q_add
      0.10            -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.ktime_get_real_seconds
      0.07            -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.lsm_blob_alloc
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.update_other_load_avgs
      0.06 ±  6%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.__smp_call_single_queue
      0.05 ±  7%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.05            +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.07            +0.0        0.09 ±  8%  perf-profile.children.cycles-pp.kick_ilb
      0.08 ±  6%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.ttwu_queue_wakelist
      0.05 ±  7%      +0.0        0.07        perf-profile.children.cycles-pp.update_se
      0.04 ± 44%      +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.ktime_get
      0.06 ±  8%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.update_cfs_rq_load_avg
      0.05            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.set_next_entity
      0.04 ± 44%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.clockevents_program_event
      0.08 ±  4%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.06 ±  9%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.___perf_sw_event
      0.06 ±  6%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.kthread
      0.06 ±  9%      +0.0        0.08        perf-profile.children.cycles-pp.finish_task_switch
      0.06 ±  6%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.ret_from_fork
      0.06 ±  6%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.06 ±  7%      +0.0        0.09        perf-profile.children.cycles-pp.prepare_task_switch
      0.04 ± 44%      +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.timerqueue_linked_add
      0.12 ±  6%      +0.0        0.15 ±  4%  perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.06 ±  7%      +0.0        0.09 ±  7%  perf-profile.children.cycles-pp._find_next_and_bit
      0.03 ± 70%      +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.sysvec_call_function_single
      0.11 ±  4%      +0.0        0.14 ±  4%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.06 ±  6%      +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.set_next_task_fair
      0.09 ±  5%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.update_curr
      0.15 ±  3%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.__sched_balance_update_blocked_averages
      0.08 ±  6%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.memchr_inv
      0.16 ±  2%      +0.0        0.20 ±  5%  perf-profile.children.cycles-pp.sched_balance_domains
      0.07 ±  5%      +0.0        0.11 ±  5%  perf-profile.children.cycles-pp.nohz_balance_exit_idle
      0.27 ±  4%      +0.0        0.30        perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      0.02 ±141%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.next_zone
      0.02 ± 99%      +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.leave_mm
      0.10 ±  3%      +0.0        0.14        perf-profile.children.cycles-pp.switch_mm_irqs_off
      0.08 ±  4%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.select_task_rq
      0.09 ±  4%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.tick_nohz_next_event
      0.05            +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.rwsem_mark_wake
      0.02 ±141%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.tmigr_cpu_activate
      0.07 ±  8%      +0.0        0.12        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.22 ±  3%      +0.0        0.27 ±  2%  perf-profile.children.cycles-pp.msgctl_stat
      0.10 ±  4%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.nohz_balancer_kick
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__switch_to
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__tmigr_cpu_activate
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.idle_cpu
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.put_prev_task_idle
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.select_idle_sibling
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.switch_fpu_return
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__update_load_avg_se
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.cpuidle_governor_latency_req
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.ipc_obtain_object_idr
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.sysvec_call_function
      0.11 ±  3%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.update_load_avg
      0.12 ±  4%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__get_next_timer_interrupt
      0.13 ±  5%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.__hrtimer_start_range_ns
      0.50 ± 15%      +0.1        0.55        perf-profile.children.cycles-pp.security_msg_msg_free
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.radix_tree_next_chunk
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.tmigr_cpu_deactivate
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.native_sched_clock
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.ipcctl_obtain_check
      0.12 ±  3%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.ct_idle_exit
      0.12 ±  4%      +0.1        0.18 ±  4%  perf-profile.children.cycles-pp.dequeue_entity
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.asm_sysvec_call_function
      0.30 ±  4%      +0.1        0.36        perf-profile.children.cycles-pp.__pcs_replace_full_main
      0.14 ±  2%      +0.1        0.21        perf-profile.children.cycles-pp.enqueue_entity
      0.14 ±  3%      +0.1        0.22 ±  3%  perf-profile.children.cycles-pp.dequeue_entities
      0.46 ±  2%      +0.1        0.54 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.17 ±  2%      +0.1        0.24 ±  3%  perf-profile.children.cycles-pp.try_to_block_task
      0.47 ±  2%      +0.1        0.55 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.16 ±  3%      +0.1        0.24 ±  3%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.40 ±  2%      +0.1        0.48 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.00            +0.1        0.08        perf-profile.children.cycles-pp.osq_unlock
      0.41 ±  2%      +0.1        0.50        perf-profile.children.cycles-pp.do_softirq
      0.21 ±  2%      +0.1        0.29 ±  2%  perf-profile.children.cycles-pp.need_update
      0.09 ± 11%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.34 ±  2%      +0.1        0.42 ±  2%  perf-profile.children.cycles-pp.update_process_times
      0.20 ±  2%      +0.1        0.28        perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.41 ±  2%      +0.1        0.50 ±  2%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.22 ±  2%      +0.1        0.30 ±  2%  perf-profile.children.cycles-pp.quiet_vmstat
      0.09 ± 11%      +0.1        0.18 ±  3%  perf-profile.children.cycles-pp.sheaf_flush_unused
      0.00            +0.1        0.09 ±  7%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.56            +0.1        0.66        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.21 ±  2%      +0.1        0.30        perf-profile.children.cycles-pp.tick_nohz_restart_sched_tick
      0.00            +0.1        0.10 ±  9%  perf-profile.children.cycles-pp.change_prot_numa
      0.00            +0.1        0.10 ±  6%  perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      0.00            +0.1        0.10 ±  6%  perf-profile.children.cycles-pp.task_numa_work
      0.00            +0.1        0.10 ±  6%  perf-profile.children.cycles-pp.task_work_run
      0.44 ±  2%      +0.1        0.54        perf-profile.children.cycles-pp.rest_init
      0.44 ±  2%      +0.1        0.54        perf-profile.children.cycles-pp.start_kernel
      0.44 ±  2%      +0.1        0.54        perf-profile.children.cycles-pp.x86_64_start_kernel
      0.44 ±  2%      +0.1        0.54        perf-profile.children.cycles-pp.x86_64_start_reservations
      0.00            +0.1        0.10 ±  5%  perf-profile.children.cycles-pp.flush_tlb_mm_range
      0.00            +0.1        0.10 ±  5%  perf-profile.children.cycles-pp.smp_call_function_many_cond
      0.22 ±  3%      +0.1        0.32 ±  2%  perf-profile.children.cycles-pp.enqueue_task_fair
      0.22 ±  2%      +0.1        0.32        perf-profile.children.cycles-pp.menu_select
      0.62            +0.1        0.72        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.1        0.11 ±  6%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
      0.47 ±  2%      +0.1        0.58        perf-profile.children.cycles-pp._nohz_idle_balance
      0.23 ±  2%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.enqueue_task
      0.52 ±  2%      +0.1        0.63        perf-profile.children.cycles-pp.handle_softirqs
      0.22 ±  4%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.27            +0.1        0.40 ±  2%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.30 ±  3%      +0.1        0.43        perf-profile.children.cycles-pp.tick_nohz_idle_exit
      0.00            +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.rwsem_spin_on_owner
      0.26 ±  3%      +0.1        0.39 ±  2%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.25 ±  3%      +0.1        0.38 ±  2%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.36 ±  2%      +0.1        0.51 ±  2%  perf-profile.children.cycles-pp.tick_nohz_stop_tick
      0.37            +0.1        0.52        perf-profile.children.cycles-pp.tick_nohz_idle_stop_tick
      0.84 ±  2%      +0.2        1.00 ±  3%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.36 ±  2%      +0.2        0.52        perf-profile.children.cycles-pp.sched_ttwu_pending
      0.25 ±  2%      +0.2        0.41 ±  2%  perf-profile.children.cycles-pp.sched_balance_newidle
      0.31 ±  2%      +0.2        0.48 ±  2%  perf-profile.children.cycles-pp.sched_balance_rq
      0.40 ±  2%      +0.2        0.57        perf-profile.children.cycles-pp.schedule_idle
      0.42 ±  3%      +0.2        0.60        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.52            +0.2        0.71        perf-profile.children.cycles-pp.wake_up_q
      0.34 ±  3%      +0.2        0.56        perf-profile.children.cycles-pp.schedule_preempt_disabled
      0.23 ±  4%      +0.2        0.47 ±  2%  perf-profile.children.cycles-pp.try_to_wake_up
      0.40 ±  2%      +0.2        0.64        perf-profile.children.cycles-pp.pick_next_task_fair
      0.46 ±  2%      +0.3        0.72        perf-profile.children.cycles-pp.__pick_next_task
      0.83            +0.3        1.09        perf-profile.children.cycles-pp.flush_smp_call_function_queue
      0.25            +0.3        0.52        perf-profile.children.cycles-pp.up_write
      0.10 ±  3%      +0.3        0.40        perf-profile.children.cycles-pp.up_read
      0.59 ±  2%      +0.3        0.91        perf-profile.children.cycles-pp.schedule
      0.09 ±  4%      +0.3        0.41 ±  3%  perf-profile.children.cycles-pp.osq_lock
      0.86 ±  5%      +0.3        1.19        perf-profile.children.cycles-pp.sysvipc_proc_start
      0.27            +0.4        0.64        perf-profile.children.cycles-pp.rwsem_wake
      0.98            +0.4        1.36        perf-profile.children.cycles-pp.intel_idle_xstate
      0.24 ±  3%      +0.4        0.64        perf-profile.children.cycles-pp.sysvipc_proc_next
      0.06 ±  6%      +0.5        0.52        perf-profile.children.cycles-pp.idr_get_next
      0.05 ±  7%      +0.5        0.52 ±  2%  perf-profile.children.cycles-pp.idr_get_next_ul
      0.97            +0.5        1.45        perf-profile.children.cycles-pp.__schedule
      1.34 ±  2%      +0.5        1.84        perf-profile.children.cycles-pp.cpuidle_enter_state
      1.35 ±  2%      +0.5        1.86        perf-profile.children.cycles-pp.cpuidle_enter
      2.09 ±  3%      +0.6        2.65        perf-profile.children.cycles-pp.ksys_read
      2.08 ±  3%      +0.6        2.64        perf-profile.children.cycles-pp.vfs_read
      2.05 ±  3%      +0.6        2.61        perf-profile.children.cycles-pp.seq_read
      2.05 ±  3%      +0.6        2.61        perf-profile.children.cycles-pp.seq_read_iter
      0.35 ±  2%      +0.7        1.03        perf-profile.children.cycles-pp.down_write
      0.31 ±  3%      +0.7        0.99        perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      2.05            +0.8        2.85        perf-profile.children.cycles-pp.cpuidle_idle_call
      0.76            +0.9        1.69        perf-profile.children.cycles-pp.msgctl_down
      3.25            +1.3        4.57        perf-profile.children.cycles-pp.start_secondary
      3.69            +1.4        5.11        perf-profile.children.cycles-pp.do_idle
      3.70            +1.4        5.12        perf-profile.children.cycles-pp.common_startup_64
      3.70            +1.4        5.12        perf-profile.children.cycles-pp.cpu_startup_entry
      0.89 ±  5%      +1.5        2.41        perf-profile.children.cycles-pp._raw_spin_lock_irq
      1.26 ±  5%      +1.9        3.11        perf-profile.children.cycles-pp.down_read
      1.21 ±  5%      +1.9        3.08        perf-profile.children.cycles-pp.rwsem_down_read_slowpath
     83.56            +2.3       85.86        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     82.93            +2.4       85.34        perf-profile.children.cycles-pp.do_syscall_64
     15.69 ±  4%      +7.3       23.00        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     10.46            +9.9       20.40        perf-profile.children.cycles-pp.ipc_obtain_object_check
      7.08 ±  6%     +10.6       17.72        perf-profile.children.cycles-pp.__percpu_counter_sum
      5.95 ±  8%     +11.0       16.93        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     56.30 ± 26%     +13.0       69.30        perf-profile.children.cycles-pp.stress_msg
      0.48           +13.3       13.78        perf-profile.children.cycles-pp.idr_find
      8.76 ±  6%     +13.5       22.29        perf-profile.children.cycles-pp.ksys_msgctl
      9.05 ±  5%     +13.6       22.62        perf-profile.children.cycles-pp.msgctl
      9.11            -3.4        5.66        perf-profile.self.cycles-pp.ipc_obtain_object_check
      6.42 ±  2%      -2.8        3.64        perf-profile.self.cycles-pp.percpu_counter_add_batch
      4.69 ±  3%      -1.8        2.87        perf-profile.self.cycles-pp.do_msgsnd
      4.42 ±  2%      -1.7        2.76        perf-profile.self.cycles-pp.stress_msg_receiver
      4.70 ± 31%      -1.6        3.10        perf-profile.self.cycles-pp._copy_to_user
      3.87            -1.5        2.42        perf-profile.self.cycles-pp.stress_msg_sender
      4.61 ±  3%      -1.3        3.27        perf-profile.self.cycles-pp.do_msgrcv
      3.72 ± 13%      -1.3        2.46        perf-profile.self.cycles-pp._raw_spin_lock
      2.36            -1.2        1.12 ±  2%  perf-profile.self.cycles-pp.load_msg
      2.26 ±  2%      -1.2        1.09 ±  2%  perf-profile.self.cycles-pp.__refill_objects_node
      3.48 ±  2%      -1.0        2.50        perf-profile.self.cycles-pp.__memcg_slab_free_hook
      1.88 ± 73%      -0.9        1.00        perf-profile.self.cycles-pp._copy_from_user
      1.33 ± 16%      -0.8        0.55 ±  3%  perf-profile.self.cycles-pp.__slab_free
      2.05 ±  2%      -0.7        1.36        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      1.06 ±  2%      -0.4        0.69        perf-profile.self.cycles-pp.check_heap_object
      1.94 ±  2%      -0.3        1.61        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.47            -0.3        1.20        perf-profile.self.cycles-pp.__percpu_counter_sum
      0.90 ±  5%      -0.2        0.73        perf-profile.self.cycles-pp.__get_user_8
      1.01 ±  2%      -0.2        0.85        perf-profile.self.cycles-pp.entry_SYSCALL_64
      1.02 ±  3%      -0.2        0.86        perf-profile.self.cycles-pp.__kmalloc_node_noprof
      0.85            -0.1        0.70        perf-profile.self.cycles-pp.__put_user_8
      0.32            -0.1        0.21 ±  3%  perf-profile.self.cycles-pp.ss_wakeup
      0.37 ±  2%      -0.1        0.26 ±  2%  perf-profile.self.cycles-pp.trylock_stock
      0.68 ±  2%      -0.1        0.58        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.56 ±  2%      -0.1        0.46        perf-profile.self.cycles-pp.prandom_u32_state
      0.62 ±  2%      -0.1        0.53 ±  2%  perf-profile.self.cycles-pp.__check_object_size
      0.51            -0.1        0.42 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.59            -0.1        0.50 ±  2%  perf-profile.self.cycles-pp.__check_heap_object
      0.52 ±  2%      -0.1        0.43        perf-profile.self.cycles-pp.__account_obj_stock
      0.57 ±  3%      -0.1        0.49 ±  2%  perf-profile.self.cycles-pp.ipcperms
      0.55 ±  2%      -0.1        0.48 ±  2%  perf-profile.self.cycles-pp.__virt_addr_valid
      0.43 ±  2%      -0.1        0.38        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.26 ±  4%      -0.1        0.20 ±  3%  perf-profile.self.cycles-pp.number
      0.28 ±  3%      -0.0        0.24 ±  2%  perf-profile.self.cycles-pp._find_next_or_bit
      0.20 ±  2%      -0.0        0.16        perf-profile.self.cycles-pp.check_stack_object
      0.22 ±  3%      -0.0        0.18 ±  2%  perf-profile.self.cycles-pp.vsnprintf
      0.24 ±  3%      -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.wake_up_q
      0.26 ±  3%      -0.0        0.22 ±  2%  perf-profile.self.cycles-pp.store_msg
      0.09 ±  7%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.mod_memcg_lruvec_state
      0.24 ±  2%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp.security_ipc_permission
      0.18 ±  3%      -0.0        0.15 ±  4%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.21 ±  3%      -0.0        0.18 ±  2%  perf-profile.self.cycles-pp.format_decode
      0.23 ±  3%      -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.x64_sys_call
      0.09 ±  5%      -0.0        0.07        perf-profile.self.cycles-pp.__libc_msgrcv
      0.15 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.12 ±  4%      -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.security_msg_msg_alloc
      0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.barn_replace_full_sheaf
      0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.security_msg_queue_msgsnd
      0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.is_vmalloc_addr
      0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.security_msg_queue_msgrcv
      0.19 ±  3%      -0.0        0.17 ±  3%  perf-profile.self.cycles-pp.__refill_obj_stock
      0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.wake_q_add
      0.12 ±  6%      -0.0        0.10 ±  5%  perf-profile.self.cycles-pp.__x64_sys_msgsnd
      0.08 ±  6%      +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__sched_balance_update_blocked_averages
      0.07            +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.update_rq_clock_task
      0.03 ± 70%      +0.0        0.06        perf-profile.self.cycles-pp.ktime_get
      0.08 ±  6%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.__schedule
      0.06            +0.0        0.09 ±  7%  perf-profile.self.cycles-pp._find_next_and_bit
      0.06 ±  6%      +0.0        0.09 ±  6%  perf-profile.self.cycles-pp.enqueue_task_fair
      0.08            +0.0        0.11        perf-profile.self.cycles-pp.need_update
      0.07 ±  6%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.memchr_inv
      0.03 ± 70%      +0.0        0.06 ±  7%  perf-profile.self.cycles-pp.___perf_sw_event
      0.06 ±  6%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp.menu_select
      0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.07 ±  7%      +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.07 ±  5%      +0.0        0.11 ±  5%  perf-profile.self.cycles-pp.nohz_balance_exit_idle
      0.05            +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.rwsem_mark_wake
      0.17 ± 16%      +0.0        0.22 ±  2%  perf-profile.self.cycles-pp.security_msg_msg_free
      0.01 ±223%      +0.0        0.06 ±  6%  perf-profile.self.cycles-pp.timerqueue_linked_add
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__switch_to
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__update_load_avg_se
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.update_load_avg
      0.01 ±223%      +0.1        0.06        perf-profile.self.cycles-pp.do_idle
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.radix_tree_next_chunk
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.finish_task_switch
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.native_sched_clock
      0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.cpuidle_idle_call
      0.07 ±  5%      +0.1        0.13 ±  5%  perf-profile.self.cycles-pp.rwsem_down_write_slowpath
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.sched_balance_newidle
      0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.osq_unlock
      0.18 ±  3%      +0.1        0.27 ±  2%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.00            +0.1        0.10 ±  6%  perf-profile.self.cycles-pp.smp_call_function_many_cond
      0.00            +0.1        0.10 ±  5%  perf-profile.self.cycles-pp.up_write
      0.08 ±  8%      +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.ksys_msgctl
      0.00            +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.rwsem_spin_on_owner
      0.04 ± 44%      +0.1        0.17 ±  4%  perf-profile.self.cycles-pp.up_read
      0.80 ±  2%      +0.2        0.96 ±  3%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.51 ±  4%      +0.2        0.70        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.2        0.19        perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.08 ±  6%      +0.2        0.28 ±  3%  perf-profile.self.cycles-pp.rwsem_down_read_slowpath
      0.09 ±  6%      +0.3        0.41 ±  3%  perf-profile.self.cycles-pp.osq_lock
      0.97            +0.4        1.35        perf-profile.self.cycles-pp.intel_idle_xstate
      0.00            +0.5        0.46 ±  2%  perf-profile.self.cycles-pp.idr_get_next_ul
     15.58 ±  4%      +7.4       22.94        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.43 ±  2%     +13.2       13.63        perf-profile.self.cycles-pp.idr_find




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

