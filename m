Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C472AEFE;
	Fri, 16 May 2025 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747423063; cv=fail; b=fWP0Azhsyjcyu0sohM2dTU9A2rIJREiA+yPBedBRHFzS8Lf+nQsFHNp0nn8NDX2u530pWw/h+Mnu8zR9udc1LLkSj1RZwPt53GjjcvTY/0oPLI1H5eEIoLqHxHnpM2rzgtqIcIFwMeW4YAdsFD4qE7jSF/P1n6ciaRWJGrS448E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747423063; c=relaxed/simple;
	bh=bho+4nARHzzEi5XpkhBxdm1WPXIY5bg6/prajZAptAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TQP4lFihkhK08QBmWKhK6HuGGUYmqzyBzj2o6JV4jfqgvpECbx8esefk1i5aY7UqexKnlPyWEVXpqOmTIOiZ+P11KmK45h5VB1C1jUTkub6Z3KDa6Q0dT95urCtAsSFebIBaUae6BhGj9GymU4UgwuNax7cQSomDEpyUQrmg5/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXUFxsu+; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXUFxsu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747423061; x=1778959061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bho+4nARHzzEi5XpkhBxdm1WPXIY5bg6/prajZAptAc=;
  b=PXUFxsu+qr6ut7tx2COxUn3TcQTNZcDQ0Hxxn4d3aAUwY7Gh8bSp62D6
   rYIivZqMk+4g9+oRtuszQ077h9iSTygz5SzYrGQT076QajjPKCGpSg58t
   l9JWs1jYrq4ZX/dsGA/sWnnn5SAmqoUE0BkscsFk5nHjui7WDkIE/f/PK
   dkEMEEID1C8FAA9KNfqHms79QWRyxVe9k623KZBs0HUcYd0Rfa2S+TD6F
   +EgJRQDzIL1MMi4NeNV86rl65pXG20nMisLl0zgHgY+mYf4HvEQV4+Dqx
   K7ldDi1/b2KsWfD1h7JdwLz8gVIp3UEbiZarcLfUj1UGU46o41HURegMV
   A==;
