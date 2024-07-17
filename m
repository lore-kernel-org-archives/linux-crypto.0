Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A27217FAA9
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216780; cv=fail; b=fvLh+MEWTa2zuFQ/KojqNx9T4vV5XdYj1kqKsZwg8zWWEELwgkTTi0sg4PMcSshdV2wf+FAt9r5S1lbq8K96N9TQB8lgtW/CGx6UZCPnTiHfWd+kYjB+AWLTo8UWNIVobOi8cchqsUEXnXPdlQuKDs9hTZeVFuzzEHBUWtc05D0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216780; c=relaxed/simple;
	bh=ada0s/ERN8UgB4Thja2S37JLaMbFxENjWIwX3HAdK3M=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KtJ8EeAz4JbQnuEVlhDBXKly9vjutwZzTl7JvTuXZ1z8MPQPJS+vBMr88W+jqypJIwLLcT2l14cUUXIPisjGTEZ4UJwR3nSbcGUd3MGPx9qyyca/6SgwoRdEoQV2AhYEeC9kEkUSd0Dg7BjFvBQa9fq41m7nv68lLBWu/I2uYuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOhPNEYT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOhPNEYT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216778; x=1752752778;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ada0s/ERN8UgB4Thja2S37JLaMbFxENjWIwX3HAdK3M=;
  b=HOhPNEYTwWdNX3DYoia9HD1hqh1bsj92BdP3iRs2y/WnObp78MnWTAtD
   hjJmhmaenWr2/s1KUP2nNfHtIIJrIjW4H3+m2ljT0NwsbgFgz5rYOEzMN
   K9xcXKHtYv5lZeA8HmFEPvSv+O8IjPs8JlX/+I9gU9WP6A+qQ7Vhjqror
   gCBuvgFL6x9LxE8ebKw6PDqo2RW+I9Zzi+9mJb3cpYJJaUA84eOPdsoa3
   rbTdNnAKYRNhoQCA31AdGuRj5zj8E3r5IZIZTsabBRjfTmX1t5smzGFUX
   Q8db2PLKq6Mo5Qq5j0toBICQK1St+T6HrneEY6Ub/BAYriIBf5XNqmT7a
   w==;
X-CSE-ConnectionGUID: AMl1HtnCQoSRaTj/A3U1LQ==
X-CSE-MsgGUID: kTXLR1pLTaa/klz8BdVTsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="21617660"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="21617660"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:46:18 -0700
X-CSE-ConnectionGUID: e9F24vMVQ46CYakFaPH3Pg==
X-CSE-MsgGUID: 2lemCMVSRtypwbGfQidtew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="81406904"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:46:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:46:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtocJ/2mE1oBizjRgGTshQgkXqNW2sIwXfk+ugO2rRFIJa40si2WIMrlCIW6WG3SMYPNuazCQWOWo5c1+lIsfoD81MKs6B+gWK5DNirFrm0rnOi2R0uxs83gUuFQeu//otL52SGPvqX+QpYi4OchxF4pnkt5jGbZl0cyUmRgO+P3YF7mp0hFeRTXrBFfG3GJJROlxxSpvGtd0nkoh7INdlrKCmeZzSd40jEPwl+KqMEAaEq0+jpvO1YHdJBYXXNDbofQ2TcCi4oQhwF4cnEJIlKQy5PHOPEHtX1I+4doEuET55GIBbbH6ReFCiZKLlLKQSgHfwSPiQHTOtD+QEm/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltpqqIYabW3nY2uE3spb/XdJNND2CTlt9u2x1N6iNjY=;
 b=aDCecs4BFi8G3CQjVAr6iIeGNdyGWSQNvFosOb+PMh8NwlZMaGZmhP+S2jsNj7OwUR2YT/W7yAseGRMwawS7DBst7YP7m6o3AtrlczeM94O9IiIMAvd0bsFepGdoBrfylWEsB/XwO4VUzWIZz2R3pjCQuKZYUUGwGcr/mUgbWJ8JkqGnnkTcY9DQ7P+eUC7DqDq8/C2CIdlvQ9IrmDniXxpGC3+hQ9GD1KKd+NX1B+Vy26DJCrsFA9lG+IPI1rxFNJtZ8qEPrDIWOIBjW4ts/DvoiUf5U8UOsc7eoZIerBJ2yQVLP8EFzCzf2lPUshyNqfsxvX29prWOILVF0QTzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 11:46:13 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:46:13 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Michal Witwicki
	<michal.witwicki@intel.com>
