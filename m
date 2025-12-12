Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B941CDFCA;
	Fri, 12 Dec 2025 01:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765504739; cv=fail; b=HOct0GUErGDRWY6MqlHo1QPqgO378V2Uw9arlBFz27dMWCI1sR++MyKnN4FM6KYQaP6i24VZqDZVggTo4SNrwBpk7VCdeCjArI/qTp7wQgPMDbnxub21/vgCSQDMMJBj782OPCfHibvO7AVrFQ6d0SnUOcR7UQ7QlKKWyrkpzbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765504739; c=relaxed/simple;
	bh=3hw55Mm1ohywA7rSBr/S9j2ljhpG1RHNkbCnHN+6Uc8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lI2Smk0zeZZam3UGPBwELgYWKQswwFD43nURiUCn33Htx+dX4jEp2GQ1zmRZgktuZGxeSAKp7TAlqo4CJI1l8h4ggouV0haMcFnSyEwDC17LXKMhHkOlyoB6+dESm+BP0j556ujcLsJnmeP0TPuVYLG420hkG8dZ9uK6+vX9Dys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNA/OflZ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNA/OflZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765504735; x=1797040735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3hw55Mm1ohywA7rSBr/S9j2ljhpG1RHNkbCnHN+6Uc8=;
  b=kNA/OflZTrsEDnsmWbK+Jtb2LSyUSca+WWkX9oUKBSRD18jkXiRj0Ows
   SDv4s2FUGl3z0cb5BtNs2F6NUrthl9XNMpDxGV/zFN3tinagz9WsAwaT6
   Myui5AwUKuFWOJZGCjzgfhmNaBHMJpAYnGyAg3nEpq8IR5MTxGyNfWO8M
   ybcusbcSmh2svVlWwt7Cdy57i9+eleyT+D1BFAwEmmTCgjzTImI4Tl27m
   mRkXodbPxtY5c0oazsqCB74xBsrCRV9PDOkO4VTgER9eOIOpgturjFHiw
   qkJw615wOrMBYBmsGChDkRnCOxVj66pAwzdHrz4J0OD5JszQdFIHLw56f
   Q==;
