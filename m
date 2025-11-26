Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F4523AB9D;
	Wed, 26 Nov 2025 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764187547; cv=fail; b=MunCTYEQ/TTQ83ArDNqjJ0gmaNgRwHkEOubvztJAidUBwGSDDU0UdojPIk4CM7VsiyPSVsjWl6hpTvExZTcm9OrkuT/fk9d8tZnS4FNjXycGAu2/iGH4RcMxP+OpB2S25OTH/rMi5tL6JUYAGr2SrRZCbiQn1dDGl2L20tQxBU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764187547; c=relaxed/simple;
	bh=oNRNsU5J8wnsAngIJvswOlEVp4DB3bztbF3SSDVkoIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lK6OT/BgnUGiJVOe1xnqXAcGf5tWMk2TDD7YMumOR0GuoXJyE7oq0GyMjqMQga49vGzp4u0oQr8PjriQdpHx/09awjRehlXxdzBUhhnUduEuEE4DSwBLwcl97xrcGJACf5VPYu6ym4ZHcSH+1sduARsXc+721aGR4WE8xvQI3s8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MOqRAvcn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MOqRAvcn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764187545; x=1795723545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oNRNsU5J8wnsAngIJvswOlEVp4DB3bztbF3SSDVkoIk=;
  b=MOqRAvcncg8/hdWgefChDIAoYa1A0jMHT/gOszTpDHZw+2XMcsPcdIc8
   gQZSP1Ux4CfdIYTk0ZCJMXUuSHVz7Th/QwKR7zm0Gy1Re5v/JCYkPqCsg
   WJ6jEU5p0xGtiNFCoDK6xuN1DFoJgEsKgv/X8+5RdHf7X0MqxeFTebMgG
   fxJBuuWfWZf9yDPPnij92VXX/86B+WccU4NhSGpX3m2uerC21VZuQNqOC
   OgOw0wBGYxRXW+Z+FxUv29+j7Qq67Cwm5v1LUTMsK3xBsFpR9R3pbeRwE
   g9myKR+K7ZXZV9CNEZ1yvg6TJNw7SIwBj3XfW+ahH6A7K4Ye8SBQGFylk
   w==;
