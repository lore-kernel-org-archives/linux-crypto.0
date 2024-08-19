Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530B516BE1D;
	Mon, 19 Aug 2024 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073255; cv=fail; b=otKocTFGORhKiaK3o62h5MNxQdOhlJYOdbGux6VdaruQc7M9mwsYygsPHZFXPvJDVjXlBaMIUIP2IDW61Y4h+9ZzCA1DohvGvDvjfYNLFMT6J4pNLc/iK/QoQJLIIkjoTDQvT1B/20RaVehEyi7CuIQLXyIpSChSrRx7rJTsyyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073255; c=relaxed/simple;
	bh=QYbum3gtNQr+jPEPYJ6+AH4hI18a/q0ByWUFlGOZioo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=URrq83JtCFq4foo01ydwb5ufz+ghRhTqhF5vsmn9z9Rh+Y7MHKHgnJl16B/48mpQdBhnVw7NUim+bzb+zpYjJRjb5MgLTm06GcQ/GZ7thtyU2cardY03BAW4SIws8czLM4uA6IK+bDkcE80wZfkd7KJ9JXUonhDx3ti6cOnt0jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TesbaYll; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TesbaYll"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724073253; x=1755609253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QYbum3gtNQr+jPEPYJ6+AH4hI18a/q0ByWUFlGOZioo=;
  b=TesbaYllOIcakaGkidIp1DgzQr3uChG9tPBNzWj1jx3tDnjO7z8RLH5Z
   WI3JJFxo+iG47R0b5nNGV11Vo8BTs9jotSgjDaBvQa5ed7Oqd/tjVpdWE
   sq1ntpKn3hb/mpatsCsTVjkYAzgyEX3jmqKTBiLCTWrUJy/LALybjdO4e
   of/vnGPmsZ6QTawFFkCvCHLImHZk6j4UuFO+4Xd7gzd+d0XMz+0gpbtdE
   r6yjWEuUNieKbSU+VTuLp2HUfLSKfvesE9n/+30rSNh/8IjHqacnCN0f+
   NzR5/mezOLRt8Zxk+bb/0SvpaKxkYoo58MyhOu2nb37KMf2Lg0D9cSlhj
   A==;
X-CSE-ConnectionGUID: AaEduAU6SGyHSJxtVcPJhg==
X-CSE-MsgGUID: M7wR5KbCT9GZM7mapGb+Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="21940731"
X-IronPort-AV: E=Sophos;i="6.10,159,1719903600"; 
   d="scan'208";a="21940731"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 06:14:12 -0700
X-CSE-ConnectionGUID: rsJSjG3RRM2hAG05CPiS3A==
X-CSE-MsgGUID: tSicnCFMT4+Ih4wEsMl5jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,159,1719903600"; 
   d="scan'208";a="60348389"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Aug 2024 06:14:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 06:14:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 06:14:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 19 Aug 2024 06:14:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 06:14:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YLDMASEavd5bjICAEVdPGguzc1hT7BH0sgKZwYXLjexk5nh12CDCIr9c2hsI6CgQs0ezmEFAofLRNKc+7OZhVgDEKctR2EN8JMKqNEqDP3kJhkmjqOFvxzytC5pGCUkHYyIOsUbzFwmHxqXtpaWcpicPHX0eYuV8AD6OUBhUjD51LksLgyLoppjm+KNLjdmHWvMuZG+MLdjV/RSAbq0NKy5mLvJdVAnmWRnlvAa3yYeoSme+pbEBczA6V8SuFbdQ+aMpwxFSAnCYKFCLPvNtToPQ6nvXuzETZBGZ1BFmPyLn0pQM29C7bz6r3RmqiWEub+a1SzdZkgMhkghe2yy5DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYbum3gtNQr+jPEPYJ6+AH4hI18a/q0ByWUFlGOZioo=;
 b=tlocS2TPtQprZAuXKWAON5XYh8EoCcGaHQVw/HPQ3Q1u880NiB18CqI5ci6W57hzp72AQ+ezZ4zH3ko0/pJRE790jL5y6pTvn0q0KHfkQ8pUXYtP1YzbfzbPHOhVpuLnOXkZ6gdjPYwIkdnbuZUJXO4BH99vQyAygL7H2wLlp4CQ+KMA6/TSyyYPkH/Nm23M+UoaegwexlUPC9HynGE4djR0h5R80PnAaxzu7Bat4WnxMlw8LosaDRVusKJsXbiTg1s+Mj9nORTIWQRMOk/D0SQVU6BcMWj59nFAqIcISRP6aoieLseCz+95HFrZsxcgFJ15cVqDJ0fSu8xU7rj4qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6759.namprd11.prod.outlook.com (2603:10b6:806:25e::10)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Mon, 19 Aug
 2024 13:14:09 +0000
