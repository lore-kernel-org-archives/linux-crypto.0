Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFCE1DAC93;
	Tue,  3 Dec 2024 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733264280; cv=fail; b=HdjXZR4A8RoYDxBXdwVi91KW+b6wbj0ACZP60sg5XKXy8jDo2y5cjXNBTu1TguyhgxNKAiiQ9a6c6NDeCB8p/5mBgWazevej0Sc26ixy6d28ln/ivZroLoZGc2pnWFZuVCnRs0ar8pJfpwOsChku0fcoGEpAL1J7aqYFL2wxnHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733264280; c=relaxed/simple;
	bh=eRcrvJ6Uc64bDnSw9Io1w2vW+x50nHHQVdBtf8SCxqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WNEohtdufaSVAP+p+EX8AQMLZSu4/npP+lfoEoJXLrqIVKBOXzne95VJa9kh2asQ1Lystf/IVkuCjmQUmIp5rS+Fzf5B6vZ137CWwaR1wBDGWB0ygWp3qtUzAKfO2W6Noa6doiqtL+imTXI+FrgcnY4JlWcdGevuHFCDZvc+p90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nltvrLjp; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nltvrLjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733264278; x=1764800278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eRcrvJ6Uc64bDnSw9Io1w2vW+x50nHHQVdBtf8SCxqw=;
  b=nltvrLjpRlrNMuUytf2ukd1p0QlNCxzy1fEHovKRF8XI9ymJRF4u65mx
   kUjpkWsZCZMTjoqaFvkTkIpFwPnOBKarZu4tRhzZ5j+agcAddD85Iv1M1
   OgP2boQxH9TOCBxGxkygMkBmeHxTP/g/t4nIIxmdDonEjwAUKPWzCcibO
   gT8lQIFWb1xp7fkW/Bj/iaW7KolJMX8gCB/gZ7XJbqgzPDWp/eUszJvmN
   kHnzfXif3MLUYZHmfzFRmYIgWrYS4EakZWQNdShNx38g5V1G37pWX1TY3
   iDfZc7GRzFqwm3q/7Akrp4SSgTNA5yL8Ezdj+8JaKFLLmOpIredBYkdN5
   Q==;
