Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460C76F06A;
	Wed, 30 Apr 2025 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047159; cv=fail; b=LZ3S6TKpI3F+FLWvDPSE6ov0qWZgmrCAuPY6lX+dPvCdU2h5VGxAARReZa9SiuJs5teU4deo0jr7HG92U0JLjbLy1vLvf2Kg54RBqiBlJJmcsvsZ1v5BskuJ4Wr9IbE35ieYse8p1hmKdW/n+GC5y0+TlWedYM3dMyjd/d+xOpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047159; c=relaxed/simple;
	bh=UBwOiGjmmP2OEI/7Dym7FENgGZO94Ww0J19WV2LqNsg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N8/3iGGez9zB+mtTuyJSB6PDlfDpjTH73/PSZxSHoMPCJ3VptbRD9v+ovh6iAC/wc894jWUtsVOPPpQqRg2HQdacKUmWj64RTTjyb8pHejzgDqEFr/rbkF/WrkJt4r1j0Y+J+C9DlrXjMsQyIg6zjejHrBxtxZ/XcHpKEgmV4dM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DrwUGcLM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DrwUGcLM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746047157; x=1777583157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UBwOiGjmmP2OEI/7Dym7FENgGZO94Ww0J19WV2LqNsg=;
  b=DrwUGcLMHNbKZmywBBIauZa+RjQnaaqsoLCl0uVwaFm4MTWzoTmMDMpJ
   ltdqsg8HOTKfctvjc1geMR9tZ1M26g63jIqy0NqarHSUQ/60PBG5IH0qf
   YweMYlJPfPVFqrGLricBx/09xjnn74Of7GfFcGON5u13vvhgSiIV1Fqpv
   1YM7RTZTNzbSWxnLlpTHdaJQGiM2dhA/Dgfrs6lWwvIP79GyuAPj/Njc9
   pDuyprgTyVoEYOtQyHSURSjGD4spF3lgRDsajmOGz/eVd22iucs5jFKJT
   EGc23ZhDjFCJMAQ/MhXoBYciRXPIL73eV3XG0lWep+c8+WZB8ritQPiZK
   w==;
X-CSE-ConnectionGUID: 2SHHrO+1QU++8n+easbgzA==
X-CSE-MsgGUID: G56xZGdaQoKBYGQ/cBaozg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="73113955"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="73113955"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:05:56 -0700
X-CSE-ConnectionGUID: HiuY2r36S3i47Qvr2eUELg==
X-CSE-MsgGUID: Fi11+1O/TUK4Y6zeZYqejQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="139404637"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:05:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 14:05:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 14:05:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 14:05:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLUnp5hmrJ6Wxo8cVL8cf09RaqMEbBPCDHgigfCfX2N39iPPWbH1HJhcYp4XIIPwLlF6vq3vb7GEr7qksOLULWR71I5waWhX6Akub72stzcIJ8e0CpzcDFUYBEIdcZ0bA8XKE3wxCfWmFBkY4ahQgh/MSrBfuaSp5yDjguzF+Z4xDLSt+pfbu2XhZg9mUAVPy1bjn0ItV3E4tDQcNdgaFu1nD/CGl9e/yODHC7LYVYYs/xmI9y8AXCnQiMUjeOo+oDjTo5YWzz4Juc0GPT+PHDqliVhx1JJmQF4l17+lRjQpa0Xl3wL52LMlOeJzNiqXiz+HRH7HxhfiSj1cMlQRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Osg5AAyDPOWVVBMxpbN2oQ/cgW/u7KcOfXstE+8E+js=;
 b=yhq8dVGta2VGyPwMoIcNs2yED70cGDfOT4eEoioxDxnpJ3RO0qMoK0gqu6jRma5FckK/f60hRsbUZBoQ/DgKO33i69cLsB0vhEmpqVHnx+1bVqdpduH7Eq2JHw+M6KFZxsmK/+bk3KRU4tSiTk6sA1yUoVUUZWD7exY3mGnsAm51yBPtX4Wrc7SbeTl4PWGGM0HxMY/8wqHfswZayTtxq8GOPEl+a90dWGUWMZiksMXrvAfqDJueIKEyVnlga09xHIvP/ev4d7t4I5N1KfBqt0W1ChT6J7ApGfQ6dFIP42xiSiEf3UqBeYxyXHM5qNSYRZvL7RJOI75dKdChr0r29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CO1PR11MB4819.namprd11.prod.outlook.com (2603:10b6:303:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 30 Apr
 2025 21:05:50 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%5]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 21:05:50 +0000
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
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Thread-Topic: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Thread-Index: AQHbjBjvM/RpC9YLRU+yz1iNoK3rUrNmogMAgFZqxAA=
Date: Wed, 30 Apr 2025 21:05:50 +0000
Message-ID: <PH7PR11MB8121C5F339E8BF5330496D4BC9832@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-15-kanchana.p.sridhar@intel.com>
 <Z8oQzmL_P9W5Mad2@google.com>
