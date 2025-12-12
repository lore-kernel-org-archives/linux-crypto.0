Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC8D1E86E;
	Fri, 12 Dec 2025 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765562590; cv=fail; b=oYoKN8dmLmqf+nlCLkQoS2lGAvzVoY88caOfe0ssnQ4e+Uxq/B5q3tlWZi/QhXtaIS2+AcDFmomzK6TYTrz//WUHQU2P+R5c4/DMRNNd7p1srGhFISzblsxsvOI2vxnN+vIr6GK/oGlWf2+h3j60GMrdEUOzLXrh1fWoH8we6tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765562590; c=relaxed/simple;
	bh=1R9IIjusy8Q7B+W9S12Ct1dGPZ1UQpQAlhz2YAJOldE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oFZ2qfVhznggQYoeGc3ogiThlLpAwEnWg/5PBrVu3OI4XjiqgB3p8OHYDbL9xNgrIh0bddgiKA4/8qHdo8DvqZvhlhV68dw9d27TEdaJ5p4fZHPhaBF/V/x8zGJtkKD+8VNwwFVEcSwUJCPbRJfan03d3L4NMOhnC6MrzSMIX3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhlpmSrh; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhlpmSrh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765562589; x=1797098589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1R9IIjusy8Q7B+W9S12Ct1dGPZ1UQpQAlhz2YAJOldE=;
  b=UhlpmSrhcYid7Da6zfTa791C4rzuLD1ThTO4UZWltTgyUJ+6Kss1XVjl
   lA5RUo+SNt55Z9Q7mXs/rRfUJvFY3+uvQJfBhM/otzzZ/5V4G1vP2+cqT
   xd/IOj2YsbCkVRXKK8GEjYQmQJ/I5hjvLxzgSEFDIMuxT43vqT74tZ03o
   u+KoKN0f/5IXI31D26MyUy/pnyUF7JhCuKJUYFquWtEkOmWllCmNgO7rB
   IdN8Lfr0DbITqc2sxhZgI0Vp0RoWVAb7YCUrD8OR1HA0rtHzwD9jpKjh3
   eCeaVMYK/ZRvgpBsrUBZhTGJ3rrxTQHYB0iNYAhC9KCpzNPUkCydIHrJy
   Q==;
X-CSE-ConnectionGUID: nRbz4+sdSpKIJ47zYos/cg==
X-CSE-MsgGUID: pwlLfexOQ+WMuw/Uf9ZYxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="90221771"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="90221771"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:03:08 -0800
X-CSE-ConnectionGUID: EjxlTsqCSyiqRy+sJMZ7yQ==
X-CSE-MsgGUID: hd1pcm4wRfu/TnZjAeNhoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="202233365"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:03:08 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:03:07 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 12 Dec 2025 10:03:07 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:03:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMO4FfOtVghAZs6NBF5l3RehzfBS6fB8TkMGbZNxtZw6IGXRAYXTXHE+eITQDVfa7KizO7U5gzw0bg+GOoSZAORyBlLPQl7t9NtHOeWaRVLm18sCQpG5PyEygX2kJEpnwF1sZkwaLKlbW1h60wXcaZjJk+LBCfceHYg+cb6lti4+tLz8YU4lC+T+1/uOaPQwSqP8GBdgM7qyNYSkaKWCpdenS6eRl+nZITGWn2YEbYWo6twWAjJ7J/I3bD3GLSrtuiSnmYgV3Bpe8BdBwxCwfmrWpW09u0/B4RTazJQx3ex3pGEnAEmlnLmNMQNXpvaPgIs/A+XZ2aRI6bathqv69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qjUk8joeli+U+Hf6ZydaPsUm++uKgydk6f4GgF6nkE=;
 b=LA8IjMSM6t3UWuT8oNEEWS7/0YeF0XNKpz4puwBWG10b+rgJfT7Objs4MqQyKlUE/ZkC0wHU2iHto5h5Ir/S2+wKFoy1M0rRv1IpxHNGp9TXxTjxvW3/hPG52355slPhOPodNt5VWaDxXMP9ZBrNQlTNiLqlwTZzyLAVUzgDNRzLgHc93zTYdGCe5tjQ3y2einOaRwOQMyHHwfejI35pE7XzJ7taQf9cFpN1NQqJIefAJ+lQ52IVg7E8L/xmvkI/90CUsoNyurhqJbAvySGbCedZ0TwDMt0g2IWjzTI8OYBlGXHAEA83z6fX0ptg5FSvEfEBjpdqFdhSLxO3XmL/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Fri, 12 Dec
 2025 18:03:03 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 18:03:03 +0000
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
Subject: RE: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcTWsxfEPA0eGp6kWYA/H17miOhLTxI7AAgCxKBKCAADpygIAA3mcA
Date: Fri, 12 Dec 2025 18:03:03 +0000
Message-ID: <SJ2PR11MB84728FA0B92A86B7D1C92AD8C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
 <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
