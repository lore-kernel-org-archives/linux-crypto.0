Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4018D376490;
	Thu, 16 Jul 2026 07:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784185574; cv=fail; b=Ff4FHEwCch0AQyfmN48mDgSY4p6gP86JyKbEUC3mllSKAm22PpnVujcykwS7itoscAsXnuyh2V+3SJfdLHHeD0B8WCFl9B8ZLZQ065l2S2ZptNit+JNa9GeI9yKin8MIolYkcaDKlE7+DkuYkriHN4iD3hXwleGLRVsZzWWFLNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784185574; c=relaxed/simple;
	bh=6k5sjxxkKdno/e4+u4/qBLktXlkadFOc+0pZyvorEdg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nHWfJ0RMf93RjqSKi8kPUzY8L+YWr2qm4ZG1RJeCTLjjrsmkf9y9zGX3Wf0rRFAvzIoycStBd8O1hT/HLkwIpA8y4v+at6hbem0EQc+oIy/jFlsZ4xIZT8H6tWdDp3Iw7Fknc5k7y6T3DTzPovYgo5iNJvq/IHj4CqGwxCQQCSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZL2VBd36; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZL2VBd36"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784185571; x=1815721571;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6k5sjxxkKdno/e4+u4/qBLktXlkadFOc+0pZyvorEdg=;
  b=ZL2VBd36TU2EwsKn71jAImWqJewOXAow4iV4IDEI/G9ZpQxs/YQIttAv
   y6nxQ8kqIhHlpX6XGHwGRpQLttCzA7REuSbU/Rfp1QELpOyHzBdxan5Ma
   2WYTiv3TRKrBVPWQXo36h1DRS2+cDyTOce07m7Njot12OclVzeZOS9Hu4
   jXlVhpOUrFxOhGOX18AT4lWl7xcY7zTiBE3qyvihHjTOrVBtLUyhQ1W7l
   EKLszAqH41JmsX57ETyRfvUQdD+rE35IVnM4JLJ2UwSlsA3drv1gatZdB
   pMak7RTNmvLiD3LYSkipAejQ9Ub6rmtPoCpWUH3k/FcXZNEKqFwGBOcKM
   w==;
X-CSE-ConnectionGUID: XIhvVEaQRr2zCKWzS48v+A==
X-CSE-MsgGUID: PWIUyrdOTwiO6voSck3tZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84929050"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="84929050"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 00:05:07 -0700
X-CSE-ConnectionGUID: 5vA4NHYJSWq9ZwNbkiVhpQ==
X-CSE-MsgGUID: Kw3qtCIhS5e56LvN/Ab2kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="250048368"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 00:05:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 00:05:06 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 16 Jul 2026 00:05:06 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.39) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 00:05:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Afvldw0xXjJpHhUzwOsUYU0BS1MpOaWms7Wdc0iyMCRmdb3zFDAqYkBAdy9o6w9C+U3kV5n3ASgwBma86s+69rGrcPLOYgf9aIe3xywVal9EaQOADIDQLw4cQ+lUDaGgaqQFH68kpwQ3MvTggLSxFVNAxGxWBwdWcHtokxlJ0/5SD8GXOxrgqbiIABgEc0aDJBhNs4uSEc/lxbEuQLHwRw1KUTkJazeF4eprukzU0W+31kqx/aBHanwYvcBVjjvQnwAowuSkTrbPvgAYCNFNZ3PNPoAaEChVqtpYN9/z7BP1kOMsHcBRzGcIem1rXZm3yaIwOSouCqcvau3vbhB98g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYJ5jylC+Gtx0RU1HsEHY/nvWqCnhurKLvbaBvD9M24=;
 b=zQd9u0g8tJl+VbuawxAH0PZ5BBMTvk/gkRbRhhLlUY0SOxCE7ZUrlXW2jh5lxQNmY0dFjp0PJSCz++fhQkX9vSdEw9+hVXq1UpDaCr8ruu//gVyglPCmXEMXhCnLiCblh6FCqvacvVYUkAA6gVBpxuJeLsZA0SYVnuwyGiMev8Yrq3yHTEzLWjeriDJ4tN0/BKtHyz518HOZtjcYbtsJFfnKxg1b6o0liBWpO2wrM6nxVwk3BDCU0VNowhqQ+BDZZaaCSOP24rWznAxT6Cf6D62HdmQd9VQLQIlum5DfoF1zuSU6SYGYBzTMiFaTJh8nPZtzlTPJccYKsXkGuD5QIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MN2PR11MB4679.namprd11.prod.outlook.com (2603:10b6:208:26b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 07:05:03 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 07:05:03 +0000
