Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C1A632;
	Fri, 20 Feb 2026 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.132.183.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771545781; cv=fail; b=SV3CigUzsbXYosOizKrAeHjsR7/kAtP3E+JmIOb6AIb4Ao/4A13w2YzI0vXVELSn9hpRJ5OTQSAEi8eTm7JryLcuUgwCpwV635oIjP4UqOSkMbu4VthSV5jYSzKgRmKZPwJ8oN0FG9vqwc/Um3bnl4Yz1I7ttpMKRBKZd0bSjzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771545781; c=relaxed/simple;
	bh=/gM6SbYRS74Rl+nlS+yM46VQKh5kFRElW/9a+UUP3sk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fDvZZnCr1xx6hf9smC8WliwvVONZDJNz93PZ8ud4c7qmNAUhj/HYqoOtCs1d8pd0cTrraZcpqz6RbmeSUUn06tDGd7JLRtvcXRuDe3Wr6Xiy9Y4j/s+SFMOxHYYW0eSADDWEVVfCy/jO9OtYDilEJyDCL+Bvi23jJdvhfh/iwbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=JKF2RwXy; arc=fail smtp.client-ip=185.132.183.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="JKF2RwXy"
Received: from pps.filterd (m0209328.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JLf6IS1497022;
	Fri, 20 Feb 2026 00:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=S1; bh=/gM6SbY
	RS74Rl+nlS+yM46VQKh5kFRElW/9a+UUP3sk=; b=JKF2RwXyG8SwhFTjwrrKzZH
	dartIP09EcGChNyPbbp9I3JRJ2ygBCiOxn5emwhcKuQ4cUEN6uasSxGahPeLFtQn
	mInYJ52ER9tR1u/BO/bRt6WiYac4dBwiIE9P/x3j6bxzfomnf+LbrN4C5Vflbgf4
	B0rXUCGo22tWbHLkmrQDj2wb0FrpcOTTZ43OsskGj6Aluk3HlKUH7NuAlb5v2TZn
	Yi948RCfgRgdtWWJIAs7kCug5m4kAlTjqHhBS/IgIv9XU1DZL+478T/NKUlkZvqH
	mxQBFIJKDFsgaOuswmHRPkarBJVt+qfDKEawP6b/ZF7dfQojn1Z6jt9fT+/Ui3w=
	=
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4caj7eprwy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 00:02:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7Hb9wbhAf5mEmIUqXuFoQL1Y0gKzf97hHyv+j+Td+h5hz7ltqo/3hUigC13RiBvURr2NjJoSYHYypAndy8itZnj33pqr1ATTF47KuJWJVYg5CsCXzZ2RP8CLOTH9kGwNwRay0L+mKCRFitbwdjIpTaWgr3WJ2LaQNIgWkZ9GAt/idILMLxANGX2YyAjodsVyoPU8wqAAu00rVaYfL3WI5OzmD0lajYc153qTXs5zj/nkZWsy7on9mhy8w6LS7cf8D06v33dU9UUARv6/XZJN00ArjS2deZji/EaB4uvkuxo+kYbz7Ddeb1Ao86cj924Le1yzVVpsc5mlVuovI6Pig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gM6SbYRS74Rl+nlS+yM46VQKh5kFRElW/9a+UUP3sk=;
 b=SSKNs4cz4V8eIY/EtT3bm6tXTU2Lbhe4OH7gAFBFYULaDyerSbW5w1PjaAOVOxrRbpkLJYLyLhJeP52s4xmOKbZhuCaJCvYSpnQsJEfLhLW0toq6LcmysDwsbBoFk27WJ+dsqYVgLTfNH+zujTcC9N8mz4wp8vXXmbZsYMs7sS6pI3NnULRv6ucDq0D9tJAhB+1WzZjMvjrO0u/LY4SKBIoFxoKtdAxejszrfbIdvw86Er1asVsMOE0i+ayEjxu2hGnjvnGpEOPbxocVT6Uf8nlB5WSkxVjUC+U4dYFAPALLsMy6HMdcd2uXKH10ZpLY/RqXeLYDmsa2A9AG7NzauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from MW5PR13MB5632.namprd13.prod.outlook.com (2603:10b6:303:197::16)
 by BL3PR13MB5179.namprd13.prod.outlook.com (2603:10b6:208:342::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Fri, 20 Feb
 2026 00:02:24 +0000
Received: from MW5PR13MB5632.namprd13.prod.outlook.com
 ([fe80::29e9:b355:cabf:66f1]) by MW5PR13MB5632.namprd13.prod.outlook.com
 ([fe80::29e9:b355:cabf:66f1%4]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 00:02:24 +0000
From: "Bird, Tim" <Tim.Bird@sony.com>
To: Richard Fontana <rfontana@redhat.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas@wunner.de"
	<lukas@wunner.de>,
        "ignat@cloudflare.com" <ignat@cloudflare.com>,
        "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>,
        "smueller@chronox.de"
	<smueller@chronox.de>,
        "ajgrothe@yahoo.com" <ajgrothe@yahoo.com>,
        "salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "linux-spdx@vger.kernel.org"
	<linux-spdx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: Add SPDX ids to some files
Thread-Topic: [PATCH] crypto: Add SPDX ids to some files
Thread-Index: AQHcoTQbBh6mZATRN02cQiVFWvtk77WJV2UAgAFTZHA=
Date: Fri, 20 Feb 2026 00:02:23 +0000
Message-ID:
 <MW5PR13MB56321384E8C28E3320ACCD96FD68A@MW5PR13MB5632.namprd13.prod.outlook.com>
References: <20260219000939.276256-1-tim.bird@sony.com>
 <CAC1cPGy07RtOQifhova1+6ezTiKHzK8ZjBKQrWY9UW1t4hAG1Q@mail.gmail.com>
In-Reply-To:
 <CAC1cPGy07RtOQifhova1+6ezTiKHzK8ZjBKQrWY9UW1t4hAG1Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR13MB5632:EE_|BL3PR13MB5179:EE_
x-ms-office365-filtering-correlation-id: 44b4c7bf-e24f-4343-fc63-08de70135382
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXhzZVFzMm5wUVJRR0ppZDVBckpJekFuL2NRZUthanBZZ0pWbStRK3E2Q0hn?=
 =?utf-8?B?clk1OVBrQ3I0YzZIVUFtWGNERHlJeDArakg1a0hYVkcybkRpYy8ybW93THJk?=
 =?utf-8?B?aXV4TkJtSnhieE5QYXRPZkQ5TzBiemJqT0NhYVpkMHpndTlpclRhaUpnN3RW?=
 =?utf-8?B?UG1kSFNheDhRcVpaQ2VWWFFwTjhrejlpNk5UOThpamoraHVaNi9MajVxUFRV?=
 =?utf-8?B?SlN5bHJLSHQrUllMS0wwQTBpZmd4YzQxZS8rN2lzYzBUNTNvR1krV2FQU1VP?=
 =?utf-8?B?WXZGMGpIMDAvVmxkOFZwdHV5ZEVJcDdUN2hGTjE5cGZMTlVNNDkwelhyN2o0?=
 =?utf-8?B?KzF0bk85MGUwRkpDWEdFUGJMSHJTbnRaTUVHaW1UWDN1WTl1d3hzcXhIMnRF?=
 =?utf-8?B?bDJCTVRKQ1VEaWNaQWJUdHpsZFFJdmdEY1dyVHZybEdBWXNRd3RDMUNJUUhK?=
 =?utf-8?B?SkR3ME9IWkhQVkg0aURhbGd5N09TVFM3TGJLVlJ3bE41L3BOOW1VVXhJbFRF?=
 =?utf-8?B?dFF0VGpqSnJ6NUFENGhYU1NwQ1Z3WTZIZHdvSk5NdzBJVmpmY2YzbkVIWVE3?=
 =?utf-8?B?ajBsa2I1Z0k5ZFB5L3Zka2FvYlVGamF6eWR0NHB5RTVadjJ4UTc2bzBPcnR3?=
 =?utf-8?B?NzRzVGNIbFp0YjlNR081amp0U0s5QS9Mc2dwVFBWdUgzOFlDMTROdWhrMDda?=
 =?utf-8?B?ZTArT0RhTXdMTUxGWnU2T1dqU1lVeGVCaXlhSlFnUDBjWWxTMTRvalNPL2hG?=
 =?utf-8?B?ckZDSVJ3OWU5MWU1YTNPaHIzVzk2em5DKzVmbm1nSzM4Vll0QTdzTk5lNHNz?=
 =?utf-8?B?UnJjbDRFUUZNYkdEZXFOd1VWN3d3NGVQaWtCRFFkcDBUQTgvWllmWFhNeGpD?=
 =?utf-8?B?YWhEQmZlL2pmQ3IyUlhxbVFBNnlQM0hjbnVuWVQxL08xbG4vUmltcjl1dFla?=
 =?utf-8?B?MlR0R2tWeEJJNUptVkZESkVUTXluRWtISmtVN2w0MlVNK3ZtaFMxU3ExRERG?=
 =?utf-8?B?KytOaCtYMnd4MGFIY1I5ZzRSOXlBYTZGeGh3UXZsZXBoVkRGSHRFODJBL1Bs?=
 =?utf-8?B?YUtVbnloSDRwQ21BL3FBVlFGL2NCVkFSSlZVclBCMFlBZURvT2E3TkxhcmVw?=
 =?utf-8?B?MXQ5VTZLUnU3eENGZmhmWm4yUGRRSy9xS1JLN3JaV0FIZmN1VUE0Q3ZFUDhp?=
 =?utf-8?B?WkRHc21HZVY4bGxDTWhUVkRVMzJaRUx0OEhmd0NoR0xJUGkzbk5UcnMvY2Ny?=
 =?utf-8?B?S0xvVHRua0ZYQkp5YUNuWjNHWjZVZTE3NC9XUks3b1dvTytrRE1ud0o4N1lv?=
 =?utf-8?B?N1JjYUxyY0o2eFJ5T3BVQzIxcmhIOWIwcG9mV3JCWDQ0TTVwUzlBbWIyb3VY?=
 =?utf-8?B?bGViRGY2QStwc3N3dzBXVnU2cHc4M0lraE42QjlKcVlIRjc2TXhXZGFOQkxh?=
 =?utf-8?B?cUpxWGVtUTFWalhsQTVpeThrN0VJUU9NUGJ3eWxQWUNWVXN2TEtmcW5iMHcx?=
 =?utf-8?B?SWZhNG5ld1FoOHBtYzJ0VjVXd1J0NTAwSmhlNFNFcmo0SEFtZUtQbEJHRjY1?=
 =?utf-8?B?TDMwY1RQbjNveERsVjczSjFVaWJnb2p6YXpqZHB6aWFKZXpTWUVmYW9tKzd3?=
 =?utf-8?B?SVNnUnZDejB6dmFGbGdMSmIwZVM3c1l1eG9FUVZsWWQwTzBUdmVldFJkUlh2?=
 =?utf-8?B?WHgxY3ZRVVNyYWRUWUR1NFE5TzQ0SE9YSTd4QXN3TU1hS0c1cFF2TUJGYXRn?=
 =?utf-8?B?czNQMnkyb3FYdGEvcTYvZnl1UHhDRk5iaFlURXg2YUVXZlFRbjR1MTlLYW1u?=
 =?utf-8?B?T1JIK2JrejBKOXdNaDJMclZWQjVBRFg3RHVPbW5GSU1JT3VKRnBZaHRTZGlt?=
 =?utf-8?B?WEZYc1lKa24wZzFvUzYzd0EybU1CYlVad0xIbGN5L1BMUDgzZHNlVW5RUStG?=
 =?utf-8?B?eUNlcStXT0o3ckxZYlFUNEN0cFBmVkVnYTB2Y3NuT0cwdzNzZDJCKzhpeEs3?=
 =?utf-8?B?UEtwbnU2SzRiN1F3U0ZUTDVkdUJwQkZUYlFBVmRPcTlNaEUxcVFIaU1EUy9C?=
 =?utf-8?B?RXBLODJrVkQyMlB6ZU1yQko4cXdDTU5PZ2h5cEJ3bC9VdVcrcEtlTDZWMVo1?=
 =?utf-8?B?LzluaGl2ekFZL3NQYXpsN3FlM1pFQURMZGF5TDlKNzVEYXRROUN5UUR2bUdP?=
 =?utf-8?Q?tD9cGUU4OdMQohbQVX68Y7w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR13MB5632.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QVlnNWY3VUtVbFB0SU9LS2FIeEZXUGpyWGlwaXZQMGZtV3FmK1RQd2R1RmpK?=
 =?utf-8?B?cStNdmd3R3JiOFZnd3YxWm5lNmpMUGFISWE0Q0VveGhGVStPaS9KMCtMTHg5?=
 =?utf-8?B?dTdqS0FEbFd0MXdiL0dTR1dWUzZQWnM4ME83ZkxEdUp6Z2ljS0JPbHVkQTdI?=
 =?utf-8?B?U0NGbUJMZVA2cGlSUFI2dnFRUVg1QlVBWEI1K3kwTXRJRWxnZGVEeURPWTlC?=
 =?utf-8?B?YkRxRmhRRmhpdUdKdERsN0p5YkdWUGZaS2lDNzl4aElOTmw1UTRsNFgzMVJ4?=
 =?utf-8?B?YUw3SkhCbnZMMnNFOE1LdEpXbVFnbGdtSU9LOEg2OWw2VHRnYWRKdzVXMndS?=
 =?utf-8?B?YldsOTFkNUZxVjQ4S2t4L2wyZkYzbTI1RGZoZytWMzFvalRsemZGbWNCZFVH?=
 =?utf-8?B?R20wL3o5OXZlcGh5S0x0U3UrdCtnR1BBQ0JaQlRMdHJtei9mdFhaRGJyNHp0?=
 =?utf-8?B?VldGWHZMTGpQWGdteUI4c1FEQXVlSUxObGJkSGdYQVV5b3JJQVZzSitJYnJ6?=
 =?utf-8?B?MTdWMDh1Ti9PckpDSVIxSjBiWWd3UUZ6QTN4ai9oK3cvcWFWZ1hBTGZmY1hS?=
 =?utf-8?B?Y3RlaEljd04xM0VScHBDS0JrSmtRWUh6VUlydDJyVjZzWmhjS2Q4NytDQkM5?=
 =?utf-8?B?YlBMSjRySFNSdHdGaElzejVxQ0JiZXJ3cjlhTS9IWk9mWmhMZ0NwT1VQT2RL?=
 =?utf-8?B?Rk9ObnMxaGZ3akpDblpPOStyR2hxV3lDY3ByNDlhU3kxRVY1OW1TN0dCZGEy?=
 =?utf-8?B?dFZLS3JYTk1aeDRTVWp2NHZya0lmbVp2dk45eHo3OUl6MzFMbjR3ODdZdlN4?=
 =?utf-8?B?TEo1L3lDbWltdVMxbkpMMnZBNEczTXZJMFVVS3R2KzY3NkVCcDJ5Rml5RCtD?=
 =?utf-8?B?d0E5dHhHMmQ5cGlZUi9acVpCMTNrcXFrVUxaQ1JVaStYZkxZbmMweDFBQTFT?=
 =?utf-8?B?R3JDM3lkbmQzaHlkcTFEUlpuUVpOVDZZVnJISzRuUWMvWE1wK2s5RlI0WW9B?=
 =?utf-8?B?T1RUY1QrL2FrWmJUQWxVc0UrRHBVZmoya0o5SDBrSW96K2FnN25rOVlsUDF5?=
 =?utf-8?B?OUFINTFrc21ZV0M5RE44dExBMjRUMXRxbExmR2c1UnpWR3AvKzJxdUpEQ3cx?=
 =?utf-8?B?UmgwcTJDYTF4S3hqVG5qTk5HTkdkY240M1FjT1dWTmxCc1gvMlJBU293MmtI?=
 =?utf-8?B?dC91RHl6VlVkcTB0bnVJWVlDREpMV1YybUEvWVZQOE56VG14Ky9KY3ZNNUZw?=
 =?utf-8?B?VUg5RStNTGI1VjY3YjZpMzhuMjR6andIREFONTErOVpLM05QY2dyYSsvdGph?=
 =?utf-8?B?T2UrRHA5TXVlRzdYem5SQytmRGx3cnc3SXROcElsakhpM21pRk1yMGV5bDMw?=
 =?utf-8?B?Qy9RRHp1KzJKS3hxeXc2NWdIekxHcWg2SGxraXFOSDEyejd5ZjB5NSt5VjNS?=
 =?utf-8?B?YngxVFRGelFYNHJOdm1LMEViV0xRbTFIQVlBcWlZWDIyTVdpRXZQNG5xNFNp?=
 =?utf-8?B?Vk9oUTRWanNDRitmVDI2WEorbHM3QlNmZmc3RE9LYXpJZ3UxS2JHZjQ1YmYz?=
 =?utf-8?B?OFNvNFZVOFUrcmJSanBqbkR2dU5pRzlKdmRFNE16dTdHbW1FbktSVXBVRmhB?=
 =?utf-8?B?SVhqTjRGVWF5RXZzbmFCUEhVT0ZTcEliaG9RT3luZTJJZzRaS1hnSE1TeW1U?=
 =?utf-8?B?djlVSDlSdzgvR2NlYzZraytEM3JpNVFFVW5NMkV0NHBSSmE4cnVrUVdiMWxG?=
 =?utf-8?B?NzI1Q1c5T2l5U2xKbytvam9QdkVDRmxPcFZsUDB3a0pBTmpzRndvNzlLYnVt?=
 =?utf-8?B?OVZYaVQwdmd2MkVlVkJrZ21YbEYvWkRrY2Y1d1B3M09ESWZDRHBjMStVY1M2?=
 =?utf-8?B?dkt4NkJXNHZCVUtNVjJzdGo5Q0J3a2tiOXRSNVlBU1ppcEE2c3Z4ZWlOQ2hM?=
 =?utf-8?B?V05sZVhhTCsxYkFlME5oOG1ESnkzbkJrMi96ZmlNb3NUZ1hwTS82UGFiVTZB?=
 =?utf-8?B?eEZza3FEaWg4NFFRNDk3VDc2SnM2YmREMWsycCtuc3ZvajFsOGhHcXZ4OGdW?=
 =?utf-8?B?R29xZnhFaWRyUWZadUsxenU0a2w4eVNZSU0zRVZCbWo2VDFFOU16ZXpQbkl2?=
 =?utf-8?B?L2tKNm5FdkVicXJnWHVZaUxsdjFNd0FqaHJHKzRTRXhKSWNWSFU0Ymc2Qkg2?=
 =?utf-8?B?RkZSMC84YWtmK1pRU3lIb092NlVjckZRbXVhL0ZyTWw2TGFRcWQ2TDFJVVZI?=
 =?utf-8?B?cE44NmkydXFHclVXbEExMGp4MlJWUzJlWmpFaDRHcVJpZGoyaWRscThKcVMz?=
 =?utf-8?Q?B186ElwEX3/bM2xpHa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WmOo7oNsFxtkEPNBUGVoWD47GBnowyAJ16az98BFdgPMtZavOHAfOi5Iny1w3FsYntHHrYUTTeydD7/1yfaVhBcd64ayh1E5sFu/dba9G4v9BwnNQpDnHnF70Wg5rpFHWyIpJQ9eoUV0Zg16ABxWHF94ZvHUaG4Oai7DWFMP+lLlTQB1Yp+zTG9Szat9MFPHhTGK7N6NJdpE5Yee/OTJoT0s4WCWvDQQjJoxuGZ6piHjQFvuBl/SahLw/MTpvya/DueOt9N3aAEwdr7ZkU2Gr5G3pVph/m7aH3WCO4vv7bejjtqN6bzczGJuJQDA3BFQbwTlUlFipV4m67JVPvaPJRwITFEBD/vyX2hLnUD5T/awxQK2glGWS6vIebrf3LFsbLHM6+k5Flomux/uBWzh1pLNUjR/wP220mgGlBAdFKmdkgGCL7+ufCpoSdb7Th77ml1QUoOAm6Nus9WYGkuedjbMfRblucDu7+QrnxhbxeUsFrkRhz0INbXHodl789iSZxGDP49WbS+7HRK+aGI2ImHKDpmWYPuGQyLohi/NbZsOFFAHZf6iUdaSRI4xKnePeCHnYeRiwo8nMhx3hyQ6lbUL+GIfVp5LgEOHl6mjPG/TRJEr7qps0k+FQFd0VM5Z
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR13MB5632.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b4c7bf-e24f-4343-fc63-08de70135382
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 00:02:24.0233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kZa6/hpn9K1dVWaFA+3JzwX3Y4GsbgnqLYxqSuh6VFV9MsuU7HWcc33/dlD3yEO+hNoBsdF8K6oafGWmn184g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5179
X-Proofpoint-GUID: ytAisGEo70g324310-MeSaJUssVX9Aoi
X-Authority-Analysis: v=2.4 cv=EbXFgfmC c=1 sm=1 tr=0 ts=6997a499 cx=c_pps
 a=uKk6FyUS+xKIvFCPM6xM7A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=xR56lInIT_wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=20KFwNOVAAAA:8
 a=z6gsHLkEAAAA:8 a=rZcL1z7Yst9iWw913SIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ytAisGEo70g324310-MeSaJUssVX9Aoi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDIxMyBTYWx0ZWRfX2a4do5guPBWS
 mDKNAJBrNwroaMqWJ6zpY7HjItPC071Zki5xBPlElMtm9W6L5dlDCthJUd3Jwjjj/xnfuzlHRz7
 nbqUMLudsZ9cuWPfq3PN3/PHzn4GUylxo55/4rFqI5Zlv7S0HSBF3omKzuE4hEdoTTWOfiQouQs
 f1nYMyQUgiOmRsxxVIdhJlXAZtP/e9i0yPRWe4bLdCmyE446dSJNlwsqSQ7vIdzoOGe7E9GJExV
 863rbW1u9QOY7zRYMJ5shwnZiNUntQcoacx1Asiiskpvk/jBuNab4PWq6Eh8dq/d+hf/NOg3+Ym
 PdFeOdRFRJqTNhYNso6T0n4siz+CeBzsAmQmljd8WXM+vX1d/TSPR2/tL7SijthxkwfyBjidgo1
 Y+23FSc0t7MsF1xxpXlPuz50Qww1SAUcoQgj92H1z6jebxZePZioMxeXAMdnXFDl1BESDOh7Qfe
 7yHQ4ZJs/2sWYFsWJgA==
X-Sony-Outbound-GUID: ytAisGEo70g324310-MeSaJUssVX9Aoi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_05,2026-02-19_03,2025-10-01_01

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmljaGFyZCBGb250YW5h
IDxyZm9udGFuYUByZWRoYXQuY29tPg0KPiBPbiBXZWQsIEZlYiAxOCwgMjAyNiBhdCA3OjEw4oCv
UE0gVGltIEJpcmQgPHRpbS5iaXJkQHNvbnkuY29tPiB3cm90ZToNCj4gPg0KPiANCj4gPiArLy8g
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0ZXIgT1IgQlNELTMtQ2xhdXNl
DQo+ID4gIC8qIEZDcnlwdCBlbmNyeXB0aW9uIGFsZ29yaXRobQ0KPiA+ICAgKg0KPiA+ICAgKiBD
b3B5cmlnaHQgKEMpIDIwMDYgUmVkIEhhdCwgSW5jLiBBbGwgUmlnaHRzIFJlc2VydmVkLg0KPiA+
ICAgKiBXcml0dGVuIGJ5IERhdmlkIEhvd2VsbHMgKGRob3dlbGxzQHJlZGhhdC5jb20pDQo+ID4g
ICAqDQo+ID4gLSAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlz
dHJpYnV0ZSBpdCBhbmQvb3INCj4gPiAtICogbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0
aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UNCj4gPiAtICogYXMgcHVibGlzaGVkIGJ5IHRo
ZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uDQo+ID4gLSAqIDIgb2Yg
dGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uDQo+ID4g
LSAqDQo+ID4gICAqIEJhc2VkIG9uIGNvZGU6DQo+ID4gICAqDQo+ID4gICAqIENvcHlyaWdodCAo
YykgMTk5NSAtIDIwMDAgS3VuZ2xpZ2EgVGVrbmlza2EgSMO2Z3Nrb2xhbg0KPiA+ICAgKiAoUm95
YWwgSW5zdGl0dXRlIG9mIFRlY2hub2xvZ3ksIFN0b2NraG9sbSwgU3dlZGVuKS4NCj4gPiAgICog
QWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gPiAtICoNCj4gPiAtICogUmVkaXN0cmlidXRpb24gYW5k
IHVzZSBpbiBzb3VyY2UgYW5kIGJpbmFyeSBmb3Jtcywgd2l0aCBvciB3aXRob3V0DQo+ID4gLSAq
IG1vZGlmaWNhdGlvbiwgYXJlIHBlcm1pdHRlZCBwcm92aWRlZCB0aGF0IHRoZSBmb2xsb3dpbmcg
Y29uZGl0aW9ucw0KPiA+IC0gKiBhcmUgbWV0Og0KPiA+IC0gKg0KPiA+IC0gKiAxLiBSZWRpc3Ry
aWJ1dGlvbnMgb2Ygc291cmNlIGNvZGUgbXVzdCByZXRhaW4gdGhlIGFib3ZlIGNvcHlyaWdodA0K
PiA+IC0gKiAgICBub3RpY2UsIHRoaXMgbGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUgZm9sbG93
aW5nIGRpc2NsYWltZXIuDQo+ID4gLSAqDQo+ID4gLSAqIDIuIFJlZGlzdHJpYnV0aW9ucyBpbiBi
aW5hcnkgZm9ybSBtdXN0IHJlcHJvZHVjZSB0aGUgYWJvdmUgY29weXJpZ2h0DQo+ID4gLSAqICAg
IG5vdGljZSwgdGhpcyBsaXN0IG9mIGNvbmRpdGlvbnMgYW5kIHRoZSBmb2xsb3dpbmcgZGlzY2xh
aW1lciBpbiB0aGUNCj4gPiAtICogICAgZG9jdW1lbnRhdGlvbiBhbmQvb3Igb3RoZXIgbWF0ZXJp
YWxzIHByb3ZpZGVkIHdpdGggdGhlIGRpc3RyaWJ1dGlvbi4NCj4gPiAtICoNCj4gPiAtICogMy4g
TmVpdGhlciB0aGUgbmFtZSBvZiB0aGUgSW5zdGl0dXRlIG5vciB0aGUgbmFtZXMgb2YgaXRzIGNv
bnRyaWJ1dG9ycw0KPiA+IC0gKiAgICBtYXkgYmUgdXNlZCB0byBlbmRvcnNlIG9yIHByb21vdGUg
cHJvZHVjdHMgZGVyaXZlZCBmcm9tIHRoaXMgc29mdHdhcmUNCj4gPiAtICogICAgd2l0aG91dCBz
cGVjaWZpYyBwcmlvciB3cml0dGVuIHBlcm1pc3Npb24uDQo+ID4gLSAqDQo+ID4gLSAqIFRISVMg
U09GVFdBUkUgSVMgUFJPVklERUQgQlkgVEhFIElOU1RJVFVURSBBTkQgQ09OVFJJQlVUT1JTIGBg
QVMgSVMnJyBBTkQNCj4gPiAtICogQU5ZIEVYUFJFU1MgT1IgSU1QTElFRCBXQVJSQU5USUVTLCBJ
TkNMVURJTkcsIEJVVCBOT1QgTElNSVRFRCBUTywgVEhFDQo+ID4gLSAqIElNUExJRUQgV0FSUkFO
VElFUyBPRiBNRVJDSEFOVEFCSUxJVFkgQU5EIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQ
T1NFDQo+ID4gLSAqIEFSRSBESVNDTEFJTUVELiAgSU4gTk8gRVZFTlQgU0hBTEwgVEhFIElOU1RJ
VFVURSBPUiBDT05UUklCVVRPUlMgQkUgTElBQkxFDQo+ID4gLSAqIEZPUiBBTlkgRElSRUNULCBJ
TkRJUkVDVCwgSU5DSURFTlRBTCwgU1BFQ0lBTCwgRVhFTVBMQVJZLCBPUiBDT05TRVFVRU5USUFM
DQo+ID4gLSAqIERBTUFHRVMgKElOQ0xVRElORywgQlVUIE5PVCBMSU1JVEVEIFRPLCBQUk9DVVJF
TUVOVCBPRiBTVUJTVElUVVRFIEdPT0RTDQo+ID4gLSAqIE9SIFNFUlZJQ0VTOyBMT1NTIE9GIFVT
RSwgREFUQSwgT1IgUFJPRklUUzsgT1IgQlVTSU5FU1MgSU5URVJSVVBUSU9OKQ0KPiA+IC0gKiBI
T1dFVkVSIENBVVNFRCBBTkQgT04gQU5ZIFRIRU9SWSBPRiBMSUFCSUxJVFksIFdIRVRIRVIgSU4g
Q09OVFJBQ1QsIFNUUklDVA0KPiA+IC0gKiBMSUFCSUxJVFksIE9SIFRPUlQgKElOQ0xVRElORyBO
RUdMSUdFTkNFIE9SIE9USEVSV0lTRSkgQVJJU0lORyBJTiBBTlkgV0FZDQo+ID4gLSAqIE9VVCBP
RiBUSEUgVVNFIE9GIFRISVMgU09GVFdBUkUsIEVWRU4gSUYgQURWSVNFRCBPRiBUSEUgUE9TU0lC
SUxJVFkgT0YNCj4gPiAtICogU1VDSCBEQU1BR0UuDQo+IA0KPiBUaGlzIGlzIG5vdCBgR1BMLTIu
MC1vci1sYXRlciBPUiBCU0QtMy1DbGF1c2VgLiBJdCBhcHBlYXJzIHRvIGJlDQo+IHNvbWV0aGlu
ZyBsaWtlICJHUEx2Mi1vci1sYXRlciBjb2RlIGJhc2VkIHBhcnRseSBvbiBzb21lIEJTRC0zLUNs
YXVzZQ0KPiBjb2RlIiB3aGljaCB3b3VsZCBiZSBgR1BMLTIuMC1vci1sYXRlciBBTkQgQlNELTMt
Q2xhdXNlYCAod2l0aCBzb21lDQo+IHNpZ25pZmljYW50IGxvc3Mgb2YgaW5mb3JtYXRpb24gaW4g
dGhlIGNvbnZlcnNpb24gdG8gU1BEWCBub3RhdGlvbiwNCj4gYnV0IEkndmUgY29tcGxhaW5lZCBh
Ym91dCB0aGF0IGJlZm9yZSBpbiBvdGhlciBmb3J1bXMpLg0KDQpXZWxsLCB0aGlzIHBhcnRpY3Vs
YXIgY29tYmluYXRpb24gaXMgaW5kZWVkIHByb2JsZW1hdGljLiAgVGhlICdCYXNlZCBvbicgbm90
aWNlDQpkb2VzIGluZGVlZCBub3QgbmVjZXNzYXJpbHkgbWVhbiB0aGF0IGVpdGhlciBsaWNlbnNl
IGNvdWxkIGJlIHVzZWQsIGlmIHRoaXMgY29kZQ0Kd2VyZSBleHRyYWN0ZWQgZnJvbSB0aGUga2Vy
bmVsLiANCkl0IHdvdWxkIHRha2Ugc29tZSBkZWVwIHJlc2VhcmNoIHRvIGRldGVybWluZSB3aGF0
IHdhcyBhZGRlZCB0aGF0IHdhcyBOT1QgDQpCU0QtMy1DbGF1c2UgYmVmb3JlIGFuZCBhZnRlciB0
aGUgY29kZSBlbnRlcmVkIHRoZSBrZXJuZWwgc291cmNlIHRyZWUuICBBZnRlciB0aGUNCmNvZGUg
ZW50ZXJzIHRoZSBrZXJuZWwgc291cmNlIHRyZWUsIHRoZSB1c3VhbCBhc3N1bXB0aW9uIGlzIHRo
YXQgY29kZSBjb250cmlidXRpb25zDQphcmUgdW5kZXIgR1BMLTIuMC1vbmx5IHVubGVzcyB0aGUg
c3BlY2lmaWMgZmlsZSBsaWNlbnNlIHNheXMgb3RoZXJ3aXNlLiBIb3dldmVyLCB3aXRoIGJvdGgg
bGljZW5zZXMgbWVudGlvbmVkDQppbiB0aGUgaGVhZGVyLCBJIHN1c3BlY3QgYSBsYXJnZSBudW1i
ZXIgb2YgY29udHJpYnV0b3JzIGludGVycHJldGVkIHRoZSBzaXR1YXRpb24NCmFzIGFuIE9SLiAg
VGhlIGVuZCByZXN1bHQgb2YgdGhpcyBpcyB0aGF0IG5vcm1hbGx5IG1vc3Qgb2YgdGhlIGNvbnRy
aWJ1dGlvbnMgYXJlIGFzc3VtZWQNCnRvIGJlIEdQTC0yLjAtb25seSwgYW5kIGl0IHdvdWxkIG5v
dCBiZSBhcHByb3ByaWF0ZSB0byByZWxlYXNlIHRoZSB3aG9sZSBmaWxlIHVuZGVyIEJTRC0zLUNs
YXVzZS4NCg0KSSBkb24ndCB0aGluayBpdCBjYW4gYmUgJ0dQTC0yLjAtb3ItbGF0ZXIgQU5EIEJT
RC0zLUNsYXVzZScsIGJlY2F1c2UgdGhlIDNyZCBjbGF1c2UNCmluIEJTRC0zLUNsYXVzZSBpcyBp
bmNvbXBhdGlibGUgd2l0aCBHUEwtMi4wIChhbHRob3VnaCBzb21lIHBlb3BsZSBkaXNhZ3JlZSB3
aXRoIHRoYXQsDQp0aGF0J3MgaG93IEkgcmVhZCBpdCkuDQoNClRoZXJlIGFyZSBsaWtlbHkgYSBu
dW1iZXIgb2YgY2FzZXMgaW4gdGhlIGtlcm5lbCB3aGVyZSBkZXZlbG9wZXJzIHRvb2sgQlNELTMt
Q2xhdXNlIGNvZGUNCmFuZCByZS1saWNlbnNlZCBpdCBhcyBHUEwtMi4wIChvciBHUEwtMi4wLW9y
LWxhdGVyKSwgd2hpY2ggaXMgbm90IHN0cmljdGx5IGtvc2hlciBiYXNlZCBzb2xlbHkNCm9uIHRo
ZSAzcmQgY29uZGl0aW9uIGlzc3VlLiAgSG93ZXZlciwgSSB0aGluayB0aGUgM3JkIGNvbmRpdGlv
biAodGhlIG5vLWVuZG9yc2VtZW50IGNsYXVzZSkNCmlzIGEgZ29vZnkgb25lLCB0aGF0IGhhcyBu
ZXZlciBiZWVuIGFjdGVkIG9uIGluIGFueSBsZWdhbCBjYXBhY2l0eSwgYW5kIGZvciB3aGljaCB0
aGUgcmlzayBvZg0KYSBiYWQgb3V0Y29tZSBpcyB2ZXJ5IGxvdywgaWYgaXQgd2VyZSBjb21wbGV0
ZWx5IGlnbm9yZWQuICBJIGNvdWxkIGV4cGFuZCBteSB0aGlua2luZyBvbiB0aGlzLA0KYnV0IHRo
aXMgcG9zdCBpcyBhbHJlYWR5IHRvbyBsb25nLiBPdmVyYWxsLCBJJ20gaW5jbGluZWQgdG8ganVz
dCBtYXJrIHRoaXMgb25lIGFzICdHUEwtMi4wIC1vci1sYXRlcicNCihub3QgdXNpbmcgYW4gT1Ig
YXQgYWxsKSwgYnV0IGxlYXZlIHRoZSAnYmFzZWQgb24nIHRleHQsIGFuZCBjYWxsIGl0IGdvb2Qu
IEkgbWlnaHQgYWRkIHNvbWUgdGV4dA0Kc2F5aW5nIHRvIGxvb2sgYXQgdGhlIG9yaWdpbmFsIGNv
ZGUgYXMgc3VibWl0dGVkIHRvIHRoZSBrZXJuZWwgaWYgc29tZW9uZSB3YW50cyBhIHZlcnNpb24g
b2YNCnRoZSBjb2RlIHVuZGVyIHRoZSBCU0QgbGljZW5zZS4NCg0KQnkgdGhlIHdheSwgUmljaGFy
ZCwgSSBhcHByZWNpYXRlIHRoZSByZXZpZXcgb2YgdGhlIHBhdGNoZXMgYW5kIHlvdXIgdGhvdWdo
dHMuDQogLS0gVGltDQoNCg==
