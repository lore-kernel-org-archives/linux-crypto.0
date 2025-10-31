Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA771B423B;
	Fri, 31 Oct 2025 22:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761948918; cv=fail; b=puO0lYczl6EwwwijvBtCDaX1Wma/dCjh+flXhII/ZDXfhu234zp+5xoteeUtV6s1SYh8NDY5z5a08y7GWwzfBHCwEKN28/Iq26nO+PLddg3v+IJd7doKGoqqf6xoprdFYEb1JCLmV/OPn/Uduu0pqNUQxfus9VduS/4bESNx94A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761948918; c=relaxed/simple;
	bh=cABwSOB8X3VWAj1jE5hI/ZsB0bFGCZ+cpuWhfrwu968=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIKXq7EVpR6ur1XOOCD9QZMb4xBKFA/AE8rumsPYXhMqUl9OY9uc0lrL0I6jmI1kzv1K0YD3RLeSyWzhYLhw2Od2bY1ovam65yCYBv5O0T7ix9+oPqi76rgMf+3CeBGN1sga/8lZa5+u534cRjzIzPdl0iOq1w/H96PXlwfk2+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FjFvRiOe; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FjFvRiOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761948916; x=1793484916;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cABwSOB8X3VWAj1jE5hI/ZsB0bFGCZ+cpuWhfrwu968=;
  b=FjFvRiOe3rRlGHB0J3Fu7c889CBIkXiKWLiAn0ZojBSWQkdgWWQZYPEN
   SSlh1LRFRogpXbj+tcUUi3rWBPejcxXoSM5H/CgHZpleAp8Os0NN8EX91
   RkuWEkoJS6u0RDmO9H5gZDMC9we9LwvpF88lYX0Yl4Z1GRfzNzMuVRbtb
   3RyOewYwYuWTVS/tHqCY24TDM/XbRG2y1VULwPTeVswpm2Um95GoqVjwc
   7E+o5qgBK8N6a5aM7I4F9hBwyS+VHRx598umpnSgRfBDeNRcMXD3izzHS
   FYej8pRNuw2Yg5rVGCXyZ3r+JVqtyjY9bb8pIgIqSHxo0TCBiaYMd4HNp
   A==;
