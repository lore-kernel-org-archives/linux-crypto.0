Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B821D358C;
	Wed,  6 Nov 2024 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925585; cv=fail; b=YXxz9IarkwxsvQxVCUqDLFJFakFt+Hgeg/2YomJiPXI0Kj+kjU0jnrIN3EOqHoCLP8sJBGQvBVXZLmxCyqeJPUYDd7umT0E5AdBY6n7Vw+kdGTBpuJJGQMovZEGOcS7tSHvUPjjC85wdMjatogfP5W8XJ0rqCixUjPIzJJZCpPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925585; c=relaxed/simple;
	bh=cq+jUYOAFW1iz+6R/Io+cabYGeknahyV7Z3WGz5z7ow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n4uaiDZchHqeRmYQpE55m2iWMyk+9APvLHIhnvbhT5QqNrTUuZxManoEO3TBulYEUIp7ZtkCuBDYN+LodsH9UEz1XzqKoRazoCOEbHnsJo2BNk7dTD1nEMZ3P28FIfqgGCZ0A4sGBbseI4KxE+/bQGs/LQ5vNpcEgxzxNlepLh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gU2WZCSt; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gU2WZCSt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730925583; x=1762461583;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cq+jUYOAFW1iz+6R/Io+cabYGeknahyV7Z3WGz5z7ow=;
  b=gU2WZCStYxI62Rqr+qOiSVasuPff4jZnPoBHS1B4+UXQ+/JdQ0az3USQ
   SXFneuIjYNfbUVLP/TusCjT8oQqeRI+fo9sS4+GPFsZ6wubBMRzcdgRle
   Kagm+32d0j0ovFn0HptzWCl13NvzH2BAg2WA5HJSI6vq3TVmf+0e4YGL9
   zVPQiPTYC25CgV0PCI4AhXUqAHgayq84sOnONWXCNw5xnhBMIQvpv/ixu
   nzVR1F72+kAk1hwnmdQYZKhgstz/J0PSw3CNwtsDjC6HmJ6XUiel26XRt
   bqRPqGNj7UChWxGDPyhPH2+n855E+FuPvLjE/vh7yVEqSf2FOcJldGnLN
   Q==;
