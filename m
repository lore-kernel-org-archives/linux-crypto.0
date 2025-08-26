Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F92BE657;
	Tue, 26 Aug 2025 04:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756181391; cv=fail; b=DuXQhd4YX8C0/gKa6q14UT63BQXEoCQ7LeJyr7yv3iVuWWTb2uAQeDKVxU/8G1cf27ULAWe1caA9Y7Z5A1Eoc06fHJQxNkz9nKFg8tiI6n4BDXw8Rg1ND5GYlZuOw2QP7g2uINDL6yi0NtWEhL0sI9dZ3Zc2on/Pjuw20tBpChk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756181391; c=relaxed/simple;
	bh=aFOx0sc2v0pZAmyyW3LPgFsPX9SonTSHRyTt/AML45Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lkXg3BHqP51IyqM9p6KJuAFflxpdt/clpTbbCLQN0ukU9n4PdzBjxHtrcmwqSNqkOcPd66z4ktDkWqlbYw5fvj/gjUz1K4WkAV0AG40GblxRRuYy6Q7uB48MxkOPje5eLzlMa0abbPQ8MgKhc72rZnlaCm5R0I771ukVpko7sZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lK3zuRxZ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lK3zuRxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756181389; x=1787717389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aFOx0sc2v0pZAmyyW3LPgFsPX9SonTSHRyTt/AML45Q=;
  b=lK3zuRxZIibSmC4METbefthjHAew5ZyiLGfonMuSJP0DSOLO5ZEnfWMX
   Nj14KXDCundC23rjaRXM7qjq+JmwfCRB25zfg6ZOogFrESTkxJVMmLZB/
   QSYq6Vl2EH0U8Ng0PINS4Z2xxPWhcSApznjUMOId0EkXlqp4xeN6nUmLD
   C6FePTUBf6SSjoIVKueZTP4Rr74JbAd9nLVJEQooG5PQQtfErOJT0FaQo
   Bebiw+9GpGumh1baevbj6VqatXpYtw5tT+mH1ONYaxlZh+TTPX1Y3nPAx
   s1bHfk2QCa6VmCy14pKqQiLr4LwVJcSZ3rZJ3lLzshyh1vVkVHy4knLoU
   A==;
