Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F0933F394;
	Fri, 14 Nov 2025 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763150404; cv=fail; b=Im21yCrqVqgl4ZfdkLXslA2sVHGWG2EP4kqGzMHCTctlN4iedBNsLDT0NrOrj0Ze1Bh0GLqnruqTkUOFCsySgPpNSbnyrIGJhOL26ZHNZ9yXVZyCV8CqLzfPKAm8ch/VSGkkQBeLkHkppfoZ1ndBo4Oxr+PVgWjPFe+07R6FM3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763150404; c=relaxed/simple;
	bh=nJ/Hv6y/Z3BBqtg7+jqs23hqAEvGaEu3VUUUz2wCQ5w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PI3OCXhxCGo0ifoBhHDQYIHqtmCiMx8Bq8LD4R4dKohqEWWXPLX3pgM9ZY6gcmK9aSNrUoFTYtJGLpcU1OsHwLlmcWcb/mVyAsDDQ2bM/KTv6T+3fTqID5D+0LW1NOH1lqFVZaP/dpimMu06IGjfXjqR5WLhY/8eqTdDM6cwsf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SEkhJ6Qz; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SEkhJ6Qz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763150402; x=1794686402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nJ/Hv6y/Z3BBqtg7+jqs23hqAEvGaEu3VUUUz2wCQ5w=;
  b=SEkhJ6QzZv2z+dD6CnpQZi+WzP6YV+y9rhMUCM02QE8IZH+zFKED4KPp
   DSsCIYDw76ocAMTgD6jAK8NkpSpUJafeD+xdrs9nbcs1YkZU1RH526aY4
   QU03ugynK4owZl1p9N5yWCvxi4G/c3eBCz2hLFfPQWtnRJOByeVtS3GEb
   42/uo5KlnshKF1h3oLywpxBSFVJzmlG1M5oSz8HkomeYbCxCsPob62IVM
   a01PzZxIAVvWBKd1LXr3TnCAJ+l96KajqlCJXJzAStU1w22PTWSqacEt/
   HzdsM8oWjyYaDy7hS5M0VbEiJ1wBQRwAO8gMbAMAIe5355WoUSnmk9C43
   w==;
