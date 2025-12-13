Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AEB2FE052;
	Sat, 13 Dec 2025 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765655602; cv=fail; b=hC3PdLVLpfKTHy3cPElHTPhEMzlbbwKTQujAfRThlf7aMhN17QGuyWWaQC+z2vO4WAeO+mxE0cE3LU7+7fX7mhnBEeymSRALa33FB8TbUmxlUIkMQz0Uvq9sa3cZhsmRJFNTO1A9Sm6bF9ecv66XKcSx7t8ft+JmB3FuCfuqbFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765655602; c=relaxed/simple;
	bh=CdIxxYSYf4eXCLJKq/DnZndJwMiLzRGz4d2cSA5blLk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PpMcHCmRtzw9ZA02ViKhM9KeQ0rkDTRrhaY9/FvA+yEiXiPqSoSxcUwcaH3z4EobLTdV1AYlFEasU8oPdpN3fEfBB0YMOrs17RonxGPiQD8m374eMNSbZTVbmVTIlqZXaWYKUbbVcH4UKhJikyjIhT/ico5NwWUwYwJXzM30riY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jYU203+C; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jYU203+C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765655602; x=1797191602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CdIxxYSYf4eXCLJKq/DnZndJwMiLzRGz4d2cSA5blLk=;
  b=jYU203+CiDIGFS0q+gnM5OCGjoik6gRj+1F0JMNpIU6hEJooa6LzRTnK
   isvPnwpAXuViogI22lA27RUZIDsJZJYUkrKXA3Mnts9Rkx6e8PyBN2iAf
   pjtayhiQZ8C4V/yG1yQzrKpe75Iyorzuwap/gGJBb0Px/Ew07Ef/bgYUf
   tKbRKvoTheh9NU4oA9CdXxz8c9BqgCZYM68urwDeMTdptZ19vVfL0w2e5
   Hz5IKcgg8anArONKinBJo/IBZ+oVFCo34R5wL1/fV6rT+T7Do22tkWr+Y
   0mxb900TsVk2GYnY2GVtqNV1F+zZpxlFRnDHnv/DU1rB/bE8F37cS1u/9
   g==;
X-CSE-ConnectionGUID: PKdY4suPS0ycZB/c/n9/zQ==
X-CSE-MsgGUID: AtDnhgabSoWD1qUkELzc9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11641"; a="71249377"
X-IronPort-AV: E=Sophos;i="6.21,147,1763452800"; 
   d="scan'208";a="71249377"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2025 11:53:21 -0800
X-CSE-ConnectionGUID: OS+ct2eJRxKPX/F7a0vHQw==
X-CSE-MsgGUID: kRH6O69YRGuGDiGFmiXSKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,147,1763452800"; 
   d="scan'208";a="196438615"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2025 11:53:20 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 13 Dec 2025 11:53:19 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 13 Dec 2025 11:53:19 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 13 Dec 2025 11:53:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyQv/0Zj7zlM+6De3iNxLD8sDherp4DS3yfsYCiRg9eS99yNjmqNOpGrQksKjTpVISNlKvzjgm/yMEm6ufl0QSpCuIUmTPFyAHVTmsQpdoHctjjZPCM7F4nMVX3nY1+HhDCJd0RZYd5TlgZ2jbo4ApdOl1iEVdayaXrAhVN9L79CRKP6VlFg0B/H43jISy0GbE6N4GPrgy6/w9zi+axjKloMZilPMyrQcIXbCnNbGbO51th/Hg/FJBwyHSv3ZW5UtzUVxRmIMkAsgwCFBWJMReJd/ODCc8xL7o9rPtkwftp/mTcIEM/lG03E/afBDW+TVqIBGJp5oTaPiLtNho9YiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OTuu1tHdOqy/dVw0nARqupmCGs4SjMVem7Vv3xtBVw=;
 b=ijTTGSBrW2HIABnT//E+6i4Us3qHCRrNHHU+YorYGAtvw6P9LSD9KRfB3uWHda720vc9GVfgsw9ACUo2UexQV+QrK3O1fJ2onSeFP8r2prEtb76Q6dZQ9JCoJb4d4nitoOiiCzG5jC29RTAsTJFoRqXw7U1OAeV3lBWf8heYLMiRuXdI/FnL2aesqzYXJWJSm+wVLoVPSPOJZCyj/YEfuBH0PSIx8jr9KCqTR250EAtvg34Lv1Dtd/u+gCsqRtC2ncLw7O0w+9/WwN93DMUeIBwnVG5z8gxAlp5K/0EH4dLmJjQdnF2NXOE2c5XeXadsv5Bkiz0giHbSRX8JLSU5Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH0PR11MB4838.namprd11.prod.outlook.com (2603:10b6:510:40::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Sat, 13 Dec
 2025 19:53:17 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.011; Sat, 13 Dec 2025
 19:53:17 +0000
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
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgC1uKYCAAAlEAIAAIBNQgAAd0gCAAWY5MA==
Date: Sat, 13 Dec 2025 19:53:16 +0000
Message-ID: <SJ2PR11MB84729257422FACB33E315958C9AFA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
 <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <qbrym673jqbz4kaqqzhgioh7vhiq55pqdxyvlwgfle5yqlbtln@xjxem4dbwca7>
