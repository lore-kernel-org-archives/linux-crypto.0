Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90333286D57;
	Fri, 12 Dec 2025 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765503850; cv=fail; b=m4dCLkIsrq1kOK8MMP/vmmgAkQMFp8VQ64OD05Ec7APvgXJM6waaKF4waBv4BCzDCmN6x3eBRwphlwTnx8Rnj9Uahzn9c0bMJr9hpwL1Gl1SR2Pbhi48UmYPbbfGkinJW7QC9qL/m1ldwWpyok7W3X/Ls+kzJ+/w31wN+WiBj0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765503850; c=relaxed/simple;
	bh=O5M/o1elptHprFwjfSwVFHvK2LfXtAEH9i3ctohtd8Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a7ZZ1BEbs4gaFN8MswrCP4mKLASf4vKorTpxCWkXTqirL73ylC042uKQxP6sGCJ62Yd91MO16pbFP09wmg+7IC9L5FwYPuQxp2aINr1lsOBNzLCyRJb4dkpyzmrXolunz9jftjyuyftxZDr6x8/fcgD2tofkMebROzoJH8foBg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXs1bVpa; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXs1bVpa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765503847; x=1797039847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O5M/o1elptHprFwjfSwVFHvK2LfXtAEH9i3ctohtd8Q=;
  b=TXs1bVpaFVz5kBLHtGbzy5+ra9d0b98Mm/IEqbhuSgFbuuye/I34EqCT
   rrrAtSQhXDVF5/QFLinAdOa2pptu1th4KJVcRCjFS3BaBx1q5P4FF4/Df
   T7C27amK/dxIUa1Edmrpf5Bbg/uhdCpQdIT0noXa9NtI7JnJzN0E6RYH6
   cnI26gzJOSmLWdQKsqyS/rHPWbXhcuIDwyNHRULV02Pgb1NQH7mzkUCXM
   OqoFfgG6k2ea0NtM7uw1QDCFF4t4YZ5ojl2iIVZ3L1HGqFabIMMLmm85e
   VURcV7hAgHTC/TBDgbWns/fCJOGzmLloWUiIHz/7Qf34FfuzUP0K+ZE8r
   A==;
