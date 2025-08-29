Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67723431FF;
	Fri, 29 Aug 2025 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756492783; cv=fail; b=Pd3c3xvYomfk2wkCPITRzSrd6WPz3YgdNz9LM2INz16YAh+rq9/IPHZDC/PfV6MYIzTeEJylZEwE+LjJ60JMDnpp1Ra89ga2ML/kUEEI2O3kBPUDF1Hb/wsdA0I4af8VAjyG0RWhu8gSE/4kFIg+4x84lPZf9kmRxfHRISwIoBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756492783; c=relaxed/simple;
	bh=cETdYrX2IXFKFnceJ9xjDyamzXwbq5FR6ZGeaIcowf4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qQ279ekWFrdOaUvDHAWqBjeHJJAlUlDFznMmKg9r32DqjEdWHm68Ui/DoYAsVQzrES8fUfAyxSNuN1PbHPW1OIp4s1+lUDR5Wt0uWD3yGU/aV76mNyjISwzdKpJWCrpvWtpQd+LbZE32Y9CCSCN1fOQ7Aw4/ylcca+q+AOHZhI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPkpoH9D; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPkpoH9D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756492782; x=1788028782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cETdYrX2IXFKFnceJ9xjDyamzXwbq5FR6ZGeaIcowf4=;
  b=VPkpoH9DAXQBNmpUGxhcyCDD8AZSQSgp5Vn/bq3tIaYQ7yALcqP8fYuo
   vy8bQ0AUxN2FrcHREVGVNeoOIad+qUK8qwGzLOQt8qnj/TV8LYrBkR6ct
   CdtHkwQVMklkKEfhxocRU/THJSApH70oCCLx2oXqB+3v9iDOU/RCUEZcl
   6m4YiBDuHIRJwgwn+HABhmOw+Zb1jmFqhpmNnceYeG5sYF7g19GjwN9YU
   iyYG+tLvqWzytulxYbagtH2Mbd/NjnTUvKC9v3e8p6jDUHTcu/ldt3Els
   +O1WCxgokRd/J3VmWJnJZzJWRLwoTE4SRgwyCIzcbOxsC4kxnSlOsHnmN
   g==;
X-CSE-ConnectionGUID: o4EasHTpQYqo2hr3wThpbg==
X-CSE-MsgGUID: a28FOoA/S8WsKsdVvHJXuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="62605749"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62605749"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:39:41 -0700
X-CSE-ConnectionGUID: mIoKXXcqRsCfSw3akWIUxw==
X-CSE-MsgGUID: YvqNFbzBQj6jwiTnwqG62Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169745641"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:39:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:39:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 11:39:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.79) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:39:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYDimmn8jIueOXj/zJC0XEGUEIKu0/q5Y1JYLi1upopqFJc1lnVDg832iCfzdiTbIEvw02USs8Nn7mxYFYHGLv7owebwy2b9PKQm1B1wNUqKLiJX6N4HPAA9G/SSkpn89IDHlKL0UOmB+e4KaL2T1pcwcmZRQBn3tKs2n8h/8O59G8+N6FGKC5Z/AWP+Cvj9JVR8G0eYTed2Q1q5bTYWQ/mHzY/I36IKn3iyI6BARR/455deS5LxVpGqfIEqjGrsiMod70xi8i8/Hb/tl62+GsROuy7RlhljEpJToNh5h3WICV6WWaJNi9laOOyLur84QjUSM17ATDmwDFNw0GXA5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cETdYrX2IXFKFnceJ9xjDyamzXwbq5FR6ZGeaIcowf4=;
 b=NnjIc46BUo09OJASfjliajitKnYhJb5jYKQDfaYaeZ5/AVEB3mIdVtPkyQMythL6J6FjRDe9sUgFYXV0OrrL1HEBLvpPX/IyKJk5e97/Lx/0kPtXHB/oJ69gqBIhgZhl0lGFC9JwsxWyVAYGsLALds0TKB6Mq4gBezwCihOJ3xjEVUMZpeL0J9FATebgu/egXvfu0CxrSaAd58/lN/Kekl4CRI5mOW6B04nh8DcDfy1t44GaMJV0T+ZG1oyb0YH5Fs3HtPbDolJpXajKEqFe+0V57enT1Z4b3MQ7+r+vHvZpeN4ir1n12hLaevi4F0yuF1eQGf+VVCix432RC7MsoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH7PR11MB7607.namprd11.prod.outlook.com (2603:10b6:510:279::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.18; Fri, 29 Aug
 2025 18:39:30 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%4]) with mapi id 15.20.9073.021; Fri, 29 Aug 2025
 18:39:30 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVggAAI1wCAATLsYIADBCAAgAAKX0CAABQZgIAANf6QgAAQ4ACAAPJPwA==
