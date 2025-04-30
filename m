Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89512126C05;
	Wed, 30 Apr 2025 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047747; cv=fail; b=dbuaDPmPwNjbRQeZ3Hzj8EPgcKu4HvtUPzOfOjwahVBT+UraU08F0r85fgiskYIGQXgolSRL6W8IE5zZXcsFGLKut/m+TTRxb++H/TmKKZvy+iXxMcPmkq7joZRJHHXjsQ9mXrY6nemxDeQ+IuOg30BQJwihjqzrTxBKi+UbTPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047747; c=relaxed/simple;
	bh=vGUn4ApPsdtzokNpyoBg0VYq3gtDqlZsMeSnFSKkhbo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BMSj21FcmdxtBB/ptcsije4cleZXIKEmzBnrxg1njCxU8ZI0Z3/RHcPI2X0hUrC8S06T+fPC1NMFhM3PVO8fh6lfF4e3ZjytUHroqyLCToCSJ3gUL4rN9mfoA86QjdrcIjJMGLWeKP9SirIMESzdaxNIsRkD1SdAnJU/H9Mt+Pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVpQ0DQf; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVpQ0DQf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746047746; x=1777583746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vGUn4ApPsdtzokNpyoBg0VYq3gtDqlZsMeSnFSKkhbo=;
  b=RVpQ0DQfuw4iLqPIyud5sPkQPy8PAJptwKMoIC92tb6Suaakokk4JxT4
   Cieb6T+KGF3hR00Ev2QeDHCnbZmovj53jG4pQKe4t3rkimCAvX5cY8nhY
   oWks4fzTysnlcMKp8MqC8QQMlMUDdHQvfz+4yCc3ffTUo/yiiYGl5hro+
   X7i1UBR8rv5ERr9aXjVdxenMJpIooSLwFAay57gTbfIBpGK5c4R//bmMf
   LNbZcPees9+nXlNDGPkc2GJFa3tB6+KXuw1YQoHx6dK8oHQLIGFxgvBaP
   yMpgCu6ri2SQQNHrM8BSOpN3k15SFPMZ3YjHMkZbo/ITLd7eu/Snj7moh
   g==;
X-CSE-ConnectionGUID: AB4dUH5DTWapaiXPlD4hMQ==
X-CSE-MsgGUID: /eHAV1CyTPCHR1LeAT0XtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47633519"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="47633519"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:15:42 -0700
X-CSE-ConnectionGUID: pCXJa22NRLWKvyaWoxnIfQ==
X-CSE-MsgGUID: oOQDHHcWRs6kjFVRQ1LBww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="134169078"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:15:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 14:15:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 14:15:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 14:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOKvAIf6yuoVLQR9oEQPHSTd0aEBW2zHtjfTqLGUYh7hAXdZOIdvtONrKOMpjVP82wJa9hHv65sOoVNv7a3ZiikbSif7yl7lI/i1FN27614j12L/+sE63nyvzLAZh7qeE+guX5EI98EhSt/RyxIPnBlyCXTgCPHzBmEEz1ybSemyNGDuq3UlbBlxM/T9SpCzxLgtQ2FuCGCPOxOqoj5dek69f4ajDcN474n7zBW3CFecj+JpQKP9BdL8k9Yq8mD5rDIZSHcaqDMn20pMRElXMLdBDJy5McCOxk+zz+MIneKXa4lXmdhTEcOM8/EndN9mSgsXTcl/VhYSHWmcCiVuUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9vSecYw+yKSsNx+RXN9SQXiKgc8tHMSq6XDYXJ3+kw=;
 b=qkY6wrEcMZbmX3kpVBEA1Js7c8Wufm05skjJhD24qQGyTeiRUyrhqvwdB0Y/dro77k51xVDNJoI+Wm45Gz4N8rM6vKzrB2lNGyOdekvJ0jsi41LMwxLiLBkU4El3/DOm05hT7lkX2osXxal9kK10cprOgOEqXtaCOka1ZltX4PLD+UHLmANPtYMDUNYOHuwPotveyyiD5H8SOAy8DBhuA9sP+hxaFxcg12MuUKJQ9lOPnGqoDWGO1Lk7b/qRa5Wn5eCWb5Suoz0nJ09imvslgw9f8ObceFhXd5GbyrF6LEQX/5v2oeuuzMO/V+xNMw7HBzLyh1MoVzXmxHF0d1IPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 21:15:20 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%5]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 21:15:19 +0000
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
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v8 13/14] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v8 13/14] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHbjBjwi+6+ny6QHU+1SXyLkH1U4bNmjMIAgFaC5BA=
Date: Wed, 30 Apr 2025 21:15:19 +0000
Message-ID: <PH7PR11MB8121A2B54A5887004754AF3AC9832@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-14-kanchana.p.sridhar@intel.com>
 <Z8n--rF3H2-uWhEc@google.com>
