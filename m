Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C07256C7C;
	Fri, 28 Feb 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736829; cv=fail; b=sBewtpYnMkQgKhxgAGvTWdoPWdVNpQWiCMH+lidJXE/pcRVFeQdZCG5stZlfYq5oY4zG6H6Ir5Sw4NokqGq8kXEgvwfM7TIG4BlsM0MpYDo5rvvHzcUzQoVItDfRSyER4XyuG/qSnLOdC1kcrExVG5dhqtPxO4Bz/18PcwUdYd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736829; c=relaxed/simple;
	bh=FR7VXhq7kJJhnDdXogb0kbltGNxPbQG5i1EfEqzgX2g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QsJSx2qCt5EsQDuebmEJY5Jko1p39/g8Uq3Kw3sW49YHwmXB64QonEmafat+Co1GGZDE//OjB3yipYyYr5qilQ0uu47JBlAPvY2UjR1Jg/hGIHdtLaLF+p9sWasUjuP3y06LO2kfLlENSz5GkT+1eLcFnrqMHybv72Hp8bjf2iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i47JWgpf; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i47JWgpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736828; x=1772272828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FR7VXhq7kJJhnDdXogb0kbltGNxPbQG5i1EfEqzgX2g=;
  b=i47JWgpfHBGqP2h8m71QZdoRQNt0I64MpBLV2iamDX17XzyjuTwLxAhe
   H7+7aJc+4+vquWfhUt5MPYNH1CXx9d6pxmFKtMGr+wk745mWXqempb3Tz
   4A+gzn3gjadsxSYBpCLzSNQM8uNPhVvBTLXCNodN49HAdYSwwuBBKoibr
   ZAdOhGA42ZnWwFleiXBvZvpWq5815o5pcxp57T1nlS917sE6PZ2/Sou9I
   eWfQy4Xu1zIVomZeDvGbFC+/0TR5ODw7tIZOwakzCYk5SasZJEBIAkMeO
   vmhl6uBHMyRfu7DwlDCobfxmoCzYnCQGUguTjhbU17m/6lmcdcf5Z/ylj
   g==;
X-CSE-ConnectionGUID: f+q/mnYhQnyv5Fa9MdY31Q==
X-CSE-MsgGUID: GRFIhvBoSEyxuiHYOAQzGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41911938"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41911938"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:27 -0800
X-CSE-ConnectionGUID: m47WACJ4Q/WYy0gale5nxw==
X-CSE-MsgGUID: 97+XO8wJRMavJVwY0pznGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="122238626"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2025 02:00:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 02:00:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0e5B5H6WNVQhyyoWO8jFainmurqs2pgvow4Zf/WI5PUxE8xQ1B1wvnx+hVtxrdJ2R2bgYx9vHsWIJcB2i57U42s3iYufUJLRTlQpFh1ELpGi9a/6HcRKDUXuFBnrLD2kFSPBjQhVM75xqZ62aqmauw3U/eJSJvIRasxr2zugM3IjPT5CFcw9a0QGCFf6bRD5ZkHg1rzVnseTtUxNVrKTwC8B3/UzrMq1nCTgJJ0AXEOhpuwhs3iX4oK3y1dsUyZKtG+SfhcCAJs/yAxxU/ThraBaW7Ppk92F1CVZbOzirndDZcfcWtCzHa8OPu4RlR9AI3aNfEn1JHdKdEj3aHi3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjFXpprxqMosk4BcvHyPTQhgah+sYbjBFVf6UOk6mfA=;
 b=sR2Ity9OeSx+PJlpDcHNvVkrK1T0Z3ad+Cf9EQFcHKH2BhJTChesCnx4AQTOHZlC+ehWhpG4gOUsYqEBhhv0cbk78SGozvZZqlLVcJzHiBIpcEP9vmcMie3dxpropgbvwGrjLRiIvapnA1xGLbu0Lf1SiaN9PZuL3+0+4f9GwEKfiFTMB3PmYPgc+w3mcuuM1Vtbtgy+frl0Jf5J+DMTOSud0BOHiskU9G3DCjrfy4coWLB6InUZhxM6QMypFHrbBglnzHBOFfSOPVOOTl45zhkbLC4nkLPApcfPCJuvdCK4ieNljG9hkOss2r73CMaf6ObZOFnVcthfH3593WWqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 10:00:14 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 10:00:14 +0000
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
Subject: RE: [PATCH v6 16/16] mm: zswap: Fix for zstd performance regression
 with 2M folios.
