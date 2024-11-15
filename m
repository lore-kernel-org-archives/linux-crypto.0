Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219C1DA23;
	Fri, 15 Nov 2024 21:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705431; cv=fail; b=AKsnzwyzBzUatfDXvJ5w3QQbOYVXlTmb0ZXhVaa6CJxtnqCP/aPsUzqlHzI1F1lP2K5cPCxOlxxfk2iSHaNvxLdexALs88NrKIpwZTOrmQDrKgeyvgzVwWcRCaSpDz4LZY1zarcKnA0XnRzu6SwQZ6J4TVcTjqucSrjLToe9X+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705431; c=relaxed/simple;
	bh=rCAUGtlspUnk8Qu0Bde/3P2u89kSMyEOTfAY4InD1uI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QgVBUPtp5KYRgpig4Uh+YokhBJRBXPsy7K+JyO7piaQysHCRDuDH8pw14CM/DHGz7U9trlYKQCyJSUAGzmIZjTKBJo+UBsrxM3vNQms1K8ec9JmxeR6KoL+7NmMfAjBnQbk5BfTdcczEwaR4Zdz4D7Fm2rqi0T0q9utzlh6ga1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hr9rGUS9; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hr9rGUS9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731705430; x=1763241430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rCAUGtlspUnk8Qu0Bde/3P2u89kSMyEOTfAY4InD1uI=;
  b=Hr9rGUS9G7TofhlM5uZZvRo1bWuuoq3syfFeiBTxkU+rA4oBF7lzUxt7
   xK1Dz107mNE81sA4zbfgro3lds2vp/YZb5gDBa6WG5GnetFIfAAftLBmS
   Z8yxtk/jLqkpT3EXTnRB/+JvMkQdcVQnBBI22RXOAYfvOK6hCUVrLY5B5
   nqV6N3D86HRiK7kTFIPNMfBAcz8kccjB7RxVbtxN7NYERTqRUfIz+rWUY
   /4DgmqjZ5vHtuDAqgtc513wQcj1yhvVVFzShZDBMI/ax8DRVZkjLSrzvO
   nVp98J8QCzbT9VFbS8uP4CzenKJ1kGehlSQ5HHzMaVtmoqU8yv1c96o+D
   w==;
X-CSE-ConnectionGUID: NQdqOvzSR+SXWaEAWdxd8w==
X-CSE-MsgGUID: 9CsFnrw1RhSLKRNdTsrL+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31483650"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31483650"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 13:17:09 -0800
X-CSE-ConnectionGUID: RO+WPZwNTlKhQWttqry0Ow==
X-CSE-MsgGUID: AL/LSft0StCBdzy2r3DI7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="89077411"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 13:17:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 13:17:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 13:17:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 13:17:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpfdAGBocf8+KPkG/SDXoqYghYcD80r85BtwXAfU4APZkD21uLj8OHdwn/i9oae4O3zHROx0+eAEbkG6SP7tGLtgawhcEiG6OJ/wD5EYPN0UR/bjtqgRVZDqfiNZF6HCKBB07QbjR/X1AD7gN13k6UpcA+Vmm5k+G6ZVdN5XFpKVq40PyzQt8RzUF6LMTQIrZ6p3EVUgZ7W1Z2BFqUKchRollMFgxb490p7BFy6ag5N/wPAGsCwm8+izQz+8GuqVMO7J2/Zd1kOfnBeaXbomUCn4XzyQ+fV3qFS47jCV5jisyAl51SyZ5IWpE/EV5Zmy0kuo0EfR9fkS9avLXoCuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDQYVh6t7bSTyXkoh5FZIUk11BkNLneNoGTb0pGc7w4=;
 b=Jpyws9FJBKxvqe1u2HFn3GrVGfBKXTupKoaHZ/XmSB4aFUpq3b/9MMYcyM9P4Yffs0Y7LhvU20sVkpzXEhN2Q7K5IHZQrIp2yH6ChuqucXmWZCj9d6Gv5qZb1/oxGk4dFqe/XBZ/lQGFTaj0OqL88/OQR6hXEri6vxyhp4lSKgMwODH5u169+/TAu32hlYn61rdyHwqAaZkk0xG43luY9+oV9pwk1k9FeXuHYG4SpaVQ1ipDuuhFosNcPC2LTQSUq0Bo/xTib5iMfXeKZaf+8Q5vTcZzV7zyht0iD+NAN7GF63lNLZW9SJhz3TvTAcZwRbrO1idHyABI2/8M4H20LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 21:16:55 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 21:16:54 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"zanussi@kernel.org" <zanussi@kernel.org>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v2 01/13] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v2 01/13] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Index: AQHbLZ96S6+VCFtXz0CZAeW0BLMs07K4SPaAgACiuhA=