In-Reply-To: <Z8n--rF3H2-uWhEc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH0PR11MB4965:EE_
x-ms-office365-filtering-correlation-id: ee22b09f-8f2c-483e-83c5-08dd882c1cad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?GnsW1RUUb+HJCF0BvmJX8mGwCXni/an7lyz7r5cGMEElkGIwt6JV+fW+KgAl?=
 =?us-ascii?Q?qQY01rayUdNg8azScTkudRhiRNk9ImwBaOjoVirMeyDbten5EFsTiSfxexkO?=
 =?us-ascii?Q?ING3/ez9vKC9xdDLjK2hWDiLdcE8GcsS6UzaqZWtKLakwWNXlTfs4I/1zj+B?=
 =?us-ascii?Q?eL2mL75Fd1f1fJFbn7iUj3eeag5lz0BA6u89ikN3M0BRsFBPaWBpzdf2uHY6?=
 =?us-ascii?Q?y2zOckoBTahZy9ey2uUOkuK/QrKbrH82eYn5IDGwuCMNUFYuh5vMqU24qpxt?=
 =?us-ascii?Q?DkVA3F5LLiRfi11hlp40R/ANgQXULx+k67OxlvlM055ffWPjX1VUtvtJ2Dsr?=
 =?us-ascii?Q?Ns2RaQPe2VkvCBX/RA/nkv0ugIsrYc5GKWxUt2niSHwpGgcmGvCIWPh/m475?=
 =?us-ascii?Q?kGoCcUAuUXMCDCXqVZ0sd2E4pcCG5Lcq7lg9VloViJO8eBYTia0tRd9petOT?=
 =?us-ascii?Q?E/nTIMKjmLJUGIi8uOYXgXOFoKptq5XwrQNEL2iffmD1cVjg9zf2lvVlu6aN?=
 =?us-ascii?Q?f+6N/p2coKsFPtWt2CoQ2Jd1BAGwXLwXhJqzCA51OC9noKKksRrUM+Jf/BFi?=
 =?us-ascii?Q?7oasWD6fui2IHs2rtkHvqReMcgKt0WGu/VR98NyfYRDIoxtlfP+rpFKzWlr+?=
 =?us-ascii?Q?zRl5Zjf1lGq+B4mR7Mw4O69nqQFKmM2h0srih31RGpaaj9KzSw8yaJI7fRbC?=
 =?us-ascii?Q?GsCyLelnjrdbsPlGip1f8qbUZokZNTxUOyugAd+mwacPIkLELaj4JoR0/4t2?=
 =?us-ascii?Q?4L0nYPu4K+cbdIgWohafg1m4tg0Y/MjQ7TfIvga19+x3Jcw1kLXvTtufFeKh?=
 =?us-ascii?Q?P9/VPftUAFJa+LT/vCsDsrtbqFB0U4vC94qsi8mAG6g87R5tfcAASMzPF1yl?=
 =?us-ascii?Q?EBm36XVFL4sa1L+l8cwMstnQuz8Q+F+trNjXKBrsiOjjIUjf5/8kUST9HKj/?=
 =?us-ascii?Q?VKaw8qc7NptTsMQu6CclFDnKpkTHRxT4z9gpwNeILRVz6AWkOc+MC1SOEZKn?=
 =?us-ascii?Q?f9C14yhvWzDYRqkFtgDPb1U+D7iVMIjpskle3g/3Tj0xgd3bttmQSxfR/aFv?=
 =?us-ascii?Q?cF/vc2/kkHopEdYq3dTD3lsTuARnWvDVJ494GqPEIBFX6dnCY9zZQsgDS+sS?=
 =?us-ascii?Q?Y681CiVQ8sXUBX35AlgF/JdTwdJQ+AkaYtj63ipLh4D3tyfaHgZa13XWp9u2?=
 =?us-ascii?Q?5QImb9qlJdZ+DXzlinDQa2oa51/OVRWdWT9JpOInySdMdGDDL9GvgulQTHpl?=
 =?us-ascii?Q?EVgzxMBv1ScKllJXjXa8yef1uDcLqFzrIJ5aGYdljB30HouUTgEnH84LFsls?=
 =?us-ascii?Q?wLUFev4Lg9s3edWH1vwpisjhhbS1IxqWJ8o5KTCX28EPTfVnHKPzObl3PwyF?=
 =?us-ascii?Q?KWQCH5rULDgAENf4ZdC1R37uE4np35LF8G1aOyARGULwzfcTMymuanCDl6Qk?=
 =?us-ascii?Q?CIOM7w/63JDUH2ZCfyJIOS5twhbm6U5Fra7hZoBBrICHHSWi8b3FiQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?su+yt/rxrOUnQ45l9fwb6WawOJtofXMyok0KHqGiXnlxXLsyFSx3YOO55aSm?=
 =?us-ascii?Q?y+/uJ2JXVaJr4owiscT85ozQyHlDZ2kw8mZ2rgTMtzmdu+cBqE7hneoYn9BH?=
 =?us-ascii?Q?hveGgKRG/YO0q9CiZOc44k6TtA4FqLyp9Q/iGZj3mkxoZT7PTjQgO8BGs4SU?=
 =?us-ascii?Q?nM434GcttKMvg9Ez/5pGAO7WFuYKbKfpIFcJ6x7ByjYFk+GSHlHqGjzEKL/1?=
 =?us-ascii?Q?7TwjCuCFmIlLret/pMdv+WSLAkaCDwJ13s+AiDbwO9EdAPuy00Q7Cqm6WnOp?=
 =?us-ascii?Q?eZzoId3hgR8X5t/8v+AXywFgyxc69i6Tlfpa6yLDEDDGdRA1nUVAhFf+Ec3E?=
 =?us-ascii?Q?ti0aJ8N2NgGHiw1hMTQrXb0e8AcNYfmuWNWij8j0j2A7cTVOoVfxf60pgWCJ?=
 =?us-ascii?Q?MuC15Tqc3XF2YVsyhjXgE/Nfateu1HelzUVIfyxyl/3EfkiVYSUwlaMbdBey?=
 =?us-ascii?Q?cfws31aDbgjHSGEjezsJhbP7IyMri/7+D21pERtgdUhF8FfKIoSWA8C0zjLE?=
 =?us-ascii?Q?4Z5P0HJC7IY6OjH8KcSo7UOCPxxjsEGHIp9fyjWpDWz8Kd3v8BdDlU9rffTX?=
 =?us-ascii?Q?2r10EzXmNnF2C6ccPJGXDyrijGZXjKrVMgU82uRoIPE2l944Opp2LtLwWbt8?=
 =?us-ascii?Q?XG8RqU8xVCKmOs54210P4woRfoVyv3qb1mdvcrQ8nuIv0igpbwmKOJCa9tZ5?=
 =?us-ascii?Q?GadP9iG8B5Rpr8e0KfkH8/aOnAK+/Sf+viOVa3BDRHdCrMzL834sNKh/D5HG?=
 =?us-ascii?Q?BnlD4l6BZUCil5TklRLl0xlRqqEXLcFaoqdejAbBLi+xg2No9jUKNvFexxKT?=
 =?us-ascii?Q?iVu5ofeqB5YIQIj4ooKzH0Up9PoyD7MwppMnJ2w1H4Mt4s7XtMvscG5VvK6o?=
 =?us-ascii?Q?uO/uKIGH1mGOOu1yP/Hq6cImnEjcfUqOn34eBrTMI9UcAVfvknHX43xcSSms?=
 =?us-ascii?Q?5cPn3RO6XRzKKQGgjd3RkoSI/okACQcnulOjYswn7IQzFWbhcLOx5iKK6Og1?=
 =?us-ascii?Q?hLWky5Xq8tHW67h0eBSQSKA5ALCvcgUq9QGq/pagemnYEjetM96s5+Ke08dC?=
 =?us-ascii?Q?tIrg1XPNdl6FngR1EosUZroUPbqovyOdgMVj5+3rSBN44zmAK+ANWwAIk5TS?=
 =?us-ascii?Q?/HEymJexOMRVU+HzyO5JHxxFNrSj3MT8yJ3jhe/AvCsUWlnPg9lfhi/ylLhH?=
 =?us-ascii?Q?0SH3Fm+Al6AvLmFP/uGyKi2dhohOxFOFeo+SCkdnxYbdeJt648rbc4Lf4PLA?=
 =?us-ascii?Q?B2jaA+ShqVpByu/5s9B1PwckZDVeHp5HtvDh6QPnx4sJ6aVAC6xp4nLprmBk?=
 =?us-ascii?Q?2k6n0vf4ct7Eh9Z0cqAHPOKJHHMWmhbc/hJ9JZpDmPywDDD87ffa5PplBpPS?=
 =?us-ascii?Q?k7s76E6g+nV9F7SrFLPc1NqYb6PEkP5OGe0HfWPqzrFTThRgIqTXYFvicpyX?=
 =?us-ascii?Q?qYI+/IleIU0EBloIk9Lchmnjb4DoVr5J0zrYuva8tnrSSeVg7F/wTTfrR0tU?=
 =?us-ascii?Q?KrucSdCMmJe/FxdQiqwWBQfnPbQoEyB2TNkoCZ7SHHBlEwwLDa7piqmP3Rq8?=
 =?us-ascii?Q?vliAXdbX90th2+OU8TJY42zMBl1H5Souw6MnQBttbIpdniAwsnqrGNleNhwF?=
 =?us-ascii?Q?5A=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee22b09f-8f2c-483e-83c5-08dd882c1cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 21:15:19.6922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4FBFr2jLO3JQ3HT5VaxZejIKQp7TdyAWCBVx3JdIwVehpB4y6FeZAspVpfhLx2QQGplN++eJVQqNuNqO+H+GNeW8XJdk2408h35wW0wUwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, March 6, 2025 12:01 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v8 13/14] mm: zswap: Allocate pool batching resources=
 if
