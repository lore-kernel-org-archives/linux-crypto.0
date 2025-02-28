Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916DA2561DE;
	Fri, 28 Feb 2025 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736827; cv=fail; b=m+HnhimBpkP09VyO6J+sSnSzzp4JNuifVmbhuV2UX74iNyy/23VQeFVZ/tvuK+sb7wzyFIGSi+kCZ3+ZKGLTMpdWdvQsgSXxkdDy1Ij0IrO/EkblQuw5AM8b30XNwq2Big/0Hy55PDjGGYuTLrgiXh2z4+QbjF0R4pof5eOZz0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736827; c=relaxed/simple;
	bh=moQnzUPUYfWjf2y6Tw4lbP6uS/eXrfnBDjtj4RCOLp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GYXWH6UbosY2JcmqCMb/1Zdky5Kev5J+jSrJAxLIgiGS6WILUjmNAYM9opRH/LFQfJQIG1Rl8kJzt3OOcaHnWXm19EIdUWnOFwtKPWR9N8WkhodOwo5NNK5ld6FUuSy02R3Ywl6/QtNEWN0OMClwdnL2xEc2qmJe2YVSvClERj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTt2BWdn; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTt2BWdn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736826; x=1772272826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=moQnzUPUYfWjf2y6Tw4lbP6uS/eXrfnBDjtj4RCOLp0=;
  b=HTt2BWdnKumDlrAc2d9t0pVYlIUoU0M/WKCT9PMNWgm8j5+bAm6Uf6hh
   yuS55dbtaSTrDpra+v8Z/DOrhVL9y1HveIy6bkFdF78Y6+VWTPZ9HDa1a
   LBWwTxUy8mNArPAMgF04VvSxM/qEpKsG3Gy6k2zIaNKtNGaHpymCpx4tW
   5NVuxhpuejBoXcu5Fz+yvCQVYFxNkk2CkU2xEkbE7V2n3razB14FIhuGp
   9BC7eHmP+DT9ZuqdZ7JScLN6O+qDT2/Ua4EOD329msaVI0qq8h44gsdUA
   K1x3QbTDVRnifB9vBD0HbtiJyc/AnD9SIluozcjc8hAXeNTuPuOPaMTWy
   A==;
X-CSE-ConnectionGUID: ajtzroomQDmpSPaJQw2NAg==
X-CSE-MsgGUID: AuD/WhsqSyKZVCoUGjm0jw==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41783648"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41783648"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:25 -0800
X-CSE-ConnectionGUID: qQbo3LJOSEaNJTj2MZ6NIA==
X-CSE-MsgGUID: 0FhQQ85WTI6zSV6azKfccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117962393"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Feb 2025 02:00:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 02:00:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrTs0GnP1sm2CylGytVTfYTiRRNDDpIlfAAXZBrdUtmlxLATh/DxkbutNFwFy+dkIkVBvmanqj1KfwBfMjfb4Gw+kQpbg/rldBTk1CcL4pw9gOv2TNhaRU+vobsthW0h0h7tV/jnpJMG/jaS7bdT0612gQzSxkiogX3ke3r7loA6fxHTIoUc3ThWKxpx4bk3JI7LJws9WiS9Wy6neLpeA7+GHyrA5dFBao6q9CLvNfUOI4uaV/039gwisIcCS4oZKSQE/gpN1/yomBqm2jeSo6bxTDXXPuelDtKJ+ilcXb99mcS2xNeHYahW42ng0rSNdWAuiaD6aHhivIojUl+SRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRSJ+XS/sG1o8PJ9CL9grBfCdpGiioonYfGbPjKLQtM=;
 b=pvMbXSZ6DqDWDSJvRQghg80QWDZo8lTw06oWg+aJSuxDEV3Z1wuB1E6YmFOVsahbuqTod4Xwg8W2Z6jhvWyK677BqKPW2O4QiCwX9z1kSyfWjGS+AqgnpitXE5K6nuuQeSQ/BpbWMyZeDRYIThZtRZ61aSjXvFDXhYghwX3jiltHJZTnHiqONP3dvS6mtJcGU0KTULcy0v6/5B+k4BWLreEBIIW9kat1rvULvWrHRnpQoEIBwkAmNbA5q2kBn4CVlt5YOSx+ft8wPL2sncxM+4YxgxBAmH6jpuIzYTqMRwYId32+cFu04oVw6oZklNsvgMs62+NESjt3CIL7dexQjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 10:00:09 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 10:00:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Topic: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Index: AQHbeGfAjZbrwpkGjEqL/QTV2aedp7M6pMeAgAABk4CAIaljMA==
