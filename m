Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159541D9A49;
	Tue, 18 Mar 2025 21:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742332193; cv=fail; b=hjJNKtlyFgey0b3iNW8KghhOebXEIqXfEozzvL7Y0gamBVALI2IC9dBwPiZsgbBK3Ueqvka1lDI+f1fJ6JdG/nAUh3CRpW3jQhTRXBEudlRVZHKTbacLwe62oYjaaBwvLjSLbkxAFTcl3hb1Ez4ZG0CRLKPuj8MZ3asKVk+oxYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742332193; c=relaxed/simple;
	bh=BGEIt+sxtJTHcyAkUJM2MAaILEP+GhqXEnx0Ykvvb0U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IPqfSNGzv/ZobrhpssLxPOKhuVOMcHWU+10cjg7mgZi/gw0qv+319f/czOZ4pdvlONJubi4CWoOH3jngg5bAED/YzjGKzdVHzl9cDQXSUb+Wfo9P4KArX+7/31Ub9pGSYKpTA4CBpfY5lyeCLfqTEoSFLKVHCiI8jqhjr9mgJ/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcpubW08; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcpubW08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742332191; x=1773868191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BGEIt+sxtJTHcyAkUJM2MAaILEP+GhqXEnx0Ykvvb0U=;
  b=kcpubW08ZQ58mYB6rQgzF2WD/nc2QqJGbeuBaT3ar7QoxrJX4wP20Vw/
   SYvWIVIfhzLfyGkGKjV/dF3mhz0WokiTCHM8KyK6iuJdvx2HSAfNfnsh+
   iPnATRRe90KBs74mIw3Iig4sXSPnvzfovFNBV2/TWSt9OmS5MiXtpurd8
   aglGvDYoJ1whKS3sckjzcqv2GCoA+JdhS+qGHLe92KLBS/baDHYKCwTvN
   9e6oaSoPHOsYWaaxVKjVyjUB1OIdKSqsPSBcfID7E59oWzkSvtTU231Bu
   r3wNp9gfkLLdWltBmFhBhsGW+rZxcr7iDdSxeLngH6jCLqLtTMU59LoEs
   g==;
