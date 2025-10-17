Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB3B1C862E;
	Fri, 17 Oct 2025 04:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760673793; cv=fail; b=db1mijO4rChLLNBP6s9QnPdRx7BbIzwsU7t2VmVJF+yg+q0xw/wlysWxgx4snZnC7wMq8c0Eo2iONaKYLlcXIatF2oglD0bFcuS8lVC+N9EI+JdlgfH++uUzFvUUUoqsEqcgBGJbVfUgXf7uthgw9UQJDsh0HAMPhe2PP7iNcwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760673793; c=relaxed/simple;
	bh=RwacxIm7HBYr7UQ51sKS4wfpPjdNEwJt814NticVZnQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=slpqnjEwdCfE5kp2lNCUTmyTw2gxLyOSGKU5TlA12g0htuJ0/DFrfWq3jl+TmZbUQ4duBWbQURfeKIaXDYbZfnF3lZw/+xY6VpCsAun1Xot+Bu5fB/pgU2NuQbWx+uE1iYrXDzgO8ttM0yphGsjT7kBKeU5OR6hcJ7wZow+YXAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qk1VeS7s; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qk1VeS7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760673791; x=1792209791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RwacxIm7HBYr7UQ51sKS4wfpPjdNEwJt814NticVZnQ=;
  b=Qk1VeS7sbZkqDnKYfFcZed7bcaGekB9x5NW6LXN4b2W5WMaqlT6s1rJX
   unzsz+Z3Hf0q9fP1ZEfvL5A7OTPLASvmrxeAw+mXwOIV99DuooEjgywgU
   FLKxK2VP8VMG5UMH/OwQ+3cZztnXofzaLSFZ8l8Fa7uz2Sn2gP/1yPZoh
   cMiV1fuRb/m/oyjXw3PCUL+rmFLc6gRgJW9RVn6MOZnLrsMyNY7gb9cqz
   UuTc11Qs6Hwv681b0ksOD7Sya//eItDY0ag5UBZf5Blyd23FUCiwBszvk
   OvsHOY3NamkyGJYbTesNuoP0z5O/e0Axhlwv6ZE6WK2hWSFzfVKfNFPqw
   Q==;
X-CSE-ConnectionGUID: ZlT5Aq0RTQSx9eK/V6rtcw==
X-CSE-MsgGUID: b0AII9m3R9ieZ7VEHptNcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="80325637"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="80325637"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 21:03:10 -0700
X-CSE-ConnectionGUID: N7KNn39zT72mLEObVOY+Lw==
X-CSE-MsgGUID: JxKMEmrrR5uzyjmUW1cpyQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 21:03:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 21:03:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 21:03:10 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 21:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lS4PbMSXXI0yrhfA3fHlivIyEq1NSqzSRgMY8HpSDOLfGvse2TX9J72eFC9O7Fgt21cdN8yQ63xP/qkUX81pWzb50U23C5Pscf/jMkxawT+XKM/xsD+sHxn1S9rZl1C9Tovn9LpYzQAeTCEcrQS9yqe4IZKUDdhgG918fzwoPf7Efd5PEPuQf/EJmnCrpcBQDMQnsSBFa/TrObUhwrUyr3b9/GK6c83v2PBWU5K6eiPyMFjrsW+NEdK5xTCA/oQKII7XPOyARxTkHqlMXfFMM9EUUfLZrhkc1vQNV/J0iSJgu2JpQSY92UQPNidF2GhzZ6pY+iG7PN/aylf9aycgNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wepf3tRpl7gttefkbc6QrIxtpoK0ts8klxzng8LphFc=;
 b=HFi19zFtieUCAZp3NefUWieHofMZhyyoDGx5wI8h6ZnkmGsa0fiYaWWREsvfjmpRk43gvkd5IuTOUQ6Tk+hvW8RC+AIQS48ayjlWFxFoKAusFo9QduiH2Cd14THAlziN6MTfadLqc80Gaa6cY0KCa0S22up8fkUVrbgashnJCQfhmtw9qjJAQXEWQIx/zYFP0D8jydMjQYLUzwDUYGpYv3SA5rR86ot9jBxjt08Wny9GPAHXOg/OGa1ErLL7Kl3j8FnfTrlVf716wIjyxay1jx67GUEEHwsiI7rWfNQWQJv6jYejw4HHBJGIb6drMrjXJpBeL1Jy71ZDtygGCDwItw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA1PR11MB8351.namprd11.prod.outlook.com (2603:10b6:806:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 04:02:33 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 04:02:33 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 19/23] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Topic: [PATCH v12 19/23] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Index: AQHcLpaVzyA/YBo9FkGV9wFr494MybTFps2AgAAxd+A=
