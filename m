Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D3720B80A;
	Tue, 18 Mar 2025 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742319537; cv=fail; b=nAMRCRSsoBTTqDrcFdrxAcYcXUFUWJeiDV3praf9TKstI2zd5W3vvUBLWKBHv9zdqeWrZmOUzm/81p/m2cbVL+DqDUVZJiJXTXy6ctLbOk/isuqXLsbHTFdkuiZAMgwu6y0DFyYL6/kHgjipAbgSYIv0VHYoh9IZLs0m8Z6pEys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742319537; c=relaxed/simple;
	bh=AwEjEY3poQhYyVSK2TlpDsMxpjtll3NC0rdiC++/6Sk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B5ZNjUr+yZq+TUw8FC+vrwOHbDbQXk7YPrle7NPmu7fxbxxbzb+efDbrDAwMmEN4fGCk4POhR3zXtL7qk4QcyRbSg1OBf/6Xt8Kxawqqf1rW7uLTRLRD0ji4uVdSiOKV+nQjjG29ZxS6v7iynqWvmb6v99HZlANuRNx50Po9uYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XUuKF6PY; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XUuKF6PY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742319536; x=1773855536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AwEjEY3poQhYyVSK2TlpDsMxpjtll3NC0rdiC++/6Sk=;
  b=XUuKF6PYETixTpRwIjL+ZxzjuFQ6L/L16opvA2ymd3rChWuWEnKgXy+f
   2ti4ZEEOIP1ct0BxA+0Kq/5N5CnAJPsk40tkDzC7Vl4oxaeuk/XGoYFX8
   W0HdRNnYgHb2AGzRvTco4RwKsWeQEq5ctLNKZsUFAwoogQ69JwCKFpkFu
   GsIy87ZoK+zj4VFiICF9X+DkFk2izlMb6AIfT/aXWTTNQBdMmoBh0JSel
   J2IHzAAIcSTTLSJPexzsMry1WDW0coEsbNxKLzDwQ2JU0d/7KSmGxNDlF
   odH1xbf9wriKw5w3KkJzaf+ibIePOuokLTJQk/a3cGZLfYdrhfXzx2kF3
   A==;