X-CSE-ConnectionGUID: 9+NZJtJ3TlKAZyGJJ9MdYQ==
X-CSE-MsgGUID: X6RYX57bQpWcziu3067FQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71364405"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71364405"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:44:06 -0800
X-CSE-ConnectionGUID: lJYigf13S3igVc9W3OQ0Yg==
X-CSE-MsgGUID: LfQgnIcoQhelivyZp8FV+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201860245"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:44:05 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:44:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 17:44:05 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.36) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:44:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Et1ldQJ8BnR60drHBTJMOwN/5KnGGeI8G+wfL2UtUkxq/LsbaOGZlCy0/+7vb58wkEXp54EAZ/eqMe6vktXkJchWu7RDYZ8mNvD0q4LPoQMN0HRsWLHZcgoE8EySRTWkKlmzB1XKf3WGLDmG2rbZWFxKFNe9dT+93O/rrLbjHBCAYajTRMzjdTSUP3/daQMCnFiVUo16ImQAYo1llIMCVN//JoYiEZhx/fXpSTHS3BaAVxwfzPWFtvwRNd+KQnRPIyDWoWdVTyo2xJNcJugIFMkMNbstAHWC2+QEVOjNigMTsE2X0EEDfJgirA0+UsExoTL62KWSuQfxkAcBBzRnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWxGW5sY+7AqVMpeMpnfvF2KSYRtgOfleizzFJn95Nw=;
 b=JI/rtI8Q0Nw/Dq1r/Zy36/tAJ0XOE+8RAyz4bGmfce2fgjlVTcfmZMbRxsJOPQpxIzjOvhVOT9Rxr7ukZeax8tLJYWdUejASvKQghlGy+496wH/1Sx9oEpmb+88LB/sAtraI/x4eL5LjD3Ir9snCx8B2jATScBjDzNFPy4pGXgXtMUrtCsBhPM11oPPdHCow6ZDrVdi5YJFGUS2F0RAGOA8wL+4+lpW1lFBgQd01hpQBWBpe17NlbS2BlMvi0SdGq79+jf2oZyDSpVlO0WWT33eD13NrK8CBwFLQeDVBLuu/K8gR+E7l2gKwRD+ZCDsyixmKlU59gibo+3GX0iXkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by MW4PR11MB6667.namprd11.prod.outlook.com (2603:10b6:303:1ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 01:43:54 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 01:43:54 +0000
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
Subject: RE: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcTWsxfEPA0eGp6kWYA/H17miOhLTxI7AAgCxKBKA=
Date: Fri, 12 Dec 2025 01:43:54 +0000
Message-ID: <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
In-Reply-To: <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|MW4PR11MB6667:EE_
x-ms-office365-filtering-correlation-id: 7f73e450-943c-440c-9404-08de391fe88c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?EiInigwAhFjNZIxQa7s8DHLf5HmcxtqiLTi5d61TaevmFhsmL4tsLhVmM2uR?=
 =?us-ascii?Q?hMyxuJvpOu1NR7ZX9teC6sDxbPN1weELfKpu0m1PD8dnPpX+etL/dOoIlbLk?=
 =?us-ascii?Q?CLyrYVWYh9tRCn/MLtlWCKaOUhFydhrvfdgV8Pao0vCszG00hFL2Df/mQIQw?=
 =?us-ascii?Q?p6wX1tNWZ8GBJlZGwAHFyjiC9/MiMmidyR+JFN3A+NKQDQiFNKwFgde6SGdM?=
 =?us-ascii?Q?7XEUTp19LmHLZu9gwgBL/TM7o/AWCi+MG36MZ6VO7l56mGhWHG+gBmzAJ8RA?=
 =?us-ascii?Q?wyi7EVIR+8F11nxf7uBB2ZNaiqCmBq/pk7kN4icoWY0ofgwOtLJhZ0l6Ef9K?=
 =?us-ascii?Q?JX3ltcrgXifEuVpanceHargT6xRCUZl4I1hsMEulCFDwjL+d3H8PyElqy1PL?=
 =?us-ascii?Q?Pry/TgEfpLUQtjNCg9mKyTQfRHnqhyUu7DQzogR6g18iXczWF9HeAWPrIwMY?=
 =?us-ascii?Q?he2oy2MztmTl01wfwPUAMFBxQjPc5QSryCIBWCOKQqYXER1muwDTYbl3qjAi?=
 =?us-ascii?Q?QfUpO4Koaleu+M5uFt7LoaRAuU3dVcS0MZF97HcU7zFcaLOBW14qekHQSjaS?=
 =?us-ascii?Q?P9NfSy8t58wkIIHEPLyzekrHvo6XHxH5ogZhfVkKQOT+sQbuyeWrlAKNFWiB?=
 =?us-ascii?Q?Ju2QjkQ0ztaccSoQ5xtizrXGJ88DquugqMENdivui1zj4EuLz9JVNEHr5EUd?=
 =?us-ascii?Q?UYdExtxF8YD+EgCoMiCDxYDpXQCab7PhCT5AKcJZ4vhk9ySsrUClz4WkRzI0?=
 =?us-ascii?Q?g7mbxKgmM4EDp6Z72oNRlk8Tvtgoa8b+AGF102YT7iw4Bsly3YQX9yMbzUyH?=
 =?us-ascii?Q?6cQYzRdHI+PJG5VgssSNMWVSwiVv3ua/r13nmAVuV63o1fg98h32WPfuURPn?=
 =?us-ascii?Q?gV9cDrTXHASt3xEq4GJAd2hUITK9DdLcMKqfUGF2juJ34frKZNNKXkfVehV0?=
 =?us-ascii?Q?Y10xnd6ePWbgEQjnFvSpLD2cGz1xtVujEPMwFPd/NZrjRHVcm0a8K50jn6g/?=
 =?us-ascii?Q?3EKWNtSypjP3H6Niv5kDNueXYjFf6nEwOQ6GBrMBelJexdCyrqsqO3XWW/KP?=
 =?us-ascii?Q?+oqw9fAk18BrTZZVmaAEB95e4zVflKxHUj95GbkdU/HK2AIhAsKSf6BIlXZl?=
 =?us-ascii?Q?ybkKWofcEt27QBbOYo9GLJ6iN1RuWvlfHNG0efQaTULGFZQw1jUvS1XA5UPI?=
 =?us-ascii?Q?VTebOR6b0CgxFHRitHmNDbHroN/XSnt27fZBzoDMOF3GxQhY6FfHoiTkVcBy?=
 =?us-ascii?Q?OFkTNfLhWoU0hzHCjmfRYaY0EXxafOUl0OrKFWmZ/rkTalBvwlmDzsdCF86d?=
 =?us-ascii?Q?3zJ/ktLWAq4iJIOeLN4lZLqhllDAKuMPS7Rclz0BXSQscJXASTPkhav9dWQa?=
 =?us-ascii?Q?88+OXVrQ2bdopKt3IwlBzfQaFldxEPpDN4on3ptEBmOo9SJ/2MEXZiv4jrUQ?=
 =?us-ascii?Q?szJs1aBAsel279Iolc+uOeoxldzoz9bhRmzrxUSzOtm/4L5ZPDbnqzoPzmkZ?=
 =?us-ascii?Q?Hf+deEOc4bepr+ugiv8S3edtMIUp1Ir4mWJw?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HB1oxRBrChUwczwrXS0wTTDoc2v99RQKqXSTjGbYFkZTGcgQaD5Reyk9D3d0?=
 =?us-ascii?Q?8osL0bweNZal5yrcwgVWIGaBeR+kQRKgLhPdN/b+mLsIXhDlJ8tibzbNpVaI?=
 =?us-ascii?Q?Z/3JlKreKHb4Hm2KrkxPgfcAcaIKPxuWwyOp+MnhtMBvO75cSFR+mxl850Fw?=
 =?us-ascii?Q?ocjvbV/j/f7iS9Obgv6/Tw658TC8I87Ep1KeREUsUXIl2Axh9VL+Q8PBOptX?=
 =?us-ascii?Q?P1GNh5ZtCrEAJFIol5k1du9N7WZVOzVfvSoEkYzDUnHgNRu7aG0QEkc6qDHt?=
 =?us-ascii?Q?PDveewuq0RTHNLLCBU1iYWSrwk7F6A8u5Vb8FWCcNP5wCn4dFAOtRiITUN80?=
 =?us-ascii?Q?y/MSHY9ZBXTl7iZIgwNwgwPePGZYnY0OIGAuvZlP+m1f3wh1SqscDJsiz4DP?=
 =?us-ascii?Q?VVLr7B/QmNn7TFdBtGPFKkYpgm+Laux8GySdjQq1s63wHo07KGuK9hCD6+Yv?=
 =?us-ascii?Q?61J09s7s+IoL6gB1mRxuDmsTC9DP0vGYc1MmHqj9wBFeiQNyM+6fKkDUe83f?=
 =?us-ascii?Q?Nzkp/rWmmImpeoiY+4tpo2Zlv0e8IHb+0jcL989PLfJI73p5MCBXsTenqls/?=
 =?us-ascii?Q?NvcltszyuL4tFvhOz5VtgZgnCeugVOGAcO2ll2HF4vCiyJMoAtmUe4Td4lJd?=
 =?us-ascii?Q?2X8NTTv/M2uLtgHt6ItCPUf6laCU6T+quqAaBUfJMlghMxyCSDNEOTZ5eRMH?=
 =?us-ascii?Q?+tqSYwSYLjFXimMo99pITIbABput5ylzFyrOp31WG/uxZkL79QuHaRiqbcDq?=
 =?us-ascii?Q?9Hoaeo+niib+xbEjV+7Pf8jcxr1unxAjR12tSNOJsA0KxSO/b2ivLZuzetlc?=
 =?us-ascii?Q?QvxEDLBB4AnXmrYi0wZxz8Knje1VKiU2T3+7u4TUeu05d52ChCk6G3y0nQk8?=
 =?us-ascii?Q?vx4jL3rHgNRRM6i7L9fJULVnzun8Kq7rkE/Y+mrAbROUXxQl1Jh3G703qtSU?=
 =?us-ascii?Q?shD3UdCe7v2RqWVBk4z4G7W44cZbneCfbMqXSaQ+xybWN+LPAZNx36A5xif3?=
 =?us-ascii?Q?3jNPmDROaHivijk9CkvMR/dl/9IbsGULGB67v0Rarkl7c9pTw+mnihmyYXZr?=
 =?us-ascii?Q?XUnCfXmvpow3ZCvz45sR2B55EhRvjnjWa7G0HmKlMeIx1POI370Gt7rn+ysu?=
 =?us-ascii?Q?WP0vuPK1r8lE8NY8W7aYJ0dhBo3g4d2GqG0bdnMZZ+Hit0xdlEIiSz2TA/3p?=
 =?us-ascii?Q?ZHSjJ4imYzljMYhZ/Kc8Hb8cLhUSEuooPtcXFJ9meGpAtm1bUx2ZXOIHacsl?=
 =?us-ascii?Q?MYvNcWPodrjytNTsQfl31a6q0LqAXJySdQrSKWxJ0xbxe4U6gmvNQRlxgPaD?=
 =?us-ascii?Q?VNmAHkT3RZfn/41r4nrC1reHeBOmq6c2otSb+zECnWyGqQCWve0NelvsYepS?=
 =?us-ascii?Q?61P/xk51mIBzcDX3dZXzSI4kzScf3UicuZnPNcHFxHFFG0M5hzNvwADrXB5Q?=
 =?us-ascii?Q?0DW0UP9/mdHNqCNasKezqFDFnkzkpbhhe5i5R19Vj7/8NV/NyBeNUUmhRRSV?=
 =?us-ascii?Q?IF88BikPTiMxklADQKmZQBX0QPXkTYwROB2F7CzDuYEo0uVewzaQiNCbFzj0?=
 =?us-ascii?Q?4INV3CiHZOspB3ji4zhDhhuSvQ9oiheKrwCApjfxCWLk7ove3N4yWFkG6etl?=
 =?us-ascii?Q?HnlEQK+2cwSPhLU3RwbkXr+6871qTMWscuk7xLxbxOG61jJkLdaIza3YKFrc?=
 =?us-ascii?Q?Cmba5w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f73e450-943c-440c-9404-08de391fe88c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 01:43:54.1349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUuSpyLRXZ9WbvCZjT0Ze4w6Wn6cXCLknK2AtXgTf9aJLWVyH+U3yttsPhrDUVFMoz5knjr/VQePG4sf49FXEqD7eyc/xQ0U9e8AVS6bZrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6667
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 12:51 PM
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
> Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
> On Tue, Nov 04, 2025 at 01:12:34AM -0800, Kanchana P Sridhar wrote:
>=20
> Subject:
>=20
> "mm: zswap: Store large folios in batches"
>=20
> > This patch makes two major changes:
> >
> > First, we allocate pool batching resources if the compressor supports
> > batching:
> >
> >   This patch sets up zswap for allocating per-CPU resources optimally
> >   for non-batching and batching compressors.
> >
> >   A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
> >   limit on the number of pages in large folios that will be batch
> >   compressed.
> >
> >   It is up to the compressor to manage multiple requests, as needed, to
> >   accomplish batch parallelism. zswap only needs to allocate the per-CP=
U
> >   dst buffers according to the batch size supported by the compressor.
> >
> >   A "u8 compr_batch_size" member is added to "struct zswap_pool", as pe=
r
> >   Yosry's suggestion. pool->compr_batch_size is set as the minimum of
> >   the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE.
> Accordingly,
> >   pool->compr_batch_size compression dst buffers are allocated in the
> >   per-CPU acomp_ctx.
> >
> >   zswap does not use more than one dst buffer yet. Follow-up patches
> >   will actually utilize the multiple acomp_ctx buffers for batch
> >   compression/decompression of multiple pages.
> >
> >   Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used
> for
> >   batching. There is a small extra memory overhead of allocating
> >   the acomp_ctx->buffers array for compressors that do not support
> >   batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes)=
.
>=20
> Support batching when storing large folios in zswap. If the underlying
> compressor supports batching (e.g. HW parallel compression), allocate
> multiple compression buffers, otherwise allocate one. The number of
> buffers is bounded by a new constant, ZSWAP_MAX_BATCH_SIZE, to limit the
> memory overhead. For existing software compressors, the only extra
> overhead is the extra 'buffers' pointer, so 8 bytes per-CPU on x86_64.
>=20
> Only the first buffer is currently used, but subsequent changes will use
> the remaining buffers for HW compression batching.
>=20
> >
> > Next, we store the folio in batches:
> >
> >   This patch modifies zswap_store() to store a batch of pages in large
> >   folios at a time, instead of storing one page at a time. It does this=
 by
