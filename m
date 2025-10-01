Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EABE2C237E;
	Wed,  1 Oct 2025 17:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759340286; cv=fail; b=BtdCAKNfz+pQRMaZVfAv1/h+XFFQK1xqbiQslk4x/sNi+hIjEn2+TjL4YPF+cXWfHddYv2DjDDb1hUtns7WzRXp9EynhofTQQslGW0qCJSuLoIkTsiUtYF2i8uCaofYWC18m3YAF2uXZ51rXmG2BUfIgwJIcQSr7bVLiijW3Zyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759340286; c=relaxed/simple;
	bh=1hc/zMGiazTux8zXHvPrm1/15j36fc1HJrCr10sFuo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qdzGZV5bN5ZsVK30ndsAgLKToCGd0eNqVdDHg3a+HfHbI8RXPmHvKGZKHeEcD61JU8m++PipkD71xC0WpzAtbClZljshQdIRsWkAT6q9NHoT5JLmu7148peh3gHLc8KZhj3mhJXq90OqrfpoLaE2pdHHg71JsZfdbiVH5vU2MeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/oyM5J0; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/oyM5J0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759340283; x=1790876283;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1hc/zMGiazTux8zXHvPrm1/15j36fc1HJrCr10sFuo0=;
  b=n/oyM5J0pfYnJAiDDL8ldED29Qc/XBYtW7WeiMaOhHSOFgTheu49h8U+
   vnoU4LWVdEOR8ymOC8mevB9gMzJHdYpLtOAKyz4gYBrjqqXzveAmMoIob
   wkofnOMwkanG+cU5Yzi/mK7NZ3ia92yg4XL5ZbeZZHJY64FqitjqMnzn2
   IVAC+uMaYktNucTEwKAR4YH7SwOaiS+H0jg1U8Pos246CLft1/Z/wU2OL
   E7zBnoRKOVL9dzVeHsGkeJv84nPh58t6USygF1O79flRbyUTv3kd1SQpQ
   h5yUNIY/ZpXfT44mqjShp3ZlBztaf1RLacpl5DAd6NWK3gXE1TDtJtp0M
   Q==;
