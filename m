Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A7255E58;
	Fri, 28 Feb 2025 10:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736827; cv=fail; b=aKGdWYliUglMZygUfhxBUWe1NiVkbQFFFSGfsWB3IVJcj26kvi1o4C48zGFj7XhzwUKmKQ5GrUWRaTdzqZBfFYU03v3nGjjKXGvSFhbaHXlzqiGVUvgNqxoxhlvKAzWN6X00oBTi1VO17TuzJfrsXcJBuSTvdibiwnLjnYeDiew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736827; c=relaxed/simple;
	bh=syfRXMOiP86rn9nfboIzF7X9FVdIKVKyoQddqlH0wFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PhnpxmNsCmoIvgUKgpwXxav5g0F6eYACyxLHGQSH23GdBS+4TI9gbcYR7+UueYnGw+ogxofsV5N/u1KTksH6yKOL/XylLTLctrGg265s6BZ0VT+MZHwuU1j5tUtkwSO5l39rlT3qTGX9S/Lyq6kCQE7NA9wWG7h9Oo52twRPP70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0Ye68fv; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0Ye68fv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736824; x=1772272824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=syfRXMOiP86rn9nfboIzF7X9FVdIKVKyoQddqlH0wFE=;
  b=H0Ye68fvwOSAj5ZfugpyyuUk3bosPLAZjktF/2d78JyGKJg8QFq90Xz8
   L1uIFAfyZ2mC4ZLfT2i4SOHdzeyFVr7BnD7lRWhp4VWnhHd4ca7stRiG1
   RNKZQTdWPKHcvSxNzPElg6xibZKj7Ori1pSbF1s0oeOuy6b/XXm4tIuhV
   +/aS127OXHemj5qQgjuzxEgam6m4YRN/Dbn6bVEYgKjr0nsC8SjNxgVu6
   DYLQJyYRVXpZ65CB9h7xE1il8Wz7wNG7VssaRyzwWdcZjJf0AAyKnJr49
   ejBZWifB6WQOMhpklSC2pQr9XVPi6dkt40goBlcfSzaWtwpmqEt09mf/D
   A==;
X-CSE-ConnectionGUID: w19vn4DYQBykndSHhI6Jaw==
X-CSE-MsgGUID: 106n94TaTL2tB27RtYtfww==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41911924"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41911924"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:23 -0800
X-CSE-ConnectionGUID: 4ALcXGuEQMK1/XIaalc5Yg==
X-CSE-MsgGUID: ZYhIbvXMTwCf4O2GOgzT0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="122238592"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2025 02:00:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:22 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 02:00:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbWPpJwNUpmnjZ5Eh6iduGqyPlKAI5CY/uDb7T0LFLM18ZbfftUXT75waIWXiefXqDAlqk4U3tFz3oqx+Vm3KdkxcbUTzFRVbPsL1Y2O+LQA/LUTRGiNI9LGi5RJz3EQNjA/Q46H5csIo5L/IZggaKtvMkvpATf9mKs9vNtq1hA2pT8bUa2ZKVBiDUkhUI0hOm/7JdXVyU6krRStb6trfE/5HfohOny+JvsgxXK5R+4CUeq9LzywTGId6ewQttYkTLSUEPD59Gmzf/xrCcrnYNYEgm751QUwLuMf0IFdamr9B3e8svyr7B9AhvOSLVCoQaOHQf1zHvBxTZENmFm+IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXFMNOOvQGJG+wPY5jIiH6+MuAZuhf0GH980GMwuAHE=;
 b=ph6OVAd0GRtKHvCl44aHN2wUPB3915IH+6BfLm3GH2UlVgg5c2LK8dRjFJ9hbrKocSFzXese/gMurOd2Fy+2gp2Vc/Tcuq3LosiDIUDIpeQLadY5laOsT2NNReuu3kc65sETb2kqQ9DJxqKw6ckztcD2p8cC88/4N5aHbOJwHKtcXnG56Trvmfj0SgQ1VTAzj4eoPVBHtGa8IdImmH12z7RW6XA68Roxl0jS0b/jSoNEPCJoX7YdCWcE0gt1KNEKhG69MWHSCr6qquKkTJvcCCvs7GR6CUCoCpBG69S56DwnahARVEzHTL7+2IAjhNJdIEffDFZpV65BirsJIzVgcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 10:00:04 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 10:00:04 +0000
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
Subject: RE: [PATCH v6 12/16] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v6 12/16] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHbeGe+JgOkdecqMU+L+fU6UmgJ1LM6oIOAgCGsIoA=
Date: Fri, 28 Feb 2025 10:00:04 +0000
Message-ID: <SA3PR11MB8120AF70EF3C24DA43C2699BC9CC2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-13-kanchana.p.sridhar@intel.com>
 <Z6UFlV2B47vgpXgt@google.com>
