Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814B83EBF1F;
	Sun,  1 Feb 2026 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769914410; cv=fail; b=b+ydNG4tNhLniKLCa+AF9lLVl3hndVVENspq/bMhgsTbdtiZz+Px5AVSywu913yvgMnzjMxWyBw4/oNgceMrmdG/K1ArVbGvv4/rF3ADLjpqcK8z3XmfX+ClrTJs0Zs1mIFz4MxttFMcfH10gy2Wv+cBu2ce5fp+yJQv98kb7/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769914410; c=relaxed/simple;
	bh=g+cIjgfM880x+KXPpEQjvSxG4jxgJvoC+nf+9eOraug=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AItOPkPkBTAGLJnrbzxXOzZJ4QzWN4vXN7Lm0QBJaGKg0mn+/R7n8H7uSr8P9tUu2/2zBzxq5X1zArO7ljoFEMBQDasmnd9aKxr6S8EbX5a0AsDKjFlfNhOX/lBaLIFSzoVy85P31YX505LkwuY3C/ATISQI8pVCQptLxSPT6ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jHOLBUb3; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jHOLBUb3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769914409; x=1801450409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g+cIjgfM880x+KXPpEQjvSxG4jxgJvoC+nf+9eOraug=;
  b=jHOLBUb3rRvYYfdspC4z4ARKx3RoVvVkROU2nzYn4xpJmWpKTplkyAxQ
   +0fyw3zEs8cpmeiW6wQsqsov3oyrwXJpZI8641I6KMhl4wVCjLhTLDlXP
   YFPwPIiyskwvvKEJGoGTWb/NeS70wgNbWI503zwakTNgKLCxb68NNJZ+6
   NsxpjBlCk4m76vArYihvzgPiir1oT0bByj8SMETfWMREptOpKA+V3ytTV
   a7oFGQqQCgGweKwzwyjjJYpHiTW2sfygsw63XM4uJdmO0wk6hyaArgZIx
   Mp1buJM7rF0NF3s6br4fF1fDHvG4KKmoZgctqVQscFzr9SXEBM6KIewUy
   g==;
X-CSE-ConnectionGUID: 3PH8Y8AISbyCnOHKxOj5kQ==
X-CSE-MsgGUID: aQq0vT8WS7uGFEpx40o98Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11688"; a="74969133"
X-IronPort-AV: E=Sophos;i="6.21,266,1763452800"; 
   d="scan'208";a="74969133"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 18:53:28 -0800
