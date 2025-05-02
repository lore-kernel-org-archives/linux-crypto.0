Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D86622A4F8;
	Fri,  2 May 2025 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746201202; cv=fail; b=IVhCftd8gOp9tVpoehweA0u60X1ktnk6os6lFfADKvHGX7XMnOyay728OqlY4phpHBxBI4NP97x7O9B6A+nTK4Lj+5edjXoX1nfmNOEGNh8gE6MZMLXKsJuXT2oiLHjvkdTBPVzOoGMqMKykzgujX5PbbmNWXEKnbe1ccMr8+3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746201202; c=relaxed/simple;
	bh=fnJI4WSxssDUEaz0rVHqLxkzWm3FOlqpW7DJ86Rov+M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fTa/bgcjyTNb5DOLYeDK1cvfTAOGOn2XrsN8vqzVOLTLIKwJsn2rGYT1OAtxX59zgcKzEZVqdQSPH2TDHWLCN5flnEi7dmkffqXuk6kF75NJ7z09xSAyZQxXPlY23AoB2Bh867SoNmNY8ZTpAFfGXnxAjoZDlKRenU9C2z8Cwzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2CeqyYp; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2CeqyYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746201199; x=1777737199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fnJI4WSxssDUEaz0rVHqLxkzWm3FOlqpW7DJ86Rov+M=;
  b=K2CeqyYphg6q+XzMCPAMABndYHDI1nXeJDy0Fl8GKU9GpSZI1HFchc98
   mXb4RU0mHJ2HX9Wkl71F6NAT/oD3/G7dLYgual4uw0P5yD4+tJBnK+gYB
   JGKrnHXu3f2x9l9sH8qd3sZiiXchr6mqEResOrsrDkAAI8uoLDPfI9o4y
   pSa08FTwaKcvLTnBI+PnfbOhXd+9FNRo3lg5vtMlr8oBFN4xWKYaOIsOf
   bLZAqyWGRAzZLiI54bJmhFeFOe06Zdx8EQgnSB4jDLpmbQXv4Qw9ICmCx
   vUwOgFuvqlGkPC0bC2c7aN3KlJXLC4OQmMSioo0G4YsBIRBJtBCcLmQjb
   A==;
X-CSE-ConnectionGUID: /B7+RKSUR0q/LiUrLDZ1Hw==
X-CSE-MsgGUID: bxZmYdBpQy2lf9DfPW4pGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="50541345"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="50541345"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 08:53:12 -0700
X-CSE-ConnectionGUID: Sr/j/jbFShW1DZH+GsQUEw==
X-CSE-MsgGUID: Di0TaOQ5T2SZdUckDHgt3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="134419273"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 08:53:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 2 May 2025 08:53:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 2 May 2025 08:53:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 2 May 2025 08:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dO2HSgNlXa+LZJJU8nKB7crHfGGAU63zgmqnIkXkJ6wqdQQhAllu51eO87qZAuGSI6imxcGwuWqGlCV4VSev9b+Pgbex+dQPzFb/aTTm5vhL7PymDm93qLHGz8r85UkAkpaR2dXp2I+WHJa7hsL3Jb3etsis8ZWTrz1yzYMTc2t/W8yMI/SdIMkdvEMyirshsuUMclXakmAfi7c+QRyL8qAxZ8WBXv7hjH4+fPdVNtjNEXSVyT54MSIYR/R3DZ5PTRj1mXOnuW5F7Zs1v+UWR1gnobxYtXnJj8AtISa51MAqk25Mp+D3QZ/V8pBkZypijg8djKUXDXq8oPZ+55V56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJM9dFi6U4K0IIRA8+wZh266skZPKVEwqE6XiAk/6lk=;
 b=kgv05o17VQBNJwj+jjaYVEIgXTYhgT5LdXddYQvhnuvIq2Dyn7ztCliaj/Dz/jRqziLv0dnlDJa/xhqQv2kYDVDbIlZ7pxcbSYpblwwWXIUToV5r/Ro7qY5g/OHhRvO+FW8+Gc2DRabSlhXno7nsr0LmmLIyg6cy7a56n0q6X7Yr3c8c7xiiBnXfVn1xTuBc6g1jFxakLA5DAY597w+KbxjcZ6LpzszwY3mnzR3ViaO4QJyFOE1qUd+pf/AukN71TRp0WF4OKVsh5MMIRAxRiF8EgymnAcrJfdKXBOpP+6ZGMJAaSJ+EEE0DSqB7OKjLmMe7F/6497oXlq00nTEdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Fri, 2 May
 2025 15:53:07 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 15:53:07 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Topic: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Index: AQHbuhHqqvvzDgyN0kmGLETwq+HXa7O9AAgAgAJ9QoA=
