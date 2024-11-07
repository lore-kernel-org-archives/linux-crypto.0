Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD63218306;
	Thu,  7 Nov 2024 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018075; cv=fail; b=cVK9KrtE8R3M2ujYXegsbCrGtW/ZdnFshsC8Ap0Y+JsvSMII12gqHeTg9muRTTvyeVZoSsiHYavDYxNtj+aakBMmRnoVAcIZfio5vzi/44gGfiPV37mmRuaX/YQC42iPqAYaxMeqGpxLnSG4J2c4uqgdzGHTv+iGor+h7YFSikA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018075; c=relaxed/simple;
	bh=NkI5Q8YtZNTEFhhfiePd3WW60qO4wQvKofHKaYHeXo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S6me0Nplratg8Tfz0iwq2v7B356hMycivYK/rg/Q3TE8Q3WIiJyl7TY4GwNzMJOYARFrDpGKKBLpQLwRa1iFGBn4VNCDeUbs/S8oP/D8gKfxt7gzWDwjjz9WnlRvyPUehXXG2HLiMWWplbm6tVnbVfc9B+ojy885k9IpmAIbTWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mrvdq9fi; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrvdq9fi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731018074; x=1762554074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NkI5Q8YtZNTEFhhfiePd3WW60qO4wQvKofHKaYHeXo0=;
  b=mrvdq9fimgW6QmFxGZtliVFWVBoSnP5lTaOYsigZSkWdFQ+uaV8xbfU+
   zuSMTCz/H564eU6Mq5puwc02VTQwVlmab89lgf5XitO298/mIq15qW4Lv
   t2XSq/bYxd/3Lf6G9GtgnKbcifOZylxqHo6RNbcAiZ0FFBfHjBvnStOwX
   MkXSh7eDARjMeh/g/82FlDpivvUXokHz1bVcL6wNpf91H6lc+4DgR3ZZs
   HI18izuz/xH3WQA8lGKEKbgOOjgEsQOo8MNieGuAIbzaQAkF10wSG6+C/
   h0a5kCRgKSHqiZGmbfq4XpUjwqHYMr1JbwpErEQPLXcIXZz4+9u8+31bB
   g==;
X-CSE-ConnectionGUID: i7xlLlHSSdC51HgswpAECw==
X-CSE-MsgGUID: d9x9YFNEQRq6nJA+/nw2Rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30660114"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30660114"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 14:21:10 -0800
X-CSE-ConnectionGUID: DaEOUmPUTn2aVAOe4F6qGg==
X-CSE-MsgGUID: SvSJ+CS8TKOb4I/tUmU/fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="90385026"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 14:21:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 14:21:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 14:21:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 14:21:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GKIA58D2qiBSSmg+gmDfFnY3nVy6IDZ+AeC0rSyuRRAJcfDgQu9Nkuc/PTpyqD+fpapcX92djmBI6icqcenYFQn7XYjpUwdYoNFffd4rdWUFJp5hvgpLiHxIzP9tMgFNN95u59qg/x1hHBO6cS7d5gX7QnLh9+GyeRTiTJYR5QwYvgC/i19YGdsJiHvYs+XoSFhFinbddpx3AsNn7KmpQ3Df2IM/cGKBP6T0WkJMfurfV55/gWNAbYiYoz264AjpwQY85I5VTgo3v70hnId+S486q4JvDCh2GRbYplrPxzT3cPIxfsWTkCgImjsR538ORcpFrlnQUiT3JYVgpif5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKc1IEfuhkuQql0fp/oMALWM9XpgZ9scgKJe6QwBObg=;
 b=WmPIi98TcI42dJ6JT1ar0OmeDEy0kZGw5k4IE4c5avI7p9T/h/vIbMszYdloHMt/QjeFmW0XzlvNenz8odRqxlFlMbP+CI3qr8YkodCMvrerzSRf6qqVPsZnIH9zSQBUke7qSNPjLZ5QJTnhA6lTz8L2pV+jNzeCVy2mwlRVZeubx1NOf5qpqozAlHj7P3CyZH2jfiVH59MhBEWfrSkXx3lAKWUyxMgi8v6OvrmbcBypKSW83MG1ETzaAUgHCJNvc4ttSpENH6o0s1IEnERMzKjWBYw/IRkRPIi9sWbPYr2J/Q9BG3varMACNmoXQavtm435VOIoL8B661Qq+sEFCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 22:21:04 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 22:21:04 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