X-CSE-ConnectionGUID: 5L0FwfLuRkW+UZBFSYZJmg==
X-CSE-MsgGUID: sSQtkqsDR8qwroCv11r/TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="60868591"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="60868591"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 10:38:54 -0700
X-CSE-ConnectionGUID: YouJnVXqRUO7xeUnNvn8Tw==
X-CSE-MsgGUID: DurZsEj9RQaDAu+xgial5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="127378086"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 10:38:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Mar 2025 10:38:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Mar 2025 10:38:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 10:38:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ed3ZhgOKh1yVEsyVZNiv7OKC9rSrVbHKQQa9o2EAyF077Kled1ZPq5I+bi1MecEUB0rO8ilebWt4RXBYJDj8ahITpfKFn8qrb7BTI6pXuR79QvFl8at7pilx3m/VBJ1eQv73P0hXvG/igJupKhWQ/cL1sIswov6hX2Ozk9XMObAuBDbpBCn0rnoxXe+xC7lzD5l+5/RJ/QBS8Oe4BjHa/jxPcDl25hev4eq64qKmCGEIaIXMKXBFtijopEhUK+Sisan9OVVIhg6HEGd/1ij/xDMovzcwOlo6VnSjzdN4hG9aWdmlgK8KgvzWVt3EOAsfj8L+fcjMeztzTCDB6bAD3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pD92lxNHC32gJbPbCyTDMfNgbYgfZJW9My2Why5Xv1M=;
 b=D8331WL4ax0urSGYULhQGgXoKXEP3tjerWkPalWw99fU3AqmuZgXkPGb2SkiZMK2JWvCXvdJlBHF6T2c78BY6mpMFJVgu+iqDErNmtif36hyPP3nmAWhKeVxXa5Lrj6S3nCJWc2km84E8+vtx0zPnWdOZtdxlvzOhR61fYbeNUO0D1Ad/AS/7NQgK1NFj/ap+H8j1BycyKCdxmwrbyEOVVVYPZ+9AS41lFviLKkUgyYfOZwKzMTF90b9+Rg4IvGs9ONOrXabS6Efd2lqLr0foikvEiroHeuL003cYxWDL7Z+hgDbApboK+TwYFtB+PrvPLZ75hN4eXZ0SMmH+E4YOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by SA2PR11MB4876.namprd11.prod.outlook.com (2603:10b6:806:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 17:38:50 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 17:38:49 +0000
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
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hCAAVPdAIAAYjdggAQziACACyMtkIABOxcAgAAmLoA=
Date: Tue, 18 Mar 2025 17:38:49 +0000
Message-ID: <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com>
In-Reply-To: <Z9mB5IbNEdNdtmUp@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|SA2PR11MB4876:EE_
x-ms-office365-filtering-correlation-id: 8b9414cc-a52e-4daf-687f-08dd6643be48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?FbUFxgtEbRSimt3IcHAxtuUPHAbIujF8AsnKtsgaeMPGe3LTMWhi8Jqm7bId?=
 =?us-ascii?Q?/RuQKsJZPBt7nA/0XbNWWjCqaciFfX7r3NXOMmqiUW4gDjiUyGLEMiJjUPvt?=
 =?us-ascii?Q?teC5/w1uX8O5xAdlvP0cowQQ6wxi/15TjlViilVSwR+hw8W19G/TQQ6ePtjm?=
 =?us-ascii?Q?ptC6Vt6vFfP5ngDBHCSQ6fiRv5g24UZr4cIoZTrs4BjlN2BWGKQE4xSVEfCj?=
 =?us-ascii?Q?xdtD9CJU4Gw7lUz+qZCn0d8qcr6EOBDC4PzoM5u2O8Yw04QH/8NXULhINdFa?=
 =?us-ascii?Q?iQr2Gyo4QpIRaJxVg07aows2qxWcO08i4pun4BgufbZwLsalW0KgVnY/8vr5?=
 =?us-ascii?Q?T3bizt1X0yjmqQqNfyvGCfMxmWdSIpB4ApnBIzXdXh9j3xPsa9QHKfZCINP4?=
 =?us-ascii?Q?jtysy8gCDf7VBRorzM+YiSqp2AQ9ju0SQVx6JWIq45gVc/Hm8s6fXX0p27EP?=
 =?us-ascii?Q?BD2JTInJiK9yntIDkh8lhLiRwUelIxQpQZQW+cyMaOvpNoNFCTp09nF8z4G6?=
 =?us-ascii?Q?Y0kvESWr6y0WYLTzuD1Yeom4dTaY0DxJdUGrOxjM+4K7bIg5cxZEjb6FOoJk?=
 =?us-ascii?Q?UwAIfVIAoVOZarZEcRxMSgNWN5/Gav1Aavsa8qK4UpqTPSAGZ/jIkVztJJJi?=
 =?us-ascii?Q?yN1ZzSPRLH5AZOsABuOHq3evzYOPfuGQRcNCMj2iz2Tk+MdqXU8ooV8HcJ24?=
 =?us-ascii?Q?vWX5NCpBUXGqj9EfcBGh0CredsRulQgwoRwg2O5OreDu6439UIAB5fBDrkjn?=
 =?us-ascii?Q?e6R8Tda+noNoJ4fpaWcVNuS+ZDpdJeBB4xg0SeEzs6tr0/fFqiU4kDzzTYBe?=
 =?us-ascii?Q?4/4jCxZITtY9GoEPKy+rDzk/zd2tnCgbOpX1WGmfJtuI3UXZju/jXBr0BS76?=
 =?us-ascii?Q?rElvR65+SV5HtycnlOsbyKLR8XJQpahp0C060wcmCTBkSzKQkocbYu3hdU6t?=
 =?us-ascii?Q?7H18zmiGVoRDhAg9/bvbWO1S33RJL/BYmi162330R0agEuK99+aLxh74A9Ek?=
 =?us-ascii?Q?958BsQ7JIHjWLCDZGo5cU09KOsy8i/+YPCL8NcI8TIhmI8YYH7EDyrtkz80Q?=
 =?us-ascii?Q?5JDCwgUIvpQc7NHcY/LC9eQxqjeHGS628iW9mN/+KBZvlJF2Aoxz17vL56bd?=
 =?us-ascii?Q?YcSpRxsefTDS5hdskD1r8JIUJlP/Al2KK6HZkLJm1UrxsID/UoSkItPDs0PY?=
 =?us-ascii?Q?RsDAwrTTgj4zOIoBLfMpbjZ4vGPm2N6MWzhoGg9WscsYPbkucd2RtvE3CVJ8?=
 =?us-ascii?Q?REL9rhMEAMp/rNGfVXN3aOL4Nvdpku/8giix/hLIX+I+i4WPqrHeWMPMkAR+?=
 =?us-ascii?Q?lsAS7FipZpNZDN83Ym87Tlo62tt3TBD1UabP1aZ1rbLKaylJQfPMWdMnFHFk?=
 =?us-ascii?Q?Q8DNl2+w6EnvmmP/caIZNRBbrkjIejgeANf9gQv0jU77MpLNasuOZF9hvMjQ?=
 =?us-ascii?Q?9oOlrhZRU5mLaE+YZbgH/UDyOoBF45tn?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S44V5SEAIwMEicXJziOjB0nYOtpWQGaM6J6rSQ4PBBUyOla9nL1UOgJGs3uN?=
 =?us-ascii?Q?FLTusnBvpHWutJIwSFJg59j1gmO0H7rU4fYdU2DiPNOCbyQjpqpZU5q2pDPA?=
 =?us-ascii?Q?JLGySFx72xXjYxP6Egr+Ah2ObE/omlupDk8zwLFO8nBFMkSamYZwkmYrpUWp?=
 =?us-ascii?Q?Lfye2BydY2qQ58NNKVSDNVHmdIYHwPuP3moSuGF+QMHOWvSWpiQQ1jiCkBoB?=
 =?us-ascii?Q?KqSJgtth4qKIuXZCXVlFvoHZCTaT/85XKC4WpLwnwG3iPGLiXmH3olry8iGm?=
 =?us-ascii?Q?CL92/QMRmp3T0BmVWWcIBcfaLQfg2jecATi3O3Q03Cp25y0+Y1ZGnIQ7BE5i?=
 =?us-ascii?Q?EQSwkW0whAs1lK7X+Lna5ONSXIs2GnNTYP8FBXhJXoY/SWcb19wJcLHBZwTx?=
 =?us-ascii?Q?RuKx5RbzugVNfa4+6xY4+spQDWOTe7Qu0iMGFUxSereO8E5uDYRFO3a3BWlV?=
 =?us-ascii?Q?RqJedAwOimqI0KawrLPNMqamK5CXpnT9s1gq0/N++Dnr1uD2ECEBAo4W25oY?=
 =?us-ascii?Q?jJTQYmEvNbZmc8w/AjY9G6EY00viSbDQFlsIouuq8M+hr9245233OOSYhH3s?=
 =?us-ascii?Q?1TUYKVPN8Jl5caoAAu4Pm28oHhy3qdcPT9qoXOlGOQkFfDE/jNRjJi+gfqXZ?=
 =?us-ascii?Q?HtYsTpSkgvlUAIUt6ZL/c/yLKpfGNXSE4Tp/bE4vokY5PQiUkxAaqcNUFZ9Z?=
 =?us-ascii?Q?STdDNxNnp81OQWSFbd7TsKbNed1Otb5ZZptn3vQasRFyy8DyJMjO2t/XrW5S?=
 =?us-ascii?Q?jVWIEWXN8oLMa+0+H3t1ML2W6bDGxbiQ3UkYTs7bqu83bgPlUkCFHN0d9KJE?=
 =?us-ascii?Q?bkI9GTi6Kox9VXQ4CixtsprET2r+iMSIaRXZKFBhBSeerLX9aCUeNZe33WeF?=
 =?us-ascii?Q?CciFt6MtAGeRC7/YXFQSy8ruGcq41XU8JBX6NDeljNRwepvkWh1fFSE2svoC?=
 =?us-ascii?Q?CpuBu2GWx/zYqtZMut2+ccDGK+o5YkUq/kBagnDekFHXgI59qVAj4mcq/p56?=
 =?us-ascii?Q?Uh+59RZX4tlq6RaB+ENisBhMSO9IqNPDHenFGgzehcd5dvTdvPwyqRhm5770?=
 =?us-ascii?Q?nnUTpoW6Q3pLTxb9YGOGiT5mD+xbcp8fMXGZrb0abVmNeZK7FKtM435Q19wz?=
 =?us-ascii?Q?ewscMqmJ04w0a5XSBUVOHN4C8KfAzLkSQOH/jjr8lGfNdYvtoVeSX86hYNvE?=
 =?us-ascii?Q?HrUbS4Fj5OD6W5HZdAynEEUk9i4RMZj7dkaP24LAhfkQw392JQBbXegp/lq3?=
 =?us-ascii?Q?9+KVVnkeY7Dl+pb1eoPGBjyGNbltm0xHxg8yLLZx5YgYhn50uGDYYjfFdoZX?=
 =?us-ascii?Q?hnMJEAwskbB4dxnFmpji2D0+5cTepxmCacwkT+MYEmlTytBuq63bKQM+4xhG?=
 =?us-ascii?Q?UtXKFd1l3sQ3VpuYGso9l9Xq7ESHcSzB0lKttpVVdamB5W8lAwtC6ImdLHy6?=
 =?us-ascii?Q?+C+0m6t0Nfxmf/t/riKMHLABtAQK5crGyC74FRp/9GLC0Ds7w7QfnJJQfV63?=
 =?us-ascii?Q?crSykT/GruB4DBq0Q5zksOyCzk7TrC5nD/+gFhteb8YA0226YDR03V5aHoKh?=
 =?us-ascii?Q?QVeAPAbvESg1U35b4XyUEjSQquLgBdG8Fdyq5f2B2O3B3ZzwJIkiFGiB9NPB?=
 =?us-ascii?Q?Cg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9414cc-a52e-4daf-687f-08dd6643be48
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 17:38:49.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eZPruIR5Oti1BN3BcOh6a7kLTio+oVGKBFUT7TcnoNmsYqqN/IPLBoe5tV+J1Ts5GSsBc7PvUGqIdZql//d6uUw71pqJmG1ZkKiYGVbMI4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4876
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, March 18, 2025 7:24 AM
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
> On Mon, Mar 17, 2025 at 09:15:09PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Monday, March 10, 2025 10:31 AM
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
> > > On Sat, Mar 08, 2025 at 02:47:15AM +0000, Sridhar, Kanchana P wrote:
> > > >
> > > [..]
> > > > > > > >  	u8 *buffer;
> > > > > > > > +	u8 nr_reqs;
> > > > > > > > +	struct crypto_wait wait;
> > > > > > > >  	struct mutex mutex;
> > > > > > > >  	bool is_sleepable;
> > > > > > > > +	bool __online;
> > > > > > >
> > > > > > > I don't believe we need this.
> > > > > > >
> > > > > > > If we are not freeing resources during CPU offlining, then we=
 do
> not
> > > > > > > need a CPU offline callback and acomp_ctx->__online serves no
> > > purpose.
> > > > > > >
> > > > > > > The whole point of synchronizing between offlining and
> > > > > > > compress/decompress operations is to avoid UAF. If offlining =
does
> not
> > > > > > > free resources, then we can hold the mutex directly in the
> > > > > > > compress/decompress path and drop the hotunplug callback
> > > completely.
> > > > > > >
> > > > > > > I also believe nr_reqs can be dropped from this patch, as it =
seems
> like
> > > > > > > it's only used know when to set __online.
> > > > > >
> > > > > > All great points! In fact, that was the original solution I had
> implemented
> > > > > > (not having an offline callback). But then, I spent some time
> > > understanding
> > > > > > the v6.13 hotfix for synchronizing freeing of resources, and th=
is
> comment
> > > > > > in zswap_cpu_comp_prepare():
> > > > > >
> > > > > > 	/*
> > > > > > 	 * Only hold the mutex after completing allocations,
> otherwise we
> > > > > may
> > > > > > 	 * recurse into zswap through reclaim and attempt to hold the
> mutex
> > > > > > 	 * again resulting in a deadlock.
> > > > > > 	 */
> > > > > >
> > > > > > Hence, I figured the constraint of "recurse into zswap through
> reclaim"
> > > was
> > > > > > something to comprehend in the simplification (even though I ha=
d a
> > > tough
> > > > > > time imagining how this could happen).
> > > > >
> > > > > The constraint here is about zswap_cpu_comp_prepare() holding the
> > > mutex,
> > > > > making an allocation which internally triggers reclaim, then recu=
rsing
> > > > > into zswap and trying to hold the same mutex again causing a
> deadlock.
> > > > >
> > > > > If zswap_cpu_comp_prepare() does not need to hold the mutex to
> begin
> > > > > with, the constraint naturally goes away.
> > > >
> > > > Actually, if it is possible for the allocations in
> zswap_cpu_comp_prepare()
> > > > to trigger reclaim, then I believe we need some way for reclaim to =
know
> if
> > > > the acomp_ctx resources are available. Hence, this seems like a
> potential
> > > > for deadlock regardless of the mutex.
> > >
> > > I took a closer look and I believe my hotfix was actually unnecessary=
. I
> > > sent it out in response to a syzbot report, but upon closer look it
> > > seems like it was not an actual problem. Sorry if my patch confused y=
ou.
> > >
> > > Looking at enum cpuhp_state in include/linux/cpuhotplug.h, it seems l=
ike
> > > CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section. The
> comment
> > > above
> > > says:
> > >
> > >  * PREPARE: The callbacks are invoked on a control CPU before the
> > >  * hotplugged CPU is started up or after the hotplugged CPU has died.
> > >
> > > So even if we go into reclaim during zswap_cpu_comp_prepare(), it wil=
l
> > > never be on the CPU that we are allocating resources for.
> > >
> > > The other case where zswap_cpu_comp_prepare() could race with
> > > compression/decompression is when a pool is being created. In this ca=
se,
> > > reclaim from zswap_cpu_comp_prepare() can recurse into zswap on the
> > > same
> > > CPU AFAICT. However, because the pool is still under creation, it wil=
l
> > > not be used (i.e. zswap_pool_current_get() won't find it).
> > >
> > > So I think we don't need to worry about zswap_cpu_comp_prepare()
> racing
> > > with compression or decompression for the same pool and CPU.
> >
> > Thanks Yosry, for this observation! You are right, when considered pure=
ly
> > from a CPU hotplug perspective, zswap_cpu_comp_prepare() and
> > zswap_cpu_comp_dead() in fact run on a control CPU, because the state i=
s
> > registered in the PREPARE section of "enum cpuhp_state" in cpuhotplug.h=
.
> >
> > The problem however is that, in the current architecture, CPU onlining/
> > zswap_pool creation, and CPU offlining/zswap_pool deletion have the
> > same semantics as far as these resources are concerned. Hence, although
> > zswap_cpu_comp_prepare() is run on a control CPU, the CPU for which
> > the "hotplug" code is called is in fact online. It is possible for the =
memory
> > allocation calls in zswap_cpu_comp_prepare() to recurse into
> > zswap_compress(), which now needs to be handled by the current pool,
> > since the new pool has not yet been added to the zswap_pools, as you
> > pointed out.
> >
> > The ref on the current pool has not yet been dropped. Could there be
> > a potential for a deadlock at pool transition time: the new pool is blo=
cked
> > from allocating acomp_ctx resources, triggering reclaim, which the old
> > pool needs to handle?
>=20
> I am not sure how this could lead to a deadlock. The compression will be
> happening in a different pool with a different acomp_ctx.

I was thinking about this from the perspective of comparing the trade-offs
between these two approaches:
a) Allocating acomp_ctx resources for a pool when a CPU is functional, vs.
b) Allocating acomp_ctx resources once upfront.

