Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2361DE4F1
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768356914; cv=fail; b=FITVgqWuVhIvUIGeMV7Fz9Q9KbTjA8Zt8pRD/Doc9ygNF7RLqc/mkjxbWRGCbF01tkqyAnPI66mhkwy+Q1avJ1f4mpGewUQp8StdnC6nK5Fc3xuRuh8ChqTi4Rd9OyrTz6BEJJfTkiEMubYGXEtUNC5NIpCTqn+iVM9dMkbzVVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768356914; c=relaxed/simple;
	bh=W46/xpIlrfxKTUCxFsHtgc/cuj/7uSFSqhEFMVQiH6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OT+AFoPdNi780XMm3A8FRyqDBJfHHxgWwh7DvR7oLFizmi5c3d7IvHaulgkwSSwa0FPU/fNvjOEfjzIUwmAyCu73kVyJtjgOJIavCvDesRUMtop1splkrStDjVXAdz6UBC9nufENuu16P7r3SiC5P3vPOq+3ok4T+3oSTblJOHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XyTZH6Zx; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XyTZH6Zx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768356913; x=1799892913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W46/xpIlrfxKTUCxFsHtgc/cuj/7uSFSqhEFMVQiH6k=;
  b=XyTZH6Zx+8D3T1sGa9jPGMELmXtvecSPSq8ZPdQVthwceE0SZ+qrCuZn
   mVMZolsW+HUQFIAw0ajFwodQpi8i9XHpo/a9tzxzcW0vYHKLwIcqc/Ic/
   x09DldiYpfnhhSvwoxAQMWQmp3K6se2YColSyH5CIw9BOcS6IC3vCqyM6
   KoEGhhoEbgtB2DGs6SpsKK0chlPbmIuHfhfhscVD0fMcJaq8fNomxCOyk
   wlfHIeLJM1N0CG7myMuozuvRFDyT5v1wlrqXfjnAK7AHRCx9EUqEikYKz
   hLUSWv3KmoOYcxT4Ajkepi9zWi3tyGxyc3qso14HGxrIQtMsfImMVf3Sg
   A==;
X-CSE-ConnectionGUID: 49NTAW5kRdC0ldZLvDTM4Q==
X-CSE-MsgGUID: 8P0kPnG/TZack+QmHrsdZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="92321607"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="92321607"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:15:04 -0800
X-CSE-ConnectionGUID: IfuIKu6GQsW+MMBm4t5erQ==
X-CSE-MsgGUID: gjqwMGXAT8Kyup1yYsKuOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="204821434"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 18:15:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 18:15:01 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 18:15:01 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 18:15:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m+dHVt9miKpbTGwD2d/kjIBK2Jatacxqh6FhxexJzTnI1W/4Js4j5aWYvAKQW9I1IoObk4zHdZrXngUgaReiW1LfY6vaIP5r8Xn5LGZuL/WdkK3kU0og1n46Cgw8xgiQnkDBLGkBrn94OIXieq1L0tfaNs9DRvQOPgT6IBUUfRCEb0rg/xlOlEW40CmmtQcC3/NePOzIw4p5+8qoR81CdHyP7OUiWh0DKSsO0n/ev2v9KvlKrI2JPTTotvQ+9lmwUMecqDJDdh2sJikPsQRnMw8hIaj8zpvuZzisOp4pVq+GyoBFlzAvmfZHoEqde2qmnQfVV49LybuQSgF7NGJYqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFayYdhnAAtHUmYFaedgxlcSL30gFRuW9tm9HhmWCe4=;
 b=vGkGrKpmxSD0dNM29LfjoGETBcoQQtBXuVW0lh/tlm2mWAjsUOka/fq59wifQlDM/RV57WIZs6TbzmZh7rNflver0KM5ooNkuehFHRLZQWxGFUVUkggVZDke4RmxIU7x1pIZ2udProvuE+BUbhHGTsvM0PFooIaPnl9TTn70DqdJ+ZVKcs0Ih0MRPPH7EYtGUyCjFk6MlG1FLdr3UMWXsjrJbc5IKaWoBp+UOEi/sP8OlF1+C7YjMcqWsnhil8oCuSLse9knQA3598/mL8LUI4e+KrI81UnJxIlOK9me9cZf1XRolAP1APMKFVtcoy/8UhcyFeAvouTq3H0pwTZDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20)
 by MN0PR11MB6110.namprd11.prod.outlook.com (2603:10b6:208:3ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 02:14:58 +0000
Received: from SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939]) by SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 02:14:58 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
CC: "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>
Subject: RE: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Topic: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Index: AQHcdgAD4xdTWMSnLUSEH7bPw2ktk7VGKlmwgArevIA=
Date: Wed, 14 Jan 2026 02:14:58 +0000
Message-ID: <SA1PR11MB8476CABAA90DCF9B492B001AC98FA@SA1PR11MB8476.namprd11.prod.outlook.com>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
 <SA1PR11MB8476DC4555BAABB5734BE314C984A@SA1PR11MB8476.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB8476DC4555BAABB5734BE314C984A@SA1PR11MB8476.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB8476:EE_|MN0PR11MB6110:EE_