In-Reply-To: <Z8oQzmL_P9W5Mad2@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CO1PR11MB4819:EE_
x-ms-office365-filtering-correlation-id: 7e480999-53f1-4778-a14d-08dd882ac97a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?TB6WFSDJ9Nl+jMX4BZgYdSFyjwbjoG6KsiI+VtX7o1ExBPxUxQWGnkvks+vz?=
 =?us-ascii?Q?NY9UJLhckvQNoCCc24U4CognH2+GVi2lbcA9km4dEjWwWcEWEX7WDM/1WI5U?=
 =?us-ascii?Q?mXrF6y1AflYvScB5ZzTZcRPOLdacbgKsrUUnTNk6csh70QWViI072fpJJIG4?=
 =?us-ascii?Q?LYBLmR2w/GmV1w2dnprFkMQJtBaR0c5wZbRymeRhiBW7n02wrCw15tSokrg1?=
 =?us-ascii?Q?bseU5fY4pHs/7j6Y6YKV/wgWtEktz+DGxXCAYVa71y4BC+1RrxvRH9LisQ3l?=
 =?us-ascii?Q?CKJZpakQQ5fuXP9CmjHy3jUGGw+x/pj7okYznHBV/IwLsIurxtsiy/kC364j?=
 =?us-ascii?Q?2xpEjQ4idPGW1hQh3cG5noxcYlRD8J9fCqLvcZU7AD3ot0xWrwq/qc1IU36K?=
 =?us-ascii?Q?WnbsKNIf4w6SphMQeRwEeg3HM4vXh6Ff+rc4DED2L5uFYhdcFwDXujsqLksD?=
 =?us-ascii?Q?LFTfKh5Ylsny+oANgQ8fXCypg7fJKetP77fewb7XAfCFwgWArnWhrp5ZQP6G?=
 =?us-ascii?Q?PPl1rdzU24HzGIHg4sRCZBhESzxckGWzCcP5WEtLeKI54YijnYUUcBQkWD6F?=
 =?us-ascii?Q?TL5hgUlgAXsinzifCgrEkoK1I/i5kxCZyl2G0e1HjqtrHCCpZaU+DX6FgehN?=
 =?us-ascii?Q?TakQ/G2qhA4PBUlu6QyRNr23rLINbEfQcy60JavsPmK3/HJ3tEB0XZirjG3t?=
 =?us-ascii?Q?RZEkxaTLgxAoNnkK0unI7r4g2m5b0Wpx1S7a2/INm/S+U5gOnyRBN/QRM2CJ?=
 =?us-ascii?Q?1qSdn8+zX+3Ndmf8JUrcbXCt1lMrJflDHfdw41gmuNFnOAkZH9oUFqHGxwLP?=
 =?us-ascii?Q?AlD4YABtIYrvq++ZFKx05XF4bwaPEaKQEwDKk5u0f+b4UiaK+fAewkskL+A7?=
 =?us-ascii?Q?XJDeIbjed34RTWJwIroKZIovkW1i1YM9Un1iO89SrlDN/qk/w/23rT6oPVrF?=
 =?us-ascii?Q?sGf/djdowUQ63MNEpm7HvDXFclABXbSN+rQnB7BjXvN5jbh6MA/Hz3Vd5Deh?=
 =?us-ascii?Q?4vg7zpZ3yNpPJR5625Zj6L85+0I+IV1nWcjhgwXXU4yD/iLX1FqgYREeTei9?=
 =?us-ascii?Q?RiZeZi3WXGsnflUxEkjgGnX9mRlRCnFbbmrE/mL332WNaE4Kz52Soq1HghJZ?=
 =?us-ascii?Q?aBTWOR7MuMTyAH5T/OKkJvohjt0rWk2eEGg6WmXgkx6mPw6LhJqWmJGroBuz?=
 =?us-ascii?Q?6wrlEw0/CI3ebnZdBy8INwiJuAHYW1jLGE2U7nnBu/YntF/C08CQeJWR3iwn?=
 =?us-ascii?Q?Zo26pDFA3G8BdUQZUuolDQqqbM7I6NBUkSgKhOhv6r6KODTio+gJ3aOHyuG5?=
 =?us-ascii?Q?/ByjTUreEmNErZtAlCXrfty5kKgf16Bry0V5jAcOJRYxuSDC9J1pznk0sZAd?=
 =?us-ascii?Q?pLNne69c+FzSEMgQ6FwsnhZuRHvBfgE/IM1Z7Olu6vW4tEfAwQTNKAS1msGS?=
 =?us-ascii?Q?kzeKRF5/8KWzAaMzRHZ7/0ynVDERm6VAC5fUVyLd8TNNLn+gjHyKrQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e1GPdMtmkylxiGkVqOq80+gGKDhdW/gHHwzUd9MM5hMQSfUmlbiACimcJ4G6?=
 =?us-ascii?Q?5RPvwlps0WvBz4M9BkY1hMZy7itkayt4BubCrc7pP3FXN6xD5o8yNMGpqsIg?=
 =?us-ascii?Q?zAjKx6q4InpeeTWqzUI70YggLXL3Noz+6YI9okD/PDP/r4Z9kHPZPdQB/1WS?=
 =?us-ascii?Q?6vmdInkgTFcYPPYa88DQGnoGhqGYnUCdsm+wzb2BWaWkMzpmnS4z1M/+AwE/?=
 =?us-ascii?Q?lBZiOB23G41Lxl0wkU16PBULDUJS9ptJUQKxsk13D3ZqJ8vKvnCj7p9bUkeN?=
 =?us-ascii?Q?Fl/BZo+BFp/BxqP0YiW0EOJWtCrdN6a4ds8aMYcy0NtjrhmXQ4zsg2bqLZjo?=
 =?us-ascii?Q?Q/z26lQx59qacfCP8WxRgRqu/kif1XqEZfU39e0LPDRKsJMvx4Eog2ar4PZE?=
 =?us-ascii?Q?W1JzFHdeSeYUiTW+xASMWEu4ZzgMcjQCKlpsFJdJ/PKabZux1TN4w8hGarNR?=
 =?us-ascii?Q?+4pMVOAVVp4Q9rqb53nam4VHGrsCb01h3yXSklzipeIGQOo8Q/R2CmY2ZNYB?=
 =?us-ascii?Q?GkuJRn9X152/BOqVCt1nbVDdSpTpcn3I0Y7+ErMuxkS8iet8+cMsX4SV4zfv?=
 =?us-ascii?Q?u7Uh5xR0koZCc9ILYPKpucS5pPyN+vRBfyZI66NBE3hWIVg9fapwhk1TZ5cx?=
 =?us-ascii?Q?lAQynUQesGubfSB2IlqJiPVnsBraz/3AcnQWogof/PamtvFre/k0C0BkTrkb?=
 =?us-ascii?Q?NE2DPOMajMyZ/UVLoLqosjgmu9IsUlFA26ovSyJN/+0sQsE69k4wcBEcF3/5?=
 =?us-ascii?Q?v45e6ctNqfFRbHnOqYOJkM54zAGgmNVDb8t/pxij/FUhJJ3t2T3j1vnpEksC?=
 =?us-ascii?Q?Yasei+iU8O/cqKRGq4mee4jGyvuKMhuV4kukkSQLPxO44O/BNh8OnNL2E8N2?=
 =?us-ascii?Q?VO7U+lDTABwJRGVXU8iKqVdZRAAKh+otdE414g0SKoPQ2NcOSeOy9VV/fNSy?=
 =?us-ascii?Q?X9YkQUmtnz/JGqbRinEqx8FZ9+G1JtrpTbiH70vcPnr15PAzbGYi+hLKYrfT?=
 =?us-ascii?Q?utpAxKIC38NlqWjA0/yGmgM8DLAbVGyeu8mWQLYaM8FPbYNJdGhw1y68Hf1z?=
 =?us-ascii?Q?XkGRjGX/QhO/ZPjKB5fzSTlY9cC4FRKeCm1g83eTXVyo6a4Qb3myC2WmtdG6?=
 =?us-ascii?Q?hcKCblUXJ8IPsyS/oj7yn7cq4i2yRnmZnbuUMKKLObyjh8EBkCTWpvOcMAP1?=
 =?us-ascii?Q?MJiw658xm+WTD2G/8NYjQZZjrhEKMng1HXrHk91KDl0eF50g4eKiF98DHVwz?=
 =?us-ascii?Q?nsoL8ijedKhl3jWyitQd07eW/WT7Ni8M8yRR4RjtWAIeyLupLmGRBvg0j+ZQ?=
 =?us-ascii?Q?5Cz0MMY/vubTFTvw7r6BqzQ3KJXn/cCbTtEC4RIo2pKwBotxHMj3SOYLFDgu?=
 =?us-ascii?Q?BmEr0hGTw5WCs2kclA1f8NRtnkOeFlwoj8HetpyTPlSNI/GVDMp+s8jLPBc6?=
 =?us-ascii?Q?uHa8y35/4PZ04vK+1Wi/zGmPuCUwifau8HGML6jvC/KwNs2ROMA7DjOxuaPr?=
 =?us-ascii?Q?8dgW+FCeqkwMmkm/D7ZHnm6I9pfHesS+y3g1pl0JKwdoJVrn+q+sHVlOKHTN?=
 =?us-ascii?Q?KuN/ecdh7qMZmWWhMXAstY86ITXIzm4AOB8/mbNArUiou3qxrMt0h+E45w5b?=
 =?us-ascii?Q?/Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e480999-53f1-4778-a14d-08dd882ac97a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 21:05:50.6703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qghrt+KVwCnoG+UfESx/S3MRFZwnKiiJokg0VbYuFkQCCD+21iGs5fHTPopAqD438SDwcJhmfP8I9MR7tzaY7C9XGho2xE4V8Ptj6tpKnpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, March 6, 2025 1:17 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v8 14/14] mm: zswap: Compress batching with request
