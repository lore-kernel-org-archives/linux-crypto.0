Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460321DDC07;
	Fri, 14 Nov 2025 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763148232; cv=fail; b=c0g82/aCArMz9xpawtD9GGym+5fIKRWzMPRTJLPymF4sh/fkmj6ycNv/ckPhejSuCw5cHgkfWpU6gY+sA5TxMmi9u0LvRmYf6o0AvkU5UrSFQrqMtKTDzyJf6ZN1SJEbfWDMQ8VlU6CCABdqPfn5cGXI2fcP6I3XtGRnrokAJLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763148232; c=relaxed/simple;
	bh=IcqlAoeV6kW6NBTe2pqUIAI9snAnlO66MKdlPAsbsXs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HDgIlCkPl/MAwWunKV9yVZ1DTyyiihzw7AbHoktyrgQgzPUQlomGZWcVjv0DJv2yABf/ty14KeaJsA8dXhVSltlgIdOYSElvH+4XL3P8c2+u4hlDj/Mpx/4irKIVIuk4aX5gTRRBeNC617z1QJKp8Rq1bJ9xKnZ4asl4AEobGes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k8jAf4yZ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k8jAf4yZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763148230; x=1794684230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IcqlAoeV6kW6NBTe2pqUIAI9snAnlO66MKdlPAsbsXs=;
  b=k8jAf4yZ5hqNihiGCvRKNfRhmz4IuqFa4jQuHgkNYDvlL65j1jMwpr/y
   6mda63MhUgwvr5Nl222MD2iYojnptoEQbonEqXncM+2plCjhzPxnhDB7Z
   RMTfYOPhGPsQOziFFJcRG+ADhAIDY2ZssBWrNSXMvi0c0iII0fqoIlnMt
   WWicYyg6zenX3E+/6JjoCjo53NlqRLjQBhtirZLYp3U6XNxc9WNaUNu2A
   opgoNvt27SG3ro3FXCAPT8BHthnw3q5ZEqkkUxd0BGpxGVQUAiyEb9Ix3
   4fYRFBf0Zyyg0cUNiN77yXEccfnTQDQzBt6ssJLkZTfed8a1sfHH8Ml1A
   w==;
