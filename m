Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB703323D;
	Sat,  8 Mar 2025 02:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741402045; cv=fail; b=tKaaVsV95RiAR/ui0QIY1Tzno6Vn7Wh+v6QF571C6aYAd3DNV1vI/rfTOEUaRp9DFGvAW7NZ7D1sejFz9BzvA1UVEB9LT0+z07mYrJ6vD1MdjCOD6V7nufPc2EFKhkKpHr7PgcDt+3NfzZYL9vLKkyYcNsABFxyMZQ4za4qlBpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741402045; c=relaxed/simple;
	bh=Z1pvsuiXXAbl2rfE+RhmLydifW4Jm8orlmrD/c1KeO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OlXLzTq8+PE5ekK3zT9Oo2iYmBj9/tey+VYvBu24T30n0bpP39UMbNoQvjYvDN/0tIztYRj9Z9JZOKIW1nqXxChQL203vglZ/FPEOhPHmUUoK33p+i1IjnxccwRzikNJJTGNmmbPgiKiGdF1aT7tpLeklUhwlhZq3bcDUbpNqeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fj1KiHmy; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fj1KiHmy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741402040; x=1772938040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z1pvsuiXXAbl2rfE+RhmLydifW4Jm8orlmrD/c1KeO0=;
  b=Fj1KiHmy+aXwr+ejerdSWjx/Pgmu9YFDhDGyUpf2hbX86973iKAQcGE6
   a2YCa3BpR84I7VWLSCt2rPrapd8byvZEEfA0KjY6WWf8m0mCdQ4Ha+cdM
   /r1cWhDcs/GZkc0MUtg/GabH4P/9N2guPB1pQrCGUGfTBMOMe3qX9szc9
   KQ7PzgETjA47x9B1YVj4TIJk/fe0n1bEuK1pttQM2IY2U7wR4dfksACh7
   3kNLwNbGgKmlZ/vX8egHlsb6VM1TqNCFR4N/oL79q/vZbOx8vS/zWd/+M
   X7QVxo5zskBEVN1NuBxmz2FKJbiX5t7jbmdIy3MNp6ddrCSoxZCcZbRs1
   g==;