> chaining in zswap_store() of large folios.
>=20
> On Mon, Mar 03, 2025 at 12:47:24AM -0800, Kanchana P Sridhar wrote:
> > This patch introduces three new procedures:
> >
> >  zswap_store_folio()
> >  zswap_store_pages()
> >  zswap_batch_compress()
> >
> > zswap_store_folio() stores a folio in chunks of "batch_size" pages. If =
the
> > compressor supports batching and has multiple acomp_ctx->nr_reqs, the
> > batch_size will be the acomp_ctx->nr_reqs. If the compressor does not
> > support batching, the batch_size will be ZSWAP_MAX_BATCH_SIZE. The
> > compressor having multiple acomp_ctx->nr_reqs is passed as a bool
> > "batching" parameter to zswap_store_pages() and
> zswap_batch_compress().
> > This refactorization allows us to move the loop over the folio's pages =
from
> > zswap_store() to zswap_store_folio(), and also enables batching.
> >
> > zswap_store_pages() implements all the computes done earlier in
> > zswap_store_page() for a single-page, for multiple pages in a folio, na=
mely
> > a "batch". zswap_store_pages() starts by allocating all zswap entries
> > required to store the batch. Next, it calls zswap_batch_compress() to
> > compress the batch. Finally, it adds the batch's zswap entries to the
> > xarray and LRU, charges zswap memory and increments zswap stats.
> >
> > The error handling and cleanup required for all failure scenarios that =
can
> > occur while storing a batch in zswap are consolidated to a single
> > "store_pages_failed" label in zswap_store_pages().
> >
> > And finally, this patch introduces zswap_batch_compress(), which does t=
he
> > following:
> >   - If the compressor supports batching, sets up a request chain for
> >     compressing the batch in one shot. If Intel IAA is the zswap
> >     compressor, the request chain will be compressed in parallel in
> >     hardware. If all requests in the chain are compressed without error=
s,
> >     the compressed buffers are then stored in zpool.
> >   - If the compressor does not support batching, each page in the batch=
 is
