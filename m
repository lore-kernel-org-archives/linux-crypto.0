Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B051CAAD;
	Thu, 20 Jun 2024 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898444; cv=fail; b=JXwuUsOHaiv2+KXcLzchknNaMdJmwD/JWeSrYgJaXmzTkV2bJ3l5UgYazaT/gxcTfROdAibgqgqhx3ASBlCbUvh5W+OuiHGav5FhD5bAO5hNL0mM1o7lvJheJGswaVKHeMVT+iZRod4XmwYtUiLGoxzga1WxGdXS6fz6gZA0ugk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898444; c=relaxed/simple;
	bh=ZkTLFaH/hPNH0qVxzx4YJXkEsRSkkh/QiDTNrr+Ll6k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nm2BmOW2CzN7dB+uWT0XrzzL4IRdiZFHPEdMzQRRuIRjlAd+I8JXXrnuUwchv83l9o2q3d/W5RzV44wH+rmvKax9dqQSnd0lZoZD7NCTrW0OaeKhXWN7sbUtxKzwwBy9Qql751w1rnM6Dxy/Wtln60be2hRhljKuEwHvEmNobdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTWmvNw/; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTWmvNw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718898442; x=1750434442;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZkTLFaH/hPNH0qVxzx4YJXkEsRSkkh/QiDTNrr+Ll6k=;
  b=aTWmvNw/0vTp4S5AppSoDJfWSkoBfOxHswMMQRDp2z2A0SyTAe+ikea1
   vXDTQ5rzY0zei7Vi+79M/TujlNLDZzLYg7rmVSffXlcrgS64QNLppumfo
   hn9pW47WNyDeysr7ivq+RiF270g0oNl7BFTpoA/XQHkVmSQndhQmPuthl
   oy5sJH+CgO0renoeGV/8mlpQ8pnyx5m7jJ7pFX3tiIBqka0k+C2vJZ/NO
   5bWpcHHfCzQth+v/ta0rX+cuvaQSQD5Qk8ipjHShD8ENLrDlVx18lRPR2
   sqpuKc+kmlqlxyFjqoVkoX5EahLs70Pckb0mjOVW5qzx93wFEApKrg4so
   Q==;
X-CSE-ConnectionGUID: okIAmoqrRDWLOqxWcW02Zg==
X-CSE-MsgGUID: Zunh9RHZRmqZEmDKtQsjQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="27294795"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="27294795"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 08:46:18 -0700
X-CSE-ConnectionGUID: Ec4rI0Q7RJ2jvIYvr6P40Q==
X-CSE-MsgGUID: T4WEMCntS/+gEX1WpoOLSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42376953"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 08:46:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 08:46:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 08:46:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 08:46:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 08:46:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XS7l4+ez6sr62ZHQGm8+qSah5XTnC9oHtQxPWQ4zgm4+xtbamu2BLLPzpbu5Q3JGVPX8W+uWTio02AsJbTVny7ORARs4DGvcT06m8OSJ3CdzVTDOMqQvNsnJskRLtHb/5I2X4Ig+e41RMBpTcb2rBuFQLP95qSEYZNj4IDbC6wDl/CDSz99qll6dSxt/Bs8EzslEI0zpwtN8oMVUSc+uR/6O1Z7kK5PiYDnf2mTxu/UQxk34o4uHJYvX9Y1poHoQgcf8rBLxVNhNwphz9ji69/O9NkWRzn5xPyFouPCnHTqkFAkYLE4E2hdw7t5L6R8RWH+JeXuopNVOxnciJc/eOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydvDJQND1JeYIz/GIEDJR7YB/CWD4B53BRATvH26dZA=;
 b=hkdl+YKnDXABLlbPNeCZs+7aJUmokEFQbWPmKD6ZSJpGSEOX3Vf7Yg0Ycvz67guXsddzVujiucDEYCZLKVvOPRh9u+G2iOeN6q+1iCFjs41mFc6t2UljxP3m9OASHPWEvd/FMf13suY37xh060zvHQ3OMeQOWVstj8OhJ2yh1SXH0Zoa5ZQA7nc+PHXvRN31Bwn8k6N/bKT1pz28ro85UzXmAmmTpt0PD8godLWMFHk1/pPFQYfLFOCKRWXiYRTaYSQ63EN4rrjYREtNi4lx7RuPQewuSFK9dbsbjsj1MnmLSfqd0GtUx5OzWCHzIRheIsm1p6m4KTv2pAe4QFm07g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 15:46:09 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 15:46:09 +0000
