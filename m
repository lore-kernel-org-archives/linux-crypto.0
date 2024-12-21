Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998625948C;
	Sat, 21 Dec 2024 06:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762677; cv=fail; b=OUb4fla/8UHId1kn/RgAyyZmuyAzqDG+xBqyP0oAppcqA4tt2hJbngx3xnj8FP3hsGhO+rsQDwHnc85UlDHCwHbOmTwxoWMtHyfqPsfGzgmEKLFPuUu/ruw8W3+7w286caX9XRKfeuFdt2YBxdFya9lCBLJRb1V2SwF8faLQbOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762677; c=relaxed/simple;
	bh=Ery+G3r9SSe4p0uJHlm4t2KN0aDeez4qP/DB96Ge1DA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nJOCBhJPaO9VKa5DL01V3QdPHASoq+WGkwC+kzIv6CITgd6ycQzwIGvGIuVPC1nCe9z5F1eppzJRhPbGXfGRPm6zIo1No7hFvSkjTHSh1ZXJXV4ElVTsdcVAnVY2SNm0tChD5WqIVMFKBIOz1hSB3Si4iyAVqFAS2hxA+gMQOhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ho5vRJgV; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ho5vRJgV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762676; x=1766298676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ery+G3r9SSe4p0uJHlm4t2KN0aDeez4qP/DB96Ge1DA=;
  b=ho5vRJgVmZ9brsslXAoY+cbTtqD1YSSVUyThoSDcRMNJtfnu28cjAkrF
   l3Y9k+rcbRs248r1/CGqbf0FavjfDg9P9UoUrbSlhIsyClQgC6EqtuaHC
   ihhVCOObMAcgtVl+joUsm0bqrsHiza7Ivge1MZ6/Feoyc3NPGNC4LXTNe
   k8rVtpDtYs5TOSmrvzqMNekCUQ5gaaJsjH1GrXZORgkuQ0WkZa4uOyNhL
   Je6kvP3X7g4icdhB8d3MnansDSocmMQd/P0Pd4QM9THkFtY644DP7NUrP
   hNFxJRzxTuqS68+CRBHyfzQ6LO4mXqxqB6+Ap5Nt8Pzj6HynKW9XZjirT
   w==;