X-CSE-ConnectionGUID: P/oy8r3aRGSjVA1uZlFC/Q==
X-CSE-MsgGUID: UuVS8rsYSr6SHgXRYQLXfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="52674561"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="52674561"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:47:20 -0800
X-CSE-ConnectionGUID: UwE5aV45Ta6iCJGqnwTC3A==
X-CSE-MsgGUID: fxdKekHXSSqN2nH40IuDjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="124404453"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:47:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Mar 2025 18:47:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 18:47:19 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 18:47:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZ86wHwcK3GECsavuhbTQ94g6JH2hMvzUWtGJ4/RNYsvbDoeKomVPNA7I9+5TkU0HKDx2SJu4trXb9aN7FRJpEGgmG3C//4u1kFYAHqGi3MOAlGTecEdcLLI8lzErIQqosTB/52yOquIVmcd/wfDt6BcMI1QV7Lh8GpoGN16qmlz0L8uXRL8ZaJyyh5SZK5Ei6D5cCM+VnRezwpn4oFueg0SOLRLeIZPL1TBHvvsjJvvSzdh5zJx1M4wL+hTB4ojboGfTNwtXP5luR3V69UG6JJiNNuBc7Oiuuvo/phm2uHEeM+9eosin8/5LjOTiilhz0MOwbHbtGMaL7AYVImXfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEwoZuk8NFs9ziiM6ntoiKdJV06GV+R6+SZxENh5Vn8=;
 b=EyCe2bLHFGxYYJEjTkXlTnRXVU+9lT2l1dAZrSrs0Wf5XO9A7NmnVkI8RwIc1zsRLxW5Ebgb/mQDvtq7f7wwq4b0mWDQ2YsGrTrf4Z/A5bU/OADMsrTmDOHgoXe+0tEKr5QouELuteDh39rnKRbeLfkjhhj/ngj560F2tgLA9Oe6h9x3NhnOW4LIRmF0MqAHl+IAkntHfLf2FM7BSLGFppq2JfLBU99rmkveyyfm/kvCO/moKgcuefoqVjJjSOzB1+njTTsStIysaUkAfjEq1OVUlOP4CibXJZByDJjXhscweKjtT05L4DLZFL0Qk6riWYhgsbIZtRu6CprtHxSHiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8SPRMB0044.namprd11.prod.outlook.com (2603:10b6:510:258::17)
 by PH8PR11MB6801.namprd11.prod.outlook.com (2603:10b6:510:1c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Sat, 8 Mar
 2025 02:47:16 +0000
Received: from PH8SPRMB0044.namprd11.prod.outlook.com
 ([fe80::3f76:ba1a:2e7b:43a4]) by PH8SPRMB0044.namprd11.prod.outlook.com
 ([fe80::3f76:ba1a:2e7b:43a4%4]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 02:47:15 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
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
Subject: RE: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Topic: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hCAAVPdAIAAYjdg
Date: Sat, 8 Mar 2025 02:47:15 +0000
Message-ID: <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
In-Reply-To: <Z8tJOi5G_3dpK31v@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8SPRMB0044:EE_|PH8PR11MB6801:EE_
x-ms-office365-filtering-correlation-id: 1e5771e9-b4cc-499f-967f-08dd5deb88e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ImmptVEDp+SKLrCEAxjPmUTga231vns0o87w/SpgtjWATkPu7dUE4LIhpc6c?=
 =?us-ascii?Q?yNrc+OPSNBu0hzoo0pQorLfhKGj2HrJ4Yfmsc7zatxaZtlsRqHHYGTDlbuir?=
 =?us-ascii?Q?jQ5+4/fWPbBpjmfh3KCocJ0oHEQql6ZQLXshhQzx7angsZxWmjAFgRQTLQok?=
 =?us-ascii?Q?f658jsi62Gw+0llIkpb54IzFq7O0PegFdd3TLU33QOMQPjao4MZsBOMnOBD/?=
 =?us-ascii?Q?NMKlHnrkMu0BzSLL9MU4i/PHxyy1JN07MHSOdb8rfG5W/S5KxzMYb7QmQCFz?=
 =?us-ascii?Q?aGFNfyWThMCKtzaMikFj82oQ//BSAh8+R2l+eTG03HCJ/u/1Q0JJxVI5YuMO?=
 =?us-ascii?Q?SjVCBwvRJzglTRFbGVur+IIPP309L69M17L6TIlp6IsFDIyVA0ZFKQnJwjo4?=
 =?us-ascii?Q?+0v+NuZI3ted/+TxmT9p/cCKoO+DumXCaCjyuE8grdiBFLRmLzO3lt1v9Ih/?=
 =?us-ascii?Q?lSPfwqNqFR20NlFlfw7L0eac3izcuZqzGR+9v4PA8YeCl/sV2Pcvl+e8IMB6?=
 =?us-ascii?Q?INAb5FDON5xg9lShRYRqBJqI7rupmtlAarX+bGSqEZgEvneymTcNplK/A49l?=
 =?us-ascii?Q?LWgYx/4KO/Y3j8fKAQa66ILfcRdhn227FLFnk4ohgMaT1ZOlBSy1lmMMy4PB?=
 =?us-ascii?Q?OG+TpkVvMQrV8OXenKanWwui8ak3hnLa00aGh6wfVL2isk8VcQg4Snb2UhCr?=
 =?us-ascii?Q?EykgbhS/RM7Ze48y9tcVyYwLRDGX8qmpi5LcMa+Vpu47tg0/JTqJRar5X4lo?=
 =?us-ascii?Q?oXlZKL3tSJqkK01EyzBKcaGugzsIK47VxJ48b75QbkiterBkhRtLycCzTQ0n?=
 =?us-ascii?Q?sx2cE/ARHcpWch7OEVl8RCo/h82j9Z2lYiSn47WEUU4xkRuRQ4tPkwIWb9RM?=
 =?us-ascii?Q?7Gc2lZ3OD8YXyr5npksFCBc455RMH54GduE69ALZqBtnfc6FLVaGH5Ukyp1b?=
 =?us-ascii?Q?cD8rrbaKI1Dl2/fmkvH8NZa6d5o3gL21ylIi/k09KdtBmrBu7OxFmHfgVAmA?=
 =?us-ascii?Q?skiMcQYWKskvOy4bG3n5EQWtt93CdfnSJIlZ6uDIQ2pugetvcPrcX0/cWrfK?=
 =?us-ascii?Q?ewamSskZIPhbtEdJsLoRCDzpGIOMgwacZJ2Iw9Yv5m55b5+9UGnoWVqRZfNC?=
 =?us-ascii?Q?vihD2aPJ2D/ZecoMZaWjor9CCiaj0KgqJxvGqSZWsaOjQNThWVdJCslxpdur?=
 =?us-ascii?Q?MEvP8pB/inQvvVNbeoPWuSGKHEC1iDo73lAmYIgj5r4XPCUlgNN9VPbALhff?=
 =?us-ascii?Q?MR/w6TvLrNQ1++wDaKK3jVb6QbKVkiWG0i/BZvKqXyDLIEY8HEE5sIQLLl06?=
 =?us-ascii?Q?X5nDBNs8WhMPI6C0RUc0nJXYNCxcxlLAKr5LMD2JkGNH1Bon0ukzTCynRDeC?=
 =?us-ascii?Q?zYiXaURJwRzz5T/iaVqtbTGzleq0t76JNUrSfwylA3BEPRiIEVhQYmYpDMyA?=
 =?us-ascii?Q?8YIl/TRo2siXFRZs1B2zB+jlCbLIzyCI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8SPRMB0044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2h30zbGfZKjDri55Ymcdde80wnsOdgPIJ6d54XiZihjGWOI3sQNuypz7shQi?=
 =?us-ascii?Q?757pu9hfYEWHFrO7sCRycwPQFbamSvimwIeuIYevXqZUiIWQP810nLTZ1QCm?=
 =?us-ascii?Q?S23y0pyKCEgI9opueUhog4aDBOJZ1+QegpIcTFuJ32r0NVf4i0+sp1COWatX?=
 =?us-ascii?Q?FpXsTwv6nny9B0yM4olMHBN4VCVmTYpFy9SckmEjRLkufjFrIPSagbYQ7zoe?=
 =?us-ascii?Q?WbDLif0P8oIav8cBsvbbPpnTI+8JDEKn3pqP8z7FQd3dVrO9iKWMZnXY3aWT?=
 =?us-ascii?Q?/PJ06kjhKOosfACsLOKcvPsOy70jNwow8Ar+r5OKZPMb6UG88+r1tit0/utP?=
 =?us-ascii?Q?T61E2hSzbHILJunrihh6ktMFDDQJCDpPMl7vXhPaMx2RPBjFtlgwGwmkz/w8?=
 =?us-ascii?Q?QrlYzJu7GOMOWVyxoN6XxgRsSA8r0SkHUT8fV7hXWG8OhefrDXyWcedi1VV5?=
 =?us-ascii?Q?Uol9wxYsIVEsQ0HPDrf8ilVQ+5Yhc3pyD3ElEFmnyvwo9me7ccsR+61tnJ02?=
 =?us-ascii?Q?tjvMG6SS/CIytoqWFAUYTXV8wm3ENo5dqn/zdnyNUPAsyiM5aMfnp3PaHG5Y?=
 =?us-ascii?Q?dWik4C1Rn2zfqN88975tBa//voRfMZ2OEOmNXpRcKT1AP4PbDhWdsRzn9fN2?=
 =?us-ascii?Q?2nb3oiBamCPgTh83zI+LkepNo4Q3jutVqna9is3RZ33b0Vd3QzsEMVlBbXAD?=
 =?us-ascii?Q?iqhX71bJ62e+XdXsEoKz7KtIYB4w8k6VLdMF1RzGwgOXku5c/Ir9dtsx4WKo?=
 =?us-ascii?Q?zKtYKZpLdNKL1WyYNgEU/jWLNj9mwiAl3CTqL6OYtYx0U/TFpjvHyvIw0Yv7?=
 =?us-ascii?Q?6xKAEOZL0pgbXRkm9E7kuIlEvqZmqU7BdM12zSqqDtq9GzR7lDiF/dXiSaqB?=
 =?us-ascii?Q?1sYD42XsjdcTsbEYtp/MUFS4apvKWq/DglC0n37pCcMh8hyQRYBErm/eA3XI?=
 =?us-ascii?Q?RDQ/oj+mwCMBHuSXaLXxfOTLn9R4SZtZ5ukTn40HzlNjzN3FeZZhtq62f+Ey?=
 =?us-ascii?Q?jAliK8PnZLAhKQ/Mh5IIU9NrTS3mnJlEAndwtweQbgBh6bAQGDK7UvsF3tV4?=
 =?us-ascii?Q?fLqHzUZXv92/BCjgoLr1ggSsBQnsCkqQ1EVE4qnC/UlmOMmdX5/ZWwdcBFRg?=
 =?us-ascii?Q?lyhoyGjjKdOd6QequpWGDPLqZZESyMQCHeCFif+bOhsptP4BtQ7kI4OF63YK?=
 =?us-ascii?Q?Tr88fFXlN9raFrEN2R8ce/xKQVvk9xQy6US62D+kRYui5Uqk+0IPRhOyy6zF?=
 =?us-ascii?Q?JUVdL1vvJqqIXE3z9vddZmabTkRRb8QRbJTjYfQiBLeN5JpBAV0TnX9MwyiU?=
 =?us-ascii?Q?9f/hArIB2gRWPGf0grWyA6u8gU86PAZLo2XjtSRzYx+1iQk4f9cnRgon+3Vb?=
 =?us-ascii?Q?Mj6XbZahUnt3fHjwez+dk05PE5Ru3gTaIp2yoEKiM4lT8a3jgFh5wrNksbgy?=
 =?us-ascii?Q?0cYVJjZobtKvw3bqHE6bQ7+OM55iL2EcutJNY2Eu0ab7b2Lx1alKo+eAj0Hp?=
 =?us-ascii?Q?EFhRpX+BW8Mu9pfJfK21Up/o8dq08dSUqxmrIG20q5thQ80kPUQcZDAhUJXl?=
 =?us-ascii?Q?ZwmNx1uNWIU9sYKE4RdMPVacUATqQGgBwrcXv5ZOqK50WPEYTXSnDQOojPvR?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8SPRMB0044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5771e9-b4cc-499f-967f-08dd5deb88e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2025 02:47:15.1101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9g3wx4TPJM+MLb8/Wy+nMpdmTE2G3lqY4cChFahn3f9mYvQBpiMG2p1N+q529OjqXNYcrgPjAGWXuV4At/cvYkz3dlIG5oWystVyv6L3Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6801
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, March 7, 2025 11:30 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> allocation/deletion and mutex lock usage.
>=20
> On Fri, Mar 07, 2025 at 12:01:14AM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, March 6, 2025 11:36 AM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>;
> > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> > > allocation/deletion and mutex lock usage.
> > >
> > > On Mon, Mar 03, 2025 at 12:47:22AM -0800, Kanchana P Sridhar wrote:
> > > > This patch modifies the acomp_ctx resources' lifetime to be from po=
ol
> > > > creation to deletion. A "bool __online" and "u8 nr_reqs" are added =
to
> > > > "struct crypto_acomp_ctx" which simplify a few things:
> > > >
> > > > 1) zswap_pool_create() will initialize all members of each percpu
> > > acomp_ctx
> > > >    to 0 or NULL and only then initialize the mutex.
> > > > 2) CPU hotplug will set nr_reqs to 1, allocate resources and set __=
online
> > > >    to true, without locking the mutex.
> > > > 3) CPU hotunplug will lock the mutex before setting __online to fal=
se. It
> > > >    will not delete any resources.
> > > > 4) acomp_ctx_get_cpu_lock() will lock the mutex, then check if __on=
line
> > > >    is true, and if so, return the mutex for use in zswap compress a=
nd
> > > >    decompress ops.
> > > > 5) CPU onlining after offlining will simply check if either __onlin=
e or
> > > >    nr_reqs are non-0, and return 0 if so, without re-allocating the
> > > >    resources.
> > > > 6) zswap_pool_destroy() will call a newly added
> zswap_cpu_comp_dealloc()
> > > to
> > > >    delete the acomp_ctx resources.
> > > > 7) Common resource deletion code in case of
> zswap_cpu_comp_prepare()
> > > >    errors, and for use in zswap_cpu_comp_dealloc(), is factored int=
o a
> new
> > > >    acomp_ctx_dealloc().
> > > >
> > > > The CPU hot[un]plug callback functions are moved to "pool functions=
"
> > > > accordingly.
> > > >
> > > > The per-cpu memory cost of not deleting the acomp_ctx resources upo=
n
> > > CPU
> > > > offlining, and only deleting them when the pool is destroyed, is as
> follows:
> > > >
> > > >     IAA with batching: 64.8 KB
> > > >     Software compressors: 8.2 KB
> > > >
> > > > I would appreciate code review comments on whether this memory cost
> is
> > > > acceptable, for the latency improvement that it provides due to a f=
aster
> > > > reclaim restart after a CPU hotunplug-hotplug sequence - all that t=
he
> > > > hotplug code needs to do is to check if acomp_ctx->nr_reqs is non-0=
,
> and
> > > > if so, set __online to true and return, and reclaim can proceed.
> > >
> > > I like the idea of allocating the resources on memory hotplug but
> > > leaving them allocated until the pool is torn down. It avoids allocat=
ing
> > > unnecessary memory if some CPUs are never onlined, but it simplifies
> > > things because we don't have to synchronize against the resources bei=
ng
> > > freed in CPU offline.
> > >
> > > The only case that would suffer from this AFAICT is if someone online=
s
> > > many CPUs, uses them once, and then offline them and not use them
> again.
> > > I am not familiar with CPU hotplug use cases so I can't tell if that'=
s
> > > something people do, but I am inclined to agree with this
> > > simplification.
> >
> > Thanks Yosry, for your code review comments! Good to know that this
> > simplification is acceptable.
> >
> > >
> > > >
> > > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > > ---
> > > >  mm/zswap.c | 273 +++++++++++++++++++++++++++++++++++----------
> ----
> > > ----
> > > >  1 file changed, 182 insertions(+), 91 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index 10f2a16e7586..cff96df1df8b 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -144,10 +144,12 @@ bool zswap_never_enabled(void)
> > > >  struct crypto_acomp_ctx {
> > > >  	struct crypto_acomp *acomp;
> > > >  	struct acomp_req *req;
> > > > -	struct crypto_wait wait;
> > >
> > > Is there a reason for moving this? If not please avoid unrelated chan=
ges.
> >
> > The reason is so that req/buffer, and reqs/buffers with batching, go to=
gether
> > logically, hence I found this easier to understand. I can restore this =
to the
> > original order, if that's preferable.
>=20
> I see. In that case, this fits better in the patch that actually adds
> support for having multiple requests and buffers, and please call it out
> explicitly in the commit message.

Thanks Yosry, for the follow up comments. Sure, this makes sense.

>=20
> >
> > >
> > > >  	u8 *buffer;
> > > > +	u8 nr_reqs;
> > > > +	struct crypto_wait wait;
> > > >  	struct mutex mutex;
> > > >  	bool is_sleepable;
> > > > +	bool __online;
> > >
> > > I don't believe we need this.
> > >
> > > If we are not freeing resources during CPU offlining, then we do not
> > > need a CPU offline callback and acomp_ctx->__online serves no purpose=
.
> > >
> > > The whole point of synchronizing between offlining and
> > > compress/decompress operations is to avoid UAF. If offlining does not
> > > free resources, then we can hold the mutex directly in the
> > > compress/decompress path and drop the hotunplug callback completely.
> > >
> > > I also believe nr_reqs can be dropped from this patch, as it seems li=
ke
> > > it's only used know when to set __online.
> >
> > All great points! In fact, that was the original solution I had impleme=
nted
> > (not having an offline callback). But then, I spent some time understan=
ding
> > the v6.13 hotfix for synchronizing freeing of resources, and this comme=
nt
> > in zswap_cpu_comp_prepare():
> >
> > 	/*
> > 	 * Only hold the mutex after completing allocations, otherwise we
> may
> > 	 * recurse into zswap through reclaim and attempt to hold the mutex
> > 	 * again resulting in a deadlock.
> > 	 */
> >
> > Hence, I figured the constraint of "recurse into zswap through reclaim"=
 was
> > something to comprehend in the simplification (even though I had a toug=
h
> > time imagining how this could happen).
>=20
> The constraint here is about zswap_cpu_comp_prepare() holding the mutex,
> making an allocation which internally triggers reclaim, then recursing
> into zswap and trying to hold the same mutex again causing a deadlock.
>=20
> If zswap_cpu_comp_prepare() does not need to hold the mutex to begin
> with, the constraint naturally goes away.

Actually, if it is possible for the allocations in zswap_cpu_comp_prepare()
to trigger reclaim, then I believe we need some way for reclaim to know if
the acomp_ctx resources are available. Hence, this seems like a potential
for deadlock regardless of the mutex.

I verified that all the zswap_cpu_comp_prepare() allocations are done with
GFP_KERNEL, which implicitly allows direct reclaim. So this appears to be a
risk for deadlock between zswap_compress() and zswap_cpu_comp_prepare()
in general, i.e., aside from this patchset.

I can think of the following options to resolve this, and would welcome
other suggestions:

1) Less intrusive: acomp_ctx_get_cpu_lock() should get the mutex, check
    if acomp_ctx->__online is true, and if so, return the mutex. If
    acomp_ctx->__online is false, then it returns NULL. In other words, we
    don't have the for loop.
    - This will cause recursions into direct reclaim from zswap_cpu_comp_pr=
