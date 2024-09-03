Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D91B2139D4
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 08:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352849; cv=fail; b=J5N4bQvTwAhFjor9R1yfn0YFaDwtrLPgTrAVwpGgpBWO8H/7GXd2y22fqrOLWWpEDQkobWvB8eNShnUFSq9B+Nc3TP2GaTTl2KeOl5/2QONxagyKoQVbvcJt0llHd6B3zFJj2m0O78Nccp4jVcZrPJ6WSupGqbtiJZyqbF4J9yE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352849; c=relaxed/simple;
	bh=acBOEAlnxE43AmBjEzYe0blLVbH06TLxl1ocPgo81oE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z4jDRUNsoq6xOLrvi6Gu5avhC9+4jSB1IRtR4jwGETNfSOj/wpVPbgKM65gzb0vTQEpSKuekNwONgdmXX1GHee1/VKcRJZ2OiM0LXlcjsvp2ifoIHFXxu7xju2i4ikfuNu4xqkpL9ntdpWdez8h1SDE+t9OIANM2Im89shXSpko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJHZRDSG; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJHZRDSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725352847; x=1756888847;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=acBOEAlnxE43AmBjEzYe0blLVbH06TLxl1ocPgo81oE=;
  b=jJHZRDSG6IzCB6+SYzWARI6kITSDya05R51m24AUMb3g9gQuZ4jtZDI4
   vM6hwqJAj1zAo262uz9uPGzVgivoE18AxkVYZP4RcBjf/rh89hO4W83Rs
   1zqvci28Xm+9VXsM2rIU0/JuB+REUu4Dh7IFajzOe7KMwZZ7WnAhchBcg
   UMWe8GclM9bre/4eVwh4Khne+cFmxQRAEoFzgy/oGQRevyh90N8FG5Z4S
   0BXwg9HlpAY5jJZLtnTp4ULOf+F6yg8Umr7hXQZQtkSMVkyr6Mky4z131
   6MiY5P7eVAlE2ufMf2n/qoSXG7/q+FRVOanvfifroSA6gsdcoep5Urv07
   A==;