X-CSE-ConnectionGUID: Lo9Y7bFzRaugZonmEadCPQ==
X-CSE-MsgGUID: t30uWWSXS2Cgu4cFLWdWGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="69117726"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="69117726"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 11:23:49 -0800
X-CSE-ConnectionGUID: SybMLB97RAW9bCJsf/V3SQ==
X-CSE-MsgGUID: WZVfmuGmQTanGp1W6jou4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="189867836"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 11:23:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 11:23:48 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 11:23:48 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.17) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 11:23:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xqGfBDv1nJsvF30J8UDPLd1Fuus1R6ix+WgJCnCEIcKWGk3UNNFVRAoEL+P2bOLt35HClc2aWRWyD0ZUZmoupuzTdwdzrjERkNJ9x76XdxOvEsCQaGzizXkbZa6OcHQjt2lJ5nHDhmzKHzuKihGL8geRGjz8lkfFFCCcM/5isjOgZ65nHKmqHQhnD9tsgD1Modfs+qGJ7LiL9sRZXLmZx6rEwoBVGMc/3eoKAzQ54d3aAwG9WJ6B+1MNcUQojLLXcMvSlfIrrINFc4rKuynwaA0K/PLNTQvH79MYFHCfd6MJ9W4rmQie6Y3p03xMLMb5NM+aSLJH+9ItoFGcyLnCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlUZ0iU9550YhgX0q0q1SUARrXtqC3cSLBkn+h+7mRk=;
 b=veV3YJgkvNxFGpO6SECECbdEVC0GfMyJ/chKHm87BV8babC+8TADmNVAG+Fv9x0PdqlAlpjEKQYqy8mqkWpRmQK/98S4OLLuvjtQax+zghEYsKUb6PPvC0t+faAZ5GrjvoM6GvP7ioHb1WrvFv0C2erCW4DIJWoiLMXyoG1cjJXv6H8emCd2UnPY9LzzzBYudfcIeJhNLACOWDHIOrlulaRXrndrQUmk+N+z/R+UHqswBm9SnDI7IOJBbBrpmjLflKuJpevK2ZTv8Uc1iImSKuzAsGFAb5wxpn5UcKXGxds5Hine+DUZCYvVCzBrXxweN0IT/Mzmvq7bqExLmqONPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 19:23:43 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.018; Fri, 14 Nov 2025
 19:23:42 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>
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
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAADiUEA==
Date: Fri, 14 Nov 2025 19:23:42 +0000
Message-ID: <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
In-Reply-To: <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SN7PR11MB6798:EE_
x-ms-office365-filtering-correlation-id: da8aeca7-3a49-4a2a-ac93-08de23b352ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?wqPIO0raalphSYK9p0suWMn1xCUdUt/H89sNaYldj4ki3OBBZQ+fGeB8XolH?=
 =?us-ascii?Q?RKWS+7WbRtO/rdZR7yyoHyG8PZcIXrGfsC3CvxANg7XnHbpevSWSTSNkWZ0w?=
 =?us-ascii?Q?lr2Tj3oNW/q/HvgD1Dmu6kRTol5+oR7YwhQMbpOlw0BJpacpK7r63722WOJu?=
 =?us-ascii?Q?7tKk/g+q7gpQfYEKaSi2AJ6bxKhuNdmuunlIP1v5B08oN69QtyASCOYXCtur?=
 =?us-ascii?Q?GqB6gSFEq2sDjgDhg8SZN4VDPaCejjCBxOo1U4bKNWTQGLTU1KmHov07s5I+?=
 =?us-ascii?Q?NUYdCRwjWsvKyIlYApp5GurwabGICyDnsCve3xG5BBg02gnyJF/1VbIbHbjS?=
 =?us-ascii?Q?mVij3cCNoyRbz+jhMuFBrSO3iNxI4XyiEy4zBml6jMIrHUOpifBh3HaK/5e7?=
 =?us-ascii?Q?jPucIN4XKP/W+XM0jC/nf1U8KH7HHPkPdIe1SEZVVkqAthcBPm4urbZC5dC8?=
 =?us-ascii?Q?Es34Q60xwze+P04qHjnF6IkWuLiEiRzDpZMzc3KYvz0Ag5PDMag762lpaeU1?=
 =?us-ascii?Q?30Cx1DrgLI1XX1ktE2It0OboInIQlJghJA7ec+QJB4/zqjpmFJjLMJ9upjUD?=
 =?us-ascii?Q?LsJfU0BM802zkLSekqxqkDqlmKAD55pM9DkCHYQ3AbSFVptamfkel0sx+rdB?=
 =?us-ascii?Q?dsilvD4E7L7Uu/hkDDxJL4eACSBayjCzBVMZXUoTj18MOwiJyDL0e0PEhfFP?=
 =?us-ascii?Q?tsPhdKiSkMCON/6wp4dKMsbfjefHNhj0HEf3Quxq+3RIPycCc3wRjgOsVvc/?=
 =?us-ascii?Q?pfei9GbrOuNvODUf+UOTBWO7Yz35d1y3gXBIGwmRAP+6CqZEtdPus7r7c6Bs?=
 =?us-ascii?Q?zz2yU3ycfUMSwl/rVRTNHUgY1S7ottDKLf2G4059nMzWl+AOWJ5BtgDTv7x+?=
 =?us-ascii?Q?1ylfExUATbAfGqAMmnEGX8HRkJMPBijKkKUWWml+rRSM1egxaNozvu5kbShL?=
 =?us-ascii?Q?0Iyibgxcw97TBJS0gsfBUA2oOgBI6mkiw1TOQVKR0Qk+m4oDrrRMa+ykKPIv?=
 =?us-ascii?Q?8yCho3D96aszCIRX27KRSheuPlMXAP/dJHPScYXipr+a3ntERmb0N3rGYMfC?=
 =?us-ascii?Q?hIrg9R//C1PIRfJ2BiST+e8VUFQ0PgSIeG63gMacYpegKbZZAcnWK/8WQRcb?=
 =?us-ascii?Q?cyRn4UleAdGiHW1/aKA3b20ZoxaUU61Sgftg7a1yGzbeuEQzQgrxGuyjlXWY?=
 =?us-ascii?Q?8qE4iW8u35gGeoGQVl3zKjMMl0nuXA0zfuDgD1HOZq1LIJE9CVImeDV3vbQ6?=
 =?us-ascii?Q?W2cacCTu9FKE8Rdzkq0o5i6tuMwWNBHZuLo0EEnCFdmdk3qJ2gGwjQ6L/QlE?=
 =?us-ascii?Q?lFM0M/XhM6PjiH7uFMJDXIFG07epsF1PqSKD18Ob93KlGuB3wZ5Q4uWf6hnC?=
 =?us-ascii?Q?lQJABtWRSbppzL3KwoPMYh3zNjJpoqHKNIpSTNixNzHvTqyzy/9fhMZsi+Pn?=
 =?us-ascii?Q?Zfib9p3gOaeaZnpzn2yLELHPmPa0CIyy0Y+sZmUwSBS+V766gv4EaICfpICh?=
 =?us-ascii?Q?R+64r0RAazPojMCIDTSBg8oVaHWoEVMAYP/k?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DFGkV5MzQ2O7hV/0rZFrf0moC0dJpeVaT2cAH+IswvDs4yBj/I5Flr+msBK8?=
 =?us-ascii?Q?8IotZtv+jk5xc6qPH5cM534yxU1WSgdBFT2VkDK4dHu9vMTB6PlJ0/fPej6I?=
 =?us-ascii?Q?ryrDSh68ZGe+xXwTGDQG25+Ut0+KKBNjU49/2wIiC8Wluknnx7qg+o5ox8qA?=
 =?us-ascii?Q?u/pWO3LMUpXMTezSP2srKuNy+NNHHpP/UAYg1ypb20Od/RVs9pNJoG6DIovE?=
 =?us-ascii?Q?uNQVXlUdrGmnIsi+OD0WNH2FlT6Eoroo3sgNvyDVCBuwg1Qt8xdsneti2QK5?=
 =?us-ascii?Q?ikDnayIQ1irnrQ+/jsdobPEBa8Jgqvbq9m0MaCAFtSjbkGljUBxpKBVeJp5d?=
 =?us-ascii?Q?9QG/ANtlEAcaFDy5B+SJiYsC1upDrvlOhpntlC4Gy7hDSRL8AyjHrLNPbURG?=
 =?us-ascii?Q?4Xzco1uune1m91Y8VEt58S/SKUcUcpCzZ6RkqawEy5d+kFUXTL1IzPjdc+Kb?=
 =?us-ascii?Q?xfz9LXwpQzkVvb5iRYecoG8p8D9lx2SZF+Ow3umqqDmjCPsBqIUFus5Rqp6t?=
 =?us-ascii?Q?XRVEVkOqAjfzkXk2W5qKnk09TscigUFeU0XZ0u7/j2s7f4tJoBQLHFTe3AcA?=
 =?us-ascii?Q?yB3LiwCyGqkhaazSZQZsGP/T9Ssx2Q28MFCySaeXjkfZHf/6D0EvH7+NSoXf?=
 =?us-ascii?Q?/Y7+TAbP5VP9MVroD2+hsdrPCNaS6e4PuTUxwlepUpqkPinmB8701TkIdG6y?=
 =?us-ascii?Q?4YXTahfeg2sWmfb+nxyJEgyM0o6QpxNKN9PEzN8GHw6osdjvK1lxhcAdQYXe?=
 =?us-ascii?Q?fsr/E13Jpx2nBt0z+2eZ0Q4eeHzG+UpDHCBjFQ2ObDS3d6xmf7DwMVcwzIq5?=
 =?us-ascii?Q?aMo54oIEJ+U8RX8sSnNAP1LD64FRJTy4TrTZhLdbp+Q5NLh/xdjisMn2L2TB?=
 =?us-ascii?Q?rw/aE6Ix+eIUi6tvSYHBSYD9NMMYbdufZyaHYEnQw9iAFHlbabbORRI3BPwv?=
 =?us-ascii?Q?SHQEmx+7F32igOuLA24PRGtGAtDUZRbTYHgFvAnK5yTqjYh3OGn8H/H3iNgF?=
 =?us-ascii?Q?SWRh1EL4WK/U2g1B63ClOtFQ7/RuyRJ2eoG3q/v0ysls3NUpVDYTq1dzvxfr?=
 =?us-ascii?Q?4pTl8MWZED2yzQP8W2iYLHUNy8sCbJ+cyymAe705devJ0YfRLj+zMaY0kFnV?=
 =?us-ascii?Q?UvImibY1WlL+cm/1JgiIXE0wNQc6pCfGNeluYraoaShSUVaz23jSulj6snIe?=
 =?us-ascii?Q?AXjJgl5Gca1OrYVXaQelNd+MvNaU4HEa5rOLrjE5W1idBTzDM7AI5gM4qHRm?=
 =?us-ascii?Q?CpeFTkRz0a+ze4TCwxqc81QJ90OxNDO/Lj25JCtE+uArXcEevnS3XiKXsAt9?=
 =?us-ascii?Q?CEauA8xGAheNxyE5KGg5RUV2wz6XoAm0xYDLq1Fvb0Sjnznr4++Ci0yUMwB6?=
 =?us-ascii?Q?RQ3IRzHmRYOB7N+Y+NE+PGl0vZHjbRZC1OSSq1gW/0xtzXwi96Iljm4Ms6vy?=
 =?us-ascii?Q?huEvw26oUCU8Fw3h5DRd4DH0qNkWoCxlzwZpJsbP1XqLsaMumRSKjYEQIjSg?=
 =?us-ascii?Q?R0fXxPaI9nqtHIsBqRaOl2PECwxo3y5zoiB9ufHh1RDtVIP147LFdhBU0PSZ?=
 =?us-ascii?Q?XMBBsvW8uFxvfCuH8Bg3AWgwLorOSh8ztKH4MbYu7CPxiOIMfTtXQcQXXzmb?=
 =?us-ascii?Q?7g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: da8aeca7-3a49-4a2a-ac93-08de23b352ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 19:23:42.8166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vn7Br94G8h4qQyyHA7eZpYybykEN+TWtPbVsGgKC5NKSj/ZQkAngq+AGkqL0tF4dSdCa0Uy4mreXd0h9I4yIP5an/u1MlikkxzqIebUhV/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, November 14, 2025 7:38 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> <sj@kernel.org>
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
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Fri, Nov 14, 2025 at 06:43:21AM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, November 13, 2025 9:52 PM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> with
> > > compress batching of large folios.
> > >
> > > On Thu, Nov 13, 2025 at 11:55:10PM +0000, Sridhar, Kanchana P wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > Sent: Thursday, November 13, 2025 1:35 PM
> > > > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > > > hannes@cmpxchg.org; nphamcs@gmail.com;
> > > chengming.zhou@linux.dev;
> > > > > usamaarif642@gmail.com; ryan.roberts@arm.com;
> 21cnbao@gmail.com;
> > > > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com;
> linux-
> > > > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > <vinicius.gomes@intel.com>;
> > > > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > > > <vinodh.gopal@intel.com>
> > > > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched
> zswap_compress()
> > > with
> > > > > compress batching of large folios.
> > > > >
> > > [..]
> > > > > > +		/*
> > > > > > +		 * If a page cannot be compressed into a size smaller
> than
> > > > > > +		 * PAGE_SIZE, save the content as is without a
> compression,
> > > > > to
> > > > > > +		 * keep the LRU order of writebacks.  If writeback is
> disabled,
> > > > > > +		 * reject the page since it only adds metadata
> overhead.
> > > > > > +		 * swap_writeout() will put the page back to the
> active LRU
> > > > > list
> > > > > > +		 * in the case.
> > > > > > +		 *
> > > > > > +		 * It is assumed that any compressor that sets the
> output
> > > > > length
> > > > > > +		 * to 0 or a value >=3D PAGE_SIZE will also return a
> negative
> > > > > > +		 * error status in @err; i.e, will not return a successful
> > > > > > +		 * compression status in @err in this case.
> > > > > > +		 */
> > > > >
> > > > > Ugh, checking the compression error and checking the compression
> length
> > > > > are now in separate places so we need to check if writeback is
> disabled
> > > > > in separate places and store the page as-is. It's ugly, and I thi=
nk the
> > > > > current code is not correct.
> > > >
> > > > The code is 100% correct. You need to spend more time understanding
> > > > the code. I have stated my assumption above in the comments to
> > > > help in understanding the "why".
> > > >
> > > > From a maintainer, I would expect more responsible statements than
> > > > this. A flippant remark made without understanding the code (and,
> > > > disparaging the comments intended to help you do this), can impact
> > > > someone's career. I am held accountable in my job based on your
> > > > comments.
> > > >
> > > > That said, I have worked tirelessly and innovated to make the code
> > > > compliant with Herbert's suggestions (which btw have enabled an
> > > > elegant batching implementation and code commonality for IAA and
> > > > software compressors), validated it thoroughly for IAA and ZSTD to
> > > > ensure that both demonstrate performance improvements, which
> > > > are crucial for memory savings. I am proud of this work.
> > > >
> > > >
> > > > >
> > > > > > +		if (err && !wb_enabled)
> > > > > > +			goto compress_error;
> > > > > > +
> > > > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg,
> nr_comps, k) {
> > > > > > +			j =3D k + i;
> > > > >
> > > > > Please use meaningful iterator names rather than i, j, and k and =
the
> huge
> > > > > comment explaining what they are.
> > > >
> > > > I happen to have a different view: having longer iterator names fir=
stly
> makes
> > > > code seem "verbose" and detracts from readability, not to mention
> > > exceeding the
> > > > 80-character line limit. The comments are essential for code
> maintainability
> > > > and avoid out-of-bounds errors when the next zswap developer wants
> to
> > > > optimize the code.
> > > >
> > > > One drawback of i/j/k iterators is mis-typing errors which cannot b=
e
> caught
> > > > at compile time. Let me think some more about how to strike a good
> > > balance.
> > > >
> > > > >
> > > > > > +			dst =3D acomp_ctx->buffers[k];
> > > > > > +			dlen =3D sg->length | *errp;
> > > > >
> > > > > Why are we doing this?
> > > > >
> > > > > > +
> > > > > > +			if (dlen < 0) {
> > > > >
> > > > > We should do the incompressible page handling also if dlen is
> PAGE_SIZE,
> > > > > or if the compression failed (I guess that's the intention of bit=
 OR'ing
> > > > > with *errp?)
> > > >
> > > > Yes, indeed: that's the intention of bit OR'ing with *errp.
> > >
> > > ..and you never really answered my question. In the exising code we
> > > store the page as incompressible if writeback is enabled AND
> > > crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
> > > if crypto_wait_req() fails and writeback is disabled, but what about =
the
> > > rest?
> >
> > Let me explain this some more. The new code only relies on the assumpti=
on
> > that if dlen is zero or >=3D PAGE_SIZE, the compressor will not return =
a 0
> > ("successful status"). In other words, the compressor will return an er=
ror
> status
> > in this case, which is expected to be a negative error code.
>=20
> I am not sure if all compressors do that, especially for the case where
> dlen >=3D PAGE_SIZE. The existing code does not assume that there will be
> an error code in these cases.
>=20
> For the dlen =3D=3D 0 case, the check was introduced recently by commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is"). Looking through the history it seems like it was introduced in
> v4 of that patch but I don't see the reasoning.

The existing code did not check for dlen =3D=3D 0 and dlen >=3D PAGE_SIZE
prior to commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression
failed page as-is") either. We need SeongJae or Herbert to clarify whether
this check is needed, or if it is sufficient to rely on comp_ret, the retur=
n from
crypto_wait_req().

>=20
> SeongJae, did you observe any compressors returning dlen =3D=3D 0 but no
> error code? What was the reasoning behind the dlen =3D=3D 0 check?
>=20
> >
> > Under these (hopefully valid) assumptions, the code handles the simple =
case
> > of an error compression return status and writeback is disabled, by the
> > "goto compress_error".
> >
> > The rest is handled by these:
> >
> > 1) First, I need to adapt the use of sg_outputs->sgl->length to represe=
nt the
> > compress length for software compressors, so I do this after
> crypto_wait_req()
> > returns:
> >
> >                 acomp_ctx->sg_outputs->sgl->length =3D acomp_ctx->req->=
dlen;
>=20
> For SW compressors, why is acomp_ctx->sg_outputs->sgl->length not set?
> IIUC we are using the same API for SW and HW compressors, why is the
> output length in different places for each of them?

This is to first implement the SG lists batching interface in iaa_crypto, w=
hile
maintaining backward compatibility for SW compressors with the new API.
I believe we may want to adapt the crypto API to SW compressors
at a later point. I also believe this would be outside the scope of this pa=
tch.
It would be nice if Herbert can share his vision on this aspect.

>=20
> >
> > I did not want to propose any changes to crypto software compressors
> protocols.
> >
> > 2) After the check for the "if (err && !wb_enabled)" case, the new code=
 has
