Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD222D7B1;
	Fri, 12 Dec 2025 20:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765572800; cv=fail; b=AkU0In6DXBvM77+zwvvEuPQ9caMFSYzYLMNl1UrQ9A7/iwmk/G+juITOUQUZvPGWxurik+sHFKBucXiVaQo6YWE44WcCf4rePHHqxNPA9YmzE1NJnID0At+HV2ArYxcLLHN80ciCOVT+zmI+/p3XYzX8MizUwZgIR75OGy3YkAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765572800; c=relaxed/simple;
	bh=J1mvkE+v3LpQYUv0i7HSCcroHDpNORoAcaX/8L/L4c0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XGFhJpXr8c9vyVIM38Qtk3841EzJouOV+jWuZmjd7W8kF8f/sWxtbC6DWO3CU/+XKa1ECD4Z4Y/KvspWCkGfbHhTIoT/du8Zdgi0bQJ8qheDvwQN/f0aDWVKaolHhEEr4j83kJE2VtmwKpbX7u8QPzUwCn3bxOEO4wWiJS6q4PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLg5n45j; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLg5n45j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765572799; x=1797108799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J1mvkE+v3LpQYUv0i7HSCcroHDpNORoAcaX/8L/L4c0=;
  b=JLg5n45jVpvI74ZI8ugCFls1yHPUW7E6QOeD7Puv7YMvBkeDoAFYlSHf
   N7idCEJ0qhMxSyH+RXxjuUqVo0eDWfK6X52zzjeWc60R8ycXW/slYrRux
   LsaX86cfkOiLxbVhkL0eoKh+V8SmgWLnCDUCR/aDEnSg2jqi39aRcel2+
   fzSbn8stcPr2hgZpxi2inTfnOnvDfl93iLdMZRWQt4uPpFgZNAul8bJb6
   3DzrU9nQo4epvoGUgBEqM+UZsgP9GO5F88KXZMi+UNmjihVPPt30ylDhx
   4HuNGyNtcxDdTRhVJrUCQG7d1a8ywfIClH6SqIgJCWGsW6UuL5WFcikbR
   Q==;