epare()
       to fail, cpuhotplug to fail. However, there is no deadlock.
        - zswap_compress() will need to detect NULL returned by
          acomp_ctx_get_cpu_lock(), and return an error.
        - zswap_decompress() will need a BUG_ON(!acomp_ctx) after calling
          acomp_ctx_get_cpu_lock().
    - We won't be migrated to a different CPU because we hold the mutex, he=
nce
      zswap_cpu_comp_dead() will wait on the mutex.

2) More intrusive: We would need to use a gfp_t that prevents direct reclai=
m
    and kswapd, i.e., something similar to GFP_TRANSHUGE_LIGHT in gfp_types=
.h,
    but for non-THP allocations. If we decide to adopt this approach, we wo=
uld
    need changes in include/crypto/acompress.h, crypto/api.c, and crypto/ac=
ompress.c
    to allow crypto_create_tfm_node() to call crypto_alloc_tfmmem() with th=
is
    new gfp_t, in lieu of GFP_KERNEL.

>=20
> >
> > Hence, I added the "bool __online" because zswap_cpu_comp_prepare()
> > does not acquire the mutex lock while allocating resources. We have
> already
> > initialized the mutex, so in theory, it is possible for compress/decomp=
ress
> > to acquire the mutex lock. The __online acts as a way to indicate wheth=
er
> > compress/decompress can proceed reliably to use the resources.
>=20
> For compress/decompress to acquire the mutex they need to run on that
> CPU, and I don't think that's possible before onlining completes, so
> zswap_cpu_comp_prepare() must have already completed before
> compress/decompress can use that CPU IIUC.