Subject: [PATCH 0/5] crypto: qat - Disable VFs through a sysfs interface
Date: Wed, 17 Jul 2024 07:44:55 -0400
Message-ID: <20240717114544.364892-1-michal.witwicki@intel.com>
X-Mailer: git-send-email 2.44.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DBBPR09CA0046.eurprd09.prod.outlook.com
 (2603:10a6:10:d4::34) To PH0PR11MB5830.namprd11.prod.outlook.com
 (2603:10b6:510:129::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5830:EE_|PH0PR11MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a451a8d-14ee-4766-4965-08dca6560f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hwphW5E5mHN1MLnZFwlB4eJWfTtKy5HseW7L5AKeBQIhDMIdFNaq5hvgFbsj?=
 =?us-ascii?Q?6fQuZDVfFSvMYcbXvoFtlwssSgb3g+X+DqdYd9HAS/Typo3P7fFJ0HNiAv+6?=
 =?us-ascii?Q?pMAODvx5JgQM0gmLVxS2xC3n43Ng/AZnL+MszcMNZ/5yHGcb5Cg8Gv/C8w81?=
 =?us-ascii?Q?VMh4pP4OR11wS8/tneUjbuPeVNtvxSHAGsvwd0J/ZY7sPZeQHA/FMtFAz3ki?=
 =?us-ascii?Q?cM2fjLFkaZks3O4Lo4c6hAg+8vCMrxubk9XNG8ZUsSbp07cD047MF461X+QE?=
 =?us-ascii?Q?SkMYrib7YnzFf5elAi5HXUt+9wtkFpyypF4dz8fOhqgvC/CKcGLtfRNAvrFw?=
 =?us-ascii?Q?Bu1Ckqwred9P3SAhoLradJ9zkPGp7JANA0PW0D/Ye++OtjM1o0WDH5C0ogG4?=
 =?us-ascii?Q?PvkuPvtTq3mfK+64kxj/sbOuPTCpRjDlhJEUGNPmRn0rct/QMAYIaZ/X63Cw?=
 =?us-ascii?Q?gSNthY4+sTgEVbAFGnHVU9qQgTbQNH85HNs+fFKg07H1Je2MtDvBdZn0WLiE?=
 =?us-ascii?Q?/E9FKJmO/3712lZT2QUDiKQisFYNzBlkf6z3n7wxSDBVoVbWy6ibjGJU++KS?=
 =?us-ascii?Q?nREhhgXQY8CqA+7fy5L0CgsYRgCuMaLCdTbxZiamsOg1ezZBdeRlkE492vlj?=
 =?us-ascii?Q?cB2R49o/XtE93Grhlj466HyA00f3xIuIVHW82yyFhAKgsXtj2rRNcJ0mtAIq?=
 =?us-ascii?Q?UsX2rhLEEwiLruD9Z8D7fxvCzK4nuI6I+bBR2nrBRYkyrDqL6P0i4Yp1dqo2?=
 =?us-ascii?Q?GWRpwSD0cL4MgGhz4Jw0yznNQRpY2UNuORHQHGO8GbVS49vlGm2E8DmBOQkx?=
 =?us-ascii?Q?P4zR/f7XuM1JnNGmdUi4E3lEPekbsPtgObYlPfcGieK2Y1yhoLXsyA6NqSaJ?=
 =?us-ascii?Q?bfuQnquvfyKmyKvrRPaD3Mp00YBNbEX8iWST+h3WJL2q7+rQ4h9zvf2vvDHq?=
 =?us-ascii?Q?zBewgcgEyhOCzfchAIrNBqnmHzHM74coQqoTtth4uw6qPuYAh8F0G72G8H2G?=
 =?us-ascii?Q?yPnKI+4Y1Hm0xuGItgGt2RY4YiVQVa9xpavgXQ3dZiiatUJJ5U411CW67mQ0?=
 =?us-ascii?Q?K3tNz9MgEaYAbJNKmkxoKcW8d98e9R+hfsZGNKkyC39QhlTvT/csP3FCpwI7?=
 =?us-ascii?Q?fBJJ3S5rvn8uZBv8RUfNBaZPAbULKjl4E4btqbCQIlzdc/KOMZAejXjfbQhv?=
 =?us-ascii?Q?FKhmMAalyV4uHOwMrPhn9wc0Pm6uqmA+o9wLPahzux3rUbNWNGvhrB3wFzj7?=
 =?us-ascii?Q?l9pWdt/kz21kMEf/stp9PyWcIES+V7p1OZ9/axgJajDb35pMYI+QhTPqqt+O?=
 =?us-ascii?Q?lftPIkhVFgO7f7g7D+01dK2hh0HYYD53M/gwWQvRf/5/ng=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VnBNGi7uMvcTnMWXgZFLjfT1w4ThSklseniH/O43AXPlyy8tbSI64cclYIlD?=
 =?us-ascii?Q?R1kwEdYNslK2ShWcUqWo9cZXsfIPfqBhaV8gIAyRzxEJXF3oraS+1WXVL38R?=
 =?us-ascii?Q?wPcWteORFP8nTTimvr/uH77SpShAW8LLAD5I3zLTeSCW/SvV7LoM4R+8909p?=
 =?us-ascii?Q?YkJm6mqUfO/mqnIql4E8n6/LPWv8H5GFbndFXJXnnvkWUzJNtnt9yfM2y5Ln?=
 =?us-ascii?Q?/gbY4q4Q1t/PDKxEFEqzQPaQix5LyjKe2O+4QDVrWNSoV6eEdEEnXYJaUfgq?=
 =?us-ascii?Q?P9EQ9LkHKVsRwAxmiCFhhH/BauacVFyX4xCknDrMAC07AZi96cqwLdhnhi6n?=
 =?us-ascii?Q?x5vb5crOEcKt1JvpqJEJxLLPC46HStsCigxjsxViPN62koa+NKqinMyOvWG3?=
 =?us-ascii?Q?FQfCtswZh+BrL5/TBBUHE3yQEaP380SXSrCu2Zeg9FnUla23rJtg8qmL4lXZ?=
 =?us-ascii?Q?v41kNPtHj3QD9xDJHgkPvGD2846n7vqrGiPkQHfjQE2fY56hporGUEV1pX5j?=
 =?us-ascii?Q?V6xhJdAoJNAangEvBXvQNRTvKTALtM/KY7k/O5sxch+fosi5g+FD14XKWTWe?=
 =?us-ascii?Q?9NaYu58/a0b4kz8qQsi9g9Yhgx54sZMZwTGSxgUq/txv/+gt6CJDvbIAQMzA?=
 =?us-ascii?Q?WvIpCUDRgPSDeLbQNHp2FeyXnGMitXF7dPVkcfPwHdP5XG8PGpueakzWgK5n?=
 =?us-ascii?Q?FVSfqLG0IelNaeI5XpHKlTUqQXJWz6qrsXkJi+l18kUWlPE3Anm1hUmItPtI?=
 =?us-ascii?Q?ZuEqfijLNg/pBgPEUfKVoJ98FveDQvfdlQj37QJN7LgW2RRiqpbkq5k0N/Ia?=
 =?us-ascii?Q?dir+BbeQusX9eJKpJWa/C1Yzfhjw9RoxSy09DrqbX0NgfMTLcJlTOO/JqJ+W?=
 =?us-ascii?Q?vZMxQIlLrV2PdHA8KrYm83CYRFF0v3n9B60nSnQR+Aeuv5L0xewr/8k0WqY3?=
 =?us-ascii?Q?ryGvWSiGF/P8XShMuvt9dMeFbgUIFC0K4aU4k2gWM0QL87CKjvGYklB+UZu0?=
 =?us-ascii?Q?eT6q6xCM6jJ+VyPTctnTVDZNzNaIi1EePGuwOqnXysHsbuFQRqf7HjwylPLt?=
 =?us-ascii?Q?hlfadqNNLN1RGgLvkk7yZiyvEnkbWGke03A+6pIeLFS1NgpnabED/fHcJupB?=
 =?us-ascii?Q?ZdnIJ2FgtKRAJ7R/oXBCSeqI1vDASGVIAu+xglXTLbupflEUOop1LqgpRTCO?=
 =?us-ascii?Q?uVsyVDKkUooHgQAZFSptmICAc8r4wMz9Divw6kbwrqiItSk51fxs2SUGV3si?=
 =?us-ascii?Q?O7Of/wsoAM+XctQC8wzGI3QjuYTgLBXDElXUzHOowGZ4KTzKuMnTTWLdy1DE?=
 =?us-ascii?Q?uB1bIv5BGsU+Qi3BcWL+XBnNI0Vv8Y6j5LvpT7vKftnNYAZUC9ODaTWxGV4W?=
 =?us-ascii?Q?k+PoCWC/VMskminXiZCnYS0dElLtNGJfhLXSBKUL4WPELQAwU7ZnIMfkk5nj?=
 =?us-ascii?Q?7Oykhs9wfyCWwtE9ZnZGRPqlvQc1DMojl2+cFURyGlHrkgQQtJ60o5TfuQfw?=
 =?us-ascii?Q?P0jRATuzWHfHz+uoSDeZ4tlkoOTMNRUcrSnPfinUTuJ8Qwh5iWGTS7sMXAHY?=
 =?us-ascii?Q?8W3jX/0bTTxEjicvHKN33A9cdsoGyekrwv5MEzGYd9RJWlSafYz9Qy52bUC0?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a451a8d-14ee-4766-4965-08dca6560f50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:46:13.5463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCG3rbtkoHDuyN5tQtftGPpJWSgLjAyznw6f8c7fyNBfKmUT4FZfz/OLFHfzjGnAoQnZvt6M15KwlNRkEHaN3fxh14y8awVb8FNr+p7xT+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7710
X-OriginatorOrg: intel.com

The main goal of this patch series is to introduce the ability to
disable SR-IOV VFs by writing zero to the sriov_numvfs sysfs file.
Alongside this, a few additional enhancements and fixes have been
implemented.

Summary of Changes:
Patch #1: Preserves the entire ADF_GENERAL_SEC section during device
  shutdown.
Patch #2: Adjusts the order in adf_dev_stop() to disable IOV before
  stopping the AEs.
Patch #3: Adds support for the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE
  message to ensure proper VF shutdown notification.
Patch #4: Fixes a race condition by setting the vf->restarting flag
  before sending the restart message.
Patch #5: Enables SR-IOV VF disablement through the sysfs interface.

Adam Guerin (1):
  crypto: qat - preserve ADF_GENERAL_SEC

Michal Witwicki (4):
  crypto: qat - disable IOV in adf_dev_stop()
  crypto: qat - fix recovery flow for VFs
  crypto: qat - ensure correct order in VF restarting handler
  crypto: qat - allow disabling SR-IOV VFs

 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |   4 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   4 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |   4 +-
 .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |   4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |   4 +-
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |   4 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c |  29 +++
 drivers/crypto/intel/qat/qat_common/adf_cfg.h |   2 +
 .../intel/qat/qat_common/adf_common_drv.h     |   2 +-
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c |   6 +-
 .../crypto/intel/qat/qat_common/adf_init.c    |  44 +---
 .../intel/qat/qat_common/adf_pfvf_pf_msg.c    |   9 +-
 .../intel/qat/qat_common/adf_pfvf_vf_msg.c    |  14 ++
 .../intel/qat/qat_common/adf_pfvf_vf_msg.h    |   1 +
 .../crypto/intel/qat/qat_common/adf_sriov.c   | 194 ++++++++++++------
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |   4 +-
 .../crypto/intel/qat/qat_common/adf_vf_isr.c  |   4 +-
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |   4 +-
 .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |   4 +-
 20 files changed, 212 insertions(+), 131 deletions(-)


base-commit: 64409cf846e03f8372654e3b50cd31644b277f8c
-- 
2.44.0