X-CSE-ConnectionGUID: BuC3t1xjRLeHPgjqFIw9rw==
X-CSE-MsgGUID: NEh7ZrI7R+iPdANiW9JhEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30706837"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30706837"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:39:42 -0800
X-CSE-ConnectionGUID: mb8KkYszS6un67GHDexBFQ==
X-CSE-MsgGUID: R+wyV7/cR6KQ3ks488JV+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="84357095"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 12:39:42 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 12:39:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 12:39:41 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 12:39:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3tvMJl62s/Lvg/w+0fHg/U0MdXgJ3I5QDdUL/aiW/838BV0JSWRtT3Wc/aPZ/p845iDX35Jqx5PaRB1BfLDaZcgMTYW4bl2bTluVmElAk/AkoNktakwK00hwfVTMidRBtDu/oRkd8RwKiuDVSDtbZmqJkWuugtFkIAMm8snRIorJrLFkVT3mZt0ylVHJgPJrfdqAHz8tS9Ii0SLlaVb/LEmnARXsOjRngwZ00l7GOXqkA2Ag+S0lAuP30M4F4Lp6pRkadbEtLEY2MRBjx/jGj1JarMc7yN6CLlfwnO7cEfVM018+hxfpO2MFLHwxW/Z6BI1FcMTbK0C+LPIh2Oy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbajC0twp8rubxfbg7CwWcoUg+Na2W1hJgx9wfRcm9c=;
 b=Rk2Q8Hpr/WA2QkKO9Td8gS6bFxN7NNn8CfKt4yWosaGZvzQSDLIBMMENVZ/5qeCQ6Mlv4YZlS4V7nProjMpy+KBtOjLlSoRJfuhOt6NfFD03AqNCSYEcNiFJYwl2eWMh+A7DDi0AkwHiurXyc8WTcAXiMO7Kmxw5p97RO/Ord1u6mgnDQG1ppsn77Qf1cqN3pGhkydjF6oVhpghYIobekFz2+CxYCs5UpbG9uZoGV3reSjcbgXk3J0hJ/UnRdV4o+jE7offN3tB9gTUZmLmYVBLx6wTMKs0POggc44UQC/WPZytfuq8ekJYUz6yzaJFe0LuF/0fFcuoqhV5sVg8EFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SJ0PR11MB4941.namprd11.prod.outlook.com (2603:10b6:a03:2d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Wed, 6 Nov
 2024 20:39:38 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 20:39:38 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Topic: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Index: AQHbMIESISE0FUMsYkiPsANVvfbhO7KqsOoAgAAFxUA=
Date: Wed, 6 Nov 2024 20:39:38 +0000
Message-ID: <SJ0PR11MB5678DF05999B0D723C06325AC9532@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
	<20241106192105.6731-13-kanchana.p.sridhar@intel.com>
 <20241106121754.644440c6d8d1edf60f6163d7@linux-foundation.org>
In-Reply-To: <20241106121754.644440c6d8d1edf60f6163d7@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SJ0PR11MB4941:EE_
x-ms-office365-filtering-correlation-id: a4af5166-c090-4d87-b3a7-08dcfea3220b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?UBoHM5UwmrONo8jni8DsJ0j1IAlj2tsldwrUC0mbd9TEdYGECrUlXdh/AygR?=
 =?us-ascii?Q?XLy8TCwXgxyaZiI+MJuVVlaYRuvPt+5XxRVKVzmhPIfaP9RFfdLVP26ID1AY?=
 =?us-ascii?Q?/l+X69iG84WiPfIUVCk7p9tpGMPW4sRNBvoPW6KyJ9PSIq41yVcmrDX7YG0n?=
 =?us-ascii?Q?2B2uDy97kRtYCOc7DffuQ+0BGLMtJsM+gHaY33xcsDr6LxswPxiMaPkRihRQ?=
 =?us-ascii?Q?4N72PWEjIRiQtNxi4BKuNEumbGkHaDJkRYGiQG8wDS4TZwSxi+7EQXWeuS0W?=
 =?us-ascii?Q?oyixMpeZLKOSZAzgMuvpBmkXA/OKutBB8YLjAjuwAKPdrtCUuIjfe2J7TorF?=
 =?us-ascii?Q?+bB/bjqI0vJN7YBYokOsqK6WDyaRcRmSjtmsZyJQp9ko03bc3D1/8+l3wOxK?=
 =?us-ascii?Q?/wX3Hulw/+M5U2lXYFYg8LzVHtcQr6NMfdT5ncB6gV/oVi2aiQiO3VXIizul?=
 =?us-ascii?Q?Q84JSjcIwIr2u0c+/KVmoCkciRIyu0G3XWt8h/u7fiKWkBN8PSmTsgzzMIb9?=
 =?us-ascii?Q?rfDfWqwMXRlsdm9oRqoTQv0dWZTRMnsEEbhd0jy4L3Ahojhy7HGg3vC9Ivte?=
 =?us-ascii?Q?SnkZEzPk/O4gWmC8r0LFOmPBT8MzxTQx7fp1QRFxrx395iV+MvqIPwzRG5Dg?=
 =?us-ascii?Q?zp0ZK4YwuMG7ALuyoXAqSgbEYiwVoafc2kidteeYXcamfSFohcOR6UK38anu?=
 =?us-ascii?Q?n0NrDyuyVlG/wjn+qP0Mk7XvGohB4WKiCqKIDW9cIlSPhjiYTs7aKT3s/32F?=
 =?us-ascii?Q?mYDouwQLPW26XQwz7aCBuN8IOns7JbCyUQmWlu5ZTyPXlClCnvEZfRtruaCD?=
 =?us-ascii?Q?eIK0M5mT5Ds+QJClgSgiuRWSBipzPm+M2F0nEcRJjRqERRJVx0r9+9mwgniG?=
 =?us-ascii?Q?+tLuEP/QhChKSPTllD9jDGql9RR2WqZTgpoq2D3zxHX6nMpHX2qUPyD4B/Fb?=
 =?us-ascii?Q?+7iR3j+u2uUJZf2mJq68WAzKjgJk7E/CoDeVbBnWf+FdjQwJlgldbRG9tnzs?=
 =?us-ascii?Q?KtuYu8eVxTHNfXq2sgzgUjCWoOLzVGYtO7OEVLHsiY41cC1Q1bgg0Mvo77Wu?=
 =?us-ascii?Q?7uBihxveI79NqzMOrAIVHYqjT57xmbwJPpXuxOkiLvwQmAvJQhFoSzAt2mvc?=
 =?us-ascii?Q?Ed1v23GVkhe4f7x132lGwsFs0gXqcWZBGwv7YZDfCLPtCYpGXQSVnbiWLleJ?=
 =?us-ascii?Q?f4xRa2Xldf3bPRbpLz4t3D1onuqtz4RM/80Atd8x+zsf8+8XJZmihp/hVkWD?=
 =?us-ascii?Q?Elb8zdSRbMrqU6z84JsaYF9DzaY2fHHwLrHJJpNbrmkq8Q+aLNiWSExmLuYe?=
 =?us-ascii?Q?ePtPQh8CuUCK9SLlBMWixTuqgh9X7OBarWsC7lFzehmxaIiieDqqo4XiDNYt?=
 =?us-ascii?Q?m7F1bkc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?90k6ak3CZKR44I2mImFzNI76V3rfnTOdtHw7ZXlOIhiv+S+2atc2sbSW5nF2?=
 =?us-ascii?Q?mBb9hMMXq/Yk6wfBJKb5CTyE0BrZBZqmLZprdz3wzjVsgprdzQsx3/5l/5Mh?=
 =?us-ascii?Q?kT4cvCGPVzcOgN3nxYtuHjyKvvqUcWPModikFKzGiR3ePp/5I7tbr90gBq20?=
 =?us-ascii?Q?thr4QXaTClF1BC4Rx4AdCq0e62Mmrf4HQyp9qbnQGwHlzJ5PgawqDflDEaWd?=
 =?us-ascii?Q?okJ+MG7y5kB8T5FUN567YciULqUUcLiVjC5N0FwtnzVzGhpKk883TsbllDpW?=
 =?us-ascii?Q?W2MbysRQbF3toHOEJsKZeDObzRKmQDqGUMxOjZpzXzDogYaVku8TNOilAoI2?=
 =?us-ascii?Q?weodF2CA2D8Q25E4n9SLHYcCgcyWledFp2KscN7Jqf8wt8FXPCmC3NiLO3zz?=
 =?us-ascii?Q?Vid8PXsZbYSI/LgzL3O5iXfozzbXkJwbi8zj1xbW4Mshpxsj82UDz3otDaiG?=
 =?us-ascii?Q?eaEAfVxEQ8jX2tQDRPFk4M9Qd/jcGGI6TjkobCiwAV/O29lqdLeYRFTNYpw3?=
 =?us-ascii?Q?VfU5LjF7ZwO6uji4ddq8ISsPNkJkVSDJ10+7EiOc/n3nMoYuZV0qc4c3t3r/?=
 =?us-ascii?Q?sqwh9v04H87wN/nYxCclvmSvBb7seF8MFqPyGs+JYL0QnldBtMIoV9t78cTT?=
 =?us-ascii?Q?JVLlnZj13nfVcvo2eVuT5S53LVlGEsTpLbgucmYr2YBuOqxa9GJEdEMlIRsF?=
 =?us-ascii?Q?KycWzvZzKK2/XizXiM1zi65Uf0A+jktAv30mlLuNjVNpW3UbU6sxsJEB782z?=
 =?us-ascii?Q?co1+rnaKkmxy04943OoWVNo/Az1YPQZRW4D8vlHgtR/qg35lrlwdfEjvc2Vf?=
 =?us-ascii?Q?HKAF+FtreZMt0nyfrQdriIU+kAIP9SfQ7T+QcpXixoJhLSELvep4tsBZ/k00?=
 =?us-ascii?Q?kshaqK4sOAutTvIMSHZzUb0Xeu5Rq6gysq7zQ1RUPR2R0rGYujKMX2YsfuHm?=
 =?us-ascii?Q?ES345nw6lO7/PVBpXIGg7cn5nme2+T2+Utt2nHBoP6U0dcICZ6DD1SYiup7A?=
 =?us-ascii?Q?fdhxC7KDLhaAvyoXw7zpLAiEhPxtGx1AvGaHnKSGAR8vuZlJLUuHEa56q3Ho?=
 =?us-ascii?Q?AOv31Cj9xyZY6F0DdvK/Usj8Bb24ZcB6nhgqR6fpfD3/mNBtenj1T+e5YyDS?=
 =?us-ascii?Q?WCBA7XBwNk5VwuJhu+G+yXZkl4TTjnPiFo+VQo4/GPFfL4/PHPA3gf6lENUI?=
 =?us-ascii?Q?Cv3d5bq9hWjA+nXzRRFegiQs1tYGvoFVnzSS+TPWS6bzqlmkIIHoud7ZTiqn?=
 =?us-ascii?Q?ejGgOvvleJeemthYNXaO7wDOYnzRt2geVSxUIA4v6+6r7hW8RjBqEM6Dew9b?=
 =?us-ascii?Q?OoDsB8svI0tzZTcPhgqNEKIDAxVbt5lcDoZyJjeAgnCd0+YgIkyouZzuc+LZ?=
 =?us-ascii?Q?GIVIcO1XXuAk4zZe8W75kfSMGEBAyoBc+788dX6BVcC8Fz9zy9q/WlBnjjgY?=
 =?us-ascii?Q?0wx3Dv3zlnSCrsiFJD1sPPVNQEKfezrdLMKso4GdG75hXow4OyYn6fkA3v4J?=
 =?us-ascii?Q?szQaWVvk1DASV0vsnOh/dNLYKw2aeZNiV5meZCoU0jDntsDanPa3R3FIKwYI?=
 =?us-ascii?Q?D/wz+I1UYuAdUihYDkATptC6vrFS/RnKxe1PE+BOWDps+2kv2Ff/ANPTMQ4i?=
 =?us-ascii?Q?lg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a4af5166-c090-4d87-b3a7-08dcfea3220b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 20:39:38.3904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mvy27Yu8nnf+fBLkgl5c78nGJ4FSLShj4at9XCZeVCw3jq8zPQQw+Hu+/Y3tVfDhfGuxIyV6PITjooiviHQeOVgNQQ+kb/D4m13Ij5glPg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4941
X-OriginatorOrg: intel.com

Hi Andrew,

> -----Original Message-----
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: Wednesday, November 6, 2024 12:18 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> zanussi@kernel.org; Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal,
> Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch
> for compress batching during swapout.
>=20
> On Wed,  6 Nov 2024 11:21:04 -0800 Kanchana P Sridhar
> <kanchana.p.sridhar@intel.com> wrote:
>=20
> >  extern int sysctl_legacy_va_layout;
> > +extern unsigned int compress_batching;
>=20
> nit: I suggest calling this "sysctl_compress_batching".  See how we
> treated sysctl_legacy_va_layout.

Thanks for the code review comments. Sure, I will incorporate this in v4.

>=20
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -47,6 +47,9 @@
> >  int page_cluster;
> >  const int page_cluster_max =3D 31;
> >
> > +/* Enable/disable compress batching during swapout. */
> > +unsigned int compress_batching;
> > +
> >  struct cpu_fbatches {
> >  	/*
> >  	 * The following folio batches are grouped together because they are
> protected
> > @@ -1074,4 +1077,7 @@ void __init swap_setup(void)
> >  	 * Right now other parts of the system means that we
> >  	 * _really_ don't want to cluster much more
> >  	 */
> > +
> > +	/* Disable compress batching during swapout by default. */
> > +	compress_batching =3D 0;
>=20
> Not really needed?  The compiler already did that.

Sure, will address this in v4.

Thanks,
Kanchana

>=20
> >  }

