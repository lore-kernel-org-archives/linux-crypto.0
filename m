Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0621892D;
	Thu,  7 Nov 2024 22:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018140; cv=fail; b=h7Izc70rArwCRZ06OSYiBhL2q+PG438jHWU07dr8M8akGxXiXpzg3lQwi1fcZPJLj9SmkdVqrVfe12yuOnBSFFprTLeZiVKmtNgEh9IeWQ45yEY5GtWISAf0kLtmWCtFSbe61Nq7tdy6v2PcYzxB7u6A8DWLXUNC26N5FIV/jgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018140; c=relaxed/simple;
	bh=HJgPIC2nktuw0+2l7E3Subvj9wOW9bBBsVXXYcKGdC4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Og8bB1NuFTOU2H9MdGWpbGIKtFtNEVf+QJZNdxNHLD8mR4ojRsPy9Dt15AZRR6UNizT92Hhu1bFOwXdhooGWpVV2BoPVhyy7qKX8gVXFnqOIrhexEBMaQeoXHdlfRN2D30Dya64QHuzMmJ4WGqwKD3f8yVNrrT3bqs8sPdT962w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JkYbGdtU; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JkYbGdtU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731018139; x=1762554139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HJgPIC2nktuw0+2l7E3Subvj9wOW9bBBsVXXYcKGdC4=;
  b=JkYbGdtUE0TYQJXa4q6dzCC0ID7D5eSI8h5oCiiZ9JUMymxdtRzwJjOK
   FiIrwA5WLUajKXmIDTEJYeMaKoO1sJ2f02BYO1N85UlXotoHMkcNtjEvX
   5gerpZGfQu7WcOtbwuoBJoFRkPcom9fcHeoiYEFRtbsAfrZQRfU/roR06
   TuVqt9OZTstwupUDZzsmAPHkbXHWOcJI2u2ieMguOSWWTC/HZ8Ta+3ABO
   u35gL1iVrlO1rZoz1uDLV/3HasnZE1X431NYpPePd4iXrU7yjK/ck9rP6
   OYbHFAynBoeW2kEBiuSN7ojfZ7HHBgCwctnHJ1IUqdebPpPnZB7bUJrE8
   Q==;
X-CSE-ConnectionGUID: yeJMTZoKSdGaZ9AfUYkGHA==
X-CSE-MsgGUID: aMGg5BEeRdetv8KcJd1uew==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="56286384"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="56286384"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 14:22:18 -0800
X-CSE-ConnectionGUID: ewsZlRuASKK2CMrGv4HKBg==
X-CSE-MsgGUID: egYxZEu/RY20vTb5bB3M/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="116135834"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 14:22:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 14:22:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 14:22:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 14:22:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tba09qRqO+22R53fnTLZTlagL+nQ6TA2DUKOe8kVnG8IT0Ht6lcjTofvS84KBDqM1lpF/k7t+S3bj7NBbfbQle8hFeNZ9oe9QcqBSSUN4Vtqwy5eIT0Nm1fvlI7GhBqik3WKyDGUFpp9dWmgHCxNYQUw9X+sQNaBV3iqqwmjQOpExHOEMGFQcTsyUqzBd857LDlcZnHDqXhGjagWoVq7DJATd3Td7FvOWNi2j04WAK8M+4CpkyHK3CDpKNO7q/AIQzl4qCXmnVifvCr2Vnc8xpB2C0Ua8AYZZO+pF1cfwFkdHe71yn47yPR8Qad4CmO+/6L0DbM0cSUQ27F+4rySHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HNdGBEgrtGJlUXohrxXO1i+Qv4Ua8gYHVPunEXP20U=;
 b=y064jvFRobbMiJ0+dbYuewu+Go6E3onNqYKGYAke/HdGITTwA7/P7FIdIsWSa9ankjPshdmjnq3FQNSsFPsGR5rSzoq2+kt+m4B2QHnaFNjswCVbXm15AKQiU2AxcRiYO7aOXk1eZC+OEV8PDIISEvFANu0u0OJVqq05GlCymzP6cd1mLCV0TVfOQdRR+lzJ9i3X4c06Rzp6VZUNf88md0OskYVavMG1Y9GqkqXwaSTol6frpxssUfjB3lDzFRpD7UDcAaDUK71jy7Om6HKhBvOwY7EjyhhtbJ5QgG1HiHwzKV/ByMPLDAVeZyDameBpZDkwUAbTAHrbZXqZHOIGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CY8PR11MB7108.namprd11.prod.outlook.com (2603:10b6:930:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 22:22:11 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 22:22:11 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 11/13] mm: zswap: Allocate acomp_batch_ctx resources
 for a given zswap_pool.