If we can make this assumption, that would be great! However, I am not
totally sure because of the GFP_KERNEL allocations in
zswap_cpu_comp_prepare().

>=20
> >
> > The "nr_reqs" was needed as a way to distinguish between initial and
> > subsequent calls into zswap_cpu_comp_prepare(), for e.g., on a CPU that
> > goes through an online-offline-online sequence. In the initial onlining=
,
> > we need to allocate resources because nr_reqs=3D0. If resources are to
> > be allocated, we set acomp_ctx->nr_reqs and proceed to allocate
> > reqs/buffers/etc. In the subsequent onlining, we can quickly inspect
> > nr_reqs as being greater than 0 and return, thus avoiding any latency
> > delays before reclaim/page-faults can be handled on that CPU.
> >
> > Please let me know if this rationale seems reasonable for why
> > __online and nr_reqs were introduced.
>=20
> Based on what I said, I still don't believe they are needed, but please
> correct me if I am wrong.

Same comments as above.=20

>=20
> [..]
> > > I also see some ordering changes inside the function (e.g. we now
> > > allocate the request before the buffer). Not sure if these are
> > > intentional. If not, please keep the diff to the required changes onl=
y.
> >
> > The reason for this was, I am trying to organize the allocations based
> > on dependencies. Unless requests are allocated, there is no point in
> > allocating buffers. Please let me know if this is Ok.
>=20
> Please separate refactoring changes in general from functional changes
> because it makes code review harder.