Date: Fri, 15 Nov 2024 21:16:54 +0000
Message-ID: <SJ0PR11MB5678647BE6A60744D07977D7C9242@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
 <20241103032111.333282-2-kanchana.p.sridhar@intel.com>
 <ZzcxY8P8NdfwvxB_@gondor.apana.org.au>
In-Reply-To: <ZzcxY8P8NdfwvxB_@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SA0PR11MB4672:EE_
x-ms-office365-filtering-correlation-id: 4e586b3f-8ec3-4703-6101-08dd05bad4d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?JAbxQlcfTO31BPC09xOViAkdn3qFDwpBtilC7Rwi2eE41+1bYuHjqzHQSnUY?=
 =?us-ascii?Q?STzYxq9xIC4tCvPsOklK0v7/uOlqNalcp226XH5kBdElSNXq1xn/sNKFOt5f?=
 =?us-ascii?Q?ER4nIpLVg5gVXv8gZ9BBV43NklPN9IZxni0xMDT2G4jl491nHppXhcx8iMVl?=
 =?us-ascii?Q?UetLFSF4/QqTIZ08uNiZnKSIq08ONv+kPDO3/TWSy2MtwuWge70yGB6bY11C?=
 =?us-ascii?Q?tpa6WBn2rl8/O5Sle3lWv8xDBY08Q2ASO/VBPS5BbTXrfPOqocWq6YiKEEU4?=
 =?us-ascii?Q?sQIeJ6O2AG3T8bcyvcMRK/K4wRyweVHXhPsC2F8ODhSXicuLKRPkQvvB2cq7?=
 =?us-ascii?Q?SvFzrxqp3gt/XN5la/JCURozuV7hFV7O793f2ldQovtKPliX+HUiTF9FX6X4?=
 =?us-ascii?Q?mq6UBtr2bW8kf5IHg4e3NqtA7Sh1prL4W4CKhMcJjbNSZ6yo3ePDfPFztaGn?=
 =?us-ascii?Q?8KPHuTlG/hgruu1GmPkcSSoQDhn+QNiEWngYnWM8+/X9AWPbl5kQTNX79pON?=
 =?us-ascii?Q?8T32ncvq3HtD1Dxv5+6AfHcYm5KQmAI7ywa4PZ7cgLY8CbT1pC0VfJzofnlh?=
 =?us-ascii?Q?kq6wgkWu6a1rCXYog2EVm/E77PBcu/dyQoujK18LTdhXmJtN+9UFBTabXrKl?=
 =?us-ascii?Q?Ypy3udk4pzqQ2rIhixNcMMlEl4nIGDZtqEdeW2ATvOMYFbyw5WzJMhaxrDlV?=
 =?us-ascii?Q?vOGD24MC97i8m6X0pf4zl/DfgJ2LDHZIoVcnBE95ABVZD0tGCHvf+8LvwQo5?=
 =?us-ascii?Q?V0eHaDCxLjcr/uHhA7Iot3eZbe5v+IB+f9cRNqeqMOcJioMA+Zl4cpKYLrMx?=
 =?us-ascii?Q?FVZArhleGfM15+Y8+37pyj4hhqPFe3HuzgC6drXTxcuIzbBN0Bp42Gq6twnR?=
 =?us-ascii?Q?VRLC5NPv4c22a9UQClHUwhjxiEsQXp4L4C3xDrImlrB79j092L+QXmt2zPq9?=
 =?us-ascii?Q?510s13daJ8yhsQhT5+KDbORGbnWvfqGigZQjRjMjFkbfI/fqgV22TmriWOQq?=
 =?us-ascii?Q?sLVytkjFCReIzVKiBWG5IUiX6okHGOGf2E8/CRmUI7klord2RyipeoMJeG+Y?=
 =?us-ascii?Q?F4QoyB2DT+1Y/vbPGQbA8Icr1DURQy8lBd8BtlgB6ezYVG4umWFvuUSkCfe5?=
 =?us-ascii?Q?dcmSW3heAElmWZTNdnldFeNH7SYohQdNdhKoSI/bVO3yLQkK8hqPA/G1ZwnL?=
 =?us-ascii?Q?KLgP9+2l8Pj/rk/LE2k51P+uctvJPoquqbDfN3AZ35dTjpgfiowplIgYpsbs?=
 =?us-ascii?Q?HC1hRk9ou9X9kGCTwyzKxmLU635NC48RKy/Jkc1j4biMiuJIev8lf9zrylla?=
 =?us-ascii?Q?xACNDBDtcoZvkiqmDPjEon6B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Sx7ceGNDXnnvk4Pvg2rEzsusLJxMsZ1UDVfdZX0r5k7/j8YZl4TnWyT5NqO?=
 =?us-ascii?Q?8KDe+egglLqmbesDFz13CVC+EWfEYFFuK10/Mg+6AGU3sRyKKolsBzHZFhoL?=
 =?us-ascii?Q?avXF2AuFw4DosMz/g6+Ua+7Ho3Pm1GUSndz2ZK98ogGEPB0MysXbVctyMnSh?=
 =?us-ascii?Q?Tm7SdtiGLriLx+vyqypi6YRKLANpAYHaTSzjjDnzgWs4M7bhcSSAPsfHzwJp?=
 =?us-ascii?Q?ZhmU5LWABEEXIl6aRrZ/4UJTnoR4wwLjT4Fi4O6As3vBCo4UNRxbVt/Hi7Bt?=
 =?us-ascii?Q?JBjwhh7T7ed5I2ZJtTwOjKR/uz4gSaSN592pCNu4LbpLBh9C4WVUcjsPaipF?=
 =?us-ascii?Q?E5PNW5ZmLsA1y5br0+VMBeXnnlyh9jXfDdvVXEz5nP1zdzK4nClhyeISe9rW?=
 =?us-ascii?Q?YruqPNICj2XI5dVQcobcvS30MdLE5AfgQrVktAkpbTmf5ZoBKjrYTHW96Kt/?=
 =?us-ascii?Q?VvKLKy/kHt8iEcmuCcbZVvhC9AhbWyNq11lMbyQdH11SFEdYng4NHEOfBwi5?=
 =?us-ascii?Q?Y5tHg40OZmbOJIPqRzy5QMSAfrTJNRj1qClpkEUSEImCWsqYa0Uw2zpz9QWI?=
 =?us-ascii?Q?Lb5CWDhrhrUUfErshafp6xmXZFRiNzZ+gVR5ZLXzWfTFzzD8hOwlFSF2n9r/?=
 =?us-ascii?Q?0BYTX+Inu2mDwFYzqlHRAL6xHSvfmi+FEeM8FO1V7io0GiptlAz6ZyiYRnKu?=
 =?us-ascii?Q?ZTRf4t5XkITs2Tw46ScTM27VSo1U5zrQajQLSEGRsXBT4Ua92VN1gyvjXqr7?=
 =?us-ascii?Q?XP5C0uZn6IZuPMNFceQgNDQIwLK8lRBSNNNyJIM56I1TZjBLvqoYUPs5+0Ds?=
 =?us-ascii?Q?mcF6xcKliaimbvtrTYQzWXjkwIebTbFlt0YD6x2kGP0os9rLmfa9AesycvWk?=
 =?us-ascii?Q?mP7k9GV7/AWw7Gz1Fc2SO+70hrAU2cNyeKZZ3oURGYwKtFijwCIrdanhZrXd?=
 =?us-ascii?Q?k+h0Q8SaHscH5NlEMofxjjHSMeC4w/Ool3UaJa3eouGHTYPJTTHqtCrcRDir?=
 =?us-ascii?Q?SNstnY0fl7qiyloeOW1KSXOIxoRhQYaoqIr3E0omjKBYLTttamZxGiqjs0c6?=
 =?us-ascii?Q?pohZCL5ITrIClfj6UBWm8NHTXVtd6NT3GkQqCYsN4ZhPwk3tG++5gNZd+aVk?=
 =?us-ascii?Q?Xg05rSat+1JfBXfuI539XpJxdDdYO0tmSJb0TsoTX5Z470yAw66NxLG9HqgX?=
 =?us-ascii?Q?YN7PTE+QyyEamXrOmyfNpGBIr0vNHvYd+pdN4/oN3TQjg93VBZ2dHRYAtrnB?=
 =?us-ascii?Q?/YbkjMcSlV3ZirwRjK0l9ZSGmD0YVXVUfVOffgAXMIrHMKhH5jcd3p0haCxZ?=
 =?us-ascii?Q?UwLpnMytpKMfalxVc3Cel0ONKnOVkQLoDpZvSl9206a/Rmu8f9g1IatAOGm+?=
 =?us-ascii?Q?B27UxZhQpdOduYpo65PWToLYN6JhuM2W1FWE0KIHuoMmA78n3NSeDRlFnTZN?=
 =?us-ascii?Q?6A6PxdStfh3WgNBiREM6xv2rKcoYSz6zoax1E6f6tjPnTU8h4mGqDNAYIrJu?=
 =?us-ascii?Q?xwH5FtzkRS0W/ogHbI1iWNeeTRM34ZmkBeqsstJM8XLzzblaNZFzpvVuVJfa?=
 =?us-ascii?Q?vT+obAY3+16QcOLbU25C9LyL3Ag0UnNsgNbUlQMb1ykvgqFy1XObNey4lBeW?=
 =?us-ascii?Q?Ublp2M1gP9lomaxKyQNLWmzjqX0qqNgY3MeQHzi4SaPDz109YszLx3EFfzdT?=
 =?us-ascii?Q?PNjRBQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e586b3f-8ec3-4703-6101-08dd05bad4d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 21:16:54.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pz7Rxwkyr9mZgnWoiQ34OOxtSKIH/LsJMEFk+hUKtt9Rsz7GI5DWLQMBkm783E/hN2ahRZTaJsSOGnIaWRX6u/2SkNNHdjMXTDfLQzNis5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, November 15, 2024 3:33 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Waj=
