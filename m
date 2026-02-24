Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D432926056C;
	Tue, 24 Feb 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956713; cv=fail; b=AwoT0IYtzlGieuvvKL60JTL/NK8mPdmRg4Rg4mcY6vZfDCkq6XNcI6FhsN6LQme9LjaBOy8uHwGtU5FRJy8PGbALc1iuaSvg/F4hkI708Rcoihv+hQPQMt8cHAbyrh1ON7UBD6RAU79mNF3vRtYTb3oAwuDqIDSPHfGoprqIfoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956713; c=relaxed/simple;
	bh=klEBeLE1hJsv3Ewo6iAUXKREHUlKiQg43ElqJGPvRQQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DCW9c1Idn3y3FaVpHXBIEPKtaxyWHG76Olsww9IwPuMKhctWlV6x+jHUZKH7ePZaG8Isz1FbiuSz39Zo1669I/x5Ny4/oLNwrWnZFfWv6+bx4T5QNiH657WD7FR9Z8Wk/YkFZ/bWZ6LcFQCsGx9lg8SilzJuEw+XtoeV8cpkysk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V9cDrxRS; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V9cDrxRS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771956712; x=1803492712;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=klEBeLE1hJsv3Ewo6iAUXKREHUlKiQg43ElqJGPvRQQ=;
  b=V9cDrxRSA67WUTSSTKOuJSppx/+Y8PaTRwsSaTpbPmXHjOXPCFL1WqNL
   BQeOFV51Twwrb5AWbXs/YuZoLD3FeCk79pMa4aN+bXiAgN2S1+4VlkqLs
   0oAEhK2vRER+OAuJxaOgslZWvWXcq6hePGM/q3oc0F5YaYBkwC7jomJJ0
   K5RjnwFmcqhne7JkYWCtfPRVFCn5PltemIBI+oIYyswZEeWKg1GPlGB2K
   GYOZnwUMXL9PvyKw5bTZW4xSZ92iQJQUEuFTH6RcOOAKx6cX/Squgqbmy
   1UYaKK7i31ZhE1w2sBbanvB9sWa5A4BBFvZO+MafM5dQZLQrzL8YE+zAj
   Q==;
X-CSE-ConnectionGUID: oSFvb6sxSVWJ7Jjl4IidKw==
X-CSE-MsgGUID: MFh1bRwAT86pyp178uexOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="83603660"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="83603660"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:11:51 -0800
X-CSE-ConnectionGUID: RCu3Ea63Ria7Nhfvs+8xdw==
X-CSE-MsgGUID: Btlkfj7SReOy8F/HRQZvNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="214188553"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:11:51 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 10:11:50 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 10:11:50 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.52) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 10:11:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBf5914ghkUB14zZPls2SyK5idl00sgrddm95998iYZvKVS8HXfk9aCJQv7ulA3LFicxbVsV7qvXzlU8BPHEAKLZRLx/MYIi4hsfxyoNSq9DqJlVh/teGIbS8dpkNeaXO80tXGB5L0mCO/TyuDlbdmA/O0nnXZZQyrUcgWwBTiSwVT9g8Vtdrrn6HxQrRfVQjLULVkZYCiGlKfLM0kYxVaL74pIETdR+PNzC1BIDVFpEKLXyXWFxhcDA/ClV78PUHVWqVHeXgpw67vu/5n5Fvat2Pz6i0DBpu0UMmbrJiGfXmgHfmazmoobD+uffZctHoMUcrI4GxZfA+xyoLIZx/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8D+G67j2/zZyPZY2gsmE3IuqARUVJKD3E8BQYLuP7Fo=;
 b=VyWzmFwmXy7znM2fsNwFTwdj/GoY4whXlzG1Sr2/HgdQ2ZpBUoDhvB9qG432A0lLPd44SyzTmkZ16YOHASMAADzpXcPNLEi/oKyx1+QLxv+jpeb/WU1BIyDERp+/l7eTjk+affnnp2YSA8Y5bs1zOc5OiRGWskZ3ZRw7G2yCNkp2si0vbewaAsbXY1AOsGU5/M21zQvUrCP8t5iCYbYyHMqI57LuByd4kGHkfzt8u5fdr8RB1xzOW/gf18d9FycgFPRgi3qXoR0ZzPw/Gf79O6rVW+lHtVBDw/ZATeQUP9Y0WbkDU1Q7g2rcEUVbjsP3xOzPF7WE0n6ttczydda8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Tue, 24 Feb 2026 18:11:47 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:11:47 +0000
Date: Tue, 24 Feb 2026 18:11:37 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: <david.laight.linux@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Vijay Sundar Selvamani
	<vijay.sundar.selvamani@intel.com>, George Abraham P
	<george.abraham.p@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] crypto: qat - replace avg_array() with a better
 function
