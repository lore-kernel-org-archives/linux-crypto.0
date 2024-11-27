Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AAD4414;
	Wed, 27 Nov 2024 01:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732670567; cv=fail; b=JxDRVzaMALcdvZ7IUmAmPwIh3X1aL27/EtVPmUtUFSbWowjuM+lOGPjxU9EEXB1Fe9i/M9flTGmkVhmm8EZpIdmfEwt0IbpZ+sbJVBpK/RUI2aKxm8b5SMTZhdU5cdZrtHepvcTAlJdBhH9aGcb5mtwpxZLXsS+bSPc/EhvGHP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732670567; c=relaxed/simple;
	bh=GCgL8kqWebQaZrATEqYwwnyDGBUOFcekcHAoRaOt568=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OieiMGMgaPhr2dGBi4/pnPt0+lEDlXnaur74S8YyhOkX3HwPD+W/E+qXyWtGG2soCoiuquryxyRkUvrqvlx+pLMnnSBvDnabay8UMy0mDYC4jh1rjVXfYw2+G+Zi60cjPARi3gjyWUEWLOSG/KUuOvR8wxI0G7HKcW2zaW+2rRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IL5qZXG1; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IL5qZXG1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732670565; x=1764206565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GCgL8kqWebQaZrATEqYwwnyDGBUOFcekcHAoRaOt568=;
  b=IL5qZXG1WhmzpwIvbQ0HDhQnwCrW5raiZaSwMP0m7xtg1NdMbFSSNG8H
   ULyWK6XGYiOBFQ4kHudVeaDjFUzbMHJS+ygyRhSd0cwljREYFs8sW0BC0
   d5rTYYkeAwllGI8prxLjVT44Ld/c3TPIhHwZynMe5ASzUOrylmtKL6i8W
   pW89F7Ja39ncYm6mh9Ul8j1YBD9yYHYbmOXQz/NkXNjcV22lwExpuDmSe
   aqwuwNsfP925h8Y8UK4H/T6ysFSwMjKfQAt99wmlpQb4+RO4X1sBod3b2
   oIJsiU8AMaXfbRDbHF37xCfZf6RU3nvNa3ALMg3QK9UV3LcSrjnDiA4+d
   g==;
X-CSE-ConnectionGUID: Ok1PqlvCThSvP5UJHZwCKQ==
X-CSE-MsgGUID: CMDvleqDRkGecOSbjQVAKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="32991077"
X-IronPort-AV: E=Sophos;i="6.12,188,1728975600"; 
   d="scan'208";a="32991077"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 17:22:44 -0800
X-CSE-ConnectionGUID: p/LBgVFvRN+NGUQtncOu5A==
X-CSE-MsgGUID: eVIxsC9WSeqi2kOhozbfVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,188,1728975600"; 
   d="scan'208";a="96527518"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 17:22:44 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 17:22:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 17:22:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 17:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuKXqaq5Qo9h9p82UXyJ8Q1DqHQD1aJiIKxhBK9bdT2lnH60VJfp6kteTIzM4U2gUr/LVnJEVqqAqRv5R7ve9cqwRKSqBlOP/NlF2UspN7WWP7rLBkPLmLko24+0CVcerfojh1aO93JH1JL3b5vIBsmD1rH0omnLMg7lXHGGUIz3NjTk13VNzF29PwWMALI1aFN4EKpX44sVkdFzsJUNgUM4kHIJa58/cryWgMyEh8RBVC3dqSS4NzL9A7GVbmDNMJxJQaqn0WcI1nAyEnjDIbAnbNb9rELVc6C0M8F5B6pVlmLf7vOTqhjZqYrhsZAK0Kx/kVJsB0iYxnw15Lufcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brP437tvp7TDsRkR80XBUdW4v6CzoGtmXfyCUIlErjc=;
 b=tPf3CGkjVbIQ8s6Pf4FtKFlk6venY0S5REcg0jQlJJZM9+5lXcqfT4gAiUgposC8HfTVGNFvUs1SdsEwslJb/saCiKmw6kqacqUAjh6q3HXgwGTVX1OgzKNpYhK6NDzoBpmC3/qZ+yJNrvwABpxKhZjmheE8TjNcyQfPl8XD6YPwjxjnSZFaVBFvAuuiqVvxmOa1FvIlj5cg4vF+h/3ghaoA+xNZOhs6f3tIlAFRpWEfSNDQuY98oqFAswBFpHaB0NZXRdk6tzSBfi21xCNGr/Cbl7ebDKpnRP52E6NEH9GBCTXo6HV01Kq84+mMQfecp0nGTgVwXdFymEnwLyPpiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Wed, 27 Nov
 2024 01:22:40 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8207.010; Wed, 27 Nov 2024
 01:22:40 +0000
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
Thread-Index: AQHbPXWM22jcCkeyAE6LgM2tVAM8N7LHv8kAgACul1CAAGZgQIAAAicAgAABOWCAAX7pIA==
Date: Wed, 27 Nov 2024 01:22:40 +0000
Message-ID: <SJ0PR11MB567871A712CE2E971B909D93C9282@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
 <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z0UvACaa5wwtTgQu@gondor.apana.org.au>
 <SJ0PR11MB5678654768005E5DF6542F2FC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678654768005E5DF6542F2FC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CY8PR11MB6939:EE_