di K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v2 01/13] crypto: acomp - Define two new interfaces f=
or
> compress/decompress batching.
>=20
> On Sat, Nov 02, 2024 at 08:20:59PM -0700, Kanchana P Sridhar wrote:
> > This commit adds batch_compress() and batch_decompress() interfaces to:
> >
> >   struct acomp_alg
> >   struct crypto_acomp
> >
> > This allows the iaa_crypto Intel IAA driver to register implementation =
for
> > batch_compress() and batch_decompress() API, that can subsequently be
> > invoked from the kernel zswap/zram swap modules to
> compress/decompress
> > up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardware
> > accelerator to improve swapout/swapin performance.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  crypto/acompress.c                  |  2 +
> >  include/crypto/acompress.h          | 82 +++++++++++++++++++++++++++++
> >  include/crypto/internal/acompress.h | 16 ++++++
> >  3 files changed, 100 insertions(+)
>=20
> Please take a look at the request chaining patch that I created
> for crypto_ahash.  It should be applicable to acomp as well.
>=20
> https://lore.kernel.org/all/677614fbdc70b31df2e26483c8d2cd1510c8af91.1
> 730021644.git.herbert@gondor.apana.org.au/

Thanks for sharing this, Herbert. I will take a look at this as I work on
updates to the IAA compress batching series.

Thanks,
Kanchana

>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