Thread-Topic: [PATCH v6 16/16] mm: zswap: Fix for zstd performance regression
 with 2M folios.
Thread-Index: AQHbeGfFTl/pqIzrhU2kP7T9pgXuirM6pheAgCGsBRA=
Date: Fri, 28 Feb 2025 10:00:13 +0000
Message-ID: <SA3PR11MB81204A08DD5F8E5C58EB526AC9CC2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-17-kanchana.p.sridhar@intel.com>
 <Z6UKQ04ClABSePLZ@google.com>
In-Reply-To: <Z6UKQ04ClABSePLZ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH8PR11MB8287:EE_
x-ms-office365-filtering-correlation-id: 4157f54f-9cd1-435e-b8c1-08dd57deb21d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?l0Ugx6I96E6w/QVrn0wJqbqmkBTFJmzgfgGr0yVWEC88DPhY1LkQrV3tSAY9?=
 =?us-ascii?Q?/nNGYnVftT4GOZN7EoWTk4/b77OcOcmuz7i5gffHv4rCOQVRTkmEdPqJg89f?=
 =?us-ascii?Q?kT3RU8jnxX1KyIm2fvISYiZ1rM5IEd2WIuI5H48p1Kiqw3c76Puf6hI8OP5n?=
 =?us-ascii?Q?TNsLF1WWpowljSZI6HV/WRcjjvNTdmY7oyGGN0+3yFaj0CkOoy2W3hvXdaZG?=
 =?us-ascii?Q?uMkT0y028eQk1iMZybaaLaBx2KxR93Dn+WyA9AfblhoXrhSbegpjHUA5xoJ0?=
 =?us-ascii?Q?R3eS596h3/Wce9kHiWqYxj5H6JnMmo+SALcHaktj6NaKJ2ZQYP/QHeePjfgR?=
 =?us-ascii?Q?DNBh0knB+HBmVDHMgfoBCyW6qMZOZlA9iG52D7iXFApZA3pNwxLk73N/6qr+?=
 =?us-ascii?Q?47mOtMQyW1w5As8FDU8lr3x/ed8m1aCGPzf+QLFn/UT5w95tzhpPs43qw7OA?=
 =?us-ascii?Q?gnXokm3jvr1i4dLDzq+VYyDoto8N+8mEFC12Ub3uoDCv16WvI3zmxItKTX7h?=
 =?us-ascii?Q?PyvPXRp8Qjfr+zNWXGCUzRPfl5a0A6oFsEBdXxVJ/koIHgrpIhiew76UNN8n?=
 =?us-ascii?Q?Z7ymGwZAcJ5Dg+sQ+CTixaKHRnRwUdZ0jRQqhQijAG/c29D+VZsZJxAobI4p?=
 =?us-ascii?Q?yHA12eqqkkh9Z73KNDJH7s5Z463Z7R/lFTKxIJdV/Lm8P4u4JlHMwwKGv2wK?=
 =?us-ascii?Q?fCfEpFX6ESjvQ4I745/1H/YmxFnrzg65gEAK7qt5rmTdp8Uhw5bLyG+IUS8E?=
 =?us-ascii?Q?gEFQNVf5CS+WAjdnA1zQDA2Qi4Nc4RH26MzVWwdjsCkV2NTWrHoldCriuevO?=
 =?us-ascii?Q?qHHjLp2i8B9HA3wgTAuq8AcCNhN3P9pIWUN7s99T8BphAgFsAYkxATHa3JXb?=
 =?us-ascii?Q?gf+9l4n+rFmtRITzfDhiasFPPnTntcCwh9HVwZBEBxpccR+Bk5UXkxnQhDyX?=
 =?us-ascii?Q?pjQAHqsgOYmgm2tm8XpkYU9pasFr/Nan36wtzOSB9AwTmH0jhxUruYsAWj2t?=
 =?us-ascii?Q?EHZGzIWcQisM4Dmutwt9D82oGjHFJNmL+1J457zrlPOYvCFppq/duVVtFeKH?=
 =?us-ascii?Q?br+kG4yiaSJMxx+kppHcuUnXZvyObOebdBumSCNVFdeLJrg4kNM5dNOQbPC2?=
 =?us-ascii?Q?fTZMOG/maipYoAehD7uj3BKhhTaluPGRB9fGtXrWvlBFNFkm8ww7PO5RTwHP?=
 =?us-ascii?Q?FBWN7VidcVXh5dhYeBI7KmUgBriUuA2wYDb/esmUOqTHDAKscdxtaXCfEl1y?=
 =?us-ascii?Q?SWVqywGgDd0SkRgZrcWVGuwa+QIWG3WzdQcLz7Y8a+8azZWtEruMsn+s54B4?=
 =?us-ascii?Q?EgNmnd8p17hTqFiLZbRzvLufXB7JJE0ME+kvkVrNWChmZXi8ACGrSgfdh2rf?=
 =?us-ascii?Q?B7CTF8w5FZspK4kBIxLBMmULSroK7lfn95Hvqkqt8cC5hJkR4y7cS1kqDZrk?=
 =?us-ascii?Q?rqR35agjLQMamrqCXeFvBW/k7aGXnyIl?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/F/6WACLYUQJaQp+R7/4NbDlLZpi52ozo18l17+Z0ZXwDVMs0RaIB2fhnO5Y?=
 =?us-ascii?Q?yURW8BRnCycuRmoZpwVYOaBDtgPYNig9lwZKxYWwBjiFK4PODJPcfvEqLm4c?=
 =?us-ascii?Q?BVJFWloojnMiPy0R/ScVqQPskA/u2zdJyoyRSAFvWFSS4aNc4rNIe3URkkna?=
 =?us-ascii?Q?TkT0VRvAQfcPqscCQvAW4+pUaeJ6mqqjy4foumCmxwVuLwXAoEC/GxkzjFAQ?=
 =?us-ascii?Q?o7BGWgfky0SvlXSIFuuxNp1dtu8yYYG/nVhdPTj+lPpgoeXeRhxOZ7KZDqxS?=
 =?us-ascii?Q?ADlDqRFessDL/zt60mrv7k0DWm6Barnbul9ikr+FHvjrYm3omc4k7FREnNN/?=
 =?us-ascii?Q?PBRzCSutUZq1MtYXilQgCMJBTSkYh0vdiUThnQEcVeU2X6BQGcUEvi4q3nxm?=
 =?us-ascii?Q?BkrRcEq7+K3WGiW34NXkYzPKC+LtUQ/zpgQzdg4KLs6JQvJxDwvC2M+AFVPz?=
 =?us-ascii?Q?J9Kxlp8kBmlcA6bB9IDW/N7zMH8dhziibnjTnPGje39c1i2LB5VmjeEOWU7L?=
 =?us-ascii?Q?iWst5aYp/SRD2x4mjtLU5O6/smOgypKwPk7VmKNCZfcE3sSyshfr67Yc0H1k?=
 =?us-ascii?Q?UulaDvsrYJjDX3jfxu0ZgKnlStCj8SCLho811dfR3O4r+P58ft0TyvbHhVkf?=
 =?us-ascii?Q?Gpn7irzs8Z38Pz5CAsmFuB3zffhtjZhWjQKd8ty7Gro+gTIaa3zgmHDENnfA?=
 =?us-ascii?Q?kEm/8c6LJqMy2owFvlcHe5in5T2/LcE0WH62oCwalxnbM7oDR7Rpv5O9L9sr?=
 =?us-ascii?Q?qqrxAnq5wUJVTwZ0+4BD+COqrWxveyEgXbeYZRPjSXNLxxRV4Ar4XJ49pZfF?=
 =?us-ascii?Q?Tin0Mnmy3zjdH4W1JzGonX6Lq5oMwNppp+LnA/gDVVulVYVrBg+HGxla6mvN?=
 =?us-ascii?Q?aRz8syWRNr6AVKWw97y8QDPrn3XLqZ1WSSuydNUGDJi15AboW+V17SYb4fKa?=
 =?us-ascii?Q?GcNSlXBInu6yBSEVxSzTOlhgSpPWxdBGoPq+mW829FSYjSe+12XqXoQZ27/F?=
 =?us-ascii?Q?ivQR2A1hCTbV4/t0toGoAwY6t6G0KroxnRbv6XyrDVviuOoXrv1bbEuMYPtY?=
 =?us-ascii?Q?o67NTljeGStxqZL39vzBSbAVxvSAiSX2jKgtOwAIK8f/zSgRmJLDsQzHLqVJ?=
 =?us-ascii?Q?rVmCMu419pvSAMYpUxgGgYcbLii3hPZde47ZMk4H/gIsDvJwx+/dsotVudqo?=
 =?us-ascii?Q?KdHnmq7d3pBs7uJdio7ZQc3b9EpgBPXXlugT8VNLZQtWY06MeyT55VkdGVvv?=
 =?us-ascii?Q?gdv9v5AuBDJZXlqdDzCPX0DkoJd5GQOJGc5rdfM+S1CZaNl+kwOBsK8f7ZgT?=
 =?us-ascii?Q?AuauKltgOo+SRSMg0GZDpvpYCd3rmnvCg7Y4kGKizoQbsgcajuVDeJ/uDaX2?=
 =?us-ascii?Q?7e6Z4Or4qdKbtV1tTFMb97IFJ9IT+s0XbRgHEvNF1FG4mASQLJfc/rxxUN1N?=
 =?us-ascii?Q?K2Hb7o3zNOi5bxbRGkrAur+xdobfwwyEApA8rA2MzYBZ/5ME9TB1yKNnUfmI?=
 =?us-ascii?Q?KbvaNfeI2aHSRCUO/XAdzp6iIzMtLyKVXgcrUpIGrhiW18qLOVkLwLTgHxyz?=
 =?us-ascii?Q?gvk4GgNXJvomvPw7hdAJfPWPtWP68NNTH3CPYdXTjvecNYg/0V7iT7kgRIAs?=
 =?us-ascii?Q?Mw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4157f54f-9cd1-435e-b8c1-08dd57deb21d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 10:00:13.9023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PR9k3d2hwB/7oOFK52THJXKNOvWmUmwjOfPwkfoWsNhiDRR2OZo/b8uWuzgKvGLq7U6uD9oiMae/c+eMxyktPDz1GOuKkCZlJxWJo+sYS7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com