In-Reply-To: <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SJ0PR11MB4911:EE_
x-ms-office365-filtering-correlation-id: 3ba2b43c-6728-49b5-4b04-08de39a8b204
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?moYEczGGmvwaaakKkQlHzkRKEH8Kb+ivbTNel348BVi5v5h9zgD4OdWzE26l?=
 =?us-ascii?Q?n+a/H5nWTU4Ll+nxZt2VKtqXJ5vVaYrSdt665vQVC73jwcPertKVzla1+vhO?=
 =?us-ascii?Q?In3D2+RPZumafzjVLdi0CXSVkdRVsnnK0c3IDlZgJuD/i/A4XaJEUVNhDWTz?=
 =?us-ascii?Q?SsdIGUhdYQAlH54n5p/2ykJO5NRCTcDUnR8sP+BiO29MW7FdYsPB0sjRzpLd?=
 =?us-ascii?Q?+mHdHF+FLtifS/SoxP4B07fFAasb5B1jRo98PRZbcfw7ij+4ssgc9i5K703V?=
 =?us-ascii?Q?ay2x1CPK5tKryToGS83+av0WGTteXcH4zpwKSjddHFG1+rUbQQxmnvSnbG0B?=
 =?us-ascii?Q?5D99c/TuDEhPOQfkQhXRsHrwqLz0vkT+/a/N5jbOhaIz6aP5K/Ug0Sskbk6/?=
 =?us-ascii?Q?zYgdafIRpHTwP0ZLjj2Ud7ceCIbH3yvj/P0ipM5lsQIq0jqO9eSXQ9Wi9Kd6?=
 =?us-ascii?Q?MWjEkPhcyVwjHuZX35b/RbprktdLQRcls/JVOz03L7Cr8rTNTLSDjIHkZ5JY?=
 =?us-ascii?Q?WeKJiL3nUrRWSi7TZrgg6/2LYIpPGdMijatuI28+yoCpVqjJRT7QjdZFvHuS?=
 =?us-ascii?Q?Oo69dQM+BZcI1xLLIYNhC6LaF1+iw3EOu20DQjd8/bYUoYsuG/PfnZHfkxTV?=
 =?us-ascii?Q?y/uyAhAEz4bB4WNo9oRh3+gBrMa59u9Xl9DYmB8vQtFAFJA1ZMGgfnkc4NGA?=
 =?us-ascii?Q?CKIzjTcUPmXubQnnkuJUV6Fm1kf0vhyFnymMILwvIfu019/Z0hKjlv08+mO7?=
 =?us-ascii?Q?h8OkvsPaEAwU50LpXQS6djGv98u9/U1bTO6466sOtIbCrURgmRCVwmv6WeHe?=
 =?us-ascii?Q?eNa0yDhGxW91hweTsoPVfsJ2CKYthyxdqvbeq6NsSURrFCiN74bC3x9GDfrU?=
 =?us-ascii?Q?qnyDPjq2xy916mFvNVrJPd29mWyN5GvprQiOWIMt6rBA7MUPUtBXP0NJmKrM?=
 =?us-ascii?Q?5n69wBO9PT/9MQjL9vm5hV4k7BeTzioEQD9i4y/mWGC6aPUdfimERmzTTLH+?=
 =?us-ascii?Q?XKBWERXohVyYkPSMj3wZH3RxcNARJS5PcHiEWiiNR/Ea0LVBx2QzeApedpI0?=
 =?us-ascii?Q?w156G8FfMknZaBIbUsbTOnRy9P4IyncAMpCGfzgmhnvFNlAN6kW0AwLGPwA8?=
 =?us-ascii?Q?iPU2DCq6XAyVc5MWgQ8Pvb7+f/+awB2tWFT4pK+VLWxOYLBGeup/oFZ4TzrM?=
 =?us-ascii?Q?BczqWuOtWb32S7eGH1CLXTND+iVVmQhmH7NapgkAlVcF26uDf2nHMTQe3Qgx?=
 =?us-ascii?Q?H+skpXFNo6IHE5XXOYHyCPKcDRxlsDEMFgtKI2irkIw6kBjZgJxoAT9H/sob?=
 =?us-ascii?Q?CluQNHVifCLwGoOyWQQfwlHl1tVG53SDawflabPzwA6sFRmgC26ab3PTsXVW?=
 =?us-ascii?Q?IyhTijScn5/fQz8e1NX5qLh1VvmM992WYxS7zYzYuWovufKr8A8GlYQcYZaB?=
 =?us-ascii?Q?Zh+zdB4lQk/XGvcnDqcdkrR0loRxFPM3EuVDRE1Gd4pVDNmifaIF/YhtHL3h?=
 =?us-ascii?Q?7E5FCufP/htASy1b7N/UR03LRZhy4VMTCCp2?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WK/j/CP6HIliCki8EgQcXI98ZDvkeKz0xyy8lhA0jPiboCl1mbIMM3T74AkW?=
 =?us-ascii?Q?bPrD3V2q0LgoG7T46StugwKmp0BA30Gg+BWyCn6296j1LLtp8FE5RZbh4q4N?=
 =?us-ascii?Q?mVvrFZcx+VYSqhocTUAdrQlhhXCJsaVvV3W8AXolfjIXvkmDQEPbk9xhnEdV?=
 =?us-ascii?Q?/67yROrSGgQKf22iSc07DRq0Hud5yF9lLofOFv49cmBw22xUgFuZShz4T//R?=
 =?us-ascii?Q?pclIRA/WnU04dK3TMZk8CUrl2EK8NkmDVU089wAbJKRp+rlYfgYtoRrNXSnR?=
 =?us-ascii?Q?r5GxTf+q7o5Fd4cZnxzB/EWLBkAwivPTD5fQGkdjli69ZoPy37qHb6VsnT6I?=
 =?us-ascii?Q?uMud9AIAWYH8FredCPjCf7eT1F5fr1fPuxACVegMxg9J8UA/XDNCtzB4++/a?=
 =?us-ascii?Q?Yhv4LYjrfAzfWIvSwiojdLcvsXWWVWu6QPJ+B/UJjSRKUZLnWksTl78UXHW4?=
 =?us-ascii?Q?IVI4X+V9dtR+SAZztf3WV0yZ58uzO01sQCqNG2yA0ILkXC3/InLh0CK/yjYs?=
 =?us-ascii?Q?hLJ8rc7+hqJEH8c9mnYbMuF+rOabCSWmZwNBAnnKg0Pkdie8BPTS7Mgw4Wxk?=
 =?us-ascii?Q?RKfyqZokeT8yqWouLc3d4cxQUVgFmtxY5avVDow+Daqe131u78HfAG5pNqkK?=
 =?us-ascii?Q?q3KXMbFrq+uCHNc4RPEfoJhQKeBuhP3bFsKZYDX2sRrs6oOHlqe/4nziGrAX?=
 =?us-ascii?Q?ptaPbiFiAFu02pAT9ztftqzjeO2qZIuvCu718c6HCsLwd7rtAjCRkIG98fWZ?=
 =?us-ascii?Q?yrc3VrgoMrqG9rC4QuoMV+se0vgnqpgjLnRCa6hBeGBymJ/+XFrLTN3Mio3p?=
 =?us-ascii?Q?sSVS8pQWX+GEPv6oIBCqjjmj/oAgWobaSAdhdH8vvIBXrKsTR68OFGu93KrE?=
 =?us-ascii?Q?K9CmhRMUNmCmYSs6giixiyVf9yilDlcmsz0NCg52U6zNpIzBZrY5Z40iPlxq?=
 =?us-ascii?Q?4rXw0R7IHJ54bEvUPadLkP6oGT81/IBPBGb/rjn1PmdsrZk/UxvQa017QZLt?=
 =?us-ascii?Q?um1+m15QGJ+SrcZXEJG02ei+3KxhK7prff/5rdmOMxbVmQImapmmIL8cQxni?=
 =?us-ascii?Q?fb/egxXJ6H89J14MtFonF9VGglmQvNQCZRNV9+NjfjCtUpPOWnoyo5rdiTos?=
 =?us-ascii?Q?kj6bz25djjcLxsulU8H8RFCIqsquBgRpnhM2VPJHw6rRpeU6pHeYTFm4WUNf?=
 =?us-ascii?Q?H4Vd0NH0N71zRrMVEG/Z1ayM49mO/xQ5SPPnQMMhW9i5Mmy40sB8kdl8PHNo?=
 =?us-ascii?Q?vS0aoeEtkKWDuyxAp9shaRdrv2JjJ4B4MeD83PDA7h6vTNtjdoLeswBow/f9?=
 =?us-ascii?Q?9t4c6d7TOQVzGeePyeoqgFLHu0tX7eYA5ivxQBbByiU+fbZpdPNT7o/pnYWy?=
 =?us-ascii?Q?9B+I3L30FhpvmGtV4C5fszJLXxKotqT0DMrzOk0ecUTf3+nW7UqP2Bqig5un?=
 =?us-ascii?Q?WCPKV8USOx5MgnxPU7GHZ2aIFWTj05t+QMBNBjanpiA7xwWVLTEETUKoWFqe?=
 =?us-ascii?Q?7afscshvspS1jS1sZvrBbhco2VIR/cxWb4z2+DEirpNgD9EPmvTVW5frYDt0?=
 =?us-ascii?Q?YTL/5ZgJ8Ei5OGK3hF7fY12CncTIVudDSqZjLj7wqj5mbDj5GkliGcCUm5Hq?=
 =?us-ascii?Q?VrX1p+cQdrTItsm49JUlHgcJer2F2jRM10km+79nT800Zr9rsTwZnm8BiOKm?=
 =?us-ascii?Q?OGK5bg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba2b43c-6728-49b5-4b04-08de39a8b204
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 18:03:03.6954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dERzU1StpJnj5XygeaD2ytvZR2VlhggvslJ9QhkXeV+mey+MpTtTCJB2e61w2sakXDHj0nQgT15iQK0zeTt/F/hckC6JJR/ssU9g0OwFBeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, December 11, 2025 8:41 PM
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
> Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
> On Fri, Dec 12, 2025 at 01:43:54AM +0000, Sridhar, Kanchana P wrote:
> [..]
> > >
> > > Instead of this:
> > >
> > > > +/*
> > > > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive numb=
er
> > > otherwise.
> > > > + * The code for __kmem_cache_alloc_bulk() indicates that this posi=
tive
> > > number
> > > > + * will be the @size requested, i.e., @nr_entries.
> > > > + */
> > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > **entries,
> > > > +							   unsigned int
> > > nr_entries,
> > > > +							   gfp_t gfp)
> > > > +{
> > > > +	int nr_alloc =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > > > +					     nr_entries, entries);
> > > > +
> > >
> > > Add this here:
> > > 	/*
> > > 	 * kmem_cache_alloc_bulk() should return nr_entries on success
> > > 	 * and 0 on failure.
> > > 	 */
> > >
> >
> > Sure.
> >
> > > > +	WARN_ON(!nr_alloc || (nr_alloc !=3D nr_entries));
> > >
> > > WARN_ON_ONCE() is sufficient, and why do we WARN if
> > > kmem_cache_alloc_bulk() fails? I thought that was expected in some
> > > cases.
> >
> > I can change this to a WARN_ON_ONCE(). The code for
> kmem_cache_alloc_bulk()
> > makes sure that either all entries are allocated, or none are allocated
> > (partial allocations are freed and 0 returned in case of the latter). I=
t can be
> expected
> > to fail based on this.
>=20
> Right, I mean specifically the !nr_alloc case. This should be expected,
> so we should not WARN in this case, right? IIUC, we should do:
>=20
> 	WARN_ON_ONCE(nr_alloc && nr_alloc !=3D nr_entries)

