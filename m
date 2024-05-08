Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCA43A1BE;
	Wed,  8 May 2024 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715154126; cv=fail; b=mhVpglRm2fPbXvugPsRbSknQo81ydZVMgQGDALKcFHV/N6WeKPsnoPjKeCO/YhBHTYmR8FCvNYvEh9dLdBxhVp6wQ7iInyE7XtWvF1Eh7nfusKqzkfwfAMt9zq7hEVQA2u/tPKdM7ILKMrPb+60dXPNnEzGTin0B7MTtmUmcGUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715154126; c=relaxed/simple;
	bh=fg9kcdzPFSqQFijJSdAoUOI3U24JoyK75CJO9gGiF7Y=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NmKV74sP1lv1WVuYtlpl9SDZOq1bf286aLEGKY6Em/CLcZuR9QDm/494yW6itRNxE8kh/GiFPLbQEHOBTAtCuJ5vVpYJYzEXT2XbSSevJzPDceL6NojZbpA0LS+6HFY+9mlQZrloxEhmSJCJqZccvuXf0dVpwc0IOOAPokucdtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqYLtlzl; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqYLtlzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715154125; x=1746690125;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fg9kcdzPFSqQFijJSdAoUOI3U24JoyK75CJO9gGiF7Y=;
  b=DqYLtlzl8LkWM/tBaef+RpAhfUimAqZQI6b/fuLhTq7H8TdfBz9Dek4L
   ZCif/b3SrvaF0HU+vcwxpP6zV+0t0XgWbIeA0eyqyIJOodPEX66xpBzcm
   DypF0xCZh/FFhS1WkgqhHHu1SRfRPEUEN2RhvxNAscQshG/41ioZDIen/
   fEnkL3K0yr3q2yitaowEp1RdJmNvAMopLkXhkPCxnN7y4sq//oEYUGb43
   s2x+PMZp4rRowrEaH/jBiT7ZPcisxmtT3RZPsOJKhdBiTsRGKnHCkb+m1
   bN7Wt4JsN7/FBOerx5tgF22r/Q93jZxBXqGlXemzs1Qjpw7XDQM7F3ehk
   w==;
