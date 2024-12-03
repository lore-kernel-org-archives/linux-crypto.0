Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665DE2A8D0;
	Tue,  3 Dec 2024 00:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733186086; cv=fail; b=V1TRcKUFwHDskJOrcyn5rehOM4RP4+mPhgYWPkn6K/QbYQMix9/7x8nbt2s9sM1uJ3XXGvYbDn4dQXuL6TrO9V2sksQ7HOhL/omLVNF774JWFPuLGo8Hl2MIroXA1dFi3kODiz4M4zGrW8dp7ttahZbUptN9NiDj2q5DA4uVJ1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733186086; c=relaxed/simple;
	bh=uDFX7YlxE43r8ySnE4YmE/+uKeaq2jNGb8Z56qNVMMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A4WGo1fsFOql1st4e/RCdvBIIDy6TzIJt3hBKRKbP7sg+vHddTr93iC4vY7YRssJHkAzjwN3FIw/vBYYwuJwEPi7ywT+PcJHMULn6HNz1kH6fsRVZ+DPoM9+6r93Ewcw+6vOy9g1VhYMX2Ff41xl+kXoiQOXlFhJcipb0knr2dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SV4Ahdpd; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SV4Ahdpd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733186084; x=1764722084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uDFX7YlxE43r8ySnE4YmE/+uKeaq2jNGb8Z56qNVMMo=;
  b=SV4AhdpdVx+g9h9+ogToBNzwWZwiC5B5cEttDOCEIATjwP0VjmQntWmU
   HRXobdKtSIV8QnxaYoOGJK/xpifIi50SeMq/GNBRkjPQMOL7TeChNgW5J
   UtS2D8hHrd5sYmxDM669hfAVqKJan80Xr18TXBm3lfeLPd8Qjf/Dg/CSB
   MqUP/8kW7Xq1OhovWJcq7uml1GP7M95PxWQDgIqffqkpvQT3QXAA7W+tG
   e/8KBq1oI/Kb4UFJd07k0LQgJ7MAQkthiFiIsuK0KWq5LV6uuB0Sxa9w8
   4fZFqCVF8wLr6ZTj9nr8f1RKHEv/hooiosYrR8zQinZvbrzh0vUBU3tqs
   Q==;
