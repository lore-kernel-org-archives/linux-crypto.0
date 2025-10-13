Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175A5275B03;
	Mon, 13 Oct 2025 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760377639; cv=fail; b=V6uyp/8c8dx6eOyeR8tPMMHqX3SBYRoKf0BJnSgZieBqc24+VML6To92TcwDmajRvZcB+LS1nNsgrq6xyn3ROFofOFDGZEHQ2li0z2a1uBoa/2rY+XI+U+41H8pwGXIwX1tZ+d0wmUwMcHwena5/MGL0k59eeiZnzRwGLiIpisU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760377639; c=relaxed/simple;
	bh=KP2No7xwf/GYfv9HLFmI9koZghFcOMwbl/H7oyAjgIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fiq9Uic/InEgiv9DFlvNIN0z0tppIGBSYSTdobOn1Wudkq3SvJ9M17Bq6KNh2/2n4AANEkG2za9qerUXjrIpEpTsw4wTCz6ccKk0DvnqPAlK2n4UGN1CvqBb4WyYEiJcF5gEQwzLGrVsOdsfLu8sJXLYM3tlk14qMomcVpC4Ue0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtJtLnoz; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtJtLnoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760377637; x=1791913637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KP2No7xwf/GYfv9HLFmI9koZghFcOMwbl/H7oyAjgIw=;
  b=PtJtLnoza4S7sTl1FgoFBcZtXxYGNljSahHw/ZaOiNX5oUtDMplZAvxC
   +xm+7X423S06dDcuKgRKDoAKnAtr7CTBDwmSIteSw5Ue6szoV6yRAFcI9
   3ymM8R4Xi2GXW3sF2gMsL/xjgs9mMo6SwQG3Bwwe4jQa5PrTdW67ms3/V
   EaWLQvaluV6zGFl0bA6Hp0pwHMlH/MvkPZ2AAym341+9O7iZcXItlVgHo
   +fEyxmezx0GRcNNgc3UwBC2goUBURLcutLVuIOCXFX7IZtX+G3KYvwjbT
   O2CIw+aHAVO3NHSEsczcoDYz+Cu4J/L39tVaWr9rGOpSIPFXpmvWUrcy6
   w==;
