Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C5B2500AA;
	Tue,  3 Dec 2024 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733185852; cv=fail; b=b9TRYPob3WwkO1XF+BvsWgQrGRw0uJ+XqI8CFc09Lu69V9eeEftnFDmg3Ah5S+8Rp+VzwRRPllpFSXX07wFIM4941cnZ7XR6Nk6rwb+PUmGYreoIwG3P09k/gguDhCEr5J7DN10s1lb9Bu+RAgPh40zSE3gSY6lDoIqD9dOL6Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733185852; c=relaxed/simple;
	bh=3j0XJqzxDBgXYqqbmykvEGy6C6bZNsLktyZncYkACH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DlU5n1vVzmRextpEjTxjrqK6OR9FzJWou/tA3B0wxg9sDWr+H9mo/Khj2Ht9qFxx4uyqPDb//idVJdjK8/277P7IqvPhZ5mikgiJrNe37buF6TglprzErPOQqFeI/GdOuWxho3Jd0HY/5hY7YhFrlssfNZHBieGz2VsxRBKRk1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BA5F5OpR; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BA5F5OpR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733185850; x=1764721850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3j0XJqzxDBgXYqqbmykvEGy6C6bZNsLktyZncYkACH8=;
  b=BA5F5OpRx+j92ezYNnadTrIIolbj4rjOG6fEObiPmWRET4dUokCe9Y3z
   Ah//wI9GlDNed2LYvsQBrYDxd4sR6C1s5GQprcDbDGfMxd5HSoaBMx3FV
   BKszFtLtFY8sTewP5tWvI6D2xPMwT2Zj4GIj7mIv8MNT85XB0HxafUco0
   Y+61lYf+IC4/4lbcaZUm4fu0cyEaEsyYaXXYv7M2NVbkDbk+5cLa/U6dT
   6xFbqvAQ2/h5yPKMGoaFAwPEdVXZ+CznNOA2i1AYS7MlW4u0a+sQRLMT9
   1gBqFOjevCcXbWlKGCpL7Hqw7MxEehO5pFikrEsxMpfpr+BMT/Fa/Ev39
   Q==;