Hi Yosry, Nhat,

> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, February 6, 2025 11:15 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v6 16/16] mm: zswap: Fix for zstd performance
> regression with 2M folios.
>=20
> On Wed, Feb 05, 2025 at 11:21:02PM -0800, Kanchana P Sridhar wrote:
> > With the previous patch that enables support for batch compressions in
> > zswap_compress_folio(), a 6.2% throughput regression was seen with zstd
> and
> > 2M folios, using vm-scalability/usemem.
> >
> > For compressors that don't support batching, this was root-caused to th=
e
> > following zswap_store_folio() structure:
> >
> >  Batched stores:
> >  ---------------
> >  - Allocate all entries,
> >  - Compress all entries,
> >  - Store all entries in xarray/LRU.
> >
> > Hence, the above structure is maintained only for batched stores, and t=
he
> > following structure is implemented for sequential stores of large folio=
 pages,
> > that fixes the zstd regression, while preserving common code paths for
> batched
> > and sequential stores of a folio:
> >
> >  Sequential stores:
> >  ------------------
> >  For each page in folio:
> >   - allocate an entry,
> >   - compress the page,
> >   - store the entry in xarray/LRU.
> >
> > This is submitted as a separate patch only for code review purposes. I =
will
> > squash this with the previous commit in subsequent versions of this
> > patch-series.
>=20
> Could it be the cache locality?