X-CSE-ConnectionGUID: wcikXcgsQWytvd4fS25xRQ==
X-CSE-MsgGUID: 9EcQIJHJQY2ptYW0+DZKGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="54879955"
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="54879955"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 14:09:50 -0700
X-CSE-ConnectionGUID: 0pDWRxlHQ9mUprfdBTMCyw==
X-CSE-MsgGUID: nZE7LzykRxOYOR2lDqGINw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="122851867"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2025 14:09:51 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Mar 2025 14:09:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Mar 2025 14:09:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 14:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozovcj12GyIFbT8Y9wDFAhCP0UFb/If7bcBPGMCMkx+GaHzKHPkWhshj9dY8YAQSOobwwJTl+1UhNKCM9vl+GndqbYtS129uj7m0c1C3NB5BZpLBXSnM+1kMI5iF7roNAxlNatKKiDWi1Eqiw122iwKMCUE61JJfZEOp40ywCVEWtkpW9HhnGs3/ewZQkAgkVGw4d7KmD6fFOX5KlKeuPKjsOy/vlhs92UrX3EAZh3l63rTPfhSkgHb9R5vKwhX3yvgq5oGD9jKp4mxUcPnSK4d/d5KheRiwj60lZgN8uHHoZslqTbyYB0XblVHHOyGuZhwwRJu7GKwc5L1sICBssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYkMJs7lJvaItuq9Q7e32WJc4e/ws2RSpi2SeHLEIFY=;
 b=qe/QObpJHrcKsjOdU2EELVv3e0BLS0tLB9fRxUPN9FX+4PtU7HMrpcizM5GWe4XLSgiFEXbQW6yjHpAAfPBwg0ezjbVCm6ADh5boN7MMnTb+r8KKrW9R9HqXUC33M4JM2PHXNuqWz+1qbRQsqT3G78pWIMCKTTW1SZzcRgmSxwvwseCartSkVf3ESSv5R3heVZ+VtBlv2hMYwmr0jH9iQV2lF8pS/sn1N7F4aWqjOK7p4rrYC0tQ8GuWWtbp5vnyyaw1sD6o7W+XDLn6psQ8L71rUQGGQPz692z2Muewque8e5trs8P9x4/ucOZ6U8uzYjkiDrswD1J+REisEwQRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by IA1PR11MB8100.namprd11.prod.outlook.com (2603:10b6:208:445::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 21:09:05 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 21:09:05 +0000
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
Subject: RE: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Topic: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hCAAVPdAIAAYjdggAQziACACyMtkIABOxcAgAAmLoCAACiqAIAAHucg
Date: Tue, 18 Mar 2025 21:09:05 +0000
Message-ID: <SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com>
 <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9nECMZW67F8XYoV@google.com>
In-Reply-To: <Z9nECMZW67F8XYoV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|IA1PR11MB8100:EE_
x-ms-office365-filtering-correlation-id: f21a43f4-9ec0-4030-4aa2-08dd66611e08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?vHP3U3wwxufNtvvEyY+RbbxfG5fND1XHA4C/8kfim1uvFFGY/ZYwuOO2PmRV?=
 =?us-ascii?Q?7w/7LtCwVArE2lltB79RH5RcQt8ZxSKegMNDMSYkmzSFbvgnrY7W0vL1P5eh?=
 =?us-ascii?Q?X0A7AnpqSbyqmQC1LFAi8vk7LkkQIAp0mfM+WW91fMh3if0vdku2tWJpNQV8?=
 =?us-ascii?Q?m25ACqB3f4mxDztC2Ak6tc951MA+pBXWu31WaKbODGmvTI7c6KyoMB7ktNNE?=
 =?us-ascii?Q?l5QCcjBkHTkqsQ7hNPhlXUTb/EOzjxLKxwpBR1ojK/4TPB67RZQ0gx/TI+Jk?=
 =?us-ascii?Q?evlB/0wI4nRg/QAnYPHOrQYtzDdOOcU4mElXKR1LF70ZaLjauNao97fI7abL?=
 =?us-ascii?Q?wcv3KunWuCzhjCZgmu6UaPT39OP480qwreJE1zFQfoCsmTBdSDKeSG1YqMD+?=
 =?us-ascii?Q?WVaD2S3s97W2CLwg7w9ZpMJvOOd9S06w6Av7Dp94Jw+CEORyMHNEdoYEX0he?=
 =?us-ascii?Q?/QeNCQQxCmd2uDYO/prOoUF6tq8K0ZLu0qPO8YGocBmJuNjeXSrX64J7q9a+?=
 =?us-ascii?Q?tZA8UNCfA5R7/XWSCEiR1tByPjj8E/U/Fhfz2PWUhyKeVWNs8mga1gwpBZiQ?=
 =?us-ascii?Q?RvH2wi+zHHIPX8+ZfV7WCCCVHlg/EAHBsBKBLnp+g/m+WVhe55L2jr0LuKEq?=
 =?us-ascii?Q?hoNH2uhtGUupceJs46Y69rl8CzQ2h1cW+eHAMEjUrHWmg5nnajrhRHKZdJK1?=
 =?us-ascii?Q?markE2PMlye2JmURoE1slbrwOczVlYMe9EdqYiSs1Tf7v+Vo5pGuMM7LlOK3?=
 =?us-ascii?Q?cNqtaLBlpHgDzDU8qpclUQF/XNpyMnIOCFOFRmF8OZ5nv2RyPiabUgXHier/?=
 =?us-ascii?Q?5tRQK+3Z4p4w5i6u7pvbHTfNl0p/zC9CTyFJn0Sx9SuI/CnLzJYqviEeLsmv?=
 =?us-ascii?Q?lbrbuiUDozS7eX6ekhOO72s3j+b6VvrAI47PcSbCEgmZyip1/yPUk67fFalB?=
 =?us-ascii?Q?snmbOVbVtIZWk6J1c2XOmeGnVBgtenYTq/gxuiJh0U0zulJP2vf7Az/avKnB?=
 =?us-ascii?Q?s8QaieU6H0UQGdQL3aZSC/9RG3cEvBNbUhoxyF+46DnL+ZmatD/GaZK11tNT?=
 =?us-ascii?Q?aN5BA2nRK9AGL+R+XBEtxlqg59mC8Q211at3bfRmvyFgT+75AC5vL8wujfG9?=
 =?us-ascii?Q?H4r/BHh4lOGJH8lwXENVt6PLdVXPkeCvoY+a/Pz3wayFyQjhnq3VcxrUfyNa?=
 =?us-ascii?Q?hLLM9ZvRmzDxvXRnvHV3CydSgFHXYcZzrTO56hnVpVODPQH53AjDXiOs3OcQ?=
 =?us-ascii?Q?hiL0nxpxQ30QQR8+BZN8LRLxMhuNj8R0amZ3ALx4119QRxLpvM3/L2G9lW7O?=
 =?us-ascii?Q?Os9a5I4vChT0Tc6XtC99YGV/0kK0QMkH/7IjMQsXXCKAYHzH8nZZls/TNo+k?=
 =?us-ascii?Q?QWkItTzRogSN3BiOAdEmBmNh5UDcoRpVXw6G2k5splXS7f/7hMe6uePtlrBh?=
 =?us-ascii?Q?7d6I/fQoyUVEx2+vRGeyZniGLVvEKkVG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XH/sbnTeGss0T+SI+1e82g9iQ+Sj3zJRN6hGDBp92Xh8zd7UqIInjKB9Jvz/?=
 =?us-ascii?Q?FnUUfycBx92y69E/ua28OiPSqwXGCIPbYc469Ttzh6m5Zr0i3SKLaJN+jgtM?=
 =?us-ascii?Q?MjXNvHLAcgfOsCD55EM8iJT8zGkyT0FM4YdLbnUlcWoA7BHNhpvQcMC7ptzi?=
 =?us-ascii?Q?iXwjWnFXVH677LxoEMewaYNH8BfaoLPXao1UDZJbzfkevbL+3mP9Ha0Uvhht?=
 =?us-ascii?Q?bkTeXVmY8kd01jnChvItGkx0mF8D/j4ef+YsEcgN41bGEzBJzM6BP15jXaWw?=
 =?us-ascii?Q?F8cN6y+MIi15Jo4/Bo+BykiKGhfDEVITlEnb7yl6IQcV3MJ8JPjws5hG1ZMq?=
 =?us-ascii?Q?H87bjxZFi4Y3OE+dUKCCFtQpNGdGE6yd06q44Z4eFfiNFy4sOhJwG1RqA6EZ?=
 =?us-ascii?Q?wMKUP5IKzVXzCZvPY2eBA1o/QzvwCO9SLKJ9YRUsaxv6IO7SXJZ4O3G+X2/F?=
 =?us-ascii?Q?qahxYvo7FpCezz9ZesV7vLocyPR01HXk3nDIgXvrzvHaqyBOTdpLZeFw9RrA?=
 =?us-ascii?Q?EjUb5PmZEnJ5tWP6fveVnx/GHx/56GdLbTypijE/P9eF8UhzUmNkzMuy41LI?=
 =?us-ascii?Q?WyjvUNrKok+4in00MIUgabj7JDfC1iC7kL537RzqZMrM9Ic3kvlXJSfNAGid?=
 =?us-ascii?Q?+paytrLgyhnbSXrm1QBVIxc99IMVOX/8Vxelxi2BJMG9nGAbXzRdQohqw5ZD?=
 =?us-ascii?Q?Veda+i58Z4WacSWmNOECT68asEKnkuxOMqgo6CEoqMSKAwZuX5gIhB9VIA+6?=
 =?us-ascii?Q?xtSFSsriVyNTYbUnrQnT9CE/XPUSw5vluJQoGYqUYU1FBGm/MjRIx6/6vGSI?=
 =?us-ascii?Q?TJiybK/FeQ+0bhrjIVcOH4scYU67lu3X7+0AN/fgxJaZ6o6dFu0QwymzXpt7?=
 =?us-ascii?Q?LMHSzbXbN3Oyzu87Cck9WdUWXw1Rk9uiPL8iZtIqG+A1AfQ6Wby0sFYD2fpy?=
 =?us-ascii?Q?gumGQhSXCMgXPlvcn4H26lWs4RsCIn/Ns9hmUMn7Mm4m7RcQd9KPuI9AhjnI?=
 =?us-ascii?Q?G5PlvsSJ8U9SY1BGrAFtNrcQXkXpLyOv1IgUEege60PTPZxw4dw/I2XMvvhy?=
 =?us-ascii?Q?3o+ZRrY0g+QNMbZ91Uc4/RIgxAkqYAn661z5iy+gyTb21JwMnH2JvPROPw9B?=
 =?us-ascii?Q?2Sq6kkPuCcx4v7zC5j50Gw58Icpzd31VRhWNmobZG/KGe5riFOFIimkCrPtm?=
 =?us-ascii?Q?jsHETb3HIWQLdVSoAg/ZA+E0dUYFgCEIwmcN2X0zzW0+DHy//3T8VX/wN1Xv?=
 =?us-ascii?Q?SwHAcZ6lr72BgoQxtmOFjRA7/CUrW3jcY9Ux8FDRkZiVfo0rJy0Lok/i5MUG?=
 =?us-ascii?Q?KzZpCRHq7G0t1cRKm8TeF3wk690Vx05BKNOgpTI4qrMGb6VW8C5Ywdq/Ttd+?=
 =?us-ascii?Q?vsxu0My2oV7V5DuiPWdl8zSxwLKBp+joIMK7dAf8rkH7FaVEWoACgnoLUBK9?=
 =?us-ascii?Q?m2A178nULPNixtvy2iU3HrG3WxOcRaOOnVIpKCqiZ0B54PEsfBcZBzdj/r52?=
 =?us-ascii?Q?5HwkQ3okgDnp9TvSM7BbMk//0HVHCK6bnjoTUge6YjVhD1hd0Uut0F83IAhu?=
 =?us-ascii?Q?eXqsPFe52B1eK2N76f5uLnjLRsm0lNddZhNKLgwBlpIiaktVmU7dM0eo2YVQ?=
 =?us-ascii?Q?8w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f21a43f4-9ec0-4030-4aa2-08dd66611e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 21:09:05.8056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmZQ5CPrY/dMkRV4ne47SjAou3WfAmtSKkS/4LX4uswbtjB1jDJQSflckfloacRnJ5ajc97eAD6B9DYBVw/Gt9YR93NCvGj0XycKSQSCBy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8100
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, March 18, 2025 12:06 PM
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
> Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> allocation/deletion and mutex lock usage.
>=20
> On Tue, Mar 18, 2025 at 05:38:49PM +0000, Sridhar, Kanchana P wrote:
> [..]
> > > > Thanks Yosry, for this observation! You are right, when considered =
purely
> > > > from a CPU hotplug perspective, zswap_cpu_comp_prepare() and
> > > > zswap_cpu_comp_dead() in fact run on a control CPU, because the sta=
te
> is
> > > > registered in the PREPARE section of "enum cpuhp_state" in
> cpuhotplug.h.
> > > >
> > > > The problem however is that, in the current architecture, CPU onlin=
ing/
> > > > zswap_pool creation, and CPU offlining/zswap_pool deletion have the
> > > > same semantics as far as these resources are concerned. Hence,
> although
> > > > zswap_cpu_comp_prepare() is run on a control CPU, the CPU for which
> > > > the "hotplug" code is called is in fact online. It is possible for =
the memory
> > > > allocation calls in zswap_cpu_comp_prepare() to recurse into
> > > > zswap_compress(), which now needs to be handled by the current pool=
,
> > > > since the new pool has not yet been added to the zswap_pools, as yo=
u
> > > > pointed out.
> > > >
> > > > The ref on the current pool has not yet been dropped. Could there b=
e
> > > > a potential for a deadlock at pool transition time: the new pool is
> blocked
> > > > from allocating acomp_ctx resources, triggering reclaim, which the =
old
> > > > pool needs to handle?
> > >
> > > I am not sure how this could lead to a deadlock. The compression will=
 be
> > > happening in a different pool with a different acomp_ctx.
> >
> > I was thinking about this from the perspective of comparing the trade-o=
ffs
> > between these two approaches:
> > a) Allocating acomp_ctx resources for a pool when a CPU is functional, =
vs.
> > b) Allocating acomp_ctx resources once upfront.
> >
> > With (a), when the user switches zswap to use a new compressor, it is
> possible
> > that the system is already in a low memory situation and the CPU could =
be
> doing
> > a lot of swapouts. It occurred to me that in theory, the call to switch=
 the
