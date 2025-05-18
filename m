Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB857126BFA;
	Sun, 18 May 2025 20:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747600889; cv=fail; b=JkKERzZANoDR4r9v/oODYya953US8MBZjz8x6Zr0rTFJrqQ0ohaCGNhkCTh6fk3UH2scaq2lqcpj3lNzPNnZWTmOhf46GFJwzVs9wG4hN3/VmrLHvMEe31Aql9t4jzYY5v3OK5WYa+3ucvtvY6lZqKXhA7jUY+O9dRhOsVcM1rA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747600889; c=relaxed/simple;
	bh=RXnQ7IVLW6e6BJw2dhGX9rBG5Q3NBxzADekOi02+qx8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SLzVtgc1Wj+ScCtwieCmp8mw1Wa+1lZyfel8g13bom+AiddVfjMBXn8oMRf2t9FC/HcDQR8oV4MvZ7PgOABgrpkm5RIGTT4/clUoUDPocXKmeFgoLRWiW1PEAoAO0yAKDTFb1yNcpPiV9NsxJQKUUfE/Q4romqL5sfQoxH8Wgqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixcv5gQF; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixcv5gQF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747600888; x=1779136888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RXnQ7IVLW6e6BJw2dhGX9rBG5Q3NBxzADekOi02+qx8=;
  b=ixcv5gQFEVCmXH5njghwn4y6WEejxLSGIPS2k762x/qyes35UJfjYhti
   bUe6oSSjikOtMKaIs7RuiLxTed4AZI5NjRyI2KUWvn9CTr53JVhBYYcvM
   aiIcwC4kLzJJ1r92vlqBEwkis18J2Z+NJcuXKX3JviXZLKDyUeOmsCxiY
   kjLdyJkoBSlOiaozl2ffI2H9Ca4IhZMVnwk8h4WpAL5MKHp+iXAOKc22W
   d4VFXdQUhB/8mTNZwinTASZxD6+KqDP6TN5ODSYhzyfVLkimIaM5is9RE
   947jeGNhah0YY6FrQV7iOkiTIEmQWVEi8HNFq1lt1NWvYe5ZmrEB8dB/J
   Q==;