X-CSE-ConnectionGUID: qGkASLV3RF2RBc3tKTHFsw==
X-CSE-MsgGUID: swmBHYRVQL2IjnS8M/SHGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="78952495"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="78952495"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 12:53:18 -0800
X-CSE-ConnectionGUID: 1bO012G2TmWuKQsAgt1gFg==
X-CSE-MsgGUID: hMPHPJ0nSe6sK6DIaGKHng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197443609"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 12:53:17 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 12:53:17 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 12 Dec 2025 12:53:16 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.29)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 12:53:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8wsoMkXy0cCEwjm06DVyy4tsKX1SOe97L+lV+c6b5v8u2T14AS7pncuwHDp35kPAkZvfbaP1eHkdv0iTi4OaFQ62h0st0B0VEJmQ5A1MdtVXWeg1viL69Dr9zCQ/DpL6vgsbX1WvRtuQJCXwJx3TznMwuxiALLwlV8OtUMvzI7VTQa7bjVrXsIjlJOLwnsrgOnC4zT5KtGlPXhEDF63IIjs2uop4wOCyDWSo0NWruz6RGKnWNEK5+FWDh9yacoxuTVGSGD3vQInC1mCzUHECqO79+75gWqsYUwOGBOe3sUl6cXa8n6aI7V4AuTrIaQCwMS0i1K5CspQCXEK5PMYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCQv4vBJdWuH356DgK6TOxKuPACq6CafIc4AxhrSV/k=;
 b=kGD5YaGML/j2IY45YR7xIMIdd3lpjZ87EPM0gcF6kB6znU4U+3DPB2uoQDwIaFlpUi0tXVJAuAvVMWKKwdbG8avEYsSKp2mZZPGN44GCzinDC93MuoJWPgn76YE2ozHh2O91cAak0BigrEf/6fnubd1ar4t6sBcgrHFXRtU2lDDREG6m+ZRQre3F9o+im3wsdNzxIclvvuwylJ4qeYg7o27w2o/JDX4fle4GXaepAPVoCAPbsCD+rTW61xpY8yKur3HsJng8c0Nbn44iPZ9lC7+5m1TAUT6AYMXsPrD7lHxA4QJNcX6U5GkL0CYbbLNX9qVBhNSZvntJ87xSc0zrvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by CY8PR11MB7266.namprd11.prod.outlook.com (2603:10b6:930:99::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 20:53:14 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 20:53:13 +0000
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
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgC1uKYCAAAlEAIAAIBNQ
Date: Fri, 12 Dec 2025 20:53:13 +0000
Message-ID: <SJ2PR11MB8472C23A8E67F71D207D66E1C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
In-Reply-To: <ckbfre67zsl7rylmevf5kuptbbmyubybfvrx5mynofp3u6lvtt@pm4kdak5d3zx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|CY8PR11MB7266:EE_
x-ms-office365-filtering-correlation-id: 3fe38f15-1b5d-4140-bba1-08de39c077a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?PZ3JqFYS6NhcwjYMxLvMi+GbDMGlLvQ75diIGFG8c1W/KW3532zp83PIFqMR?=
 =?us-ascii?Q?d3+gWigRYG0YnB106khFkXFD/C3ZFURI2UMYDAYM0yZgg2UjDEiDU9faNtKE?=
 =?us-ascii?Q?x5MUZY+I2IIRarN9urv9X6JwAehbEAW0pMY5C+fqagbxojV7OI5KVudkrGmB?=
 =?us-ascii?Q?a0eV7OkQCZNoidZiWaVE0yCsUKdSUeTHXuGa6CsK0ZgjRZ8GOqx0LLt9N6Sn?=
 =?us-ascii?Q?M55mSNYlH2pHoMAHCybldm4yLAV9cYdej9vj65gPREn0b4+erkEvT6cMmK59?=
 =?us-ascii?Q?NgFWuxlT0qzWn+uQDRwMwzmZBSJg8SsDoYktY9vqqMS8jN7Y3i4v2KaesMSs?=
 =?us-ascii?Q?zYeCj9wVHq1mKGemqY4vklUshSXGoKSb1yjTTpS1SnJmHttijl9mTqDcgp9Y?=
 =?us-ascii?Q?IH9vMgf/0429T/fgMYGf5CKX5jDMbpTiyQqK5d0aZRjMwPO5hGcVnIhUXaKo?=
 =?us-ascii?Q?OEHOE+0EMXT5Xn4biFAAsKnnrGV484JOAPiRtP8tMjSyAqDhA1h1eC+w8Bb8?=
 =?us-ascii?Q?PMHwsag8BrBLTRaJdETM4US6IwJUc91ckg3Ijxn3trOY2T/V0vV7055Ou7h+?=
 =?us-ascii?Q?Dt+PXNh7k4MovR3dsxmfpNQLaE4d6E23Kfs+bg4e0RcWvqSSHqaEmHpG/8YF?=
 =?us-ascii?Q?/ftHtDhTh/TdEEwxjFv+q7z/KrzPYov4LfKgpQoV09cvmQPgc45ZqzoL7YZg?=
 =?us-ascii?Q?s7h4W9gbbWSrJYvUhxrzuUpSEIYDXg5tC7/G722aXc2i2Y2KTn1xtZIcoSd7?=
 =?us-ascii?Q?gbCpgvERoXDmDobyQN+Iz34t4NL4xljJ272yRawObDEyXjC0V8EXPTg7Fv9p?=
 =?us-ascii?Q?AyvmfG2178fWZHqnWjHVVFNQB6r5EdfV/2BPuzXixFGMNnzDA1G2ea02rNxf?=
 =?us-ascii?Q?kl5U66LF1N8Xm0jWe9Och/9sDmEPge4uL3RdzCB1YLHv4yi+dBxwlvOqiEkA?=
 =?us-ascii?Q?ezW/KQJAhML+gKrAU8ajNZk13wlcy3YGzS2BRH3SWSWE5voA/OXNoGNk8Art?=
 =?us-ascii?Q?xVVPYLE8NwHM5qdy9QUcz7nHt+NG9AygwDCutoxPPlXZ52Ayw5V0nEGVPDIY?=
 =?us-ascii?Q?X3mtS3xptNjnJvdzd2y0tct4jK8n8yzalO9fgrabZ7faLAQDteJ5aZauAaJW?=
 =?us-ascii?Q?TZu8na8lVptDqTwNEyGkn56aF5jKO7TyzeQNUpJXiFZfl4OA4Z9gCbDuSgYP?=
 =?us-ascii?Q?VjT93prAANlnk5PkLzl2po8FFXc5RwgPxiluH8pxMsCaBPRuL7aGo0JAQbz/?=
 =?us-ascii?Q?QtoPyMLzgysloEtFcEtXwXw0fP4G42OXjatmce41sEkmVQarYBOo402PbmKY?=
 =?us-ascii?Q?Wcsrb2RcWXwC6qPnnksHel+LfT3jijq8E9xexnJGoDyNoMzGnZZbq79fzZoZ?=
 =?us-ascii?Q?sySGwys6Bd/01S1j8XRmQAGd3GMqX4kyax3VXO9dT1J0b+CYAIG8PjwQC9n9?=
 =?us-ascii?Q?ela9XyFSRu8BHivk/FGy7oUMMv0Ca5TQ/B9NFMSUzRm79rWNrr863ZyQk4ll?=
 =?us-ascii?Q?20gVJzO9f3D7gnt6mtWpafxfsWVKE+Ni7Ht0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B6xzXEm3NPVKV7a1Yi03XXsAYptrB9aeitpgw9ReZY8qwoAkQoLHAs1r5Sda?=
 =?us-ascii?Q?0Y7tWBZH1GvtYr06BzYtaioHOyMUu76ftV5Mpx/btRK7SZEHobetCR5KsXPS?=
 =?us-ascii?Q?hc/GoLtr2VJSeZlhbAmsYv7aUgdlYcD/5TmNsXJ5ETYzXzJv9ALQQbyGFzU7?=
 =?us-ascii?Q?O3HrqQV1IUR2OzPEGMIUEtzh1Ng7bdVBF7Qe2SidhoyBSqy8bBMheRaSo13u?=
 =?us-ascii?Q?9VCFfAq+wXptUEwwtRsjh22O2U9itr7c3zZ6rNyRmr5m4b5IqxWVVd6sdjpo?=
 =?us-ascii?Q?qxkJ6WVYoHbu2tdaTX1aYuQnHi+B8SXZqPTu7KFof+IKHk6hs8IPSAKTofwj?=
 =?us-ascii?Q?gjjpR5TfeTbP7UL5p1Fwqy6RADwuDm4FEzQ+qPiIEA52sR0yqRd8/TAZwy8G?=
 =?us-ascii?Q?HqNNdinwxvXgzz/ONML9/lczNxqO5zrqOtI6lDbzogJIwySfwYYzxUM5L8DV?=
 =?us-ascii?Q?cIgJ3FBsewr8OpA0fGpbkGoJjaUufjpYONnYfij9c9rc8/cGcXj4nWhumxsH?=
 =?us-ascii?Q?zeifekOgnGesDZJN4rj3KrnPb2CbmL4rzx/H4pZDcRSjS0ckIiZF8TtccFi7?=
 =?us-ascii?Q?RhpQVLbbqkL45tIUOrprVj4CYB7AO3M1mBBtuhGlVoRkJdFy5xF76tU/W0Mn?=
 =?us-ascii?Q?te6VFqiohQmRjryLEJRns+mwRh0D1fa1lK772zaCbAPXSLrpuWVJeE7TP/Ua?=
 =?us-ascii?Q?nKVqmBaVlet6J7aXeRyvgZNm+vkDAZ5oZe/xASZcee0Vzv5ErOtPG+HgKmI7?=
 =?us-ascii?Q?ZpxN5AiW4jM+Y8hB3+cG4D1qMjSmcsZ4Y7YCzyjJqJhuGuXl49ZlA/DuFdzH?=
 =?us-ascii?Q?SJ5RdAF4gsWi53oLzRgKfDqX23faWYHKjMxp8PVYOb6pfQLat610FUNLemMc?=
 =?us-ascii?Q?LnlbGkAaFW6xDlTcUXnTuOldgspI5b6KZAK8/OfgJg49uFcMSOzfmtQO9tva?=
 =?us-ascii?Q?rgZFfmipHNU03qWaUFUE2xj09iBU0MDjT2plmOA4526sySqTY6nVAj59p44U?=
 =?us-ascii?Q?Mf2p2UMce5t/7+xvJ4xv/XW4RVnur8ZhkSw3bXn31gPt8BaDnziLUvqqmHmS?=
 =?us-ascii?Q?5j+lQYzKvmGI/l4wnzyYfNRm1fLfYtiVPgnOGLhhwdnQeNVIMpftzKnIjxBb?=
 =?us-ascii?Q?+X293paWBElMcwrMZ+tdb1B++2QUWt9+vAt5AUeMKERUQYNsoDnQ0LQmG5af?=
 =?us-ascii?Q?bLVx8IDJ6Usx7OqpDSXTSAzSgwV4NdsS+u/oL0OHUYdgvSxjIYemUgNaBXtq?=
 =?us-ascii?Q?x+EDzmt0sg9ia14BelcJmx8EufKuhRkUDDp3Q7me7vkvr3VMwrdcawhR8ONX?=
 =?us-ascii?Q?4Pyjo/I6pqoLD55EIylt9/qZh49oPtlbZNTykwGW/g3BKNMWrZ5zxc+4d+lq?=
 =?us-ascii?Q?tYful/GJR+d3fKwbb/OqJ7yfIlq6joh76vh1DOOaCFwV3pNPfdB6hs6RyiGR?=
 =?us-ascii?Q?ctBV+nyd1DFB8Wr9xmjWxRBhz/Rv7aRtsVRRseZEdYTc8rKIwVFLDj4odBYc?=
 =?us-ascii?Q?O5bXBWgxktlflwqirYhaEQBXmkUVwkU6KRDUV9tkVl+tvoXnokgVg6H3Ak0i?=
 =?us-ascii?Q?+9BXvtiQF6s/DyQYdOvI24TZO1ttHCgOx96Cw/4BTcPDNqNkDywwwgDB4TIl?=
 =?us-ascii?Q?Kn1st4YIG+nWXchfbnC9N7xLU833nz3PTbu4hOL5RhJfb6Zlq9xeoy5OBYSV?=
 =?us-ascii?Q?XId6SA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe38f15-1b5d-4140-bba1-08de39c077a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 20:53:13.6948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MNm6/2ULuR1RnASmHFIVB4PsuKejhue6C49xWUdUwL2R53FyNA7r5yGrS/lttVh6prv+IvwAE10+Whjw47w9iVipWleULoLHZPjuZffKNTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7266
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, December 12, 2025 10:44 AM
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
> Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Fri, Dec 12, 2025 at 06:17:07PM +0000, Sridhar, Kanchana P wrote:
> > >
> > > >  	ret =3D
> > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > >  				       &pool->node);
> > > >  	if (ret)
> > > > -		goto error;
> > > > +		goto ref_fail;
> > >
> > > IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> > > probably should add a new label.
> >
> > In this case we should because it is part of the pool creation failure
> > handling flow, at the end of which, the pool will be deleted.
>=20
> What I mean is, when cpuhp_state_add_instance() fails we goto ref_fail
> which will call cpuhp_state_remove_instance(). But the current code does
> not call cpuhp_state_remove_instance() if cpuhp_state_add_instance()
> fails.

