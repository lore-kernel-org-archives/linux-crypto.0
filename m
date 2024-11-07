Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB78218D99;
	Thu,  7 Nov 2024 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018773; cv=fail; b=FJpa9V8zFrvFJYXfgn0WxPd2Nj1ZGttHBLHeaq3nNm0RmFJyL/jkX3y2zf/emI8VGKSiH135BdXs3oasKTSOnAq3H6RUtZZwAjG3KMFOHtNBxJBKC1Q0Bbo145T+Fo7dYWDRhtBQCwF8pJO1PekXcIXwDn6d92xh+oQ+EuRm9og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018773; c=relaxed/simple;
	bh=tbzVXRqrVMpdT1GolBnJwMGEspsI+X2PB5eanNxVf9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AX97QBSXufUL9BRRbHEn1sT7cAEaRM/dP8nhd6QEasxGMvz2rlCyEFHyRi3pK3XjO0zZeXSFl1mJ1ZWVc1gusH3Wh7dpytR7Cihx5lb1aOGgwWQ/+5PRBDxQdJ/ZqMZIileCibGNrXY5+51HJPFlQy/bdOzaNYzQA8rwWDQbbHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eD+/ZvVP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eD+/ZvVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731018771; x=1762554771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tbzVXRqrVMpdT1GolBnJwMGEspsI+X2PB5eanNxVf9A=;
  b=eD+/ZvVP2RkOdSdf3n0aKSMxA4Dhn+dYYjP9muNaWw9jrdqwk4zJCnCr
   ANSWVEY/Tpr1pc9rKxGBS1f4ULzhKRcnakSaZZYqE7yFbNGWEp30QauRD
   0fxtqlYgY5WoCO0QnVbJ9FUmm20P9rzSpB2hO72cKmwJPYRho7Ov+5HNG
   MMcWhsRZK71sl7+mbxOAR3pbY2vMMhURkPHJXjQso0a/DqiQuSZx9A8WP
   wij+5gHxPr/MfBwMnWkkeCUlCW0w8Iurh6LyqwSSuzz/mh62XCM5tjtgA
   naPLJr6F+xV/CU/yd7+HuG3VbJgC5nioIGSBoPt/+lioOul7RYuxE6na6
   g==;