> this:
> >
> >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k=
) {
> >                         j =3D k + i;
> >                         dst =3D acomp_ctx->buffers[k];
> >                         dlen =3D sg->length | *errp;
> >
> >                         if (dlen < 0) {
> >                                 dlen =3D PAGE_SIZE;
> >                                 dst =3D kmap_local_page(folio_page(foli=
o, start + j));
> >                         }
> >
> > For batching compressors, namely, iaa_crypto, the individual output SG
> > lists sg->length follows the requirements from Herbert: each sg->length
> > is the compressed length or the error status (a negative error code).
> >
> > Then all I need to know whether to store the page as incompressible
> > is to either directly test if sg->length is negative (for batching comp=
ressors),
> > or sg->length bit-OR'ed with the crypto_wait_req() return status ("err"=
)
> > is negative. This is accomplished by the "dlen =3D sg->length | *errp;"=
.
> >
> > I believe this maintains backward compatibility with the existing code.
> > Please let me know if you agree.
>=20
> For batching compressors, will 'err' be set as well, or just sg->length?
> If it's just sg->length, then we need to check again if WB is enabled
> here before storing the page uncompressed. Right?

iaa_crypto will set 'err' and set the sg->length as per the batching interf=
ace
spec from Herbert.

>=20
> >
> > >
> > > We don't check again if writeback is enabled before storing the page =
is
> > > incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
> > > these cases no longer possible?
> >
> > Hope the above explanation clarifies things some more? These case
> > are possible, and as long as they return an error status, they should b=
e
> > correctly handled by the new code.
>=20
> As mentioned above, I am not sure if that's correct for dlen >=3D
> PAGE_SIZE.

