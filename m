Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF41F582E;
	Thu,  8 May 2025 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746732345; cv=fail; b=cnxOfjkEhPFRO1wj174meQW4h05DqTQ42lp/tRsx1Bays1Dr/YCCXbAEjYRxtVOZPZRRjM0c/zpFV0Ggf2pTFktMKfdyIfYxL1q8jFk11fb0wQadEDfrQmwJPnXYezXNUaEoSDxYlri/524iATYJcKp8U93nQmo6hyYjjages5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746732345; c=relaxed/simple;
	bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S63lXhz/XTIhcCqRYlEPQ7UGUi+qKnvpsl/PzpMfUxQJhKKwCOED/YC/SXnj0gxG8xV7G6gqbO6sw7eDpXSp4/n+NdxZ8scdkOl+jUZ1fsbmSRRfB8706RBChy9zEvj8XLY/nR0WBe3zEr42oRKj1DbePAgRYLSE6v/iS4Rjbtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6wvlDUk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6wvlDUk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746732343; x=1778268343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
  b=l6wvlDUkBr11UUKl8tI2XzYxPcw4MXOKJqqPH9pMg7yXqz3g7obugq1O
   ULcBNLZPApOFhO9pghJvnXWOwgcLdnZWjw3tvpNLDKmTD7eihW5Qg4+8f
   sDCPVgROAAewX9qapZGIzHzKi8le5TvPrTWRblTeSzg4Rq8djirXfx+na
   sHp2QShh1LxNZmJnktayuy6V5FdSY92rdVt1dq65/tSn5BGOq3qOkyNFo
   JoVILRHD2Bn5+X4BpYBOcXja35H7ZnN0n+uYvD36XDkhKNVjIUSAir8TX
   TBVKPoGnV+BDBv5N3XBJVGm1TCtKyDRcYV/ploMNwx5Zf3R5NMUBgaWis
   w==;