Date: Thu, 16 Jul 2026 15:04:56 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, <linux-doc@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [linux-next:master] [crypto]  2f204fe718:
 stress-ng.af-alg.ops_per_sec 113.7% improvement
Message-ID: <aliCmDna+pI1XQhD@xsang-OptiPlex-9020>
References: <202607152204.a0a3bf98-lkp@intel.com>
 <20260715162749.GA1794078@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260715162749.GA1794078@google.com>
X-ClientProxiedBy: TP0P295CA0058.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MN2PR11MB4679:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fe0097-499d-408e-374b-08dee3088ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: ZKaaEO6RTI8k9QXKGtfHWQXaXq+l1WBvCAAyW9JGg+No9oYg9b2PCUkw5ViCro5lWDIALEIQd+b5TyceP1JBFLPiwVTfF9fER7SiPGxJwt+WAyBF0qex8t52QA7GHyKb4oYh0xE3Ipw3dOyQWUmb6ki3FG/d7ETtkpgWYUOhOxCdC2yynMiHM6xc98xAaWwfi4yYtpv2pMvHaUPilc5mu7BXnbxcVggb/BCKDeTZyQEKkiaRsK2Ys+zw8q6ncNsTAy+0HLXFrkE1y2uFt9qhDWVIBPuQsz5IEq3aGW3Kc5PJ4WlWeiPvt7p5VEWOnVm4hykZRaPV5WP4BXUqEkbnjFesb0P+j/W60fwu15BfJZuM4+pRBzU5TekZJ1lpnFXBMabGWi8QbqfoDCNGAUUMvtfKk3Ap6jHhB7631c4HS66FwZbDrHkVGMH6oTDAwv4E/C4ZF4S3BDc/nApqe1hy+bp5RF3Rdb92yZHKDGcNnDxgGWq/K9mdtD+cWcpt5X3Mgw5hCiKOvf2mM8cf01J+aWlhjhyGPUuKbLhAy9iJ1sHEhmWoE44DWTu53tT3t8Bmv4R+nQNcbKlIx9gDqRiTtEDQ3YpMgRlLlJLPvSRS3qlmnID1SrzlnefD05p+f7WTtCUiJ30hRyhbDCJUx0BByqHJHVbVghMYspHb3b0XKBc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ZZ75thKsrO/GZW7vrEgTyDwXH1dZNdpFRzDQ6Qgp90fiSmTfqQKMMAC+lB?=
 =?iso-8859-1?Q?/REmazrbDVtaM1MpNjWDrUruXMrDq6R26Nvc6UoV3vvx87P4LIOeFVIQoM?=
 =?iso-8859-1?Q?4PFAhS7aW0SN97UFNAyxZNt18VhSPHe3hLBXwnPYncUOLoODWmO8xbDiJa?=
 =?iso-8859-1?Q?4tB0Y7DDRycx6mmGDENVVdX7pnVpHnXqLmphudye6ZBTHANawvYol4Jc1u?=
 =?iso-8859-1?Q?xCzjtXf7mLZ4Lzlu56KapMdCLQZig+4UADZq6Mt9aNiYdGdyu8d/+yg9ZX?=
 =?iso-8859-1?Q?uGh5Pzwe6Pt6eabyHCzI7IfzaBjw6E80xaDUxheR0VymQ/RyezuLPBczvH?=
 =?iso-8859-1?Q?JUkvf9OgONSV9VMsPmedrWTJm2vyyRZvsAB6gU+UD3kTptrkB0CbqNReXQ?=
 =?iso-8859-1?Q?RzAatpgUG3rWzvYjSSmblm80OaXnTPgDDBmArd2h/vXb9rND29piFAOnry?=
 =?iso-8859-1?Q?KOCX3iUegCjq80RL8B0KBM42WJ/Sffp2pkpTThwzeIreFncFh0h8J7c5yM?=
 =?iso-8859-1?Q?jqnWht3lfD8w7VO7LNCv2wLoelw9xFV3LJ80zEAhK33Dj7BLdOQCSSdrPy?=
 =?iso-8859-1?Q?hRb/98pc//J1mO1k1kqHJWzFe6uURpSNrPKfOSTyji05toqe5aKHaw20Od?=
 =?iso-8859-1?Q?KlX5K/5ltpUxFRVrVoO94gEe2Nei2rhE1lKFRDYPyltS1yLUgerkL4x4hm?=
 =?iso-8859-1?Q?vkGueNxf63e+zzIOL/c9XJFjbHZcsaVA0i9snXTKoO9JKZXJ7St/KIwh3M?=
 =?iso-8859-1?Q?xIHCgAB0oik6V9Zv8PlD0TLi64P6cBIEtj6ASKg7I6Y+vyAbQbh3HhnTrW?=
 =?iso-8859-1?Q?t+0tVlwYzCltAwZs1FTiWIVkLr3qNIcbR32ZLEmTtlNxr9H2AfK9z44ve+?=
 =?iso-8859-1?Q?O2qxQOP1PTPUw+ldTvZjMnGtPfZerIv/ADBit1Jtgdru4G7EGS0zF8a76A?=
 =?iso-8859-1?Q?Zpwhmxd68WT74/9vP08V6nECkaIeMGTo6OitxZsuwP3GGLygYhvdBcP8Ql?=
 =?iso-8859-1?Q?GNum9rYgCkrVPwqgXJgOAtQz2zXMXb2ERPHHaJ056YgXwAtlPKABWFHvOk?=
 =?iso-8859-1?Q?j/KLnmb0NVmodsqUBUi3oeP8bOVwsq0gZjiAVUbRSQbWzuJrvbf6bHioWJ?=
 =?iso-8859-1?Q?9eB0IHMJC8UWLuj+89zLTR56JZAKVszpSdq5tYbIUFW8D42o90gT7Ju0WL?=
 =?iso-8859-1?Q?UYEawjhN5fVb8Oh3ORfXKb7oR/FbALkOW7ROhHLrJa38x5LJ4n/G2eV+ci?=
 =?iso-8859-1?Q?sCMS4UcxntD6Akf5szcUOoSC1CTnLYShq283qAYCvII6SwdVAzBSdrGUdW?=
 =?iso-8859-1?Q?1EDAm+/CgcXo6xLozPyPgmBGNreVEtvpPnDm7R9goYH7+YEQ1pk6z6vxd9?=
 =?iso-8859-1?Q?6KH0FKvSdWUWJ2OBju9o+BooCmJroZLldJw9W5jYwVw+7FrdyOIlhPxHgn?=
 =?iso-8859-1?Q?Z8TfdhjZxk7REeDl5J+WlpZ7bSds6VwK5fnPspK0nDeCR7+W5iClbTrJFh?=
 =?iso-8859-1?Q?GpONAS3vXMDJovenX1DKZMXkZ3+V8gD7417dW9QTXGuNDXrqBiIouWhfsl?=
 =?iso-8859-1?Q?KeMBp8KeksxER6qr2RaxKdk5eW5B0Y1TV9gcLlYDumt5F0HLqyKLPX07gp?=
 =?iso-8859-1?Q?4m2Ahs7JzuJjh8i7q27ORUCU3TMXtKn6Tuv+P3LrseBX28OJMd0MI2kvj/?=
 =?iso-8859-1?Q?Oo3xBUrWrJRWvB0SndP3HkQCXfqWL4qfsy/7D5kXPQl0NcZ62HYrIAlUSu?=
 =?iso-8859-1?Q?pcQBZtMFKWgvUJx678GKdjp+DphISx+VpG8yjcRnIAFkiiJIalTKOw7OfS?=
 =?iso-8859-1?Q?2xE62fUvNg=3D=3D?=
