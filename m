Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EBFDF51;
	Tue, 26 Nov 2024 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732587186; cv=fail; b=oxJdYgLnusuDTiMPDALWd1Exe+kL0ntAlPWW83ZjIvT5wCD+srVK+y5M9RikzqN+LBa7rLgiJQY4ouctDAh6RGt/M511LziWZVlSkFOCekvpMsdudgLiWNOuES34I0rYt2DC5elbAVaEuuy4j+fdMo9oaXk1haOQuPwgrdQFhAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732587186; c=relaxed/simple;
	bh=aMkLTSkpey5V2vUfQE/fTlIpqAwjEESRBzZBW0XPcM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aboi4WUwcfUqLAT9kSmAlRESFg9xNXcpokagYHHdd82KYKVUgkgJY/cnZtwErab1MwD+MA3F5/s1NQaY02JJ1pLBtpWtj6Gfl1PCPS6E2ns2lEd4IvpqCO1PLhGbbBExhmR+NbCb4Z+XFtto7JwfMDKfZPqXtkZxv1bZxBFxBUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4LKDKkh; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4LKDKkh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732587185; x=1764123185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aMkLTSkpey5V2vUfQE/fTlIpqAwjEESRBzZBW0XPcM8=;
  b=F4LKDKkhJAkJX2AKJlvdTXOZ+Wg8YHkG0l8Zw80vcmheTJIbt0sa/6cC
   WvdHOXdOlQAaYgr2z3MO2+quOHAqqyuTaV5dIJqIxAUxu/wZdALJVhplK
   tTrmhIRRYEA1jYGXWRc6F/BQDuOmCZ6TJYDV3L+3NgX0Z7r/VPYXltc8G
   rqyDrtCUAjs66Ivlsj3GY0y3aTNvIb3JwJ2jZhZXgCPFnLf1bDYoSTxai
   Fy7+rcki3c4fFWh2ubwfoAag/1GzkScwM6mtsTjar9r2UJ+t2LBEy/FAc
   k4ynQNzvnjlolWulrIolhqKCMpiEAc/Ouzt+XumcojY3nj8P2fyDV/oBW
   Q==;