In-Reply-To: <qbrym673jqbz4kaqqzhgioh7vhiq55pqdxyvlwgfle5yqlbtln@xjxem4dbwca7>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH0PR11MB4838:EE_
x-ms-office365-filtering-correlation-id: f07491fd-de46-44cb-17ec-08de3a814239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?saCGcsx6qI2M2Y+v2X5z1IrYKTLA2Qv61njSEGENqBG+yI5lFSS4wEWh4htd?=
 =?us-ascii?Q?1M4Ziehahjo4iA9QH4tuLK7ON86xX/PjyYKMeHMFsnmtBEYxGFlVnCDpSRV/?=
 =?us-ascii?Q?40T9VA5rOeKK1krbZ7goVQCWZ7N7AjPU4dzf1Y5txs1tO/PtRlSBibtlQ6h8?=
 =?us-ascii?Q?7dGLBEl2GqjZi922S+pBW3fQ38rMYD4qJcDDNZkYKgFV88CFgJS4pTbZnqVn?=
 =?us-ascii?Q?Xb7TglyVJsebDPn/dHhutikXO7mOAKDYHrq4jnZKMnkWA3ncLbd0amgVeIZ3?=
 =?us-ascii?Q?2OmH3FejkRg2iC8ik8K7UuNtTz5dEsYBJI2Fy/d0iw4NNJZSsZtKcDiEEUZ5?=
 =?us-ascii?Q?c1EEV5iYjIXUaWoWnvMwneg2mMYmJcN1+/DXnyzloA1LhStRKKnxnd/HHF5I?=
 =?us-ascii?Q?QqoTArA9JcIfiq46B621yobGkZggegyhIWvrTN9z/6N71xUaxpgnQkfH1WEl?=
 =?us-ascii?Q?/0wppYeLEojr/IlOgUjOWh8nX/j5qOHPC9EGciJ0ZVtBHWUt4gmTzmRtatzB?=
 =?us-ascii?Q?aFVIjeakrUuwLwy4iNZCHWXljPlcsYQOt9jiyWRI3uREunm06i80p4HCVX9Q?=
 =?us-ascii?Q?w0UFCrgorDG6Ph7480abkaK6E+JVWw4JEUJhWeB5EzSg7Zzeuz1gV7Gw5Xx2?=
 =?us-ascii?Q?WuK75dBt+7DAiFUtuQyA1AGW4F7JBHtfb3tTSg9gQv6Kzt+T+GYQzsRTaXFG?=
 =?us-ascii?Q?7/ehzYnf8GqlQY6GSjtIEAhyDKiEtMv2LJhYtxqffTNnNWMHGYgDdbujEDpj?=
 =?us-ascii?Q?VnVxrM0J7qXX1E+9N6m4gF4b+MXYxtu4gOF0oJ9w47paOBAc0O6bsk2CC05r?=
 =?us-ascii?Q?ncFrcSHlucO1SF1k55Xah8xVt1QnMUKLstlU3LaIGkx1O3q2FS9DuUfEqjKd?=
 =?us-ascii?Q?duSRLD2jvmFiGWfoMO6vfmbpJV6clNoks+H13m/+PXnKLQ5acIosPfPja94m?=
 =?us-ascii?Q?iUjejj6mjjeRMxUxggeS1cmeBIw2wK1eBJUMB5eY36OUoMGTktAsZKAkv+Ym?=
 =?us-ascii?Q?bnAc2dRaid5yrCJM6uvgOsRWwKIhbZtjgHysCmiAes2cWxuXluW31s/SJ7NW?=
 =?us-ascii?Q?zo8LGcNMtPjlS9zzdYlX9FH8kTEOuvHNbxNUbfSM4uzpufDqjWsUwufoq1YV?=
 =?us-ascii?Q?/rcBil71XcUwFbYFwUZLZ9XNbMgEqwDoyYMeQM61Xf1bHQSqKYWOLwxhQ+/s?=
 =?us-ascii?Q?0Mn6ayDJYOO0UmDRYvfDKUW8iXKLClqeJ1Y+oPJsUf6VzKxGHDj+VzRG8NA4?=
 =?us-ascii?Q?oKnYf48yI0LJ3dy0km6tUGJpe0s6CIOiIlDTrMUFFcNETpGnAEC6K2HmXXy7?=
 =?us-ascii?Q?x4Jo55ApvXtIv1ShVSgVLKDDPzhMpbvHqlN/X7t/RntVC+LRr7c0nNXtkrjU?=
 =?us-ascii?Q?zlnYasTiyFT9XnDiVj1NUj+fctiz1t6P9rz3SdNODFBWIVfpDUYHpG96Cd6W?=
 =?us-ascii?Q?bkrgkv7CO0fy1cbGEp8/CHEaPiao+Rpbw+U1NifNp/3LAKNsnkFh4Cn15kv1?=
 =?us-ascii?Q?1hLa7vosJjcZso6AyT4hkyFaIQMk4BFtKawT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qxeDE4n59PasH60D26jdICD4nWdTddXR1gPJrnpGshW8BOymNjRcC6F3wMqC?=
 =?us-ascii?Q?zDBzgJ0WFOhWnPsn9C8GXGbsddcrElCh5hYQZoLEjiG+nXkRYfdXzvKQolqs?=
 =?us-ascii?Q?i5uwjd1GSrnUpwA2+9SvXeJ13faAkCnJn3TdkGuamVHczPPEM5ewCMp3/wyT?=
 =?us-ascii?Q?pN/X+CQBAT/rW3oOgv4lS505Zy8QHn2WXaLWNGdVDjQHfXvjFK0nDL5NN/lO?=
 =?us-ascii?Q?mpQfp/8yMwDmSaEgwwswvCj8DeTngU60yd90/uTBCXzyr5I7jsv9k6G5HTPz?=
 =?us-ascii?Q?FHYHPRr+5RoEgOTCbei1dediPmW9Spcfm55kO0b3yOoLJPv/p84Qtz8VKxUz?=
 =?us-ascii?Q?ekQR322PpskpAKuwVfEDfiwlzXhIcjXWnz7jtcalCBapnswCRZUPW2cS0aiI?=
 =?us-ascii?Q?lhRqiUmqh3VKkScQCa2i9F1X89BzglG6ZRMr4dH0wPr0ZV7a8e3RPElo2gvk?=
 =?us-ascii?Q?OLHuv7w3KTsRsN465+QvBBZolj9rHBaclv4W16slxJAod0UKDP+7e7OYStQM?=
 =?us-ascii?Q?cgy4BOR0onVPiIeTB8hhIkK/ayiUrDNub5C9cyy9DGFVVtzKP0oFvbYY6Brw?=
 =?us-ascii?Q?b8IZGQ2Iab3RcG98MMWhUS7zJlURMWaoeufCWUR2VNbY43ITFOkEeyNlc056?=
 =?us-ascii?Q?2PcLM8Ux7yXQs/LitaH2T778uI7KDdC6MVrH4EtUrKzxQcV3KyayXsNqSG3q?=
 =?us-ascii?Q?GxwNR3fnO/lphV+CnccA3yHXMdrBsCrRSLUnIcJwmLJPH9q2qY2gMshIJlXZ?=
 =?us-ascii?Q?O5iMBA8woGi2BUHg3chtC3KESDrJ8MOyd6fa1Pvq55PYCsFGQuW/vNX0aXtw?=
 =?us-ascii?Q?s7ElFI8E1MgfLxFw5i5l5ZlOBAnvJJpYIujbceUdgTO4NAA7SzIfA/K1TnU+?=
 =?us-ascii?Q?dPGbZ20mt4a6O02Kih3WwsR7+9MMcmvTu6d3KczH+AEYMF6+ex200gIAWDy8?=
 =?us-ascii?Q?q3dj5Xgs/we+TEQaWj0jFdlfUzc2y2UMxkGu02Gmod9sayjuhTwjmtT85nsC?=
 =?us-ascii?Q?YfuANz+nJhazV+RrbhgSw0LYKfu/GVvZ84e6k+doEk8IOz3pEP5ciMwVi+p/?=
 =?us-ascii?Q?/95vTjVsr0rTR02f4lsHuII+oTzccVXqNMolGqAWJG0Q68ZtinleW0MAO0wL?=
 =?us-ascii?Q?F154AMlHPAY9pwb5skgEWZcajej2qhjIzEScMhPYAf4uMGc1DiQREK+sMBUS?=
 =?us-ascii?Q?dk1/IGPFvsw4edAdLskgIL6GKqSt/vr9ShHOmcnyBuOFQ36zsjL7RGEFvoGs?=
 =?us-ascii?Q?ZozLMY9cApZ85F8YgotDfYvMH3RsXZO0r/Xns6NsVY21alc97pA2GRVpToal?=
 =?us-ascii?Q?CHwPhoNY07dRSDNSWShCZodOeLIM8vcFV3rarhcGy81jMqTziERrvxBigGre?=
 =?us-ascii?Q?sIdMuq0GmwIYEI7kN9UbkIWcs+ieXT9Nm8xOG2+vpiPXNYmdUOv+bJXgQCxX?=
 =?us-ascii?Q?d5M0P4lirsexxAWKo6QoCCDZ7GtjyDOoqS+RFdMo/kTzbRbJmquNUDtQ5IMW?=
 =?us-ascii?Q?1UusMNEpIFuzryHPpCJX20v99liF4lZ6ZToBFqyOLRvJyGnM5rINrvLziYi3?=
 =?us-ascii?Q?eOVsZV5QPWd9k68T2DJMaHtjLu4MuogunFbIb2SD8Lti+zUesKBDDMWq7JeD?=
 =?us-ascii?Q?Dg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f07491fd-de46-44cb-17ec-08de3a814239
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2025 19:53:16.9016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cUdClJH+1wEkT1l3TUuef5jvhbJvi1TUtbPw3oIq0b8RzM64z8pWG2H8yUI1g5JFw33Ejaa2eysOeO7GRvH3LHCDRvzpvqnjgnkk7jDfWlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4838
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, December 12, 2025 2:25 PM
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
> On Fri, Dec 12, 2025 at 08:53:13PM +0000, Sridhar, Kanchana P wrote:
> [..]
> > > On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > > > >
> > > > > >  	ret =3D
> > > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > >  				       &pool->node);
> > > > > >  	if (ret)
> > > > > > -		goto error;
> > > > > > +		goto ref_fail;
> > > > >
> > > > > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, =
we
> > > > > probably should add a new label.
> > > >
> > > > In this case we should because it is part of the pool creation fail=
ure
> > > > handling flow, at the end of which, the pool will be deleted.
> > >
> > > What I mean is, when cpuhp_state_add_instance() fails we goto ref_fai=
l
> > > which will call cpuhp_state_remove_instance(). But the current code d=
oes
> > > not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
> > > fails.
> >
> > I see what you mean. The current mainline code does not call
> > cpuhp_state_remove_instance() if cpuhp_state_add_instance() fails,
> because
> > the cpuhotplug code will call the teardown callback in this case.
> >
> > In this patch, I do need to call cpuhp_state_remove_instance() and
> > acomp_ctx_dealloc() in this case because there is no teardown callback
> > being registered.
>=20
> Hmm looking at cpuhp_state_add_instance(), it seems like it doesn't add
> the node to the list on failure. cpuhp_state_remove_instance() only
> removes the node from the list when there's no teardown cb, so it will
> be a nop in this case.
>=20
> What we need to do is manual cleanup, since there is no teardown cb,
> which is already being done by acomp_ctx_dealloc() IIUC.
>=20
> So I think calling cpuhp_state_remove_instance() when
> cpuhp_state_add_instance() fails is not needed, and I don't see other
> callers doing it.