X-CSE-ConnectionGUID: D3KgpJjTRyebeN6mOIkjJQ==
X-CSE-MsgGUID: vMqMyTSyR4y8F8y6cerppQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="43990299"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="43990299"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 16:30:49 -0800
X-CSE-ConnectionGUID: My77wf/7RBWT6aRuIGcXfQ==
X-CSE-MsgGUID: fRC/OfOKTailMOUPabalgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98281890"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Dec 2024 16:30:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Dec 2024 16:30:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Dec 2024 16:30:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Dec 2024 16:30:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IoZ05szZTZ2WQgY2nYnLnJD3JntEoEeMxYsliPTEG7C+Ql8Le591EWoYG4rAQjCP7+xsCRz93bP3NFsKcGWqr6flMK0REYHWUJwVqTKsTa4FaZblJCuTr0zWDDi+6n4YWWBHSk/0Y4ZHAOQX8aYs9iuvBW/+SujdmrK9LJYgFjzYZ3w9xuklm0FXMm5O1U7KPe00hxE9o/0SpYtwMSaAsf7hzH4GDZjk61nAc8duIWxyWTacoWcfHmelOqN/teAoA7yV6aFdAV4YwXzoOUe3Fr4v5fvVXOsLqxlQGSbyfiU/qTI8nQMXDSU0gI1cybISSYYckZLV+pIkBQ3Z+zZHMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3j0XJqzxDBgXYqqbmykvEGy6C6bZNsLktyZncYkACH8=;
 b=VHCZzJmyDDcH7qRjae+AeJ/62ibwsQx3J1UJXpXujHrDTdLN68w6XzsjIhH/kaGA0CmwbprZBFpiEkf0yuddLYQvXj2+phAHs6kez0hkHG9z3s+/WZKYNv5M7ISVPMQ8Fms2ZtEV+v6JSyfAeAc07ncguY9QNj696iWkjoKPBfZd+XA6IWpRWllG7k41z5NTc3k+zdw58dBYODsMrPFl5YCqDPY7CcsMMKJNvsYv5rFHX78UsROy3ARbpABvg5JL4hEX1hm3eiVnT4C9AJp2WTEVdQ59B6Ahcfu8aIj/r53t9G1ZWsPmtZ1W6WAt/EBOK132p4k9SXxfL4ZKzQJutg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by IA1PR11MB6098.namprd11.prod.outlook.com (2603:10b6:208:3d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Tue, 3 Dec
 2024 00:30:31 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 00:30:30 +0000
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
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaA=
Date: Tue, 3 Dec 2024 00:30:30 +0000
Message-ID: <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
In-Reply-To: <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|IA1PR11MB6098:EE_
x-ms-office365-filtering-correlation-id: 86304b26-d6bf-48b3-a61d-08dd1331b178
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0hyWDNIdW5pbG83bFo5TmgwQzVkWXRpWDdCYnhnRUJqRHNoSTZKZHlManpN?=
 =?utf-8?B?aTF5ZG1GM3pyTXlhdjNKSHhsK0lMM0JMMWFod0JQWnl1dHJ2emhORmxYZjNY?=
 =?utf-8?B?VlYyZ0dIcWxybnpReElvKzMwUk12blNPOG4wOERXTG82dzlDK1QyeHdmTFRv?=
 =?utf-8?B?c2lmREFDZWtiMjlheVVTVWZCWm1JRWUrTDlmMUswWWI4c2p3UzBiT3JBQnVI?=
 =?utf-8?B?UG01TGpjRUFXQlJBbkNxS2RNZVE5WDJHV1UxS0lkM1BqRGtKZ3Z5UUgzQVhx?=
 =?utf-8?B?MlBZMGhna3lxWW9zN3RJb0Z2SDk4cW1oL3RWM3djOE1ZcFBsR3pibjNlZU4z?=
 =?utf-8?B?azl3ZENTWmpBWmhLdHVVY3o0NnhLYmtaMDhtYTA3Rm1MNmlLSmx4MkxZNkZm?=
 =?utf-8?B?M3AzaFJEeXBvdmc5c3M1dEx2NGJ3KzVnbXJjVlF1NEg2eWVHNWtDMW4wNUZD?=
 =?utf-8?B?RjlGZCttOGVqNDU3bXovZjhJR2hMbHNzcW9zSk5GeTB4Q1Yzd0JaelZzMGNk?=
 =?utf-8?B?Q3lBZ05BVjJRVTFOUldRblEvME5iT29NcVRGRytvU0pIL3ZDYzIraUM2dFV6?=
 =?utf-8?B?VnBteW5iRmRoVE1QYWZiR1NXRUo1T2FMdTV1QzMvc3NieGZKVXBpK1Z6bi91?=
 =?utf-8?B?L2RtcTFYVzB5NWJUN1RldGlKaGF6WGZIU09sWlovMGM0ZjVaa1ZXK09tQ0hp?=
 =?utf-8?B?ZitaZWJmUmkrZ1lPZ2grOVN6ZWxqTEJTMG5xcTQ1STh1aWRZMG40NjREdkhH?=
 =?utf-8?B?QTJ4bFo4c0dXSXJZYXdVUk9GNlozS2ZoQ0paQitRby80clo0TDRyNEk0M0ZV?=
 =?utf-8?B?UXl5RzEweWFoOUx6V3ZkSjZ0emRIU2JwTENwcUpkOEsyZ2xDakMzWEo3UkJK?=
 =?utf-8?B?a3RURjFpNkdUSjhFQzZJOFhIVlVCNE1wTFdNeXpGUTEzcFRSMUlCWFJibkZi?=
 =?utf-8?B?Sk9HM2FJaFR0R1FiY25nSnIrWmRkL0QxRmFXT2JEdWlydi9xZlhadHZwVnRR?=
 =?utf-8?B?K0N2b3puKzhqQWRpVTYyWU4yOEZyMy9qcWJwOGdxWTQ1em5BZjVmMGtLWTBx?=
 =?utf-8?B?Yk44RjJpQWduYTdZY1BaTjNJMlFPN2t6dlhzbVZ5Q0Z3dCtic09HMDQ4WFp3?=
 =?utf-8?B?M1AyQSsvVHB2OHpFdEM5SEZZV2NEa1RVTVpkTjdLZjZiRDMyVi9OazlHOWg4?=
 =?utf-8?B?SWhXbStuQSt3cmFRNmNMcGlQa0J5RGh2dm5oNUh0dk1FQjRibE1Fa0c3MHR2?=
 =?utf-8?B?YjkwZjF5VVUyL1QxbzdieWlwYUk2QUpFUUVpOXZRNmJHckJTaVdvVXhxUUsx?=
 =?utf-8?B?NTdnRi9wd0R4WlV3NE1SbVdJczg0YjZQVHQvSzl1RUJwSFI1MGZxMUdDa00z?=
 =?utf-8?B?dWhpNWc1N3Z4bVVCc1YxdzRNSDlUK1JtY2x5NmJCVzdGWmxQT3pJbGZVZGpS?=
 =?utf-8?B?VW9BcTNIakMxekZOOXVUZ1NPZ1NxWFlXQlkzS3JXbmpqVHEvcGdmd015cUJN?=
 =?utf-8?B?WUVaRzU2aVR1YWlveU1mY2pQK21lK0p3M0hlOGI4UWRIVy9IZk82Z0ppQkFO?=
 =?utf-8?B?Tnh4QmE4dHFDMnJiRGNYL0FFWmdsazRkYkptaHVkM2NXbUtDYXkraENXV1F5?=
 =?utf-8?B?VENvOW43Yy9PS0NNbGlhLytLMTViQWk5SUpseVU0aVg2SVk2THBNR3RXU3Vz?=
 =?utf-8?B?UUp1ejRuczQwbDd2MW55aU5TWFBWSmVYQWJrSWlBdGVJMWx4RmVzYlZMbm81?=
 =?utf-8?B?Sk9WVXloQlp1aVg3UjBRQnpTWjJ5cEtsNG93QUhRUHZlUm5oWDZ5SGxac1F4?=
 =?utf-8?B?b2xsUCtGUmlRclZmaW40ekhyUE9DZ3hiTTF6ekFIckxKTDdhVENJOVMxVVAv?=
 =?utf-8?B?US9uMU1mTnUxVnFvQ1IzLzEzc1d1Y1lrMS9ZOEpFKzRkcVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZldIVlV5MUNqT1lMcTdiWHlQZ3BwcmFESHN1T01sMkVpYnZzeGkyRXhsT2Ns?=
 =?utf-8?B?UGQ2NmZ5Z0xlaHhla0QzRGVyOVNrLzcvbkxQeHhXY09zbXRmWHVGY1ZZbVpK?=
 =?utf-8?B?SHpKbGV3aEUzd253LzVJOEowMEkrY3paTlFhWGVvYlZOWHpxUFhmWWc2ZjhY?=
 =?utf-8?B?V0ZWTmJ0Z1ZBZjNrYmx2V2lYMUt5Qll6WDhxWHl1Mm5VaEszZUVnNVZOWGdK?=
 =?utf-8?B?MlpNVnRHNkJDNGVQMmxRZEwzYzRMSzBTdW5MaG9xV20wUjNucHJsRFdBRUti?=
 =?utf-8?B?YnlTU0MwR0FVdHlFZXRxdFU2Wnd0UEY1d0tzZCtpRXRCT3c4SWkyMXdjeDZz?=
 =?utf-8?B?enZ5MUVhYlR5RjFZdkt5cm1RR3RueDIwWjNJOTJNK1Y2MmRXdTFqSzZ3Ymhz?=
 =?utf-8?B?TzdKYzVhU2NyZkRFUGlRdVRsRHo0cUNFaVI0UmdMM1pjRTZVZldFRzY4cm9H?=
 =?utf-8?B?UTVTaEdxamcxUzBDcFUwMklXV3NMRmFXMWlCNGlCUitYOXN3d0NZYXJ4QytN?=
 =?utf-8?B?cHRyWEgyTkhxUEh3M2loYTkwNWsveUl6MkRHc1R0SkJsUUh1UFJ6TW52QW13?=
 =?utf-8?B?RXB2Y2E2QWJ4SzE2NlBFL3F5WWlOYXN3K0lzTnlKQlhPdFA4VURYbmgyZjNC?=
 =?utf-8?B?TnpsSHRoSitKeXFUMDNRRU51NnFtcGFPck4vcG1zek1hMXhtOHFVaklWK2pv?=
 =?utf-8?B?T1d3NHdkMG81Uy9xcHQ4L3owdkZIM0o0TkdrMmRqbXFCNmk0RDErS3BNcGYy?=
 =?utf-8?B?c05JQnhXR0w4MkVCL0p1RVl1Q1FjYUNHMFVsYmFsZ0ZrSU5BL1JJTmxXcGtn?=
 =?utf-8?B?QmN6aWxtU3RYcDVoRFBPOWQ0WnIwNXl0TE80K2paL0RsWDBiRXpzdGVSdFM2?=
 =?utf-8?B?MFZWQmxqaUFJRlNzNHRZVFpzSXg4bCtwTDZFR1NvR1loTGwxSHUxeTQycU13?=
 =?utf-8?B?ZkJMbkpXTllUYzFldWtkNkwwcDlYQmFJOXpLR2R6QjZqK2lJWGtFWnNKdktG?=
 =?utf-8?B?anU4clVlWGdlckJtZ0hBWERJeTM2Y0RKLzNseld0WWV0L3NOZWN2c3JlSVc1?=
 =?utf-8?B?MlNJK002V1hpdDYzRHVvK241SXBvY2pGRXNTY2JNM3VqMmFLWitGeG5aa1BD?=
 =?utf-8?B?VEVyMlA5SUlTTEhuWXZmc1pYb2JIL3Q0Ri9XbjdpcnBNTEJHYUxaV0t1R1hn?=
 =?utf-8?B?azNML2Y5QythVHM1Y3I3TENzY1E2aGJYaGxTbzF1L2grZmo1aEhqQ3NVcUFu?=
 =?utf-8?B?UGJNSDNNaDFHcEdxSTRUM2kvN2VhQW1JWkxNRW1ZcFQxWXNScTFVOEU5MDRN?=
 =?utf-8?B?M0syTm0xZlVOOFNsczBTNGxpSjgwNjF6V1RBR3FuWGx5bnFzOUxsdGJNUDBD?=
 =?utf-8?B?aFhCVUJiQ3l5OEdod0JOaHNWRmpnKzIySFpqRUFUOHZRRllDbEdzWXV6RDdD?=
 =?utf-8?B?K1B3eGx3WXVTNVF5QW43bkFuSEVzVncvTStMYWFxVFJOWDNaRGcxUWxQdEhK?=
 =?utf-8?B?dFBWMHlQTzFid2FWa2ppOUF4WXFGdWFHZ0ZPdjZTcXAvNHo0Mnk2M0UzUk1k?=
 =?utf-8?B?NXlmaXp0NXpNalRPaDdzOHRvU2YvZzFydjgrRjYwWXhiMHJaRytWK2ovWm14?=
 =?utf-8?B?MGIxMUljRTRhUVpQYkNtTEJ2YTdLSGVrOXYrYjdOZktZSGJzWGJIZ2lsWWUx?=
 =?utf-8?B?bTB0QURWa0VtSm90MDFhb0J1NWdzb29KVlJ4ZStyTXRCWlZiQ3ZpM1BZTmhK?=
 =?utf-8?B?cm10bjhiUEg4UnBZYXNRVksvei9MUUdlMlAwRE82QlZhSHBSNU4rV0dxUlJI?=
 =?utf-8?B?d05YNmlEVG1YbytYOUIyU2lNMVpKb1pkY09Wd2NWUTlLa2JwKzF0WVhpRVZm?=
 =?utf-8?B?STdjWjgzRVFCcS84SEs5M2s0NzJaczkrSE9PYUxzWjAxVm1wK0JrR01BbUk4?=
 =?utf-8?B?NEF5ZFNCL0pmaVRLNU5VT3FNcWtuZlZUVm9hem5JN0V5elE1U25zK3pFTFo4?=
 =?utf-8?B?YjU0akZSMXhMTzBCN1RUR1JudzM4c2R3VHorbUtyRGZhb2pidjJjUVNZZjIr?=
 =?utf-8?B?bGpHVzNqVjdwNDEvdk5sb1NKNWoyS1hlVmlNY09UcWhsSThockllUCsxTmZL?=
 =?utf-8?B?LzIvZ3NrN1QyNHJiSm0zQ1B0S1pRL2ZtY1ViQWQ4WW5XdmxVWjRtN1FHTDI2?=
 =?utf-8?B?K0pxRnNPQjlnM1NWNDBNUzBVQ2wvYnh0RUNZMm03RndTWStsL2hEbkxBU3FY?=
 =?utf-8?B?cE5JQkZBdzZoM2daMmc1dmljYXVnPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 86304b26-d6bf-48b3-a61d-08dd1331b178
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 00:30:30.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w2G/XoHI7Bscr4AQ7pF+rFCkez+t16ybP8Y4vrchth4NeVm0sFRUKmyBdlFxI5SGYqNmSDj7z84sT2DS8HH0hir/4gCajP4vTMQ+4KVB+2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6098
X-OriginatorOrg: intel.com

SGkgTmhhdCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaGF0IFBo
YW0gPG5waGFtY3NAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDIsIDIwMjQg
MTE6MTYgQU0NCj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBp
bnRlbC5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBr
dmFjay5vcmc7DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnlhaG1lZEBnb29nbGUuY29tOw0K
PiBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207DQo+IHJ5
YW4ucm9iZXJ0c0Bhcm0uY29tOyB5aW5nLmh1YW5nQGludGVsLmNvbTsgMjFjbmJhb0BnbWFpbC5j
b207DQo+IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5l
bC5vcmc7DQo+IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsNCj4gY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29n
bGUuY29tOw0KPiBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDIDxrcmlzdGVu
LmMuYWNjYXJkaUBpbnRlbC5jb20+Ow0KPiBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hh
bGlAaW50ZWwuY29tPjsgR29wYWwsIFZpbm9kaA0KPiA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAwOS8xMF0gbW06IHpzd2FwOiBBbGxvY2F0ZSBwb29s
IGJhdGNoaW5nIHJlc291cmNlcyBpZg0KPiB0aGUgY3J5cHRvX2FsZyBzdXBwb3J0cyBiYXRjaGlu
Zy4NCj4gDQo+IE9uIEZyaSwgTm92IDIyLCAyMDI0IGF0IDExOjAx4oCvUE0gS2FuY2hhbmEgUCBT
cmlkaGFyDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+
IFRoaXMgcGF0Y2ggZG9lcyB0aGUgZm9sbG93aW5nOg0KPiA+DQo+ID4gMSkgTW9kaWZpZXMgdGhl
IGRlZmluaXRpb24gb2YgInN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4IiB0byByZXByZXNlbnQgYQ0K
PiA+ICAgIGNvbmZpZ3VyYWJsZSBudW1iZXIgb2YgYWNvbXBfcmVxcyBhbmQgYnVmZmVycy4gQWRk
cyBhICJucl9yZXFzIiB0bw0KPiA+ICAgICJzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCIgdG8gY29u
dGFpbiB0aGUgbnIgb2YgcmVzb3VyY2VzIHRoYXQgd2lsbCBiZQ0KPiA+ICAgIGFsbG9jYXRlZCBp
biB0aGUgY3B1IG9ubGluaW5nIGNvZGUuDQo+ID4NCj4gPiAyKSBUaGUgenN3YXBfY3B1X2NvbXBf
cHJlcGFyZSgpIGNwdSBvbmxpbmluZyBjb2RlIHdpbGwgZGV0ZWN0IGlmIHRoZQ0KPiA+ICAgIGNy
eXB0b19hY29tcCBjcmVhdGVkIGZvciB0aGUgcG9vbCAoaW4gb3RoZXIgd29yZHMsIHRoZSB6c3dh
cA0KPiBjb21wcmVzc2lvbg0KPiA+ICAgIGFsZ29yaXRobSkgaGFzIHJlZ2lzdGVyZWQgYW4gaW1w
bGVtZW50YXRpb24gZm9yIGJhdGNoX2NvbXByZXNzKCkgYW5kDQo+ID4gICAgYmF0Y2hfZGVjb21w
cmVzcygpLiBJZiBzbywgaXQgd2lsbCBzZXQgIm5yX3JlcXMiIHRvDQo+ID4gICAgU1dBUF9DUllQ
VE9fQkFUQ0hfU0laRSBhbmQgYWxsb2NhdGUgdGhlc2UgbWFueSByZXFzL2J1ZmZlcnMsIGFuZA0K
PiBzZXQNCj4gPiAgICB0aGUgYWNvbXBfY3R4LT5ucl9yZXFzIGFjY29yZGluZ2x5LiBJZiB0aGUg
Y3J5cHRvX2Fjb21wIGRvZXMgbm90DQo+IHN1cHBvcnQNCj4gPiAgICBiYXRjaGluZywgIm5yX3Jl
cXMiIGRlZmF1bHRzIHRvIDEuDQo+ID4NCj4gPiAzKSBBZGRzIGEgImJvb2wgY2FuX2JhdGNoIiB0
byAic3RydWN0IHpzd2FwX3Bvb2wiIHRoYXQgc3RlcCAoMikgd2lsbCBzZXQgdG8NCj4gPiAgICB0
cnVlIGlmIHRoZSBiYXRjaGluZyBBUEkgYXJlIHByZXNlbnQgZm9yIHRoZSBjcnlwdG9fYWNvbXAu
DQo+IA0KPiBXaHkgZG8gd2UgbmVlZCB0aGlzICJjYW5fYmF0Y2giIGZpZWxkPyBJSVVDLCB0aGlz
IGNhbiBiZSBkZXRlcm1pbmVkDQo+IGZyb20gdGhlIGNvbXByZXNzb3IgaW50ZXJuYWwgZmllbGRz
IGl0c2VsZiwgbm8/DQo+IA0KPiBhY29tcF9oYXNfYXN5bmNfYmF0Y2hpbmcoYWNvbXApOw0KPiAN
Cj4gSXMgdGhpcyBqdXN0IGZvciBjb252ZW5pZW5jZSwgb3IgaXMgdGhpcyBhY3R1YWxseSBhbiBl
eHBlbnNpdmUgdGhpbmcgdG8gY29tcHV0ZT8NCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLiBU
aGlzIGlzIGEgZ29vZCBxdWVzdGlvbi4gSSB0cmllZCBub3QgdG8gaW1wbHkgdGhhdA0KYmF0Y2hp
bmcgcmVzb3VyY2VzIGhhdmUgYmVlbiBhbGxvY2F0ZWQgZm9yIHRoZSBjcHUgYmFzZWQgb25seSBv
biB3aGF0DQphY29tcF9oYXNfYXN5bmNfYmF0Y2hpbmcoKSByZXR1cm5zLiBJdCBpcyBwb3NzaWJs
ZSB0aGF0IHRoZSBjcHUgb25saW5pbmcNCmNvZGUgcmFuIGludG8gYW4gLUVOT01FTSBlcnJvciBv
biBhbnkgcGFydGljdWxhciBjcHUuIEluIHRoaXMgY2FzZSwgSSBzZXQNCnRoZSBwb29sLT5jYW5f
YmF0Y2ggdG8gImZhbHNlIiwgbWFpbmx5IGZvciBjb252ZW5pZW5jZSwgc28gdGhhdCB6c3dhcA0K
Y2FuIGJlIHNvbWV3aGF0IGluc3VsYXRlZCBmcm9tIG1pZ3JhdGlvbi4gSSBhZ3JlZSB0aGF0IHRo
aXMgbWF5IG5vdCBiZQ0KdGhlIGJlc3Qgc29sdXRpb247IGFuZCB3aGV0aGVyIG9yIG5vdCBiYXRj
aGluZyBpcyBlbmFibGVkIGNhbiBiZSBkaXJlY3RseQ0KZGV0ZXJtaW5lZCBqdXN0IGJlZm9yZSB0
aGUgY2FsbCB0byBjcnlwdG9fYWNvbXBfYmF0Y2hfY29tcHJlc3MoKQ0KYmFzZWQgb246DQoNCmFj
b21wX2N0eC0+bnJfcmVxcyA9PSBTV0FQX0NSWVBUT19CQVRDSF9TSVpFOw0KDQpJIGN1cnJlbnRs
eSBoYXZlIGEgQlVHX09OKCkgZm9yIHRoaXMgY29uZGl0aW9uIG5vdCBiZWluZyBtZXQsIHRoYXQg
cmVsaWVzDQpvbiB0aGUgcG9vbC0+Y2FuX2JhdGNoIGdhdGluZyB0aGUgZmxvdyB0byBnZXQgdG8g
enN3YXBfYmF0Y2hfY29tcHJlc3MoKS4NCg0KSSB0aGluayBhIGJldHRlciBzb2x1dGlvbiB3b3Vs
ZCBiZSB0byBjaGVjayBmb3IgaGF2aW5nIFNXQVBfQ1JZUFRPX0JBVENIX1NJWkUNCiMgb2YgYWNv
bXBfY3R4IHJlc291cmNlcyByaWdodCBhZnRlciB3ZSBhY3F1aXJlIHRoZSBhY29tcF9jdHgtPm11
dGV4IGFuZCBiZWZvcmUNCnRoZSBjYWxsIHRvIGNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVzcygp
LiBJZiBzbywgd2UgcHJvY2VlZCwgYW5kIGlmIG5vdCwgd2UgY2FsbA0KY3J5cHRvX2Fjb21wX2Nv
bXByZXNzKCkuIEl0IHNlZW1zIHRoaXMgbWlnaHQgYmUgdGhlIG9ubHkgd2F5IHRvIGtub3cgZm9y
IHN1cmUNCndoZXRoZXIgdGhlIGNyeXB0byBiYXRjaGluZyBBUEkgY2FuIGJlIGNhbGxlZCwgZ2l2
ZW4gdGhhdCBtaWdyYXRpb24gaXMgcG9zc2libGUNCmF0IGFueSBwb2ludCBpbiB6c3dhcF9zdG9y
ZSgpLiBPbmNlIHdlIGhhdmUgb2J0YWluZWQgdGhlIG11dGV4X2xvY2ssIGl0IHNlZW1zDQp3ZSBj
YW4gcHJvY2VlZCB3aXRoIGJhdGNoaW5nIGJhc2VkIG9uIHRoaXMgY2hlY2sgKGFsdGhvdWdoIHRo
ZSBVQUYgc2l0dWF0aW9uDQpyZW1haW5zIGFzIGEgbGFyZ2VyIGlzc3VlLCBiZXlvbmQgdGhlIHNj
b3BlIG9mIHRoaXMgcGF0Y2gpLiBJIHdvdWxkIGFwcHJlY2lhdGUNCm90aGVyIGlkZWFzIGFzIHdl
bGwuDQoNCkFsc28sIEkgaGF2ZSBzdWJtaXR0ZWQgYSBwYXRjaC1zZXJpZXMgWzFdIHdpdGggWW9z
cnkncyAmIEpvaGFubmVzJyBzdWdnZXN0aW9ucw0KdG8gdGhpcyBzZXJpZXMuIFRoaXMgaXMgc2V0
dGluZyB1cCBhIGNvbnNvbGlkYXRlZCB6c3dhcF9zdG9yZSgpL3pzd2FwX3N0b3JlX3BhZ2VzKCkN
CmNvZGUgcGF0aCBmb3IgYmF0Y2hpbmcgYW5kIG5vbi1iYXRjaGluZyBjb21wcmVzc29ycy4gTXkg
Z29hbCBpcyBmb3IgWzFdIHRvDQpnbyB0aHJvdWdoIGNvZGUgcmV2aWV3cyBhbmQgYmUgYWJsZSB0
byB0cmFuc2l0aW9uIHRvIGJhdGNoaW5nLCB3aXRoIGEgc2ltcGxlDQpjaGVjazoNCg0KaWYgKGFj
b21wX2N0eC0+bnJfcmVxcyA9PSBTV0FQX0NSWVBUT19CQVRDSF9TSVpFKQ0KICAgICAgICAgenN3
YXBfYmF0Y2hfY29tcHJlc3MoKTsNCmVsc2UNCiAgICAgICAgIHpzd2FwX2NvbXByZXNzKCk7DQoN
ClBsZWFzZSBmZWVsIGZyZWUgdG8gcHJvdmlkZSBjb2RlIHJldmlldyBjb21tZW50cyBpbiBbMV0u
IFRoYW5rcyENCg0KWzFdOiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGlu
dXgtbW0vbGlzdC8/c2VyaWVzPTkxMjkzNw0KDQo+IA0KPiA+DQo+ID4gU1dBUF9DUllQVE9fQkFU
Q0hfU0laRSBpcyBzZXQgdG8gOCwgd2hpY2ggd2lsbCBiZSB0aGUgSUFBIGNvbXByZXNzDQo+IGJh
dGNoaW5nDQo+IA0KPiBJIGxpa2UgYSBzYW5lIGRlZmF1bHQgdmFsdWUgYXMgbXVjaCBhcyB0aGUg
bmV4dCBndXksIGJ1dCB0aGlzIHNlZW1zIGENCj4gYml0IG9kZCB0byBtZToNCj4gDQo+IDEuIFRo
ZSBwbGFjZW1lbnQgb2YgdGhpcyBjb25zdGFudC9kZWZhdWx0IHZhbHVlIHNlZW1zIHN0cmFuZ2Ug
dG8gbWUuDQo+IFRoaXMgaXMgYSBjb21wcmVzc29yLXNwZWNpZmljIHZhbHVlIG5vPyBXaHkgYXJl
IHdlIGVuZm9yY2luZyB0aGlzDQo+IGJhdGNoaW5nIHNpemUgYXQgdGhlIHpzd2FwIGxldmVsLCBh
bmQgdW5pZm9ybWx5IGF0IHRoYXQ/IFdoYXQgaWYgd2UNCj4gaW50cm9kdWNlIGEgbmV3IGJhdGNo
IGNvbXByZXNzaW9uIGFsZ29yaXRobS4uLj8gT3IgYW0gSSBtaXNzaW5nDQo+IHNvbWV0aGluZywg
YW5kIHRoaXMgaXMgYSBzYW5lIGRlZmF1bHQgZm9yIG90aGVyIGNvbXByZXNzb3JzIHRvbz8NCg0K
WW91IGJyaW5nIHVwIGFuIGV4Y2VsbGVudCBwb2ludC4gVGhpcyBpcyBhIGNvbXByZXNzb3Itc3Bl
Y2lmaWMgdmFsdWUuDQpJbnN0ZWFkIG9mIHNldHRpbmcgdGhpcyB1cCBhcyBhIGNvbnN0YW50LCB3
aGljaCBhcyB5b3UgY29ycmVjdGx5IG9ic2VydmUsDQptYXkgbm90IG1ha2Ugc2Vuc2UgZm9yIGEg
bm9uLUlBQSBjb21wcmVzc29yLCBvbmUgd2F5IHRvIGdldA0KdGhpcyBjb3VsZCBiZSBieSBxdWVy
eWluZyB0aGUgY29tcHJlc3Nvciwgc2F5Og0KDQppbnQgYWNvbXBfZ2V0X21heF9iYXRjaHNpemUo
c3RydWN0IGNyeXB0b19hY29tcCAqdGZtKSB7Li4ufTsNCg0KdG8gdGhlbiBhbGxvY2F0ZSBzdWZm
aWNpZW50IGFjb21wX3JlcXMvYnVmZmVycy9ldGMuIGluIHRoZSB6c3dhcA0KY3B1IG9ubGluaW5n
IGNvZGUuIA0KDQo+IA0KPiAyLiBXaHkgaXMgdGhpcyB2YWx1ZSBzZXQgdG8gOD8gRXhwZXJpbWVu
dGF0aW9uPyBDb3VsZCB5b3UgYWRkIHNvbWUNCj4ganVzdGlmaWNhdGlvbiBpbiBkb2N1bWVudGF0
aW9uPw0KDQpDYW4gSSBnZXQgYmFjayB0byB5b3UgbGF0ZXIgdGhpcyB3ZWVrIHdpdGggYSBwcm9w
b3NhbCBmb3IgdGhpcz8gV2UgcGxhbg0KdG8gaGF2ZSBhIHRlYW0gZGlzY3Vzc2lvbiBvbiBob3cg
YmVzdCB0byBhcHByb2FjaCB0aGlzIGZvciBjdXJyZW50DQphbmQgZnV0dXJlIGhhcmR3YXJlLg0K
DQpUaGFua3MsDQpLYW5jaGFuYQ0KDQo=