x-ms-office365-filtering-correlation-id: 095b2ecf-8231-424e-2ad8-08de5312b797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?kJGhbP5hcalSv/Zklr8jlHLDaHGyZc97HbLIvweCbgPKJX/lu4q9VUQd/oNz?=
 =?us-ascii?Q?Z2VmyrqsELnQr/YnyGzOoHMpdFJjSxUmg8mxqFFW06fkRYeZ1H16HrHAld5W?=
 =?us-ascii?Q?Cw+CBu0fmaP7yRoi8h722COneyNc555xVPYjC1TGfwQK6ZdsJWod5t93BOBP?=
 =?us-ascii?Q?Lt2YvG4lsfSz7Pu1rff24bHuZ7xZFTa5keWYcBGn/jUFtIYwKRRMsXKbAWz5?=
 =?us-ascii?Q?gwRSgcK8Hw5G9qiznHDejY1ZWoAQW1l52qTihAD5/cpp64lLdCqPhKdoddJm?=
 =?us-ascii?Q?kb8F7CliGUWDGPklPSUoqt9O1ptPEgR1zOP6CXoCGiLG9XKMtkQ67yNmvdkm?=
 =?us-ascii?Q?8Wuxoy3dvGHYSCwH4IsMFooNfUSQEoK5hIXwMvq+6iwB91QIrmjhgiLfYoTC?=
 =?us-ascii?Q?p6v3Cg1M3yl8RbS7OSim1oIrlX8bf0Ahs4n/EIpctlLyomC6lTSLbfNtf23w?=
 =?us-ascii?Q?XvG08rrQljj1K4D1dAhTCY3tUDu9AAiPZh9cdWPz88bKMBgPwVf2ze7kesIH?=
 =?us-ascii?Q?trlxTVVu+6jr6cxhcFm2nw6xwNRJ2MyRf2JH5QLFtR/ARuR2xgRbhYQUfRsD?=
 =?us-ascii?Q?hHNX/cjSzJsDWmJDP0pCH53GQt6yddEpHhc2v/EIIkYKFWopx/u8eOMFPbot?=
 =?us-ascii?Q?k2zaPs7RcHB1pnm8oTtshlHqtLM0wfciDubcf6Vzcx/FP1+nB+86G+Ti2IOu?=
 =?us-ascii?Q?cGAXhGa7rxR30jKHMNtYcc8r5yfi5v6WUMKZKZ1wOtEbJYm+3+BgpDH45NZU?=
 =?us-ascii?Q?Qc0SHprqIIouMYqJ2x8/5Pne+2xlFeJBYS6InT9lcRIDxBr5GafOjQRG06rX?=
 =?us-ascii?Q?V66abAdzLhkgst1EcwvLyxvjp4F7bjbA0KC2SZJjYimOAgbmEY1N+vAwbhgM?=
 =?us-ascii?Q?QRMslf3emfVAYyf0tP8wvRKD1fh6hyCqljXlQsvyEM8Bi3cyv/nnLCGmR01o?=
 =?us-ascii?Q?AIpMrCuRuMqC40r4D+ECFjDNw2c9CEbhyu32gPEOXURgTn74Qo9Fe7F2bWOu?=
 =?us-ascii?Q?M4d273SgNvnecx2KbvnrvKsYh15WRw3Xiv4KzIT1Ll3tzSqBYBc28rQ/bWgm?=
 =?us-ascii?Q?w/FtbVB35c2a49gZy3b8fL7P2K+ADejBnHRktboelXjmschMJnPXcNSvvVMh?=
 =?us-ascii?Q?5+d67CkxGit18XvdJwadKL+4geW0UypzS2Wwdcb0UgpZ/clLBo4mfJE1IWVb?=
 =?us-ascii?Q?Ge7G9Ps1+nhzS10NksW9wFUoSZIMtmUn8LRGyC4bE53rOqQvDUbSKULVr007?=
 =?us-ascii?Q?qsdxOHiCLDQ7rKyxtX70POjiiNCVA02NTdaFpJLQlUIm+LiIBnGms29LmkZN?=
 =?us-ascii?Q?9Jai6UqH8twqg7S9EJ1BpmIklV6TmtQvt904C4Z8iAcurElcQkIADiqFN/5c?=
 =?us-ascii?Q?/tywXnt67EEIlYxTYA9YsPsOEsoXn5bapjXz5GEgZsqGz3G8rI2NkwaWKA0q?=
 =?us-ascii?Q?xbqNp36FZFm9zDHAISF1vIAxYtU174g0wrviP3SXZ9Oykok8rLHg52bx8UC5?=
 =?us-ascii?Q?stsDU375XKigMiNC/+QaOgmtFpMPlcdalv+R?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8476.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fCQKwaYkVs2c687/fMOzcTfOLuYRocwgIpKUHOHRMPstLV0kbLu/tun1VA0w?=
 =?us-ascii?Q?Wqp7nYbNJHOOiK6Ow4VMwzeRlUCbDmJIpLi+TBtCG3iTaS613zbh8yQw/QAD?=
 =?us-ascii?Q?xSj2JU+Yflj7Le0kWk4AxjpnfAy2iEfu8BHy0sQNMyQoUpD2LORdfytPFkae?=
 =?us-ascii?Q?UGjtjZ5lv96fiUvdAOs9An4QZj/MUWVrBkFc1jOVeNMoEHVcBcfr0naj+HfX?=
 =?us-ascii?Q?wDDJ1BtSi777ZLzmzzqr2iLxC2LwiClX0MvXPH4Dw/lNYFqdzj9OiV21QN1l?=
 =?us-ascii?Q?GVQ45jd4YGaLSdSFNJJCKsgZXj/JBeqitdx2LRxRXWwvVmfG7xHPzhwfpWvU?=
 =?us-ascii?Q?LFSj2SXqn1Agvljf9glR7kt8n7zgewquC8kEzqiJYDKM2GI4AECW7JJ48kmP?=
 =?us-ascii?Q?XtWwaYWzqSLZjjxoAOS3sPuMUjaf3vxH5zkUmYWTLfYRZPH/gij7hOfc3vgj?=
 =?us-ascii?Q?N5l5H9BTxcdh1pQZDJL5qU6+1jW7UEtcFK1e41o0b5NT8M0cKWk1dYKfisqE?=
 =?us-ascii?Q?fi6uo3Ln9iOzwzi3/fYWM7WqqG3o2B2Z99gQx1dJ73gFCUBTkbASwprKdp+w?=
 =?us-ascii?Q?2YDq/OS7yogRM1PVLqZwDZZ7gnTChMp/sWJOzgFeCluht8SBv4VF8m5R9uIx?=
 =?us-ascii?Q?0qKwMBw6YZyQr3YcovoeG/+910dd2Jq/ZJn1FruNM4InrSW+jcS14XaUQge0?=
 =?us-ascii?Q?HdPlMLaWcwjTHBKHC14Gj4SCU6m/a0h+wOTzZN/N5B+JvSO2KMU5EO6pMG9l?=
 =?us-ascii?Q?S+gq8LgttOgFylFZ/WeEY/khyhgqm2GX7YMn8qwTFSfhgN+f1eNnm1vHPSpa?=
 =?us-ascii?Q?hX/a/pa+B3B8XU3rbF3H0190GbTuSSdKTvkH98ckwTNip0m5xhzfqRJandLO?=
 =?us-ascii?Q?PaLw3fZsjbela8F/0+z4boCBFlZt6RGDIqqcAbmxCHuEAyb56plsH/7ZFuaL?=
 =?us-ascii?Q?n9UHDprVXo5/9Xh9g5KSo90RC85G8vVk02JX5Cok4+OZINBp8d5wpCLXqskr?=
 =?us-ascii?Q?qjgJcMVshYIzct6tzByWvOtWbsqUs40w+58hkLOnhPDnJJu/07UwmHQDCfrR?=
 =?us-ascii?Q?KZ3xHsKzpZOqvkWQwazNJw93I+2qNgF6AQNnjhs3Dh45vg1JTs1PqaYAuAoL?=
 =?us-ascii?Q?k8ZOPdt8HuOiu9y29hzKFOxzFWTO8447qHWkDKuCh1Dfo4zhaP3M26k0rV4q?=
 =?us-ascii?Q?R4742MJ7BqSCf6ZEdsMjGJm/ihpuhU+algXK+J8L/is0MNpFaAiUyHH2qrH1?=
 =?us-ascii?Q?hFtXx/rtTCtlqufm0LWCUN2Iz5NWEDS3cexb9arWeeAAUJExmK5kY0SbXYz0?=
 =?us-ascii?Q?10tfEUl5ryzJnyKk5ih62vARVcdl4SRg/2MGP0z+vcwiiuMYbMGPGi0WyPe8?=
 =?us-ascii?Q?YOyvf0QsanoTrQ/YizhyKQ9ogAJ7CjezjKxeU5OJGhMIdih2gj/JiTPu5m1c?=
 =?us-ascii?Q?OgZjG6T/k/AKE5cUXpzt6r3KYWK7xGfX3a7vvq3lQmtteFYmEMhD4WleBEwL?=
 =?us-ascii?Q?DnxQelMhnnAi2y6gHsF2RU96fmqsQFf2TLVGbiouWWrs8CfcJ6tfzi1EvCsg?=
 =?us-ascii?Q?dIlzgiSPwxH4wfEEMHSwy5vxTlzd1r194oMJTFpamQdXjtLFHWOacl254b5k?=
 =?us-ascii?Q?WBqDlKX/gGUZT/7ZOxGbTmJmNyxa7hp5E7kelIuYaklTvDZNq9BcS6KXDTHd?=
 =?us-ascii?Q?BVSSOQRmho27p6E+Knm/7jkc/XqminJIfRv7SkYq1iVI3ioMA2d2Z+E5w64a?=
 =?us-ascii?Q?O6f7DX9LHw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 095b2ecf-8231-424e-2ad8-08de5312b797
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 02:14:58.7309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q0j5hjKy7C4xebQJzf2C7x20h2jmdAy+L4UmkkAB703xEl92A190ZoJe2g3sT7H0kfJuGH7/TXmuuqfJ/AGemB8U0NgI3gXkqvclRGZLsX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6110
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Tuesday, January 6, 2026 8:27 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>; Linux Crypto Mailing List
> <linux-crypto@vger.kernel.org>
> Cc: yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
>=20
>=20
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Thursday, December 25, 2025 4:38 PM
> > To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> > Cc: yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; Sridhar, Kanchana P
> > <kanchana.p.sridhar@intel.com>
> > Subject: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
> >
> > Add a trivial segmentation wrapper that only supports compression
> > with a segment count of exactly one.
> >
> > The reason is that the first user zswap will only allocate the
> > extra memory if the underlying algorithm supports segmentation,
> > and otherwise only one segment will be given at a time.
> >
> > Having this wrapper means that the same calling convention can
> > be used for all algorithms, regardless of segmentation support.
> >
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> >  crypto/acompress.c         | 25 ++++++++++++++++++++++---
> >  include/crypto/acompress.h |  1 +
> >  2 files changed, 23 insertions(+), 3 deletions(-)
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index be28cbfd22e3..d97a90a5ee46 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -170,8 +170,13 @@ static void acomp_save_req(struct acomp_req
> *req,
> > crypto_completion_t cplt)
> >
> >  	state->compl =3D req->base.complete;
> >  	state->data =3D req->base.data;
> > +	state->unit_size =3D req->unit_size;
> > +	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> > +					  CRYPTO_ACOMP_REQ_DST_VIRT);
> > +
> >  	req->base.complete =3D cplt;
> >  	req->base.data =3D state;
> > +	req->unit_size =3D 0;
> >  }
> >
> >  static void acomp_restore_req(struct acomp_req *req)
> > @@ -180,6 +185,7 @@ static void acomp_restore_req(struct acomp_req
> > *req)
> >
> >  	req->base.complete =3D state->compl;
> >  	req->base.data =3D state->data;
> > +	req->unit_size =3D state->unit_size;
> >  }
> >
> >  static void acomp_reqchain_virt(struct acomp_req *req)
> > @@ -198,9 +204,6 @@ static void acomp_virt_to_sg(struct acomp_req
> *req)
> >  {
> >  	struct acomp_req_chain *state =3D &req->chain;
> >
> > -	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> > -					  CRYPTO_ACOMP_REQ_DST_VIRT);
> > -
> >  	if (acomp_request_src_isvirt(req)) {
> >  		unsigned int slen =3D req->slen;
> >  		const u8 *svirt =3D req->svirt;
> > @@ -248,6 +251,10 @@ static int acomp_reqchain_finish(struct
> acomp_req
> > *req, int err)
> >  {
> >  	acomp_reqchain_virt(req);
> >  	acomp_restore_req(req);
> > +
> > +	if (req->unit_size)
> > +		req->dst->length =3D err ?: req->dlen;
> > +
> >  	return err;
> >  }
> >
> > @@ -272,6 +279,9 @@ static int acomp_do_req_chain(struct acomp_req
> > *req, bool comp)
> >  {
> >  	int err;
> >
> > +	if (req->unit_size && req->slen > req->unit_size)
> > +		return -ENOSYS;
> > +
> >  	acomp_save_req(req, acomp_reqchain_done);
> >
> >  	err =3D acomp_do_one_req(req, comp);
> > @@ -287,6 +297,13 @@ int crypto_acomp_compress(struct acomp_req
> > *req)
> >
> >  	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
> >  		return -EAGAIN;
> > +	if (req->unit_size) {
> > +		if (!acomp_request_issg(req))
> > +			return -EINVAL;
> > +		if (crypto_acomp_req_seg(tfm))
> > +			return crypto_acomp_reqtfm(req)->compress(req);
> > +		return acomp_do_req_chain(req, true);
> > +	}
>=20
> Happy New Year to everyone!
>=20
> Hi Herbert,
>=20
> Thanks for the segmentation patches. I have integrated the changes with
> my latest v14 patch-set I have been working on that incorporates the
> rest of the comments. I had to re-organize the structure of
> crypto_acomp_compress() to make sure that performance does not
> regress as a result of the 3 additional conditionals introduced. I also h=
ad
> to inline acomp_do_req_chain() to not regress usemem/zstd performance
> with PMD folios due to the added computes.
>=20
> >  	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> >  		return crypto_acomp_reqtfm(req)->compress(req);
> >  	return acomp_do_req_chain(req, true);
> > @@ -299,6 +316,8 @@ int crypto_acomp_decompress(struct acomp_req
> > *req)
> >
> >  	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
> >  		return -EAGAIN;
> > +	if (req->unit_size)
> > +		return -ENOSYS;
>=20
> In order to be able to use the same zswap per-CPU acomp_req for
> compressions
> and decompressions, I kept crypto_acomp_decompress() unchanged and to
> not flag an error "if (req->unit_size)" for now. Besides, the added condi=
tional
> impacts performance for the workloads that I have been using (usemem,
> kernel_compilation)
>=20
> I wanted to share these updates and get your thoughts. If the above propo=
sed
> changes from my integration sound Ok, can you please let me know if I can
> include your patches in v14, or if you would prefer the segmentation patc=
h-set
> is accepted that I can then rebase to?

Hi Herbert,

Just wanted to follow up and get your suggestions on whether I should go
ahead with incorporating the segmentation API patches into v14 of my zswap
compression batching patch series, with the changes I had to make, as descr=
ibed
earlier? I would appreciate your letting me know.

Thanks,
Kanchana

>=20
> Thanks,
> Kanchana
>=20
> >  	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> >  		return crypto_acomp_reqtfm(req)->decompress(req);
> >  	return acomp_do_req_chain(req, false);
> > diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> > index 0f1334168f1b..965eab7738ba 100644
> > --- a/include/crypto/acompress.h
> > +++ b/include/crypto/acompress.h
> > @@ -67,6 +67,7 @@ struct acomp_req_chain {
> >  		struct folio *dfolio;
> >  	};
> >  	u32 flags;
> > +	u32 unit_size;
> >  };
> >
> >  /**
> > --
> > 2.47.3

