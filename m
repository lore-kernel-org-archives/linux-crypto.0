Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320B41F0E2E;
	Fri, 29 Aug 2025 03:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756436833; cv=fail; b=K0V/8yNPPl8tAWymj1dhKLm1XjEjeY5tD8+RadNlxW/R4ReAxgQTKgihgf8OvkMLuMKGCFAZp1emf1CPCaWyhRWzH8sIQI7MvhuofmUVmNyGWTCqJGMSC3y/XPByuw4qkDP4wWmVAhXxhefcZx37HkGlco1rmIMVA9iD0F6rPMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756436833; c=relaxed/simple;
	bh=waC4zWnc5XoenRCLgYGAPYtWWxsImj2RcdbKgEI7SpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qhZXGR1Oz+SjEwDt2gIOmDZynQYWG3EMVD25V2t8ruYzHpfugjT0ZH4bkNF64zhEFuqR0rI1jI1JoLWy/eqzyJvPQGtecxzWsrOswlOZM0Bqqm1vsv1iIwt6N5JxnuqbJqP8/ic2bfFs3p9Vnn0Uqzkr0cM4DkvLTxXmNAgZy+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UyBudH7f; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UyBudH7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756436833; x=1787972833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=waC4zWnc5XoenRCLgYGAPYtWWxsImj2RcdbKgEI7SpE=;
  b=UyBudH7fXwFd/8Wj6Cm0Wwx8Pqci4oCbZJrY3LA8BeS88e0BIFLuZ1BM
   468KIqaqIipV2No82wozw64Rhe8loOJ9unRRz+uwctMETCHcNk47/cFuD
   hEjKJoekqjv5fnDYArTrS1kX3VspT5YDt854M75cKSn6m/BMlQr+R6E9D
   cRDh5gPuabjTVTuLs9pXDbPORULha6wbQtTpwp+1CmECfvlKNrlJ8WBqX
   pgrZEN/SEBhiJo84x2tVkVrH8fLMUgwR5ZbAtNqwj9xSwUBz9jJbaMzI3
   FAMi9camSEg24rU7hWA0aDSWfj4QfVXvfm/FQRxmaPU31VzAbjZWMhaZq
   g==;
X-CSE-ConnectionGUID: uas8+7uBRuuwdWHgb/ePmg==
X-CSE-MsgGUID: BN7WB5VhSMab38IB/fVg/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70159949"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70159949"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:07:12 -0700
X-CSE-ConnectionGUID: MitH0VIQTce0+z6eL81J4Q==
X-CSE-MsgGUID: talUBeyuTwCD6HEg49a3hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="201217240"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:07:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:07:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 20:07:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.51)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:07:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IT0DNNnQEk3lZCj+By+CtwNSKX4s2Jifl+B9nEIu7dNfcxqtmruJFwLfKmp/n+Rj7HlBYEKtpNO/4HRt+MHn194TOXsmrJQYbIiN4fhaZ2jke6rCHTil65OWW1F0qSmOgx5l8eZYhqBNOUcd+NwVv/2jZP2fVh/QT/Qx+JPn5m/vfl865g/Fy4LYugGJH6ChjaMVnh5myvbNHjUlgNtbpeMkQkwqqBXDNWpZuEhk9yu6+69VfnapQe4ZHFxIhMfBGpeO9sgRlCIufX+f7ILO3+5v1H1WIkWEIrW5XHjy5dIKnvJmpHpbVtOFPZDJrBWY5cz9zhBhYegGSabcax63yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waC4zWnc5XoenRCLgYGAPYtWWxsImj2RcdbKgEI7SpE=;
 b=GjlrZY5yjA1QlT0zMysesBEEv0HpYWitBd91ePjhGP3QxY/jhKYckSprQkfFbo3dACLzrcmN1Uw2GOJgepzlqKcT0yPA3ULKC8C0hbcCE8ESRQmcJnvU3bgoLZLHS3zIQ3zk8f9/jHaJpzs/LVUyy+9ZAjDUR3vFONbg9kmvrIL9XlxQEHzbKFjjZyl1jL0fFnsiW5kbXzlnEkCYUXGbbFw4rm9QocNCrAjIbIKPMB24oBj1KFYuAHkqChXx3Sc7Fr9AZ5Anf5uf9TRTY6thtss6MS4L+FLK7Lx6tomUIFN6b/Nfd+zdBbaEyFP/2yVGOdj3xz7GgEyKeNo/JHrYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 03:06:59 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 03:06:59 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcAp3s2yhoOlvg0ke7aLYIJiYnCrR46mmAgAAz08A=