Date: Fri, 17 Oct 2025 04:02:33 +0000
Message-ID: <PH7PR11MB8121D84D1364ABE4A7944399C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-20-kanchana.p.sridhar@intel.com>
 <aPGWHWlsStefuvKL@gondor.apana.org.au>
In-Reply-To: <aPGWHWlsStefuvKL@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA1PR11MB8351:EE_
x-ms-office365-filtering-correlation-id: fcf29cdb-4cf2-4ad9-8b05-08de0d320014
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?2HIh9/v2zyjhBMZ1mgqTg2IXBEf4AN6zyXDDVHmYkM2op7riIao/GCpQNYQd?=
 =?us-ascii?Q?Llz8NLgPncVHmUIhVtPpUEkKKrz15UHE2Glp0vn/HNS1J4yQ84NGvJdj0y/4?=
 =?us-ascii?Q?20hAhOnNWHKDrKAq7zaPkOO6SwWxnMWnv5Y2N4PWAmq8PUWW9cHezGzUt3+j?=
 =?us-ascii?Q?1bHqHXsL45O8YqoRhhSvjW1Y29agrtQjcWjAz2D8dSMYIQVs9ZmMZNGgqsVt?=
 =?us-ascii?Q?v6uSwReZlTa60rvWiYlxxNgjspPBrVbj3mPEi5XDlpKgLSpjYt7VALb1PTXH?=
 =?us-ascii?Q?gaYUludFVKVdegxYihpV97RNzkTWlBmoT8Co3+U3YtDJ8cul3/rYRp7OpBOl?=
 =?us-ascii?Q?Uh1sqZvG8Zqj4TkfTiJg0KPw9qKP/TzgbIiUwmLl/QXFm/WhvJ44hF59ZZEZ?=
 =?us-ascii?Q?6oT7crocB7+y3E7zdqDju0AuhG1fHHFuOCamP1ffaXeBKJT68jBuDncMsA2G?=
 =?us-ascii?Q?/5KWIi+gyavSDrzF+B295p3rJBcK90hRah0HXnJ8M+e91PFZ76dZUblmFqZT?=
 =?us-ascii?Q?jroTil/lSb4aivhP+QbogYHCCK9YHTTBxuzibBkOIdCGAcCfrVkc/uKpIHVN?=
 =?us-ascii?Q?4sbDzVMM+2zv9mz8ngxQwxm8NEo6yKhwoMQapDdhqjW5x8QS5YWi2jT+CD4Y?=
 =?us-ascii?Q?OIXOpHjAF7lGSirATK48G9h948bMARFKtorc7vRNqUzMPQfDUs57v6RV1XUm?=
 =?us-ascii?Q?OrTIElxFowM++6YqqX4Hhg4qipU/J1POHh9d799WvI6dd5X5pN0IhIChcE2w?=
 =?us-ascii?Q?xcW4GIT0lZgyBT+zAp130yGTuRkRHWDP6vXuxA+lmDXNN/X7oARxrZ1cbJAH?=
 =?us-ascii?Q?d0hMcXnIajscT3GEPWnXo3zg34NhENaR4zC57sWyi1F5l27liSswn5izj7fI?=
 =?us-ascii?Q?txBRwSZI+PyVVTACM7RAdeEd3a8v+j9WOGdKctFCL2W6PDCHMMTKlViIl3T7?=
 =?us-ascii?Q?6D/HpL9v8PUNjeZd/Qa968yUk7ZZOEoiL45POJKoQTRrmW3/UYigoInCfvgY?=
 =?us-ascii?Q?X/BJrxS7+tKLj5Vi3KH/pw/ytrvnwiTe3UhUKaL9hDhbZlJa67nzPtHudlis?=
 =?us-ascii?Q?v9vtOY3q2KQBpWEWEsQjtLH2/gIp3hnTrENAm4exOgkkMGxoQRCdl6KoZ4UU?=
 =?us-ascii?Q?3PPo9bbgMIWWP5k4Micv/asrFEovlWkuHaXv2Sw114+lqbgnWNS4iWRSMcln?=
 =?us-ascii?Q?2FlzkgJQcPQU4kmRTcub5Tzv2uywN/NZNGiZPOJ3uARdfawym/TxOxfwuX39?=
 =?us-ascii?Q?Da4xLTmhgFffPSZpDsRbQvAvnYw3MGcxdzC0lgyaWKO+yjW52i3eR2MpLN5U?=
 =?us-ascii?Q?vNMukpQkRIc9lPDhtAaT87St9Oem3I1EMoSJJ4LNmQRPgkufTr/twh9Gu6j4?=
 =?us-ascii?Q?BQCqtwtWPLskycwyNsGrAr4ypzQrJ6JQUqWl8QEW5NRCUm7LTHF3x8fv1KM6?=
 =?us-ascii?Q?z14bUZX6oISQBjBNRikk/9how6/udFziMUwrateuViblRI4X3Me8XA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6sSreoxvEBoV3KcsidVdUyRA5UDOAV85q4YNS1JJ+Cc5PD73yQZUlG9H6mV+?=
 =?us-ascii?Q?imGpW3oUeURGNAhVfloMceYXHNVEUDEZfvj+zO291Y+4cm20kJ3X5j3Xlk0g?=
 =?us-ascii?Q?wKs6GDU9Z0TTrOsQWwOxTRIpvVyGROizZonIyS3352DgMEOglIvXFuQ4mdKs?=
 =?us-ascii?Q?ULAiOt7uJYhH3ft2o+l/vIzw3h+/XpLO9/3PCszJYm0aYwneLgsA1nhNXecJ?=
 =?us-ascii?Q?xa/vEzInDCY0a28fnWPbs+NNPrPwI1yxpHuaPWwZKEZBALvH/QUOE03jWnlP?=
 =?us-ascii?Q?34FhXxDV5XQm/r8j3aRpIbhsJoRsCCL5dnhZWgomvUO5HVeDYkcNVuFq4ew9?=
 =?us-ascii?Q?jTtLWthkP3nQfQh3jcMWtNG6QY0AAAXjUSOEus9BHq1NGRhupCnDqaFHZh/y?=
 =?us-ascii?Q?O2hgykfHrgM6RmcmKt+qaI0/AeSRDSPcZhGk/ZWqI9d2Jspr/EXJ/fTDm4X6?=
 =?us-ascii?Q?ONMcW3GIkxIv1Y7pRSwTqUJaxGmCrB2sNYQKE0oWpx11fYcF09kiXMuTEsH6?=
 =?us-ascii?Q?BTgVPl/bG3yx5IFsYDG8Z89Stim020aKtlSBdqt7GfYXWwmwKQH2V+VdRnhH?=
 =?us-ascii?Q?8gkpEAGxRU5Hrca/iLfvpY4zN20O1btZNQ3nxsoTM453bK4Ip9jsxPiI7Y5E?=
 =?us-ascii?Q?ewl0NERrFPTcCTtTUskqcujVoRwL6tJ+5fNR8eqsm/J0noHGsYt35oVwzxkM?=
 =?us-ascii?Q?jmHGBJYEa2xQ/PrsHQCZdKoh8Vgbts8fbjTUne/8LEW/ltwLY9Lo+DYhDWWu?=
 =?us-ascii?Q?uTRfmOhRZYwAiiYYmiLvhsx1LeL3ZZvQzyZp3vZIma9diTJvusLIyD/3ZrkI?=
 =?us-ascii?Q?goTMpUYoflcz+mIDmgaGNc1wpH0FIchz0ALqBIfkxJFsdz/pxv0d+S1lyIlL?=
 =?us-ascii?Q?gN4qFmb6l1b9fv5S1vOPgxmIzShazcxxXSykhyZBsYCjpMgUs4ZdKxOEHRRS?=
 =?us-ascii?Q?PKanmpdS5Id2jd+5+Jy9lp1Kvdg8YqSAdtTjeo/MJHjscpJctIwuwriU4w5U?=
 =?us-ascii?Q?uKLJj5emS5eib7nLU1otPZFPRDW7jMa/cY4R1SbDpgSbwCd6zyU8pes34mSP?=
 =?us-ascii?Q?n7ZJSpxAil3ONNqq+973UbUHnMnejaKcjLgUVX3iqkLRYW29UQRSjJeQlvna?=
 =?us-ascii?Q?mEa0yOSbDpixhjxyqqwyOSuT1WNnSGqitiD0BJOgm1vfN6hLPVEkb/ASz6yj?=
 =?us-ascii?Q?MHKYu9zJCZUbmCzvMJMvIq4nvJHz70fM03Yo65jSahTaxXXXS2x+QlK/+hDP?=
 =?us-ascii?Q?o9b/QCxRYngvZwFfyrgXmCz+w5e0ggqA32CiJIla61cBSqgryYPYizBX9ApC?=
 =?us-ascii?Q?oThOc5xs3A6HjNme/rspbMubR2Qg4R5jcqelZ4/Ic2oHAL4PZ4bS6Xu63HGd?=
 =?us-ascii?Q?stP/EFDGSxC+/MC0aI59mBbQdo6lOLcaJWC4c/f2Ck+JVqaRF6RWQamATUWH?=
 =?us-ascii?Q?hlbOhLT7b2OnQqx2zgenuJ4L8CET6+gGh1WmZjhcS69ye0H5IItnSF7A6ZVV?=
 =?us-ascii?Q?W4XWCkq52Pynue/x/CYY8NjsOMTDn90xAvtrwy9pCblqiT9wbhDbT1pXRRhN?=
 =?us-ascii?Q?bI1/rHN6MGEz/O1nrJpB15U9sqpRzPZgHn+rsQSOv16WPgAjK8z5D7E692W1?=
 =?us-ascii?Q?vw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf29cdb-4cf2-4ad9-8b05-08de0d320014
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 04:02:33.3770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXmi+BlDVGCfqss+KmzNWDlIw60PKC+xMdxClbQlwY60QOLDU4I6YEAw6SuYD55Z0ZQ4FnjCKCJtTHoXOUwogm0F+2THySl64kZX0XtN2gY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8351
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, October 16, 2025 6:04 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v12 19/23] crypto: acomp - Add
> crypto_acomp_batch_size() to get an algorithm's batch-size.
>=20
> On Thu, Sep 25, 2025 at 08:34:58PM -0700, Kanchana P Sridhar wrote:
> >
> > diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> > index 0f1334168f1b..e94046529e46 100644
> > --- a/include/crypto/acompress.h
> > +++ b/include/crypto/acompress.h
> > @@ -108,6 +108,8 @@ struct acomp_req {
> >   *
> >   * @compress:		Function performs a compress operation
> >   * @decompress:		Function performs a de-compress operation
> > + * @batch_size:		Maximum batch-size for batching
> compress/decompress
> > + *			operations.
> >   * @reqsize:		Context size for (de)compression requests
> >   * @fb:			Synchronous fallback tfm
> >   * @base:		Common crypto API algorithm data structure
> > @@ -115,6 +117,7 @@ struct acomp_req {
> >  struct crypto_acomp {
> >  	int (*compress)(struct acomp_req *req);
> >  	int (*decompress)(struct acomp_req *req);
> > +	unsigned int batch_size;
>=20
> There is no need to store the batch_size in the tfm.  Just return
> the value from acomp_alg directly.

I see. Ok, will do so.

Thanks,
Kanchana

>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