Date: Fri, 28 Feb 2025 10:00:08 +0000
Message-ID: <SA3PR11MB8120D8E04F55FB803004E3CCC9CC2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-16-kanchana.p.sridhar@intel.com>
 <Z6UJKTCkffZ93us5@google.com>
 <SA3PR11MB81203800298A246D7D6CB75EC9F62@SA3PR11MB8120.namprd11.prod.outlook.com>
In-Reply-To: <SA3PR11MB81203800298A246D7D6CB75EC9F62@SA3PR11MB8120.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH8PR11MB8287:EE_
x-ms-office365-filtering-correlation-id: a3773e24-f577-4c61-2955-08dd57deaf25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?wz1eVAgHpRgTJ5L0hEFgMO7ih2YG5ENb4d5EruNzTsrbnUMons/g/0tMEF6C?=
 =?us-ascii?Q?3ziE+tPQ7OtYWSFjy0FOvNPr5bFmpRiNoz49BsfToaI6EM9GK7fuF5JfQu8e?=
 =?us-ascii?Q?Fxl7HgMjYWi8jnIXR6eq2AWO/LQCsEaAfvDXJwblaaq4VQ7R/hLfAT65zXFA?=
 =?us-ascii?Q?GQ95nAWqg8+HiGRTz2k4muUwMK8E/10HTkdazeg+U//O/eZZfiTZw7La7P0v?=
 =?us-ascii?Q?DDt/9B0IFZsjLLWW7nx/O7Nbh4M60D7idiSYFNVdNfCTFQPoMfc6D6ZMyCdh?=
 =?us-ascii?Q?tIC4/JFzoVeSbeN3FsdVEcenquGW3EhoPoYr5liyP7+9/qCzTEeLRfDLD/wA?=
 =?us-ascii?Q?yrVWJOF20w0yOFrWAdks54WgPqtbZnB9hNXEEYh0hESejzqbGrcou4QCZ2ir?=
 =?us-ascii?Q?zd4swKRtj687ZXenxYBiK3/a6ESZuA8mE4kkNt4NqH3AI5ma9aUo+bo17SPx?=
 =?us-ascii?Q?91zDxq5hw0zl9Oq300vYBRnS+w2dpI0TPKLK3MX1Kphmw68tyM5tBlhf/i63?=
 =?us-ascii?Q?SFz3yuXqndOEfLBPIp8EbtTdc2heAbAcZkO694vvaMJLlVNIMrZtAdAiU8+w?=
 =?us-ascii?Q?Y79sP92ggU642DMDT2p+5g8ifnaNDsDDThrJwAAvypPIEHb6XcjzluEaJ2mV?=
 =?us-ascii?Q?tquofGuTJiMB8fSI/U/0wkPBvroe+BIdrKzQeavYlC+47yLTLxuF5MHykzW3?=
 =?us-ascii?Q?N0muUvlI3b6E0plq7nGKmVBD58RbJWesJH6FSbnhv1BoGGe+nRScDQQCy540?=
 =?us-ascii?Q?KEN6R+8jnLGu3jxxGs2FpW1HfaHxtyB2efDhZUDEjZHN1Zuwwl46E5lqikAr?=
 =?us-ascii?Q?qCscioRXICIOgmcAYj49BIfhNxEgBjeQuH0P9mKsyURbqY1vSJvv8Cr44ij/?=
 =?us-ascii?Q?XbADDw3jorSdjFXc0/PqDc2sfwLXEzsDWR53rnLKwcErgnfFjNQplAq5yWHf?=
 =?us-ascii?Q?BWW6yqaEzefmu/WIa8v/Mj0uHUPy/K2LI87zeGH0mAi/GDa4rl019xgGoL2A?=
 =?us-ascii?Q?JCWzYdZuk3/wHwHu8KZvbdJBSin2VWS+u3TWHpMOkiUeEQNPgbTQXDzkU2m5?=
 =?us-ascii?Q?/zkG+pa1zWRuz7tQ674tdLXwqOQESEVvbH4MmNPyh4QO+B34A+OnWzeQUERl?=
 =?us-ascii?Q?gbyV2E2FcEzrO6Kc9dELDR4AuLMFAqKiyKtKaaXYO6Nz17061xTjgDBzDmbK?=
 =?us-ascii?Q?o/wG1/9Ostm/7plqBKWkN0A9QpJdNio4caCOOKwOpzRNvp0BDDXDSa3V2ALZ?=
 =?us-ascii?Q?TITDE0NJwadbHjQCQsBWwy+YYVx3xasesXux/SdEKnZ0cQl2QT81KVPATN1T?=
 =?us-ascii?Q?rPyN/FQmKIdJwZgSeViNx4YvJvUmS4AcM33u3ysEgClP1PtAsQu5F60hTbLu?=
 =?us-ascii?Q?zWXGb23X9viNLDzk2qDUMJS3facU+kdRP68wVmnl4RmC6zfMRMYORltzuEvD?=
 =?us-ascii?Q?rZjY0NZrqUsB8uspFF1tbtsrVgwlBEV0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y4iFa+MhiYalkUnLnh6BztyXYib78UVipK5XZ2ZYUIiBye6nBN89kdmuFJ3S?=
 =?us-ascii?Q?/3U2wfyeSXPUWpDgCj8/aHXJCVbtjnKocaNU/0pcHPd1dZjj76TwPaG5TNQ/?=
 =?us-ascii?Q?0Zj+mwWoW1HL0B7wEqt+3hXFn2qmivlvOLzrddNDESHNI7fVkN4iFCFJGQAU?=
 =?us-ascii?Q?yAjpuwCvFEiiF8kmgJfHFFOeeUBUhESuMWp2nfWLif06oCRBxsR5Pufop4ev?=
 =?us-ascii?Q?MKhzDe10j4zoU9sWS5QZWlfb0lzSW95rZH/YHWHLJMHXfzGVLUjfJA8Sxk82?=
 =?us-ascii?Q?FaoU7aFb8WW+yJ05GaEHS705Blsip2pgUfFL2JfyV2G7Dts0oJkbkhtZ+wie?=
 =?us-ascii?Q?eJFXRF0+MQT9gi1wTO39y7HKunpZLsIVTiYRVTy0sQOKVDBKmgToUj8+DQTi?=
 =?us-ascii?Q?BuV1SWYAqBzEXvLfDg/eVhOpniNYisg74jljH8e+bM+zp5/w87Lh1QIhU6UL?=
 =?us-ascii?Q?zomSrhOjUMXUZwMK16zMD1CLraqUZGz54uCBtYkMiXFZYWSQqcyk5LptrTM4?=
 =?us-ascii?Q?1VHbde6Zl+/c4qGLfv7cqPgl+WFFwaW7hckNXiggFERAKvDalJx0/RIcljgg?=
 =?us-ascii?Q?NdaVgPNM862GIUQGq8i8WZaXyaVkxhWdnBgMC2HlSZSuc28Hgmso467DL/5D?=
 =?us-ascii?Q?bRERP5Jnaz9yK/T3SS0dHkoWfwT30RBN4PN+01yLSBnmJFlamf9sI8064Etp?=
 =?us-ascii?Q?4QgY8Y3urGOJgkyNkqbswxF7CDRPXmhql5pPakZVXKXa7f2y9eMLv1sVH6EK?=
 =?us-ascii?Q?WZykCX4Kxll+pOMVgzfZ+Ys5/jRbmMdtIYHsOlGscriN1uRk8zwrfWpSFDcB?=
 =?us-ascii?Q?G6IRtMaZWuWbQFJQAhNZqlY997fkqZGbw3euPeF2+v0p190vjWaVTDu+UKJY?=
 =?us-ascii?Q?/pr70+hgaUOp3LzXQNrai1rLGq8O6EpPWffS/pDhJFWhZifdIoqnHpGUO/QL?=
 =?us-ascii?Q?ENnmNZS7+2/XXNud5DEnD3TYP0xFUg0GaitOWRVmQOtZaMBZsAh9xr4aFzn9?=
 =?us-ascii?Q?IzzkU2nEk1dIEbm2xmy+IfFT5pu8o86cM+Yeiecw37iohHTxazFQI4fh5rPS?=
 =?us-ascii?Q?TaJ8XyKGg3F9p6C+ByVAwOOeNzGOUctpy54PsBsjlg8E64P2oCGu8F9a2Ucz?=
 =?us-ascii?Q?yPKUHSJm+9nETyLEjLOvlNFXIc9a9XGPXK9UBf78t/8DAGrkhMi0YCEeYAA5?=
 =?us-ascii?Q?ht4CdRCkyICfuP8ERtWHDMdt2aCr9VCeaq2JPY5uQbwq+r05ZnpI7y7Z3Qnf?=
 =?us-ascii?Q?Jvl+oTM/j/X+v0nsEZQgazG9hQ8xdxdtL/EnT57YMnZegBcQHtikmhYyg35C?=
 =?us-ascii?Q?HrzuZKIur9r9uYk6Xzc+5GFn8IRxGfqrPqOhNm/Qv9FzKPs8hvKAeeVE8rJE?=
 =?us-ascii?Q?1ChioMZSma0iHr20xUcUK7UxacDgFrfjGV9EaM+BYHo60J+A63CueUE+hvnk?=
 =?us-ascii?Q?gFV6d+HkZ5l0MIQ5/IHJdQ+8lMu+xh6W+TO8Z4bzxp+KeYuMZxFz+SfA1bwc?=
 =?us-ascii?Q?nlDFq+ga3F4ITtUNGi2kT6kumPfjUjPUziUXz+3xzVmikdq77HjDqqr3TfCP?=
 =?us-ascii?Q?5+TuGByIiE55AtngwGkclWHI70CI+kXurI9isHNYN7d0P0Z6BDQ9WXQg4xv5?=
 =?us-ascii?Q?GA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3773e24-f577-4c61-2955-08dd57deaf25
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 10:00:08.9208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rQ54mPgZHym+K7Be0HOET+oi8Ek0JLZNUs01N8V3ZGotSjpwBDd6X/SZdqsmsPMBP5IEaerONjeE0yjQyighxYJ3Uzii7dGNcHxKwahVEH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Thursday, February 6, 2025 11:24 AM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA
> in zswap_store() of large folios.
>=20
>=20
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, February 6, 2025 11:11 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net;
> > clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> > surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v6 15/16] mm: zswap: Compress batching with Intel
> IAA
> > in zswap_store() of large folios.
> >
> > On Wed, Feb 05, 2025 at 11:21:01PM -0800, Kanchana P Sridhar wrote:
> > > zswap_compress_folio() is modified to detect if the pool's acomp_ctx =
has
> > > more than one "nr_reqs", which will be the case if the cpu onlining c=
ode
> > > has allocated multiple batching resources in the acomp_ctx. If so, it=
 means
