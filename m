Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803A63D76;
	Fri,  4 Jul 2025 21:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751665075; cv=fail; b=bzGiwk5vZj+KOiYvpT3bR6FlnmOi99OhTe4eExDUyc0n0mtG9zenChi9dvLYBHKp42Q3YWppYl/7pLssNjlWtqTeCfZ5RyAv5yBm9nlx/62rBBluEBOamTzJ+Sqe5i0Ahc03BRj1N60eeZqi39DnvqBvLXGaXlL27mWIk6EpPQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751665075; c=relaxed/simple;
	bh=AJqhQMNNIJha2DSVUAv9EJuHJsX0pWRud0a/gioSTRg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sroJcphiryCjyzRAU9Do0QfwJT1NdtoHu5WDartvJh44YNJ1PmUd/CC6YWIzFPp1e8Xzl2m7wzR+iSvZBOSl/DvSRjUat00scQ68qIH98x94TQ6AzzZwxSnRy2Mw/xlf+iyvBzH2s3F82r2dIenBJaH3YS7HsaM/fMNEuVpzQM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5bXKWHT; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5bXKWHT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751665074; x=1783201074;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=AJqhQMNNIJha2DSVUAv9EJuHJsX0pWRud0a/gioSTRg=;
  b=g5bXKWHTvb7+WvISPROXUxgOTnbInEl5WMgS7yTigj6X2zyRyMHhy3Xg
   zcif6ogwscIECCd2kF3PG8QF1Kard8k3MCnvwGbsrqcXel3IJ4VUpNWTQ
   2C73Jfdy5i9YWL4f4gFEtWye4NRfOVuSOp+lQX2bJ4wkyQyK28SczE72W
   guaJMbjc1zJ/HOcfrEh8VPrLdpe+SgsE47a2kk+I8NbvURA3LA7hgKNtl
   u6BCtEbdYmylYuZP5VM8FrjM0rbEbQC+86ndAJxlZIsZ/XQ/SBbYrJpeM
   nmUc5cOx0ZqU9jzL6gkTvkAREsl8XhQTq1CsVOJ0DLBaV3E6F/IaQFjRE
   A==;