Received: from SA1PR11MB6759.namprd11.prod.outlook.com
 ([fe80::3faa:5b73:8343:1ccf]) by SA1PR11MB6759.namprd11.prod.outlook.com
 ([fe80::3faa:5b73:8343:1ccf%5]) with mapi id 15.20.7828.031; Mon, 19 Aug 2024
 13:14:09 +0000
From: "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To: "liaochen4@huawei.com" <liaochen4@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: "Murphy, Declan" <declan.murphy@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH -next] crypto: keembay - fix module autoloading
Thread-Topic: [PATCH -next] crypto: keembay - fix module autoloading
Thread-Index: AQHa8jmrEhaXljkpIki19h3TXYUaSA==
Date: Mon, 19 Aug 2024 13:14:09 +0000
Message-ID: <615fb6c74c7ae90646686d58c687f03b3909bfe4.camel@intel.com>
References: <20240814024406.3875287-1-liaochen4@huawei.com>
	 <63efd8d1-e294-42f0-8b0f-ec0ceb793772@huawei.com>
In-Reply-To: <63efd8d1-e294-42f0-8b0f-ec0ceb793772@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6759:EE_|SA2PR11MB5003:EE_
x-ms-office365-filtering-correlation-id: a7288b72-9903-458f-a81b-08dcc050cfa7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?anFYdkJjVkRhMndndjlEWVNKQ2lWaHp2RFdtVXRtUGRuSTdvNTZaVFZHdUZV?=
 =?utf-8?B?WFJpdHVpTzZXTTcxQ20reUc2Zkhxdkx2SWhnNVVLSllDdDNIQklDSEN0SXQ5?=
 =?utf-8?B?eitJcGhDVlZua21JblltdEZ5TzhEQlhFUS9QWVV4VzBjcG9iNmxVbzhvamxS?=
 =?utf-8?B?SjFuK0xwNjQzWm9uRjA3RUJwb2VpT0VGN2E0NHVqUWFpTGs4S09MMHdHSWJ6?=
 =?utf-8?B?WFM4MnRjb21ud3UvZVJuMVloNktsWkF1ZGJuRkgraTltUlhtUDFzby9BU25M?=
 =?utf-8?B?M0gzcjJjZnAyZDc0ZExoYmdQcWw1QUsrNzd3ekxKQWd5S1l6bCtYSm5mb3ZB?=
 =?utf-8?B?Y2Z2M3hWbXhUMy83RFQ0L0ZvWWRZWUJFTWRCajY2VklNQXA5cGhjRi92SmNF?=
 =?utf-8?B?d25sVXJJdko1MmM0NlhVWTdPUlRwQWFOcVN6VEo0NWpLRTZVSDR3Uk5wVWc4?=
 =?utf-8?B?ZFU4WUVMOStkalZyS1dreHE0ckFCbVJibkdma0JLbUlMa3NoV2VhOGJpc1kr?=
 =?utf-8?B?ejJtTTZDRERENjVMNmJTdERvdFBJcWdCd2tpazZRVnNHS2lFb2x2MmZpdkdO?=
 =?utf-8?B?Qm5ETSt2Sk5DU09qWm1lTWtGblBYS0JGWGxSZnVQdzdlcXZuSm8rdTd3Uklp?=
 =?utf-8?B?N3o1QW5oQXRZeXorUmlXYkJxVko4R3VPdDZDUThnamFyN2ppV2ptR25sOW5G?=
 =?utf-8?B?U0s1RlFIYW1MSnRWbFB5aFg2bk16RGdLSkkvTFZXYXpyZTdmdHFUdkFWWWJT?=
 =?utf-8?B?R0lIU0ZRTXlGanRydXZNQUprQXhmRmdNMXo0UWFpV3U2Y0JxUDY3bTNIeWRt?=
 =?utf-8?B?OFl5dXZHWmpMMlZNWDl4dU92YjZsNEFwODk4VVV3MllDVzUxM2lXaCt2cHF3?=
 =?utf-8?B?cTdpVEl2Z0FjVkQ5aytEeUUzYlh0b3JBOTdsSXJVQUZsajNKMDZqc2QxYTFG?=
 =?utf-8?B?NkRGL1ZWVzJXTVNjaThyNDlTVXhJRFFjRnF3eDk4cWw3cUMzUURIczdiZ2ZK?=
 =?utf-8?B?TkI3dnRnNFBjTEZtMWtFZUVSOFhIcHpYWVJnRThkZnRacWd1MC84b0xoS2FY?=
 =?utf-8?B?Mjc2dmEwcGd6cUhHd3Y2bWpEK05JQXVGVlh1K0s3cjhzWDJnLzZnZld6UCt0?=
 =?utf-8?B?a2NzZUkxMnNPSUlnckZveVN5NnJUWEhjU1pxVWNMUGlDbDFRY1ptd0srZ3Rp?=
 =?utf-8?B?cmx2MkVsdGVFdnNJYjNPZEFxWDByOG1FVlF1eDk3OVBUNlZCYXlDc2FKaGFL?=
 =?utf-8?B?M0NCbUNZOGZvRTBacm93NkM5VjhmbENJWG9yOThxU08vUHBKa1ZYTW1UQWE0?=
 =?utf-8?B?YU1wQUtBZXJpUmszdzBCNGVuaUtweVhoNmVjMnF4NkNPTU9vQzlETGFrRUVT?=
 =?utf-8?B?cHJvb3dUcGcrL1o0OWUvRmNVYTVWb3B6cFZ1YXRacmNmOUJsRVhzWC9jRW16?=
 =?utf-8?B?MlNKZHVZOU1kSXM1aDROdFVwd3dVbnFnTVN3RWFramZhdDgwWE9nYm5wbDA0?=
 =?utf-8?B?cTdUdHVBeERrMUFyamVUcHBFSkV0WmFVU25MTWxjWEdOa1crTUI2bGFFMVhu?=
 =?utf-8?B?VWRZTTdlbCt5Y0lZZHJYRmJkRVFGbGJqRHdBR2ZETW5hd0pNUUdjZ0FZRGZv?=
 =?utf-8?B?bHZDdHU1L1FZRmNHZmZxblh0MzNuRzBUNUpHS0lXOWpmTVlnSzFyVjJvaGR6?=
 =?utf-8?B?bkhTTG40b1FPNVhrYlVac2FaR3dLaGVDcWtlVnBnaTVwRko3MVhvU2pDMC9G?=
 =?utf-8?B?VWt6dllkeUNRU2ZKalpjT0ZlbEVEeHRvUjBMc2pYc3NPV0szemxTM1ROMjMx?=
 =?utf-8?B?NU5IeHNvc3lvK1RwdElCQ0hVMGE2Zm81bzRPRTVBTk42aEd5TDduYzdOMFVV?=
 =?utf-8?B?YmlLR1lZMFlZWXk5NzFYeU0wNWtvMllub2wxVDF0K2tPTGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6759.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnJPaVhlNkZYWE15bTJOMTNPcHlYSmJIRDlhV3VLQi9INCsrMDRabldmb0ln?=
 =?utf-8?B?eklHTi8vclNRV3AyR2pSUkZ2d2lCMkFNSnh4ZmtGK3VCaEhmd0U3dWhkMzU1?=
 =?utf-8?B?QnVSWkNrWTQwU1l2RDBpK0plcnBrZlJtK2kvNVp5WlBSZk1MS3RYVXZnZXpm?=
 =?utf-8?B?MWFsaS9VMkJrMmFoNUZ3b2o1TTU2OTZhZjRpQUZ1MXlWT0NFbE42cXdqejVx?=
 =?utf-8?B?aHlMdkl3T3JiWmJjTFU2cFhxYlZObzhIY01xclY3Q2kzbmE1NTRrVUZsOCtj?=
 =?utf-8?B?OGdTZDZPWU4rWEFrTko2VHhQQjVhMGhqMWlvdDRjeThQc25lVnhzN1ZWNnFq?=
 =?utf-8?B?aldSd2l1LzZvdlA2Vm1ra0YvdmRGVklFQ2s3Nk1abk4rekQra2wyMVZiejE1?=
 =?utf-8?B?UDFrdklNbFZpNWk1eithSlJMRTEyYlBXU1QwOXc2UWVTWFhZN1ZJNURXQnRZ?=
 =?utf-8?B?V1lHZCs3bWtXY2MyZzIvYVJMNStCS2VyN1VQUjJNa0dEZHFuMVVLUThBNTQw?=
 =?utf-8?B?TGs5RjU4ZEZneHNGUHhtMHM3dW9pQ29xUzVpN2duUy9MOXRmS0RZSk4yRk9V?=
 =?utf-8?B?TDlRWk96elRVT2FOQmV3SVNHVldKZlJkTW1WdTltb1hUSjZFMUNFUzlMa3lx?=
 =?utf-8?B?bGZvcC94ZGpYcmFYRFBHaW5VbFhsSUxuSnYrTUc1NGZNZTIzbUxWYncrNkFv?=
 =?utf-8?B?ZFBPREhMNFZOZTcxV1NnZks0cWp0Qk10QTJudjdZeXFlSkZZTExBeUhyaGJi?=
 =?utf-8?B?WEU5cFAzV0tLMWFGaWJqVGhHUEpRMWh4UmtwVHgzb3pSS0h4eUZwd2JaT3Jy?=
 =?utf-8?B?NXNPcHNhYlN2RDdVak5NNDV1LzUwQ3krQ2xYMVowK1N6ZFR5d0FNTjl6UDZO?=
 =?utf-8?B?MmNmc2JXclIyRlN2dmxzdzFnQTFIRHVoQXBLYUNxSDc4aEJkV20xQjNkSUU4?=
 =?utf-8?B?S0xlYnVPTkRmZDBqaStOR0R2Z3hSK0pVSEJ4U0VqTkJjQWtWUklGakgzNFNV?=
 =?utf-8?B?b0QwVzdxQ2cwUkVSSFY3ZU5uRUpzMWNta3JsbDE0K0F0a0E3REgrRG5xZmJO?=
 =?utf-8?B?V2VCcHQrM0FxYXVKalZ3ck9Vbm5wTzJPVUV3VnVrQ1BaenhOdmFLNHJvOEtB?=
 =?utf-8?B?WjZmbjQrajk3a3pGK3JjNjd5Mk9uRFQ0YWRVbG45QUNEWVFDMEdGYzA1b295?=
 =?utf-8?B?YzVITlpCdjIwYWloQUxTU053aVRkUkwvWmRYNnZXeEo0blpoM1JNWmVRRnhL?=
 =?utf-8?B?Qnd2SXhzRVRnNkNkaGlnUzUwSnE1TjMxcHR1dHpSNmZ4R1V4L3NaZ1JDMU9u?=
 =?utf-8?B?b1BoZ3R6alp2TmFtQWdqQnRFZ1dqL1luUlhmcXYxbHEzWjZqYVdmTElKTlJ4?=
 =?utf-8?B?RVZIMjcwSGRTbWFTY3QvbGlSZGVIdm9vRVdUSVVyWUhhTnA0MlNQZWxFMHFP?=
 =?utf-8?B?ME9tZThjUFVudXdJV1B2UjJiTzdMUHROM0k5Y3hxSzQ3NkFTdDlra1NpbHB6?=
 =?utf-8?B?SHp3QjhHSmtTYXRydnVyaXZqMmN0eEV4d3Q0MElnb3VpNlN2bGRvSFgzUUFI?=
 =?utf-8?B?aHNST1hlbDdOK2VZZWoyWUdkbllGWTRUcFExU09rTXBIdFIxcmFEZkhzQUp2?=
 =?utf-8?B?R2JhaVBtbnV4eGZPeWx3S2xzMzV4QnZTbThkaUh3eWRBVGNIS1J5S1hCZmJ0?=
 =?utf-8?B?N0Z0blJuNzBRSmxpbFdrSFgxS1lmOSt4dVg2Y1ZYV3NtTGltRFBIb2Jrc3BK?=
 =?utf-8?B?K2g1Z2M4NEVLYk5GbXBpY0UzTnBMMnRFS3p4YjlIaDZaY2gzMS92VldIR0Vt?=
 =?utf-8?B?dFNDWGttVzdLYmtHaU5KWWZzdm9XaGk1ZUFSbGF0TTR1S05QdytyVnNhUXA3?=
 =?utf-8?B?aUljQjU2anpaQ28xSkVqeWRUYjNESndoTEo1WVA1UjloczZnd2lHWFJYYkhZ?=
 =?utf-8?B?empqMnJnNkd6blhVK1EwRENmTVNLOWh3Ty92TENIT2F2TXhET3JpazNPdmhk?=
 =?utf-8?B?SU5LUENRdnZaOXFNYXl0OTQ3VDZGTTNnbXVicXE4bXd1RC9wd2o5SVEwOVNV?=
 =?utf-8?B?L2tjUytpS2gzRVk1bHh1YmlqQjZ2UW4zY2paQlcrcXZTU0puOEdBcnlnVlVI?=
 =?utf-8?B?aVFoTjd5K1ZWaTNUSWM3bkw5alJxK0hpeDlQSW5wYUZEK283K2FLRUNJN0ND?=
 =?utf-8?Q?EJr/juCRfYP+vpX6axXWHV8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF59CB040C8D5845A9D71F1909E0D822@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6759.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7288b72-9903-458f-a81b-08dcc050cfa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 13:14:09.3495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILHgawajNgqzgTyAQuJVHYJ6yn3GwzD8EGS54KY2f5YWWgXQim+Yj5rkpPe8iEmzPSRjryfeisZdmaIN5ZuKWTv/8uWqrSQHIRmUZNOPGTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDIwOjIxICswODAwLCBsaWFvY2hlbiAoQSkgd3JvdGU6DQo+