X-CSE-ConnectionGUID: f0YlnP+RStaA2hfoPY0oSw==
X-CSE-MsgGUID: B6gIzYU2TL2KhPSeeRlOnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="33298693"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="33298693"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 16:34:43 -0800
X-CSE-ConnectionGUID: si/ihgbpRBadej42qWMPdQ==
X-CSE-MsgGUID: fb/xUynCQXGGvz8XPydyDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="94099505"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Dec 2024 16:34:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Dec 2024 16:34:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Dec 2024 16:34:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Dec 2024 16:34:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xaUHh0gm5U5hAWY/hQeWJCWfxQPLTlzw1iZMFHMHfLUcz/CFY8656YdCYPkIUpIbPcVgTHqjtbrooF8U+ao4R/KouSSwbSdFrr9ui45m2V9TdHJRmFmkU1CrUWdToTIgDnM8c7kzRw8ItKG8OZKswqCibeY1nTYEFxIjF6nQchi+BsgejZVxjTrEch2/w066aLwX0AMNSdpVBoT4ASEbVsmMb+MIYXRF7w6pLnA7qJC5BHFbX0eS+8/tuVqKiJ1f3yf2tDLJ4ZjVmfZkehhj28GOaauh83bcHHKU+5o+zuFV+UfaXXhUKTZu+CUnlUvRPc+jM5uYscrtw6ryMwWa8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDFX7YlxE43r8ySnE4YmE/+uKeaq2jNGb8Z56qNVMMo=;
 b=BLa6ch8IG16PM7qIqWjtbeOBMuaof3iD1dkxPdOv+HqtqabUhdmyTNd5SY4atJHjdBLklf6tUELD8+fDKukxtxzqosGAFL24Z+aNty8LdI/qH+H1aJAaGld8FJBOYXyFXa006zf5VUMFgtaThRAUYQKk3DcHBivTMtO/LMjAQRPSYPzzPWe4fyYm4fX+cdVyClSFFrpMb18004X28jL4/+Izbj58aGqw9POc8MEoNa1DjCFUfU2gh/L1NGV7rxUWKXZMeUNoovu2Dm2obw5qq/CulqMxGpgZ6ngjLZYMEOGHPpaJzyp4R4vh41lRVBEFSgaHd6BjY/TwWalV4iI92g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by IA1PR11MB6098.namprd11.prod.outlook.com (2603:10b6:208:3d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Tue, 3 Dec
 2024 00:34:39 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 00:34:39 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: Yosry Ahmed <yosryahmed@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
Thread-Topic: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
Thread-Index: AQHbPXWUS2iyYzBoDUSzDIhBAfreMbLIc+SAgAARoGCACt/aAIAAVN0w
Date: Tue, 3 Dec 2024 00:34:39 +0000
Message-ID: <SJ0PR11MB56783DEAC645679D5637EC47C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-11-kanchana.p.sridhar@intel.com>
 <CAJD7tkb0WyLD3hxQ5fHWHogyW5g+eF+GrR15r0PjK9YbFO3szg@mail.gmail.com>
 <SJ0PR11MB56782CF74C6D6904DDDDAB95C92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAKEwX=Ppn-CKPNUJUMc48sU5uxkB6KS1HwFpvpty0nj+wL6rHg@mail.gmail.com>
In-Reply-To: <CAKEwX=Ppn-CKPNUJUMc48sU5uxkB6KS1HwFpvpty0nj+wL6rHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|IA1PR11MB6098:EE_
x-ms-office365-filtering-correlation-id: eceffb43-1293-4974-0ecc-08dd133245a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WTIzV1B3N0JyNFdNUVBFMEl4a1RQZ1dRbVZSajdjNlZGQ3RvK3loYkRMdzlH?=
 =?utf-8?B?K2cwT0pLb2VUMXEvYUY3aDZEcG1xZzQzZStOUWJoNjRUSHgyTjVyaG9uOUlV?=
 =?utf-8?B?NmtwSFZuU3R5aDllci8yMFZ5MGhWcnRvV0ZrdUZHMHBtTUVTdDVjNVl1OXRW?=
 =?utf-8?B?UFBRdzR0bTZOay9QRHB1M3VERTJlbkpJWU9sZi9BU2hlQmdvdmVhOXlqcWpl?=
 =?utf-8?B?VDVkMUJSTTJXRXNydGhXZURaVVhiVlloZ0RBTzFBUWppYkwzc0ZKNGR5ZUF0?=
 =?utf-8?B?ZysybmNBMHMwTWlUZWVtNnN2Q0szK3dEY09nd3IreGJCSm5XdUdQTlpkTWUv?=
 =?utf-8?B?UlFvY1ZiUUFJSzlwd0YyajBZZURRaWhZUldPNWI2UGFwQklUZGhPMHNYbWVi?=
 =?utf-8?B?cjRobGRFckNJQldzYjQ4TlpnQ0lrM1A3WFRLNW9BS2FmVE5vMFhhQ21kR1FJ?=
 =?utf-8?B?bTF5QnduM1ljZGNMN0hsYnFpZUdqUkFrRFRUQmxwL1JlaUZkclBVeTEwSHd4?=
 =?utf-8?B?a0pHVGR5WC81VUpwaFRpR2lEWHZEL09hUkJhYkZkSW1rSFh4aHp4T2x0M0lj?=
 =?utf-8?B?MUlwQlRjY1pFT29ZRkptemRMVFFJcUlZK0ZDMmt3QURveGo1UUNKZVhoM1hX?=
 =?utf-8?B?eTZVYmNsNVNFa1gwMXF4enJMYUhza05IKzRHUTFYVVN2Wjc2VUFYNG9YRVQ5?=
 =?utf-8?B?M3YvYW5ieU1tc1NmZFRLZW51Sm85SG0zM2FoWFpPUDdRZFpsVThzNGZBWWdZ?=
 =?utf-8?B?cFFoeHZGMU5tYTRXYjRwdWtMVm5CMnJRbG52V1dQaURTQXhLSCtJT2VJcGly?=
 =?utf-8?B?TkhkR1RueVE5b3FWY1lyM1BacXJ3RjRQZVh4S21ibmUzeEU0L3d5cGNIT3Jp?=
 =?utf-8?B?WjNLNVV0WmVlUW5IMHU4SjNibUZQWG1vQk1aOWVIUEoyaDUxTWZ0QnNZYWx3?=
 =?utf-8?B?MlZ3TGpnc0VEVWs5bEpKbU56d2xLdENUUnZsdHExQjlvRVVEMThwQVdzaEMx?=
 =?utf-8?B?Q2c4QUxPZDF5eklXNVFCaFBhMHlRRlBwcndxRStuQVZSY2Z5NkhPSXFiMFMv?=
 =?utf-8?B?Rjh2L1Rla1YwMTJlc1I4clRJNlFPdzdRcis0OEVWbHNKaUhtWEZqL20zZnhQ?=
 =?utf-8?B?U1NmREJRRUdBZitDMU9NM3pETUp5SUNZVmhMVlpDeTFSaWYwVWhHeDV1NVVm?=
 =?utf-8?B?K2dORHJidytFNThBd0VRZjBFdS9GRnhMcGVXOHd2U0pvUThTZHU5VXAwZ3h4?=
 =?utf-8?B?c1hvTEk5UnliRkVZL01GR3Z1a2ViclBGK1YvN0tYdVRSdmpjM0RhdFBMV2xX?=
 =?utf-8?B?VHprajViRnVaWTFab2dnMU53cEdjTk9OWk4xSUFFaktKLzcrZDdjNmJ0WUFZ?=
 =?utf-8?B?Y3o5b3FnTkdyQ2xkRnQwMEFuZEJpc3dvKzMvNEkwOUp3WUI3ZXo4MFdZa1BS?=
 =?utf-8?B?UWhQbG1MZjFreEJZRVBXZzB4RGE1M0ltK0pFYTdjM2FCdS9LWVlBNkt2cnN0?=
 =?utf-8?B?dlI2dThZUmpONk5IaDNzV3hQM2JDdmNEV3dFMnlUUzZMc1A2T3JFdi9abHh5?=
 =?utf-8?B?QTNtS29YK3k2eWkvcTFONmlRRFZla25leUNFUkhUWHRaMkcwMXd2NE9mV2NM?=
 =?utf-8?B?ZFFJYm5sMVRUbm9CRUlldU1Uczk4L3N6eFNlQUV2Q1djaW84QUlGY0h5QzRX?=
 =?utf-8?B?ZjkwbC9lWlk3Mm1lZ2dLazVHN3gwVnRjT0RYMmFxL0R0THlpbEd1SW41REpT?=
 =?utf-8?B?S05Sc3ZuaGxKWmhNdWpUMnNZYXNraGVZeDBHc3gzSTdxLy9DbnQ5clZTVWFH?=
 =?utf-8?B?SXdHSlV2V0JzSXc5NVNObnN0cCtJMWNBSSs2a0JMMlhpTUlhV09uMkxHbU54?=
 =?utf-8?B?N3JFek5TUmFUdTVSQm5tV0N5dFU0bkxuSkZqT2YxQTFGTVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aElaVWlzdXNNdm9WSnFqdEtBU3kvU3orNGFYMXZwNmc4S2pSZUZNRDNDdmVr?=
 =?utf-8?B?cmphUEZnWjBnOUtvb2FTdDdueVd1enNqTHVQUThkOEQ3aFJVU1JDNWRXLzhs?=
 =?utf-8?B?bE9HM3kxN0ZlUG5nNHptZm91aThydDVpMVI4Mkw1RmtGZXpsYkdtYnM2S1Nj?=
 =?utf-8?B?RDd1VWRxTkhkWGM4Rm5lWnFLQkFZclNUUVgrZVEvYVYxL2dBL2Q4TFd2WG9L?=
 =?utf-8?B?Y1RseUJUc3BKMG9IL3dSUGRENnh2SVpRdVpROG5uZ2pnTUUrNU1BbHhFVDFw?=
 =?utf-8?B?Z2lWdjA4bjhHYzd6eHAyY0Rib1U2Znp2L2hmaTlhUFdZcFI2VTkvSzBscm9t?=
 =?utf-8?B?R3ZiNHQ5VXZTZnF0MXNxMUZLK3F2RSsyQy9rdHBMOVRmNmdUSm9NSWhDbnFM?=
 =?utf-8?B?SEp1WkVyd3NqL1dXeTNHL1Q5QTlDWGI5VDN6OUZ5MWtNRitSL211c1A4RWpB?=
 =?utf-8?B?dWhhNURUK2ZYVldEdTlVYjN0TWpZSU52U1JxYThNbXpUSnhneWk0aGp3VkZZ?=
 =?utf-8?B?elFpTGs4S2pwR2s2c0tRSFZLeTFpQTNSZTA2dWpqWW8ya1NFaWRtNXlUQWVF?=
 =?utf-8?B?RDUyVzYwWDhNVGd0M1p2ZHdDbVNLcyt2Y2N0Ym1YZ2JUdG5aZlJNd1o5VS9a?=
 =?utf-8?B?RGFST2hXc2haRkpXQys3Kys4MVZMUW40S29QQ1FiL2tWdlRua0V0Yk5CNSs2?=
 =?utf-8?B?QWgweWdTWFdJU2o3cDU2dVptZXJ2TVFaYWNqMTJuUzlGQkUvS1RTUTJFeXFG?=
 =?utf-8?B?cDV3WE5ISkZRcFNpTEhEZGJnSHNuMm1DajRQN0hvaTloUFZhSDZuam1ZcVRL?=
 =?utf-8?B?ZVJ6d0J4c0ZCeDFVV2VFNlRBUEJCT3FyQ2NmQVhrMXFHelJnOFRZYmZKeW1O?=
 =?utf-8?B?bmsvbmNmdkcxeDRLdDNXSzVKdkhjODdQbDFYelB4S1JVYlRmZXlJbjhSNTNF?=
 =?utf-8?B?eWVjeFE5VUhSM0hrYkFML0Ura2hmYjF4NVY4WG4rSmJIZ3o5UzRuTzdmT0xK?=
 =?utf-8?B?TmZWTmF4NUJEZENNOWI3MzBBL0x2SkFPWE53VGE3YXMydFhRSExWekIzL3Iw?=
 =?utf-8?B?dlNDSW1lazFURDV1NlRxZDF4WElRUE9QT3p1S2Q2eUtkbVFwSWZZMEJsdXhz?=
 =?utf-8?B?TUVhamorRGkydTlnRE9zUksxZ2pQS0pDaFBnZTQyNVQyRlc3bkUrTmNYYzRp?=
 =?utf-8?B?TStYVHJLa2lUMzRkbEZQaDhENURaQUZmRlhRS2dhN0E1cUk0L0ltbG1WcWZC?=
 =?utf-8?B?c243a3UvRUpOYXNkYU8vOUxBWjk1TDNWMTVOL3NqWXN1OTlaN0JXOXhiUlc1?=
 =?utf-8?B?Q25qUnFjWjlVeEJ4LzkvbFhzdHZmOVVSMzZRbHpIaUlGbThXS2diMVJEb29o?=
 =?utf-8?B?QWYxWmVpdTJkcEhTOGVlRStpZ2wrUnFHWnF2QTkwempYOXB6SGsyeEFieE1R?=
 =?utf-8?B?YkJ6N3NOQXptQU5nWGxnOTUyVTZJY3RBenluUEhBOG0xVHgrekpiME9lSVZH?=
 =?utf-8?B?QkRGSVJ1N0xqT2tBd1c4Z2NlRit5S29QVER3T3BvQmZlVGxrTG5nTVJUUGor?=
 =?utf-8?B?RSsyMjVuV0lmZ3JFamxiVytnSTJERlZzamszN04xeGRHMlRNSkhqSksrUS9K?=
 =?utf-8?B?SExnd1llYWtyaitQaU9rY2hCa0V0dGNoRGxualhxTElmSDZqbjVDczd5dUti?=
 =?utf-8?B?TmtUckxRU1RzUWVCNmRZOTRUNFB2RmljWU9zUkFBZFUraWZ1dTRzTzBkWkpZ?=
 =?utf-8?B?bEpnbzllcER5ZGZzOUI5U2l4cjl3U0xzVXpBaUUzWnJ2eGtSeHdDWnVrK1I1?=
 =?utf-8?B?bTFNYldDem1oSHRrTHpoRTIza3o0b1I2cTBPZ29FVmV4aG1nc2tibUQ1VjdF?=
 =?utf-8?B?ZGF4cm9lTjdlbTBrdHhRbmtWRlJzZDkvNHhRaDhVckFIVUNCUlhzUDRZMW1o?=
 =?utf-8?B?WDRhT2NwbVUzb0ppc0NMYUJZT2U5ZXFKTE8zR1BwdzI5Y09Yem5WbzA1bUY4?=
 =?utf-8?B?N25SSGpHaFNEMGlDV1R2OVFjbHl6ZmQ2MHloN05VQmgxUzZvakZmZnRpYmdS?=
 =?utf-8?B?S2E1SU1TVW1JMVVsc1AwMGk5Q3BQZU43YTdNR2FBbUVUU1dYZStlNUdSVFBa?=
 =?utf-8?B?TmZNVFRlSlJXVnZKVitJaDBzNDkycWo4WU5sMGlqTFRYNXExSnlYVGp5ZmlS?=
 =?utf-8?B?cjVBQzNmWTBma01aTGJ6MUJwYTBDMTFjQmZMSmxueDkzZUJkaUI4dGR3K085?=
 =?utf-8?B?Q1EwSEtoUm9oR241NjVBaEFFV3ZRPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eceffb43-1293-4974-0ecc-08dd133245a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 00:34:39.4016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8cFRuhHyBjQZ4VKrWxRvTZSJsAlFTEg4+hRbOODezLLjMmfddRZnJOZS4x3U0qk2L15eAalyKemkFoxhTxqHOOPlCNjQcmfh3KMAEi4ar9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6098
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgRGVjZW1iZXIgMiwgMjAyNCAxMToyNyBBTQ0K
PiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4N
Cj4gQ2M6IFlvc3J5IEFobWVkIDx5b3NyeWFobWVkQGdvb2dsZS5jb20+OyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1tbUBrdmFjay5vcmc7IGhhbm5lc0BjbXB4Y2hnLm9y
ZzsgY2hlbmdtaW5nLnpob3VAbGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyBy
eWFuLnJvYmVydHNAYXJtLmNvbTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IGFrcG1AbGludXgtZm91
bmRhdGlvbi5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGhlcmJlcnRAZ29u
ZG9yLmFwYW5hLm9yZy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gY2xhYmJlQGJheWxpYnJl
LmNvbTsgYXJkYkBrZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOw0KPiBzdXJlbmJAZ29v
Z2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+
Ow0KPiBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWws
IFZpbm9kaA0KPiA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SCB2NCAxMC8xMF0gbW06IHpzd2FwOiBDb21wcmVzcyBiYXRjaGluZyB3aXRoIEludGVsIElBQQ0K
PiBpbiB6c3dhcF9iYXRjaF9zdG9yZSgpIG9mIGxhcmdlIGZvbGlvcy4NCj4gDQo+IE9uIE1vbiwg
Tm92IDI1LCAyMDI0IGF0IDE6NTTigK9QTSBTcmlkaGFyLCBLYW5jaGFuYSBQDQo+IDxrYW5jaGFu
YS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoZXJlIGFyZSBzb21lIG1p
bmltYWwgImZ1dHVyZS1wcm9vZmluZyIgZGV0YWlscyBzdWNoIGFzOg0KPiANCj4gSSBkb24ndCB0
aGluayB0aGV5J3JlIG1pbmltYWwgOikNCg0KU3VyZS4gRGVwcmVjYXRlZCA6KSwgYW5kIHN1Z2dl
c3Rpb25zIGJlaW5nIHB1cnN1ZWQgaW4gWzFdIHdpdGggdGhlIGdvYWwgb2YNCmludGVyY2VwdGlu
ZyB3aXRoIGEgdjUgb2YgdGhpcyBzZXJpZXMuDQoNClsxXTogaHR0cHM6Ly9wYXRjaHdvcmsua2Vy
bmVsLm9yZy9wcm9qZWN0L2xpbnV4LW1tL2xpc3QvP3Nlcmllcz05MTI5MzcNCg0KPiANCj4gPg0K
PiA+IDEpIFRoZSBmb2xpb19iYXRjaDogVGhpcyBpcyB0aGUgbW9zdCBjb250ZW50aW91cywgSSBi
ZWxpZXZlLCBiZWNhdXNlIGl0DQo+ID4gICAgICBpcyBhaW1lZCB0b3dhcmQgZXZvbHZpbmcgdGhl
IHpzd2FwX2JhdGNoX3N0b3JlKCkgaW50ZXJmYWNlIGZvcg0KPiA+ICAgICAgcmVjbGFpbSBiYXRj
aGluZywgd2hpbGUgYWxsb3dpbmcgdGhlIGZvbGlvLWVycm9yIGFzc29jaWF0aW9uIGZvciB0aGUN
Cj4gPiAgICAgIHBhcnRpYWwgYmVuZWZpdHMgcHJvdmlkZWQgYnkgKDIpLiBBcyBtZW50aW9uZWQg
ZWFybGllciwgSSBjYW4gZGVsZXRlIHRoaXMNCj4gPiAgICAgIGluIHRoZSBuZXh0IHJldiBpZiB0
aGUgbWFpbnRhaW5lcnMgZmVlbCBzdHJvbmdseSBhYm91dCB0aGlzLg0KPiANCj4gTGV0J3MgZGVs
ZXRlIGl0LCBhbmQgZm9jdXMgb24gdGhlIGxvdyBoYW5naW5nIGZydWl0IChsYXJnZSBmb2xpbyB6
c3dhcCBzdG9yaW5nKS4NCg0KU3VyZS4NCg0KPiANCj4gPiAyKSBpbnQqIGVycm9yIHNpZ25hdHVy
ZTogYmVuZWZpdCBjYW4gYmUgcmVhbGl6ZWQgdG9kYXkgZHVlIHRvIHRoZSBsYXRlbmN5DQo+ID4g
ICAgIG9wdGltaXphdGlvbiBpdCBlbmFibGVzIGZyb20gZGV0ZWN0aW5nIGVycm9ycyBlYXJseSwg
bG9jYWxpemVkIGNsZWFudXAsDQo+ID4gICAgIHByZXZlbnRpbmcgdW53aW5kaW5nIHN0YXRlLiBU
aGF0IHNhaWQsIHRoZSBzYW1lIGJlbmVmaXRzIGNhbiBiZSByZWFsaXplZA0KPiA+ICAgICB3aXRo
b3V0IG1ha2luZyBpdCBhIHBhcnQgb2YgdGhlIGludGVyZmFjZS4NCj4gDQo+IFRoaXMgY2FuIGJl
IGRvbmUgaW4gYSBzZXBhcmF0ZSBwYXRjaC9mb2xsb3cgdXAuIEl0J3Mgbm90IHJlbGF0ZWQgdG8g
dGhpcyB3b3JrIDopDQoNCkFncmVlZC4gU2ltcGxlciBhcHByb2FjaCB3aXRoIGNvbnNvbGlkYXRl
ZCBiYXRjaGluZy9ub24tYmF0Y2hpbmcgY29kZSBwYXRocw0KYmVpbmcgcHVyc3VlZCBpbiBbMV0u
DQoNClRoYW5rcywNCkthbmNoYW5hDQo=
