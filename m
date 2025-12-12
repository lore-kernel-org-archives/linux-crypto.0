Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E832221DB5;
	Fri, 12 Dec 2025 01:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765501639; cv=fail; b=HsrxdxHY8+LzkM0KGMC/SLzmXEOU/9lCxNCmjiOxJH9WWNlvpLtQATkOcwMkwqV/y3hn6VoljPHjeQx8OqsjQaFZal9RR2jYbJxBoZYx7v632Q8EiPdjIfd9qWH9IG0MO9n5Eq5CKWTlcm1WsMZSQ5gbPn+xap6UIYYAetTiqv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765501639; c=relaxed/simple;
	bh=3GUjEYA52a4nqh4enT0r9LqBm2G8b9hglm5b4QRLhqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Stx+242s7NVMWXt6bYvLlkrXzv+wk1UaYG94SMrV6QdQWhpPIUhXVRFVTlt8OJzZi6veP7Qfh+UzLhuD5f3q5XlrFJRAAd8kRAO1pkqKxcXzXkyropRdHAo3K61TTR+/OW23pouUrcn6wj90MtWXy0T1VOTQnjYhK6gKa0mmAgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DVn3+9zD; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DVn3+9zD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765501637; x=1797037637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3GUjEYA52a4nqh4enT0r9LqBm2G8b9hglm5b4QRLhqc=;
  b=DVn3+9zDK8rOS66/Fb0nDkGLZG9d4ZCaRmEvVL6j++oqeBC2nCq0b1Gs
   WneRbRY5s/YQD809oqkbJ8VPdOMkEHhq/VkFtLaXTGtfMciqn/uy4AXR3
   Fck9Uy9fdK528W+sRVi7oA24UW6j0eszTi3KlHePKAbThc4mfAOU8gRt2
   +BKvYuQeFQpXSBhyT6ErHLe9vUfQ756IO+n3uYmPvWpkzqC37WepmPdN/
   6l5vsZwuM0i55Prjq+W40yhodzpWLPT5I+ZmYvtitNTE/DtY9o+r/2BFP
   zEUgquRjU2XzQDkmdqwt6HUmmQn2+IJY8IdkmHdnYeVrAxiyKqzoX2P51
   A==;
