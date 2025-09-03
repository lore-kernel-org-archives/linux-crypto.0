Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE635E4F8;
	Wed,  3 Sep 2025 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756922448; cv=fail; b=SzcPsOd/x7CSBDCZGIt/rjYNRP76FsfOpmq5a4rGrQw529vz0XYcXDC82SfPerpk5wQb55lI3AGPE4i+A1XNYuIG6XrbaIpmO9TYuUl0RTaDk0zzYayeMhr0EG2a0anRuQnU/ApmkfurT8qVksNvujs09XY0ZZvFWhwloYK1Ywc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756922448; c=relaxed/simple;
	bh=KN67+Gu6MD4m+GMY+X/rHFCqR6r6QhGWNdIL0jKmxRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s6JBkw+pzVzq1s0ECOL0tTq9jFv75tnBYFT0cYExJskmwqbkkp9K9H/HUgPjYlDrSTtoTjU6Ok+HWPQzXWgKhFJ10shOicZqd5lRaxVPbRzJyr7BgkZ6OKFiUEE7f0Vd/H281b29+PxuDMbuib/TWtET1pGGda0/SQUbXjZvDTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ik2UVqAM; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ik2UVqAM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756922447; x=1788458447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KN67+Gu6MD4m+GMY+X/rHFCqR6r6QhGWNdIL0jKmxRI=;
  b=ik2UVqAMFEMJx5V8vL9Ct/wLAvse3Cp1403ztlInX2AB9Kl/HG/wcdY4
   m+TAFMhFnkaBadyvhxYL/WpF9PwCI/kYFIRHjzSURHZs0BDx7NU7uDbGK
   JmVRlRGLeAkCaN4gPeMpDltzaGj9HG8gQxgWNgPakwYQ7DR0P+QcVp+fP
   n3jyQB0UO65k0RAS7jvMxDffrLyd8AR5YvgZep2Ifw12tfS4zUQmgggrm
   YRKi3hzpEmP9rWFCc3iwHE8W6stCR6FfmJjqQkZ2T8a4Xla2hY+ZOk07W
   /P72mp5eKl9quWPA3XeGPAPl/BWP+5P1+P1Z913syZ4yacbztylTNZ+90
   w==;