> > compressor through the sysfs interface could never return if the acomp_=
ctx
> > allocations trigger direct reclaim in this scenario. This was in the co=
ntext of
> > exploring if a better design is possible, while acknowledging that this=
 could
> still
> > happen today.
>=20
> If the system is already in a low memory situation a lot of things will
> hang. Switching the compressor is not a common operation at all and we
> shouldn't really worry about that. Even if we remove the acomp_ctx
> allocation, we still need to make some allocations in that path anyway.

Ok, these are good points.

>=20
> >
> > With (b), this situation is avoided by design, and we can switch to a n=
ew pool
> > without triggering additional reclaim. Sorry, I should have articulated=
 this
> better.
>=20
> But we have to either allocate more memory unnecessarily or add config
> options and make batching a build-time decision. This is unwarranted
> imo.
>=20
> FWIW, the mutexes and buffers used to be per-CPU not per-acomp_ctx, but
> they were changed in commit 8ba2f844f050 ("mm/zswap: change per-cpu
> mutex and buffer to per-acomp_ctx"). What you're suggesting is not quite
> the same as what we had before that commit, it's moving the acomp_ctx
> itself to be per-CPU but not per-pool, including the mtuex and buffer.
> But I thought the context may be useful.

Thanks for sharing the context.

>=20
> [..]
> > > > 7) To address the issue of how many reqs/buffers to allocate, there=
 could