> >   calling a new procedure zswap_store_pages() with a range of indices i=
n
> >   the folio: for batching compressors, this range contains up to
> >   pool->compr_batch_size pages. For non-batching compressors, we send u=
p
> >   to ZSWAP_MAX_BATCH_SIZE pages to be sequentially compressed and
> stored
> >   in zswap_store_pages().
> >
> >   zswap_store_pages() implements all the computes done earlier in
> >   zswap_store_page() for a single-page, for multiple pages in a folio,
> >   namely the "batch":
> >
> >   1) It starts by allocating all zswap entries required to store the
> >      batch. New procedures, zswap_entries_cache_alloc_batch() and
> >      zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk(=
)
> >      to optimize the performance of this step.
> >
> >   2) The entry doesn't have to be allocated on the same node as the pag=
e
> >      being stored in zswap: we let the slab allocator decide this in
> >      kmem_cache_alloc_bulk(). However, to make sure the current zswap
> >      LRU list/shrinker behavior is preserved, we store the folio's nid =
as
> >      a new @nid member in the entry to enable adding it to the correct
> >      LRU list (and deleting it from the right LRU list). This ensures
> >      that when the folio's allocating NUMA node is under memory
> >      pressure, the entries corresponding to its pages are written back.
> >
> >      The memory footprint of struct zswap_entry remains unchanged at
> >      56 bytes with the addition of the "int nid" member by condensing
> >      "length" and "referenced" into 4 bytes using bit fields and using
> >      the 4 bytes available after "referenced" for the "int nid". Thanks
> >      to Nhat and Yosry for these suggestions!
> >
> >   3) Next, the entries fields are written, computes that need to be hap=
pen
> >      anyway, without modifying the zswap xarray/LRU publishing order. T=
his
> >      avoids bringing the entries into the cache for writing in differen=
t
> >      code blocks within this procedure, hence improves latency.
> >
> >   4) Next, it calls zswap_compress() to sequentially compress each page=
 in