Thread-Topic: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
Thread-Index: AQHbMIERO8oD7n2rBEKiN2M+KhtYprKsEc0AgABO+cA=
Date: Thu, 7 Nov 2024 22:21:04 +0000
Message-ID: <SJ0PR11MB5678FA2EA40FEFE20521AC6BC95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-10-kanchana.p.sridhar@intel.com>
 <20241107172056.GC1172372@cmpxchg.org>
In-Reply-To: <20241107172056.GC1172372@cmpxchg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SA0PR11MB4525:EE_
x-ms-office365-filtering-correlation-id: 26b6a723-4023-439e-b828-08dcff7a7805
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?dwL72CAmvZrp935IOve/zUc8FArNa2wLEEoU4JCNUdEMLCdk18xgjYpSk6O8?=
 =?us-ascii?Q?OUrIUsb52oB2Mw9gDbEXUUPv8gyFohc5nHpKnR92X7qDEQXsbxmdLykVqWyc?=
 =?us-ascii?Q?mETiTAFZvXllZuI2XVnXa7Bv3VGdY1lxGD9tRxKyHUtuyUD5d+fyrW/tpkV6?=
 =?us-ascii?Q?8q0qSAiyGUxFvVcWII/G4PSTb57jan+wigQYKVhuLI+wyLjU7CauqrnKrYz5?=
 =?us-ascii?Q?gWM1Zv9v7Xvdd+PYx28Zbqx5lTn5MsoFXWMgTEIXcmhjS3OmGNv1pNVLNDVy?=
 =?us-ascii?Q?E+fvWHbe5tcBNYi9DamqbhqnhRVdpSF/6mhNsPOPMTlGsEWMzjPGb62AcnFf?=
 =?us-ascii?Q?4tWJ3+lYQHqww2KBMxFNOdNPdoy9xGanYDvZkzCUgYbveCtD++GJk/79yX4R?=
 =?us-ascii?Q?gvZrv32IgtJJSrCSXLBqWsI0AszRWcmDXk5UN6F8b448sAPlIXEglu8iCH83?=
 =?us-ascii?Q?kMNpLIElPGrxXagQfX+mQHr/lIP1vmO4sFtXyuNOD+7yhKyT2qysh9fzUh6g?=
 =?us-ascii?Q?K9Nk9I81DdgBqWQCCCD8D6RxL0MxkdWvIR7bCVgo5skb/z7s07YMpOCcXXUI?=
 =?us-ascii?Q?RFifqxzVN30GsvaTSGAVSmVOnQEJJNbwmVay4H6QkRtF8DMp216DaWJfY5WY?=
 =?us-ascii?Q?ky6u4zC7py37lTzNVmGuyrgDjFN/Z73itO88jZrXF7wM//XXhNtdU51vwgzY?=
 =?us-ascii?Q?fzSgAtONLvE6n2iYEYtNfcF1jM5logd1cNB74J7UuFJO9cuWuyepRHiwcfcu?=
 =?us-ascii?Q?xFpCu80LlGpCSir7DnVlgNL+XYJttX+ocsd2Mi/F27zcnJgUqn2rV+AKoGiH?=
 =?us-ascii?Q?7G3eL2jyS+xpoG6H+DVYYOgTHLFSp20Hfn16rVUZyAjQSF9F3FhDjNHKdrnv?=
 =?us-ascii?Q?DvfgsCyzy/1SPTMgCzcuJ6EIg7kJlg5RCsaMYUoCsGsAts2kLixunM/I/5lc?=
 =?us-ascii?Q?VWQLVgQesKQjK2nCDopZcTXATZQ4CRwXdp6p0h3PKpv7FghwihpGNfs/jS00?=
 =?us-ascii?Q?7v3WaWjfD15QBgmg+VJbHTPsp6rJF2MN67gsvTKc2Z/eKeJqgjAnEjoLPb8q?=
 =?us-ascii?Q?BqGEu+2oYqqeUaivQEu69PLHXX0pcsdGY5OTkvqCri6sVVwOjw2bVZ3BiI65?=
 =?us-ascii?Q?pemhuvIJuNsHs5N4hZ89nVXNpgiYxDv/DEZA9dJiAEw/RMdVX8ZOZboVaZMz?=
 =?us-ascii?Q?wHkNtQgSZDh5vU4b3Xg3XjDorGBAHukDFE0AIn4H5MrxfQmjDJuqEwW5GEPu?=
 =?us-ascii?Q?rvQs8ctFEc0asviae0/2MGXrjqesvkjkff6yHlTIuyCcUUDXZM12n7fcZi69?=
 =?us-ascii?Q?lEfMD5QyHLfubjNf0HUy2zNH1p/iwqOXTsHZ/dFwLQWugfEtjqfnh6zLZPT/?=
 =?us-ascii?Q?8JWNgB8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fTUKp1FLCtv3UxZqP7Y94ZUH9iJ2i5zhQBBa6vrMhkX5xRLBM+GO0eOIrwMb?=
 =?us-ascii?Q?SP4dDGeEprimlQpv9QHavF/9Uxt7Y1sOlmdZpZ4PmiobJ+e0ts8hmrTFDpvQ?=
 =?us-ascii?Q?ylKrfx8oZ3Jt0tw5S5RlK3HYcKdt9Q7Wt9qZsQz4mJ3SjeNzob7oPhx5iFvw?=
 =?us-ascii?Q?G9cNcIKu7RUeTnvvvn9aNY7XDx43uUyHquNe6i6WW/Xa0GquZ7LuAjSkJ4h8?=
 =?us-ascii?Q?bBjE0hx8ADSM+nz6nFc1ui2Kzfgh3PS8QVW8uJvv5X0r3CYM4ge28YpTKLFP?=
 =?us-ascii?Q?yMXcrA7TTyxxO9fcfM+ymRrr7trbmtdFlkPgpAdHGj8Mk0Z/aaN4IjeWUWZE?=
 =?us-ascii?Q?P5y/yMbgqZGlnGbY2Q/jmZKjoEHN2Y/J5Rdwy7N22pvLfCBluDU72FagVXm9?=
 =?us-ascii?Q?knEvp2MJ0TwzL66ah+M76jn24jLiT7dg9jQS5CW2MOhDznrwCjbYJb6smtB9?=
 =?us-ascii?Q?n0upyI+7H1rECENFEh4YadkPXOFULhehUbsrF8m7c6/vDx2rxsH1TApHrFzm?=
 =?us-ascii?Q?csKJHE0UbMc1ij+HdyTZZYOTR7MOUVPDhiKZtcsrXtyhQHaaYsge7x1YY9SY?=
 =?us-ascii?Q?neLnM+bWOM5LBqIzyoJENxIO5NzZHQATIw/c395v1NNXanS08JBUt+nj/vuL?=
 =?us-ascii?Q?GwRryv2wif1uX5E7AYpNpIeb8CjUbgWYmbtacV2UXOoVo6bmLWKErMCCZt98?=
 =?us-ascii?Q?8WCAVUfFa1R5bfJRWptxyCh1QzUWwkGf2dhzIm4CXp5x6JvR2O5Vj+0QztFw?=
 =?us-ascii?Q?Nm2RbI19NFkrSW6ZdW7GUW1xm2eTihWCEW4JXyXzc9UOHxaSGIIANrd2vOq4?=
 =?us-ascii?Q?jRbXZTxl8Zd97vJ2quS6WiWMC6eJ/8wu1fB/oe5yBr2fNoMw9y4I3s5cGu6B?=
 =?us-ascii?Q?qtRFaXL4VDo/7rVglQCAcyqUrzFdjaXJI2YUAMTeYZRciGyC6rrpZr1bEJLu?=
 =?us-ascii?Q?X/WuKK29+9OVGEitk/51qCN1X/rBVst7XX3heRwTWRvJc7LMx6/PakOMGTsr?=
 =?us-ascii?Q?aDXGthqLjKKQu+0U/Oiyl4qlMksEUMzV+RqBlPa8jKOxQ2o+arSnYtbsa9t6?=
 =?us-ascii?Q?zViBFMrWESybRcSd+RNfFxAXP6Cpi/r3n55p0dA4FNRU1IeHvu/UyvuXvUSG?=
 =?us-ascii?Q?ZEoLG2L3vr0FCS3vswuYHyZtKUDxfsgouAPXfDk5u2kHZHoZIaRJOSmerCek?=
 =?us-ascii?Q?oI878P/u0kDr0dHyoUsK+RJpEzsINs0VEzD1qJCNDBUIJVlezA7UjVNK7kgB?=
 =?us-ascii?Q?YwcCtbeS5U+fJwyHBFgryeB8/uBbm1zZZu1SIs0hg4zKIesWkTga2atKEXOP?=
 =?us-ascii?Q?wLlloTkBCFWtNUwnY9bEFfF5cCdjXLm3ZK3hCsFPOr+weIe65VkbdAdbMQW1?=
 =?us-ascii?Q?PV9IGzIyB7cm7+Ay4KuATopcpf5moldTreoEQWqAgtbHZHOEzN7LG8zfv7Kb?=
 =?us-ascii?Q?549f5017VXTClHxtCmK1hhcnhYdVqImZwfOp2gC9MOxFdYfZw1v2vZR4hJVU?=
 =?us-ascii?Q?aJMqrSoKDbYSOs3Ps0UU3DRfoht6wqVFM/uiuOxMJWOGY+/Ar1dXu4x5ahaN?=
 =?us-ascii?Q?WC60P9qJpaw/gKl7EPrYSLtYyOG83nG/Dv5AEiAXhm373bPfsqLQw5pv/T8R?=
 =?us-ascii?Q?sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b6a723-4023-439e-b828-08dcff7a7805
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 22:21:04.4146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VoRplsYoRNUQLYSDs7ozxDcnecxxwkiVEoflqPcxuFJZ1jl89o/Ta5YyrZl0q0dD1ednXnPeiBqtBCNxVKIenMDwnDUloW3SQiU6J+io9As=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