X-CSE-ConnectionGUID: p1qz/kkGRnSEB2c5+b2M5Q==
X-CSE-MsgGUID: lofnY7tdQQyJJSEUB9+M7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="69099819"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="69099819"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 12:00:01 -0800
X-CSE-ConnectionGUID: OBG+YFySRmGHhf6U/Fd21A==
X-CSE-MsgGUID: nCJl+SrMSwKfEV961fXXfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="189685062"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 12:00:00 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 12:00:00 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 12:00:00 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 12:00:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBFNKJhKoHmRzw0yDH9MzlgffVAkivcNjwlz4n3r20/6hVa3M1wzf2oSzzPzwo1SGoPjl5AUxI+iSGDvGQ6Ju9fHT1BA14dwSW04pV/32hREweQ3NbsBMx9/RzkKEAaW5SJ4iUvEikOGYOzcgcfqojNK60kpctZtCzBgafo1XJPbsL1/tmM4Mfli3MGOWkwp1/NnQsF/zoSxXaBqijtaEsisk+DzAJUuYAnCOf1wARQRhzoD+t4s34Pk4Zd5anbDaxoHkzuCQ3vYu2K2Ji6bjgBwrJaYZxiNRL/Vis5pJHV7CjgYIZffu7Zq3znHosdMll7I14RxnzDjiwnX2W4RWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaQNtSNtl7u2XYN689Y01EV/DD085kK1e9t+e9ze1aE=;
 b=HA7hjOIPpQe/qbWd9Q9IiQB3xp7UECmkVl/GMQj+3pjIz7bCxJMoHZ833JQS2hOxT6ar7p+bPQy2o5yrsqJBQqrxRgIaA+/rLBjVzcCRW8LCWXIARvvsPpsV44NeiZzIHC45XdEqXBLGq6nVkm5254iGl90qOYtNrEE3eH2ofzggwGgLu09+UbG3+fEWS8sGfua8kT0sBAKWVdbzsiSXCbh/1wq3x/mD4rxyrhF9GnWMjiu1LzuRc9EjN+fDqf4GbEWU1LibBceBNAqqieA8fYJEelaTvZvZFHBGf8SLJXOzlvM3q9H/v0PFpzhJJJ1rZ6CNjkbeJN3ZXNwYpoXjDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DM6PR11MB4755.namprd11.prod.outlook.com (2603:10b6:5:2ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Fri, 14 Nov
 2025 19:59:57 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.018; Fri, 14 Nov 2025
 19:59:57 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAADiUEIAADEAAgAABFWA=
Date: Fri, 14 Nov 2025 19:59:57 +0000
Message-ID: <SJ2PR11MB8472CE2B46F08804CF5F2158C9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <keys236tojsj7a4lx6tyqtr3hbhvtjtkbpb73zejgzxmegjwrb@i2xkzvgp5ake>
In-Reply-To: <keys236tojsj7a4lx6tyqtr3hbhvtjtkbpb73zejgzxmegjwrb@i2xkzvgp5ake>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DM6PR11MB4755:EE_
x-ms-office365-filtering-correlation-id: ca0dff85-72f4-4166-5869-08de23b86304
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?49KRLW96ZIM+XHE5BEqrEkFv3E7A5Fcw0GAda7L3IhcDV6nMuTGpyo931wXT?=
 =?us-ascii?Q?gTKAwZrlr+0aT66NAIHcbHtkpHloYRk+ZHccSUPHjPYqlqS3Doel7W0Umyp5?=
 =?us-ascii?Q?YZcJGcIOr54bDgQ4b3R+s1c8izg2GJMj+kb6o+KxgQBD1qtR62JuS20+UOCg?=
 =?us-ascii?Q?kbxqKGuGqiHS9lubQvJ+R2Xt384rUJFIqor0+9Tiix+Zr+gJxF0cepV/heQ6?=
 =?us-ascii?Q?B07MTsFetnZZvuJJJMlELRQcM2+mKExF+QztqkGHRhCjIA26XP2Vh+zwbvJC?=
 =?us-ascii?Q?MFNS6344RyTKiwQueHjG0PXKrV8BmjarFc7d82oNkC8ifhfypxI7Zf//DnRi?=
 =?us-ascii?Q?3bF2hoZ18KLfPbSHlpWlpv/vT4H5586b46mDrx+3pQdq0e4bito1450MGwhc?=
 =?us-ascii?Q?n02T7NM/FF3dlpmtplEDEAVgocnJ4ZFBY1qaYeDGlBBmNjbP4WZPJ5zZ5bJN?=
 =?us-ascii?Q?XninG15VnrLUOlD9s0WF3jx8XaoRTd/35Q9Zqq/1Aa3VcTeWYINxuxfAZLMe?=
 =?us-ascii?Q?cY7f2yUNTCxhJyP3WTI/Fwas+oXmYal6qd/0/JWpeYPqnG/6Egy8ZAxRkJZ8?=
 =?us-ascii?Q?NsGy6DpZJKu4RXQW4y+QLlO+y/quDKOvshg3vQkI+/A/2hPaoHCAuvQvnvvv?=
 =?us-ascii?Q?riCcgNQg/le8L103JfTwERHegvR6F/7I7op+gxStQPC692+SCSKPd5HKmWwb?=
 =?us-ascii?Q?41S5lsbpU863zg9CoiaaBXwgjSbI5DOwiBwFIerJ7mAGo3BsQsPI76PKuhmj?=
 =?us-ascii?Q?2tkAzuLNvR1BeUqjqAO5Di/nnQ8gPxICFOjD6NA3mzvsPLbxG3esLBWwN6/A?=
 =?us-ascii?Q?FpkX1GGUJJaG0MAqSg7BTk1zI4iHxnzlowMHOurrYpnpJiM8VbLD1wJ5+c5n?=
 =?us-ascii?Q?2uxJwMNFsr3NaEAMIuWUO9ZI0kevXHi7HozS4g4qwU48lT2uQoRJ02qi1Xyx?=
 =?us-ascii?Q?Ol55USyzTBiuTKcTg7yPTi6G7Gug+77WVY/YaYCDJyw/zHGa6eYU9sIYcTA4?=
 =?us-ascii?Q?QS6yF+6ZPntZzNnKbFkDk7bXGjlwBbNJrirsWgVuvuyh2snCyqT9Y6VwX5wd?=
 =?us-ascii?Q?CgLsq/6BkEftD3jqHuJi5Ct5IhDg4ZhZWi/7TuZ9Uh0866XfNQvmi/2BknA/?=
 =?us-ascii?Q?MrZ9qbyxHGJtzutLm3Csi9p9mLelf7tipDQuuftMEKKeBI5/4vWfudjAlXL1?=
 =?us-ascii?Q?HkVeOnF6UJ2kc5iH6+b0ilje6Q0aVVDtn9HPqTUTz9pEnpifuOiPBX1erUWq?=
 =?us-ascii?Q?HMYuRIpFu/Ch7dskZRscIvGMaqsvPCknHw08Nufcc7yhd/plBer4c7l4cMVT?=
 =?us-ascii?Q?ITNfw+gSOCiwDJh3HUMDFpm6eRCFc+HkGHKIRaVUO2eOdi6ciXYegerwJIvl?=
 =?us-ascii?Q?+OI3ob2397EQt8N+Q5LCpUXqCSvlVv4r2xKc/7SAxj7MvfKXYgczsNad55LN?=
 =?us-ascii?Q?0RN2mTVn7RqQWWmOTMoC1pavjy5s7M9H7kXCaK0hcgpN48mp5YHIB2ebVQHL?=
 =?us-ascii?Q?ZnKVRnPhlweTDrR/+hbKhMyLzfsA48E3Fd/h?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RIMl6WOGyUGZPFzP0F4WTzn3lrLXsEBUqQJOp2rtN1nNi682/Hixrsietwfb?=
 =?us-ascii?Q?QCoD6PTogKeBM4Cg19Ed1vfdI586Aay7xI4NJ3Ttclp7B6pMlNoLl1IjfbGF?=
 =?us-ascii?Q?1DXhUoDKtLmrpgBZbzRBUocXFIhzWeIjwKEzVORSp02nAU+X8chJ4wvKgxSx?=
 =?us-ascii?Q?K1G4Tv+w7RbMvvH+MO96dLZLwotT/qelQzcxIKIk/ebGPA4///GXRXBvHD6o?=
 =?us-ascii?Q?CT7RxPuvZkOIowMBJHUrGKO9t0Ws+l2i7dqgM4uztvGnxyPeC/MNQARezZ6C?=
 =?us-ascii?Q?lpJEDFZWcANQqHVy2f5Lix2gBgkB5+cPguCANPTSzkUW3Ud6pj5kO2Kejczk?=
 =?us-ascii?Q?6mBvjeygMNHXru27Qm7XAJypaee9MBGw+V65ZZtWxgtUrm+acGe2HrfVNrOb?=
 =?us-ascii?Q?EWG7fWgHHQSUisC5c+vhmTS87wFHVT1OjDgWhOoBhgavFRy39f9H5b+5m/IA?=
 =?us-ascii?Q?GxEXqlmQLgQD6WmWnjuGmqeDjB3HED6lty2a5k0cTCie10z+wVLNlfe0GDBN?=
 =?us-ascii?Q?XEMDLYWDtZpHtwG93yS5zgTS47zbK3AyPDx97oxEeh+FM7PBGKDwHjxrKonJ?=
 =?us-ascii?Q?Mj7dVWruxS4A/XbvR1wDZryFq32UdoLRyAMYXfhcbjVdzvHXC29aTDvrmT/Y?=
 =?us-ascii?Q?xP1/ip6HxhrFiddm6oxGW8t4dEr/Ny5yZ8NLGfos5kCcoVI9FhjLGLoMoMBm?=
 =?us-ascii?Q?B0FNsFniX4ZHWx1ypz9SMm2CyvD6NlNCpl1NC4urH3wtGGeLodfHUArEZgBQ?=
 =?us-ascii?Q?pRJGy4XusouxgdcR2/ZdrYVkX2KJZUHg0HJ7kpnE8D6+Pk+qHgcf4/6FVD9w?=
 =?us-ascii?Q?cATnriiDWAX7cZHG1++NfiQJ2TUuLDVMCzmizNHx7tbMs38ZYJVVgjC1CZO2?=
 =?us-ascii?Q?43S1EfyTdNmilFHAyROHX4yrXNubvgf5I1sRprMERzGP+0IIZQUk0nEdtNii?=
 =?us-ascii?Q?M64rGqYffuvgJdz5n60TTb8HqUp4qttSqODOoz//JEt9O7mpLCvc1ozXBR39?=
 =?us-ascii?Q?novb+JkBWnzoFnuBvPzGeC1hy9p2ITPamDjnS7dpQLnp0vbL3D6/yx1IRgJD?=
 =?us-ascii?Q?brKdsjHBGmIjpxwhuYmB3bNqDxDtme7m+9bmIXYyUb1M2lovGzAsPxVvM/Z0?=
 =?us-ascii?Q?RD0QTs/XhLuPDGbbceossGFM7RwsbTFlRpAjZ2Ur4/JeXFzzdYMYn6WyeciM?=
 =?us-ascii?Q?a7Oe5Poeqs5la/10qQb9aNJvU62mIfxtWAbUnCCLimZTLU9KxKS52Yn/Mq3s?=
 =?us-ascii?Q?o6c79aNHhA2z9Jse2r4NkNvEXFYB+ji4lnmkN0CQ5qyTBX3qDRvxf8QTmf8o?=
 =?us-ascii?Q?v+AH6p/k/3LVY2qpIyms1zTb5aJjyk8VQjwJwyVqHyXENCg9Dze4zgR58PEB?=
 =?us-ascii?Q?IxijDmqHB13m2kqSZncfgEcUTwPhccmI/JZWeNm9L2Ih/gD5+kw+2i2mVeiO?=
 =?us-ascii?Q?OwGon0BI1DR/Y167WKXxxRGO9W51+KG1D6p9JeRPTxf+SksSL0ISlDjHQ5wF?=
 =?us-ascii?Q?J4il7f/yPqWfwkJXjrFSAFJD2oZolQ5eNCUICuCTcqzHEAQZpetMLIscGS+5?=
 =?us-ascii?Q?vxe/AaALaGsKrUdAt/MScT1wrISaKCyzdoOotXVQ24pQNQoe3TPg+BJSZD8e?=
 =?us-ascii?Q?yw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0dff85-72f4-4166-5869-08de23b86304
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 19:59:57.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3HVSHNV/gUieBK83nsrHX9gopRk0HsJhw5vZIT+23m6RrkFm5JPYQ8ufejqIhL2bu0KO4kGB9RqPKASX9OI3uE5BPExYwKlvu6ArSe44jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4755
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, November 14, 2025 11:44 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: SeongJae Park <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Fri, Nov 14, 2025 at 07:23:42PM +0000, Sridhar, Kanchana P wrote:
> [..]
>  > > > > >
> > > > > > > > +		if (err && !wb_enabled)
> > > > > > > > +			goto compress_error;
> > > > > > > > +
> > > > > > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg,
> > > nr_comps, k) {
> > > > > > > > +			j =3D k + i;
> > > > > > >
> [..]
> > > > > >
> > > > > > >
> > > > > > > > +			dst =3D acomp_ctx->buffers[k];
> > > > > > > > +			dlen =3D sg->length | *errp;
> > > > > > >
> > > > > > > Why are we doing this?
> > > > > > >
> > > > > > > > +
> > > > > > > > +			if (dlen < 0) {
> > > > > > >
> > > > > > > We should do the incompressible page handling also if dlen is
> > > PAGE_SIZE,
> > > > > > > or if the compression failed (I guess that's the intention of=
 bit
> OR'ing
> > > > > > > with *errp?)
> > > > > >
> > > > > > Yes, indeed: that's the intention of bit OR'ing with *errp.
> > > > >
> > > > > ..and you never really answered my question. In the exising code =
we
> > > > > store the page as incompressible if writeback is enabled AND
> > > > > crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check ab=
ove
> > > > > if crypto_wait_req() fails and writeback is disabled, but what ab=
out the
> > > > > rest?
> > > >
> > > > Let me explain this some more. The new code only relies on the
> assumption
> > > > that if dlen is zero or >=3D PAGE_SIZE, the compressor will not ret=
urn a 0
> > > > ("successful status"). In other words, the compressor will return a=
n error
> > > status
> > > > in this case, which is expected to be a negative error code.
> > >
> > > I am not sure if all compressors do that, especially for the case whe=
re
> > > dlen >=3D PAGE_SIZE. The existing code does not assume that there wil=
l be
> > > an error code in these cases.
> > >
> > > For the dlen =3D=3D 0 case, the check was introduced recently by comm=
it
> > > dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> > > as-is"). Looking through the history it seems like it was introduced =
in
> > > v4 of that patch but I don't see the reasoning.
> >
> > The existing code did not check for dlen =3D=3D 0 and dlen >=3D PAGE_SI=
ZE
> > prior to commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression
> > failed page as-is") either. We need SeongJae or Herbert to clarify whet=
her
> > this check is needed, or if it is sufficient to rely on comp_ret, the r=
eturn from
> > crypto_wait_req().
> >
> > >
> > > SeongJae, did you observe any compressors returning dlen =3D=3D 0 but=
 no
> > > error code? What was the reasoning behind the dlen =3D=3D 0 check?
> > >
> > > >
> > > > Under these (hopefully valid) assumptions, the code handles the sim=
ple
> case
> > > > of an error compression return status and writeback is disabled, by=
 the
> > > > "goto compress_error".
> > > >
> > > > The rest is handled by these:
> > > >
> > > > 1) First, I need to adapt the use of sg_outputs->sgl->length to rep=
resent
> the
> > > > compress length for software compressors, so I do this after
> > > crypto_wait_req()
> > > > returns:
> > > >
> > > >                 acomp_ctx->sg_outputs->sgl->length =3D acomp_ctx->r=
eq->dlen;
> > >
> > > For SW compressors, why is acomp_ctx->sg_outputs->sgl->length not set=
?
> > > IIUC we are using the same API for SW and HW compressors, why is the
> > > output length in different places for each of them?
> >
> > This is to first implement the SG lists batching interface in iaa_crypt=
o, while
> > maintaining backward compatibility for SW compressors with the new API.
> > I believe we may want to adapt the crypto API to SW compressors
> > at a later point. I also believe this would be outside the scope of thi=
s patch.
> > It would be nice if Herbert can share his vision on this aspect.
> >
> > >
> > > >
> > > > I did not want to propose any changes to crypto software compressor=
s
> > > protocols.
> > > >
> > > > 2) After the check for the "if (err && !wb_enabled)" case, the new =
code
> has
> > > this:
> > > >
> > > >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comp=
s, k) {
> > > >                         j =3D k + i;
> > > >                         dst =3D acomp_ctx->buffers[k];
> > > >                         dlen =3D sg->length | *errp;
> > > >
> > > >                         if (dlen < 0) {
> > > >                                 dlen =3D PAGE_SIZE;
> > > >                                 dst =3D kmap_local_page(folio_page(=
folio, start + j));
> > > >                         }
> > > >
> > > > For batching compressors, namely, iaa_crypto, the individual output=
 SG
> > > > lists sg->length follows the requirements from Herbert: each sg->le=
ngth
> > > > is the compressed length or the error status (a negative error code=
).
> > > >
> > > > Then all I need to know whether to store the page as incompressible
> > > > is to either directly test if sg->length is negative (for batching
> compressors),
> > > > or sg->length bit-OR'ed with the crypto_wait_req() return status ("=
err")
> > > > is negative. This is accomplished by the "dlen =3D sg->length | *er=
rp;".
> > > >
> > > > I believe this maintains backward compatibility with the existing c=
ode.
> > > > Please let me know if you agree.
> > >
> > > For batching compressors, will 'err' be set as well, or just sg->leng=
th?
> > > If it's just sg->length, then we need to check again if WB is enabled
> > > here before storing the page uncompressed. Right?
> >
> > iaa_crypto will set 'err' and set the sg->length as per the batching in=
terface
> > spec from Herbert.
>=20
> So both 'err' and sg->length will contain the same error? In this case
> why do we need to check if dlen < 0? Shouldn't checking 'err' be
> sufficient? and it would work for both SW and HW and we wouldn't need
> errp. Did I miss something?

Great question. For a batching compressor, 'err' will contain an error if a=
ny
page in the batch had a compression error. This allows the early bail-out
path for SW and HW compressors if writeback is not enabled for the folio.

Only the specific pages' sg->length will contain an error code. The other
batch pages that compressed fine will have the compressed length in
sg->length. This enables the post-compression loop with the errp check
bit-ORed with the sg->length, which for SW, has been brought up to date
with the acomp_req->dlen before we get to the wb_enabled code path.

>=20
> >
> > >
> > > >
> > > > >
> > > > > We don't check again if writeback is enabled before storing the p=
age is
> > > > > incompressible, and we do not check if dlen is zero or PAGE_SIZE.=
 Are
> > > > > these cases no longer possible?
> > > >
> > > > Hope the above explanation clarifies things some more? These case
> > > > are possible, and as long as they return an error status, they shou=
ld be
> > > > correctly handled by the new code.
> > >
> > > As mentioned above, I am not sure if that's correct for dlen >=3D
> > > PAGE_SIZE.
> >
> > We need to get clarity on this from SeongJae/Herbert.
> >
> > >
> > > >
> > > > >
> > > > > Also, why use errp, why not explicitly use the appropriate error =
code?
> > > > > It's also unclear to me why the error code is always zero with HW
> > > > > compression?
> > > >
> > > > This is because of the sg->length requirements (compressed
> length/error)
> > > > for the batching interface suggested by Herbert. Hence, I upfront d=
efine
> > > > err_sg to 0, and, set errp to &err_sg for batching compressors. For
> software
> > > > compressors, errp is set to &err, namely, the above check will alwa=
ys
> apply
> > > > the software compressor's error status to the compressed length via
> > > > the bit-OR to determine if the page needs to be stored uncompressed=
.
> > >
> > > Thanks for the clarification. I understand that the error code has
> > > different sources for SW and HW compressors, but I do not like using
> > > errp as an indirection. It makes the code unclear. I would rather we
> > > explicitly check err for SW compressors and dlen for HW compressors.
> > >
> > > That being said, I thought what Herbert suggested was that the same A=
PI
> > > is used for both SW and HW compressors. IOW, either way we submit a
> > > batch of pages (8 pages for SW compressors), and then the crypto API
> > > would either give the entire batch to the compressor if it supports
> > > batching, or loop over them internally and hand them page-by-page to
> > > the compressor.
> >
> > That was not how I understood Herbert's suggestion for the batching
> interface.
> > He did suggest the following:
> >
> > "Before the call to acomp, the destination SG list should contain as
> > many elements as the number of units.  On return, the dst lengths
> > should be stored in each destination SG entry."
> >
> > I have incorporated this suggestion in the iaa_crypto driver. For SW
> > compressors, I have tried not to propose any API changes, while making
> > sure that the zswap changes for the SG lists batching API work as expec=
ted
> > for SW without too much special-casing code.
> >
> > I suppose I always assumed that we would update SW compressors later,
> > and not as part of this patch-set.
>=20
> I am not sure I understand what changes lie in the crypto layer and what
> changes lie in the SW compressors. I am not suggesting we do any
> modification to the SW compressors.
>=20
> I imagined that the crypto layer would present a uniform API regardless
> of whether or not the compressor supports batching. Ideally zswap would
> pass in a batch to crypto and it would figure out if it needs to break
> them down or not. Then the output length and errors would be presented
> uniformly to the caller.

From my understanding, this would require changes to the crypto layer for
SW compressors, which again IIUC, does not set the sg->length, only sets
the acomp_req->dlen (IIUC, a temporary state until crypto for SW also uses
SG lists).

Ideally, batching could be handled similarly by crypto for SW. I believe we
will get there, albeit outside the scope of this patch.

>=20
> That being said, I am not at all familiar with how crypto works and how
> straightforward that would be. Herbert, WDYT?
>=20
> >
> > >
> > > This would simplify usage as we do not have to handle the differences=
 in
> > > zswap.
> >
> > That's the nice thing about SG lists - I think the zswap_compress() cal=
ls to
> > the new batching API appears agnostic to SW and HW compressors.
> > Other than the upfront "errp =3D (pool->compr_batch_size =3D=3D 1) ? &e=
rr :
> &err_sg;"
> > the logical code organization of the new zswap_compress() is quite simi=
lar to
> > the existing code. The post-compress "dlen =3D sg->length | *errp;" han=
dles
> the rest.
>=20
> It would be even nicer if the batches are also abstracted by SG lists.
>=20
> Also, I don't like how the error codes and output lengths are presented
> differently for HW and SW compressors.

I do believe this is short-term and is the first step in implementing batch=
ing
in zswap. We should get Herbert's thoughts on this.



