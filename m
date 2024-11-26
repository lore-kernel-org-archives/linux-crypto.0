Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17840CA64;
	Tue, 26 Nov 2024 02:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732588650; cv=fail; b=Fd9FNT6GeXzcTp9ve7f2zliKlbWLzQ2p5QGEuMyq96Yxk1b5TEsfdVwobMs0CBI/WQWWYmSLta9zUYuwkMffulpFD5i47PhI6XmwwKwlDfnHOd52CG2mjubhZCWPtNZFKjaaaUCKwvvrr9Wd0hJf1UWaga8zbVHen332ewhJNzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732588650; c=relaxed/simple;
	bh=l/MiPbXOQw0BfFOgK6TnbicEkzewJ0gET/b4VN29lHc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bRNmA0lyz6Y8JfJvF6eS8dI4P0gkItt2onuXUGEW2p+iLbdA7g3iVhiknK9OnwvbrJxIzNXayaydNHQx4lPtUSh/9HEfyWv9M3zd7dR98+9RNwdnFCAbixcgJXGZ3+XQFiUSb8tJz0roKKRhrTbHKc2It6Bmf6Z78fFqQrPi6S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HqcmodVN; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HqcmodVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732588648; x=1764124648;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l/MiPbXOQw0BfFOgK6TnbicEkzewJ0gET/b4VN29lHc=;
  b=HqcmodVN+gV8fLCJsPhgLj1Jw2L+HIL/+CO8+SfIU21QwiLYyJeAFs9T
   H+B5TXBLE03qd4wPQR9WGBkVbYxSNA2yfx6H3DM22YmZpFxeXkquEkFIZ
   lbj0GVYUpirqOlGQNOzE3+7uuNuJ8xCYXxIZUhutRMaMillm9Fx1tMnlJ
   OBd8Js05kKniCs/tN0T3rhXsF4ANe8XZDjaF3MvB4lMwzDcRbqPdFbxVJ
   NTE2T8WnK2hMpVjIaFeEPuWqaYdgRhvxK/weYFj2KMzirO+Og0Y9ucVp/
   CtX5ZuCid7IULBbJWa0xnx9n/e7MTMrNLv45K4KdZnhkH62G+X8n6iQE/
   g==;
X-CSE-ConnectionGUID: KMvemGPLSXOl/6D4dGZ+UA==
X-CSE-MsgGUID: tkNHl1gSSSyxrDRReTQ6pA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32583117"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="32583117"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 18:37:12 -0800
X-CSE-ConnectionGUID: piMLRgf8TO+E4/TBmLK1BA==
X-CSE-MsgGUID: QQeSP1yqT5eAcmBK/EhPYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91586210"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 18:37:12 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 18:37:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 18:37:11 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 18:37:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gn8iTUKep38khm1YymHcPAkOv+QuTvEEGt8KGRovxtj2C7KDwPA7IimTyfXKeLMMOhJGmKepbgEbL2jS8aNDJHEVmqH42DwRumrZmYGrvsmZXBLphtEAxzc0tFq4jaTr4iHzTJLdpXbTIgVEV472PcDdw13hcT+jQwoipn3bx80Ql5p4P4COrPgEbdcnvMx93LnB+mkaN9Klmwt4dEWZExJF+uIOizDAs61rfUC1Qs+JkvZZUqwoW6ogSlfyQrwmPbf3PcfakWlVsJ6kGUz+xYxPb7Ia0wARDeXhkvXCr+Xpvrvxb+/YQ3aulkUFfvUzG0KfO3pXqSBvw+8IrEUjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/MiPbXOQw0BfFOgK6TnbicEkzewJ0gET/b4VN29lHc=;
 b=f3PHVoc72uRu+cTQv/befRjUQOMl1E5VQtRx0xuFdwZFbzsjF2lUwdMM7QmBynIF1oXzA8o86y1KC2AMbbp35nJZwtu4iuAllGtW8eOBuoJIxAqYc5q3jAAnoPI4MVX3mctBXc2b+/U5I7NNT8zX/r2dO/8clr2hze8MiYPMsJ42Vr6kAK5EaQd67+v8QQo7m4CGxYGa1kpqVqEFNWQZw+wfv3PDZMZ3cGvm7OZeRVVTrnuxdtMMXydKYLhY4UhT58IDBYlZTXep8NQ0/49pdg8HD3/JD8N3u8dxCf5MDeqeuhBccsQ67NBebpEROr3oSBhud8bwek2WDZ12UNA//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SJ2PR11MB7576.namprd11.prod.outlook.com (2603:10b6:a03:4c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Tue, 26 Nov
 2024 02:37:09 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 02:37:09 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Index: AQHbPXWM22jcCkeyAE6LgM2tVAM8N7LHv8kAgACul1CAAGZgQIAAAicAgAABOWA=
