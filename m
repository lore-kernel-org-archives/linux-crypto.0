Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9133C1B2
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 05:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768368421; cv=fail; b=CSMD5z/eSCbNYM5eNvD1OwykmvcjeDYSGnOVdP+FGOLTSS1eZqH85CHjetAfFvrFsMlZ5K/9SrG8zlNcJLKEoaj/ys+dhgYZi1cP+MKLoGOhtHlPSJj2Ye1yMcNh1+bK1t9Mvq1PNNMv7RhBXqyxbgz4YBsT890V430vyfqW2+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768368421; c=relaxed/simple;
	bh=321yAZd1+fU1g2izavf7ik5xsPzR7+embNgyGohqPww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UVKgJjkrG6Vcd0QP9YqIs63H7gm0JYriU7s4Efff6s6iDHJYXZnQBGqWyV8xjUjGW6LztY7RxVQYtyaf/w5e333+P/kujaz/sOzR662Fy2PC2VkHjOhprMoADr0xI04f1hgaff3x6OgpCNzE7ySkmUQfHSV9Bqx7GckGlRP92V8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cwcGApuh; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cwcGApuh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768368417; x=1799904417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=321yAZd1+fU1g2izavf7ik5xsPzR7+embNgyGohqPww=;
  b=cwcGApuhkgUgcxAFqMrQ1ohu8JxaqsNAKDaJSR6kiJ9xlAFYD4gtNy8u
   xSLETQIgStkEovXg+5PHiwkjwDFSqdP/aZWOdrsbMUhTrIne0rTFAD0RY
   cZ3zjPKx9okKCzXjYBTqUAkMzeVCj7UGYh7B/DhHADH0GtPYe+7C3wJol
   C1dvGx5uSQ7arGefDTcBX5rhhclRMC73d8fza5mUhRsL5YWsqJwSeGoOZ
   Ltl/JHaEP6c3m76ZuqiJbD4g30ajI8thAItK1KSeVc1yZ5iMfvADH+iiP
   lhC60j1/X9aqEVf4Lr46PJef+/O95LTqh4gqsEZvY5xLWdpMvf0zDqFOn
   w==;
X-CSE-ConnectionGUID: tk/788akREigHlmep9q/5w==
X-CSE-MsgGUID: gtQ9lfyqRlmNAJ6pq9Osqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73517756"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="73517756"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 21:26:54 -0800
X-CSE-ConnectionGUID: 3StTZWyrTF2ahdfralZX0A==
X-CSE-MsgGUID: mmkdRD5LTTWzJD86UEADww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="204373726"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 21:26:54 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 21:26:52 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 21:26:52 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.27) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 21:26:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eUaXKd1Xs2uk8ybhckwctDVbcjRrcFmRGWEA2dKFV26FGvAwQ+qEdvmhTbRi3IhQ3Falt1g2qhzf9cHiYkk68ZeRaRRkS05cgeRHEre6245uKEPXMHrOlCnfB8jFRgB/0Ims8x/z/p4p9nagtNFX6PcLFr7n1ZufyqYW3MKptcIUtzVZac0bXnGSv9wj0n22wh4qYSB0D0Tw6Y1VjFWEnsgfzxxmWgpQv0gfIZD9B+W1+BwC/v0CDLwBgChVODiAHPG5d8byLpszkegT/x/EwcxSmzSbttIWjqVlswUeSVTyC5/Mr9zdKqFd8ZiJl2VPw8fyUdZFvulpi0Emu6FTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lX1Nu7Z21Xtoz3oznS7w4TmAYZCyAN0NCyLR6NqYhhI=;
 b=oMl1a8JxCgeJoPtqguzOnWmEshCBYX3VcuygghdF4N+bB/POK3VbqaJyEBS5wwCAepdjzy1aA+MLWUYhhsDkk/6F6+4cZK+GaL4KHdqEBIv5yVhtAFaT/HHWEkYHNxrdqZbsB9AbIMNHbqy0piYJC0CimNBqkILigJ3xYFxWVIQwZ+WTfgcBgfem+I/E9QJ54wTtJGHaBtw18wRyZ4BoA6qSzTxIOn6GcV+WcsSSLZmLrm8Id6rLCHgi7nCshxi67ph4P6T+6l7kRePsk4D63Jir7dGUAbwwzvdWUjlDyy/uO6lqmMGyo/IVZfoi965NCZZO7/mX8wagtan3Y8vw/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20)
 by IA3PR11MB8940.namprd11.prod.outlook.com (2603:10b6:208:57e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 05:26:45 +0000
Received: from SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939]) by SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 05:26:45 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>
Subject: RE: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Topic: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Index: AQHcdgAD4xdTWMSnLUSEH7bPw2ktk7VGKlmwgArevICAADHkAIAABW4w
Date: Wed, 14 Jan 2026 05:26:45 +0000
Message-ID: <SA1PR11MB84767DB8AE1A7C1B71080811C98FA@SA1PR11MB8476.namprd11.prod.outlook.com>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
 <SA1PR11MB8476DC4555BAABB5734BE314C984A@SA1PR11MB8476.namprd11.prod.outlook.com>
 <SA1PR11MB8476CABAA90DCF9B492B001AC98FA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aWckPqfPJ98clqnb@gondor.apana.org.au>
