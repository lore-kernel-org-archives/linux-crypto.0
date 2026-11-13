Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794583465;
	b=ScJOQEDmP9MF1RMPLvbABNpyuD/g//o6IVZLQ0WhygG6MKE35OI18WoWmheGnmbfab6r
	 +ZfmZ/FlW+DLMwB5jFdOvdqLk7MERCVf6F1aNh2Vfj+4NjlbyIyanlGa9SGw9M4CR5cF+
	 2Ca8VAW2dpimYjo2X1bwOEUgjn/YU+YrB7HFPWkA5MtiErZYK+qoFwZxVYDJHlRtOShik
	 r0KMkTCiJ9PTRKxNzvw9Ymz9vzZbtDbHHvJ9XzoBxiPZBF14ogh7tHT9TDbliT1abRN2E
	 PswCFkQVIOvs3hYrmQyy4rV07IZHU7Snpl17jZdUMBcvtFUdrFz9L24Vj0R18FDVOUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583465;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=6TugUyOXxNYTJWds3Op+QGMEOeW4quDeXJcdcA1nr/I=;
	b=wEXMVrhnwIjp5VwYi0GkXozxAYrUTxMO0Fzfo3k4icRhzakaiQoNYtTYrl4eBN+xz/K6
	 hDO6acZd/odPHwiewm7uVk0ZKZk6844JWQDUZk0vAC3IzXUJ1gYUXzCRFkUOSPrPf8kTU
	 EBqbGbWcphQCihVWcBYycSFfP3TMLX4wZEb3xwopiAxGh6qQg/50UcMJPQ7sweVL5yycI
	 q1pmZ9STpq7h1DR7qx1rSZjEaDgRGaaQCbmmzyYepbEFXjPB6F4eyWtJCBFU+/C5Kk3Xr
	 lo1hFOqL3QYGK20VwwJ+j3I+2h78WrlUvmiCJpfLr4fjYKhdzeLcKtX9cLhn+N1wKBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PuScYs0s;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Mb2Sbyo3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3E606A327;
	Fri, 13 Nov 2026 15:24:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17C3E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PuScYs0s;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Mb2Sbyo3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794583465; x=1826119465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6TugUyOXxNYTJWds3Op+QGMEOeW4quDeXJcdcA1nr/I=;
  b=PuScYs0sGhD//d7xmFpmRN/l8qFyT4/2OwgYRnWDaLXT/v1SAdf1WATE
   uS3135r4Nl5cMRgXqq4G/V1yZK/DFKdldGNiKHOtrrB2QK0MdhXpR8WoD
   qktFTHq+I+2Arkuq3fB25fa8nN3gYIHwbwVyCQSsHUcaL/1SXKGVDdu21
   RIy226haKrPRITTRAox6VhDTuqNsMT3BpDMHzwvb3QyGjca/aEgr16wOF
   3y6DHJbo2TuwbiNcP/QfQkRLh99cLu1IvUmsylP+wCT8NjQx7w3qXXmNr
   TUwxLttKLRVznuc0dGCqt082/m4ameFTFzDcw1eXxzKhxvggoJCyLapTH
   Q==;