It is possible, since there are more LLC-store-misses in v6, patch 15 (that=
 has
the regression) as compared to patch v6 16 (that fixes the regression).

>=20
> I wonder if we should do what Chengming initially suggested and batch
> everything at ZSWAP_MAX_BATCH_SIZE instead. Instead of
> zswap_compress_folio() operating on the entire folio, we can operate on
> batches of size ZSWAP_MAX_BATCH_SIZE, regardless of whether the
> underlying compressor supports batching.
>=20
> If we do this, instead of:
> - Allocate all entries
> - Compress all entries
> - Store all entries
>=20
> We can do:
>   - For each batch (8 entries)
>   	- Allocate all entries
> 	- Compress all entries
> 	- Store all entries
>=20
> This should help unify the code, and I suspect it may also fix the zstd
> regression. We can also skip the entries array allocation and use one on
> the stack.

I tried the above, and additional approaches to unify the code, and all of
them cause a regression in zstd throughput and latency in the usemem 30
processes experiments:

1) Operate on batches of size ZSWAP_MAX_BATCH_SIZE, regardless of
     whether the underlying compressor supports batching. I tried this with=
out
     and with upfront allocation of all entries.
2) Unify post-compression zpool malloc, map handle, memcpy computes
    done in zswap_compress() and zswap_batch_compress() by moving them
    to a procedure and calling this from both these functions. Tried withou=