X-CSE-ConnectionGUID: sVhJ1K3KRiedD3FbaejDuQ==
X-CSE-MsgGUID: dJ5d6YfsQHCgi0ImRTm1iQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="46691278"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="46691278"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:15 -0800
X-CSE-ConnectionGUID: ZIEbgJMASjGaO7nGfv5pug==
X-CSE-MsgGUID: SLqqEfqzSimdsQFiqImQTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102819463"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Dec 2024 22:31:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 20 Dec 2024 22:31:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 20 Dec 2024 22:31:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 20 Dec 2024 22:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5XOtso/K1toJExkcYNMbXJakqBxyS4mN1s/WTkD/brsmLzq2auJUg6ToCfNYWpCQ//ER5SLyHD2u/SiBPr0rnso2DU4YdHXQBk+MmhQzzID+7PglOQK2jXEe6MLXfNgsCYje3LxcbMMRdvOgGkUZfZa+kbzLj4XuZJxxLdwxI8MgO+BNV+HV9ZupcTxoVnFGktYvAPT07vWWlr6/fS5oEoY0Tl/in7UUxBe64qAyMU4lsdq11fZYsg60a4NVdYQ3kDtVVm7CbwuPrP3zWU/d9ftj04hAR0c2byKLa66CZ75M+GhBjd0CFchi3nzZPEPPoyZnLgzW34ezDld00NUXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ery+G3r9SSe4p0uJHlm4t2KN0aDeez4qP/DB96Ge1DA=;
 b=rsZmkJKtM1iMYZK0IoPOJKjPbEwQsJA+JdI4Vea0rWm2l4HMA+ZE31VwniKHiu/n8dckr2TP/0NXMMwbSRQMAj0TpOq0GVa50fjRdbrbeF0vAnixRD1lmsq4ySKjf1Fe9DUkg3TE6EC9wKsboiE7DChlfYsAokHiTX2y4Wa3noFgrcTj0YgapYbFryrWF+rjbdYBVZwI9sBtoeLla8dJ+/Yz6zjLYMF+krnOZwqW1nE1/UjwSVVNPF5SynATiwf+4IpidLypFbOfo5/KVXD4Wm1SC5Rs+88pB73dOkXiCdTM1xDVr7VRvrXGJdADKVV7e91F5q+fTXBR8yHvZlQZoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CH3PR11MB7204.namprd11.prod.outlook.com (2603:10b6:610:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.16; Sat, 21 Dec
 2024 06:31:02 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8272.013; Sat, 21 Dec 2024
 06:30:56 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "ying.huang@intel.com" <ying.huang@intel.com>,
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
Subject: RE: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Topic: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaCAHLpC0A==
Date: Sat, 21 Dec 2024 06:30:56 +0000
Message-ID: <SJ0PR11MB567876E4639F4075C9546981C9002@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CH3PR11MB7204:EE_
x-ms-office365-filtering-correlation-id: 6707740f-a078-47ca-b352-08dd2189069c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y0RlY1dvVUhMMWV4TGtWSC8vdDM0WlVZTEdPdnkzanhYUmZaRHFZRVR0MkpS?=
 =?utf-8?B?LzB2c29pZkF0WnYzM25WVWFiRXBqeFJnb0wzOWpYLzRmNDEydnFab3BuUmRP?=
 =?utf-8?B?WksrMUw4cGo1T2UrWm1kSnUrWmxzRGVZSEx2SFY1N2hpOCtBUTZDdUR1Uytn?=
 =?utf-8?B?Zm82dVgvaC85Y2Zqa3Zsd1d1TmhWVzZnMGYwSHdxck1wYWxVVHR2OGJDTjhH?=
 =?utf-8?B?bEdaSjVzNWs0TUpwdDYwa2xQUCtqUHVOSldVeHVvT253TGR6cFoxNEN2RkN1?=
 =?utf-8?B?OWFkUTJvK1BnU256MkhTcEg4MW81eTJHN3EvVmFWWCtsYjNrRjhWTnVwWUww?=
 =?utf-8?B?ejNwV25BODNFQ0I1bGgzR0NjTDR5OUg0TnZRa0YyWWRvRTQyalNURThOaFpa?=
 =?utf-8?B?YmRnS3ZnNFh4T1h1VGt6d0JUVDRvbjVEY0lzMkJVKzk0OVFFcVdhaitqMkQ0?=
 =?utf-8?B?V1Z1YTdtSXlVUm1CTExYWjZyQVgvMU14NkZGZm5LQXdPZ2JPSEh5QUZ4dVp5?=
 =?utf-8?B?blpKRWs0RFhHckRxN3lMaGI1SmVlMU03MjhydU15QUtqVTZSeFQ3Uk5ENjZD?=
 =?utf-8?B?ZjgvcDViN1ZaQ0tMVVNadTFlRmJLV2FUcDNLbFdiL3dISFBnOHdvK3MvMmFE?=
 =?utf-8?B?dDF4TzNGQlJKMitEQkQ2ZTlEWCtLZEMzQWNRODUxbml4UWpEMm5pamZqWWRy?=
 =?utf-8?B?S3NKY0lrODRZcDhBNXVQYjNvRFRUbGg3NVE1TkdxNWpvZ1o5Q3lCdlNlWk5Z?=
 =?utf-8?B?L0VFcVZIY2Y0RGlrb2Y3UmVVbVMzejl0aXJOK1RkT29lUVVzVUdic2dzM3FU?=
 =?utf-8?B?dzgxR3ZEaXBsdmZIN3ZkSndIVlpXRWFrM0lIWmNGS09IL05NbVo5cHlqSkZ0?=
 =?utf-8?B?QUVLcVcyRXNnNTdtZ2MzNmhITVVNeWV2MjRGRDkyTk5sdEhhcnZoWmVVdXFh?=
 =?utf-8?B?bCtoYXhERHBSZU1zVmM2dTR2d3I1T3QzVmViazhTUC91S0hLQ0pPdkJmWmpy?=
 =?utf-8?B?NjJwTG4wMStOa0xjYVFORGRJc0gyREFTOHFTYXRnTDZ1cEtHbnorQTAvQm5q?=
 =?utf-8?B?ZkZWTlhzSTMzQmRRVW51d1N0b2EvNDRNQ3ZYTDFEL29zUXBTdWtpZmYxNith?=
 =?utf-8?B?WnNYTFN0a0VER0lEZWV3c0tkL2dndFNJSDdwWEE3cE1PL2RMa2VVdXc3RFBR?=
 =?utf-8?B?VEpqRE0xckFxSW42N1ErdVNIYk5kR2xnQzdoYUFvdTR5bFZ5VGZHRlhxSTdM?=
 =?utf-8?B?MzZ3eUtweDNiY3F6bmIvdmx0eHM5bUZ2RUdGN0M1cW8vdWYxcGxWU01SMjQ0?=
 =?utf-8?B?SjA2ZEVsZEJBTVpIKzBzZ0U2SGtlRGxLYk5OT1lKdUUvMTYvS3dBcUpyTXVZ?=
 =?utf-8?B?OWtLUXdSZnZ1MWlmcjliMThMWDZWTkV5TC84dnNhd3JNb0dPckJucGdPd2JN?=
 =?utf-8?B?NXkwTUh3NzJFYmM5aUM1NVhVbDlydVZ0UEV3WUZCWDVheC9qai9UZ28xdkNl?=
 =?utf-8?B?enA5QVN6MzNHQWtjN01lRkxROExtVzFNN2laVEYxbm9hcUVyNlFPTWlNVTFB?=
 =?utf-8?B?QjhEamhhRzBMOW5RSkJsaHBhaWMrakppd1pEMkc5dWo4TTc1cCtBUjllSnYx?=
 =?utf-8?B?MzN0U3ZEdEg1a0FudDdjV2V2dUZTVmVZekkrbVZMMS9vVjJSeG9NcG40QUNv?=
 =?utf-8?B?V2RYQWs5aHFCN3F0Y2tEZEpPSUxHaVBmYnMxUjR1ZkREMnJycytNR0NWSGVQ?=
 =?utf-8?B?azg5L3ZBbXZaMklKT29STEpERGRVNFhCTHN3YXBMMnlPeWlqYyt1YnlmUTBD?=
 =?utf-8?B?TGdHdHdMVU1yazlNUFJFRkFmYkhaeENMdCtVWVI4SkFZcVZEMlhDV3QyajR2?=
 =?utf-8?B?MXV1ZHZYZVllSyszQ3hXbFJOQmdtQlVXRlNyTDBOWFhtYi9kYmlaUG8rTFRi?=
 =?utf-8?Q?2UIkxmNy77Fh3L0xYE5npcW1GB/3F8Nl?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFBZRmc0L0pHd0lQNGRJVll6S1c4TU9FcmhmMmhVa3g0aGY5YjlOTXlCUzVq?=
 =?utf-8?B?UXlYSDgyWHI5a3hMRUE5YXF3WmRHQTNTUFVPTW05WnNlTldERlBqS3Bwd0pR?=
 =?utf-8?B?OHZvOEU2VmV1WElGQWp5Q25CMjdXOW5NWStRemo1dHQ4NllDOVpVSDd5L3BI?=
 =?utf-8?B?a1VwV010aDN1Ky9RMFM4cWQ4Unl2SHFBOUlVS01hTllSVFNJUTFEaXhSZUlQ?=
 =?utf-8?B?blhLTkVhcy8vcnVxUzZzSnRjNHpIVWdCMTVkU0ZvbEc3Tk1lRURPQkxmdmlT?=
 =?utf-8?B?TFhyZ0I0aDlmdXZUa0JjeEk4SCtYTzMxVUhCTnVUNjVCSHRqdTR1QUtzK29q?=
 =?utf-8?B?ZGNiN25UeExyTGNiZzhGYWxoV3lMM2dnK3g4OUtXdXo2MUI3STRVM1dUYk1U?=
 =?utf-8?B?cVdGSUVxaDZHR2h4MmpoV3Fab0FId01qTVA0QWF3TGNjSitzeG9oTWFKdEVG?=
 =?utf-8?B?ZWh3OXVvaUZjMEZiZ1MvQ2YwY08vbzBkb001OXJ3TFcyME01WEFVZ3lwRUJQ?=
 =?utf-8?B?QjZZQjA5bnNPblo0RlhFK2V1MXdEZ090SHQyN2k5Q00ySjBpTzRXYk5ncisy?=
 =?utf-8?B?MXk4cTMxd1FoN1FtQXFrakhkV2xYYXlNVnpCeFp2SDF2OTNwOFdsemZ3d1Nz?=
 =?utf-8?B?MTlWRHJ3R3dZTVlIZXlSUmFia25KTTM2RGFBUml0VnJZaVlSQ1NoazRDdDU4?=
 =?utf-8?B?K3hpT0JoaitRdEJVTzZ5LzhaM1ExbXFnR1hjUFEvbkJBWmhMUnFIdGJ6cm1S?=
 =?utf-8?B?Y0RBc1hKN1VVbWQyMFozT1JWTDNadWMrK3A2L2ZzbnJrcUFzV1hERmprUm5L?=
 =?utf-8?B?S2JXamdPblFISUdwWVdiWmQ5Z3M3VXBzUEtVWWtScEJzdytpMmMyWjFTSFV3?=
 =?utf-8?B?alpyZTNaMXVmdlN3YndHV1RlWHJsZXJKOUFjTDFpUEhvc1lQUjhHVmcyM3pi?=
 =?utf-8?B?UUF1SXRlNFVkSzdjQWZhVGNSVG1tQ1hMQzBMcThHdEwwdVRlbEMzSXJGVDFa?=
 =?utf-8?B?OVovNWdGUXBUejY2OG13WEdnM3FUME42RzZXNmdPZXNEeXVKeUZKYVhDMUlB?=
 =?utf-8?B?c2dUem1xdVFsRkhpaE8zaWVjWTlNMmZqRFd5REROeklsblF4Ykd6TzFhL205?=
 =?utf-8?B?MzRaWmNQbzdxeG53aE9qOU4zcTdVTUFCYzNzamgyeWVBUHBCbm5iTEh0RnpJ?=
 =?utf-8?B?Zm1NTk9Hck05Sm5MR0xpcWR1U0ViQ3NES25tV3duSHdvRTlTa2J5Vm84aWxo?=
 =?utf-8?B?eGVCeEpxaVJPMk5abzRQNHRsT0lCU0ZMRjdOcEhZV0hyeDAyQ1BVbWI3YlZa?=
 =?utf-8?B?Z1g0RlVyemZjZUpZblpkLy80QTVaZ1pQeEhqbUVIVXZVM2RlNVBER210azBD?=
 =?utf-8?B?d3MwZVE3akRuTU5NeTRxc25Vb08vdmgzVkcxQ2xONVZTUldPRnM2Zm9yb1JD?=
 =?utf-8?B?bVUyZlVNV29jWmNmMlE1bmhHMG9JVHBUQmxBT2Z4Y0t0blJ5L3lLMzJPNC9i?=
 =?utf-8?B?Zlc2ZG5zT0tpOXNBcjFiaEJLMjNlYTVnSXdwdW9qMHg4ZmRmNThIMktLcytX?=
 =?utf-8?B?cytKc250YjhlaTlqZlhhRjZSOVV5cVRZaks5bWcyM1dFMFUrblFZVFp0RGxZ?=
 =?utf-8?B?UEVaSUJpTHF0aFAzdDR3dm8wUHZLV1hweU94b2MvSlZLQm5KMWQ4eVhUZVY3?=
 =?utf-8?B?Vjh5RmorTXNVOTUwWVNkVWd1QlBVRElqbHkyZXFYdEk3b3pPZHBVaDhldXVp?=
 =?utf-8?B?MWE0dzdHaFBhbUxsalBoMi8wUGhPeTBCNHRyWjVtMlF0VlR2M1gva1FHVzZw?=
 =?utf-8?B?UGVXRFptckYrbjJ3ak5XMi9UamorOGR3bzNyd0ZFT0hYQ1h4bmE4dXhPRVJB?=
 =?utf-8?B?bjdkU0c2Ym1MZWxGUlhNZXJaNmptZmtTR0xJL1IvL3BMNHhLd1lnZUZ4S2xW?=
 =?utf-8?B?eDRWOEJRMFhJMi9qcW1PdkMwKy83ZVZPa2pRTitnbDNrVmxpRmlrc01kc0Fn?=
 =?utf-8?B?Z013NTNFWnEvdmp6VDFJc2VkUWpoU0dDemdqclEwNHppbVJQNk55cEJoVmk3?=
 =?utf-8?B?ZE40VG9IVUtCWGhJZkJTcm9DOVBBWHB2eDlaY3ZFQjlvQzFqM1I5L1R2Vk1V?=
 =?utf-8?B?b2ZkWkQwdHd2V2JrMnBCYyt6R3ZkVURZVmhJK1c3ZE40eDZacWJnREo1UFo5?=
 =?utf-8?B?TFF2YlQzMkJ5c0Y5V0NOY3ZRQVU3U25wK09TRDhLc0xJWUF1amxIcVZOalhW?=
 =?utf-8?B?SnJObTNBdmttRlNmcUtNOE9ESktRPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6707740f-a078-47ca-b352-08dd2189069c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2024 06:30:56.1565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTfO5HqB8jCoShI/RAgCMHP1RMMYq3r+fEcMaauzYHcMfJ8uPOQUuBEtFHUitmBVcXBQO5BG0A7bKanLcHOuJn+I3igT8Kyo9+Hr1DzYWYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7204
X-OriginatorOrg: intel.com

SGkgTmhhdCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTcmlkaGFy
LCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIERlY2VtYmVyIDIsIDIwMjQgNDozMSBQTQ0KPiBUbzogTmhhdCBQaGFtIDxucGhhbWNzQGdt
YWlsLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2
YWNrLm9yZzsNCj4gaGFubmVzQGNtcHhjaGcub3JnOyB5b3NyeWFobWVkQGdvb2dsZS5jb207DQo+
IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsNCj4gcnlh
bi5yb2JlcnRzQGFybS5jb207IHlpbmcuaHVhbmdAaW50ZWwuY29tOyAyMWNuYmFvQGdtYWlsLmNv
bTsNCj4gYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVs
Lm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0
Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2ds
ZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4u
Yy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEZlZ2hhbGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFs
aUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoDQo+IDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPjsg
U3JpZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4g
U3ViamVjdDogUkU6IFtQQVRDSCB2NCAwOS8xMF0gbW06IHpzd2FwOiBBbGxvY2F0ZSBwb29sIGJh
dGNoaW5nIHJlc291cmNlcyBpZg0KPiB0aGUgY3J5cHRvX2FsZyBzdXBwb3J0cyBiYXRjaGluZy4N
Cj4gDQo+IEhpIE5oYXQsDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4g
RnJvbTogTmhhdCBQaGFtIDxucGhhbWNzQGdtYWlsLmNvbT4NCj4gPiBTZW50OiBNb25kYXksIERl
Y2VtYmVyIDIsIDIwMjQgMTE6MTYgQU0NCj4gPiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2Fu
Y2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0KPiA+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9z
cnlhaG1lZEBnb29nbGUuY29tOw0KPiA+IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFh
cmlmNjQyQGdtYWlsLmNvbTsNCj4gPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0Bp
bnRlbC5jb207IDIxY25iYW9AZ21haWwuY29tOw0KPiA+IGFrcG1AbGludXgtZm91bmRhdGlvbi5v
cmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gaGVyYmVydEBnb25kb3IuYXBh
bmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+IGNsYWJiZUBiYXlsaWJyZS5jb207
IGFyZGJAa2VybmVsLm9yZzsgZWJpZ2dlcnNAZ29vZ2xlLmNvbTsNCj4gPiBzdXJlbmJAZ29vZ2xl
LmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+Ow0K
PiA+IEZlZ2hhbGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwg
Vmlub2RoDQo+ID4gPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NCAwOS8xMF0gbW06IHpzd2FwOiBBbGxvY2F0ZSBwb29sIGJhdGNoaW5nIHJlc291cmNl
cw0KPiBpZg0KPiA+IHRoZSBjcnlwdG9fYWxnIHN1cHBvcnRzIGJhdGNoaW5nLg0KPiA+DQo+ID4g
T24gRnJpLCBOb3YgMjIsIDIwMjQgYXQgMTE6MDHigK9QTSBLYW5jaGFuYSBQIFNyaWRoYXINCj4g
PiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gVGhp
cyBwYXRjaCBkb2VzIHRoZSBmb2xsb3dpbmc6DQo+ID4gPg0KPiA+ID4gMSkgTW9kaWZpZXMgdGhl
IGRlZmluaXRpb24gb2YgInN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4IiB0byByZXByZXNlbnQgYQ0K
PiA+ID4gICAgY29uZmlndXJhYmxlIG51bWJlciBvZiBhY29tcF9yZXFzIGFuZCBidWZmZXJzLiBB
ZGRzIGEgIm5yX3JlcXMiIHRvDQo+ID4gPiAgICAic3RydWN0IGNyeXB0b19hY29tcF9jdHgiIHRv
IGNvbnRhaW4gdGhlIG5yIG9mIHJlc291cmNlcyB0aGF0IHdpbGwgYmUNCj4gPiA+ICAgIGFsbG9j
YXRlZCBpbiB0aGUgY3B1IG9ubGluaW5nIGNvZGUuDQo+ID4gPg0KPiA+ID4gMikgVGhlIHpzd2Fw
X2NwdV9jb21wX3ByZXBhcmUoKSBjcHUgb25saW5pbmcgY29kZSB3aWxsIGRldGVjdCBpZiB0aGUN
Cj4gPiA+ICAgIGNyeXB0b19hY29tcCBjcmVhdGVkIGZvciB0aGUgcG9vbCAoaW4gb3RoZXIgd29y
ZHMsIHRoZSB6c3dhcA0KPiA+IGNvbXByZXNzaW9uDQo+ID4gPiAgICBhbGdvcml0aG0pIGhhcyBy
ZWdpc3RlcmVkIGFuIGltcGxlbWVudGF0aW9uIGZvciBiYXRjaF9jb21wcmVzcygpIGFuZA0KPiA+
ID4gICAgYmF0Y2hfZGVjb21wcmVzcygpLiBJZiBzbywgaXQgd2lsbCBzZXQgIm5yX3JlcXMiIHRv
DQo+ID4gPiAgICBTV0FQX0NSWVBUT19CQVRDSF9TSVpFIGFuZCBhbGxvY2F0ZSB0aGVzZSBtYW55
IHJlcXMvYnVmZmVycywgYW5kDQo+ID4gc2V0DQo+ID4gPiAgICB0aGUgYWNvbXBfY3R4LT5ucl9y
ZXFzIGFjY29yZGluZ2x5LiBJZiB0aGUgY3J5cHRvX2Fjb21wIGRvZXMgbm90DQo+ID4gc3VwcG9y
dA0KPiA+ID4gICAgYmF0Y2hpbmcsICJucl9yZXFzIiBkZWZhdWx0cyB0byAxLg0KPiA+ID4NCj4g
PiA+IDMpIEFkZHMgYSAiYm9vbCBjYW5fYmF0Y2giIHRvICJzdHJ1Y3QgenN3YXBfcG9vbCIgdGhh
dCBzdGVwICgyKSB3aWxsIHNldCB0bw0KPiA+ID4gICAgdHJ1ZSBpZiB0aGUgYmF0Y2hpbmcgQVBJ
IGFyZSBwcmVzZW50IGZvciB0aGUgY3J5cHRvX2Fjb21wLg0KPiA+DQo+ID4gV2h5IGRvIHdlIG5l
ZWQgdGhpcyAiY2FuX2JhdGNoIiBmaWVsZD8gSUlVQywgdGhpcyBjYW4gYmUgZGV0ZXJtaW5lZA0K
PiA+IGZyb20gdGhlIGNvbXByZXNzb3IgaW50ZXJuYWwgZmllbGRzIGl0c2VsZiwgbm8/DQo+ID4N
Cj4gPiBhY29tcF9oYXNfYXN5bmNfYmF0Y2hpbmcoYWNvbXApOw0KPiA+DQo+ID4gSXMgdGhpcyBq
dXN0IGZvciBjb252ZW5pZW5jZSwgb3IgaXMgdGhpcyBhY3R1YWxseSBhbiBleHBlbnNpdmUgdGhp
bmcgdG8NCj4gY29tcHV0ZT8NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBjb21tZW50cy4gVGhpcyBp
cyBhIGdvb2QgcXVlc3Rpb24uIEkgdHJpZWQgbm90IHRvIGltcGx5IHRoYXQNCj4gYmF0Y2hpbmcg
cmVzb3VyY2VzIGhhdmUgYmVlbiBhbGxvY2F0ZWQgZm9yIHRoZSBjcHUgYmFzZWQgb25seSBvbiB3
aGF0DQo+IGFjb21wX2hhc19hc3luY19iYXRjaGluZygpIHJldHVybnMuIEl0IGlzIHBvc3NpYmxl
IHRoYXQgdGhlIGNwdSBvbmxpbmluZw0KPiBjb2RlIHJhbiBpbnRvIGFuIC1FTk9NRU0gZXJyb3Ig
b24gYW55IHBhcnRpY3VsYXIgY3B1LiBJbiB0aGlzIGNhc2UsIEkgc2V0DQo+IHRoZSBwb29sLT5j
YW5fYmF0Y2ggdG8gImZhbHNlIiwgbWFpbmx5IGZvciBjb252ZW5pZW5jZSwgc28gdGhhdCB6c3dh
cA0KPiBjYW4gYmUgc29tZXdoYXQgaW5zdWxhdGVkIGZyb20gbWlncmF0aW9uLiBJIGFncmVlIHRo
YXQgdGhpcyBtYXkgbm90IGJlDQo+IHRoZSBiZXN0IHNvbHV0aW9uOyBhbmQgd2hldGhlciBvciBu
b3QgYmF0Y2hpbmcgaXMgZW5hYmxlZCBjYW4gYmUgZGlyZWN0bHkNCj4gZGV0ZXJtaW5lZCBqdXN0
IGJlZm9yZSB0aGUgY2FsbCB0byBjcnlwdG9fYWNvbXBfYmF0Y2hfY29tcHJlc3MoKQ0KPiBiYXNl
ZCBvbjoNCj4gDQo+IGFjb21wX2N0eC0+bnJfcmVxcyA9PSBTV0FQX0NSWVBUT19CQVRDSF9TSVpF
Ow0KPiANCj4gSSBjdXJyZW50bHkgaGF2ZSBhIEJVR19PTigpIGZvciB0aGlzIGNvbmRpdGlvbiBu
b3QgYmVpbmcgbWV0LCB0aGF0IHJlbGllcw0KPiBvbiB0aGUgcG9vbC0+Y2FuX2JhdGNoIGdhdGlu
ZyB0aGUgZmxvdyB0byBnZXQgdG8genN3YXBfYmF0Y2hfY29tcHJlc3MoKS4NCj4gDQo+IEkgdGhp
bmsgYSBiZXR0ZXIgc29sdXRpb24gd291bGQgYmUgdG8gY2hlY2sgZm9yIGhhdmluZw0KPiBTV0FQ
X0NSWVBUT19CQVRDSF9TSVpFDQo+ICMgb2YgYWNvbXBfY3R4IHJlc291cmNlcyByaWdodCBhZnRl
ciB3ZSBhY3F1aXJlIHRoZSBhY29tcF9jdHgtPm11dGV4IGFuZA0KPiBiZWZvcmUNCj4gdGhlIGNh
bGwgdG8gY3J5cHRvX2Fjb21wX2JhdGNoX2NvbXByZXNzKCkuIElmIHNvLCB3ZSBwcm9jZWVkLCBh
bmQgaWYgbm90LCB3ZQ0KPiBjYWxsDQo+IGNyeXB0b19hY29tcF9jb21wcmVzcygpLiBJdCBzZWVt
cyB0aGlzIG1pZ2h0IGJlIHRoZSBvbmx5IHdheSB0byBrbm93IGZvcg0KPiBzdXJlDQo+IHdoZXRo
ZXIgdGhlIGNyeXB0byBiYXRjaGluZyBBUEkgY2FuIGJlIGNhbGxlZCwgZ2l2ZW4gdGhhdCBtaWdy
YXRpb24gaXMgcG9zc2libGUNCj4gYXQgYW55IHBvaW50IGluIHpzd2FwX3N0b3JlKCkuIE9uY2Ug
d2UgaGF2ZSBvYnRhaW5lZCB0aGUgbXV0ZXhfbG9jaywgaXQNCj4gc2VlbXMNCj4gd2UgY2FuIHBy
b2NlZWQgd2l0aCBiYXRjaGluZyBiYXNlZCBvbiB0aGlzIGNoZWNrIChhbHRob3VnaCB0aGUgVUFG
IHNpdHVhdGlvbg0KPiByZW1haW5zIGFzIGEgbGFyZ2VyIGlzc3VlLCBiZXlvbmQgdGhlIHNjb3Bl
IG9mIHRoaXMgcGF0Y2gpLiBJIHdvdWxkIGFwcHJlY2lhdGUNCj4gb3RoZXIgaWRlYXMgYXMgd2Vs
bC4NCj4gDQo+IEFsc28sIEkgaGF2ZSBzdWJtaXR0ZWQgYSBwYXRjaC1zZXJpZXMgWzFdIHdpdGgg
WW9zcnkncyAmIEpvaGFubmVzJyBzdWdnZXN0aW9ucw0KPiB0byB0aGlzIHNlcmllcy4gVGhpcyBp
cyBzZXR0aW5nIHVwIGEgY29uc29saWRhdGVkDQo+IHpzd2FwX3N0b3JlKCkvenN3YXBfc3RvcmVf
cGFnZXMoKQ0KPiBjb2RlIHBhdGggZm9yIGJhdGNoaW5nIGFuZCBub24tYmF0Y2hpbmcgY29tcHJl
c3NvcnMuIE15IGdvYWwgaXMgZm9yIFsxXSB0bw0KPiBnbyB0aHJvdWdoIGNvZGUgcmV2aWV3cyBh
bmQgYmUgYWJsZSB0byB0cmFuc2l0aW9uIHRvIGJhdGNoaW5nLCB3aXRoIGEgc2ltcGxlDQo+IGNo
ZWNrOg0KPiANCj4gaWYgKGFjb21wX2N0eC0+bnJfcmVxcyA9PSBTV0FQX0NSWVBUT19CQVRDSF9T
SVpFKQ0KPiAgICAgICAgICB6c3dhcF9iYXRjaF9jb21wcmVzcygpOw0KPiBlbHNlDQo+ICAgICAg
ICAgIHpzd2FwX2NvbXByZXNzKCk7DQo+IA0KPiBQbGVhc2UgZmVlbCBmcmVlIHRvIHByb3ZpZGUg
Y29kZSByZXZpZXcgY29tbWVudHMgaW4gWzFdLiBUaGFua3MhDQo+IA0KPiBbMV06IGh0dHBzOi8v
cGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1tbS9saXN0Lz9zZXJpZXM9OTEyOTM3
DQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gU1dBUF9DUllQVE9fQkFUQ0hfU0laRSBpcyBzZXQgdG8g
OCwgd2hpY2ggd2lsbCBiZSB0aGUgSUFBIGNvbXByZXNzDQo+ID4gYmF0Y2hpbmcNCj4gPg0KPiA+
IEkgbGlrZSBhIHNhbmUgZGVmYXVsdCB2YWx1ZSBhcyBtdWNoIGFzIHRoZSBuZXh0IGd1eSwgYnV0
IHRoaXMgc2VlbXMgYQ0KPiA+IGJpdCBvZGQgdG8gbWU6DQo+ID4NCj4gPiAxLiBUaGUgcGxhY2Vt
ZW50IG9mIHRoaXMgY29uc3RhbnQvZGVmYXVsdCB2YWx1ZSBzZWVtcyBzdHJhbmdlIHRvIG1lLg0K
PiA+IFRoaXMgaXMgYSBjb21wcmVzc29yLXNwZWNpZmljIHZhbHVlIG5vPyBXaHkgYXJlIHdlIGVu
Zm9yY2luZyB0aGlzDQo+ID4gYmF0Y2hpbmcgc2l6ZSBhdCB0aGUgenN3YXAgbGV2ZWwsIGFuZCB1
bmlmb3JtbHkgYXQgdGhhdD8gV2hhdCBpZiB3ZQ0KPiA+IGludHJvZHVjZSBhIG5ldyBiYXRjaCBj
b21wcmVzc2lvbiBhbGdvcml0aG0uLi4/IE9yIGFtIEkgbWlzc2luZw0KPiA+IHNvbWV0aGluZywg
YW5kIHRoaXMgaXMgYSBzYW5lIGRlZmF1bHQgZm9yIG90aGVyIGNvbXByZXNzb3JzIHRvbz8NCj4g
DQo+IFlvdSBicmluZyB1cCBhbiBleGNlbGxlbnQgcG9pbnQuIFRoaXMgaXMgYSBjb21wcmVzc29y
LXNwZWNpZmljIHZhbHVlLg0KPiBJbnN0ZWFkIG9mIHNldHRpbmcgdGhpcyB1cCBhcyBhIGNvbnN0
YW50LCB3aGljaCBhcyB5b3UgY29ycmVjdGx5IG9ic2VydmUsDQo+IG1heSBub3QgbWFrZSBzZW5z
ZSBmb3IgYSBub24tSUFBIGNvbXByZXNzb3IsIG9uZSB3YXkgdG8gZ2V0DQo+IHRoaXMgY291bGQg
YmUgYnkgcXVlcnlpbmcgdGhlIGNvbXByZXNzb3IsIHNheToNCj4gDQo+IGludCBhY29tcF9nZXRf
bWF4X2JhdGNoc2l6ZShzdHJ1Y3QgY3J5cHRvX2Fjb21wICp0Zm0pIHsuLi59Ow0KPiANCj4gdG8g
dGhlbiBhbGxvY2F0ZSBzdWZmaWNpZW50IGFjb21wX3JlcXMvYnVmZmVycy9ldGMuIGluIHRoZSB6
c3dhcA0KPiBjcHUgb25saW5pbmcgY29kZS4NCj4gDQo+ID4NCj4gPiAyLiBXaHkgaXMgdGhpcyB2
YWx1ZSBzZXQgdG8gOD8gRXhwZXJpbWVudGF0aW9uPyBDb3VsZCB5b3UgYWRkIHNvbWUNCj4gPiBq
dXN0aWZpY2F0aW9uIGluIGRvY3VtZW50YXRpb24/DQo+IA0KPiBDYW4gSSBnZXQgYmFjayB0byB5
b3UgbGF0ZXIgdGhpcyB3ZWVrIHdpdGggYSBwcm9wb3NhbCBmb3IgdGhpcz8gV2UgcGxhbg0KPiB0
byBoYXZlIGEgdGVhbSBkaXNjdXNzaW9uIG9uIGhvdyBiZXN0IHRvIGFwcHJvYWNoIHRoaXMgZm9y
IGN1cnJlbnQNCj4gYW5kIGZ1dHVyZSBoYXJkd2FyZS4NCg0KU29ycnkgaXQgdG9vayBtZSBxdWl0
ZSBhIHdoaWxlIHRvIGdldCBiYWNrIHRvIHlvdSBvbiB0aGlzLiBJIGhhdmUgYmVlbiBidXN5DQp3
aXRoIGltcGxlbWVudGluZyByZXF1ZXN0IGNoYWluaW5nLCBhbmQgb3RoZXIgbWFqb3IgaW1wcm92
ZW1lbnRzIHRvIHRoaXMNCnNlcmllcyBiYXNlZCBvbiB0aGUgY29tbWVudHMgcmVjZWl2ZWQgdGh1
cyBmYXIuDQoNCkkgd2lsbCBiZSBzdWJtaXR0aW5nIGEgdjUgb2YgdGhpcyBzZXJpZXMgc2hvcnRs
eSwgaW4gd2hpY2ggSSBoYXZlIGltcGxlbWVudGVkDQphbiBJQUFfQ1JZUFRPX01BWF9CQVRDSF9T
SVpFIGluIHRoZSBpYWFfY3J5cHRvIGRyaXZlci4gRm9yIG5vdyBJIHNldCB0aGlzDQp0byA4IHNp
bmNlIHdlIGhhdmUgZG9uZSBhbGwgb3VyIHRlc3Rpbmcgd2l0aCBhIGJhdGNoIHNpemUgb2YgOCwg
YnV0IHdlIGFyZSBzdGlsbA0KcnVubmluZyBleHBlcmltZW50cyB0byBmaWd1cmUgdGhpcyBvdXQs
IGhlbmNlIHRoaXMgI2RlZmluZSBpbiB0aGUgaWFhX2NyeXB0bw0KZHJpdmVyIChpbiB2NSkgY2Fu
IHBvdGVudGlhbGx5IGNoYW5nZS4gRnVydGhlciwgdGhlcmUgaXMgYSB6c3dhcC1zcGVjaWZpYw0K
WlNXQVBfTUFYX0JBVENIX1NJWkUgaW4gdjUsIHdoaWNoIGlzIGFsc28gOC4gSSB3b3VsZCBhcHBy
ZWNpYXRlIGNvZGUNCnJldmlldyBjb21tZW50cyBmb3IgdjUuIElmIHRoZSBhcHByb2FjaCBJJ3Zl
IHRha2VuIGluIHY1IGlzIGFjY2VwdGFibGUsIEkNCndpbGwgYWRkIG1vcmUgZGV0YWlscy9qdXN0
aWZpY2F0aW9uIGluIHRoZSBkb2N1bWVudGF0aW9uIGluIGEgdjYuDQoNClRoYW5rcywNCkthbmNo
YW5hDQoNCj4gDQo+IFRoYW5rcywNCj4gS2FuY2hhbmENCg0K