IE9uIDIwMjQvOC8xNCAxMDo0NCwgTGlhbyBDaGVuIHdyb3RlOg0KPiA+IEFkZCBNT0RVTEVfREVW
SUNFX1RBQkxFKCksIHNvIG1vZHVsZXMgY291bGQgYmUgcHJvcGVybHkgYXV0b2xvYWRlZA0KPiA+
IGJhc2VkIG9uIHRoZSBhbGlhcyBmcm9tIG9mX2RldmljZV9pZCB0YWJsZS4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBMaWFvIENoZW4gPGxpYW9jaGVuNEBodWF3ZWkuY29tPg0KDQpBY2tlZC1i
eTogRGFuaWVsZSBBbGVzc2FuZHJlbGxpIDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29t
Pg0KDQo+ID4gLS0tDQo+ID4gwqAgZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJheS9rZWVtYmF5
LW9jcy1oY3UtY29yZS5jIHwgMSArDQo+ID4gwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2ludGVsL2tlZW1iYXkv
a2VlbWJheS1vY3MtaGN1LWNvcmUuYw0KPiA+IGIvZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJh
eS9rZWVtYmF5LW9jcy1oY3UtY29yZS5jDQo+ID4gaW5kZXggYzJkZmNhNzNmZTRlLi5lNTRjNzk4
OTBkNDQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJheS9rZWVt
YmF5LW9jcy1oY3UtY29yZS5jDQo+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJh
eS9rZWVtYmF5LW9jcy1oY3UtY29yZS5jDQo+ID4gQEAgLTExNTAsNiArMTE1MCw3IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkDQo+ID4ga21iX29jc19oY3Vfb2ZfbWF0Y2hbXSA9
IHsNCj4gPiDCoMKgCX0sDQo+ID4gwqDCoAl7fQ0KPiA+IMKgIH07DQo+ID4gK01PRFVMRV9ERVZJ
Q0VfVEFCTEUob2YsIGttYl9vY3NfaGN1X29mX21hdGNoKTsNCj4gPiDCoCANCj4gPiDCoCBzdGF0
aWMgdm9pZCBrbWJfb2NzX2hjdV9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikN
Cj4gPiDCoCB7DQo+IEdlbnRsZSBwaW5nDQo+IA0KPiBUaGFua3MsDQo+IENoZW4NCj4gDQoNCg==
