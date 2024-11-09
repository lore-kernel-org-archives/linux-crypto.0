Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7308175BF;
	Sat,  9 Nov 2024 01:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731114195; cv=fail; b=B/zdcQcmpgXfhntnsFcUxC9SxOlv7DWiP+mUNno/1AAhoUEPilbBpVeyVx9C1bh2akaqHc0Zg2boOkw9Ai2P8rtGfEPbdgtqCXm//DOPMuppkBFGqv9eudOdqnPxKFfoVXMeZFMCDLVpM3B165yqZaKo+kBCp+nn322Qow/T+jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731114195; c=relaxed/simple;
	bh=/0j4fM/HqfPmGb0q3ASXy3z0jSCxPeQ+OF20ZKaoZYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EGz2HjxVQvPB6WDt4+WvVomDd5nVZ+CLAYkzDtk9fDhcxshDo7dhdu+hbywOe0fvTnFAQ4ltiuhUE7J8aZ+dCVokST6Rv3j0iHHZTgXhUnWkeUxYiku36KS+5SDRxWo7rL6gTiK0kitMbzQ7Jn6BC9bF9LE92Z6Fg8oKi/taqo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJItLk8S; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJItLk8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731114193; x=1762650193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/0j4fM/HqfPmGb0q3ASXy3z0jSCxPeQ+OF20ZKaoZYg=;
  b=QJItLk8ST6y+Mqq8dOIx0RKj8N2+dcFHQVSfkKkkkRa7aJ/Jcl3RKcgx
   Z72k2E58GfCkYANu4YW6vhwY25VMjOrtbSdYU2HToGTm86rl4BoCIfCG2
   3RAbUciU9Pg59XquKmeGOv5vtUIBnH00HfnXhwovEDx9oWeon8ITtVW8f
   qD/7JFQiT7zf+rbxoDRb39LH03+FaLzwVNNuVTlBjic8q/fOAeWySw9Lu
   LOF6kKKRxhofRj0gsS07W+GSOVBU0OeFDRKNZo87fRTqhnB4xZ1hDN5N4
   D7PfUlSdwHnZ9lEqf6Exdl1VjyijiWVkHl2uJJr1pIbHm8Fw/TMVyASc9
   Q==;
X-CSE-ConnectionGUID: 3phDWhTzSp2JVYuIsS3t1A==
X-CSE-MsgGUID: ooi70htxQgyZO4BMyy/+TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11250"; a="31114696"
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="31114696"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 17:03:13 -0800
X-CSE-ConnectionGUID: Tlduu6NLS8SgYl/76y5J1Q==
X-CSE-MsgGUID: tUH1bq21T8ygCHcMZ92oAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="86069047"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 17:03:12 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 17:03:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 17:03:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 17:03:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkD/uTXh3GxmyZYya1I61HJQI6rzrghAcyfbpDOxI2ddYuj/mjkFbHO8IB+JyxH1JENbpx20Gpdu+KjKoQZRjWEb2la+MzcsB2UZRpa9UGlgn+gkXuCD0/CYu/LaPBKmDgQeMlYcs9666TnCNA8JoK1QljxC+rDPoyCAGsWSbi7v8IH2w3Yrg9TrUd0nhgRdefTkTrpjuzHGUq27LaN4UUkX7m+4/vPPSppBFjrloZGMewrWIFoTeKbE0LCX8SwSfJSaAfSpc2HHyH5qs9zt1kcDx9EmXE2TjXZoo7vet/CYbtNI6ZKAQWA1CEDqKfEtGRcbaZ8NlSQ6OaJ04hv+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0j4fM/HqfPmGb0q3ASXy3z0jSCxPeQ+OF20ZKaoZYg=;
 b=C+pcOOA92MQrYvoI71Jhl+B2uLLTROXfUjEzQtdDHgy/URt/mx7eGBl1VYY8SW7KfssrXwloa4LhjwhGAiWibKI4ZXnjccg/KgFLlo562Sk59taav4Y9fzAY1JaGFC3yqomH14bpAxsg7W+sReQK1sXUwlZjp3gdEDDnZHVJG1I0O4CQ2dujWHFavaoseBEze9GoHlUUOgiYBqi4s/3CRvwQ+j/WS03AQq4BXZ9/tZ41dP7+nXi3pCeDwFa5XWApZwv3qP3U5hRGaxk6jnU1+DGo2/1XP2R59lvBc35Pe5uQRUtsFCgzJZ21WnuWTT1D+MBEtj6AdlGNq9K6y0nhUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Sat, 9 Nov
 2024 01:03:08 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8137.019; Sat, 9 Nov 2024
 01:03:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"zanussi@kernel.org" <zanussi@kernel.org>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