X-CSE-ConnectionGUID: 9cVatjneR7irGsUHqlXTmw==
X-CSE-MsgGUID: QMqD6303QAmSTO58dKYfmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3427002"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3427002"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 07:24:23 -0800
X-CSE-ConnectionGUID: rkUOHqmRTp2dv2QH/M0fNQ==
X-CSE-MsgGUID: peCUt6VSTnaIUu3dczGQrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="8856445"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 07:24:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 07:24:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 13 Nov 2026 07:24:22 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 07:24:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDnZaXV1CVKZot1bLp6U94FoBDhl01xv8uOs8daNzt8l1h4wQyz0F0t6mSgVNC4gz+EBfBjuySRPgY5jLwjwZuCsqK004CKNtG0W2JqSKW8ayr3tWSKlfq3ZQt78ZbmYmAlGtvLb1xd82U/0G9EfYosctW2lK+IPi7lvKBE3uuZxqAk+fScGqrE36zNogZXbth5NVXziJza1p2ODUHfZ+DIJNVG6Oam3QYF33XDwe5jkvaS8P2uqAVkDgHuw1PFqunZ3cpWS5/7LyrATRh8aJ+FIxxcZ4umFoguP+OLS9rZFsgcUsPL1eTPqYT349Sm/eLrmeb/2Gx68plD7nB0EKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TugUyOXxNYTJWds3Op+QGMEOeW4quDeXJcdcA1nr/I=;
 b=ipOzsRbnBh31fJbrJ97Tv04d3m/tDk1LBhxKxFSssGZv56v1ofh84h0m1EuVzr87CTxbGkjoLKKSewPPW3nSd1xVcrwdXT/KsHIOzP2S8dhXtr2kZ1hFNU8ijtAUaD0pJnZzlILUWPHKBiNgvB8crrj3nAp50tES1FX8x6WtOXoKvx3FSTq2clF6MjvADeUSGHSQcSGJ0KSOzrVnGba69a+5uX0sh1YVNvmqtVsOi713josih2HcColaww1Vv+FXDiBG59g9iaka6RXyW5tY02W+Xs4BL1CXajpcaYJrljukKbOxhnIi4CHxDnOCm9G9rVPIWwImqpA2zOI5UrS2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TugUyOXxNYTJWds3Op+QGMEOeW4quDeXJcdcA1nr/I=;
 b=Mb2Sbyo3lkrhOB16MLWX+vfXYEid7CFJb+dDLHdnsTc1yASsWo7GxmPVYyQw4OGV7Ojo8XaaX3/yrkd9243fnifLj00RaPo1fAzN/DZ4po8QIdb8Fi9h8Hxnvbrb0om17nyFf/5DhIZALkp2XyRYFFaejBdFairXwhfQVsKgmu8=