X-CSE-ConnectionGUID: YII5p7t1Rhm9A3vszXlYpA==
X-CSE-MsgGUID: vhFxBk/wR1e1F1P0cPTbHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="80162400"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="80162400"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:47:16 -0700
X-CSE-ConnectionGUID: lAkaeGKvQ9ecnsGq2A/nyA==
X-CSE-MsgGUID: U1GSPGrgTLueq9hg5lgRpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="180810252"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:47:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:47:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 10:47:15 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:47:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NX0bBcMZs/OooS7PJS0OUXGV/ded5h/1YpNn2F5I3j3yZJHYN/4NdQA0E0YN1SJPvqe9u/Gg+Mm8022PrD1nQ7KZyt865nT+SXGdJM7oqVgv2FaKTqxFdT0sd4iT9v9pDsG3I3Ob3CJ/aMxWUiohniDkrNEwxNfVNRtRQtz7Amp+qihP9KaucYdbHZQPFQPP/2nFvQJvodzk6yK6YdAkENoga8r2D8Y4sRO8zAVD5DLOD2ExG90aw+L8sDe5dLEBT5CU+nhNYTOVjxmNlRpGCAj50nNWgXUOa1hIFWoyTMTCXPOA6h0gr9prKSEoRaRzG56qNfC3yFqc8kWNuFvlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xy3CIehzmRCm7Gyv14qVOUKktX3ys7ayYEKB+qRmGCc=;
 b=jv74MBE14VurBgBWvnfYDseSq1J7CnKZM0jKwvJ3jiupdY0c07JopxJyq25GzEPq7I07koNnY/c6I2S6W0xyVbPAg3kEWVmLFeW7gkv6m861u95u52+ALA9b6st6O9l4Ro03O3g9tfZP5MtcBdKn1RdQnUxYHmB7goSNxbfbYpmSHTmV4+PlsbaN9hvaTg0093QMwWK6febpT8XhM/wZU9qWpEW1Q5HmCBXM+v7mUBdamEtiL/rGWI924XrrWpj2mIug+dWopy5a2nAJYo0kYT+qdcZ+FP0dycJW4egPpxyPdddgSt961TTqbyABnAx7zxdcYczHt3KRkqPX8UmlYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 17:47:13 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:47:13 +0000
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
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAAzXpkIAPptYw
Date: Mon, 13 Oct 2025 17:47:13 +0000
Message-ID: <PH7PR11MB81218BA4B8D8CC5F57570455C9EAA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <PH7PR11MB812152287E850FA7CBAE2FD5C9E4A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB812152287E850FA7CBAE2FD5C9E4A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ0PR11MB4976:EE_
x-ms-office365-filtering-correlation-id: acf0f638-e869-4001-85c1-08de0a808ad0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?ja60k70VeKmrGqx3iN6MgUvpIsV6s5Qg1WH5xgbbI1s2wMBEvcvA5LZpO0?=
 =?iso-8859-1?Q?rIqFTv2fA6MU0EZmr1cQ3XvbLVhte3pKX3ziKKBF6DeBowU88sj99Y4rbQ?=
 =?iso-8859-1?Q?/p+pOb0Ktn2bc+iBL7DDRY6k/Ze8CyD02oB9/AM9/xQSKMtRJLIhSETS19?=
 =?iso-8859-1?Q?5RrDDxN9TOuFvImMd9K6VItX9I84mR/nOeGGUV0ZrR5lN8WYlJbDLyaAl4?=
 =?iso-8859-1?Q?CGr8yxUjoQXcrqCMsIVOmi/znc+qybl5WK4grXJFlF8Caxe8RYumS1dlFT?=
 =?iso-8859-1?Q?lrPfY+LSwUp3gZEVbMcjpv+3l+SqyOFx1fWsc2f26C56ApLzqjp/dfOjdg?=
 =?iso-8859-1?Q?/w/Mki10LMQXJ1kQNgIjI2zPnqzGHRKu+uxFU+i9/SbLKC/dp4LZOtIU3s?=
 =?iso-8859-1?Q?oncthzLJA7iLjA9De/vcD/1d/qQC+xqTlEqgdu6hOs3fzGHufh31NRAUA4?=
 =?iso-8859-1?Q?Nm/hAvT52QTiEib4jyGh4NjQ42KC9+Nd0pZ5q5VoVIw4mt8RdIsSVwfq0J?=
 =?iso-8859-1?Q?PXq2fn/lQm6p68Rj3pe6pnNn3l9vCcfZUc6OhFyigNfIsD6V3NULiSoSzW?=
 =?iso-8859-1?Q?8xo30Y8oxYTgm8gdkLEePZQZud6g0LYNXxSp9lUfW274beeekxDQrUUE/5?=
 =?iso-8859-1?Q?+F3rxSWZR8PnIX7hftb8ZOjIIx6j8UH5zY2lIEX5yfemPxuW8dA5qZsMFi?=
 =?iso-8859-1?Q?IFTotiCkeCsOombt2hb82NudkrJwO0JxUZbTCiOepDlD2F3X5gQWFljEf+?=
 =?iso-8859-1?Q?EKA6s/dH42B8HX8AVH0TovdECcTYZ+KTFxWnD4/3ORCKwV5og1jEFcpAmi?=
 =?iso-8859-1?Q?2C1pNmBkzl4SUYwphmsTmFbSHBP1ETcF2QHaW7YsDDV5r+zcw0ldvPQtBS?=
 =?iso-8859-1?Q?4BuuNH+4MgG1W5T/I2N40J9jzl3d76qX/N2QPmpFqZ56cqYA0Xa5oWMpKK?=
 =?iso-8859-1?Q?wKHjG7nOzsK0dlr1WxLVN/yU5q3CJpBDUlOrtADUmtaublIxdxjHwQy9MM?=
 =?iso-8859-1?Q?zx63ZzA7sakG4L0yfwk9lxQq82MWXK0iJuDqTYEufPSMoGE55Q5ngBdM7p?=
 =?iso-8859-1?Q?XkyJMcgEUF7aFu5gYkQ4Bw8mZb8Rrthh7ebDGPbM3o8K8WEkg2tuHqlmOC?=
 =?iso-8859-1?Q?96Hklt9RbsGNv+Cs+quJ9Exm+voBW6GiySUuhjXIvgT1ezbMaJRc0OXNQZ?=
 =?iso-8859-1?Q?4el1NNBeq3YxQHgvJzXvc5uqb8svYQVPE6WPqGdv+M5ICGkrnBlBne2od8?=
 =?iso-8859-1?Q?RbEcypPh40EQesGeGLVYns8YDaZJc7hgaRY2QwXVaAdNi4asubXFPriIE2?=
 =?iso-8859-1?Q?ipyptUECcunPA0KaI4NX8mbMruPUh88xs/OZEhdatVRiyY9I/mVI51BYSV?=
 =?iso-8859-1?Q?tiujwo/vdLtFrSg+bcZBbpFlychZmnUVOdNBgsR1jk9MyXHX8L83VQdwKA?=
 =?iso-8859-1?Q?Zimc3enhxfN+opSgAWeLqYYWr4yqtNMPg1V+B5QffrVfivZw4PTG1qU54p?=
 =?iso-8859-1?Q?iUd5EOZYr8IfMQazKj5as7d8dNWe+da3YzuWvyGH9LMB838uDQP9oImy+I?=
 =?iso-8859-1?Q?Ze9zJXxMyswEtg+hcwv9wN0LPLeK?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NsseyGrkrk24vc5nUieDhLmHN3gySHsGvyTAntVwvqZuWshPjVJrcxUDhh?=
 =?iso-8859-1?Q?kuR7vEZ93LzneKUlHbkls2Kviro0qK3OtZbObLqo8YLQ8AUMSJV/hxhyZg?=
 =?iso-8859-1?Q?5f47VEVFOFWRlExAUG8FXSZ+Ce1r9+UrgLJCDFlWleeRWzaCd7HbpQM3oA?=
 =?iso-8859-1?Q?QdenEyicZMfbELh48MKLNn+ZgJ7bM1TBvZ9OuK52GKHEuwk9+yv1d1BCDA?=
 =?iso-8859-1?Q?tDCK849ejce/EE4Yz+JiD1009SBF4Qr1LUlhcdGshp/TzfF7YDzBgY/Umg?=
 =?iso-8859-1?Q?tjTeh2yapbZURORRIdEP3sc4tdWER0hnI2UVHj8GwM9Kj6zMCKyqFrnrwb?=
 =?iso-8859-1?Q?a7wpwn2DUbPy+xX+4HL4Mh4FcZmfNGkHCIoclaxAuLhgSRKlJa98z0CYFJ?=
 =?iso-8859-1?Q?smAVtSVdGeGtbO6/m/u02dOlOQChbvTbx1df6Y2/Xnu3PAMma+Xn2FcR3Y?=
 =?iso-8859-1?Q?ZJkQtl5IQlgFI2CLKB4ox9RxcclfNc1pzASCci/OkaxdcSPcrpF9cWp9pg?=
 =?iso-8859-1?Q?oQEw3kG9ENV09noEogOFEOIauE0XujFciTaXHYAwI09zMSHDfV+075fHAB?=
 =?iso-8859-1?Q?vgGml/BTenTVPskLM2zujBiPYy+n7zJh1bNefL7AHqGni5iKWPsS5+tvdo?=
 =?iso-8859-1?Q?ONuJoXud4ZkkqauFS+HUVIkC3BxoyEmTNSGV+XMw5cbuPJFFSujwxQJ0Vy?=
 =?iso-8859-1?Q?qQ9r7rbIfFEKKcxxNoQRJsuYswirb0OqTXOsFWXa4dndkJ8GYD4SXKa7+H?=
 =?iso-8859-1?Q?4KDEdTcCoMj01jV2lvnKsayWWTJqfkz7Ua6noFABJ6K9uz0IotGxzMbHFD?=
 =?iso-8859-1?Q?ILH9VmMVVNTehPOYoFRh9SNQmCWCKqKQcg0dNCMtr5V9pEmhG0jDPh3kyP?=
 =?iso-8859-1?Q?D7/vaYo0zrNaiOdRtao9GHgjDLrTopmwYRpfaZaWtzeuFGD++cb/wbDCAr?=
 =?iso-8859-1?Q?iQM1FIbyLJeF8cfVyfvxtNRMckp26f6FD9adzb+a1z56HzclIqcEY4tBt5?=
 =?iso-8859-1?Q?9Rgpa5OsV4smMfIYzju5YdqSyEN5VwUiBUXgJZXmaZavuE5O+G9Br7uJBz?=
 =?iso-8859-1?Q?eLUEnIlirDt5XthmiJK76ZDPlmzbmNkuQCZCttnTxccue0aHTUkOq9PWyF?=
 =?iso-8859-1?Q?l+LXDcpcY4dRL+xsgK+wLNxMfvHmqCHgpGnXqpsbVW81EB/CGv0OSpTXST?=
 =?iso-8859-1?Q?zmQpqIrdsUeOx9XATMrXKJCWrqWtrHIS7nFQ7MmBMRf0zvoHNrztx9lkXB?=
 =?iso-8859-1?Q?X9jAiBYvvQXAqMvHXfqWIvo9hA7jTiC2IPgYF+Y7TCrXkteNXbut9gtgo9?=
 =?iso-8859-1?Q?sccU+xQHBJYTXAip1iz+EWqTS8S4U5PjMesl52jeEYVJa2VuI+NRiwZKG/?=
 =?iso-8859-1?Q?37+C+hUHQrRjhXF2EkslLxcj8VbqqQogjVypbK2VjHMY0xNyTWA01Bz1Q6?=
 =?iso-8859-1?Q?SlNb1wJepMuhgr5OHUEVOiacBZ90GqYLtm+DVHTzKAgbKTwWzfsNFASo+W?=
 =?iso-8859-1?Q?Mtj6wggxMfDvU+8MJVddtMh7WnNYq6VRAodvCenQ0P91ys0MQy7s0nDgyx?=
 =?iso-8859-1?Q?ZIOJ98+FPD03r8762kzdGjc88fapcXDliInOylshqbP5y9yGEXnh+c/5KB?=
 =?iso-8859-1?Q?CbY89pZcE0fBJNF2A5omAv/WNpwSVlsskh1qbZNshvSV7xjfgqeanBi/d1?=
 =?iso-8859-1?Q?JZJxWEwSd090LrYhuGUxfl5n6Da289aip/pGLmGjxfJk2r2rUosyCPF1lX?=
 =?iso-8859-1?Q?8cdA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf0f638-e869-4001-85c1-08de0a808ad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 17:47:13.3943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GVkDXw4aXw9NHPClzvxtWZdzxVDWNzTfUf6T5rI6ubPXvMtEDXKUkJc5JXVCP8gI6H0nYFw6SfFQxED887ka4ddqoUw07G1EZjpVNLIIenY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Friday, October 3, 2025 12:11 PM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
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
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
>=20
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Wednesday, October 1, 2025 9:19 AM
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
> > <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process =
a
> > > large folio in batches.
> [...]
> > >
> > > > + */
> > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > **entries,
> > > > +							   unsigned int
> > > nr_entries,
> > > > +							   gfp_t gfp)
> > > > +{
> > > > +	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> > > entries);
> > >
> > > We currently use kmem_cache_alloc_node() in
> zswap_entry_cache_alloc()
> > to
> > > allocate the entry on the same node as the compressed page. We use
> > > entry_to_nid() to get the node for LRU operations.
> > >
> > > This breaks that assumption.
> >
> > You bring up a good point. I was looking at the code in slub.c and my
> > understanding thus far is that both, bulk allocations and
> > kmem_cache_alloc_node()
> > allocations are made from a per-CPU "cpu_slab" that is allocated by SLU=
B.
> >
> > IIUC, the concern you are raising is in the mainline, the entry is allo=
cated on
> > the same node as the compressed page, and gets added to the LRU list of
> that
> > node. IOW, the node to which the compressed page belongs is the one to
> > whose
> > LRU the entry will be added.
> >
> > With this patch, with kmem_cache_alloc_bulk(), the entry will be create=
d on
> > the per-CPU slab of the CPU on which zswap_store() is called and will b=
e
> > added to the LRU of that per-CPU slab's NUMA node. Hence, the end resul=
t
> > could potentially be that the zswap_entry for a page could potentially =
be
> > on a different NUMA node/memcg than the page's NUMA node.
> >
> > This is my thinking as to how this will impact the zswap shrinker:
> >
> > 1) memcg shrinker: if the memcg the entry ends up in is on the
> zswap_list_lru,
> >     the entry will be written back.
> > 2) Global shrinker: will cycle through all memcg's that have pages in t=
he
> >     zswap_list_lru, and the entry will be written back.
> >
> > Based on this, it is not clear to me if there is a problem, and would l=
ike to
> > request you, Nhat and others to provide insights as well.
> >
> > Interestingly, most of the code in slub.c has unlikely(!node_match(slab=
,
> > node)).
> > Does this imply some higher level mm slab allocation requirements?
> >
> > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if w=
e
> > think this would be more correct.
>=20
> I wanted to share some updates and summarize my understanding from
> looking some more at slub.c. The "zswap_entry_cache" kmem_cache
> has slab memory created for each node. The main change with v12 is:
>=20
> before:
> The page being compressed and its zswap_entry are in the same memcg,
> thus, implicitly on the same slab node.
>=20
> v12:
> The page being compressed and its zswap_entry could be in different
> memcgs if the process that owns the page gets migrated to a different
> node.
>=20
> Impact to zswap LRU list vis-=E0-vis the memcg shrinker:
>=20
> before:
> The original NUMA node memcg [hierarchy] would need to face memory
> pressure for the page's zswap_entry to be written back. Hence it is possi=
ble
> that the node on which the process is currently running may not see the
> benefit of memory being freed up.
>=20
> v12:
> The memcg whose node on which the process was running when the page
> was compressed would have to face memory pressure for the page's
> zswap_entry
> to be written back. This node will see the benefit of memory being freed =
up
> due
> to writeback. If the process has migrated to a different node than the on=
e
> on which it was running when the page was compressed, we have the same
> issue
> as "before".
>=20
> Is my understanding correct? Please let me know if I am missing something=
.
>=20
> The bulk allocation does improve batching performance, especially with 64=
K
> folios:
>=20
>  kernel_compile, 64K folios, deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            mm-unstable-9-18-2025              v12     without bulk alloc/=
free
>  ------------------------------------------------------------------------=
------
>  real_sec           874.74                 821.59       870.82
>  sys_sec          3,834.35               3,791.12     3,794.06
>  ------------------------------------------------------------------------=
------
>=20
>  kernel_compile, 64K folios, zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            mm-unstable-9-18-2025              v12     without bulk alloc/=
free
>  ------------------------------------------------------------------------=
------
>  real_sec           925.08                 853.14       899.40
>  sys_sec          5,318.65               5,172.23     5,415.20
>  ------------------------------------------------------------------------=
------
>=20
>  kernel_compile, PMD folios, deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            mm-unstable-9-18-2025              v12     without bulk alloc/=
free
>  ------------------------------------------------------------------------=
------
>  real_sec           808.10                 794.85       809.33
>  sys_sec          4,351.01               4,266.95     4,169.07
>  ------------------------------------------------------------------------=
------
>=20
>  kernel_compile, PMD folios, zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>            mm-unstable-9-18-2025              v12     without bulk alloc/=
free
>  ------------------------------------------------------------------------=
------
>  real_sec           848.06                 845.42       836.06
>  sys_sec          5,898.58               5,741.31     5,795.75
>  ------------------------------------------------------------------------=
------
>=20
> Based on this, and if my understanding of the v12 change's impact on the
> zswap shrinker is correct, I am not sure if the change in the assumption
> is necessarily a concern.
>=20
> >
> > >
> > > > +}
> > > > +
> > > > +static __always_inline void zswap_entries_cache_free_batch(void
> > > **entries,
> > > > +							   unsigned int
> > > nr_entries)
> > > > +{
> > > > +	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> > > > +}
> [...]
> > > > +static bool zswap_store_pages(struct folio *folio,
> > > > +			      long start,
> > > > +			      long end,
> > > > +			      struct obj_cgroup *objcg,
> > > > +			      struct zswap_pool *pool,
> > > > +			      int node_id,
> > > > +			      bool folio_wb)
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
> > > > +						      nr_pages, GFP_KERNEL)))
> > > {
> > > > +		for (i =3D 0; i < nr_pages; ++i) {
> > > > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> > > node_id);
> > > > +
> > > > +			if (unlikely(!entries[i])) {
> > > > +				zswap_reject_kmemcache_fail++;
> > > > +				/*
> > > > +				 * While handling this error, we only need to
> > > > +				 * call zswap_entries_cache_free_batch() for
> > > > +				 * entries[0 .. i-1].
> > > > +				 */
> > > > +				nr_pages =3D i;
> > > > +				goto store_pages_failed;
> > > > +			}
> > >
> > > Is it okay to use kmem_cache_free_bulk() to free slab objects that we=
re
> > > not allocated with kmem_cache_alloc_bulk()?
> >
> > I recall verifying that it should be Ok, but can check again.
> >
>=20
> I verified the code again, and yes, it is Ok for slab objects allocated b=
y
> either kmem_cache_alloc_bulk() or kmem_cache_alloc_node() to be
> freed by calling kmem_cache_free_bulk(). kmem_cache_free_bulk()
> opportunistically looks to create freelists from the list of slab objects
> to then "bulk transfer" them to the slab's freelists, with optimizations
> in synchronization as compared to calling kmem_cache_free().
>=20
> I verified this with usemem30 with the following code change in
> zswap_store_pages(), and saw no issues with deflate-iaa/zstd:
>=20
> for each of nr_pages: kmem_cache_alloc_node()
>=20
> kmem_cache_free_bulk()
>=20
> kmem_cache_alloc_bulk()
>=20
> kmem_cache_free_bulk()
>=20
> kmem_cache_alloc _bulk()
>=20
> [proceed]
>=20
> Yosry, please let me know how I should proceed and if there are
> other experiments that I can run to verify this change to bulk alloc/free
> to address any concerns.

Hi Yosry,

Just wanted to check in to get your suggestions on next steps as I start
working on v13.

Thanks for taking the time to provide code review comments!

Best regards,
Kanchana

>=20
> Thanks,
> Kanchana