Date: Fri, 2 May 2025 15:53:07 +0000
Message-ID: <PH7PR11MB8121D578B8BAA95B07D6EF8CC98D2@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
 <20250430205305.22844-11-kanchana.p.sridhar@intel.com>
 <aBLRKuhJOSF8kGZv@gondor.apana.org.au>
In-Reply-To: <aBLRKuhJOSF8kGZv@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH0PR11MB4999:EE_
x-ms-office365-filtering-correlation-id: 0ef15368-6624-4f88-4dc6-08dd89916e93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ho3ydbnl59hcTCCuVss2reRQysxnjcQsyFPWraIJ74Ol73mCsPRdKorcjDm9?=
 =?us-ascii?Q?LKKPqiUFZiomXOjePAsP44TFElVBJJSEQd0ZDvdnT4NecY599At3GqMr+WRi?=
 =?us-ascii?Q?4g0OBwv5Xr60dLQ3UP9p+64Q5N6bk26Ua/LpqT0+usXggG9gRrngriJE4IE1?=
 =?us-ascii?Q?YOP1jbbip9LksfT2CW/9GRJ+a8EWbCsqL2L7t/1zNItU6Ed2pawkpJfxq4no?=
 =?us-ascii?Q?wwn12NcLtiRX86o1Bpz+Q0G0CDiF6P9pyKS1FCQUALkkYIDcE8YV7M54Qe7O?=
 =?us-ascii?Q?XSi03sr7HC+S5FQwnIZNEb4gdGx5T8lDc54JYBGjPBnZZPB7isvPVJ50xY+D?=
 =?us-ascii?Q?DRvYnHon22CAfJE9LKsYPW1zPoQBI/qTlXq2cIDTxIlC8mFzbmLSZvtvYe3h?=
 =?us-ascii?Q?B+WXoBo0zQtyWEkJaG67M8o/Uek95WlQ+/AQC9o01EPvpnbLK4Cquc4Ta0dh?=
 =?us-ascii?Q?lV6NqWEjwyjTXzHvCVI+IDrD9eOgVrPyUioYPT381JvFBkaSPCMwtGuh5NEs?=
 =?us-ascii?Q?hK3/sre8xSjn7gP9zFTnDHJ7754WAAORmMpRS0N7Ks2ecuIP9qQzckejBcwl?=
 =?us-ascii?Q?hivcfGRIyWvWXSuKGqw1I72jucC2epoy12wFWta6+jkJCPiUK+ekLTPH2OcH?=
 =?us-ascii?Q?LD2yqz/OtO0+qP3XxbXeU7rieLw39R9B4k3XG7e+5p5xVjd9pwsyDcImb/ZE?=
 =?us-ascii?Q?2EXFuqNKFCQPKnAW0uk283oifWbfoU++T49UWdWpCiUCuIe89tE0DLWhl7Ro?=
 =?us-ascii?Q?OruUaqeLdvGFmHtQFhyOPEXWQlZk2X3bJ/EDEr1oNgBR5DHth1vAy9NdOGoI?=
 =?us-ascii?Q?aO/OyNEdun1q9hN3KFew8PR3fImvUybHDz32CSUQq9AZqjJsm7ov9yEy0f06?=
 =?us-ascii?Q?AUzbLp/DfQdlP3rtBXNzo+JD3Ei8uRflheYvauCgoSPe3LZYHQBkgjH8adRA?=
 =?us-ascii?Q?8sEBIRQb2IgHjrzScgWXLelK8ZA8ABJGvej9gG8qQb729k3MXGTZcF1rLbeI?=
 =?us-ascii?Q?GN76qY6qIVGBl8w/yaol4C0f7YGz96PotwxwaTKzmLLsTCLjPj9XH6lDy/mJ?=
 =?us-ascii?Q?3PkdHZfs2+jwaKw+b6tcGB8szzd+MjZUr+2d8b/IfqjW/nxax3DysdMCiXhK?=
 =?us-ascii?Q?7y5BzMMv7BVpibA67RFSRTF8w7uOL7nwaDLw9A5zB18dMStx/1O7AD+GTzZ2?=
 =?us-ascii?Q?nDlRZHptFcJzqmelfPUnJskK3itkfN/1qHNA+VrlhAHaDSaw3nToOn5Ac9Fl?=
 =?us-ascii?Q?xy7VS75Eg+yOun76p50hwtlT8WW3BSHJIwCTgKc7alpBW+/0anqz2BkmnbUz?=
 =?us-ascii?Q?C93/jVvRKgv6P5pO2v5+GAXttL5AbnqDkduY2+qvqEXwaxPkY7NZO9pkBT9x?=
 =?us-ascii?Q?YTqLhPmZ5mCI0l+iE6qiU/5k5pOtUSRrkEYM3fLHnkMNTMzbuKtlfyWsjANN?=
 =?us-ascii?Q?ctxPL8LKO5c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m55nTYk+E5nvxY3jLrpY9jvjXsfrWPvpKrSZSZI0+xYidmzVeJXvRmBBktp6?=
 =?us-ascii?Q?ZTmuqv8ukC/Qerv+/QpSIMp5/sr81JHILSgOJ/ytmZDtI6y+S9bJvf1WqAix?=
 =?us-ascii?Q?WsC3PK1smzKrW4jvCXXZubDCyT+jUUfPZ0MVsQriL+woDrC5n9Y6E0SHn8F6?=
 =?us-ascii?Q?GxmuqRWM+p/numkbux5vxL6PfU6QsxbV9MZRiDnz4zStDdvFFmpr77kIUrfo?=
 =?us-ascii?Q?QRjyfthPH0QqjIcV8JimWEYnTPfVNhIYW6VVELAhbhgTtNMI5U1YohiVk5FV?=
 =?us-ascii?Q?7nX+pfgDXkLDCQMvv5gGqoTiPMANfqOf+PtzgAvPxgiTY20y4AiN4zsSD+mC?=
 =?us-ascii?Q?uQlgceB96f/cD8qcz/S6lzWXaJghuxAJg8n5bE9rSeZLT7DlLDbUNrcB16TX?=
 =?us-ascii?Q?+68rpC0dYFFTYavMbdN04hBr1/0TosJfVEz1WfLuYw7Q/7Ujzm6Yz3nxf6C5?=
 =?us-ascii?Q?IJ9W/4QWWtLyEm3wn5Q4xcPSUG5LFWCBKFb00Q/PTb0M0wMFXdB+ita9tZyU?=
 =?us-ascii?Q?6uUAn0x6Xusw6M3R5CJZfzDdXy1b+IqgIQU2XRZBOZLvv4icRkXO0XfgiX2l?=
 =?us-ascii?Q?TwKVRLFkMisR5Dua3OGJvObdXn2RPBl+dKNTWW9atc8HvavkIzxJrh9G7w55?=
 =?us-ascii?Q?NG1JxXGHfrx1zfvvcpqHZwwGBZEF8Uq4EUmypdnKvEMPQLxnSCqkHyJInzUU?=
 =?us-ascii?Q?WmDBH8hccOJ15hYb36mYK7zCKCFPlWzlUTkMzzRr8ItOWKIx0hLR/I1UZ0pz?=
 =?us-ascii?Q?J1OFg5AeZ2kOS1UdjRjZaf29eBhKRG6qi1IuijyUwYSB11IF1dRbaDe7AwWy?=
 =?us-ascii?Q?pyHCnVouy8Pu/mt3cmeQUn/qYy/lK8qqXILfqCG6BgYHgRFOt+JZR5MUaSYx?=
 =?us-ascii?Q?MIT7wSQokg70XzhaLyetWuSHNWj0at7BXrHE4RyX0oKCmyQATgXmROennEQy?=
 =?us-ascii?Q?aiswx/Y4DQrx674BJYjC9FVe78K/FqvU+34IN6AavsdH6DoXARLy5lb7634g?=
 =?us-ascii?Q?afjG6JSzlLNz6IGt8yaP1y6UHj2B6oLMw2bHMzOWww8nDKYeET9Rb8/mc20u?=
 =?us-ascii?Q?7hc/2ydPkZtqONs/aMZLlbCmTwQbcUr68Aw8zqGS+JQ2Qj13dsJSrR4s/pAt?=
 =?us-ascii?Q?m8zOOzTR4uiR3yFCOfQ2e98blC+de9ZLGMAUJZWishZ9Gz76XF63OsSNZK38?=
 =?us-ascii?Q?Iy9SXQqDApbauzEhqnRLE7VezNfbUCU6i5BdN2YxxKXhEQ+XK5xz+utjSZ64?=
 =?us-ascii?Q?w8SdQIX05PG7Y79MlxjrEWHzDDcKVWPsNtsNEb4kEQC43bkb6T+KRd7A20wh?=
 =?us-ascii?Q?Qxdscvtk2y3tNzG1Cav14Ps5urRzMV2SKnZ3aRMKPhZTP62aH3tsr2CLnWHt?=
 =?us-ascii?Q?9yqC5cN8f4J2pNoeVrk6vVvmo8WwgWq3hb7u6j1zBrOU47dFYjdTbuDNSqdn?=
 =?us-ascii?Q?Cd7bASEeI+9yiw+hhjq1L9P8BbTaS79nXENUMSGcOSOYMf/+oWJx2VFWYzdA?=
 =?us-ascii?Q?TwkeoecPfyIq/862vOe0dAaV/vg2OR1nAaC0v5DSLJBWFREpzMFPrRqpGQvN?=
 =?us-ascii?Q?q0TDW+MBYnLAq/aHZUYFUd6mXQEmhmQjs6ClbX7FILGPVDLGd8PJ9jNEMyq3?=
 =?us-ascii?Q?ZQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef15368-6624-4f88-4dc6-08dd89916e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2025 15:53:07.4670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YOS8kfe41YG5zDeRrzqOcRtkj7fSBxkaBmtsb6IV/cDlDe43hHhrKfB702wQVtDzjQQEa9OXlpslWYPwqegYTvNJhpxQGRttAAHzAh3ID9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Wednesday, April 30, 2025 6:41 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitat=