Received: from LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22)
 by CY8PR11MB6913.namprd11.prod.outlook.com (2603:10b6:930:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:24:17 +0000
Received: from LV2PR11MB6070.namprd11.prod.outlook.com
 ([fe80::4c84:af62:dc60:fd9]) by LV2PR11MB6070.namprd11.prod.outlook.com
 ([fe80::4c84:af62:dc60:fd9%5]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 15:24:17 +0000
From: "Popov, Pavel E" <pavel.e.popov@intel.com>
To: Logan Gunthorpe <logang@deltatee.com>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>, Alex Deucher
	<alexander.deucher@amd.com>, =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=
	<christian.koenig@amd.com>, Hans de Goede <hansg@kernel.org>,
	=?utf-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@linux.intel.com>, Peter Huewe
	<peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
CC: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>, Sakari Ailus
	<sakari.ailus@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "David S . Miller"
	<davem@davemloft.net>, "x86@kernel.org" <x86@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/7] drm/amdgpu: Include <asm/cpu_device_id.h>
 unconditionally
Thread-Topic: [PATCH 3/7] drm/amdgpu: Include <asm/cpu_device_id.h>
 unconditionally
Thread-Index: AQHdcjcvOaiEUdbCQUyURjEWOxraKLcrZ3UAgAC5QnA=
Date: Fri, 13 Nov 2026 15:24:16 +0000
Message-ID: <LV2PR11MB6070DAC28BC1415346ABE2CFB27F2@LV2PR11MB6070.namprd11.prod.outlook.com>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-4-pavel.e.popov@intel.com>
 <029ccd27-68df-4e0a-bf27-3b40f68e91c6@deltatee.com>
In-Reply-To: <029ccd27-68df-4e0a-bf27-3b40f68e91c6@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB6070:EE_|CY8PR11MB6913:EE_
x-ms-office365-filtering-correlation-id: a9ceccc9-a434-4d1e-3497-08df419a2e79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|921020|38070700021|10067099003|4143699003|11063799006|56012099006|261026140227099003|261022105027099003|261026121527099003|261028144727099003|261022075727099003|261021123027099003|261009223027099003|22082099003|18002099003;
x-microsoft-antispam-message-info: SlmIN7ozEgMggX5VVhyQWxhCz9tgZ2Lnq2/vImlqBjhYMS14UP63oIq5RTrqLjN0K97ATLTofdOmSjAOwbp/LmEzS+ZSlEIEaOAc69cwMi713ZdKivAB8jVWeYPqSK5I3mWBDfeZZrBMtlDVa8jSoa9+LHM1NBog0n/QA6C7ZFnYsFWQ1sjR7DQDc8pkZ1iyx9UzXylTDR4WCDDIzPZfxOuxF/F8AOcbj0g27zZqtyLhzgU0LcbKGZ3C9pVDLxChLZc0kKcoPaW06aLBUxF/70PVhAdTRoZhCklWNk0e6plqJfze5iHq2EuMARtJWZbVy8J/f/Xl7OmPXDGhMn36iWY1KnX8fNokyaQcd0kCtLES+KT34ukcPFCZ52FyU1FgmKqCFMU2lFaWLLRywbBz0H2t2lORM2oeP4XGR6MzR3uUlgB1cIICV0efIyMo5iaKzCkylyUJXkS8Fzw4UIbt0BNbky19IGjekHMUboxDFC3DG+sFV9N52LtI8xwGAiiUOk6biffkb+k0XocHEA3coMqmoWMIIPw9Khcg9MXiwOGNiwoO75y8NFNzM18nc6UIAHogCGi10AAOxlM4JcQJerUCoyuBd+g5ixIwMhHIB2L42f3Bbv3YvZTqZJE+q4MPRu24U+G2ojjkUaNTDSgj1r26sgobVeJtTGsTLktDonPBG2Ba2wzXcm8stxZycyFV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB6070.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(921020)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261022105027099003)(261026121527099003)(261028144727099003)(261022075727099003)(261021123027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVpLNU1HTnVJOXNEVkFiWjdPMVR6cFVDR0dZbjhnTUFRenB3MWpLSEY5a05N?=
 =?utf-8?B?bTJidnFneEtzc1kyL0hzU0VJYzgvYk5pNkdKemVLOFArSlVlekV5OHJmVlJE?=
 =?utf-8?B?VWlacTAxNWFoSUhVL284NWw3dENWQi9PK2RYWmR6bjBtbmZ6Yk9SbVBxaFRx?=
 =?utf-8?B?TmtkalpkK1FGL3VoSGJYN2FoczdOTGh2UDQvbndmeDlBWEpKSUpDMmc0eDFz?=
 =?utf-8?B?Z2ZramlJNUxPYVJHRU9WazdVNWNBcmdOOHFrS0dtcEFtdDBhZkFxUDd2YmtY?=
 =?utf-8?B?ZUtIbXVyWlJLM01vbms3UzhMK2NpcDRXaGRZb0JqVEhWMmNwYUJZaitBd1Vl?=
 =?utf-8?B?bEtNOWp0d2F0TnFkSHlaL2Q1VnFnclF3SytXRjlMMThLUTNIY1orZndkMXZa?=
 =?utf-8?B?eWJ1ci9ZQno5MWJBZHFTTjYxQjlXWndWSkFGc3lWdlB4WmF2cHNqckdBcVY4?=
 =?utf-8?B?TGlTeGJ4WWxLZ3BTMlR5eTBUNWlwWHY3ZTYxRmM2NXN2K2pyNGhybzdHMG5N?=
 =?utf-8?B?VVFadDBLTlhoZGJvNmpHVmxmeVJPKzRUdXVqS3h3T2tkQStjS2g3eldtTkNk?=
 =?utf-8?B?MTFBbTBTaGhiSkpCZjZodjRlTEl2V3VjS3BOSFRsOE15L0VqdFZBQW5WbFhZ?=
 =?utf-8?B?SkJpTk4xRVVXZElwaGQwazk5MFVJcXg0WVNMNUFIZ0ZPWDhLVFBlZTlodnQ2?=
 =?utf-8?B?RURlbCtOU2tUWVZiSTUvMytBQnVvK2Y1WVIzMzI4QXB2cStrRGtFUzlnRm5j?=
 =?utf-8?B?V3E3UERqR0FDamdiUEpEQUwzK2l2SGhLNEJ0UkZJMmdBQlFzbTMxd2pQNVRi?=
 =?utf-8?B?VFpmRE53MmV5TW40Y09FM0c0TmhBK25iakVSN0FNMFBsQUJWeUpUY1M1TnNK?=
 =?utf-8?B?N2hCcnUrNnB0MGdqTHRWcisyMld2b1FNbXQ3aVJGK1FReXJBYWYwRWJ1bDVz?=
 =?utf-8?B?ZDVLeURsc210WGdzT0V5QTRmRWxYc1FCMHZCTUhwVmVlVjM3VkNTYlJLaURK?=
 =?utf-8?B?ZndKUGcvRWMwcEZWRkdNTmtIMmt6bnJwOHFjSncvQlBQaWE5bHRaSERlVU9J?=
 =?utf-8?B?ZW9iMHV6c0xCdEFITytpektJNUJJTU9SdGZ2Yk9ESkFTbXp2UEpab3hhc1Jr?=
 =?utf-8?B?M2p5ZlYwK255bE90YittM2ttQXpDTDRadUlwZWVzRnNjckU4Y0c2aVQzVll2?=
 =?utf-8?B?dmJoVDNQbHZwYWlsUWlLU04wREpoZ2xvTzlVL0N1TGladXY1WENmanZBbVVW?=
 =?utf-8?B?Q0VWSXRBRC9KNFRXZ2JZTXRLNWN2NFBUWkgyN2NybC9tOXNzZW5UU3p0ODBo?=
 =?utf-8?B?M3ptZU4zL2tYWGdKUThvaEhBMFUvOXJCa1FnaDYweFRwaDVVenBPYnZyOTZE?=
 =?utf-8?B?RldTTWxnUUx5WG4rdGhwdVpmVk9HUG44eEJSU2lFekptY1Z3VW9PNlBadHAx?=
 =?utf-8?B?QUdJNnhtOUVIL0QwNW8vQnlQYURTbVQ0UzltT2VSaHl1NGx4WW82azdDaUly?=
 =?utf-8?B?Y29SRXlHdEI1MHRtbmxFeWpyUktaU2xRQlhnbnoxbWVuQVkrOTluQnhUWUM4?=
 =?utf-8?B?MktMN1hWaVhoY09vWkxtZGpkVEZSbllid2RGMktUa09qcHdKUDhaWHVoNEhn?=
 =?utf-8?B?ZzhTNDJIc2RzWHBtR0tjTlMwbFhIbGhKTVA1aWRldHpJS0Erb0RvUFNDREtH?=
 =?utf-8?B?RUtLZVVyQTdPSjRmczFqNytxZXM2Nlpua0MzUE4xaUtFY1NWOGxtS2Fsd0Za?=
 =?utf-8?B?Z3FjZFh2OHpsdTVVNUhGUzhUd0VvcDlKODE4T3NnZHlRSEhwcE1VVVZBWWgz?=
 =?utf-8?B?Q0t0MUtzbmlhMVdwUy9CWmhhNVYrZ08rcXI4bGl2T2xlK3h4MlVkTEdnVzNt?=
 =?utf-8?B?WFphNDZIZDJNSGhpZk1rWTRyTkp1eURYeWtqNm5NRUhKbjdZU0k1aTZrWUw0?=
 =?utf-8?B?Z056RGI2Tm1OWEw5b3N6SDgwWWJLQjg4MGlyelFpa1Q2RzZyUERndytYaW5L?=
 =?utf-8?B?NmkzNWgzWDR3eUlRRkFpRnBEeFlsMzhuWUo0K0tXd3ZYRDdaeTJLb0JmV3hQ?=
 =?utf-8?B?cW5yN255UVlScVVzK1F2NlYrREdjeUtnc3VuSzIxTXIzZjdqczY5R2dOMFNF?=
 =?utf-8?B?cDRpV09CQ3N5QVBSci9kSm54ZG41Q0RYMWFNU2IvSTJvSXR2OW1pUGN1WFpX?=
 =?utf-8?B?YjlZdkdFb1RVKzBUUXRBdEhRL0NEUktvVHcxS01IbTN3QUIxZzl0QkR1SVJn?=
 =?utf-8?B?V3dZRTNHOFBHcnptNmVWWnpJNmo3djRxRnlaL3RvMzZyQzJpcFEvcUZWYmtT?=
 =?utf-8?B?VGxROVdwcHVVbkFRQ1ZlZ3hVZ3Q5SWo2d2NKeGw4SVpzbzNJNDVoUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: K26vcCurdzdlsy1Pj//HhpvJ2EH2s3m+rElRJJI6IUEoFhafOO+pcf9dEUaMJYck38x2lF+UlQhBdTogVZA9P8v7PayDDkPa21HGe9rwUGK3F+TeHQL0Bee/NT/rS9HCqOAVy6JUGqvS+xHdMIMbeWylz6y3zBimz5TLzQMiuOVYXGWCzIh/yHvorx1RNtZB5su+s8cy3xlqAT+mbVFseW4Bkl+8m4slFSlnusVy54SsqDIy1t/dlpN8ZO3ZDSImFX6Rd8D/oKWWEZBKHNbFgRG1Sf9e4YfUlcllUFYJR3XqZw49FeFY6JWpoZ0W0Eg6eU07QYQCidCsclDLVk0t9g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB6070.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ceccc9-a434-4d1e-3497-08df419a2e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2026 15:24:17.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wyzOppwJhbbD+DOQg/N3IYjvUGTMQAx8fSns+8FwqYLeKkoxBoig26LBGPwKSWZjE8XnVdGnnF9K3xHFF8qmNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
X-OriginatorOrg: intel.com

PiBJIGRvbid0IHNlZSB0aGUgY29ycmVzcG9uZGluZyBhZGRpdGlvbiBvZiBhZGRpbmcgdGhlIGNw
dV9kZXZpY2VfaWQuaC4NCj4gVGhlIGNvbW1pdCBtZXNzYWdlIGRvZXNuJ3QgbWVudGlvbiB0aGF0
LiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nIGhlcmU/DQoNClRoZSAjaW5jbHVkZSA8YXNtL2NwdV9k
ZXZpY2VfaWQuaD4gbGluZSBpcyB1bmNoYW5nZWQ7IG9ubHkgdGhlICNpZi8jZW5kaWYNCmFuZCB0
aGUgcmVkdW5kYW50IDxhc20vaW50ZWwtZmFtaWx5Lmg+IGluY2x1ZGUgYXJlIHJlbW92ZWQuDQoN
ClRoYW5rcywNClBhdmVsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
TG9nYW4gR3VudGhvcnBlIDxsb2dhbmdAZGVsdGF0ZWUuY29tPg0KPiBTZW50OiBUaHVyc2RheSwg
Tm92ZW1iZXIgMTIsIDIwMjYgOToxOCBQTQ0KPiBUbzogUG9wb3YsIFBhdmVsIEUgPHBhdmVsLmUu
cG9wb3ZAaW50ZWwuY29tPjsgUmFmYWVsIEouIFd5c29ja2kNCj4gPHJhZmFlbEBrZXJuZWwub3Jn
PjsgVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz47IEphbmkgTmlrdWxhDQo+
IDxqYW5pLm5pa3VsYUBsaW51eC5pbnRlbC5jb20+OyBKb29uYXMgTGFodGluZW4NCj4gPGpvb25h
cy5sYWh0aW5lbkBsaW51eC5pbnRlbC5jb20+OyBWaXZpLCBSb2RyaWdvIDxyb2RyaWdvLnZpdmlA
aW50ZWwuY29tPjsNCj4gVHZydGtvIFVyc3VsaW4gPHR1cnN1bGluQHVyc3VsaW4ubmV0PjsgQWxl
eCBEZXVjaGVyDQo+IDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPjsgQ2hyaXN0aWFuIEvDtm5p
Zw0KPiA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPjsgSGFucyBkZSBHb2VkZSA8aGFuc2dAa2Vy
bmVsLm9yZz47IElscG8NCj4gSsOkcnZpbmVuIDxpbHBvLmphcnZpbmVuQGxpbnV4LmludGVsLmNv
bT47IFBldGVyIEh1ZXdlDQo+IDxwZXRlcmh1ZXdlQGdteC5kZT47IEphcmtrbyBTYWtraW5lbiA8
amFya2tvQGtlcm5lbC5vcmc+OyBUb20gTGVuZGFja3kNCj4gPHRob21hcy5sZW5kYWNreUBhbWQu
Y29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzogTGVv
biBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+OyBCam9ybiBIZWxnYWFzDQo+IDxiaGVsZ2Fh
c0Bnb29nbGUuY29tPjsgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT47IExlbiBCcm93bg0K
PiA8bGVuYkBrZXJuZWwub3JnPjsgU2FrYXJpIEFpbHVzIDxzYWthcmkuYWlsdXNAbGludXguaW50
ZWwuY29tPjsgSmFzb24NCj4gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+OyBEYXZpZCBBaXJsaWUg
PGFpcmxpZWRAZ21haWwuY29tPjsgU2ltb25hIFZldHRlcg0KPiA8c2ltb25hQGZmd2xsLmNoPjsg
RGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IHg4NkBrZXJuZWwub3Jn
OyBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9yZzsgbGludXgtcG1Admdlci5rZXJuZWwub3JnOyBp
bnRlbC0NCj4gZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgYW1kLWdmeEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmc7IGRyaS0NCj4gZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnOyBwbGF0Zm9ybS1k
cml2ZXIteDg2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGludGVncml0eUB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBhcmNoQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtcGNpQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDMvN10gZHJtL2FtZGdwdTogSW5jbHVk
ZSA8YXNtL2NwdV9kZXZpY2VfaWQuaD4NCj4gdW5jb25kaXRpb25hbGx5DQo+IA0KPiANCj4gDQo+
IE9uIDIwMjYtMTEtMTEgNTo0OCBwLm0uLCBQYXZlbCBQb3BvdiB3cm90ZToNCj4gPiA8YXNtL2Nw
dV9kZXZpY2VfaWQuaD4gbm93IGhhcyBhIGdlbmVyaWMgdmVyc2lvbiwgc28gdGhlICNpZmRlZg0K
PiA+IENPTkZJR19YODYgYXJvdW5kIHRoZSBpbmNsdWRlIGlzIG5vIGxvbmdlciBuZWVkZWQuDQo+
ID4NCj4gPiA8YXNtL2ludGVsLWZhbWlseS5oPiBpcyBpbmNsdWRlZCBieSA8YXNtL2NwdV9kZXZp
Y2VfaWQuaD4uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBQb3BvdiA8cGF2ZWwuZS5w
b3BvdkBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gRGVwZW5kcyBvbiA8YXNtLWdlbmVyaWMvY3B1
X2RldmljZV9pZC5oPiBmcm9tIFsxXTsgcGxlYXNlIGFwcGx5IGFmdGVyDQo+ID4gaXQgaXMgaW4g
bWFpbmxpbmUuDQo+ID4NCj4gPiBbMV0NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIw
MjYxMTExMjM0NDM5LjQwOTgtMS0NCj4gcGF2ZWwuZS5wb3BvdkBpbnRlbC5jbw0KPiA+IG0NCj4g
Pg0KPiA+ICBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZGV2aWNlLmMgfCAzIC0t
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZGV2aWNlLmMNCj4gPiBiL2Ry
aXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9kZXZpY2UuYw0KPiA+IGluZGV4IDE5YTU2
NjE4N2RmLi5mYzRlNzI3MzYzMCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1k
L2FtZGdwdS9hbWRncHVfZGV2aWNlLmMNCj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2Ft
ZGdwdS9hbWRncHVfZGV2aWNlLmMNCj4gPiBAQCAtODgsMTAgKzg4LDcgQEANCj4gPg0KPiA+ICAj
aW5jbHVkZSA8ZHJtL2RybV9kcnYuaD4NCj4gPg0KPiA+IC0jaWYgSVNfRU5BQkxFRChDT05GSUdf
WDg2KQ0KPiA+IC0jaW5jbHVkZSA8YXNtL2ludGVsLWZhbWlseS5oPg0KPiA+ICAjaW5jbHVkZSA8
YXNtL2NwdV9kZXZpY2VfaWQuaD4NCj4gPiAtI2VuZGlmDQo+ID4NCj4gSSBkb24ndCBzZWUgdGhl
IGNvcnJlc3BvbmRpbmcgYWRkaXRpb24gb2YgYWRkaW5nIHRoZSBjcHVfZGV2aWNlX2lkLmguDQo+
IFRoZSBjb21taXQgbWVzc2FnZSBkb2Vzbid0IG1lbnRpb24gdGhhdC4gQW0gSSBtaXNzaW5nIHNv
bWV0aGluZyBoZXJlPw0KPiANCj4gTG9nYW4NCg==
