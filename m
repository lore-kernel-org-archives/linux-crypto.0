Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0A25949A;
	Mon, 25 Aug 2025 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756145554; cv=fail; b=JDXMbMDZMvFvPBf5x6X+plpY6bMUm5ojg2fdoQWnEJVwARpI4GVT81rRY/Pzorcf0dzPbV/rMIlPlzMOioZ6yeXkyamPMfFKBrsb7otjYgVz928jxDhwUVevy4aKxuUJM4exP+G00h9ooABManPf5EdlDf3wsCbI5TBtUgGI4S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756145554; c=relaxed/simple;
	bh=4Zyj6S4yJTSrDRu2FP8ykglFXirBg/ppB1oTY8mpLeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gZPs/gLtOMycAmCaOSgL6Xt/g2NOI1TglzDKpd14grLL0K02oI8MyKkqp3xS0izoQwasYMjzAeOiQH/ICNjkcCTTIIZ6cjQ6SZHI2xE0J8vsnP2ewV1Se2FYPhf6clp6FcdYsRk1y/pUO1b0bd161UB1bAwWLLWtOAMKhB6Mz7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bnO7jqau; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnO7jqau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756145552; x=1787681552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Zyj6S4yJTSrDRu2FP8ykglFXirBg/ppB1oTY8mpLeE=;
  b=bnO7jqau6z7zkGkBWfqiHuV42ZjXJctVl4pk20IKIgQUskIFXlBw/Fvm
   rT8CX88WK2hZIKpBrghrESGWRKmp8bG5R7YpZiJWe57vKVJYHsXj8KFv9
   0IIQZxnDDVxSoJohoqhupezChC8MUl4YyXItyJS41F9pecxdMEY8Bz+2r
   AnE6THoZaD7F3+II1395hsfRXGvDkd62yT6Oe6artuJmTBSAYoLj51biw
   rLnRUFfSA4bWuZ5tRWoXhtPFwhBoe1sdTnIGb85jDhTPvBPryPhf1yuI9
   H3xoHXLBpj32ChxNOYQR6/YKWAq9pHyRvqhfcXpmOgoV4jFbonDkcD7p/
   g==;
