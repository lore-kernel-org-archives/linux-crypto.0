Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0E01DED62;
	Tue, 18 Mar 2025 23:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742341060; cv=fail; b=iPZXbGkPo8U//SRGreAV6BnZUxn+hAw8HOm3u1WZ1MvjVV8ZpuV3hq9WSalAVmLyeisbOQpipitqmpXplT9ba14tqDJwAZyhgGZg/QnEhjCuox3qoYdjLyk+GLq5fk6KOFJW64okM9RoLaoCqT4U5QW2WL/sWry5iQgwBDKJOsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742341060; c=relaxed/simple;
	bh=qO2KxsugEwcrGmeoKOZhHbbz2AfjnvmL8mqQpxQWmQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u+WTGRMt32wBxuraFw0tLbOoSTwhAQZhAeWUuCkdcnGIoFZA2ZAGXBXNAF5i+L6EzTIPWembZP7wT5lgSqOa4/4QZEOdemwGJmnM9UPXvUA9BG+26357ML3We4/STjfDGX4gyMXuI+Yl2QAU21bpQQnMy4S7a597YZGegqxsw+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKVrSUJl; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKVrSUJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742341059; x=1773877059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qO2KxsugEwcrGmeoKOZhHbbz2AfjnvmL8mqQpxQWmQs=;
  b=MKVrSUJl1VCjSMv8g5tSTq/LkDFl8jmco0JW6QnCQ0B9JvLPWrHirwjq
   8wd9Q2FDMxQsi6oMqM0bLAPRoWPv4wyKiBoO5LqirsyfE6WBDS3AhL+Oa
   DCAkRsb9cUOGJRyjSp/z5q7u5jeqjV4G5n86iJXoNrsTCMFaH1+bcXoty
   MqGtT3mv7B7H/zRBe6/XUPwN0yNyBCVOcoELvIEfTDI3jCEuemB/nBhws
   +ZjJ+BhC9qOkb99biX+l2JIhHNOfQYvQXZIzgwRRryVS0/fexteqhdfkf
   y/NciknGqWdmVzzAArYIg49xbA1d5Uru7+wck2ri+ES/SkapxQGy+NtCv
   w==;
