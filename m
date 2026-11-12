Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794446601;
	b=YR8JlP3DqUBQ0bZVmqdrLb80nGQ2+1+W7Lw+PpOYPi2BNY1+FBYxUSNh+tZK8UgjwLjm
	 uXo6NYN83tfxAiNFHYUTWqCq4N/s5dGQy3zs6MM+UTjZu5rykl7/HpjNqolQmU1dx5vq2
	 VD4EMXnDGbMXo18OGD1G5mmKDJUM7pf1cQwOoOldNd92PD04NebcSN7TQCcY576PoEMQB
	 p1Y7h9exowm/LcJmjbj6AN+WM491dSxC0YTZ1m9RnJTseIP4Mn3vT7JLQB4XhRNIE6eeq
	 9ladTgmw00ti22ImaMtNuDSw3+5cPjE0vI44ZZTtIWO5MBY/oF3Udktc/sNO6W8bzDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446601;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=cA6uCR8VIe7leAztjJ5roG39+Ntke2hXFHDqt0WNkkk=;
	b=SuIBErQItTOohL5cTHn7Gm91pWEq+/Y/mmiyb+TfZGRtSbe8k8e3hBC9zINgTlTtlu9L
	 lHmIMVS+kluGj9G9oFPjCqMpVs7ww6IppzHRgUlgu/a+fTa7E5o+KeIPFGgCckSIiLqng
	 K5WwWZukj0CzJO5YqanXaerj/4oZJ1GpOGdCoBhbtTzwdwKSRI0CWMyaVOYTdo7dRm1s/
	 O/BhajuGE8Hq1G8oUcgnTInVtqF8cOxhEoQ+AatSKccb8P+QHb38B6F9zAG4lYEqUJywT
	 augD7iOT3fhq2KO4lPzEnEsXQrimNgW6Pk2HS4C+YRcnbFcsPesscfyPx/6YMOK6k7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lKmC3XaG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A31C606A324;
	Thu, 12 Nov 2026 01:23:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A31C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lKmC3XaG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794446601; x=1825982601;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cA6uCR8VIe7leAztjJ5roG39+Ntke2hXFHDqt0WNkkk=;
  b=lKmC3XaGyQvYGo+kEdC53S6u+VvQ5m72RChtK2jzRu3vuNUjLd8PEyc2
   lPqDj5M682aD6z/cnLXkCM1YuHjxHFZ24Aheaa1v8LYbVxH/EZPImUfcN
   YzQIgtSbzaeobeP/1Q+A0ueQe0iuBQncQrAivbBVq4f62qC1FB6JHAWUw
   vdyNhTPy85Go03Y3UWYJOsJCcybqvqdpg2GkP9iDfpGTrtrMPvqwCXb8t
   TKVHiIKHBeNGu8ddteTrzoGSWMWMr6sL2P7AqhcRq9xnng7e815TWAMQJ
   IBGJiPZpJZA41kSJZWTp0xHBH3TdZ0IouBUOyaD0Lws+HadllJIlt/Xm+
   w==;
X-CSE-ConnectionGUID: UnzBxFmfTom2yh3pP2xQZg==
X-CSE-MsgGUID: A97czxw+SsGl3j4xWdcN2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3117920"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3117920"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 17:23:21 -0800
X-CSE-ConnectionGUID: KhhMTgHPQamowe6u6ZmxTw==
X-CSE-MsgGUID: hSWzyHXkSBizyXVckXtc1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8420589"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 17:23:20 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 17:23:19 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 11 Nov 2026 17:23:19 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 17:23:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUmBZgS34RE7CUy7DqceUq6CdRgOinBRcqRXxVqNZiemc1C31eFXqObM+Qp8RzXeatQkXyaDKCQPEctf1SJvcLxNCoEN5R81/wNhh1JNnUFY2a+W6iuWQtb3kytrY2MJmAvbIhHWuLaR2R7hZqZJoJ1hNRA3XdbOsoznqHvOvgh7FwRbnZ/zg+ji5smBeyIUF7p70QnJBH/5u9oh93uT0AejCQPO2xPObaFVl4BvD7J9IC/LIEfJAiDtbl+yLeZ2csMvEjDqRFpX0Nv6KHcwJNSBLcc7qZLWzWpMlhrgR8M90nOC36iJnt93U99tJXACoVHE1BIxofuwnLWEuthT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cA6uCR8VIe7leAztjJ5roG39+Ntke2hXFHDqt0WNkkk=;
 b=xRSi+ARv0fj3rM+WqY6WeWoUUXGOCjyJtsk3ek9h4HRDHPwBEx7MMp4VVU1t/39OGA/8GC5ivofPf6laBNLi1nnk8NmFzNncz/MvJyBd3GfUAMCa+5XnwPHIh6yc+Y3R/JGF9NuTbufPfzdK5veZc4ewjLc/rkWN36iyZ5LS8XCxzGXy4xJRBAKYdNsiZDs2/+TpCaACBQlnSW5OC+fMOSKOxygMx6S3vZGglYcNKwhAlctKQ+bc57FVaORtW6PlQEI9cZpndr73D1U5bxI4jUFxOzb1L1lmO42GxxPrP8jAYAvmoYAGmFdsyfFkG5aPJr+XtZYqsPbWxNbDJdNN0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB6070.namprd11.prod.outlook.com (2603:10b6:408:179::22)
 by PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 01:22:46 +0000