In-Reply-To: <Z6UFlV2B47vgpXgt@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH8PR11MB8287:EE_
x-ms-office365-filtering-correlation-id: 94501891-7324-4f9d-a919-08dd57deac90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?+hmSVi2219NhSO4WbUNpxEigWI/nwkTlSuuz+B8Q/650oS0EIboWA5gH6M?=
 =?iso-8859-1?Q?/ZG1xDTem+K2n++jXnFEnfKpO6MXs2MzVNGxde7Mj1Xt7gURRJpEVvTffG?=
 =?iso-8859-1?Q?EqeNsY6EdU3dQHbua6YxS9WIswmcIdKyv0apJYF9tcU6kYFd6P4BHmqlfp?=
 =?iso-8859-1?Q?pZu97symELorV0vloRDCWbv2wpkHusIHA1x9KXhSSNH7KYSumCa65o217p?=
 =?iso-8859-1?Q?oviKQ4DnFXZyxbo9Ckaar2sLdw/QMOm3nyha8B0F/F3oK/WNP/H+XLmm07?=
 =?iso-8859-1?Q?xb6eAUOY8lZNBGEIHBhQBTh3vVHapg4sxGXy9Pnsb+glAtFGTFQXK5IpVF?=
 =?iso-8859-1?Q?KQHEfaMZEAJl9wXuAQWfJF8EOpRV+EIAcrdvR3AUQQeHBMBmwVFbPRavO7?=
 =?iso-8859-1?Q?r1KA+bK+jBXBzF5JkoKdlc7a1GN5YFpVq4oHupILBJnaeQ6mvHw4K02dfi?=
 =?iso-8859-1?Q?pZG9wZ23BvSrA7OMqF/LfAxpKe534K6RWBHmhHfag6rAVmLct8Z8N46dDL?=
 =?iso-8859-1?Q?Fu+jtMcvXYrrdU7gorn5P6uB4G8cbdgvzyVlWN0opSCxtvQmLamQ2jrWPU?=
 =?iso-8859-1?Q?5OHarqmFNaK+uNK+2fveyNXO0mEwvl4J3je9NBVKyl0Y6hiDDi1REfv671?=
 =?iso-8859-1?Q?S6r+CafWL/G1n1nEGo4BxVOWey1N7J8pEzdYTqpCBx+kaiAdaX8WmPTixO?=
 =?iso-8859-1?Q?BKLT3xJlPNMjwQxpRWo7en68OMor0Tafl4Ehlf8jEo1hma32B72w2eY/Eh?=
 =?iso-8859-1?Q?aQcoQRRAgT+QhK3XQMZzk+fiOnika9Drq1KkqyUYFoMtRQI9swj913U/kS?=
 =?iso-8859-1?Q?i2lK55NBcpSGoPIkc/U6/ABkKGYr53I2F1XIOO1i1avDvrAze6J0wZILdw?=
 =?iso-8859-1?Q?u8N/4tWytDs48wNqyrELStaA2iqSpKGA67pxngOW77Ageo9kFda15tTYPb?=
 =?iso-8859-1?Q?DQvGWirGFNhYT3GibB5TCguMAq/CgaTjOmmcU16c6q4/dY07pheI7asASg?=
 =?iso-8859-1?Q?pvqEK0EVPc3OfUOTVo+El88E9zwnZpL4oL3DmNwuwzIDDv+4eOnXL3HQKD?=
 =?iso-8859-1?Q?ad6Yy8IuwRn89OVtlPrcLGFoXMnDQ9ZIRNIkbUoJp5P5WJNIUv6rV0qs8u?=
 =?iso-8859-1?Q?QEch4BLb6HpgEZ9pO31veInD3rS5MZlYWCt0AyzKr9j+aT8Sj4v/n8jYf2?=
 =?iso-8859-1?Q?hbTtwO5yInJfk9wV5gGkwM8F4QEqTKjeTkbnWfTTnrnKSuZBCiQ2KnnzeI?=
 =?iso-8859-1?Q?/hy+bIQmBoTMCvWcpnyR5JHqSmoC+hFEwEZYZZvXuT6I9vsM4lnLF2+2Q0?=
 =?iso-8859-1?Q?HleG0d7P2mzXTwglKMeVKsRDhUmxnujB0wUaz5LjqyBK/a30Gr71W59dhJ?=
 =?iso-8859-1?Q?lknvNNnQxJgAQC9KVJ66CrnNz1eaRfPLwh1GfYtemdaCCQDBKngvg97kYC?=
 =?iso-8859-1?Q?NsavK+OOfA/4YflUGqTuX3I7N1lDvoqMdE5Fm+5tUD492w41IKWm0L9ZEQ?=
 =?iso-8859-1?Q?iTVRaFjuaGJRZ4Jz3OhR6P?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RqQlpZpxwEzBo7I3TVr7gkOZ8mFAzarnwfQYpFC5bXv1C16AjbRgziGk8L?=
 =?iso-8859-1?Q?9BcaFx6bXw5/wmsYWc+U24hrM3vRpf4R5Zq9itiWRzCzN4CRPN/Erzy2l0?=
 =?iso-8859-1?Q?au+PSXJd/gjalRNyzLZql4VONBxAnYW9tqmETQ+ciHBoRBbiIqoAfDMc85?=
 =?iso-8859-1?Q?TWclAdEAOnIhBPBWBcnbhCOEjP+92VZREbDBqJKvgAnOEQn93j4Y8weQrq?=
 =?iso-8859-1?Q?PHfzKI03fTm+0SjMvA0F2Mxp3VVEoRJNi/mM6g6vMRQXAYGdRuDCi268Ux?=
 =?iso-8859-1?Q?hNaA+RSxZUOapyF8e28zWCQpAeKfFbZUpbVpnpzxT7KdD5hy+SEbZ9b4OR?=
 =?iso-8859-1?Q?kWpMpnsmkfXHtPqm30N4lwsKIK+eB2vpE6n1h7mID28/sud2JPUBqeVWj/?=
 =?iso-8859-1?Q?ZVJHKwEyqYxgrcTDKtqFmxPA2r+bMR/m+vIsLJ7R+j4FDR8zmst4oQ2ysj?=
 =?iso-8859-1?Q?Ders4Va2W9PX4TiUg0kWiptgo509807BecWBRNeSTOc4Di50j14fAfneFH?=
 =?iso-8859-1?Q?FvzenKrAtv56ULMwxSzmrCV+K1tTdG7E8btFsjT7SwSTteaoFxDMjr/3u8?=
 =?iso-8859-1?Q?NLzOdiaPxRJvotnRLFIMNnTSKIs1nNKglMqQGh2/mlSBWrUnjVjFLc0X1s?=
 =?iso-8859-1?Q?Jluk+PrGgqBneLiUnB+HWWJObZnhXYuBHNUuD0wjHkGACEISnwu9niAQjd?=
 =?iso-8859-1?Q?I9hJiaRl6O/a8PEcwOUJmvNMPYNxr0cJhzarkflnQRkM5NofIdZVxFNN9v?=
 =?iso-8859-1?Q?8lg4KWBFzG6QcX6kyTTcjmadYnP70Pze7mv0bdMZjp9luf/Qsa0vxqL3o5?=
 =?iso-8859-1?Q?MiEO/Xkj8zd+6VJ/Fq7R0d/uED3aoRaXrJ+XxJcm7klzO+Wdxm8jyElR8K?=
 =?iso-8859-1?Q?vgKROswo3yrES0drR9hvrqJnGZ7NGWFQPvLfu4xewStsjfK4F9W7zm5+sc?=
 =?iso-8859-1?Q?u9YVKxNVPlk24eDLrmDvoop532vzyklSTzlO24FtA/CkdJIduyUqNVB+JQ?=
 =?iso-8859-1?Q?0KNqGv5iYnc+29E6iKhzwM0GDlphRVcAbVa4YZw1ZeDlVeXjDmSF6arSAJ?=
 =?iso-8859-1?Q?wQhf3OSS/XrJ7M+F+r/B3Gf0HA0lv5tSCjOAsKsroappdr7QIl1R7meUpl?=
 =?iso-8859-1?Q?gKwmIj/h4UVTCv5pT4/mT9+K5ooHt6wezs7u3/u0F4k2fcpf/uWxAQaf2J?=
 =?iso-8859-1?Q?0sW1+qp8GhSSFk/DG0cnkoQIvV3QMvU46WuVqmv/EgGaWWGEkzt2puz8HA?=
 =?iso-8859-1?Q?ct0p+ay9RX4kKlvfqVl6XCqz5K4D7LTfCAB1+ADS/pOh2QEWhfTC1a7vuG?=
 =?iso-8859-1?Q?hh2PUQrqnMVt9LIg8DcVCP7NC/h4Xn8c3DbfARKhSgc3VeaxiT4HXTZK7D?=
 =?iso-8859-1?Q?KF0C4cwI7YMDDRAf6kkLj9zac/14DwVmx2TkdsHJ5uxhyBkBUqmFcFNd6z?=
 =?iso-8859-1?Q?xmAuljSsJb/FcRgCw7PRbcGRpYakHhdmTgWpikiMkESgod1t16GEkgEnPR?=
 =?iso-8859-1?Q?u0eQyvA/tKyNssJ0e5HxvX94880jeZwm/7fVfsgGt/cQWcFkIGzpqNJCgc?=
 =?iso-8859-1?Q?8m1CjdhZw+fMhSPoqeyBKt0+o/ALAM76a2SfGYtgSP4wrfyo4mIdyvCCXB?=
 =?iso-8859-1?Q?00Udmor7v2dwoa9qeiq37EQXDl4C/ig9PsjsvakgHIGitvkOzadWkdkQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94501891-7324-4f9d-a919-08dd57deac90
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 10:00:04.5647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Ob7iGHFIT/N/l1F5sCt8lx5KewAIkLIXINKGuUWzJn3cAAQhpjqVj/fqO/8He4oKF3RoUhSIjFlXw3Zo8RPFR8STT2U5OLDe7AoC2/kzsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com