> >      the batch.
> >
> >   5) Finally, it adds the batch's zswap entries to the xarray and LRU,
> >      charges zswap memory and increments zswap stats.
> >
> >   6) The error handling and cleanup required for all failure scenarios
> >      that can occur while storing a batch in zswap are consolidated to =
a
> >      single "store_pages_failed" label in zswap_store_pages(). Here aga=
in,
> >      we optimize performance by calling kmem_cache_free_bulk().
>=20
> Regardless of compression batching, always process large folios in
> batches. For HW compressors, the batch size is the compressor batch
> size, otherwise ZSWAP_MAX_BATCH_SIZE is used.
>=20
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
>=20
> Since batch allocations do not support specifying a node id, store the
> node id in the zswap entry instead of relying on the zswap_entry being
> allocated on the same node. The size of the zswap_entry remains
> unchanged as 'referenced' is lumped in with the length (as it doesn't
> need a full unsigned int anyway).
>=20
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg.

Ok, will change this accordingly, thanks.

>=20
> >
> > This commit also makes a minor optimization in zswap_compress(), that
> > takes a "bool wb_enabled" argument; computed once in zswap_store()
> > rather than for each page in the folio.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 336 ++++++++++++++++++++++++++++++++++++-------------
> ----
> >  1 file changed, 232 insertions(+), 104 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index cb384eb7c815..257567edc587 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/* Limit the batch size to limit per-CPU memory usage for dst buffers.=
 */