Received: from LV2PR11MB6070.namprd11.prod.outlook.com
 ([fe80::4c84:af62:dc60:fd9]) by LV2PR11MB6070.namprd11.prod.outlook.com
 ([fe80::4c84:af62:dc60:fd9%5]) with mapi id 15.21.0615.008; Thu, 12 Nov 2026
 01:22:46 +0000
From: "Popov, Pavel E" <pavel.e.popov@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar
	<viresh.kumar@linaro.org>, Jani Nikula <jani.nikula@linux.intel.com>, "Joonas
 Lahtinen" <joonas.lahtinen@linux.intel.com>, "Vivi, Rodrigo"
	<rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Alex Deucher
	<alexander.deucher@amd.com>, =?iso-8859-1?Q?Christian_K=F6nig?=
	<christian.koenig@amd.com>, Hans de Goede <hansg@kernel.org>,
	=?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Peter Huewe
	<peterhuewe@gmx.de>, Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Leon Romanovsky <leon@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Len Brown <lenb@kernel.org>, Sakari Ailus
	<sakari.ailus@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "David S . Miller"
	<davem@davemloft.net>, "x86@kernel.org" <x86@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/7] tpm: Include <asm/cpu_device_id.h> unconditionally
Thread-Topic: [PATCH 6/7] tpm: Include <asm/cpu_device_id.h> unconditionally
Thread-Index: AQHdcjc2diIJvqCo3U+vE4WoMv7TQ7cpmE8AgAAKUsA=
Date: Thu, 12 Nov 2026 01:22:46 +0000
Message-ID: <LV2PR11MB6070B890C1A4683EF36F5CB6B2702@LV2PR11MB6070.namprd11.prod.outlook.com>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-7-pavel.e.popov@intel.com> <avUK6uzoAJax0ZKn@kernel.org>
In-Reply-To: <avUK6uzoAJax0ZKn@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB6070:EE_|PH7PR11MB7004:EE_
x-ms-office365-filtering-correlation-id: a19cb1c4-2224-42e4-3f30-08df405b757b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|11063799006|4143699003|56012099006|261028144727099003|261026140227099003|261026121527099003|261022105027099003|38070700021|10067099003;
x-microsoft-antispam-message-info: H3fkz/+GtXcTUrJ76CMLAVyGRSA1v7o73lO6ipeACWw6MA2rvjpSBGbHLZ2ZIvwWcczjCFnh7KcwJNNc+D5xjl1CVKaH6O5wxYXlDmOAeOefS6BmKDCMAsKRIp3tPHo1RSp9UFCWgRUgoc1NPYLozeFb6eTcl0/DJ0zt8yoeC7Q0ik/5DUkaCI4TdS24pHllfkoKFRfPDiPkAYyJimOhoZCCwfdwiazSB3RsE050ftZpfjAUL5qBl3LvE2VHYqaCm6KVdiRHsx6/swy2OL+lWzG/Qrh4sXwOoYxZOTgalxWbc8D1bjutIyCGEHrlreIXVYHJhrcxy0VkcetfyqleXgSeA2jgH4kX6diXRTv5+z1CpkXkkkzNZNjH3gPEKB+J5IFY/TZiPWH6YdCHBpfDGxuoaW/FP1K3R/pYtscZPFvrZ4fZhY/bBeKw+kqglbpl5RkYw8JUadtt3sDU58K6x7rc7t9FQoGO48crKqYNX5GVJia13K5xAfmYCvN9qwtWTB0lcsVCWYq2xBmkYyIdi3fb70/6lBFgg98Q6TamVs0jQ13QJ8yZEYKBwhmY7lj8bCh73R6jZf3sh6wMDH3B4x7+gVNdTkbmHnayjYNgJbF3Q8pVsweDtOlomlOjCePuYaGobACPw57MnD//A9FTV39oidabJOaru7YkwMcLTDU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB6070.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0hnp6tC1Zjr7c1RRaNdPxqUVH/Gor31bxgkoMTtNUuaCG94KFruambQ6P4?=
 =?iso-8859-1?Q?9rPtGu7e8QBLx/O546a8U5nRqbt58FaGeIVypJv6TjOREcKZ2tBMTafAjr?=
 =?iso-8859-1?Q?ibdtA4o6gi30n55L+iTLOc3pAGvPx5s8QI4H0WGwpNFr6VGRhFVL3vXucH?=
 =?iso-8859-1?Q?DrbOxLE3DCo5Y0JTwwb3tBuJwvdIBa6FWW+Q886LFxTG92scsa6Fk3LDnx?=
 =?iso-8859-1?Q?u9U8gTLnajXAIgb+4lWxhIjfSMnvjla4LcxRS/qdRicAjpRk7jdV9r3nAM?=
 =?iso-8859-1?Q?b0KE+bLS4UplH+mzm+Kov9bn/O1pyLtoFIRcoc/YYw34NQhPyvk5mJd7g+?=
 =?iso-8859-1?Q?lka2zd2IZmui9SFO3XoTZ31eatutX0YJ4MpN3cEbqMvQrADuttL0PjZlKx?=
 =?iso-8859-1?Q?ftSeGj4yZDUk+RCvY7DU1JF41Ngk+l/mTF/9fn4W3rLX+LR2LrOjoo7hx9?=
 =?iso-8859-1?Q?EVTdPvvpQRj09ekrURunZTJ8vO0m0d5sEI3Mf02HqPkXqKiVNxDbbAyF+s?=
 =?iso-8859-1?Q?uS+kTeaIHFLB5JeWavOknehNUf6WzdilRkLqnoiwdsslflIUq2IRxjq8qC?=
 =?iso-8859-1?Q?IkBvK5pQdWq7vVmo77qMV8VtbORKOyKngAwpqIirh+spfK+n9WGYLIeJ4e?=
 =?iso-8859-1?Q?tXKrWqPBYbtQvAjzZFvm11CvBc2duh7jXdWQ22AnFEHqcn2q8riLQyOorI?=
 =?iso-8859-1?Q?Gs3mQCPLvBRcKs2hYVU5H7zNTwuiAwnDI0HUunvAQB9CrMQnuHINa/Z8rx?=
 =?iso-8859-1?Q?XUNcKyUktcnlvT+bGzY73vqyPEyG+18HTLEREB7N0Mopl5L6nppX/5zbgI?=
 =?iso-8859-1?Q?0EMixdkTbxnAUvM0yAg9ZxulQZgrJfewydA644c819mNBs2zaTkBPEv6Lz?=
 =?iso-8859-1?Q?NaqrSQPGZnyTZYVCZ+y8IRdEsEG4YthcPWf9MkJf45YfzkOMyB+sgBLxfU?=
 =?iso-8859-1?Q?QJ5hHepWFwqvrnC6iU/9ppO9SQWA3KZTwoO2teTcA4+LkbJRlIPJxeKIOj?=
 =?iso-8859-1?Q?9weGRwBhu01lQclScILcptw3DSsR1yXP8svNp0UDenyuGTo5uGPhLqqyxh?=
 =?iso-8859-1?Q?RLHuQS22xwjzFuf2PLSDtOKqGgpZG3hV/DWEHM6MhMM2+zkYiKoFoQzpu+?=
 =?iso-8859-1?Q?899Yn5dBxPEiPMfokLpeY2Fze3MQo34N+IDxfaz341KBlxly0QGvr7kCUn?=
 =?iso-8859-1?Q?B9xMdtB5Qpm1RtlHluc0vQIh4qXBxZyJFBAnD8JsMeU6BDNCLv51cL1HRO?=
 =?iso-8859-1?Q?MnihWU8GX+8Q/jPYUHVUSW6WZVRtSLNvdyZQ0uNOFs6qPDSLqx3YXG7NmR?=
 =?iso-8859-1?Q?MwDxY89TW7WpvSOBbfP5vf6x9YHHntS7S4I2DY8IToPX4TYLrKDpulrvT1?=
 =?iso-8859-1?Q?96iKgBAJG33JOrgRxATeJRpGozDEJ71H3rOG1gSKsSFWK15RpUSl6thx3z?=
 =?iso-8859-1?Q?Ou5Rm+IvqP37VjtgmuNwr3MgSLRcisduy9TPDObVNBE3ujHnMOU0/oA20v?=
 =?iso-8859-1?Q?vjCD6aqmoP+P6pNPphCc2YrNr3iWk5F72VnETrSY3h0ngrmmvKlu8ZODlv?=
 =?iso-8859-1?Q?myhFeo8//OoKjpZgqkGUXOT/grlPtupvEZF7AzVOPVfuOTZ1sdTe/ID4Nt?=
 =?iso-8859-1?Q?7Nvq53KdRveL91uwLwlPOs/muny48fsw1QX72ck91h5qNJyuPHH3tSMMij?=
 =?iso-8859-1?Q?dWT2SdmEloIppcjGv4ccVGGCh/oFo9t8HY2W+1EFMcEKuW8zgBx1nyD+FZ?=
 =?iso-8859-1?Q?pqIbvOyHO8fT9nJbJRGmgyHWQuXyxW2NIuBGmQhpDehVFkT6GZijzTqiU5?=
 =?iso-8859-1?Q?RdYJo7BZSQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Rfszv+TW3TevVLyR1gybw1zxYWiVIEVYBDAmM3RTaGKjL1JF+aiZ8eE0X0BPZKp7p+PCn7GpHWhYo4DGw2cEL1Nx14UbibaL+QfA2yoDZ6LtnqpyA3CK+b3zFrGj49+bEx2ekV9DngTVqIXMrzl310mEt1sU1jqhrxBzlQQrUT+pItLRzAZQCbY8Gvk/XGkGIQjzxjlxChl+8Y2zI8l2T7OZZGS49+ms1/dL6QuWXvaMBfj5WFKnxyVVaHQMofAr9lg+K6hKj7DExKg+iOpc06XWFufN0rmKnW1s1SHKJyFh4QEJxRnko4hA8QVLrRpE1vCBdkPkbQTvtI0Ftoez6Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB6070.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19cb1c4-2224-42e4-3f30-08df405b757b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 01:22:46.6847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wdlLmGS1HUgpRqFQYcCKvOJHe+R5cqrUXUR5gI2nhRckS0T3oZ7k238X3j/8VqgPA3fXMNt/xditiIslGldOYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
