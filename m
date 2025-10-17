Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E496F1758B;
	Fri, 17 Oct 2025 04:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760673901; cv=fail; b=J0pY02HZ2yXEnHJ4wZBQWMQwweeTy1L8pA8xip5lfzOxoikp2KR+P15L/ViOWXX8EkTGFAHZtB86Km/lARs6H/u6N3nQnLrLSjFXyd7FuS3k50BOq1PyNA0a4bJtGJ3/TX0N3lxhSY2TIlGN2w7Wn/WgIV0PyL6RbhVKe6H0E7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760673901; c=relaxed/simple;
	bh=b7WsljRqBPnc+S9TUtfImxFCID4ydAfv0j5nL+U2r4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jZMudYd0Vuw7NkI9BIwerSbxC0QryURH13XVXH84UzPFuNUlxv9kPC1seUgtpa+BvwFMEjDPeoUZELBDbkHmEeO+FscZdqh90S5HxyS7WtY0MKFQiFj92xvcWkK0+PCn40F+GhmkaRbuYjYNiifHaSIG1ZG15HDg27NKCrUGDJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fls7jrVs; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fls7jrVs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760673900; x=1792209900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b7WsljRqBPnc+S9TUtfImxFCID4ydAfv0j5nL+U2r4Q=;
  b=Fls7jrVsbum40SbtyWEew/qzwL7eke6MyQekrxBqTiXiG1WMHtPiuGPH
   V1ZIwukI8TfMEWsVYXPZNC37icfnYxsWXuIfNr7wKPDXRw2mvw6RfERJZ
   b1E54588XOvOz3PkfXdEzHsyqjciYCsr2oOs7AOTCo+yQ+EMyYgSK7dqm
   WXP+8qjTvOWi5Wn7V/bXO6SXP23hgtQtkc6uBo3AMmH+zc2W05QxNdCVY
   aIwQWGsU6ZuUa8WB++EOnqWsvTyJKTQN1pAqO6w74ENynvop6VYIBnucA
   4VxsEV9qM5xzMSMJyPrqKw5ToNZD2WKT9rMvnd0LDxlkW4h1Z/sDtwvY/
   Q==;
X-CSE-ConnectionGUID: /qGfHq2GTiiYvLEmi80EXA==
X-CSE-MsgGUID: afdT5BwcQvqwm0KcFvDKAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66711607"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66711607"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 21:05:00 -0700
X-CSE-ConnectionGUID: 7NN/P5mNRmKrA7JsOOlxrA==
X-CSE-MsgGUID: 50eLwViNQbKWXwv46zV7Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="186887137"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 21:04:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 21:04:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 21:04:58 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 21:04:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYhme2pVXzmi0AUItx8pKwfaPk9QzL92gBhp4rSgQrjlA+5/Fw6SCr1QzU0mFvLUwuf7067KP6pANJticNfc3Q+dvYWDjbaWdlnwVwKNp7lSGUQxAfwQduByW+zqZE0Nj3FB5QGP617xmlvYOfOJgdfBfYMFGuDnb2YU9gUsOojwVWIN4p5ImE1KnEdmAGbsRHb746cIeU/6L/INCnUaT3h+1FI+7aHoBd7ho2gKUTjkneozhvoyczzVNpyn7zw8ENLnK4XrU2XxTgULdF81Fim+UIsX3noK/wC01n5CBT+HTr/AVjDsH4Y+kJ78hF5UeWaEsufcJdPZTBD04RRcfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHlf5ZF58zdAg6dPDkJ5RzYYlfaTxPZeAzyU/hlbpCY=;
 b=cLMlvrVsGYnn7PoFeEstKGiFK2I/HW+waEWHF+Yb9Om1x/Yn6/8UUkHYhvg7xFKHjOWgKcxxnXSAy0QqE+rx1v3RJGixGhgBOBiXoUwl9etGzoDH3XNLE//vft22ZSQKYClQW0tPW4s9qwze1CfHHXebPQ34rEngfDgSrlzxgqZY6ICiaLRK3X4LfetOyNUXVvAlMCoxSba6r4lPgZ+rr8m8vlT7mXSRxSFjKUHtswSmdeXLPIGFUPvvDZo7uPXSqriJj2+Ygsg6lx8qDGEtgmFMwlLQJT9vTOwhqKfv3ArgW0kb+PNAod+gdJK+lOumuQLbGhfIQAbChV+wdyWIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA1PR11MB8351.namprd11.prod.outlook.com (2603:10b6:806:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 04:04:56 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 04:04:56 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Topic: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Index: AQHcLpaVDpsUwa7oJkegsikxMLWqgbTFqD6AgAAwYoA=