X-CSE-ConnectionGUID: 66VNgl25Q6qBXTrr0fkhhQ==
X-CSE-MsgGUID: +WdnQHg0T8mafABFz1S3Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="84901213"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="84901213"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:07:15 -0800
X-CSE-ConnectionGUID: CO5UOvDkTSia56/0rfqH3Q==
X-CSE-MsgGUID: ssDGI1dzShOBGMzcgKiwlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196554690"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:07:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:07:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 17:07:13 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:07:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBgazJlI5esKWZtZNNptekfCLfa2VCcYDh7jVeDpciUJamyQw4PTFEwcqxWH10DB6JU+FmjEHEfyfmXk9j0RYyLlbaeAmXTSohhamrTusfsrcfhcdhvRFcJtS2Ok8SpUIkj96OCV80FpKPpAnIi3P41bfL8qTDoc/sfFRjY9bo7q20OH+Y/PsgPQNr8NFk0VrICNgXLsUT9zr4CW8a582JLKsnjkFMrr+4e/xxrFf27ruPPr3oi6aUFa5wmsOsFRCUCuuPcBC0fJCPkisx4IbIuEWd68uNIraXzuhXGpK+ywEGAHk7RknMb2BRp5NcQJYfd2hWeYqHQbJfhXF4+zCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO+Zf/oVrziJOPC6V+J962oBoEze9Uj2guxMzyAyDTM=;
 b=WSKHdLrvfdab87OhWFReAHT4h14OgxwYx4SIxWrbF7n412bex+koPej+4kk5wKukZDfz9s2DtmAldf+SVG3pxv3aCtvFwwYA0gzxqn+2HrGldockIYcDfQks5psScG6I6Nj0yH1OMxirZjnnXLO7zmKxu3FR0xBcl/CZwMaRilXAvlIhQp7RfoEU3dZjbpzsNZU96s5CpwUkerGpCeChGNV68CAe8XZ1ytEf2mH5oLQTPoE2xjz58mK99t38ardQ6xfEny1wfilWUQaaFCSiNZnW0tF6iBoXmZYUGMWBAG1J9U2YdsC6V66Pv6JZcDPPpBPOINctg41n7IZfRc0b6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS4PPF69154114F.namprd11.prod.outlook.com (2603:10b6:f:fc02::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Fri, 12 Dec
 2025 01:07:08 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 01:07:08 +0000
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
Subject: RE: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL() to
 check acomp_ctx resources.
Thread-Topic: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL()
 to check acomp_ctx resources.
Thread-Index: AQHcTWsw1XYYd7o4XEunpNppvJypWbTxHIqAgCxPn1A=
Date: Fri, 12 Dec 2025 01:07:08 +0000
Message-ID: <SJ2PR11MB8472CBD23CC29E5E896E07F9C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
 <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
In-Reply-To: <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS4PPF69154114F:EE_
x-ms-office365-filtering-correlation-id: 74431586-4329-42b9-35ec-08de391ac5e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?piJtCgrn1P9tiGQzfM274AE+h2du07PvcEdLhWs5KV6IKNA3Ou/xvqMNGwYO?=
 =?us-ascii?Q?o8sX0rzdI4Ed4/yW+4bBwJRKglHaJPRB9q+x/V5Iyz21T0fuIIfFpBqC1UfZ?=
 =?us-ascii?Q?XrfF+6p3jjHNbY49gJwsJQVfm1zI2/o+jbWc+ZqS27fLt7XeSbPZz38mruJI?=
 =?us-ascii?Q?q1W7uVxQPvqLrMvkFISGpfPv4s7hpv0rsSZv6oR9biSDzRbzqBIM5cLZHc59?=
 =?us-ascii?Q?W4XLMpPAqb0/xO8w5f+Ofh2+AR8uCjSyxzUrty8jEJH2/5QtdVSeZmcFlrX7?=
 =?us-ascii?Q?8pkWmEMbIkOabY7y8FidAa2rdxWsZjnY4VRFIy7U5utpRMpoW7JZikDnX1UB?=
 =?us-ascii?Q?L2slZEcNwbTU9Ly5qxV5jG/RCxEg9Hs0xQF4MJhCv1dMqFAvUQAKdEfYH6Q7?=
 =?us-ascii?Q?YF4b/xVtTd8DSj5L29LSGSx0njEEyaRrUbhOmHTLOJw2d05xo+WmQ65mRneW?=
 =?us-ascii?Q?B5ZA9RUn1t9A+XqHJZDqSEeD8QS7vooP7lMHsE3eGAXohrWtNJhTsf8368HA?=
 =?us-ascii?Q?QGwnyp9S+so+jifcwsqtomdCjth55yaMsIGRUy7a1togNfrgteh3/s3zukIM?=
 =?us-ascii?Q?cf7JALsyKESxlUWpxk8P4LiSOqMEbhkbGsf/aSQ4t54KSIHRB9w+2ea8xOMI?=
 =?us-ascii?Q?uGS1ov7hqxgwRebDkAftGgWoUtoNBUtMGsB6Ay7hJrDvd2s98mrzmXfT/DiN?=
 =?us-ascii?Q?vKkuUyl6B0/U5C+Ni7AZ6ezfkPpYyN3nnu1SdXvdaxFDhzxbQLol/9wukaD2?=
 =?us-ascii?Q?8z/4yPQspltkId/E+tdIYC4hupNwTPptuKwG6YYpMd+rg16iWq/ArBEW7bZX?=
 =?us-ascii?Q?PfZb0BK0bLuHhZOvsg6K33u5OqpvGQEDqBVIZddYuNhai+nUEhp5j3RBXJSs?=
 =?us-ascii?Q?UTSFmfW4ULsm3/4kOCWKhC8Tqa8GJmr62A0jXSednGWhAh9u+R5kZLbBjE6u?=
 =?us-ascii?Q?Tl0xQ0uPq2kuSTuKmQk8zC0KkpvRg9Xj5Q8SvVq9CUuDrFS18DTM9hEiVfzn?=
 =?us-ascii?Q?z7n2SHdKylHvMs6bXcoztY+upT4mKBm0PloCzYYo8fWCR/4Zz9k+Ujjir0hI?=
 =?us-ascii?Q?ZfRVw20VVf3V0+l6n/9BhoLLQ5b2GE945yFXuY8op3DCmNS+X+Ltvl9chGZc?=
 =?us-ascii?Q?nIGfMfUJM7XacQyNoeySvph1pHYt+6qoj8Z7rFSAD83iaiOjwIGZHgzGtlft?=
 =?us-ascii?Q?CqCXJD5DmimBeb8s8Exm8vCiWhm33LeiC94IsneCM9SwUcwnFWLk/SH+MEPV?=
 =?us-ascii?Q?CyS9aM7ui8vv6vZW/V3o/95kkui9eP+NbJxc+97x1q5JoHb/yTGCs90A1QJd?=
 =?us-ascii?Q?Owh0au1/ADcp/ABNK3hMBJXEyalxwkejI8okMvt22DfNJwmS/1qnQ1AnCUyn?=
 =?us-ascii?Q?8QvIF67wX/ZnCN66VsvYEJYmm3m2bgZ8Vs7k4/6aK2HxedylRzlqZWiUGwE1?=
 =?us-ascii?Q?yHtfiFHYacH3Ra5kVkF0wdzuK9QFsGVLYydtdRii/C7MM6q3LwnjuVu3hRwf?=
 =?us-ascii?Q?j7lAwz/lI2ZYDRKvZcdSWhLiyhVhGog4u1VA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Ws1tvPudOOBzL6Wbso/L/pBoT2W4Gd11WE5H9q1Wkf6xxfGXLk5M/Og9YA6?=
 =?us-ascii?Q?WlnZCtLcEJSF5ETkVU5CO64jOaW25Jlr+Y6sC8t6a7cQQx4PMqSL8IOwFSBu?=
 =?us-ascii?Q?4U7PvhQM3pCLywEUFZePy+rEBZkCUpXtZDvOyM8WArY1lQB6vfJdn+vVwzgG?=
 =?us-ascii?Q?hgxOMMYXbR/YV1kowpNHsaBja5Cleq44BdNFSnLn9Ks1vcZDxdTVskp7q6MX?=
 =?us-ascii?Q?3Meje3VkyPe/KrhH8tSrvyifyVbb2xPKJOktDPXxuR9EueMO48onlfiHZexZ?=
 =?us-ascii?Q?/O/x1HoHg3CsH7wfEUwaqsRD9oraQIFeLwhKr6ErOZ+QFANo6MaAj9HIrx7M?=
 =?us-ascii?Q?CjXzygG+PP3AZIr9tN6p1LMoJdGOcVWadEF0gpc0hSqUe2mMa9FoJ45/ZTDm?=
 =?us-ascii?Q?3WN0hztD3vrp2uTNJ9SzD6WEJWHw0+lroNpOAy59D05t4ctqMnnn6tvm6Cwi?=
 =?us-ascii?Q?pUzgRUL3dNZe0fFZtlsQl75b/s6Rc2L+lLdsWss0GsFreqzLr5Lb3jEZ+Ldm?=
 =?us-ascii?Q?KFnpdkWtbw4DCe0WH56omq+VBhFoGytdIEB++7SSrOiE8fAFVCfmUMGT4jZA?=
 =?us-ascii?Q?wPWTzKUvdYhf4uQCmNVo/xMMv2tr5iQ3sSc4LcuYqFEOfqJFyOkHXmDhX9ke?=
 =?us-ascii?Q?aNtvcXXfQrp3ntN7jQY3fch0qiABepjY4NJvxhq2QfaQ+OfDYSUbZImQdK2x?=
 =?us-ascii?Q?xMH5sN9hFBpybaiiXkkKaBK9PHw+xqamHREGdR7HAryWb9UsOL9V6BcEpLah?=
 =?us-ascii?Q?LfNXDEPOHk/X6L19uLB15FvuNj5auwIXgjoqvGvnw97+3Xb30KDGW1adRO9E?=
 =?us-ascii?Q?zGTQqxOb0kVGwhsXZ5YK+CE9ZgzqMs5Sv65IDjRVvCTclUX02Qx/iRAdNCcr?=
 =?us-ascii?Q?aYX27VSpuKT67mcirYZWmwEvn/+P2opbHBfIGHJTH6NDuk8psIML+L4730j7?=
 =?us-ascii?Q?eokV5xIoQ+JjwS/1+4PS8gk6dAXy8/H8MUzAmW4rK+6+aVDMxJREa+KKBixT?=
 =?us-ascii?Q?1hdWg8hbqFSE75QCCEPeIyBUoVcOl5GIZ0MJ49rt5tkB7B706bC9M0zoJqrg?=
 =?us-ascii?Q?oxNbYtCODX/7DO+vZuAt8zevmn0nyrWJAAvn8YSbK3UX0Fg9jGwJ2GQR0eWv?=
 =?us-ascii?Q?18gSmDWRUkfG6c+8XlQ6F7xXGGCfuK4uld3HoOiAVOJMjg1FMuvaRmy1lLW2?=
 =?us-ascii?Q?DcNnYrAwwnLz2eSann6uCkykOUqu5ezcvimZyikmoEyhlnJOcNjP5oBzQHi5?=
 =?us-ascii?Q?lxODdhzz7bQqgshOegX0Xxl1+0/oPlcx7iV5+NIuGFCXH6pD5Qg1+5Bj9e5e?=
 =?us-ascii?Q?PDcu83v8InNXsOXrZulic0K+LIUwx7P8be1upVXFjWENqAezv2o3wqTWnH30?=
 =?us-ascii?Q?CYpR5J8rF3yT5dE9ARKl8Wk8PDuzuHEUus+nIsYlboMHwj+9HcJINTro95cW?=
 =?us-ascii?Q?LiqpeB38XU94tSxwQ8Igr+x3GRlSDIsvVB9/6IvY6xu6ZNPfxWlAJtaXUdhF?=
 =?us-ascii?Q?RLXBqFK3sRiB35fTWk3NU1g4kDDz1f8bBIpyBFC64yR68k4nvkAWlLl8Skxr?=
 =?us-ascii?Q?S/EGHlnwuzVJGQ2lzXwiwOhho9F3vCMYgJghj0YGhecvRvf0iuiiYu8llER5?=
 =?us-ascii?Q?hWmImxrfY51t9jrdXWOh5A7qp/PoBLHjD7mo+BgFgXHUAcWltni43g2v+xNv?=
 =?us-ascii?Q?IIDCAQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 74431586-4329-42b9-35ec-08de391ac5e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 01:07:08.4930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrQJ8JSo+SqdYbYsvegoMpiFnpPJJBChZ7COkbfP+OLHA7OleaOnz1+756JrB57UcmVyV3Dzk4I5AZRta//ZiRW1+M6rFHrtBBEtWqWWAtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF69154114F
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 12:26 PM
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
> Subject: Re: [PATCH v13 20/22] mm: zswap: Consistently use
> IS_ERR_OR_NULL() to check acomp_ctx resources.
>=20
> On Tue, Nov 04, 2025 at 01:12:33AM -0800, Kanchana P Sridhar wrote:
> > This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
> > for valid acomp/req, thereby making it consistent with
> > acomp_ctx_dealloc().
>=20
> Instead of "This patch..":
>=20
> Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
> acomp/req, making it consistent with acomp_ctx_dealloc().
>=20
> >
> > This is based on this earlier comment [1] from Yosry, when reviewing v8=
.
>=20
> Drop this statement, it loses its meaning after the code is merged.
>=20
> With those changes:
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Sounds great, and thanks for the Ack!

Thanks,
Kanchana

>=20
> >
> > [1] https://patchwork.kernel.org/comment/26282128/
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 87d50786f61f..cb384eb7c815 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  		return ret;
> >
> >  	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > -	if (IS_ERR(acomp_ctx->acomp)) {
> > +	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> >  				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> >  		ret =3D PTR_ERR(acomp_ctx->acomp);
> > @@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> >  	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > -	if (!acomp_ctx->req) {
> > +	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> >  		       pool->tfm_name);
> >  		goto fail;
> > --
> > 2.27.0
> >
