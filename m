Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9CB1F0991
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 04:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767760225; cv=fail; b=olYHxeB+ygpDPm/qxDHzB0nWZ53vnREleSw3EIeLWTWVmHqZjFFMLaWLvDgZusrG2sFFjNK4nEVfLI/1Hq8eG94nnqPSFpmUKpl2q1Ss1/S4UlJehazFKVu7hHM1dwBmgKLCt15SNa6TVS4qDba3QUWpgJO4afqrwF1qYAUJnMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767760225; c=relaxed/simple;
	bh=w8uuSDf7+bxDS7zqRgcNHL7TUwO7KAJykRr2cu6//W4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pyCwPPBbT12eOmZRed7RutRvmPdeC2pAeOYZXBNifT5sFo4oavZmPmaG2NL2EnMZw8MaVCA4HXMKgFNOBd7f2DER28EgS47shbRrhmD/AmrMJpejf+3333LYUALajXVH1MLk2FldxQSGRTAllC5n5XbDbtDgZQ3JD6t9SDiStyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbLNYt1T; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbLNYt1T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767760223; x=1799296223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w8uuSDf7+bxDS7zqRgcNHL7TUwO7KAJykRr2cu6//W4=;
  b=XbLNYt1TZKTtg2lHr66OsmSTaw7AtyZGqFUIMTaKyo4pZpWNPlv8IWVZ
   UVT2IGizRxxgiOsFDEZG5+4LuxY/xOmQn28FwskkVKXY2W7jAZyH9MnFR
   SkNmZEndYijoUU6AinEAqPlaqf9h1EltMr8/37ZQZDmQhkHuz7bFXlG0I
   4n16UKlSlYUriVm4lMl3tp3ndo6i3RTDRH86pD4zWR5OrQUC+wvmTgirn
   VkdYbEz4m/YK7k7NYHlf1y/V/l4SFvD4xMTMPpw2KZ9xZuFkTyejQtHg3
   4KDO9XqxPUu7NisjjbHZV733QSfBgPdWPRlngN+fXetrfBcMPjNKqQyaf
   w==;
X-CSE-ConnectionGUID: 7+XlBZlRQBOAbWxs44pKew==
X-CSE-MsgGUID: 2A153N8SRy6AOTwyYT4f1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69285709"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="69285709"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 20:30:23 -0800
X-CSE-ConnectionGUID: Wl8VYFxiRsuR72hbJq58bw==
X-CSE-MsgGUID: 0AHiscxuQDeYRVRQh9qWxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="202837876"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 20:30:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 20:30:22 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 20:30:22 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 20:30:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqhF5Gj9MYLIzhFyS/4yDr0F9suAC1PyG4ppqavwJzJ9zH+H5nV24zHktPTNUBkuE2DjidkoZn7fA5iPz1m9JnArc8ZiXHoT4RZyrSRSIuNibzmxuIyxMTOSTviL7V4diXF/qzvp19znmc9o3AEXCQRtCzZ4ZVjVhN64WCwS0x2qKxF3ByihBQKM/pg8cYDBebRirXwe5J7nRn9VlKcLbpJXHFuLl76YNX9PD+yIP56xpz/iJEP4PH8NvcvzE/mSnt/EHpelyral+mbMzV6j86LA+qbD8gAAsMmD3lMpHYodZzOf0bIEj/qPn5EEFXC3QtAjrohCyLJCcwMdoVLjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdQ+ywX8cHNbBj8QQDndsvuBeb8J26dm3cuN+AP/rV0=;
 b=N1aKt7TKdfzZiIV0ycr1Wp/O/F/NWhmrL7P3r8gONKar6uGDCGKHfKtumAhe5o0fmFg7XVRVkuR4wLdcp5uJtageVldeXqtTz+zwFO2PkAEDNj6IrKKhpPGfzlknTLdW7pZCYvOcTGg/s97JnLneQhPogDKytvJBfcWdO74zYkzc29KLNsbpmRe0fNeMjFYehnPbjZudRbE4nrd/UVmEEzkrDaHfvYShSI+gIZG68K3Y0X5Z7a4AVwxH3g+XGU4xT2LeZQC+2964D9tykYSR9CzUdffsP1vn7xV09s2eohMzR/85fPGjGaiVVaRqSwsZ7zwshGfxk5RwdjOkg0NMdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20)
 by SN7PR11MB6752.namprd11.prod.outlook.com (2603:10b6:806:264::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 04:30:18 +0000
Received: from SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939]) by SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 04:30:18 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH 1/3] crypto: acomp - Define a unit_size in struct
 acomp_req to enable batching.