With (a), when the user switches zswap to use a new compressor, it is possi=
ble
that the system is already in a low memory situation and the CPU could be d=
oing
a lot of swapouts. It occurred to me that in theory, the call to switch the
compressor through the sysfs interface could never return if the acomp_ctx
allocations trigger direct reclaim in this scenario. This was in the contex=
t of
exploring if a better design is possible, while acknowledging that this cou=
ld still
happen today.

With (b), this situation is avoided by design, and we can switch to a new p=
ool
without triggering additional reclaim. Sorry, I should have articulated thi=
s better.

>=20
> >
> > I see other places in the kernel that use CPU hotplug for resource allo=
cation,
> > outside of the context of CPU onlining. IIUC, it is difficult to guaran=
tee that
> > the startup/teardown callbacks are modifying acomp_ctx resources for a
> > dysfunctional CPU.
>=20
> IIUC, outside the context of CPU onlining, CPU hotplug callbacks get
> called when they are added. In this case, only the newly added callbacks
> will be executed. IOW, zswap's hotplug callback should not be randomly
> getting called when irrelevant code adds hotplug callbacks. It should
> only happen during zswap pool initialization or CPU onlining.
>=20
> Please correct me if I am wrong.

Yes, this is my understanding as well.

>=20
> >
> > Now that I think about it, the only real constraint is that the acomp_c=
tx
> > resources are guaranteed to exist for a functional CPU which can run zs=
wap
> > compress/decompress.
>=20
> I believe this is already the case as I previously described, because
> the hotplug callback can only be called in two scenarios:
> - Zswap pool initialization, in which case compress/decompress
>   operations cannot run on the pool we are initializing.
> - CPU onlining, in which case compress/decompress operations cannot run
>   on the CPU we are onlining.
>=20
> Please correct me if I am wrong.