Sure, I will do so.

>=20
> In this specific instance, I think moving the code is probably not worth
> it, as there's also no point in allocating requests if we cannot
> allocate buffers. In fact, since the buffers are larger, in theory their
> allocation is more likely to fail, so it makes since to do it first.

Understood, makes better sense than allocating the requests first.

>=20
> Anyway, please propose such refactoring changes separately and they can
> be discussed as such.

Ok.

>=20
> [..]
> > > > +static void zswap_cpu_comp_dealloc(unsigned int cpu, struct
> hlist_node
> > > *node)
> > > > +{
> > > > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > > node);
> > > > +	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > > >acomp_ctx, cpu);
> > > > +
> > > > +	/*
> > > > +	 * The lifetime of acomp_ctx resources is from pool creation to
> > > > +	 * pool deletion.
> > > > +	 *
> > > > +	 * Reclaims should not be happening because, we get to this routi=
ne
> > > only
> > > > +	 * in two scenarios:
> > > > +	 *
> > > > +	 * 1) pool creation failures before/during the pool ref initializ=
ation.
> > > > +	 * 2) we are in the process of releasing the pool, it is off the
> > > > +	 *    zswap_pools list and has no references.
> > > > +	 *
> > > > +	 * Hence, there is no need for locks.
> > > > +	 */
> > > > +	acomp_ctx->__online =3D false;
> > > > +	acomp_ctx_dealloc(acomp_ctx);
> > >
> > > Since __online can be dropped, we can probably drop
> > > zswap_cpu_comp_dealloc() and call acomp_ctx_dealloc() directly?
> >
> > I suppose there is value in having a way in zswap to know for sure, tha=
t
> > resource allocation has completed, and it is safe for compress/decompre=
ss
> > to proceed. Especially because the mutex has been initialized before we
> > get to resource allocation. Would you agree?
>=20
> As I mentioned above, I believe compress/decompress cannot run on a CPU
> before the onlining completes. Please correct me if I am wrong.
>=20
> >
> > >
> > > > +}
> > > > +
> > > >  static struct zswap_pool *zswap_pool_create(char *type, char
> > > *compressor)
> > > >  {
> > > >  	struct zswap_pool *pool;
> > > > @@ -285,13 +403,21 @@ static struct zswap_pool
> > > *zswap_pool_create(char *type, char *compressor)
> > > >  		goto error;
> > > >  	}
> > > >
> > > > -	for_each_possible_cpu(cpu)
> > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > > +	for_each_possible_cpu(cpu) {
> > > > +		struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > > >acomp_ctx, cpu);
> > > > +
> > > > +		acomp_ctx->acomp =3D NULL;
> > > > +		acomp_ctx->req =3D NULL;
> > > > +		acomp_ctx->buffer =3D NULL;
> > > > +		acomp_ctx->__online =3D false;
> > > > +		acomp_ctx->nr_reqs =3D 0;
> > >
> > > Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize them
> > > right away?
> >
> > Yes, I figured this is needed for two reasons:
> >
> > 1) For the error handling in zswap_cpu_comp_prepare() and calls into
> >     zswap_cpu_comp_dealloc() to be handled by the common procedure
> >     "acomp_ctx_dealloc()" unambiguously.
>=20
> This makes sense. When you move the refactoring to create
> acomp_ctx_dealloc() to a separate patch, please include this change in
> it and call it out explicitly in the commit message.

