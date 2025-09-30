Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DC61474CC;
	Tue, 30 Sep 2025 21:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759266040; cv=fail; b=Nf4EnMVK1Vrw3Iv+j1FtUXly7qtOYqXstUSzIkxy4LTtoO5MB8C+ZyQTz+uNrPVy+4/bwCsL4UgQzaiKdlDIwGvMnsHOwWnxJ5kMhwoHovFgU09WiL+7XY/kxXpi1ARi5zrcgz3Ab4pjwDcQugvGyRJ/rEIMb0qE0Yr1hFEMa7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759266040; c=relaxed/simple;
	bh=uAHLiBHyG8+YSb8mPbkDxBA43lxzzBEPhPQeMLW9h0s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iVb4Obu6Vp/4Eha57fI/7K0WKjhpK7XRiOgjEkv05xWRD0oJ1wgLtCJAjSbzmG0iS5Bzosr4K/eAVXrn3kx3h3yvXQOkzmuC1ed3pExtU+VpqqOxhU1I5TKR1VTgrwbrcBkdKpmoiziBZ+BY1ZPPoH8nZS93OoKN+zKtIu5IWAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKCeQoj7; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKCeQoj7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759266038; x=1790802038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uAHLiBHyG8+YSb8mPbkDxBA43lxzzBEPhPQeMLW9h0s=;
  b=oKCeQoj7vatqBPYJhQIXzJaqZKZHTVA9Zmw/v1b68uKz+uDvzdQlh3qV
   5hSBGJDL1SqBcaU4XONVF2czIM7NFs9+usqnXAl4EfH/uJyALE3M1XLdb
   z+5rwYd799PkbWvZJ2Toi46jFCN0hOVBS3wSBrMzDj47W3u0DFm9wOvNU
   egtN7xMID9oMiIj0Os8ixzLDcajXrqELGK5eAYbu4v/FGe1bv6DDFIKx1
   8bVjjRBbXN8cXn2/uPu7K1Z5VQNEVt4g0DyRQH8XCzd8AS475y1Dlyfgt
   eymWntePJQzFB4cOgOtOAnlKVokzwZAL9Gedn8Zmilv6lQimYeW37OyO6
   A==;