> the compressor supports batching.
>=20
> On Mon, Mar 03, 2025 at 12:47:23AM -0800, Kanchana P Sridhar wrote:
> > This patch adds support for the per-CPU acomp_ctx to track multiple
> > compression/decompression requests and multiple compression destination
> > buffers. The zswap_cpu_comp_prepare() CPU onlining code will get the
> > maximum batch-size the compressor supports. If so, it will allocate the
> > necessary batching resources.
> >
> > However, zswap does not use more than one request yet. Follow-up
> patches
> > will actually utilize the multiple acomp_ctx requests/buffers for batch
> > compression/decompression of multiple pages.
> >
> > The newly added ZSWAP_MAX_BATCH_SIZE limits the amount of extra
> memory used
> > for batching. There is a small extra memory overhead of allocating the
> > "reqs" and "buffers" arrays for compressors that do not support batchin=
g.
>=20
> That's two pointers per-CPU (i.e. 16 bytes on x86_64), right? Please
> call that out in the commit log.

Yes, this is done.

Thanks,
Kanchana

>=20
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 99 +++++++++++++++++++++++++++++++++++++-------------
> ----
> >  1 file changed, 69 insertions(+), 30 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index cff96df1df8b..fae59d6d5147 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -78,6 +78,16 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/*
> > + * For compression batching of large folios:
> > + * Maximum number of acomp compress requests that will be processed
> > + * in a batch, iff the zswap compressor supports batching.
> > + * This limit exists because we preallocate enough requests and buffer=
s
> > + * in the per-cpu acomp_ctx accordingly. Hence, a higher limit means
> higher
> > + * memory usage.
> > + */
>=20
> That's too verbose. Let's do something like:
>=20
> /* Limit the batch size to limit per-CPU memory usage for reqs and buffer=
s */
> #define ZSWAP_MAX_BATCH_SIZE 8U

