Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5352C23A9;
	Sat,  9 Nov 2024 01:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731114261; cv=fail; b=JCGR9pqYvd9X2U5aelGhvyfxlpMXBjbm69RuGK3zLoFEschYjh7oBb8aYc6Htky6apNqifq1NFhVoaryrDLrb0MGvPgkIg2IRlJ3OWI74JOCn0B8g39ifVQ1mE+VnlLFbfJjFJdzRL9kOVLmGAx+Ajl0grcIrrh6bg/DJytzxFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731114261; c=relaxed/simple;
	bh=k6LPou2AuRrFy2OJB1N+i8lXR0VCWwCSB1J33TDI29Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MyYRi9s7s819JoO3ij8oj4CczpoNQ/HiX4uBv6Oy4Q6/+nWRx9UKmHTPJ9p3zD8ALXcxm5BoG7eYAzsWLksErwc6u+Mn3GwZW9ZOxJdxPf76zr7Cqi2p3xug5UunggFU1SrAE/ftOE0YZ76ib0bynZfhkwWUoWFX9zO0fDiRmeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=axb5Q94F; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="axb5Q94F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731114260; x=1762650260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k6LPou2AuRrFy2OJB1N+i8lXR0VCWwCSB1J33TDI29Y=;
  b=axb5Q94FeG0Vk1fIvyM7VtcbUv8taay0qqdReZnjXW8/zKW2WeeXnCYC
   g3vUZfF3pPm16MQzX7tMCnZGSPilgaaNQQIlB5uyfEaibwof7lyGhGJJw
   OHLCuTnantqkRAqMu62t9w0/JP2LAKKubh6VUGq2bZd+uLjssnu2MSFZy
   6KWjMaz8+a+YJy/elEFcckhpEeTihRrvfMWewDNPybAzDtHF9DAeJHLbR
   Bnqd9f6PDKupnA95eWVSbvHzsKHM+1G7Ga7yHFgViSlAaEf2aH8sLW+c7
   a/QxioQzyIZbwG9URpuJSsuEVMLq++PC0naJW0WL1bPoR3jBHSuSU7bha
   g==;
X-CSE-ConnectionGUID: QmwADM4wTDigf3AEoSAL/Q==
X-CSE-MsgGUID: IL50XOtMQG+OGL5mtqOspw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31169186"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31169186"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 17:04:19 -0800
X-CSE-ConnectionGUID: psPEVVnrQOKzVpumMB+TiQ==
X-CSE-MsgGUID: 8C937gHjSDGsUZorM7VzHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="86176256"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 17:04:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 17:04:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 17:04:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 17:04:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbmeZza8xYI30T/VtQ6QA38mAIErifDuKrLVD266JZmTw1Rb8tfeMBTV+PDnjtUTKPuhxNapYySMdv3I9ym0pOtJGRliBQdvOsLUWP4FDJ26xAQG8B0s+7O2MUIICSMQLsrLm+Ek/1ixOunIppaizSDPYlrbQX0HtC6WQKtOpnu94BCveaUugW5C0Qc0q5dEj2lAiMIQG7XfH0Xc09dIHl3gwX7mMNdC5yA90SCY2IyW4VN3DlkfHPu7pZB/eqlu6WQmk83vRheBCR8NBFt04k9GuQYwnHHpy/VpvNnunNdGGhW6LSEjIyRyLYc8CcNYhdfCu1w88qC+7azaGsZNyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6LPou2AuRrFy2OJB1N+i8lXR0VCWwCSB1J33TDI29Y=;
 b=YPaeplYtUl5mg0XF0NolWmcDsmOuYU76WdLH1RGMA2zzr1AT8sMrgUjkn2LxBh4qZCloNzgM/uVBwdcrEiU0XUL4arGz2iKJiednvn9hJpyqJ0dhgJ6rEhBBMjlEyxDBzICtDBNvlWnwGFff1yMUvX8wD6Ay8dJ488cVRaGt2duxayAEfeut2G13INSXyyPavtA5lToPoyJV1N5Sz5zInxrAy9TM1DKf7NlHGk0oziNjy+HVOlg54/MU2lHF/9ZQYAZjSl8MCwP7WUnx0kRezzSvysCIUQ4v9Xcz7KW7eEKODOIrsaUKQFhtVBwuQXR6EsQBvpLUsW+8ZZbi/qVgRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Sat, 9 Nov
 2024 01:04:14 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8137.019; Sat, 9 Nov 2024
 01:04:14 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 10/13] mm: zswap: Add a per-cpu "acomp_batch_ctx" to
 struct zswap_pool.