X-CSE-ConnectionGUID: 4qf6WVdWQ/Srm6qDLye5mg==
X-CSE-MsgGUID: x78YXSPBRna83t/q4EEt5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59201638"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="59201638"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:25:43 -0700
X-CSE-ConnectionGUID: C2V7h/GgTZOh+KjPJ0nymQ==
X-CSE-MsgGUID: 7eGTls9UR2mUvrq7alWyCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136399026"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:25:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 12:25:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 12:25:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 12:25:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ETLn0PZi3gYr2Hu68BZmW1uNtHQKljo6yrvbsJke/whEqqerH2JhqKbBylMBv00cgqTW/1GNHOCPJZunsccG6LyT0KfFKR2rM1tCuzYW735xX7zPqj5Xhq7DX147UqCI7w3HEZwOzXK4O4Rq4ZBX0Yr6Bch3fW/rkAD+J6Fv8bwODAxlVIwzAUj2omFurhNQwDBa09JA17okdJLwrb017bSDsO6EekcQQZaOqj1baq7bTZmwv55HxWh42Cri4nYivB4x3rR4tBp9xBN79eZL9IWM23x15UcaUw7nnI/L23sLOjn9mTfYt4N18ImNYO9AYEgo+tAxpE0SinLac4uBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Asxum+uEy+Ytvi2IrZXa2qd+C7YRw/DkLzG2I6sI90E=;
 b=ndWMcgsvzVvuCrNfZ9murGZ6SKsRCupi8Y20tdoUICLr3GmCyMjJll9UWCBUKjbzI4tzsHRmELXrCjbATmK7yySn1T5PqaZuI81skoqrUb+iXB3YEOP+5G+8JN6gnWbnwmYKBBsc1x5zoAqnNRufuv5K4/uKcNZrIZGG+pJ5D2Ld3MYbs4JynlJ4bD/n1epEX+GyfXNibtbKAZlHIKffmJ+GjSyb7uPh4mYzrRYPYB1vTYpAVoo1kxJBxV79cxvreB1IvST0wZ5fLB143qF5hYUjJYpGcmDguVNCFmUKU+D9MGO7Plky1OJyLktYWNyp/NsrZXILM7mu9/DcgPYjGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH8PR11MB6802.namprd11.prod.outlook.com (2603:10b6:510:1ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Thu, 8 May
 2025 19:25:08 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 19:25:08 +0000
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
Subject: RE: [PATCH v9 00/19] zswap compression batching
Thread-Topic: [PATCH v9 00/19] zswap compression batching
Thread-Index: AQHbuhHkPoir1/4ImUuqCyXQmSE43bPJKO2g
Date: Thu, 8 May 2025 19:25:08 +0000
Message-ID: <PH7PR11MB81216A7376042A198C323708C98BA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH8PR11MB6802:EE_
x-ms-office365-filtering-correlation-id: e2815136-c3df-4f0e-f3bd-08dd8e660b1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?uENjWBt4aFKQynrKZONCLqybugUSduu7hVwcMVyKfIPwO5c6yEa9Bj5Kz6Yx?=
 =?us-ascii?Q?DU/hQF6ldePaE9oW9zH/21JSaNvP3PqNB+MJr/+xOZTAB9BAL3F1vE/e+eM5?=
 =?us-ascii?Q?ddtgl1pOGUDqhDn/aesRANebweHrnwUYzC4eczelNlpUkXzzyl6uLxGR0xKa?=
 =?us-ascii?Q?CzwrG0kWpSHm4cXSYEwhnYZWHQu/x+XSmwjzpJCDuqGTPuNrfaLXl1CCWBi6?=
 =?us-ascii?Q?lGjvLtD7jx3TOh8y3AImLXCAE8SkJ2TCNjKDD8IdJ3FJdq3ZG3Vb7vLTEMNt?=
 =?us-ascii?Q?HpJhnt33ZQ5sTVtUWYcvEtCktNeZbW8LCa3jZRzl7BPrrDMAomBwqkPMdpCs?=
 =?us-ascii?Q?AoGj3/f3Qub0qt4EVVJ6ElXJLqAJJQZAcNlpguhMyUeKsgpjQGHNPXtz0FNX?=
 =?us-ascii?Q?eD0sU2iB2Hr9waegdbfBfw/ur6f4800ABQd0u1zymG50Fj+jBNF4JIX7Qo/c?=
 =?us-ascii?Q?P8Nfb4/CX5f9xO7E8GtOCbtgXGQqhiWJteflYn1R6Olds551dbF+Xr8jLlN+?=
 =?us-ascii?Q?s8M2ctKxhh+P/TAlQDtvsi/PjsFuvdlYC7+x69RN/hdN+V1fF9I+QH1nsWha?=
 =?us-ascii?Q?jHD7GSV9xhMQRdvwVeCqVu7iagOByYqxIffSYIgoAFxgsYAvxnajbOqjRXmb?=
 =?us-ascii?Q?+4e+ijQD2+QSvktO5S/0lDuWPz0cYBX4V1VvWKIv+5r9AYtU1W9njRjzNGWd?=
 =?us-ascii?Q?Az6PayPv+F68fY5agL+7C9ZTRGEzaVQdsjtoFf+86BccWwz7ej5AsUDGyccc?=
 =?us-ascii?Q?2EjAM/Lq5yGR/Q6eUf0QxJ8xc9/lNwFy3p7TJom4u05tGwH1qimYpVjG1ZxP?=
 =?us-ascii?Q?VQkRjzP/9LulosIT7jE3o3CPwNM6zOl8xYdJgAT4Yg3HM6yetFSwiFa939j/?=
 =?us-ascii?Q?MCiD7e2zPU9dIwKL8tegvgjJbSCvslhp7ZyFXYKNzKnipaKYkokid0fE7yBa?=
 =?us-ascii?Q?OemmdgEuDbDCBWnRtQro4AhZH2u1FAlA9+CRv1P9K/QAmNG16fhPRKUfUJEq?=
 =?us-ascii?Q?i3wqgqy+66xkEN6eS5mkMmMKekz1t4ptQBoDnMyJwoPC8f7590OyCBUBN0+K?=
 =?us-ascii?Q?oDplDNM4I3kvhpoNrFAAzjfhAw+YaU98M7vN6D33xzLfi8wHZ/5pEDp9mJtN?=
 =?us-ascii?Q?CghUh/hxulOHV+82CTWEBwku0iPHmDHcBjH7o6IAGqzOVvUqzeh/mB+7hg2d?=
 =?us-ascii?Q?wRTM+jU8p0K6ql2bM7/fmXvX10Clu6IBc851Yoxr6/vztdrxA0ySs1IDmTCq?=
 =?us-ascii?Q?jaYzvestjbg4N84/iIhmswSL38jYSjs39kBDN3bBuoRI8uV+J0oHbWf/DSBu?=
 =?us-ascii?Q?msB9eIE0N1DDg9XjHh0qO8gDrlo4Ls+F9QYxt7+uQ+zQ4KBX5x5LAK950bih?=
 =?us-ascii?Q?4W5Hy3irpAcJPhB2ZVvit5vTkReLXBVuL66hqM2ocCETL+e89Rdy605Sb1/7?=
 =?us-ascii?Q?3IZ4oCkIhlHhB6Mmk6cbwUpCMiXALjmkui/joRu5tJuhWb24DQ6XNfEa5o86?=
 =?us-ascii?Q?Co/FPDkY4v9+WiQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oj6k4qsetOm/KQI93OaR7mnlS3O7GZP8Xy7zf6rWZyvQ2eA3EOlLEGJFq8gp?=
 =?us-ascii?Q?QLSdaqqzqIpAkr+5yb7jNiQa4aGNn8dSveNcUbfbO6bKmE0retH15ARd26I8?=
 =?us-ascii?Q?lBLf3C68oEscTtRauOLGxshAj02YTG5CQbj0sbqwhIoEiM41JL1u1ajK+55/?=
 =?us-ascii?Q?ESlLu0HJUOyacdHP5netaYKNn5eemIhhoGnxdWaE2ohFNGN0CKAj+mwwBDgL?=
 =?us-ascii?Q?sVHUkdZuVlQlqwAMn2qkwFhnaCQmhhsCLyGn1oIwX1GfJ6lk+NJBFNkgOnt2?=
 =?us-ascii?Q?vlrUPywaFuoNMSbMuZxX0LcLglvzo6pFbecIsyy+AZw8ZFAlChn4kV+1lySS?=
 =?us-ascii?Q?2JZY35H0jpgcMfhqw/2u3UJwcEjlnGkpXD4erQ+vuBkC4oCJnfNAJolIIfq5?=
 =?us-ascii?Q?bo7Tq2LK5UHLAFRwYgehzBltzb+qD68RrebcQw7kPKlHhyDFgQWAqXWG9hEs?=
 =?us-ascii?Q?sTWySxIDax/AIHmvDQoAL/te2wgHCaaJZ7tXwiQ6BwQ219FUCt/TuVSQjvQO?=
 =?us-ascii?Q?IkKneDdRrw52LK2Ed7RIvSZwTT6mvaSUIcmDkQcykBuNxF/ckgDmQrYZmg8U?=
 =?us-ascii?Q?/veup6oYfPnY1bj/sEW7aggLiwJlIILG8FqpNp3TetcM1p8D3VG4R+C9O70l?=
 =?us-ascii?Q?PLTpEwjllniGVZXLzymWQsoCb4ZrwW0F8pIRY1DqAiTLRQmL+VQXby71BfeD?=
 =?us-ascii?Q?zyxtk+a9FNF769XhY6SABdlUupQDzXTsjljAFct/vmAZ+6CGZ0cuw4egEf0E?=
 =?us-ascii?Q?IJCE9KoPM6DbKUXLZE7iyroKc+inejDW/LCMgt2NJ7oX1/wqyO0NASH+2zgM?=
 =?us-ascii?Q?HfP6KoRsN0ydgG2rIVPJvJc9xDAII27nm0g3vBpzHgzwS9PQ7ZUmjsOMEzHK?=
 =?us-ascii?Q?7HuKHBXrbPhi5PLoY1qgWGg/YKIfXYKkCu/L02OD9j62AEQUX/BRu4Nkq8RR?=
 =?us-ascii?Q?DJ6nl6keKdXt/eJNbITUoJxyRkvqQwmhzatq8K/MIOp3d+SA8UqB+LZzMxOS?=
 =?us-ascii?Q?gzae4owBq8zUeqzULYSQ1T1A1YSOgToaoh5l8g6CXQx1u5d/pSufW5P3J+k9?=
 =?us-ascii?Q?EMOtx3rw24efN5vCuoY3aTMrh5ifVItd//Fir+9/0ZW4YZetyPUpFCzDTUn6?=
 =?us-ascii?Q?wr+oFmbaHnxLScjI4D5DLyCuSOuBPxyCLges3r/rhjFNDQCF4tv4lL8DmUrs?=
 =?us-ascii?Q?A6szSc5AfOL4bimOaWEYgIzbm64WrNiik3b+m7nDxu3OxL9hDfsUIRplTrsC?=
 =?us-ascii?Q?T2K/S1geFilDs1o6k40rIX7d9bXAg/HET04WqGjAhLNI6mPEZwPaCZj6WJoI?=
 =?us-ascii?Q?EQPjCOWnJr24Mb7/NmJxARTa2t4a+szrClZVnvX4P5FLQCZmmnUaBg+B7tma?=
 =?us-ascii?Q?B7Ost0H+XrvrB8pnPsLcRn2zYB5EScRyJkdHax/x7we6AENZTiPQfsdd6R7k?=
 =?us-ascii?Q?21PEWrksy9Triix3m+DojyUcy98t06Pz6mEK8b5qQlVgeyDa8PsmxHnGvjTI?=
 =?us-ascii?Q?wg8LT1CkYF49cNPgqDRSv0xGC+N4FE9sIAOnpy/Ltj6ghq4tz+F+dz2GmTkH?=
 =?us-ascii?Q?nlZzX+U8QOlwfLfyWwxBcpD+gBl/9uD10gdsA5r/uL9MjtlaxAFKW+pg+sgw?=
 =?us-ascii?Q?AQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2815136-c3df-4f0e-f3bd-08dd8e660b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 19:25:08.0500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZtWYdXXL7belzjXYKGD3EDUyq0CS7lL0b0U9qrjW7f+xZdhQHiDeBdbOWh/YIMMQagedDElYaySQDfcpmQG8CUGaP4+DJIB3xmWcR/NkWgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6802
X-OriginatorOrg: intel.com

Adding Sergey.