Thread-Topic: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
Thread-Index: AQHbMIERO8oD7n2rBEKiN2M+KhtYprKsEc0AgABO+cCAAXYLgIAAFEPQgAAWKYCAACN7wA==
Date: Sat, 9 Nov 2024 01:03:08 +0000
Message-ID: <SJ0PR11MB5678B69DBDCBDED4589B4785C95E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-10-kanchana.p.sridhar@intel.com>
 <20241107172056.GC1172372@cmpxchg.org>
 <SJ0PR11MB5678FA2EA40FEFE20521AC6BC95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkZrdrez2mohU_SRb3SYho5JGgwGYK4-imvfCNvSHfe=Eg@mail.gmail.com>
 <SJ0PR11MB5678E6DED92BDA697D572355C95D2@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkaCPMQUpvudJ+nQUrcvE9QmMwfQoU3AzCUjiGg61pnZaw@mail.gmail.com>
In-Reply-To: <CAJD7tkaCPMQUpvudJ+nQUrcvE9QmMwfQoU3AzCUjiGg61pnZaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SN7PR11MB6680:EE_
x-ms-office365-filtering-correlation-id: e69896cd-d277-47e2-0084-08dd005a464d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RndyYnczS0ZFd2ZPalNsVkx5R2VibHFxSVNqYUJQeGJGckRNMGxWeUthN05k?=
 =?utf-8?B?OVRUL2gzUHNQNTN2dzRuVE03d01XQndva0ZSWThPUHBlQ2FLdngvVXlkTlJ3?=
 =?utf-8?B?cUtIQnFNcFAzNHlVdTRhaEczeExtUnBrS3MzY0dkdHFDNE12L0p0RGxJT1k0?=
 =?utf-8?B?MDJaVTczT2wyWmhWVVdzZURDaUtQRUFLbUlEN3U4QjhGS1lWS3dRbmRmSWRX?=
 =?utf-8?B?WjVkVGFUNXp0S2NPbFhONzMzNEwxeWlVQm55L2ExZ1gyZnR3R2dCZHc0Ulkv?=
 =?utf-8?B?SXM4bWZZUm1FcDlrQ1R3aVJGdXZrSDNhdjY0MDVKbEtVS05ZV2JUbkFMMHRy?=
 =?utf-8?B?ZC9EV010NkxpU0c2VmlLRmJjWEVtdmFSWkRyc3ZMNEl6ZFdVRUkraUZpZUMv?=
 =?utf-8?B?bmxhaGc5b3JwTFcyODVnenB0aC85MTRHdCtGa0xnZVREN0FkQUlVMTdjNVlk?=
 =?utf-8?B?UDdRaTR0SUVCTExtb0JIWjlnMkpIVjQzSzQwekNQZTQvMEhaaVlGOFlUNzY2?=
 =?utf-8?B?R2twam5MamZIaEVnWmo5b2FucmdqY2xqTmE4c0UxYmZVcHRaVHVCN2lnYnBt?=
 =?utf-8?B?NVVWSDJaTTUvSSs1eUpLNlQ2d2Y2YTBWQ2ZERzVpRHZKcXB2aTRkMmcrU0Mz?=
 =?utf-8?B?cUtMQTY3UHQ5TFkwKzZBZzkyS1BGRWp4T3JDNnVreVlVY1EyVm1jdmdTYkpM?=
 =?utf-8?B?eForZUt3b05HVno5T1hYaW14VHFyTVFCSE5xZzRKem90U3BsNTIrSEhpYTFI?=
 =?utf-8?B?L3oyY0VkTWdMVm9hZFkxWU9aT2MvREMyNVhmcFViS0MwOU9uUWo5RmxkUG5w?=
 =?utf-8?B?STlFakRFNXdSb0ZjdVNITDNpZEQ2a3VjVXBPbVhjRHl3eGoybktRWnV5b2hJ?=
 =?utf-8?B?eXVKSVhvQlBqNHBGTnhVNjM0SFZpeEc5L1NrT2tGYTJOa3UyR3Q5VHk1VktI?=
 =?utf-8?B?dXJ5YmlFNmNWamJRU28xYVlWMWpnMWpGdDRpNGUxSWo5RVpRM0o3RWNxaDgy?=
 =?utf-8?B?d3JucTd5dmx3T0tJZUw0VURKZVh2OUkxVmIvSVhDVW11U0lFM1ZkV0ZDai9q?=
 =?utf-8?B?dm50VGVJMnMxK1l6MXFJQ0xycTZ5QW5IbnM1dldMOVBJWW10ZGE4SEw0NHZz?=
 =?utf-8?B?Unc5UGdwMGdoU0tsODBZN1RmU3NPRVVjVVE0b0daSmhSMmk4dy9VOWlkek11?=
 =?utf-8?B?WlM5UllEWTIrdTlXMHhiaUV5TlhmKzExSDZFL0FxRHJoakl3Q1RiaS9IL3ZJ?=
 =?utf-8?B?aW5OeFZZeENHbUFZSWZoaVpKK0FrRTFtTkxMVXltVStLOVpFN3F0NHJvaTBn?=
 =?utf-8?B?d0RUM0Z0SzdHejhpNWxQVUtDZUpwZG5rdDFQTXNyZnV4M3E5SUlsZ0liM3Fs?=
 =?utf-8?B?enFzQisvQnVjZkxFK0ZNS2JIdTRWNHRSa001SDZoNzF4NWc4eDFhejdmZzdk?=
 =?utf-8?B?cmg5Y2FQSDd6SFpnZHFmL2FWM3JUWnJ1YXlOTEw3Y044Zi9meUQ1bmp5cXZi?=
 =?utf-8?B?T09KZXM1Ynp0QnIvSXR0ZWVvSi9ScDZFRi9ZaU52ZFNJZ04xcEt4VnUxNnA5?=
 =?utf-8?B?bytzN1I3aElTWlJPMzBJREhxazNveGJNVWxJeE1kVE9KVHFYRHlPSGVCVlFa?=
 =?utf-8?B?Y0REQWhqM3lhS3ZXa21hQXkyR0dWa09IRkxOWmJNYjZOY0dFU2lwUXBuQmQz?=
 =?utf-8?B?Sm1kTzlHdTlwV00yTnlKTFF5U0RGa0xGbU9JUmV1WlQwL1ZIOWJtUEtHZnI5?=
 =?utf-8?B?b3Ivcm1IZG44dklIemJOZE1sQmZWQUFYS0NYYTZOUCtOcmgyZkMvYlE4L3Nm?=
 =?utf-8?Q?6UxJLe6PlpjFtAin7/a+CN5DiSLgLAHU1z1RM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmlNM09VVnhFUXF5THAxL1NFU1dRQ0RRcGwrMUsyNUNMd0ZZVmlGOEhPcVEy?=
 =?utf-8?B?U3plUm1MaS9tbHlvaC9qZkhCaEVjNXd1bEJKSDZJUkxWcDhJUkwrQ3FaYUxK?=
 =?utf-8?B?YnBHVkRSdVRCN3JDeFJZd0lzTnZiK2FvYmJKK0UxcUpMK0NvWUpSVlRtTEkw?=
 =?utf-8?B?bXpGeUJxMzVIZFBXRU1reFA5MU5FUmkvWm1PNExHdm5QT2V4cW5FV3JjKzd4?=
 =?utf-8?B?TlMwWk1lOWszQXByeGdvMW93SysyV3FQN3BaaWloZmpwRW1MM3pGWVd3eHBr?=
 =?utf-8?B?cG10dG9ONkY3OFRobGNlOXZNSExFbVkzZzVWbU9ETUUrRERhS1Q1TUNrb1FE?=
 =?utf-8?B?MU5heEw5U2l2Q2FZaVdWOXRrL0U0R3ZObzhmdUZNQ0cxZHVnT0djTGdqVVNw?=
 =?utf-8?B?azRYTHdmbUl1WU14emU0clhSN0xyQXNLSFg0MlpIRnpVNUVCRGc4WjdtTGpI?=
 =?utf-8?B?UEkxUXEzYkhoa001cTl2NHhNOXBHUExHNWt1SGJuQXFxRkRJc3d6Z0tNWDRz?=
 =?utf-8?B?T1lFaFpHYnpVb0Fhekp2NTdTa3dJRVg4WWNuOVEvc29ORmYyNFIvdUFjM0FN?=
 =?utf-8?B?UXV1UFk5K0hwR2dKQnN6WndZR2FFcXJNZlppSGVHN1M2NmljOE40NTNacGgw?=
 =?utf-8?B?UnNuMlUyU2RUTTFHR2pxRHZaSUk1TmMxTnRHTjE2alpheEdNbFVrVEY1ZUo3?=
 =?utf-8?B?cEErWHpCUXhWakNvb1hhMTArU0ZpaVJ6cEM4UVRCQjJMMnBieCt3S1NoSU1l?=
 =?utf-8?B?ZVpCTUFIenVic0JOYXlqOXR1Q2ZUVHBSVGlkSE9RaHFxM3dCQytzeFhBeTU4?=
 =?utf-8?B?V1Y4U2l6RHhzRnNsT3djaVRFYXlLS0FHYmI3MjVOL2lPNy85NjJlRXN0Zlh4?=
 =?utf-8?B?c3JYMGlURUcxcEdGblE2QTMxMDJqLys0WTljc1ltVU9ZaGQxYlk1Sjl3QXlY?=
 =?utf-8?B?OGM3ZHJEYWloRFFxK3JNRng4UzM2UjFLeHcvSGV6NnFPSHRVY3gxUE1UT21Y?=
 =?utf-8?B?eHpBVVpLbnl1SFFoOEJaZDlaNGM2RXdaUW9MdjA4b1FnRGhMVGJpSWQ4c1l2?=
 =?utf-8?B?bnF3Unc4M2hHZTd3akw0dUhqMGE2MnlaS2cyQTJqMzNrVWROb1cyQWR5M1Zo?=
 =?utf-8?B?NXA2bnBWSFNscXMvM015M3hYd0RIY1hnemw3aUtVVjJVT2I3WVYxRG9WWjVB?=
 =?utf-8?B?L1l0UlgzZWFvanhXVENlQkE1RTFkaVZ4V0ZSODRZOEZHRVcvUGM3YkJzTWJ0?=
 =?utf-8?B?dlVjQ0VYa1NvVFBvWW1GbmlyUzVWQVdhZ0JIRXNaeEFFc2tIY1dKbmo4bW9R?=
 =?utf-8?B?L1pOUW5tQnlnYkw0WDlIMG10bFRYaWpYMXhIeEl3ZWh4MEh1Zm1rNFFWZFF0?=
 =?utf-8?B?ZmFJY29RSUJ0QXZ1QjN1N3BPbXFUcEVYN1BKeStoeVRHQjV2dGg3SVArZ2Mx?=
 =?utf-8?B?OElISnp0dzV6SHdHNDZOTlkwV2YvMmxHVlYrK3hBL0hMU09zZ3YyWE41KzFG?=
 =?utf-8?B?RjBIUjFHdEdRQ1pFdUhnT2dieEFqT3k1MGtvU2pzcXVpeTYxSFluM0RmKzlM?=
 =?utf-8?B?MTQ3R1cwSmJJaHdzWHFha3hQSEkvWndTTStoR1RMZVNZTkhDTXBIaTFRZlhZ?=
 =?utf-8?B?dit3cGdtbEdqVGFNZVZoeUFGb0dyUGltcWZubElLTEFmT0hla29MYW80Q1RH?=
 =?utf-8?B?QjBzby9TdmM1cTdDT1JOeXNZUkNsSHduWk9Xd1pKMVQ2TkZJZDBxSS9FYkZw?=
 =?utf-8?B?OWpTYk5hMzVvZ2lMN1o4bnE4QnR0Z3pzb0RFUkYwLzVsc0FqQ1I4clBkTnM1?=
 =?utf-8?B?bHB5eXhnNXVnZHZ6QWM1RU9SNURpMG05V3FrL25SK0lnV1dvNlI0dkI4SG1N?=
 =?utf-8?B?amRKZkxLRnVPY3JlbTUxdndPOGlIVm9hNzZLSHFQQUlXaXQ4d0hWQ0pxblU2?=
 =?utf-8?B?NEpsY2t4NVl1QmdmL29MVmd5ejliRDF0cWR1b1cxUEx1cWR2VlNnMXY1ZU00?=
 =?utf-8?B?Vnl6U28rb01XYVRNZ1dZWDJTckRhRjR1WXFkM1l4ajNYeE9sOUUvSG5nTVhh?=
 =?utf-8?B?LzRxajdYS1hQeUhkc1J5NUdZZ2dUZFZTSkVGR3Bua084YmV1UmlWQnREbDhY?=
 =?utf-8?B?ZVJDRFU5TzUzRlNKNStoeHNuNXFWazVqNytrSktoNXZtRXFXQW8rUW91M1hv?=
 =?utf-8?B?ZGc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e69896cd-d277-47e2-0084-08dd005a464d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2024 01:03:08.2806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEe3JSJZyVStU7WEvuPZPpPN5t3rg8Pj49lx1nuSO5C7BHpscHd7o0Klm5ysaCV6Ct0mpBS5o9hk4xtqWvor4twB6rcEBhYiSsDiKAdq2Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgOCwgMjAyNCAyOjU0
IFBNDQo+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwu
Y29tPg0KPiBDYzogSm9oYW5uZXMgV2VpbmVyIDxoYW5uZXNAY21weGNoZy5vcmc+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1tbUBrdmFjay5vcmc7IG5waGFtY3NAZ21h
aWwuY29tOyBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5j
b207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyBIdWFuZywgWWluZw0KPiA8eWluZy5odWFuZ0BpbnRl
bC5jb20+OyAyMWNuYmFvQGdtYWlsLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4g
bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5l
bC5vcmc7DQo+IGViaWdnZXJzQGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRp
LCBLcmlzdGVuIEMNCj4gPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IHphbnVzc2lAa2Vy
bmVsLm9yZzsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47
IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjMgMDkvMTNdIG1tOiB6c3dhcDogTW9kaWZ5IHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4
DQo+IHRvIGJlIGNvbmZpZ3VyYWJsZSBpbiBuciBvZiBhY29tcF9yZXFzLg0KPiANCj4gWy4uXQ0K
PiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhlcmUgYXJlIG5vIG90aGVyIGNhbGxlcnMgdG8gdGhlc2Ug
ZnVuY3Rpb25zLiBKdXN0IGRvIHRoZSB3b3JrDQo+ID4gPiA+ID4gZGlyZWN0bHkgaW4gdGhlIGNw
dSBjYWxsYmFja3MgaGVyZSBsaWtlIGl0IHVzZWQgdG8gYmUuDQo+ID4gPiA+DQo+ID4gPiA+IFRo
ZXJlIHdpbGwgYmUgb3RoZXIgY2FsbGVycyB0byB6c3dhcF9jcmVhdGVfYWNvbXBfY3R4KCkgYW5k
DQo+ID4gPiA+IHpzd2FwX2RlbGV0ZV9hY29tcF9jdHgoKSBpbiBwYXRjaGVzIDEwIGFuZCAxMSBv
ZiB0aGlzIHNlcmllcywgd2hlbiB0aGUNCj4gPiA+ID4gcGVyLWNwdSAiYWNvbXBfYmF0Y2hfY3R4
IiBpcyBpbnRyb2R1Y2VkIGluIHN0cnVjdCB6c3dhcF9wb29sLiBJIHdhcw0KPiB0cnlpbmcNCj4g
PiA+ID4gdG8gbW9kdWxhcml6ZSB0aGUgY29kZSBmaXJzdCwgc28gYXMgdG8gc3BsaXQgdGhlIGNo
YW5nZXMgaW50byBzbWFsbGVyDQo+IGNvbW1pdHMuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSBwZXIt
Y3B1ICJhY29tcF9iYXRjaF9jdHgiIHJlc291cmNlcyBhcmUgYWxsb2NhdGVkIGluIHBhdGNoIDEx
IGluDQo+IHRoZQ0KPiA+ID4gPiAienN3YXBfcG9vbF9jYW5fYmF0Y2goKSIgZnVuY3Rpb24sIHRo
YXQgYWxsb2NhdGVzIGJhdGNoaW5nIHJlc291cmNlcw0KPiA+ID4gPiBmb3IgdGhpcyBjcHUuIFRo
aXMgd2FzIHRvIGFkZHJlc3MgWW9zcnkncyBlYXJsaWVyIGNvbW1lbnQgYWJvdXQNCj4gbWluaW1p
emluZw0KPiA+ID4gPiB0aGUgbWVtb3J5IGZvb3RwcmludCBjb3N0IG9mIGJhdGNoaW5nLg0KPiA+
ID4gPg0KPiA+ID4gPiBUaGUgd2F5IEkgZGVjaWRlZCB0byBkbyB0aGlzIGlzIGJ5IHJldXNpbmcg
dGhlIGNvZGUgdGhhdCBhbGxvY2F0ZXMgdGhlIGRlLQ0KPiA+ID4gZmFjdG8NCj4gPiA+ID4gcG9v
bC0+YWNvbXBfY3R4IGZvciB0aGUgc2VsZWN0ZWQgY29tcHJlc3NvciBmb3IgYWxsIGNwdSdzIGlu
DQo+ID4gPiB6c3dhcF9wb29sX2NyZWF0ZSgpLg0KPiA+ID4gPiBIb3dldmVyLCBJIGRpZCBub3Qg
d2FudCB0byBhZGQgdGhlIGFjb21wX2JhdGNoX2N0eCBtdWx0aXBsZQ0KPiByZXFzL2J1ZmZlcnMN
Cj4gPiA+ID4gYWxsb2NhdGlvbiB0byB0aGUgY3B1aHBfc3RhdGVfYWRkX2luc3RhbmNlKCkgY29k
ZSBwYXRoIHdoaWNoIHdvdWxkDQo+IGluY3VyDQo+ID4gPiB0aGUNCj4gPiA+ID4gbWVtb3J5IGNv
c3Qgb24gYWxsIGNwdSdzLg0KPiA+ID4gPg0KPiA+ID4gPiBJbnN0ZWFkLCB0aGUgYXBwcm9hY2gg
SSBjaG9zZSB0byBmb2xsb3cgaXMgdG8gYWxsb2NhdGUgdGhlIGJhdGNoaW5nDQo+IHJlc291cmNl
cw0KPiA+ID4gPiBpbiBwYXRjaCAxMSBvbmx5IGFzIG5lZWRlZCwgb24gImEgZ2l2ZW4gY3B1IiB0
aGF0IGhhcyB0byBzdG9yZSBhIGxhcmdlDQo+IGZvbGlvLg0KPiA+ID4gSG9wZQ0KPiA+ID4gPiB0
aGlzIGV4cGxhaW5zIHRoZSBwdXJwb3NlIG9mIHRoZSBtb2R1bGFyaXphdGlvbiBiZXR0ZXIuDQo+
ID4gPiA+DQo+ID4gPiA+IE90aGVyIGlkZWFzIHRvd2FyZHMgYWNjb21wbGlzaGluZyB0aGlzIGFy
ZSB2ZXJ5IHdlbGNvbWUuDQo+ID4gPg0KPiA+ID4gSWYgd2UgcmVtb3ZlIHRoZSBzeXNjdGwgYXMg
c3VnZ2VzdGVkIGJ5IEpvaGFubmVzLCB0aGVuIHdlIGNhbiBqdXN0DQo+ID4gPiBhbGxvY2F0ZSB0
aGUgbnVtYmVyIG9mIGJ1ZmZlcnMgYmFzZWQgb24gdGhlIGNvbXByZXNzb3IgYW5kIHdoZXRoZXIg
aXQNCj4gPiA+IHN1cHBvcnRzIGJhdGNoaW5nIGR1cmluZyB0aGUgcG9vbCBpbml0aWFsaXphdGlv
biBpbiB0aGUgY3B1IGNhbGxiYWNrcw0KPiA+ID4gb25seS4NCj4gPiA+DQo+ID4gPiBSaWdodD8N
Cj4gPg0KPiA+IFllcywgd2UgY291bGQgZG8gdGhhdCBpZiB0aGUgc3lzY3RsIGlzIHJlbW92ZWQs
IGFzIHN1Z2dlc3RlZCBieSBKb2hhbm5lcy4NCj4gPiBUaGUgb25seSAiZHJhd2JhY2siIG9mIGFs
bG9jYXRpbmcgdGhlIGJhdGNoaW5nIHJlc291cmNlcyAoYXNzdW1pbmcgdGhlDQo+ID4gY29tcHJl
c3NvciBhbGxvd3MgYmF0Y2hpbmcpIHdvdWxkIGJlIHRoYXQgdGhlIG1lbW9yeSBmb290cHJpbnQg
cGVuYWx0eQ0KPiA+IHdvdWxkIGJlIGluY3VycmVkIG9uIGV2ZXJ5IGNwdS4gSSB3YXMgdHJ5aW5n
IHRvIGZ1cnRoZXIgZWNvbm9taXplIHRoaXMNCj4gPiBjb3N0IGJhc2VkIG9uIHdoZXRoZXIgYSBn
aXZlbiBjcHUgYWN0dWFsbHkgbmVlZHMgdG8genN3YXBfc3RvcmUoKSBhDQo+ID4gbGFyZ2UgZm9s
aW8sIGFuZCBvbmx5IHRoZW4gYWxsb2NhdGUgdGhlIGJhdGNoaW5nIHJlc291cmNlcy4gQWx0aG91
Z2gsIEkgYW0NCj4gPiBub3Qgc3VyZSBpZiB0aGlzIHdvdWxkIGJlbmVmaXQgYW55IHVzYWdlIG1v
ZGVsLg0KPiA+DQo+ID4gSWYgd2UgYWdyZWUgdGhlIHBvb2wgaW5pdGlhbGl6YXRpb24gaXMgdGhl
IGJlc3QgcGxhY2UgdG8gYWxsb2NhdGUgdGhlIGJhdGNoaW5nDQo+ID4gcmVzb3VyY2VzLCB0aGVu
IEkgd2lsbCBtYWtlIHRoaXMgY2hhbmdlIGluIHY0Lg0KPiANCj4gSUlVQyB0aGUgYWRkaXRpb25h
bCBjb3N0IHdvdWxkIGFwcGx5IGlmIHNvbWVvbmUgd2FudHMgdG8gdXNlDQo+IGRlZmxhdGUtaWFh
IG9uIGhhcmR3YXJlIHRoYXQgc3VwcG9ydHMgYmF0Y2hpbmcgYnV0IGRvZXMgbm90IHdhbnQgdG8N
Cj4gdXNlIGJhdGNoaW5nLiBJIGRvbid0IHRoaW5rIGNhdGVyaW5nIHRvIHN1Y2ggYSB1c2UgY2Fz
ZSB3YXJyYW50cyB0aGUNCj4gY29tcGxleGl0eSBpbiBhZHZhbmNlLCBub3QgdW50aWwgd2UgaGF2
ZSBhIHVzZXIgdGhhdCBnZW51aW5lbHkgY2FyZXMuDQoNClN1cmUsIHRoaXMgbWFrZXMgc2Vuc2Uu
IEkgd2lsbCBhZGRyZXNzIHRoaXMgaW4gdjQuDQoNClRoYW5rcywNCkthbmNoYW5hDQo=