Message-ID: <aZ3p2dQFDNOgyQVz@gcabiddu-mobl.ger.corp.intel.com>
References: <20260206210940.315817-1-david.laight.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260206210940.315817-1-david.laight.linux@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB9PR02CA0024.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9::29) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: 1608a5d9-1bb2-439d-9f0c-08de73d02c9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nGFIoOYqwDK2Ej5n6WjfCqqSELOgGQVGVMBNY0/b9W687+1NK3/mFojCdYYZ?=
 =?us-ascii?Q?A3mQyrgfcwqGXK/WuimFqYF6d5HFQPvVrQFwox3sSbtqpc1O1zBdCnE7A1Oq?=
 =?us-ascii?Q?nLjMl4KmTKP4PnoUuUKoI1cw6+thW8B0951t8OFnypy7gIWSi2v22Iu8cYaw?=
 =?us-ascii?Q?YDLrg1c/2aetNu1YBch1Qw2VQSz5KMetdfkjdGQu0+n767XuVKJ5vxU0rvzD?=
 =?us-ascii?Q?LNs4ay7cHDsAmDOS7tLKY1LIVT+7U1KtadWxF3ckvz82kAaM1gPbmdPAyTc+?=
 =?us-ascii?Q?ZzHVZqtGbXO588yPONgL+v5N5p4z4BprZFxmH+y7YG0YK5vOld4QR0hOfFU8?=
 =?us-ascii?Q?QZKunJy0B/cK+mqkiND8/pxnt5pMIiK2LqyQEiOnEkUcrfbNjy8yPY3zgpfY?=
 =?us-ascii?Q?UJLeGklGT2oPYT94JzwqfjE9jtOiaY9PB3PMuQAF1Qe/8hl8xv1Yue3/N7GS?=
 =?us-ascii?Q?S+UzGt5EV3jLkEGM5WD44AB1dA9HbR3Kt01u1Tfe/GxGn2NTjTi0bdnKdbRj?=
 =?us-ascii?Q?K6yrB0nhPjuFlcPwj/UVv2ICao5+jEuqn8ENG0CP/fKr8PXBCRtqyUbQsxZw?=
 =?us-ascii?Q?xTn1x0muo5JjChgzjY8sxHfoteschKmd50lGWEO5Bma26Cyjovk12Bt0knaX?=
 =?us-ascii?Q?pX8PaQTJbNJAaxDas/SKP7FQ0zZ+AE3EU/MHFPpYzx72sZLI8NPp3qtjcyHw?=
 =?us-ascii?Q?A57fKfk4M42F5gH1FeY/RWeG0Rh2qGQKBGcRJSCRaB37F3PNtM0tJ3+a4Jph?=
 =?us-ascii?Q?1HlZ74Z7/ZcCQiHG1/CTJnyDCqjEN7MMOAfOcy+C9x1fFSJhIY0+K9oPj/sn?=
 =?us-ascii?Q?h7HBOLVo8oBB4BOs7L7qRWCOHbMgvLYcotldTbmj5BUS9OIdu6XcQTiSVx+g?=
 =?us-ascii?Q?EWXT9kcOGG/57taeqfWTVoTSX0zkiMmUzJRGVmXATchqfT00+whVP2MRWe3/?=
 =?us-ascii?Q?e91luiLTrvPaa06sZ887bf/LsVpsHbsh1FvdSmZ1hWFSbLtADlL91TC11hsO?=
 =?us-ascii?Q?XYoQpYjmzEHzy7AzpUXdktgCIZO2Ln/sN+k5R7yCNm+jWijG1KZFvk8OQykH?=
 =?us-ascii?Q?pHxUC324d9tEh0yVpYl4LW0Fqr4c56cBlW8bnT2b8ctRW4UEM5BOF9vdPW0T?=
 =?us-ascii?Q?1GmWtlgu06wbYbonhDlmUQCvwxiu2B7cEUJ4WpDZfy3qH10zMn2vkaesrF27?=
 =?us-ascii?Q?ywZLFqCkS8rnnoH2swQ+cx4kYoB6U0s7eTeuKMTEP4bSwoQo2JWzsq/JTEXG?=
 =?us-ascii?Q?jTJTC38QsBAKR+3xefvrkUApPCEq80+a55mPbbjPIQaWDrIMbH/PsnWVhVOg?=
 =?us-ascii?Q?ssx3bmEP0c8K+e6Luq1m1nMa5VgTON6/fBE7NyZZ/jDbyDmn+HDeB24NgVhP?=
 =?us-ascii?Q?k5191lYUztCrHfITT6PHv2q/sPdlJobCJbL66QqDrNJRz5w/wsZSxtjThfsd?=
 =?us-ascii?Q?Is34F6Oi7vdUWEFUNvr4962HhQGGyArkm3A9iRw6D4G7onDJcg5V9W8b9Go4?=
 =?us-ascii?Q?nVPHebFKAZJLj4Ksqqkd1bAtyFNOA5L4gRYswqbzPSaRIUbdh70hY4NiK+7y?=
 =?us-ascii?Q?CGd6a/5gJSFlwF+FOlY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l9mhEdI2gzt3Atskd4osYpe+ctzv4lhigWE5S8aXecP2GjuVuPJ0d8LlGVrN?=
 =?us-ascii?Q?Habv3a2bF2QjVAyJM0nl+5su3up+Z3nmnDfQgE0IURmPo/42BiKnhOOaP0rE?=
 =?us-ascii?Q?1KFqktmoGtTZ3WrWU4A4gZpOWx/iGKF6oD6Fc34xArLvGD1Bk61BsdHEtMLw?=
 =?us-ascii?Q?jk9mtYh/INL0XODqj08vHLOeRvBAKBiYgmvJJscRhN1uIIlKP6qwDCkjVdlv?=
 =?us-ascii?Q?ismgM7WTRGlpGp1ItHkQvynR8Vh/FLIjzaPlGmIEUc9tblQggTIMjdx/MgGP?=
 =?us-ascii?Q?llrqscsqkz+gzIrukR41uK8Y+IVl3ivrXqKeT6mZDbp3O0OrSkl2UTM3xuo9?=
 =?us-ascii?Q?oGYAyX/hAB8whHXxyp5AjERhuDrCWSv5IdKbTk10Q28X79R5tz0jscd/1AzQ?=
 =?us-ascii?Q?V4TptazZ9/Q6jSu+9t6X7qA6nyIei/FlIkR36PsXFy0VUnsKquewNw4nHAMV?=
 =?us-ascii?Q?oQf7Uf6chh+B50rUYDNxMYZAtXHSIaFmpzji2HscAFLSavbWk50uOVc+COKt?=
 =?us-ascii?Q?ypx3/5F9S8Vc/SbMPI3oavBuOIqht3BGWLcy6gVvUzVrQARl9fQbVlAqgRrZ?=
 =?us-ascii?Q?uQfCfbVK0tG1EpHKoU+TtHiysCQOpg75eD2oEUvH6c7PwVJEILQGCvHezCuB?=
 =?us-ascii?Q?+3+KL4OKLLvDhychq8Pm5X12hoHbJhIBz9nE4SQYB+nw8dDX9zk1I9xtu1xT?=
 =?us-ascii?Q?qoBAokGkL0qQTacCcgCEM/TA5G4Df8phjjqLpN2BiFRyD+1hXjZIC+JTWImc?=
 =?us-ascii?Q?EZ0TEVGCDeREVOQdoAYXRedrJ4kLkNLUu/QbYZQYEp9wKrh41yfF9saiokU6?=
 =?us-ascii?Q?mJcb+hzwoa5/sjfBGvBxWOCpJnnNjdtzeXA8kp6eGMP7hBdvAht204oufEgH?=
 =?us-ascii?Q?0NJy9aVMDvNH5DZEV47CYKt6R9otDrCqPO9cJEvV1Rs7snwqDx9YHV6qSpk1?=
 =?us-ascii?Q?KYM1IfkOYYvBR7e1dfELqWbGaiBFJ7RbsKngFV1z6/d8fqbV9ACClemzXMWj?=
 =?us-ascii?Q?NtKhXgL3hsyzVkMn0cZSiEXwAfeNzunSEM28jm8wNDlEzEzTLVxRpICjruiE?=
 =?us-ascii?Q?2EsLGFpBcHMo08dhtrEWP21M4lqJQt0w7cIk9eXTqXBmze0ojlf0wTSvLvxg?=
 =?us-ascii?Q?jVr1KNiKpvWWJELjxYH33j+9AB/ZWePmTdasMnWBTC6Qn8gsI/XZTgVCTCKp?=
 =?us-ascii?Q?XFNLsiEAGvTQiELA9VwAvt5SRjlL75CNjSBJVcZER+BONHaqKxL/lWSsp3rD?=
 =?us-ascii?Q?GHc7XMdn+6L7Kt5IDxDltvE6E2y53H2wMciT9SZNtqmj0XWWXwNhiQYIbX0u?=
 =?us-ascii?Q?hTScw8xY8sYxYwWpd+5/k4qJIxn1f6t3Bkg/78OQ35R/ZkNRzXywBmd98mJx?=
 =?us-ascii?Q?GOir30v9C6roNYkEn94x29/b511N6CfjEUm7L7lcVhWS6mb/gJtEXLuyaTUh?=
 =?us-ascii?Q?OGwxmV0ObDiKdX3XZdVGGNT6QYvmS16T4SaqfjU2jqyWNubaoRphIzd7ynLp?=
 =?us-ascii?Q?GjoaHdJ0oEzJuyJJ+jZeSVf9bQJGoe6Pgz3tR24HGW+Ek+tlLpvgG2MRZVd/?=
 =?us-ascii?Q?UQTqdjvHjbZ1wx8CKUt+7M4i42kZMvNCVHn9cfxrV2X/OllA0YgFSHIS/LNX?=
 =?us-ascii?Q?stWYsP+/GC/4S9oNd730NOG6Xf6DjEd6r8/hnpAX932goXGyn0a2Umxlu6Vd?=
 =?us-ascii?Q?gJGjegrRrTBsoN51HLR1A47lH80jVZ0Qu99O8bq6+3epMzW85BY+Y0RW2Q4W?=
 =?us-ascii?Q?C1i1qRtBTq81mH8osFq8dvzrKT08ciE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1608a5d9-1bb2-439d-9f0c-08de73d02c9e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:11:47.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHjZEw+A5KFucXiBybyNbmlKSBSv003GCa0tExDu5JhNg7wdcbvAORCSGiiPL70eCJTi3jTLQlt8nN8Z5E7mcdXS5hkmjJSNkr6aBa4P/80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