Sure.

>=20
> > 2) The second scenario I thought of that would need this, is let's say
> >      the zswap compressor is switched immediately after setting the
> >      compressor. Some cores have executed the onlining code and
> >      some haven't. Because there are no pool refs held,
> >      zswap_cpu_comp_dealloc() would be called per-CPU. Hence, I figured
> >      it would help to initialize these acomp_ctx members before the
> >      hand-off to "cpuhp_state_add_instance()" in zswap_pool_create().
>=20
> I believe cpuhp_state_add_instance() calls the onlining function
> synchronously on all present CPUs, so I don't think it's possible to end
> up in a state where the pool is being destroyed and some CPU executed
> zswap_cpu_comp_prepare() while others haven't.

I looked at the cpuhotplug code some more. The startup callback is
invoked sequentially for_each_present_cpu(). If an error occurs for any
one of them, it calls the teardown callback only on the earlier cores that
have already finished running the startup callback. However,=20
zswap_cpu_comp_dealloc() will be called for all cores, even the ones
for which the startup callback was not run. Hence, I believe the
zero initialization is useful, albeit using alloc_percpu_gfp(__GFP_ZERO)
to allocate the acomp_ctx.

>=20
> That being said, this made me think of a different problem. If pool
> destruction races with CPU onlining, there could be a race between
> zswap_cpu_comp_prepare() allocating resources and
> zswap_cpu_comp_dealloc() (or acomp_ctx_dealloc()) freeing them.
>=20
> I believe we must always call cpuhp_state_remove_instance() *before*
> freeing the resources to prevent this race from happening. This needs to
> be documented with a comment.