We need to get clarity on this from SeongJae/Herbert.

>=20
> >
> > >
> > > Also, why use errp, why not explicitly use the appropriate error code=
?
> > > It's also unclear to me why the error code is always zero with HW
> > > compression?
> >
> > This is because of the sg->length requirements (compressed length/error=
)
> > for the batching interface suggested by Herbert. Hence, I upfront defin=
e
> > err_sg to 0, and, set errp to &err_sg for batching compressors. For sof=
tware
> > compressors, errp is set to &err, namely, the above check will always a=
pply
> > the software compressor's error status to the compressed length via
> > the bit-OR to determine if the page needs to be stored uncompressed.
>=20
> Thanks for the clarification. I understand that the error code has
> different sources for SW and HW compressors, but I do not like using
> errp as an indirection. It makes the code unclear. I would rather we
> explicitly check err for SW compressors and dlen for HW compressors.
>=20
> That being said, I thought what Herbert suggested was that the same API
> is used for both SW and HW compressors. IOW, either way we submit a
> batch of pages (8 pages for SW compressors), and then the crypto API
> would either give the entire batch to the compressor if it supports
> batching, or loop over them internally and hand them page-by-page to
> the compressor.

That was not how I understood Herbert's suggestion for the batching interfa=
ce.
He did suggest the following:

"Before the call to acomp, the destination SG list should contain as
many elements as the number of units.  On return, the dst lengths
should be stored in each destination SG entry."

I have incorporated this suggestion in the iaa_crypto driver. For SW
compressors, I have tried not to propose any API changes, while making
sure that the zswap changes for the SG lists batching API work as expected
for SW without too much special-casing code.

I suppose I always assumed that we would update SW compressors later,
and not as part of this patch-set.

>=20
> This would simplify usage as we do not have to handle the differences in
> zswap.

That's the nice thing about SG lists - I think the zswap_compress() calls t=
o
the new batching API appears agnostic to SW and HW compressors.
Other than the upfront "errp =3D (pool->compr_batch_size =3D=3D 1) ? &err :=
 &err_sg;"
the logical code organization of the new zswap_compress() is quite similar =
to
the existing code. The post-compress "dlen =3D sg->length | *errp;" handles=
 the rest.

>=20
> If that is not doable, at the very least the API should be consistent.
> Right now the error code and length are propagated differently to the
> caller based on whether or not the compressor support batching.

Hopefully this minor difference is transitional while we move zswap to
use the new batching interface, with the assumption that crypto SW API
can be updated later. We would need to get Herbert's thoughts on this.

>=20
> >
> >
> > >
> > > >
> > > > >
> > > > > > +				dlen =3D PAGE_SIZE;
> > > > > > +				dst =3D
> kmap_local_page(folio_page(folio, start
> > > > > + j));
> > > > > > +			}
> > > > > > +
> > > > > > +			handle =3D zs_malloc(pool->zs_pool, dlen, gfp,
> nid);
> > > > > >
> > > > > > -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > > > > -	entry->handle =3D handle;
> > > > > > -	entry->length =3D dlen;
> > > > > > +			if (IS_ERR_VALUE(handle)) {
> > > > > > +				if (PTR_ERR((void *)handle) =3D=3D -
> ENOSPC)
> > > > > > +
> 	zswap_reject_compress_poor++;
> > > > > > +				else
> > > > > > +					zswap_reject_alloc_fail++;
> > > > > >
> > > > > > -unlock:
> > > > > > -	if (mapped)
> > > > > > -		kunmap_local(dst);
> > > > > > -	if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> > > > > > -		zswap_reject_compress_poor++;
> > > > > > -	else if (comp_ret)
> > > > > > -		zswap_reject_compress_fail++;
> > > > > > -	else if (alloc_ret)
> > > > > > -		zswap_reject_alloc_fail++;
> > > > > > +				goto err_unlock;
> > > > > > +			}
> > > > > > +
> > > > > > +			zs_obj_write(pool->zs_pool, handle, dst,
> dlen);
> > > > > > +			entries[j]->handle =3D handle;
> > > > > > +			entries[j]->length =3D dlen;
> > > > > > +			if (dst !=3D acomp_ctx->buffers[k])
> > > > > > +				kunmap_local(dst);
> > > > > > +		}
> > > > > > +	} /* finished compress and store nr_pages. */
> > > > > > +
> > > > > > +	mutex_unlock(&acomp_ctx->mutex);
> > > > > > +	return true;
> > > > > > +
> > > > > > +compress_error:
> > > > > > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > > > > +		if ((int)sg->length < 0) {
> > > > > > +			if ((int)sg->length =3D=3D -ENOSPC)
> > > > > > +				zswap_reject_compress_poor++;
> > > > > > +			else
> > > > > > +				zswap_reject_compress_fail++;
> > > > > > +		}
> > > > > > +	}
> > > > > >
> > > > > > +err_unlock:
> > > > > >  	mutex_unlock(&acomp_ctx->mutex);
> > > > > > -	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > > > > > +	return false;
> > > > > >  }
> > > > > >
> > > > > >  static bool zswap_decompress(struct zswap_entry *entry, struct
> folio
> > > > > *folio)
> > > > > > @@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct
> folio
> > > > > *folio,
> > > > > >  		INIT_LIST_HEAD(&entries[i]->lru);
> > > > > >  	}
> > > > > >
> > > > > > -	for (i =3D 0; i < nr_pages; ++i) {
> > > > > > -		struct page *page =3D folio_page(folio, start + i);
> > > > > > -
> > > > > > -		if (!zswap_compress(page, entries[i], pool,
> wb_enabled))
> > > > > > -			goto store_pages_failed;
> > > > > > -	}
> > > > > > +	if (unlikely(!zswap_compress(folio, start, nr_pages, entries,
> pool,
> > > > > > +				     nid, wb_enabled)))
> > > > > > +		goto store_pages_failed;
> > > > > >
> > > > > >  	for (i =3D 0; i < nr_pages; ++i) {
> > > > > >  		struct zswap_entry *old, *entry =3D entries[i];
> > > > > > --
> > > > > > 2.27.0
> > > > > >