X-CSE-ConnectionGUID: GdC5DHuGSJGANk9JSvBk4Q==
X-CSE-MsgGUID: BcdPN+sVSj2k+VVroSH43Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="44105724"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="44105724"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 18:13:04 -0800
X-CSE-ConnectionGUID: yU5wcy27SDWY7r+bZ4TxtA==
X-CSE-MsgGUID: 7Jq4C26bTpO7yTmYO2pffw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91355041"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 18:13:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 18:13:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 18:13:03 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 18:13:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o3rzp/2giliRqpd6H83ub+a/HcJzbXg9/CmdJHnHnhqA69NbmK9Mv62z5TMMsZ5UZ9dZU8oE9cWa2hc3JYivX5+grdTXra8Q6d2E2imEZ+uRdxTGmjmyKMs6v/vLIcCvkN3j8XYsm9Nv33+EgJUcWaP7/p3havEeLcOEVrsSvzo3qO7jZitn8+RbXDi4WvfwhZ6pB11wFfLcbIw69lqdkPqiqapGmcANl8eAafbdjNjsXBsCAjsvdh7tpjwpD/R5iVOYwqriRQRg+x5AhNSaREFDBgNsZt7Jgyy4iM+Kq2oaT+lHOrqVEilSGMXCDqnv6KG3cEfZwhCBpsA0tDfYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XP807OClU9ArOqB3h8gjUWV8Qk/UN0Y3IHUOymLPP9I=;
 b=A4J1SFal/gtDs36LAxpUHXWfXkqk+TasSYS6INrKEgcaxQaD0hvZHFwEmH/48XN1Jm6trQ4Tb1vfX9RvMkskUlA2Z3ky43jHC+giGbEJnBiG/BXhGyO+uk3F4DonOX5t8xmajJKBiaDjzg4VmSIUgYTapLqvpcB+fCFx525dYeQB+7kvWANiTw4S7ndEVGQs5mOHbLA5ETHALcbTLYwqglw8FOuxyBSiwN1f+amT6W4fx6itFJEHkIQVHcE/m2bszQPi+dWImvssTqRhvSKo5Kdmdb2pV989OX+tooTD88XKyYVpGuokBq66BsmVBgeA0Q3jFb34eI+Ys4NI5jUovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CH3PR11MB7675.namprd11.prod.outlook.com (2603:10b6:610:122::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Tue, 26 Nov
 2024 02:13:00 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 02:13:00 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Index: AQHbPXWM22jcCkeyAE6LgM2tVAM8N7LHv8kAgACul1CAAGZgQA==
Date: Tue, 26 Nov 2024 02:13:00 +0000
Message-ID: <SJ0PR11MB56786BA58DA2E5C83824CBDAC92F2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
 <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CH3PR11MB7675:EE_
x-ms-office365-filtering-correlation-id: 6ed1365d-77c1-4159-247d-08dd0dbfd9df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?dtgBvaqHxUCxM4NID0193JqzkOctcGOMfMMf2EhhC4xlDbY27SaPsyQTmqqF?=
 =?us-ascii?Q?tpnJSgNSNHyTHfJYwp9DNHx0yzbsAIbsBTN0wa0YsnLfCfNOBAxWDKcSFIdk?=
 =?us-ascii?Q?dE8iJno9AlHGiXvLgxl0Wr2i37pr2PutwMB1Z2GmEwAqonmidhIDxC1+qB1E?=
 =?us-ascii?Q?uw90TzK8oib1s3SfWLC4tbuAdU1M9HsE/AGKoLCrAsGwbowfWvy0vhABBiLB?=
 =?us-ascii?Q?gWVC8w/e8l48XIjdADZUzgHMUvkP6qcIGeg0cxeNamrGneubvHwCEeTJd8S7?=
 =?us-ascii?Q?pliMNl5MxwbjTepTdPfubN9kZb6x9Rndd4HBPn3BzGVHaf2tRiKLpqEubcS1?=
 =?us-ascii?Q?/bGwFFdNNWJIHzrqpKiIGGc25ZJv9SB+48D3XHcD49fsWGPPNUH0HcqRDeTT?=
 =?us-ascii?Q?7UQPddu//QWG2DbW9zWCvKliMXlprNg3P2NnVLjvL0BVzzJDa+3+vd4WUgP0?=
 =?us-ascii?Q?5cAB4cSb3w3NBuWIGw6mPS4N7Tw8blWatEZT69sPXNYUgvwg/9FCfWNYPQ7n?=
 =?us-ascii?Q?Rni8goskLmTEcYo3wXi7Nzb1VywFtlcDQXtzXkDZH7z2933umKK6pg7BS6p9?=
 =?us-ascii?Q?vQYZDOA5jZSWFc8PupQGYzPhzSA7T+PZZzkLrOCwFaf1oNAQBToaeafo034R?=
 =?us-ascii?Q?v8yE+j8Q4GQUYWQZXYZdBdPU5njDnS7qd64LOZS0t1WNuBSqDd9/IMsPsNjF?=
 =?us-ascii?Q?ySHiFi7TI7sQzunp5dNcJOpPCL3hWNmfZs0AaIl8eymhEE/bzWSS4yOPSfZy?=
 =?us-ascii?Q?ko7idVFH0RW97WuT+GlG17sYvBTylm4+QHquHE5lzY/u5tUr/cre2JXD0Jk5?=
 =?us-ascii?Q?rK+NdQrdhU0/AoJ4zuvWE/UJOSFn1z9J0KPWjFm4WQHXimNKVyOdkM2X+6PT?=
 =?us-ascii?Q?hGQFRlXwdgJppx4Yf3S+LudMSj+xf4bQMYBjqUP9wVyJtzqxE0Zn+54ZjMYb?=
 =?us-ascii?Q?V9AFUbvZ122A4oIRnkt6qOSU0al58/ah86D5N8lhfVxwKCGTuHMlyWsTPUHJ?=
 =?us-ascii?Q?jWqj0HalTiw84Gnaylo5Va722PXVtD/T3pijP4TzMe0wpbb9fJU8ardAN8Jj?=
 =?us-ascii?Q?MN9XPeOSLV2lFsdrL9B1BiEypxMwmYUQdytR26Q0j6mOH7HrIRbFUOGUgiPO?=
 =?us-ascii?Q?liGPKGZaRBtXC2e6X+t/8nrjMSY8jANYLoJFZ8HvG22YiMCdskJkwU7NEHR8?=
 =?us-ascii?Q?MQSHMt6voNMVpF0fW2ANjiFPtCkY5bk99/zzcyrOA0EbXbi2CCj9wrQiIeIy?=
 =?us-ascii?Q?6GHDGt1s7Q5sYRDNLECju/nLZFOsxkfp1y47gNLp861PCqCz/fnSioeCNm65?=
 =?us-ascii?Q?Kw+z6sYKnEAAXYkCPs6PLvdNoOdeURJrSFQPpkshQAi2KZk62ahR/3SuPwhc?=
 =?us-ascii?Q?igJQna0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?up0R732uHZN/uZoQwybi5RV6zYe8oj5xOpYTEDGtqB72+fPnWxcQQv4J1OVe?=
 =?us-ascii?Q?s69OIXt2grVq7h3gUfrKXRartr4Awd6KQQl0e0cvhfToHF/IvdH69Z11QnpI?=
 =?us-ascii?Q?26QAx4/fv8yvKT0Df7VDCRmcbdAAralLdq4yy+LGwUw/EIEmmWiCVy7EV4kR?=
 =?us-ascii?Q?5YgU010fu7r1bgh95aSA2gX1FFT21PmnuP4EN8xIL5uSMV/ryloR8ZSQhmRr?=
 =?us-ascii?Q?y5dLc0lAgR9KcnW4/kAtno81u30gbE+XzoMsz/oVM8z57rc0sRszC+WgaVG0?=
 =?us-ascii?Q?XeUuKVstLKg4XL+fpd+z/wjH2akkZGr5RdDS5PqCEqiCLIkLeHBar26/seW8?=
 =?us-ascii?Q?t7bYIpWkkgcigfTyTCnkawDrnDjQfUEtO5dbsjUr95iZCoF+sYtXnC7xn2cY?=
 =?us-ascii?Q?6tbs2sSXFhFgfpO2e/XUMarthRIiuFpGMqX8pJonbRiGMqnTREzo4aWnR3cR?=
 =?us-ascii?Q?EWD5z/RiD/l70gZ39MJCiTyrJvo0QZHVTZ7Y8edc2zS6HrAxWguqRz/d7iua?=
 =?us-ascii?Q?PrlBXzAtC3lPHlsYyQMU5txDfSnv4kA7tCOT/6AdItXLge/ZNv1t52+YMU1d?=
 =?us-ascii?Q?ExBkjnA54IDfdpsG4GJwrsllvQ/jW9HgxIzjgSo3vGsQBL1Iwolxfw21kVLj?=
 =?us-ascii?Q?NpfprlnYf05Lb7HbWmeT6N14lkGdME47DjTMLzM4drGiFOVvgxo8OJO6rrTZ?=
 =?us-ascii?Q?JMvvDpfKeoLYN2/G5NEdiV2M0h9V/sj7MYpENLvsolR5zHdjNV3B3RmJuoke?=
 =?us-ascii?Q?KCAknI8ZtUlr4F11X7Mjpb4Jo2GO3nB7SwsU9K87S+AlY65vVeQB8FmbStcr?=
 =?us-ascii?Q?48yPXDBNCupbtkwmQCHTEI5Ha7Pu2Pq4hznUo4fABYns6L5OSWSbKs3nxUEg?=
 =?us-ascii?Q?xtVnsjZAh669Ng/hKvYMpZIEVsU/fJTD1xnT1LlmupQ/G3DRlqoIHHN27RoB?=
 =?us-ascii?Q?OJ4jRTNHj7ZYl51Pwq5LxRVA93EjV4LEAkOTuB95LOFArOlrlAeusdfIiD+H?=
 =?us-ascii?Q?weovPDV1//f5LH8xrbeN6/Hb7BeA68TqXW1aNxfKN6Rt154hNGE4JTDYViCt?=
 =?us-ascii?Q?itdkljdquy3g70w7elbLUfvH256t8tHcustuySDV4se+M59oX3bFvWl7m28S?=
 =?us-ascii?Q?8uMYfiXVVpe66puVYfyQL8p5NNunotYd7JQjwtzdLNhjoZ2v7r4pUWRd9ZYK?=
 =?us-ascii?Q?96E6iPddOApgB64Z7oMfqCcCQXTzXVvv0KVcX/26JHwTF2SJjZGKrm2I/wkR?=
 =?us-ascii?Q?dtfO+jkqLFKKz32ZtcOUozSR2+8wgUHsNTdkA8mQsODx3kDXwN7MbVjTN4wP?=
 =?us-ascii?Q?3+dcQUI2gk6mU0TbvvkcaKVl9x9xdPHsTo9KMwa19MPL60Zu1EsP9iAPyYQt?=
 =?us-ascii?Q?PhOEAu3wRinnK0E3eioacUJjQoaKHEsRiPo5wHHr/sFVX423ztWGoyOuiAbj?=
 =?us-ascii?Q?Y4+qLfDKNhoafp+w27NT7C23txFKfMLNeZmLlB4lETxLJskLsOZxdcHvABHR?=
 =?us-ascii?Q?fCDsqqKpIYIzgd+kbjzOk774PtegxIqTW3NCk2kVi71SXCdvvMIszEuoAiNy?=
 =?us-ascii?Q?BcIITVPS/OmEccimhjuMM+21KQMpkaiG2XiEcRmCR/6/i3e+JLvn/ptLQZpW?=
 =?us-ascii?Q?kb4bNr7osSp2kkwnc/C7UTrYm2HXAlvPnRMly7oqzEscv0fw0R/IcTRvnoGS?=
 =?us-ascii?Q?CjEpwg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed1365d-77c1-4159-247d-08dd0dbfd9df
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 02:13:00.1465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: egHpwDVq2yppFYTkdGBadl5nXaatza7PicBioOqo6cZANqBoxYwzEy7r3Szs5OlZCWHiyRwlFWLqOPX2Et05udlmAqIts5mbYAVPC9GZxHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7675
X-OriginatorOrg: intel.com

Hi Herbert,

> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Monday, November 25, 2024 12:03 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; ying.huang@intel.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v4 01/10] crypto: acomp - Define two new interfaces f=
or
> compress/decompress batching.
>=20
>=20
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Monday, November 25, 2024 1:35 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@intel.com; 21cnbao@gmail.com;
> > akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces
> for
> > compress/decompress batching.
> >
> > On Fri, Nov 22, 2024 at 11:01:18PM -0800, Kanchana P Sridhar wrote:
> > > This commit adds batch_compress() and batch_decompress() interfaces
> to:
> > >
> > >   struct acomp_alg
> > >   struct crypto_acomp
> > >
> > > This allows the iaa_crypto Intel IAA driver to register implementatio=
ns for
> > > the batch_compress() and batch_decompress() API, that can subsequentl=
y
> > be
> > > invoked from the kernel zswap/zram swap modules to
> > compress/decompress
> > > up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardwar=
e
> > > accelerator to improve swapout/swapin performance.
> > >
> > > A new helper function acomp_has_async_batching() can be invoked to
> > query
> > > if a crypto_acomp has registered these batch_compress and
> > batch_decompress
> > > interfaces.
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  crypto/acompress.c                  |  2 +
> > >  include/crypto/acompress.h          | 91
> +++++++++++++++++++++++++++++
> > >  include/crypto/internal/acompress.h | 16 +++++
> > >  3 files changed, 109 insertions(+)
> >
> > This should be rebased on top of my request chaining patch:
> >
> > https://lore.kernel.org/linux-
> >
> crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herb
> > ert@gondor.apana.org.au/
> >
> > Request chaining provides a perfect fit for batching.

I wanted to make sure I understand your suggestion: Are you suggesting we
implement request chaining for "struct acomp_req" similar to how this is be=
ing
done for "struct ahash_request" in your patch?

I guess I was a bit confused by your comment about rebasing, which would
imply a direct use of the request chaining API you've provided for "crypto =
hash".
I would appreciate it if you could clarify.

Thanks,
Kanchana

>=20
> Thanks Herbert. I am working on integrating the request chaining with
> the iaa_crypto driver, expecting to have this ready for v5.
>=20
> Thanks,
> Kanchana
>=20
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