> > +#define ZSWAP_MAX_BATCH_SIZE 8U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> >  	struct acomp_req *req;
> >  	struct crypto_wait wait;
> > -	u8 *buffer;
> > +	u8 **buffers;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> >  };
> > @@ -149,6 +152,9 @@ struct crypto_acomp_ctx {
> >   * The only case where lru_lock is not acquired while holding tree.loc=
k is
> >   * when a zswap_entry is taken off the lru for writeback, in that case=
 it
> >   * needs to be verified that it's still valid in the tree.
> > + *
> > + * @compr_batch_size: The max batch size of the compression algorithm,
> > + *                    bounded by ZSWAP_MAX_BATCH_SIZE.
> >   */
> >  struct zswap_pool {
> >  	struct zs_pool *zs_pool;
> > @@ -158,6 +164,7 @@ struct zswap_pool {
> >  	struct work_struct release_work;
> >  	struct hlist_node node;
> >  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> > +	u8 compr_batch_size;
> >  };
> >
> >  /* Global LRU lists shared by all zswap pools. */
> > @@ -182,6 +189,7 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the wr=
iteback
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> > + * nid - NUMA node id of the page for which this is the zswap entry.
> >   * pool - the zswap_pool the entry's data is in
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> > @@ -189,8 +197,11 @@ static struct shrinker *zswap_shrinker;
> >   */
> >  struct zswap_entry {
> >  	swp_entry_t swpentry;
> > -	unsigned int length;
> > -	bool referenced;
> > +	struct {
> > +		unsigned int length:31;
> > +		bool referenced:1;
> > +	};
> > +	int nid;
> >  	struct zswap_pool *pool;
> >  	unsigned long handle;
> >  	struct obj_cgroup *objcg;
> > @@ -242,8 +253,10 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8
> nr_buffers)
> >  {
> > +	u8 i;
> > +
> >  	if (IS_ERR_OR_NULL(acomp_ctx))
> >  		return;
> >
> > @@ -253,7 +266,11 @@ static void acomp_ctx_dealloc(struct
> crypto_acomp_ctx *acomp_ctx)
> >  	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  		crypto_free_acomp(acomp_ctx->acomp);
> >
> > -	kfree(acomp_ctx->buffer);
> > +	if (acomp_ctx->buffers) {
> > +		for (i =3D 0; i < nr_buffers; ++i)
> > +			kfree(acomp_ctx->buffers[i]);
> > +		kfree(acomp_ctx->buffers);
> > +	}
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -265,6 +282,7 @@ static struct zswap_pool *zswap_pool_create(char
> *compressor)
> >  	if (!zswap_has_pool && !strcmp(compressor,
> ZSWAP_PARAM_UNSET))
> >  		return NULL;
> >
> > +	/* Many things rely on the zero-initialization. */
> >  	pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
> >  	if (!pool)
> >  		return NULL;
> > @@ -315,7 +333,9 @@ static struct zswap_pool *zswap_pool_create(char
> *compressor)
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> >
> >  	for_each_possible_cpu(cpu)
> > -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> > +				  pool->compr_batch_size);
> > +
> >  error:
> >  	if (pool->acomp_ctx)
> >  		free_percpu(pool->acomp_ctx);
> > @@ -353,7 +373,8 @@ static void zswap_pool_destroy(struct zswap_pool
> *pool)
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> >
> >  	for_each_possible_cpu(cpu)
> > -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> > +				  pool->compr_batch_size);
> >
> >  	free_percpu(pool->acomp_ctx);
> >
> > @@ -644,14 +665,8 @@ static inline struct mem_cgroup
> *mem_cgroup_from_entry(struct zswap_entry *entry
> >  }
> >  #endif
> >
> > -static inline int entry_to_nid(struct zswap_entry *entry)
> > -{
> > -	return page_to_nid(virt_to_page(entry));
> > -}
> > -
> >  static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entr=
y
> *entry)
> >  {
> > -	int nid =3D entry_to_nid(entry);
> >  	struct mem_cgroup *memcg;
> >
> >  	/*
> > @@ -668,19 +683,18 @@ static void zswap_lru_add(struct list_lru *list_l=
ru,
> struct zswap_entry *entry)
> >  	rcu_read_lock();
> >  	memcg =3D mem_cgroup_from_entry(entry);
> >  	/* will always succeed */
> > -	list_lru_add(list_lru, &entry->lru, nid, memcg);
> > +	list_lru_add(list_lru, &entry->lru, entry->nid, memcg);
> >  	rcu_read_unlock();
> >  }
> >
> >  static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entr=
y
> *entry)
> >  {
> > -	int nid =3D entry_to_nid(entry);
> >  	struct mem_cgroup *memcg;
> >
> >  	rcu_read_lock();
> >  	memcg =3D mem_cgroup_from_entry(entry);
> >  	/* will always succeed */
> > -	list_lru_del(list_lru, &entry->lru, nid, memcg);
> > +	list_lru_del(list_lru, &entry->lru, entry->nid, memcg);
> >  	rcu_read_unlock();
> >  }
> >
> > @@ -740,6 +754,29 @@ static void zswap_entry_cache_free(struct
> zswap_entry *entry)
> >  	kmem_cache_free(zswap_entry_cache, entry);
> >  }
> >
>=20
> Instead of this:
>=20
> > +/*
> > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number
> otherwise.
> > + * The code for __kmem_cache_alloc_bulk() indicates that this positive
> number
> > + * will be the @size requested, i.e., @nr_entries.
> > + */
> > +static __always_inline int zswap_entries_cache_alloc_batch(void
> **entries,
> > +							   unsigned int
> nr_entries,
> > +							   gfp_t gfp)
> > +{
> > +	int nr_alloc =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > +					     nr_entries, entries);
> > +
>=20
> Add this here:
> 	/*
> 	 * kmem_cache_alloc_bulk() should return nr_entries on success
> 	 * and 0 on failure.
> 	 */
>=20

