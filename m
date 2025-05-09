Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE523717F;
	Fri,  9 May 2025 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746815379; cv=fail; b=PyFzyIohvWi15xanCgSNKuV9A4h2NNsB7KYYF34A8sxxJD1uWS0ScQdyUZPRRQUSxDonhQLEuZ/rOyfLw+tWfzUThebT+xFH8hGXpsZzgZvlPsmEMJ0ZoUTV81+BMMVYJY0wuhqeYP7EHpQB6qA59q7S1kBqq0me4DkO0kgr5Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746815379; c=relaxed/simple;
	bh=4fxY+zAaTXbiEmpChvv9MGpR8FkU6r1q+UL6xGmQobI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QmUU7QoH2Li+5k31Q0JaOcleCKjzJdn66CDyz32BhKA+atfUbQ7h/f37hgAMBm4sVePuBMU2DEgNr1UTalXhFqYU4rcYd+JOFlB0uMvnrN+OvwaXM2onp/+seFH5NDE2lwr1Fw7Ygh7nNkpQ0ZKPKM5mUYzmxVJq3vJxnKB5AWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAUIaO/H; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAUIaO/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746815377; x=1778351377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4fxY+zAaTXbiEmpChvv9MGpR8FkU6r1q+UL6xGmQobI=;
  b=TAUIaO/HrZVAu5zoADdRYpQh+ShvrLR7UpN3AXsMdsUepMTMiPx0hwvx
   APHHYe1G25h4t+piAlV3jQH692TYr/li913OKC3yKIi8zn7OZ5OH7Z5I2
   JdAo9DrQgeYoagomcWanAFI/j+FiaWWRofEN9SdvZ6jFgeAgSy8vAURdx
   OV6ICbaop2DALJflx2aAlnKgOG3rLPt9Thro0ztL9sGjMy3KUoQGTjsZu
   hx9gyzYxjNsppVaXBQGavWotAW0BElDSLJ2stucKH+A+iY+1AfMw+nJzW
   FlVkW/Mcp/2NjyW2YwAwO78X0SU0eZdkK8PD5aLYQAFE4BDgSgr5Z13AA
   A==;