X-OriginatorOrg: intel.com

> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> Are these expected to be picked separately by subsystems?

Yes, each through its own subsystem tree, once [1] is in mainline.
The tpm patch does not build on non-x86 before that.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

Thanks,
Pavel

> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Wednesday, November 11, 2026 5:40 PM
> To: Popov, Pavel E <pavel.e.popov@intel.com>
> Cc: Rafael J. Wysocki <rafael@kernel.org>; Viresh Kumar
> <viresh.kumar@linaro.org>; Jani Nikula <jani.nikula@linux.intel.com>; Joo=
nas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Vivi, Rodrigo
> <rodrigo.vivi@intel.com>; Tvrtko Ursulin <tursulin@ursulin.net>; Alex Deu=
cher
> <alexander.deucher@amd.com>; Christian K=F6nig
> <christian.koenig@amd.com>; Hans de Goede <hansg@kernel.org>; Ilpo
> J=E4rvinen <ilpo.jarvinen@linux.intel.com>; Peter Huewe
> <peterhuewe@gmx.de>; Tom Lendacky <thomas.lendacky@amd.com>;
> Herbert Xu <herbert@gondor.apana.org.au>; Leon Romanovsky
> <leon@kernel.org>; Bjorn Helgaas <bhelgaas@google.com>; Logan Gunthorpe
> <logang@deltatee.com>; Arnd Bergmann <arnd@arndb.de>; Len Brown
> <lenb@kernel.org>; Sakari Ailus <sakari.ailus@linux.intel.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; David Airlie <airlied@gmail.com>; Simona Vetter
> <simona@ffwll.ch>; David S . Miller <davem@davemloft.net>;
> x86@kernel.org; linux-acpi@vger.kernel.org; linux-pm@vger.kernel.org; int=
el-
> gfx@lists.freedesktop.org; amd-gfx@lists.freedesktop.org; dri-
> devel@lists.freedesktop.org; platform-driver-x86@vger.kernel.org; linux-
> integrity@vger.kernel.org; linux-crypto@vger.kernel.org; linux-
> arch@vger.kernel.org; linux-pci@vger.kernel.org; linux-kernel@vger.kernel=
.org
> Subject: Re: [PATCH 6/7] tpm: Include <asm/cpu_device_id.h> unconditional=
ly
>=20
> On Wed, Nov 11, 2026 at 04:48:19PM -0700, Pavel Popov wrote:
> > <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> > CONFIG_X86 around the include is no longer needed.
> >
> > Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
>=20
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>=20
> Are these expected to be picked separately by subsystems?
>=20
> Br, Jarkko