Hi Johannes,

> -----Original Message-----
> From: Johannes Weiner <hannes@cmpxchg.org>
> Sent: Thursday, November 7, 2024 9:21 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx
> to be configurable in nr of acomp_reqs.
>=20
> On Wed, Nov 06, 2024 at 11:21:01AM -0800, Kanchana P Sridhar wrote:
> > Modified the definition of "struct crypto_acomp_ctx" to represent a
> > configurable number of acomp_reqs and the required number of buffers.
> >
> > Accordingly, refactored the code that allocates/deallocates the acomp_c=
tx
> > resources, so that it can be called to create a regular acomp_ctx with
> > exactly one acomp_req/buffer, for use in the the existing non-batching
> > zswap_store(), as well as to create a separate "batching acomp_ctx" wit=
h
> > multiple acomp_reqs/buffers for IAA compress batching.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 149 ++++++++++++++++++++++++++++++++++++++----------
> -----
> >  1 file changed, 107 insertions(+), 42 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 3e899fa61445..02e031122fdf 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -143,9 +143,10 @@ bool zswap_never_enabled(void)
> >
> >  struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> > -	struct acomp_req *req;
> > +	struct acomp_req **reqs;
> > +	u8 **buffers;
> > +	unsigned int nr_reqs;
> >  	struct crypto_wait wait;
> > -	u8 *buffer;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> >  };
> > @@ -241,6 +242,11 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
> >  		 zpool_get_type((p)->zpool))
> >
> > +static int zswap_create_acomp_ctx(unsigned int cpu,
> > +				  struct crypto_acomp_ctx *acomp_ctx,
> > +				  char *tfm_name,
> > +				  unsigned int nr_reqs);
>=20
> This looks unnecessary.