> > > >      potentially be a memory cost for non-batching compressors, if =
we
> want
> > > >      to always allocate ZSWAP_MAX_BATCH_SIZE acomp_reqs and
> buffers.
> > > >      This would allow the acomp_ctx to seamlessly handle batching
> > > >      compressors, non-batching compressors, and transitions among t=
he
> > > >      two compressor types in a pretty general manner, that relies o=
nly on
> > > >      the ZSWAP_MAX_BATCH_SIZE, which we define anyway.
> > > >
> > > >      I believe we can maximize the chances of success for the alloc=
ation of
> > > >      the acomp_ctx resources if this is done in zswap_setup(), but =
please
> > > >      correct me if I am wrong.
> > > >
> > > >      The added memory cost for platforms without IAA would be
> > > >      ~57 KB per cpu, on x86. Would this be acceptable?
> > >
> > > I think that's a lot of memory to waste per-CPU, and I don't see a go=
od
> > > reason for it.
> >
> > Yes, it appears so. Towards trying to see if a better design is possibl=
e
> > by de-coupling the acomp_ctx from zswap_pool:
> > Would this cost be acceptable if it is incurred based on a build config
> > option, saying CONFIG_ALLOC_ZSWAP_BATCHING_RESOURCES (default
> OFF)?
> > If this is set, we go ahead and allocate ZSWAP_MAX_BATCH_SIZE
> > acomp_ctx resources once, during zswap_setup(). If not, we allocate
> > only one req/buffer in the global percpu acomp_ctx?
>=20
> We should avoid making batching a build time decision if we can help it.
> A lot of kernels are shipped to different hardware that may or may not
> support batching, so users will have to either decide to turn off
> batching completely or eat the overhead even for hardware that does not
> support batching (or for users that use SW compression).
>=20
> [..]
> > > >
> > > >     The only other fallback solution in lieu of the proposed simpli=
fication
> that
> > > >     I can think of is to keep the lifespan of these resources from =
pool
> creation
> > > >     to deletion, using the CPU hotplug code. Although, it is not to=
tally
> clear
> > > >     to me if there is potential for deadlock during pool transition=
s, as
> noted
> > > above.
> > >
> > > I am not sure what's the deadlock scenario you're worried about, plea=
se
> > > clarify.
> >
> > My apologies: I was referring to triggering direct reclaim during pool
> creation,
> > which could, in theory, run into a scenario where the pool switching wo=
uld
> > have to wait for reclaim to free up enough memory for the acomp_ctx
> > resources allocation: this could cause the system to hang, but not a
> deadlock.
> > This can happen even today, hence trying to see if a better design is
> possible.
>=20
> I think the concern here is unfounded. We shouldn't care about the
> performance of zswap compressor switching, especially under memory
> pressure. A lot of things will slow down under memory pressure, and
> compressor switching should be the least of our concerns.

Sounds good. It then appears that making the per-cpu acomp_ctx resources'
lifetime track that of the zswap_pool, is the way to go. These resources
will be allocated as per the requirements of the compressor, i.e., zswap_po=
ol,
and will persist through CPU online/offline transitions through the hotplug
interface. If this plan is acceptable, it appears that acomp_ctx_get_cpu_lo=
ck()
and acomp_ctx_put_unlock() can be replaced with mutex_lock()/unlock() in
zswap_[de]compress()? I will incorporate these changes in v9 if this sounds=
 Ok.

Thanks,
Kanchana=20
