Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFD0306D2A;
	Tue,  9 Dec 2025 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309115; cv=fail; b=lsaCBGhRDgp9aLvjDHhsmjZwVNdbIVdh/FyHULByUwhU0TW0zmAXUrTMUu4BTXjEAxJXRzbdKlrp0TzdY0mTIiO385H0vVUs0gPNKQ6skA5E6dAPAeazEV7Fz5KG7su12dCqx1Es/PtBde6Of/kizfuBuW5SkzoC3rkP7yswcy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309115; c=relaxed/simple;
	bh=AQKqUAiwUUxoA84FZ0OB0h1guDPl+JRFDDeaOrYSm60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eSOaxmtZmNJAD2V3cNuDlZsHiQRWOpNPEcb8HIm72aTUMh7UUXEDHWUQnLdIr9QpnwSdcJTISRKAPXSclqbyta+PyvRAFIJjih2hZ1bb7HHt5Ph6i+mrATZw3G+eMpPNRbArfTPBhGnThH+8aU1u/gPYzwuUi7imt1EnPjQzpd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZuoSadkw; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZuoSadkw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309113; x=1796845113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AQKqUAiwUUxoA84FZ0OB0h1guDPl+JRFDDeaOrYSm60=;
  b=ZuoSadkw6NwYASJcMi1lWZIUcsDQQvEl18FQMFyZd5wtGKF9SvnnCcYb
   0quTQfzyXw77jOdyt7UKFXpempfltqfLIN4UsSZClt6NqgPmSleGjM1l+
   XIEwZBLG2y4m4FuOPHxTue7BZE5/4EYBibPvp3ofEzJfDJY1w0uMt2vXe
   t2eRNcp6L6ObChkqA+7idDgNBKm98Of9s5sdls7nkz47pNdh1TQ+rVhzm
   DgCl4nT69DiL3+LLSuHhMhFDsNFc+lkZiOR91UhonnF8LR90pUmuq4KHL
   fM4DYJvfakXh8jF54W8ejYs9wrdkJ9QUiCKkyLidm7tnOXslH1moT6mx4
   A==;