X-Exchange-RoutingPolicyChecked: pVJFnSsx6xjbmv3AWhJFGB4HkSYyE/ow+d4U8peQSZ/8MUbQJUDcI9DHEtTx85rR90zS+QLJ9KFckmNi5UO/aZ4MY/XS3u/+AuOAkeynELmAobcRdpLXAg4p04T9LUZdZe8EhFjILtduu7bLX0h9MW2F1cN8QBdrejW0iQfWyDx0fljlSmorj70hm1/1AwghZkeKHdO06yE7Sn7s6FvX3xByuL4AdgtM8ZDbu24VTNV1XJetPx9VE47KBbCbtPFTo2of6Loiy/36Yvzyua2f1SkNOV9PF2NNC9lcVDBNV8081RwfehDLtFzmUzwQivjo4WxI5Ku6N4n21hRwR+fViw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fe0097-499d-408e-374b-08dee3088ed1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 07:05:03.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qx21Un1AgrOtnQ4faSaeAZwuIob9vCcqPOg6xMzVzkVTN5IAJezJ3nphzSnmE4Jo08gPpK6L+UfZq9g4g/Sgtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4679
X-OriginatorOrg: intel.com

hi, Eric,

On Wed, Jul 15, 2026 at 04:27:49PM +0000, Eric Biggers wrote:
> On Wed, Jul 15, 2026 at 11:00:46PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > 
> > we don't have enough knowledge to deeply analyze the impact of this commit
> > to stress-ng.af-alg performance tests.
> > 
> > along with the major kpi improvement:
> > 
> >    7756377          +113.7%   16578454        stress-ng.af-alg.ops_per_sec
> > 
> > we also noticed lots of misc tests seem have changes, e.g.
> > 
> >     697423            -9.5%     630908 ±  2%  stress-ng.af-alg.aes_cipher_ops/sec
> >     245103          -100.0%       0.00        stress-ng.af-alg.blowfish_cipher_ops/sec
> >     369646          -100.0%       0.00        stress-ng.af-alg.camellia_cipher_ops/sec
> >     162192          -100.0%       0.00        stress-ng.af-alg.cast5_cipher_ops/sec
> >     115113          -100.0%       0.00        stress-ng.af-alg.cast6_cipher_ops/sec
> > 
> > we don't know if these are expected behavior upon 2f204fe718.
> > so this report is just FYI what we observed in our tests.
> > 
> > 
> > 
> > kernel test robot noticed a 113.7% improvement of stress-ng.af-alg.ops_per_sec on:
> > 
> > 
> > commit: 2f204fe718f5bf519013cc2536ad7bb2cbb51661 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> That commit makes AF_ALG block access to some algorithms by default,
> overridable by a sysctl.  Apparently these performance tests
> misinterpret that as a change in performance.
> 
> It actually doesn't make much sense to do performance testing on AF_ALG
> at all anymore, given that AF_ALG is deprecated.  A limited form of
> AF_ALG is being left in place just for backwards compatibility with a
> few programs.  None of those programs use it in a performance-critical
> way, as far as I know.
> 
> To the extent that it's still done at all, it shouldn't test random
> algorithms like "ecb(cast5)" that are obsolete and unused.

thanks a lot for education! we will disable the test of AF_ALG.

> 
> - Eric