X-CSE-ConnectionGUID: EGEjsnXrR9ikA3zqjZWCGw==
X-CSE-MsgGUID: +M7H/uEZS6mhR+oqalRqbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58340351"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58340351"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:09:48 -0700
X-CSE-ConnectionGUID: tDfj2exLSJ6geassQJ0gMA==
X-CSE-MsgGUID: CBAMhoM+S9GoQmDSF3Og9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200417871"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:09:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:09:47 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 21:09:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.41)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:09:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFPBhlKazP0SltSyiZ7YErP7TlHJ7YGUcxaCRc1fwrNWDZx+kpGQUFN7hGpAOeBXTBXVEM+HxJSVVY8SHXbF+Y57KBg9WRBXNXqQPkd4+PUVgovkKhILQ+bfOUjPP3rDty0vrWlYDGF/COb0VUi7zjtPdxR0yWLpKyijpraLbB/8P+FJDSxAO9rDGLJfa73DF+duudsk1oYgXtPLP4W7V8tpAfFPvHsWcqwvUxr20VGPcQPtlHEMUjU0ms84XRgO+DQ0usSxahOj0leMij9bUHGyeeTIYDpmACzWQ55D0RkC3yspMBGq79FGPCIJ5JdXdggIUpp+IS3MpiLXX0CSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPkh1/Hd7+Uw9qwfB7BSi6mZf+unpr1AMVzbn0xtTGc=;
 b=G+awTMN0aQ758JCF4WTWvh9RSM42Qjr/AE/8ikVzm1hxYT6Jebd1XeGXxsjmlLzjm6rVZb67zkk1epk57/ILpRGu4fmi5ysCwTKn17f0Dz+qXktfRgB8EFgn9LTzgf44t63a6Yb/Hi4sTV6Fy9UF4h1sXTS8L1dUKaBhAyBIHZ1KDiTHU1Rx9ahrmEDGyoNzZ4Ra73T89E/d+LtLhTzCWO2dxO8xMWgtNUW009VgbHI/zQ62+MPnblfsUF8d6onLy/Khfteg44LMKHQtmL0jYRRafdNXPL9ZvXlyc5iUGSC7YP1MDvGCKMhv/zzOLJorQhpA8phqJNSzg9etTDiN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by BY1PR11MB8030.namprd11.prod.outlook.com (2603:10b6:a03:522::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 04:09:45 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:09:45 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8IAD0bOAgADL1oCAAHxNAIAAJ5Eg
Date: Tue, 26 Aug 2025 04:09:45 +0000
Message-ID: <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK0KNAmQh_JVgnML@gondor.apana.org.au>
In-Reply-To: <aK0KNAmQh_JVgnML@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|BY1PR11MB8030:EE_
x-ms-office365-filtering-correlation-id: d8950887-b62a-4640-d842-08dde4566442
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?asJXVP8zpfeLiDzxy4XByv4nzeZOep4EqUBnX+afIbgLFvKYf3wRWf582zTj?=
 =?us-ascii?Q?hAbZPUS7UIW2mjXi4ti29a92JuzkA4Y12CdlO3e9IxSxeKKfTE1QjUTGCycp?=
 =?us-ascii?Q?X5zmiBLhRn87b/+VJI/3QU7Nk3buO/cVXvh+lNGlcV6hVLfVbCJAOS3jJug8?=
 =?us-ascii?Q?ArKRbfVmvZHOKi/Wupx/t4FycugA4fQf6DoNI31y0ZOgMI3Z15ebDd7LotAO?=
 =?us-ascii?Q?FVykAOKcBfavxeSAZE92t41XfWetamQeSfPQcvc8X/5N0teLCILBk3PIEFYI?=
 =?us-ascii?Q?GKp+nDwbQV+9S0Xgm3UdwEyp3VvYkpNh3o3peh5BPtCS/ZqxYBf5Qdri7LmA?=
 =?us-ascii?Q?iGBr7B6XBOJhxDIW5+y92FUdScXFFnoh4Jgy51ZyQcRxe87DpKxZyXXM2VOh?=
 =?us-ascii?Q?FeJ8QLZ/mm3mhlK3F87Az3fKuHpgppqzGHun4hewJ+8WpnONDaHKUi5wchpH?=
 =?us-ascii?Q?HugQvsg2ceLgwRGk1JG+PcIbNc3xMQUM9YON+w8/R1bDbAbQyXdeavSCVbRF?=
 =?us-ascii?Q?+lqpu/lD4vy5AfMkTeiL9WRz03lzrJh1h9098veIi9alsgWILzt5lT+ypdmH?=
 =?us-ascii?Q?Tx6GHdbH7aO4tumbhk27VJgR1cWwVuqsLqyqb1KWV1S7nztduBwVt86qomzr?=
 =?us-ascii?Q?sh2ssfsarxe2n3YWXNZZhcaI9IyE96C0XJbTu+tBB89uSAQKfAC3gwnRzrEY?=
 =?us-ascii?Q?PIo6oClLLnLwa/R/cc3Wa79zkDZtRyusx2zIPd8h+/qI8yLjeyDUDq8bMl+r?=
 =?us-ascii?Q?IWdlqat2psrMpLzMQQQg58K01lmC1kVI/eLqIVCK7vVUE5mc5iUEzhwd+6PX?=
 =?us-ascii?Q?Ty5hlC9vJmP0Ph6If3JLIJK2T4PTlLRtZTFQ7RJz7wZM6p+Qku6z+RoS+DtN?=
 =?us-ascii?Q?HdjQarC8PxEANd8tL32RfXazwdobvoH6Waf6+zWVf0lhDV/NuPZ1LJrQpGUs?=
 =?us-ascii?Q?I6A/hVD+wyxSmo287xAjAFERJkUYIIhXx5C6K38r4zJv3j4gPHNuUkYPwd+w?=
 =?us-ascii?Q?e8Z2O0AFIFOb8H5MoCum13WA9rkb4+2UFCIKYFTsURRms2UpQAhxnoi72nfr?=
 =?us-ascii?Q?wUZPK5MAqq6dNfZGvBnIG4cw4zk0EJAskp2Vuu1KYAXrxMhGSguzwCCfdK2d?=
 =?us-ascii?Q?d1UJb8sfYFMDv6jN6A5OJLtb1NCtskKg/Cx5ZQ1gUEdk0UJmCbf1GA6Dvnlu?=
 =?us-ascii?Q?lcMysVDvEW4YXU5dSe+CdR3iiuaSqtyWbFj6TfdSv9diB2ctBu523Rteyk6t?=
 =?us-ascii?Q?i5ALwXRV5Ikc2lCyA2Bmcl31K2dvGgnsPICf4oc/to1+oV5fTNompmk+kAIV?=
 =?us-ascii?Q?p0P207/Rzv4W9vfMIe2XN2Lk32ZztTKOxZ6gbZFRWmViGcHp1trSQke1yFJB?=
 =?us-ascii?Q?dgsB+/nnA+2F9G41f4roBmHz8JNDaEih55C/R/lqpF8DkFNOsYKnPz6Bl30v?=
 =?us-ascii?Q?209D9Wez6/w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NGObFHHE7HKRb8ROzpeUFSOquqPOvrCnqRtH2g2Y0ZtU2LxKkbs/C36xinN6?=
 =?us-ascii?Q?aylDLg0P6onGfeyUVcx28awMDoCpJ2dIWZhIEHeNzDL9e4wCwUkF/mTMZ2L7?=
 =?us-ascii?Q?PkwydFbrejnPA/2ssIlZvx1Olt1oNgT/3yi/LaLq1UENkuf8+TZ1/5qWByBE?=
 =?us-ascii?Q?VMcIwASSgHkiZPlmPDO/T24MFV0JUHdLRdeE5ON2IR3e2y1eT+HTHE1Ayj+U?=
 =?us-ascii?Q?lmDSJ01e8jQsYvk1zvmP2/iTCVGxbJKcOz/OiE1xqemY8trnQUgvKl0saLd8?=
 =?us-ascii?Q?QCh5Qo/VyBz0xRrvOZRWk9dRRMijZUbVwDux3bTunHu4n+lcJapwQw1u//fH?=
 =?us-ascii?Q?q9TokjqNPuzH6cfpxOardOK1JIlrR5/NAblS2W3qPrOhron7fuS7qHwdXcHb?=
 =?us-ascii?Q?EZZdsj1lmSTPoUKA11UQDatLePhyMg1rt7JldwPFvFbxPG/+FVNaCeDbiLn/?=
 =?us-ascii?Q?zjasO/pG1JzN+IYikS/w3K1wXEYmGouYTWCx86i6SBGetkSPP17rv66m5SbJ?=
 =?us-ascii?Q?Cs9IDCWa6Zba50UQ2BMdZorxDX4kS5v2MygK0Sy4awSw5AVgwK0AOKIQ7JJT?=
 =?us-ascii?Q?d3swBw+dgzKKP9Q9lEnHqUC58FDG99N08ZUPzY4rOhyiQcv8whHeZ/rsSc30?=
 =?us-ascii?Q?PVr0WkQs/ihEYjf0K79UHSMUwtXIgvAejfbj6fkYyFN7OhYhw5KUhE6nyf5o?=
 =?us-ascii?Q?N+cswLp819iTpxLB0ICi+31PpxJMPLcM/3EfAxUeh1QHIwElQZNBEJwc+C+l?=
 =?us-ascii?Q?INkZgIRVwQQ2n0MV0RRtWiFU4SwjcrBvBwj8NilyS8FfcBbkd+q6+q6fb1Rv?=
 =?us-ascii?Q?NAQyox8UO+xFoZo569vjIX/DNr2vus/5SGqAupWbilopsuie2FyaHa/9QQVS?=
 =?us-ascii?Q?CthkmMtOVnzbOXTuY2LpxImUEP7Hl2yF2eBLJHrMjwtoWIJmw6RaDSQuypC9?=
 =?us-ascii?Q?ESmq9M19XEGe8QWEeNrKv1RBJ8QUf5Fb22Y1kYq+tgweX4x0D/g3H6p9M2e3?=
 =?us-ascii?Q?5oGtVWT9fxdRMXcWzaN9DkXUtiH+KLS2ca5FFarsbjSgk0Tfic7WQ6I+Ie5+?=
 =?us-ascii?Q?95STIEdBtcTQaSVbIbznniSyPqVPwS1anGklisVv7fTu6B787m+zfbF/TMCi?=
 =?us-ascii?Q?o7HHDH+OqpiIOL8WJFWrA0sp8e78ZstwdSLs5r6JIUK3rlGgDLHftf3QBaVo?=
 =?us-ascii?Q?21lN2uGtuWZasGPzn7CYkzM5E7D66o8K0X7z/UriP3vLBegWVS3OFSs5ibs9?=
 =?us-ascii?Q?lhExeak2+YeZmRdZa/WXRYiojpyEBx6pIEth9bMDF9Ybi3LIoo42Q/zGxHKI?=
 =?us-ascii?Q?t8r6kdypja/FuBjx5cm0clrnfXaxxUfVmojJ5ZMUFooG1ZHitQdspJ55X1Hp?=
 =?us-ascii?Q?e92l43x6ZlTXRHkmcdqjvMtW3eo4D15kwDgftfwII14uZQNA/RVnGZ9q3VA5?=
 =?us-ascii?Q?7ksXLSiY/WLyxoNnVaCYGt4+kK0qfVcrNRNARS6HqYFrBCUTog8ldz6IlYNQ?=
 =?us-ascii?Q?8BzLU93RE+ALGriBwtqDgTs3zVDUCrlpBIwWXGIdDlqNGjOIBXFedI7L9jpD?=
 =?us-ascii?Q?w9YWTL7kkbh2yuH66xtmDUoMNNdmUiKdcwN5GUBA+tARGCdwZAGKX+S5ffVa?=
 =?us-ascii?Q?JA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d8950887-b62a-4640-d842-08dde4566442
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 04:09:45.6309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oH7Kp94569q8hV45CHfD3TSIZcVXP9tlYmtXIgT9W/N/5A/Ty7ohyAyOScLijBfT7uEx2pP7+S6OCoBZtvcWxuYlF3NHb+iiJcHcKqX3tpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8030
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, August 25, 2025 6:13 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosry.ahmed@linux.dev;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Mon, Aug 25, 2025 at 06:12:19PM +0000, Sridhar, Kanchana P wrote:
> >
> > Thanks Herbert, for reviewing the approach. IIUC, we should follow
> > these constraints:
> >
> > 1) The folio should be submitted as the source.
> >
> > 2) For the destination, construct an SG list for them and pass that in.
> >     The rule should be that the SG list must contain a sufficient numbe=
r
> >     of pages for the compression output based on the given unit size
> >     (PAGE_SIZE for zswap).
> >
> > For PMD folios, there would be 512 compression outputs. In this case,
> > would we need to pass in an SG list that can contain 512 compression
> > outputs after calling the acompress API once?
>=20
> Eventually yes :)
>=20
> But for now we're just replicating your current patch-set, so
> the folio should come with an offset and a length restriction,
> and correspondingly the destination SG list should contain the
> same number of pages as there are in your current patch-set.