You are right. I too have verified this. I will create a label for the call
to acomp_ctx_dealloc() and fix this.

>=20
> [..]
> > > > > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > > > > *__zswap_pool_create_fallback(void)
> > > > > >
> > > > > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > > > > >  {
> > > > > > +	int cpu;
> > > > > > +
> > > > > >  	zswap_pool_debug("destroying", pool);
> > > > > >
> > > > > >
> 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > &pool->node);
> > > > > > +
> > > > > > +	for_each_possible_cpu(cpu)
> > > > > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx,
> cpu));
> > > > > > +
> > > > > >  	free_percpu(pool->acomp_ctx);
> > > > > >
> > > > > >  	zs_destroy_pool(pool->zs_pool);
> > > > > > @@ -736,39 +766,35 @@ static int
> > > zswap_cpu_comp_prepare(unsigned int
> > > > > cpu, struct hlist_node *node)
> > > > > >  {
> > > > > >  	struct zswap_pool *pool =3D hlist_entry(node, struct
> zswap_pool,
> > > > > node);
> > > > > >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > > > > >acomp_ctx, cpu);
> > > > > > -	struct crypto_acomp *acomp =3D NULL;
> > > > > > -	struct acomp_req *req =3D NULL;
> > > > > > -	u8 *buffer =3D NULL;
> > > > > > -	int ret;
> > > > > > +	int ret =3D -ENOMEM;
> > > > > >
> > > > > > -	buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL,
> cpu_to_node(cpu));
> > > > > > -	if (!buffer) {
> > > > > > -		ret =3D -ENOMEM;
> > > > > > -		goto fail;
> > > > > > -	}
> > > > > > +	/*
> > > > > > +	 * To handle cases where the CPU goes through online-
> offline-online
> > > > > > +	 * transitions, we return if the acomp_ctx has already been
> initialized.
> > > > > > +	 */
> > > > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > > > > +		return 0;
> > > > >
> > > > > Is it possible for acomp_ctx->acomp to be an ERR value here? If i=
t is,
> > > > > then zswap initialization should have failed. Maybe
> WARN_ON_ONCE() for
> > > > > that case?
> > > >
> > > > This is checking for a valid acomp_ctx->acomp using the same criter=
ia
> > > > being uniformly used in acomp_ctx_dealloc(). This check is necessar=
y to
> > > > handle the case where the CPU goes through online-offline-online st=
ate
> > > > transitions.
> > >
> > > I think I am confused. I thought now we don't free this on CPU offlin=
e,
> > > so either it's NULL because this is the first time we initialize it o=
n
> > > this CPU, or it is allocated.
> >
> > Yes, this is correct.
> >
> > > If it is an ERR value, then the pool
> > > creation should have failed and we wouldn't be calling this again on =
CPU
> > > online.
> > >
> > > In other words, what scenario do we expect to legitimately see an ERR
> > > value here?
> >
> > I am using "(!IS_ERR_OR_NULL(acomp_ctx->acomp)" as a check for the
> > acomp being allocated already. I could instead have used "if (acomp_ctx=
-
> >acomp)",
> > but use the former to be consistent with patch 20/22.
> >
> > I cannot think of a scenario where we can expect an ERR value here.
>=20
> Yeah maybe do if (acomp_ctx->acomp) and
> WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp))?

Sure.

Thanks,
Kanchana