X-CSE-ConnectionGUID: 2qdmmF3AStW3z+MuYXiKNQ==
X-CSE-MsgGUID: ulcAoWQOSgOTpdNmc7+Myw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="79043947"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="79043947"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 10:38:02 -0700
X-CSE-ConnectionGUID: dzRY4phNSUSbkNs09gIBQw==
X-CSE-MsgGUID: CAwt0KeJQUy86+tKo2YPQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="182878605"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 10:38:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 10:38:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 10:38:02 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 10:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iL6R075mV9b2u2/EuU9Ob6LP8YCo5cotvcZNIHmIoq3P5RM65f8CxNxt+/oKM+9veyX+DNXnWhsoBZ0xVXauaECxbvPeyzfutZMrQzbK1xhN3ACL21QJFsJiikzLfhWkbdIbRKMb9nsg560/PPVP8bdLBcUXopOd847Uof1vFtSfJk+5DNs1UP/cMbhzot0IJkCpIxglGVLa4hZMmULiF6rpEuuJdEquC1PcWktbg4JM4KMDOtyjw8KOnRT4CzUhKM7JJ8gYLIuECdI/Bxrz8PM5SH+UiIXNQlQGvZtoUYykLW/L4xzsFdPTkTknbUXokb95Q/5+2Z/uV0WI6VBSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZec31FxAdxVin+cZIq/RLPZPhWsdyUzjXzDrJ4cz4Q=;
 b=TYOPR/ifnUQdfSDAI6dA82GNJOXvquCAx7w8WSKAN32tNg7I93MVuKbrRypG9/OT0/v5sHh5Qwu4y2k7wIOog0YFG9XYlthf2z963dFoPmRvqjTrJGDjyU83yA+wouhAcDcWoyY4zIME6JcySaHAYabB9rSOb8WYxK8JKiVg3qc/TH8xu8KFYH7o8m/IjYJ6U/CTXRbFGmX3GBCMQVxxch9cxhpxkdVP/xZ6l/G8n9SI23YGb8kIxw8Zb7h1am/G5knYOjsa3QiQKiKDAigm+rm293wsoMYhhzz6Wk4MOFhyHaTm+dbElDyxJJ2gC0pAYZORD6ttYPaeoFqWoveGaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DS7PR11MB9474.namprd11.prod.outlook.com (2603:10b6:8:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 17:37:59 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 17:37:59 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
Subject: RE: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcLpaVftDjct+5Jkq/fUkbn0Rx3bSr5mcAgAAXwZCAABUagIAAJKswgAAK3QCAAAiGUIABKOOAgAAirzA=
Date: Wed, 1 Oct 2025 17:37:59 +0000
Message-ID: <PH7PR11MB81213920BBB94AA1E8DDD39FC9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
 <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <6xb7feds424kfld4udwmbtccftwnnx6vmbpvmjcwlionfdlmuj@vz4uzh6tog5g>
 <SA3PR11MB8120D4BDA8A6980A4BC5447FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <6frwacvukeaqrmtja43ab3nkldkrupczmhelrgjljvtk5eh4km@4pebysubl3dl>
In-Reply-To: <6frwacvukeaqrmtja43ab3nkldkrupczmhelrgjljvtk5eh4km@4pebysubl3dl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DS7PR11MB9474:EE_
x-ms-office365-filtering-correlation-id: d92026d7-085a-4d37-cf90-08de011143a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?9HqlAK+LJkBgEH/m2F9TscExcjWTPYn/lkhM+zpK4RL8W28P9aj6N0AM7Jot?=
 =?us-ascii?Q?yku7kv5nfeNRX7hYsPbDQudViqS0tTj5HeVe//n4XzK/IPan/9gna0DxyQp1?=
 =?us-ascii?Q?Ld5HC+trxvop4thqC1Wg/oXCv6rpBzvVje3DnOzMZgk0zzqDc6yyQMKGuYMF?=
 =?us-ascii?Q?hYLavGV78oXw/f8mEiY3S23Kc4Mo4xtmQsKi72oBaHFEwtDXqU+ffVOMV/nJ?=
 =?us-ascii?Q?/z796G57s4/mYPRi27t6b044QSYfw0V5mdcCfWJLkbeP0GENILmMlqW1bQbN?=
 =?us-ascii?Q?Yh2DrQatDFZBiv9PMLLqv2+uTEwYtApfvsXq0KKTZdCDlXGoHyIfHDzp6OsA?=
 =?us-ascii?Q?KO+ARJ1aUOmf38wgbJ3IID6xO5JpR3cHfhKq+EWNpPYDYXLZt3uvG1PhHww+?=
 =?us-ascii?Q?s/unpYM3T+qzEh+yiY04/RlUYrLXMFShOy6Nf/oYrihLf/E/4H5CMJ8zbbqD?=
 =?us-ascii?Q?XqI8kd7PzCyJEh4EDFmxa9uSR38iZgjolpgCV0/0dvSjHnN7oL3mNKdsVAIW?=
 =?us-ascii?Q?RXQAYBp/iiyzb32KxNEnONFtoZ+hElgfFasotbrGmqA8raJhxXdQxgJaMpih?=
 =?us-ascii?Q?pxjLQ+S1IwPO1BlL8ZGPSeF/LQxmOX9OMDKyE9WgtYC8RDyud+iCBpDRqOsr?=
 =?us-ascii?Q?SzBgHuCDC9fuVQtrGxcKraw+2asfXX8DBXay0uiXJeFvddW5FfM63aAuRMDO?=
 =?us-ascii?Q?9sSuRAOYG8tqLhZAJXfhJuGoQvCmzhkZw4ibJ1bXp0LbwawVpK52DrOkRWgO?=
 =?us-ascii?Q?0HTcg/wGMDq/S+BazO2/u+JZOnFsE99Km6g4LPW98RRC+vHJvD+7IjBM5Cjj?=
 =?us-ascii?Q?x0TKj5ESrc8Wi1JFxKIqt8CEtsXq0/eNpAXLjX3cLX0z9noINiI1TVcxaMnN?=
 =?us-ascii?Q?wBBiC4awJEYrsWwPLjs+ZlMU6I+UJphZUPkMxWE06lCIphqXfnXvmfDflP96?=
 =?us-ascii?Q?SiVyPPGaNN/uCfnhRkUAB/1b5AmRTuN4HwLmDGxyomV6WFZv7YrOQVEZjHYj?=
 =?us-ascii?Q?+o28tOzmgmDQmU1/sOOFRjblL3kJgrH105KTmD1dC0M88D99IykvWgLx7NnW?=
 =?us-ascii?Q?Ssc8FKGBttWgXmtGHsUJymXYwZafBACdYFZHwWfo9VkBwjzqJ9ImEP7qspUD?=
 =?us-ascii?Q?/bsNpiQUGYq9j+SBRKn3FIF+sIYSA513k6n50UxKuBqqjBWtgbJZh80g7Mml?=
 =?us-ascii?Q?GOwiIDFMrjybr6Gkr9vtOCqaCiQbjZW5/6bSbu1d1ietiLPlCwKWQ59V9NGL?=
 =?us-ascii?Q?Dc/p4PFCaYiNThvSvWs2Gv4VDx2wB0DULhQXPWDe1sTTlGl19OKQevANviw1?=
 =?us-ascii?Q?ViogNEbcPnyyW2F+2BRsAPGGr8WKorP8BrPJtBW3GELQikHRCSdJ+WFniLEB?=
 =?us-ascii?Q?25FyyYjQi5MYgolpQjDl/P/Qdae7Xw/p9nNjDtojqig9S3tUGOCdyE435hgI?=
 =?us-ascii?Q?Pe9woe9kggJ6ND4FSyTAy9rl9cC2TuyUnNcERnj9FrLZJ9NN02AFg/XSB24K?=
 =?us-ascii?Q?lSuI7va+r750amT438QNESAvLeoY4uX/U+Dk?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o/mNtKg7CGlgNU5WLHnFsvx2oVYP+yQi2Ex1sDiApqFsYYvJbKdhZzke08DG?=
 =?us-ascii?Q?wRD1sDCRJfljVdJXUUiAyRnnw0VLLq6rg2NcPuuecvQwMIbCqjNb7XB+WYtU?=
 =?us-ascii?Q?BFQYr0RvDdmfd/U89EHK9wcrz1yoEMLCgXCYwAGaeB8wZ3oMR5X0vLhzbuBh?=
 =?us-ascii?Q?6o+M8SBVMOnei6ilZOKsyWCU4TEpZMzWqLdfvSa/ivZ0YNfAOGKTUV+Wz60U?=
 =?us-ascii?Q?O7le/g/JaHrSbRMYDhGR5nYNzDhs766IZZR4TSdZKS71XazEiw0rovI63GTy?=
 =?us-ascii?Q?gxQUXRh6r1JLoekxTWcqjaF8pQgm9YWP8YBlg5nQNvl/xYxAMIV5ZhD8F64A?=
 =?us-ascii?Q?BdMvzK2EgYNXUj9K7pSTH2X1r7YoK984hBQwNmKnnAkqJ2dfEddu/RjLJWb6?=
 =?us-ascii?Q?laR8znww90OmUNG0rHdPBNpaDJKaNKVtDGxxSHX4OX2+0DkpAZR2tTGzw/W8?=
 =?us-ascii?Q?MhpGW/f/EdM4tXPjzZqjJYus32TCSrV1KgkjZipjWjnKWfeOX8Hk02ZCGGVI?=
 =?us-ascii?Q?tLXFqkgB2le8zhAYG0vTGf1euGl2p91TN15BsvLQ3bVv2bUN4+yXAbw1IwsN?=
 =?us-ascii?Q?9rOImNS6/6rhtDDBAgiXwrvFyfqdy+sHlXh1p4guncLRy1NP6k77cqZsQizR?=
 =?us-ascii?Q?y71HnI7vlArDzgFtptZrJKowie51NgiKMNGTeuuW/g0UbqnAJi2dMejVuqdh?=
 =?us-ascii?Q?8RqKOZAiL82M/ZLoTXZgs1d3zfqZyGFFuoOxo1WbrHQYbVXxMdJXm2PXt8nE?=
 =?us-ascii?Q?1CVXKnFGWC8pSEzEp0Gz/gvQFhzl6b9ftoNMnJNf46ZJbjnmbpq10DlX7+pQ?=
 =?us-ascii?Q?cRW/DqGf4oxTFhBsMHhk2E53+LbPx7gLxrcJu3XW+GyNcaUeXnd8ZEPMQsKr?=
 =?us-ascii?Q?PFwoestCoy2LG4M//MrKF2o76+568NU25mpurHkdnPtp9gL8yFoZ1UZ/ZepV?=
 =?us-ascii?Q?oi96jumCL+Ghu+FYxzSTjsE0zSuVAgcC9lYJnKZsibjcccVLqXZH4GakPZ9G?=
 =?us-ascii?Q?G+UNOPWFPHPD22Q/d0U2niMbdUwzdcSQ+uEPX/czQ1zUQ8o6G01r8/dibdK7?=
 =?us-ascii?Q?hVUCTr1qFn5r7DhdAj9jZYF2x/E4DKnPZ2etzZiPyYSDeDirm6K7quAoJ1ZL?=
 =?us-ascii?Q?n6B8iXv8RT00UcNDXon9HovXF6cM2ZhwM+QG2gO/Z7fQpgVPfTL11TPfyMOT?=
 =?us-ascii?Q?PvQOalDXX/2R3YjKxtRG4Y0K2k8fcKQDeWvkQ5K5wyqKkkWdhQ53uZDfjbUa?=
 =?us-ascii?Q?nftOWYUk2XTeiA7tVWjc01X3BdvGHjuESTuaV1e7vJevNrG0Il07HGLlIqOk?=
 =?us-ascii?Q?7f1cXe0NlRIOx4WWaJTrPOcd5WDLzhqI25/dQWaY52oBdzOz1OOZrPvLgTYN?=
 =?us-ascii?Q?O7qb/ES3uxts75B+SreJu4un0oKpdyT6fT92JciTc+1v8MOwoubZUvqOsLeu?=
 =?us-ascii?Q?6AS9d3mu1ByRJzNlCPzSYPn/Cm/xqi2phwZt+8eimZ9yI8vIt4qFNtQBMMJW?=
 =?us-ascii?Q?UoKc4IvzvumN1ZXbRYGX/L9KIzZ21/94WrAzssLUd59o9LmFAfaPDiAVagaU?=
 =?us-ascii?Q?1QOpZkMkvprY+UnJMZHHgRxkA+KkiEP8g5HpQXASKvU5vbcMxJ5BIrQO6hT+?=
 =?us-ascii?Q?sw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d92026d7-085a-4d37-cf90-08de011143a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 17:37:59.4065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ca4oHEIIfqrVj9VuZ4Bc/2k1QvNWW4Jr/4aaONZ9jljUerVN3IQBsE/awELCPtanjXHKVj75tX/ECYF0SNp6lZQFtgOpkIxVS3SdmVweV+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9474
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Wednesday, October 1, 2025 8:33 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Tue, Sep 30, 2025 at 09:56:33PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Tuesday, September 30, 2025 2:20 PM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx
> resources
> > > exist from pool creation to deletion.
> > >
> > > > > > > >  static struct zswap_pool *zswap_pool_create(char *compress=
or)
> > > > > > > >  {
> > > > > > > >  	struct zswap_pool *pool;
> > > > > > > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > > > > > > *zswap_pool_create(char *compressor)
> > > > > > > >
> > > > > > > >  	strscpy(pool->tfm_name, compressor, sizeof(pool-
> > > >tfm_name));
> > > > > > > >
> > > > > > > > -	pool->acomp_ctx =3D alloc_percpu(*pool->acomp_ctx);
> > > > > > > > +	/* Many things rely on the zero-initialization. */
> > > > > > > > +	pool->acomp_ctx =3D alloc_percpu_gfp(*pool->acomp_ctx,
> > > > > > > > +					   GFP_KERNEL |
> > > __GFP_ZERO);
> > > > > > > >  	if (!pool->acomp_ctx) {
> > > > > > > >  		pr_err("percpu alloc failed\n");
> > > > > > > >  		goto error;
> > > > > > > >  	}
> > > > > > > >
> > > > > > > > -	for_each_possible_cpu(cpu)
> > > > > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)-
> > > >mutex);
> > > > > > > > -
> > > > > > > > +	/*
> > > > > > > > +	 * This is serialized against CPU hotplug operations. Hen=
ce,
> > > cores
> > > > > > > > +	 * cannot be offlined until this finishes.
> > > > > > > > +	 * In case of errors, we need to goto "ref_fail" instead =
of
> > > "error"
> > > > > > > > +	 * because there is no teardown callback registered anymo=
re,
> > > for
> > > > > > > > +	 * cpuhp_state_add_instance() to de-allocate resources as=
 it
> > > rolls
> > > > > > > back
> > > > > > > > +	 * state on cores before the CPU on which error was
> > > encountered.
> > > > > > > > +	 */
> > > > > > > >  	ret =3D
> > > > > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > > > >  				       &pool->node);
> > > > > > > > +
> > > > > > > > +	/*
> > > > > > > > +	 * We only needed the multi state instance add operation =
to
> > > invoke
> > > > > > > the
> > > > > > > > +	 * startup callback for all cores without cores getting o=
fflined.
> > > Since
> > > > > > > > +	 * the acomp_ctx resources will now only be de-allocated
> > > when the
> > > > > > > pool
> > > > > > > > +	 * is destroyed, we can safely remove the multi state
> > > instance. This
> > > > > > > > +	 * minimizes (but does not eliminate) the possibility of
> > > > > > > > +	 * zswap_cpu_comp_prepare() being invoked again due to a
> > > CPU
> > > > > > > > +	 * offline-online transition. Removing the instance also
> > > prevents race
> > > > > > > > +	 * conditions between CPU onlining after initial pool cre=
ation,
> > > and
> > > > > > > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > > > > > > +	 * Note that we delete the instance before checking the e=
rror
> > > status
> > > > > > > of
> > > > > > > > +	 * the node list add operation because we want the instan=
ce
> > > removal
> > > > > > > even
> > > > > > > > +	 * in case of errors in the former.
> > > > > > > > +	 */
> > > > > > > > +
> > > 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > > > &pool->node);
> > > > > > > > +
> > > > > > >
> > > > > > > I don't understand what's wrong with the current flow? We cal=
l
> > > > > > > cpuhp_state_remove_instance() in pool deletion before freeing=
 up