Thanks Herbert. Just want to make sure I understand this. Are you
referring to replacing sg_set_page() for the input with sg_set_folio()?
We have to pass in a scatterlist for the acomp_req->src..

This is how the converged zswap_compress() code would look for
batch compression of "nr_pages" in "folio", starting at index "start".
The input SG list will contain "nr_comps" pages: nr_comps is
1 for software and 8 for IAA.

The destination SG list will contain an equivalent number of
buffers (each is PAGE_SIZE * 2).

Based on your suggestions, I was able to come up with a unified
implementation for software and hardware compressors: the SG list
for the input is a key aspect of this (lines 24-25 from the start of the
procedure):

static bool zswap_compress(struct folio *folio, long start, unsigned int nr=
_pages,
                           struct zswap_entry *entries[], struct zswap_pool=
 *pool,
                           int node_id)
{
        unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
        unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
        struct crypto_acomp_ctx *acomp_ctx;
        struct zpool *zpool =3D pool->zpool;
        struct scatterlist *sg;
        unsigned int i, j, k;
        gfp_t gfp;
        int err;

        gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;

        acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);

        mutex_lock(&acomp_ctx->mutex);

        prefetchw(acomp_ctx->sg_inputs->sgl);
        prefetchw(acomp_ctx->sg_outputs->sgl);

        /*                                                                 =
                                                              =20
         * Note:                                                           =
                                                              =20
         * [i] refers to the incoming batch space and is used to           =
                                                              =20
         *     index into the folio pages and @entries.                    =
                                                              =20
         *                                                                 =
                                                              =20
         * [k] refers to the @acomp_ctx space, as determined by            =
                                                              =20
         *     @pool->compr_batch_size, and is used to index into          =
                                                              =20
         *     @acomp_ctx->buffers and @dlens.                             =
                                                              =20
         */
        for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
                for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
                        sg_set_folio(sg, folio, PAGE_SIZE, (start + k + i) =
* PAGE_SIZE);

                /*                                                         =
                                                              =20
                 * We need PAGE_SIZE * 2 here since there maybe over-compre=
ssion case,                                                   =20
                 * and hardware-accelerators may won't check the dst buffer=
 size, so                                                     =20
                 * giving the dst buffer with enough length to avoid buffer=
 overflow.                                                    =20
                 */
                for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k)
                        sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE * 2=
);

                acomp_request_set_params(acomp_ctx->req,
                                         acomp_ctx->sg_inputs->sgl,
                                         acomp_ctx->sg_outputs->sgl,
                                         nr_comps * PAGE_SIZE,
                                         nr_comps * PAGE_SIZE);

                err =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->re=
q),
                                      &acomp_ctx->wait);

                if (unlikely(err)) {
                        if (nr_comps =3D=3D 1)
                                dlens[0] =3D err;
                        goto compress_error;
                }

                if (nr_comps =3D=3D 1)
                        dlens[0] =3D acomp_ctx->req->dlen;
                else
                        for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comp=
s, k)
                                dlens[k] =3D sg->length;

[ store each compressed page in zpool]

I quickly tested this with usemem 30 processes. Switching from sg_set_page(=
)
to sg_set_folio() does cause a 15% throughput regression for IAA and 2%
regression for zstd:

usemem30/64K folios/deflate-iaa/Avg throughput (KB/s):
sg_set_page(): 357,141
sg_set_folio(): 304,696

usemem30/64K folios/zstd/Avg throughput (KB/s):
sg_set_page(): 230,760
sg_set_folio(): 226,246

In my experience, zswap_compress() is highly performance critical code
and the smallest compute additions can cause significant impact on workload
performance and sys time.

Given the code simplification and unification that your SG list suggestions
have enabled, may I understand better why sg_set_folio() is preferred?
Again, my apologies if I have misunderstood your suggestion, but I think
it is worth getting this clarified so we are all in agreement.

Thanks and best regards,
Kanchana


>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