X-CSE-ConnectionGUID: B+mFmnglS6av7BpnlrOWXw==
X-CSE-MsgGUID: VwJhP3dASSaW97uyyEfAAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="48519215"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="48519215"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 12:17:40 -0700
X-CSE-ConnectionGUID: pMpKNHl/Sw2z2bccV6Cajg==
X-CSE-MsgGUID: g1BsBiO0RdWjGvZvCPwl3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="138699398"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 12:17:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 12:17:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 12:17:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 12:17:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NCaXCjNeqnYai5OzjE3V8ZLuuX+oX4BMOgxSVE0NI4sRYS8O8FCdWImJXDqOdORgMV6fKn7zkfmuSmmzb/M02rTZFNCN+Fy47pdh1kfWe2I0z+9cWz0NyuyV5Hf7aOZQbKtPlxttiRxS3EdWj2HFiYdJ8P9Si1a9XlLn8GCjbu531h4TzzsiPGSbJCGSNqVOzaX8LcVzs/3OqX+8hUAbhynhehGvvE1sIyI1ix6/iugsg9aBAkJVZZzR0sVB79DkSQdLI61IeaDFzUXoFXUr58YQz3C3m9aGIIGOcu54LllaynML4Abe+JAS2wrTpa18CLYwfojMYNESTAL3MV8wag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nisIpCSRnfKOgRggFaAqB1O9A3BM85u3E/IuZ+OfwnU=;
 b=g2DTe5xbApHnGXiFFJfizXnoMaiWKC4fPdzz+XWxpnw/mkUOI77i0QpujJoZkUhRXNToXDuJZd2tCXnScdiRbWtaOdSJ9vr57IS1RemJKG5QnQnMyzjs/eWNRNe+s4+BDbWSYKOR6XPVL7NExIE9mc44Ql1/+3Rprrk4xb8Aoz+YOo0DtKZ/YsFqKlBoOHhcZcCraLVqfjB2vecfiXmw2iHW6M7LH9QaZYn2izYsKNcFZ5uVIPWkO2bMWaijnEw1G8m29wpLPupQM6/G2hZwnc7dbUQ87dsS/anU1vdDVlPYdvHqH9JH/EO+u1Q/n+iZ1OyRspyN3skoWVHOCT+9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DM4PR11MB7759.namprd11.prod.outlook.com (2603:10b6:8:10e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 19:17:37 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 19:17:36 +0000
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
Subject: RE: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Topic: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Thread-Index: AQHbwFE+HzcrM8vfg0+DcWZ2l00PSLPQOoKAgAVp/tA=
Date: Fri, 16 May 2025 19:17:36 +0000
Message-ID: <PH7PR11MB81215CF69F51F2801F4767CDC993A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <20250508194134.28392-11-kanchana.p.sridhar@intel.com>
 <aCL86_v0jaqW8jxS@gondor.apana.org.au>
In-Reply-To: <aCL86_v0jaqW8jxS@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DM4PR11MB7759:EE_
x-ms-office365-filtering-correlation-id: c9e0d728-d132-459c-7195-08dd94ae5183
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|10070799003|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?/eNc6YbWpqB311MpKLV5Crvic5a5NwYzSJe42u/mwejJ/qh5VmkQH7v7lA4r?=
 =?us-ascii?Q?r6gArFZ1h87zGdnd1l51unVkfbqiuHKrUeqYPcE4nFQ6GVIqqku7rlOhMZLq?=
 =?us-ascii?Q?D2tsiTD5czSepV/21F0L5d8CUtcTCmcqHcsmH+GlfVA/eTp3+YHc6sIHzo7a?=
 =?us-ascii?Q?hf4bQdkgNxBAu3TGlfIhkqMph1t4rOCXXKvsKPy0pPlifbW5WtYmvRhnCIvm?=
 =?us-ascii?Q?zJ/QPO89DM0/+/dm61/s4+J7EVRlTxYEa+6wOjRdORlVzIIvI9OEgunKJtwI?=
 =?us-ascii?Q?bjQlpRtewTuFx/VILlwlGgrOslhwYCTCR77PrqVFSEuKpXvJo3OktP4Qr9gq?=
 =?us-ascii?Q?2hs6Tvs0mZdK7p1LBPm/XtVKmaBxE5sIKyKuEg4qVbrygDR8Cwbm/vWJ0b0L?=
 =?us-ascii?Q?2G8PgmDxBajq8w6tuEHMyiupPkV8DzAIbnYQ8vhoNtu3xFyXy82f5rmXpwjL?=
 =?us-ascii?Q?V1YN9uCtuHLs8diq8WjsdbEU9vlT7VCmX8lg6yLAW116J7Lpu7AhHlBX1lkx?=
 =?us-ascii?Q?BVglPgyZVEoTQ25QxGcW1NPyLEbwuhHtpVpVtX4MUajtfFTXTSQT4FKmJtc6?=
 =?us-ascii?Q?XypCKnV6bbPlFSfYDE9eklg411Ode43ex27RnSxQTv3N1CQKCxmy/kPqrdUC?=
 =?us-ascii?Q?vawIt8eEd4ymKcAczbefY9DHoRuTMcPxFZSQ14PXlUtcsGHwSQhSPwwvsT0X?=
 =?us-ascii?Q?qW988FbP6/NTNhH3llmROzk7nGG20TNePKbr9CB/41uGaA3NuSL0jmYzdDJQ?=
 =?us-ascii?Q?Ht+CiAeU8nrI7erFIJZ46Dxm+uWQhr6QzSnocsWSEmI/6GVNOvtHXZ9vs3Mw?=
 =?us-ascii?Q?So4h0ZJ8jDjNJQl/6bM7CyT6iifJfbWjQbi5bben4Gtzsqmz7j5UCd50Vuxo?=
 =?us-ascii?Q?GYi+SY3kZcmgAaPtPidxfzsNdyN0H4ZH+YFCE4l1TrI02y4Cx6C2jspX8F3d?=
 =?us-ascii?Q?jxzzy0Xam0KPsCK4PFtp8nRmTd7dM6/Haqh1VlgRvWANwp+zkTr4JJl1A1A1?=
 =?us-ascii?Q?0s90AgOjT7CY6QZzg4VqNhvDhK/358b64rTArwuKugqaRQ7jyw8MzQhnoV5d?=
 =?us-ascii?Q?OqLTzJu1+GDhAn0BKaMQ8M+JJiDDGTlHjKpAlp7pg2dEEOU1mX99Ab7o4dKq?=
 =?us-ascii?Q?4SYY0G5T4tVBe8q20xnhqZCgd4jUgLOxcLUuvgWJGFb06AOytj/DTpWtilGq?=
 =?us-ascii?Q?f9Pn7m/IwxCIyTqVMZ6UlMyxfB4Pc6KxiJyslgN0SCoy9v+FsYViOO0CsXqM?=
 =?us-ascii?Q?YMKPFQRtMXI2fHzjkm6AIMoTZSw8xquu8jh9IlUNVhxeBLvki2l3ibGxRTdF?=
 =?us-ascii?Q?WuVTfmlEVRsoNrBBQaGTBWFf0u0tAPAFivuK4FYMn039yFl/Uk3itE5oWlGY?=
 =?us-ascii?Q?WdL9sZBT15CNT3g/a8KwJqJHN1U/vhxO9vEqBZQqcUg+U6mpMRUHBmaWBvdO?=
 =?us-ascii?Q?JyPIQ695BckBxZR0bxjyp3hc3HzojBR1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wtLEiX+DnBM7Nm1Wd942LfpP4UPpGfhE2okgPjh39flUfXKcTzQZ28sw6uqR?=
 =?us-ascii?Q?kz2ryxcid7kv7BRq/VU6FX21ChTgkrBAQlae6V8ZVhkMsC+PdYQv1t0N80pc?=
 =?us-ascii?Q?JUOyEgA3Sd7iD6HR2DUmjLS2cdhYsn3Soud9etx2Qnb1/eQIIuXCI1X6KBlC?=
 =?us-ascii?Q?/6rg/FHfdtKLNiugK3DoHcUN9+bOESPOq+Ze3cuIvN5GM4/iHEF2Krf387X7?=
 =?us-ascii?Q?4Zx6gfEWDbdMDsbUuKguzDwsGHEKiWIujLVRtsvLQfdrkVS/oNwennEtd2A0?=
 =?us-ascii?Q?8c9YwbYiqdMvgt8vg0UwjGq/fu/KuZ8VKXeB36MIYcjwoVrz7wwrleY0M94P?=
 =?us-ascii?Q?iAtvcmbiUXF5E4SD1SQ2NsTAA9Enq3jEhPRBWdAr8HOFLcBRkEWhXJayBrrN?=
 =?us-ascii?Q?t8Rr1RNvr9AJ6DGPoJjd0mYbVOjGzYG9lMUUoUBU8v2WB+N3/C6W6Nuv7XTL?=
 =?us-ascii?Q?JLwqg88Mz3b95NRzP2PzBuHbM5gI86SELK+jcD6oj8XEk3xTqw5PGnVWtGup?=
 =?us-ascii?Q?4+Y0QK/8e7oGQu2YlkAs/+BbLaMr3N2IHmWZjT2Tgj/AlyBR6WS0Vvyxmsqn?=
 =?us-ascii?Q?xe+JlN2hk6dqVF2FX9b56T90OAPIuUZRQVeGJbDT/b4nCFhQ+pxiD+zzG1v6?=
 =?us-ascii?Q?gvAAgT8ggHI/MxlBHU0H506IxvlSFqPn2Ky98WGKZkD05+6Rax6zvzT47Jmy?=
 =?us-ascii?Q?L4Wzu2kRBfPIBayLO1ZWJpKduqg0dEprP84Dt9nicqQZCB0KY+GxRRACX3WZ?=
 =?us-ascii?Q?C98rx73b68/soxu8iJWVdEcNbHg35jjUyKt1NIqVo3moPabHOG2FzSRi33LL?=
 =?us-ascii?Q?1yF9FleWKOVyWMpEzHBB2bfypU41Ky1RPGzC3iXX3MplMAMnoebdGdIf5+uu?=
 =?us-ascii?Q?PRtiy7MpM0Xpz3tortdp7SrnIvGYwgANsUlziNMNKS2ZwJO7Jyvww4ZHe3B9?=
 =?us-ascii?Q?3jwUolWAJ/c8xmMvgs2bF3SXjiEkgbcFdYCIb36tNAI97RNlSK5Ab0zCHKuT?=
 =?us-ascii?Q?xp2HligtPJOlMLgNKQYi2CVcqzu9mG41ZCf6JxcE96nhawPwRY4cMgYndvEj?=
 =?us-ascii?Q?OmBotQ5aYL7D+z79rLQCq5xXv0sLNDUYXFDYc6SVEgCq6Qv9JbF4gx4CREHn?=
 =?us-ascii?Q?usCcr5PvdNyysO69LUqApEB9f10CSmlIjfImly0q/RiNE2wKpKH6Qh1wa7u8?=
 =?us-ascii?Q?prIzIeY3/8OWDHAIJutE3a7ElX5+d9+KWg68NGgRytedzQPexM4RkRnw5zNB?=
 =?us-ascii?Q?9P0Mgs4n8Y58PeTfc4t3UP656AhTe97/8jf0SnTxMDpF6wnIYNyJGtAIe9CF?=
 =?us-ascii?Q?p32beKIyLtSXSQZ4vbsk8ZrwHaeLEhusE30F9JyRo+Tj2kbTjYIV7Mv5VXch?=
 =?us-ascii?Q?K5aWA+8BvYwyUUZx2ff9TD7LFe/BAWE1D9fxvHPcRj5aVyrEYxUw0n41cTQq?=
 =?us-ascii?Q?JMmAHgzPLudyE0yZ/nmszIJrTJ+a4J964zsA+O1pO9vuYaYyMUOVf5BpkUB8?=
 =?us-ascii?Q?NQfIwKpuRlHt7b+xP8GZszCbE8cbFkX/nRNk6LxDQcZjyxInkD2BTfM46WQn?=
 =?us-ascii?Q?QRetX3NinPApPt1PIhVbPI3LJCej9A87qr4Fung9X0he5JY7c9hYSTFDOPyP?=
 =?us-ascii?Q?VfO6vCWtBquSpMWzHudig5gJzShrz2dBpF9F6QoPSuT6l2jnYpEWqZLQHGyH?=
 =?us-ascii?Q?ybcmmg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e0d728-d132-459c-7195-08dd94ae5183
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 19:17:36.9230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vW7CrW/BxLUlAw8RMr6u2zfBoxz3N52rsQS8xMg8itfBoTzHyiTN4MjyI46HxONXahnfrJfruW8WuF865EvS5f2lugwGD5ZZEyzIP7kTRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7759
X-OriginatorOrg: intel.com

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, May 13, 2025 1:04 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
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
> Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitat=
e
> batching support in acomp & drivers.
>=20
> On Thu, May 08, 2025 at 12:41:25PM -0700, Kanchana P Sridhar wrote:
> > This commit adds get_batch_size(), batch_compress() and
> batch_decompress()
> > interfaces to:
> >
> >   struct acomp_alg
> >   struct crypto_acomp
>=20
> An array-based interface is not acceptable.

Hi Herbert,

Thanks for your patch-sets [1, 2, 3] "crypto: acomp - Add compression segme=
ntation
support". I went through these patches, and had a clarification question:

IIUC, [3] allows us to set up a large folio to be compressed in one shot by=
 calling:

acomp_request_set_src_unit(req):
     Sets up the request with a [large] folio as input scatterlist to be co=
mpressed
     in PAGE_SIZE units.

acomp_do_req_chain(req), acomp_reqchain_finish(req):
     Compress the [large] folio in PAGE_SIZE chunks.

It appears acomp_do_req_chain() and acomp_reqchain_finish() compress the
folio units in a chained, synchronous manner. If so, I cannot see how a har=
dware
accelerator that can do [de]compressions in parallel, will be able to submi=
t
multiple [de]compress jobs simultaneously. Without this, a hardware acceler=
ator
such as IAA would unfortunately not get the benefit of parallelism that we =
are
seeking.

Can you please advise on how to overcome this?

[1]: https://patchwork.kernel.org/project/linux-crypto/patch/e4ca39a0ada7de=
aaf86dd1a40a717b30cc3e462f.1746102673.git.herbert@gondor.apana.org.au/
[2]: https://patchwork.kernel.org/project/linux-crypto/patch/4be83ed9da46eb=
4e8a309fa37e3050766ea2784c.1746102673.git.herbert@gondor.apana.org.au/
[3]: https://patchwork.kernel.org/project/linux-crypto/patch/c48990bee119c8=
a7b0a04edc7de4065723025a16.1746102673.git.herbert@gondor.apana.org.au/

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