x-ms-office365-filtering-correlation-id: a8792e04-37b0-43db-7f7e-08dd0e81fc7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?eLRpZLVta8LOJC1W0n5GyfUrkjiM84GR7b5uuoRnlA7zMmz8gZ5x1D4MmQTG?=
 =?us-ascii?Q?S3zxCVBmvCg3R60ciU9gaUXFuXCPKVsvmwYLmkP5OFl6iJI+wUCfJXKojcDo?=
 =?us-ascii?Q?XilKPuxt8LHBkrDX2WBL375fCBtawR15eqH/3AHJv0v3M4K1c3DCC6sRL2rx?=
 =?us-ascii?Q?NEFa6JFzMmHEcb5vIeYgn2xAOKDaJfC5xruu/wXINOm56AfDl0aS89+CCcQw?=
 =?us-ascii?Q?q8NQBR6P2icg3UxDA7HqrwB2AJg+nfTG3KscvBUtLL+9I1wSsMK5uImnMFT/?=
 =?us-ascii?Q?mXNNFcjUR4LtC3q0eD1H65/d22y7BMwlAxeLs+LcnhRtxo+AXK+Qdxh6j9Cf?=
 =?us-ascii?Q?srRepMRMrlTKwmgDNV6pS8/XvLHnac3AjQSClxQgcJ5jlN1lQgX9RVlzlAee?=
 =?us-ascii?Q?XPAzYe04BmTFLOUsl9igQpeE7kKspgJ9XtYf2a0kXxJhEx03zWEJ3i7HbLCJ?=
 =?us-ascii?Q?CBPi8U3+20ytAFHuVq/L7Wt0MFyppIRmIBAw+MXkikYaoASKh6LEBL9AmyaH?=
 =?us-ascii?Q?XVZoazpbT5i9WLonuc/Q994/I/wr5cKGkRgVovOtONxn30Y7n7N2nzAj5euP?=
 =?us-ascii?Q?jMdgRkxQMz2+7BFjEFFubCbbSbyFR82KyiqZ9H2aXQj7q0Mtxt+zNg1QnJhv?=
 =?us-ascii?Q?VWePQ5sSC+oJyMgD7gHDNsUT5a3v+Icvxbrr+SnMCGHsZJzofw1ZpHoUMpxD?=
 =?us-ascii?Q?shzZJxJhLKzxGvlgUkXVGsTKn2JavhdNoAJs3WMw0wa7/aiZ916t4eN08V8N?=
 =?us-ascii?Q?3vwOxOU/MxpJm/mD8uFOMCBf0YzLosGbvfDNbQs59CIeOijNTBqmpv+oPbpD?=
 =?us-ascii?Q?gVuJKnDIP48Rxi4hWkXm2D+INEfrvr8DDca85kzkes547hlCPIBgJSGFtjYX?=
 =?us-ascii?Q?c+HF5kj5FVnEMuAy9UtsIXjdYk3xM1Pum9FrdDykoKcFC4R4poXHcspUge40?=
 =?us-ascii?Q?8Cj2VRX/kF6IFKgT8VKfcqHNqZrP8Wr8eGLRkBn5rhxpQm85B6TTZoRQo8H+?=
 =?us-ascii?Q?lY5gtvPfM3ZcSE9VySXhiJr6L69taEY3LeJpgP+vybcqXDYuv5WgTK+aKf5a?=
 =?us-ascii?Q?zq/cu9nHq7fKrGN7NNQH02bU8AtwZ3g1X72xMQuLiEhH4OE+ncirk4Ap7rVi?=
 =?us-ascii?Q?iIEGaRku8mV8lqEwDgjVJMFRh0ZaNHr9jGgT7pkA/gbE7+GlxxOIj8agjDUn?=
 =?us-ascii?Q?EShqimskevejxqT36jnnmtMk+EkPxJvbId+sJSGn41FwBVmG97NVvTh7mBZL?=
 =?us-ascii?Q?ji1i26/QfGLQWTm/cx+myeTx91/rjd9BzVzX3EnVK9nB8Q5WobGVnJRhl47e?=
 =?us-ascii?Q?thYVuaZ2OpMMq8Z4zmJR5rLyGUCH25A6TllBwVHaqmMRdAgH2//ytVLOw+b+?=
 =?us-ascii?Q?LtnImoY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hz7Sw/m8nxe+ovuWbBYGpVpnEzzpgHJpI9CjsxUsOrRiu9GGXoKjAE2EO9IE?=
 =?us-ascii?Q?xPMVnQ7nBwV7sVa/RH0FaCFdclIzjB2EoHaRV3CyGAE9R3OLlzXwj50KEY2d?=
 =?us-ascii?Q?sD9OaOusF7Apgi/u/1nhjPsnYDAmNU8oxg6zevSWw4HSiIb3oDrqTupMnF7V?=
 =?us-ascii?Q?V7WZfG2uyUIDwOf9qPzRzh3L/nmlwE9WggyxsSmULi/bym076gOdkKECQXn/?=
 =?us-ascii?Q?joZb2cYq93TpqcwI24ErmFYhOhnwm1apgeM4ODtVmqSwF6YkmusuhErmMwDY?=
 =?us-ascii?Q?4hZW2da1l1qEolcNcmKmh1e01zWwSVPbdjNQ5mAizrSY/k1y6ib82AcwQRDe?=
 =?us-ascii?Q?/DnoOHncyZ6aT9R5eLKvlJFVYwfcdJt8h5eEtMtQFwxE2J9EoHxHFIQ6TMxI?=
 =?us-ascii?Q?cpzMO0oGBO6AY8cKdncjAmmrCxpW1Tyn3yI0jGgt0JbMkrmeFv+tpNA7h12H?=
 =?us-ascii?Q?bFPToAf6F+cRPBwpBUMk0hbegUSdSSybKmGvdL44L9SIkTWpyeBvpKbXPRPy?=
 =?us-ascii?Q?etW36ftLd/Pu/Xl/BHFdJlpTUUHQPeAXmzSj5VgRrruMk01eYWBEV+Z8TTR4?=
 =?us-ascii?Q?MutGig/KHbYjQZCkXj6HKbPAaD+iz3pVa+zBwPYfjT8aEnbHsMrYUGnpog1I?=
 =?us-ascii?Q?RCule/zoDzgdyxxQ6zyjnZAOoIp+Bo0Ar+hM8yo44wGSuqpDQbHqJQ/WSPOa?=
 =?us-ascii?Q?dsHzXsmv8HRoAYkcYnKgrkpIWUDj5bp32vp8QNy2oMxJD8XgGNrB10v5P2bl?=
 =?us-ascii?Q?PXACl8OONPUsP/FiJlHco1PsQhaOZz0GSgQLoFfz7VKVvH7sSbOQeT6IUUK9?=
 =?us-ascii?Q?7c96BnyNuvGL9FGNCX5Z7sAEcOl2oyI6Nr/zwpBOkff8rY/ZWJuEubXyrdJ3?=
 =?us-ascii?Q?measTuZr6bViWgCUMPV0pjlRYh+XU396PEo6ZmeUtwa52Gbwj050OBdRdKPg?=
 =?us-ascii?Q?IHevK/j2H7hgMztuI5K4SyNhi5sc6JVSv9oDIRtZ1UHO00CIpT8SDTWL7LtM?=
 =?us-ascii?Q?r1/Uc7cWPDN/t42JcXlXeon70pE7K+njJKW8D3srw0c4s/jp1L/NbDxQSsLW?=
 =?us-ascii?Q?I91pJdHZ/5pI7YzRBahNwgwT1co4lWwtQN0Q2H5VeEZAUOYkn626yQh0BNRV?=
 =?us-ascii?Q?tku7mEr8PE05Bc8hrHsAHKud2Wu9FQBFDkJb38V7S4l3la+UEupPVPn6W/2Y?=
 =?us-ascii?Q?JUzi7pwu7etTZuEYL2Mq6AoNEZoJqilwy80fnXFi5u9d9Vwjw09Ayq5ViJBk?=
 =?us-ascii?Q?M1s54kbTmWSJmwd4uWq6Cp0RFaGMdDHTk0jLY2sNW0wEvqDu1v8/ZJcJRbwt?=
 =?us-ascii?Q?qXwdWSnAL35OpNdzdYzgdeKX49AQrfTyxDqhK5qYgRRb9kx51QZ4xE+Msj/3?=
 =?us-ascii?Q?URyL6I65sp8FEdqDSXPLcSQyApL4B0xiPqQI+gImJv7IQ1PH+bON30FCBf6Q?=
 =?us-ascii?Q?2lexwSt/FumsYPcKvqsPBUconBd4Bh+UPSQd14PkvSQXujU7JLoWfpKJZ4s+?=
 =?us-ascii?Q?i6BV5gRzGtaFiExGHqrIIwKj/71Z3apkEA73DOmCkAtlHDelxr3uxxF9bkvu?=
 =?us-ascii?Q?6pbnwpeUV8CtS2R4iiGdIuc1tCG30h9dpg5Lx23YfAejW5vdqA1pShUK3TGe?=
 =?us-ascii?Q?IA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a8792e04-37b0-43db-7f7e-08dd0e81fc7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2024 01:22:40.5788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HB8Jblv+CnL4psiO7fHBQp+EdCPDPCmX2Y0JlpIO2GeS1gOiCYGLfZwHYgcg45JpBZe/uKRYPD7KOHqNwtPtmd+kOvF1+aRTqjKjgU12Nis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Monday, November 25, 2024 6:37 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> linux-crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>;
> Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v4 01/10] crypto: acomp - Define two new interfaces f=
or
> compress/decompress batching.
>=20
>=20
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Monday, November 25, 2024 6:14 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> > linux-crypto@vger.kernel.org; davem@davemloft.net;
> clabbe@baylibre.com;
> > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces
> for
> > compress/decompress batching.
> >
> > On Tue, Nov 26, 2024 at 02:13:00AM +0000, Sridhar, Kanchana P wrote:
> > >
> > > I wanted to make sure I understand your suggestion: Are you suggestin=
g
> we
> > > implement request chaining for "struct acomp_req" similar to how this=
 is
> > being
> > > done for "struct ahash_request" in your patch?
> > >
> > > I guess I was a bit confused by your comment about rebasing, which
> would
> > > imply a direct use of the request chaining API you've provided for "c=
rypto
> > hash".
> > > I would appreciate it if you could clarify.
> >
> > Yes I was referring to the generic part of request chaining,
> > and not rebasing acomp on top of ahash.
>=20
> Ok, thanks for the clarification! Would it be simpler if you could submit=
 a
> crypto_acomp request chaining patch that I can then use in iaa_crypto?
> I would greatly appreciate this.

Hi Herbert,

I was able to take a more in-depth look at the request chaining you have
implemented in crypto ahash, and I think I have a good understanding of
what needs to be done in crypto acomp for request chaining. I will go ahead
and try to implement this and reach out if I have any questions.=20

I would be interested to know the performance impact if we kept the
crypto_wait based chaining of the requests (which makes the request chainin=
g
synchronous IIUC), wrt the asynchronous polling that's currently used for
batching in the iaa_crypto driver. If you have any ideas on introducing
polling to the chaining concept, please do share, I would greatly appreciat=
e
it.

Besides this, some questions that came up as far as applying request chaini=
ng
to crypto_acomp_batch_[de]compress were:

1) It appears a calling module like zswap would only be able to get 1 error
     status for all the requests that are chained, as against individual er=
ror
     statuses for each of the [de]compress jobs. Is this understanding corr=
ect?
2) The request chaining makes use of the req->base.complete and req->base.d=
ata,
     which are also used for internal data by the iaa_crypto driver. I can =
add another
     "void *data1" member to struct crypto_async_request to work around thi=
s,
     such that iaa_crypto uses "data1" instead of "data".

Please let me know if you have any suggestions. Also, if you have already b=
egun
working on acomp request chaining, just let me know. I will wait for your p=
atch
in this case (rather than implementing it myself).

Thanks,
Kanchana


>=20
> Thanks,
> Kanchana
>=20
>=20
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