X-CSE-ConnectionGUID: ZygPpVzNSeSucILsEgKdTg==
X-CSE-MsgGUID: 0w8Ph7WNRmSarcRDPHMF2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,266,1763452800"; 
   d="scan'208";a="209534674"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 18:53:27 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 18:53:27 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 31 Jan 2026 18:53:27 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 18:53:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8yhvA8m4HeyQpj3I5r0MCv9G/lalyP+muoRKtHac8tkG76EmLX13mkHVWv0jaeE+bcXE8COoJPn6UgmwjNPmFZuDKzOSDoTjuQLHxoJL4i1tPq+VauzYn9RYhIN0NdGwoZ6WrWDbS9C/Mk8YvAyQ2lBZtKYJyPQQeKwqGl3+HeuUuoWFTBa2ff/QYVgUWAisI7/5OUr9u5CNZkzY/LMP7YnrRPJ/tzqyZcfhtBN/j4KqM0NvzJ/J3ZZlOZAWwWZNktjieI1QlLJNwjj0c4GiiL8LgrAfY/ELZMjtM6qmYkKCXTKRsjWBVmverTLaHPsPRVTPn+k4TCw50GgA3ztRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+cIjgfM880x+KXPpEQjvSxG4jxgJvoC+nf+9eOraug=;
 b=DfJKKPZepTmaYOMq7IjPe/qZLHJ3qwOSNaAcH3rfubN9GVGgSJIw25srkGx+26rVDsqtyft68yeyyuIt179tz+Oq2+vbZCHi9Tsia+Pbo3Ir391Yya/n8ab2k2rQju8vQDFpglFl0F2/yFmmW/90uLw52UJyRMYgdyOMCgetQ05rYKH1cYR3LU1SF9lkSANRjHEGemPZ/8/IwSMylqWuMhas+lttKQ9FTW38M1B+I9PHx+IhIQ+3+7Hr0DwVH79Avt3mAbrMXZZrTBhrjXP17tRb4dST0dlXQh0+qbLP9SuQmnsW2Mg+2bZM8/CwBZ/OogfswTAE97ywR0DvMIvRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by CO1PR11MB4834.namprd11.prod.outlook.com (2603:10b6:303:90::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Sun, 1 Feb
 2026 02:53:19 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9564.014; Sun, 1 Feb 2026
 02:53:18 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
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
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Thread-Topic: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Thread-Index: AQHcjavINWdijqC6NE22B4mO/Dl5lrVrggWAgAFBfSCAAEotgIAAIk0w
Date: Sun, 1 Feb 2026 02:53:18 +0000
Message-ID: <SJ2PR11MB847268ABD6F084E87CC5F5A4C99DA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
 <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
 <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <CAKEwX=PqWQ_39BuApc_bT1WKQMJyNPDs+Gv0JAU5cTa1KNDj9g@mail.gmail.com>
In-Reply-To: <CAKEwX=PqWQ_39BuApc_bT1WKQMJyNPDs+Gv0JAU5cTa1KNDj9g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|CO1PR11MB4834:EE_
x-ms-office365-filtering-correlation-id: a05e4ae1-3b61-4d2c-8f72-08de613d0dfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S2t1RnY1cktOeG1WZldLa0FBUkVLclBPcmtoQVJnVkRnT1lUYm93NEwvZDVz?=
 =?utf-8?B?aFFhMHBjWndTdm5NOVFzR29aNmdva05XS2t5SGFXMWM3Z3JyZ295TDlBWlhQ?=
 =?utf-8?B?OWFaa1F3ekFLK2pCNHRmLzQyUXBDejNyU3kvV001R1NZNGFDeFNQZWV4ak5J?=
 =?utf-8?B?RHIvdTVsN1oyRlVTY0Z5ak1wbkw1aWQ4YitmRjMzODZDWS92MHlPblFFODBn?=
 =?utf-8?B?QUsvenE4TWg5eWJFN0hGelg3blhSMTBXTXBXeC9uaExiRGZpYlZadTlKbkJI?=
 =?utf-8?B?MG9KZHF1bFo1cXM0T1RtU2diYTUweFZhajQ4M0g0cUYxd2dJYU1tWHl5NFZQ?=
 =?utf-8?B?eTFVKy80OWdLUnlTUWl1SEl6Zm54ZHV4dEx4dmdVV3o0TjNMNVZxZUl1czZy?=
 =?utf-8?B?VXlhRDMrckRQNDlHQ0pHRDRWNHgvcW5RU3NjNkNxS2IxU3hUQURheFF1QWdY?=
 =?utf-8?B?T2JYVytkc0RTOXRXUUhMWVJpMHJDdGpJa2VwTFZBcU8wdFYvWm4zcnFGSFlZ?=
 =?utf-8?B?dUdRT01XbTlXeDl6bW54NzRHcTZyMjRhNnF2MUxGK0xTVGNaZXkvT2xWb2hw?=
 =?utf-8?B?UnRMYWRYajRtZFpia1c4cVkyeU85dmsxaDBVemNpWG1CTUpCWTVtenc4cExB?=
 =?utf-8?B?UnFIZmVRSGlBQWJGNUhIeFhmNEI4S0puSFpJYXF2Y0lacUZvWXRINHFtcno1?=
 =?utf-8?B?NWhEdkVCdlJ3Mmp2UzdmZ2xDM05IYWRvNkQzTmEydSs2K0lHTThKQjRXM01B?=
 =?utf-8?B?WHhnSlJIa2RUU3FXQmtVc0g4YmtMT2xFem4rN2l6dHFxVHMxQ2M4RllLYmZ3?=
 =?utf-8?B?TVJBV2k5U1B0QXcrSUt1bEpjbllzK3A3TEpDTlhBc09uZWhUUm55TENuamd2?=
 =?utf-8?B?dnpkZjhrUjM2WXhlSWg5Tlp0cFZUR3VXclVBNlFjR3Q3L3NXekpTdE12R1Jq?=
 =?utf-8?B?ZjdPNWtOZi9FKzAxUFhzeERGZktPRTNzcFNYdVdCZDc2YWFrY3d5RFNSdGdM?=
 =?utf-8?B?UHNFamtwbHlOakloKyt6ckVyYkRUeXFsYThRQ0d4NHhpWXpZUXc2alNaTHNC?=
 =?utf-8?B?SWhUM3ZlQ2xwdEFRbHZZaHlWNmlxUWY3ZHBFbTVhTVIzS25rSGpsVWQvSkM5?=
 =?utf-8?B?eU92cS9KZzl2elgvZ1BUdnZoc1BLTTh4T0lQaGVXSlVYaE8yRnhjSDlUSFF6?=
 =?utf-8?B?ajlJYmdSUTgwRkdVOHNuQ2RaMWxjR1JLU2pFWWNzR3ptSkJOK25KbzdaN2hD?=
 =?utf-8?B?OVdBd1JKVmZYRC8rU2cwNEliQUxZaVhXY2p4WDdqNVJPTEVTRVp2eHNwWWVU?=
 =?utf-8?B?Vm1IeTlYbU5GeW5hcnRqTGhZcTFnQ3lRVVBnZDAwQzd3Y3lLT0tWRGZ4WkUy?=
 =?utf-8?B?dDlOY1R2WGdZemhOejlVODBaSzVibXowQXpxa251VUdFekRZMjBwRUl2UG9z?=
 =?utf-8?B?UUFQKzBaRWRTYUJwdklMNVgwblR4ZE9BMURJWjZMYnI2bFhHc2cxcVdpZUQ4?=
 =?utf-8?B?ZUV4OWk2QzZSOGhpZWNFOGZwVXM3cnlybnBScHNvUDNFMHRqWkN1VDVhOWJ3?=
 =?utf-8?B?MlpmR1RWNVZQTWNOU2ljaEp4dEtSUmlFaDFXSWEvTFFQeGt4UWswdk5FWXhO?=
 =?utf-8?B?SmNocVRaSE9iWnp0QUpyRktncDZIS1FCWTRXbFlQSWxnZFFzQUhzWDFvUG1h?=
 =?utf-8?B?a0JxUERQRGNrcTNHQ1FEdXZuVkI0QUVmcWkzTXkxMENsWHNUOERSVXhSSi9z?=
 =?utf-8?B?ak43WTd0MllCTWRMaUpnb1pvVlZVQi96NW0wL0dLUTVDRVVmUDFjNzY1VGpn?=
 =?utf-8?B?RGxLRTN5bnNMblpBSm03VGg1cVJoT1BsZldaRzdOeFZJOE55Z0lZUlRYbTgr?=
 =?utf-8?B?Mms3ckdkYjhBbm9Md2M4YXZIck9jczBQYjFIRFRDQ1pXc0ZrWFFZRWtWclFM?=
 =?utf-8?B?R1JzTFYvbGVqWTNaT2MvWkc1TkJVZ3k5dFNqZXBVVDRCVVFJeDlnUTU0S2hG?=
 =?utf-8?B?K3RML2xQNS9xcHZZMGhUZUJydFBkOTllUFRERkJ3VFhpbzV1V2h1T2hkNWN1?=
 =?utf-8?B?T3p4S2QyNzJuRUUxWHJrUmhaWlRWd0dsaHg5UWg2UVQyVGhjd0FsdHgwWVlW?=
 =?utf-8?B?dnF6c2tnSWo5QjhONG00aGhOUmRvWlhwS1RMSjE0K3puSU5QWGpxemJZZUtW?=
 =?utf-8?Q?30dCIV5P3+F6xmrDxcrzgPU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE5DRnZKVEd3Z2FtdytpWDdCUjliZVFTV2Qza0ozaFJNUFd0UllGV2t3b0VK?=
 =?utf-8?B?bVpUdHl1SU1FbFFNUGNuS0x1OHQwK3NVSm1OWWZuNzl1ZlBSY3AvU2VvRVNL?=
 =?utf-8?B?L0VHQko2S0JjM3BBMmhDck9zOGVYVkJ6cTNoOG52eGUwaUEra2JiM3VVMGpX?=
 =?utf-8?B?a08xQzArbVBNVkU0VTVmckZCVVZUaHk5U2pxWGIvcWowaVJqcUFVOHpJZmN2?=
 =?utf-8?B?ODlTdlNTb3NiK1BPZWd3ZU1DaDVHTWpYeG5KQVQweDRpNHd5Q0x3SEpCOGlX?=
 =?utf-8?B?Ni9jZ25CbnRBd3oyNXJPNUtpU3d5T2NXRXhQWTFUU1lUMGR0bmpvREsweVBq?=
 =?utf-8?B?eUtvT1N5RWloa1pSVEo4VlhBcDY4c1kyZXcxWUJ6QW4vZk5reVd2OXdsVkY5?=
 =?utf-8?B?VUp3QkMwN29aRjVnMWdQSFgzQklsWVAxR0NwZ1UzN1Q3Sml5YkdMQVFVNXZa?=
 =?utf-8?B?c0x0Tys0bUFaeXp4ZXd2Ym51RzROM1Z3dVdyTG1YWnlYcklLUmlXS2ZmN3R0?=
 =?utf-8?B?R3BVNjQwMWV3MXBMRTdjMmdqQ2k5Q0gwOG9VSlJjdFlRMzU1VnpFTFFsUzdI?=
 =?utf-8?B?eGpRZ0VhMEFyY0U2MWc1K0Rlc05ndWF5U0NsTVB1bkE4YVhqR3ZZajV1YXNH?=
 =?utf-8?B?UTR6cEFoa3p5TVZ6dnBMcWFlZ2FBcnJpbnBwY0ZJczN2Mm1xbHJmZ3dxOHBN?=
 =?utf-8?B?NTNOZklISU1qRmNQWWd2VzhDYzBvSHMwSGNQTkxqVkNjZWdyaXRGK2gwbjIr?=
 =?utf-8?B?Q3ZMVnpWUCs5elh2M1dmQUVTKzlwZHMxSXFUbkUrdTNyYWRXdWlRdE9Vek1L?=
 =?utf-8?B?V3g2S2VNSzB0UHF3TGdxd0JzQkNHdXVKWjF0ejhjdUk5eGIyRFFYVHA1NVp0?=
 =?utf-8?B?RTJlTjRaOGpYRmZmOW91TXBHaDBpWFBJREhvbk1yUnJKUDV2VUtXMi9WblQy?=
 =?utf-8?B?OVhLV2NINEhBOWNMb3g5ZndQdHhFUVF5b0FoMDRaMWpQQUtUOHJnV0s3aERT?=
 =?utf-8?B?NUp3cGI3WlhHcWxTVlMrSW5ycGhrcUxBQU81UEpxYVJsTDdySzQxejRmS2di?=
 =?utf-8?B?N1VMY1hET2ordkp4V0hyMmxvYlFaRG80M0Y1MkxRVkVrakRYeEIrQjFBc2V1?=
 =?utf-8?B?YWFROTRRYlpZdlRLcERyVExERGcxcG9FdXFuRnRNeWw4TlNORDU1d0F6cUo5?=
 =?utf-8?B?eTZUZ2daWkpuRnJOdXYvdXNQY29oRnpTKzZOei95WlVlSi9LZEdCdzljOStO?=
 =?utf-8?B?alAwSEZiNWRxZVdvN1BCZTBaZmNUZlJUQ3JMSndLbXZmV2kxMWVyZFVZWXRw?=
 =?utf-8?B?dnF3UE1rSkp2TWZDTkhJeDVWSUJTdkxoM0hDUC8wOVpUVEcrR20yZ1BqL1lh?=
 =?utf-8?B?ZkExRGZpditrVFR2R29kOXloUDlTQ1JoZ0lqeVYwS3F0bXFTejU4ZGswUUJJ?=
 =?utf-8?B?N240WGkrdW41STBZY01HaEhMWjBpNTVwaFlFanpNQldSL2FPWGdDSzBaOFAx?=
 =?utf-8?B?MjZYeGFBQ1ZCZ2dHTXhBT0IvYk4weXRFWVFMdEkxNEZQS0ZDNDVEQ1hJdFVn?=
 =?utf-8?B?cE1mTklRY1NOb09ua2dFM0dZWWpTTHFMc0RvbkVlTXNBaVhGazgxSnZJK3pM?=
 =?utf-8?B?amFST09Ra1BrYXRaYTJPOEFjeE56T1JpTExRSXplVjRSUWwwdy9XTTZLRFJa?=
 =?utf-8?B?UmlnMHBNK1U3czB2QnpJTHVQUlQ2OGR6ZXBZYy9ONytqVngzcytIVGZCcWFQ?=
 =?utf-8?B?cXNFbEh1OUI5NXBHaXFsVXpyWUNUbmt6Mng4aUFZWGRsbjNnd3RlUFl0ZEls?=
 =?utf-8?B?ZmUzNzFoalVvR3JXRTB6ME02RGdyTXdQV29NWENFWEZ1ZWRRN05KYzZRUHUv?=
 =?utf-8?B?azFtb3M3a0VXaEh0RFJBNjd0MWxVKzQxdXZTNktlR0FnZnJKRkNsZWlSdlBI?=
 =?utf-8?B?NFZmN1E4MWZ3MWdUSXBaVytGQS93amNORi94eVV2cHVGVHo5Ky9LekpFdlhF?=
 =?utf-8?B?OG9XdXJ6VjJ0cFFjMDllelpvdWZnckhiMTZDcGE0aU5Da1RsWWNXUmRLQU9F?=
 =?utf-8?B?YklsZTdkZnhSRjhxMXo2dGtkbnhUeDYyMXNlMVRZUmtwTzNBOENXcjJwdDhs?=
 =?utf-8?B?MGhXY1BTRk4ySWJYRmNSMmNQcHVMNGRkcklqUkxXeWpPQ2JUVk90dmJVRHht?=
 =?utf-8?B?eDFXY2hPQ1hzN2xwUFRjdDhCZXY0MnZvZmIrNm8wK2hub1FYeG1WWUxZMjVO?=
 =?utf-8?B?dm0vWC9VVGtHbkJVa29sTzZ0aFRpNjNkN3djY0tHc3kvdkZRTFA1YkZRbytN?=
 =?utf-8?B?ZVRPL3ZDQ3V1L3VDQjRJK28vZ3B0bzYwQzNlTVBUUTRoRkFDVHUzaW1BMDVy?=
 =?utf-8?Q?dcGxvo53RHkRaIBEqnshSeM00affH4EOZnGsYavDa683l?=
x-ms-exchange-antispam-messagedata-1: D7iCxkDT89eLxrkcTqW9UJzSOP8zpSMdVrs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05e4ae1-3b61-4d2c-8f72-08de613d0dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2026 02:53:18.8314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JVN2ne0QtV4PMdSAm9UhIzQLMcvTzm84a0nYfMLl6wjru7eELeG6J4AiHffx6iz4szkmY7+CFnvG2OXeSRviX069Svr29PLbjZUv1wTh7+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4834
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBKYW51YXJ5IDMxLCAyMDI2IDQ6NDkgUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBjaGVuZ21pbmcu
emhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0c0Bh
cm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gc2Vub3poYXRza3lAY2hyb21pdW0ub3Jn
OyBzakBrZXJuZWwub3JnOyBrYXNvbmdAdGVuY2VudC5jb207IGxpbnV4LQ0KPiBjcnlwdG9Admdl
ci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IGNsYWJiZUBiYXlsaWJyZS5jb207IGFyZGJAa2VybmVsLm9yZzsNCj4gZWJpZ2dl
cnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdvb2dsZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQw0KPiA8
a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzIDx2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb20+Ow0KPiBDYWJpZGR1LCBHaW92YW5uaSA8Z2lvdmFubmkuY2FiaWRkdUBp
bnRlbC5jb20+OyBGZWdoYWxpLCBXYWpkaSBLDQo+IDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxNCAyNi8yNl0gbW06IHpzd2FwOiBCYXRjaGVkIHpz
d2FwX2NvbXByZXNzKCkgZm9yDQo+IGNvbXByZXNzIGJhdGNoaW5nIG9mIGxhcmdlIGZvbGlvcy4N
Cj4gDQo+IE9uIFNhdCwgSmFuIDMxLCAyMDI2IGF0IDEyOjMy4oCvUE0gU3JpZGhhciwgS2FuY2hh
bmEgUA0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPg0K
PiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IE5oYXQgUGhhbSA8
bnBoYW1jc0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIEphbnVhcnkgMzAsIDIwMjYg
NToxMyBQTQ0KPiA+ID4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhh
ckBpbnRlbC5jb20+DQo+ID4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGlu
dXgtbW1Aa3ZhY2sub3JnOw0KPiA+ID4gaGFubmVzQGNtcHhjaGcub3JnOyB5b3NyeS5haG1lZEBs
aW51eC5kZXY7DQo+IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsNCj4gPiA+IHVzYW1hYXJpZjY0
MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4g
PiA+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFrcG1AbGludXgtZm91bmRhdGlvbi5v
cmc7DQo+ID4gPiBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IHNqQGtlcm5lbC5vcmc7IGthc29u
Z0B0ZW5jZW50LmNvbTsgbGludXgtDQo+ID4gPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBoZXJi
ZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+ID4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFi
YmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+ID4gPiBlYmlnZ2Vyc0Bnb29nbGUu
Y29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+ID4gPiA8a3Jpc3Rl
bi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzDQo+IDx2aW5pY2l1cy5nb21l
c0BpbnRlbC5jb20+Ow0KPiA+ID4gQ2FiaWRkdSwgR2lvdmFubmkgPGdpb3Zhbm5pLmNhYmlkZHVA
aW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA+ID4gPHdhamRpLmsuZmVnaGFsaUBpbnRl
bC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxNCAyNi8yNl0gbW06IHpzd2FwOiBC
YXRjaGVkIHpzd2FwX2NvbXByZXNzKCkNCj4gZm9yDQo+ID4gPiBjb21wcmVzcyBiYXRjaGluZyBv
ZiBsYXJnZSBmb2xpb3MuDQo+ID4gPg0KPiA+ID4gT24gU2F0LCBKYW4gMjQsIDIwMjYgYXQgNzoz
NuKAr1BNIEthbmNoYW5hIFAgU3JpZGhhcg0KPiA+ID4gPGthbmNoYW5hLnAuc3JpZGhhckBpbnRl
bC5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBXZSBpbnRyb2R1Y2UgYSBuZXcgYmF0Y2hp
bmcgaW1wbGVtZW50YXRpb24gb2YgenN3YXBfY29tcHJlc3MoKSBmb3INCj4gPiA+ID4gY29tcHJl
c3NvcnMgdGhhdCBkbyBhbmQgZG8gbm90IHN1cHBvcnQgYmF0Y2hpbmcuIFRoaXMgZWxpbWluYXRl
cyBjb2RlDQo+ID4gPiA+IGR1cGxpY2F0aW9uIGFuZCBmYWNpbGl0YXRlcyBjb2RlIG1haW50YWlu
YWJpbGl0eSB3aXRoIHRoZSBpbnRyb2R1Y3Rpb24NCj4gPiA+ID4gb2YgY29tcHJlc3MgYmF0Y2hp
bmcuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSB2ZWN0b3JpemVkIGltcGxlbWVudGF0aW9uIG9mIGNh
bGxpbmcgdGhlIGVhcmxpZXIgenN3YXBfY29tcHJlc3MoKQ0KPiA+ID4gPiBzZXF1ZW50aWFsbHks
IG9uZSBwYWdlIGF0IGEgdGltZSBpbiB6c3dhcF9zdG9yZV9wYWdlcygpLCBpcyByZXBsYWNlZA0K
PiA+ID4gPiB3aXRoIHRoaXMgbmV3IHZlcnNpb24gb2YgenN3YXBfY29tcHJlc3MoKSB0aGF0IGFj
Y2VwdHMgbXVsdGlwbGUgcGFnZXMNCj4gdG8NCj4gPiA+ID4gY29tcHJlc3MgYXMgYSBiYXRjaC4N
Cj4gPiA+ID4NCj4gPiA+ID4gSWYgdGhlIGNvbXByZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBiYXRj
aGluZywgZWFjaCBwYWdlIGluIHRoZSBiYXRjaCBpcw0KPiA+ID4gPiBjb21wcmVzc2VkIGFuZCBz
dG9yZWQgc2VxdWVudGlhbGx5LiBJZiB0aGUgY29tcHJlc3NvciBzdXBwb3J0cw0KPiBiYXRjaGlu
ZywNCj4gPiA+ID4gZm9yIGUuZy4sICdkZWZsYXRlLWlhYScsIHRoZSBJbnRlbCBJQUEgaGFyZHdh
cmUgYWNjZWxlcmF0b3IsIHRoZSBiYXRjaA0KPiA+ID4gPiBpcyBjb21wcmVzc2VkIGluIHBhcmFs
bGVsIGluIGhhcmR3YXJlLg0KPiA+ID4gPg0KPiA+ID4gPiBJZiB0aGUgYmF0Y2ggaXMgY29tcHJl
c3NlZCB3aXRob3V0IGVycm9ycywgdGhlIGNvbXByZXNzZWQgYnVmZmVycyBmb3INCj4gPiA+ID4g
dGhlIGJhdGNoIGFyZSBzdG9yZWQgaW4genNtYWxsb2MuIEluIGNhc2Ugb2YgY29tcHJlc3Npb24g
ZXJyb3JzLCB0aGUNCj4gPiA+ID4gY3VycmVudCBiZWhhdmlvciBiYXNlZCBvbiB3aGV0aGVyIHRo
ZSBmb2xpbyBpcyBlbmFibGVkIGZvciB6c3dhcA0KPiA+ID4gPiB3cml0ZWJhY2ssIGlzIHByZXNl
cnZlZC4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIGJhdGNoZWQgenN3YXBfY29tcHJlc3MoKSBpbmNv
cnBvcmF0ZXMgSGVyYmVydCdzIHN1Z2dlc3Rpb24gZm9yDQo+ID4gPiA+IFNHIGxpc3RzIHRvIHJl
cHJlc2VudCB0aGUgYmF0Y2gncyBpbnB1dHMvb3V0cHV0cyB0byBpbnRlcmZhY2Ugd2l0aCB0aGUN
Cj4gPiA+ID4gY3J5cHRvIEFQSSBbMV0uDQo+ID4gPiA+DQo+ID4gPiA+IFBlcmZvcm1hbmNlIGRh
dGE6DQo+ID4gPiA+ID09PT09PT09PT09PT09PT09DQo+ID4gPiA+IEFzIHN1Z2dlc3RlZCBieSBC
YXJyeSwgdGhpcyBpcyB0aGUgcGVyZm9ybWFuY2UgZGF0YSBnYXRoZXJlZCBvbiBJbnRlbA0KPiA+
ID4gPiBTYXBwaGlyZSBSYXBpZHMgd2l0aCB0d28gd29ya2xvYWRzOg0KPiA+ID4gPg0KPiA+ID4g
PiAxKSAzMCB1c2VtZW0gcHJvY2Vzc2VzIGluIGEgMTUwIEdCIG1lbW9yeSBsaW1pdGVkIGNncm91
cCwgZWFjaA0KPiA+ID4gPiAgICBhbGxvY2F0ZXMgMTBHLCBpLmUsIGVmZmVjdGl2ZWx5IHJ1bm5p
bmcgYXQgNTAlIG1lbW9yeSBwcmVzc3VyZS4NCj4gPiA+ID4gMikga2VybmVsX2NvbXBpbGF0aW9u
ICJkZWZjb25maWciLCAzMiB0aHJlYWRzLCBjZ3JvdXAgbWVtb3J5IGxpbWl0IHNldA0KPiA+ID4g
PiAgICB0byAxLjcgR2lCICg1MCUgbWVtb3J5IHByZXNzdXJlLCBzaW5jZSBiYXNlbGluZSBtZW1v
cnkgdXNhZ2UgaXMgMy40DQo+ID4gPiA+ICAgIEdpQik6IGRhdGEgYXZlcmFnZWQgYWNyb3NzIDEw
IHJ1bnMuDQo+ID4gPiA+DQo+ID4gPiA+IFRvIGtlZXAgY29tcGFyaXNvbnMgc2ltcGxlLCBhbGwg
dGVzdGluZyB3YXMgZG9uZSB3aXRob3V0IHRoZQ0KPiA+ID4gPiB6c3dhcCBzaHJpbmtlci4NCj4g
PiA+ID4NCj4gPiA+ID4NCj4gPiA+DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4gPiA9PT09PT09PT09PQ0KPiA+ID4g
PiAgIElBQSAgICAgICAgICAgICAgICAgbW0tdW5zdGFibGUtMS0yMy0yMDI2ICAgICAgICAgICAg
IHYxNA0KPiA+ID4gPg0KPiA+ID4NCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiA+ID09PT09PT09PT09DQo+ID4gPiA+
ICAgICB6c3dhcCBjb21wcmVzc29yICAgICAgICAgICAgZGVmbGF0ZS1pYWEgICAgIGRlZmxhdGUt
aWFhICAgSUFBIEJhdGNoaW5nDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZzLg0KPiA+ID4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJQUEg
U2VxdWVudGlhbA0KPiA+ID4gPg0KPiA+ID4NCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiA+ID09PT09PT09PT09DQo+
ID4gPiA+ICB1c2VtZW0zMCwgNjRLIGZvbGlvczoNCj4gPiA+ID4NCj4gPiA+ID4gICAgIFRvdGFs
IHRocm91Z2hwdXQgKEtCL3MpICAgICAgIDYsMjI2LDk2NyAgICAgIDEwLDU1MSw3MTQgICAgICAg
NjklDQo+ID4gPiA+ICAgICBBdmVyYWdlIHRocm91Z2hwdXQgKEtCL3MpICAgICAgIDIwNyw1NjUg
ICAgICAgICAzNTEsNzIzICAgICAgIDY5JQ0KPiA+ID4gPiAgICAgZWxhcHNlZCB0aW1lIChzZWMp
ICAgICAgICAgICAgICAgIDk5LjE5ICAgICAgICAgICA2Ny40NSAgICAgIC0zMiUNCj4gPiA+ID4g
ICAgIHN5cyB0aW1lIChzZWMpICAgICAgICAgICAgICAgICAyLDM1Ni4xOSAgICAgICAgMSw1ODAu
NDcgICAgICAtMzMlDQo+ID4gPiA+DQo+ID4gPiA+ICB1c2VtZW0zMCwgUE1EIGZvbGlvczoNCj4g
PiA+ID4NCj4gPiA+ID4gICAgIFRvdGFsIHRocm91Z2hwdXQgKEtCL3MpICAgICAgIDYsMzQ3LDIw
MSAgICAgIDExLDMxNSw1MDAgICAgICAgNzglDQo+ID4gPiA+ICAgICBBdmVyYWdlIHRocm91Z2hw
dXQgKEtCL3MpICAgICAgIDIxMSw1NzMgICAgICAgICAzNzcsMTgzICAgICAgIDc4JQ0KPiA+ID4g
PiAgICAgZWxhcHNlZCB0aW1lIChzZWMpICAgICAgICAgICAgICAgIDg4LjE0ICAgICAgICAgICA2
My4zNyAgICAgIC0yOCUNCj4gPiA+ID4gICAgIHN5cyB0aW1lIChzZWMpICAgICAgICAgICAgICAg
ICAyLDAyNS41MyAgICAgICAgMSw0NTUuMjMgICAgICAtMjglDQo+ID4gPiA+DQo+ID4gPiA+ICBr
ZXJuZWxfY29tcGlsYXRpb24sIDY0SyBmb2xpb3M6DQo+ID4gPiA+DQo+ID4gPiA+ICAgICBlbGFw
c2VkIHRpbWUgKHNlYykgICAgICAgICAgICAgICAxMDAuMTAgICAgICAgICAgIDk4Ljc0ICAgICAt
MS40JQ0KPiA+ID4gPiAgICAgc3lzIHRpbWUgKHNlYykgICAgICAgICAgICAgICAgICAgMzA4Ljcy
ICAgICAgICAgIDMwMS4yMyAgICAgICAtMiUNCj4gPiA+ID4NCj4gPiA+ID4gIGtlcm5lbF9jb21w
aWxhdGlvbiwgUE1EIGZvbGlvczoNCj4gPiA+ID4NCj4gPiA+ID4gICAgIGVsYXBzZWQgdGltZSAo
c2VjKSAgICAgICAgICAgICAgICA5NS4yOSAgICAgICAgICAgOTMuNDQgICAgIC0xLjklDQo+ID4g
PiA+ICAgICBzeXMgdGltZSAoc2VjKSAgICAgICAgICAgICAgICAgICAzNDYuMjEgICAgICAgICAg
MzQ0LjQ4ICAgICAtMC41JQ0KPiA+ID4gPg0KPiA+ID4NCj4gPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiA+ID09PT09PT09
PT09DQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPg0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+ID4gPT09PT09PT09PT0N
Cj4gPiA+ID4gICBaU1REICAgICAgICAgICAgICAgIG1tLXVuc3RhYmxlLTEtMjMtMjAyNiAgICAg
ICAgICAgICB2MTQNCj4gPiA+ID4NCj4gPiA+DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4gPiA9PT09PT09PT09PQ0K
PiA+ID4gPiAgICAgenN3YXAgY29tcHJlc3NvciAgICAgICAgICAgICAgICAgICB6c3RkICAgICAg
ICAgICAgenN0ZCAgICAgdjE0IFpTVEQNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEltcHJvdmVtZW50DQo+ID4gPiA+
DQo+ID4gPg0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KPiA+ID4gPT09PT09PT09PT0NCj4gPiA+ID4gIHVzZW1lbTMwLCA2
NEsgZm9saW9zOg0KPiA+ID4gPg0KPiA+ID4gPiAgICAgVG90YWwgdGhyb3VnaHB1dCAoS0Ivcykg
ICAgICAgNiwwMzIsMzI2ICAgICAgIDYsMDQ3LDQ0OCAgICAgIDAuMyUNCj4gPiA+ID4gICAgIEF2
ZXJhZ2UgdGhyb3VnaHB1dCAoS0IvcykgICAgICAgMjAxLDA3NyAgICAgICAgIDIwMSw1ODEgICAg
ICAwLjMlDQo+ID4gPiA+ICAgICBlbGFwc2VkIHRpbWUgKHNlYykgICAgICAgICAgICAgICAgOTcu
NTIgICAgICAgICAgIDk1LjMzICAgICAtMi4yJQ0KPiA+ID4gPiAgICAgc3lzIHRpbWUgKHNlYykg
ICAgICAgICAgICAgICAgIDIsNDE1LjQwICAgICAgICAyLDMyOC4zOCAgICAgICAtNCUNCj4gPiA+
ID4NCj4gPiA+ID4gIHVzZW1lbTMwLCBQTUQgZm9saW9zOg0KPiA+ID4gPg0KPiA+ID4gPiAgICAg
VG90YWwgdGhyb3VnaHB1dCAoS0IvcykgICAgICAgNiw1NzAsNDA0ICAgICAgIDYsNjIzLDk2MiAg
ICAgIDAuOCUNCj4gPiA+ID4gICAgIEF2ZXJhZ2UgdGhyb3VnaHB1dCAoS0IvcykgICAgICAgMjE5
LDAxMyAgICAgICAgIDIyMCw3OTggICAgICAwLjglDQo+ID4gPiA+ICAgICBlbGFwc2VkIHRpbWUg
KHNlYykgICAgICAgICAgICAgICAgODkuMTcgICAgICAgICAgIDg4LjI1ICAgICAgIC0xJQ0KPiA+
ID4gPiAgICAgc3lzIHRpbWUgKHNlYykgICAgICAgICAgICAgICAgIDIsMTI2LjY5ICAgICAgICAy
LDA0My4wOCAgICAgICAtNCUNCj4gPiA+ID4NCj4gPiA+ID4gIGtlcm5lbF9jb21waWxhdGlvbiwg
NjRLIGZvbGlvczoNCj4gPiA+ID4NCj4gPiA+ID4gICAgIGVsYXBzZWQgdGltZSAoc2VjKSAgICAg
ICAgICAgICAgIDEwMC44OSAgICAgICAgICAgOTkuOTggICAgIC0wLjklDQo+ID4gPiA+ICAgICBz
eXMgdGltZSAoc2VjKSAgICAgICAgICAgICAgICAgICA0MTcuNDkgICAgICAgICAgNDE0LjYyICAg
ICAtMC43JQ0KPiA+ID4gPg0KPiA+ID4gPiAga2VybmVsX2NvbXBpbGF0aW9uLCBQTUQgZm9saW9z
Og0KPiA+ID4gPg0KPiA+ID4gPiAgICAgZWxhcHNlZCB0aW1lIChzZWMpICAgICAgICAgICAgICAg
IDk4LjI2ICAgICAgICAgICA5Ny4zOCAgICAgLTAuOSUNCj4gPiA+ID4gICAgIHN5cyB0aW1lIChz
ZWMpICAgICAgICAgICAgICAgICAgIDQ4Ny4xNCAgICAgICAgICA0NzMuMTYgICAgIC0yLjklDQo+
ID4gPiA+DQo+ID4gPg0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+ID4gPT09PT09PT09PT0NCj4gPiA+DQo+ID4gPiBU
aGUgcmVzdCBvZiB0aGUgcGF0Y2ggY2hhbmdlbG9nIChhcmNoaXRlY3R1cmFsIGFuZCBmdXR1cmUN
Cj4gPiA+IGNvbnNpZGVyYXRpb25zKSAgY2FuIHN0YXkgaW4gdGhlIGNvdmVyIGxldHRlci4gTGV0
J3Mgbm90IGR1cGxpY2F0ZQ0KPiA+ID4gaW5mb3JtYXRpb24gOikNCj4gPiA+DQo+ID4gPiBLZWVw
IHRoZSBwYXRjaCBjaGFuZ2Vsb2cgbGltaXRlZCB0byBvbmx5IHRoZSBjaGFuZ2VzIGluIHRoZSBw
YXRjaA0KPiA+ID4gaXRzZWxmICh1bmxlc3Mgd2UgbmVlZCBzb21lIGNsYXJpZmljYXRpb25zIGlt
bWluZW50bHkgcmVsZXZhbnQpLg0KPiA+DQo+ID4gSGkgTmhhdCwNCj4gPg0KPiA+IFRoYW5rcyBm
b3IgdGhpcyBjb21tZW50LiBZb3NyeSBoYWQgYWxzbyBwb2ludGVkIHRoaXMgb3V0IGluIFsxXS4g
SSBoYXZlDQo+ID4gYmVlbiBpbmNsdWRpbmcgdGhlIGFyY2hpdGVjdHVyYWwgYW5kIGZ1dHVyZSBj
b25zaWRlcmF0aW9ucyBpbiB0aGlzIGNoYW5nZSBsb2cNCj4gPiBzaW5jZSBBbmRyZXcgaGFkIGFz
a2VkIG1lIHRvIGRvIHNvLiBJIGhvcGUgdGhpcyBpcyBPaz8NCj4gDQo+IEFoIGhtbW1tbS4gRm9y
IHNvbWUgcmVhc29ucyBJIHdhcyB1bmRlciB0aGUgYXNzdW1wdGlvbiB0aGF0IHVzdWFsbHkNCj4g
QW5kcmV3IHdvdWxkIGNvbmNhdGVuYXRlIHRoZSBwYXRjaCBjb3ZlciBsZXR0ZXIgYW5kIHRoZSBw
YXRjaA0KPiBjaGFuZ2Vsb2cgYmVmb3JlIG1lcmdpbmcuIE9oIHdlbGwuDQo+IA0KPiBJZiBBbmRy
ZXcgcHJlZmVycyBpbmNsdWRpbmcgdGhhdCBoZXJlIHRoZW4gSSdtIGZpbmUgd2l0aCBpdC4NCg0K
T2ssIHRoYW5rIHlvdSBOaGF0IQ0KDQpCZXN0IHJlZ2FyZHMsDQpLYW5jaGFuYQ0KDQo+IA0KPiA+
DQo+ID4gWzFdOiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL2NvbW1lbnQvMjY3MDYyNDAv
DQo+ID4NCj4gPiA+DQo+ID4gPiBJJ2xsIHJldmlldyB0aGUgcmVtYWluZGVyIG9mIHRoZSBwYXRj
aCBsYXRlciA6KQ0KPiA+DQo+ID4gU3VyZS4NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBLYW5jaGFu
YQ0K