X-CSE-ConnectionGUID: pE8wTkz2SaK6Epf1GyaeZQ==
X-CSE-MsgGUID: eYo4I6VQSceaCkX6Wlszpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59313314"
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="59313314"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 11:29:36 -0700
X-CSE-ConnectionGUID: 1begspKFQQ+qQkZa4ikd4g==
X-CSE-MsgGUID: 5D0VaI9NSo+S7wb1Xqu/Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="141906594"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 11:29:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 11:29:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 11:29:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 11:29:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORCVbSTvtElkX66Ipbo41N0K6uTi8GaD5K+zPpYYnbBIESFobpiIwI04fheZgJVirTwGd77XfhxcDOIkGP/yJL2BKe+QPXIGOI1o3dKd4O4O/h4EWHeghtegYN9wavPltdrPnw5FkuuWky6Y2/I/3IEBHuEXR86xw1Iz6uKM86ndgAEInJHYl3p1R1imk1DIvv/uq4XIiZcyBxBJgzgKAQmDfZ3JQWf2GgfBKEdj7xtnKRm00KlLt/2PQyzDUASM+jcV6bk9SmLXHFcvjsc0IbMYj6YM5h1SIP9IM8a9Hz1xcQww2ZhqwSqd4S7GlDq5DrqXhszD+zJ7+6VljZtaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fxY+zAaTXbiEmpChvv9MGpR8FkU6r1q+UL6xGmQobI=;
 b=jHH+8yc96BbgmRpiEQeSRrV9S657JMggf+3rBR6trmQ6fxZm3vs3aDT8jFfl1XNXpCuYCReht7Ag0W5kIjKxBvkTyL90EOWrnry81t58xKD32TaiBnBIYoJUY0wZA2sALNd8APicez0XILla+idDOPMFocQHSW5EVj89rMcFPe+ktn6Zus/s6vhK0GCdq4lGqwdT8MJmaHvmEuSGQpmffMCb4mKljOkpKwI7Z68JjnVvH2RSRQZHXFnPjfkGcuGZiS1tF3j+kl3qpmXWXEGjVAClF5omqFJYE5GsTk4JRbIz02GboUA7CHJmDUpZ4EVBJSZ0WKur4pg0987rMoS6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DM4PR11MB6044.namprd11.prod.outlook.com (2603:10b6:8:63::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.21; Fri, 9 May 2025 18:29:32 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 18:29:32 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [RESEND PATCH v9 00/19] zswap compression batching
Thread-Topic: [RESEND PATCH v9 00/19] zswap compression batching
Thread-Index: AQHbwFFAVvH/XaQ67k+2PUM4dnM9ErPJNo0AgAAGvgCAAWHb4A==
Date: Fri, 9 May 2025 18:29:32 +0000
Message-ID: <PH7PR11MB81213C0A34D7DAE5AE7A4239C98AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=NJm-9zodgb_UC2z+vshw98MmcqZDw_xvbQWaaU29eGMw@mail.gmail.com>
 <CAKEwX=MybjpmXVxM3QbfdQyXOv2xq87CZKzh1w2pdxucwSMttA@mail.gmail.com>
In-Reply-To: <CAKEwX=MybjpmXVxM3QbfdQyXOv2xq87CZKzh1w2pdxucwSMttA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DM4PR11MB6044:EE_
x-ms-office365-filtering-correlation-id: da913306-9914-49cb-ad3e-08dd8f277166
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0VYUmNlMHlLRTZUYkNXY0RXNUVjUUZWS1gyWXhSWGtiNGExVmhGMjdaRjlh?=
 =?utf-8?B?eENIdmFIdmNxYkkyUkdLUFUvYkViQ2Q3UnR1NE1mQTlMZHdwd2tCenJhaCtn?=
 =?utf-8?B?czlINDMyR2JLN2x0cWZGd1JoM3E5UGlpUGlWeWpRUktTVTdlWTExdEs5T0FF?=
 =?utf-8?B?bVZYQ0Y1cE1DZ2M4b3g5OS84aVV3bXc1T04vN0pQYnhuc2o5SkNZanNZQmFo?=
 =?utf-8?B?YWJTdDVsa3pZOHNsamd1cEp1Ti9tKzNZT0tadjF0eG14RzVaWmVZRmdUQkRF?=
 =?utf-8?B?QjBCOHFCajltRTkrRlBlMjVmUmtVZ1EvUks0RXlMMDNFeTZFWmV4UDRlb1Fm?=
 =?utf-8?B?bU54MGttMU5JQk1VYUFDbTBHazlYWkxXZmtUV2xtVWtYTFE2c013anpRWXMx?=
 =?utf-8?B?bnBoZmlMZ0hNdVNkRzFvWWwyZXBwUGw2OC9oMGluSkh2TDM5aHM5UlRoUWUv?=
 =?utf-8?B?RjJBYjVxakY0eVdJd2hlR2MzNHIzQmtsc0JwSWdMYU55blJua0JNL0tyMkVL?=
 =?utf-8?B?c2xNNHhnMStiMTE1d1JFNUk4MEpvQVkrN2lYSkZIU3YwNjBhVXVHeUh6NWVp?=
 =?utf-8?B?UHBGb2xjWHlQbmFHbzFvMWQvbUdYMHdhN3k5dndyV0RsVE9JUXEwOG9tUVBE?=
 =?utf-8?B?QStYb0cwc0owWEVaRlNCRUpmTStGMEhHdzNVemEwaUE5VmlPSXcrMG5kNU1P?=
 =?utf-8?B?MnF3eHgrOHNja2w4N3hNV3V3MjRpcHZwSUZJeWppTFNkWjI3NmNRNjZVZlFI?=
 =?utf-8?B?WEkvMlBRZnNtY2IySmZPNGxIQ0ZJMFFoNEdSRnJVSWJtN2MvNE82SUcxK2JX?=
 =?utf-8?B?UlU0bzdLd0NMbVRQbE1zODljejFiNVpFY2xMYUdSb3NLUlhmcThSVldBS3Y1?=
 =?utf-8?B?dVRwU3JvMGdRZENTeS9Pcmx5VEQ1d0JLNmRVdkNVMitwWjhLaSt2aFpmd2dX?=
 =?utf-8?B?aGZucWQzcitoc29Uc3JIOXloQk92cndmZ3o1WHR6MDd2NDlwWjF0bUhFWEhK?=
 =?utf-8?B?RGJ2YmJwbU4rVWVIOFAzV0V0ZFU5ZThNQWJvcjJ0NEtJWG5xK09wUEl0RmRz?=
 =?utf-8?B?Z2NuZXd4RWRvazZVYlRJdXU2Wlk1VnpLWURCalBRdVJxY1NZRmhpNkppdDRq?=
 =?utf-8?B?WXlLdkVBMlJuR1JsWUFYSUo0TkdMZkhqbVhKRTNoRHJ6bUg1aW5sM3FRU2Qw?=
 =?utf-8?B?U3dYWE45ekNUUmRQZjl5My9BUzZlcU5ESW9xVWtwdm1JdzZiaThYTnZPNVlu?=
 =?utf-8?B?NTJJMEplMTZ2QWd3MStUZGk1OWpweHlYekdEeEdxTmtnUGlHRXZ4bk9wNlJp?=
 =?utf-8?B?QXNxT2pPRjdJSHVobndtekZaeXlscWVjbGJHSmt4T3ROcGdzQ1lCRGdoMlRY?=
 =?utf-8?B?QjRsc3dkODRHU3pibDkxcG9BQy9ELzV1ejZrR1pOb3FQUFRQQWZwTENrVm5W?=
 =?utf-8?B?TG02MlhkdzhNb0QrOG9HdXBRTzFvY2xiNVpPU05Vc2NFamZOYklPbUdKdkZa?=
 =?utf-8?B?N1BTb2JEMCs5S1dFelc1Vm12STczbUZYSmVvZ2NVaGtBY01JRGMvNzBlYVVi?=
 =?utf-8?B?LzVoNEY2SmZ2NEdNK1RxTFNiZUtiSVFGV1U4bVIzeVVjUzBhRDNCemUybGpk?=
 =?utf-8?B?YXg5WmdDeWc5b2dTY01YQmtMalEwTE9wZjl1WlRTM0VTdWhBblFwbnZWSDhJ?=
 =?utf-8?B?NytkbXNKYUdJY0JmUUJ3NllQWHZONGN0a21jKzNxZnJLNDJ6VkFEeTBqeith?=
 =?utf-8?B?SE9lZG92RC9ISFg4WXBWUG5JeFdUVnpSYUQ5a2NQM2RwK3oxR1k2Vkoycm5Z?=
 =?utf-8?B?Vkk0MHQxZDJLSWNidjJ0MGdWVVUxSWVIbExFT1lCSXBGQlJ4TVJpMHd0R3dO?=
 =?utf-8?B?QVhBVE5rYUQ1TmhJZE8yMHVlbG03QjdkUnpzSUs5WXRVbG16c1FidW44M2JG?=
 =?utf-8?B?dXFVRzU5TFJIeEVmZUNzRFRrTHYva25IK2FNdVdJelFSSTIxYzJHM1IvY1Av?=
 =?utf-8?Q?ve2VOOqykU3+rvX62POeCnTaU7ICoM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVJCV0diRG1Vd1dDdy9tWWVHbUtiell1NXB4eWpKL1pKVGl0ODY4MzllZUhL?=
 =?utf-8?B?UUlEOVZLM3NwWitRbXlnOEkvMHRCZmxiWXVlNUI5WFVpUnFteUVRdW1tNFlu?=
 =?utf-8?B?RjlMek9JRnE4ZFl4cG5pRlNRYUllTG1kSVI5eW9qdk1zcDU5K2tDRE5nTXJN?=
 =?utf-8?B?UnFadUxEcitmUFZpV1owZncreW9yUzBYWWx6dmZnSldMc09RdGZDUzdSTUEz?=
 =?utf-8?B?TFVJZXZuTXQyZnRvblcwaW4xaW9kcWxlWWFGNmd4QUNmYjhFOG5kdFZpTDds?=
 =?utf-8?B?VmV4Q0MyVDRGNEIrSEtDTkNzaWY3WGRCNWJHTUp1dWFhOGJaemhyOFNhcW5v?=
 =?utf-8?B?UW04VU5DQmxhNG85SUFsaDF2VEpLS3ZEU2tsb0g1eXc5anBCSk1xaXR5UWkz?=
 =?utf-8?B?OUZsYzN0eWhBbG45bVdRdnlMelBXdjNnOTd0QzlxUmlzcEU5UlA3a0xITk04?=
 =?utf-8?B?RUxlMHVTeC9ZMGJySUorQzdaTTNSbTQvaUErY2NQRlFibmJRSitXQi9EZ1dh?=
 =?utf-8?B?ZmhsUkIxK3RrU05VZ0c0bzdxK1E3WUFwbmxwS0R2QnIzd0Q1bXlkWTJJYmE3?=
 =?utf-8?B?Nld5WWxuRGtGY1lwQjhMSG5FeEliem5RcFovNGNRakd0VndTT2F4Y0ZBckJS?=
 =?utf-8?B?VlJWOFVxMGplam9LU3puRXphMXlSMTEyWEUxUDRkbnIreUJQYkNPTlphWDVW?=
 =?utf-8?B?Tm9CS0NTdjduelZEY25mdzNab1RGcTFRNFpSbjk3RmloMXlIZzE4MExaMEU5?=
 =?utf-8?B?YlJNeVlZbEJQQk5DQXBQNHZLdy9zNkExUUVsLzJiK1Q4SGxCR3VtcHlOelQx?=
 =?utf-8?B?QUxwaGVtN0hPY0duUWxwQVlESCsra3ZpQTBVV0JKRjNucjV3aFJock9CQnVr?=
 =?utf-8?B?QnIzL3hqNXZ5SHdnMEtaSGc3U3lIRGxYNmtIL2djMnBPUkxnSXB6K2RZc2Zi?=
 =?utf-8?B?ZUd3bHl2a3h6OGdkemQwMTBpb2dlZHNYeCtuVllGTGJtRXVBTVlLZmVXelg1?=
 =?utf-8?B?enR2amM4SXphUkJyRVRocHJSRDlZaytvLzdpODFRR2U5VUZscVNPQ2IxbTNi?=
 =?utf-8?B?UTVaaENGUUZvOTZDZjdsY1dlMXAraVpwd3JOcW53dThTQmxUajFPOXcxWWhp?=
 =?utf-8?B?VG9xdDlVWTZiQjZibzNXUWlLRW8vaWlFNFlrOFhkT2ZZVlFNQUY0QURSTkFm?=
 =?utf-8?B?ejFXMUNoUnRtb09uNFlKMlRYRVhIeVBrS3lGUUxhUzNRNFFsRU1rTWRUVEk4?=
 =?utf-8?B?WmtMY2Q4TFU1alhVZlhQZ2VNWE9UN0o3T3d4WGVpd3JwNDh1UmZBWXh1YVQz?=
 =?utf-8?B?UVFnekMrazFVOWFPZkEzeVBOdjAvMHo3KzJEYnQ0YWZXTWNqVHYyYXVxS1F5?=
 =?utf-8?B?a0JlYzFhRW1sWTAzTzZxZlc5azJBemYxSnNMVmdKOE1zMVJva0VsUW45QTc0?=
 =?utf-8?B?cFBDOGhLSUMvNXY0TU5uclljWStsZFdBbEd4Mmh6NGI2dzRKTnJxWUtjclVh?=
 =?utf-8?B?N0VEM3FiWmsxdk9QbllXNVR2c3pCV3B6YWIyUG9QV0pzYmU4WE5WazRxZUNO?=
 =?utf-8?B?Q3hBTkowQTJ4cDUza0JNMlVmVm41Tko4aSs3bm5pdUZLYXRCWENJcG5SSkdC?=
 =?utf-8?B?UHNNQnlKMmovbzhpWDN3TS9yeUZHTWpnTktmVmZpY0ZLL2IxQ1llZXI3L0FG?=
 =?utf-8?B?cCt3N1djZXdITUxscjJManQ3V0ZRWGhsUnNlTVQ1MEdjRzNuWTNJNUFyWWdV?=
 =?utf-8?B?bGI5TUpBbi8wVXpkejJpU3hMWlZzWjcyWHA3dmFRdWNMSDNORi8yUEJSMHVw?=
 =?utf-8?B?VFBuUGNaYWJHejVKMnA0T01CMUpHWmlTaEhxSHZKQjIyZTkxUC9ZaG5mVlFa?=
 =?utf-8?B?YmY4UHBCc3FOZjBhQXc4a1prZUt0MjNtNnhWaW1CMnpCTXY2ZFllRlVyb29Z?=
 =?utf-8?B?R1ZXeDJwbzk1UXJMelZzVmtXdk1US3IwYmpGckM2ZWpTUjBVY3lOcjJNOVIw?=
 =?utf-8?B?NGxMbnJyMEc0VktsemFrdFcrQUdYaDI4cG5nMDhxaHNIL2VkNlZGWWlaTmZv?=
 =?utf-8?B?ckFaTmUvQ0Z2dkhHVDJmeWhad3RYUjdBV1A5cUFCUDgwdWx1MHFiUzhkMndm?=
 =?utf-8?B?SGhHS3plc2NzZDVWYlZaNDB6Vi9mdCtFZTFQN0hCYkdqRmdvdnhhbGIvQlBX?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da913306-9914-49cb-ad3e-08dd8f277166
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 18:29:32.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz4keTt10gRVKuXujqYJa1A0t9Qou92+1D+59HqtCeD++o+qUmgIzApEA0NbITLhmxZ0lHZL7UvTqWgjpG5MPNMu81awLkTxJJ8mmfkMAg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6044
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXkgOCwgMjAyNSAyOjIwIFBNDQo+IFRv
OiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiBD
YzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0KPiBo
YW5uZXNAY21weGNoZy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpob3VA
bGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJtLmNv
bTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFr
cG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGlu
dXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5l
bC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRp
LCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVzLCBWaW5p
Y2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2Fq
ZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3BhbEBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkVTRU5EIFBBVENIIHY5IDAwLzE5XSB6c3dhcCBjb21w
cmVzc2lvbiBiYXRjaGluZw0KPiANCj4gT24gVGh1LCBNYXkgOCwgMjAyNSBhdCAxOjU14oCvUE0g
TmhhdCBQaGFtIDxucGhhbWNzQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUaHUsIE1h
eSA4LCAyMDI1IGF0IDEyOjQx4oCvUE0gS2FuY2hhbmEgUCBTcmlkaGFyDQo+ID4gPGthbmNoYW5h
LnAuc3JpZGhhckBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+DQo+ID4gPiBDb21wcmVz
c2lvbiBCYXRjaGluZzoNCj4gPiA+ID09PT09PT09PT09PT09PT09PT09PQ0KPiA+ID4NCj4gPiA+
IFRoaXMgcGF0Y2gtc2VyaWVzIGludHJvZHVjZXMgYmF0Y2ggY29tcHJlc3Npb24gb2YgcGFnZXMg
aW4gbGFyZ2UgZm9saW9zIHRvDQo+ID4gPiBpbXByb3ZlIHpzd2FwIHN3YXBvdXQgbGF0ZW5jeS4g
SXQgcHJlc2VydmVzIHRoZSBleGlzdGluZyB6c3dhcCBwcm90b2NvbHMNCj4gPiA+IGZvciBub24t
YmF0Y2hpbmcgc29mdHdhcmUgY29tcHJlc3NvcnMgYnkgY2FsbGluZyBjcnlwdG9fYWNvbXANCj4g
c2VxdWVudGlhbGx5DQo+ID4gPiBwZXIgcGFnZSBpbiB0aGUgYmF0Y2guIEFkZGl0aW9uYWxseSwg
aW4gc3VwcG9ydCBvZiBoYXJkd2FyZSBhY2NlbGVyYXRvcnMNCj4gPiA+IHRoYXQgY2FuIHByb2Nl
c3MgYSBiYXRjaCBhcyBhbiBpbnRlZ3JhbCB1bml0LCB0aGUgcGF0Y2gtc2VyaWVzIGNyZWF0ZXMN
Cj4gPiA+IGdlbmVyaWMgYmF0Y2hpbmcgaW50ZXJmYWNlcyBpbiBjcnlwdG9fYWNvbXAsIGFuZCBj
YWxscyB0aGUNCj4gPiA+IGNyeXB0b19hY29tcF9iYXRjaF9jb21wcmVzcygpIGludGVyZmFjZSBp
biB6c3dhcF9jb21wcmVzcygpIGZvcg0KPiBjb21wcmVzc29ycw0KPiA+ID4gdGhhdCBpbnRyaW5z
aWNhbGx5IHN1cHBvcnQgYmF0Y2hpbmcuDQo+ID4gPg0KPiA+ID4gVGhlIHBhdGNoIHNlcmllcyBw
cm92aWRlcyBhIHByb29mIHBvaW50IGJ5IHVzaW5nIHRoZSBJbnRlbCBBbmFseXRpY3MNCj4gPiA+
IEFjY2VsZXJhdG9yIChJQUEpIGZvciBpbXBsZW1lbnRpbmcgdGhlIGNvbXByZXNzL2RlY29tcHJl
c3MgYmF0Y2hpbmcNCj4gQVBJDQo+ID4gPiB1c2luZyBoYXJkd2FyZSBwYXJhbGxlbGlzbSBpbiB0
aGUgaWFhX2NyeXB0byBkcml2ZXIgYW5kIGFub3RoZXIgcHJvb2YNCj4gcG9pbnQNCj4gPiA+IHdp
dGggYSBzZXF1ZW50aWFsIHNvZnR3YXJlIGNvbXByZXNzb3IsIHpzdGQuDQo+ID4NCj4gPiBBbnkg
cGxhbiBvbiBkb2luZyBoYXJkd2FyZSBhY2NlbGVyYXRlZC9vZmZsb2FkZWQvcGFyYWxsZWxpemVk
IHpzdGQ/IDopDQo+ID4NCj4gPiA+DQo+ID4gPiBTVU1NQVJZOg0KPiA+ID4gPT09PT09PT0NCj4g
PiA+DQo+ID4gPiAgIFRoZSBmaXJzdCBwcm9vZiBwb2ludCBpcyB0byB0ZXN0IHdpdGggSUFBIHVz
aW5nIGEgc2VxdWVudGlhbCBjYWxsIChmdWxseQ0KPiA+ID4gICBzeW5jaHJvbm91cywgY29tcHJl
c3Mgb25lIHBhZ2UgYXQgYSB0aW1lKSB2cy4gYSBiYXRjaGluZyBjYWxsIChmdWxseQ0KPiA+ID4g
ICBhc3luY2hyb25vdXMsIHN1Ym1pdCBhIGJhdGNoIHRvIElBQSBmb3IgcGFyYWxsZWwgY29tcHJl
c3Npb24sIHRoZW4gcG9sbA0KPiBmb3INCj4gPiA+ICAgY29tcGxldGlvbiBzdGF0dXNlcykuDQo+
ID4gPg0KPiA+ID4gICAgIFRoZSBwZXJmb3JtYW5jZSB0ZXN0aW5nIGRhdGEgd2l0aCB1c2VtZW0g
MzAgcHJvY2Vzc2VzIGFuZCBrZXJuZWwNCj4gPiA+ICAgICBjb21waWxhdGlvbiB0ZXN0IHVzaW5n
IDMyIHRocmVhZHMsIHNob3cgNjclLTc3JSB0aHJvdWdocHV0IGdhaW5zIGFuZA0KPiA+ID4gICAg
IDI4JS0zMiUgc3lzIHRpbWUgcmVkdWN0aW9uICh1c2VtZW0zMCkgYW5kIDItMyUgc3lzIHRpbWUg
cmVkdWN0aW9uDQo+ID4gPiAgICAgKGtlcm5lbCBjb21waWxhdGlvbikgd2l0aCB6c3dhcF9zdG9y
ZSgpIGxhcmdlIGZvbGlvcyB1c2luZyBJQUEgY29tcHJlc3MNCj4gPiA+ICAgICBiYXRjaGluZyBh
cyBjb21wYXJlZCB0byBJQUEgc2VxdWVudGlhbC4NCj4gPiA+DQo+ID4gPiAgIFRoZSBzZWNvbmQg
cHJvb2YgcG9pbnQgaXMgdG8gbWFrZSBzdXJlIHRoYXQgc29mdHdhcmUgYWxnb3JpdGhtcyBzdWNo
IGFzDQo+ID4gPiAgIHpzdGQgZG8gbm90IHJlZ3Jlc3MuIFRoZSBkYXRhIGluZGljYXRlcyB0aGF0
IGZvciBzZXF1ZW50aWFsIHNvZnR3YXJlDQo+ID4gPiAgIGFsZ29yaXRobXMgYSBwZXJmb3JtYW5j
ZSBnYWluIGlzIGFjaGlldmVkLg0KPiA+ID4NCj4gPiA+ICAgICBXaXRoIHRoZSBwZXJmb3JtYW5j
ZSBvcHRpbWl6YXRpb25zIGltcGxlbWVudGVkIGluIHBhdGNoZXMgMTggYW5kIDE5DQo+IG9mDQo+
ID4gPiAgICAgdjksIHpzdGQgdXNlbWVtMzAgdGhyb3VnaHB1dCBpbmNyZWFzZXMgYnkgMSUsIGFs
b25nIHdpdGggYSA2JS04JSBzeXMNCj4gdGltZQ0KPiA+ID4gICAgIHJlZHVjdGlvbi4gV2l0aCBr
ZXJuZWwgY29tcGlsYXRpb24gdXNpbmcgenN0ZCwgd2UgZ2V0IGEgMC40JS0zLjIlDQo+ID4gPiAg
ICAgcmVkdWN0aW9uIGluIHN5cyB0aW1lLiBUaGVzZSBvcHRpbWl6YXRpb25zIHBlcnRhaW4gdG8g
Y29tbW9uIGNvZGUNCj4gPiA+ICAgICBwYXRocywgcmVtb3ZpbmcgcmVkdW5kYW50IGJyYW5jaGVz
L2NvbXB1dGVzLCB1c2luZyBwcmVmZXRjaHcoKSBvZg0KPiB0aGUNCj4gPiA+ICAgICB6c3dhcCBl
bnRyeSBiZWZvcmUgaXQgaXMgd3JpdHRlbiwgYW5kIHNlbGVjdGl2ZWx5IGFubm90YXRpbmcgYnJh
bmNoZXMNCj4gPiA+ICAgICB3aXRoIGxpa2VseSgpL3VubGlrZWx5KCkgY29tcGlsZXIgZGlyZWN0
aXZlcyB0byBtaW5pbWl6ZSBicmFuY2gNCj4gPiA+ICAgICBtaXMtcHJlZGljdGlvbiBwZW5hbHR5
LiBBZGRpdGlvbmFsbHksIHVzaW5nIHRoZSBiYXRjaGluZyBjb2RlIGZvcg0KPiA+ID4gICAgIG5v
bi1iYXRjaGluZyBjb21wcmVzc29ycyB0byBzZXF1ZW50aWFsbHkgY29tcHJlc3Mvc3RvcmUgYmF0
Y2hlcyBvZiB1cA0KPiA+ID4gICAgIHRvIFpTV0FQX01BWF9CQVRDSF9TSVpFICg4KSBwYWdlcyBz
ZWVtcyB0byBoZWxwLCBtb3N0IGxpa2VseSBkdWUgdG8NCj4gPiA+ICAgICBjYWNoZSBsb2NhbGl0
eSBvZiB3b3JraW5nIHNldCBzdHJ1Y3R1cmVzIHN1Y2ggYXMgdGhlIGFycmF5IG9mDQo+ID4gPiAg
ICAgenN3YXBfZW50cnktcyBmb3IgdGhlIGJhdGNoLg0KPiA+DQo+ID4gTmljZSENCj4gPg0KPiA+
ID4NCj4gPiA+ICAgICBPdXIgaW50ZXJuYWwgdmFsaWRhdGlvbiBvZiB6c3RkIHdpdGggdGhlIGJh
dGNoaW5nIGludGVyZmFjZSB2cy4gSUFBIHdpdGgNCj4gPiA+ICAgICB0aGUgYmF0Y2hpbmcgaW50
ZXJmYWNlIG9uIEVtZXJhbGQgUmFwaWRzIGhhcyBzaG93biB0aGF0IElBQQ0KPiA+ID4gICAgIGNv
bXByZXNzL2RlY29tcHJlc3MgYmF0Y2hpbmcgZ2l2ZXMgMjEuMyUgbW9yZSBtZW1vcnkgc2F2aW5n
cyBhcw0KPiBjb21wYXJlZA0KPiA+ID4gICAgIHRvIHpzdGQsIGZvciA1JSBwZXJmb3JtYW5jZSBs
b3NzIGFzIGNvbXBhcmVkIHRvIHRoZSBiYXNlbGluZSB3aXRob3V0DQo+IGFueQ0KPiA+ID4gICAg
IG1lbW9yeSBwcmVzc3VyZS4gSUFBIGJhdGNoaW5nIGRlbW9uc3RyYXRlcyBtb3JlIHRoYW4gMlgg
dGhlDQo+IG1lbW9yeQ0KPiA+ID4gICAgIHNhdmluZ3Mgb2J0YWluZWQgYnkgenN0ZCBhdCB0aGlz
IDk1JSBwZXJmb3JtYW5jZSBLUEkuDQo+ID4gPiAgICAgVGhlIGNvbXByZXNzaW9uIHJhdGlvIHdp
dGggSUFBIGlzIDIuMjMsIGFuZCB3aXRoIHpzdGQgMi45Ni4gRXZlbiB3aXRoDQo+ID4gPiAgICAg
dGhpcyBjb21wcmVzc2lvbiByYXRpbyBkZWZpY2l0IGZvciBJQUEsIGJhdGNoaW5nIGlzIGV4dHJl
bWVseQ0KPiA+DQo+ID4gSSdtIGNvbmZ1c2VkLiBIb3cgZG9lcyBJQUEgZ2l2ZSBtb3JlIG1lbW9y
eSBzYXZpbmdzLCB3aGlsZSBoYXZpbmcgYQ0KPiA+IHdvcnNlIGNvbXByZXNzaW9uIHJhdGlvPyBI
b3cgZG8geW91IGRlZmluZSBtZW1vcnkgc2F2aW5ncyBoZXJlPw0KPiA+DQo+ID4gPiAgICAgYmVu
ZWZpY2lhbC4gQXMgd2UgaW1wcm92ZSB0aGUgY29tcHJlc3Npb24gcmF0aW8gb2YgdGhlIElBQSBh
Y2NlbGVyYXRvciwNCj4gPiA+ICAgICB3ZSBleHBlY3QgdG8gc2VlIGV2ZW4gYmV0dGVyIG1lbW9y
eSBzYXZpbmdzIHdpdGggSUFBIGFzIGNvbXBhcmVkIHRvDQo+ID4gPiAgICAgc29mdHdhcmUgY29t
cHJlc3NvcnMuDQo+ID4gPg0KPiA+ID4NCj4gPiA+ICAgQmF0Y2hpbmcgUm9hZG1hcDoNCj4gPiA+
ICAgPT09PT09PT09PT09PT09PT0NCj4gPiA+DQo+ID4gPiAgIDEpIENvbXByZXNzaW9uIGJhdGNo
aW5nIHdpdGhpbiBsYXJnZSBmb2xpb3MgKHRoaXMgc2VyaWVzKS4NCj4gPiA+DQo+ID4gPiAgIDIp
IFJlY2xhaW0gYmF0Y2hpbmcgb2YgaHlicmlkIGZvbGlvczoNCj4gPiA+DQo+ID4gPiAgICAgIFdl
IGNhbiBleHBlY3QgdG8gc2VlIGV2ZW4gbW9yZSBzaWduaWZpY2FudCBwZXJmb3JtYW5jZSBhbmQN
Cj4gdGhyb3VnaHB1dA0KPiA+ID4gICAgICBpbXByb3ZlbWVudHMgaWYgd2UgdXNlIHRoZSBwYXJh
bGxlbGlzbSBvZmZlcmVkIGJ5IElBQSB0byBkbyByZWNsYWltDQo+ID4gPiAgICAgIGJhdGNoaW5n
IG9mIDRLL2xhcmdlIGZvbGlvcyAocmVhbGx5IGFueS1vcmRlciBmb2xpb3MpLCBhbmQgdXNpbmcg
dGhlDQo+ID4gPiAgICAgIHpzd2FwX3N0b3JlKCkgaGlnaCB0aHJvdWdocHV0IGNvbXByZXNzaW9u
IHBpcGVsaW5lIHRvIGJhdGNoLWNvbXByZXNzDQo+ID4gPiAgICAgIHBhZ2VzIGNvbXByaXNpbmcg
dGhlc2UgZm9saW9zLCBub3QganVzdCBiYXRjaGluZyB3aXRoaW4gbGFyZ2UNCj4gPiA+ICAgICAg
Zm9saW9zLiBUaGlzIGlzIHRoZSByZWNsYWltIGJhdGNoaW5nIHBhdGNoIDEzIGluIHYxLCB3aGlj
aCB3ZSBleHBlY3QNCj4gPiA+ICAgICAgdG8gc3VibWl0IGluIGEgc2VwYXJhdGUgcGF0Y2gtc2Vy
aWVzLg0KPiA+DQo+ID4gQXJlIHlvdSBhd2FyZSBvZiB0aGUgY3VycmVudCBrY29tcHJlc3NkIHdv
cms6DQo+ID4NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTA0MzAwODI2NTEu
MzE1MjQ0NC0xLXF1bi0NCj4gd2VpLmxpbkBtZWRpYXRlay5jb20vDQo+ID4NCj4gPiBJdCBiYXNp
Y2FsbHkgb2ZmbG9hZHMgY29tcHJlc3Npb24gd29yayBpbnRvIGEgc2VwYXJhdGUga2VybmVsIHRo
cmVhZA0KPiA+IChrY29tcHJlc3NkKSwgZm9yIGtzd2FwZCByZWNsYWltLg0KPiA+DQo+ID4gVGhp
cyBtaWdodCBwcm92aWRlIHlvdSB3aXRoIGEgbW9yZSBuYXR1cmFsIHBsYWNlIHRvIHBlcmZvcm0g
YmF0Y2gNCj4gPiBjb21wcmVzc2lvbiAtIGluc3RlYWQgb2YgY29tcHJlc3Npbmcgb25lIHBhZ2Ug
YXQgYSB0aW1lIGZyb20gdGhlDQo+ID4gd29ya2VyIHRocmVhZCdzIHF1ZXVlLCB5b3UgY2FuIGdy
YWIgYSBiYXRjaCB3b3J0aCBvZiBwYWdlcyBhbmQgZmVlZCBpdA0KPiA+IHRvIElBQS4NCj4gPg0K
PiA+IERvd25zaWRlIGlzIGl0IG9ubHkgYXBwbGllcyB0byBpbmRpcmVjdCByZWNsYWltLiBQcm9h
Y3RpdmUgYW5kIGRpcmVjdA0KPiA+IHJlY2xhaW1lcnMgYXJlIG5vdCBjb3ZlcmVkLCB1bmZvcnR1
bmF0ZWx5Lg0KPiA+DQo+ID4gPg0KPiA+ID4gICAzKSBEZWNvbXByZXNzaW9uIGJhdGNoaW5nOg0K
PiA+ID4NCj4gPiA+ICAgICAgV2UgaGF2ZSBkZXZlbG9wZWQgYSB6c3dhcCBsb2FkIGJhdGNoaW5n
IGludGVyZmFjZSBmb3IgSUFBIHRvIGJlIHVzZWQNCj4gPiA+ICAgICAgZm9yIHBhcmFsbGVsIGRl
Y29tcHJlc3Npb24gYmF0Y2hpbmcsIHVzaW5nIHN3YXBpbl9yZWFkYWhlYWQoKS4NCj4gPiA+DQo+
ID4gPiAgIFRoZXNlIGNhcGFiaWxpdGllcyBhcmUgYXJjaGl0ZWN0ZWQgc28gYXMgdG8gYmUgdXNl
ZnVsIHRvIHpzd2FwIGFuZA0KPiA+ID4gICB6cmFtLiBXZSBhcmUgYWN0aXZlbHkgd29ya2luZyBv
biBpbnRlZ3JhdGluZyB0aGVzZSBjb21wb25lbnRzIHdpdGgNCj4genJhbS4NCj4gPg0KPiA+IFll
YWggcHJvYmxlbSB3aXRoIHJlYWRhaGVhZCBpcyB5b3UgY2FuIHBvdGVudGlhbGx5IGdldCBkaWZm
ZXJlbnQNCj4gPiBiYWNrZW5kcyBpbiB0aGUgYmF0Y2gsIGFuZCBtb2RpZnlpbmcgcmVhZGFoZWFk
IGNvZGUgaXMgcHJldHR5IHVnbHkgOikNCj4gPiBCdXQgd2UnbGwgc2VlLi4uDQo+ID4NCj4gDQo+
IEFub3RoZXIgcGxhY2Ugd2hlcmUgeW91IGNhbiBkbyBkZWNvbXByZXNzaW9uIGJhdGNoaW5nIGlz
IGZvciB6c3dhcA0KPiB3cml0ZWJhY2sgOikgUmlnaHQgbm93LCB3ZSBhcmUgZGVjb21wcmVzc2lu
ZyB0aGUgcGFnZXMgYW5kIHdyaXRpbmcNCj4gdGhlbSBiYWNrIG9uZSBwYWdlIGF0IGEgdGltZS4g
WW91IGNhbiwgaG93ZXZlciwgZ3JhYiBhIGJhdGNoIHdvcnRoIG9mDQo+IHRoZW0sIGZlZWQgdG8g
SUFBIGZvciBwcm9jZXNzaW5nLCBiZWZvcmUgc3VibWl0dGluZyB0aGVtIGFsbCBmb3IgSU8gOikN
Cg0KVGhhbmtzIE5oYXQsIGdyZWF0IGlkZWEhDQoNCj4gDQo+IEkgaGF2ZSBhIHByb3RvdHlwZSB0
aGF0IHBlcmZvcm0gYmF0Y2ggd3JpdGViYWNrIChtb3N0bHkgZm9yIElPDQo+IGVmZmljaWVuY3kg
cHVycG9zZSkgLSBsbWsgaWYgeW91IHdhbnQgdG8gcGxheSB3aXRoIGl0LiBQcm9ibGVtLCBhcw0K
PiB1c3VhbCwgaXMgYmVuY2htYXJraW5nIDopDQoNClN1cmUuIFBsZWFzZSBkbyBzaGFyZSB0aGUg
cGF0Y2ggaW1wbGVtZW50aW5nIHRoZSBiYXRjaCB3cml0ZWJhY2sNCmFuZCBJIGNhbiBnaXZlIHRo
aXMgYSB0cnkuDQoNClRoYW5rcywNCkthbmNoYW5hDQoNCg==