X-CSE-ConnectionGUID: SZzu1O8kQt2Su8B9JbhDmw==
X-CSE-MsgGUID: lKd0UV+tTFe33Z3y53hWjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="70095534"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="70095534"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:05:44 -0800
X-CSE-ConnectionGUID: 4oKXDtexTsCGf1SumLnWMQ==
X-CSE-MsgGUID: 6IkvMB6gQ5+iG0PVvSjZaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="198148668"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:05:44 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:05:43 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 12:05:43 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.60)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:05:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b5tIPn+F8woL6yB0zZNoRyWo6BZegRwL10GaIXXEV4+L8F3XseIkgCrRAkbrZuUJBtAdwgwugzQUQF2TrAurjEWtmFkNdNI6U0XFSaE9S1UJVO3eg28PMc5mEwmY/+ny6CHtP9iSOpyuW6Tjnji1Z7Pypq9whL36YcDNjM+Fuf8xvb4JvZcAYDajSN8PdOPpOzbpwg5kXI5gBCP0Rnls4ImNj3Wgjug6cb4QbvsqJtR2joGIQqECn6RfnWq8d3DpIjWfq8Vm6gkUW6ta24wx90uIPMDeWPdxP9C9SmKLNBp6pTVJDD1i6JPZgG2zA77d+qgBuom0Hxq473n2fdduGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo+rlc0JwB2D2BEysHHzVl7tLoYSlsFdR2YHJdEltfQ=;
 b=xja8suTrbSunsBLBfowfV3L9Tcx23PZPfNVFwKQDjs/7fiJvK/GnDfQ+YHZDq3warpQBTCA+fIXoeMTiWuqDneJZRYmN0JzyjQbBu5ylARg8pXpbnrqeLZdS1jABA65lrFsdqoHpg19OwHLexLS8XuTh1Z7Iuz6uZ37fYwK56NZHlQMvm+8f8Zc/Kdiiq79dRlAvbzAj5ap8vW6BugvJJGyVPUJ6UQfVzLwzs274SNd3P9+kH+uoYBNPUP6TtfdrakgbBE0R6cc8TYThAW7Rw27SXuIuU7+a0bgzrfOruKNhNrNnaPtfnDd66Tuo5pPR/yAsyUnNa/dfOh6EE9+Utg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20)
 by LV8PR11MB8560.namprd11.prod.outlook.com (2603:10b6:408:1e7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 26 Nov
 2025 20:05:40 +0000
Received: from SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::4255:20e7:3c8d:300e]) by SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::4255:20e7:3c8d:300e%4]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 20:05:40 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0A=
Date: Wed, 26 Nov 2025 20:05:40 +0000
Message-ID: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
In-Reply-To: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB8476:EE_|LV8PR11MB8560:EE_
x-ms-office365-filtering-correlation-id: cc204d31-161c-4a78-e007-08de2d272c52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?IRKf+ZRhRNfl0yjI7gU2SBkWf2XzJLo9U/kg3JpKd1ypjCrX1Ot6jEt/S0sW?=
 =?us-ascii?Q?WiUqLw/ilU0/wFtexbxlhHrUPup69zmWdPc0wtsFe1qM3+SliW0NrKu3d8CF?=
 =?us-ascii?Q?HNF5l4F4HBAxTxSwreglJITAJnjQfNQVOY6fXSm//TJAWc/zO4lfCP08dHbo?=
 =?us-ascii?Q?j0M+lGf4g0lThTeZyBcL4K+wCUtX/Y2xFgoqk8xX32/bE37+RLA7sj3X0ZfW?=
 =?us-ascii?Q?hAeIB4hSEr5nvxOhwax9yWs6pCKbYjIbeYSo2KaVIrgSLAC757WMEmB1VoKL?=
 =?us-ascii?Q?wEDz12DR2Qn/aUyP52Y2QzFNG4eQZMi4Y3HQy57k06LGKd8R3+RCk1/jYHYQ?=
 =?us-ascii?Q?rIi9rj0xWblX7XgeHiPjwCI/sV0ZwkClIj9DWZmWmwNIu/PBDBwW4EhYmSLT?=
 =?us-ascii?Q?+E6DlFSozP2Wr+yfn8RmPJj3QnKtR1Ew6bqH8j0Sq6fzXBVxGhzK0jnrktPh?=
 =?us-ascii?Q?mP21VoItR4tE7Mfh5lOrNJY0igTq6n2XIOe1ckb3OZKgM4NDNb1SHW96O4AE?=
 =?us-ascii?Q?josbI4epWvVpoFalybBnMcsWK3QPv6fhkp7sSx4lSR+GSaTf3vux6hNoL+Jz?=
 =?us-ascii?Q?ZIeIKXPJyMmSp7WsV+/XSiK+0SphNc+pDxuzwBZb+Ez6FWcMCwZ5jmJxTWZf?=
 =?us-ascii?Q?EdKx+yDk0pXej5901OWYX5oWySuwGRqN6xoNBuPtgE6Vn6DCxjdgZaii9lBr?=
 =?us-ascii?Q?11ZVcU8RuZLWwFNUnGDmgfYZkrJ46xVZkykpUbvFGEvV0kLM+JPQkTdiKVg+?=
 =?us-ascii?Q?3ca9ftl5a+UVEIFpNygY19Eey5D7wCuF2D6hOy9Gd2Qc7NRA/5Hu+5jdqzXb?=
 =?us-ascii?Q?7aZiOYlhUOlbT5R+4JeSvsR+B5389Zsf2NaebZxaIz08Are98wk3A4fWRMTT?=
 =?us-ascii?Q?5pWd9nJd8zArwIcWdObycc8Gigt1jM2J5U2ydzUE1RdgbcXRF+gXo+rrEf44?=
 =?us-ascii?Q?+o6+D071cHwQcNuWqQfmwEqmzq28EOpAf29cm5neyHaULH/LPDb+OYdgLQAa?=
 =?us-ascii?Q?TaXpKfmmA2h18dxg6gf24RLqK4T3QG58Wy+G6Ng+KRE5/gmpAiwDV+Vppbhe?=
 =?us-ascii?Q?y/NxJ9EhUfXlY2RdM5e1BgCKFVsfBCuCUsLtZDYZsAP3Hlv5jQ5ExVi6Qejr?=
 =?us-ascii?Q?DglBJVNnw3HKXkaoz0SnyPEbirqXcDtPy3gnkE3KkEJEYLcQq9chyIrTjpMh?=
 =?us-ascii?Q?EfO58jsthYLns59RcU63mZBpX0iekv148p1QPgngH6aH5ridFiEPP6HeyzO5?=
 =?us-ascii?Q?PblRMl4P1rjO13ak70VkGDYs1D5OWlKeEgSydRzvpWit1hP6/sUsxtsgExWf?=
 =?us-ascii?Q?klMMRA3q45epi9Z1tEXY+SnEBryoIWsqIMionNRboc26aPW097UFMv334KRr?=
 =?us-ascii?Q?j637gQWpXnJdoIcrqT7fhq9VDqFde26KUcNLE8JMvOqb4PTensONmyqF664e?=
 =?us-ascii?Q?iVMUaRz8Is1AKrp77xdq8UScOOSc0VqW5wRsSOwxZjMUN+vGeoLGng=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8476.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iWhP9B9pThlGre3hkVRBfIEsHQESZUzKmYkqMjewI1/hGloeY5v5qeZ3KJ28?=
 =?us-ascii?Q?aJ07l3bEW7cYD9xewEqZa1SUayDG0ZJiC1WOx0ntJb/D7ZoGuoZJ5Ef+ZIQb?=
 =?us-ascii?Q?+pbGkLjZUUxeBf5iGBbICUyYiGWPaJYnY/5cUNui0FxAW58SurTB3Scq+BsL?=
 =?us-ascii?Q?AXciieuTc5y5QxfgC3vmi5KQpr0vvOhuzKfy1QSA1p3kcAlr4s5T3hL6VgRA?=
 =?us-ascii?Q?LsnnDwklJ85oSGwJiFWfPxTM2ejKan2wE8NJiVk5PUNmLCMo8VGfCE3T5wQ5?=
 =?us-ascii?Q?NunOgkYwWITtMmgx89vBiKqBgKN1BYESLe/04CxemavoX1oQSUMN5tRetQFX?=
 =?us-ascii?Q?LgjgVQtLXDYCvMglBMIivw4dqaNW1e2PfazX+rlyYJX4bvZfRLjub02AD6T0?=
 =?us-ascii?Q?BPY/eyOtzUQzN8kGi9e25EwPtYm3Xa4dEKhiSAH8m/4NfidKl8iP3UXF2K8l?=
 =?us-ascii?Q?WK2OTKjEyMgUS8q/qxLoh3p43BLHcYRMbMZ6RqJYWjE63erXf5fxKvsGa+y2?=
 =?us-ascii?Q?pTLTZNCKrOsaKwaLfBGeXpPrg6NlqCraN4X8ZIPlVzRDjYMwYhRC3KfpiVFk?=
 =?us-ascii?Q?z7EkWRW3Kuhqo3Y8FuGY34AaxCxgjE5I0l+uko8YCcCbc1YOWEeKOekgJdXV?=
 =?us-ascii?Q?F18/xW4V/lp7KDBKz8Hyq2Posc9FN8Egcad730i5auSATEMU4LCAFNp3xi9p?=
 =?us-ascii?Q?0pPI/xlNiGBEN9JCCb53mVBU3XeOj9rTkMlDXGZJMJQZifDfXlcmIfWnKpA3?=
 =?us-ascii?Q?FfeXHdpKJ9oK4CA6ggwXia/jXxSdHegzYpEY/LzMV7C5de4ONSIgr8xwfM5i?=
 =?us-ascii?Q?oN8K6UG0J6VGSAo6o0xdMK9gu1rI//DN4k2y99w50gUp5+4TYYoHR58qlGt/?=
 =?us-ascii?Q?OAuHmYeRAFZc56h3F6w+E8l1rEQ2K90+V38ebN/GVKy0/i5CJIe7ScHGNK02?=
 =?us-ascii?Q?L45HZltqiNejY2VlBxX8uLkpFNolsZBA6UjUcJmqD0mO+16lf4Irh+IcSxAY?=
 =?us-ascii?Q?8NHPabbV6h84M7SheH3nvNaehDk/lRkiyVVtZa80y9ewdF4ISGYGKEUyqin6?=
 =?us-ascii?Q?j/xb3puz4kxK7xzzaMed/noNZLoMG6470dIn3g0ce5vXJhR16Tzat8ptDlFq?=
 =?us-ascii?Q?h2nMNNma1mJegogAy3P914Qc+m84e52JTSpZ4627x8EyypbKcgby2ndm1+y5?=
 =?us-ascii?Q?3BWNrMHEDXV7fN69Ab/uVUSpxPp525R9H1pZC3fFEsTUzOH4IgYN1vsLvqq/?=
 =?us-ascii?Q?+xrec1Qjn+bJmCk3slP78VZYYPwoO94qJpxTUtOXc+zpWoCY+MUMXdUlqxEk?=
 =?us-ascii?Q?Nfi0sY4iyZTvbfStkE4iKsS3u80Hsxrg4B9LcRCcaBh+/8b8qclA5H1xwOP0?=
 =?us-ascii?Q?/VkPAOemQORtJXbCeTFCVvLJG5ibkTgPNDgVquOO1IuiJpC8Rbm5xHHbVM8E?=
 =?us-ascii?Q?0Z3wUUNssBoQZe5owwR6ZLUamJdelYV21A4bQRT4Zm/ui7U5zajWFB3g8qJ1?=
 =?us-ascii?Q?rPZXoVLgUTv7nocMKBn2Ses37L7QfC/GaIdddDvjtD2GZHbfJDA6jLPl0+sh?=
 =?us-ascii?Q?KPPH9q4UWQ1YHE/6kMRApViRBnTdqHFcUWBoXvE7RTWnLqZ+IrV8U7i0jXPw?=
 =?us-ascii?Q?fg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cc204d31-161c-4a78-e007-08de2d272c52
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 20:05:40.3422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TRniULh2hwHdkUGnUIfhZDIi24ZK70IR994JOaptU3RbqFeoYVrpeCkx0irWmmMncsvLsn0zN/PM5nItETKOxDV9nnGxE04wIDSzebIQwoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8560
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, November 25, 2025 10:35 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
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
> On Wed, Nov 26, 2025 at 01:46:57PM +0800, Herbert Xu wrote:
> > On Fri, Nov 14, 2025 at 03:37:53PM +0000, Yosry Ahmed wrote:
> > >
> > > Thanks for the clarification. I understand that the error code has
> > > different sources for SW and HW compressors, but I do not like using
> > > errp as an indirection. It makes the code unclear. I would rather we
> > > explicitly check err for SW compressors and dlen for HW compressors.
> > >
> > > That being said, I thought what Herbert suggested was that the same A=
PI
> > > is used for both SW and HW compressors. IOW, either way we submit a
> > > batch of pages (8 pages for SW compressors), and then the crypto API
> > > would either give the entire batch to the compressor if it supports
> > > batching, or loop over them internally and hand them page-by-page to
> > > the compressor.
> > >
> > > This would simplify usage as we do not have to handle the differences=
 in
> > > zswap.
> > >
> > > If that is not doable, at the very least the API should be consistent=
.
> > > Right now the error code and length are propagated differently to the
> > > caller based on whether or not the compressor support batching.
> >
> > Yes we should only have one code path in zswap, regardless of whether
> > batching is used or not.
> >
> > The degenerate case of a batch with a single page should be handled
> > by the Crypto API.
> >
> > So I will change crypto_acomp to take care of this case.
>=20
> Nice :)

Thanks Herbert and Yosry!

Herbert, to make sure I understand, will you be implementing all of these
features in crypto_acomp for software compressors? I would appreciate it
if you can clarify:

1) Error & compressed length propagation to the dst sg->length only for
    non-batching compressors.
    a) For batching compressors, this wouldn't apply since errors could occ=
ur
        for any page in the batch, and the first page (dst sg->length) coul=
d have
        successfully compressed.

2) Will you also be handling the case where zswap can send an SG list batch
     with multiple pages to a non-batching compressor, and the crypto_acomp
     API will internally compress each page sequentially, propagate
     errors/compress lengths before returning?
       =20
If so, this would really standardize the code in zswap for batching and
non-batching compressors.

Thanks,
Kanchana

>=20
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