X-CSE-ConnectionGUID: DBV7jlo4Tji2fCC5JyYzZA==
X-CSE-MsgGUID: rng/nqaVT76gT+VD+fvdgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="72636771"
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="72636771"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 14:00:37 -0700
X-CSE-ConnectionGUID: JG8O90ykRAes7sfyU7QO3Q==
X-CSE-MsgGUID: JfaBrE8SSb2GJC0uMNflEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="215752566"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 14:00:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 14:00:34 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 14:00:34 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.64)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 14:00:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7GiveL/dTmFybgJMZwJ2AdcACLe3V7K7wk9i8AHXypDH149LnYm6+HoNMqqCyFnkjsxgcoPkFfb2bge9UoqJ110N3GXxLKEHSvZ4LtDMmKRF4caW6FBrecd4/JnF7rTxEtYOaWKnwPCY/O51xcn8ofnIXmiFmw/zW5pvxLqJkeT//5x/LHksla5/EG2YwnGMUsa2hkGJ4CVv0TNDJO9zuU6b1cCH+B4C54egEa8r/VXWVW2zkU5MMDmXcCNQHI1hvmmpg/ffUYUkdOE2uTPJ5E7p6kSNRL/7wCR5DWQQzfWARkOX3Fc8E3ocRidvXVfIfiN32Mh9sMwUDvk1W1+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLGpdDx8oh/37dEsK8F+XJOlQ8BOjbXtOAkypnG/vGI=;
 b=RJJd3qxVwFfhx2gw8S1NgciP8l0fOEK8V+nwV643tLj3jAk/UjiYulvpoZApUhD7olNo6n6pROZBfb4O+l62y3VLSI2xT5mwLrzFs4RAJFvwd9ObAKui1twZ7S3kK9c1+XI6/G5wzqTQff+cpb3u0V+MBr2ib35OPOLbcwkyXkLvA4exdzmFBhp1cHJRXnhF8+D/8stY7ZqwQDwMViCjOLkcqtfA7iO7t4FldGCcGnU3fYaE7RPclZ2DZa4rvoR8OrY+cbMc+HgCMQ96CwPnKu8PZFTAqNEoo+xbxCm25z2s+gw/d2y5Lh8o8bGuBqJZMdS4ksnWVf2Ayyq5SQZvMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by DS7PR11MB6015.namprd11.prod.outlook.com (2603:10b6:8:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 30 Sep
 2025 21:00:31 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%4]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 21:00:31 +0000
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
Thread-Index: AQHcLpaVftDjct+5Jkq/fUkbn0Rx3bSr5mcAgAAXwZCAABUagIAAJKsw
Date: Tue, 30 Sep 2025 21:00:31 +0000
Message-ID: <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
In-Reply-To: <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|DS7PR11MB6015:EE_
x-ms-office365-filtering-correlation-id: af387917-b32e-4acc-2916-08de0064644c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?eqR4Yk7OYClC0I8Sn3X4ZONW7Fyvo12hNNVmJHVK9G69JZCGKXqJSu0PcNoW?=
 =?us-ascii?Q?GOASmnMGWiLfFFqhnOLFqZC86LmBekqqpKxgaysfsON0zj1Kp6CawzDjHMPz?=
 =?us-ascii?Q?vg1732ZpxsSr7o9aX8Q1W+z6075bIi6KXRi7DSBcyVYjbnusvV5fbkO0a9de?=
 =?us-ascii?Q?Bk/zcVpdZf+YJuXn57OSEb3gf1d1Zptpnc4xYx0BpJ/bImgXxvl/Upecpskj?=
 =?us-ascii?Q?xw/ZOxgs8gjHDvj5EOlLzoWH5uMKdMDCbhVt35VpLX0qwJKs1sUdOLNEeYe8?=
 =?us-ascii?Q?Smb3R4fNyHOVew+3z66igGexYw8xGuTDictdyE0kxhT8mMy7jCht8C7h2xjs?=
 =?us-ascii?Q?1XXnwRJ2y6szi8RWGNsRL43vgZSVuQEYUoDEZGh07iHx/Wvn1vtLJXPAQdCe?=
 =?us-ascii?Q?dOXA73VIBr4WOKxXGmWc01ucAiZoFKLKItjBWUuJLetdVPeQxKnQQ2k8GxSi?=
 =?us-ascii?Q?3m4d0ibwYocqYmKAgNmpDBbYWaEwaX23gzBufjqiNS43Ti4BCOz6S6ylb7I6?=
 =?us-ascii?Q?dlASrncfU134KDsz1kxgXAtgL+IP2A1aH5fSM5Mz8PnL+XvkQpaCIKAGY8BB?=
 =?us-ascii?Q?8Kl865gsTGprpVq9QdFQ6G5ZqIFBWlkbXcSKg147rZR934UM8pFWBvj1rtaG?=
 =?us-ascii?Q?ZkWhtZITZ2zsHLKoBnWwmf8IjTe1aG2iaVLHxzUm3soYZHv1r5LUUrpYl3/0?=
 =?us-ascii?Q?67tF5sB+X5jmB58vP6QmDEcQkUEP6bpLBS9M6NDi4xl0uWvpRfm8uaH+JZ+n?=
 =?us-ascii?Q?3FG0RqwqU/xTv0VoiGWqPMJUZzfkR5fZ0xgO5EOYgbgM6T8mooK/JdfV/+QO?=
 =?us-ascii?Q?wmx/vY+5jC5AWLTdEiSlg+6j7zUOLuWE3MhQL0uwNVmHpK7Zytx75kMFZiC6?=
 =?us-ascii?Q?/DKC2vF8KROLVS5sxyWGLhX3wJG2CH/qMKrgXOAOjJasf+2OHmPWusvfmvy8?=
 =?us-ascii?Q?ydtIUYspiOS1rr/zvmV7U1DI/Os4E25923+dNlzCekAgibKGftoe+omTjQvi?=
 =?us-ascii?Q?1vMKY3XRrwooRXCzs5+OzC0k3rBnrqlF9j/wabJHDYQBd0wXRHOTklFZgmgv?=
 =?us-ascii?Q?RODb58cHiVhU4zgmrfq1dZLj/AHIm3+mVMxdx18Hkgh/v4djhLLgavez2CAF?=
 =?us-ascii?Q?gfb5QmpjOY7qYlUsrjaQCEq1SFml5aJeG6CvrEOotwNSkiwZ9dO7vupzTdN4?=
 =?us-ascii?Q?qbxlq4Dgm8WY5FVq6aCFEMVT9kZTqi53hCT2pQtYXM+nBafolwzpjxEd/OK0?=
 =?us-ascii?Q?7ACEm4dmHYDCmVD5QD9d0VJ3vzq40f/p8hoGE36jvDDXLYFd0lkdckNdIxfx?=
 =?us-ascii?Q?D1wN6etQIvKVXLqJlcqghBIhNL6D8h5Qq6h+DF8fiNYkNZAWbgOfAVvzPb0a?=
 =?us-ascii?Q?0PUXQrIwdktVEvdj0gyZOzMOjy0Sm2G7naaaEFkoNRFOFMaLp3RSRPhCzYwg?=
 =?us-ascii?Q?CSZbAhFvpkOCdhae2Wfs4CpE+6Lv3wYFBiRgE8/FRv/p6BafHlcAvO6XSPkb?=
 =?us-ascii?Q?HFtg3GGEwUGyMNiwLgAJSwPPghZNSlWChraR?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PxSoQCRIKxnJYLYiACRYiSmTjEOFs/gW2mx4DJgyPAu+avX8+VXGmvNbgIih?=
 =?us-ascii?Q?Nvov7dUYG+R0TVshZr3aN71kx4681EKUdsyImdRNNLl/kQv1XA0XXzFAvRWO?=
 =?us-ascii?Q?Dbk45OxG7aMcNYxuPju/rJUFrRIUUXtW0WlRvMYe/ZYBBNaBWg0yxJztI0WG?=
 =?us-ascii?Q?LmaY/9feMJc/w6uELcb8vssdBB4e5MJvFf8hP2IX8dz3jcyJeWVq3HRuH0SU?=
 =?us-ascii?Q?gHoPr6rU+zGJPrwCnz8Ie/Z7vlbd64rxsQhgspgyoFKo9RqV8s6ApQkCrLrG?=
 =?us-ascii?Q?NoMfX64lJ2glwtnMTSjHqx9Ce0L4NxaaOJODme//9GjHSfZ20Kgnt+93hFqV?=
 =?us-ascii?Q?GpmD6umoelNml1DFGQCZL/ERSfBOvMYLBeLZIXexC9N4awuLNk3ZCgkcBkrM?=
 =?us-ascii?Q?OUnbBM4XtFWM6LM0gt0vOTHGLGYXzGO1PKjkalgGCCqKOctSR0z3fxF6S2tN?=
 =?us-ascii?Q?91ovvOVf12xXzofA2MxUyy6fcEYWmpOP8aLPBpcX8KqgLBigeBrp2wv/fcBp?=
 =?us-ascii?Q?1xJ0HNRGygggMBarKNIUoueNWmiQWuzm9A37VFfg2ivmgtC/k7r3gdOIgdvL?=
 =?us-ascii?Q?7Rj72r0iMgVp3WOY6yBTsuG910p27VsymZyEkZiFZP3A9BndPW+Xt488rNE8?=
 =?us-ascii?Q?PUpjKyg1KKHEhUIlq67XMg2AtPuMEwIoR4U3zb89/TJNf1zbVgtzaANchXzV?=
 =?us-ascii?Q?+JRip7lZPF6GCVEg822QRPcmdIrWcMUinljWZ+K03d9VfXiNhceDo4IR3IYE?=
 =?us-ascii?Q?GYDfCYEkckpoW7RVSg1e1LqaDTtInVHFvQb+oP0G7gW9PF2DDUXrkCG+ou8h?=
 =?us-ascii?Q?IgD2GY9Ponu/t3OCCPBUcYLo4VVTHGIU7rNGTRYAHpatQc+4+4yyXRRfjxwV?=
 =?us-ascii?Q?QUE6AYu/+6DIgAwhxIiehmo6M1HKEo7vx6u20jLPaisOKIxdQB32WWPvpfaZ?=
 =?us-ascii?Q?Dayerk6F18D6mAEZ08BI7Sqb/HVmeNA9KFD9/L9ly32/Flq10v40BU8secRL?=
 =?us-ascii?Q?mD4rRIbTxzsn43jABo3jqLbYAZ9oF+lsaRjxr9OrTBJMNEUo6hkJSxBDGN8r?=
 =?us-ascii?Q?udpxz9Fw2o7se0451MGf2jumB+eMhajL7ETF6FdxZeol2CJmVX7xiRTgqPMD?=
 =?us-ascii?Q?rEgcqmIB862yxGscyqqg4NsHygZgB8sny3nq0YtD9bquNFw5hQt0Usrs/Hsr?=
 =?us-ascii?Q?AThmqgOS3zgigAnq9bmtOlYyuwqmzAbhnHDmzRcbK2f37gxc5Yd6tOyqEUX3?=
 =?us-ascii?Q?bvfV/N9qKZSj2i/rwOtapzofaChIqgEt2ojMU4z3VMSHblzCzwbOXGsFTwbd?=
 =?us-ascii?Q?6VVoNXTu/bcdGhWuVmbdAwipB6jdAf79b1lHbkMwA2Yq8mA2cgXmRkeoeW/H?=
 =?us-ascii?Q?qSwPCo/XQNFnraK/89y2oZnYkk4ZABRFIG7PWtRT7B3f24/kVAzP8prnLXUn?=
 =?us-ascii?Q?RkaMpYOYtxihSWkPGTFEL2ZrR3UoOASqDtCW9fMmJdsFZwMmle2fH6AX9kzD?=
 =?us-ascii?Q?JGF4y6nHZL9ikPOdHbICYYPdvPPY9ke8yW/GrjaIotUc/PyGkIeKc1+LnuKm?=
 =?us-ascii?Q?fbCKWNrAmZ8uE35UhonBIf4e5odPwPyw6ubef0O5Lt6yJ54cKwgnY1QoVsXR?=
 =?us-ascii?Q?gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af387917-b32e-4acc-2916-08de0064644c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 21:00:31.2499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZELsKBhAafEFS3SVw0leLFM9dMLsEdjYyMIyfMWAB5DkgzTjFFCXhq2Ct0lYtqkEs7529tDMQUh94QRuyNpJoGMVzD/kVSNAEkDs/zxq0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6015
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, September 30, 2025 11:30 AM
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
> On Tue, Sep 30, 2025 at 06:20:13PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Tuesday, September 30, 2025 8:49 AM
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
> > > On Thu, Sep 25, 2025 at 08:34:59PM -0700, Kanchana P Sridhar wrote:
> > > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be f=
rom
> > > > pool creation to pool deletion. These resources will persist throug=
h CPU
> > > > hotplug operations. The zswap_cpu_comp_dead() teardown callback
> has
> > > been
> > > > deleted from the call to
> > > > cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> result,
> > > CPU
> > > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > > resources are concerned.
> > > >
> > > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > > new function acomp_ctx_dealloc() that preserves the
> IS_ERR_OR_NULL()
> > > > checks on acomp_ctx, req and acomp from the existing mainline
> > > > implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is
> called
> > > > to clean up acomp_ctx resources from all these procedures:
> > > >
> > > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > > 2) zswap_pool_create() when an error is encountered, and
> > > > 3) from zswap_pool_destroy().
> > > >
> > > > The main benefit of using the CPU hotplug multi state instance star=
tup
> > > > callback to allocate the acomp_ctx resources is that it prevents th=
e
> > > > cores from being offlined until the multi state instance addition c=
all
> > > > returns.
> > > >
> > > >   From Documentation/core-api/cpu_hotplug.rst:
> > > >
> > > >     "The node list add/remove operations and the callback invocatio=
ns are
> > > >      serialized against CPU hotplug operations."
> > > >
> > > > Furthermore, zswap_[de]compress() cannot contend with
> > > > zswap_cpu_comp_prepare() because:
> > > >
> > > >   - During pool creation/deletion, the pool is not in the zswap_poo=
ls
> > > >     list.
> > > >
> > > >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry poi=
nted
> > > >     out. zswap_cpu_comp_prepare() will be executed on a control CPU=
,
> > > >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section
> of
> > > "enum
> > > >     cpuhp_state". Thanks Yosry for sharing this observation!
> > > >
> > > >   In both these cases, any recursions into zswap reclaim from
> > > >   zswap_cpu_comp_prepare() will be handled by the old pool.
> > > >
> > > > The above two observations enable the following simplifications:
> > > >
> > > >  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim canno=
t
> > > use
> > > >     the pool. Considerations for mutex init/locking and handling
> > > >     subsequent CPU hotplug online-offlines:
> > > >
> > > >     Should we lock the mutex of current CPU's acomp_ctx from start =
to
> > > >     end? It doesn't seem like this is required. The CPU hotplug
> > > >     operations acquire a "cpuhp_state_mutex" before proceeding, hen=
ce
> > > >     they are serialized against CPU hotplug operations.
> > > >
> > > >     If the process gets migrated while zswap_cpu_comp_prepare() is
> > > >     running, it will complete on the new CPU. In case of failures, =
we
> > > >     pass the acomp_ctx pointer obtained at the start of
> > > >     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, c=
an
> > > >     only undergo migration. There appear to be no contention scenar=
ios
> > > >     that might cause inconsistent values of acomp_ctx's members. He=
nce,
> > > >     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> > > >     zswap_cpu_comp_prepare().
> > > >
> > > >     Since the pool is not yet on zswap_pools list, we don't need to
> > > >     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). =
This
> > > >     has been restored to occur in zswap_cpu_comp_prepare().
> > > >
> > > >     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> > > >     valid. If so, it returns success. This should handle any CPU
> > > >     hotplug online-offline transitions after pool creation is done.
> > > >
> > > >  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> > > >     migrated to another CPU before the current CPU is dysfunctional=
. If
> > > >     zswap_[de]compress() holds the acomp_ctx->mutex lock of the
> offlined
> > > >     CPU, that mutex will be released once it completes on the new
> > > >     CPU. Since there is no teardown callback, there is no possibili=
ty of
> > > >     UAF.
> > > >
> > > >  3) Pool creation/deletion and process migration to another CPU:
> > > >
> > > >     - During pool creation/deletion, the pool is not in the zswap_p=
ools
> > > >       list. Hence it cannot contend with zswap ops on that CPU. How=
ever,
> > > >       the process can get migrated.
> > > >
> > > >       Pool creation --> zswap_cpu_comp_prepare()
> > > >                                 --> process migrated:
> > > >                                     * CPU offline: no-op.
> > > >                                     * zswap_cpu_comp_prepare() cont=
inues
> > > >                                       to run on the new CPU to fini=
sh
> > > >                                       allocating acomp_ctx resource=
s for
> > > >                                       the offlined CPU.
> > > >
> > > >       Pool deletion --> acomp_ctx_dealloc()
> > > >                                 --> process migrated:
> > > >                                     * CPU offline: no-op.
> > > >                                     * acomp_ctx_dealloc() continues
> > > >                                       to run on the new CPU to fini=
sh
> > > >                                       de-allocating acomp_ctx resou=
rces
> > > >                                       for the offlined CPU.
> > > >
> > > >  4) Pool deletion vis-a-vis CPU onlining:
> > > >     To prevent possibility of race conditions between
> > > >     acomp_ctx_dealloc() freeing the acomp_ctx resources and the ini=
tial
> > > >     check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(),
> we
> > > >     need to delete the multi state instance right after it is added=
, in
> > > >     zswap_pool_create().
> > > >
> > > >  Summary of changes based on the above:
> > > >  --------------------------------------
> > > >  1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() t=
o
> > > >     simplify and share common code for different error handling/cle=
anup
> > > >     related to the acomp_ctx.
> > > >
> > > >  2) Remove the node list instance right after node list add functio=
n
> > > >     call in zswap_pool_create(). This prevents race conditions betw=
een
> > > >     CPU onlining after initial pool creation, and acomp_ctx_dealloc=
()
> > > >     freeing the acomp_ctx resources.
> > > >
> > > >  3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-alloca=
te
> > > >     the per-CPU acomp_ctx resources.
> > > >
> > > >  4) Changes to zswap_cpu_comp_prepare():
> > > >
> > > >     a) Check if acomp_ctx->acomp is valid at the beginning and retu=
rn,
> > > >        because the acomp_ctx is already initialized.
> > > >     b) Move the mutex_init to happen in this procedure, before it
> > > >        returns.
> > > >     c) All error conditions handled by calling acomp_ctx_dealloc().
> > > >
> > > >  5) New procedure acomp_ctx_dealloc() for common error/cleanup
> code.
> > > >
> > > >  6) No more multi state instance teardown callback. CPU offlining i=
s a
> > > >     no-op as far as acomp_ctx resources are concerned.
> > > >
> > > >  7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directl=
y
> > > >     call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx-
> > > >mutex)
> > > >     in zswap_[de]compress().
> > > >
> > > > The per-CPU memory cost of not deleting the acomp_ctx resources
> upon
> > > CPU
> > > > offlining, and only deleting them when the pool is destroyed, is as
> > > > follows, on x86_64:
> > > >
> > > >     IAA with 8 dst buffers for batching:    64.34 KB
> > > >     Software compressors with 1 dst buffer:  8.28 KB
> > > >
> > > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > >
> > > Please try to make the commit logs a bit more summarized. Details are
> > > helpful, but it's easy to lose track of things when it gets too long.
> >
> > Thanks Yosry, for the feedback.
> >
> > >
> > > > ---
> > > >  mm/zswap.c | 194 +++++++++++++++++++++++++------------------------=
-
> ---
> > > >  1 file changed, 93 insertions(+), 101 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index c1af782e54ec..27665eaa3f89 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -242,6 +242,30 @@ static inline struct xarray
> > > *swap_zswap_tree(swp_entry_t swp)
> > > >  **********************************/
> > > >  static void __zswap_pool_empty(struct percpu_ref *ref);
> > > >
> > > > +/*
> > > > + * The per-cpu pool->acomp_ctx is zero-initialized on allocation. =
This
> > > makes
> > > > + * it easy for different error conditions/cleanup related to the
> acomp_ctx
> > > > + * to be handled by acomp_ctx_dealloc():
> > > > + * - Errors during zswap_cpu_comp_prepare().
> > > > + * - Partial success/error of cpuhp_state_add_instance() call in
> > > > + *   zswap_pool_create(). Only some cores could have executed
> > > > + *   zswap_cpu_comp_prepare(), not others.
> > > > + * - Cleanup acomp_ctx resources on all cores in zswap_pool_destro=
y().
> > > > + */
> > >
> > > Comments describing specific code paths go out of date really fast. T=
he
> > > comment is probably unnecessary, it's easy to check the allocation pa=
th
> > > to figure out that these are zero-initialized.
> > >
> > > Also in general, please keep the comments as summarized as possible,
> and
> > > only when the logic is not clear from the code.
> >
> > Sure. I have tried to explain the rationale for significant changes, bu=
t I can
> > look for opportunities to summarize. I was sort of hoping that v12 woul=
d
> > be it, but I can work on the comments being concise if this is crucial.
> >
> > >
> > > > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > > > +{
> > > > +	if (IS_ERR_OR_NULL(acomp_ctx))
> > > > +		return;
> > > > +
> > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > > > +		acomp_request_free(acomp_ctx->req);
> > > > +
> > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > > +		crypto_free_acomp(acomp_ctx->acomp);
> > > > +
> > > > +	kfree(acomp_ctx->buffer);
> > > > +}
> > > > +
> > > >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > > >  {
> > > >  	struct zswap_pool *pool;
> > > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > > *zswap_pool_create(char *compressor)
> > > >
> > > >  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> > > >
> > > > -	pool->acomp_ctx =3D alloc_percpu(*pool->acomp_ctx);
> > > > +	/* Many things rely on the zero-initialization. */
> > > > +	pool->acomp_ctx =3D alloc_percpu_gfp(*pool->acomp_ctx,
> > > > +					   GFP_KERNEL | __GFP_ZERO);
> > > >  	if (!pool->acomp_ctx) {
> > > >  		pr_err("percpu alloc failed\n");
> > > >  		goto error;
> > > >  	}
> > > >
> > > > -	for_each_possible_cpu(cpu)
> > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > > > -
> > > > +	/*
> > > > +	 * This is serialized against CPU hotplug operations. Hence, core=
s
> > > > +	 * cannot be offlined until this finishes.
> > > > +	 * In case of errors, we need to goto "ref_fail" instead of "erro=
r"
> > > > +	 * because there is no teardown callback registered anymore, for
> > > > +	 * cpuhp_state_add_instance() to de-allocate resources as it roll=
s
> > > back
> > > > +	 * state on cores before the CPU on which error was encountered.
> > > > +	 */
> > > >  	ret =3D
> > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > >  				       &pool->node);
> > > > +
> > > > +	/*
> > > > +	 * We only needed the multi state instance add operation to invok=
e
> > > the
> > > > +	 * startup callback for all cores without cores getting offlined.=
 Since
> > > > +	 * the acomp_ctx resources will now only be de-allocated when the
> > > pool
> > > > +	 * is destroyed, we can safely remove the multi state instance. T=
his
> > > > +	 * minimizes (but does not eliminate) the possibility of
> > > > +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> > > > +	 * offline-online transition. Removing the instance also prevents=
 race
> > > > +	 * conditions between CPU onlining after initial pool creation, a=
nd
> > > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > > +	 * Note that we delete the instance before checking the error sta=
tus
> > > of
> > > > +	 * the node list add operation because we want the instance remov=
al
> > > even
> > > > +	 * in case of errors in the former.
> > > > +	 */
> > > > +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > &pool->node);
> > > > +
> > >
> > > I don't understand what's wrong with the current flow? We call
> > > cpuhp_state_remove_instance() in pool deletion before freeing up the
> > > per-CPU resources. Why is this not enough?
> >
> > This is because with the changes proposed in this commit, the multi sta=
te
> > add instance is used during pool creation as a way to create acomp_ctx
> > resources correctly with just the offline/online state transitions guar=
anteed
> > by CPU hotplug, without needing additional mutex locking as in the
> mainline.
> > In other words, the consistency wrt safely creating/deleting acomp_ctx
> > resources with the changes being proposed is accomplished by the hotplu=
g
> > state transitions guarantee. Stated differently, the hotplug framework
> > helps enforce the new design during pool creation without relying on th=
e
> > mutex and subsequent simplifications during zswap_[de]compress()
> > proposed in this commit.
> >
> > Once this is done, deleting the CPU hotplug state seems cleaner, and
> reflects
> > the change in policy of the resources' lifetime. It also prevents race
> conditions
> > between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called from
> > zswap_pool_destroy().
>=20
> How is a race with zswap_cpu_comp_prepare() possible if we call
> cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the pool
> deletion path?