e
> batching support in acomp & drivers.
>=20
> On Wed, Apr 30, 2025 at 01:52:56PM -0700, Kanchana P Sridhar wrote:
> >
> > @@ -127,6 +131,22 @@ struct acomp_req {
> >  struct crypto_acomp {
> >  	int (*compress)(struct acomp_req *req);
> >  	int (*decompress)(struct acomp_req *req);
> > +	unsigned int (*get_batch_size)(void);
> > +	bool (*batch_compress)(
> > +		struct acomp_req *reqs[],
> > +		struct page *pages[],
> > +		u8 *dsts[],
> > +		unsigned int dlens[],
> > +		int errors[],
> > +		int nr_reqs);
> > +	bool (*batch_decompress)(
> > +		struct acomp_req *reqs[],
> > +		u8 *srcs[],
> > +		struct page *pages[],
> > +		unsigned int slens[],
> > +		unsigned int dlens[],
> > +		int errors[],
> > +		int nr_reqs);
>=20
> I shelved request chaining because allocating one request per page
> is actively harmful to performance.  So we should not add any
> interface that is based on one request per page.

Hi Herbert,

My cover letter presents data that I've gathered that indicates significant
performance improvements with the crypto_acomp_batch_compress()
interface that allocates one request per page.

In addition, I would also like to share the p50/p99 latency of just the cal=
ls
to crypto_acomp_compress() and crypto_acomp_batch_compress() that
I gathered using the silesia.tar dataset (http://wanos.co/assets/silesia.ta=
r)
and a simple madvise test that reads the dataset into memory, then
swaps out all pages and swaps them back in.

This data is on Sapphire Rapids, core frequency fixed at 2500 MHz.
I have enabled 64K folios.
The "count" refers to the number of calls to the crypto_acomp API.
As expected, the deflate-iaa "count" values in v9 are much lower
because zswap_compress() in v9 uses compression batching, i.e.,
invokes crypto_acomp_batch_compress() with batches of 8 pages,
while storing the 64K folios.

     ----------------------------------------------------------------------=
---
     64K folios:    Normalized Per-Page Latency of crypto_acomp
                           calls in zswap_compress() (ns)
     ------------+------------------------------+--------------------------=
--
                 |     mm-unstable-4-21-2025    |              v9
     ------------+------------------------------+--------------------------=
--
                 |   count       p50       p99  |   count      p50       p9=
9
     ------------+------------------------------+--------------------------=
--
     deflate-iaa |  50,459     3,396     3,663  |   6,379      717       77=
4
                 |                              |
     zstd        |  50,631    27,610    33,006  |  50,631   27,253    32,51=
6
     ------------+------------------------------+--------------------------=
--

There is no indication of sending one acomp request per page
harming performance, with either deflate-iaa or zstd. We see a
4.7X speedup with IAA that uses the crypto_acomp_batch_compress()
interface in question.

>=20
> My plan is to supply a whole folio through acomp_request_set_src_folio
> and mark it as a batch request with a data unit size of 4K, e.g.:
>=20
> 	acomp_request_set_src_folio(req, folio, 0, len);
> 	acomp_request_set_data_unit(req, 4096);
>=20
> Then the algorithm can dice it up in whatever way it sees fit.  For
> algorithms that don't support batching, the acompress API should dice
> it up and feed it to the algorithm piece-meal.
>=20
> IOW the folio loop in zswap_store would be moved into the Crypto API.
>=20
> This is contingent on one API change, bringing back NULL dst support
> to acompress.  This way zswap does not need to worry about allocating
> memory that might not even be needed (when pages compress well).
>=20
> This won't look like the useless NULL dst we had before which simply
> pre-allocated memory rather than allocating them on demand.
>=20
> What acompress should do is allocate one dst page at a time, once that
> is filled up, then allocate one more.  They should be chained up in an
> SG list.  Pages that do not compress can be marked as a zero-length
> entry in the SG list.
>=20
> If the allocation fails at any point in time, simply stop the
> batching at that point and return the SG list of what has been
> compressed so far.  After processing the returned pages, zswap
> can then call acompress again with an offset into the folio to
> continue compression.

I am not sure if this would be feasible, because zswap_store()
incrementally does other book-keeping necessary for mm/swap
consistency as pages get compressed, such as allocating entries,
storing compressed buffers in zpool, updating the xarray of swap
offsets stored in zswap, adding the entry to the zswap memcg LRU
list, etc.

As soon as an error is encountered in zswap_compress(),
zswap_store() has to cleanup any prior zpool stores for the batch,
and delete any swap offsets for the folio from xarray.

Imo, handing over the folio store loop to crypto might make this
"maintaining consistency of mm/swap incrementally with each
page compressed/stored" somewhat messy. However, I would like
to request the zswap maintainers to weigh in with their insights
on pros/cons of what you are proposing.

>=20
> To prevent pathological cases of zero progress, zswap can provide
> one pre-allocated page to seed the process.  For iaa, it should
> just allocate as many pages as it needs for batching, and if that
> fails, simply fall back to no batching and do things one page at
> a time (or however many pages you manage to allocate).

I'm somewhat concerned about a) allocating memory and b) adding
computes in the zswap_store() path. It is not clear what is the
motivating factor for doing so, especially because the solution and
data presented in v9 have indicated only performance upside with
the crypto_acomp_batch_compress() API and its implementation
in iaa_crypto, and modest performance gains with zstd using the
existing crypto_acomp_compress() API to compress one page at a
time in a large folio. Please let me know if I am missing something.

Thanks,
Kanchana

>=20
> I'll whip up a quick POC and we can work on top of it.
>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