Thread-Topic: [PATCH v3 10/13] mm: zswap: Add a per-cpu "acomp_batch_ctx" to
 struct zswap_pool.
Thread-Index: AQHbMIERFIR7MF2PLEmT/CnHutpAZbKt1yOAgABORJA=
Date: Sat, 9 Nov 2024 01:04:14 +0000
Message-ID: <SJ0PR11MB56785CF9EC244B89256CD6F6C95E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-11-kanchana.p.sridhar@intel.com>
 <CAJD7tkaWixgwXHKLar9_EFa-ooeU0zx5Q=gQW7utyokm3ARkqQ@mail.gmail.com>
In-Reply-To: <CAJD7tkaWixgwXHKLar9_EFa-ooeU0zx5Q=gQW7utyokm3ARkqQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SN7PR11MB6680:EE_
x-ms-office365-filtering-correlation-id: 415710c9-65d4-4a2d-977d-08dd005a6dce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUhoTHhXY0VkZmZZR3VXbVh0NStyUlZ2U0wzSlc4NUdPSnU0ZnJleXZvemVI?=
 =?utf-8?B?UXVDYkhMbG5BeEtVcjlUTGNrOGd1Mkl5TTZjSlhVVUlOZjhjR1JjeUJoMk1z?=
 =?utf-8?B?N1kweEZNV3I0b2owS1p6ZExRTU92aEtOTTVOdGlsVWNHUXRtTXMxMVYwdTNu?=
 =?utf-8?B?UWxpZkdOOURGQnZOcUZuc1dOaVljWWRiUENCajYwd2cvN01lS1pMK21GTjd2?=
 =?utf-8?B?K1B2VC9NVVlkOGx3bS84VllKUUhYbjdOWmNYQ2JJSkZjU3B3SlFIOHp3V3RJ?=
 =?utf-8?B?YkJuZE16L1pNNnptUnB0ZGhER1ZqTjJkSG5yOGI5Q2ZGZWZkUFZnaVdIOTZX?=
 =?utf-8?B?dGVXWTF4NXdLNnExazNWVVZoV1NtdmQ0SVY0SVdsUFNrZkhZM0FzVnNXRFBj?=
 =?utf-8?B?RStHMWw1Y3V5UGthVjl4Z1h0dW42bmljM0M3cm9VTU1FZ1Z2UDduVWZ5KzFm?=
 =?utf-8?B?MlFNQVFmQzMrU0VSaFVCRVNRSzRWelpSVVF0NWNHcFUzQk1IUm9IMkcxSEo0?=
 =?utf-8?B?RjMvOVRINTdLbnFlSTljZ0NEUkgvc2wvM3ZVSE9SejRUQzdlWktBWm9ka29Y?=
 =?utf-8?B?M1E3VTFvYWo2VWgvVzE2QjhOMGk1bzh6OWlNVGYyKzAvbTNSOXVJMVZhMkFM?=
 =?utf-8?B?Z3pJVEhxb2VIa1FhOWFVU3VGcG8vdSt1M2lLTGpaeTA2V0xFTjRiMStUTXB4?=
 =?utf-8?B?b0lkaEppZHhtSVUxVEdWZElFc3orcm1EM1JFY0dZbk1TTzZjeDZjMVYxT05Q?=
 =?utf-8?B?MVJMbE8vL0UxL2wyd2wvaEFjN2hyMVB2eXhmcHJUWkxkeXBLTy80RWpoeGc5?=
 =?utf-8?B?bnFiK0R4WkcwdXNtYXg4T3dJcVdmN0QzR3A3TDJGR0pBaTdEL0Jkc1NCUERi?=
 =?utf-8?B?N0dzWEIrd25jRS9mcUR5Um44aEN2dGFtclFZMGdPcnl5b05rSkJBRjlGTU1P?=
 =?utf-8?B?dVNIaE41aTh6SE43L0FzWk5RTG9hNW9lbXpNeE5IbUIzUkpNWThDR08zcllp?=
 =?utf-8?B?dGptTGRGMkZUUFZvSzJKOGg1SXM1dFY0NmRlTnl2L2YzNitETW9PcEt4aGtV?=
 =?utf-8?B?d2o3L1lEVmJ4bTBQajIvaWpockFFb0VUQjE5V1NRbmQ1OUljTXhkMEV5MTV1?=
 =?utf-8?B?djR6Mno0ZWY0KzV3MVZhQU8wZXhIbUZSZmNIRFc2L2dSK0F1ZmlhdGM1dFl1?=
 =?utf-8?B?OE53eW1HdWlTQmxYUkVzb3Voa09kand4Zk11NmN3QzErdnVES1VuSzBJRHN0?=
 =?utf-8?B?MXRhZWlIak55TFgzMjJ5MnI0aVlFVCtPSCtlZElnSm1Mc3YrUUpuU2tBRjgz?=
 =?utf-8?B?RDFEcFdyaFJpWmpUTTRpRnZ5K2ZXYzNoRVFXVlFGUFRWcW1vQmpkYzA2Tk9X?=
 =?utf-8?B?K2t3VDhzOXhsYjd6K3ZyQkpCdUhLRlRFOW9SL0phQS9OQTJNQjNZemFMdkpD?=
 =?utf-8?B?KzVjcytvMmdqUmludzRHeE9ieXloRmViMHdycHlWblFiWmhKRjRMM0VvOUhq?=
 =?utf-8?B?cHpvanhNMlF6dEVzTXYrV2JCRFo5SnIwUVoxbzZ1MjdzOXRhUU42TXgxanRp?=
 =?utf-8?B?UjZRTXNsTDNhZHRMMEZKTnhFUmZLOThHa1dUS1orTWZ5OTBNaGF0bjZ0bVVs?=
 =?utf-8?B?Wkx4RjdzaWQ3UFlpUkZ6R1owK1lJUHBrajBJdEF3SUpDcU9jTU5TZldJWjNL?=
 =?utf-8?B?d2FuOWdKQ21hTHQrRXcrRWtxbmJlNWNYdHhoTTZjQzNNVXB1NmdENnpycWlU?=
 =?utf-8?B?bHhiQlR4Qkp0blIrVE9qRlRwcFJ4Wm05YjZTUWsvTGVmalF1UFhaRVQ2R1NI?=
 =?utf-8?Q?A2jIP+LpbBxliySmaSqFiH+0GuYr8lfaBIlDs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHNGSXAwMGpRQ3loNkpWZG1iN25oQmVveE16b21GSGYvLzJ5dFpsSTF1NHVQ?=
 =?utf-8?B?UUxTMGFtK0VpMzA1TXFnMUErWk9rdWU2V0d3cjRvbzFFWE9JQ2JTeXU3Zm1F?=
 =?utf-8?B?VVkxMmRrc2VaY2RsVzBuc2YwQUk3aE1zVUpSd3drakhTbXMyd1BaV2I2K2lO?=
 =?utf-8?B?MHNsMEVFVjVnQnhsUmNDZzBaNkdHWlpZUDBhZEd2ZnE4YU5aQnJLN21OYXZz?=
 =?utf-8?B?RUVpMWJJMkNJMnRNZ1RlTzhqdFNDTnliYnBDekNIbEwrMGI3NmkwWFpNdkww?=
 =?utf-8?B?dGx3eEhSY1Nqckkwa1F4Vy82dFlHaGJLMHhuTDBtNDhrUWJEeFQ0S21odUxR?=
 =?utf-8?B?d2oyTVhxL1V4WEt6c3pmSmthMzF0TjU1TDlCUGFuWktibUozTFdZeGdRdmov?=
 =?utf-8?B?cXlxbW1YVlJXRzVlc3lwSnVZQVZZWkdqWmE4THhCaHlYVUoraGZkVlZYT3Rk?=
 =?utf-8?B?ejRnVFpQakVZazNJRXpKWGJsaFU5Y20veW5DRG5KSHduMXhFS3h0VG9IT0tw?=
 =?utf-8?B?M2F0SXV3VFp5eUlNcjI3NWNhd0pHUUpSWmRGdlFCRjEzUFlNZ3hqcktNZzBw?=
 =?utf-8?B?NlBmZVpNS2lkNWxuclA3dXhUUm5kanJIbDhzazFTYlp4ZVJnOTcxejR2N0RJ?=
 =?utf-8?B?T0VWZHA4bTR2bzNiQkcwWTM1bHBML2NYeitsK2FJRWIrcFM1ZjZZdVJGWWhP?=
 =?utf-8?B?OCsrTzZJSDlQNEJJVEFLUHlPNythNHpyTS9rVjVPMkZCZ1ZvTTNkNjA0bzhl?=
 =?utf-8?B?Sk5wUTJ0bkpYcVVJNjJrNGhLZlUyejJ5bmNOemp2WHorRUNNUFNCNnluNE1O?=
 =?utf-8?B?R2hVZDlaRXAyN3U5cjhiai93RkhiL3pxWmFHelpHU0ZGUElCQUEvYnY2ZUxm?=
 =?utf-8?B?VkhyTnR2a0FqaWFBQUNpNnpXanVEV0FQdXdiYkMwWUZNZFk5ZWtFRG15SjBT?=
 =?utf-8?B?alpNRG9CZnJPaStZS1o1amNUZkpyYVFBdHJmOU9GNE1uelovd0Q4NUF2RzlT?=
 =?utf-8?B?QldnMkZqZ0g0VlFGMGF2UHMvdTl6bTZYZE9ubTVSQnZUZVQzb2ZKWkxEVWNs?=
 =?utf-8?B?cDgxODRHbVdsL21RY3EweWV4azF3RHJVUVd0ZVhKR0ZtYWt5Ly9uV29NcnZU?=
 =?utf-8?B?VTB4Tkc0d29zMmN5QTJKSVBwMkxRcnVXNWh3MUNWWGo4VUJaUlNyb1dJeW11?=
 =?utf-8?B?dC9OL3ZqUkZrVWJ3T1BtRFAzSXBFSGV4TkxWTmdxMTQvQnAwalVROGZvU1ll?=
 =?utf-8?B?bFpFWkNXS2lCLzVwV1hSOHFuckUybitKWVc1bmhBK2ZtZzNES2w1bUJLSE9Y?=
 =?utf-8?B?WGZoNWlRdDFiT1MwUEJwU2dhU1ppV1d5TlZBSkdkYVFaSlovcFN2MnIvUXpS?=
 =?utf-8?B?SmNON2I4a3J3UUNqbHVuL010bTNiRzdhZ1RZYjRvMWh3SXBua2pPZFRhQWVn?=
 =?utf-8?B?YURuSzNlcm43MDFhVnlZY211R1N0Qk9rR2VTK1N1bW1nQWJmaUdmNVpDZHZu?=
 =?utf-8?B?MkNhMTNxRW5DaEk3VXcwYXh3Y2lPMXR0M2JJQ0R6MTdRNFZlVnRUME5EK2hI?=
 =?utf-8?B?MHg2SmJzbWFyTHNxNHlzQ0Z4ZjQyMWRDbXlqa2N4cFk5VjFhVDhOZWgvaUxx?=
 =?utf-8?B?UVd6eDhOeFdJS3orNW5jRFJRM0c1TGFHMmNWdVJ4Qld3ZmdseUFQeEwya2Q2?=
 =?utf-8?B?K2hQUmtITUwrL3daRFdQRDczNmFMalI4TGVzR0Y2MEtDekNtRTlNMVF1YTlU?=
 =?utf-8?B?V0dGdVNOWjRtcUVZTUpwTjcwZjV1cDdKTStsT3lwTldycUtPYlNhVng3dmdL?=
 =?utf-8?B?SVFQQkMwY0VVVENST2ZoeFhXRWx1YzBNMWtkeXV3WDV4Y2Y4OFc0MkhFREd3?=
 =?utf-8?B?eStxZ1o5Z2JkSG1zV0Juam1TN2pqTW5sVVVFcUJTR0xLSVlWOStJRkRNajM3?=
 =?utf-8?B?WlhYRVBrSWp2Ni91K2U3QW1VN0c1R3kxVGtuSWdDUkdyTER3Y2pjbngrTldm?=
 =?utf-8?B?MXBXY1B5b2pZM0tCbFRsMERDWE9YQUNTNzhqTkJyb3piUzNFOElGS05pOVgx?=
 =?utf-8?B?NDltWEVlT3BTZUEveVVGdHZwTkJSdnpVOC9UenVlUVk3bk5DenlSWVczUmhO?=
 =?utf-8?B?YTRFWlZOTDlSdFE2VVZCVlE1d2ZhSXlNMzB6RXZtT0U5UDM3Q2NqdndXUnFM?=
 =?utf-8?B?RHc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 415710c9-65d4-4a2d-977d-08dd005a6dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2024 01:04:14.5270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v/Lz+dlck6Hc1OH+apBnzIB8/yxNOEp1zXnmDOyNq0IZhLopP7Ta1rcyaD1Nxs/8/J93ujX9TFfFosxZk/+rSfGlLTpMHvhL4ltdkDCe9cM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgOCwgMjAyNCAxMjoy
MyBQTQ0KPiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVs
LmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNr
Lm9yZzsNCj4gaGFubmVzQGNtcHhjaGcub3JnOyBucGhhbWNzQGdtYWlsLmNvbTsgY2hlbmdtaW5n
Lnpob3VAbGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNA
YXJtLmNvbTsgSHVhbmcsIFlpbmcNCj4gPHlpbmcuaHVhbmdAaW50ZWwuY29tPjsgMjFjbmJhb0Bn
bWFpbC5jb207IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IGxpbnV4LWNyeXB0b0B2Z2Vy
Lmtlcm5lbC5vcmc7IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsNCj4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJuZWwub3JnOw0KPiBlYmlnZ2Vy
c0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+IDxr
cmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+OyB6YW51c3NpQGtlcm5lbC5vcmc7IEZlZ2hhbGks
IFdhamRpIEsNCj4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoIDx2
aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDEwLzEzXSBt
bTogenN3YXA6IEFkZCBhIHBlci1jcHUgImFjb21wX2JhdGNoX2N0eCINCj4gdG8gc3RydWN0IHpz
d2FwX3Bvb2wuDQo+IA0KPiBPbiBXZWQsIE5vdiA2LCAyMDI0IGF0IDExOjIx4oCvQU0gS2FuY2hh
bmEgUCBTcmlkaGFyDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4g
Pg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBhIHNlcGFyYXRlIHBlci1jcHUgYmF0Y2hpbmcgYWNvbXAg
Y29udGV4dA0KPiAiYWNvbXBfYmF0Y2hfY3R4Ig0KPiA+IHRvIHRoZSB6c3dhcF9wb29sLiBUaGUg
cGVyLWNwdSBhY29tcF9iYXRjaF9jdHggcG9pbnRlciBpcyBhbGxvY2F0ZWQgYXQNCj4gcG9vbA0K
PiA+IGNyZWF0aW9uIHRpbWUsIGJ1dCBubyBwZXItY3B1IHJlc291cmNlcyBhcmUgYWxsb2NhdGVk
IGZvciBpdC4NCj4gPg0KPiA+IFRoZSBpZGVhIGlzIHRvIG5vdCBpbmN1ciB0aGUgbWVtb3J5IGZv
b3RwcmludCBjb3N0IG9mIG11bHRpcGxlIGFjb21wX3JlcXMNCj4gPiBhbmQgYnVmZmVycyBpbiB0
aGUgZXhpc3RpbmcgImFjb21wX2N0eCIgZm9yIGNhc2VzIHdoZXJlIGNvbXByZXNzIGJhdGNoaW5n
DQo+ID4gaXMgbm90IHBvc3NpYmxlOyBmb3IgaW5zdGFuY2UsIHdpdGggc29mdHdhcmUgY29tcHJl
c3NvciBhbGdvcml0aG1zLCBvbg0KPiA+IHN5c3RlbXMgd2l0aG91dCBJQUEsIG9uIHN5c3RlbXMg
d2l0aCBJQUEgdGhhdCB3YW50IHRvIHJ1biB0aGUgZXhpc3RpbmcNCj4gPiBub24tYmF0Y2hpbmcg
aW1wbGVtZW50YXRpb24gb2YgenN3YXBfc3RvcmUoKSBvZiBsYXJnZSBmb2xpb3MuDQo+ID4NCj4g
PiBCeSBjcmVhdGluZyBhIHNlcGFyYXRlIGFjb21wX2JhdGNoX2N0eCwgd2UgaGF2ZSB0aGUgYWJp
bGl0eSB0byBhbGxvY2F0ZQ0KPiA+IGFkZGl0aW9uYWwgbWVtb3J5IHBlci1jcHUgb25seSBpZiB0
aGUgenN3YXAgY29tcHJlc3NvciBzdXBwb3J0cyBiYXRjaGluZywNCj4gPiBhbmQgaWYgdGhlIHVz
ZXIgd2FudHMgdG8gZW5hYmxlIHRoZSB1c2Ugb2YgY29tcHJlc3MgYmF0Y2hpbmcgaW4NCj4gPiB6
c3dhcF9zdG9yZSgpIHRvIGltcHJvdmUgc3dhcG91dCBwZXJmb3JtYW5jZSBvZiBsYXJnZSBmb2xp
b3MuDQo+ID4NCj4gPiBTdWdnZXN0ZWQtYnk6IFlvc3J5IEFobWVkIDx5b3NyeWFobWVkQGdvb2ds
ZS5jb20+DQo+IA0KPiBUaGlzIGlzbid0IG5lZWRlZCBpZiB0aGUgc3lzY3RsIGlzIHJlbW92ZWQg
YW5kIHdlIGp1c3QgYWxsb2NhdGUgdGhlDQo+IG51bWJlciBvZiBidWZmZXJzIGR1cmluZyBwb29s
IGluaXRpYWxpemF0aW9uLCByaWdodD8gU2FtZSBmb3IgdGhlIG5leHQNCj4gcGF0Y2guDQoNClRo
YXQncyBjb3JyZWN0Lg0KDQpUaGFua3MsDQpLYW5jaGFuYQ0KDQo+IA0KPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBLYW5jaGFuYSBQIFNyaWRoYXIgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gIG1tL3pzd2FwLmMgfCAyMiArKysrKysrKysrKysrKysrKysrKystDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvbW0venN3YXAuYyBiL21tL3pzd2FwLmMNCj4gPiBpbmRleCAwMmUw
MzExMjJmZGYuLjgwYTkyOGNmMGY3ZSAxMDA2NDQNCj4gPiAtLS0gYS9tbS96c3dhcC5jDQo+ID4g
KysrIGIvbW0venN3YXAuYw0KPiA+IEBAIC0xNjAsNiArMTYwLDcgQEAgc3RydWN0IGNyeXB0b19h
Y29tcF9jdHggew0KPiA+ICBzdHJ1Y3QgenN3YXBfcG9vbCB7DQo+ID4gICAgICAgICBzdHJ1Y3Qg
enBvb2wgKnpwb29sOw0KPiA+ICAgICAgICAgc3RydWN0IGNyeXB0b19hY29tcF9jdHggX19wZXJj
cHUgKmFjb21wX2N0eDsNCj4gPiArICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4IF9fcGVy
Y3B1ICphY29tcF9iYXRjaF9jdHg7DQo+ID4gICAgICAgICBzdHJ1Y3QgcGVyY3B1X3JlZiByZWY7
DQo+ID4gICAgICAgICBzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ID4gICAgICAgICBzdHJ1Y3Qg
d29ya19zdHJ1Y3QgcmVsZWFzZV93b3JrOw0KPiA+IEBAIC0yODcsMTAgKzI4OCwxNCBAQCBzdGF0
aWMgc3RydWN0IHpzd2FwX3Bvb2wNCj4gKnpzd2FwX3Bvb2xfY3JlYXRlKGNoYXIgKnR5cGUsIGNo
YXIgKmNvbXByZXNzb3IpDQo+ID4NCj4gPiAgICAgICAgIHBvb2wtPmFjb21wX2N0eCA9IGFsbG9j
X3BlcmNwdSgqcG9vbC0+YWNvbXBfY3R4KTsNCj4gPiAgICAgICAgIGlmICghcG9vbC0+YWNvbXBf
Y3R4KSB7DQo+ID4gLSAgICAgICAgICAgICAgIHByX2VycigicGVyY3B1IGFsbG9jIGZhaWxlZFxu
Iik7DQo+ID4gKyAgICAgICAgICAgICAgIHByX2VycigicGVyY3B1IGFjb21wX2N0eCBhbGxvYyBm
YWlsZWRcbiIpOw0KPiA+ICAgICAgICAgICAgICAgICBnb3RvIGVycm9yOw0KPiA+ICAgICAgICAg
fQ0KPiA+DQo+ID4gKyAgICAgICBwb29sLT5hY29tcF9iYXRjaF9jdHggPSBhbGxvY19wZXJjcHUo
KnBvb2wtPmFjb21wX2JhdGNoX2N0eCk7DQo+ID4gKyAgICAgICBpZiAoIXBvb2wtPmFjb21wX2Jh
dGNoX2N0eCkNCj4gPiArICAgICAgICAgICAgICAgcHJfZXJyKCJwZXJjcHUgYWNvbXBfYmF0Y2hf
Y3R4IGFsbG9jIGZhaWxlZFxuIik7DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0ID0gY3B1aHBfc3Rh
dGVfYWRkX2luc3RhbmNlKENQVUhQX01NX1pTV1BfUE9PTF9QUkVQQVJFLA0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZwb29sLT5ub2RlKTsNCj4gPiAgICAgICAg
IGlmIChyZXQpDQo+ID4gQEAgLTMxMiw2ICszMTcsOCBAQCBzdGF0aWMgc3RydWN0IHpzd2FwX3Bv
b2wgKnpzd2FwX3Bvb2xfY3JlYXRlKGNoYXINCj4gKnR5cGUsIGNoYXIgKmNvbXByZXNzb3IpDQo+
ID4gIHJlZl9mYWlsOg0KPiA+ICAgICAgICAgY3B1aHBfc3RhdGVfcmVtb3ZlX2luc3RhbmNlKENQ
VUhQX01NX1pTV1BfUE9PTF9QUkVQQVJFLA0KPiAmcG9vbC0+bm9kZSk7DQo+ID4gIGVycm9yOg0K
PiA+ICsgICAgICAgaWYgKHBvb2wtPmFjb21wX2JhdGNoX2N0eCkNCj4gPiArICAgICAgICAgICAg
ICAgZnJlZV9wZXJjcHUocG9vbC0+YWNvbXBfYmF0Y2hfY3R4KTsNCj4gPiAgICAgICAgIGlmIChw
b29sLT5hY29tcF9jdHgpDQo+ID4gICAgICAgICAgICAgICAgIGZyZWVfcGVyY3B1KHBvb2wtPmFj
b21wX2N0eCk7DQo+ID4gICAgICAgICBpZiAocG9vbC0+enBvb2wpDQo+ID4gQEAgLTM2OCw2ICsz
NzUsOCBAQCBzdGF0aWMgdm9pZCB6c3dhcF9wb29sX2Rlc3Ryb3koc3RydWN0IHpzd2FwX3Bvb2wN
Cj4gKnBvb2wpDQo+ID4NCj4gPiAgICAgICAgIGNwdWhwX3N0YXRlX3JlbW92ZV9pbnN0YW5jZShD
UFVIUF9NTV9aU1dQX1BPT0xfUFJFUEFSRSwNCj4gJnBvb2wtPm5vZGUpOw0KPiA+ICAgICAgICAg
ZnJlZV9wZXJjcHUocG9vbC0+YWNvbXBfY3R4KTsNCj4gPiArICAgICAgIGlmIChwb29sLT5hY29t
cF9iYXRjaF9jdHgpDQo+ID4gKyAgICAgICAgICAgICAgIGZyZWVfcGVyY3B1KHBvb2wtPmFjb21w
X2JhdGNoX2N0eCk7DQo+ID4NCj4gPiAgICAgICAgIHpwb29sX2Rlc3Ryb3lfcG9vbChwb29sLT56
cG9vbCk7DQo+ID4gICAgICAgICBrZnJlZShwb29sKTsNCj4gPiBAQCAtOTMwLDYgKzkzOSwxMSBA
QCBzdGF0aWMgaW50IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUodW5zaWduZWQgaW50DQo+IGNwdSwg
c3RydWN0IGhsaXN0X25vZGUgKm5vZGUpDQo+ID4gICAgICAgICBzdHJ1Y3QgenN3YXBfcG9vbCAq
cG9vbCA9IGhsaXN0X2VudHJ5KG5vZGUsIHN0cnVjdCB6c3dhcF9wb29sLCBub2RlKTsNCj4gPiAg
ICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4ICphY29tcF9jdHg7DQo+ID4NCj4gPiArICAg
ICAgIGlmIChwb29sLT5hY29tcF9iYXRjaF9jdHgpIHsNCj4gPiArICAgICAgICAgICAgICAgYWNv
bXBfY3R4ID0gcGVyX2NwdV9wdHIocG9vbC0+YWNvbXBfYmF0Y2hfY3R4LCBjcHUpOw0KPiA+ICsg
ICAgICAgICAgICAgICBhY29tcF9jdHgtPm5yX3JlcXMgPSAwOw0KPiA+ICsgICAgICAgfQ0KPiA+
ICsNCj4gPiAgICAgICAgIGFjb21wX2N0eCA9IHBlcl9jcHVfcHRyKHBvb2wtPmFjb21wX2N0eCwg
Y3B1KTsNCj4gPiAgICAgICAgIHJldHVybiB6c3dhcF9jcmVhdGVfYWNvbXBfY3R4KGNwdSwgYWNv
bXBfY3R4LCBwb29sLT50Zm1fbmFtZSwgMSk7DQo+ID4gIH0NCj4gPiBAQCAtOTM5LDYgKzk1Mywx
MiBAQCBzdGF0aWMgaW50IHpzd2FwX2NwdV9jb21wX2RlYWQodW5zaWduZWQgaW50DQo+IGNwdSwg
c3RydWN0IGhsaXN0X25vZGUgKm5vZGUpDQo+ID4gICAgICAgICBzdHJ1Y3QgenN3YXBfcG9vbCAq
cG9vbCA9IGhsaXN0X2VudHJ5KG5vZGUsIHN0cnVjdCB6c3dhcF9wb29sLCBub2RlKTsNCj4gPiAg
ICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4ICphY29tcF9jdHg7DQo+ID4NCj4gPiArICAg
ICAgIGlmIChwb29sLT5hY29tcF9iYXRjaF9jdHgpIHsNCj4gPiArICAgICAgICAgICAgICAgYWNv
bXBfY3R4ID0gcGVyX2NwdV9wdHIocG9vbC0+YWNvbXBfYmF0Y2hfY3R4LCBjcHUpOw0KPiA+ICsg
ICAgICAgICAgICAgICBpZiAoIUlTX0VSUl9PUl9OVUxMKGFjb21wX2N0eCkgJiYgKGFjb21wX2N0
eC0+bnJfcmVxcyA+IDApKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHpzd2FwX2RlbGV0
ZV9hY29tcF9jdHgoYWNvbXBfY3R4KTsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gICAgICAg
ICBhY29tcF9jdHggPSBwZXJfY3B1X3B0cihwb29sLT5hY29tcF9jdHgsIGNwdSk7DQo+ID4gICAg
ICAgICB6c3dhcF9kZWxldGVfYWNvbXBfY3R4KGFjb21wX2N0eCk7DQo+ID4NCj4gPiAtLQ0KPiA+
IDIuMjcuMA0KPiA+DQo=