> the
> > > > > > > per-CPU resources. Why is this not enough?
> > > > > >
> > > > > > This is because with the changes proposed in this commit, the m=
ulti
> > > state
> > > > > > add instance is used during pool creation as a way to create
> acomp_ctx
> > > > > > resources correctly with just the offline/online state transiti=
ons
> > > guaranteed
> > > > > > by CPU hotplug, without needing additional mutex locking as in =
the
> > > > > mainline.
> > > > > > In other words, the consistency wrt safely creating/deleting
> acomp_ctx
> > > > > > resources with the changes being proposed is accomplished by th=
e
> > > hotplug
> > > > > > state transitions guarantee. Stated differently, the hotplug
> framework
> > > > > > helps enforce the new design during pool creation without relyi=
ng on
> the
> > > > > > mutex and subsequent simplifications during zswap_[de]compress(=
)
> > > > > > proposed in this commit.
> > > > > >
> > > > > > Once this is done, deleting the CPU hotplug state seems cleaner=
, and
> > > > > reflects
> > > > > > the change in policy of the resources' lifetime. It also preven=
ts race
> > > > > conditions
> > > > > > between zswap_cpu_comp_prepare() and acomp_ctx_dealloc()
> called
> > > from
> > > > > > zswap_pool_destroy().
> > > > >
> > > > > How is a race with zswap_cpu_comp_prepare() possible if we call
> > > > > cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the
> pool
> > > > > deletion path?
> > > >
> > > > Good point. I agree, calling cpuhp_state_remove_instance() before
> > > > acomp_ctx_dealloc() will not cause a race. However, if we consider =
the
> > > > time from pool creation to deletion: if there is an online-offline-=
online
> > > > transition, can zswap_cpu_comp_prepare() race with the call to
> > > > cpuhp_state_remove_instance()? If so, wouldn't this cause
> unpredictable
> > > > behavior?
> > >
> > > How will this race happen?
> > >
> > > cpuhp_state_remove_instance() is called while a pool is being destroy=
ed,
> > > while zswap_cpu_comp_prepare() while the pool is being created or
> during
> > > CPU onlining.
> > >
> > > The former cannot race, and the latter should be synchronized by hotp=
lug
> > > code.
> > >
> > > >
> > > > I agree, this can occur even with the code in this commit, but ther=
e is
> > > > less risk of things going wrong because we remove the CPU hotplug
> > > > instance before the pool is added to zswap_pools.
> > > >
> > > > Further, removing the CPU hotplug instance directly codifies the
> > > > intent of this commit, i.e., to use this as a facilitator and manag=
e
> memory
> > > > allotted to acomp_ctx, but not to manage those resources' lifetime
> > > > thereafter.
> > > >
> > > > Do you see any advantage of keeping the call to
> > > cpuhp_state_remove_instance()
> > > > occur before acomp_ctx_dealloc() in zswap_pool_destroy()? Please le=
t
> me
> > > know
> > > > if I am missing something.
> > >
> > > What about more CPUs going online? Without the hotplug instance we
> don't
> > > get per-CPU resources for those. We are not using the hotplug mechani=
sm
> > > just to facilitate per-CPU resource allocation, we use it to
> > > automatically allocate resources for newly onlined CPUs without havin=
g
> > > to preallocate for all possible CPUs.
> >
> > This is an excellent point! It makes sense, I will move the call to
> > cpuhp_state_remove_instance() to be before the call to
> > acomp_ctx_dealloc() in zswap_pool_destroy(). Thanks for catching this.
> >
> > >
> > > Also, this makes the code more difficult to reason about, and is an
> > > unncessary change from the current behavior.
> >
> > Ok.
> >
> > >
> > > The only change needed is to drop the teardown callback and do the
> > > freeing in the pool destruction path instead.
> >
> > Just to summarize: besides moving the call to
> cpuhp_state_remove_instance()
> > to zswap_pool_destroy() and more concise comments/commit logs, are
> there
> > other changes to be made in patch 20?
>=20
> I don't believe so. Thanks!

Sounds good, thanks!

Thanks,
Kanchana