X-OriginatorOrg: intel.com

On Fri, Feb 06, 2026 at 09:09:40PM +0000, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> avg_array() is defined as a 'type independant' #define.
> However the algorithm is only valid for unsigned types and the
> implementation is only valid for u64.
> All the callers pass temporary kmalloc() allocated arrays of u64.
> 
> Replace with a function that takes a pointer to a u64 array.
> 
> Change the implementation to sum the low and high 32bits of each
> value separately and then compute the average.
Thanks David, this is a great optimization.

I also reviewed the algorithm and confirmed it is functionally equivalent
to the previous version. I tested it on a platform with QAT and it
behaves as expected.

Some minor comments below.

> This will be massively faster as it does two divisions rather than
> one for each element.
NIT: probably not `massively faster` as the maximum value for len in the
current implementation is 4.

> Also removes some very pointless __unqual_scalar_typeof().
> They could be 'auto _x = 0 ? x + 0 : 0;' even if the types weren't fixed.
> 
> Only compile tested.
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
>  .../intel/qat/qat_common/adf_tl_debugfs.c     | 38 ++++++++-----------
>  1 file changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> index b81f70576683..a084437a2631 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> @@ -77,32 +77,24 @@ static int tl_collect_values_u64(struct adf_telemetry *telemetry,
>   * @len: Number of elements.
>   *
>   * This algorithm computes average of an array without running into overflow.
> + * (Provided len is less than 2 << 31.)
Should this be 2^31 or 1 << 31?
Alternatively: `Provided len fits in u32`?

>   *
>   * Return: average of values.
>   */
> -#define avg_array(array, len) (				\
> -{							\
> -	typeof(&(array)[0]) _array = (array);		\
> -	__unqual_scalar_typeof(_array[0]) _x = 0;	\
> -	__unqual_scalar_typeof(_array[0]) _y = 0;	\
> -	__unqual_scalar_typeof(_array[0]) _a, _b;	\
> -	typeof(len) _len = (len);			\
> -	size_t _i;					\
> -							\
> -	for (_i = 0; _i < _len; _i++) {			\
> -		_a = _array[_i];			\
> -		_b = do_div(_a, _len);			\
> -		_x += _a;				\
> -		if (_y >= _len - _b) {			\
> -			_x++;				\
> -			_y -= _len - _b;		\
> -		} else {				\
> -			_y += _b;			\
> -		}					\
> -	}						\
> -	do_div(_y, _len);				\
> -	(_x + _y);					\
> -})
> +static u64 avg_array(const u64 *array, size_t len)
Shall size_t len be u32 len?

> +{
> +	u64 sum_hi = 0, sum_lo = 0;
> +	size_t i;
> +
> +	for (i = 0; i < len; i++) {
> +		sum_hi += array[i] >> 32;
> +		sum_lo += (u32)array[i];
> +	}
> +
> +	sum_lo += (u64)do_div(sum_hi, len) << 32;
> +
> +	return (sum_hi << 32) + div_u64(sum_lo, len);
> +}
>  
>  /* Calculation function for simple counter. */
>  static int tl_calc_count(struct adf_telemetry *telemetry,

Thanks,

-- 
Giovanni
