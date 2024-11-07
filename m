Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EED1DF989;
	Thu,  7 Nov 2024 22:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019842; cv=fail; b=bsS0uRRDoBJjQuwRQrdv/DelkVQ8WwVVgJWq90/3R74wPrP9puaGEwuP941Gr3GIkiUNdpkF6eGPLyuf4yLUi9xGbxuGjWwHNuLtaDdA+e874nFUYRh5c+e5OKcbxTP+mRHRjCSwTbvtERE/Qb8Cm/gEeCZVWu2EXdTWDVspJy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019842; c=relaxed/simple;
	bh=xIjrekqteTeTWXeZZ3FinwRvTlENDQDnO+5tRJSeSvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sz7vs5VTShcc8onjX0J2k1ItF8afByFyWGWjK4g0dwUq7Eza81avzQA7f/NZ3qXVTakXGDsP4FAb083NPYR62DbJGQtgLR3YE4IBig8+LVl45zvXcNi4lR6OEtS0p29xYLx1vv/LSSHyDI6BxcQGhI+fDzKH/Gz9PfiRdz8DRww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ygf/Xm9Y; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ygf/Xm9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731019840; x=1762555840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xIjrekqteTeTWXeZZ3FinwRvTlENDQDnO+5tRJSeSvQ=;
  b=Ygf/Xm9YxCwEGiUfkQs8i6rDNhUHU5m4XxC8MkZIHTeUJCgVCpk7yGH1
   pGB9CdW9KphmpiUgfcZDllW4r6f7Syf3j0ctx/gZN3j/iYQmS6jiuA3QK
   F1donPOEgL6OAOPJyQjVjrgynmcHF12qD/JGa+5nS08YY+SKdHkwOXWzf
   SC8g0EKX5KElKYFKPegzxNjcy7AcT/hy7zJsmO/RNGlrXXtRX/YIPRGqA
   NZvG+fYJPIgPvfHTZ4Ut/8LFnsXxDXQ9VR2ETqrQsC/9/XKO6NuY8BhH7
   z9hqAjoynZ0hQCnPj2HzunvmZh/JjWcrSCSfnZfqW5rLi3gys8M2dkYg3
   g==;