> >     compressed and stored sequentially. zswap_batch_compress() replaces
> >     zswap_compress(), thereby eliminating code duplication and facilita=
ting
> >     maintainability of the code with the introduction of batching.
> >
> > The call to the crypto layer is exactly the same in both cases: when ba=
tch
> > compressing a request chain or when sequentially compressing each page =
in
> > the batch.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
>=20
> High-level comment: It may be better to break this down into two
> patches, one reworking the code to process folios in batches, and one to
> add support for compression batching and request chaining. This may make
> it more digestable.

Hi Yosry,=20

Thanks a lot for all your suggestions!

I have addressed this in v9.

>=20
> >  mm/zswap.c | 396 ++++++++++++++++++++++++++++++++++++-------------
> ----
> >  1 file changed, 270 insertions(+), 126 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index fae59d6d5147..135d5792ce50 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1051,74 +1051,141 @@ static void acomp_ctx_put_unlock(struct
> crypto_acomp_ctx *acomp_ctx)
> >  	mutex_unlock(&acomp_ctx->mutex);
> >  }
> >
> > -static bool zswap_compress(struct page *page, struct zswap_entry *entr=
y,
> > -			   struct zswap_pool *pool)
> > +/*
> > + * Unified code paths for compressors that do and do not support
> > + * batching. This procedure will compress multiple @nr_pages in @folio=
,
> > + * starting from @index.
> > + * If @batching is set to true, it will create a request chain for
> > + * compression batching. It is assumed that the caller has verified
> > + * that the acomp_ctx->nr_reqs is at least @nr_pages.
> > + * If @batching is set to false, it will process each page sequentiall=
y.
> > + * In both cases, if all compressions were successful, it will proceed
> > + * to store the compressed buffers in zpool.
> > + */
> > +static bool zswap_batch_compress(struct folio *folio,
> > +				 long index,
> > +				 unsigned int nr_pages,
> > +				 struct zswap_entry *entries[],
> > +				 struct zswap_pool *pool,
> > +				 struct crypto_acomp_ctx *acomp_ctx,
> > +				 bool batching)
>=20
> If we have a single compress function let's keep it called
> zswap_compress() please.

Yes, I have addressed this in v9.