X-CSE-ConnectionGUID: dxmIuLt1RXCJZLwvQZ35HA==
X-CSE-MsgGUID: kx++MrNGQaiIPztSCihZcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49563646"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="49563646"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 13:41:27 -0700
X-CSE-ConnectionGUID: QsjiSuF6TGqb6Q6Elno+mQ==
X-CSE-MsgGUID: Ucu1cgXESIqBP/BXaEkjbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139030129"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 13:41:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 18 May 2025 13:41:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 18 May 2025 13:41:26 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 13:41:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJAwzJwFX4+Gr34GNyP6ArIZW33oIP2XLC1jI4zzZEdwUkIugy45MMb58aU+H8eExMcw1UrMaGg8zFWuvrDWr1FTlSUZcf/HGn6Gv5x1Xke/H58d8dpE6Xz+/TIPz36LHK0392H9RIuJlDctYogyOaPXNBeE1fxDoscYNr1wd/Ie4Hv5IIACX3astyfcRtXbuZz3ynn+FXeu25X3z3WX1NKaDVnKpvX35JEZEaRARo2i47IkCEh54d6mVbd6h5gWdDelBqTlFT6AG+rZMemJIdFtnIacaSIlStPJFFTgEkVyitZ5RT6ffcYa603GBtXc9w8cPeTnYd5DXvYvhaA5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1h7BebZZNJ6H6Wly6wiRvkn6kHGzib/lhQ7CCEPVF8=;
 b=ZACt92gD7nmr6GrZAg/yUbPANLHPnJ+XwJzDvigQbcr2LjezgIrXDo/ABc02B4D899wtA6rvx2PkkMqc+TX4km7LDrLVOho/K+l4Q8fQ7983Ll4yVLU8C1wqz0ZCCVKfpdG2jW8uDBYs0zmEUI4XY2KpEA9g0X93fPyX4+h5jj009F/rrGWOvsleDSRLPG0rGpFCQeBJkTIP/NSFNog35Bl6N3TYP4US37JuMZmC7IJ7eDDllRjzkS7JDrDej8MwpNe63K2h/kvZwZ0pPe905TxipX9ZnSJgd2kQv3SwMfCu4w/b3wxXPKpJvuYzxAwaN2vujf+QIj4GXkMMtjTF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by BL1PR11MB6050.namprd11.prod.outlook.com (2603:10b6:208:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Sun, 18 May
 2025 20:41:10 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.031; Sun, 18 May 2025
 20:41:10 +0000
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
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Topic: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Index: AQHbwFE+HzcrM8vfg0+DcWZ2l00PSLPQOoKAgAVp/tCAAGUCAIAC3Yvg
Date: Sun, 18 May 2025 20:41:10 +0000
Message-ID: <PH7PR11MB8121A80EE57CD2FA015A66B4C99DA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <20250508194134.28392-11-kanchana.p.sridhar@intel.com>
 <aCL86_v0jaqW8jxS@gondor.apana.org.au>
 <PH7PR11MB81215CF69F51F2801F4767CDC993A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aCfcTpLgFp4lPaZK@gondor.apana.org.au>
In-Reply-To: <aCfcTpLgFp4lPaZK@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|BL1PR11MB6050:EE_
x-ms-office365-filtering-correlation-id: 72772d86-0f30-497f-054f-08dd964c5299
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?imvpz+o8qR6Kja8ao7RAEXWMZYHnSn1RBGvpeEbMnhTrHqeOstuDy8WUA79X?=
 =?us-ascii?Q?fci25xv9liDQAUEDAoyXeaWE6tf10+TrpFQ4BnfbYVMn9O/MbYzvgH1ccfFP?=
 =?us-ascii?Q?qwRlkxYWqPY4clrb8Vhh9J1il1vLFdy/0fi/A3iv9TNj31wWFM3K/fHGIDHE?=
 =?us-ascii?Q?dfiZM0jOQB2LR4fG2BNmWoarYZCLXwgoQymx+sXSoJYZM9WUrFm9uD+7Ubtm?=
 =?us-ascii?Q?TGi6tgXRsoNIL1ynI0WEJiXbTpvR3iziB7/3QizMz+oz2NBGHnkQNQvx6VUS?=
 =?us-ascii?Q?j1aT/wOK/mAMX10NRpdwmZwWJStOQp9y2oPS3+8779DX+yBmccrKbpz8UasK?=
 =?us-ascii?Q?hiPuQRBoMnVYc3FFvgn7xDVygDReTOCxZrj68vc8OuNNgZUGXnR+eU+Hi61c?=
 =?us-ascii?Q?KXdwTPHVg5Ie/g4T93iAXt4Emk2/KZ3Mk95M9adqX7IsgzmQ6rJb86G9gHup?=
 =?us-ascii?Q?cqkEthGAA7kQFOMa1XSCbrrKDPf79/xw/khHBU9gu2bxtSAfVLC0MBYOCCxw?=
 =?us-ascii?Q?voifyTVislKyzZBMU1zqauo2VlI3VXJUGt05EDROftawWPr58KxuvIATjKgg?=
 =?us-ascii?Q?UdIBMTB6eidNf61BNLb3K0/WUCb6etPjbMhNhTVgWycpqiXNjuEA5dy3p9l9?=
 =?us-ascii?Q?6JOl0JUsEcGfwNO3VdRO71kSjvkH08mvX41W+HNtBw74HQQREjyNDiR2tLil?=
 =?us-ascii?Q?R0ELAAEc9KJaxByySAepRNfgYDaDPhgm/GO0hDOwP7Av265CqDvkbARDq4RQ?=
 =?us-ascii?Q?2QxBSJN261p+NTPkyge+mm+ZWJVgaDgmECkj82RC6tZazs1UVTWT1nEBHBB0?=
 =?us-ascii?Q?0ObYaPiVnZH1JVpuQCEZUcHMa/nsapukrvumUM5doAKEHbSrmTaIU/eOIQhs?=
 =?us-ascii?Q?8YF9xICz8mh++z+SEyeUQUBi6Wb5MWB0aBBLNhJV2hw+XMnz+5EFj9wKHkyq?=
 =?us-ascii?Q?g85T8aQUEu8AP7xPDJwUYPAG0fyEDyw/AXEX7tpsjgOt65WVR0cWL3gGWKxe?=
 =?us-ascii?Q?AGwkdtk6IdplDbEH1200lF0hxU6vWa20ehEyIfut4OUsotMKUJia42hTQFIL?=
 =?us-ascii?Q?M6l+7BvIvpSv0rVtbbli22vru7igN83UYFtrNgZ8ZTlR9tQjltNpMPg5cD6m?=
 =?us-ascii?Q?AbIqnexcylrocbs/KmiGUupZJr91yrobbqejBQredNgwxOCLXxQvrRJI5uJm?=
 =?us-ascii?Q?OgXtyT1/kGOwWj0mvom95OFDMuR+c54xZqEe4yFeqtE/SySNsAWabFdp9/m2?=
 =?us-ascii?Q?liNH+7ZxawcdHiwcXBNMztt1W0dfFcXsZ55/1z81p4uBqh2ZMBbm23tQhc83?=
 =?us-ascii?Q?UvufaVBSlVCw3haGISHhxZy19DZXyXEDvV8RG9S3vFLVSESLr4EX7I0I7ipI?=
 =?us-ascii?Q?MhSH15Sgd83+j5x1es07AXdasCnCIyGizKlgvDXHloUKiPpvb7FaS+FNl8pN?=
 =?us-ascii?Q?nGMdJ1PyvUO5SFmtxhrAdiBdzLVM75QDt//hyfLb3YpcD5ebU2PMDAk74rqy?=
 =?us-ascii?Q?EUA2INSnAkotYyY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UXyFVxC6U2pskCjBzgN7HXKa7S+zPv1eoHJjQNM3bktS1TvpEH1KnJitf2Gx?=
 =?us-ascii?Q?bkiDdhfhfpp7gLaavQxZ9OHLxGK1f5z+GsGt2LCc1cZU1MkPtAMnh2OqxZZT?=
 =?us-ascii?Q?qAWJhqdG5GRL71zybDoP3MJRK68rgAe/gmXCEzxXRL8ACBkv+u9p48Dcp4/P?=
 =?us-ascii?Q?ApjEJNeHG9GEwKlzvVTCO+6UbBpwgWR6/j67tKrWolK0qMgDeLz5jgQuZUV2?=
 =?us-ascii?Q?JlR9kNbysBufhpO2B4rA8QlVOmOxVXHlIFPUSJqs7Rmbw5uzBO5DXAy2JCOK?=
 =?us-ascii?Q?2mlIqKMES67pYoMqvn6Taf/OMwZkS651HbB19PuuUNAKt6aVEulAq+XDFMve?=
 =?us-ascii?Q?JLd6wQWZ1ofnUBsA/KEoOay31+b3IRJfBy+q1/vNcXRF9TiUjiwmPbFD1Z+g?=
 =?us-ascii?Q?BR1yvMk9DNSZQ7l95eM5FzEEpNr40Bu3GGipAgoW3+wDDZJjsF8V8PiZj6NF?=
 =?us-ascii?Q?oh+CWKuKKsHHYaT6iexqttneUTdaYZnOlHqHWr8yPmFplnSu3vKssNXSbpVq?=
 =?us-ascii?Q?SagjcqGmQ90XMOsgLCsv2cphPogWKB2YGV2+uzRtkUy5QAFBUDdZgoEPf5+X?=
 =?us-ascii?Q?n46xdln3Aks8xnTtuuEUGGobwqJVSULlcz6Ki+xn3ZyILxUxhq0wLATn7+bM?=
 =?us-ascii?Q?vjGqpelFCy9Wl3946FnOTXNZ5FadfftF9AiOlu7Rm9suiiJNMZyYMbd6wYfJ?=
 =?us-ascii?Q?7KR481pPvI0cIz9UAtP5ko2ohC1gjZF0sfGty5aWzv2mVjvYdBSud9IDhzSw?=
 =?us-ascii?Q?+mt4ND+54EuAZ46qgChNWOUbOVardE49xtvtT/eNW4EgNeYymTHRVbybNh2e?=
 =?us-ascii?Q?t6vcaAxA6fZm+6YQExhVjhlaQhnqqSUwaLVQKGKENlO4q+Yp/s01ZpkptDf8?=
 =?us-ascii?Q?ZG/MdACb+E1Bgh2pY6tWmDLXMKD+Py/oN+r4ooCHdfYQ58QyHI4Ds73wAlZ7?=
 =?us-ascii?Q?YeiATf2bef4nSETAPB0567jHhxl0jvBkrdWCfxenv7G3A2b33I4guX/Pdja6?=
 =?us-ascii?Q?rf46/sBAbqFjLs+M/XbzAg0IwIxm+ViwF1TorHQo+PH7y7TCp81wyEXZAzgP?=
 =?us-ascii?Q?78W/bybRXmtu7o+ax3qlQxMAMo10e+PdcbjW8xzk13ezRuEOijTzhC4ki1V3?=
 =?us-ascii?Q?NBoB2ub3yWGGeU8YHRQEO5cSnkihsSl1fBlTrg8P6VWETN6iFbxi/NkThwtt?=
 =?us-ascii?Q?182Gc7lkIL4JinG3M//ME3lAPxDo4rNezJ98b6l+lAkn722QE/zcVU/PsvsT?=
 =?us-ascii?Q?1t9SZy3KQ9iD5hzCbFk/Wok3qSvDDdVkFmHaZjUGQGVvZsBBwQKhkEUmQj5b?=
 =?us-ascii?Q?Vet43dCh7Q/ZRQPnxlY8nAkg3voqOQTcv7ZhpRfywopMtUI6iAZ3z0nTxz8B?=
 =?us-ascii?Q?G3Gz6MDGvsml7KT9sTsJMSw2MOQsvDf6fPXH3DP5+g3gnngnsf2zRGTEa4GP?=
 =?us-ascii?Q?BHfA8bwwOG+JJffcQ3hILZrj2qDjMrSHFbWDTABhq/hmHgRVcf/hHXI8PKQg?=
 =?us-ascii?Q?IE6PicIhuz1cfD1qaCjMdw4PFq4M8KJn1V7FbvOUIJXg2520qVkqlq2jIS0C?=
 =?us-ascii?Q?+zvQUfnanmlXiGbsTfX7+PfJWytsdgFzams772kAZEOa9gm+2TkgM1hTnLQ0?=
 =?us-ascii?Q?Fg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72772d86-0f30-497f-054f-08dd964c5299
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2025 20:41:10.3647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WGxxGxlPq9R5Xuj76x/qYnE4/i1Yo2BEIeceRGjU8ur4R1/tWVlk2YHqkymo7miQ2/jcArOaJpqVeMVPXrbOcjSxE6L4dXaU6Kv8tXJT+Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6050
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, May 16, 2025 5:46 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitat=
e
> batching support in acomp & drivers.
>=20
> On Fri, May 16, 2025 at 07:17:36PM +0000, Sridhar, Kanchana P wrote:
> >
> > It appears acomp_do_req_chain() and acomp_reqchain_finish() compress
> the
>=20
> That's the fallback path.
>=20
> A hardware driver capable of batching is supposed to declare the
> bit in cra_flags that bypasses the fallback.

IIUC, are you referring to the "CRYPTO_ALG_REQ_SEG" cra_flags bit?

If a hardware driver sets this bit, then crypto_acomp_req_seg() will
return "true" in crypto_acomp_compress() and the folio will be compressed
as one unit by the call to " crypto_acomp_reqtfm(req)->compress(req)":

int crypto_acomp_compress(struct acomp_req *req)
{
	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);

	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
		return -EAGAIN;
	if ((crypto_acomp_req_virt(tfm) || acomp_request_issg(req)) &&
	    (crypto_acomp_req_seg(tfm) || !acomp_request_isunit(req)))
		return crypto_acomp_reqtfm(req)->compress(req);
	return acomp_do_req_chain(req, true);
}
EXPORT_SYMBOL_GPL(crypto_acomp_compress);

If so, then we still have not addressed the issue highlighted in [1], pleas=
e
correct me if I am wrong:

[1]: https://lore.kernel.org/all/CAKEwX=3DPRzZEYOuTECjjqYbUDXUjMzOc-R5s14-i=
X8qevDxGBpA@mail.gmail.com/

Can you please advise?

Thanks,
Kanchana