X-CSE-ConnectionGUID: 5mpG5dQmRua6mD6ZpkKDsw==
X-CSE-MsgGUID: chXlfY2bSd6/2tuFdTsWvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58467553"
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="58467553"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 11:12:31 -0700
X-CSE-ConnectionGUID: mDz/Vm+lQUqZj8g8VwOFhA==
X-CSE-MsgGUID: 8YjCdpxPSzOF9ax2YLx6pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="200254149"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 11:12:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 11:12:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 11:12:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 11:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLIj5hRyMNkENifJnwefpvyfSq/KVSKWcmuzpA85kYPjsm+RUozI/xT6fEIePF2x4W9ttEGamawFHBUiMUchbYS05wc42ce++pk7ppEhlkTzBdE0ZK83caHO0QE626pHUvJAIzWIzVYQWIujD8X/Z8yjOxpLqB7Ici42m+VgBzf9CaHju9NSOn6ujYX/i5zfEib0HJn1VNKmaoqUVPwM0h8nzvpD5xzy/1sC9XBx44YEpqwOJW0eGsviL1Nae8G1BKzTmfRXokJBP3uJiJT7w+WDbggdw//Y/epjAVNkrMG9TeG+NYupcuhfnuYo88CpTfGDARKv1xSioviFBKUcKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz4I9EJ/5OrrYdnRzLgbMsjuGlrAARIfXbsbsSnpMgM=;
 b=eXpAppjFw7Xq7yxZTmUVPCvzy4ToxrN/2wcz0Y6mlb5lbVcLww6oK3klHwQTyzvOoqCwypnvfH+i+HQdghcnzLsJYyENGIckCSyCvP0lvf+T+7HsAYvlUOSviLPFrprkeFbRjLrottFcxGXRVo69/+/y/42ehqENm/i3soZz0f+H06sWKZ7FzSy20K5uA19zIRmK8GPTaXAg8DGorqpnIuaLIyQokSFAYCN2iRg0TDWpcvQ/NcqKa1KIu2S0iLbREBjzMLWAAIDCFbfiCjeQdO5cMahLzOsWscy929hw1HNfq9c9KKq1ytonj5oynYW2DPwJ6w4dU0Fu78QiG7Xehw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA1PR11MB8811.namprd11.prod.outlook.com (2603:10b6:806:467::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 18:12:19 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 18:12:19 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
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
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8IAD0bOAgADL1oA=
Date: Mon, 25 Aug 2025 18:12:19 +0000
Message-ID: <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
In-Reply-To: <aKv28XTvAITuq-p8@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA1PR11MB8811:EE_
x-ms-office365-filtering-correlation-id: 02ddd78b-30cd-4493-924a-08dde402ee5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?gmYonN21m9CGAOGU1jRz3OLPqE0XxqvezMSlzSZP5iwHDrKrTotPrbTVv8V0?=
 =?us-ascii?Q?RejdAVYmCCMn50ZS32CgAtgXvpiDOKFTFxNQcUE1qwyxyndOJKAbZcA1/GNJ?=
 =?us-ascii?Q?z4rg12G9PGCrSqb98xqdSOWr2Q0jmFWTfri3A/bmokjoMRnnFckWntAonB9H?=
 =?us-ascii?Q?I1i7I9syvpQRG3sqvTaYihcrq+pD257opGzeE+6td033vRF5d4bF+Enq0C5N?=
 =?us-ascii?Q?t4K/LFy2Y2mM7k82yah1SxRAX0zpxBlXsNaLSmNNLnMajo49/rOgT+hfK2Uu?=
 =?us-ascii?Q?NfzajZ0vqDe9KNWc6zgp8BUNewWVDEZrIIUbN6rYlFOcKDVXxQZGckvG8kgW?=
 =?us-ascii?Q?jpK7hgP1TQfvkhhGNm63A9vHJ5wTl46LP2Ze5TN27t9jrBbI4ShZjHpZcEE9?=
 =?us-ascii?Q?broIHH3Ic7XjVzvYEgvuBA2Osd80drjZskZCKYVKu+36EJLcgIoZ82mPrupT?=
 =?us-ascii?Q?zRqamnkoTEA+Xd3Eh+eJAIEQdAibISUmGGxADsQl9ior1ECAFP2Z29jkbUOr?=
 =?us-ascii?Q?ArLe2GKxEzpH3OZWwIfGgBpCiXm5QZK9rnRA1EOi6Mjax/EubphUx8RDMwTJ?=
 =?us-ascii?Q?/MElhzgRjaQGIBz1x3k0PuySGTAz6PRzmVfAMqDe0a13mmVxld80EXecRBNA?=
 =?us-ascii?Q?7fqfKyiz2eQB5hUzqlqaX90ENRuIZNG4o5uk+9+UcY6tJbQe7rGiMB/kKo/V?=
 =?us-ascii?Q?rgJ/vm/IAlNACsXPNgeFF8BDydFSyRG9Zdnm/33Nftx7ycvSNFvTNLasaTlS?=
 =?us-ascii?Q?Hc3ghZt0DEsY2BOg4gJ0litrQ/eo/qanZDC+0zSBQQmkWMyIidvdXO9DuHZa?=
 =?us-ascii?Q?HQVSr+2exth5JROM59JYZ14R+kEF/bluqsnXSpt1EfokP2bQRxg0hsLUGGE6?=
 =?us-ascii?Q?IMpgH0YMQVcyX8wvdR1g8JbihxX4vOzfkOjQivMb1rAeJtJeXKJA4EohM1lp?=
 =?us-ascii?Q?3LIO/xMS97LO/Jr+NG2WyYu3RaAM4HRyrn5Xry14Loe7aBBzLqRkiOdx2Uhb?=
 =?us-ascii?Q?nU6QyVrNvscVBp196q9hxexNhooPRek/V+vi7CFBIX7zn5ofHpmPQ6hmNajx?=
 =?us-ascii?Q?N+JY9hXBuAMJ/5wlfiQ9codXMpAd8HpXdfAs8f/YkiMDAMr0VE66zhzq1RXd?=
 =?us-ascii?Q?vJiCSaQmEz5AGjeTpJmwbJdCnA7LN4G0TbYF/tYg9OWfOrm03XBMaPTpd9fP?=
 =?us-ascii?Q?kkd3gBS/fceVxUOLfnbVjdBwd0FdIBVVFBhu4/S7/zH7+e+gUiROF+HiLLmI?=
 =?us-ascii?Q?vHAv+EWS9iDbPo9wKTnFNt6TCQq1IRpmUq0SaWFKHONMoJlvVBFE87sgWfAR?=
 =?us-ascii?Q?NtPO7iK0EgyRXYAm97roZQBpO3i6GfpZNIr2WAmHWnvr8OqzooCZOj70PbNp?=
 =?us-ascii?Q?6WL7IOU9s4soBAvOzeW7jon19FQ/k3XL1d4O18crbwhPdiZ1n4eKX2GfSwhb?=
 =?us-ascii?Q?7V6+DEEnbt0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oqCsUcF5x5RTKVJaalSj0hMQZrrNcPrUZeZbz6LfPxWbTnvgP7t+PjnHrLxi?=
 =?us-ascii?Q?UHum5GweLlL2XVS+SU8bZgLse3AB/V0K57p3drHPrNx389RKe/u8VVJbc94z?=
 =?us-ascii?Q?gLNXXDYhl6tfqllaXBMn8W6+a8JcWcBF2gPzzOUxUYPKXbXYrZVAIkjf8Wml?=
 =?us-ascii?Q?GTffXLQYpy3Znmvr2Zz7c3NjHQQ/WxOwEm0jpGrO7c4RqeeDcZJouEyVZWJr?=
 =?us-ascii?Q?XGr1xAhIh2a9K6iLBRRW6hJoquYXioBlxzXf+QNjyJQmnBgGbnk2R7lXP17s?=
 =?us-ascii?Q?C7cbCDGhQXr64BgtYOJNFfzr1aizs7paPL/RfTWXCTJEeonrtwLKjQdRtMOb?=
 =?us-ascii?Q?p1oL7XpNEh9f8Ejsx0+yVWEnuNYBwVgiMFKlgxRsiaAbVXiO9AA2Ff1bAY7V?=
 =?us-ascii?Q?52Inyr6q2p2Ij+5nHQYOmnM/p48N4Jj9lZxgDnqBraKgKj+bhrvw171+YNjY?=
 =?us-ascii?Q?UACgZyWxgihE1VkkbKx8YHvjfkqbBpgjE/uRvboyslxKW1zo5RaPeVavDOyW?=
 =?us-ascii?Q?4Kzbpy/0+jx1KDTQcTuVKh4UOxhBpoLkXg3KOd529yF0Wp7c5nnjcOcMVdtD?=
 =?us-ascii?Q?kSE3WkoozUgzxdigKbf2UUWLOebN82sqRK+bZAXx33ZC2ndMcnGWQaUB4hA/?=
 =?us-ascii?Q?NuN/m5u5RjEHz4VJihJvv8dk77TdlPLkJDKN/2y3spuBsjPuepNek5Mf7awG?=
 =?us-ascii?Q?zUHpfpC0AgifHyBDpVqeI92/j6ArYibhhPY4j5KwQ8bgXNDeB/yPIWDWg/qo?=
 =?us-ascii?Q?GUcmdm2HL3oaS2dd/eQBQGFAhPfSjBx+gW0w1vhsqNzST48ZfHYHiEWUFxkK?=
 =?us-ascii?Q?PtR89rFWRh50rNnQNcWScanGE5uvfmyY2GrhQwp6bNA8wyGtI5Lqmc0QeItX?=
 =?us-ascii?Q?Qlz+SaLpXbvqcldjPLDRMaAdpQdWJLNLs5pv3F3UZpzqVS7OQQGZsNKyrmMR?=
 =?us-ascii?Q?cum9VNXl13tdWvZz/W41ZQnxpDM1afBHK06TgdjyASG57xJDvx3E1a+xXkp7?=
 =?us-ascii?Q?GNRGgHb1ot+WF/wgXpBoOlGg+XehhCZysQ3YPIS5uhYqDZr0TabQD6hcno+r?=
 =?us-ascii?Q?oVKTkfBc3EsXbm+CB9HkOubDS0AMSRMOdMKL7/pEJJtwmn7ZXZGWGpzdJUTZ?=
 =?us-ascii?Q?lzL9J/W/KeGuc5OFAZGRqeGL0Tr0l9XudxIYbtoIuytYGvVgSTxqc+PFEsIZ?=
 =?us-ascii?Q?qy/gYl+LvHZ3oKIE22Lm0OX5Yvp4AV7l2F/LRvzM7oHdQWr6/HdWdtIXcwdM?=
 =?us-ascii?Q?0JUbu4UIKvJkNt/H4jwFPVmZbbM1WENs4lrYUyADofRdvDQEf5dEuY5nOCDW?=
 =?us-ascii?Q?MHSf5hvPUmCsqtOoRPMxaejJG5T3zPG/hmAHfuLBTDpn0a8OIwI6Vv1uwJwN?=
 =?us-ascii?Q?I0yhbt298xEP8LnnEiuqqz1ww6rtVqrVqVPIi0L7KBBi2F1ly7L8qU8cQKt4?=
 =?us-ascii?Q?H6Vxu3y4T4kXktrARNy/YRkqZ6CQtIuh4RPPjGJ6rXpAv/R9TztIE1H4hUps?=
 =?us-ascii?Q?iwE2IxiiGNtjxyXnGot5Sn4EFuFaK4irXBkDQYo9cpHoBkg/grfT6EqAttE5?=
 =?us-ascii?Q?EG9cbIHeKGRLGIbtYG2Og6KLrY8r/B4stVupkhEUOV7Lg7P2eKAzH1aA4m8Z?=
 =?us-ascii?Q?TQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ddd78b-30cd-4493-924a-08dde402ee5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 18:12:19.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oOEeH7QMHgd4SvpWEsahAAuzAdWMNFY3Mx5x+NaV5ZsIxF/WUzHJM0n0kw5qpZzVETd7RQfoHGnM2WrseYM/p/ee7vpTYdiYDL/Ptgml9MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8811
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, August 24, 2025 10:39 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosry.ahmed@linux.dev;
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
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Fri, Aug 22, 2025 at 07:26:34PM +0000, Sridhar, Kanchana P wrote:
> >
> > 1) The zswap per-CPU acomp_ctx has two sg_tables added, one each for
> >    inputs/outputs, with nents set to the pool->compr_batch_size (1 for
> software
> >    compressors). This per-CPU data incurs additional memory overhead pe=
r-
> CPU,
> >    however this is memory that will anyway be allocated on the stack in
> >    zswap_compress(); and less memory overhead than the latter because w=
e
> know
> >    exactly how many sg_table scatterlists to allocate for the given poo=
l
> >    (assuming we don't kmalloc in zswap_compress()). I will make sure to
> quantify
> >    the overhead in v12's commit logs.
>=20
> There is no need for any SG lists for the source.  The folio should
> be submitted as the source.
>=20
> So only the destination requires an SG list.
>=20
> > 6) "For the source, nothing needs to be done because the folio could be
> passed
> >    in as is.". As far as I know, this cannot be accomplished without
> >    modifications to the crypto API for software compressors, because
> compressed
> >    buffers need to be stored in the zswap/zram zs_pools at PAGE_SIZE
> >    granularity.
>=20
> Sure.  But all it needs is one central fallback path in the acompress
> API.  I can do this for you.

Thanks Herbert, for reviewing the approach. IIUC, we should follow
these constraints:

1) The folio should be submitted as the source.

2) For the destination, construct an SG list for them and pass that in.
    The rule should be that the SG list must contain a sufficient number
    of pages for the compression output based on the given unit size
    (PAGE_SIZE for zswap).

For PMD folios, there would be 512 compression outputs. In this case,
would we need to pass in an SG list that can contain 512 compression
outputs after calling the acompress API once?

If so, this might not be feasible for zswap since there are only "batch-siz=
e"
number of pre-allocated per-CPU output buffers, where "batch_size" is the
max number of pages that can be compressed in one call to the algorithm
(1 for software compressors). Hence, gathering all 512 compression outputs
may not be possible in a single invocation to crypto_acomp_compress().

Is the suggestion to allocate 512 per-CPU output buffers to overcome
this? This could be memory-wise very expensive. Please let me know if
I am missing something.

Thanks for offering to make the necessary changes to the acompress API.
Hoping we can sync on the approach!

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