X-CSE-ConnectionGUID: c9HrG1rfT6Cildd0Cqjkng==
X-CSE-MsgGUID: WE1Od46HQ4qmQ6jRCiQ79g==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11155045"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11155045"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:42:03 -0700
X-CSE-ConnectionGUID: fbhEIF+kSV+5mMvVK4uY6g==
X-CSE-MsgGUID: yGevak6HQWm7rJJwYumAcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="33356629"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 00:42:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 00:41:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 00:41:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 00:41:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKWS30umos1s7SWoxNnq7L0OCQlUitam9qIICu3FChXaGgNNxdflH6AnBVL/HJw6k61D34mmK3n1A0Fu8EJhh4+QqXVdpeoTddNH6cc4R3FtwB/ODaT5b/thCTRqkPqthftaBWC+azbvED1Lw1ue8i0I1irBPHOaf4cGeSGN4BmhrQtpLZSUfftIrs/0DiKQa2oiPeWPg9DuBgcDKg/dJbi8h3kx2GoAoT2YJsFMCcI5W4iN/p5wchXV/Tccc4lkc0v75zk4lfOoj6qPWuv479IgTYaEpTetZ0e243LqBOpp5eGfrfUSlA3Yg+gPPVBEl33ULAVsrMtberppn1oVxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5KenTLNIuRK3D8sPF297I8PJioVTG49qTCIffye5zY=;
 b=c3YLFZRroSV+DfjwGEFZ9tNwRnHIRRUL0OBujgskPKsEMJfV7v7p0KfRsoBStmMLEDGdPKEXaa77v/VR4lgLRS4yAemHYlPeR5RJu8QV9cuw71PYefxP4Rzl6eSh05+CRmmXPrFB5BxmPleA0mVvn+5iBOK8bpVTS0+Q+WnSKJQNmCvEkSvbuRc/iFsQpSQZUydtHSVvrZF3cMMjGvRHe5GjpPSmwbTxd2Acwj0beLrOY8P8suLvDf0jmN7oiQ80wnhggsPLMaHpnnb0mnG4CsWVIK5cxr5N8C2e2HHkBhTM2VSXyimjANdwrG5KNxlKIVY5gZb0MA9T2Jxq2xncuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA2PR11MB5116.namprd11.prod.outlook.com (2603:10b6:806:fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 8 May
 2024 07:41:57 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 07:41:57 +0000
Date: Wed, 8 May 2024 15:41:46 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Aaron Toponce <aaron.toponce@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <ying.huang@intel.com>,
	<feng.tang@intel.com>, <fengwei.yin@intel.com>, <aaron.toponce@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <oliver.sang@intel.com>
Subject: Re: [PATCH] random: add chacha8_block and swtich the rng to it
Message-ID: <202405081501.e1c083b0-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240429134942.2873253-1-aaron.toponce@gmail.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA2PR11MB5116:EE_
X-MS-Office365-Filtering-Correlation-Id: 290a36ba-f7bc-48e4-1668-08dc6f32566f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?a+y7lsmK4JioFWnrfYlyhPHWHKS7Pcq0/6nFlqyWbwmwcHP7EGtCEoe4+b?=
 =?iso-8859-1?Q?CoCIjEkm3vw2s8CwMUt19QHojl5m+57FmgQuFHWiaHe3YNNg6MzZVmMln+?=
 =?iso-8859-1?Q?vqidDBpar2tdNuSG1JoH96I9fKDOLaMGqebVCSpSc99xanH4W1KmNHy/Ec?=
 =?iso-8859-1?Q?EkRdOIHPFBAZsX3uCrPEcT64QgTchYETcvU3n5tChmbMo2vXsPhK0OwxaQ?=
 =?iso-8859-1?Q?hjm/NZcbMJB5ozB8Mf9npyrzvtJuOBpv/8Pgyc9kglCjLhPyKEg81qtggB?=
 =?iso-8859-1?Q?43vBgT2tdeWdx7vhBs4NlXIl0eO1zsb9Sl8MknnoZo26pRXjW3F6gTjx9d?=
 =?iso-8859-1?Q?tQRWRk0I8kWUNAFfUfZOFRex1AHI+XhXKbDVscj5crX3nLmPUUqKurltFc?=
 =?iso-8859-1?Q?WD20AqMP3FQkP7sgLqdgUWq+fslw4Al/ZytVyiQ+XxJcIMhrd8Sxj4uyRz?=
 =?iso-8859-1?Q?ROj6hb4lb/hmDMW446DGOLANchW7DIhAONREWFxPQjv6AR/3wunBsJmoMS?=
 =?iso-8859-1?Q?FXp2BT+IiVHbnb262/nDc75t3j+/KC0LX9hD7w1LaNFPVLFqYuV86Gb8Qf?=
 =?iso-8859-1?Q?g+IbPvjb4o/lXJnYFXR48nPnzBX+irIcaI7JXkSDKSOo+m83Khpbw/k8BP?=
 =?iso-8859-1?Q?/XTiYHMmzKMbUQIYzWXvCmIW7x2QlQR12o4yQVxs4E5Q/rfvTwv2JtHkVD?=
 =?iso-8859-1?Q?ZptZe0wcB7cuaQxj0+20tGUHQHrry+wNBWZR4iral30M+riG5iHdwINGIO?=
 =?iso-8859-1?Q?RRWAwDTlgRBq9AmREBat5yKQ3HinAgBKGpYj23yjoXluhHbInBxcOdJYMS?=
 =?iso-8859-1?Q?dxM9JkH3vAuWEAd3ppKQPXTlphEqKKFgNAsny2F+5BQ2whGLud2TdDB2uN?=
 =?iso-8859-1?Q?weAOILX8xCkdwPhV2iXWPDCsEhxEp1iv78FN76jNRrbuwRlQFJNZjkWGoF?=
 =?iso-8859-1?Q?Jyci/oAWomVvxXJn5hlPi8xtXTpSb0vGBM2Lv0bkWhP8a2pBA32xxpXYDm?=
 =?iso-8859-1?Q?8s3V5xX5WXU0o+09pHm27vfXDfT2Gc8jssH9R9c3286sBnSYDYh+OiwUEF?=
 =?iso-8859-1?Q?mVnzKL1HQiw6B8rsY3jYgC9F8bRGAkHfFsMcd4c1at7VHvgn2yCLXaSkxo?=
 =?iso-8859-1?Q?ZFKq4xcuIOUbt6uB96dXkHDxcBtvUHumRCsCofC6xk2ZsrcckPsUJhjylX?=
 =?iso-8859-1?Q?x5QpZbGnCWM1FlyJxghPeZXKy9AqRLO+0SWqRFf176XvJ2NrgyoUxpKLV8?=
 =?iso-8859-1?Q?VxBrBDGYsAFajFZNTWk+Y/vL4ARYi21tUNuLMLAHU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?kQhcqJp8gMGmJBYF2k4umiKEHK00lHtbKpjs/2/N7MhrEch8GRQ/muy/PK?=
 =?iso-8859-1?Q?bI/nXIxvrw/c4/LnejK8dCFC1smH6I2hA5qdlGVFXef8dWy89TxZmgPBPX?=
 =?iso-8859-1?Q?WcyHBukVo5VUzCTvsNbs8UxSpM+45BQBCfA4KeBppIBTBJbNZ5UXhPuPVc?=
 =?iso-8859-1?Q?9wOtesybykbqd8Yn70omXMdH08EodhEliIdlTaJ3Uq4+mxp3xfIyxW+t71?=
 =?iso-8859-1?Q?fm2ZjegykatWwT4gbdSJpXec7iogTqoVCqAaBL83ezG7hKiLBQLEq7QEQ8?=
 =?iso-8859-1?Q?0nn2Ih6PWU0PP0q/2PUQG0pJfQGP3uDZvnQVfH7SnJr7cE7iErL40k/Sjn?=
 =?iso-8859-1?Q?NVlO78fBiEbgmqV+AWb3X9Em879KtbSFk2gdPLTN4EdB/+6j3p/UHuHnWS?=
 =?iso-8859-1?Q?012l8OLxl91suVnpTT1AQrlnHBIMUau2xrTcbeJLi7Kv9UrjbPlhGv9J/M?=
 =?iso-8859-1?Q?hfN096csbG4dyzBkZeveGRkSZhmGZcH+xYtfGwBIonIJNf77ijd8+ihIed?=
 =?iso-8859-1?Q?//QHlAU4Dpc/NelZN5YFOEsy07OU9txRdOMiWPVGoXG0fC9fh3DjeX/ANl?=
 =?iso-8859-1?Q?WxckI18XSQVpFiaxWw+7BNx6uIJk9wdtvymikAFE8ESMahBTo2VvzCt2fb?=
 =?iso-8859-1?Q?ua4FUwjj2gyfyxvetD2iGbRIV37cgOhs7/gv9hRKHtAPzbH/jHIRGow47m?=
 =?iso-8859-1?Q?UlIfpwzal8Tx8cEOYeru9aBvhEOsFvikMBUU+ZgmkimHz+j0r44aq6fa+5?=
 =?iso-8859-1?Q?M5SbGmWRP935dDS+atf2iaJp23TblGinG+H/kpnowNMoFXleouY9bEln0l?=
 =?iso-8859-1?Q?yM9xRjb31Sam495WK4UQ8vnlvMiXTIoTbPNbFata+GgQw2k8M2wZViXtYf?=
 =?iso-8859-1?Q?Qcz/QHl9tDUmtCCmBrTN9puGw1OhOQfODbT2MJ1djMPgEu+ZVeJuwk2O9S?=
 =?iso-8859-1?Q?acWyK1Fg2sjc9eDoGID+iuPg2X8H1dtjb5yM97eFT59vHjt3rTnfIoN5Bv?=
 =?iso-8859-1?Q?Ammymn1cCx1uVbVcLHqbeTchSI/sL+eTTz7/aeUEF6cXJ2xQMyW4xFgDg0?=
 =?iso-8859-1?Q?8lfQkZ4o+LUFIP5svzVjLps2HTdEdEpdBZMNA8r8Aj10YUsK+64W8FKf7M?=
 =?iso-8859-1?Q?7JgRGSy/V4EsR38A4vI/zDwnOTuYYkPFiRP2xpo6dfU8BPfAbbb+y4zctI?=
 =?iso-8859-1?Q?KmMiA8VErAS5PEUBRrVG8EPFhBPsTnuzTwkIMDrSIAZExfsbyq+4EGnq4G?=
 =?iso-8859-1?Q?GAte0jXEfHQTNTFQqFFL1MEPETSL7HZeHA8L645n28gy5b/jQ1q9KyF0ae?=
 =?iso-8859-1?Q?dcB7CUD8YL5qY9R49DIiPGmJ4dF5XoTI5OiF48/+QdWRZFP9bAW8KGbn2X?=
 =?iso-8859-1?Q?6nkVzUL4u2ji1rPg1a/lddYc58VvMHreAVhZwrAd6w5GxGJb0d0FWabmvK?=
 =?iso-8859-1?Q?0+UTYc+ydab6n+hKG9zv1+Ldr0szlkN1HPF92MUbKSXDpo9bWOUKKPFavU?=
 =?iso-8859-1?Q?VRsKcQ5g3QZt2lEDl6GLw3fpoomKzC9pabUrc4ne4VNlA7tRx2G9oUL9ze?=
 =?iso-8859-1?Q?DrUClLSg3/UTgbk4XiN+LZcsvXhjwtuVpavw1CyWzt9+Hb/PIWIJxZ09yb?=
 =?iso-8859-1?Q?F+YGW/gkFWA2uSZYRhvseUyy+V6Yepm0s40gDAwCJ50QNX4PwAoSLxwA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 290a36ba-f7bc-48e4-1668-08dc6f32566f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 07:41:57.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2etp4SGV/hOERgPupxbhNq+nKqicchzVDI6lYn3xq933NMt5H7yvtoobSdlbmNuUSTFhmm2M2alwKufWc/E5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5116
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 80.5% improvement of stress-ng.getrandom.ops_per_sec on:


commit: 470a8ed1624a45a74176a786e28fac3234c71424 ("[PATCH] random: add chacha8_block and swtich the rng to it")
url: https://github.com/intel-lab-lkp/linux/commits/Aaron-Toponce/random-add-chacha8_block-and-swtich-the-rng-to-it/20240430-130757
base: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link: https://lore.kernel.org/all/20240429134942.2873253-1-aaron.toponce@gmail.com/
patch subject: [PATCH] random: add chacha8_block and swtich the rng to it

testcase: stress-ng
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: getrandom
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240508/202405081501.e1c083b0-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-13/performance/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/getrandom/stress-ng/60s

commit: 
  ed265f7fd9 ("crypto: x86/aes-gcm - simplify GCM hash subkey derivation")
  470a8ed162 ("random: add chacha8_block and swtich the rng to it")

ed265f7fd9a635d7 470a8ed1624a45a74176a786e28 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 1.793e+09           +80.7%  3.239e+09        stress-ng.getrandom.getrandom_bits_per_sec
 1.054e+08           +80.5%  1.901e+08        stress-ng.getrandom.ops
   1755950           +80.5%    3168792        stress-ng.getrandom.ops_per_sec
     13.18           +74.9%      23.05        stress-ng.time.user_time
 1.088e+10           +52.5%   1.66e+10        perf-stat.i.branch-instructions
      0.29 ±  8%      -0.1        0.20 ±  7%  perf-stat.i.branch-miss-rate%
      0.57            +7.2%       0.61        perf-stat.i.cpi
 3.411e+11            -6.7%  3.182e+11        perf-stat.i.instructions
      1.75            -6.7%       1.63        perf-stat.i.ipc
      0.29 ±  8%      -0.1        0.20 ±  7%  perf-stat.overall.branch-miss-rate%
      0.57            +7.2%       0.61        perf-stat.overall.cpi
      1.75            -6.7%       1.64        perf-stat.overall.ipc
  1.07e+10           +52.6%  1.633e+10        perf-stat.ps.branch-instructions
 3.355e+11            -6.7%   3.13e+11        perf-stat.ps.instructions
 2.049e+13            -6.3%  1.919e+13        perf-stat.total.instructions
     74.33           -18.9       55.41        perf-profile.calltrace.cycles-pp.chacha_permute.chacha_block_generic.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64
     83.70           -10.8       72.88        perf-profile.calltrace.cycles-pp.chacha_block_generic.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     97.41            -1.3       96.15        perf-profile.calltrace.cycles-pp.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe.getrandom
     98.10            -0.7       97.41        perf-profile.calltrace.cycles-pp.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe.getrandom
     98.19            -0.6       97.55        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.getrandom
     98.23            -0.6       97.61        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.getrandom
     98.43            -0.4       97.99        perf-profile.calltrace.cycles-pp.getrandom
      1.30            -0.2        1.14        perf-profile.calltrace.cycles-pp.chacha_block_generic.crng_fast_key_erasure.crng_make_state.get_random_bytes_user.__x64_sys_getrandom
      1.56            +0.0        1.58        perf-profile.calltrace.cycles-pp.crng_fast_key_erasure.crng_make_state.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64
      1.62            +0.1        1.69        perf-profile.calltrace.cycles-pp.crng_make_state.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.05            +0.2        1.26        perf-profile.calltrace.cycles-pp.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe.getentropy
      1.07            +0.2        1.30        perf-profile.calltrace.cycles-pp.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe.getentropy
      1.13            +0.3        1.40        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.getentropy
      1.16            +0.3        1.45        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.getentropy
      1.31            +0.4        1.73        perf-profile.calltrace.cycles-pp.getentropy
     11.88            +9.5       21.40        perf-profile.calltrace.cycles-pp._copy_to_iter.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     75.73           -19.0       56.70        perf-profile.children.cycles-pp.chacha_permute
     85.45           -11.4       74.03        perf-profile.children.cycles-pp.chacha_block_generic
     99.14            -0.5       98.63        perf-profile.children.cycles-pp.get_random_bytes_user
     99.20            -0.5       98.73        perf-profile.children.cycles-pp.__x64_sys_getrandom
     98.52            -0.4       98.13        perf-profile.children.cycles-pp.getrandom
     99.45            -0.4       99.07        perf-profile.children.cycles-pp.do_syscall_64
     99.49            -0.3       99.14        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.44 ±  4%      -0.0        0.40 ±  6%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.46 ±  4%      -0.0        0.42 ±  6%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.42 ±  4%      -0.0        0.38 ±  6%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.42 ±  4%      -0.0        0.38 ±  6%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.24 ±  7%      -0.0        0.20 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.25 ±  7%      -0.0        0.21 ±  6%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.12 ±  4%      -0.0        0.11 ±  7%  perf-profile.children.cycles-pp.scheduler_tick
      1.56            +0.0        1.60        perf-profile.children.cycles-pp.crng_fast_key_erasure
      0.03 ± 70%      +0.0        0.08        perf-profile.children.cycles-pp.stress_getrandom
      0.09            +0.1        0.14        perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.__memcpy
      1.62            +0.1        1.70        perf-profile.children.cycles-pp.crng_make_state
      0.00            +0.1        0.08 ±  6%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.13 ±  3%      +0.1        0.25        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.17            +0.1        0.31 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.37            +0.5        1.83        perf-profile.children.cycles-pp.getentropy
     12.20            +9.8       21.97        perf-profile.children.cycles-pp._copy_to_iter
     75.17           -19.1       56.06        perf-profile.self.cycles-pp.chacha_permute
      0.05            +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.05 ±  7%      +0.0        0.09        perf-profile.self.cycles-pp.crng_make_state
      0.07            +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.do_syscall_64
      0.06 ±  6%      +0.1        0.12        perf-profile.self.cycles-pp.getentropy
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__memcpy
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.stress_getrandom
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      0.00            +0.1        0.07 ±  7%  perf-profile.self.cycles-pp.__x64_sys_getrandom
      0.09 ±  5%      +0.1        0.17 ±  2%  perf-profile.self.cycles-pp.getrandom
      0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.13            +0.1        0.24        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.23 ±  2%      +0.2        0.39        perf-profile.self.cycles-pp.crng_fast_key_erasure
      1.81            +1.4        3.23        perf-profile.self.cycles-pp.get_random_bytes_user
      9.46            +7.4       16.86        perf-profile.self.cycles-pp.chacha_block_generic
     11.93            +9.6       21.49        perf-profile.self.cycles-pp._copy_to_iter




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