Sure.

> > +	WARN_ON(!nr_alloc || (nr_alloc !=3D nr_entries));
>=20
> WARN_ON_ONCE() is sufficient, and why do we WARN if
> kmem_cache_alloc_bulk() fails? I thought that was expected in some
> cases.

I can change this to a WARN_ON_ONCE(). The code for kmem_cache_alloc_bulk()
makes sure that either all entries are allocated, or none are allocated
(partial allocations are freed and 0 returned in case of the latter). It ca=
n be expected
to fail based on this.

I believe there was an earlier comment for which I added the WARN_ON? I can
either change this to WARN_ON_ONCE() or drop the WARN_ON_ONCE(), since
we anyway have a fallback mechanism.

>=20
> > +
> > +	return nr_alloc;
> > +}
> > +
>=20
> Please document that it's okay use this to free entries allocated
> separately by zswap_entry_cache_alloc().

Sure.

>=20
> > +static __always_inline void zswap_entries_cache_free_batch(void
> **entries,
> > +							   unsigned int
> nr_entries)
> > +{
> > +	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> > +}
> > +
> >  /*
> >   * Carries out the common pattern of freeing an entry's zsmalloc alloc=
ation,
> >   * freeing the entry itself, and decrementing the number of stored pag=
es.
> > @@ -766,7 +803,9 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  {
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +	int nid =3D cpu_to_node(cpu);
> >  	int ret =3D -ENOMEM;
> > +	u8 i;
> >
> >  	/*
> >  	 * To handle cases where the CPU goes through online-offline-online
> > @@ -775,11 +814,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  		return 0;
> >
> > -	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!acomp_ctx->buffer)
> > -		return ret;
> > -
> > -	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > +	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, nid);
> >  	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> >  				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> > @@ -788,20 +823,39 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	}
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> > +	/*
> > +	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> > +	 * compressor supports batching.
> > +	 */
> > +	pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +				     crypto_acomp_batch_size(acomp_ctx-
> >acomp));
> > +
> >  	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > +
> >  	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> >  		       pool->tfm_name);
> >  		goto fail;
> >  	}
> >
> > -	crypto_init_wait(&acomp_ctx->wait);
> > +	acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size,
> sizeof(u8 *),
> > +					  GFP_KERNEL, nid);
> > +	if (!acomp_ctx->buffers)
> > +		goto fail;
> > +
> > +	for (i =3D 0; i < pool->compr_batch_size; ++i) {
> > +		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE,
> GFP_KERNEL, nid);
> > +		if (!acomp_ctx->buffers[i])
> > +			goto fail;
> > +	}
> >
> >  	/*
> >  	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> >  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> >  	 * won't be called, crypto_wait_req() will return without blocking.
> >  	 */
> > +	crypto_init_wait(&acomp_ctx->wait);
> > +
> >  	acomp_request_set_callback(acomp_ctx->req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  				   crypto_req_done, &acomp_ctx->wait);
> >
> > @@ -811,12 +865,12 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	return 0;
> >
> >  fail:
> > -	acomp_ctx_dealloc(acomp_ctx);
> > +	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
> >  	return ret;
> >  }
> >
> >  static bool zswap_compress(struct page *page, struct zswap_entry *entr=
y,
> > -			   struct zswap_pool *pool)
> > +			   struct zswap_pool *pool, bool wb_enabled)
> >  {
> >  	struct crypto_acomp_ctx *acomp_ctx;
> >  	struct scatterlist input, output;
> > @@ -830,7 +884,7 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  	mutex_lock(&acomp_ctx->mutex);
> >
> > -	dst =3D acomp_ctx->buffer;
> > +	dst =3D acomp_ctx->buffers[0];
> >  	sg_init_table(&input, 1);
> >  	sg_set_page(&input, page, PAGE_SIZE, 0);
> >
> > @@ -860,8 +914,7 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	 * to the active LRU list in the case.
> >  	 */
> >  	if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> > -		if (!mem_cgroup_zswap_writeback_enabled(
> > -					folio_memcg(page_folio(page)))) {
> > +		if (!wb_enabled) {
> >  			comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> >  			goto unlock;
> >  		}
> > @@ -906,7 +959,7 @@ static bool zswap_decompress(struct zswap_entry
> *entry, struct folio *folio)
> >
> >  	acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  	mutex_lock(&acomp_ctx->mutex);
> > -	obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx-
> >buffer);
> > +	obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx-
> >buffers[0]);
> >
> >  	/* zswap entries of length PAGE_SIZE are not compressed. */
> >  	if (entry->length =3D=3D PAGE_SIZE) {
> > @@ -916,15 +969,15 @@ static bool zswap_decompress(struct
> zswap_entry *entry, struct folio *folio)
> >
> >  	/*
> >  	 * zs_obj_read_begin() might return a kmap address of highmem
> when
> > -	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
> > -	 * handle highmem addresses, so copy the object to acomp_ctx-
> >buffer.
> > +	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does
> not
> > +	 * handle highmem addresses, so copy the object to acomp_ctx-
> >buffers[0].
> >  	 */
> >  	if (virt_addr_valid(obj)) {
> >  		src =3D obj;
> >  	} else {
> > -		WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> > -		memcpy(acomp_ctx->buffer, obj, entry->length);
> > -		src =3D acomp_ctx->buffer;
> > +		WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> > +		memcpy(acomp_ctx->buffers[0], obj, entry->length);
> > +		src =3D acomp_ctx->buffers[0];
> >  	}
> >
> >  	sg_init_one(&input, src, entry->length);
> > @@ -1378,95 +1431,156 @@ static void shrink_worker(struct work_struct
> *w)
> >  * main API
> >  **********************************/
> >
> > -static bool zswap_store_page(struct page *page,
> > -			     struct obj_cgroup *objcg,
> > -			     struct zswap_pool *pool)
> > +/*
> > + * Store multiple pages in @folio, starting from the page at index @st=
art up
> to
> > + * the page at index @end-1.
> > + */
> > +static bool zswap_store_pages(struct folio *folio,
> > +			      long start,
> > +			      long end,
> > +			      struct obj_cgroup *objcg,
> > +			      struct zswap_pool *pool,
> > +			      int nid,
> > +			      bool wb_enabled)
> >  {
> > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > -	struct zswap_entry *entry, *old;
> > -
> > -	/* allocate entry */
> > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > -	if (!entry) {
> > -		zswap_reject_kmemcache_fail++;
> > -		return false;
> > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > +	u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> > +
> > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > +
> > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
>=20
> Is this equivalent to just passing in 'entries'?

It is, however, I wanted to keep this equivalent to the failure case call t=
o
zswap_entries_cache_free_batch(), that passes in the address of the
batch index that failed xarray store.

>=20
> > +						      nr_pages, GFP_KERNEL)))
> {
> > +		for (i =3D 0; i < nr_pages; ++i) {
> > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> nid);
> > +
> > +			if (unlikely(!entries[i])) {
> > +				zswap_reject_kmemcache_fail++;
> > +				/*
> > +				 * While handling this error, we only need to
> > +				 * call zswap_entries_cache_free_batch() for
> > +				 * entries[0 .. @i-1].
> > +				 */
> > +				nr_pages =3D i;
> > +				goto store_pages_failed;
> > +			}
> > +		}
>=20
>=20
> Maybe move the fallback loop into zswap_entries_cache_alloc_batch()?