Date: Fri, 29 Aug 2025 03:06:59 +0000
Message-ID: <PH7PR11MB81218BC3475BA5799E4FEA4DC93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
 <CAGsJ_4zFXzXKVKu9M2_R1Nqqt6FBEktT1YBGAFPRgjTxv=+1_Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4zFXzXKVKu9M2_R1Nqqt6FBEktT1YBGAFPRgjTxv=+1_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH8PR11MB6779:EE_
x-ms-office365-filtering-correlation-id: 8d45a629-1d5b-4ae9-a81d-08dde6a91eac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?d1dZK0hzbkFMVThUQWJiYzVJODZIOFlKV0MvY0pxd1NRcWR2TmlkQ1A0OUdq?=
 =?utf-8?B?OUFEU25uNFhpdG1tV0M2YjRrQTlzUFpQb3MzT3M2QWYzNFExeXRmMzlCNXQz?=
 =?utf-8?B?bTQ5QXBQUjZib3YwdnZZOWJvV29HcVd5ZjYxeXRWeUFrNXZkQVFmL1pBTkJI?=
 =?utf-8?B?TzhJZDVKOWZaelNwOGQ5R3FYMDlHV0M3TDA0Y0pRdXg1MHBVMlN3VlY4Z2tJ?=
 =?utf-8?B?MGdOU3cwdlBMbzdEbXRnVEI1WGgxMnpSNXdhMTRRRUhnQXk2Y1ZtWC9ITjJu?=
 =?utf-8?B?RzdoQXU4RXJaQ3duT05hTnFGMTdrUndMQkRncXA4TFRQbWpxbFV2UkdpZjU0?=
 =?utf-8?B?Z0VoSmVXdGpkcmtHL3hGa1M1cFZrZDlXNEdpOG1aUTU1aUduZWdNc3p6YU1U?=
 =?utf-8?B?TDYyaC80N3YxcVVYS1FWT3NpL1pMV3pPV0drQXNFdHF5SXdSUmhCSTI5c3hP?=
 =?utf-8?B?Qkx3bUtHejJueDVWWndnYlNjN0FxUUowZzkwV0ZJWS9VZTczeVY1NWp5eEJ1?=
 =?utf-8?B?YUNlTkJoU043T0dPOE0yOWpZQWF1T1A3S0tHV1B6bDFHQTJOVENIaUh0N3c0?=
 =?utf-8?B?bnVoQ0lDMjF4eFhXNXYzczhKU1JUcnM2b1NkZ2lkNnhKbDBROFF2Vll4T1pn?=
 =?utf-8?B?OWQ4RmljU0JvZjYvcWIxaGFWUEZrVHVtWktXKzRSZHB6ODJRYkJsR3J0bEtq?=
 =?utf-8?B?MUtGbHZWWGFldmNaWkFadEh3eStjSXJxYmJ3U2pGRFpUNXNDMXBGYld4ZERY?=
 =?utf-8?B?WWxlRmR5S2J3Mk93S0tHd0NWVVpDZE5jT3VGN0hMcGM1a1FLSnN2SExaYTB1?=
 =?utf-8?B?WGJZaEg4UnBIbSsvb2UzdkVoR1JqSTUyTWF6amRiK3B6K3N6RW1kTnhMTTdV?=
 =?utf-8?B?ZFJ1ZURlTE1kcHdBYUQxeXdUdDR1RDhRS2xuOG9tNWdzMGEyN0VmcmVWOXhm?=
 =?utf-8?B?ZXNrODFaNWdObVJoU3N3MWNmV1hFVEIwUGVpWWttL2c1UjJ2b0RxUkw2ZVJV?=
 =?utf-8?B?enZuUlVXNGZCS3VPN2k5MUtaVGIraWdxNk5VOHoxUkpkOVdrc2FBSk9aWDcy?=
 =?utf-8?B?aUZyVms3ZEpMSGdLYTl3QW1ueDBEVW9sZVVLUDl4bHh5ZzU1N3hHdnc3UUxj?=
 =?utf-8?B?c0lQRFNiNWtJdGhpaHIyWVBZTTJsMitoQlV4UHJBblJsZ2xPN1pvZVo1azJ0?=
 =?utf-8?B?dFM2R2g5OGQyeDMxdERIR3BDb21nZVFnbWFDTDllY2tWSzhpcnQrWUFLWk45?=
 =?utf-8?B?UkZaL0ZCQm0zcHVsMndlSVdDeXZodXJJNmZQUit0QnBXOC9ETzFlK21IY1VQ?=
 =?utf-8?B?bkprYllpNVZOUThEZ0lmcnJpcFdndEZKaE5HM2Q5MFk5RE1JcEdaR2ZDd21C?=
 =?utf-8?B?djdiRFJpa2hEREJ6dEZSamhxOEJBblM1c21Rb09oWHc4MUFIYWZDZGtBR1ZH?=
 =?utf-8?B?WTlkelVWd1loampySlFyaUMyTzJXMkJBUmJGT1M1N2tESXZ5dXY1bTdONGMr?=
 =?utf-8?B?cGE0QUdPYllFOHBVVXRZRW03emFmZGtGTnNwWEgvNE95QVVVVS9ZRHhKZ08v?=
 =?utf-8?B?eUI3M0xDM0xSWUFNdllzNmpCcFl1dlFtTkxRT09pL1ZZMTk1RUcvSHBlUzJ0?=
 =?utf-8?B?Y1laRCsrNE9KRDg4cmRzd3hCOGVSdUdWWUhEWVlVZmtDR2Uwb0FZRkNIVDE0?=
 =?utf-8?B?Um1hSzI4MUQwWWdhV0ZadURjKzVTYzk4QmVORWRZYzdud1hRMnNxaXpyUjND?=
 =?utf-8?B?V3FzTVpueWJMOHJoVk11YWhpM1RrQTFnS3VDSVgwZ3lnYkI5UC9zanAxS2xY?=
 =?utf-8?B?em96dnBCTmpWYnJxVTFUR1lQZFZFV3ZCS2dud0syaTZ0c3RqMmZUSmpRT3lJ?=
 =?utf-8?B?ZWRQMU5XeVI3bW5HYXRDU2RTcllFa25PQ2FwVlNuUVRmbCtVQkcvV0NtN1g1?=
 =?utf-8?B?bU1KTHFjcTExczBVNG44bE5ubmlWZ0JGRGk0RnZhZm5rYk5Eb0NDdGp1cks5?=
 =?utf-8?B?L3EzaDMvcFFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODNra2psQ3NBUDBIOHdzdjU3Uk5VNXg1RzJtZHFGZnBqNG1rS0tERXJLMUxV?=
 =?utf-8?B?T2daa0RqVU16OUx2dHlvNjNSSGJHdFdKN1V1bWR1TzFsenFTamhlUUhjY3Y1?=
 =?utf-8?B?S1lNVjJsODZaTCtjN3hMci93RzIzSlFXakZkbEhOMyt4Q2hPSGw0VTBRNGJI?=
 =?utf-8?B?K3hRSVFSMldGZEJxNjY2UEZqWkZkOFFKaTRnT3FaR1ZiYWI3TU5tdk5tWXhw?=
 =?utf-8?B?NHUxdzRaTXNPSHlhRXJSTFk1T1J6K2p1NzN6MmIwOUFVVDRab29RZ2xXd3RP?=
 =?utf-8?B?Yy9WbmNjL2FHUEFBOHc4Y0tubWRSNldqazIzcko3MmNQYWZqVWJNWmVzSUxi?=
 =?utf-8?B?cStqZFlOaVdEZk1NTUZqZTNadWVrUkJiRHkyTzFLVklWS05MaEY3dDhDajVm?=
 =?utf-8?B?aHBqWmdUcXFsTzhhRjY0WmpLTm9rbWVCVVQ5RnF5QVRpa1VhUS9ZN0RVSHJq?=
 =?utf-8?B?UkVPa1Ira3BmZk0ycW5VSjB2RE9oT2tzclJ5bnRwelNvbmJobGMxSFNBZzN3?=
 =?utf-8?B?QTgzY25Kd3d5UTNIdW5FOVEwT2dSWmVPakJSdk8vbHJFNS91b1k5WXV3Rkx1?=
 =?utf-8?B?TGJRUVJXZnJadDVmcEtGL3JUSWYybDRLN0s4NHM3TlJBQUFOUUhYT0VJMkN0?=
 =?utf-8?B?S2oxdU9GR3lKOTJvSWRVZGlFekdXT0hjbk5vVGRXd0xjbHFNQWxYd20wSS9F?=
 =?utf-8?B?MVF6OXVWNmVnaGFGa2ljWXpPQ3g4K0pBdFRIVHdXRmJuc3RTV3ZPQk83bTJi?=
 =?utf-8?B?R28yMHVaeG9EWVE3Q0lObUdVQkFrY2J2WURTVFROS28vR2x1R04rb3VMMlpx?=
 =?utf-8?B?R3YvajJoYmxLVGlKWFpDaTV0TUtDTnFsNno1dVRJTWlRcmlFWTh5Y24zTlZs?=
 =?utf-8?B?bm9sMDdrNzdZTlFIclphWWRLRWtoZGNKTmh5Skt0ZWt2VlNNU1NOUE9wais4?=
 =?utf-8?B?TzNCMDcxNEkyNGh5dUR6cWxzMDA2bER2U2U5MHRIc1J1VkJ6K1NwNFhlZWxr?=
 =?utf-8?B?UUdMalhxSU5DaVdDZEg2VWV3R1RPa1R0bVFoRkRyZDZ1Tm5MN3NaaWlWdWhr?=
 =?utf-8?B?RlQ0R00wOFpXeEpZVlFiY2x5U0xvQTdzUy9ITUpMNDNkVFFIRFNpZy95aUsz?=
 =?utf-8?B?RCtGSGpsazlQbytSOWNEWDNFQTlJMzJFODBqZVhBVGRWUGxjRWJ0QmFCUWxS?=
 =?utf-8?B?LzV1T1laZmtjMVFhbEtic2dqZzVRcDRVS3N0QUVReGZJVHpPd3FvWnBncTV4?=
 =?utf-8?B?Qjd2WXNiT0lVaXFGa3QvVG5ZZy9YWGhRS1F6UkNQTGF2QnREZkRjZGJzMTho?=
 =?utf-8?B?c2VWWGY5WFpyMTB3a1BlWkpSNGVxYXlvdkdId2N6WldvOVJ1TjFXUG5BNVo0?=
 =?utf-8?B?dXNkeldnWTBoTG1KV2ZqSTVYNWg4YmVuTXBzcFFrQzJIdkw4eDZMS2Rhcm5k?=
 =?utf-8?B?aVVIQ3VkV3NVT09HQXVvTVoxNFpvWUNlc0hKOGcvMmp1SGJTdjJCc3hTd2JQ?=
 =?utf-8?B?TGFrWHJxVk1QTHFYdUlnclhscVhTWUZJYlBzbU9YODM4SFQ2eEcvb3hmVlIv?=
 =?utf-8?B?NG80anZhQWVkb2tmazdMbU0xRWZ6RDRFNzJhT0VldHp5R3NPRzBoaVh3UDFn?=
 =?utf-8?B?ZWV3STlpZUczaUxjZlc4OHBaVHNFUHBETkhZdzlWU0x3Q1IwZ21WcTRhbmVE?=
 =?utf-8?B?ME1mcXhCTURvSmhaUDRmRktCeDh2NWNUMXlGaFptNkRmZ1lNT2ZuOVhyVSt0?=
 =?utf-8?B?a2xHaVpXb0M5TTN3YWNLTitzQmtpVVN2dW1LNWxGYTB3RjN1cldNVGpKK3h1?=
 =?utf-8?B?d1NWVG5pd3NGSGoyU3QySzBqOFJuS2VWMEc4d0tNUGMyKzlhT0ZkMUQ5OWhT?=
 =?utf-8?B?Y0EyaDVTcjgrcFQwR2orcnNzYlNBMUdxT2ZEMDM3T3dOZGppZVlTWkkyWlB5?=
 =?utf-8?B?NDhGSUN5MVdRWk1JQXFKMUhNRlJjT3NVMkJNRTEvSXBXL3ZIZHZ3L1dmT3NN?=
 =?utf-8?B?Y25xZS8xMm8wOFNOUDlPZ25ZaXA0VG1WMWhJTytwQlI1UVNsR2RSSlFZU21F?=
 =?utf-8?B?V2YyekZ4alBITGcrK2xsWlhLbm9QVHBFS20rR3FKSmd5eUlGTFBWd2xKcXRp?=
 =?utf-8?B?UXBZMi9PT0R1bm9BV3M4NHNiYXB6Vm55bGRDL0paUENLc1BEZFEyV2dQTzFs?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d45a629-1d5b-4ae9-a81d-08dde6a91eac
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 03:06:59.4585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CuT6XmV6Mo/THU288wq5qjsPK7/RvNdClNNHlwXWNn71ehq/DXaZBfmZQYl+42VKnlzH/U9AMr+xqNvfcSj+YzErBoR+/KlUP+jOhgAixIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6779
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDU6MDAgUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdt
YWlsLmNvbTsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwu
Y29tOw0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVz
LCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIzLzI0XSBtbTogenN3YXA6
IHpzd2FwX3N0b3JlKCkgd2lsbCBwcm9jZXNzIGENCj4gbGFyZ2UgZm9saW8gaW4gYmF0Y2hlcy4N
Cj4gDQo+IE9uIEZyaSwgQXVnIDEsIDIwMjUgYXQgNDozNuKAr1BNIEthbmNoYW5hIFAgU3JpZGhh
cg0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGlz
IHBhdGNoIG1vZGlmaWVzIHpzd2FwX3N0b3JlKCkgdG8gc3RvcmUgYSBiYXRjaCBvZiBwYWdlcyBp
biBsYXJnZQ0KPiA+IGZvbGlvcyBhdCBhIHRpbWUsIGluc3RlYWQgb2Ygc3RvcmluZyBvbmUgcGFn
ZSBhdCBhIHRpbWUuIEl0IGRvZXMgdGhpcyBieQ0KPiA+IGNhbGxpbmcgYSBuZXcgcHJvY2VkdXJl
IHpzd2FwX3N0b3JlX3BhZ2VzKCkgd2l0aCBhIHJhbmdlIG9mDQo+ID4gInBvb2wtPmJhdGNoX3Np
emUiIGluZGljZXMgaW4gdGhlIGZvbGlvLg0KPiA+DQo+ID4genN3YXBfc3RvcmVfcGFnZXMoKSBp
bXBsZW1lbnRzIGFsbCB0aGUgY29tcHV0ZXMgZG9uZSBlYXJsaWVyIGluDQo+ID4genN3YXBfc3Rv
cmVfcGFnZSgpIGZvciBhIHNpbmdsZS1wYWdlLCBmb3IgbXVsdGlwbGUgcGFnZXMgaW4gYSBmb2xp
bywNCj4gPiBuYW1lbHkgdGhlICJiYXRjaCI6DQo+ID4NCj4gPiAxKSBJdCBzdGFydHMgYnkgYWxs
b2NhdGluZyBhbGwgenN3YXAgZW50cmllcyByZXF1aXJlZCB0byBzdG9yZSB0aGUNCj4gPiAgICBi
YXRjaC4gTmV3IHByb2NlZHVyZXMsIHpzd2FwX2VudHJpZXNfY2FjaGVfYWxsb2NfYmF0Y2goKSBh
bmQNCj4gPiAgICB6c3dhcF9lbnRyaWVzX2NhY2hlX2ZyZWVfYmF0Y2goKSBjYWxsIGttZW1fY2Fj
aGVfW2ZyZWVdYWxsb2NfYnVsaygpDQo+ID4gICAgdG8gb3B0aW1pemUgdGhlIHBlcmZvcm1hbmNl
IG9mIHRoaXMgc3RlcC4NCj4gPg0KPiA+IDIpIE5leHQsIHRoZSBlbnRyaWVzIGZpZWxkcyBhcmUg
d3JpdHRlbiwgY29tcHV0ZXMgdGhhdCBuZWVkIHRvIGJlIGhhcHBlbg0KPiA+ICAgIGFueXdheSwg
d2l0aG91dCBtb2RpZnlpbmcgdGhlIHpzd2FwIHhhcnJheS9MUlUgcHVibGlzaGluZyBvcmRlci4g
VGhpcw0KPiA+ICAgIGltcHJvdmVzIGxhdGVuY3kgYnkgYXZvaWRpbmcgaGF2aW5nIHRoZSBicmlu
ZyB0aGUgZW50cmllcyBpbnRvIHRoZQ0KPiA+ICAgIGNhY2hlIGZvciB3cml0aW5nIGluIGRpZmZl
cmVudCBjb2RlIGJsb2NrcyB3aXRoaW4gdGhpcyBwcm9jZWR1cmUuDQo+ID4NCj4gPiAzKSBOZXh0
LCBpdCBjYWxscyB6c3dhcF9jb21wcmVzcygpIHRvIHNlcXVlbnRpYWxseSBjb21wcmVzcyBlYWNo
IHBhZ2UgaW4NCj4gPiAgICB0aGUgYmF0Y2guDQo+ID4NCj4gPiA0KSBGaW5hbGx5LCBpdCBhZGRz
IHRoZSBiYXRjaCdzIHpzd2FwIGVudHJpZXMgdG8gdGhlIHhhcnJheSBhbmQgTFJVLA0KPiA+ICAg
IGNoYXJnZXMgenN3YXAgbWVtb3J5IGFuZCBpbmNyZW1lbnRzIHpzd2FwIHN0YXRzLg0KPiA+DQo+
ID4gNSkgVGhlIGVycm9yIGhhbmRsaW5nIGFuZCBjbGVhbnVwIHJlcXVpcmVkIGZvciBhbGwgZmFp
bHVyZSBzY2VuYXJpb3MNCj4gPiAgICB0aGF0IGNhbiBvY2N1ciB3aGlsZSBzdG9yaW5nIGEgYmF0
Y2ggaW4genN3YXAgYXJlIGNvbnNvbGlkYXRlZCB0byBhDQo+ID4gICAgc2luZ2xlICJzdG9yZV9w
YWdlc19mYWlsZWQiIGxhYmVsIGluIHpzd2FwX3N0b3JlX3BhZ2VzKCkuIEhlcmUgYWdhaW4sDQo+
ID4gICAgd2Ugb3B0aW1pemUgcGVyZm9ybWFuY2UgYnkgY2FsbGluZyBrbWVtX2NhY2hlX2ZyZWVf
YnVsaygpLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogS2FuY2hhbmEgUCBTcmlkaGFyIDxrYW5j
aGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBtbS96c3dhcC5jIHwgMjE4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCj4gLS0t
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTQ5IGluc2VydGlvbnMoKyksIDY5IGRlbGV0aW9ucygt
KQ0KPiANCj4gVGhpcyBzZWVtcyBmaW5lIG92ZXJhbGwuIEhvd2V2ZXIsIGNvdWxkIHdlIHB1bGwg
c29tZSBkYXRhIGZyb20gdGhlDQo+IGNvdmVyIGxldHRlci4gRm9yIGV4YW1wbGUsIGV2ZW4gd2l0
aCBoYXJkd2FyZSBiYXRjaGluZywgd2UgYXJlIHN0aWxsDQo+IGltcHJvdmluZyBwZXJmb3JtYW5j
ZS4gU2luY2UgeW91ciBjb3ZlciBsZXR0ZXIgaXMgdmVyeSBsb25nLCByZWFkZXJzDQo+IG1pZ2h0
IGZhaWwgdG8gY29ubmVjdCB0aGlzIGRhdGEgd2l0aCB0aGUgcGF0Y2hlcy4NCg0KU3VyZSwgd2ls
bCBhZGQgdGhlIGRhdGEgaW4gdGhlIGNvbW1pdCBsb2cuDQoNClRoYW5rcywNCkthbmNoYW5hDQoN
Cj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0K