Thread-Topic: [PATCH v3 11/13] mm: zswap: Allocate acomp_batch_ctx resources
 for a given zswap_pool.
Thread-Index: AQHbMIES+FiMds3s2EWIJNIPU6thtLKsFLkAgABRDdA=
Date: Thu, 7 Nov 2024 22:22:11 +0000
Message-ID: <SJ0PR11MB5678221143E2B0A7FADFDAFFC95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-12-kanchana.p.sridhar@intel.com>
 <20241107173124.GD1172372@cmpxchg.org>
In-Reply-To: <20241107173124.GD1172372@cmpxchg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CY8PR11MB7108:EE_
x-ms-office365-filtering-correlation-id: 84cc8970-29aa-48b3-6d13-08dcff7a9fe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?WI5soo7SpngeLTRA+EFBaq7B8fbvtKs8Enj1/H8qCQqwk4JxMrN/Xj1NvTsz?=
 =?us-ascii?Q?ogScYl7tM9AL4uVL5ERa07lgsLG9AlfTIVbrGKiOj3ZJYnM14BtIk1K7EO3L?=
 =?us-ascii?Q?a6TbaeUqpJ7pyfRWZa/b8gPeWbI8aXsWUhJZ2ob6C75xnbTiVx3HRyRpUL3Z?=
 =?us-ascii?Q?F9L+5hLoAA6XnFwNMfewJ0o35SnxMOnUYxiJHbgTKGmcOnY7cAe6jETvslS8?=
 =?us-ascii?Q?IK891Yya6gH3QR55Z0GtoGhZLpLxHJbL3fRs1D1EtZEk7d28gAlbiwG4ZAdX?=
 =?us-ascii?Q?DPpuS9VKbmL73cj0Mg4dtoUpeaJ/X+2B52YYl7p269Datxn9fTDwJxK1lcss?=
 =?us-ascii?Q?18it9RXiZl/fU0NAHgpAaB5mOiZCOy2D+bP1l6znOzPzF5VjOSIvWHdY0HdJ?=
 =?us-ascii?Q?eyQga0n9A7OyVSJTOz8UBwGpLW7y7bHh4XE/IRnf6jG8QBK18OW9gVIpMgKn?=
 =?us-ascii?Q?s77z2/AhZPi7KdTMmaZX2FUzWWZsiB9V8lSBMdv52XmDuQfrpKr11gdYf2zQ?=
 =?us-ascii?Q?NVr1eNJ0lljcqr8fJx8rg8VmlNdTaS+Es8OwyDwmfcXBbltaGcoN5f84eYae?=
 =?us-ascii?Q?C635Pmu+nxMlz+vp1yPkkZv1RC4U5821lykdG3exJXeXUgDfQCEjZNv97DfM?=
 =?us-ascii?Q?AoaPYTSUQ8vqQBGcwAyOnwXmES9NA4oiY2GD0tbwQOHVZEDcRWOFQJnyNmlf?=
 =?us-ascii?Q?StjOUZlFre9/tnuYsAiC9IeeVM0sfDCCvby4cQTzxjd+K5GJs4/IdEmnhiS/?=
 =?us-ascii?Q?8aYoPeALHhopYjcHR2Z5AHLS7lw7E0qfyjOlCdE3tGypCxkzxA1MWA1SgToH?=
 =?us-ascii?Q?0cuccErsofVOKCqFIz+PogZEdSu6pzs467GiP88eRRsUkSa2YPAAC6ePK5CO?=
 =?us-ascii?Q?Ig+Ftb5nM4c5+aRcxVDwyB8i16gOVn3Xx+GFVP/Auig+hZwwqIWK/xVAfk4z?=
 =?us-ascii?Q?8jiy2dseIBvWPN/BiDgxpYggZYW+NwJPJ5FXzgiQBDebXxolFQ3u0lD4lOEu?=
 =?us-ascii?Q?CaDEW8HExOYdcTc4MQYkQbpspdJfYnFPWcizHgENYc+jxpqK9xKi+FsKq9g9?=
 =?us-ascii?Q?kTkwq8x2WTyBzg03IYkKQ4K2wfoxLCHE7L+6TBZbTnvNess2mR3sVQxvwarV?=
 =?us-ascii?Q?2BC959eXL2UQrvb3kSyqHEaKwgcwIWBBOp9ROWsFoOmgsxQG+mSWT2K/pdUB?=
 =?us-ascii?Q?BGf+TwLdsOBMSlD3k9KDqZ4h4OckckvsLmRdYMT4Kqr3qB/ML5C/iTpjP8b+?=
 =?us-ascii?Q?lPhRSKzkpV/pV68IsepxQPcm2jHRnGJeIFxlX5hkFHv5jzZBw+zMYAuTNA99?=
 =?us-ascii?Q?HwTrlzk9RUqTCjHes9Y+fOOTQ3t+LrCrErGNbNlGm50tzwNwL0YhLc595yAJ?=
 =?us-ascii?Q?CGCXzyo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UONnjmwwQiQwFxAtlrbWtBRc8myabLFfseqrHh2pL2GiC6ml8nhz1h15dblT?=
 =?us-ascii?Q?z1YpMhN0mMbXrG9etWtM+6kHbvl5gBjK90ysWkus7gRQF/B0vGbH/wG2rf/W?=
 =?us-ascii?Q?EfIr4Zp9J7GxHzmZRNUloy6JpxoE4byg0Z6Sm2mda8KCose7e8ao1n6Iw1RF?=
 =?us-ascii?Q?4dMeYnB8An9XP7/sXrRJxYGumfm4zQZjpVrwbqDnPl6X2kb+oxhYp+7+NBLR?=
 =?us-ascii?Q?TtgFN6I4f9oLGOE+MRhjkEuKpQnayFBJR4eQIapwWUpJTAQr6kY65UcBCgjD?=
 =?us-ascii?Q?0jCgh9xeH1gZWoi00FizWtz/LVk2VgjGPuiscaNW421OlecXsVxh50Xqirvl?=
 =?us-ascii?Q?jHICJpdhIvc9mlB87OCS0qp/4OXdr/CjsCvhmp8JGW3ThO/C1py1Lr8i2gTJ?=
 =?us-ascii?Q?MITqbblP6ZhWRbBOlxRjoSviuQpzQpLJcq1tknDFrP5Brw+LE1TbVgMjKPOv?=
 =?us-ascii?Q?Xa17P2BzNjrjThDjBoGtENy85inHcce+2v00ry9hwPP+H31Bt8MsFzY0F106?=
 =?us-ascii?Q?jk8/uWWs97l9EQL40MNYsC0q4GFVf+rQSSHnGmEAadwsYZ9vyT1QBMfO9Bha?=
 =?us-ascii?Q?Td7h4p1yFtN3oFr+J2/iNL82u0G22zRfCbFUVIVfPVLL8G/1EVR+bq6+MQjt?=
 =?us-ascii?Q?cItHJJTq77LOraUJoVbpArD3us/58YdUSXYX5Ez7aXvbl6Pdh0nYpU7ew7Mv?=
 =?us-ascii?Q?k2Z9IQiWJlnoZ6KA+Ro9BxmARoRccyzca6WwqphRRPrSwKLbI4w77MShqXzA?=
 =?us-ascii?Q?LhnN9eVLuuzuPckulOlPOiDN+8ROlhmlpCaBjkvymAOO26Vo6biOsYXWkSvy?=
 =?us-ascii?Q?V0mcU5zbzMWZqm9myspjV+RCR83TMSFLxZBaYWsQRkGv08CU9c5E7w1iVJx+?=
 =?us-ascii?Q?pFO9FcUhGVqXcLh9eLUKQb4XdTBaXBAdr5ZCHwTTWbMoRaSAB85ok68t1cFf?=
 =?us-ascii?Q?c6YXF48n+QhyG9YSdeVUgIczNwja705yvzk1II0e2120lpXt3mqd3ZmqhrnH?=
 =?us-ascii?Q?mdnGpcE+9Q58awho+KneLbIQYBhvS3FY7GjUeVK4i6MbgRfKh5BCKVC/6gym?=
 =?us-ascii?Q?mCc22hTFPXBaCiO0nNRpYv7AUXvr8pvCZDK1G2XdE5fn1wKFrOGxndTL1L9W?=
 =?us-ascii?Q?GURNNTBrJA4O0PlcOBIR0rkcdWT0lrU3uD/TgvCCZWRJrVly4C356dvah8M/?=
 =?us-ascii?Q?GGvly2DgVza+c6aw+3UHSquX0iDgwp7vVaLZ94rjqkecasNaVLsPHG3gROKM?=
 =?us-ascii?Q?TSkzCbdCAC3uoL4dMPW9/3oSVZjz4T7HhQsopaM9mXBu99bxOb8StFTAnutu?=
 =?us-ascii?Q?pDwSKaQW1SgA6d3rApptuJj/S78jjTAg6ySl9EUy/2VU4omt63+TwLaCsgPi?=
 =?us-ascii?Q?rZ4HJzlmfX21ZZp4H3XcDpZSUVRTVF9KF5D/PbXhfOO9ZbUJnzEuKboNA4au?=
 =?us-ascii?Q?XtACC56zxJAYC8McAuhtUGDmVX9TUlFVCsCe3EfZF4efDP3ASKkJvgpcj0CK?=
 =?us-ascii?Q?KLz2csD2laAZ4ZwUmpJh3RS+emRPlgYoZM2OTaLIgChFhqxDKLp8OeUYES1i?=
 =?us-ascii?Q?IbpD4CATDnOEvHUMV/AkC2JGMLX26jTLwPikg9eYnovet1lfTjGuLRoT9mL3?=
 =?us-ascii?Q?9Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cc8970-29aa-48b3-6d13-08dcff7a9fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 22:22:11.2970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrphH0rDtx0qkDVJP9IT4gX1AHuNLNq8tqVtYzQQ6Y1w9no+HXivV7RiRtOUA/bQ4PHgA+kCKomYl0RrTI0xRFlSJmODPDhSpzCbzWG6laQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7108
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Johannes Weiner <hannes@cmpxchg.org>
> Sent: Thursday, November 7, 2024 9:31 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 11/13] mm: zswap: Allocate acomp_batch_ctx
> resources for a given zswap_pool.
>=20
> On Wed, Nov 06, 2024 at 11:21:03AM -0800, Kanchana P Sridhar wrote:
> > If the zswap_pool is associated with an acomp_alg/crypto_acomp that has
> > registered batch_compress() and batch_decompress() API, we can allocate
> the
> > necessary batching resources for the pool's acomp_batch_ctx.
> >
> > This patch makes the above determination on incurring the per-cpu memor=
y
> > footprint cost for batching, and if so, goes ahead and allocates
> > SWAP_CRYPTO_BATCH_SIZE (i.e. 8) acomp_reqs/buffers for the
> > pool->acomp_batch_ctx on that specific cpu.
> >
> > It also "remembers" the pool's batching readiness as a result of the ab=
ove,
> > through a new
> >
> >    	enum batch_comp_status can_batch_comp;
> >
> > member added to struct zswap_pool, for fast retrieval during
> > zswap_store().
> >
> > This allows us a way to only incur the memory footprint cost of the
> > pool->acomp_batch_ctx resources for a given cpu on which zswap_store()
> > needs to process a large folio.
> >
> > Suggested-by: Yosry Ahmed <yosryahmed@google.com>
> > Suggested-by: Ying Huang <ying.huang@intel.com>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
>=20
> A general observation: this is a lot of code for a hardware specific
> feature that many CPUs and architectures do not support. Please keep
> the code self-contained, and wrap struct members and functions in a
> new CONFIG option, so that not everybody has to compile this in.

Thanks for this suggestion! Sure, I will address this in v4.

Thanks,
Kanchana