Sure, I could add this, but it would be for potential future changes in
kmem_cache_alloc_bulk() since at present, if a non-0 nr_alloc is returned,
it is the nr_entries.

>=20
> >
> > I believe there was an earlier comment for which I added the WARN_ON? I
> can
> > either change this to WARN_ON_ONCE() or drop the WARN_ON_ONCE(),
> since
> > we anyway have a fallback mechanism.
> >
> > >
> > > > +
> > > > +	return nr_alloc;
> > > > +}
> > > > +
> > >
> [..]
> > > > +static bool zswap_store_pages(struct folio *folio,
> > > > +			      long start,
> > > > +			      long end,
> > > > +			      struct obj_cgroup *objcg,
> > > > +			      struct zswap_pool *pool,
> > > > +			      int nid,
> > > > +			      bool wb_enabled)
> > > >  {
> > > > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > > > -	struct zswap_entry *entry, *old;
> > > > -
> > > > -	/* allocate entry */
> > > > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > > -	if (!entry) {
> > > > -		zswap_reject_kmemcache_fail++;
> > > > -		return false;
> > > > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > > > +	u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> > > > +
> > > > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > > > +
> > > > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0=
],
> > >
> > > Is this equivalent to just passing in 'entries'?
> >
> > It is, however, I wanted to keep this equivalent to the failure case ca=
ll to
> > zswap_entries_cache_free_batch(), that passes in the address of the
> > batch index that failed xarray store.
>=20
> I understand, but I think it's clearer to pass 'entries'. Also, can we
> make zswap_entries_cache_alloc_batch() take in the proper type and avoid
> the cast at the callsites?

Sure.

>=20
> >
> > >
> > > > +						      nr_pages, GFP_KERNEL)))
> > > {
> > > > +		for (i =3D 0; i < nr_pages; ++i) {
> > > > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> > > nid);
> > > > +
> > > > +			if (unlikely(!entries[i])) {
> > > > +				zswap_reject_kmemcache_fail++;
> > > > +				/*
> > > > +				 * While handling this error, we only need to
> > > > +				 * call zswap_entries_cache_free_batch() for
> > > > +				 * entries[0 .. @i-1].
> > > > +				 */
> > > > +				nr_pages =3D i;
> > > > +				goto store_pages_failed;
> > > > +			}
> > > > +		}
> > >
> > >
> > > Maybe move the fallback loop into zswap_entries_cache_alloc_batch()?
> >
> > I could, however, I would need to modify the API to return the error in=
dex
> "i",
> > so that the "goto store_pages_failed" works. Imo, inlining this makes t=
he
> error
> > handling more apparent, but let me know.
>=20
> Hmm yeah. Maybe make zswap_entries_cache_alloc_batch() free the already
> allocated entries on failure? Then if zswap_entries_cache_alloc_batch()
> fails we exit without goto store_pages_failed. This is the first failure
> mode so we don't need any further cleanup anyway.

Sure, this can be done.

Thanks,
Kanchana