X-CSE-ConnectionGUID: OtvjVKSBSU6rTAbjJyFfVw==
X-CSE-MsgGUID: RUOKhQMUR8e534ilBZITpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="42265200"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="42265200"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 14:50:39 -0800
X-CSE-ConnectionGUID: wQ0w7/OmRCOsKxLFzYVyvQ==
X-CSE-MsgGUID: gUT3gvyAR3yQR135Pgfh9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="116124295"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 14:50:39 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 14:50:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 14:50:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 14:50:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WeCHbyFNrWDNt9WG7ic0dLCJLI6pE2vE1CJu0NhRLl9A1vOELd2QFDisx4gM8G1t4EEK83MiklrkO0zQePUOOSuDZVOIv2YHgLrs21bDVeE5r6sVqIrmyHM0izlwurZkBUHyyCbNzGBZ09xwtPJYgsJrzNuOZddWnfZTzFb4mj1EVBD/r6KBfb+LKyPqL3IwEIbFyoUePtfxCAbqqcd9YS+pOt2iJdRCxRBovZnvP1cCE1dOrOv1IH6KwVsBnkClCK/uQChhWlty6rerDxBg51FwiJWPUJ4ai2LaDtye4ssV6pz/lq60CwCGCN4izMRzVi9/UGt1EP9O2T7DgVJczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzy4OZ1qPg6MqQDx+mMe3EKe8898CczU3yzwfjxMvoA=;
 b=ON9mfgR8CrS2/eLMI+rXd6YKJC4rWYXU+RPc8oSiE4L0l2zmHdNtWynmsUubzDPFj6aIiGD4dUEHT0vUTLMXAhsKX6r8Is2l3z3dpbq+HNq1AaGUuH3ijflh4cBvw7342ukaaDcmwW5DEkAJovPkby7cxEebFJl8dfYctNRE3+sByT62TmQb1KV3PcfkSprXCXkfa/dNrqrMtkxVCuBZU5OcWKyEUMcotUhTRu76bKB4W9myIvQbdysEWOLOK7BGWFRATAFEu9c0CVpHQyGtHZDNlbHKmQGtYxhzKBinjKYOiD6hB1b16umT82rOoxWdMNYqz/5KybPYel6yLn3PXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SJ2PR11MB8401.namprd11.prod.outlook.com (2603:10b6:a03:539::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 22:50:34 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 22:50:34 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Topic: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Index: AQHbMIESeDDekiFHHEqRnEEQm8zAvbKsK7YAgAA9ZfA=
Date: Thu, 7 Nov 2024 22:50:34 +0000
Message-ID: <SJ0PR11MB5678EE2AC8DCCD7E7E8B0AD2C95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-14-kanchana.p.sridhar@intel.com>
 <20241107185340.GG1172372@cmpxchg.org>
In-Reply-To: <20241107185340.GG1172372@cmpxchg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SJ2PR11MB8401:EE_
x-ms-office365-filtering-correlation-id: 0f3cccf9-b150-48fd-1cec-08dcff7e96e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?VxqR4Pc2PS++YQHRYwgnG6/inICAvyn/HubX45NJICxMJcHwQorG+GqnUIrK?=
 =?us-ascii?Q?Neh3E2gOw+MGRJZBQMXcfuGGP0y4FlxU9jUs6mQMvpbzk/Mg86KTiDM85v+x?=
 =?us-ascii?Q?bikPi47IFFU3Ns8zCs0NFTKM3z8+O5h30WhqJKV/NGNW/40OrfQKB+cJP+FI?=
 =?us-ascii?Q?agrYB2Z8LIbeXPYyfCQfX8Yy0y4sN8wKX8annkb89x2ZpbXNywMGFO3wkR6d?=
 =?us-ascii?Q?4ZbUgH4Eh6U3ylLxb9tl16m2dPQcKfUlBa+KLfNo0yKa7g6YAAZ3oz0418iG?=
 =?us-ascii?Q?WndlEda0XRW5E14+2FaBV7UdNB6nJeugliROD7N47xE5HbbWnJqAnYPyAF85?=
 =?us-ascii?Q?0tWo+WRnQ7BCFpD62ySiU/BZKMArtB4KswZbAMhviikZ1nfbXGXJoOlbLgoC?=
 =?us-ascii?Q?0YZnY7XrMKmFBRr+33szexN0g8tTWx+R0G7z9j8kNB8TPkctsxQ09SGQwGRt?=
 =?us-ascii?Q?6MTKlhC3Ypkg4TO6Mxx+ntgfd+1F+YPHyYwLtqLbqUPH4H3SB7/ujDpxDZgf?=
 =?us-ascii?Q?tdUmpD5UZiOXsgd4XukOcfkV5/qMGUfhw1jadvYB62UEzk5Yc097xSzhIkhX?=
 =?us-ascii?Q?JdrGRIzjobJVspmeA2AaMSr7lkXb4cN2eU/V4PdgESsDMcxPI9kh8aOiZNmj?=
 =?us-ascii?Q?dPyNT4kf9E7GnQoApnCTdxT5aoLRkuzNliqprYQCMpflpHmNCxCENU7LEuIW?=
 =?us-ascii?Q?J6BtUXwVrqMraHloD7tDEzGMpjvb12nq1Qug/9NM1qDq2ZClyHCjCqGZ7VZj?=
 =?us-ascii?Q?ha7C7fEAxG2X8ptmDvegJ82p3+aLAdoxdAQH7YUukxaOBlhD0SnZItgURJtL?=
 =?us-ascii?Q?IiYAU4hgu5UA+0BRRHxSCFuecK75c2Mjm4advIjw9XYx04f5dndxhyDPtcM6?=
 =?us-ascii?Q?XE1kZjxGEjDY9IQsYxdpifK9AWO8wy8IBvveBZ9DNEiBXZ0T7VhbojUOG91g?=
 =?us-ascii?Q?3epY2F//8eXRu7yWTAO4ITT0kagkI9ULmjzWcH/66ln5s85reVyn582Ld0+f?=
 =?us-ascii?Q?SZSOjs94QTRUaa6gsBzILdxI70zbH+QGc2YmvOlwPIL/+Sj6CLEO+my/H5/3?=
 =?us-ascii?Q?oVsa/AUNVVzF9E3jvNwijw+ViZUv9augk7Udfv40LUW8fsn+K7gfZA7Y0IXM?=
 =?us-ascii?Q?17ZrILOQSu/k0i4fipHBLUb8Hic88qHVx67lWivyzGILzOjDohELzEUTsicO?=
 =?us-ascii?Q?4IAGQL78o8iLcRooIlJcg1mNzcllhXHeufJwSV4zbJEIb+PvNx2C3m6rfNj9?=
 =?us-ascii?Q?pu8svLP+wr9Go7bjQfhOYhEBDmqPYp09B83p0KJLhS8WE5I3fcCog4D434Ln?=
 =?us-ascii?Q?eX/RxqCxqF9m2FZccSBKkTrkSlh0iaKAaaxnO1MVgZp01EOeJLfdd84fDp3q?=
 =?us-ascii?Q?wg0UT68=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N1+KWuAUxYsZmJPjkR0Cj+nmHEEOoZ7cXeIuHTEcPIk4SNJ9aJR2VXXqUNd+?=
 =?us-ascii?Q?IwL9SmegR7iKK/M+AraiI9Ea0BSq4HBVgeJTbJfdAtaUDIXBa6ulc+VcuAMd?=
 =?us-ascii?Q?LJO8adBxV/j9S5zfYgv/5dgLFc8BDEcWFqN++Dvw9Dw3CDeBd5+FyJpYUHEy?=
 =?us-ascii?Q?hiBiPwxGdX1W8URMleCo6IfnCIopRYS8r9jcyR/hI9gLAGGDBu/LNg5WzLDe?=
 =?us-ascii?Q?Eq1AF7uZ8lm6PGDdwE2NA3aSgS9LX6tl6plBjIvu9XQ1m/gg9nApn6HmZCPH?=
 =?us-ascii?Q?22ZSlR1g2NA9+X/lXELQxGMnbRgNi0rEZzxplmazFTz7SIw1EN/pK5RoDpQj?=
 =?us-ascii?Q?98nee8nPVyLWh4L6KacPACpKCsyAx+lE+A+behJa3K/GxqaDr5btNJf+nVvx?=
 =?us-ascii?Q?70eVSOYRmDm9OY68pbhq630ps5udrRPp2GJanbBMRYdnc/tMsdYxpUBsJyJ1?=
 =?us-ascii?Q?Qf/zbyLLXPzCxkXOtAe/ruoF/D5mu4vIVi3+H/9xA8cSb7hJHxoWR6YMhi8p?=
 =?us-ascii?Q?W1o+QtiAbfQmWBdlRKPGj+vXZxBPjPEwQzb8W8CmEygEbnje74JtNLBHakSj?=
 =?us-ascii?Q?ulY4UJbyotwX9o1xvzA81IA2QkF1hlDeHyYhtYk6HDQQE8JVKWv+SNMdTQPZ?=
 =?us-ascii?Q?qQifZKy6RH5tMH0gHlImfsHDlQrPGJk85x1HrMp/O8AWlrmE0D/Y+s6UyqIC?=
 =?us-ascii?Q?TI4Q3m90zcSvEY3kt91sldu++riQCNcHB6Q4tSZfSuZHf5jTTRN0/GHjQA83?=
 =?us-ascii?Q?Cs6BG6QxqLbjyhhvqikE1IVJ4iv+qurP/43ab7xRFsBM/7cNkA7wvcHEDu+L?=
 =?us-ascii?Q?+pb7T06oi5qp1yBFF6JytXgF0MOvLtkRadwn5pm8tDr3x7WF0Ov3wGneEQbm?=
 =?us-ascii?Q?75diR/zLV/V9VbQkCjCRq6I8sMKkyaDVVCBQ2KqcsnuDzEG5YYWBxcL6y7zP?=
 =?us-ascii?Q?YWG5Q/LGPRPgjjlihNOhiwhW42cdgK5JRqZtpAvcl2n6g3XWxtlGWTqkZRan?=
 =?us-ascii?Q?VsxzI1jCPagpF6EAsQ4sNmg6dsq0XXCiogkVaaxb/xxwo4QTiQex6qUtK3HE?=
 =?us-ascii?Q?bIh8JJp8OpAfcPPK5SHD5J8pfiIze6LlbIBquzeHtJkGW5DIpW74xP1GAY9y?=
 =?us-ascii?Q?nm2xtcuJjFrLxY7mZDzii5vg1vrdRv0xhugn7ZuHDG4oZOwRwauo1KC1Sh/y?=
 =?us-ascii?Q?xzfIkkBGejWVdzj56ukADO79I+ZbN6u3NovSDxZWqX2GZCW6RqA6xdWIdCaT?=
 =?us-ascii?Q?qBKE6j+xZUuWxA4tlR/Od9q1ZDZfdfzolzeLjeGBpaEOnquFvpu1kQI8BuX8?=
 =?us-ascii?Q?v9nC71R2J5N6v7hn3fVG/T71dps3zk0Rn0Pd7TPUghHeWbUdm+k8zLN5/JlR?=
 =?us-ascii?Q?FmX2uFlIpWMgOl/pAinttoNw6+C+NUO98fiyNFRPfKyUNIawBnbHvJNSpCyY?=
 =?us-ascii?Q?5AKqpaQ9iDYh11T+IyvQhzbrVK8vpMEIRYeMGiPAaOY/3Bxwl2tF4UeJjAdC?=
 =?us-ascii?Q?WQ8lop91YYoyNq1akVlxLlvZxiVaA3tLNU3heKGBdL+8jNPH/vFHVY/4K8yV?=
 =?us-ascii?Q?1mV6YixZnqK67b7OzMfQ2jvPW4gcdVXHFn0nnezhHquCN5OTt+D9Wzp9YZyq?=
 =?us-ascii?Q?bg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3cccf9-b150-48fd-1cec-08dcff7e96e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 22:50:34.2126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBfnaC+Z3Nx5W3fsVBBIQParTrU6yJ69iIRWa3owmKPPiLuUNQbD01syhBoDn6R7X4FYA2nVnYsBfXeJ3EysxaNCLRD+c9a6uc/flCfTcMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8401
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Johannes Weiner <hannes@cmpxchg.org>
> Sent: Thursday, November 7, 2024 10:54 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA
> in zswap_store() of large folios.
>=20
> On Wed, Nov 06, 2024 at 11:21:05AM -0800, Kanchana P Sridhar wrote:
> > +static void zswap_zpool_store_sub_batch(
> > +	struct zswap_store_pipeline_state *zst)
>=20
> There is a zswap_store_sub_batch() below, which does something
> completely different. Naming is hard, but please invest a bit more
> time into this to make this readable.

Thanks Johannes, for the comments. Yes, I agree the naming could
be better.

>=20
> > +{
> > +	u8 i;
> > +
> > +	for (i =3D 0; i < zst->nr_comp_pages; ++i) {
> > +		struct zswap_store_sub_batch_page *sbp =3D &zst-
> >sub_batch[i];
> > +		struct zpool *zpool;
> > +		unsigned long handle;
> > +		char *buf;
> > +		gfp_t gfp;
> > +		int err;
> > +
> > +		/* Skip pages that had compress errors. */
> > +		if (sbp->error)
> > +			continue;
> > +
> > +		zpool =3D zst->pool->zpool;
> > +		gfp =3D __GFP_NORETRY | __GFP_NOWARN |
> __GFP_KSWAPD_RECLAIM;
> > +		if (zpool_malloc_support_movable(zpool))
> > +			gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> > +		err =3D zpool_malloc(zpool, zst->comp_dlens[i], gfp, &handle);
> > +
> > +		if (err) {
> > +			if (err =3D=3D -ENOSPC)
> > +				zswap_reject_compress_poor++;
> > +			else
> > +				zswap_reject_alloc_fail++;
> > +
> > +			/*
> > +			 * An error should be propagated to other pages of
> the
> > +			 * same folio in the sub-batch, and zpool resources for
> > +			 * those pages (in sub-batch order prior to this zpool
> > +			 * error) should be de-allocated.
> > +			 */
> > +			zswap_store_propagate_errors(zst, sbp->batch_idx);
> > +			continue;
> > +		}
> > +
> > +		buf =3D zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> > +		memcpy(buf, zst->comp_dsts[i], zst->comp_dlens[i]);
> > +		zpool_unmap_handle(zpool, handle);
> > +
> > +		sbp->entry->handle =3D handle;
> > +		sbp->entry->length =3D zst->comp_dlens[i];
> > +	}
> > +}
> > +
> > +/*
> > + * Returns true if the entry was successfully
> > + * stored in the xarray, and false otherwise.
> > + */
> > +static bool zswap_store_entry(swp_entry_t page_swpentry,
> > +			      struct zswap_entry *entry)
> > +{
> > +	struct zswap_entry *old =3D
> xa_store(swap_zswap_tree(page_swpentry),
> > +					   swp_offset(page_swpentry),
> > +					   entry, GFP_KERNEL);
> > +	if (xa_is_err(old)) {
> > +		int err =3D xa_err(old);
> > +
> > +		WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> %d\n", err);
> > +		zswap_reject_alloc_fail++;
> > +		return false;
> > +	}
> > +
> > +	/*
> > +	 * We may have had an existing entry that became stale when
> > +	 * the folio was redirtied and now the new version is being
> > +	 * swapped out. Get rid of the old.
> > +	 */
> > +	if (old)
> > +		zswap_entry_free(old);
> > +
> > +	return true;
> > +}
> > +
> > +static void zswap_batch_compress_post_proc(
> > +	struct zswap_store_pipeline_state *zst)
> > +{
> > +	int nr_objcg_pages =3D 0, nr_pages =3D 0;
> > +	struct obj_cgroup *objcg =3D NULL;
> > +	size_t compressed_bytes =3D 0;
> > +	u8 i;
> > +
> > +	zswap_zpool_store_sub_batch(zst);
> > +
> > +	for (i =3D 0; i < zst->nr_comp_pages; ++i) {
> > +		struct zswap_store_sub_batch_page *sbp =3D &zst-
> >sub_batch[i];
> > +
> > +		if (sbp->error)
> > +			continue;
> > +
> > +		if (!zswap_store_entry(sbp->swpentry, sbp->entry)) {
> > +			zswap_store_propagate_errors(zst, sbp->batch_idx);
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * The entry is successfully compressed and stored in the tree,
> > +		 * there is no further possibility of failure. Grab refs to the
> > +		 * pool and objcg. These refs will be dropped by
> > +		 * zswap_entry_free() when the entry is removed from the
> tree.
> > +		 */
> > +		zswap_pool_get(zst->pool);
> > +		if (sbp->objcg)
> > +			obj_cgroup_get(sbp->objcg);
> > +
> > +		/*
> > +		 * We finish initializing the entry while it's already in xarray.
> > +		 * This is safe because:
> > +		 *
> > +		 * 1. Concurrent stores and invalidations are excluded by folio
> > +		 *    lock.
> > +		 *
> > +		 * 2. Writeback is excluded by the entry not being on the LRU
> yet.
> > +		 *    The publishing order matters to prevent writeback from
> seeing
> > +		 *    an incoherent entry.
> > +		 */
> > +		sbp->entry->pool =3D zst->pool;
> > +		sbp->entry->swpentry =3D sbp->swpentry;
> > +		sbp->entry->objcg =3D sbp->objcg;
> > +		sbp->entry->referenced =3D true;
> > +		if (sbp->entry->length) {
> > +			INIT_LIST_HEAD(&sbp->entry->lru);
> > +			zswap_lru_add(&zswap_list_lru, sbp->entry);
> > +		}
> > +
> > +		if (!objcg && sbp->objcg) {
> > +			objcg =3D sbp->objcg;
> > +		} else if (objcg && sbp->objcg && (objcg !=3D sbp->objcg)) {
> > +			obj_cgroup_charge_zswap(objcg,
> compressed_bytes);
> > +			count_objcg_events(objcg, ZSWPOUT,
> nr_objcg_pages);
> > +			compressed_bytes =3D 0;
> > +			nr_objcg_pages =3D 0;
> > +			objcg =3D sbp->objcg;
> > +		}
> > +
> > +		if (sbp->objcg) {
> > +			compressed_bytes +=3D sbp->entry->length;
> > +			++nr_objcg_pages;
> > +		}
> > +
> > +		++nr_pages;
> > +	} /* for sub-batch pages. */
> > +
> > +	if (objcg) {
> > +		obj_cgroup_charge_zswap(objcg, compressed_bytes);
> > +		count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
> > +	}
> > +
> > +	atomic_long_add(nr_pages, &zswap_stored_pages);
> > +	count_vm_events(ZSWPOUT, nr_pages);
> > +}
> > +
> > +static void zswap_store_sub_batch(struct zswap_store_pipeline_state
> *zst)
> > +{
> > +	u8 i;
> > +
> > +	for (i =3D 0; i < zst->nr_comp_pages; ++i) {
> > +		zst->comp_dsts[i] =3D zst->acomp_ctx->buffers[i];
> > +		zst->comp_dlens[i] =3D PAGE_SIZE;
> > +	} /* for sub-batch pages. */
> > +
> > +	/*
> > +	 * Batch compress sub-batch "N". If IAA is the compressor, the
> > +	 * hardware will compress multiple pages in parallel.
> > +	 */
> > +	zswap_compress_batch(zst);
> > +
> > +	zswap_batch_compress_post_proc(zst);
>=20
> The control flow here is a mess. Keep loops over the same batch at the
> same function level. IOW, pull the nr_comp_pages loop out of
> zswap_batch_compress_post_proc() and call the function from the loop.

I see. Got it.

>=20
> Also give it a more descriptive name. If that's hard to do, then
> you're probably doing too many different things in it. Create
> functions for a specific purpose, don't carve up sequences at
> arbitrary points.
>=20
> My impression after trying to read this is that the existing
> zswap_store() sequence could be a subset of the batched store, where
> you can reuse most code to get the pool, charge the cgroup, allocate
> entries, store entries, bump the stats etc. for both cases. Alas, your
> naming choices make it a bit difficult to be sure.

Apologies for the naming choices. I will fix this. As I was trying to expla=
in
in the commit log, my goal was to minimize failure points, since each failu=
re
point requires unwinding state, which adds latency. Towards this goal, I tr=
ied
to alloc all entries upfront, and fail early to prevent unwinding state.
Especially since the upfront work being done for the batch, is needed in
any case (e.g. zswap_alloc_entries()).

This is where the trade-offs between treating the existing zswap_store()
sequence as a subset of the batched store are not very clear. I tried to
optimize the batched store for batching, while following the logical
structure of zswap_store().

>=20
> Please explore this direction. Don't worry about the CONFIG symbol for
> now, we can still look at this later.

Definitely, I will think some more about this.

>=20
> Right now, it's basically
>=20
> 	if (special case)
> 		lots of duplicative code in slightly different order
> 	regular store sequence
>=20
> and that isn't going to be maintainable.
>=20
> Look for a high-level sequence that makes sense for both cases. E.g.:
>=20
> 	if (!zswap_enabled)
> 		goto check_old;
>=20
> 	get objcg
>=20
> 	check limits
>=20
> 	allocate memcg list lru
>=20
> 	for each batch {
> 		for each entry {
> 			allocate entry
> 			acquire objcg ref
> 			acquire pool ref
> 		}
> 		compress
> 		for each entry {
> 			store in tree
> 			add to lru
> 			bump stats and counters
> 		}
> 	}
>=20
> 	put objcg
>=20
> 	return true;
>=20
> check_error:
> 	...
>=20
> and then set up the two loops such that they also makes sense when the
> folio is just a single page.

Thanks for this suggestion! I will explore this kind of structure. I hope
I have provided some explanations as to why I pursued the existing
batching structure. One other thing I wanted to add was the
"future proofing" you alluded to earlier (which I will fix). Many of
my design choices were motivated by minimizing latency gaps
(e.g. from state unwinding in case of errors) in the batch compress
pipeline when a reclaim batch of any-order folios is potentially
sent to zswap.

Thanks again,
Kanchana