X-CSE-ConnectionGUID: xzDIERGtRC63mYn8Hh2A/g==
X-CSE-MsgGUID: Nbxrs56aQQe16w21MpRrPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="54143827"
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="54143827"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 16:37:37 -0700
X-CSE-ConnectionGUID: JdBYEeu5QHuzCZUl5zVQWg==
X-CSE-MsgGUID: BA3IoMGATqybomMJKKUFBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,258,1736841600"; 
   d="scan'208";a="122880222"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 16:37:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Mar 2025 16:37:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Mar 2025 16:37:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 16:37:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CL1MvR7tfMCP+Pu2qJs2tx8j3Vc76P+d7npeuaZl8mALPHhArDqrKrT7NtGNisNzNLeOyvGXb9R+diyMEPVToe7xEMuSz0ip8HHcBZ4QOzBcekvi3GTq8yXnOUh/LEiCcHEYdy+i69pGaxeis1ia7fxOhyOVyMq75xV70F5KDJeSrIns+Mw0D4uKbehfmIuH0BwiuK1//nlBFe1zZbtJx9R7fx2xp7sOd1LAqR3rJV3tBii4u5ZTvob+nLi/huOc+Im+Fz5eg9Ew00N5yWKPoTM5remYAdBPriif6NuRFlJ4Ud41tgzGSq5+UJs2xd6VXA7cErrTaiDOGpRr0Qqc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7NaDTruPlL1BFQpRkE4OhilmLlM13EEwG/G5MjOCtA=;
 b=yYXfVzzbgddKgMHtNCWIjnGv0cTULLUny8KJ/rs+NKHwEeYjixsJeeLQdwxKsth66jBDQqfNpXrrB5jCoPUM+jKDb/dtQoe16bmL1rBs6chKJDroGHzpMJt8Hip1r4i7k3h+L0URSFqeelNT6auCvtGhyHx1BgZmDCyW3o2P6bjbJDxdWyfmBn3z+QUHmkHQpzKgS0ggEaOosmkROfPZlPJbyQpCFsfk+q5dXBlSOLAELoMWmdfe7JwFc7MFOdHD7/4QaRDEAVxP7zNPlHzwKt4t4vIchCPmLFjiiYQywme9XqQgZKQeGsGAfWnXOiNylpDJQpkdVO8Dq1YOwJ/KBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH7PR11MB6955.namprd11.prod.outlook.com (2603:10b6:510:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 23:37:33 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 23:37:33 +0000
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
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hCAAVPdAIAAYjdggAQziACACyMtkIABOxcAgAAmLoCAACiqAIAAHucggAAmeQCAAAZeUA==
Date: Tue, 18 Mar 2025 23:37:33 +0000
Message-ID: <SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com>
 <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9nECMZW67F8XYoV@google.com>
 <SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9n-OnGPK7BOdGxR@google.com>
In-Reply-To: <Z9n-OnGPK7BOdGxR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH7PR11MB6955:EE_
x-ms-office365-filtering-correlation-id: ddcf233b-efe5-4f85-4f63-08dd6675db82
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?OTSKtB2SLf/G5BA+NDdnjpvjk+xJ1gKqqegFTAlDc/jh5AkaOPTkzzdDMrVj?=
 =?us-ascii?Q?m9waGCSyJiizbf4yz9O4Cv5d+XFeh2MLkWxPvv5F+6H61djnpW4k01FbGsNX?=
 =?us-ascii?Q?qXLAKneWq+TnsPkWHleQqSGyISPHcqQ43a4SAJ2S6feh9C3yC4OxlhzPJ4V2?=
 =?us-ascii?Q?C+0bTNysAP1Cq/x3OOa4eKrTqp0h1ZgN9blPqqTf/SV+jcu+n7ZMCviw+N/Q?=
 =?us-ascii?Q?wr+hDFonYbauPe8CS6FA4ZZy9alxz1OJYswvn2lvR7+DT0BD8w7367mySJnH?=
 =?us-ascii?Q?aGt2BQ37bKT/66hDCNCY2UAevSVi0cAR16AgD1qJ8U5F1CCpOqh/lBY5kCRO?=
 =?us-ascii?Q?bUL29BJszmffEzuzL+Wnpgsprgmq8IEc5HfvqrBBXn/Fw6JqXWaIohCbsKDb?=
 =?us-ascii?Q?k5SIBxZtIZuJv2ay/2qsgjeo7Spcrf6JGx+B4eMfJAIeCgpHMQWv18jMnpJR?=
 =?us-ascii?Q?euxYsoUB2mltKEXpwa74DdaLZ7q3bY0+V6VezT33O+uPgv9C8F7A/tcFdL2p?=
 =?us-ascii?Q?Y/pUEAkFsmszNitzoiDhdu+4XpwG+rFrCEFdtKnN/5uL5/8B4RLxwzYtkIeB?=
 =?us-ascii?Q?5VBnvnO/fVNH0fR/BFdaqj5NeLoGpBvtUPtowMmQcipPLOtnKuzoq6QsyGwb?=
 =?us-ascii?Q?1UrYMm/Fnb2gCVS0G9muygI4okabOuO82h9n70mfi+OcNy6PPjq3ZUe4YXQL?=
 =?us-ascii?Q?55m/Xgy1uJYrni/qXlgesWs2x3DoiTs7l9ITdqy2N2rphLXY7P+YTYUj4S4I?=
 =?us-ascii?Q?mR/Q4lniZbhOscK0XfXFQ4kp9IArRu2I52pT+ZtRPprknrVnBcH+Y8IwolZd?=
 =?us-ascii?Q?vGq8g7wvHzM3Ccl3s8NyUbBLngTkC0SuGY6QuRuol2c49QKO/hbb2kUufmzj?=
 =?us-ascii?Q?G3WyuY/gjIZP1RUIv6JaZolMX5Pem2T2Io0p55DVYuEAHaEeHyhiGGfeT/eL?=
 =?us-ascii?Q?hVjbWpA85qIbGowOA1PjSQXxtN3gpGpyWU4f1h7vxy9ir6Qv8id9chVEWHZv?=
 =?us-ascii?Q?CLbgfalflyH/fBhafiO539fTpUBWo1uP794etDwVKVPBC1kA+FoLRsbM3SMc?=
 =?us-ascii?Q?XqDY7jjnR0NtBcyECLGXY2/tS6YIrOx0IEKD/9RbebYZFf1kfqS6q4fjJD6L?=
 =?us-ascii?Q?F46mOjNQ8tt82sue4ZTQbwOn8J7EGMa4b6miInD+4grme7a5i1yhcII5uu/P?=
 =?us-ascii?Q?nAklKBc85BFQrqBD+5ugZlH9spn2TVnj0gmLAPopoXHjDx0tXZTI6oRGZLrL?=
 =?us-ascii?Q?4D8JS6zvAsmYOxnDfzPfhySTUSgH1gEAaO1OvMhgRsMVSBLfX18JOGUq2zdW?=
 =?us-ascii?Q?jjYKqRuXCoyybHcO7eN96HUJqzhyCcxae1sp1PYhnIs5i+NKBGXAbcsykHMe?=
 =?us-ascii?Q?sfcjFDpzZ07RCw0AJtcED9F3o21kH/PuK/Zhsbhl+YyxUafOyZYfzLjV+MoD?=
 =?us-ascii?Q?Ig+dWUhbijdh8ZSIcNcO0cryHBHULQIQ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YQQNUD9RKIQZA87zb13rfULdhSC/QVUvrUT2PzU9yd3kf40d4TJVOY5V9Q0m?=
 =?us-ascii?Q?Mbey+m3Fp0lKcckj8UnbDZ4JaB1H+s0vjs/H8A/asNrsG7/XNH0KpFwc2btK?=
 =?us-ascii?Q?5vEbideQ1FEzXnnypEFffOVfOD3ISaYQWxVQBH1x7sbOfGQaXtSthVH8+UcS?=
 =?us-ascii?Q?MZiehVm1JvV5iiR+A/6t+vdWTRGvXFM+GgPHUOHXvsU8OVSmirpiZAkxQweT?=
 =?us-ascii?Q?JMl9WfjLWZxzdXc2g4t/CFjaq9M1vY9zaFJDMVonsl8V2t/mEeCAbtx4YOWu?=
 =?us-ascii?Q?MW+00/K2kMlJpORTzgfCGkzx9j5TtJ/7hViy4WHuDScNRDl/XWF6dAHwhoR3?=
 =?us-ascii?Q?JaaLhwcX+GvGq3JS6iIGVivy1mapXQO54DuBHnFNpPuGddznYWa0MKnh0SG2?=
 =?us-ascii?Q?hpncBe96htSKnN+2sUUFatDiYpQRvTj7M1Bn+O7sEKzwYyzVSBxahPLWqu0l?=
 =?us-ascii?Q?yXra+wESHZJZDWA7Rdu7K9tGFIYkO6pHVV4fAYzeuT/+ywjuVPw7Su4jvU7C?=
 =?us-ascii?Q?1VCPGRfldzkxKBuU9zxQek69Bf6Bu7zYSgiucJCM2HpKrYdmbSpw1Mes2tqb?=
 =?us-ascii?Q?mYarAQwXsRlDJE7YJK+dJRJSL4bL16/Efq1tnlqsDFaIgK2T5LYBMZXhcA3m?=
 =?us-ascii?Q?hJtqYr+H7vUND7OR02bq+SincTzDdfPrXMcYpXUg3mPxaMrSeejbzZH+YE93?=
 =?us-ascii?Q?QKp21wmkjF3ou8ZwUjxw8J7Nbkbmipb2DlteNLf8v7rfC6P1gAfg/JpT5C3q?=
 =?us-ascii?Q?OgLYFROf+l4P3EiiiDjxMCiKBa7GfQt6zz+qiqJKCCltBp3Xdd3oOyqYYImA?=
 =?us-ascii?Q?KyR5isZaIX/XhZKYH6GRujExyXu0Cpe0EEIejEv/HwlhpO+ewv8Y8RFR/SK6?=
 =?us-ascii?Q?LETWTDF79mnlNgdg6niaNXoSanbPWtzPy0YuRq7rLVPKSI95k20+sTRhvmRy?=
 =?us-ascii?Q?TNMLrrxHBqnZbd7Y15mxFqf9cBiWoqBCUGEeIpMX7ZH6jf55Cf4xyRTiMkCu?=
 =?us-ascii?Q?bUgtqGTK0M8tEuEO1bvtXnOndoBpd1NjFKC6c6ONUC072+wrfhGoh4zVsdMd?=
 =?us-ascii?Q?im75gdqQ+Gv2fyWugR8sLEo6yo3HR92IY+vEPXsdQ91zK5RMzGigFD7oSYei?=
 =?us-ascii?Q?fb/3Vi/xJ9L2w/AsksWxip7fMU7ERgr9aToY66XlIkYXERRPjXHiFinsI+sh?=
 =?us-ascii?Q?xXYzy7QPkuxkl2jkFjMzrQ4yzTiL9BAAvTd19t7xYHYhpQLAQMBaB07/bsx/?=
 =?us-ascii?Q?QyVpimk9whRa68VKPhDUvUpDCtdLOktlPVld3xu8ThAzzOpqZfmuMxL9zg6Z?=
 =?us-ascii?Q?0P02GIXmUUARdYdPV1PxQ5Ldp5MQ6h/RmuKBIirhEQToQqUMAZ/Hge2bOTFV?=
 =?us-ascii?Q?EzasW82yeYS5IQpRmT662obwL86Y7oQc9yrs2W6zh+STWpeHsh8zoG7oqBNc?=
 =?us-ascii?Q?GSIIZgru4gBtzY/PKgN3kddtREhbaWu9qUrUQsQRe//V8/Hol/9iGw2DjKxE?=
 =?us-ascii?Q?lqs7EHrjne0G5gRkALUWcxVNl4PnggRh89U91tO4nUquzebGXBf1rWB/u5HM?=
 =?us-ascii?Q?x/0BxdwXCMEmsPQQ59z/h4bvoWK8lbNBg6h4PrCWPrtub8F8GhnUGR3VkxRN?=
 =?us-ascii?Q?rQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ddcf233b-efe5-4f85-4f63-08dd6675db82
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 23:37:33.6359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ylvt1eAAjD177yGCoqB4W8JFRbAVBZGKCTWMKxrrOIUDGGEp4bUR/FJXWalcc+cb/yVVRN/0h4cZc2Q2O4fSyZqlci+btYHLfi8WSf3L08k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6955
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, March 18, 2025 4:14 PM
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
> On Tue, Mar 18, 2025 at 09:09:05PM +0000, Sridhar, Kanchana P wrote:
> [..]
> > > > > >
> > > > > >     The only other fallback solution in lieu of the proposed
> simplification
> > > that
> > > > > >     I can think of is to keep the lifespan of these resources f=
rom pool
> > > creation
> > > > > >     to deletion, using the CPU hotplug code. Although, it is no=
t totally
> > > clear
> > > > > >     to me if there is potential for deadlock during pool transi=
tions, as
> > > noted
> > > > > above.
> > > > >
> > > > > I am not sure what's the deadlock scenario you're worried about,
> please
> > > > > clarify.
> > > >
> > > > My apologies: I was referring to triggering direct reclaim during p=
ool
> > > creation,
> > > > which could, in theory, run into a scenario where the pool switchin=
g
> would
> > > > have to wait for reclaim to free up enough memory for the acomp_ctx
> > > > resources allocation: this could cause the system to hang, but not =
a
> > > deadlock.
> > > > This can happen even today, hence trying to see if a better design =
is
> > > possible.
> > >
> > > I think the concern here is unfounded. We shouldn't care about the
> > > performance of zswap compressor switching, especially under memory
> > > pressure. A lot of things will slow down under memory pressure, and
> > > compressor switching should be the least of our concerns.
> >
> > Sounds good. It then appears that making the per-cpu acomp_ctx resource=
s'
> > lifetime track that of the zswap_pool, is the way to go. These resource=
s
> > will be allocated as per the requirements of the compressor, i.e.,
> zswap_pool,
> > and will persist through CPU online/offline transitions through the hot=
plug
> > interface. If this plan is acceptable, it appears that
> acomp_ctx_get_cpu_lock()
> > and acomp_ctx_put_unlock() can be replaced with mutex_lock()/unlock() i=
n
> > zswap_[de]compress()? I will incorporate these changes in v9 if this so=
unds
> Ok.
>=20
> Sounds good to me. Thanks!

Thanks Yosry! Will proceed accordingly.

Thanks,
Kanchana