>=20
> >  {
> > -	struct crypto_acomp_ctx *acomp_ctx;
> > -	struct scatterlist input, output;
> > -	int comp_ret =3D 0, alloc_ret =3D 0;
> > -	unsigned int dlen =3D PAGE_SIZE;
> > -	unsigned long handle;
> > -	struct zpool *zpool;
> > -	char *buf;
> > +	struct scatterlist inputs[ZSWAP_MAX_BATCH_SIZE];
> > +	struct scatterlist outputs[ZSWAP_MAX_BATCH_SIZE];
> > +	struct zpool *zpool =3D pool->zpool;
> > +	int acomp_idx =3D 0, nr_to_store =3D 1;
> > +	unsigned int i, j;
> > +	int err =3D 0;
> >  	gfp_t gfp;
> > -	u8 *dst;
> >
> > -	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > -	dst =3D acomp_ctx->buffers[0];
> > -	sg_init_table(&input, 1);
> > -	sg_set_page(&input, page, PAGE_SIZE, 0);
> > +	lockdep_assert_held(&acomp_ctx->mutex);
> >
> > -	/*
> > -	 * We need PAGE_SIZE * 2 here since there maybe over-compression
> case,
> > -	 * and hardware-accelerators may won't check the dst buffer size, so
> > -	 * giving the dst buffer with enough length to avoid buffer overflow.
> > -	 */
> > -	sg_init_one(&output, dst, PAGE_SIZE * 2);
> > -	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output,
> PAGE_SIZE, dlen);
> > -
> > -	/*
> > -	 * it maybe looks a little bit silly that we send an asynchronous
> request,
> > -	 * then wait for its completion synchronously. This makes the process
> look
> > -	 * synchronous in fact.
> > -	 * Theoretically, acomp supports users send multiple acomp requests
> in one
> > -	 * acomp instance, then get those requests done simultaneously. but
> in this
> > -	 * case, zswap actually does store and load page by page, there is no
> > -	 * existing method to send the second page before the first page is
> done
> > -	 * in one thread doing zwap.
> > -	 * but in different threads running on different cpu, we have differe=
nt
> > -	 * acomp instance, so multiple threads can do (de)compression in
> parallel.
> > -	 */
> > -	comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> >reqs[0]), &acomp_ctx->wait);
> > -	dlen =3D acomp_ctx->reqs[0]->dlen;
> > -	if (comp_ret)
> > -		goto unlock;
> > -
> > -	zpool =3D pool->zpool;
> >  	gfp =3D __GFP_NORETRY | __GFP_NOWARN |
> __GFP_KSWAPD_RECLAIM;
> >  	if (zpool_malloc_support_movable(zpool))
> >  		gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> > -	alloc_ret =3D zpool_malloc(zpool, dlen, gfp, &handle);
> > -	if (alloc_ret)
> > -		goto unlock;
> >
> > -	buf =3D zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> > -	memcpy(buf, dst, dlen);
> > -	zpool_unmap_handle(zpool, handle);
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		struct page *page =3D folio_page(folio, index + i);
> >
> > -	entry->handle =3D handle;
> > -	entry->length =3D dlen;
> > +		sg_init_table(&inputs[acomp_idx], 1);
> > +		sg_set_page(&inputs[acomp_idx], page, PAGE_SIZE, 0);
> >
> > -unlock:
> > -	if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> > -		zswap_reject_compress_poor++;
> > -	else if (comp_ret)
> > -		zswap_reject_compress_fail++;
> > -	else if (alloc_ret)
> > -		zswap_reject_alloc_fail++;
> > +		/*
> > +		 * Each dst buffer should be of size (PAGE_SIZE * 2).
> > +		 * Reflect same in sg_list.
>=20
> The existing comment about overcompression was useful, please move it
> as-is.

Done.

>=20
> > +		 */
> > +		sg_init_one(&outputs[acomp_idx], acomp_ctx-
> >buffers[acomp_idx], PAGE_SIZE * 2);
> > +		acomp_request_set_params(acomp_ctx->reqs[acomp_idx],
> &inputs[acomp_idx],
> > +					 &outputs[acomp_idx], PAGE_SIZE,
> PAGE_SIZE);
> > +
> > +		if (batching) {
> > +			/* Add the acomp request to the chain. */
> > +			if (likely(i))
> > +				acomp_request_chain(acomp_ctx-
> >reqs[acomp_idx], acomp_ctx->reqs[0]);
> > +			else
> > +				acomp_reqchain_init(acomp_ctx->reqs[0], 0,
> crypto_req_done,
> > +						    &acomp_ctx->wait);
> > +
> > +			if (i =3D=3D (nr_pages - 1)) {
> > +				/* Process the request chain. */
> > +				err =3D
> crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]),
> &acomp_ctx->wait);
> > +
> > +				/*
> > +				 * Get the individual compress errors from
> request chaining.
> > +				 */
> > +				for (j =3D 0; j < nr_pages; ++j) {
> > +					if
> (unlikely(acomp_request_err(acomp_ctx->reqs[j]))) {
> > +						err =3D -EINVAL;
> > +						if
> (acomp_request_err(acomp_ctx->reqs[j]) =3D=3D -ENOSPC)
> > +
> 	zswap_reject_compress_poor++;
> > +						else
> > +
> 	zswap_reject_compress_fail++;
> > +					}
> > +				}
> > +				/*
> > +				 * Request chaining cleanup:
> > +				 *
> > +				 * - Clear the CRYPTO_TFM_REQ_CHAIN bit
> on acomp_ctx->reqs[0].
> > +				 * - Reset the acomp_ctx->wait to notify
> acomp_ctx->reqs[0].
> > +				 */
> > +				acomp_reqchain_clear(acomp_ctx->reqs[0],
> &acomp_ctx->wait);
> > +				if (unlikely(err))
> > +					return false;
> > +				j =3D 0;
> > +				nr_to_store =3D nr_pages;
> > +				goto store_zpool;
> > +			}
> > +
> > +			++acomp_idx;
> > +			continue;
>=20
> The code structure here is really hard to read:
>=20
> (1) Why do we need 'batching' to begin with? Can't we use the same
> request chaining APIs even for the '!batching' case? Are there any
> regressions for doing so?
>=20
> (2) Instead of the control flow having 'continue', 'goto', and nested
> loops, can we just have separate loops?
>=20
> IOW can we do something like:
>=20
> 	for (..) {
> 		if (i =3D=3D 0)
> 			acomp_reqchain_init(..);
> 		else
> 			acomp_request_chain(..);
> 	}
>=20
> 	crypto_wait_req(..);
> 	/* collect errors */
> 	acomp_reqchain_clear(..);
>=20
> 	for (..) {
> 		/* store */
> 	}
>=20