X-CSE-ConnectionGUID: HS5aX7W3T3aqLFd6wLT1+w==
X-CSE-MsgGUID: w+5udJCZST+LMt0GNGIunw==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="79433240"
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="79433240"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 14:37:53 -0700
X-CSE-ConnectionGUID: foDjdGEdRkiopK9xL6cpMQ==
X-CSE-MsgGUID: Htzf3JjdSqWpP9LBFamfIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="155472977"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 14:37:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 4 Jul 2025 14:37:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 4 Jul 2025 14:37:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 4 Jul 2025 14:37:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4Z66oZZt5lLJwgT+Mgo33qWdn5Lhyc13s7LAEHtelfa3+PtNdHku/jv4acf6EcXgskQgp5HIUQ0WMDiOsGict9PODS0MU9VwfOLtA/4Y6X0cGbWt6ARCjbMEjsmihyuVKH0AvLmXjdbMJwBuq/3qGK67M/WMv35j1yhsCPGXuvpsD+2bp9NWKlfZU4HgIYGatWy+tXl4iZkdYF7VyLXHgsKD9uENcuVKZlJnAO2cnzZRs8yjLQFEzmlrQU8D8xau3KOPphoR3CrPSOMiLb9boL4Sxpee7iAm3cfUF8SmiBO23UyND9/4ByxNOTfL7PtDa5ZngSllZnK6XH0A2XRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJqhQMNNIJha2DSVUAv9EJuHJsX0pWRud0a/gioSTRg=;
 b=OCtuBsYiP8X2sLPHB7A9yDdweK+8kEKtBZYOx375Pzr4pTH5ud1rC866FTehRd5ewL3M+HPp098MxX3XVR6zgTHimhQxCWjGEoS6HZurjKfFTMUS6BpL1mIxDeVTrFAJeV+y0QZjptgs+WpX5s3KF0MwQ42ORn+Fv++WESMY/a5OjBDodCZ7Q5maEqStA8r9aQOeYk/PU6c49RPS+VKRzvW80jSdANtKC+6LMYHdR9YN4RFjAgbNyebmsEzCsqU3KjS28WjsHX/bcVMHrBA8loOmMsy4a3uq+iSSh/V0Sg6pNILjIC3BRyAXQD2dlhHvQvY97bbIJXqQqT82NBEFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ5PPFF9DAC6756.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::863) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.37; Fri, 4 Jul
 2025 21:37:50 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%4]) with mapi id 15.20.8880.034; Fri, 4 Jul 2025
 21:37:49 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
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
Subject: Recall: [PATCH v10 00/25] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v10 00/25] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHb7SvjuzI/cqezh0ew2lryXHIh4g==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 17
X-FaxNumberOfPages: 0
Date: Fri, 4 Jul 2025 21:37:49 +0000
Message-ID: <PH7PR11MB8121F97D882E43A0128EB328C942A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ5PPFF9DAC6756:EE_LegacyOutlookRecall
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a452c33-c15c-4ac6-5d89-08ddbb430637
x-ms-exchange-recallreportgenerated: true
x-ms-exchange-recallreportcfmgenerated: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?EG3KmnQngMFpPFGtuhUx54XtX9vKdeoRbE/Xk0yxyauYiOLAaxaX52x08tSf?=
 =?us-ascii?Q?08XOr3hq6YXLkSytrJi2cl1U6PhD7G/gH27HYa9pJ4Cdifr/NlxO3CZjdxO/?=
 =?us-ascii?Q?/jCqd6NBlp+aD+ft0J3izz5k+j9YTOcdXpPiGtdtHKfU+cM7yh68QfIHYM1X?=
 =?us-ascii?Q?2pt4LI7HHvFdFjw7Knu1rffEnKuyEU4Rbeq5lmz0Mrakr2LNzBbIsX1juJGk?=
 =?us-ascii?Q?tgLPKrwg75c0FByJuHF19DRhX7H/6B3npoDDJ7TMW2PIp+WxaKzlPzT6B9+f?=
 =?us-ascii?Q?ZV3JmaZV+dIAnimOq2swoVvXa7nNfEFOsXSpCJbNq3GxmA18KX094c8eKOFy?=
 =?us-ascii?Q?j6R7Nt3/NwaE2y+BSqX4Kn/rsl4ObIDYxMt5slZmawyPO6LT0JdBzf1keQKb?=
 =?us-ascii?Q?uJ972hypqhtvT+x0N0bawOnd5UN5Huoa0Xsfz042ng6TXASOlkaCQ6mqV8PL?=
 =?us-ascii?Q?1vWKdu4uAKCVJi2Oe974/tsaatSFR7waXszd4Va+uD2n9mfir85JEt3M7S/m?=
 =?us-ascii?Q?WQA/jtqBqL/SH6bXp3oklh45lfVOzsof5xNxP/4ZL8fTv2Apfj32dgf21r+p?=
 =?us-ascii?Q?aV2YpLzaEtGEeZ6bSnxhTGO1H0Abv6xcGx/lOH8dyYDzqLrndhC+Z9ieUFPi?=
 =?us-ascii?Q?1rd3cpAIuTq/YzuU9bZV6MPXFMyWA9jqkAo1muAUxbjXvm6HuHbs/k2BIVud?=
 =?us-ascii?Q?eZRZh0tpnNZLUyurz5T07OzBqMNaA8UJN+9N2Ezo+2Dx8ugEwNkolk3PdV7p?=
 =?us-ascii?Q?Z7G59RFZFAJc0dPEx0vQ4SCf2XXS57drDh6+/sFrG0exudqYc5CN9YcVPTkj?=
 =?us-ascii?Q?cNGfI8Ru/6dJUrr/ks3XINHOkirqNZdnNZKG2vrgB2MQ3i4YNU7k2wCgJ71s?=
 =?us-ascii?Q?RKyqrmDUTNTiF9uotZj5bXqsF9DR8NTJHPw5W8wTbnC58j8MhSc9OwRw9vMM?=
 =?us-ascii?Q?Wk2iTa4l5RdaggGXruyQuetGkJI0xHnY+JQGuTttwpwVoyCrZ2T9nRgMWzsC?=
 =?us-ascii?Q?mTQCUnZ5A8akX2KgeTxlG1pAUSsHAsICy9U8mWZ/bXKvwOUEKo0ll0qF21vs?=
 =?us-ascii?Q?3lZonv4D8P4U7CsMxopdhFe9Ecl+6qRAe6J238i/UPI24qz5J8rPVzmj8ZLF?=
 =?us-ascii?Q?Kjli23ndmTgXAXwe6taN1KO83YB0D3Iz5y4/bQl3KMVq3AyozbOqXWMstX9f?=
 =?us-ascii?Q?fCTncD4lC7DfGAhCobcwC9kbBpncEyDCndVLC9ryDo1ssWbfAOc/RL/+jRdj?=
 =?us-ascii?Q?r+aP8bjGbWQ7pglaS+CPmjnZnLDORpbxNPx6q3hIu3L9G4DFnv0fRg2Ploy3?=
 =?us-ascii?Q?nboyoBcDMN68x3VY2v4SjjVD6rktNkAv3iPQtaDClNVD2Kv06LzYYU6Dn+3e?=
 =?us-ascii?Q?3KmxcamopGFCrZLgUxEnOCALHgIJTRnVX5lw0nA8a5lUKypCHMaP5qFmGXw7?=
 =?us-ascii?Q?oiG4cF23kiMs/fIYdmWLFr4wsoKGx0pdoQkCrYnrQ8tTzzpsBflf6Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xpStbT1fUCi4Jz9OT8+Xk4o+F4yl2dZzP19eGYb0hZiL0mlRmHn8idqZnpzl?=
 =?us-ascii?Q?71auGDDPPPAp25gFtFswhOQNKvB72yTWiz+NnXyKgAJSx/lFNOcaJvIz6ueV?=
 =?us-ascii?Q?4jzBYKOE7OADx2Yr1hfb0j4+DjemSsyiXqdvuCipyyr8hga93EWVR3E8nMq6?=
 =?us-ascii?Q?QdF3beRivUsxvE6zQ039ym+B5+evewl0lalmhNrMfyLAWiw0IN6vgHVmMUUW?=
 =?us-ascii?Q?p6A4tmDJxGzmLAXSRXo2aOZu+P0pOiL9jsgbHzywrVk5vLtSKsF6t0xG4NKO?=
 =?us-ascii?Q?L9hwqNpIMnsb/HKRGUbg0cNffHNohhs9mcRBDjam6kMASmofz2Ud4ym3m1YO?=
 =?us-ascii?Q?7mZ/ygDMd2jeHTF5sJR/E0Bfv30L0VfRmARL1WFwq2SpJxNwcGG1EP6dtn9P?=
 =?us-ascii?Q?D3Y8LFDN3w1BkIxF7mdRFQJsk4Oj4tSPcPS2036Rpjr63tLLAhgVKhvhVtQn?=
 =?us-ascii?Q?kQsSCfchIn5MbcScSZLfadNAEcK/kU//VMuomRSOHBVPpnEuNbpGLOSD+Er8?=
 =?us-ascii?Q?09Q98EgZs52RNg/Khvou+w2j6QNdPCI/lLLUqod6IsG/oH6oLNZUvOU1CitP?=
 =?us-ascii?Q?Z05J2jRqGc+8McPo2k0D0NIi68rik6guB2F0MR+nPQk/oqK70aPHSBaOAEd7?=
 =?us-ascii?Q?D8mg2dDozIvNAg9pnj5h5g4YFIkvIvl5NOJJgoSpNbkaea6LhhzZg79O902y?=
 =?us-ascii?Q?K3HCuvOX2qlebQL8Jrb/ziIsppXkhCf16iSAqRmVCob+M34JzL4eYUIEFU3H?=
 =?us-ascii?Q?ugi1KIZKr6FIml/ZQ4QII16Bm4zsWP0OFn/Obl5ASgcyy7ib1w59r9RsOio7?=
 =?us-ascii?Q?m4KfTboAtsglR9LcTb32a1kHB7X3Kn7FJhMXJUXF4XrBwRunfB1+yE2n2peB?=
 =?us-ascii?Q?IPyJ1QmrfkTSAeEXAJF/LEuvN/N1LvfzUurzyv/aDwy951JSft6AM4FNGe6V?=
 =?us-ascii?Q?3noEJ8niuC5qVvZyIz4E6KdZDR9vagu9UsFAfWw+Lpn91mlnjupbQO7F6H6n?=
 =?us-ascii?Q?gSey17Ia0309nPRydywMcBikXY4XhjDjatpd0WgaoA8NC7oH/ezwNdJ6TzhT?=
 =?us-ascii?Q?rqbOq/GVl3UbHHiux6WDBZDcXrHzmvx2a6FOLhEx18hzgRPRAZaNOykMp0DT?=
 =?us-ascii?Q?JkoNvpURaCYqjrebxdbSwO2YDrdq7SM9xk/pMyH0X54PfOUaua5nLRcJbyEN?=
 =?us-ascii?Q?/Cp6txsWSzmgHOgM0jysJ6QgPRZvAh4BjLCURregrtsQA8Y9q4sVtfkRUiZi?=
 =?us-ascii?Q?FAaHuHsP56+WKmskWqQwa/0qnuqUnuGIbcr0TGuION8xQx5iuGWhPosQzfwm?=
 =?us-ascii?Q?63lZEo/sjaf8bA2txEb8NT7/GMkOmEntPg4PoNsZ3qJlhIC5LbOQNxISYn68?=
 =?us-ascii?Q?I8znZjBLMmRuI2kMyNiwlRB4cnU+wjeg8bKch742rZJFXphIayrwbVvJUrSc?=
 =?us-ascii?Q?eKMtQgxaCVrxiCa3AoPTAiiO+UaRu529X7MvmwAPArmw//Jk8iTA/IUn+dpb?=
 =?us-ascii?Q?1S6MRapxjTCUEpQzfqI/3pyzIMzyx5mARiu432Ooeln8yOHqOuJ6yrZVJ+0k?=
 =?us-ascii?Q?H/qe1KE2HwD9zFKN5ZSsJZI7E4+xJMhfi4c9YWbyQthdLca2dY+B4bCr8gwB?=
 =?us-ascii?Q?byVawfj5iME1laY/SXLLYAOJvxr4DN03YZskp7l587jqCyLNWMv/r4oEsxt1?=
 =?us-ascii?Q?ExlDhg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a452c33-c15c-4ac6-5d89-08ddbb430637
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2025 21:37:49.7742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlUXNGWl3EXFIl9U3GSEY2MoEwfiuyPqYNbsSK0x7pCyhiW8FdGdEyrf0W/2vNvs9LwCEGbIJeYf0mMPXt/wU0IoLqxGdT+ug8CuUE309G0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF9DAC6756
X-OriginatorOrg: intel.com

Sridhar, Kanchana P would like to recall the message, "[PATCH v10 00/25] zs=
wap compression batching with optimized iaa_crypto driver".=
