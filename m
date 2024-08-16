Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A521386BF
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723797980; cv=fail; b=qamuPSTAzzSw5DdVj8GS10pYtEg0oPmvxe07Z1LVdmx6os68ly7ywuBJSzt9u1ZnJlctTDQGnTmjEuBOC97OVUAEa/IJRcG4gkxh9sio/GdQ3YqDu/ubYjz6lZjOx7glqvdm4rb9rWWZj9ufQ5qxs9HpMgJD7rBxnW0lo7mJsh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723797980; c=relaxed/simple;
	bh=JFX5QNw5lJspqdD26SLU03r4h3JJuXk9b1FDGxsAVHM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ir7X7oSnO2s/gCy/WbDC40nkprmlBA7oDslLniuBWP9jdoYXP3/+nNo9kW5l8zsWGPjTNneodHVaO3r6C+95rgozYYyVjpAKo2sdWLPfZz72qKaw6L+NwC4FyrdlddsxP7MLF5D+8t56nGH1B/Tzdf/JM507f7vcZ3Y/0pEwUDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PkP8iKHi; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PkP8iKHi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723797978; x=1755333978;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=JFX5QNw5lJspqdD26SLU03r4h3JJuXk9b1FDGxsAVHM=;
  b=PkP8iKHixSaHKuK5QgNssi9V6pbTGw9wnCUY05LHL7ULHSBy/yuBDkSR
   GflSsJJXdN2nKr4EolZzpnSEdUk9MnTYssE18V3PE42xd7Z8hIDP+MLwv
   BKJNGd0FCAMSKf9E8GdeRbFdX/WCAzY/UDgLa4QpUshwYaegm/GNbSphx
   VCvYkjDHWpXVL/Ivguan0hIU362wlDbV5xq3gEFbTnlpwX9PBkVE7nrZH
   MNRSGtwRn/Wsw3+d8h7FuEpnwR/GMto64slpJwVP9q1M6P0NPki4IIRmw
   Ueh63oi2e3euIC/Cd4EWYt+iJ0X3CPgixDm+IdbxMQkjppRzXTG3LxBaA
   g==;
X-CSE-ConnectionGUID: JPoNsaqBRz6OomcoZBKn3Q==
X-CSE-MsgGUID: ACeFFVA2TuO/EzD5g0K1MA==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="32761217"
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="32761217"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 01:46:18 -0700
X-CSE-ConnectionGUID: H5qbv8D8Sxm6wQERMz7LmA==
X-CSE-MsgGUID: YeMP6EAwQtWQyTJp9rxYrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,151,1719903600"; 
   d="scan'208";a="59573452"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Aug 2024 01:46:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 16 Aug 2024 01:46:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 16 Aug 2024 01:46:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 01:46:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xqxq1Vc/V3+i+svmMGeMn1c69OXmr9umeLSMfbX1XH/jhgkJXDu7g3XjlB8QDQO/MDC2xM2obPJFxWDE59DsGSA8be6igy6ugAfKC9pHOu3pwar8gddyygoPcws+kQqNxAfagFBElxOWR2w5oEyzw10LSyYIQrYAMchGDCcYlPgB4aizly1dyI9oeLmkafu9s/pPvulxxP8Kxljm2qB5qwy7N63yx33XogBpguRJw32zOrvxOsyXegGSMyvYWDrTnMOnN50mH5a0bXEVM7rbeP/81W2P7H+mXPh0kCqwsIsfJAjhxj9m70LsAkwu07E+IVVUq0c6Ku0mMFz3H9b2mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+lCmI8jZdwiWpqhPgMMLZTGfQCiS9AmdGX+bBxxhsM=;
 b=fNP6bz0CYDyHxVCuy3//+FF5ObCMOtLhsaikQHz7qiU6QJhIj49Yw9NjFS0D2YdHXy3uzIHoOgWHEMFjhV+SAATj54eyXlcJCiyxYdcBqcqp0sl0iXgBZVKOf0efrWckFMmAIg0QXZgXiFdUU+uysdipTFwdxkYFx3MS9+sliTmN8qlU3LSZI6x+enBb2e+lBI9dcDWijjOqb5xZEthF439VSdKZEuQAmB07vvuWdvMM26nTXYUFtMznOLOpSPy76Y7wlWLpMKAZdXEvgksOIBlMYhIJtckKW6NMBGZNaXCCAg2AkJ9J6LBcdzWMepnI6ad/BlSctU8bHOKwO1R3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA1PR11MB7037.namprd11.prod.outlook.com (2603:10b6:806:2ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 08:46:10 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7875.019; Fri, 16 Aug 2024
 08:46:10 +0000