Thanks for these suggestions! Hopefully the v9 version is much simpler.

> > +		} else {
> > +			err =3D
> crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]),
> &acomp_ctx->wait);
> > +
> > +			if (unlikely(err)) {
> > +				if (err =3D=3D -ENOSPC)
> > +					zswap_reject_compress_poor++;
> > +				else
> > +					zswap_reject_compress_fail++;
> > +				return false;
> > +			}
> > +			j =3D i;
> > +			nr_to_store =3D 1;
> > +		}
> >
> > -	acomp_ctx_put_unlock(acomp_ctx);
> > -	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > +store_zpool:
> > +		/*
> > +		 * All batch pages were successfully compressed.
> > +		 * Store the pages in zpool.
> > +		 */
> > +		acomp_idx =3D -1;
> > +		while (nr_to_store--) {
> > +			unsigned long handle;
> > +			char *buf;
> > +
> > +			++acomp_idx;
> > +			prefetchw(entries[j]);
> > +			err =3D zpool_malloc(zpool, acomp_ctx-
> >reqs[acomp_idx]->dlen, gfp, &handle);
> > +
> > +			if (unlikely(err)) {
> > +				if (err =3D=3D -ENOSPC)
> > +					zswap_reject_compress_poor++;
> > +				else
> > +					zswap_reject_alloc_fail++;
> > +
> > +				return false;
> > +			}
> > +
> > +			buf =3D zpool_map_handle(zpool, handle,
> ZPOOL_MM_WO);
> > +			memcpy(buf, acomp_ctx->buffers[acomp_idx],
> acomp_ctx->reqs[acomp_idx]->dlen);
> > +			zpool_unmap_handle(zpool, handle);
> > +
> > +			entries[j]->handle =3D handle;
> > +			entries[j]->length =3D acomp_ctx->reqs[acomp_idx]-
> >dlen;
> > +			++j;
> > +		}
> > +	}
> > +
> > +	return true;
> >  }
> >
> >  static void zswap_decompress(struct zswap_entry *entry, struct folio
> *folio)
> > @@ -1581,84 +1648,165 @@ static void shrink_worker(struct work_struct
> *w)
> >  * main API
> >  **********************************/
> >
> > -static bool zswap_store_page(struct page *page,
> > -			     struct obj_cgroup *objcg,
> > -			     struct zswap_pool *pool)
> > +/*
> > + * Store multiple pages in @folio, starting from the page at index @si=
 up to
> > + * and including the page at index @ei.
>=20
> 'start' and 'end'?

Incorporated this.

>=20
> > + *
> > + * The error handling from all failure points is consolidated to the
> > + * "store_pages_failed" label, based on the initialization of the zswa=
p
> entries'
> > + * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that t=
he
> > + * entry's handle is subsequently modified only upon a successful
> zpool_malloc()
> > + * after the page is compressed.
>=20
> This comment is not useful here. Instead comment on specific parts of
> the function where the intention of the code is not clear.

Done.

>=20
> > + */
> > +static bool zswap_store_pages(struct folio *folio,
> > +			      long si,
> > +			      long ei,
> > +			      struct obj_cgroup *objcg,
> > +			      struct zswap_pool *pool,
> > +			      struct crypto_acomp_ctx *acomp_ctx,
> > +			      bool batching)
> >  {
> > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > -	struct zswap_entry *entry, *old;
> > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > +	int node_id =3D folio_nid(folio);
> > +	u8 i, from_i =3D 0, nr_pages =3D ei - si + 1;
> >
> > -	/* allocate entry */
> > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > -	if (!entry) {
> > -		zswap_reject_kmemcache_fail++;
> > -		return false;
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL, node_id);
> > +
> > +		if (unlikely(!entries[i])) {
> > +			zswap_reject_kmemcache_fail++;
> > +			nr_pages =3D i;
> > +			goto store_pages_failed;
> > +		}
> > +
> > +		entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> >  	}
> >
> > -	if (!zswap_compress(page, entry, pool))
> > -		goto compress_failed;
> > +	if (!zswap_batch_compress(folio, si, nr_pages, entries, pool,
> acomp_ctx, batching))
> > +		goto store_pages_failed;
> >
> > -	old =3D xa_store(swap_zswap_tree(page_swpentry),
> > -		       swp_offset(page_swpentry),
> > -		       entry, GFP_KERNEL);
> > -	if (xa_is_err(old)) {
> > -		int err =3D xa_err(old);
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		swp_entry_t page_swpentry =3D
> page_swap_entry(folio_page(folio, si + i));
> > +		struct zswap_entry *old, *entry =3D entries[i];
> >
> > -		WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> %d\n", err);
> > -		zswap_reject_alloc_fail++;
> > -		goto store_failed;
> > -	}
> > +		old =3D xa_store(swap_zswap_tree(page_swpentry),
> > +			       swp_offset(page_swpentry),
> > +			       entry, GFP_KERNEL);
> > +		if (unlikely(xa_is_err(old))) {
> > +			int err =3D xa_err(old);
> >
> > -	/*
> > -	 * We may have had an existing entry that became stale when
> > -	 * the folio was redirtied and now the new version is being
> > -	 * swapped out. Get rid of the old.
> > -	 */
> > -	if (old)
> > -		zswap_entry_free(old);
> > +			WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray
> error: %d\n", err);
> > +			zswap_reject_alloc_fail++;
> > +			from_i =3D i;
>=20
> 'error_idx' or 'store_fail_idx'?

Done.

>=20
> > +			goto store_pages_failed;
> > +		}
> >
> > -	/*
> > -	 * The entry is successfully compressed and stored in the tree, there=
 is
> > -	 * no further possibility of failure. Grab refs to the pool and objcg=
,
> > -	 * charge zswap memory, and increment zswap_stored_pages.
> > -	 * The opposite actions will be performed by zswap_entry_free()
> > -	 * when the entry is removed from the tree.
> > -	 */
> > -	zswap_pool_get(pool);
> > -	if (objcg) {
> > -		obj_cgroup_get(objcg);
> > -		obj_cgroup_charge_zswap(objcg, entry->length);
> > -	}
> > -	atomic_long_inc(&zswap_stored_pages);
> > +		/*
> > +		 * We may have had an existing entry that became stale when
> > +		 * the folio was redirtied and now the new version is being
> > +		 * swapped out. Get rid of the old.
> > +		 */
> > +		if (unlikely(old))
> > +			zswap_entry_free(old);
> >
> > -	/*
> > -	 * We finish initializing the entry while it's already in xarray.
> > -	 * This is safe because:
> > -	 *
> > -	 * 1. Concurrent stores and invalidations are excluded by folio lock.
> > -	 *
> > -	 * 2. Writeback is excluded by the entry not being on the LRU yet.
> > -	 *    The publishing order matters to prevent writeback from seeing
> > -	 *    an incoherent entry.
> > -	 */
> > -	entry->pool =3D pool;
> > -	entry->swpentry =3D page_swpentry;
> > -	entry->objcg =3D objcg;
> > -	entry->referenced =3D true;
> > -	if (entry->length) {
> > -		INIT_LIST_HEAD(&entry->lru);
> > -		zswap_lru_add(&zswap_list_lru, entry);
> > +		/*
> > +		 * The entry is successfully compressed and stored in the tree,
> there is
> > +		 * no further possibility of failure. Grab refs to the pool and
> objcg,
> > +		 * charge zswap memory, and increment
> zswap_stored_pages.
> > +		 * The opposite actions will be performed by
> zswap_entry_free()
> > +		 * when the entry is removed from the tree.
> > +		 */
> > +		zswap_pool_get(pool);
> > +		if (objcg) {
> > +			obj_cgroup_get(objcg);
> > +			obj_cgroup_charge_zswap(objcg, entry->length);
> > +		}
> > +		atomic_long_inc(&zswap_stored_pages);
> > +
> > +		/*
> > +		 * We finish initializing the entry while it's already in xarray.
> > +		 * This is safe because:
> > +		 *
> > +		 * 1. Concurrent stores and invalidations are excluded by folio
> lock.
> > +		 *
> > +		 * 2. Writeback is excluded by the entry not being on the LRU
> yet.
> > +		 *    The publishing order matters to prevent writeback from
> seeing
> > +		 *    an incoherent entry.
> > +		 */
> > +		entry->pool =3D pool;
> > +		entry->swpentry =3D page_swpentry;
> > +		entry->objcg =3D objcg;
> > +		entry->referenced =3D true;
> > +		if (likely(entry->length)) {
> > +			INIT_LIST_HEAD(&entry->lru);
> > +			zswap_lru_add(&zswap_list_lru, entry);
> > +		}
> >  	}
> >
> >  	return true;
> >
> > -store_failed:
> > -	zpool_free(pool->zpool, entry->handle);
> > -compress_failed:
> > -	zswap_entry_cache_free(entry);
> > +store_pages_failed:
> > +	for (i =3D from_i; i < nr_pages; ++i) {
> > +		if (!IS_ERR_VALUE(entries[i]->handle))
> > +			zpool_free(pool->zpool, entries[i]->handle);
> > +
> > +		zswap_entry_cache_free(entries[i]);
> > +	}
> > +
> >  	return false;
> >  }
> >
> > +/*
> > + * Store all pages in a folio by calling zswap_batch_compress().
> > + * If the compressor supports batching, i.e., has multiple acomp reque=
sts,
> > + * the folio will be compressed in batches of "acomp_ctx->nr_reqs" usi=
ng
> > + * request chaining.
> > + * If the compressor has only one acomp request, the folio will be
> compressed
> > + * in batches of ZSWAP_MAX_BATCH_SIZE pages, where each page in the
> batch is
> > + * compressed sequentially.
> > + */
> > +static bool zswap_store_folio(struct folio *folio,
> > +			      struct obj_cgroup *objcg,
> > +			      struct zswap_pool *pool)
> > +{
> > +	long nr_pages =3D folio_nr_pages(folio);
> > +	struct crypto_acomp_ctx *acomp_ctx;
> > +	unsigned int batch_size;
> > +	bool ret =3D true, batching;
> > +	long si, ei;
> > +
> > +	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > +
> > +	batching =3D ((acomp_ctx->nr_reqs > 1) && (nr_pages > 1));
> > +
> > +	batch_size =3D batching ? acomp_ctx->nr_reqs :
> ZSWAP_MAX_BATCH_SIZE;
>=20
> acomp_ctx->nr_reqs is a function of the compressor. Can we store it in
> the pool to avoid having to hold the mutex here just for this?
>=20
> This would also save a tiny bit of memory as right now we have it
> replicated for all CPUs.

Great suggestion! I have incorporated this in v9.

>=20
> > +
> > +	if (!batching)
> > +		acomp_ctx_put_unlock(acomp_ctx);
>=20
> So in the batching case we keep the mutex held throughout, otherwise we
> hold it for every batch. Why?
>=20
> IIRC you mentioned that only holding it for every batch removes the zstd
> regressions, perhaps because holding the mutex for too long is a
> problem. But why not do the same for the batching case too?
>=20
> Also, the current behavior is that we only hold the mutex during
> compression. Now we changed this to do it per-folio or per-batch. Does
> the current behavior cause regressions? Ideally we'd like to keep the
> mutex held as little as possible.
>=20
> This is worth explaining in detail.

In v9, the mutex lock is held within zswap_compress() for the duration
of a batch. This was one of the optimizations that uniformly improved
performance for both, non-batching and batching compressors.
With the latest code, other options that I tried, such as locking per folio
or locking per page, caused regressions for zstd.

>=20
> > +
> > +	/* Store the folio in batches of "batch_size" pages. */
> > +	for (si =3D 0, ei =3D min(si + batch_size - 1, nr_pages - 1);
> > +	     ((si < nr_pages) && (ei < nr_pages));
> > +	     si =3D ei + 1, ei =3D min(si + batch_size - 1, nr_pages - 1)) {
>=20
> This is too complicated. Can we do:
>=20
> 	for (start =3D 0; start < nr_pages; start +=3D batch_size) {
> 		end =3D min(start + batch_size - 1, nr_pages - 1);
> 		...
> 	}
>=20
> Also, we subtract 1 from ei here and add 1 in zswap_store_pages(), so
> perhaps it's better to make it exclusive:
>=20
> 	for (start =3D 0; start < nr_pages; start +=3D batch_size) {
> 		end =3D min(start + batch_size, nr_pages);
> 		...
> 	}
>=20

Done.

> > +
> > +		if (!batching)
> > +			acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > +
> > +		if (!zswap_store_pages(folio, si, ei, objcg, pool, acomp_ctx,
> batching)) {
> > +			ret =3D false;
> > +			break;
> > +		}
> > +
> > +		if (!batching)
> > +			acomp_ctx_put_unlock(acomp_ctx);
> > +	}
> > +
> > +	if (batching || !ret)
> > +		acomp_ctx_put_unlock(acomp_ctx);
> > +
> > +	return ret;
> > +}
> > +
> >  bool zswap_store(struct folio *folio)
> >  {
> >  	long nr_pages =3D folio_nr_pages(folio);
> > @@ -1667,7 +1815,6 @@ bool zswap_store(struct folio *folio)
> >  	struct mem_cgroup *memcg =3D NULL;
> >  	struct zswap_pool *pool;
> >  	bool ret =3D false;
> > -	long index;
>=20
> These seems like an unrelated change.

I now have start/end, and reuse start in the error handling.

>=20
> >
> >  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> >  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> > @@ -1701,12 +1848,8 @@ bool zswap_store(struct folio *folio)
> >  		mem_cgroup_put(memcg);
> >  	}
> >
> > -	for (index =3D 0; index < nr_pages; ++index) {
> > -		struct page *page =3D folio_page(folio, index);
> > -
> > -		if (!zswap_store_page(page, objcg, pool))
> > -			goto put_pool;
> > -	}
> > +	if (!zswap_store_folio(folio, objcg, pool))
> > +		goto put_pool;
>=20
> If we move the locking out of zswap_store_folio() and simplify the loop
> there, I belive it will be simple enough for us to inline it here.

Yes indeed. Incorporated in v9.

>=20
> >
> >  	if (objcg)
> >  		count_objcg_events(objcg, ZSWPOUT, nr_pages);
> > @@ -1733,6 +1876,7 @@ bool zswap_store(struct folio *folio)
> >  		pgoff_t offset =3D swp_offset(swp);
> >  		struct zswap_entry *entry;
> >  		struct xarray *tree;
> > +		long index;
> >
> >  		for (index =3D 0; index < nr_pages; ++index) {
> >  			tree =3D swap_zswap_tree(swp_entry(type, offset +
> index));
> > --
> > 2.27.0
> >
