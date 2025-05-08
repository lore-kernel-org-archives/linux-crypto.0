Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28FD1DF97F;
	Thu,  8 May 2025 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746732630; cv=fail; b=ezFB20BldH4nbyOaPq3E/yvubR1c6hqwqOwz194oQcYzgEPL7EksiqTzzJLUiQrV9tpWt9+sKJRgTOme43N6CHq7aqIEBh2EozUkBf+6boEWX+tFaKG8f7VEtobLjg9Z2JfBvL2LzASW3QWbmspfllA9qDwqIKsIPr5zmUZLY0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746732630; c=relaxed/simple;
	bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SJW2qv/CpogEcYxpKEZt0ZxWeBxpHtI/7X4K/D6n9g3NDsRkJO0cWQfzbofIZjcsAzJ2NANKcyQrNJ2jI+mFVuQy/ZjDWxLNVTrafKVCa+VXTGVNKknGBQpV4CfjdHG0t4BB/28Cve3OrGnZ5Xwp/1f4uU1pLRpC7ss2SR47c+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxbHQSWq; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxbHQSWq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746732629; x=1778268629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
  b=HxbHQSWqLvQ/zCQhDXEbF26yf1UMJW/7eWd65BWjtyowBl+FgToGspM6
   9NuA01EXktoOWIY70db+zbhfnbOkelj4sVy69wK/5eCXuiO+BoPu0vEFr
   VQDO+JkBZgOuOxkNrR5tFCAmTe3TBR5nDLsuBdMhW7lUpFKSt04VnO+xl
   PNqZ1WLjJA6di2zY7Jp2gnckr+TUvBH84NEQX/jCqaCc2kSlHqtVn58e0
   GrckIA4vWNEH63y966PSkRdRCFYiNkbbZ58QXooCmBJ6QLma7j7RFMGxo
   SpiClsOl5BzjBEGfOzocE1zf0R+AzTU6qeU3O31dRDuNaXBBXee/8KhhL
   w==;
X-CSE-ConnectionGUID: gE77qNToRoiskIqDKxUALg==
X-CSE-MsgGUID: fJyFtjZvQISKWhad0fRVfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48247238"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48247238"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:30:28 -0700
X-CSE-ConnectionGUID: Y0zDGPMdTKi9BHOX4seZfw==
X-CSE-MsgGUID: iXvKGJs7SvOdGJC86hgBlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="173574829"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:30:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 12:30:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 12:30:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 12:30:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZTAGrM6vRhJbDPkdK4pCgsfAarqRrcaRA583PImZNUElYXEmAOjcxbvDNHVdBSP1zyIAbOyndEazUklBNsfaXtN/KFg/j4KRI0ZA7fs4H4mR3x5lQeLaE9d7rFOCBSwCdyay027ldgjEIeRqlVTZD+Bo+OXQ3/DxP2FgcEaQImWKzqKzMohNpUNNmWl55SGifut4kSu3AVo9NBsVWvu5OEKI/Og3syLFePbUPkga4qprQJT9qWodREClcq6EZPjA6pLYcQWHAvUgWWAhogxOzW2OZu7PtCdsVBxfm6IWGHKECU+W4JUxUb8YwkoFRAUXPfrSpihgHP+WdCZG5O+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
 b=qxWQPtBdxJKFn4uu17KfDDQeaPIVazLGUgDz8DWOqvOkO8zuZLULoC2tJXHo+cXX6QuAAfsN4O2MeYiq3At9PuQeiK+a3Q07XwGVH1GGyS2aDUVMYIVHMPCuH/5lLkTKKQkwEsDZNGN0rBc3SSG6C2YgLUALN3xpYZXUcxEP0TIrxVRULtuGrp2EbBWQbv2JTn2VAX2HSgZ9JgLQMGp8DH0r9YKvSV70MRNpdVqZ16do5L4s82KfH2YWGsmNmzabuhg5CwlZN2nuYipHh8TxPSScPWgvGn8WQTy+B+2wKdAUQSesKXzkUkw6a8D1NpUx+yrznMQ+ghLfgnH8xOFbdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Thu, 8 May 2025 19:30:11 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 19:30:11 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>
CC: "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v9 01/19] crypto: acomp - Remove request chaining
Thread-Topic: [PATCH v9 01/19] crypto: acomp - Remove request chaining
Thread-Index: AQHbuhHmydvYArLhLE6Oh9X3tNyZqrPJKsvA
Date: Thu, 8 May 2025 19:30:11 +0000
Message-ID: <PH7PR11MB812131A02A68DBB9E3B84EE7C98BA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
 <20250430205305.22844-2-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250430205305.22844-2-kanchana.p.sridhar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DS7PR11MB7781:EE_