In-Reply-To: <aWckPqfPJ98clqnb@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB8476:EE_|IA3PR11MB8940:EE_
x-ms-office365-filtering-correlation-id: b0d8b082-b57a-420c-d7cb-08de532d8230
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?GS7UEfUGwtHlvHeVkScw1m1PopGt43NBcdEKlQNkYKNoPX9mI2kjEjE8m7jt?=
 =?us-ascii?Q?gCVebu+bmQ9mLAbBt8EwS1niZuZrjwMVI6dxXIS+WnazYevIYB7GFNrxIdu5?=
 =?us-ascii?Q?Uo3F/0m5+qooHiXxr8Hq0brHQvnuZrn8NaOUOAbhnZfSwQpfOVjmTEX/eblj?=
 =?us-ascii?Q?3k7DlU/9ZErjettJoRyqHv+RoOXGGcgx97K7ywJmOsj2rYjYgKESzL5udqW8?=
 =?us-ascii?Q?bNeBvl2IWmqZe54EHzbqedt+kAe0ztSuXVMokotQvqgkUI8fp/11+pBRHGWj?=
 =?us-ascii?Q?8Q7D7YMbwZ2GZJslDYH+x0yJMC6OQ5QXblU4pVEYob00Jc3/1xeylxdkOM4u?=
 =?us-ascii?Q?TmoDcSGzGJDJcmPZ/GwJuAkYve3jL5Q+MpyLgTnXQs4nmTCemt5PsjgSPLy1?=
 =?us-ascii?Q?LrsQagatraHBRtGz734gCmObVkCNmjtyi2IE/SNbZiJv0jIl5nK76Sw6FP0P?=
 =?us-ascii?Q?+Y85W7Lr7QN9jJdPEg4cuWO/cTIoADBJoJXckd2OYx9wsXARy+4I6CAj4g2P?=
 =?us-ascii?Q?j8WeQvoTh7ZyX+Tgg8i77Uw50TCAiX9t9PLP1naMpPeWQBcwkFambpywVMy+?=
 =?us-ascii?Q?frDAiLb7d/bSeUUvDGyFzbSM3OEXFjRtDQubWa/+9HwbTo8DMBFcU81elnTg?=
 =?us-ascii?Q?TB+ClXf5YSjmLU8TOup3f94T1R3pSOSQqrGy3Es6G8H2kK3MK7+w5UtTke3o?=
 =?us-ascii?Q?zlfgc2E9W1AJeNHlP19HkzpeGhW1p2piU5UwHw7WmKNDrkJYJ/k0r9qGwUii?=
 =?us-ascii?Q?XelA64CyQBgChH5Z7sKh+Grb6Vw8piBgDgHZwoThpCqffwPIDSWG9R80n+9g?=
 =?us-ascii?Q?/V8QP5dRW/kLefGrStTzl0009bavt2JEz/1T23Whq5pYuoNPvVZdCy2U8Awh?=
 =?us-ascii?Q?ikZ161qN9GQUYtwzLCvIlK9f+KQanjXbRW3RrhLippyiTOXCd4qAr6h1cLIH?=
 =?us-ascii?Q?kxwC9EVc780kA6gLr3q8oEv6SCGgei5qLvnlIjmCakc9s7pbAqJqgnR4dTO9?=
 =?us-ascii?Q?SVwuZNGVOMgTENdtBE0Ryj3uHMh9tGCIHVzv+PWqV9gDjce+LgAGeVTkIYWr?=
 =?us-ascii?Q?nHbG+Dongb5rGUohYrbhzm3fUgsmRKkDzQw81RreM1HdyrCtLkudMO/jHbPn?=
 =?us-ascii?Q?6LN0zGWhEcnViI7N9fQUKgOr58AXiwJSdcsifl+vetEE/SgY90is3WyUIbuH?=
 =?us-ascii?Q?e2qelUJvWwBGtdXPHvXzxsdl+nbZYcQeu8GOhsoRoaRq1gGYcEnGF0L03d5v?=
 =?us-ascii?Q?4eKmjocMrv9lS/QUQDe6ux/vHl/yIFqonKBLoIO7E1efkXPPTX/ySrRzu4vd?=
 =?us-ascii?Q?TKDfiehRdrfc9mMUmjnWZUhIcw5695tqe/oVleWRY70tDVDT5PW/KO9RYsXw?=
 =?us-ascii?Q?t4quoXPOhnZNoJXxI/zrfiTim5KP6XNvvT1+cKPY+jfovwSqhLeznsoS9b8o?=
 =?us-ascii?Q?yHCFLxBEeJkByrgf0KBOzfXipkShggHc9jdIYBIgLz6hsMVUap0Arg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8476.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/7vw17PThh5K3pGvfTvnlX7zh107xiUNSVqExYdk805uolU+a1KeI0yn87mV?=
 =?us-ascii?Q?nu4zCkdAiN6QCBKlz56ZKWQLnVtL/GZV2NMnvIAl6jEbJhZTpdgZGpfCKThx?=
 =?us-ascii?Q?Jw89DoA0ae2sh0pPO9BKqOSoM4RFCN10U71Vm739BjMnxGhX4XJuMBfrFK7j?=
 =?us-ascii?Q?c6QQRqwkFCvbw98/UTMTcTmNxLYph83NGMwPrG5lmfRgiCGQAk+QsV5rpaV4?=
 =?us-ascii?Q?y9OmdGY5rorbeKojpC+Bx/ETL3QQQQRg+3I6CxApKjqcMvmERwNFWRe8Ujfi?=
 =?us-ascii?Q?MfuvdNvxYvmxo5zi0ZUpOrYa7e+rwPaw3pJwr4c3KDS+z8OZlEusNCFUfNOD?=
 =?us-ascii?Q?fUPVKYdB6F/BA1JS++LLg7wiftbNFixB7dThcInzq3hjjOW2mIPj5+sz09x+?=
 =?us-ascii?Q?auATYXXmAmZyPSzSZsf7xeP95AsyWwP95GnXtbdLpy8toZgqD0ISNp4aOZI6?=
 =?us-ascii?Q?PcgIbI8/HjVWEMld2X8OR77lyTpl5VtSE0/8D+HG++Jxph3YghDcp4PYYdWM?=
 =?us-ascii?Q?qV7jEIRqq99GGNLDwa6deeAWZTxzrnN4lVAvYcCADdi1BmaFH4upAmIBDRVJ?=
 =?us-ascii?Q?0Yq8hjjuLhofb3LQgdB86RjsRAfyfxVt/2ndj4mcCKKdyjx+PC2VwvCBsRmw?=
 =?us-ascii?Q?/pXOnV7a71aZxPy1XySkCoMuF5WgMMD/MpCfBMFn1+AgDUKudDxNmqBF6Izj?=
 =?us-ascii?Q?uhncSo/v5A2/y+5dqeY9xmO7f3ADf8diTimrYFTXOCn8AbKHYOcImtUo+MQb?=
 =?us-ascii?Q?KgWxItfgJL0RqdT7IppR7o1oH0trcU0Z/GI6t8lRyOQ37t/mtpmFb+9vjayc?=
 =?us-ascii?Q?/Kb8IG6Sc0EXskI1qtcSExD3pCF/NxyyrdUHYB8T44Gof/j7BotpEG8Hjyba?=
 =?us-ascii?Q?afrAnoeZnUO8SwisnMRIHJK3y3PmMC/UyuA69bjiXiQMi+WAtgyoxn3ITeYD?=
 =?us-ascii?Q?kOCBDVBQCfZmYZisf89L4EwqF/yMFn42PHM1VecNcDruQCoX8IdSj745t89m?=
 =?us-ascii?Q?dSL1Rz+tQXjt1WfVn0uTQPQBOXXmvKUvQPCZ4WWkoHUjOsK3OYT3uTxv2OFo?=
 =?us-ascii?Q?lnIoKPsI67okxETS1/io7Nv7wjSVIbkYlcWPJi2wNTybge0t5WGLUrs687i1?=
 =?us-ascii?Q?XkCBpVD+Vki6qYsMXZPMv0xAItpNBGaC3hlU3PBVqtu8/uBlnRAknGcjhD5K?=
 =?us-ascii?Q?QIPQFZTpogBBffudx0UVa6c5t1E0pCzEV7iZlvddvBX25f270X/2Tu0ePuIC?=
 =?us-ascii?Q?TMn+LZ9AvPGG6mVHTRp0IrTUXw22sw2sBYamvf3MqLJ9/HrIDMjYBAUCNsDa?=
 =?us-ascii?Q?NSCVF+Ns5Imvaw0OufXnaiM45GNosQ6CoGtnsAvUzFollnj0pGQzsd8MP5L7?=
 =?us-ascii?Q?gZfM7/OXjyvRB1Klg6Uv6y/YwHG+Ck/NQg1eo6c+KpfrsJcmjf5kvS+tRsBD?=
 =?us-ascii?Q?bgmas2HK9PjLBM34Ni5Dqz3RBI5LaxIKl5vSCDtRAslzDbk600thjjIPsPW+?=
 =?us-ascii?Q?HMgTjfrHX6GxyuP2ntbawQrUy6914t2LXKOqnxqWnc/LI6qvyWCLYL/zzvVD?=
 =?us-ascii?Q?AEB+ozf6Uj5GoZvIZ/aMdU7GnmztiFhfkw3sIwOF8DxZImNNc9EXM3wXl1YF?=
 =?us-ascii?Q?VJlAKSdcqoevj72gpKiYjvHGYVqLYDpplGEbkv39z6lEMBl4Cs44E5Z72LTf?=
 =?us-ascii?Q?HoFA8BeKfricUfq1QjUkRGXyxWQBDQcePcfaeTErWgwQGsL6Uu29g/ZfPSad?=
 =?us-ascii?Q?0T9tQmiJnQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8476.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d8b082-b57a-420c-d7cb-08de532d8230
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 05:26:45.5214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzHMuluoWVWSi/QgqQgHTsw8H+EtH0jY7ihleX7th3DQMASrUQPc+Lz2el3TuLXvHbJOKmSBoWSMoES5UU1MU9SN7PCs//Loe6WrFG0qkJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8940
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, January 13, 2026 9:06 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>;
> yosry.ahmed@linux.dev; nphamcs@gmail.com; chengming.zhou@linux.dev;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>
> Subject: Re: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
>=20
> On Wed, Jan 14, 2026 at 02:14:58AM +0000, Sridhar, Kanchana P wrote:
> >
> > Just wanted to follow up and get your suggestions on whether I should g=
o
> > ahead with incorporating the segmentation API patches into v14 of my
> zswap
> > compression batching patch series, with the changes I had to make, as
> described
> > earlier? I would appreciate your letting me know.
>=20
> Yes let's go ahead with your changes.  Thanks,

Thanks Herbert, this sounds good.

Best regards,
Kanchana

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