Thread-Topic: [PATCH 1/3] crypto: acomp - Define a unit_size in struct
 acomp_req to enable batching.
Thread-Index: AQHcdgCuwqF//5iFN0KclLFY+p2GbLU4ep0AgA21EaA=
Date: Wed, 7 Jan 2026 04:30:18 +0000
Message-ID: <SA1PR11MB8476A76C2A3BF7E3A28F5FCAC984A@SA1PR11MB8476.namprd11.prod.outlook.com>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9565daceae6efbac8ba35c291e7f9370ecfc83d6.1766709379.git.herbert@gondor.apana.org.au>
 <aVJg7Gov5rWKOfVB@gcabiddu-mobl.ger.corp.intel.com>
In-Reply-To: <aVJg7Gov5rWKOfVB@gcabiddu-mobl.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB8476:EE_|SN7PR11MB6752:EE_
x-ms-office365-filtering-correlation-id: 076bae3f-39c4-4333-de2f-08de4da5769f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?pnTsOnECPTrkpMaz2WzGXJMJ1nOZh5b2Coloxbm9/daET+VqTxWahcywkRyP?=
 =?us-ascii?Q?6p1viJctCNS/G22/aii9+30YgGhVNTpJo2ljvZXOrD22hID7PnEqsdsyDf+Q?=
 =?us-ascii?Q?TJkyMIqgxIlHmfEgF+zguRm5q1OIXjBZ7spiqbphJqjr1pSXyIxDW3BQtUcx?=
 =?us-ascii?Q?upL5xLzjoB+NlnBSlKuCwhjeqXBgFwihePEMrmnbn0s2pqnGreTmK+b16eev?=
 =?us-ascii?Q?wbQTHMWFAK8sWau+gg9NxHx9U7YP/S8YoK+eyeGTD2ZbhZoEdkAghBAa5Yae?=
 =?us-ascii?Q?Ch0qdDsEYDJ2V4A2wXhVTaWl9cmIBaOzeROFNDU6S+ZfF6o51EdzIzNyVhrm?=
 =?us-ascii?Q?1H74wOolE+1sBBPEw7tejKYW3WlB1cBJov8AZOmVI8PY7bnVMy1N/0DLko3X?=
 =?us-ascii?Q?oEtpKO/wl8bJTHcX3eTCxOcpezXxhZ2zfw3TYL+oZhMeq531LtdltZZ2sP1e?=
 =?us-ascii?Q?Mz+XqUkBMAVhy2LDTv26RvLjqDMEszCmbDffNX3KUyGZ1e+5W1Q1ssb7qY+O?=
 =?us-ascii?Q?H+1bolCZSVeA69ijueJp0TYP+FV5CKtU6LDlX910s3r74ZOzkYic5GCHDM6O?=
 =?us-ascii?Q?HnlQtPvt1ghFLziMtY1cFKCeRwwQ6KN98Db3xdlVgaSX6G6TJiAeur18v8LO?=
 =?us-ascii?Q?6O2FFhztGlHfBM2L0Mld5SnDiKZxSatp2bnGlQtdcV1xv/m8xW9zcvEUm51z?=
 =?us-ascii?Q?5INklxdYxmRCsbQfq1hr4SC5q9xrfUx6zfFyGBpmzBReiBLEDJ1rmaQAU5o0?=
 =?us-ascii?Q?Fi+hEyyx7TEBOonXntIem+TFDz8ZpoxoheXN7US/vAkXYGXJtcP/NlJ9sB1p?=
 =?us-ascii?Q?jSnFYbCgYlmFZT7nd1WA3ftfQ7a0AOxe4UGpmNkFsLjYo42qvGfluQrLZd+3?=
 =?us-ascii?Q?FKmpfhwfqvnI8Y21mEl19k9pWRq6X1suKROsqLHArncdoVK7GFD1LMdAnTxy?=
 =?us-ascii?Q?4QWnMzG45eo8GTtiM/KfYM7/2eGrSzHFcJoA3l/QY0HuKLbUYs4rOurm0Rt0?=
 =?us-ascii?Q?pfSp2GNDHm8U6p5Xfpf9IET8Zj+4P41ZkUxjIP/D4Nh1hq1z3nIqzmVNXPSn?=
 =?us-ascii?Q?cM2f9/bq3dUH0rvsMPxN+gotDBWIC+Z/LWe95YMLqKLTuS01Yn4S0bM76rvZ?=
 =?us-ascii?Q?9lQev8U4ErlmSTekG0mQX5THCZL3u/mZ22TnVf47qCYdt22KLfyS59f0Kmb4?=
 =?us-ascii?Q?M1xMpt0k889x3wG1FuptQz6azkH73WJ9Q2wS/hKyaN9Qq+gjyVCVN4nKFBEU?=
 =?us-ascii?Q?OV3mweFth4qlQEmtchUQwSWFsJ2erBysVw8FrKAS9IxYThqpBr2yHlgaPUiL?=
 =?us-ascii?Q?zKVSrycFhEQp78SbKP8Q11z3pbC/9GyNrdVoKtsKy2oEfX//0Z0d7I/Rl0gf?=
 =?us-ascii?Q?g6G6kSqcaU5+nmiecu8cUIl3P/8em6gLITJ2ldfigzIAhph5S6NEboOh8sVs?=
 =?us-ascii?Q?OUaiB1fE1t/LWw5xjLD8YX/gJKByP8TtMK0B0jkk03VsRSoEdegX4fQj5HBC?=
 =?us-ascii?Q?oryJEwsVMdYy0uZz0aP9cSbwQoK6Kxa26r3Z?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8476.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q7/NpkeJhpm3uznLIMYE8KQxEBlMixSJyC90IRIXugtzHxKVjLePtpcog0jZ?=
 =?us-ascii?Q?EXlHbEbK9Dbu7uf6rqTKP5CUBBN29qTNMq6VrqiVLVfg/fzUWTYpSfbBZzKd?=
 =?us-ascii?Q?lhr+hRbkGvdVd+aUapLTbQMofrgWVmP5T3sz/gRTRFQbRCHlAFw1QuBdHMAV?=
 =?us-ascii?Q?RY+FhVguzDTp6jFnHLPlskNO4UXIEdov3CmQT9QQdZaE4gs1WGQrX2GEFzNN?=
 =?us-ascii?Q?kT0dnz0JXou4h6xcjnsKYa7YgMZmUbViquUkq9iw9jssKAegmCj+5Gb6wcpx?=
 =?us-ascii?Q?s5piAEzjbl1/Tx3ezbZ6tFpE3Yb1lWlk6aL80GYgqWTPB4gYpVCXgwuUWc9T?=
 =?us-ascii?Q?ThBUsUt2s8unUC3IUvE2PrwsVRYqYoLziqMOBK1grkI2NrYZvg5mW8VxsaAW?=
 =?us-ascii?Q?W2nMNCm1rTrK8IlpJWTjvGgwOqsRQn1D/A+DmyCWjLEImMly+sXsNXeYnss6?=
 =?us-ascii?Q?4JXQM5JVV7muUvJf3EuOUSwGZu9BOPe8LAcM0pAhfeHY6fG5KIiwwavXDip6?=
 =?us-ascii?Q?bFWFbz/VbXSMKdI6f+Omdtuh/MQoxBjdhaSQIdS2mU/SrVw+2+UwlbYpVmgC?=
 =?us-ascii?Q?z7gw33MSz8dNw9Z6ba+dVYWoB0mzkD1ZQx9lE86ERAAYRzab50i5FGGzOB3t?=
 =?us-ascii?Q?ZB3FLmdUI3iLm89te0d9DOL81v2jXVbw2uCu9WgVpf7TCuc4XQafRG/xjI6s?=
 =?us-ascii?Q?g3NDlA+rY0W1Ven+eWpEPQWEKVDX4e8WOLn/vEvUGa7rkX8/YSQdquEZKL0d?=
 =?us-ascii?Q?JcpiLRGT2qZNYSES2Fy7DccZn0sT8OS+CbuqCbPvefkKrBcuf30DareHRobU?=
 =?us-ascii?Q?VUOJe5ulGKyjWGTd1fUmTKodp26ULX9mLK+wReybKKht0gXD1woLzOTdtepG?=
 =?us-ascii?Q?zpFE0VTXbVmjvjkPTMiPfS2oG9LTP5sNQJtCE8FXp8KskIjFS+QF3tW1TU1+?=
 =?us-ascii?Q?m1U3AnFulUWyS/p0bs7p1pPd2+RRpXoGymyAcwvV1D2SwjisR9N1gocQHo9x?=
 =?us-ascii?Q?4xTjOJX9u2GI2rStV2lBykYZRIUFMOxYCRZ+/htuxRgk10FGys2qO7xGeC0O?=
 =?us-ascii?Q?6kk+SS1l6LSihn3kyLyzp3JmE+TZ6BKSxz7qS9EoF44TTLU7b1TJ6U3/xfbW?=
 =?us-ascii?Q?t29sg89JW+2aUUG7ydupZby0p/fSdHzs7nynpuYWx6ZSCkyzP5YmYEjk/Smt?=
 =?us-ascii?Q?MUFKOnK6I7aQQ/bBu0DH5+Cve6RuBVbClHE6lGvmwbA4pT/Y++jlwBRHXHkc?=
 =?us-ascii?Q?fsef7VQKf3bGtd9+IdtGx23QWVKmURlrIj+LMcLUmwFpAdoD0RthicPfnP3Q?=
 =?us-ascii?Q?/vJ1HrFY0JSLVjHR82zT72ABljm0q2QEXq2C1Zvbpz8qImuMnAzeLXH/16xo?=
 =?us-ascii?Q?sF6QeNAw4n0hcoZWoaA2KET9cAnW7l7W1/+eVCt/TIu63hDyYBqMXpg5ShL2?=
 =?us-ascii?Q?xkKnpp+PoOercVNFq6Xo3t7rJGajHFTExKp83VpUvB+sSECBUPkuDvWZ4QR+?=
 =?us-ascii?Q?rR/sJ8k9yAlXSKWhG+ZChRbpqSGn5KoL9i27vil3Hlq85ATeDNI5P6PH36wp?=
 =?us-ascii?Q?60xBDIuKJ+AYBMIKbU/1yQp4L02jEhnVx9O+ZghNRgLWpvZZLzfTsHdwKPv/?=
 =?us-ascii?Q?+5+cJW8Qxt/kIyskMEWIN11V2czt4rZXK/XYnC6LhpFKLTIyv2o31/hyODgz?=
 =?us-ascii?Q?L6X7q/KUuE10N+rFJdU1eDIlecX2H0Nc/BlYjUrU14eHqRj0TAo9xmucVDBA?=
 =?us-ascii?Q?l4fkTV4lZg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8476.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076bae3f-39c4-4333-de2f-08de4da5769f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 04:30:18.8073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3b57p77Fi+I+4TygNLqCtZo3AUEfE/ZDKm9c/SszxJNWN6ZtzkPO8prULrIJogjNb0pWr8eVf2A/jPCKXsfj2XAjfqBMYkM6K97tEWPt8vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6752
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>
> Sent: Monday, December 29, 2025 3:07 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>;
> yosry.ahmed@linux.dev; nphamcs@gmail.com; chengming.zhou@linux.dev;
> Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Subject: Re: [PATCH 1/3] crypto: acomp - Define a unit_size in struct
> acomp_req to enable batching.
>=20
> On Fri, Dec 26, 2025 at 08:38:25AM +0800, Herbert Xu wrote:
> > From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> >
> > We add a new @unit_size data member to struct acomp_req along with a
> > helper function acomp_request_set_unit_size() for kernel modules to set
> > the unit size to use while breaking down the request's src/dst
> > scatterlists.
> >
> > An acomp_alg can implement batching by using the @req->unit_size to
> > break down the SG lists passed in via @req->dst and/or @req->src, to
> > submit individual @req->slen/@req->unit_size compress jobs or
> > @req->dlen/@req->unit_size decompress jobs, for batch compression and
> > batch decompression respectively.
> >
> > In case of batch compression, the folio's pages for the batch can be
> > retrieved from the @req->src scatterlist by using an struct sg_page_ite=
r
> > after determining the number of pages as @req->slen/@req->unit_size.
> >
> > Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
>=20
> A few comments below.