Date: Fri, 16 Aug 2024 16:45:59 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<ltp@lists.linux.it>, Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>, Horia
 =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, Ard Biesheuvel
	<ardb@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH 1/3] crypto: api - Remove instance larval fulfilment
Message-ID: <202408161634.598311fd-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA1PR11MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: dbcab8ec-cb6a-4a2f-f916-08dcbdcfe092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pdUQgQavZrKfTpWzL4S30RTQRXUPVqTlJhkJjhX1QT3Q2Z4cF/KdNvnRHx6i?=
 =?us-ascii?Q?+UuayltggUQ5b1MweEKWdUB6cq55yKUWElPOHm1TuU9Y7+lGfBsB8qe5ZhqQ?=
 =?us-ascii?Q?1djQjNt9b5EXfb7WQEKA1bLPCY72jr4On6HkvbJUpfi5Vg5/OUhnsgTVf7Kw?=
 =?us-ascii?Q?axdXisoxSdgMGrR78Qe1houTGtQveZMfEUWhAuf1Ovy5fJLSFFdgOEC2GKGB?=
 =?us-ascii?Q?Qz65jVNNOdNM8mo/rw/O80EjKnA26+lULb04F5Uhf+D5H+ske648q7GfS7ib?=
 =?us-ascii?Q?PUD8HI4sMKpD/JmKL1mGmg+POUskluPHfvvweSnjrbgVf3AjerKY8Vg93e7w?=
 =?us-ascii?Q?hleHBZJ7VC4uve3hyWjrR+2JGkmGbECsFpZRDGbp+8mj+7oLdlO1VFV7xOFm?=
 =?us-ascii?Q?of+a/BRY8HMDGrqpAL++OLw/gaYc4QrATGa9TpoD6JK3lKOHLiE8D6Ev1yYZ?=
 =?us-ascii?Q?OXfeaztX+ENVcjWnPuvXkO/a9Fm1+s0FLwuHQRxiKaX0n9vCQzqaW58RVbei?=
 =?us-ascii?Q?4JpGqU4mAcSC4/lHTT5YFmeRVIDqb2wSeOcqX8W6aPYmK42vb4UAW8ywBAaV?=
 =?us-ascii?Q?mHZG1iLj5dB6Qa10Vj5cvwHulYVWjKZaG7qkYj2nHx8twXYUmAnOdhBlhvxn?=
 =?us-ascii?Q?lT9f3R0QTqZkHqYbKQ6B5CiST2y4pz9a0UE4JipwFZi1/0FFR+rVVRkoj8Fk?=
 =?us-ascii?Q?LrUVn2PkF5LFI3DpI9V4WYdHeQcgOX/18DlDE+DyHvhcacEEgI515LtMNbER?=
 =?us-ascii?Q?vChHlGFID86JdFG4c4WVs8n2IDvL9mZJm60wQHZ43+DoRkmQpF4+CjXO5fZJ?=
 =?us-ascii?Q?7eDJSRm5XeYhvgAdJUIUqg4PSYyG2sg461jk6GUAzHm7Y4VVUPhAaEZ4fzuy?=
 =?us-ascii?Q?RWtbuViZ5gkcQu41qnE2EcbQ5SpKS35QqVebOqNlW5hA2z1oQUbPdAQxZkJ6?=
 =?us-ascii?Q?nMNsSQ2CdzkI8Gi3Jd1jQ6saE364DHhuPd/N9dnoNjdhuvs6ngNdyhw1UqYb?=
 =?us-ascii?Q?0H+8fijVy7xevsSERXnJp0ryfVuCv+pIJpD4eItvRxJ8EyaIBll6NWpkzM8x?=
 =?us-ascii?Q?CO6Spu7I+6+ZmCALTEkKya0geWdQzwqExe71T0ridcGKmDt+kGFjOowmoSL3?=
 =?us-ascii?Q?YcM8quuebvs78a4dXRqghWHk88pizI6F/Z8w2K/Hvkb4gwe01qXXattgnTDL?=
 =?us-ascii?Q?s7ywv/hikylj5Q1+GGtTuIsubEjxT3DspIHvM+xBFm1lTMgz/2DTXQRyU6ry?=
 =?us-ascii?Q?N9Gh41AywaPptr3r9vYbTcWODbh1D/MOBuJ2U1Nl7bmMQmPFQ8ko1Vlyo1nX?=
 =?us-ascii?Q?4CU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iPCS0EgRoL1mCftWSJfMX81gr5ynlLGgu/XclT4X3FB1Y2WLfLaxGnz/CRx4?=
 =?us-ascii?Q?2qTZRXUzSjhBuiVR/ikj2G505JcxtEjDnfpnvcV69Wh+u/rgLbc7cbeo4Hg5?=
 =?us-ascii?Q?G/1/RbAVO2cBmzZJTyas8siMdwi1jRAQKhDXXcIAj4z+HglWeofMxV3rcxkR?=
 =?us-ascii?Q?hrggoVrUtqhPLQ8ytBeu7qjisrYdfNy1yoEiZK0ivV1psLI2eCLaBvFt2GhK?=
 =?us-ascii?Q?kri+WbhQmMp07TbUJolmkQEQu8jhYZDRzYilb5VzRXX2oAJhqF5uF5GRRzEQ?=
 =?us-ascii?Q?L/YpEYyTHkfuAmAqCrvksW5gE8yiYBtY5tKc+kYqyTv9+5fQgc7ZV3zEY9xC?=
 =?us-ascii?Q?HFSEW/B4tmTKMOGATksx/ZMiRme0vK2CPwyl9XDngVFgqKiwqNlhD0sTzAzI?=
 =?us-ascii?Q?wVdIx+Y7gtLr6fJ3LWSQX7XAP4VZLtdmk+6INk07x9/MUY/rEuc66wOtsUGc?=
 =?us-ascii?Q?Ze+CBjL70vAfpdsqs3fhfib26n88meKI1I2lMlXKR1OXg2ay81QSy6EQCxhW?=
 =?us-ascii?Q?bujjRt8PCOWWPcAcn9YFEXo4FtBB8tlrTBqwChgMCaWcCD3X+MDVL2OzBokM?=
 =?us-ascii?Q?m8hx+MN1lv5f0zjZOgZvSWuHOhq9iM6pmUo+3T9h9AA4NZzwMkrs9iOu/JUT?=
 =?us-ascii?Q?wWiJKC3n7HBKllyCANS4PE+b1v8RcnVAPs9KxhFnfs3wu64f8qI7xP4f6aEg?=
 =?us-ascii?Q?sxGTX0ImTKtsCOcUHE6wFuu9CiBcZ/Rb2zljOHTsrgR9cxy51rlh7oM/HA+t?=
 =?us-ascii?Q?Fit1bSOfGwkgb/6RoMQP9MpfiJa9KvGJ75QhnSLcgJB8pMyZfHHnrkJWYvgi?=
 =?us-ascii?Q?T+tMopInyGglzRY6yk1Q0hwU0YH+Rd9vKTq2lTzTBG56sm00a7odkQFZVaJU?=
 =?us-ascii?Q?NTCu2ulmj1kA0JsxQvjBsXxW1MZycy1n4XF6mJQ8uM6SBahRqS3U4tBMSCzI?=
 =?us-ascii?Q?up8GoGS1s0QHy6jLPXUQFmmx/J19bci9JXlSrZomEwxu0YGvsLOfMowX6q4r?=
 =?us-ascii?Q?qSLzAZZP4REVNHDtBUPqxibTnckxTpRvmDne6WbGkqzK0Kk3xK8FVGrMpTFb?=
 =?us-ascii?Q?DcRCGBtQ1Irndv1nhSO374pH8uhuuYUwJXfUQhR/reIzdMWBBC+L0xWvPPEM?=
 =?us-ascii?Q?E+OOuC6CwAX6ZCdTmexJOq5V2XoT3Zz+xX4XLk90FSf4pc4IsLTGr7wxORb1?=
 =?us-ascii?Q?RHggx72I7AjzafyJwAC0iL7101Y3moQqi2FVs4RTbrmtnLaiz8BVE0hChHxv?=
 =?us-ascii?Q?zIRWJSoPk63r61AHi56Svq4gszOH11QzNA5GN4A2s5D7stOCNb/H1QEne0Th?=
 =?us-ascii?Q?G7603qH6C9zHSxIhfnrlwoJZMW4TkeAqMrCQtEKjjl0USyJSd24hyaEgZkLH?=
 =?us-ascii?Q?AS1wK32xTHbwqqa2e7Z6gngFb7Gixk+KVJXPM9dJd76TliTdSSUPPlMO/xmx?=
 =?us-ascii?Q?JcL2tQ3iUhB1wvlsumKHPiRMCd38xtHvzT/AZx19AnNjkf8l8OKn4XQb+g0C?=
 =?us-ascii?Q?oxlyGFfcnbv2Cit2VT/k2JiNwwN0ScwtZtH4Pgr9fBrjp7XZAdhDlL3HfFpp?=
 =?us-ascii?Q?yaUp9iPj7qD/Hfq1mkHglg+XK3WCTIYzQxQaNzZlqWxGI5xtb2/nAzhvdNUv?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcab8ec-cb6a-4a2f-f916-08dcbdcfe092
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 08:46:10.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLKHeK21UVQkeaOJqyj6U0PhEnyjUb5NNmOVqVD6uF+zcbXjl7Kk4SMuuuehwgkaHIsvhMf42UhbdSbM3YpZTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7037
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "ltp.af_alg03.fail" on:

commit: 103961609b0935ee6ad40b0a9fea2924b1c62c18 ("[PATCH 1/3] crypto: api - Remove instance larval fulfilment")
url: https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-api-Do-not-wait-for-tests-during-registration/20240810-160343
base: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link: https://lore.kernel.org/all/ZrbTUk6DyktnO7qk@gondor.apana.org.au/
patch subject: [PATCH 1/3] crypto: api - Remove instance larval fulfilment

in testcase: ltp
version: ltp-x86_64-14c1f76-1_20240810
with following parameters:

	test: crypto/af_alg03



compiler: gcc-12
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (Ivy Bridge) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202408161634.598311fd-oliver.sang@intel.com



Running tests.......
<<<test_start>>>
tag=af_alg03 stime=1723519123
cmdline="af_alg03"
contacts=""
analysis=exit
<<<test_output>>>
tst_test.c:1807: TINFO: LTP version: 20240524-172-gcc410eaa0
tst_test.c:1651: TINFO: Timeout per run is 0h 00m 30s
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Test timeouted, sending SIGKILL!
Cannot kill test processes!
Congratulation, likely test hit a kernel bug.
Exiting uncleanly...
incrementing stop
<<<execution_status>>>
initiation_status="ok"
duration=80 termination_type=exited termination_id=1 corefile=no
cutime=0 cstime=0
<<<test_end>>>
INFO: ltp-pan reported some tests FAIL
LTP Version: 20240524-172-gcc410eaa0

       ###############################################################

            Done executing testcases.
            LTP Version:  20240524-172-gcc410eaa0
       ###############################################################




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240816/202408161634.598311fd-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