X-CSE-ConnectionGUID: E3QJrmqkTJK5B/Wete4lQw==
X-CSE-MsgGUID: +e2e6YiFQD2flaeBmyhH5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="84903903"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="84903903"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:58:54 -0800
X-CSE-ConnectionGUID: PWefHH5FS/ukwLv3sLwKOg==
X-CSE-MsgGUID: exUD2YWtQAi2Qrb3VXZvPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="228013896"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:58:55 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:58:55 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 17:58:55 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.28) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:58:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVPOgS9Bun404VdWpcCKR4N0uBlBwEM46pP6UwplSgpXZa45ufMlvhLP57CCfvIF6kzn8TccuONBUozKT3m7CzgwMMMLgL5tQuG6j2yfzKmihAhMoksJGAKQ+3Hsup0qeSxj+Q0BW0zxnNM4vKh97ua02lib0ytRwuye1n2TCmO6JiCRUaeLPQI0DCXDbdM8FXUbhvav9+ompNuXuHXtidlK1EK8NC43R/gSYK92WpWfGFhxgPYpMHJ0GsZGkCANFU31EbIj6eceRSwmostjExbSNgDUwfSbeaxS7EfAhmAKj8+ywT0ylND5sEfEfojuOuMhCemYb1sB0hfN9i59tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fS9kW1qCaFEalOohPD7CYa3dP97NCvI2OaGl9ZJQpKY=;
 b=O0KXvU/LJXFviNv2zLe9wP7MEd1AjfaqyR6SQWROfsZBQhOJvNJFPCpUX9lBzJr9mkehzGIogvpN9NRUDYy+UCHUohgEGsiv9mC3CixjPWN8S7KkY4OQvALQe3U33Y6WRGPeQ8Ca3QZKWObqEUe0ccJWgmh7x9tdbLoe4uci1V7m2dlLtOvG0d30M2hPxz+qyM8+0xt7JxBMAFNbieknV6V3ECfPHpBHPgviQgSGvOH5T1VmXqzeeTzJ7/THMikgTdBbC3I7WmUZHU12KODZ70Qxs4wsvvttrTictsR/AXmNpKNcjKrL1q/guBFgFgXN3eiyGjqpj40YSKWhj3YmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS7PR11MB8806.namprd11.prod.outlook.com (2603:10b6:8:253::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 01:58:52 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 01:58:52 +0000
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
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgCxKvnCAAAU8gIAADIng
Date: Fri, 12 Dec 2025 01:58:52 +0000
Message-ID: <SJ2PR11MB847266BEA195A20A095AFA73C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
In-Reply-To: <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS7PR11MB8806:EE_
x-ms-office365-filtering-correlation-id: c812b036-cec6-40f2-2ab4-08de3921ffe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?81sMNIFDprL0ua3rliDOoZdtM0wj6qMzCZQIDydtBMUz1Yd1oe3jaeWUeNLY?=
 =?us-ascii?Q?A1TQ3aW7g76nx0Sj8lLdlX1L7C0HPAvlOMiiYuKrlmizDve5Uop9RO+4akEO?=
 =?us-ascii?Q?xHAJe6GDjuHpQBn84xxDUBabgOM9z01e9tbMV2GjZrgKB9iG5vc69OyJCnNd?=
 =?us-ascii?Q?otHSIVmSXRNfceS/V2wOdRodLsRJx7ZoFRayl6YpKqm8GxZ+1dk8o0WQGnXH?=
 =?us-ascii?Q?bakZhyrzixLYY4FIfNGs8W7mhpnyWfx5Zkq2rsxF2icF8klwWMX5yc9Yudv2?=
 =?us-ascii?Q?U44aUxckZiOvk2wGd/FzeBI21IJWj+6jUw93b2wOH6OCSdqvkmqHD3sMJTfz?=
 =?us-ascii?Q?/ecG8J8CqU8oQYTtFMqc641iEQYvoJ5f87MP3FcRVsLqnbXDb64+PLWRZ/mN?=
 =?us-ascii?Q?17n+b/ZD9m5sljpgJOVYgMGCOrgPbuhwBYnjTvugZPCgsu4+WnUD1xnYGh1E?=
 =?us-ascii?Q?3i6ve5hoGjotSKYbJI3Ao+bQE7wO37JxCe+RMFhPQWc+c6PqF5/MFgIffZAk?=
 =?us-ascii?Q?1mgEV9VIDOHX8GI7srHeqhD/ekgQbPfXOkttkJrEXTMqiUesF3CWa6F7Vaw/?=
 =?us-ascii?Q?B+hDau4EhN8Wx2kE/70UR+wwHBbvq+Lar02YvscyBWPZHO+Nykzk0U0wNxgL?=
 =?us-ascii?Q?7V2uO9oF3fI7nk5ivxNzxHgRxnJy4D4rzFtKqM8w85Hwh12ZNLIfQr4VvLMK?=
 =?us-ascii?Q?pv5w9zEhukGvxOT0bPRp3bhK6omVwEJ0IunBcawaH/bVDbeFAbJDfCtiSP77?=
 =?us-ascii?Q?JrscR3woe3wP7OODN1S7G37cjspk4nnX8XLtgTyZGkInR9NgbHk+YJmZR07z?=
 =?us-ascii?Q?lC01VWArr5lX5v+nSaLkSa9UK/ZaAWa0mdDTP9VdpafgqLc/P0ynpbJ9DBjg?=
 =?us-ascii?Q?slrX1eA/npRY5M2dRWpnAfu62bf/PLqPKHcdVWlwZuVVXpAt7mEYOefUruX7?=
 =?us-ascii?Q?N/aERAlgairWnA0/kgA94t2l3OHktuKR/50TTIrhfqiWmsPysogp63Ur++iE?=
 =?us-ascii?Q?YRIZ/MUWxnbdYuJmvw15PbfVIpq53nMgxdWUKf29qa8HTt19I3nuk2zlGdFp?=
 =?us-ascii?Q?97YarA+V9xgCU4MlF80XzWU/0DMWTtNp7EUHmH2KfT1RjufXS/X0C2L89eeM?=
 =?us-ascii?Q?na23Sj+9NUufDUdP6NBRBoCll6FEkwy37ajH8fUu+NLBZgggELdqH0PjMGoy?=
 =?us-ascii?Q?sz0FzhdTql5oB7CPbCVdYsb/EgMQC6NkxcJgH0V2N8b0RLM7cxbKc9C/qr32?=
 =?us-ascii?Q?IMwZYMaEMGPgXEbehKNak4FXFw/BTVxvw2Ja265EGpEeM/gOAKxsVKpEHCK3?=
 =?us-ascii?Q?Gly+gm4NFIfZrP76JRg6QbNgC3oSIa2QLWf36IhNmFun8dG8SpM8iomQGGkO?=
 =?us-ascii?Q?7fSi4aXX08m2x66ut2DUFExVp5v5DOYh0TWxxF/qShJPcreg+Tkmlwi4RE4Y?=
 =?us-ascii?Q?ghTTxuY2wQ+POyQiIhdYX8jw/Tng8ylmR4DdTijM8Nn1H3LJDO1E/QTabqWF?=
 =?us-ascii?Q?Slu/oU0QiFQG6fkauRzDfSgXGYKoWOq0Gnmi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?494B08lc4CdTCvXmyiCZdUV4oDbvJnMmwkLLevx9tbfwYb48xk8vUGn7Bp6Z?=
 =?us-ascii?Q?koxxUXanHtyVMVEfcRQ/OZL0QgBQJnQLbb7yfEJZVoMYgtrEVR2oU2QsbQes?=
 =?us-ascii?Q?X/TjK7qDuC4Ozvecbnvr5e2IL840p2VtQ7UBiFZYCLWHgnv6KpWyzQFX5mU2?=
 =?us-ascii?Q?XRfLZMIvhYoJH8PqeKc9ND54N1ryqfK840Oo0l120VSNak8PiL11OJG4iAES?=
 =?us-ascii?Q?llJlvJexS6YDutt2WHBpLamzHapEVVVFHo1MSP9v16xCJgzXbgYYFicOb2bj?=
 =?us-ascii?Q?9Mc5m8r8nuWECvW3c2oJIRePq56ZHKioxZmp5lSFRUeIbO2i3D7J8RNP7sQU?=
 =?us-ascii?Q?b9jA9s4Il9QvPucUM/oE5vhUJfR/ZBGLfLzUI+tzV01PBE4ZkURMgFPnuF7u?=
 =?us-ascii?Q?qQXUTKaZlnrCciXWgUlE6ZcR58RHNwdosG/am1PCADdmDhJEydjLlMM5Ncig?=
 =?us-ascii?Q?SB92dmFddJ+dMMD9/e7arV0gk3eLpdcpuAciP+lKeUViOqLicZbc5uSuTNfu?=
 =?us-ascii?Q?Bz5Ik2m4JCjgTvLbzJ9EJLZBM6A7DDv3ep5l4Ix1sd/z/YD5ajdYSZZqhp02?=
 =?us-ascii?Q?OopDuhHTGX6ysWEMIl0MlKUfKRgZA9PWaN/C6Prb/hMKZe26KTC7U6+Xs1sO?=
 =?us-ascii?Q?yPdM2lsq5hI5qQZJF1p5hRkObLdJvPWjW54+Nipx/fXdWwJEtPZjiBnEe7I3?=
 =?us-ascii?Q?mlOh8U9mhdYU1Bf9tshFJHxbPQQBXvtrrqUGGar/ZICp4SS+p9PvTQJZfg2A?=
 =?us-ascii?Q?TM7HdsdzRBPUwILzkMnwtDlOPf1Wa33GvsNoizzz80cqwqCCCs3Xa80vV9Mf?=
 =?us-ascii?Q?ZaiI1epjxxdCSqN6Dxza5lvB+JDmDyRfBbtD/Kqendgvx8OKuXhUUB+OrcAU?=
 =?us-ascii?Q?jyVnZ7xBSQW/WWfHLWgaPrSzz6A2/yGkTwD+7+UQSgBOYdE7K84GAf/DFAQ3?=
 =?us-ascii?Q?r8zW3iY9hSZGHZrXn9VmCLR0kf7X+qeg13W1sNI6G8aws0Gn8kvIrjD1hi92?=
 =?us-ascii?Q?1XicJLvOyGNpWDeZWNa0Tv+ZX/wZLOQS42V010Muy0nvPY+j1vJNwt6YODhN?=
 =?us-ascii?Q?h8duJWGQjb3PgbRw8Ep7qrlTj4AMNsPGk8U+ZzVODITXdJRjtc6S/OePOja1?=
 =?us-ascii?Q?aK6EX6TF5myisF/55RmoVL5RpW2myzJI8tJi0ND3hsWnrfAcWL+kn8DHNECW?=
 =?us-ascii?Q?dRvCG6eRGrhgmRixYnVugaDICd8FNokBxfJ9atJx77aE+yiBdQFvZD6k8EPd?=
 =?us-ascii?Q?egKVT/mQwnYKDLZGuH03teYLn1AGR0bB60YYOPG7fNeMUf45yfAWIro4uzBK?=
 =?us-ascii?Q?8tp0syo/IvV1c+UQ/sdFZ90SQE4O3+oIhpNhbLtUyB7H856nnwzB7jbAaGTg?=
 =?us-ascii?Q?4T49nmHTIxnNMJAYcjgrW6PsK1EBTWGPn/+pP57Th15azRSmnD6reew6jxIK?=
 =?us-ascii?Q?SPZYWxYVg1P/5MYr61yumMJzAZJGs0BDs8EQW3b4j0u07/ypvt2o3ShY2vTv?=
 =?us-ascii?Q?hQj6o6H/bVVi5j3cIq9pr+AB4hpTMaiNLs9xHl5bG2U9Hq0uEJm/WnIsfOGp?=
 =?us-ascii?Q?ec94W7absWaFRY9In7JTuf6g1RmhPnBNpx6zzYnCIxXKvKTaSbPMciTI/lzE?=
 =?us-ascii?Q?tJiOdO0tsf3Loiyr22bfPcaNT+hTvna9GV5V4GbuIV+rRb1r0XMHcVGKywbA?=
 =?us-ascii?Q?oVGerg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c812b036-cec6-40f2-2ab4-08de3921ffe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 01:58:52.2420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dg538vsfgjc7E8njzBIy+Yibn0Lvcgl1wDU8ZLU/RIqfIb4CJfdOrJ9kixwf/dyp+08RHso6oBQka70O80rkTKK1ttDZDzR6EIbvQYusTX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8806
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, December 11, 2025 5:06 PM
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
> Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Fri, Dec 12, 2025 at 12:55:10AM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, November 13, 2025 12:24 PM
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
> > > Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx
> resources
> > > exist from pool creation to deletion.
> > >
> > > On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
> > >
> > > The subject can be shortened to:
> > >
> > > "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
> > >
> > > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be f=
rom
> > > > pool creation to pool deletion. These resources will persist throug=
h CPU
> > > > hotplug operations instead of being destroyed/recreated. The
> > > > zswap_cpu_comp_dead() teardown callback has been deleted from the
> call
> > > > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> > > result, CPU
> > > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > > resources are concerned.
> > >
> > > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CP=
U
> > > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > > complicates the lifetime management to save memory while a CPU is
> > > offlined, which is not very common.
> > >
> > > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > > pool creation (or CPU hotplug for CPUs onlined later), and keeping th=
em
> > > allocated until the pool is destroyed.
> > >
> > > >
> > > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > > new function acomp_ctx_dealloc() that is called to clean up acomp_c=
tx
> > > > resources from:
> > > >
> > > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > > 2) zswap_pool_create() when an error is encountered, and
> > > > 3) from zswap_pool_destroy().
> > >
> > >
> > > Refactor cleanup code from zswap_cpu_comp_dead() into
> > > acomp_ctx_dealloc() to be used elsewhere.
> > >
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
> > > >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
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
> > > >     subsequent CPU hotplug online-offline-online:
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
> > > >     The call to cpuhp_state_remove_instance() cannot race with
> > > >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> > > >
> > > > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> > > > Instead, zswap_[de]compress() directly call
> > > > mutex_[un]lock(&acomp_ctx->mutex).
> > >
> > > I am not sure why all of this is needed. We should just describe why
> > > it's safe to drop holding the mutex while initializing per-CPU
> > > acomp_ctx:
> > >
> > > It is no longer possible for CPU hotplug to race against allocation o=
r
> > > usage of per-CPU acomp_ctx, as they are only allocated once before th=
e
> > > pool can be used, and remain allocated as long as the pool is used.
> > > Hence, stop holding the lock during acomp_ctx initialization, and dro=
p
> > > acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().
> >
> > Hi Yosry,
> >
> > Thanks for these comments. IIRC, there was quite a bit of technical
> > discussion analyzing various what-ifs, that we were able to answer
> > adequately. The above is a nice summary of the outcome, however,
> > I think it would help the next time this topic is re-visited to have a =
log
> > of the "why" and how races/UAF scenarios are being considered and
> > addressed by the solution. Does this sound Ok?
>=20
> How about using the summarized version in the commit log and linking to
> the thread with the discussion?

Seems like capturing just enough detail of the threads involving the
discussions, in this commit log would be valuable. As against reading long
email threads with indentations, as the sole resource to provide context?