X-CSE-ConnectionGUID: zNgbqk+dSwK2EZbdtomTjA==
X-CSE-MsgGUID: uPIQ7jN6Qq2X6CiUbtUXuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="33734851"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="33734851"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 14:32:50 -0800
X-CSE-ConnectionGUID: IynNzk6BRhiZ5BkdV0PCOw==
X-CSE-MsgGUID: kzZfLtFISNSO7pBtOlAtYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="85257066"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 14:32:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 14:32:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 14:32:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 14:32:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWFxoDpeZ3JYS9NBqjDSx4bUDk2IgW9sa17MOnfEQ59MFRSgMaGeTM9hgWZSDD5rrK1W9X6BT9xj9+sZgmqHGF2YDX9yIEW0Og1KBk6jIo5WoQkjlzf3YCZu7SEjqf2OaryqzOnw0HruXFJe5Qk6W+M67xyiPbdxmBdnMRt3fLrJtehldkh02sVJWkm1ZbHIigmHrxplKSRbcQpGLvTX287QHFo3wnSMvXBNseNTWeJVyqItL5q/40SqWAuy7zQNO2kj5oy2bzkmuuTeFEEQhYo5Hzkrfb6vljtpHIXbHN8Gp2xBf4S8ro0kUvdxZyRIdDcKoRM4BJOW4Tf2Z34uFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggiuB4zk7BUUWFi3UOnq9TfDhYDRgT1pBdn8chrr/hQ=;
 b=S/x/Aq/V8gwxaAXTyzjJOQCkE+MNDyEapO7UNsardfX1XVkVF7f34JG645rNj7s7zpt5J0aLsx0XD6U/rsfJ2inilv+Y5t0eug9K7zsYPJwGGm2/DhjEfhr2eVgzp5Ik08mx8bPfOK1Xb0J0AMwp3u09ITCm7Gfuml9yahQmXbjyGzYz/ogCV+XgLNzekpx5Hnj4GBWwtD0cNUPp+aZ+eN6WPOAsSAKybJvg1D8eV5xdBsdw+GmRo31Rd9Fxpjclz3o6/nGMIUTMptzQ13pEApCI/nCFAxZROBa7P5Tbxl8djoMOKGE+dP5+ZairwwlrVK7V9j34Jk8yaJ0di44AHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by MW3PR11MB4668.namprd11.prod.outlook.com (2603:10b6:303:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 22:32:44 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 22:32:43 +0000
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
Subject: RE: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Topic: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Index: AQHbMIESeDDekiFHHEqRnEEQm8zAvbKsIU4AgABF2wA=
Date: Thu, 7 Nov 2024 22:32:43 +0000
Message-ID: <SJ0PR11MB5678A2F2802F780DB32C9A98C95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-14-kanchana.p.sridhar@intel.com>
 <20241107181626.GF1172372@cmpxchg.org>
In-Reply-To: <20241107181626.GF1172372@cmpxchg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|MW3PR11MB4668:EE_
x-ms-office365-filtering-correlation-id: c4b7520b-8a60-4cc6-5a74-08dcff7c18a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?euRWW0uECybN/N4TQlGpP+D6i0+89SobrMhavvXUPPNF8Q3Hqu/9uwH5WS+j?=
 =?us-ascii?Q?2z8BmiewPxlGvjlAgVvk4eC1GBPsreMRQAqFXG32WU1S6qJkg+rXyVEBc+qN?=
 =?us-ascii?Q?X9cP5h9rRlW4PzGxbXvCRPvb2K/Vf72d/h3/m1lQtmPGogoZj5/RXy9h4a1V?=
 =?us-ascii?Q?iT9EDoYzF7Ps5k2ZFOwlJiAcUU2y8ef21A5YmkVUog0Xb1hDV7Rer+yUfaeQ?=
 =?us-ascii?Q?3DyHPE84vyL2PGzfXkz3JRA3VtdvHdd2cl/5u4p8xUyHADA1CiusvqyfDPTj?=
 =?us-ascii?Q?nCHWomXLjpv05+8PD4XPUGulF1/hmyKKXvz75JzILPQTmt9fMt0C+YGoGHFi?=
 =?us-ascii?Q?MmiVq+GNZYpBzUjNmrtXC8wbNfQ89CRAdWGR6+oZ+FATBYu+M7qnzmjBPkEp?=
 =?us-ascii?Q?0KYn/R1i8fYaFebt7GHDKEwY9X70/UOYwgUloaglHNt0LX3xWowWuttDCSqG?=
 =?us-ascii?Q?TEGN0TxDhXgX27KevVCdWHlx8QQFbKWCDTgnXlOAbggTU8kcCiP3BN1aBsJ/?=
 =?us-ascii?Q?SaK2GrSahcMe3xOW3gPO2KqTWPdANLhRoZvsnKHd9DdGynZwrkqBgY7zW4x3?=
 =?us-ascii?Q?zbUDnMDNyI7ZxQT8gIz+kvg7/SfWxjW38dKizFfF098J7FdyNi/fxO6AAM0k?=
 =?us-ascii?Q?zRRU5cxIl8OXiIdd9TZNMxqbe8FwQpoo9NaUP6gerbfk5aVRPU6A86RUAqcH?=
 =?us-ascii?Q?hePqiBcGXBrXnuKJNK0oYuGw/0vJ8j5vDmJmGfHEOqChcyTmtjZn/n2lwYPD?=
 =?us-ascii?Q?RuRyLx7jPjHcUozq3i8WeJNyEXzJBUouD1NsQvaL18fpdi3E8OiHHNQSvriB?=
 =?us-ascii?Q?44aBcYZ2O4a/XjscueDLA5WK9NvPGmJAKOiwCJNBfJm5R+8Q7JQpWIu6kQs/?=
 =?us-ascii?Q?3PGoi/Os6Nmncc49krl+Q7Zxw+hnMEF5f3BdbDDEhwtJLSuIDqzmfpYMbgzB?=
 =?us-ascii?Q?A2GEEBvs6mJ+3EbcCLcg53+bhrlYKbl97cgP8TTFA3lAQKVcos8JbzcpKBXE?=
 =?us-ascii?Q?LJ2nxI+AUvn8kArrYzQn6kIn5sFn0fWE/SMKs/iZdCsTxlNe3Na2xB054dDs?=
 =?us-ascii?Q?rz8sJZIcIgo+IfAZEqWKG9GZIZ0BFv5QNnXxRgt0WpCKQXhXR5aR/awfMoOp?=
 =?us-ascii?Q?N3ifDcLgpDFWBfKIQuKIRitSHfSlu4ZHjxZduALDeZR50tvvcUWSnCxccWoH?=
 =?us-ascii?Q?gN7xpsCLbzMZrjxaUvOcjM7ekck8xQFtEu9m06aipLg9i2jPAOw84W2bYls0?=
 =?us-ascii?Q?9NivLjYAZSCaB/RSqj11n96QnS4q/MGdGmyUmHBdiTGI6qaLZUsEi3xCgwlC?=
 =?us-ascii?Q?yE7IVDsFkfuBgN7IWNWinTDe8xd7mQ/ve2qzgbfQtPo7prhxnTu5hM3u5d+6?=
 =?us-ascii?Q?PrF126c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xvtCakEh8O5S6Hfhz2Zjw4RTJ+EWP3aBgMQynqdEbXrl6EB6r9VUdWk+Fd0k?=
 =?us-ascii?Q?5+FxP40tSqBQ7+QlrlrFC5frjuvGu65jOg7dL7CnYqom96jud78WOgMAQFW9?=
 =?us-ascii?Q?lg2kSDxC7Szf1XzXCF4ZG07CxdNjQzQRE/Gs9AXJPTTa2He0OGpGALO5DnjY?=
 =?us-ascii?Q?j6W8aPHChZ5JoW2WrfI1UvMscUxIjCkiUXbmanXW5SztidjcZA0xx04k9XIj?=
 =?us-ascii?Q?qLkXCG+e8dERNlWqP/3e7twmIGHkqW7pe6LH1hDcFgVKwRWc+hwIbuzuDuoI?=
 =?us-ascii?Q?XCD6Evizh3Sq37UkprRy4XipYnUW3PUapn2efWhfL5kPuciUDktc0J+PfRBD?=
 =?us-ascii?Q?C5lj4ZG5EzQtICPwJTnTQBqTqxKPsKrqKI9+kKVGUbEQVbqNolJdzDhEb2f0?=
 =?us-ascii?Q?B3/sI/actvQX8aHgHEL+V2NALc1NCLEcmXcr+kzyG2KiYUizvRk9w4f3Gd6n?=
 =?us-ascii?Q?kx8FTFKmJTH5De1y3K0dIvxAIFk+b3bzFnuGusNilM2D5dMb42os+UiccUUk?=
 =?us-ascii?Q?b/4ZIlqPLN+CV0gK3hrOSuH3j83tfey1aV60c8FYQZWBp50hZNASzMPdAzvD?=
 =?us-ascii?Q?bIVsfsJ7mMnkkLJbtgJteYIhb2mHQM7RU0LGcrVzt85BpgpIaxUbPjciPOE/?=
 =?us-ascii?Q?VC0jB+JB/jig9Qf1aMciLCAZqQMXd2hPafw+OR2qui2cZi4Ezj9pNla13zgM?=
 =?us-ascii?Q?JCEWsdukufwv1IQFXHi/OpGmWEgpLr/QCagzx2qPeye/mgEoWWWsa3yLXt2N?=
 =?us-ascii?Q?bbTPAX5y4VN9Z2oRT9EjLYCkDE38vXRBg2IUAJo5zmkdLREAAorWzCjMHUqS?=
 =?us-ascii?Q?blLSL+V9rYkHILzRuD8n2r0qg5mQW8bMl/yNsBrJV59pFgq2gxAw2aJOMuZi?=
 =?us-ascii?Q?C0Y4H9664yfSVO6Kj3kAsAM+l0670aJv8Xy9eEcHn4v1C9KhTo+6mzLEoJ91?=
 =?us-ascii?Q?atG6pHjUW8yskjf4JeOcPZPIlM4fY70tqWoO3xNstDro7plCzoYUR/HwuMEu?=
 =?us-ascii?Q?sndKDqCGZPAUyLKeXm6ZTHYO3178+gvbsqBpL4q9uFw7re6/gPdAWcSyFrJM?=
 =?us-ascii?Q?w9MwaCvuJAOFKWf9L0oGGHDpjYpAgZduYmGRvlklHHj3m1jauZ+M8s0RgE/W?=
 =?us-ascii?Q?gtQmsn0O1qhdPQCKuTM2g3SQb/8v7t0AazIGkA6KYZLRhdEYR17vqmNnXt4n?=
 =?us-ascii?Q?iIy4PQoac30A+l6CVUIIESHhHIfzQE9No23pXIlNvBtF4IsrUg0DNiXDa0sa?=
 =?us-ascii?Q?Qbz0KDFRSzIVLwAKN3GYHLIygALWKPMykMpRFa9AZzx+NCXsaoanvTHcAwGD?=
 =?us-ascii?Q?+7zOkoi75iM+elLPIbYrOM3OTAsZosZ8pgWb76rh2RrTNoIRDzNrsOGgj71R?=
 =?us-ascii?Q?2Soc0NxwHYa1ytkXslIEFH0v7j2/4pOKMPsWXKa5iFyAXdvZhkTaqk80dt4G?=
 =?us-ascii?Q?VhZhA7eZ5VZhAZA+TEl18O7K081iOGdHZKAqC/cJSzl+r00uJnABs5b6g/Fn?=
 =?us-ascii?Q?P1iKanqiF6etykHBNl1g1tibJcIw+1EcX61DJSfIdtz+lY9lr1aF9jPYATa7?=
 =?us-ascii?Q?Fff529F462oJGSgC8zwPU8CSJbauSk4ex4PI4Fl+3CrrkeAdF8fgpx436OAg?=
 =?us-ascii?Q?mA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b7520b-8a60-4cc6-5a74-08dcff7c18a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 22:32:43.3479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U+lVPmvSjcs+W7P3Elhgw5bw2e8G7OFLfkfFJneu3ZXtQ/RytWtgx+7VvE/FX1VJ1LOUol90vpnf9glRjXB3o1m7s6C6ZYgsB/WCro4Pr8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4668
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Johannes Weiner <hannes@cmpxchg.org>
> Sent: Thursday, November 7, 2024 10:16 AM
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
> Subject: Re: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA
> in zswap_store() of large folios.
>=20
> On Wed, Nov 06, 2024 at 11:21:05AM -0800, Kanchana P Sridhar wrote:
> > If the system has Intel IAA, and if sysctl vm.compress-batching is set =
to
> > "1", zswap_store() will call crypto_acomp_batch_compress() to compress =
up
> > to SWAP_CRYPTO_BATCH_SIZE (i.e. 8) pages in large folios in parallel us=
ing
> > the multiple compress engines available in IAA hardware.
> >
> > On platforms with multiple IAA devices per socket, compress jobs from a=
ll
> > cores in a socket will be distributed among all IAA devices on the sock=
et
> > by the iaa_crypto driver.
> >
> > With deflate-iaa configured as the zswap compressor, and
> > sysctl vm.compress-batching is enabled, the first time zswap_store() ha=
s to
> > swapout a large folio on any given cpu, it will allocate the
> > pool->acomp_batch_ctx resources on that cpu, and set pool-
> >can_batch_comp
> > to BATCH_COMP_ENABLED. It will then proceed to call the main
> > __zswap_store_batch_core() compress batching function. Subsequent calls
> to
> > zswap_store() on the same cpu will go ahead and use the acomp_batch_ctx
> by
> > checking the pool->can_batch_comp status.
> >
> > Hence, we allocate the per-cpu pool->acomp_batch_ctx resources only on
> an
> > as-needed basis, to reduce memory footprint cost. The cost is not incur=
red
> > on cores that never get to swapout a large folio.
> >
> > This patch introduces the main __zswap_store_batch_core() function for
> > compress batching. This interface represents the extensible compress
> > batching architecture that can potentially be called with a batch of
> > any-order folios from shrink_folio_list(). In other words, although
> > zswap_store() calls __zswap_store_batch_core() with exactly one large f=
olio
> > in this patch, we can reuse this interface to reclaim a batch of folios=
, to
> > significantly improve the reclaim path efficiency due to IAA's parallel
> > compression capability.
> >
> > The newly added functions that implement batched stores follow the
> > general structure of zswap_store() of a large folio. Some amount of
> > restructuring and optimization is done to minimize failure points
> > for a batch, fail early and maximize the zswap store pipeline occupancy
> > with SWAP_CRYPTO_BATCH_SIZE pages, potentially from multiple
> > folios. This is intended to maximize reclaim throughput with the IAA
> > hardware parallel compressions.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  include/linux/zswap.h |  84 ++++++
> >  mm/zswap.c            | 625
> ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 709 insertions(+)
> >
> > diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> > index 9ad27ab3d222..6d3ef4780c69 100644
> > --- a/include/linux/zswap.h
> > +++ b/include/linux/zswap.h
> > @@ -31,6 +31,88 @@ struct zswap_lruvec_state {
> >  	atomic_long_t nr_disk_swapins;
> >  };
> >
> > +/*
> > + * struct zswap_store_sub_batch_page:
> > + *
> > + * This represents one "zswap batching element", namely, the
> > + * attributes associated with a page in a large folio that will
> > + * be compressed and stored in zswap. The term "batch" is reserved
> > + * for a conceptual "batch" of folios that can be sent to
> > + * zswap_store() by reclaim. The term "sub-batch" is used to describe
> > + * a collection of "zswap batching elements", i.e., an array of
> > + * "struct zswap_store_sub_batch_page *".
> > + *
> > + * The zswap compress sub-batch size is specified by
> > + * SWAP_CRYPTO_BATCH_SIZE, currently set as 8UL if the
> > + * platform has Intel IAA. This means zswap can store a large folio
> > + * by creating sub-batches of up to 8 pages and compressing this
> > + * batch using IAA to parallelize the 8 compress jobs in hardware.
> > + * For e.g., a 64KB folio can be compressed as 2 sub-batches of
> > + * 8 pages each. This can significantly improve the zswap_store()
> > + * performance for large folios.
> > + *
> > + * Although the page itself is represented directly, the structure
> > + * adds a "u8 batch_idx" to represent an index for the folio in a
> > + * conceptual "batch of folios" that can be passed to zswap_store().
> > + * Conceptually, this allows for up to 256 folios that can be passed
> > + * to zswap_store(). If this conceptual number of folios sent to
> > + * zswap_store() exceeds 256, the "batch_idx" needs to become u16.
> > + */
> > +struct zswap_store_sub_batch_page {
> > +	u8 batch_idx;
> > +	swp_entry_t swpentry;
> > +	struct obj_cgroup *objcg;
> > +	struct zswap_entry *entry;
> > +	int error; /* folio error status. */
> > +};
> > +
> > +/*
> > + * struct zswap_store_pipeline_state:
> > + *
> > + * This stores state during IAA compress batching of (conceptually, a =
batch
> of)
> > + * folios. The term pipelining in this context, refers to breaking dow=
n
> > + * the batch of folios being reclaimed into sub-batches of
> > + * SWAP_CRYPTO_BATCH_SIZE pages, batch compressing and storing the
> > + * sub-batch. This concept could be further evolved to use overlap of =
CPU
> > + * computes with IAA computes. For instance, we could stage the post-
> compress
> > + * computes for sub-batch "N-1" to happen in parallel with IAA batch
> > + * compression of sub-batch "N".
> > + *
> > + * We begin by developing the concept of compress batching. Pipelining
> with
> > + * overlap can be future work.
> > + *
> > + * @errors: The errors status for the batch of reclaim folios passed i=
n from
> > + *          a higher mm layer such as swap_writepage().
> > + * @pool: A valid zswap_pool.
> > + * @acomp_ctx: The per-cpu pointer to the crypto_acomp_ctx for the
> @pool.
> > + * @sub_batch: This is an array that represents the sub-batch of up to
> > + *             SWAP_CRYPTO_BATCH_SIZE pages that are being stored
> > + *             in zswap.
> > + * @comp_dsts: The destination buffers for crypto_acomp_compress() for
> each
> > + *             page being compressed.
> > + * @comp_dlens: The destination buffers' lengths from
> crypto_acomp_compress()
> > + *              obtained after crypto_acomp_poll() returns completion =
status,
> > + *              for each page being compressed.
> > + * @comp_errors: Compression errors for each page being compressed.
> > + * @nr_comp_pages: Total number of pages in @sub_batch.
> > + *
> > + * Note:
> > + * The max sub-batch size is SWAP_CRYPTO_BATCH_SIZE, currently 8UL.
> > + * Hence, if SWAP_CRYPTO_BATCH_SIZE exceeds 256, some of the
> > + * u8 members (except @comp_dsts) need to become u16.
> > + */
> > +struct zswap_store_pipeline_state {
> > +	int *errors;
> > +	struct zswap_pool *pool;
> > +	struct crypto_acomp_ctx *acomp_ctx;
> > +	struct zswap_store_sub_batch_page *sub_batch;
> > +	struct page **comp_pages;
> > +	u8 **comp_dsts;
> > +	unsigned int *comp_dlens;
> > +	int *comp_errors;
> > +	u8 nr_comp_pages;
> > +};
>=20
> Why are these in the public header?

Thanks Johannes, for the detailed code review comments! Yes, these don't
need to belong in the public header. I will move them to zswap.c.

>=20
> >  unsigned long zswap_total_pages(void);
> >  bool zswap_store(struct folio *folio);
> >  bool zswap_load(struct folio *folio);
> > @@ -45,6 +127,8 @@ bool zswap_never_enabled(void);
> >  #else
> >
> >  struct zswap_lruvec_state {};
> > +struct zswap_store_sub_batch_page {};
> > +struct zswap_store_pipeline_state {};
> >
> >  static inline bool zswap_store(struct folio *folio)
> >  {
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 2af736e38213..538aac3fb552 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -255,6 +255,12 @@ static int zswap_create_acomp_ctx(unsigned int
> cpu,
> >  				  char *tfm_name,
> >  				  unsigned int nr_reqs);
> >
> > +static bool __zswap_store_batch_core(
> > +	int node_id,
> > +	struct folio **folios,
> > +	int *errors,
> > +	unsigned int nr_folios);
> > +
>=20
> Please reorder the functions to avoid forward decls.

Sure.

>=20
> >  /*********************************
> >  * pool functions
> >  **********************************/
> > @@ -1626,6 +1632,12 @@ static ssize_t zswap_store_page(struct page
> *page,
> >  	return -EINVAL;
> >  }
> >
> > +/*
> > + * Modified to use the IAA compress batching framework implemented in
> > + * __zswap_store_batch_core() if sysctl vm.compress-batching is 1.
> > + * The batching code is intended to significantly improve folio store
> > + * performance over the sequential code.
>=20
> This isn't helpful, please delete.

Ok.

>=20
> >  bool zswap_store(struct folio *folio)
> >  {
> >  	long nr_pages =3D folio_nr_pages(folio);
> > @@ -1638,6 +1650,38 @@ bool zswap_store(struct folio *folio)
> >  	bool ret =3D false;
> >  	long index;
> >
> > +	/*
> > +	 * Improve large folio zswap_store() latency with IAA compress
> batching,
> > +	 * if this is enabled by setting sysctl vm.compress-batching to "1".
> > +	 * If enabled, the large folio's pages are compressed in parallel in
> > +	 * batches of SWAP_CRYPTO_BATCH_SIZE pages. If disabled, every
> page in
> > +	 * the large folio is compressed sequentially.
> > +	 */
>=20
> Same here. Reduce to "Try to batch compress large folios, fall back to
> processing individual subpages if that fails."

Ok.

>=20
> > +	if (folio_test_large(folio) && READ_ONCE(compress_batching)) {
> > +		pool =3D zswap_pool_current_get();
>=20
> There is an existing zswap_pool_current_get() in zswap_store(), please
> reorder the sequence so you don't need to add an extra one.

Ok, will do this. I was trying to make the code less messy, but will find
a cleaner way.

>=20
> > +		if (!pool) {
> > +			pr_err("Cannot setup acomp_batch_ctx for compress
> batching: no current pool found\n");
>=20
> This is unnecessary.

Ok.

>=20
> > +			goto sequential_store;
> > +		}
> > +
> > +		if (zswap_pool_can_batch(pool)) {
>=20
> This function is introduced in another patch, where it isn't
> used. Please add functions and callers in the same patch.

Ok. Unintended side effects of trying to break down the changes
into smaller commits. Will address this in v4.

>=20
> > +			int error =3D -1;
> > +			bool store_batch =3D __zswap_store_batch_core(
> > +						folio_nid(folio),
> > +						&folio, &error, 1);
> > +
> > +			if (store_batch) {
> > +				zswap_pool_put(pool);
> > +				if (!error)
> > +					ret =3D true;
> > +				return ret;
> > +			}
> > +		}
>=20
> Please don't future proof code like this, only implement what is
> strictly necessary for the functionality in this patch. You're only
> adding a single caller with nr_folios=3D1, so it shouldn't be a
> parameter, and the function shouldn't have a that batch_idx loop.

Ok.

>=20
> > +		zswap_pool_put(pool);
> > +	}
> > +
> > +sequential_store:
> > +
> >  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> >  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> >
> > @@ -1724,6 +1768,587 @@ bool zswap_store(struct folio *folio)
> >  	return ret;
> >  }
> >
> > +/*
> > + * Note: If SWAP_CRYPTO_BATCH_SIZE exceeds 256, change the
> > + * u8 stack variables in the next several functions, to u16.
> > + */
> > +
> > +/*
> > + * Propagate the "sbp" error condition to other batch elements belongi=
ng
> to
> > + * the same folio as "sbp".
> > + */
> > +static __always_inline void zswap_store_propagate_errors(
> > +	struct zswap_store_pipeline_state *zst,
> > +	u8 error_batch_idx)
> > +{
>=20
> Please observe surrounding coding style on how to wrap >80 col
> function signatures.

I see. Ok.

>=20
> Don't use __always_inline unless there is a clear, spelled out
> performance reason. Since it's an error path, that's doubtful.

The motivation was incompressible pages, but sure, will address in v4.

>=20
> Please use a consistent namespace for all this:
>=20
> CONFIG_ZSWAP_BATCH
> zswap_batch_store()
> zswap_batch_alloc_entries()
> zswap_batch_add_folios()
> zswap_batch_compress()
>=20
> etc.
>=20
> Again, order to avoid forward decls.
>=20
> Try to keep the overall sequence of events between zswap_store() and
> zswap_batch_store() similar as much as possible for readability.

Definitely.

Thanks,
Kanchana