Agreed, this is my understanding too.

>=20
> >
> > I think we can simplify this as follows, and would welcome suggestions
> > to improve the proposed solution:
> >
> > 1) We dis-associate the acomp_ctx from the pool, and instead, have this
> >     be a global percpu zswap resource that gets allocated once in
> zswap_setup(),
> >     just like the zswap_entry_cache.
> > 2) The acomp_ctx resources will get allocated during zswap_setup(), usi=
ng
> >     the cpuhp_setup_state_multi callback() in zswap_setup(), that regis=
ters
> >     zswap_cpu_comp_prepare(), but no teardown callback.
> > 3) We call cpuhp_state_add_instance() for_each_possible_cpu(cpu) in
> >      zswap_setup().
> > 4) The acomp_ctx resources persist through subsequent "real CPU
> offline/online
> >      state transitions".
> > 5) zswap_[de]compress() can go ahead and lock the mutex, and use the
> >     reqs/buffers without worrying about whether these resources are
> >     initialized or still exist/are being deleted.
> > 6) "struct zswap_pool" is now de-coupled from this global percpu zswap
> >     acomp_ctx.
> > 7) To address the issue of how many reqs/buffers to allocate, there cou=
ld
> >      potentially be a memory cost for non-batching compressors, if we w=
ant
> >      to always allocate ZSWAP_MAX_BATCH_SIZE acomp_reqs and buffers.
> >      This would allow the acomp_ctx to seamlessly handle batching
> >      compressors, non-batching compressors, and transitions among the
> >      two compressor types in a pretty general manner, that relies only =
on
> >      the ZSWAP_MAX_BATCH_SIZE, which we define anyway.
> >
> >      I believe we can maximize the chances of success for the allocatio=
n of
> >      the acomp_ctx resources if this is done in zswap_setup(), but plea=
se
> >      correct me if I am wrong.
> >
> >      The added memory cost for platforms without IAA would be
> >      ~57 KB per cpu, on x86. Would this be acceptable?
>=20
> I think that's a lot of memory to waste per-CPU, and I don't see a good
> reason for it.