Date: Thu, 20 Jun 2024 16:46:02 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Jiwei Sun <sunjw10@outlook.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<damian.muszynski@intel.com>, <tero.kristo@linux.intel.com>,
	<siming.wan@intel.com>, <adam.guerin@intel.com>, <ciunas.bennett@intel.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sunjw10@lenovo.com>, <ahuang12@lenovo.com>
Subject: Re: [PATCH] crypto: qat - initialize user_input.lock for
 rate_limiting
Message-ID: <ZnROuu8K1mcUjz2O@gcabiddu-mobl.ger.corp.intel.com>
References: <SEZPR01MB45275F2F7A32D2DE4D6E2C9BA8C82@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SEZPR01MB45275F2F7A32D2DE4D6E2C9BA8C82@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR2P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:50::10) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: ff90ef59-1cd5-4095-1e06-08dc91401afb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SutnDA9U8ijK8lGpVCN2wFyV0ZeLfSFDFqT+m+ED575wAcx8Ja/RWaJet/T8?=
 =?us-ascii?Q?21w7qIMPyT5nHZugi3yZQoOoHvbWnfzT5lgxgH7YsAUotok8LZICUSgubLtd?=
 =?us-ascii?Q?r3VWC1SBjKEwK3lMrNHH2B+2X/9X0x0+jeFBWJCR5icxKdoxvVdrNmgaorZH?=
 =?us-ascii?Q?HenT1LF1MJiyK+XxYJzbPrjWJmdxfX3mznJtx7fnYj4cd146Jk5ul+QPVcrw?=
 =?us-ascii?Q?WBdKnZQHjSfqi55eRF7dK1PtI1AGx7pP4Y/XHIBn4CYUm6iqYXh57w8G8XFh?=
 =?us-ascii?Q?GYTbGk+2WTlMq6AsiIAxRuoBtDKc5s665J8e8Mjy090QMSoGuzQioQVKEJ0F?=
 =?us-ascii?Q?iz5cmbkMUygC6DouPFQm6G6slyUKDKdk3lJaft827zx6KZx/lviOB/lff+M7?=
 =?us-ascii?Q?Ac9JITcXfFim/VGTWNUmbHAstV5DAX8JVG/ewO1u8s/Rmh8dV0+HbdaKGfRg?=
 =?us-ascii?Q?cKd9No/CQlSaNbiwmW6mWb7tUWR1+RQWSkgFu4WWEIQlFZK/0tOLVv7wrCx5?=
 =?us-ascii?Q?M8q/TCEHxXuK9tUNOoEWxNL89EAs4YlZYMSz1vUNACSVWJ66hA3vFNj5/1XW?=
 =?us-ascii?Q?TJcnHncqKFX18rXv5twjRLbf/rQwqEzdmUTQoQFbSuEKLv5cJDwSzykpXhsM?=
 =?us-ascii?Q?QueJkozyPNii+xNukMssiNqhcOnQlFW7o1HNZb6cPZvC0ut0+hBnsyXfJFGj?=
 =?us-ascii?Q?i1qT4U2goHAYYu4YX9/SHCo0/Ez9oHxtckGKuVYZ9GpvCeIMt7VwG8b29SRA?=
 =?us-ascii?Q?LoquxM0FlwdiFz5/E55otrBaHCWrfxryPq7NbiUJN3ul4zllPK5nIRVOdH/G?=
 =?us-ascii?Q?pIZwM/9fSjY+YvpXx0rD8NZ03qq4ryuq7C52+ApAPKeRAJhnSZK/YuulUsCq?=
 =?us-ascii?Q?z4pkvN6Nj5LgaOLnm0JdX5VJ151tQJ/nw7FKOdBudPvtbmL8njH1QzRdS6nv?=
 =?us-ascii?Q?E2i9dU/2w7+//hrrRMWQjpdZkcsIYtXbv3L3gIO5FxBc0fULaGNH9wduPCBN?=
 =?us-ascii?Q?vgGzP8CJWBZRLuPV6k/IJo63XvbeRdtESiylIPtsQorPsQpuYnwa0lzuWvnQ?=
 =?us-ascii?Q?zt+mpGu/2ZaJTk6exA8wUCZRzrF+/LZUjunmgXzhJTm2sBfKRbfT+JMNH5dO?=
 =?us-ascii?Q?meDc2OM+NEM5BblutGKItjZ3iHYwa4Z/P5Ha0CozuoKHRjrXzFieZDdFMu1d?=
 =?us-ascii?Q?kVum9NBfxgDbD2NBbIcLh9K1OlZWKdKK13DeiGwoafFFc8YJ2IreNIc3QRbr?=
 =?us-ascii?Q?xBHsaYnt7i/bLECfCrhy6UHeB9zq3DrSchDRAyGuAVTrEmdR10X0xVLH1fk/?=
 =?us-ascii?Q?ghuwsB90lskvG2smKn2w7q8G?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jj21R+iWEmDaahZrzrfyZallDWdJRUbvwM52ZyeAptBAtbWzamkFckgvWKyn?=
 =?us-ascii?Q?kJElr8DrfwMkTRadDfxkycl2SEH4iI2ZMIiuh4mk14S7yeYAMJyz304rF8/b?=
 =?us-ascii?Q?JB6RohqZ/jJRyvhWnV/lMRsxyzQGprnxnMtgSYW/l+JifjRcPWzVSINJg4I8?=
 =?us-ascii?Q?DNbLMfQuif/ja0mP+yJinF6S3mSfAmX3D0/AtmAfH2LKkLyuF5/g/mZUR6ik?=
 =?us-ascii?Q?k1/H6nqhlgN03nMWk+v9NHaxfmqfoE33XdAFxpT5zjKWIWUvwLT6VVHieK0S?=
 =?us-ascii?Q?kBkRevVeDonj2qQiVIYFBPyJEq5BUx8VXLgPH5UybQhmUXB8ixpGPp+aosuf?=
 =?us-ascii?Q?/sFbEqD6vezZeTjKt5G5ZFCSEsW8If8xkrhVKSXIwSVBHK+RDbc0gS7645ut?=
 =?us-ascii?Q?H4oueJW7AHZBvQWeaTj8BDY6rdJEojmR79+vLz3FRJN/iwvPdgwthAwqo1N5?=
 =?us-ascii?Q?BQd7BzLaJi7bRwIvaV7zwLr51llPJ35foIJi2j8WQKEocBl3kUJzbMhxSHNQ?=
 =?us-ascii?Q?Unl8uZBw4s9gEjbBP0sV8XmfIfzXSWXiT32aCIw+Kl4ZG2q+qkHXva6QRl+U?=
 =?us-ascii?Q?4ktQOuidaWcZjMKv+aTd+Vz4w78RydGdRNhaVAHLGdiApkytVlba0EZ9xZhl?=
 =?us-ascii?Q?Bn7iebLhm857S2ry7afrDV0ffykSF+vUjT8yXQlxQphzpSk/pg/bmaCThphd?=
 =?us-ascii?Q?1VOsUd+ED1cUnkMVPDZrErB6hv6yOJmIs+VjDxxC2f/Pt+7rmY1EDmf3A72E?=
 =?us-ascii?Q?nSzX/ck8/k1TJca9XxtT20L118I5Je+SI2x/ITRYaX5kuTZi+TI7hiCdvHrB?=
 =?us-ascii?Q?kTKta0x53w5+ZuYw65siaVpb6763gR7k/vYijdHROcWpsviHWVf+ldnV4zE7?=
 =?us-ascii?Q?BJR4Nfyd48LyGR///BeuKQTIDNDYyWa6csrtIWPKL/osK3czE5mW3IuUk4uR?=
 =?us-ascii?Q?k1dOpE33QTcYAP/5hcAvuL1VmWDXMR7oCeenJE43cjiYGaYqw+4eaoqisSjH?=
 =?us-ascii?Q?q1dqdJv6yQOFKk5N52JLC6xulaFlHF+dfWLJAQixJ+jxeTNZFoqfamOEL+Lz?=
 =?us-ascii?Q?Wd7otwB3v34Hy5DqFbBWluze5q48T1ZzEfnLjkpyncu01qKq5+kBESk0NOV2?=
 =?us-ascii?Q?jo0wDErQgPU/aPaceb6/zsH8MKfBtwjsg2rN8SnGhBJ2Y3hQt6l2O4tONXJQ?=
 =?us-ascii?Q?Sa49kS7+KAbOUlBGCa52VKvl/4zNk1GajhrXfMK/whIdMyA7UGKUMMQfCT95?=
 =?us-ascii?Q?mnBbZWEwz9FJa87xqkbOfpePsub9/GArzqsZ9Wh6N3S8oqb132lF1Dh05WCP?=
 =?us-ascii?Q?mpT2zQ17+pVVWoGKUR4qz7Sjz2wgaqLIuwQBamRt2yzD/Up4fjMlcTWL9YVA?=
 =?us-ascii?Q?gv3wtdrFCUGZzXsNYo9vxnIGGDUMYW9VlBGYt0XJOlKwU1ATn7Bq/GIN8ieT?=
 =?us-ascii?Q?zzjvr5ds35ceXf2M0tX+MEPaSK5bAcuLkXqn4+Bici6wZe/YhbK/Zg8hl1XW?=
 =?us-ascii?Q?4KjV9XeogNTUZLEvSNuMYyYfHxR3lDE/AK4P7DszPeTYbxJtzwX21BYDckJd?=
 =?us-ascii?Q?LoBlgYn48pRxmAtNur/CtsoW2ETdRy4I9DuEw4KbVouI7VodcrNK5YTVVKcK?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff90ef59-1cd5-4095-1e06-08dc91401afb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 15:46:09.7529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ts/bWZYokvEozoki4VfQSwZUKKJl9AsBJZ8wZ2Lph2h5QSbxVrWHy99N1kSCBbbmt+ps3UdPvkYTpnMeQzg2cx7NmmADBmTXRxPUzfCDgxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8660