Hi Yosry,

> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, February 6, 2025 10:55 AM
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
> Subject: Re: [PATCH v6 12/16] mm: zswap: Allocate pool batching resources=
 if
> the compressor supports batching.
>=20
> On Wed, Feb 05, 2025 at 11:20:58PM -0800, Kanchana P Sridhar wrote:
> > This patch adds support for the per-CPU acomp_ctx to track multiple
> > compression/decompression requests. The zswap_cpu_comp_prepare() cpu
>=20
> nit: s/cpu/CPU

Thanks, this is fixed in v7.

>=20
> > onlining code will check if the compressor supports batching. If so, it
> > will allocate the necessary batching resources.
> >
> > However, zswap does not use more than one request yet. Follow-up
> patches
> > will actually utilize the multiple acomp_ctx requests/buffers for batch
> > compression/decompression of multiple pages.
> >
> > The newly added ZSWAP_MAX_BATCH_SIZE limits the amount of extra
> memory used
> > for batching. There is no extra memory usage for compressors that do no=
t
> > support batching.
>=20
> That's not entirely accurate, there's a tiny bit of extra overhead to
> allocate the arrays. It can be avoided, but I am not sure it's worth the
> complexity.

You're right. The v7 commit log has been amended accordingly.

>=20
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 132 +++++++++++++++++++++++++++++++++++++++--------
> ------
> >  1 file changed, 98 insertions(+), 34 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index a2baceed3bf9..dc7d1ff04b22 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -78,6 +78,16 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/*
> > + * For compression batching of large folios:
> > + * Maximum number of acomp compress requests that will be processed
> > + * in a batch, iff the zswap compressor supports batching.
> > + * This limit exists because we preallocate enough requests and buffer=
s
> > + * in the per-cpu acomp_ctx accordingly. Hence, a higher limit means
> higher
> > + * memory usage.
> > + */
> > +#define ZSWAP_MAX_BATCH_SIZE 8U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -143,9 +153,10 @@ bool zswap_never_enabled(void)
> >
> >  struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> > -	struct acomp_req *req;
> > +	struct acomp_req **reqs;
> > +	u8 **buffers;
> > +	unsigned int nr_reqs;
> >  	struct crypto_wait wait;
> > -	u8 *buffer;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> >  };
> > @@ -821,15 +832,13 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> >  	struct crypto_acomp *acomp =3D NULL;
> > -	struct acomp_req *req =3D NULL;
> > -	u8 *buffer =3D NULL;
> > -	int ret;
> > +	unsigned int nr_reqs =3D 1;
> > +	int ret =3D -ENOMEM;
> > +	int i;
> >
> > -	buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!buffer) {
> > -		ret =3D -ENOMEM;
> > -		goto fail;
> > -	}
> > +	acomp_ctx->buffers =3D NULL;
> > +	acomp_ctx->reqs =3D NULL;
> > +	acomp_ctx->nr_reqs =3D 0;
> >
> >  	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> cpu_to_node(cpu));
> >  	if (IS_ERR(acomp)) {
> > @@ -839,12 +848,30 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  		goto fail;
> >  	}
> >
> > -	req =3D acomp_request_alloc(acomp);
> > -	if (!req) {
> > -		pr_err("could not alloc crypto acomp_request %s\n",
> > -		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> > +	if (acomp_has_async_batching(acomp))
> > +		nr_reqs =3D min(ZSWAP_MAX_BATCH_SIZE,
> crypto_acomp_batch_size(acomp));
>=20
> Do we need to check acomp_has_async_batching() here? Shouldn't
> crypto_acomp_batch_size() just return 1 if batching is not supported?

Good catch. This is fixed in v7.

>=20
> > +
> > +	acomp_ctx->buffers =3D kcalloc_node(nr_reqs, sizeof(u8 *),
> GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffers)
> > +		goto fail;
> > +
> > +	for (i =3D 0; i < nr_reqs; ++i) {
> > +		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2,
> GFP_KERNEL, cpu_to_node(cpu));
> > +		if (!acomp_ctx->buffers[i])
> > +			goto fail;
> > +	}
> > +
> > +	acomp_ctx->reqs =3D kcalloc_node(nr_reqs, sizeof(struct acomp_req *),
> GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->reqs)
> >  		goto fail;
> > +
> > +	for (i =3D 0; i < nr_reqs; ++i) {
> > +		acomp_ctx->reqs[i] =3D acomp_request_alloc(acomp);
> > +		if (!acomp_ctx->reqs[i]) {
> > +			pr_err("could not alloc crypto acomp_request
> reqs[%d] %s\n",
> > +			       i, pool->tfm_name);
> > +			goto fail;
> > +		}
> >  	}
> >
> >  	/*
> > @@ -853,6 +880,13 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	 * again resulting in a deadlock.
> >  	 */
> >  	mutex_lock(&acomp_ctx->mutex);
>=20
> I had moved all the acomp_ctx initializations under the mutex to keep
> its state always fully initialized or uninitialized for anyone holding
> the lock. With this change, acomp_ctx->reqs will be set to non-NULL
> before the mutex is held and the acomp_ctx is fully initialized.
>=20
> The code in the compression/decompression path uses acomp_ctx->reqes to
> check if the acomp_ctx can be used. While I don't believe it's currently
> possible for zswap_cpu_comp_prepare() to race with these paths, I did
> this to be future proof. I don't want the code to end up initializing
> some of the struct under the lock and some of it without it.
>=20
> So I think there's two options here:
> - Do the due diligence check that holding the mutex is not required when
>   initializing acomp_ctx here, and remove the mutex locking here
>   completely.
> - Keep the initializations in the lock critical section (i.e. allocate
>   everything first, then initialize under the lock).

Thanks again, another great catch! In v7, I have attempted to simplify
the acomp_ctx resources allocation/deallocation vis-=E0-vis CPU onlining
and offlining. The main idea I have implemented is that the lifetime of
the acomp_ctx resources should be from pool creation to pool deletion.
The v7 code comments and commit log provide more details. I would greatly
appreciate your review comments on this approach.

>=20
> > +
> > +	/*
> > +	 * The crypto_wait is used only in fully synchronous, i.e., with scom=
p
> > +	 * or non-poll mode of acomp, hence there is only one "wait" per
> > +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> > +	 * there is at least 1 request per acomp_ctx.
> > +	 */
> >  	crypto_init_wait(&acomp_ctx->wait);
> >
> >  	/*
> > @@ -860,20 +894,33 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> >  	 * won't be called, crypto_wait_req() will return without blocking.
> >  	 */
> > -	acomp_request_set_callback(req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +	acomp_request_set_callback(acomp_ctx->reqs[0],
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  				   crypto_req_done, &acomp_ctx->wait);
> >
> > -	acomp_ctx->buffer =3D buffer;
> > +	acomp_ctx->nr_reqs =3D nr_reqs;
> >  	acomp_ctx->acomp =3D acomp;
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> > -	acomp_ctx->req =3D req;
> >  	mutex_unlock(&acomp_ctx->mutex);
> >  	return 0;
> >
> >  fail:
> > +	if (acomp_ctx->buffers) {
> > +		for (i =3D 0; i < nr_reqs; ++i)
> > +			kfree(acomp_ctx->buffers[i]);
> > +		kfree(acomp_ctx->buffers);
> > +		acomp_ctx->buffers =3D NULL;
> > +	}
> > +
> > +	if (acomp_ctx->reqs) {
> > +		for (i =3D 0; i < nr_reqs; ++i)
> > +			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> > +				acomp_request_free(acomp_ctx->reqs[i]);
> > +		kfree(acomp_ctx->reqs);
> > +		acomp_ctx->reqs =3D NULL;
> > +	}
> > +
> >  	if (acomp)
> >  		crypto_free_acomp(acomp);
> > -	kfree(buffer);
> >  	return ret;
> >  }
> >
> > @@ -883,14 +930,31 @@ static int zswap_cpu_comp_dead(unsigned int
> cpu, struct hlist_node *node)
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> >
> >  	mutex_lock(&acomp_ctx->mutex);
> > +
> >  	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> > -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > -			acomp_request_free(acomp_ctx->req);
> > -		acomp_ctx->req =3D NULL;
> > +		int i;
> > +
> > +		if (acomp_ctx->reqs) {
> > +			for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +				if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> > +					acomp_request_free(acomp_ctx-
> >reqs[i]);
> > +			kfree(acomp_ctx->reqs);
> > +			acomp_ctx->reqs =3D NULL;
> > +		}
> > +
> > +		if (acomp_ctx->buffers) {
> > +			for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +				kfree(acomp_ctx->buffers[i]);
> > +			kfree(acomp_ctx->buffers);
> > +			acomp_ctx->buffers =3D NULL;
> > +		}
> > +
>=20
> The code here seems to be almost exactly like the failure path in
> zswap_cpu_comp_prepare(), would it be better to put it in a helper?

Makes sense, and addressed in v7.

>=20
> >  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  			crypto_free_acomp(acomp_ctx->acomp);
> > -		kfree(acomp_ctx->buffer);
> > +
> > +		acomp_ctx->nr_reqs =3D 0;
> >  	}
> > +
> >  	mutex_unlock(&acomp_ctx->mutex);
> >
> >  	return 0;
> > @@ -903,7 +967,7 @@ static struct crypto_acomp_ctx
> *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> >  	for (;;) {
> >  		acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  		mutex_lock(&acomp_ctx->mutex);
> > -		if (likely(acomp_ctx->req))
> > +		if (likely(acomp_ctx->reqs))
> >  			return acomp_ctx;
> >  		/*
> >  		 * It is possible that we were migrated to a different CPU
> after
> > @@ -935,7 +999,7 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	u8 *dst;
> >
> >  	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > -	dst =3D acomp_ctx->buffer;
> > +	dst =3D acomp_ctx->buffers[0];
> >  	sg_init_table(&input, 1);
> >  	sg_set_page(&input, page, PAGE_SIZE, 0);
> >
> > @@ -945,7 +1009,7 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	 * giving the dst buffer with enough length to avoid buffer overflow.
> >  	 */
> >  	sg_init_one(&output, dst, PAGE_SIZE * 2);
> > -	acomp_request_set_params(acomp_ctx->req, &input, &output,
> PAGE_SIZE, dlen);
> > +	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output,
> PAGE_SIZE, dlen);
> >
> >  	/*
> >  	 * it maybe looks a little bit silly that we send an asynchronous
> request,
> > @@ -959,8 +1023,8 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	 * but in different threads running on different cpu, we have differe=
nt
> >  	 * acomp instance, so multiple threads can do (de)compression in
> parallel.
> >  	 */
> > -	comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> >req), &acomp_ctx->wait);
> > -	dlen =3D acomp_ctx->req->dlen;
> > +	comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> >reqs[0]), &acomp_ctx->wait);
> > +	dlen =3D acomp_ctx->reqs[0]->dlen;
> >  	if (comp_ret)
> >  		goto unlock;
> >
> > @@ -1011,19 +1075,19 @@ static void zswap_decompress(struct
> zswap_entry *entry, struct folio *folio)
> >  	 */
> >  	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool))
> ||
> >  	    !virt_addr_valid(src)) {
> > -		memcpy(acomp_ctx->buffer, src, entry->length);
> > -		src =3D acomp_ctx->buffer;
> > +		memcpy(acomp_ctx->buffers[0], src, entry->length);
> > +		src =3D acomp_ctx->buffers[0];
> >  		zpool_unmap_handle(zpool, entry->handle);
> >  	}
> >
> >  	sg_init_one(&input, src, entry->length);
> >  	sg_init_table(&output, 1);
> >  	sg_set_folio(&output, folio, PAGE_SIZE, 0);
> > -	acomp_request_set_params(acomp_ctx->req, &input, &output,
> entry->length, PAGE_SIZE);
> > -	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx-
> >req), &acomp_ctx->wait));
> > -	BUG_ON(acomp_ctx->req->dlen !=3D PAGE_SIZE);
> > +	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output,
> entry->length, PAGE_SIZE);
> > +	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx-
> >reqs[0]), &acomp_ctx->wait));
> > +	BUG_ON(acomp_ctx->reqs[0]->dlen !=3D PAGE_SIZE);
> >
> > -	if (src !=3D acomp_ctx->buffer)
> > +	if (src !=3D acomp_ctx->buffers[0])
> >  		zpool_unmap_handle(zpool, entry->handle);
> >  	acomp_ctx_put_unlock(acomp_ctx);
> >  }
> > --
> > 2.27.0
> >