I see what you mean. The current mainline code does not call
cpuhp_state_remove_instance() if cpuhp_state_add_instance() fails, because
the cpuhotplug code will call the teardown callback in this case.

In this patch, I do need to call cpuhp_state_remove_instance() and
acomp_ctx_dealloc() in this case because there is no teardown callback
being registered.

>=20
> >
> > >
> > > >
> > > >  	/* being the current pool takes 1 ref; this func expects the
> > > >  	 * caller to always add the new pool as the current pool
> > > > @@ -292,6 +313,9 @@ static struct zswap_pool
> *zswap_pool_create(char
> > > *compressor)
> > > >
> > > >  ref_fail:
> > > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > &pool->node);
> > > > +
> > > > +	for_each_possible_cpu(cpu)
> > > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > >  error:
> > > >  	if (pool->acomp_ctx)
> > > >  		free_percpu(pool->acomp_ctx);
> > > > @@ -322,9 +346,15 @@ static struct zswap_pool
> > > *__zswap_pool_create_fallback(void)
> > > >
> > > >  static void zswap_pool_destroy(struct zswap_pool *pool)
> > > >  {
> > > > +	int cpu;
> > > > +
> > > >  	zswap_pool_debug("destroying", pool);
> > > >
> > > >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > &pool->node);
> > > > +
> > > > +	for_each_possible_cpu(cpu)
> > > > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > > > +
> > > >  	free_percpu(pool->acomp_ctx);
> > > >
> > > >  	zs_destroy_pool(pool->zs_pool);
> > > > @@ -736,39 +766,35 @@ static int
> zswap_cpu_comp_prepare(unsigned int
> > > cpu, struct hlist_node *node)
> > > >  {
> > > >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> > > node);
> > > >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> > > >acomp_ctx, cpu);
> > > > -	struct crypto_acomp *acomp =3D NULL;
> > > > -	struct acomp_req *req =3D NULL;
> > > > -	u8 *buffer =3D NULL;
> > > > -	int ret;
> > > > +	int ret =3D -ENOMEM;
> > > >
> > > > -	buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > > > -	if (!buffer) {
> > > > -		ret =3D -ENOMEM;
> > > > -		goto fail;
> > > > -	}
> > > > +	/*
> > > > +	 * To handle cases where the CPU goes through online-offline-onli=
ne
> > > > +	 * transitions, we return if the acomp_ctx has already been initi=
alized.
> > > > +	 */
> > > > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > > > +		return 0;
> > >
> > > Is it possible for acomp_ctx->acomp to be an ERR value here? If it is=
,
> > > then zswap initialization should have failed. Maybe WARN_ON_ONCE() fo=
r
> > > that case?
> >
> > This is checking for a valid acomp_ctx->acomp using the same criteria
> > being uniformly used in acomp_ctx_dealloc(). This check is necessary to
> > handle the case where the CPU goes through online-offline-online state
> > transitions.
>=20
> I think I am confused. I thought now we don't free this on CPU offline,
> so either it's NULL because this is the first time we initialize it on
> this CPU, or it is allocated.

Yes, this is correct.

> If it is an ERR value, then the pool
> creation should have failed and we wouldn't be calling this again on CPU
> online.
>=20
> In other words, what scenario do we expect to legitimately see an ERR
> value here?

I am using "(!IS_ERR_OR_NULL(acomp_ctx->acomp)" as a check for the
acomp being allocated already. I could instead have used "if (acomp_ctx->ac=
omp)",
but use the former to be consistent with patch 20/22.

I cannot think of a scenario where we can expect an ERR value here.

Thanks,
Kanchana