X-CSE-ConnectionGUID: /966KRUeTTyD78qev1bS1g==
X-CSE-MsgGUID: YSpMohKGTu6og+FS0yhM6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="89926297"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="89926297"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:28 -0800
X-CSE-ConnectionGUID: 0CWMw7H+TOa8tjmwQh4TbQ==
X-CSE-MsgGUID: 28GBxrOFQH6F6usu2GaQTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200479783"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:27 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:27 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:38:27 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.6) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O3j6VKQ7LBHtsheFqGeL2OHNnfyMUqYCyJ/iJzvuIZHxHMZYqcQjw7+2gYOfeI+T5DCKrsUK5UPlyUzLKLlxP1K7VKxOQWVGsSObE27kfW82DzzghRHc6yQd2hiPp7FI6SmiiONT4U38oR6vRoUkLLJdhNxqdYaLNcnp7eLo2U6uvxpThzM5l/83KRyk5lbqd0i8ijb4YYSNizxUyjys2N/HeXhPL8ebSzQgZoWUfX1C6QUt7EQHvtkkqvyscLdslvavxyzRwpm3SIOQ44DtRfhZbV0hU6Av5HEjkbpqN7jVHhRxKvI1LfDlN8z7H1Nbkv9v199DSVWVQf77VserDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/5Fmd5100DjrV/fBPGxM5MC0UvXAyQRl5MAP9sZJr4=;
 b=IbSjDWSQzN6bRcwg/wob0IQKkyFZalYNbFQTPsTwoz+EzNvozlrFHFtRpytH6IqmEwmGl8s5dz4sWKCTLhjrcN+8XwyISVTySUA2YrrCKH3EWrVwIEIT+W7Z+dcnvJGHzDucTjGZ6zTxObw9Mzs8Pkq6QrUgbpiH4Bj12dErpYF3ndI4UTVCE+PoHAPDYzLPB5cC+Yop+dHEP5NhrCIYxP4ae5hkLLvmmFSvfgdTwICspmEHH72DR1JD68JPVnMt6Gmwy3E9+dBpAbhn1CNzL6bXUidx1aTLX7GZKEjagqA9ouAV+FdOPbmFaj2oHHx1uCwzWUzvpVeA2w5RCqdRWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS0PR11MB8738.namprd11.prod.outlook.com (2603:10b6:8:192::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 19:38:21 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 19:38:21 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAV2IAIAAFZkAgADxCICAAAPuIIAABkmAgAAcNRA=
Date: Tue, 9 Dec 2025 19:38:20 +0000
Message-ID: <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
In-Reply-To: <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS0PR11MB8738:EE_
x-ms-office365-filtering-correlation-id: 6e1d3f0b-2379-4a75-261a-08de375a8294
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?mXLxZ0QHWnSr95waudiLiPWerqzHpHJ13bzy+/WJIF8k3V23UEH45nvpeu/B?=
 =?us-ascii?Q?/PXwlhf+lCDebMbsedII7btWIXuyl8u63AoIj/9NuqZ0JE+BhINSeV+WDKYc?=
 =?us-ascii?Q?97etyNZvCx0dRrIpzq4ngHIVqDeqDXa9M8pbuVGp4haK8yb+295YwIzG6CQV?=
 =?us-ascii?Q?SAGHSq8M0nLk5e4E+FN8BJyz+sQIdqen2PGanH2v24I/aX5lt0pq1zCigW5s?=
 =?us-ascii?Q?itOjd0n2OLi4hjYaqAmnRDghZEen21SSwStgrz/q7Go+jd1/20uJhTOF13SZ?=
 =?us-ascii?Q?++W23smkw/RDDtq8Kxbr0IJNScgqU3SigKP3sdjVHi7t05HMK7yNZjEoHh/u?=
 =?us-ascii?Q?J7qIfqaIeX6+3DUCj71xZo8S0cjoVud8BCDU1zn3E1SaEpUVSMDYFMOFiy8n?=
 =?us-ascii?Q?VMyx+KydZx6cPGIuH9OQgLQSuscPpQnSIo5XgAvHoEISn4IDqiGapN2onNP5?=
 =?us-ascii?Q?6tQ7+iV60fkyAcAuBgLISjEru3hBmv6dxcEik9EQVtka7U3hPfS219Tlxtcl?=
 =?us-ascii?Q?JD680NTX+FEjeJrrEI/bcsPt06yqOMZDKFZB1jZcc/8jMG7OwPitOed0mUyN?=
 =?us-ascii?Q?Mx+ya7FeRbHA5ieLhCnBxsy0ouvQElQultnSpAm41Xcw28GKjBvoyJF+LONe?=
 =?us-ascii?Q?wNtR+ko6hwlEnFN+4+ywlHgZd9UxbYSsIO6+PpQkecUVm7M0/NwSpo3B75o7?=
 =?us-ascii?Q?cimO2ANdvKeBrjqtTmyLf3Nd0Uda74SntzfIctz2gdEvA4dv6N2p+9vQUyVA?=
 =?us-ascii?Q?XZgp9dM7FJb5O2tqsA0YyRfQ8QS8tWk08uwteazMuhq/1XygLe42JbvWVTx0?=
 =?us-ascii?Q?jA+Ap++23d9KidpmvadzOINJ7GZnXSdhA5BTdTgp605UoGt5Fwu8oQl3JW5e?=
 =?us-ascii?Q?eimUYxIrENzPSV+c2OXLuvMrme1+zkRXATNxRXieMOGpHc4oxZWS7us6dQS9?=
 =?us-ascii?Q?NXUa+XDqfBv+V7JlwqbTPolOqzzv1lLwuP2ybX5W06btYzCN1QVAx+xirkzr?=
 =?us-ascii?Q?dAkSUElvscd5yvEg9KRRucn4Mic65yolckBLu7wBWQhR/JCfwFtamdonx6af?=
 =?us-ascii?Q?9zq9xb+z2j3+lU8Q+e+FZkkzheAuZ1nUqOr06/V2/sTkU6ilbcExgfCzevIQ?=
 =?us-ascii?Q?MUkFwx2qfRLkjsxGPE4nXVhWE1d2AqAm+NUOhPSnPKGqct/mKH7Xfh4vma3X?=
 =?us-ascii?Q?d2YqWwMaWtkVCk3LTVK8+B/uNVOUAMkUVCQSMjQDpR3DQP/JpdtAMrSD5ctX?=
 =?us-ascii?Q?iuEPOnlyMBbyHVV1SPhRNfV0/DXTH/AtNM2CVuE13vM/jR/KfDTvoZqhRZYD?=
 =?us-ascii?Q?L6GdMiGwgh5dYkwLDgVZsNh/OOTzFtNsFwqCHqmhPh0Q4adkWX4ORft4smq7?=
 =?us-ascii?Q?N1eAvu4IVHRZB4dAv5aUhfF0qsWBc0wN8MjkPAaw/xxQDS580yNHAGXeF83I?=
 =?us-ascii?Q?yjtuQS0SxszGzKRBYajL4CZ9svvVq49goMcIuzm/XjJiXmBSN3RNiw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nBy75xVcSwst4M1XGtDwbajwiUL4HiXMwxc1ssNShyFbllDp7YTAS0MldyG6?=
 =?us-ascii?Q?MjGPBvCCgmx0gUjiXgpvM6juGifq12Z/t+RSkjDmTr0CnchK09+/b8+Nv+HX?=
 =?us-ascii?Q?YRI0IZie3EFrZpYVSNGuvNnEYx53xk38wdVBkGfRanCC5CcBVJZ/chvounWG?=
 =?us-ascii?Q?gqJiofUZT1x8GaPICFyS7JK2XBSp094hpkU2wzb0WBaC26TT1SjeMDPAt4Ql?=
 =?us-ascii?Q?+vbQuBF+2rmIFjqY+HNl3PjSUsm5ylMzMZm2DasCEQk6nN5Y2sPfxumOjY91?=
 =?us-ascii?Q?Zt+RbEo5LtGr5sQ/UKWAEkR2txBC6Im2U4uWv6WVHH+hpYgXl1256KKzgZma?=
 =?us-ascii?Q?aub+e41bcOYnieO9DGtdTRvhxGRY759v92RLeqlliqDZHDk1UZgSeGxgXVqa?=
 =?us-ascii?Q?aJFmDA6iqrsZ9v4OcCDqYAKU5s3151P9fpAKCEudDEwqmSJ/8ykZyFOO5hEC?=
 =?us-ascii?Q?A1DzpDQOBWs4i0CySk8ibVtnqNRLZlQzHdAnCp/fU32Zhm1bqUCNPKCafV/K?=
 =?us-ascii?Q?ayZTZK5O5T6Q47JGY0NYkjt9nOcDehT/LDgIZvrRlgnz0gUOWmptvH5TfAPZ?=
 =?us-ascii?Q?Dm55wwfUzE4cxhxEASYWeYbyr8UGqmKY6V+8cgi2sMKF6cIctQqk8fCxMUvF?=
 =?us-ascii?Q?u/cdFkubehCFnlAssxt1XNgHhk7beLA4ZaEXiDMzyVY6EwpSFc7PbYBbC6ks?=
 =?us-ascii?Q?o08DrRVhu+fvvME2adwJsWwue5wtjqsY2f5ufE8Bdy92UY3+J+CK7zMEHPlv?=
 =?us-ascii?Q?lZWVsUQXD1i6+hyPrf16rE6vV7wtsor7WTnPDczEuPJVeTkbvKNB8odn5afs?=
 =?us-ascii?Q?7k+fJFtCez0Iw/6JlYRPCcIyLogPoz3GMdej9AdnVfwUHf2zPrewQvfPQLuy?=
 =?us-ascii?Q?D8fIfc/EARJH2fetoaYy0d3TJCLjlWUxDeYiwYsf/rq8Lx/Z+wjpNS5n6Ie1?=
 =?us-ascii?Q?Skl9eiiENXfMdx7rzHgvHKLrPF1wf0zlfJlWMFN/C+jm3ug+6jX5gBW6cDi4?=
 =?us-ascii?Q?99EfZaYr8e7Y5IZtd5WtrIO5bBWBeKPJvbVXNzpGgRMEQY6E6xGExFb4lFtL?=
 =?us-ascii?Q?dmxjyqUcDe1p+NayX+ayyxR6pVIYEnhUNA/0z5lWczUgWTqnl4fssBeATts2?=
 =?us-ascii?Q?ehddJeGF8Oh1qVsvBp2Irp4Og8VzoyvKIkulJcO15/+unzCb6bCbl++9tAhu?=
 =?us-ascii?Q?/bCVM/yb9rmw9YNvswjWoC9y8O9FZRykeyGW1exjXm5ftmWHuANjWhhED0xD?=
 =?us-ascii?Q?3MP/DdqeO/j7u3ODNiqTqiE421H2LfHafplCBEGTKkTU7D0lcumEyL8cFsWW?=
 =?us-ascii?Q?OazSbdnqF4InJfdaaHnxSeQZXe6tZmeMMHZPhgKr6ZdMZ8DyUnF1s/faHfsk?=
 =?us-ascii?Q?ml0WMzJ6bfBIGFEVNIXoHcmb2A/P3eohvp0A8bmFysMQX7A2KdBiQ5y0piUj?=
 =?us-ascii?Q?620tgHTjxpxJpi2WmEFtDITkX7xjXfBexr1ThWlua+Dl9QuVgpl68JpG8Jbo?=
 =?us-ascii?Q?FWnhm1w+VdjoSPobXzSFeo3Io039GeoM3u+jXRaXeTfGQVr0rmekKMk5JX1T?=
 =?us-ascii?Q?w4Ov3zHYegCd+gOQWBXLiBmgE/1HSWbc3GSm+zHLVQEH7pPBpc6r7mzkhAaR?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1d3f0b-2379-4a75-261a-08de375a8294
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 19:38:21.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +LZIDi+nciC8E9mkXhWPnvtSI55u7ICqKoPZDQjjHR8YAU1ds/AO//6uPi+r0BXPwzms6xPy3IuYtxswu43f0Qe0+0DjjDkOegHwCS4viWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8738
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, December 9, 2025 9:32 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; SeongJae Park
> <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Tuesday, December 9, 2025 8:55 AM
> > > To: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> > > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > <vinicius.gomes@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>;
> > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> with
> > > compress batching of large folios.
> > >
> > > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > > >
> > > > > Just to clarify, does this mean that zswap can pass a batch of (e=
ight)
> > > > > pages to the acomp API, and get the results for the batch uniform=
ly
> > > > > whether or not the underlying compressor supports batching?
> > > >
> > > > Correct.  In fact I'd like to remove the batch size exposure to zsw=
ap
> > > > altogether.  zswap should just pass along whatever maximum number o=
f
> > > > pages that is convenient to itself.
> > >
> > > I think exposing the batch size is still useful as a hint for zswap. =
In
> > > the current series, zswap allocates as many per-CPU buffers as the
> > > compressor's batch size, so no extra buffers for non-batching
> > > compressors (including SW compressors).
> > >
> > > If we use the same batch size regardless, we'll have to always alloca=
te
> > > 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> > > compressors.
> > >
> > > So we still want the batch size on the zswap side, but we want the
> > > crypto API to be uniform whether or not the compressor supports
> > > batching.
> >
> > Thanks Yosry, you bring up a good point. I currently have the outer for
> > loop in zswap_compress() due to the above constraint. For non-batching
> > compressors, we allocate only one per-CPU buffer. Hence, we need to
> > call crypto_acomp_compress() and write the compressed data to the
> > zs_poll for each page in the batch. Wouldn't we need to allocate
> > 8 per-CPU buffers for non-batching compressors if we want zswap to
> > send a batch of 8 pages uniformly to the crypto API, so that
> > zswap_compress() can store the 8 pages in zs_pool after the crypto
> > API returns?
>=20
> Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> compressors.
>=20
> I think the cleanest way to handle this would be to:
> - Rename zswap_compress() to __zswap_compress(), and make it handle a
>   given batch size (which would be 1 or 8).
> - Introduce zswap_compress() as a wrapper that breaks down the folio
>   into batches and loops over them, passing them to __zswap_compress().
> - __zswap_compress() has a single unified path (e.g. for compressed
>   length and error handling), regardless of the batch size.
>=20
> Can this be done with the current acomp API? I think all we really need
> is to be able to pass in a batch of size N (which can be 1), and read
> the error and compressed length in a single way. This is my main problem
> with the current patch.

Once Herbert gives us the crypto_acomp modification for non-batching
compressors to set the acomp_req->dst->length to the
compressed length/error value, I think the same could be accomplished
with the current patch, since I will be able to delete the "errp". IOW, I t=
hink
a simplification is possible without introducing __zswap_compress(). The
code will look seamless for non-batching and batching compressors, and the
distinction will be made apparent by the outer for loop that iterates over
the batch based on the pool->compr_batch_size in the current patch.

Alternately, we could introduce the __zswap_compress() that abstracts
one single iteration through the outer for loop: it compresses 1 or 8 pages
as a "batch". However, the distinction would still need to be made for
non-batching vs. batching compressors in the zswap_compress() wrapper:
both for sending the pool->compr_batch_size # of pages to
__zswap_compress() and for iterating over the single/multiple dst buffers
to write to zs_pool (the latter could be done within __zswap_compress(),
but the point remains: we would need to distinguish in one or the other).

It could be argued that keeping the seamless-ness in handling the calls to
crypto based on the pool->compr_batch_size and the logical distinctions
imposed by this in iterating over the output SG lists/buffers, would be
cleaner being self-contained in zswap_compress(). We already have a
zswap_store_pages() that processes the folio in batches. Maybe minimizing
the functions that do batch processing could be cleaner?

In any case, let me know which would be preferable.

Thanks,
Kanchana

>=20
> In the future, if it's beneifical for some SW compressors to batch
> compressions, we can look into optimizations for the per-CPU buffers to
> avoid allocating 8 pages per-CPU (e.g. shared page pool), or make this
> opt-in for certain SW compressors that justify the cost.
>=20
> >
> > Thanks,
> > Kanchana
> >
> > >
> > > >
> > > > Cheers,
> > > > --
> > > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Home Page: http://gondor.apana.org.au/~herbert/
> > > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