X-CSE-ConnectionGUID: otl09wQaSd+gZpDF+AiWRw==
X-CSE-MsgGUID: xA3oGGfySF6uug/WBzZHGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24120069"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="24120069"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 01:40:47 -0700
X-CSE-ConnectionGUID: og5PRTzxQZGKBPcwJxY8JQ==
X-CSE-MsgGUID: U67xBJxmR6yprPTI+/LiUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="69213477"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 01:40:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 01:40:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 01:40:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 01:40:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 01:40:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouUYWkGpMui731iDRSaff2TG6ZipYRXA/frg2LQevxuSpJm+eiNDYefBCO9udVITQOOrXZypMAgXJAWF3LA+M7KQ4rQvJPG4/e97Shf1XUZohyXJacgF0dpmSQYEM0b9wGNXeJwMK8hW2T5/m/wuHEWVundcaS0Ozxq3Xi0X1+djdhyq+Ca7zzwQdYyOf2pas8eaKHrt3qt2vkVaFuA3ri7NwCwjZfUd3aQdSg0clznaHAqzSCHz6oo5qTDpt6jPNIegI+sMNwvl7QsCyP/RvSNiOpnW6hvIXyXlcC2g0qwyhm8qSOIxvc3kkvFJHIvqRGf70mKTaW5UJ9t/6cPbeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyCndPPhxQLwhCvu0P8HtZK/gsWFUQ/UZgaNNfVNOlg=;
 b=K1OSiZsfbTatBzIEuR/N+oortTzjdpMxBoK1Ik1+KHav9Z1aqR9ZN+keRdymXJwH2tE6AVIS/OhPuX4mn7X3F9wV7Zq0uEbQ/Hz+zhIOH6HEz4vtx6UXUBkFsWXjacm2EejjJNR2kqSWxuzYl+EHGkIXsYUC4a7SRp5z3iqecHJoVAkcAZSlC0uryd7IKPbz16Qy+m+obx8Mg8nMhLMymCMZfpOf43YNC3AcKl6BF7YKIyAdM83YwU2EklV9DbniYh31fLO57TeElTxqk1o9kyhxV4RIz9hoF9MK1yL7gjY7Cf8FXYK5TJq8r9nB7RqHMMJ71ooZS9CpZtCDosm4QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BN9PR11MB5273.namprd11.prod.outlook.com (2603:10b6:408:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 08:40:43 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7918.020; Tue, 3 Sep 2024
 08:40:43 +0000
Date: Tue, 3 Sep 2024 16:40:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	<ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: Re: [PATCH] crypto: algboss - Pass instance creation error up
Message-ID: <202409031626.c7cf85de-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZtQgoIhvZUvpI8K4@gondor.apana.org.au>
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BN9PR11MB5273:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ff081c-1db0-41c7-8a43-08dccbf418f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5sTT52zgaOAWfNC3OkOBgCBbkMgBzIvjWA2Aw9LmuQQHUPwV7xrFvnF2aKBP?=
 =?us-ascii?Q?hB1Fgj0EI/E62v4M+FDWbva1zfA81sJp1yLhPgsJDtxlVbYb69afoiTcByYk?=
 =?us-ascii?Q?ARM7uYmJDbJQUMgUrNfv4VnNwrpQhFaE7wgcVh1cTIb9QaOoniQG1wQuxCjF?=
 =?us-ascii?Q?r36SdJMFzo9PbpwkVoMtEqJ7DhVzwIaY1mCd3tggomfPe2f3wc7/GgYf+5c6?=
 =?us-ascii?Q?NJCRILzwWaBv5kjUmdscb3YaEB5Lnj2VKBNekW+Za/zdQJvY6UxjtJeWxqVq?=
 =?us-ascii?Q?kFMmD9TCNh+om9JRnFvZE4X24D/Jt+68gJqKsmHmMdro6slYPiNE7sUrbj6A?=
 =?us-ascii?Q?4ao+J2kcryYDTW9brRbPJnscRwV1jXG34Ji5iivdUy7oD3RFWuNlaUhfL3Ai?=
 =?us-ascii?Q?19fHq2f07K+1WVDuaUICZjU1bd3LLkAMz3wLrRkB6zt27pkSGwLQqPxUE1ru?=
 =?us-ascii?Q?gHu2Fzd9q3sZFHYCR0oFFnWKQOsxfippRN4+oLGt9XnFdAjh+8CzDNmg2Vfr?=
 =?us-ascii?Q?hTmjl601rk9EyNuOUCJJGqmAbxsjgeDBC8qSg9E/UR0z+wDic9iqe8tIGa5Z?=
 =?us-ascii?Q?fJlkDoN+9PL+J+HO+rz2E+3qKUV4A0xr9oTiBqtVxaj0GEmDEne23UCzvnrj?=
 =?us-ascii?Q?nc/xfJZAwB7jTqeXXv8jPoR9WZvBn7kMWGzVOf8jLZBPO5rA2MgLf+B6KsU0?=
 =?us-ascii?Q?4ln23MtQ8U05laYuEY1VIwrdSJ5529Tp7qqDAIpo6CbdcO55DT9b1btUx9f1?=
 =?us-ascii?Q?yFACl5rQvcl1IqPaG9fYIrivuyVyRxuDKeGIlAfOHXPYYO/tPeC7C7OODgiW?=
 =?us-ascii?Q?VG9DHhH2ytpTHkklyAue/gojnd9S9TEwEk4aY94d9Vx77U5BWkKoe35b71cw?=
 =?us-ascii?Q?M2ckH84nfxU2qsDFf0kv+U/N08t/LVSEV+1oPdH1Ub98ih7TgT7zWUlMYzlU?=
 =?us-ascii?Q?r6rJaCEqCOVEaPESDJ2pmRb8yjk0wckQwDgoLywLUm2oZ9EN/Izwr8T4NsrN?=
 =?us-ascii?Q?SSkEvuXE1xWnQjRO2G9L0RALv7auajOIiHLqmt0dfLGfQ5P3PnHQOcLmYbCR?=
 =?us-ascii?Q?hMl5sjIeELaQnk04mOk3B4mjwgyNuXswDXX8tTSci2JrLK43GMUeGeprRbzO?=
 =?us-ascii?Q?8OajPgVDGGOLn6qdi/dcUPU7RGJ3vxMPAyfJcECyvYKz+/fPCSlWeSvy/4HZ?=
 =?us-ascii?Q?5klSuHeoBtKPNspExaydeKH3xeTvOElMgGwmOBi4hY/JNPE6OVt+twmwftow?=
 =?us-ascii?Q?Bn3ukozt5Zpnv879cP+tdjvGvmnHx32IH2dvuZdBUgiZaiUSzPLD0QlMq9M7?=
 =?us-ascii?Q?isbU2kD4xxTxsacEgQwBxe3r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y2FfFebybI4+L0v73q0bpCPPoQr9mslucYFUOujS4gW4PoKncKRJZnyoZd0Q?=
 =?us-ascii?Q?/+BMsJ/c5nma14DPNdRj9n6/rvkcErhvM4Qo6ayTsaEtnj1bLjDAzPCXYcnT?=
 =?us-ascii?Q?4DTf32CByqMe2/2e0JXGuOjXKYiY98q4hK0Zumeg8uMhs+5aRenx/ZMLioq7?=
 =?us-ascii?Q?xcTI5ZlTVsNPPWMXtb79oB5aXohKBV8T70de7aC1wPgRgQJjo4yGrc1ik0s6?=
 =?us-ascii?Q?t8u9boY27Lncu1EIkvk7hrn6lN6X1CR9m26CBnRc2Mv7nrTaDxNyEKaoA2u+?=
 =?us-ascii?Q?ttNSdF7kk0ClgIe/Dao8F/CSEuk8pPx1xhLVTyHIe+EGajBIOLP0I4IX0XMm?=
 =?us-ascii?Q?NDc39BdVstIHBmNTVb8csu04v+1D/nVGzOSqc/zWdmA17x2PoO/BJ+hRux0r?=
 =?us-ascii?Q?Js20jAVUwx7ADqbzQAUFkBeSyA5ks62EByDLawNNPx9CxEluld7v5AWC7qv9?=
 =?us-ascii?Q?FOO11gvIr9I2GJf3kBlpyu87OJXvT2MJroe38/tGTmfLikeSdgo3yWzTplOE?=
 =?us-ascii?Q?kByXwJc3OR7yZbc3ggcCRE//zDsOEUsmu1XEdpppECSxroYo8+9ODsuGAmcs?=
 =?us-ascii?Q?HOQxUpBEI4sA83F9+rLdNIcY/0gY1svmFM3P+ubuLgmKcggrHdR2DcMRoqU/?=
 =?us-ascii?Q?B+11xVp/+VOWzLfT6iDLL8FyCc1JtzFdGDKkOfR28orkRwJZR3BQuVBSfxP7?=
 =?us-ascii?Q?eUB8BQDkPKi1wvJQgl5esv8zOyCS20dlvilDpQeaCngNbGgibKqY/21u9Joa?=
 =?us-ascii?Q?uggTD9T+V9wbCVf0Q2qnadaSHO9E0+NimZxgPQaXYlI8lVFHGuh0ZcvXilRV?=
 =?us-ascii?Q?xO97MMwMhwENArspBWjT6aSaMOOIT7cci0NWAen7djx+nFf5O1q0x5GYdeBX?=
 =?us-ascii?Q?6JSAMJrAzD6ujIQ/zRHPUWgHjywzedHjKaCsT/rdabFJr2NWvYcxu8kcmWOO?=
 =?us-ascii?Q?UpLJAbSBofp4KCUtPAh/PjBq6ZPY+ycmf5+DGNVLZHAMPU1F462uFl7Z2UGi?=
 =?us-ascii?Q?j77C1tIsgL0fb4uHe92hnHGQlL1+Dl8NEO1iKZfDfD4MED21G3meaqTsNJn6?=
 =?us-ascii?Q?Id60Nb1Pa2kmB0kaCkXTGL7GZwYA177Ju+tPj1A8nNqGbupcB1cnHI8ZO0TE?=
 =?us-ascii?Q?FUuBUVrMbjFwYWKFQlf2tz3zVtDAxbpHsBcVjLGz7YJdYCmbULJGGSHZWJT5?=
 =?us-ascii?Q?woy4kyElVI5YajmDJ+YAkIpBRLPFS7IabQvITIe3jf+0yg+c4yUdBBZPMIS3?=
 =?us-ascii?Q?7HX8CG0rWhwKQWSsQrL4laMSQSHcPYFYfm4kkyJzGhEMxx3BHEBPWbzRfEPv?=
 =?us-ascii?Q?qskYxAhNEvNOGEutIOGo9TCQrvGFLjY8RNewKS5K3ZLptLhNxzaY7OPcGklM?=
 =?us-ascii?Q?iol8c7tCrjtfvgEiO2AhQs8+7keY8ZcRluykSo0B0t4DV/E2ZYRemA0PYmyw?=
 =?us-ascii?Q?f+74z8Mq0vytIcfIf0uP0q9jhk4iFmLH1we28UBGfiJInlPa2Uy58uYBMJqS?=
 =?us-ascii?Q?j5H6sPShJRh9wYWHzjxfGcur4VL1BzwCA9t26hD9P6O5zOtTEaAYVlplN8Pl?=
 =?us-ascii?Q?AH2k3jUt5+inmZG/MxBrDIcP5hM8bSJaxhhQWBnFbbhKoENUtmcucowmx8pK?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ff081c-1db0-41c7-8a43-08dccbf418f2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:40:43.1728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxffTAu6KkQ00vUxS+xytJVFKBI9Kc/Weq/stvDjyI0uS7saIAzdhgmhzfb4osYadTFrB0tKz8WiBhE/AucKtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5273
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "ltp.cve-2017-17806.fail" on:

commit: 577bf9f41d619f74d0498abb0d9467d1bbc4e115 ("[PATCH] crypto: algboss - Pass instance creation error up")
url: https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-algboss-Pass-instance-creation-error-up/20240901-160826
base: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link: https://lore.kernel.org/all/ZtQgoIhvZUvpI8K4@gondor.apana.org.au/
patch subject: [PATCH] crypto: algboss - Pass instance creation error up

in testcase: ltp
version: ltp-x86_64-14c1f76-1_20240831
with following parameters:

	test: cve-07/cve-2017-17806



compiler: gcc-12
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (Ivy Bridge) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409031626.c7cf85de-oliver.sang@intel.com


Running tests.......
<<<test_start>>>
tag=cve-2017-17806 stime=1725329707
cmdline="af_alg01"
contacts=""
analysis=exit
<<<test_output>>>
tst_test.c:1809: TINFO: LTP version: 20240524-209-g9a6f3896f
tst_test.c:1813: TINFO: Tested kernel: 6.11.0-rc1-00074-g577bf9f41d61 #1 SMP PREEMPT_DYNAMIC Tue Sep  3 00:19:02 CST 2024 x86_64
tst_test.c:1652: TINFO: Timeout per run is 0h 00m 30s
af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
tst_af_alg.c:46: TBROK: unexpected error binding AF_ALG socket to hash algorithm 'hmac(hmac(md5))': EINVAL (22)

HINT: You _MAY_ be missing kernel fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af3ff8045bbf

HINT: You _MAY_ be vulnerable to CVE(s):

https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17806

HINT: You _MAY_ be missing kernel fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af3ff8045bbf

HINT: You _MAY_ be vulnerable to CVE(s):

https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17806

Summary:
passed   0
failed   1
broken   1
skipped  0
warnings 0
incrementing stop
<<<execution_status>>>
initiation_status="ok"
duration=0 termination_type=exited termination_id=3 corefile=no
cutime=0 cstime=1
<<<test_end>>>
INFO: ltp-pan reported some tests FAIL
LTP Version: 20240524-209-g9a6f3896f

       ###############################################################

            Done executing testcases.
            LTP Version:  20240524-209-g9a6f3896f
       ###############################################################



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240903/202409031626.c7cf85de-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