Yes, it appears so. Towards trying to see if a better design is possible
by de-coupling the acomp_ctx from zswap_pool:
Would this cost be acceptable if it is incurred based on a build config
option, saying CONFIG_ALLOC_ZSWAP_BATCHING_RESOURCES (default OFF)?
If this is set, we go ahead and allocate ZSWAP_MAX_BATCH_SIZE
acomp_ctx resources once, during zswap_setup(). If not, we allocate
only one req/buffer in the global percpu acomp_ctx?=20

Since we are comprehending that other compressors may want to
do batching in future, I thought a more general config option name
would be more appropriate.

>=20
> >      If not, I don't believe this simplification would be worth it, bec=
ause
> >      allocating for one req/buffer, then dynamically adding more resour=
ces
> >      if a newly selected compressor requires more resources, would run
> >      into the same race conditions and added checks as in
> >      acomp_ctx_get_cpu_lock(), which I believe, seem to be necessary
> because
> >      CPU onlining/zswap_pool creation and CPU offlining/zswap_pool
> >      deletion have the same semantics for these resources.
>=20
> Agree that using a single acomp_ctx per-CPU but making the resources
> resizable is not a win.

Yes, this makes sense: resizing is not the way to go.

>=20
> >
> >     The only other fallback solution in lieu of the proposed simplifica=
tion that
> >     I can think of is to keep the lifespan of these resources from pool=
 creation
> >     to deletion, using the CPU hotplug code. Although, it is not totall=
y clear
> >     to me if there is potential for deadlock during pool transitions, a=
s noted
> above.
>=20
> I am not sure what's the deadlock scenario you're worried about, please
> clarify.

My apologies: I was referring to triggering direct reclaim during pool crea=
tion,
which could, in theory, run into a scenario where the pool switching would
have to wait for reclaim to free up enough memory for the acomp_ctx
resources allocation: this could cause the system to hang, but not a deadlo=
ck.
This can happen even today, hence trying to see if a better design is possi=
ble.

Thanks,
Kanchana