I could, however, I would need to modify the API to return the error index =
"i",
so that the "goto store_pages_failed" works. Imo, inlining this makes the e=
rror
handling more apparent, but let me know.

>=20
> >  	}
> >
> > -	if (!zswap_compress(page, entry, pool))
> > -		goto compress_failed;
> > +	/*
> > +	 * We colocate entry initialization as much as possible here to
> > +	 * minimize potential cache misses.
>=20
> s/colocate/co-locate
>=20
> Please only keep the portion above and drop the rest of the comment.

Ok.

>=20
> > +	 *
> > +	 * With kmem_cache_alloc_bulk(), the batch's entries will be created
> > +	 * on the NUMA node of the CPU on which zswap_store() is called,
> which
> > +	 * might not be the same as @nid, the NUMA node on which @folio
> was
> > +	 * allocated. In order for the @folio's entries to be written back wh=
en
> > +	 * @nid experiences memory pressure, we store @nid in @entry-
> >nid.
> > +	 * This ensures that the entry is added to and deleted from the LRU
> > +	 * list of the correct node, namely @nid.
> > +	 */
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> > +		entries[i]->pool =3D pool;
> > +		entries[i]->swpentry =3D page_swap_entry(folio_page(folio,
> start + i));
> > +		entries[i]->objcg =3D objcg;
> > +		entries[i]->referenced =3D true;
> > +		entries[i]->nid =3D nid;
> > +		INIT_LIST_HEAD(&entries[i]->lru);
> > +	}
> >
> > -	old =3D xa_store(swap_zswap_tree(page_swpentry),
> > -		       swp_offset(page_swpentry),
> > -		       entry, GFP_KERNEL);
> > -	if (xa_is_err(old)) {
> > -		int err =3D xa_err(old);
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		struct page *page =3D folio_page(folio, start + i);
> >
> > -		WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> %d\n", err);
> > -		zswap_reject_alloc_fail++;
> > -		goto store_failed;
> > +		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> > +			goto store_pages_failed;
> >  	}
> [..]