Hi Giovanni,

Thanks for the code review comments.

>=20
> >  include/crypto/acompress.h | 36
> ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> > index 9eacb9fa375d..0f1334168f1b 100644
> > --- a/include/crypto/acompress.h
> > +++ b/include/crypto/acompress.h
> > @@ -79,6 +79,7 @@ struct acomp_req_chain {
> >   * @dvirt:	Destination virtual address
> >   * @slen:	Size of the input buffer
> >   * @dlen:	Size of the output buffer and number of bytes produced
> > + * @unit_size:  Unit size for the request for use in batching
> NIT: use a tab after the colon for consistency with the other fields.

Sure.

>=20
> >   * @chain:	Private API code data, do not use
> >   * @__ctx:	Start of private context data
> >   */
> > @@ -94,6 +95,7 @@ struct acomp_req {
> >  	};
> >  	unsigned int slen;
> >  	unsigned int dlen;
> > +	unsigned int unit_size;
> >
> >  	struct acomp_req_chain chain;
> >
> > @@ -328,9 +330,43 @@ static inline void
> acomp_request_set_callback(struct acomp_req *req,
> >  {
> >  	flgs &=3D ~CRYPTO_ACOMP_REQ_PRIVATE;
> >  	flgs |=3D req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
> > +	req->unit_size =3D 0;
> >  	crypto_request_set_callback(&req->base, flgs, cmpl, data);
> >  }
> >
> > +/**
> > + * acomp_request_set_unit_size() -- Sets the unit size for the request=
.
> > + *
> > + * As suggested by Herbert Xu, this is a new helper function that enab=
les
> > + * batching for zswap, IPComp, etc.
> This sentence should be removed. We shouldn't be mentioning on the
> documentation that this function is new or who suggested the change.

Sounds good.

>=20
> Instead, explain what batching actually means in this context: that it
> allows multiple independent compression (or decompression) operations to
> be submitted in a single request, where each segment is processed
> independently. It would also be helpful to clarify that each unit has
> the same size for source and destination, and that each segment must be
> physically contiguous, if that is the case.

Ok, I will add the appropriate explanations in this context.

Thanks,
Kanchana

>=20
> > + *
> > + * Example usage model:
> > + *
> > + * A module like zswap that wants to use batch compression of @nr_page=
s
> with
> Pages or folios?
>=20
> Also, @nr_pages is not a parameter of this function. Is the usage of `@`
> correct?
>=20
> > + * crypto_acomp must create an output SG table for the batch, initiali=
zed
> to
> > + * contain @nr_pages SG lists. Each scatterlist is mapped to the nth
> > + * destination buffer for the batch.
> > + *
> > + * An acomp_alg can implement batching by using the @req->unit_size to
> > + * break down the SG lists passed in via @req->dst and/or @req->src, t=
o
> > + * submit individual @req->slen/@req->unit_size compress jobs or
> > + * @req->dlen/@req->unit_size decompress jobs, for batch compression
> and
> > + * batch decompression respectively.
> > + *
> > + * This API must be called after acomp_request_set_callback(),
> > + * which sets @req->unit_size to 0.
> This mentions a constraint, but does not explain why.
> Explain why this restriction is needed.
>=20
> > + *
> > + * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
> > + *
> > + * @req:	asynchronous compress request
> > + * @du:		data unit size of the input buffer scatterlist.
> > + */
> > +static inline void acomp_request_set_unit_size(struct acomp_req *req,
> > +					       unsigned int du)
> > +{
> > +	req->unit_size =3D du;
> > +}
> > +
> >  /**
> >   * acomp_request_set_params() -- Sets request parameters
> >   *
> > --
> > 2.47.3
> >
> Thanks,
>=20
> --
> Giovanni