Date: Fri, 29 Aug 2025 18:39:30 +0000
Message-ID: <SA3PR11MB81201972CB6D308FB4659E7DC93AA@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
 <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
 <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zMHtYG3rS61PyGfJYd8KwGEw=Gy=g5s5wT_vrEL9fhbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH7PR11MB7607:EE_
x-ms-office365-filtering-correlation-id: 1f764a38-3d22-430f-9fad-08dde72b63db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?QkJwN0VTamh0K0Z6U0ovMEt1MnRGTktoZ09yY0tEY0cwKzFjNlkrNmxsK1lj?=
 =?utf-8?B?ZDNhM0t1ZzkvTllOK011WTNaeTZGUDE0NVVnWUlDa1Z1RXdJOG5TN1ZVWjBN?=
 =?utf-8?B?U0E1blBXSHozOTgvc0Z4RkRPQVVhZ1V1OXBuRHNjdk40MmtVUCs5Y0Y0V0ww?=
 =?utf-8?B?SHh4TWREdHIwemdDSUNmUVY4bDJ1OUhKakx6YW9VZ1JUL0RNVENTREh4MGZs?=
 =?utf-8?B?dkd6QVo2OFViVGpoUW9Mc3l6dE5tWnY2Ui9vNnYzM1BQeDFqVWhZQVlLNno3?=
 =?utf-8?B?cXdPN0dzelNibThCSUh0cDFXSW9iazFiVnFTS0VqYlAvcHZLUExWMjdSemE5?=
 =?utf-8?B?UWRSNTFZNS8zb0UzcCtkT0F2RUxEN2pCaHhHMlphZVhwbStWeGFIUTJpRThu?=
 =?utf-8?B?SUNlQlpXVFVOOVlHZ2ZEbHFDNTQwL0VZVE9yV2JhaTNmQW9hSGZSSExzK2k0?=
 =?utf-8?B?ZGlVRXFqaDR3bmZ3ZUhuNTFxdW11NFNWa0Q3ckJRb3h5Z2FnTzIwUUR1TkVZ?=
 =?utf-8?B?SjBOUW85ejhaUEY0QngzMG83eHpDWlNHdUZ4OElRYlRLYTkzYno0U3lkc2VU?=
 =?utf-8?B?TUhpQXd4YTJxT0dyZ2lzNGJITXcva1YwTW9pRndJVTJyakx3MVhiZlg5L1Y2?=
 =?utf-8?B?cXNTVlIrOXFIa2tGajFEbnRqYkFhTy8vanc3TnNKSWQ5OTF3R3FFSC9ORmkw?=
 =?utf-8?B?WmwzMUI5Q3lNV1RaVnZWQ3JmSExpb0xLQWx4NDRMNlVmTkhWNFE5VWZyNVg0?=
 =?utf-8?B?UGJUTWR2SWtJUC9TTDYwWS9VbElsc1FVcXNvZUg0Y1cyV2dUdElhRGFONDAw?=
 =?utf-8?B?emVmZWZIVDFXUldSZSt3Smx2OFJobmx5MXo4UmhYVVlMWDBTRWh1R0FzWkt5?=
 =?utf-8?B?cnVuNU5iVEFYYWpjSDhkU09ibTZmaGM5NGdjdWpaZmd3SEJNcWEvU0JqMjIv?=
 =?utf-8?B?Z1JYN2V6MG1rZmFHYWJiMlV5TjY4NWRFZldSL2tjVUVpQkhIVHVVZjEyRjQ3?=
 =?utf-8?B?OExUM2xOVjBwU0JnSDcrM2l2d0w3Zi91SWRzb0FvUWtqcmlPVjJuRmszR2tB?=
 =?utf-8?B?M25qa3JhM255YURtWk9ncEZTSlJmUUhrV29uazRPbWplWlB2N2ROdVd4RDB3?=
 =?utf-8?B?UWtQOExhWHdBT2IvdWhvZFFKclQ4dzVQaFBWU204WFdZbGdCb3lEenJ6UllM?=
 =?utf-8?B?OFNsRlUxSUpQRkhpOWpiN3pmTjVwSFNWOUlUNjViSDRHNEtzSW55cVUyWmdE?=
 =?utf-8?B?dkw0WFZTZVNpbFpzeTdIWDFDc0JDMm42SWNTSk5qWmoxZ083NWpWaHhvOTZY?=
 =?utf-8?B?bmxWdTc3K0VGN2daNU5hd2ZHUFVTaWRYQWV0ZGNvL0FzSzF0MGtCT2RXdk1U?=
 =?utf-8?B?SUt4QkxhQWtvVExRYmo5SUpHNjRGN0FxUW9aL0x2aXIrVUI4NjloTWYzRnJi?=
 =?utf-8?B?V2h1M21nVm5LSnVDc3pPNHQ4bnR1U0FuT2FmbHBxdkJJTEgxVDV1RXcvSnFY?=
 =?utf-8?B?cWVvZ0tXc1UrWURXWk41QXZzanIwdC9JUFRoWFR6a2lzbHBpbWlsSm9nVU4r?=
 =?utf-8?B?MmlMcTNMRXkwSFBweEFKZ2F4TUlQTXV5WGtwdi9zOXZNdWp0YTlvQXFVdkVL?=
 =?utf-8?B?emFsVlAxOFlnUHd1VE94cG00Um9nblJoTEg2RGUvdjlFSVNqTWsrZWJ5VFNm?=
 =?utf-8?B?aE9jbCsyUDlDdWVZY3FtVXBhWWgybzJkRm9kNm9PU1RuL1FqSVQ5UXlaa2ZM?=
 =?utf-8?B?dHVGTkxDSExZWC9NRWhjM0lhNVhnYjJaZERCdzlWVDRxdnZOcllpRGJyV0tE?=
 =?utf-8?B?enpZKytzTjFlUWNFb042cTNEeTBhcjFBblB1cUxLLzlVRnFNK3htZkRjUUNP?=
 =?utf-8?B?WVZIOXU5NWFHOWwwN3pmN0RsZ0oyM0wweHowdEtWa2p1ck9iMlhPMFRWTStm?=
 =?utf-8?B?L09heURibjhCenhSYmsxNC9NTzhROW05ay9QN1NzN2xPQUhnL1IvODgvazhu?=
 =?utf-8?B?Y3lzN2FBT0pBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a243emJMcjZSckhqZ25XNXRzTVl3b0pUOW9wV2Y1bDZrTUc4Q3hwWlhicHYz?=
 =?utf-8?B?eTZiYzE1dkIzKzJkRkRBT0daSjlrU1prdVdhQUVmN1A4NVBLMkhCZld5MjBN?=
 =?utf-8?B?M05nc1p3eFVqMENoTmptUDczd1lhZW1iZnBIRVEwWFUyeFp5S043aWhLV05a?=
 =?utf-8?B?eTFsUkJxdlFMcWJPR0R0ZVZzR2tGWEhoUHFpbmNnZ1dpY2ZGOFZVb2FmNktm?=
 =?utf-8?B?Q2tlSng4SjRuMkQyMXBYKzh1dE1EM0xZdncybHViSjlnQk84bXE2Q1pxWHNr?=
 =?utf-8?B?cmZ3OXMvSUxVM2dsMjc3aFg0SktiV3ZSTWJoRWN2Q20zSVY1d1pUOXNaVi9z?=
 =?utf-8?B?cDcxUEU2a3RFVllTUUJPUWNBR0N1QlJ5ekt4SHpBcFljRGJWWXJ4c2M0Z0xj?=
 =?utf-8?B?M1B6bU5BNk4zY2pJOHdybW1tUG1kQThzMEtNN09pVnZzMXMzVlNnbUJuU1ll?=
 =?utf-8?B?ZmQ1dnlnWXNtQXc4U0JvTWR0YTZ1aHcvWWh6dmQwb1BhMTY1UVNKMFpZOGk5?=
 =?utf-8?B?azB3ajBSN0h0c3dzNS9NSnZvdGJjSDEzaUlxZ3Bmenh1Zjg4cVB1bWl1RFkz?=
 =?utf-8?B?Y2Y3SjBuRGpiamNaWUQydkZ2Tkk4eFExRnpNUlJLZ2dqSWkrd0R1bk5MbE1I?=
 =?utf-8?B?dzhld2x3b2F5dWdOZGxrNHhDaHo5bDFYbDZrY1dzaUw5WFFsMWlUd0hVMjFG?=
 =?utf-8?B?QW1BZ2F0UkJ4TFJiVm1mcVJ5NHlCNkZRbXdEOWZRK2Z0TGJvNEpmM1ZSUENo?=
 =?utf-8?B?QU4weExYY1Fjcy9HTklIZmRsWFdMR0s2a2xZRjRoK0ZBVlhVMTN4TS9mbzVS?=
 =?utf-8?B?amxuNE9ZbzRKODFXVjhTUFplS0prdEx3cDN0SGJCY1Fva3E2bGF1cVlLVFpa?=
 =?utf-8?B?UW93dlZKOFVidEsxUXJ1RVl3OHBzR20rU1RvNmNkeHBIdERuMVY3OWp4ZTJw?=
 =?utf-8?B?dXJKTDU1VnRwYldPSzRQR1lHbUdnSFFvVFUydXlIbzF6YTF5Mi9TZ2RaT2FY?=
 =?utf-8?B?dTVqcUZXSjlHQmlxYkpFdExqQUVmU0pyWUdrVEgya21sTXBOZGtjdUVUU1NQ?=
 =?utf-8?B?QTg4K2JmQTJuSXlZMHcycWJqU1Q5SzlqTWIxeXZ3eCttSEFMWjA2OGVxTTZI?=
 =?utf-8?B?OE9UZmZUZzVRNW1UUG1Zc2puYlE5OC9QN1FwdUtpRXJ5VU9VUVhZSXNOdzFG?=
 =?utf-8?B?eTBlQzZKOExsQnlwanJNUHVTT0NxdnFZUk85ZTlVMzh3bjR1Ri96Q2daV2RL?=
 =?utf-8?B?QW10cnZYelhDelJCSEVtZFU0czhQbG85WjJIcEtDTDJMclF0RFVodG9tc0hF?=
 =?utf-8?B?T2x6blpQdysvOXp5cTBRc2ZTQzlGWDdKWEE4eEhvcm8zRWNSMW5iSHJRdDFw?=
 =?utf-8?B?VFFtbFNQelRlZUVuS1JjR2EzZzdvNjhaNW93MU52VmR4U3NaODdITkh1R1Vj?=
 =?utf-8?B?WXc4U3RyZnVjcG1kZ0RseEZJTjg0WWFxSEpUMmdnOUlXVW8zUHpmSVRhcHU4?=
 =?utf-8?B?KzRSTEpvWnZpTytzL08vRXNwSXF0cWFySXNubGgwYURqa0kwUVZ5djBCNUUv?=
 =?utf-8?B?SjVYTnMvN3U3QWxHWTNveURYUis2bWpYR0NtY2x0V0ExYitRTlI1RmRWeEpk?=
 =?utf-8?B?Z1krVDZKTXlkRy96NlhLWjhGMGJXd0FJdFJHRVpHZWFwQnVDeERYUGp1b3BK?=
 =?utf-8?B?Q0pZQTJCNVNMY0hvenR2VElGZDdVTXBFR1htaENWdkt1ZW56YVV6bEMvM01M?=
 =?utf-8?B?VUNxMmd3K2NLYVRhSkJHdGw3Zk9Nd1YrRFQza3ZxREwycllCQnptdHRKZGoy?=
 =?utf-8?B?eURVMWYzdWVJYnBRSUNoZVY2Y3ZxZjBsYXk1TXk4M1dESXhzaU9vVXpsbkwy?=
 =?utf-8?B?RU9hL2t6WVhObXBzOEpZdkpGRzRyVHBldzIzZTFvbGl1L1I0WXkyNXNDS2cy?=
 =?utf-8?B?QTQzc09iZS9VanNOKzNta1dwOW56ZnR1Q1g4M0xJdGI2SnRpVitKUDhQVkpC?=
 =?utf-8?B?cFNRa09NL28vTFAxUlRnUUI5aGpxQ0xLcVg2NlhlT2ZGUWZjU29PUzZlUTB4?=
 =?utf-8?B?d2Y0ZjMyVHFDY1VYRktDYWhHUko0N0dvcXUyT3BSQWJocUEzWi85dDVETVor?=
 =?utf-8?B?cGdIWGFwcURjcURFSUVpVTM5SWRIK0tobWNReWF1N0tla3RCUnIvN00wSFNy?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f764a38-3d22-430f-9fad-08dde72b63db
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 18:39:30.0988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWYJ+Ij7Dw5zHrckQWtur+pGQx1kP66Q7/2XQbU5O3/21RBZaTKEtjO3vtdD5/pc2oXrixDYkLtbPocmZgLkfuBlKKaU06oywZssvUwC3h8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7607
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDg6NDIgUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdt
YWlsLmNvbTsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwu
Y29tOw0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVz
LCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIyLzI0XSBtbTogenN3YXA6
IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzDQo+IGlmIHRoZSBjb21wcmVzc29yIHN1
cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gT24gRnJpLCBBdWcgMjksIDIwMjUgYXQgMTA6NTfigK9B
TSBTcmlkaGFyLCBLYW5jaGFuYSBQDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3
cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4g
RnJvbTogQmFycnkgU29uZyA8MjFjbmJhb0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBUaHVyc2Rh
eSwgQXVndXN0IDI4LCAyMDI1IDQ6MjkgUE0NCj4gPiA+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQ
IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiA+ID4gQ2M6IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gPiA+IGhhbm5lc0BjbXB4Y2hn
Lm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdtYWlsLmNvbTsNCj4gPiA+IGNo
ZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsNCj4gPiA+IHJ5
YW4ucm9iZXJ0c0Bhcm0uY29tOyB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBha3BtQGxp
bnV4LQ0KPiA+ID4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGlu
dXgtDQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4gPiBjbGFiYmVAYmF5bGlicmUuY29t
OyBhcmRiQGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+ID4gPiBzdXJlbmJAZ29v
Z2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+
Ow0KPiA+ID4gR29tZXMsIFZpbmljaXVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+OyBGZWdo
YWxpLCBXYWpkaSBLDQo+ID4gPiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBW
aW5vZGggPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENI
IHYxMSAyMi8yNF0gbW06IHpzd2FwOiBBbGxvY2F0ZSBwb29sIGJhdGNoaW5nDQo+IHJlc291cmNl
cw0KPiA+ID4gaWYgdGhlIGNvbXByZXNzb3Igc3VwcG9ydHMgYmF0Y2hpbmcuDQo+ID4gPg0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gSWYgWlNXQVBfTUFYX0JBVENIX1NJWkUgaXMgc2V0IHRvIDggYW5k
IHRoZXJlIGlzIG5vIGhhcmR3YXJlDQo+IGJhdGNoaW5nLA0KPiA+ID4gPiA+IGNvbXByZXNzaW9u
IGlzIGRvbmUgd2l0aCBhIHN0ZXAgc2l6ZSBvZiAxLiBJZiB0aGUgaGFyZHdhcmUgc3RlcCBzaXpl
IGlzDQo+IDQsDQo+ID4gPiA+ID4gY29tcHJlc3Npb24gb2NjdXJzIGluIHR3byBzdGVwcy4gSWYg
dGhlIGhhcmR3YXJlIHN0ZXAgc2l6ZSBpcyA2LCB0aGUNCj4gZmlyc3QNCj4gPiA+ID4gPiBjb21w
cmVzc2lvbiB1c2VzIGEgc3RlcCBzaXplIG9mIDYsIGFuZCB0aGUgc2Vjb25kIHVzZXMgYSBzdGVw
IHNpemUgb2YgMi4NCj4gPiA+ID4gPiBEbyB5b3UgdGhpbmsgdGhpcyB3aWxsIHdvcms/DQo+ID4g
PiA+DQo+ID4gPiA+IEhpIEJhcnJ5LA0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIHdvdWxkIGJlIG5v
bi1vcHRpbWFsIGZyb20gY29kZSBzaW1wbGljaXR5IGFuZCBsYXRlbmN5DQo+IHBlcnNwZWN0aXZl
cy4NCj4gPiA+ID4gT25lIG9mIHRoZSBiZW5lZml0cyBvZiB1c2luZyB0aGUgaGFyZHdhcmUgYWNj
ZWxlcmF0b3IncyAiYmF0Y2gNCj4gcGFyYWxsZWxpc20iDQo+ID4gPiA+IGlzIGNvc3QgYW1vcnRp
emF0aW9uIGFjcm9zcyB0aGUgYmF0Y2guIFdlIG1pZ2h0IGxvc2UgdGhpcyBiZW5lZml0IGlmIHdl
DQo+IG1ha2UNCj4gPiA+ID4gbXVsdGlwbGUgY2FsbHMgdG8genN3YXBfY29tcHJlc3MoKSB0byBh
c2sgdGhlIGhhcmR3YXJlIGFjY2VsZXJhdG9yIHRvDQo+ID4gPiA+IGJhdGNoIGNvbXByZXNzIGlu
IHNtYWxsZXIgYmF0Y2hlcy4gQ29tcHJlc3Npb24gdGhyb3VnaHB1dCB3b3VsZCBhbHNvDQo+ID4g
PiA+IGJlIHN1Yi1vcHRpbWFsLg0KPiA+ID4NCj4gPiA+IEkgZ3Vlc3MgaXQgd291bGRu4oCZdCBi
ZSBhbiBpc3N1ZSBpZiBib3RoIFpTV0FQX01BWF9CQVRDSF9TSVpFIGFuZA0KPiA+ID4gcG9vbC0+
Y29tcHJfYmF0Y2hfc2l6ZSBhcmUgcG93ZXJzIG9mIHR3by4gQXMgeW91IG1lbnRpb25lZCwgd2Ug
c3RpbGwNCj4gPiA+IGdhaW4gaW1wcm92ZW1lbnQgd2l0aCBaU1dBUF9NQVhfQkFUQ0hfU0laRSBi
YXRjaGluZyBldmVuIHdoZW4NCj4gPiA+IHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPT0gMSwgYnkg
Y29tcHJlc3NpbmcgcGFnZXMgb25lIGJ5IG9uZSBidXQNCj4gPiA+IGJhdGNoaW5nIG90aGVyIHdv
cmsgc3VjaCBhcyB6c3dhcF9lbnRyaWVzX2NhY2hlX2FsbG9jX2JhdGNoKCkgPw0KPiA+ID4NCj4g
PiA+ID4NCj4gPiA+ID4gSW4gbXkgcGF0Y2gtc2VyaWVzLCB0aGUgcnVsZSBpcyBzaW1wbGU6IGlm
IGFuIGFsZ29yaXRobSBoYXMgc3BlY2lmaWVkIGENCj4gPiA+ID4gYmF0Y2gtc2l6ZSwgY2FydmUg
b3V0IHRoZSBmb2xpbyBieSB0aGF0ICJiYXRjaC1zaXplIiAjIG9mIHBhZ2VzIHRvIGJlDQo+ID4g
PiA+IGNvbXByZXNzZWQgYXMgYSBiYXRjaCBpbiB6c3dhcF9jb21wcmVzcygpLiBUaGlzIGN1c3Rv
bSBiYXRjaC1zaXplDQo+ID4gPiA+IGlzIGNhcHBlZCBhdCBaU1dBUF9NQVhfQkFUQ0hfU0laRS4N
Cj4gPiA+ID4NCj4gPiA+ID4gSWYgYW4gYWxnb3JpdGhtIGhhcyBub3Qgc3BlY2lmaWVkIGEgYmF0
Y2gtc2l6ZSwgdGhlIGRlZmF1bHQgYmF0Y2gtc2l6ZQ0KPiA+ID4gPiBpcyAxLiBJbiB0aGlzIGNh
c2UsIGNhcnZlIG91dCB0aGUgZm9saW8gYnkgWlNXQVBfTUFYX0JBVENIX1NJWkUNCj4gPiA+ID4g
IyBvZiBwYWdlcyB0byBiZSBjb21wcmVzc2VkIGFzIGEgYmF0Y2ggaW4genN3YXBfY29tcHJlc3Mo
KS4NCj4gPiA+DQo+ID4gPiBZZXMsIEkgdW5kZXJzdGFuZCB5b3VyIHJ1bGUuIEhvd2V2ZXIsIGhh
dmluZyB0d28gZ2xvYmFsIHZhcmlhYmxlcyBpcyBzdGlsbA0KPiA+ID4gc29tZXdoYXQgY29uZnVz
aW5nLiBJdCBtaWdodCBiZSBjbGVhcmVyIHRvIHVzZSBhIHNpbmdsZSB2YXJpYWJsZSB3aXRoIGEN
Cj4gPiA+IGNvbW1lbnQsIHNpbmNlIG9uZSB2YXJpYWJsZSBjYW4gY2xlYXJseSBkZXRlcm1pbmUg
dGhlIHZhbHVlIG9mIHRoZSBvdGhlci4NCj4gPiA+DQo+ID4gPiBDYW4gd2UgZ2V0IHRoZSBiYXRj
aF9zaXplIGF0IHJ1bnRpbWUgYmFzZWQgb24gcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZT8NCj4gPiA+
DQo+ID4gPiAvKg0KPiA+ID4gICogSWYgaGFyZHdhcmUgY29tcHJlc3Npb24gc3VwcG9ydHMgYmF0
Y2hpbmcsIHdlIHVzZSB0aGUgaGFyZHdhcmUgc3RlcA0KPiBzaXplLg0KPiA+ID4gICogT3RoZXJ3
aXNlLCB3ZSB1c2UgWlNXQVBfTUFYX0JBVENIX1NJWkUgZm9yIGJhdGNoaW5nLCBidXQgc3RpbGwN
Cj4gPiA+IGNvbXByZXNzDQo+ID4gPiAgKiBvbmUgcGFnZSBhdCBhIHRpbWUuDQo+ID4gPiAgKi8N
Cj4gPiA+IGJhdGNoX3NpemUgPSBwb29sLT5jb21wcl9iYXRjaF9zaXplID4gMSA/IHBvb2wtPmNv
bXByX2JhdGNoX3NpemUgOg0KPiA+ID4gICAgICAgICAgICAgIFpTV0FQX01BWF9CQVRDSF9TSVpF
Ow0KPiA+ID4NCj4gPiA+IFdlIHByb2JhYmx5IGRvbuKAmXQgbmVlZCB0aGlzIGlmIGJvdGggcG9v
bC0+Y29tcHJfYmF0Y2hfc2l6ZSBhbmQNCj4gPiA+IFpTV0FQX01BWF9CQVRDSF9TSVpFIGFyZSBw
b3dlcnMgb2YgdHdvPw0KPiA+DQo+ID4gSSBhbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgdGhpcyBy
YXRpb25hbGUsIGJ1dCBJIGRvIHdhbnQgdG8gcmVpdGVyYXRlDQo+ID4gdGhhdCB0aGUgcGF0Y2gt
c2V0IGltcGxlbWVudHMgYSBzaW1wbGUgc2V0IG9mIHJ1bGVzL2Rlc2lnbiBjaG9pY2VzDQo+ID4g
dG8gcHJvdmlkZSBhIGJhdGNoaW5nIGZyYW1ld29yayBmb3Igc29mdHdhcmUgYW5kIGhhcmR3YXJl
IGNvbXByZXNzb3JzLA0KPiA+IHRoYXQgaGFzIHNob3duIGdvb2QgcGVyZm9ybWFuY2UgaW1wcm92
ZW1lbnRzIHdpdGggYm90aCwgd2hpbGUNCj4gPiB1bmlmeWluZyB6c3dhcF9zdG9yZSgpL3pzd2Fw
X2NvbXByZXNzKCkgY29kZSBwYXRocyBmb3IgYm90aC4NCj4gDQo+IEnigJltIHJlYWxseSBjdXJp
b3VzOiBpZiBaU1dBUF9NQVhfQkFUQ0hfU0laRSA9IDggYW5kDQo+IGNvbXByX2JhdGNoX3NpemUg
PSA0LCB3aHkgd291bGRu4oCZdCBiYXRjaF9zaXplID0gOCBhbmQNCj4gY29tcHJfYmF0Y2hfc2l6
ZSA9IDQgcGVyZm9ybSBiZXR0ZXIgdGhhbiBiYXRjaF9zaXplID0gNCBhbmQNCj4gY29tcHJfYmF0
Y2hfc2l6ZSA9IDQ/DQo+IA0KPiBJbiBzaG9ydCwgSeKAmWQgbGlrZSB0aGUgY2FzZSBvZiBjb21w
cl9iYXRjaF9zaXplID09IDEgdG8gYmUgdHJlYXRlZCB0aGUgc2FtZQ0KPiBhcyBjb21wcl9iYXRj
aF9zaXplID09IDIsIDQsIGV0Yy4sIHNpbmNlIHlvdSBjYW4gc3RpbGwgc2VlIHBlcmZvcm1hbmNl
DQo+IGltcHJvdmVtZW50cyB3aGVuIFpTV0FQX01BWF9CQVRDSF9TSVpFID0gOCBhbmQgY29tcHJf
YmF0Y2hfc2l6ZSA9PQ0KPiAxLA0KPiBhcyBiYXRjaGluZyBvY2N1cnMgZXZlbiBvdXRzaWRlIGNv
bXByZXNzaW9uLg0KPiANCj4gVGhlcmVmb3JlLCBJIHdvdWxkIGV4cGVjdCBiYXRjaF9zaXplID09
IDggYW5kIGNvbXByX2JhdGNoX3NpemUgPT0gMiB0bw0KPiBwZXJmb3JtIGJldHRlciB0aGFuIHdo
ZW4gYm90aCBhcmUgMi4NCj4gDQo+IFRoZSBvbmx5IHRoaW5nIHByZXZlbnRpbmcgdGhpcyBmcm9t
IGhhcHBlbmluZyBpcyB0aGF0IGNvbXByX2JhdGNoX3NpemUNCj4gbWlnaHQgYmUgNSwgNiwgb3Ig
Nywgd2hpY2ggYXJlIG5vdCBwb3dlcnMgb2YgdHdvPw0KDQpJdCB3b3VsZCBiZSBpbnRlcmVzdGlu
ZyB0byBzZWUgaWYgYSBnZW5lcmFsaXphdGlvbiBvZiBwb29sLT5jb21wcl9iYXRjaF9zaXplDQpi
ZWluZyBhIGZhY3RvciAiTiIgKHdoZXJlIE4gPiAxKSBvZiBaU1dBUF9NQVhfQkFUQ0hfU0laRSB5
aWVsZHMgYmV0dGVyDQpwZXJmb3JtYW5jZSB0aGFuIHRoZSBjdXJyZW50IHNldCBvZiBydWxlcy4g
SG93ZXZlciwgd2Ugd291bGQgc3RpbGwgbmVlZCB0bw0KaGFuZGxlIHRoZSBjYXNlIHdoZXJlIGl0
IGlzIG5vdCwgYXMgeW91IG1lbnRpb24sIHdoaWNoIG1pZ2h0IHN0aWxsIG5lY2Vzc2l0YXRlDQp0
aGUgdXNlIG9mIGEgZGlzdGluY3QgcG9vbC0+YmF0Y2hfc2l6ZSB0byBhdm9pZCByZS1jYWxjdWxh
dGluZyB0aGlzIGR5bmFtaWNhbGx5LA0Kd2hlbiB0aGlzIGluZm9ybWF0aW9uIGRvZXNuJ3QgY2hh
bmdlIGFmdGVyIHBvb2wgY3JlYXRpb24uDQoNClRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGdp
dmVzIHByZWZlcmVuY2UgdG8gdGhlIGFsZ29yaXRobSB0byBkZXRlcm1pbmUNCm5vdCBqdXN0IHRo
ZSBiYXRjaCBjb21wcmVzc2lvbiBzdGVwLXNpemUsIGJ1dCBhbHNvIHRoZSB3b3JraW5nLXNldCBz
aXplIGZvcg0Kb3RoZXIgenN3YXAgcHJvY2Vzc2luZyBmb3IgdGhlIGJhdGNoLCBpLmUuLCBidWxr
IGFsbG9jYXRpb24gb2YgZW50cmllcywNCnpwb29sIHdyaXRlcywgZXRjLiBUaGUgYWxnb3JpdGht
J3MgYmF0Y2gtc2l6ZSBpcyB3aGF0IHpzd2FwIHVzZXMgZm9yIHRoZSBsYXR0ZXINCih0aGUgenN3
YXBfc3RvcmVfcGFnZXMoKSBpbiBteSBwYXRjaC1zZXQpLiBUaGlzIGhhcyBiZWVuIHNob3duIHRv
IHdvcmsNCndlbGwuDQoNClRvIGNoYW5nZSB0aGlzIGRlc2lnbiB0byBiZSBkcml2ZW4gaW5zdGVh
ZCBieSBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KYWx3YXlzICh3aGlsZSBoYW5kbGluZyBub24tZmFj
dG9yIHBvb2wtPmNvbXByX2JhdGNoX3NpemUpIHJlcXVpcmVzIG1vcmUNCmRhdGEgZ2F0aGVyaW5n
LiBJIGFtIGluY2xpbmVkIHRvIGtlZXAgdGhlIGV4aXN0aW5nIGltcGxlbWVudGF0aW9uIGFuZA0K
d2UgY2FuIGNvbnRpbnVlIHRvIGltcHJvdmUgdXBvbiB0aGlzIGlmIGl0cyBPayB3aXRoIHlvdS4N
Cg0KPiANCj4gPg0KPiA+IEFzIGV4cGxhaW5lZCBiZWZvcmUsIGtlZXBpbmcgdGhlIHR3byB2YXJp
YWJsZXMgYXMgZGlzdGluY3QgdTggbWVtYmVycw0KPiA+IG9mIHN0cnVjdCB6c3dhcF9wb29sIGlz
IGEgZGVzaWduIGNob2ljZSB3aXRoIHRoZXNlIGJlbmVmaXRzOg0KPiA+DQo+ID4gMSkgU2F2ZXMg
Y29tcHV0ZXMgYnkgYXZvaWRpbmcgY29tcHV0aW5nIHRoaXMgaW4gcGVyZm9ybWFuY2UtY3JpdGlj
YWwNCj4gPiAgICAgenN3YXBfc3RvcmUoKSBjb2RlLiBJIGhhdmUgdmVyaWZpZWQgdGhhdCBkeW5h
bWljYWxseSBjb21wdXRpbmcgdGhlDQo+ID4gICAgIGJhdGNoX3NpemUgYmFzZWQgb24gcG9vbC0+
Y29tcHJfYmF0Y2hfc2l6ZSBpbXBhY3RzIGxhdGVuY3kuDQo+IA0KPiBPaywgSeKAmW0gYSBiaXQg
c3VycHJpc2VkLCBzaW5jZSB0aGlzIHNtYWxsIGNvbXB1dGF0aW9uIHdvdWxkbuKAmXQNCj4gY2F1
c2UgYSBicmFuY2ggbWlzcHJlZGljdGlvbiBhdCBhbGwuDQo+IA0KPiBJbiBhbnkgY2FzZSwgaWYg
eW91IHdhbnQgdG8ga2VlcCBib3RoIHZhcmlhYmxlcywgdGhhdOKAmXMgZmluZS4NCj4gQnV0IGNh
biB3ZSBhdCBsZWFzdCByZW5hbWUgb25lIG9mIHRoZW0/IEZvciBleGFtcGxlLCB1c2UNCj4gcG9v
bC0+c3RvcmVfYmF0Y2hfc2l6ZSBhbmQgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSBpbnN0ZWFkIG9m
DQo+IHBvb2wtPmJhdGNoX3NpemUgYW5kIHBvb2wtPmNvbXByX2JhdGNoX3NpemUsIHNpbmNlIHBv
b2wtPmJhdGNoX3NpemUNCj4gZ2VuZXJhbGx5IGhhcyBhIGJyb2FkZXIgc2VtYW50aWMgc2NvcGUg
dGhhbiBjb21wcl9iYXRjaF9zaXplLg0KDQpTdXJlLiBJIHdpbGwgY2hhbmdlIHBvb2wtPmJhdGNo
X3NpemUgdG8gYmUgcG9vbC0+c3RvcmVfYmF0Y2hfc2l6ZS4NCg0KVGhhbmtzLA0KS2FuY2hhbmEN
Cg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=