Date: Fri, 17 Oct 2025 04:04:56 +0000
Message-ID: <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
In-Reply-To: <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA1PR11MB8351:EE_
x-ms-office365-filtering-correlation-id: b83d07b6-78dc-458c-3f73-08de0d325573
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?U1+2UUJJZbexWNAgd+ykXjssWtDCRB+0GKCsUjjGP4qPzwUIynVCRMPR/L3S?=
 =?us-ascii?Q?MfE2D12MAp7EQ6dhdhy5qqH9JrA38Tl6KD+oBz16PKY00/hnXlfnVWgk3Tlp?=
 =?us-ascii?Q?KABdJzCiqWDFeI2BeMtTQARX4GghIHoTn/HLI3MJCilwozO5ZDSqIYMfeShQ?=
 =?us-ascii?Q?DWFkvAZeQm4q9pKPdAUbK1IQWbCu1DGTUUFDPBkIDnN3WCDQEpy7S+vZ846E?=
 =?us-ascii?Q?cpPHuHoLHpHKK3AT5kdEV32sWLkTYHxWME538BNoczySgB/qwWrwfnp631NI?=
 =?us-ascii?Q?Xr79fYF5AZaFHJVnvoyqmDP9XQFlTIhwtIF9ha2Qp+GaWONScLuFb0thgl1T?=
 =?us-ascii?Q?+5GTz62hPzf89/fU6Y6cBaJ57B3ICYAINQnSyylnwJRallk2At62WZ+4uuGk?=
 =?us-ascii?Q?sz4xG+AhyGhXBaDXGo8MHlJAFTUNfWuAdJNlK8CZdi3W7JJmnJHCZwqgXtHS?=
 =?us-ascii?Q?SxdJbROyui+aA4iWLhkv5TzXDrQ2N1PqdVLVu6pC7S7loShQV67PHyCPJIe9?=
 =?us-ascii?Q?qe/v+TqIu99rLtnaFBnJyCcXHQHn+Gpd4di2RfhOcAvJ4pePmPhf5CiY91Gd?=
 =?us-ascii?Q?KlRBGkrNmT0pQC0LLdwEXln+av3mFDIPjpBj6hN2dxGEQ5BtwKUSBzbLt8Yt?=
 =?us-ascii?Q?iGtg0SNM5RusI1bUJuTpKEbhXFXLFchU5WJzagTe5ERRGMDgZvzd7wTDetCR?=
 =?us-ascii?Q?D//DQ57sEy0RMyuoFG4UN2F+DaT01i8j6bcgQJUqvY/9QgCZ3IA2uNDx6XHy?=
 =?us-ascii?Q?UD2lKM3zlQioXaeYqV4QcvU2gKHaUBjqnuigIQFOUhB0EpbIeC6f8q2QaBm1?=
 =?us-ascii?Q?poTJRTXQsvLwndbT9+Ps//oz88dnpzH6WLlqQRYIJxFpYBtM+gijMene06dr?=
 =?us-ascii?Q?DiQeOyNwrjeOpJAPtXb53PmNyHjCSOPMC6qf1yzzW5F7xfl8SbluZh/q1/PE?=
 =?us-ascii?Q?iaF86kdL3o4RnpNlEFvlT0YUD5N6k/qC0YE6SKpS7GtHYrK0fYDFwjX/a3FA?=
 =?us-ascii?Q?eYqXoUh8Guamu5pZD6uJ7i4nkzXJrnP8xc5kq6/eq64xBssRktTyrq2pTIJD?=
 =?us-ascii?Q?UfsrJ5ubCELsNqISBZKI5SxhnzPKE66cqWRXxJw5VV/hhoifwR9YIk+Takgz?=
 =?us-ascii?Q?Ac34GUAG3Z42I4pJOdo+KRmbewKf3xma0f1zdACKCAaE8hkPS14FGN3KXOvP?=
 =?us-ascii?Q?avSkaiIcsmOrzR163tzOFIVl7i2yBpW+9unsZllJrbB6bUR4fMn8g3sJafZ+?=
 =?us-ascii?Q?XRJTQioM0WTu+hhdyKi6n9ti0zB6IiMwQh5sPx2TpU8PkpEE4EvPpHyCAM/o?=
 =?us-ascii?Q?TAcX7Vmdq3cYdCzWtwWTr6dWWwMickSnEH+xS19AZWGdpfNjzxMz2XyPCvgM?=
 =?us-ascii?Q?KyDU1TV27lCCHE6WbikxBqVdN2cfT36bgo4Kc5p7nPxVWtj1x21gz4Ugeykt?=
 =?us-ascii?Q?hWNy2DTZ+iGcLccYHO9Bl291m+oDJAmHSOdVKtlnETwLQ07tqP6Meg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jZe1ADbifMSBmzNzFcHcuqw2YYyt8FQeDlG+4Ajishm2vXy7tokH+B1on22m?=
 =?us-ascii?Q?x7yX46gxmAJNH5Gs1PSN8h1eB1H8PKboM5M1e51nwdKho0UQ9ycIxNa0GKq6?=
 =?us-ascii?Q?5HeAljDK7m7QBCuBySA9g3MkpwCwCvvXARtnL7Wnbj5L0aJaauUkdX85axwz?=
 =?us-ascii?Q?XtULTrt3PuI1HXP9F2bWTdLZwsxZbE44t3EY1xq9wxAsae6WSqEZYH/Kwoto?=
 =?us-ascii?Q?MN7YwBUBgsLzNf+st/BJbsswrqpg8kQP0GAbmsinbLkqYp41bywkTYbjRtia?=
 =?us-ascii?Q?oyVH/0qqLTpDb4WHRYD0cOkiPx85eUVenWiu0xPrbsXfG7x1Eosf088FGWii?=
 =?us-ascii?Q?Tidk8R0AH9XvXj/vOFQ+v9gHJAe8pfMkGNbBZA338eyq2gPLE8KuavGGrzi+?=
 =?us-ascii?Q?k3V8FPf2fCRWwoJqiOabYKvqmUL3JcQKy1tkdO2Xje0nx0h1kB3gNqbp6E1P?=
 =?us-ascii?Q?BmkdQI3rWaAKPMXKn0fwHOuIMoiOKYdrtGopzBG0j+Wt2JuRgKFcz9tFXAZr?=
 =?us-ascii?Q?IWUr207HkXO1yQtI1+6G1DoQChd6/gg88q6tFpAMKwn6Wpc3mEAo6Ku8Wb79?=
 =?us-ascii?Q?KlmojuFs1WuGlQsf70u6QuquahfN1YrvbAlYM+vQNHDIs5JKHuGBoeSuaR+l?=
 =?us-ascii?Q?/ieXC9FfnF6C6/q69pvRL4PjOA7vEnwKCx5D9+3M+qUM6Aed2lD1GxEJ1HtF?=
 =?us-ascii?Q?Mp3a044G6HiXgJSipNKdaOFDFA+ZGICsaXzKdUo9Hf+uae39Hs19sjWsn7Yr?=
 =?us-ascii?Q?VhAmHSlgvK/gSeTK/yZRMfLkxjRVGTt1+DNYk4rpJxi8sC6VokDfnZhV5m/F?=
 =?us-ascii?Q?Rc5TtjEA1tJKvkJqVlOodk8Yz3Ipw7GVNwcoY2ulKziYpmbrHScOyf7zKzg6?=
 =?us-ascii?Q?clz7nTIzOEOmyr4FPBW8U4COmFmezDCgZKM0ce507KBmFW/m0JmPVR8u4Qgj?=
 =?us-ascii?Q?KEgEIGBJyfC1rrEkF6d2pnuZQfK8IHCaXAU+cl6CT71HWl9+O1d2iniRJEe7?=
 =?us-ascii?Q?g8R/jntY1nOq2PjWQ7cL5mcfglk04GR7VAO2WkrB+AlrHCQJ4ZdkTu/JZpHC?=
 =?us-ascii?Q?sU1zx4g34Zv3F4n0eyMm++eiQs751hCKcQ840Boej2exWpzPuB5AHQWk7510?=
 =?us-ascii?Q?AdGHLrlgNHMRKRTscUCiNu/+8kyvo3ZlaPcoidCQluID9HQCkD4wUl450Ume?=
 =?us-ascii?Q?mCNISOJt/O053d06UIV3R5QGR6WDBhZ27sNtQkPFUIWa5nYT939SB71d5jsz?=
 =?us-ascii?Q?2jmBiOrS3fFqP5BHeQfXBeAp9n8G8s7XT5NkoQDhU+149Vl7lArfQhExkDvJ?=
 =?us-ascii?Q?z4DkRKPY4Gf1nfSiCfKu+NnrVcOYJyNLBmu26r7DdMvcSsml9yqHm510gjKR?=
 =?us-ascii?Q?De+OdPjx1tc7k6e9qQfE7vaEWUrpm0RP1atwP50e/LTfp3zEavL2UQ4wD3SU?=
 =?us-ascii?Q?leGMFn7/0BKA7oJYvEqp2zsHfmvzP/S8mn803SdKpdbRE+NURUsaCCzdFz7P?=
 =?us-ascii?Q?DpHoB9G/oiVOfctPX10AVWCr52P+NU295CTJRC/JUfHU7HsNjuLmqovHOeXu?=
 =?us-ascii?Q?oaQvXddee6Z62D4YaAPfktYrtlxhC0sQjlbK5jitgp+091X6kdb1QhK6REd0?=
 =?us-ascii?Q?bA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b83d07b6-78dc-458c-3f73-08de0d325573
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 04:04:56.6226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7URlEe1LKjvcT04I5UVHuNIJVshEVU72aoNNtQI6xaych3gxx72MyaRFb6Bmpd653wuuBBC0EReSD8eLbTdrk2yyXMT5w6eot7UeJfbMMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8351
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, October 16, 2025 6:10 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
> compressions/decompressions.
>=20
> On Thu, Sep 25, 2025 at 08:34:53PM -0700, Kanchana P Sridhar wrote:
> >
> > +__always_inline int iaa_comp_compress_batch(
> > +	enum iaa_mode mode,
> > +	struct iaa_req *parent_req,
> > +	unsigned int unit_size)
> > +{
> > +	return iaa_comp_acompress_batch(iaa_ctx[mode], parent_req,
> unit_size);
> > +}
> > +EXPORT_SYMBOL_GPL(iaa_comp_compress_batch);
> > +
> > +__always_inline int iaa_comp_decompress_batch(
> > +	enum iaa_mode mode,
> > +	struct iaa_req *parent_req,
> > +	unsigned int unit_size)
> > +{
> > +	return iaa_comp_adecompress_batch(iaa_ctx[mode], parent_req,
> unit_size);
> > +}
> > +EXPORT_SYMBOL_GPL(iaa_comp_decompress_batch);
>=20
> What are these for?

Hi Herbert,

These are for non-crypto users such as zram. I plan to submit an RFC for
zram that enables IAA as a zcomp backend with batching support. These
API will be used for this purpose.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