Good point. I agree, calling cpuhp_state_remove_instance() before
acomp_ctx_dealloc() will not cause a race. However, if we consider the
time from pool creation to deletion: if there is an online-offline-online
transition, can zswap_cpu_comp_prepare() race with the call to
cpuhp_state_remove_instance()? If so, wouldn't this cause unpredictable
behavior?

I agree, this can occur even with the code in this commit, but there is
less risk of things going wrong because we remove the CPU hotplug
instance before the pool is added to zswap_pools.

Further, removing the CPU hotplug instance directly codifies the
intent of this commit, i.e., to use this as a facilitator and manage memory
allotted to acomp_ctx, but not to manage those resources' lifetime
thereafter.

Do you see any advantage of keeping the call to cpuhp_state_remove_instance=
()
occur before acomp_ctx_dealloc() in zswap_pool_destroy()? Please let me kno=
w
if I am missing something.

Thanks,
Kanchana

>=20
> >
> > The only cleaner design I can think of is to not use CPU hotplug callba=
cks
> > at all, instead use a for_each_possible_cpu() to allocate acomp_ctx
> > resources. The one benefit of the current design is that it saves memor=
y
> > if a considerable number of CPUs are offlined to begin with, for some
> > reason.
> >
> > Thanks,
> > Kanchana