Addressed in v9.

>=20
> > +#define ZSWAP_MAX_BATCH_SIZE 8U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -143,8 +153,8 @@ bool zswap_never_enabled(void)
> >
> >  struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> > -	struct acomp_req *req;
> > -	u8 *buffer;
> > +	struct acomp_req **reqs;
> > +	u8 **buffers;
> >  	u8 nr_reqs;
> >  	struct crypto_wait wait;
> >  	struct mutex mutex;
> > @@ -251,13 +261,22 @@ static void __zswap_pool_empty(struct
> percpu_ref *ref);
> >  static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> >  {
> >  	if (!IS_ERR_OR_NULL(acomp_ctx) && acomp_ctx->nr_reqs) {
> > +		u8 i;
> > +
> > +		if (acomp_ctx->reqs) {
> > +			for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +				if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
>=20
> Hmm I just realized we check IS_ERR_OR_NULL() here for the requests, but
> only a NULL check in zswap_cpu_comp_prepare(). We also check
> IS_ERR_OR_NULL here for acomp, but only IS_ERR() in
> zswap_cpu_comp_prepare().
>=20
> This doesn't make sense. Would you be able to include a patch before
> this one to make these consistent? I can also send a follow up patch.

No worries, I have included this as patch 16 in the v9 series.

>=20
> > +					acomp_request_free(acomp_ctx-
> >reqs[i]);
>=20
> Please add braces for the for loop here for readability, since the body
> has more than one line, even if it's technically not required.

Done.

>=20
> > +			kfree(acomp_ctx->reqs);
> > +			acomp_ctx->reqs =3D NULL;
> > +		}
> >
> > -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > -			acomp_request_free(acomp_ctx->req);
> > -		acomp_ctx->req =3D NULL;
> > -
> > -		kfree(acomp_ctx->buffer);
> > -		acomp_ctx->buffer =3D NULL;
> > +		if (acomp_ctx->buffers) {
> > +			for (i =3D 0; i < acomp_ctx->nr_reqs; ++i)
> > +				kfree(acomp_ctx->buffers[i]);
> > +			kfree(acomp_ctx->buffers);
> > +			acomp_ctx->buffers =3D NULL;
> > +		}
> >
> >  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  			crypto_free_acomp(acomp_ctx->acomp);
> > @@ -271,6 +290,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> >  	int ret =3D -ENOMEM;
> > +	u8 i;
> >
> >  	/*
> >  	 * Just to be even more fail-safe against changes in assumptions
> and/or
> > @@ -292,22 +312,41 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  		goto fail;
> >  	}
> >
> > -	acomp_ctx->nr_reqs =3D 1;
> > +	acomp_ctx->nr_reqs =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +				 crypto_acomp_batch_size(acomp_ctx-
> >acomp));
> >
> > -	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > -	if (!acomp_ctx->req) {
> > -		pr_err("could not alloc crypto acomp_request %s\n",
> > -		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> > +	acomp_ctx->reqs =3D kcalloc_node(acomp_ctx->nr_reqs, sizeof(struct
> acomp_req *),
> > +				       GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->reqs)
> >  		goto fail;
> > +
> > +	for (i =3D 0; i < acomp_ctx->nr_reqs; ++i) {
> > +		acomp_ctx->reqs[i] =3D acomp_request_alloc(acomp_ctx-
> >acomp);
> > +		if (!acomp_ctx->reqs[i]) {
> > +			pr_err("could not alloc crypto acomp_request
> reqs[%d] %s\n",
> > +				i, pool->tfm_name);
> > +			goto fail;
> > +		}
> >  	}
> >
> > -	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!acomp_ctx->buffer) {
> > -		ret =3D -ENOMEM;
> > +	acomp_ctx->buffers =3D kcalloc_node(acomp_ctx->nr_reqs, sizeof(u8
> *),
> > +					  GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffers)
> >  		goto fail;
> > +
> > +	for (i =3D 0; i < acomp_ctx->nr_reqs; ++i) {
> > +		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2,
> GFP_KERNEL,
> > +						     cpu_to_node(cpu));
> > +		if (!acomp_ctx->buffers[i])
> > +			goto fail;
> >  	}
> >
> > +	/*
> > +	 * The crypto_wait is used only in fully synchronous, i.e., with scom=
p
> > +	 * or non-poll mode of acomp, hence there is only one "wait" per
> > +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> > +	 * there is at least 1 request per acomp_ctx.
> > +	 */
>=20
> I am not sure I understand. Does this say that we assume that scomp or
> non-poll acomp will never use batching so having a single "wait" is
> fine?
>=20
> If so, this needs to be enforced at runtime or at least have a warning,
> and not just mentioned in a comment, in case batching support is ever
> added for these. Please clarify.

This was pertaining to the request chaining batching implementation and
is no longer relevant. I have deleted this comment in v9, in which
crypto_acomp_batch_[de]compress() do not take a "struct crypto_wait"
parameter.

>=20
> We should also probably merge the comments above crypto_init_wait() and
> acomp_request_set_callback() now.

Done, and clarified the use of the single "wait" in zswap calls to
crypto_acomp_[de]compress().

Thanks,
Kanchana

>=20
> >  	crypto_init_wait(&acomp_ctx->wait);
> >
> >  	/*