> > > compress batching can be used with a batch-size of "acomp_ctx-
> >nr_reqs".
> > >
> > > If compress batching can be used, zswap_compress_folio() will invoke =
the
> > > newly added zswap_batch_compress() procedure to compress and store
> the
> > > folio in batches of "acomp_ctx->nr_reqs" pages.
> > >
> > > With Intel IAA, the iaa_crypto driver will compress each batch of pag=
es in
> > > parallel in hardware.
> > >
> > > Hence, zswap_batch_compress() does the same computes for a batch, as
> > > zswap_compress() does for a page; and returns true if the batch was
> > > successfully compressed/stored, and false otherwise.
> > >
> > > If the pool does not support compress batching, or the folio has only=
 one
> > > page, zswap_compress_folio() calls zswap_compress() for each individu=
al
> > > page in the folio, as before.
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  mm/zswap.c | 122
> > +++++++++++++++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 113 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 6563d12e907b..f1cba77eda62 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -985,10 +985,11 @@ static void acomp_ctx_put_unlock(struct
> > crypto_acomp_ctx *acomp_ctx)
> > >  	mutex_unlock(&acomp_ctx->mutex);
> > >  }
> > >
> > > +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the
> > caller. */
> >
> > Please use lockdep assertions rather than comments for internal locking
> rules.
>=20
> Sure. Thanks for the suggestion.
>=20
> >
> > >  static bool zswap_compress(struct page *page, struct zswap_entry
> *entry,
> > > -			   struct zswap_pool *pool)
> > > +			   struct zswap_pool *pool,
> > > +			   struct crypto_acomp_ctx *acomp_ctx)
> > >  {
> > > -	struct crypto_acomp_ctx *acomp_ctx;
> > >  	struct scatterlist input, output;
> > >  	int comp_ret =3D 0, alloc_ret =3D 0;
> > >  	unsigned int dlen =3D PAGE_SIZE;
> > > @@ -998,7 +999,6 @@ static bool zswap_compress(struct page *page,
> > struct zswap_entry *entry,
> > >  	gfp_t gfp;
> > >  	u8 *dst;
> > >
> > > -	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > >  	dst =3D acomp_ctx->buffers[0];
> > >  	sg_init_table(&input, 1);
> > >  	sg_set_page(&input, page, PAGE_SIZE, 0);
> > > @@ -1051,7 +1051,6 @@ static bool zswap_compress(struct page *page,
> > struct zswap_entry *entry,
> > >  	else if (alloc_ret)
> > >  		zswap_reject_alloc_fail++;
> > >
> > > -	acomp_ctx_put_unlock(acomp_ctx);
> > >  	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > >  }
> > >
> > > @@ -1509,20 +1508,125 @@ static void shrink_worker(struct
> work_struct
> > *w)
> > >  * main API
> > >  **********************************/
> > >
> > > +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the
> > caller. */
> > > +static bool zswap_batch_compress(struct folio *folio,
> > > +				 long index,
> > > +				 unsigned int batch_size,
> > > +				 struct zswap_entry *entries[],
> > > +				 struct zswap_pool *pool,
> > > +				 struct crypto_acomp_ctx *acomp_ctx)
> > > +{
> > > +	int comp_errors[ZSWAP_MAX_BATCH_SIZE] =3D { 0 };
> > > +	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> > > +	struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> > > +	unsigned int i, nr_batch_pages;
> > > +	bool ret =3D true;
> > > +
> > > +	nr_batch_pages =3D min((unsigned int)(folio_nr_pages(folio) - index=
),
> > batch_size);
> > > +
> > > +	for (i =3D 0; i < nr_batch_pages; ++i) {
> > > +		pages[i] =3D folio_page(folio, index + i);
> > > +		dlens[i] =3D PAGE_SIZE;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Batch compress @nr_batch_pages. If IAA is the compressor, the
> > > +	 * hardware will compress @nr_batch_pages in parallel.
> > > +	 */
> >
> > Please do not specifically mention IAA in zswap.c, as batching could be
> > supported in the future by other compressors.
>=20
> Ok.
>=20
> >
> > > +	ret =3D crypto_acomp_batch_compress(
> > > +		acomp_ctx->reqs,
> > > +		NULL,
> > > +		pages,
> > > +		acomp_ctx->buffers,
> > > +		dlens,
> > > +		comp_errors,
> > > +		nr_batch_pages);
> >
> > Does crypto_acomp_batch_compress() not require calling
> > crypto_wait_req()?
>=20
> It actually doesn't. If the crypto_wait parameter is NULL, the API requir=
es
> the driver to provide a way to process request completions asynchronously=
,
> as described in patch 2 that adds the crypto batching API.
>=20
> >
> > > +
> > > +	if (ret) {
> > > +		/*
> > > +		 * All batch pages were successfully compressed.
> > > +		 * Store the pages in zpool.
> > > +		 */
> > > +		struct zpool *zpool =3D pool->zpool;
> > > +		gfp_t gfp =3D __GFP_NORETRY | __GFP_NOWARN |
> > __GFP_KSWAPD_RECLAIM;
> > > +
> > > +		if (zpool_malloc_support_movable(zpool))
> > > +			gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> > > +
> > > +		for (i =3D 0; i < nr_batch_pages; ++i) {
> > > +			unsigned long handle;
> > > +			char *buf;
> > > +			int err;
> > > +
> > > +			err =3D zpool_malloc(zpool, dlens[i], gfp, &handle);
> > > +
> > > +			if (err) {
> > > +				if (err =3D=3D -ENOSPC)
> > > +					zswap_reject_compress_poor++;
> > > +				else
> > > +					zswap_reject_alloc_fail++;
> > > +
> > > +				ret =3D false;
> > > +				break;
> > > +			}
> > > +
> > > +			buf =3D zpool_map_handle(zpool, handle,
> > ZPOOL_MM_WO);
> > > +			memcpy(buf, acomp_ctx->buffers[i], dlens[i]);
> > > +			zpool_unmap_handle(zpool, handle);
> > > +
> > > +			entries[i]->handle =3D handle;
> > > +			entries[i]->length =3D dlens[i];
> > > +		}
> > > +	} else {
> > > +		/* Some batch pages had compression errors. */
> > > +		for (i =3D 0; i < nr_batch_pages; ++i) {
> > > +			if (comp_errors[i]) {
> > > +				if (comp_errors[i] =3D=3D -ENOSPC)
> > > +					zswap_reject_compress_poor++;
> > > +				else
> > > +					zswap_reject_compress_fail++;
> > > +			}
> > > +		}
> > > +	}
> >
> > This function is awfully close to zswap_compress(). It's essentially a
> > vectorized version and uses crypto_acomp_batch_compress() instead of
> > crypto_acomp_compress().
> >
> > My questions are:
> > - Can we use crypto_acomp_batch_compress() for the non-batched case as
> >   well to unify the code? Does it cause any regressions?
> >
> > - If we have to use different compressions APIs, can we at least reuse
> >   the rest of the code? We can abstract the compression call into a
> >   helper that chooses the appropriate API based on the batch size. The
> >   rest should be the same AFAICT.
>=20
> All good ideas. Let me think about this some more, and gather some data.

Based on Herbert's suggestion, in v7, I have separated out the compress bat=
ching
API to a new zswap_batch_compress() that uses request chaining.
zswap_compress() exists in its current form with the only difference being =
that
I get the mutex lock once, in zswap_store_folio() to decide whether or not =
to
batch.

I will provide more details in response to your comments about exploring
smaller batches to address the zstd regression seen in v5 and fixed in v6.

Thanks,
Kanchana

>=20
> Thanks,
> Kanchana
>=20
> >
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  static bool zswap_compress_folio(struct folio *folio,
> > >  				 struct zswap_entry *entries[],
> > >  				 struct zswap_pool *pool)
> > >  {
> > >  	long index, nr_pages =3D folio_nr_pages(folio);
> > > +	struct crypto_acomp_ctx *acomp_ctx;
> > > +	unsigned int batch_size;
> > > +	bool ret =3D true;
> > >
> > > -	for (index =3D 0; index < nr_pages; ++index) {
> > > -		struct page *page =3D folio_page(folio, index);
> > > +	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > > +	batch_size =3D acomp_ctx->nr_reqs;
> > > +
> > > +	if ((batch_size > 1) && (nr_pages > 1)) {
> > > +		for (index =3D 0; index < nr_pages; index +=3D batch_size) {
> > > +
> > > +			if (!zswap_batch_compress(folio, index, batch_size,
> > > +						  &entries[index], pool,
> > acomp_ctx)) {
> > > +				ret =3D false;
> > > +				goto unlock_acomp_ctx;
> > > +			}
> > > +		}
> > > +	} else {
> > > +		for (index =3D 0; index < nr_pages; ++index) {
> > > +			struct page *page =3D folio_page(folio, index);
> > >
> > > -		if (!zswap_compress(page, entries[index], pool))
> > > -			return false;
> > > +			if (!zswap_compress(page, entries[index], pool,
> > acomp_ctx)) {
> > > +				ret =3D false;
> > > +				goto unlock_acomp_ctx;
> > > +			}
> > > +		}
> > >  	}
> > >
> > > -	return true;
> > > +unlock_acomp_ctx:
> > > +	acomp_ctx_put_unlock(acomp_ctx);
> > > +	return ret;
> > >  }
> > >
> > >  /*
> > > --
> > > 2.27.0
> > >