Date: Tue, 26 Nov 2024 02:37:09 +0000
Message-ID: <SJ0PR11MB5678654768005E5DF6542F2FC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
 <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z0UvACaa5wwtTgQu@gondor.apana.org.au>
In-Reply-To: <Z0UvACaa5wwtTgQu@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SJ2PR11MB7576:EE_
x-ms-office365-filtering-correlation-id: 2bb741a2-a794-402c-5c36-08dd0dc3397a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?yGvTiNQm3AmBeclKbBSEqotKkqkiVv3uv1WyIn40u3pKohwUcM5qV2HrTJoj?=
 =?us-ascii?Q?QH58trHVssTU+gBqURaH6Yb4bHSml94/oPbdRHr9KxAsbZnQUHa12d+/hfin?=
 =?us-ascii?Q?p6itdFlwv63gtbjQNGSL9f4lk+o8KUhHTYcRGQzuRLr/RU+obpD++jG6BVSH?=
 =?us-ascii?Q?I55MNQtdQAhlMxMwbv9JFfKsa5aFU3X14CViQ8qHOg3UIVzUUn06DApkcasu?=
 =?us-ascii?Q?6MpR0YXJnzyyT0nA38Q6zbmI74YLWvLV+vheA2C9ri9XOoCHxscOavM+KvPd?=
 =?us-ascii?Q?xM14nJYI25qE1hkj96Cd5XUX2SrtT8JfrJYPgZSjZam0EpfhE1OsiB1sDlNp?=
 =?us-ascii?Q?DPcvcze4fXOmQkKc+fkbOJvh4sel+uZPrwS2jlHDdvC0kUHC/frJ5T4kiQaJ?=
 =?us-ascii?Q?Absvxxrl3Eroh3k6/nhBulxT3DLQnynKBnonX616lR5D0vMGZzd2AOwi3yOK?=
 =?us-ascii?Q?/1HeYCK7ts4D5DQUTjm50ijyAO9ix7fnaikwYzYxNgbMuFAAsvrkzfE+nyEn?=
 =?us-ascii?Q?UOfEejNdzf3MHB2q4kJjy71fCqSgkE2VkPJOfhF4ksbosvDlEEsK87XXGLru?=
 =?us-ascii?Q?2qSfMbfAZx2m39GFCsULPzE5mUVm2q7AsFvvUREQrH0nTRKxuxVcA9i0f4bJ?=
 =?us-ascii?Q?2cmsp83ESurba/v23c+fu4RiAHkK3Co5SgizfkLKM5bYflC5XHeUNuwgF6FV?=
 =?us-ascii?Q?6pGhjc0bLwxzOEqGyLXLOVTw/+pJ2zA3fXFQ8HaBtAP+ssLdTAZDO0Mcw679?=
 =?us-ascii?Q?+V29ukJ/fhfPllBtc/LxnSOuOa9N8/HW4Vg31k2qibhEdowRSptBOGr8e3jp?=
 =?us-ascii?Q?i2+2KzoOHD7Ab9j0P+NYgZ4a2GPgvKoB7/jqftCFRPmd/foHjTWc5bDYg1hz?=
 =?us-ascii?Q?KEm3/A2XcHlC6s4VMQVg1QDF83rtGr/MEh5ulBLmW3zbqZRRrHWvowqbB3Jr?=
 =?us-ascii?Q?CacRKpmvKH/QYR1zrpP6WcqOiUJNrYfQHVdx1MyUfdT4zL6wS4hD/tLZ2JC8?=
 =?us-ascii?Q?p/znx/P2aqKpVe0LcHhY+W8QcFgeqKEnKmdmrWfjI/ItRtzNtrYzbMhmLSuF?=
 =?us-ascii?Q?cOGRTdcEgpeKfqSBFKP/uGa1uxDfv0NrQMkGQL6Y42Cqmp6LxhDpdt/r+GQC?=
 =?us-ascii?Q?/2y9viMHUmh795lHwN2jVcqKbxqvXcDbMCELjxAKeD6e5lwJ4rYqNMucs0FM?=
 =?us-ascii?Q?zoKEmcTNHSod8VVkNlMhvoxupbfNM0NPSW4SReERivTNsUSknJNhTC215786?=
 =?us-ascii?Q?E95qD+2QykHVZG5gLuRlKWjMOe88h5EKLhDPuYYxUiUGmdp1z+QPiqOQY6g3?=
 =?us-ascii?Q?KXjbzs8PWQszPRkwW2oTsSUxx9AM+BUyvlCvjcjQdZgYkYCOxkIFoUG/hu3v?=
 =?us-ascii?Q?FpnOhTU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jqsyu4jpivIp1WD9c8+30mzbRRbTiiuWTpf1tZTzcP6Ka1A+0g6c3hZ4u+jx?=
 =?us-ascii?Q?/ZNkV6YRhkv8ozjStO6k6tTLrywvbKShC7N354qegUbHLi2SJsizbFCt6fop?=
 =?us-ascii?Q?86Q+zebLsqL5g+YS2zuTa1FTcZrc90EHzujfv+ti+aw7xdT/h/Va0KBf+pSm?=
 =?us-ascii?Q?90jlMJeqL3nehVU12u6xr6Fz+g4tbGJ/kQ6KQrYbUsx1pWudfJ4B0cF2vax0?=
 =?us-ascii?Q?ACnW/Z2Hbk7ur4C4w52s3yGnLFeWvwEHBsFrN0ahX3ayVj3IEHwr5SypUyUF?=
 =?us-ascii?Q?2Q/pN8tl+Pjt8WpiVOQAX98x/wisKm78fQHmZQXdReyh7uIbnxG1coWkZ6Yn?=
 =?us-ascii?Q?kPWjN4Xpb1+IklunkFZm0/hc9P73lfM5I628lLQHgQz7Ly+IWFn1GPsCFr82?=
 =?us-ascii?Q?YnDHaRITdO1KLorYjrf4uapX04XpOx4LlQ1no7BMNo8KsukW4lIjmRhoHfal?=
 =?us-ascii?Q?Q3AnlMk0pIab1kmuBD12aP14A0xrFAJYqhbvJOci+4oBikwB35xQiG3yaHhZ?=
 =?us-ascii?Q?lL5CVbUV9Rs7rDTIvLY1E42CCC3dI6VlM3mdFpU9vtMDsZ4vPHu//7786nl8?=
 =?us-ascii?Q?WEm9NpVI1x8zF2MWX3flXn7+KSj6KI3d2nQh1V3EsZJruhaxvdXJLvgcmbIB?=
 =?us-ascii?Q?Hcm/VdZ3IMZ9sCPTSiBB2DqmfFownB4mH9SQEW6Ty4R1DtP1GnGNJW9oj/Md?=
 =?us-ascii?Q?m+5ba9DH8Lpyk+xSx9Kr8zhNKfNUpZtK9rFECC0Tr1J+GS/bPPzPDP+5ytTQ?=
 =?us-ascii?Q?b0xiPlHFammdVbhxhc7jrXi8H6K2+v+9792BohpKIJkG41YqVFSrSJae5HQx?=
 =?us-ascii?Q?3tDfBORFwrjlQuzMIhs78jz/d16w1gXJ9JW2PgQXPDtiulCmtCBr/6SiklRj?=
 =?us-ascii?Q?WVwUsDEcPtVSN8s1GDvfqZU795KspmTb78HckVoXJuSmRSKQLHN9sIc5sicE?=
 =?us-ascii?Q?YuFo/CuCHZ5a0PuELESJ5g4yLTn5NZHJal8/hqk60rQn6efJ1ByuAjtoPYna?=
 =?us-ascii?Q?pOovtPAqlhGkVGK9o2X/ES5HD4HFkHq8NdRziqFeiTg89kJUit9JanUdwP71?=
 =?us-ascii?Q?/FEXORRL7UubckIvayVnP7hNUout/ThTV0znDBrt7HB6mpd/cYatOQXZkFC+?=
 =?us-ascii?Q?uSeR0Mg8R63eZGSRfGF2t3l8SZPMtjA2D7TvFVaQK6xbol1YeYJUWqRbCGRC?=
 =?us-ascii?Q?k6rTTH3pthEpB6Ac9CqYwDBfvv6gSBwp/BV5+K57lIFaPcCi4zi8vR2WRxG6?=
 =?us-ascii?Q?OOys5EAHUG/BKDyieucANppPgm4G+aKa8npZb90la/9T2mq2NmC4Ct0MbC8G?=
 =?us-ascii?Q?45Zv/0ajvVxb8TuQhpgdU3n7yedM6yRd7/6mSpTl41qv6F/D/GT8ptOc3dD9?=
 =?us-ascii?Q?mOSKMn/JfsB4eU0dQ2MmC0zb+OlVDjfK0KdcwhfznLzWJsQBea34Xx7zzFue?=
 =?us-ascii?Q?klmY3GdKir6tYTwkv7flJb+YY7MDdAj/j+b4z2OqT8UvwNhil8aX7M8m77bJ?=
 =?us-ascii?Q?8t+Na20dA+WXneAxccLcAFvPXGk1l1HgbScGj0pJgFsQn+SiL9tI9EyrmdFV?=
 =?us-ascii?Q?1sSKf8gvvrDYYWI8Ja9iKr7p6kjZNvMyXJ/KRN3oId5ETx5XSeaO8TvivNXo?=
 =?us-ascii?Q?OYVDN3U4InmMfj4bdgABgh6C80Ast5Mj7+HvWmC/3x08A6XrL4gNaXXdy0Gx?=
 =?us-ascii?Q?74b5jA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb741a2-a794-402c-5c36-08dd0dc3397a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 02:37:09.0239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nb3DbYj1KgnylgaKcZW07MbTzrZA2RXe5QfyEe4C9l0X9Fxq0tQ/P1uQN8NJ2dHNq1lzd4HWAmfOh7SsWe4wlP7brh97trLJtpxMRfzY97I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7576
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, November 25, 2024 6:14 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> linux-crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces f=
or
> compress/decompress batching.
>=20
> On Tue, Nov 26, 2024 at 02:13:00AM +0000, Sridhar, Kanchana P wrote:
> >
> > I wanted to make sure I understand your suggestion: Are you suggesting =
we
> > implement request chaining for "struct acomp_req" similar to how this i=
s
> being
> > done for "struct ahash_request" in your patch?
> >
> > I guess I was a bit confused by your comment about rebasing, which woul=
d
> > imply a direct use of the request chaining API you've provided for "cry=
pto
> hash".
> > I would appreciate it if you could clarify.
>=20
> Yes I was referring to the generic part of request chaining,
> and not rebasing acomp on top of ahash.

Ok, thanks for the clarification! Would it be simpler if you could submit a
crypto_acomp request chaining patch that I can then use in iaa_crypto?
I would greatly appreciate this.

Thanks,
Kanchana


>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