X-CSE-ConnectionGUID: V2oBrf8QTN6VzFRgGKWmaA==
X-CSE-MsgGUID: LcEWTbPzTbaLHl3fxUwnLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59162052"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59162052"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:00:46 -0700
X-CSE-ConnectionGUID: DQy6nmA5SH+F/wWK8lnrPg==
X-CSE-MsgGUID: PJCzU9L2RKiHvqi+7RPNEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="176889178"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:00:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:00:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 11:00:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.78)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eXH9WT5KM1ZqJhmi3jeRjo+s1FuxSNC/Qd5ZJL4Kvc1t5b9lkMi/2z+ETXFixmrOeh/iaKo6iOkj71vR08KRBtsfF0VP+paRf6Hj0SamNhyuze2ICksMHwVnnZ5AxJDBp2hCJQLOu7JPm5q5NRA5y5qloDfy6AWUWejQnU3ym/mEF0rNbbuC0DyZllTg0+v7ojiGjZHkhgkxGRd3Ksg28vnNgrCGvyVmzH28ClxytVM7P7ovxlm9c3ql++PQAhBhMqpZOHlaHy7Pg1BJNIxd43Smgcdvf/o/F3o26B0b1WK0jQKE/plApo0xov2AC549bmuI+8osTeAsXZXnB0UmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KN67+Gu6MD4m+GMY+X/rHFCqR6r6QhGWNdIL0jKmxRI=;
 b=fIoLrE13Myh7+uwkvKHzRaNIm66i3QMOiTYh8JfktRkcoDc2lp7YeSM5TLY4HmpbkMfpbfdWtFc+2xLU6jutWLIuNlRQkjKhqyt+eGO5LPb4oy0lg8K3dy0kdjydNX7IWMS5ZFgnbWp9HA9CLKY1Leim52clD+r+VZ/M+uguHXMG6sX4hkmaJhfhhLveS+V8XgwzobAq8XSlFumZxgyjKeUN5cKKlzrVpy2xGCIeqsnlLZqIZV+ULjwNJXgMwLrN/RQNsi7w24EkNQBlsfMQpqG9o27E7GU8QavidAQ0O6ZIDopUu0NnS+DfHA2v14SnUAbyqPFGOAEIDMgG9yZV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH7PR11MB6883.namprd11.prod.outlook.com (2603:10b6:510:202::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 18:00:40 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 18:00:40 +0000
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
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVggAAI1wCAATLsYIADBCAAgAAKX0CAABQZgIAANf6QgAAQ4ACAAPJPwIAA836AgAbkY3A=
Date: Wed, 3 Sep 2025 18:00:39 +0000
Message-ID: <PH7PR11MB81210004ECD59264FF37B767C901A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
 <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
 <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com>
 <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <CAGsJ_4x38iz1XmRp_j3jX-8fY8o_3RNXLx78wc3s_4-o+N0URQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4x38iz1XmRp_j3jX-8fY8o_3RNXLx78wc3s_4-o+N0URQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH7PR11MB6883:EE_
x-ms-office365-filtering-correlation-id: 9108e0c3-ce9e-4032-48c3-08ddeb13cb19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?eWFsdEtWR3RKM1kxYTlyRkZjU2ZnNCt5cnN1UWxrWUlZSGdibWwrL1pnenFp?=
 =?utf-8?B?c2ZHL3pCSEs2cmFmYUN3dXo1M1FxT2FUeHVLeXhzaHJQQTZOMzNoNVBLN2dv?=
 =?utf-8?B?THRzZFAveDB6cUV2bTNBbGNoNFJsamNhcWNwQ2hXejhJK2tlUUx2S1RQMDdx?=
 =?utf-8?B?eXZTb1ZmcUFUamZySDZacVZpcDlMbm5RdXd1blVKWEFWY2RJOTk3cmpDekdp?=
 =?utf-8?B?b2pFUWpsNFlPckMzUjFXQjZEeG1HWWtHbXYrazBTbU93UG1RQ200SWl0UEtI?=
 =?utf-8?B?a1BPSVNBekEycEhydWp3bWlQMkNiYzd6Tngyd29EaDF2TWxXVTEveXNmZUhT?=
 =?utf-8?B?OVpQeXE1QUladHdKdGp6MjZ4SWhlTHVHU09xSE1FY21udTByRzh2SFZ0ak1B?=
 =?utf-8?B?bkc2SDdIcEhJV0ZZSE53VmpZazBiNUxBY040STQ3Y25Celp3cURCNjBTSW81?=
 =?utf-8?B?eC9VNFFidWt0NmNTck1DTU92SjlOdFhUakwrSmlDQlBoZGZ0andiN3oyZ3RI?=
 =?utf-8?B?S1A1dm4ybmVGVys5REF6Nm4yM2lGK0RmNkZMN2M0eWF3TExzRkgvU3U0cmlr?=
 =?utf-8?B?c2V3L0N3SlVvRjBqUGpsUkVKbUdYMlFQSldKSTZ1NHJMOE5pNjB3cHNOb3A0?=
 =?utf-8?B?VUFCSERlS1FDMzliQk9ZaGMwRThENHJQU0ZQRUNBMms2UWxXWm5VMWNZUzla?=
 =?utf-8?B?RE9zaHZWdktwbTdLdWZrSWdoT080L1JlUVc5SGlMVmxpcDJXd2ZPb0RNSVY1?=
 =?utf-8?B?WU5nbm5uMitNOUQxdWZ2QWJGRk1MRzhZRCtMcnIyL3hETFh5TytEU3dEL1or?=
 =?utf-8?B?a1lRaVdiZHpDWFZFaXovOU9CNWdHaEc4dGJuSTJxQ3MxemRTR1FnV281bGZz?=
 =?utf-8?B?R3VjMWR0U21ibld1dTVRbnh5eXdSdkNjNVpEdUVPa2VYTENqcDIrRlh1WWFu?=
 =?utf-8?B?NXZjMGk2ZGcxTEFVT1ZkYXJDUVZFMXhBZi9UcEZVMXV0NU90eXV1ZmJrbm1v?=
 =?utf-8?B?R3lVRVZPbTJIdXMrREw4aEtFdjlrOXdlMUMvZ0xFOHE3S0tIeFlYZ1BwQWdO?=
 =?utf-8?B?SmRlTnQ5bUFDN2hOb0Q5V2JsOWVTMkR6UGFHV1doL2E4cllPSndRdzhUcGRy?=
 =?utf-8?B?YnNTbHVHL0h5UVJtdlJCUEU4cy8xY3pidUZIeFI4Q1NpZ1JXNllkYmpKUEV1?=
 =?utf-8?B?Z1BlYUVqNmFIbENyUUtiUlU3VVQ0OERTTTROMXBUODZxMTBXTFY2ek9sTHBH?=
 =?utf-8?B?MExrMzZjNEUwdFBicEJMYjBqSlhISVVPQzJzdVhrenpRODZPTkhOR3U2MTVG?=
 =?utf-8?B?YUtMVjdhR1JsOHVXMURCWERPaDMydUhra3pncVdqYWRVRDIrRCtnYU5QSno3?=
 =?utf-8?B?SmV3VWNINUpJMmdZOU82ZnhOUkR1WnRheDlPKzNMZ1I2MVlJdEsyN2o0YkdX?=
 =?utf-8?B?NW5odjZvbmpsR2drUDVSV0Y4M3BYM3pWTGU3VEM1dVdMdkl5MWxodU8wWlpV?=
 =?utf-8?B?ZFcrc2pVdEVpVUpzcUJjeU9kSWQ4STBTTHorUlU0Q1k4SVlDRm5UNzVLSFlF?=
 =?utf-8?B?YmhQRzFtaXZaOUJXWkFwZjMrTTJDdnl0ZVNkcldCOFJ6MGZKQ05BVEE0M2Q3?=
 =?utf-8?B?TWV1MHZCYVdmZnYxTGdYYXptem9zRzdWOUc3MHkrQ3ZsaGVzeHR5MHpEeXN1?=
 =?utf-8?B?UWhPbVRRMjBrNCtNc2dtb3NRbEtOV1pYMldXV1pCNVpzcHhudzhQK0hjT0tw?=
 =?utf-8?B?WmJJY0JkNytVa1pBd2N6TURMNzdEaW9obEZLQi90dzBncHlmbm12Qk9KYS85?=
 =?utf-8?B?SUtIVW5aZEdlYzNpRTdPQkVZTHVpTmVxYlhGTGdUSjRWY2NoZ0dXS2hkYjNk?=
 =?utf-8?B?eGZGZ01ZUHk0SVI3ZWdTcGVacEFyemtPMnBNeFhIMFRiUGxhZHhJZE5FeWRP?=
 =?utf-8?B?enVlb0w5Yk5xUnNmbUtTdUhBRWQyTFZsN0wvTkZ0UXhRajZIT3BSKzBZQy9X?=
 =?utf-8?B?NExEVFh5LzV3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE56Mk9jTzEyUHA5TDl6aDI1anRhNlF6N1pjQXBTcFpNRURjWnlmUVU2TFpI?=
 =?utf-8?B?OUlsUW4zYmd5VjZNTisxWVEvUm8reVVoblhCYnFsNzBleDZuOW5nSlVqZk1Q?=
 =?utf-8?B?bFRyMGtSVVdYNGVXUklZVENKSFdPTzFxZjJJZ28wMm9iYVY3Ky9JejNIOEt2?=
 =?utf-8?B?SEhja3NiZllKUXFZTFo4L2ZqU1RQVUdtVUVLcUlmQ1Q5WHFETHhPRmczQVli?=
 =?utf-8?B?c3hCdFg4VXJCWEx5cmRnM0wzMGFSdE01VkdLL2wrNWg5bDBaYkZ2cU5IbDlW?=
 =?utf-8?B?QVgzREdlNkNrQW1xSk9naVdZWElKZjUzdXU3WHNUaTBma3dXQ1M1UGF1eGFB?=
 =?utf-8?B?bkdvWmZpMTQ1eGVWS3YxMjFNV0hVSW9Rd3I2S295YjM1ZkZockp3cmluMCtI?=
 =?utf-8?B?azl4V1lqZ01PdkxXVStXMGQwOXRXZW1UUzNHbDI1RjhpbkRMMzdZZnY2VXZj?=
 =?utf-8?B?RW1yd0FWeE9zYlFVaFpvNnordEtiNkJqZTdXbTh0aEJSSEQ5VDFoSWg3YlN1?=
 =?utf-8?B?a0JFeEsvNVowcGJQT3dCYXVVSDlwUzBxNkNtWjBQTHRXaDdJNnc4MEdwcTlq?=
 =?utf-8?B?clFYbU1uQ0hTNCt2bWJacy9wVmhzc0RiNXpncUwxMXl1dVdqVCt1Uld5d090?=
 =?utf-8?B?OERqVTZPa21jLzMyL1AwY0NYVWNEZVUvZklmOGlZVVBVV1N3amVEN1hnTHEz?=
 =?utf-8?B?ZC9LT29DRFI2NFBxQko4QnNLWkU1RUNlbzUwczJvcytYb3dlcHlvM3FGaDRF?=
 =?utf-8?B?UUF3UEdGMC9DMzJpaU1Cb3BWNTd2QTIyblUyWUJoaHhhUUlyR2F1eXZtdFJl?=
 =?utf-8?B?UCs5dTlYVndadFcwSWhZOTBKeGUySDVRTXJKYzRXaFJrMlpyNndWeHovWitK?=
 =?utf-8?B?bjkwN0dEN25KOFJXT1FiVnVUMExYZUJIZE9mOFYwcUREWnhTRVZoUEZ3YStp?=
 =?utf-8?B?bVFFTkc3NGptdU1kRFFDc3J2MURxTWllY0dhNjVmdEtXYnZtVktBMUZBQ01M?=
 =?utf-8?B?T3NBcUhiMi8wanVwYVlnY3Z3T1JtQU5aSEtJUUNOOTNidkZBS1lmNkZsWFNx?=
 =?utf-8?B?c0RnRkFtTHpyN0o1OGRQZXprU0pTOW5TcXg0L2U1TEJ6M0pIdzZaOVZXTlpy?=
 =?utf-8?B?SHhETkkxR0llWFFQc3NYZ1IrYStaMmVKb2M2dXhRR1MrWUtHUEh0WGpVLzBC?=
 =?utf-8?B?Rno5cFVYVWVoaXZPMU1BbXdYYXQ0T2Y5RFZlZHV3OHhoVXpQalFKTGRlMXhE?=
 =?utf-8?B?WEV0MXN4NktuNWtOdDRkQVpYWXhkdXdmZ0NvNFJvWDRvbmludkF3V3NoenVI?=
 =?utf-8?B?d0xFTHhSN2E2a1VLK0NWTDA5OTBLbTBpRGVYRHUyamhaeUdPRitNNnlrZ0Ru?=
 =?utf-8?B?OVJRVWRNRXo4b0tEaUtwMitUY3dDVWM0Ukd0TmY0SzFheDhnMjRCNkFlWitC?=
 =?utf-8?B?RHllcGNjR0dSNWdlVlIyZzlKbkl0aFh1ZXVodnF6NlJQcjdwQlEra09vaTl6?=
 =?utf-8?B?WFNDR09ldVdLSWphdU13RVRzWWhBSXVaQnhMMzlXbjQxMnozQmw0WUhLME0y?=
 =?utf-8?B?dmc1Rkp4U1hyNkluZWpGVDVyaGU0VzB4ZkkrTGlDbTJJYjMrQVB2SWJKQXh1?=
 =?utf-8?B?VUs2RFVJNVRjN2d5d3NWVm5FcTBhaTRwdmNXMWZMYzZDZHhrZzBJaTNETURk?=
 =?utf-8?B?ZUZQRWhXU0dpeHJaUFVxeUF1V1Zlb3ZDK2VGa240dGw0aTIxT0xHOWZFTG1z?=
 =?utf-8?B?OFcwVnBMRTBQSjF0WlZzaE52bzhUWXcrV29EVk95QVROWkpvdFZhdDRwNGVD?=
 =?utf-8?B?eHJ1LzhuKzVpcFdxd2Z5WVpCTWlXa2tuYTg0Q1pPdEhoSkhQOGtRb3U2T2J1?=
 =?utf-8?B?eWZPbm1zSUhySXlHTUR1c2Z3TUUrQWY5MHJ6YkQ1aWZ2YlUzMGpidmo1NEgz?=
 =?utf-8?B?dG4wMm1TVHJmZjJxdjdiTnRPTDZYcE14Y1EvOHR5VzNwbUN3SzlOdFBFOTF4?=
 =?utf-8?B?c1NrS1djUFIxMXNYYzZpUEJDMWFnQmZhRHF5cExYdHUxRzIyMjA1OUVaWlZ4?=
 =?utf-8?B?L2w2TENtdS9nZUxrYkpGZU5LcG1jdkxFOGJqRVBuT1dIMzUyTEVHa0xtSWIz?=
 =?utf-8?B?ZHQ3b3JzbmdlTEdLTEFJZmxYS05BellBOUlrTDB0ekkvT1lxbUZUNXFaaXZJ?=
 =?utf-8?B?L3c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9108e0c3-ce9e-4032-48c3-08ddeb13cb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 18:00:40.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AzaNDpK145KCkXkX/Nr9NXosoPKu/BwGjaPYSax0HF/qLJVPZoK1SH/ifb7AK0KZu19lpn3s9/z5Uyp4LhY/9vUjRCYrUE6V0wvie8s/2Wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6883
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgQXVndXN0IDMwLCAyMDI1IDE6NDEgQU0N
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
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIyLzI0XSBtbTogenN3YXA6
IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzDQo+IGlmIHRoZSBjb21wcmVzc29yIHN1
cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gPiA+ID4NCj4gPiA+ID4gSSBhbSBub3Qgc3VyZSBJIHVu
ZGVyc3RhbmQgdGhpcyByYXRpb25hbGUsIGJ1dCBJIGRvIHdhbnQgdG8gcmVpdGVyYXRlDQo+ID4g
PiA+IHRoYXQgdGhlIHBhdGNoLXNldCBpbXBsZW1lbnRzIGEgc2ltcGxlIHNldCBvZiBydWxlcy9k
ZXNpZ24gY2hvaWNlcw0KPiA+ID4gPiB0byBwcm92aWRlIGEgYmF0Y2hpbmcgZnJhbWV3b3JrIGZv
ciBzb2Z0d2FyZSBhbmQgaGFyZHdhcmUNCj4gY29tcHJlc3NvcnMsDQo+ID4gPiA+IHRoYXQgaGFz
IHNob3duIGdvb2QgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnRzIHdpdGggYm90aCwgd2hpbGUNCj4g
PiA+ID4gdW5pZnlpbmcgenN3YXBfc3RvcmUoKS96c3dhcF9jb21wcmVzcygpIGNvZGUgcGF0aHMg
Zm9yIGJvdGguDQo+ID4gPg0KPiA+ID4gSeKAmW0gcmVhbGx5IGN1cmlvdXM6IGlmIFpTV0FQX01B
WF9CQVRDSF9TSVpFID0gOCBhbmQNCj4gPiA+IGNvbXByX2JhdGNoX3NpemUgPSA0LCB3aHkgd291
bGRu4oCZdCBiYXRjaF9zaXplID0gOCBhbmQNCj4gPiA+IGNvbXByX2JhdGNoX3NpemUgPSA0IHBl
cmZvcm0gYmV0dGVyIHRoYW4gYmF0Y2hfc2l6ZSA9IDQgYW5kDQo+ID4gPiBjb21wcl9iYXRjaF9z
aXplID0gND8NCj4gPiA+DQo+ID4gPiBJbiBzaG9ydCwgSeKAmWQgbGlrZSB0aGUgY2FzZSBvZiBj
b21wcl9iYXRjaF9zaXplID09IDEgdG8gYmUgdHJlYXRlZCB0aGUgc2FtZQ0KPiA+ID4gYXMgY29t
cHJfYmF0Y2hfc2l6ZSA9PSAyLCA0LCBldGMuLCBzaW5jZSB5b3UgY2FuIHN0aWxsIHNlZSBwZXJm
b3JtYW5jZQ0KPiA+ID4gaW1wcm92ZW1lbnRzIHdoZW4gWlNXQVBfTUFYX0JBVENIX1NJWkUgPSA4
IGFuZCBjb21wcl9iYXRjaF9zaXplDQo+ID09DQo+ID4gPiAxLA0KPiA+ID4gYXMgYmF0Y2hpbmcg
b2NjdXJzIGV2ZW4gb3V0c2lkZSBjb21wcmVzc2lvbi4NCj4gPiA+DQo+ID4gPiBUaGVyZWZvcmUs
IEkgd291bGQgZXhwZWN0IGJhdGNoX3NpemUgPT0gOCBhbmQgY29tcHJfYmF0Y2hfc2l6ZSA9PSAy
IHRvDQo+ID4gPiBwZXJmb3JtIGJldHRlciB0aGFuIHdoZW4gYm90aCBhcmUgMi4NCj4gPiA+DQo+
ID4gPiBUaGUgb25seSB0aGluZyBwcmV2ZW50aW5nIHRoaXMgZnJvbSBoYXBwZW5pbmcgaXMgdGhh
dCBjb21wcl9iYXRjaF9zaXplDQo+ID4gPiBtaWdodCBiZSA1LCA2LCBvciA3LCB3aGljaCBhcmUg
bm90IHBvd2VycyBvZiB0d28/DQo+ID4NCj4gPiBJdCB3b3VsZCBiZSBpbnRlcmVzdGluZyB0byBz
ZWUgaWYgYSBnZW5lcmFsaXphdGlvbiBvZiBwb29sLT5jb21wcl9iYXRjaF9zaXplDQo+ID4gYmVp
bmcgYSBmYWN0b3IgIk4iICh3aGVyZSBOID4gMSkgb2YgWlNXQVBfTUFYX0JBVENIX1NJWkUgeWll
bGRzIGJldHRlcg0KPiA+IHBlcmZvcm1hbmNlIHRoYW4gdGhlIGN1cnJlbnQgc2V0IG9mIHJ1bGVz
LiBIb3dldmVyLCB3ZSB3b3VsZCBzdGlsbCBuZWVkIHRvDQo+ID4gaGFuZGxlIHRoZSBjYXNlIHdo
ZXJlIGl0IGlzIG5vdCwgYXMgeW91IG1lbnRpb24sIHdoaWNoIG1pZ2h0IHN0aWxsDQo+IG5lY2Vz
c2l0YXRlDQo+ID4gdGhlIHVzZSBvZiBhIGRpc3RpbmN0IHBvb2wtPmJhdGNoX3NpemUgdG8gYXZv
aWQgcmUtY2FsY3VsYXRpbmcgdGhpcw0KPiBkeW5hbWljYWxseSwNCj4gPiB3aGVuIHRoaXMgaW5m
b3JtYXRpb24gZG9lc24ndCBjaGFuZ2UgYWZ0ZXIgcG9vbCBjcmVhdGlvbi4NCj4gPg0KPiA+IFRo
ZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGdpdmVzIHByZWZlcmVuY2UgdG8gdGhlIGFsZ29yaXRo
bSB0byBkZXRlcm1pbmUNCj4gPiBub3QganVzdCB0aGUgYmF0Y2ggY29tcHJlc3Npb24gc3RlcC1z
aXplLCBidXQgYWxzbyB0aGUgd29ya2luZy1zZXQgc2l6ZSBmb3INCj4gPiBvdGhlciB6c3dhcCBw
cm9jZXNzaW5nIGZvciB0aGUgYmF0Y2gsIGkuZS4sIGJ1bGsgYWxsb2NhdGlvbiBvZiBlbnRyaWVz
LA0KPiA+IHpwb29sIHdyaXRlcywgZXRjLiBUaGUgYWxnb3JpdGhtJ3MgYmF0Y2gtc2l6ZSBpcyB3
aGF0IHpzd2FwIHVzZXMgZm9yIHRoZQ0KPiBsYXR0ZXINCj4gPiAodGhlIHpzd2FwX3N0b3JlX3Bh
Z2VzKCkgaW4gbXkgcGF0Y2gtc2V0KS4gVGhpcyBoYXMgYmVlbiBzaG93biB0byB3b3JrDQo+ID4g
d2VsbC4NCj4gPg0KPiA+IFRvIGNoYW5nZSB0aGlzIGRlc2lnbiB0byBiZSBkcml2ZW4gaW5zdGVh
ZCBieSBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KPiA+IGFsd2F5cyAod2hpbGUgaGFuZGxpbmcgbm9u
LWZhY3RvciBwb29sLT5jb21wcl9iYXRjaF9zaXplKSByZXF1aXJlcyBtb3JlDQo+ID4gZGF0YSBn
YXRoZXJpbmcuIEkgYW0gaW5jbGluZWQgdG8ga2VlcCB0aGUgZXhpc3RpbmcgaW1wbGVtZW50YXRp
b24gYW5kDQo+ID4gd2UgY2FuIGNvbnRpbnVlIHRvIGltcHJvdmUgdXBvbiB0aGlzIGlmIGl0cyBP
ayB3aXRoIHlvdS4NCj4gDQo+IFJpZ2h0LCBJIGhhdmUgbm8gb2JqZWN0aW9uIGF0IHRoaXMgc3Rh
Z2UuIEnigJltIGp1c3QgY3VyaW91c+KAlHNpbmNlIHNvbWUgaGFyZHdhcmUNCj4gbm93IHN1cHBv
cnRzIEhXIGNvbXByZXNzaW9uIHdpdGggb25seSBvbmUgcXVldWUsIGFuZCBpbiB0aGUgZnV0dXJl
IG1heQ0KPiBpbmNyZWFzZSB0byB0d28gb3IgZm91ciBxdWV1ZXMgYnV0IG5vdCBtYW55IG92ZXJh
bGzigJR3aGV0aGVyIGJhdGNoX3NpemUgPT0NCj4gY29tcHJfYmF0Y2hfc2l6ZSBpcyBhbHdheXMg
dGhlIGJlc3QgcnVsZS4NCj4gDQo+IEJUVywgaXMgSFcgY29tcHJlc3Npb24gYWx3YXlzIGJldHRl
ciB0aGFuIHNvZnR3YXJlPyBGb3IgZXhhbXBsZSwgd2hlbg0KPiBrc3dhcGQsIHByb2FjdGl2ZSBy
ZWNsYW1hdGlvbiwgYW5kIGRpcmVjdCByZWNsYW1hdGlvbiBhbGwgcnVuIHNpbXVsdGFuZW91c2x5
LA0KPiB0aGUgQ1BVLWJhc2VkIGFwcHJvYWNoIGNhbiBsZXZlcmFnZSBtdWx0aXBsZSBDUFVzIHRv
IHBlcmZvcm0gY29tcHJlc3Npb24NCj4gaW4gcGFyYWxsZWwuIEJ1dCBpZiB0aGUgaGFyZHdhcmUg
b25seSBwcm92aWRlcyBhIGxpbWl0ZWQgbnVtYmVyIG9mIHF1ZXVlcywNCj4gc29mdHdhcmUgbWln
aHQgYWN0dWFsbHkgcGVyZm9ybSBiZXR0ZXIuIEFuIGV4dHJlbWUgY2FzZSBpcyB3aGVuIG11bHRp
cGxlDQo+IHRocmVhZHMgYXJlIHJ1bm5pbmcgTUFEVl9QQUdFT1VUIGF0IHRoZSBzYW1lIHRpbWUu
DQoNClRoZXNlIGFyZSBncmVhdCBxdWVzdGlvbnMgdGhhdCB3ZSdsbCBuZWVkIHRvIHJ1biBtb3Jl
IGV4cGVyaW1lbnRzIHRvIGFuc3dlcg0KYW5kIHVuZGVyc3RhbmQgdGhlIHRyYWRlLW9mZnMuIFRo
ZSBnb29kIHRoaW5nIGlzIHRoZSB6c3dhcCBhcmNoaXRlY3R1cmUgcHJvcG9zZWQNCmluIHRoaXMg
cGF0Y2gtc2V0IGlzIGZsZXhpYmxlIGVub3VnaCB0byBhbGxvdyB1cyB0byBkbyBzbyB3aXRoIG1p
bm9yIGNoYW5nZXMgaW4NCmhvdyB3ZSBzZXQgdXAgdGhlc2UgdHdvIHpzd2FwX3Bvb2wgZGF0YSBt
ZW1iZXJzIChwb29sLT5jb21wcl9iYXRjaF9zaXplIGFuZA0KcG9vbC0+c3RvcmVfYmF0Y2hfc2l6
ZSkuDQoNCk9uZSBvZiB0aGUgbmV4dCBzdGVwcyB0aGF0IHdlIHBsYW4gdG8gZXhwbG9yZSBpcyBp
bnRlZ3JhdGluZyBiYXRjaGluZyBmb3INCmhhcmR3YXJlIHBhcmFsbGVsaXNtIHdpdGggdGhlIGtj
b21wcmVzc2Qgd29yaywgYXMgcGVyIE5oYXQncyBzdWdnZXN0aW9uLiBJDQpiZWxpZXZlIGhhcmR3
YXJlIGNhbiBiZSB1c2VkIHdpdGggbXVsdGlwbGUgY29tcHJlc3Npb24gdGhyZWFkcyBmcm9tIGFs
bCB0aGVzZQ0Kc291cmNlcy4gVGhlcmUgYXJlIG1hbnkgZGV0YWlscyB0byBiZSB3b3JrZWQgb3V0
LCBidXQgSSB0aGluayB0aGlzIGNhbiBiZSBkb25lDQpieSBzdHJpa2luZyB0aGUgcmlnaHQgYmFs
YW5jZSBiZXR3ZWVuIGNvc3QgYW1vcnRpemF0aW9uLCBoYXJkd2FyZSBwYXJhbGxlbGlzbSwNCm92
ZXJsYXBwaW5nIGNvbXB1dGVzIGJldHdlZW4gdGhlIENQVSBhbmQgdGhlIGFjY2VsZXJhdG9yLCBl
dGMuDQoNCkFub3RoZXIgaW1wb3J0YW50IHBvaW50IGlzIHRoYXQgb3VyIGhhcmR3YXJlIHJvYWRt
YXAgY29udGludWVzIHRvIGV2b2x2ZSwNCmNvbnNpc3RlbnRseSBpbXByb3ZpbmcgY29tcHJlc3Np
b24gcmF0aW9zLCBsb3dlcmluZyBib3RoIGNvbXByZXNzaW9uIGFuZA0KZGVjb21wcmVzc2lvbiBs
YXRlbmN5IGFuZCBib29zdGluZyBvdmVyYWxsIHRocm91Z2hwdXQuIA0KDQpUbyBzdW1tYXJpemU6
IHdpdGggaGFyZHdhcmUgY29tcHJlc3Npb24gYWNjZWxlcmF0aW9uIGFuZCB1c2luZyBiYXRjaGlu
ZyB0byBhdmFpbA0Kb2YgcGFyYWxsZWwgaGFyZHdhcmUgY29tcHJlc3MvZGVjb21wcmVzcywgd2Ug
Y2FuIGltcHJvdmUgdGhlIHJlY2xhaW0gbGF0ZW5jeSBmb3INCmEgZ2l2ZW4gQ1BVIHRocmVhZC4g
V2hlbiBjb21iaW5lZCB3aXRoIGNvbXByZXNzaW9uIHJhdGlvIGltcHJvdmVtZW50cywgd2Ugc2F2
ZQ0KbW9yZSBtZW1vcnkgZm9yIGVxdWl2YWxlbnQgcGVyZm9ybWFuY2U7IGFuZC9vciBuZWVkIHRv
IHJlY2xhaW0gbGVzcyB2aWENCnByb2FjdGl2ZSBvciBkaXJlY3QgcmVjbGFpbSAocmVjbGFpbSBs
YXRlbmN5IGltcHJvdmVtZW50cyByZXN1bHQgaW4gbGVzcyBtZW1vcnkNCnByZXNzdXJlKSBhbmQg
aW1wcm92ZSB3b3JrbG9hZCBwZXJmb3JtYW5jZS4gVGhpcyBjYW4gbWFrZSBhIHNpZ25pZmljYW50
IGltcGFjdA0Kb24gY29udGVuZGVkIHN5c3RlbXMgd2hlcmUgQ1BVIHRocmVhZHMgZm9yIHJlY2xh
aW0gY29tZSBhdCBhIGNvc3QsIGFuZCBoYXJkd2FyZQ0KY29tcHJlc3Npb24gY2FuIGhlbHAgb2Zm
c2V0IHRoaXMuIEhlbmNlLCBJIGNhbiBvbmx5IHNlZSB1cHNpZGUsIGJ1dCB3ZSdsbCBuZWVkIHRv
DQpwcm92ZSB0aGlzIG91dCA6KS4NCg0KVGhhbmtzLA0KS2FuY2hhbmENCg0KPiANCj4gSeKAmW0g
bm90IG9wcG9zaW5nIHlvdXIgY3VycmVudCBwYXRjaHNldCwganVzdCBzaGFyaW5nIHNvbWUgc2lk
ZSB0aG91Z2h0cyA6LSkNCj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0K