X-CSE-ConnectionGUID: URM3EHQhRw+FBVSUlBq+pQ==
X-CSE-MsgGUID: KbUmK+LLQ/SkrInpM3+RCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="67976792"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="67976792"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:15:14 -0700
X-CSE-ConnectionGUID: SMfxGMI6RMyNkzembfI/bg==
X-CSE-MsgGUID: KmYqEJ7wSJW63wWJvOE4EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186008091"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:15:15 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 15:15:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 15:15:13 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 15:15:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfsdO2SvdZ2SWO07FUPKX6TyNzam8FJrB54XpHSTGAfgJWiYLfy22PWRrm11Kwl7eCIdSHEXfOaeKR1l8ey+FZZlWoILJb3QQB/K9GpqlFN42WcF8ButPiYanOz/BFSgoc8Z6l4SbhTTYlKttMy5au7xFlIWYavxe1FY0D9+ud/F+zG5hirQpwlUNE7gM8CFG9xKz5ReM3U5O/s1gdJwonCUc9xiMJUt9783/JsHO9KjtM+Y/OTJoe/rYtCbhryCUF5MSh5nOr0xYxP1lJueU1RDpkXQB30YpayR4KCYt/mAsBGda7FSo8WzMU4C1jWIhDoP4stplXWL+TNCTu8IaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cABwSOB8X3VWAj1jE5hI/ZsB0bFGCZ+cpuWhfrwu968=;
 b=yyjpaWvf+s0g09kWnkGKQW5LPnCF916ACCV6Q0YW3f6oW2bOjaDptGeff7al62C5tCAEsoWh+2i0CUJwQMmDnnjDMiY41cYq65P76Mp7AfpbhRxrlHlAaiNJsYxsdva13PmcU7xHW2B9wch+DDiLWxD/yXBPbcVRmBVM/tATIR6eS6imi8COsBqg2Gdo1wPEI4Fyn0+zTAuLBdL6FSljyosVxw7bSOXd+SSFGdaqE0pHQ9nzsXpkIg6bjlaMMA+yMPIhdyTwaWoRfbBIohafvhIUQF8r0ChSZH6rZjeECqLD9u0VbRIk1V+l2ZaW74aqAXdpTo1cS5aoRMtuany1Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CH3PR11MB8548.namprd11.prod.outlook.com (2603:10b6:610:1ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 22:15:11 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 22:15:11 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAFEmngIAAElMAgACww2CAAOmsAIAACgIwgABPXoCAAANOgIAAJp0ggBj2+5A=
Date: Fri, 31 Oct 2025 22:15:11 +0000
Message-ID: <PH7PR11MB8121779612BDD6C3A3D54959C9F8A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
 <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
 <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
 <CAKEwX=NT_3QJSQGRgogGYmx_M262O+F4Hs9BtbCUqK3qbh+t8g@mail.gmail.com>
 <PH7PR11MB8121663B9F5A2210B8431C9FC9E9A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121663B9F5A2210B8431C9FC9E9A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CH3PR11MB8548:EE_
x-ms-office365-filtering-correlation-id: 92714c40-46ea-41ce-71b0-08de18caf570
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RjVyY09IMVRaZ2dFSkV2RldtOEFXTEs5b3FqY05VVGNIeEV3M3lDKzF0WXZN?=
 =?utf-8?B?SGxHdmh0MXVVNlBMZkV2cmtJbG9JYjV6b3lyaTV4d1VkTmpHbUExemZDTHcy?=
 =?utf-8?B?U1RmemtqVGxGK3Y2cmRkUFlhWG9VeE1pcm8vaWs1MXVKWlVzQURDaTdMMXhB?=
 =?utf-8?B?SGM4NyswdTFuMWxhQUtWcnNNbzhyK3pxS0NIQlRLNHhQWERTN255RGJwMXBz?=
 =?utf-8?B?QXFmL05sRDdDdXVTbTNQOUFsMjRnVS9hek1CSzUwMlpGcW03NUJBWDF5ZXg3?=
 =?utf-8?B?UHFZNk5BZzI5YlFNWWNVQnU4WlY2ejBBV3NTazZSTGdST01FNUw0djBYQmpx?=
 =?utf-8?B?Z3pwc0lvZEoyVDF0VVkwYlE1UVdIYTU1dXJwd3hSZ3BQd3VUK3VjbXV2RTRI?=
 =?utf-8?B?NkRrL3YrVWVGSVVUVEdTUHFYRWIveUhEM01WNkRybktvUXozazJ0SmNacDdY?=
 =?utf-8?B?ejF6U3E3MzAyN0FpVlNoRDJPZHBVUHlMYVZPOGFXOFVlSFVDcGtMMVhkbk1m?=
 =?utf-8?B?RVhEQVcwd2V6MDd4c3RVVzZVSWdOTUJVanlLQTRGVG9xOTJGcWpITTM5LzlE?=
 =?utf-8?B?N1lCNDFCdFVXc0xnNE4vNjNvb2w0M1Z5Sm5GRWk2aTltWm1yVkxwZ3Buak1W?=
 =?utf-8?B?b0VKVTMyQ3JPamY0dUNsVm5IQUc5VTgveTgrZHdVbWM3OGNVeFR5clJZb0pi?=
 =?utf-8?B?VGIwY3prd28wTXBQd2xiZGR6MG5XUG5MVVlZM0NZL29vd2p2aklGdEUxTlY2?=
 =?utf-8?B?N0NVb2kzK2hucjNRclRFbHN4S2VzWDlsZzFYOCtaVmVDL0U3RlI1b2dQMnhI?=
 =?utf-8?B?dm0xemdIZnNvMDcxRkZFYm1zWVd2S3ZNZW4vVkRLdmMvQ3hRN2hScGhDcTl6?=
 =?utf-8?B?M1NUT2dxazg3NjNONExNVEk3c1NzS096ZnhRWkJCVXphcXM2dnhlRkpaandG?=
 =?utf-8?B?Si8zZERYcUh6MHJreTJtSDRuclVwNHUyaW9MQmViY1Fkd1N5a3hzVm8xVWhL?=
 =?utf-8?B?RGVod0JhMXJ2MTNHb2o4TWpOTXVFZU5mbU9CNFR2R0l1a2p4Z1FDdTJXZUZy?=
 =?utf-8?B?N2lxZWpFc1hjRlE2WmNFV0ExaFl1TUhKLzI1Njh0RHFId0E1NGNuelBYOEtX?=
 =?utf-8?B?c0s1cUJCUFVWZTJVU2NaREJVRFdoemltK0JvcndEQUQ3QXJGWlY2U0NaM3do?=
 =?utf-8?B?K2duQ1B1Z3FqTEhQVnlQVCs1aVMvWndWR1JpSUV1cVUyLzJCLzVXbzZPU2NO?=
 =?utf-8?B?NFYzNGttSE0vZytMV2dEWUNyMzkzdmtINHpnUno1MVp1MXVjSUJabFBraWh2?=
 =?utf-8?B?NU1wbEpkdUVJN2JOZU5wQ212dUNmOGZ1UndRMzJ5VWtldHFFL0RkR29nQVc2?=
 =?utf-8?B?STlKTTFPNmRvVWJGVFZBR0IwOXIxTWtvUWZPcTFZTEZIMmhnQ3dYRUg5VHZs?=
 =?utf-8?B?YjJhZXRYcnZYTzFBVFFUUlMvYU05aVo1eVpJMXR1TENGVnhUNGtkd3M0eVZN?=
 =?utf-8?B?OHczYk5FcThIOExKeU9ReHV6Z0JRbVBZL0podVR4eVhjM3Nib2VMZTFmSWFv?=
 =?utf-8?B?dnJZMUY2ZGRtSHVQMFAxV1VlRUlXdzdyUUpMNVJFbnNUWkUxQTJEeHMxdmxC?=
 =?utf-8?B?UHA2Nm1FUFlxYjc4M2Y3dWRqMUZFWjZzcGdSYXhUVTRsRkZLcGlrRWowd2ht?=
 =?utf-8?B?VWNORmRCYWtPaFJST0QvcnZMV2ljU09oeVNJbzRiWnp6aXorcGovYnRzeTdK?=
 =?utf-8?B?K0Joc3JOMHJxYzZvVXY2SG1iYkVBTnpBbytNV1lTc2FZbm1oeGlBZG1DU3dH?=
 =?utf-8?B?cWRHTlhZb09oYkNHejFyR0pnQlRsNG85WEJCMlBOdFdnTmVMSGhacVh3aTB5?=
 =?utf-8?B?aDFOMXYyanNHTVVCOUFoWjFWMjdPb25QcW9meDU0M05DMzk4OHM2bGtKd2VB?=
 =?utf-8?B?cmNGRWdKcU5qeGVqdTJBTDdyZkhaeStWTkt6VWpkQnFLRlFXVTZIOVBxdFow?=
 =?utf-8?B?R0hramJxRE9WNFlQT2RqVjFmT0tHYStEREVrMkFKK01YS1Z3WEVHVjd3OW54?=
 =?utf-8?Q?U9oyTj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHQ1cnFZd2dEL1pnbjV0UUdPQmJJeC9iR0dnbU9BMnhFNmlTT01nSnMyWVkw?=
 =?utf-8?B?N3E2M3dSUDQwalR0WmZvN21rMkI2NFU2K281SlByTWF2SmpPSEhDOUZZbEsw?=
 =?utf-8?B?OWlkM1E3RUMzaHphd3V1U0JEbkVzdEZncmdQTkZBdFBCQldaNkFTZnZUYVRS?=
 =?utf-8?B?dVZxOVFybzdmSEdyOEJVY20vMDNkVlhqWGJoc1dGTDJqT2hseUVOUnVRaGI5?=
 =?utf-8?B?V20xWmxacGVuTmZGZFZwK2k2dkpwdFBkOGJMM1lpWlV0cGU5bDkxb21ZaWZq?=
 =?utf-8?B?eGxwc09keE4zRTRnb1RvR3d5dHQwVWtWSk8rZiswWGJ2czAydzVPUmQzYjM0?=
 =?utf-8?B?WjhiSVM1VXo1dk1lbDkzZWxldGNveHZ2SC9IdXEzMjVPOGFoSndYeWRNYXlx?=
 =?utf-8?B?MFdQYmNPRUhxenkvbEpEamhvRU5oZ2ZoQTBqaFdLbTZDd1Q0RHdxMktxeERu?=
 =?utf-8?B?YXFnc0hpa0M2SE9SMGRrZXNBaE4zd1hxMFlxSU5kcjJyWk91MUNJS0tYTG1W?=
 =?utf-8?B?bzcvdmR5YTdKZmZPOUp5MStoQjBpSlJDNG1lc0F1Rk92TUFOWFI4OWJ5NUpn?=
 =?utf-8?B?U2JibFhnU3hkSERsczZJb0lmSWM4V0NVRlpPbzdhaWJjdEZiZWozRkQ1Rzcx?=
 =?utf-8?B?RERvWGNVbEczVEVYSGMvamh1Y0NqcURDUXJzN2o3NWgveFJLam54M0svOFdl?=
 =?utf-8?B?cDZEYlVENklDVkdhM08yM0lRNUtQWHRMbzlKSFA0RHVkR2xQWFFETGtiNjh5?=
 =?utf-8?B?ZE1UVlA2SXJuUDBlZEt5R0pOMnpoZDN4dThDb2FuTTZWSmgxZ1JwRk92bU4v?=
 =?utf-8?B?dDNWRlF5M0FaNFo3UXRZUTZ4bW5wQlJzNEdqS3BzSEFYVmdUazI4RWcrcTVz?=
 =?utf-8?B?STJ2NkdTQXhVOHVZOGJ6OUNkTFcxS1RjSUJyTlFONXlFUHkwTlJaSy9yNTd6?=
 =?utf-8?B?M2tjOTI0dDh3eks0WU5zeWthZVppdXZxZjhKNDQvTXZpbVhKRGc5QTJFeUY4?=
 =?utf-8?B?d3dzOVE2V1BoYkxjV2QrTmNNRDJkT3hrdFUrOU5scmNYeDlLZkV0NjJNZVpx?=
 =?utf-8?B?WWJQdzRoQzhLbTFDWDVualJ5RmlkY09abTdTWjF0TDVKTGlna0s1dWkwSUIv?=
 =?utf-8?B?MVdudDJyb1piVHVhUzBtY2tialZnTkN0V2tXRjJ1aWRERkYvS3ViNkI1cmgw?=
 =?utf-8?B?UGE2ZHVyZzRXZCtOV0FNOUNIcUt6TnM2NU9MdnZSMnpDRXFaL2RCNzBUdFYr?=
 =?utf-8?B?Q2UxQ2ljZjJQQzlZK0EwTHhJV2wzQm9TN1pkNnp2OWFyTzV5eHlnTkY1am90?=
 =?utf-8?B?cUlvMjZrQmNEUDJSOEEwVkM3c0dsMVZGU3pDeEgvZTlKM2FiS0VGVTNvMnV3?=
 =?utf-8?B?bTdjQkppVDIxbEIxUlVUSDlSTzRyeittWmF3dU9Oc005RWE2dktaSENTb1Yx?=
 =?utf-8?B?MnYyKzVMZ2RRWkRoY3QzaEZ1QURpRUU1TTMzUFJnUDRhRUw5NUZYWEUrUjlH?=
 =?utf-8?B?Unhud0VPRFRQK3Yyd0ErSkdUVEZxTmllNlBaS0JtZGp6cHhFYlc1OUgxeFRE?=
 =?utf-8?B?Yk40QjBCdlNPYmZ2QmJsNzdQaFVrRXBGWUhvQW9tZ0U2MFNZZVVnaHBSLzBl?=
 =?utf-8?B?Y2xreUR1RzZneXZIajRwR1pUd2VsTmRPMVVxUEhPZDFKK3UxZlZrcU8yQzIy?=
 =?utf-8?B?VGNsbFgwYkJoRDhtK2E2SVNoS285b3pnOEJzK1ZJdG9ZTzNhbDQ4YXV2WjU0?=
 =?utf-8?B?SkFrVUZkRElDZmo3OEhGM20walRnT1JjOWxHRE5JOERtWG5yYWl2VnRKcWlJ?=
 =?utf-8?B?eGxWS2IzQnBUVTlnc1ArTjRacXZOY2UrYzE4aDM5ZjczdU5yUXlaOW5MWjhv?=
 =?utf-8?B?NzVqTzNOUHk0Q2JyNDBNb1grcXdScHpsS2hsdHFRMDVid0tacGV6NVU1RzRP?=
 =?utf-8?B?cTJkcGxsbTF1S0RyREsyR2UyL3l4ZXlDcFJzZUJjekVqR0s1OFM1YVBXVnZu?=
 =?utf-8?B?Qm05cFpCcUNjMXF3Y1cxZHVrc2c1dSthWU04bHlmV3d3RDdGNWVCb0xpQlM0?=
 =?utf-8?B?R252UjFtWlQ5VGtHQmdwRUE3d3FtMnFldi9NTjBodno2QThMaW5CY1BzZDdJ?=
 =?utf-8?B?bjNkckk2V2UrVWtpZ2dDQThXZ1lRN01Ub0xVbFhub0Uzc3NSMUluYVNiaGZ4?=
 =?utf-8?B?OUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 92714c40-46ea-41ce-71b0-08de18caf570
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 22:15:11.2839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+nY1VCvYk2794qdNdDhOoBVYOPsQpKX+7U7GUSs3PoiUvoxQg5qewRRjjcf4opW0xDJwuPedBjLrKB7n0EZsHLsjXwUpBaq8E9RNczWJJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8548
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNyaWRoYXIsIEthbmNoYW5h
IFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0
b2JlciAxNSwgMjAyNSA1OjU3IFBNDQo+IFRvOiBOaGF0IFBoYW0gPG5waGFtY3NAZ21haWwuY29t
PjsgWW9zcnkgQWhtZWQNCj4gPHlvc3J5LmFobWVkQGxpbnV4LmRldj4NCj4gQ2M6IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gaGFubmVzQGNtcHhj
aGcub3JnOyBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5j
b207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5odWFu
Z0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gc2Vub3po
YXRza3lAY2hyb21pdW0ub3JnOyBzakBrZXJuZWwub3JnOyBrYXNvbmdAdGVuY2VudC5jb207IGxp
bnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcu
YXU7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGNsYWJiZUBiYXlsaWJyZS5jb207IGFyZGJAa2Vy
bmVsLm9yZzsNCj4gZWJpZ2dlcnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdvb2dsZS5jb207IEFjY2Fy
ZGksIEtyaXN0ZW4gQw0KPiA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZp
bmljaXVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+Ow0KPiBGZWdoYWxpLCBXYWpkaSBLIDx3
YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsIFZpbm9kaA0KPiA8dmlub2RoLmdvcGFs
QGludGVsLmNvbT47IFNyaWRoYXIsIEthbmNoYW5hIFANCj4gPGthbmNoYW5hLnAuc3JpZGhhckBp
bnRlbC5jb20+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjEyIDIyLzIzXSBtbTogenN3YXA6IHpz
d2FwX3N0b3JlKCkgd2lsbCBwcm9jZXNzIGENCj4gbGFyZ2UgZm9saW8gaW4gYmF0Y2hlcy4NCj4g
DQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogTmhhdCBQaGFt
IDxucGhhbWNzQGdtYWlsLmNvbT4NCj4gPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTUsIDIw
MjUgMzozNiBQTQ0KPiA+IFRvOiBZb3NyeSBBaG1lZCA8eW9zcnkuYWhtZWRAbGludXguZGV2Pg0K
PiA+IENjOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29t
PjsgbGludXgtDQo+ID4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3Jn
OyBoYW5uZXNAY21weGNoZy5vcmc7DQo+ID4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2Ft
YWFyaWY2NDJAZ21haWwuY29tOw0KPiA+IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdt
YWlsLmNvbTsNCj4gPiB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnOw0KPiA+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgc2pAa2VybmVsLm9y
Zzsga2Fzb25nQHRlbmNlbnQuY29tOyBsaW51eC0NCj4gPiBjcnlwdG9Admdlci5rZXJuZWwub3Jn
OyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
Y2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJuZWwub3JnOw0KPiA+IGViaWdnZXJzQGdvb2ds
ZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPiA8a3Jpc3Rl
bi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzDQo+IDx2aW5pY2l1cy5nb21l
c0BpbnRlbC5jb20+Ow0KPiA+IEZlZ2hhbGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRl
bC5jb20+OyBHb3BhbCwgVmlub2RoDQo+ID4gPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+ID4g
U3ViamVjdDogUmU6IFtQQVRDSCB2MTIgMjIvMjNdIG1tOiB6c3dhcDogenN3YXBfc3RvcmUoKSB3
aWxsIHByb2Nlc3MgYQ0KPiA+IGxhcmdlIGZvbGlvIGluIGJhdGNoZXMuDQo+ID4NCj4gPiBPbiBX
ZWQsIE9jdCAxNSwgMjAyNSBhdCAzOjI04oCvUE0gWW9zcnkgQWhtZWQgPHlvc3J5LmFobWVkQGxp
bnV4LmRldj4NCj4gPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBXZWQsIE9jdCAxNSwgMjAyNSBh
dCAxMDoxNToxMlBNICswMDAwLCBTcmlkaGFyLCBLYW5jaGFuYSBQIHdyb3RlOg0KPiA+ID4NCj4g
PiA+IEkgYW0gYWdhaW5zdCBpbmNyZWFzaW5nIHRoZSBzaXplIG9mIHN0cnVjdCB6c3dhcF9lbnRy
eS4gT24geDg2XzY0LCB0aGVyZQ0KPiA+ID4gaXMgYSAzIGJ5dGUgaG9sZSBhZnRlciAncmVmZXJl
bmNlZCcuIFdlIGNhbiB0ZWNobmljYWxseSB1c2UgdGhhdCwNCj4gPiA+IGFsdGhvdWdoIHRoZSBu
b2RlIGlkIGlzIHVzdWFsbHkgYW4gaW50LCB3aGljaCBpcyA0IGJ5dGVzIG9uIHg4Nl82NC4NCj4g
PiA+DQo+ID4gPiBJbiBwcmFjdGljZSwgSSB0aGluayAyIGJ5dGVzIChpLmUuIHNob3J0KSBzaG91
bGQgYmUgZW5vdWdoLCBidXQgaXQgd2lsbA0KPiA+ID4gYmUgdWdseSB0byBjYXN0IHRoZSBub2Rl
IGlkIHRvIGEgc2hvcnQuIFdlIHNob3VsZCBhdCBsZWFzdCBXQVJOIG9uDQo+ID4gPiBvdmVyZmxv
dy4NCj4gPg0KPiA+IENhbiB3ZSBwYWNrIGxlbmd0aCBhbmQgcmVmZXJlbmNlZCB1c2luZyBiaXQg
ZmllbGRzPyBJIGFzc3VtZQ0KPiA+IGNvbXByZXNzZWQgbGVuZ3RoIGNhbm5vdCBleGNlZWQgMl4z
MSAtIDE/IDopDQo+ID4NCj4gPiBTbywgc29tZXRoaW5nIGFsb25nIHRoZSBsaW5lIG9mOg0KPiA+
DQo+ID4gc3RydWN0IHsNCj4gPiAgICAgdW5zaWduZWQgaW50IGxlbmd0aDozMTsNCj4gPiAgICAg
Ym9vbCByZWZlcmVuY2VkOjE7DQo+ID4gfQ0KPiA+DQo+ID4gVGhhdCB3YXksIHdlIHNhdmUgdXAg
YW5vdGhlciA0IGJ5dGVzIGhvbGUsIHdoaWNoIGNhbiBiZSByZXB1cnBvc2VkIGZvcg0KPiA+IHRo
ZSBub2RlJ3MgaWQuDQo+ID4NCj4gPiBEb2VzIHRoYXQgd29yaz8gSSdtIG5vdCB2ZXJ5IGV4cGVy
aWVuY2VkIHdpdGggdGhpcyBtYWdpY2tlcnkgLSBwbGVhc2UNCj4gPiBmYWN0IGNoZWNrIG1lIDop
DQo+ID4NCj4gPg0KPiA+ID4NCj4gPiA+IE9yIHdlIGNhbiB0YWtlIHRoZSBzaW1wbGUgcm91dGUg
YW5kIGRyb3AgdGhlIGJ1bGsgYWxsb2NhdGlvbi4NCj4gPg0KPiA+IE9yIHRoaXMgOikNCj4gDQo+
IFRoYW5rcyBOaGF0IGFuZCBZb3NyeSwgZm9yIHNoYXJpbmcgdGhlc2UgY29uc3RyYWludHMgYW5k
IGlkZWFzLg0KPiBTdXJlLCBJIHdpbGwgc2VlIGlmIEkgY2FuIHVzZSB0aGUgYml0IGZpZWxkcyBh
cHByb2FjaCBhbmQgd2lsbCBtYWtlIHN1cmUNCj4gdG8gbm90IGluY3JlYXNlIHRoZSBzaXplIG9m
IHN0cnVjdCB6c3dhcF9lbnRyeS4gSWYgdGhpcyBkb2Vzbid0IHdvcmsNCj4gZm9yIHNvbWUgcmVh
c29uLCB3ZSBoYXZlIHRoZSBzaW1wbGUgcm91dGUuDQoNCkhpIE5oYXQgYW5kIFlvc3J5LA0KDQpJ
IGhhdmUgYmVlbiBhYmxlIHRvIGdldCB0aGUgYml0IGZpZWxkcyBhcHByb2FjaCB3b3JraW5nLCBh
cyB5b3Ugc3VnZ2VzdGVkLg0KVGhlIHNpemUgb2YgInN0cnVjdCB6c3dhcF9lbnRyeSIgaXMgdW5j
aGFuZ2VkIGF0IDU2IGJ5dGVzIHdpdGggdGhpcyBjaGFuZ2UNCmFuZCB0aGUgYWRkaXRpb24gb2Yg
dGhlICJpbnQgbmlkIiBmaWVsZC4NCg0KenN3YXBfbHJ1X2FkZCgpL2RlbCgpIHVzZSB0aGUgZW50
cnktPm5pZC4NCg0KSSBhbSBhYmxlIHRvIGNvbnRpbnVlIHVzaW5nIGttZW1fY2FjaGVfYWxsb2Nf
YnVsaygpIHRvIGJlbmVmaXQgYmF0Y2hpbmcNCnBlcmZvcm1hbmNlLg0KDQpJIHdpbGwgaW5jbHVk
ZSB0aGlzIGluIHYxMyB0aGF0IEkgZXhwZWN0IHRvIHBvc3Qgd2l0aGluIGEgY291cGxlIG9mIGRh
eXMuDQoNClRoYW5rcyENCkthbmNoYW5hDQoNCg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLYW5j
aGFuYQ0K