X-OriginatorOrg: intel.com

On Thu, Jun 20, 2024 at 04:51:10PM +0800, Jiwei Sun wrote:
> From: Jiwei Sun <sunjw10@lenovo.com>
> 
> If the following configurations are set,
> CONFIG_DEBUG_RWSEMS=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_RWSEM_SPIN_ON_OWNER=y
> 
> And run the following command,
> [root@localhost sys]# cat /sys/devices/pci0000:6b/0000:6b:00.0/qat_rl/pir
> The following warning log appears,
> 
> ------------[ cut here ]------------
> DEBUG_RWSEMS_WARN_ON(sem->magic != sem): count = 0x0, magic = 0x0, owner = 0x1, curr 0xff11000119288040, list not empty
> WARNING: CPU: 131 PID: 1254984 at kernel/locking/rwsem.c:1280 down_read+0x439/0x7f0
> CPU: 131 PID: 1254984 Comm: cat Kdump: loaded Tainted: G        W          6.10.0-rc4+ #86 b2ae60c8ceabed15f4fd2dba03c1c5a5f7f4040c
> Hardware name: Lenovo ThinkServer SR660 V3/SR660 V3, BIOS T8E166X-2.54 05/30/2024
> RIP: 0010:down_read+0x439/0x7f0
> Code: 44 24 10 80 3c 02 00 0f 85 05 03 00 00 48 8b 13 41 54 48 c7 c6 a0 3e 0e b4 48 c7 c7 e0 3e 0e b4 4c 8b 4c 24 08 e8 77 d5 40 fd <0f> 0b 59 e9 bc fc ff ff 0f 1f 44 00 00 e9 e2 fd ff ff 4c 8d 7b 08
> RSP: 0018:ffa0000035f67a78 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ff1100012b03a658 RCX: 0000000000000000
> RDX: 0000000080000002 RSI: 0000000000000008 RDI: 0000000000000001
> RBP: 1ff4000006becf53 R08: fff3fc0006becf17 R09: fff3fc0006becf17
> R10: fff3fc0006becf16 R11: ffa0000035f678b7 R12: ffffffffb40e3e60
> R13: ffffffffb627d1f4 R14: ff1100012b03a6d0 R15: ff1100012b03a6c8
> FS:  00007fa9ff9a6740(0000) GS:ff1100081e600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa9ff984000 CR3: 00000002118ae006 CR4: 0000000000771ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  pir_show+0x5d/0xe0 [intel_qat 9e297e249ab040329cf58b657b06f418fd5c5855]
>  dev_attr_show+0x3f/0xc0
>  sysfs_kf_seq_show+0x1ce/0x400
>  seq_read_iter+0x3fa/0x10b0
>  vfs_read+0x6f5/0xb20
>  ksys_read+0xe9/0x1d0
>  do_syscall_64+0x8a/0x170
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7fa9ff6fd9b2
> Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 1d 0c 00 e8 c5 fd 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
> RSP: 002b:00007ffc0616b968 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fa9ff6fd9b2
> RDX: 0000000000020000 RSI: 00007fa9ff985000 RDI: 0000000000000003
> RBP: 00007fa9ff985000 R08: 00007fa9ff984010 R09: 0000000000000000
> R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000022000
> R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
>  </TASK>
> irq event stamp: 0
> hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> hardirqs last disabled at (0): [<ffffffffb102c126>] copy_process+0x21e6/0x6e70
> softirqs last  enabled at (0): [<ffffffffb102c176>] copy_process+0x2236/0x6e70
> softirqs last disabled at (0): [<0000000000000000>] 0x0
> ---[ end trace 0000000000000000 ]---
> 
> The rate_limiting->user_input.lock rwsem lock is not initialized before
> use. Let's initialize it.
> 
> Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
> Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
> ---
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