X-CSE-ConnectionGUID: 3GiZcdqGSl2RtAZV8w8hoQ==
X-CSE-MsgGUID: rh9TDzfZRAuSau/O+OMfog==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="58907881"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="58907881"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 14:17:57 -0800
X-CSE-ConnectionGUID: 2+oPRKrkRyWXqkcsPXxNNQ==
X-CSE-MsgGUID: T3ZtAELcTRKPU0OmZUW1cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93430555"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 14:17:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 14:17:56 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 14:17:56 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 14:17:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKVFmAMUF8/KjD4IU4TS6KMHznDfSoQ4h+MRYZXmq4uC5eePz0ffbMUAkhVIKvXvK9/I/LnQHtLC2xjmAaeuKQUsGeCpNWCv6nGw6+ig9QP8UI3sGA4Sox4QUCGeueDFuCu5b5Jr8fqFZDbLJxWGycNvlcBya2X8vFbN+KQfkLQxsyCQC1uhKWa2R+TS+VdwoQPKjTuQAeBgJaXheG847JTQn48R6ttevqafv+Ga0Y1Ui8BK7g+lrI/EGY7dLhaacAeatMh5LjZATzfNeRC2xIXlwgrTjMTFpg64yp+oXS0kStHhsZSb+oCzD4o84qG8PR8QKm97e1TkOH5DbhDVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRcrvJ6Uc64bDnSw9Io1w2vW+x50nHHQVdBtf8SCxqw=;
 b=yNV5JKqjfY3QsAGcnfJwIPdyWmh+aqR9hry5Zq/uk4/9DG5M/QyDo+vPzRcjgDGIG03cx4ickx2NndqywE4JohY3mf5bRYpxlMneJUvkjsgXBnxFaWAo25t0a/AJhve4gR1i8PuuG3vOsj4ezx7Z0Ln3cpqC8JXGS3f7ypzFbbItshp65NkOZ0LWdBmCguTsWaYoOue81adxsl6ZgjubRAXebklsv+dYwQxnZIMmzlwmfVR39u7elNO3vSz3c8jWH2q7BB9FHs666m4YBieuIHdPLdsBrBqlpwtHUH7aJh1o1UaAZRyKbRzV+vm4VkWVJr1IgHc18zbmykefSQ/+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CYYPR11MB8360.namprd11.prod.outlook.com (2603:10b6:930:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 22:17:48 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 22:17:48 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Topic: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaCAAIvAgIAA4a2QgAAEXQCAAACVwA==
Date: Tue, 3 Dec 2024 22:17:48 +0000
Message-ID: <SJ0PR11MB56789D21AAA0970F9B8AB5CFC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au>
 <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
In-Reply-To: <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CYYPR11MB8360:EE_
x-ms-office365-filtering-correlation-id: 0afe88c7-9622-4487-c0d3-08dd13e851e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UFhwRCsyNWhDTkxkZzFqZENxWS83RHZ4bFRkcG5DZUowZWp0c2ZTV0lKSnEy?=
 =?utf-8?B?ZEVIYURjZmIrQ3d0S0VjaUgvNmJXY3JVU1dBUmRiNVVSdFFMNDJJMEU4M0tC?=
 =?utf-8?B?UFRxVTZ3TkdDM1BKQWdlSkdlV3haSU5kOExwclUxMmJ2Rjg0NTFiUVRWTmdF?=
 =?utf-8?B?aDROczFSaENVQnB3citLM29vdmV4N2N4YnRxbExncVdKRDVsbThNMTJmL1ZK?=
 =?utf-8?B?UTFrUHlOUmFNbFUwWkpwd2FFNGZMYjVmMkR4ZElMazQ1ZTFVOWVob3h5NFZv?=
 =?utf-8?B?QVg5UlJNUEJ0Mjh2MFZKRkhGK3lNSktneDZSUVUwZ0xENGNXWDJGT2swOURh?=
 =?utf-8?B?ZXpKSW50VnQxbmozaVVPZ08vR0lvbjVjYU5WcnZzdGhzZTVjVmZzWXEwVVFH?=
 =?utf-8?B?Q2hZRFYwQnNhWTgrOG5CcFFvRXhkTWdSVWpZZGtSRWYxbmFCZndiV0V2Z1ly?=
 =?utf-8?B?WTZjbno1WGxIeEo3VGgrbWFIUUdDdTIvSXpKSm4wR1J6Q2lKMHp6aFVNS1lS?=
 =?utf-8?B?VjhJRkxKem9ORFJLenFyWWNRbzJwT0dJaE5MaDVabDNoZXFPaDlzemk2bVdp?=
 =?utf-8?B?SVUwMU9OMWxlWjRtWncyWUo4WkMwN25YT2FtZTdXY0NQVzlFb2pqSUU3QXZq?=
 =?utf-8?B?N01SWEEvWGV4L2FlYW81SVU2dnd1SFVEV0UwWGIrS1JKUitOazEwRlNjeUJV?=
 =?utf-8?B?RGN0TWhmRFMyNWpmK3pRQVpzNTdCOEIwMkZrK3B5WFpZTlJjYWZybjROaWY1?=
 =?utf-8?B?d1BuckpmeWpvOTU3dnlCRk5SUUI0TXJFeUU5d2MwblQzNXZGdVdMMlZ4Um5h?=
 =?utf-8?B?dTE5Y3Vpa1pkMEMydWxqcERvOHh4dWtkSk9oall4eDJkWmZ4SU5LUkI4RUky?=
 =?utf-8?B?R3BIaERMcHVGQU1OMDdlNU9Zc1d5UW91d2RSYWYybXAwWjJYRkNoMG00ayt0?=
 =?utf-8?B?Y2hRWXpVQUgzdXNNSElWc0dpaERGYXpycHdmUHNFY3lTRzZEZngzbUFDRWhV?=
 =?utf-8?B?VndDdldwcFl3TjdXMTNWbUQ0NGNCdi85aTNaNXRDVzlPZWZJTThZWXQwY3NC?=
 =?utf-8?B?WHJta0hvUFYrVU5aQmpVRXVxekRlbk1ObTErWWo1Rk94VFFxZ2RzcXpsVmli?=
 =?utf-8?B?T1lnendRSFYyUC9OdlF3QkxYRXZUbk5uTmptbXdxUEJKZm9kN0Y5RXNwV1BG?=
 =?utf-8?B?UEpMNFRHVXBJRitxWmU1ODlVYXdwcUxLb1FUbnAwZFhHYjR3aGhKcEJ5eGxM?=
 =?utf-8?B?Qjc3RkhYT1ZYSzZIa3NTck9NWkczbFQvanoxTmlQSmJUeXY2bG81UUJtYkJV?=
 =?utf-8?B?c0sycytYQUI2RExiWmRRSVhIT1lMbXVJbG5hcmN3Uk5uYXlPV09jK2xvdEdJ?=
 =?utf-8?B?QXdUN2FqelppaWRtRzg1cU9kZk01VDYycFhDOTVGN3ZMSXU3a2dQZnRVbzdU?=
 =?utf-8?B?aDJpcUNyR3prN0s4VDA2ZVFIM3pKaEVKZUhXZ1MrczJPbmduM2pENE12WG1F?=
 =?utf-8?B?WmE2c1BZYS93cGEyUUtQYTRHSlB3NWVvOENYbHAvSnNWWHJRK0ZidmFTZGpB?=
 =?utf-8?B?eWdEWHJsRFYwV2tPYW1qTkFuS25rNjEwaEVkSE1oRnlmVVJRN0xvQ1Y2R3Vs?=
 =?utf-8?B?Y0NQVm53QjYrc3ZBZ3E0cWlnQUlNVXZYSlkvVXZxeFFvU29sMkRZQmFaT0lw?=
 =?utf-8?B?ampuSlc1UTc4MkpMK2k3bXdSZktkcEpoOVhkdnU1LzNObjd0Y3NaRS9rM0N3?=
 =?utf-8?B?bWxTYzdYdElDSjlZc3NianFsNEpNNmpDU3NqUjBXTEttQllwblFlVjZ4cEp5?=
 =?utf-8?Q?VSi8xHiWVjCk/3sCwtHatQnYNFIPhoPEgPY7U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0Y1NGlleXpHUnpZRnlnZHo3QkQwQUdsWEdlcy9CNXhHUlIrVjVXV1Z3end2?=
 =?utf-8?B?dFhrMkw3elE3Zy8zbzIyTDRMR3FwQU1OTms5dmxJRHZoME9BMDFXNHZ3VzFD?=
 =?utf-8?B?MGlacDAwdGtHbVhYU2RFdlNvZktXZFNxVGdvbjdjaGJnNUVleG1iRWFuKzk2?=
 =?utf-8?B?RzRtRzdobFEvMS9JYmFwVUNJMEpBQ2F4RUNoTERneXlHQ3QzNGlSOGVla2VX?=
 =?utf-8?B?M0RlZTdVN2ppVE0yZEhiOUZuSDRjN0NSK28vVGZHU3hDTEExTTg5akp5QTBF?=
 =?utf-8?B?YlFEZ0Vmb1VYOFBYRHBYVmorR1p3MnBZZlhGVW9jbzA3N1Q3ZXkrdEd2QlJY?=
 =?utf-8?B?OTFPczlYUElySzQ3WHBOZE93emJzUGo5WWUydGdaSjNwcXZYM1l0b2xabzNw?=
 =?utf-8?B?OXlVOEU5ZUhuQUtZR3duWGhxNXZySVlmNTdERGlSeXA1QUZxUVV0MG1pMGN2?=
 =?utf-8?B?M21UVlNiTHJsTHNWa2JVNjdJc0RQSGU0cXJWcjNxL1pwVkJ3c0hmbEZQRkNa?=
 =?utf-8?B?ajc0cmdtbDRrUjVUK3ArL0FHRitkOHAxODRlNGVSb0ZmZTNLZU9XQUxnNHFa?=
 =?utf-8?B?UG9LL1pBQ3RQdUtkcEx0c1BvdllqbFBxOTNkQ1lhS3piMWtMTVd1anJOOEg5?=
 =?utf-8?B?Wlp4LzNRR01ISndaWmlsTEpFVGNFZm13MmJMVzNVMXBDaTV4VmR1Snhzd3Fy?=
 =?utf-8?B?ZUU4ZVZTTGNpYU5UL3UzbUtUeERpbHF3YXhkSGlBL29yUFNnT3lNd2FTQjk4?=
 =?utf-8?B?NkpZUXdZMk9rbkNNeE1FR0k0MGRVdlQ3Y0puazdHYTN3L0JSQ25nSDU1NHNx?=
 =?utf-8?B?T0VMK0FaTy95K3FlTXVFQUlWbEFscFJvV2tQdjZxVlI0d04xUlpaL1E0M3E4?=
 =?utf-8?B?dnVKU3MrWUJCdzgwd3RJRERjdjhHcUVpRkhLbmYxc1RwU0RqbzFYZzQxNHBF?=
 =?utf-8?B?Qmh3ZzZLbEJEaXREdjcwTGp2NGc2QjI2UmZQd016UzZncXlhSmtqQWI2Q205?=
 =?utf-8?B?NlMweVNsam9qNUl1MmFhYTVraVlGVUczenpXSm1VWmJMQXoyRnhmY2pDVzM5?=
 =?utf-8?B?bXZ6WnoxbDE3WWl6YXBmcGgzRW8raGNraHpUT1NHNmNZOENsQXFuR1hqcXRZ?=
 =?utf-8?B?ejQxZ3dCUWxzTUNEcEpaYms5ejR3QWhFYWNoNXdhY2hveVl4VklESjhJRjlq?=
 =?utf-8?B?YzZIY1l6cGdTNTg0Tm9lU2xPZ1p4dUQwRi8zNE9MNGZjRTFTQlJHMjFLenRt?=
 =?utf-8?B?RHY4cXovdjc3NkQ3dXFiWFpwSFlDV1dpdHZySS9pWTR5Z3B4KzFxbXZSUFQ4?=
 =?utf-8?B?Wjl2bG5yK2JibnBKSVVNdXlXcTV4SXA1d1NKaEFBUDFkM1BCNi9Mcm5TRVkz?=
 =?utf-8?B?dVhhV1UvT251dElnRldFOG9DSTUzTWJxUGNmY1JkaFBQSGVIM3dSQWhUckFz?=
 =?utf-8?B?allscDU1TGFaUTBhN2JUK3B5WUVEV3dIaWltM293SHlNQkMyN3BSYTdhZkNG?=
 =?utf-8?B?Z1dSTXFackZFaGhic3NyeVMwSnVTazQyWk1mNzhRWTRoVVdjWDgxWGRlTXlv?=
 =?utf-8?B?d3RRY0g3Q2lLOVB0dDdyS3NmNGFIZU1vS3IrSUcyYjVNY3lRNWdkZ2FuNjBF?=
 =?utf-8?B?NHk0TkZXUFRlZ0VvbSttOFNkY2lyK1N5aUlqSUNDK1VmV01nLzJIU1lHS0Zt?=
 =?utf-8?B?czV2WGJZRGY5b2FYR0xlNmUyOTNmSHRMdVk2S2lEWWJ1dFhGalp6ZDhxUE5q?=
 =?utf-8?B?eEV4WmdGMW1iUTV1c2dBMXF5c2hTZndlQnE2YzN3VDRwc21tUkZsNC9NazN3?=
 =?utf-8?B?QXZHMlhWOE9IVThMb3UxSTVsVzZ4dW9XOW8rYUZUdnBaeDBWeUtxb2trKzk0?=
 =?utf-8?B?Zk81V0Y4TTNLZHNuQ2NwODRwTjRoS0lTVEErQ1lMVSt1ZUdCWDVKZWZoL2F1?=
 =?utf-8?B?RzczaXdCV1VXQU1sU3VucUcwZjdUTWhxNEQyaERxTHJsYjJ0VnhKdnNnaU0v?=
 =?utf-8?B?aFd3K3d6UW9jTVZTVlNsYzZkRzB5dXhUMy90MWFLbXZVMi9XaDdGaUVaSUJ4?=
 =?utf-8?B?YTAxZ01aSHBXVkFnTXBJZW5yUkV1dFFtZ2JBQ2ZNb2k0Wld6aXpRcXlyVzNu?=
 =?utf-8?B?VkwrUFlqZW4zcyttbUFSbTJDSng3dWhMTUg3RDUrV3hYWnpzaGMrU0ZyaHZj?=
 =?utf-8?B?clhNRlpGdWVMdWp1Nlp0MzkyWXdqNzAzNERQMU11UWZadjJobm9EVEwyYWNC?=
 =?utf-8?B?QXBTWS9XdUIzOHRhSmN1QVkvOHlBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afe88c7-9622-4487-c0d3-08dd13e851e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 22:17:48.3743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDAlUyKVuE3/NmQn9IloZdp7NBxPB8g9dH7wqUgZo1UmrT2nV0zLsDc2tZThfsQKatnDwsGvOCpxkrRnTgFDeMWalmoJ6m4ddR7twgU0Bag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8360
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDMsIDIwMjQgMTo0
NCBQTQ0KPiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVs
LmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IE5o
YXQgUGhhbQ0KPiA8bnBoYW1jc0BnbWFpbC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgY2hlbmdtaW5n
Lnpob3VAbGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNA
YXJtLmNvbTsgeWluZy5odWFuZ0BpbnRlbC5jb207DQo+IDIxY25iYW9AZ21haWwuY29tOyBha3Bt
QGxpbnV4LWZvdW5kYXRpb24ub3JnOyBsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJlLmNvbTsNCj4gYXJkYkBrZXJuZWwu
b3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwNCj4g
S3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+OyBGZWdoYWxpLCBXYWpkaSBL
DQo+IDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsIFZpbm9kaCA8dmlub2RoLmdv
cGFsQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAwOS8xMF0gbW06IHpzd2Fw
OiBBbGxvY2F0ZSBwb29sIGJhdGNoaW5nIHJlc291cmNlcyBpZg0KPiB0aGUgY3J5cHRvX2FsZyBz
dXBwb3J0cyBiYXRjaGluZy4NCj4gDQo+IE9uIFR1ZSwgRGVjIDMsIDIwMjQgYXQgMTozN+KAr1BN
IFNyaWRoYXIsIEthbmNoYW5hIFANCj4gPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+IHdy
b3RlOg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBG
cm9tOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+ID4gPiBTZW50
OiBUdWVzZGF5LCBEZWNlbWJlciAzLCAyMDI0IDEyOjAxIEFNDQo+ID4gPiBUbzogU3JpZGhhciwg
S2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gPiA+IENjOiBOaGF0
IFBoYW0gPG5waGFtY3NAZ21haWwuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsN
Cj4gbGludXgtDQo+ID4gPiBtbUBrdmFjay5vcmc7IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnlh
aG1lZEBnb29nbGUuY29tOw0KPiA+ID4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFy
aWY2NDJAZ21haWwuY29tOw0KPiA+ID4gcnlhbi5yb2JlcnRzQGFybS5jb207IHlpbmcuaHVhbmdA
aW50ZWwuY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4gPiA+IGFrcG1AbGludXgtZm91bmRhdGlv
bi5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+ID4gPiBlYmln
Z2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+
ID4gPiA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8
d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47DQo+ID4gPiBHb3BhbCwgVmlub2RoIDx2aW5vZGgu
Z29wYWxAaW50ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAwOS8xMF0gbW06
IHpzd2FwOiBBbGxvY2F0ZSBwb29sIGJhdGNoaW5nDQo+IHJlc291cmNlcyBpZg0KPiA+ID4gdGhl
IGNyeXB0b19hbGcgc3VwcG9ydHMgYmF0Y2hpbmcuDQo+ID4gPg0KPiA+ID4gT24gVHVlLCBEZWMg
MDMsIDIwMjQgYXQgMTI6MzA6MzBBTSArMDAwMCwgU3JpZGhhciwgS2FuY2hhbmEgUCB3cm90ZToN
Cj4gPiA+ID4NCj4gPiA+ID4gPiBXaHkgZG8gd2UgbmVlZCB0aGlzICJjYW5fYmF0Y2giIGZpZWxk
PyBJSVVDLCB0aGlzIGNhbiBiZSBkZXRlcm1pbmVkDQo+ID4gPiA+ID4gZnJvbSB0aGUgY29tcHJl
c3NvciBpbnRlcm5hbCBmaWVsZHMgaXRzZWxmLCBubz8NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IGFj
b21wX2hhc19hc3luY19iYXRjaGluZyhhY29tcCk7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJcyB0
aGlzIGp1c3QgZm9yIGNvbnZlbmllbmNlLCBvciBpcyB0aGlzIGFjdHVhbGx5IGFuIGV4cGVuc2l2
ZSB0aGluZyB0bw0KPiA+ID4gY29tcHV0ZT8NCj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtzIGZvciB5
b3VyIGNvbW1lbnRzLiBUaGlzIGlzIGEgZ29vZCBxdWVzdGlvbi4gSSB0cmllZCBub3QgdG8gaW1w
bHkNCj4gdGhhdA0KPiA+ID4gPiBiYXRjaGluZyByZXNvdXJjZXMgaGF2ZSBiZWVuIGFsbG9jYXRl
ZCBmb3IgdGhlIGNwdSBiYXNlZCBvbmx5IG9uIHdoYXQNCj4gPiA+ID4gYWNvbXBfaGFzX2FzeW5j
X2JhdGNoaW5nKCkgcmV0dXJucy4gSXQgaXMgcG9zc2libGUgdGhhdCB0aGUgY3B1IG9ubGluaW5n
DQo+ID4gPiA+IGNvZGUgcmFuIGludG8gYW4gLUVOT01FTSBlcnJvciBvbiBhbnkgcGFydGljdWxh
ciBjcHUuIEluIHRoaXMgY2FzZSwgSQ0KPiBzZXQNCj4gPiA+ID4gdGhlIHBvb2wtPmNhbl9iYXRj
aCB0byAiZmFsc2UiLCBtYWlubHkgZm9yIGNvbnZlbmllbmNlLCBzbyB0aGF0IHpzd2FwDQo+ID4g
PiA+IGNhbiBiZSBzb21ld2hhdCBpbnN1bGF0ZWQgZnJvbSBtaWdyYXRpb24uIEkgYWdyZWUgdGhh
dCB0aGlzIG1heSBub3QgYmUNCj4gPiA+ID4gdGhlIGJlc3Qgc29sdXRpb247IGFuZCB3aGV0aGVy
IG9yIG5vdCBiYXRjaGluZyBpcyBlbmFibGVkIGNhbiBiZSBkaXJlY3RseQ0KPiA+ID4gPiBkZXRl
cm1pbmVkIGp1c3QgYmVmb3JlIHRoZSBjYWxsIHRvIGNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVz
cygpDQo+ID4gPiA+IGJhc2VkIG9uOg0KPiA+ID4gPg0KPiA+ID4gPiBhY29tcF9jdHgtPm5yX3Jl
cXMgPT0gU1dBUF9DUllQVE9fQkFUQ0hfU0laRTsNCj4gPiA+DQo+ID4gPiBXaXRoIGFoYXNoIHJl
cXVlc3QgY2hhaW5pbmcsIHRoZSBpZGVhIGlzIHRvIGFjY3VtdWxhdGUgYXMgbXVjaA0KPiA+ID4g
ZGF0YSBhcyB5b3UgY2FuIGJlZm9yZSB5b3UgcHJvdmlkZSBpdCB0byB0aGUgQ3J5cHRvIEFQSS4g
IFRoZQ0KPiA+ID4gQVBJIGlzIHJlc3BvbnNpYmxlIGZvciBkaXZpZGluZyBpdCB1cCBpZiB0aGUg
dW5kZXJseWluZyBkcml2ZXINCj4gPiA+IGlzIG9ubHkgYWJsZSB0byBoYW5kbGUgb25lIHJlcXVl
c3QgYXQgYSB0aW1lLg0KPiA+ID4NCj4gPiA+IFNvIHRoYXQgd291bGQgYmUgdGhlIGlkZWFsIG1v
ZGVsIHRvIHVzZSBmb3IgY29tcHJlc3Npb24gYXMgd2VsbC4NCj4gPiA+IFByb3ZpZGUgYXMgbXVj
aCBkYXRhIGFzIHlvdSBjYW4gYW5kIGxldCB0aGUgQVBJIGhhbmRsZSB0aGUgY2FzZQ0KPiA+ID4g
d2hlcmUgdGhlIGRhdGEgbmVlZHMgdG8gYmUgZGl2aWRlZCB1cC4NCj4gPg0KPiA+IFRoYW5rcyBm
b3IgdGhpcyBzdWdnZXN0aW9uISBUaGlzIHNvdW5kcyBsaWtlIGEgY2xlYW4gd2F5IHRvIGhhbmRs
ZSB0aGUNCj4gPiBiYXRjaGluZy9zZXF1ZW50aWFsIGNvbXByZXNzL2RlY29tcHJlc3Mgd2l0aGlu
IHRoZSBjcnlwdG8gQVBJIGFzIGxvbmcNCj4gPiBhcyBpdCBjYW4gYmUgY29udGFpbmVkIGluIHRo
ZSBjcnlwdG8gYWNvbXByZXNzIGxheWVyLg0KPiA+IElmIHRoZSB6c3dhcCBtYWludGFpbmVycyBk
b24ndCBoYXZlIGFueSBvYmplY3Rpb25zLCBJIGNhbiBsb29rIGludG8gdGhlDQo+ID4gZmVhc2li
aWxpdHkgb2YgZG9pbmcgdGhpcy4NCj4gDQo+IERvZXMgdGhpcyBtZWFuIHRoYXQgaW5zdGVhZCBv
ZiB6c3dhcCBicmVha2luZyBkb3duIHRoZSBmb2xpbyBpbnRvDQo+IFNXQVBfQ1JZUFRPX0JBVENI
X1NJWkUgLXNpemVkIGJhdGNoZXMsIHdlIHBhc3MgYWxsIHRoZSBwYWdlcyB0byB0aGUNCj4gY3J5
cHRvIGxheWVyIGFuZCBsZXQgaXQgZG8gdGhlIGJhdGNoaW5nIGFzIGl0IHBsZWFzZXM/DQoNCklm
IEkgdW5kZXJzdGFuZCBIZXJiZXJ0J3Mgc3VnZ2VzdGlvbiBjb3JyZWN0bHksIEkgdGhpbmsgd2hh
dCBoZSBtZWFudCB3YXMNCnRoYXQgd2UgYWxsb2NhdGUgb25seSBTV0FQX0NSWVBUT19CQVRDSF9T
SVpFICMgb2YgYnVmZmVycyBpbiB6c3dhcCAoc2F5LCA4KQ0KZHVyaW5nIHRoZSBjcHUgb25saW5p
bmcgYWx3YXlzLiBUaGUgYWNvbXBfaGFzX2FzeW5jX2JhdGNoaW5nKCkgQVBJIGNhbg0KYmUgdXNl
ZCB0byBkZXRlcm1pbmUgd2hldGhlciB0byBhbGxvY2F0ZSBtb3JlIHRoYW4gb25lIGFjb21wX3Jl
cSBhbmQNCmNyeXB0b193YWl0IChmeWksIEkgYW0gY3JlYXRpbmcgU1dBUF9DUllQVE9fQkFUQ0hf
U0laRSAjIG9mIGNyeXB0b193YWl0DQpmb3IgdGhlIHJlcXVlc3QgY2hhaW5pbmcgd2l0aCB0aGUg
Z29hbCBvZiB1bmRlcnN0YW5kaW5nIHBlcmZvcm1hbmNlIHdydCB0aGUNCmV4aXN0aW5nIGltcGxl
bWVudGF0aW9uIG9mIGNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVzcygpKS4NCkluIHpzd2FwX3N0
b3JlX2ZvbGlvKCksIHdlIHByb2Nlc3MgdGhlIGxhcmdlIGZvbGlvIGluIGJhdGNoZXMgb2YgOCBw
YWdlcw0KYW5kIGNhbGwgImNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVzcygpIiBmb3IgZWFjaCBi
YXRjaC4gQmFzZWQgb24gZWFybGllcg0KZGlzY3Vzc2lvbnMgaW4gdGhpcyB0aHJlYWQsIGl0IG1p
Z2h0IG1ha2Ugc2Vuc2UgdG8gYWRkIGEgYm9vbCBvcHRpb24gdG8NCmNyeXB0b19hY29tcF9iYXRj
aF9jb21wcmVzcygpIGFzIGZvbGxvd3M6DQoNCnN0YXRpYyBpbmxpbmUgYm9vbCBjcnlwdG9fYWNv
bXBfYmF0Y2hfY29tcHJlc3Moc3RydWN0IGFjb21wX3JlcSAqcmVxc1tdLA0KCQkJCQkgICAgICAg
c3RydWN0IGNyeXB0b193YWl0ICp3YWl0c1tdLA0KCQkJCQkgICAgICAgc3RydWN0IHBhZ2UgKnBh
Z2VzW10sDQoJCQkJCSAgICAgICB1OCAqZHN0c1tdLA0KCQkJCQkgICAgICAgdW5zaWduZWQgaW50
IGRsZW5zW10sDQoJCQkJCSAgICAgICBpbnQgZXJyb3JzW10sDQoJCQkJCSAgICAgICBpbnQgbnJf
cGFnZXMsDQoJCQkJCSAgICAgICBib29sIHBhcmFsbGVsKTsNCg0KenN3YXAgd291bGQgYWNxdWly
ZSB0aGUgcGVyLWNwdSBhY29tcF9jdHgtPm11dGV4LCBhbmQgcGFzcw0KKGFjb21wX2N0eC0+bnJf
cmVxcyA9PSBTV0FQX0NSWVBUT19CQVRDSF9TSVpFKSBmb3IgdGhlICJwYXJhbGxlbCIgcGFyYW1l
dGVyLg0KVGhpcyBpbmRpY2F0ZXMgdG8gY3J5cHRvX2Fjb21wX2JhdGNoX2NvbXByZXNzKCkgd2hl
dGhlciBvciBub3QNClNXQVBfQ1JZUFRPX0JBVENIX1NJWkUgIyBvZiBlbGVtZW50cyBhcmUgYXZh
aWxhYmxlIGluICJyZXFzIiBhbmQgIndhaXRzIi4NCg0KSWYgd2UgaGF2ZSBtdWx0aXBsZSAicmVx
cyIgKHBhcmFsbGVsID09IHRydWUpLCB3ZSB1c2UgcmVxdWVzdCBjaGFpbmluZyAob3IgdGhlDQpl
eGlzdGluZyBhc3luY2hyb25vdXMgcG9sbCBpbXBsZW1lbnRhdGlvbikgZm9yIElBQSBiYXRjaGlu
Zy4gSWYgKHBhcmFsbGVsID09IGZhbHNlKSwNCmNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVzcygp
IHdpbGwgbG9vayBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQpzdGF0aWMgaW5saW5lIGJvb2wgY3J5
cHRvX2Fjb21wX2JhdGNoX2NvbXByZXNzKHN0cnVjdCBhY29tcF9yZXEgKnJlcXNbXSwNCgkJCQkJ
ICAgICAgIHN0cnVjdCBjcnlwdG9fd2FpdCAqd2FpdHNbXSwNCgkJCQkJICAgICAgIHN0cnVjdCBw
YWdlICpwYWdlc1tdLA0KCQkJCQkgICAgICAgdTggKmRzdHNbXSwNCgkJCQkJICAgICAgIHVuc2ln
bmVkIGludCBkbGVuc1tdLA0KCQkJCQkgICAgICAgaW50IGVycm9yc1tdLA0KCQkJCQkgICAgICAg
aW50IG5yX3BhZ2VzLA0KCQkJCQkgICAgICAgYm9vbCBwYXJhbGxlbCkNCnsNCglpZiAoIXBhcmFs
bGVsKSB7DQoJCXN0cnVjdCBzY2F0dGVybGlzdCBpbnB1dCwgb3V0cHV0Ow0KCQlpbnQgaTsNCg0K
CQlmb3IgKGkgPSAwOyBpIDwgbnJfcGFnZXM7ICsraSkgew0KCQkJLyogZm9yIHBhZ2VzW2ldLCBi
dWZmZXJzW2ldLCBkbGVuc1tpXTogYm9ycm93IGZpcnN0IGhhbGYgb2YNCgkJCSAqIHpzd2FwX2Nv
bXByZXNzKCkgZnVuY3Rpb25hbGl0eToNCgkJCSovDQoJCQlkc3QgPSBhY29tcF9jdHgtPmJ1ZmZl
cnNbaV07DQoJCQlzZ19pbml0X3RhYmxlKCZpbnB1dCwgMSk7DQoJCQlzZ19zZXRfcGFnZSgmaW5w
dXQsIHBhZ2VzW2ldLCBQQUdFX1NJWkUsIDApOw0KDQoJCQlzZ19pbml0X29uZSgmb3V0cHV0LCBk
c3QsIFBBR0VfU0laRSAqIDIpOw0KCQkJYWNvbXBfcmVxdWVzdF9zZXRfcGFyYW1zKGFjb21wX2N0
eC0+cmVxc1swXSwgJmlucHV0LCAmb3V0cHV0LCBQQUdFX1NJWkUsIGRsZW5zW2ldKTsNCg0KCQkJ
Y29tcF9yZXQgPSBjcnlwdG9fd2FpdF9yZXEoY3J5cHRvX2Fjb21wX2NvbXByZXNzKGFjb21wX2N0
eC0+cmVxc1swXSksIGFjb21wX2N0eC0+d2FpdHNbMF0pOw0KCQkJZGxlbnNbaV0gPSBhY29tcF9j
dHgtPnJlcXNbMF0tPmRsZW47DQoJCX0NCgl9DQoNCgkvKg0KCSAqIEF0IHRoaXMgcG9pbnQgd2Ug
d291bGQgaGF2ZSBzZXF1ZW50aWFsbHkgY29tcHJlc3NlZCB0aGUgYmF0Y2guDQoJICogenN3YXBf
c3RvcmVfZm9saW8oKSBjYW4gcHJvY2VzcyB0aGUgYnVmZmVycyBhbmQgZGxlbnMgdXNpbmcNCgkg
KiBjb21tb24gY29kZSBmb3IgYmF0Y2hpbmcgYW5kIG5vbi1iYXRjaGluZyBjb21wcmVzc29ycy4N
CgkqLw0KfQ0KDQpJSVVDLCB0aGlzIHN1Z2dlc3Rpb24gYXBwZWFycyB0byBiZSBhbG9uZyB0aGUg
bGluZXMgb2YgdXNpbmcgY29tbW9uDQpjb2RlIGluIHpzd2FwIGFzIGZhciBhcyBwb3NzaWJsZSwg
Zm9yIGNvbXByZXNzb3JzIHRoYXQgZG8gYW5kIGRvIG5vdA0Kc3VwcG9ydCBiYXRjaGluZy4gSGVy
YmVydCBjYW4gY29ycmVjdCBtZSBpZiBJIGFtIHdyb25nLg0KDQpJZiB0aGlzIGlzIGluZGVlZCB0
aGUgY2FzZSwgdGhlIG1lbW9yeSBwZW5hbHR5IGZvciBzb2Z0d2FyZSBjb21wcmVzc29ycw0Kd291
bGQgYmU6DQoxKSBwcmUtYWxsb2NhdGluZyBTV0FQX0NSWVBUT19CQVRDSF9TSVpFIGFjb21wX2N0
eC0+YnVmZmVycyBpbg0KICAgIHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKS4NCjIpIFNXQVBfQ1JZ
UFRPX0JBVENIX1NJWkUgc3RhY2sgdmFyaWFibGVzIGZvciBwYWdlcyBhbmQgZGxlbnMgaW4NCiAg
ICB6c3dhcF9zdG9yZV9mb2xpbygpLg0KDQpUaGlzIHdvdWxkIGJlIGFuIGFkZGl0aW9uYWwgbWVt
b3J5IHBlbmFsdHkgZm9yIHdoYXQgd2UgZ2FpbiBieQ0KaGF2aW5nIHRoZSBjb21tb24gY29kZSBw
YXRocyBpbiB6c3dhcCBmb3IgY29tcHJlc3NvcnMgdGhhdCBkbw0KYW5kIGRvIG5vdCBzdXBwb3J0
IGJhdGNoaW5nLg0KDQpUaGFua3MsDQpLYW5jaGFuYQ0KDQo+IA0KPiBJdCBzb3VuZHMgbmljZSBv
biB0aGUgc3VyZmFjZSwgYnV0IHRoaXMgaW1wbGllcyB0aGF0IHdlIGhhdmUgdG8NCj4gYWxsb2Nh
dGUgZm9saW9fbnJfcGFnZXMoKSBidWZmZXJzIGluIHpzd2FwLCBlc3NlbnRpYWxseSBhcyB0aGUN
Cj4gYWxsb2NhdGlvbiBpcyB0aGUgc2FtZSBzaXplIGFzIHRoZSBmb2xpbyBpdHNlbGYuIFdoaWxl
IHRoZSBhbGxvY2F0aW9uDQo+IGRvZXMgbm90IG5lZWQgdG8gYmUgY29udGlndW91cywgbWFraW5n
IGEgbGFyZ2UgbnVtYmVyIG9mIGFsbG9jYXRpb25zDQo+IGluIHRoZSByZWNsYWltIHBhdGggaXMg
ZGVmaW5pdGVseSBub3Qgc29tZXRoaW5nIHdlIHdhbnQuIEZvciBhIDJNIFRIUCwNCj4gd2UnZCBu
ZWVkIHRvIGFsbG9jYXRlIDJNIGluIHpzd2FwX3N0b3JlKCkuDQo+IA0KPiBJZiB3ZSBjaG9vc2Ug
dG8ga2VlcCBwcmVhbGxvY2F0aW5nLCBhc3N1bWluZyB0aGUgbWF4aW11bSBUSFAgc2l6ZSBpcw0K
PiAyTSwgd2UgbmVlZCB0byBhbGxvY2F0ZSAyTSAqIG5yX2NwdXMgd29ydGggb2YgYnVmZmVycy4g
VGhhdCdzIGEgbG90IG9mDQo+IG1lbW9yeS4NCj4gDQo+IEkgZmVlbCBsaWtlIEkgYW0gbWlzc2lu
ZyBzb21ldGhpbmcuDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IEthbmNoYW5hDQo+ID4NCj4g
PiA+DQo+ID4gPiBDaGVlcnMsDQo+ID4gPiAtLQ0KPiA+ID4gRW1haWw6IEhlcmJlcnQgWHUgPGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gPiA+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRv
ci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvDQo+ID4gPiBQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFw
YW5hLm9yZy5hdS9+aGVyYmVydC9wdWJrZXkudHh0DQo=