x-ms-office365-filtering-correlation-id: c5152a54-801b-42ff-8206-08dd8e66bfc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?OXgNcfXxDjmDiFiTXUOUFPXF1HZlAdELe2eO6i/Flvj6rSL1o0Syn09hLnrd?=
 =?us-ascii?Q?enfPst7yYMO+NgctlS0xXhXqXim7U577FwyTgo7h91PUvOcxMUvWffp5UKUy?=
 =?us-ascii?Q?I5V+gjAhGIASGOFw5zPcUvTZTJ8SP3JWwSw9SephSDaLAF8HkKWIJ0jHoNnu?=
 =?us-ascii?Q?Exz2h2njekJ5Jtv3iEBH/Xs6yVrjaR1wpWv89hqtbQt4tgoJPvtTVFvDLxlz?=
 =?us-ascii?Q?5QhdYNto2a6CNMvXxmuAfkm284uSq8L3s8wahLK3opkRXAgTJbC8vvOZd776?=
 =?us-ascii?Q?utZ8uaHHCloyogTHaxg4yu/GYUg+4SyOa20K9zM1LzigzG5StHmyN2gTleYi?=
 =?us-ascii?Q?DOKrJc8FYEvOvurPjKZIoAf1ze8uEkzxLG67ysvpzOptXg+FXUqMcqFU333/?=
 =?us-ascii?Q?ezY1Faqwo1KL7VkJ0H0/iLn0uChm/KfrOHKH5o34udUigRB4CnzHrewr//5s?=
 =?us-ascii?Q?DX3UmsG5zEQ0hCJHBcdLX/CoGbszxFRTMp316C1niknXt8s5i7SGLe/bhzmo?=
 =?us-ascii?Q?TbGbrmFKbkREgIDMBsh8KMQ31CtcUp6lsUsrYQztL4+tztPIW5vG58UiVEnu?=
 =?us-ascii?Q?EKErL289cq47i2C0SifqN5s1w28zV87RPqferVzcIEh4H8qZBeMkSUGfyNx2?=
 =?us-ascii?Q?cxMFqJ+6+VK7iL45Yv6JLV3Hpi2EXGDJp86XWcgY1G9fDp+tu4zBgmuzss0R?=
 =?us-ascii?Q?VTJ6W/l4H68jDx7SEBkngfzGpluN0RZnDZujV9OHyG6sBl5Dz//1P3inoDDn?=
 =?us-ascii?Q?DqH2zhz8KZTn9YyUIx3LSnzfTz+N+ZYVcn0JQ+yFPFW1k7ttYPLVlYxw/swA?=
 =?us-ascii?Q?EaHOGS/Q/CTSISGi2LsWM50QPgALy3O/vLhGM3P+GHY4FfdmubiAddoJrqsW?=
 =?us-ascii?Q?s/YswavteieEy2YufyiXP2n0hm6IKaoFuEG+/e5cbb6XHL+z3q77xFfjMgsT?=
 =?us-ascii?Q?u/enZtsMXPY4fR1QOaB8SpdapJIMyrQ4ThgsamRJSyWXV1glx02M2SUJt74r?=
 =?us-ascii?Q?KY+YXfzS+YrKrrkbddW36mIrNcWN0uGNimx371WlhwPUTvF3KaHFT5xiUmGn?=
 =?us-ascii?Q?mmPb2Fb5JJ9fytgVSv9VJQp2xW93Zb9k8Ln8t+l8IAjHL0YYECTO9LWZ7XyV?=
 =?us-ascii?Q?+uInhZNMx6ohz0UcxXuT29ss3opG2JUOAWLGpivRM9E8pRUmb60+eJGhPNTj?=
 =?us-ascii?Q?eTLBXQce64h5ttzIgcI8LhtM0CVOUW0KEGI9REru24W2UDiELiw4LIsuQkVS?=
 =?us-ascii?Q?4z7wOj1RxTyP1vYAfeVLVSoGJoot/zqdKUnyq7NhF0cyW7jvk5pPtQhmXZAu?=
 =?us-ascii?Q?Mi/yeWIQbuVDfh/qlHo1GXLCqpM8AuJxq3WAInZIofcP4GRNSFe/oT8C8c+R?=
 =?us-ascii?Q?m0WD4xyHsw9xQ8Vr1oJBWcJnu7Rgn1xhckeje3asr9ZXr7xIEfO74KUk8MZp?=
 =?us-ascii?Q?6BTgbSDqXUtmZ6fIOSiGvjum5fqwvwXCdPx6bgwpoRiLQiawRHM7WG5KwxIq?=
 =?us-ascii?Q?3qUHO9/rdx384F0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rq3A7cTpgupeM8xVD13H2hTMJ/XHgROnwsi6thHHQw+JIe25jYjnikqXzu42?=
 =?us-ascii?Q?qnOSyiklV1m+HfA58SLHsTUZNnJRww/4Z0h0J7xq+rQWYf1Qhenn3DwOnZ2+?=
 =?us-ascii?Q?XTQH8kzESnUjxlU18TsvT9FLfUsPRuD1J+0pt+UoCrRZt4CVRBW2/5HBtyg2?=
 =?us-ascii?Q?n6xYdgINF52bYL7IZz5ojE/5CBHbq9RhiOh24dBrCIQVOIRNh32nRZI/3mf9?=
 =?us-ascii?Q?AF90WEk8EExsURfk1eASR8B0UTpMEmy8l/YPN8xA6kZcqw8zYNmdlULuK1sW?=
 =?us-ascii?Q?7/OB+6eovvW0a7DvxsUsfSM31wLrLX466/aEeElxpNnBzGDr9tN0PKuXh9UM?=
 =?us-ascii?Q?SBIIqWyCKUsdVfPJgWD2ycjCbiQJCn71hHvHZYA5Ug04mt+DRrcTcagixSjq?=
 =?us-ascii?Q?4q2hnO7yD+W+FAmnd+SIz6fWTmWvC1JJB+uvd0PLtOklLFF21gnFm55b+J96?=
 =?us-ascii?Q?q8iELN1CQ0bvWb7qQiUjbMgKc11AGA/hbezCc+aONlhu+xIWJ+gmJy7GUcWm?=
 =?us-ascii?Q?rAlrMVzQC6C/7gbZmZ5sS+fWXa68Y80+B0l0faa5NnW6+SqkMnH9GubzNOfM?=
 =?us-ascii?Q?I5Keh5I0F4jA2jOoXXA/J0fMEQY0ahJDh34yjqJU6jvaXQQCSmQFAZVl7+WN?=
 =?us-ascii?Q?xD0U3++rrXLUNIwQwZREZBNSRbVS9/uM8n6ciaAyiYTGM18c/TuP3J85SZnC?=
 =?us-ascii?Q?MMIAmypUhgacIL4rxfDB3gr1TGz3lEZB0V5DTAWcRTEHoWKw8d/kshqWMh03?=
 =?us-ascii?Q?GBsGIQ2z7KgrNoRo8Zrnpon8U34u1X7lvH4+MDYMj4sN2i3QjEV99sHf+PsI?=
 =?us-ascii?Q?QtE3tyGrDj2QjsvN3Bap0oOK32DHpmmkLgGmmfp5/c7QITT8bC3Fhrm38QIu?=
 =?us-ascii?Q?papB1xV0o/ahkYCJ+i6m2NwlLX9CG+oF2y9/DF6qDKChM+O6pq0Lu0yCkQAR?=
 =?us-ascii?Q?smhTd3/crfvt2klqyYOEfdhMA9v2jy/m6Ln+JFjDuCuTubdvtCmJVZPhPM1I?=
 =?us-ascii?Q?V+y0TAZgpjO/dSpiQEkifMiLFSQ1wKbPcwa1t/YMaP7xNVtCb4HLm8A5KToi?=
 =?us-ascii?Q?/SuWpf6HrfsZfwh7MaovJevcq/ctHr+J5f4WsKrVAX61X30Hd7H3DK/gjLoW?=
 =?us-ascii?Q?lffhAgvrhaTlcOeWah2tndWfp/tkcT3xPDHYt+UKbSajD0E4+tswJ74KO8DE?=
 =?us-ascii?Q?u/M+FTOpYXX+suDVObzAS1N8Pl8dUfpvVarHaYqtHbb3ui2ViDZDtr6FrGsr?=
 =?us-ascii?Q?U5fni72d2x7MmtCK0vA5Euy2yCgitLCmf1yR97qBz5ULTlXZADrr09LBmMgx?=
 =?us-ascii?Q?0FehVgLBXbCtZH46a98tnuGiqg7x/VQLxYISdrUETXUUjUyRTEtMMEUWZ60F?=
 =?us-ascii?Q?3mE3UuO7YznIcGlS5eRPt5Vv10MlTSZgSCe1AlAyGDayiiQk2SWVbTFyBmWy?=
 =?us-ascii?Q?ssVcEf+irtIEo7h5/EkmZY6d8Wptp0Kmro3/49alD+EgO9uGPZRtgqwDZIuU?=
 =?us-ascii?Q?bl99A+NPuMSNuMYsdf+LLgxc39XaNKepphxkkUvpwCL6qJsbzCjVJktQSyev?=
 =?us-ascii?Q?HbB8bnBz8xQdXo+slaXdQf4XP0VuwAiVxq/yWdRxzEVWKUAdZ7aU90GNKInw?=
 =?us-ascii?Q?1Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c5152a54-801b-42ff-8206-08dd8e66bfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 19:30:11.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7E1T4F1nVooU9gnVlktsSEZF1wHRyjwYCUC4an+DlhAfKG7c6xj6qCDgF9kd1hPXnfg/2MAOUAh9r/rSV1YSV1QOICWNn0VjPZn1ysoV2cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
X-OriginatorOrg: intel.com

Adding Sergey.