t
    and with inlining this procedure.
3) With the v7 changes to make the acomp_ctx resources' lifetime be from
    pool creation to pool deletion, I wanted to make another functional cha=
nge in
    acomp_ctx_get_cpu_lock(), as described in the code comments in v7.
    However, I found that making just this change in zswap_decompress() cau=
sed
    zstd regression:

     do {=20
                   acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
     } while (!acomp_ctx);

		/*
		 * If the CPU onlining code successfully allocates acomp_ctx resources,
		 * it sets acomp_ctx->initialized to true. Until this happens, we have
		 * two options:
		 *
		 * 1. Return NULL and fail all stores on this CPU.
		 * 2. Retry, until onlining has finished allocating resources.
		 *
		 * In theory, option 1 could be more appropriate, because it
		 * allows the calling procedure to decide how it wants to handle
		 * reclaim racing with CPU hotplug. For instance, it might be Ok
		 * for compress to return an error for the backing swap device
		 * to store the folio. Decompress could wait until we get a
		 * valid and locked mutex after onlining has completed. For now,
		 * we go with option 2 because adding a do-while in
		 * zswap_decompress() adds latency for software compressors.
		*/=20

My main learning from these attempts to try alternate approaches to resolve
the zstd regression and to unify common computes into distinct procedures
that zswap_compress() and zswap_batch_compress() will each call, is this:
zstd is extremely sensitive to any and all compute overheads. The above
approaches yield approx.. these zstd latencies with 64K folios quite consis=
tently
(I will summarize the mm-unstable data in v7):

Total throughput (KB/s)              6,909,838      =20
Average throughput (KB/s)        230,327
elapsed time (sec)                       94.58
sys time (sec)                               2,358.36

The v7 implementation of zswap_store_folios() consistently gives better lat=
ency:

Total throughput (KB/s)              6,939,253     =20
Average throughput (KB/s)        231,308
elapsed time (sec)                       88.64
sys time (sec)                               2,197.54

My main goal in v7 has been to not regress zstd by introducing compute
overheads, while deriving the benefits of batching with request chaining,
while trying to preserve the v6 structure of zswap_store_folio() that aims
to strike a balance between:

1) Common code for batching and sequential.
2) Making that common code "behave" sequentially so that zstd does not
    see a latency regression.

I would appreciate it if you can review the v7 implementation and let me
know if this would be acceptable.

Thanks,
Kanchana