Yes, this race condition is possible, thanks for catching this! The problem=
 with
calling cpuhp_state_remove_instance() before freeing the resources is that
cpuhp_state_add_instance() and cpuhp_state_remove_instance() both
acquire a "mutex_lock(&cpuhp_state_mutex);" at the beginning; and hence
are serialized.

For the reasons motivating why acomp_ctx->__online is set to false in
zswap_cpu_comp_dead(), I cannot call cpuhp_state_remove_instance()
before calling acomp_ctx_dealloc() because the latter could wait until
acomp_ctx->__online to be true before deleting the resources. I will
think about this some more.

Another possibility is to not rely on cpuhotplug in zswap, and instead
manage the per-cpu acomp_ctx resource allocation entirely in
zswap_pool_create(), and deletion entirely in zswap_pool_destroy(),
along with the necessary error handling. Let me think about this some
more as well.

>=20
> Let me know if I missed something.
>=20
> >
> > Please let me know if these are valid considerations.
> >
> > >
> > > If it is in fact needed we should probably just use __GFP_ZERO.
> >
> > Sure. Are you suggesting I use "alloc_percpu_gfp()" instead of
> "alloc_percpu()"
> > for the acomp_ctx?
>=20
> Yeah if we need to initialize all/most fields to 0 let's use
> alloc_percpu_gfp() and pass GFP_KERNEL | __GFP_ZERO.