Thanks for the code review comments. I will make sure to avoid the
forward declarations.

>=20
> > +
> >  /*********************************
> >  * pool functions
> >  **********************************/
> > @@ -813,69 +819,128 @@ static void zswap_entry_free(struct
> zswap_entry *entry)
> >  /*********************************
> >  * compressed storage functions
> >  **********************************/
> > -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node
> *node)
> > +static int zswap_create_acomp_ctx(unsigned int cpu,
> > +				  struct crypto_acomp_ctx *acomp_ctx,
> > +				  char *tfm_name,
> > +				  unsigned int nr_reqs)
> >  {
> > -	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > -	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> >  	struct crypto_acomp *acomp;
> > -	struct acomp_req *req;
> > -	int ret;
> > +	int ret =3D -ENOMEM;
> > +	int i, j;
> >
> > +	acomp_ctx->nr_reqs =3D 0;
> >  	mutex_init(&acomp_ctx->mutex);
> >
> > -	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!acomp_ctx->buffer)
> > -		return -ENOMEM;
> > -
> > -	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> cpu_to_node(cpu));
> > +	acomp =3D crypto_alloc_acomp_node(tfm_name, 0, 0,
> cpu_to_node(cpu));
> >  	if (IS_ERR(acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> > -				pool->tfm_name, PTR_ERR(acomp));
> > -		ret =3D PTR_ERR(acomp);
> > -		goto acomp_fail;
> > +				tfm_name, PTR_ERR(acomp));
> > +		return PTR_ERR(acomp);
> >  	}
> > +
> >  	acomp_ctx->acomp =3D acomp;
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> >
> > -	req =3D acomp_request_alloc(acomp_ctx->acomp);
> > -	if (!req) {
> > -		pr_err("could not alloc crypto acomp_request %s\n",
> > -		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> > +	acomp_ctx->buffers =3D kmalloc_node(nr_reqs * sizeof(u8 *),
> > +					  GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffers)
> > +		goto buf_fail;
> > +
> > +	for (i =3D 0; i < nr_reqs; ++i) {
> > +		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2,
> > +						     GFP_KERNEL,
> cpu_to_node(cpu));
> > +		if (!acomp_ctx->buffers[i]) {
> > +			for (j =3D 0; j < i; ++j)
> > +				kfree(acomp_ctx->buffers[j]);
> > +			kfree(acomp_ctx->buffers);
> > +			ret =3D -ENOMEM;
> > +			goto buf_fail;
> > +		}
> > +	}
> > +
> > +	acomp_ctx->reqs =3D kmalloc_node(nr_reqs * sizeof(struct acomp_req
> *),
> > +				       GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->reqs)
> >  		goto req_fail;
> > +
> > +	for (i =3D 0; i < nr_reqs; ++i) {
> > +		acomp_ctx->reqs[i] =3D acomp_request_alloc(acomp_ctx-
> >acomp);
> > +		if (!acomp_ctx->reqs[i]) {
> > +			pr_err("could not alloc crypto acomp_request
> reqs[%d] %s\n",
> > +			       i, tfm_name);
> > +			for (j =3D 0; j < i; ++j)
> > +				acomp_request_free(acomp_ctx->reqs[j]);
> > +			kfree(acomp_ctx->reqs);
> > +			ret =3D -ENOMEM;
> > +			goto req_fail;
> > +		}
> >  	}
> > -	acomp_ctx->req =3D req;
> >
> > +	/*
> > +	 * The crypto_wait is used only in fully synchronous, i.e., with scom=
p
> > +	 * or non-poll mode of acomp, hence there is only one "wait" per
> > +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> > +	 * there is at least 1 request per acomp_ctx.
> > +	 */
> >  	crypto_init_wait(&acomp_ctx->wait);
> >  	/*
> >  	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> >  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> >  	 * won't be called, crypto_wait_req() will return without blocking.
> >  	 */
> > -	acomp_request_set_callback(req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +	acomp_request_set_callback(acomp_ctx->reqs[0],
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  				   crypto_req_done, &acomp_ctx->wait);
> >
> > +	acomp_ctx->nr_reqs =3D nr_reqs;
> >  	return 0;
> >
> >  req_fail:
> > +	for (i =3D 0; i < nr_reqs; ++i)
> > +		kfree(acomp_ctx->buffers[i]);
> > +	kfree(acomp_ctx->buffers);
> > +buf_fail:
> >  	crypto_free_acomp(acomp_ctx->acomp);
> > -acomp_fail:
> > -	kfree(acomp_ctx->buffer);
> >  	return ret;
> >  }
> >
> > -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> *node)
> > +static void zswap_delete_acomp_ctx(struct crypto_acomp_ctx
> *acomp_ctx)
> >  {
> > -	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > -	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > -
> >  	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> > -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > -			acomp_request_free(acomp_ctx->req);
> > +		int i;
> > +
> > +		for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> > +				acomp_request_free(acomp_ctx->reqs[i]);
> > +		kfree(acomp_ctx->reqs);
> > +
> > +		for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +			kfree(acomp_ctx->buffers[i]);
> > +		kfree(acomp_ctx->buffers);
> > +
> >  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  			crypto_free_acomp(acomp_ctx->acomp);
> > -		kfree(acomp_ctx->buffer);
> > +
> > +		acomp_ctx->nr_reqs =3D 0;
> > +		acomp_ctx =3D NULL;
> >  	}
> > +}
> > +
> > +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node
> *node)
> > +{
> > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > +	struct crypto_acomp_ctx *acomp_ctx;
> > +
> > +	acomp_ctx =3D per_cpu_ptr(pool->acomp_ctx, cpu);
> > +	return zswap_create_acomp_ctx(cpu, acomp_ctx, pool->tfm_name,
> 1);
> > +}
> > +
> > +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> *node)
> > +{
> > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > +	struct crypto_acomp_ctx *acomp_ctx;
> > +
> > +	acomp_ctx =3D per_cpu_ptr(pool->acomp_ctx, cpu);
> > +	zswap_delete_acomp_ctx(acomp_ctx);
> >
> >  	return 0;
> >  }
>=20
> There are no other callers to these functions. Just do the work
> directly in the cpu callbacks here like it used to be.

There will be other callers to zswap_create_acomp_ctx() and
zswap_delete_acomp_ctx() in patches 10 and 11 of this series, when the
per-cpu "acomp_batch_ctx" is introduced in struct zswap_pool. I was trying
to modularize the code first, so as to split the changes into smaller commi=
ts.

The per-cpu "acomp_batch_ctx" resources are allocated in patch 11 in the
"zswap_pool_can_batch()" function, that allocates batching resources
for this cpu. This was to address Yosry's earlier comment about minimizing
the memory footprint cost of batching.

The way I decided to do this is by reusing the code that allocates the de-f=
acto
pool->acomp_ctx for the selected compressor for all cpu's in zswap_pool_cre=
ate().
However, I did not want to add the acomp_batch_ctx multiple reqs/buffers
allocation to the cpuhp_state_add_instance() code path which would incur th=
e
memory cost on all cpu's.

Instead, the approach I chose to follow is to allocate the batching resourc=
es
in patch 11 only as needed, on "a given cpu" that has to store a large foli=
o. Hope
this explains the purpose of the modularization better.

Other ideas towards accomplishing this are very welcome.

Thanks,
Kanchana

>=20
> Otherwise it looks good to me.