Sounds good.

>=20
> [..]
> > > > @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx
> > > *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> > > >
> > > >  	for (;;) {
> > > >  		acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> > > > -		mutex_lock(&acomp_ctx->mutex);
> > > > -		if (likely(acomp_ctx->req))
> > > > -			return acomp_ctx;
> > > >  		/*
> > > > -		 * It is possible that we were migrated to a different CPU
> > > after
> > > > -		 * getting the per-CPU ctx but before the mutex was
> > > acquired. If
> > > > -		 * the old CPU got offlined, zswap_cpu_comp_dead() could
> > > have
> > > > -		 * already freed ctx->req (among other things) and set it to
> > > > -		 * NULL. Just try again on the new CPU that we ended up on.
> > > > +		 * If the CPU onlining code successfully allocates acomp_ctx
> > > resources,
> > > > +		 * it sets acomp_ctx->__online to true. Until this happens, we
> > > have
> > > > +		 * two options:
> > > > +		 *
> > > > +		 * 1. Return NULL and fail all stores on this CPU.
> > > > +		 * 2. Retry, until onlining has finished allocating resources.
> > > > +		 *
> > > > +		 * In theory, option 1 could be more appropriate, because it
> > > > +		 * allows the calling procedure to decide how it wants to
> > > handle
> > > > +		 * reclaim racing with CPU hotplug. For instance, it might be
> > > Ok
> > > > +		 * for compress to return an error for the backing swap device
> > > > +		 * to store the folio. Decompress could wait until we get a
> > > > +		 * valid and locked mutex after onlining has completed. For
> > > now,
> > > > +		 * we go with option 2 because adding a do-while in
> > > > +		 * zswap_decompress() adds latency for software
> > > compressors.
> > > > +		 *
> > > > +		 * Once initialized, the resources will be de-allocated only
> > > > +		 * when the pool is destroyed. The acomp_ctx will hold on to
> > > the
> > > > +		 * resources through CPU offlining/onlining at any time until
> > > > +		 * the pool is destroyed.
> > > > +		 *
> > > > +		 * This prevents races/deadlocks between reclaim and CPU
> > > acomp_ctx
> > > > +		 * resource allocation that are a dependency for reclaim.
> > > > +		 * It further simplifies the interaction with CPU onlining and
> > > > +		 * offlining:
> > > > +		 *
> > > > +		 * - CPU onlining does not take the mutex. It only allocates
> > > > +		 *   resources and sets __online to true.
> > > > +		 * - CPU offlining acquires the mutex before setting
> > > > +		 *   __online to false. If reclaim has acquired the mutex,
> > > > +		 *   offlining will have to wait for reclaim to complete before
> > > > +		 *   hotunplug can proceed. Further, hotplug merely sets
> > > > +		 *   __online to false. It does not delete the acomp_ctx
> > > > +		 *   resources.
> > > > +		 *
> > > > +		 * Option 1 is better than potentially not exiting the earlier
> > > > +		 * for (;;) loop because the system is running low on memory
> > > > +		 * and/or CPUs are getting offlined for whatever reason. At
> > > > +		 * least failing this store will prevent data loss by failing
> > > > +		 * zswap_store(), and saving the data in the backing swap
> > > device.
> > > >  		 */
> > >
> > > I believe we can dropped. I don't think we can have any store/load
> > > operations on a CPU before it's fully onlined, and we should always h=
ave
> > > a reference on the pool here, so the resources cannot go away.
> > >
> > > So unless I missed something we can drop this completely now and just
> > > hold the mutex directly in the load/store paths.
> >
> > Based on the above explanations, please let me know if it is a good ide=
a
> > to keep the __online, or if you think further simplification is possibl=
e.
>=20
> I still think it's not needed. Let me know if I missed anything.

Let me think some more about whether it is feasible to not have cpuhotplug
manage the acomp_ctx resource allocation, and instead have this be done
through the pool creation/deletion routines.

Thanks,
Kanchana
