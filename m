Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3210A2417C2
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770139049; cv=fail; b=fH3Ea7INDzxBI8sfN4m3T2fx3+cpbRpGLwNgqd2UfJpscxUaaUSmIEUZwz/E9IlzaCdIMuw4rMunU827408usEY7ZMeZeW5AaLoT+wR2jKluuzuuc/YZVPqnKISR0HP3TYZtlBRXj06Qr5Y7uhiEW9NGdLhUgwxdCr+4QcLor2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770139049; c=relaxed/simple;
	bh=gQBv1KXgXndhrt4Co3yQLwsCioZ9UPGz9u4XexkKeKM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HkdC9X9e/ca0IEiu+WAaG0RytSGG/dd4opyYSKRdf3VLhXTTpc25l3jTDxTA6wKq3ESqMibBKjRCzFGtPw8yvxo+O5MvfaupLjULxib/XIylOxdvgrUtDUQltZK6eaiJ3QEp2M7kI5qAvalh/wKDavXwcQUVUOpsWUdSyyhR14Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=B/D+Gp+F; arc=fail smtp.client-ip=52.101.46.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="B/D+Gp+F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l7y93uRtFfv2azpcz4Yj5SgWMFhAaSMjXJeVAjHe9wobpGhh+ogUAnP+KyEwZ1YMq03lK5VSBoGdmY2j1nfmW3Jrerx4OIzlFbUaI2XHfHbBIL2FDaSb1S6EUQ8Mq9/PjvPlVFLnwql4KdMLObhGzAB7lsxb/WCEpiSJhEhr2jjL9uB6kaTCx62WDlMn3xTmcOvUDf+yyL13k1h7lLkAb1KGmsU5ZqY6sQZxePkJSBwQQSx4GbAQZHTtvDs8iXAJCw7o6lomdmer6x+g92OJ9cVD2Sy6M7UGFONQAQhQbnWesep0b1JM2G5DqcKnkpblv0qXMRle3MODLv3fPUGxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQBv1KXgXndhrt4Co3yQLwsCioZ9UPGz9u4XexkKeKM=;
 b=FKWYw0b/J+w1rb4/CSE6IayiITq6VSDfpTll2q2nQLp8HnTwZlCggGZrbJonuTuhpIc54EZkk52sjphEfiKsPVQ4z3mGmuK5hIrs5hMLfsSeJrl6daWZuQKw5jQZ+3xcIs2ZOYccOXcUt8jhhr8pQ3ZO4jzeuYO+UkgHDybZ2xkMxqVTyCQgd0MpF12uIzISEdlIWcT+Soyx2ooJLvJCNVOnUGnKGFVvXg4OFbCvOg+THBhNe0HbqlegyVE3aY7rVb1lQQ6ivj0p07jQaezt6QnJfb8cmt1aC/+TPwZv7Z7xV4g8eqnXQzwqISp2I2x2Yuw/0eoklzO2372OGAFdig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQBv1KXgXndhrt4Co3yQLwsCioZ9UPGz9u4XexkKeKM=;
 b=B/D+Gp+FoxieFB0BuyQUdkDN8PD8VS/NiJrzTa8e+2BXGpgur5YogHrlLXSTG1HfM0ibq6lgOQ6IYctW6WrSbKFCW/8nV9QkiRH9GlvA69yrDCDKYJzbQsGqfP2RKdMVOjTUWojMvj5j4TWkVNTQDy2sXrO1Q+jyAYRhOKHrT/c70Ij7mSgyQmPIKEy4eYe6C989+OpvZRzOd+gH6/CV5R5GtpW/x/rvpBPEUWWAxnhYmovSKamvE1pn/VY+RaHuq47eK1yJ4LAFyYZtvbAbQHZuSHLpAdlfHURAoYwIlfnNWRn2mwPMubr4nAWmAB0x9To/wGkVSKauJ9evWGvkfQ==
Received: from DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f28) by DS0PR11MB7928.namprd11.prod.outlook.com
 (2603:10b6:8:fe::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 17:17:24 +0000
Received: from DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 ([fe80::49f2:f63e:c633:5e11]) by DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 ([fe80::49f2:f63e:c633:5e11%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 17:17:24 +0000
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: AFALG with TLS on Openssl questions
Thread-Topic: AFALG with TLS on Openssl questions
Thread-Index: AQHckTxGvIr0hmw/6UG4ScH02tuyNLVqKqwAgACiwgCABnI0gA==
Date: Tue, 3 Feb 2026 17:17:24 +0000
Message-ID: <c2ee6f99-458a-4447-aa03-5bad7babacd3@microchip.com>
References: <25e13e64-f39c-44b4-9877-1e3b6caed458@microchip.com>
 <aXw8-J2KRklumOa8@gondor.apana.org.au>
 <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
In-Reply-To: <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM3PPF67FA1A8F8:EE_|DS0PR11MB7928:EE_
x-ms-office365-filtering-correlation-id: 61f9e08d-09af-4830-b37b-08de63481905
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MUs1d0E4aEYvYnVMSTVCV2MrdnFCNVE2cGg5bFpOeGovYTQxb0o5RlNmcUxB?=
 =?utf-8?B?RG1xV3k1NTMveE9tRVJrWFpjcFFtNUdKdXpMTkNySHFiYmpuQ2JpN0J6Q0xh?=
 =?utf-8?B?OXFXWFdHUlRPdUtidFNYR29JNFFLc0ZaQS9nRWpVVjZTSXNwc1pJZndRbUFv?=
 =?utf-8?B?S1ZnOElPNUduN05oWVBMNHNhdEduM0xiMUNhUWc0ZFQ4ZktGTExya2J6WEp2?=
 =?utf-8?B?ZFlFbjhzVE5RSEd4UDF4dzB4eEJRd0RDakcyNlVvUWVQSHZTQjRUbGxrOXcr?=
 =?utf-8?B?K3JDVE9KTTMycmlqdjV3WlIwYlNSQkNVenkxdWtydkN2bjBlNjlpdEphcnRY?=
 =?utf-8?B?WFAxY1dRN0R1dnRNd212cHZVdWpwbmFlZ1hWU0RTaStpaW04cHdiMlFwYkRr?=
 =?utf-8?B?STZDc3NRUkRJZ28vYTlUSFJwWUdvVGM0MWhBK0paZjVNNC9iMXpjOCtROFYr?=
 =?utf-8?B?T1JtekhvYVVFV1owWlVBVVN5RVJxaHl4blpYbFlsYVhZWUUvT2lzZ1ZkOE9E?=
 =?utf-8?B?M21sVlJoNEtEbkRVSWRuTDNOT3BETHJlZFkzU0U4bHJvaG8xUWkvOXBvWVpt?=
 =?utf-8?B?MXBDWEhIRnNEQkxtSkxPZFBhdzcyUjJXRHdrbDFVRXluVUQvK21LbTdGZHgr?=
 =?utf-8?B?bVowdUFEem5tWCtPc1lITVNVejBxb2RiN1Y4UDVNUUdFaXRVeG1JVFZhS2M2?=
 =?utf-8?B?QkJNbngzZzdtVVdienYvQTd0T2RVSkJnNEZPTktoR0MyK3RjV2k4ZWJ4TTNS?=
 =?utf-8?B?SUxHdU9aMHdNRmJNZ2laZEZQeU91YmJhZ3dZNzMxbnV5TmNwdlJLNUhtUmxk?=
 =?utf-8?B?YjFoNGRtOUo4dHMvLzB3aXpsZm1IbEQwazVLQWFJSVR3SnJwTGJCRE5hNjVj?=
 =?utf-8?B?Z2I2K3UxbzhzWndWbG5MQytsd1NnaHlseHM1OGNIelhhdXAwVUxsMkFXTEhC?=
 =?utf-8?B?WmFiKzcrWUhhU2ljYW1XWjhTdzJURXRUNFdpc3Izb0tmNjk1VERpdzk0Wjd3?=
 =?utf-8?B?c2VReHpUZzh6Y09mUktYS2d5U3ZjaDdZUDBGcmxCem1OMkZSbk05ZWcrRG9V?=
 =?utf-8?B?RnBQNkxGY1gxK1UxZWRLV0Z2cFh1ekFqcnU2ekRZRVhsekM2OUw0b2xTempP?=
 =?utf-8?B?aE5xOHdtTGNMdXY1aEpSb2JTKzBFbXFtVG5nZjVXdnNJaU5Yb0pxemFzcmR4?=
 =?utf-8?B?d1ZGRWhMSDJwaUJMaFJUSzRTMFVtSWNud05pRXlnWXRqZmJBVGU0MkRFYmp5?=
 =?utf-8?B?b2xjTlN3blJESzlQUWw2Y29GZ2owRjJjWE9VZjNJbUdua3o2a1hqenZlZWZn?=
 =?utf-8?B?VlFyeDBXeXAxZE04S0NSV05TZkJVVkVqd3VHZ3Jka1IwckdQVlJKK3loelpW?=
 =?utf-8?B?WFd3Rk41S2t4ZlV5NjZGbzhyQnRFQWl5UlVkeUkrUkVDUy9Cb001dlZ6ZnBQ?=
 =?utf-8?B?L2xieEtQc0xjVFFIUjdNd09BZlRhREI1Z2dZVHMrUGovRy85emhDWitYMFBE?=
 =?utf-8?B?aW45Z3ZscUk3L1pYektPY1BlenhXWnNqN1dGRTg2UDdqMnlsZzlrR3F6QTJE?=
 =?utf-8?B?MU5JS3hrSSszRXJ2THlPSVdaNFdwaEhHWjlWMkJySlZ2YmlaM2RYNWRrRkQ0?=
 =?utf-8?B?TEt6d1VkVmk1TnFrSHNJWnNENWN6dzVkWmZWRzZ1NjNsZm5VS2JHaFpGMVJ4?=
 =?utf-8?B?WDBrUFRZbkZSR1BZdEpxb2Z4ZUpQTXE2YVhzdUdsZC9ocEpoTElWMmErSDAw?=
 =?utf-8?B?SnhCbXlTMjdONkVpc2JSN29CTmNDSmVBVE1JV1RiUTVkOUR3d2lXL3FEbmpz?=
 =?utf-8?B?c1lYQjhOU1lqK1dFS0VQbHpSWW1JcUJWOFhOZDMrV2RqWisxNHlVN29DaHJi?=
 =?utf-8?B?cHBPenJ2MVdMZ1J2MERrS0xSS0NGb1lTQWJPaERGN1FLTXVvVGYxVVZYd2U5?=
 =?utf-8?B?RTVMTmpFRE5yWWNIeHYxQzRMVWVDMWhzYkJQbml2VUdxL0k1TnpadWJtL0Zs?=
 =?utf-8?B?T01tWmI5TEVXYmg3aFVxOFFZNEFvc2t3NEgrZm56M2hCcEQvUmZrSjJUWGpo?=
 =?utf-8?B?bTJ4cVc5clJhdkpmUnEzaEpPTWJMSUs0TU1EMlBrTm4vM3RaZDRHMHpmdklZ?=
 =?utf-8?Q?M85X6W25JKQaJwK2f3lwMascF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF67FA1A8F8.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjU0U0NEQTFlUEd0c2dsVTVnYndlMHpNUmlFdzFnaVc5VnVQN0I5UFJ6UG12?=
 =?utf-8?B?SW9Oamw0OEJyUE5yQWxWYjJPRC95bDdZem5UcHRSbE02dDFZN3lZd3AyTWtv?=
 =?utf-8?B?a1FXNElrMVlZa1o2VXJXS2FIUkRxazZLRTRIV3BvRGh2ZHROak1LMmtQRnh3?=
 =?utf-8?B?bXU4dTdwZjlva21IUThDeWFoMnZ4QjkvWkx4MGNpT3JTVkRWTW5KOTZlN1Mv?=
 =?utf-8?B?NXpHNzkyZ1ZsdkRqYlQ1SGNXRkt6cmNyeWxTZWJnbksyV0ZyYWthc2tIMFlT?=
 =?utf-8?B?cFh3MXczRmFwcEwzZkhGKzNqWnRoN0RwakNlREwyUFY3b0RrVGw2REtTc0xz?=
 =?utf-8?B?YWNOWXpOL2NDRFdMQ29rMHRVZFpCOHIrMFhPL1RzcXUyRVc5SDV4ZGErUlNh?=
 =?utf-8?B?NnBPWFZpdE14UkJpUkNjK1dqUEJMK29EZ1FpYjVVdGVyTVQ4RnhBc2dXUit5?=
 =?utf-8?B?S3dYMXNtc0VQOThDTlQ5ZS93T0ZOMkR0Rm1iRlhnNkk5VHpDL3daZCtNV0cv?=
 =?utf-8?B?eU43TFMvMUgwdFkrQVJhUXc1TUdLVzRlV3FiNVVrb25BQ1ZyVyt4RGVKbm80?=
 =?utf-8?B?b1g5VGtNSVN3dEhnK21WbFZGY2F5NHB2Zm9Ic0lMUHpuWTlxOWlkOWxHaFN2?=
 =?utf-8?B?WHdRayt5UERZUnZSRU9MeDdnR3dHRE01Q2xSVWk0S1VxWDRQOXpRd3poNnh6?=
 =?utf-8?B?Y2RqMjYzR2Z5YndQNW1ua1NhTjZEajFhYlQzM29Gemc5UUh6Szg5UkhFMHZj?=
 =?utf-8?B?RnNtc0FtNjBlMVZOTHpPMlNNemtiNHdOdVRqYWZKTEI0cTJXWklzdkthTjVF?=
 =?utf-8?B?YTJpWk80c3FsUTRRRllkSGQ4TGhOQzdldnExcks1S2duLzhoTlVyZlk5MlE2?=
 =?utf-8?B?Q1p0cFNzUmZhMk5Vdnh1VzJZZHh5bVN0SHNHVDZIWENzdmlYWno4Tm5Ha2Nl?=
 =?utf-8?B?cjlMM0R4TFBxenV6SktJVFQxRTBTOFRhdC9jMUlkT0FOOGIwdnR5SUY0KzB1?=
 =?utf-8?B?cy9TNE5uMWUxdGZBL0NpMTNqVVF2c0hDR25UMjM5SVZhZ1p0UEJVZmd6b0p2?=
 =?utf-8?B?dmtORHpjZHJDeFFPQUE2R3UxQnlsNnVCSTBxOWlKcCtSZ3RvaWN4VXpVaEp5?=
 =?utf-8?B?SEJGZSt5ampWVkE3UmJqQXNZd1NMMFY0cUlyZ3RWSnBoa2l4NDBLNktsN0Yr?=
 =?utf-8?B?bWc0UGpkNVNsUEpqRU5mWERnT1hJdXFJYjhtUHVuN1NBMUk4Y2lRUnd5djJa?=
 =?utf-8?B?OFIxbElvSzkzRE5DRks2d3d0dkFVTmpUaUtoTktoNnAyUWV4QlZlWTRyeXBH?=
 =?utf-8?B?UFl2dVpPQnlwdUVrZElKT213SytBSmlPWUpLWVVTeVpQZmRFd01jNnlGTGJC?=
 =?utf-8?B?aTFyR005cURjbG5NdUZFbk5zd0ptUTdGSUdiZHIrNEs2ZEtDUTZDanpnUjFs?=
 =?utf-8?B?WEhVUHRPSEw2TzJRbUdlc2pzcTVnU0c0cTk5bUxFQ01jdTVkMTNDc0JXQ2NH?=
 =?utf-8?B?bXhDT0F5RjBOdXVkQ0xLR3pMR1IzZTJlL05EckxtVXc5L2NZT1BaL2tlV3hT?=
 =?utf-8?B?NmQ2Tm4wZEx0RGRReGtJblJmeFJGWU5wYlJRWHBtcmlReVNZSjRBeS84eFhS?=
 =?utf-8?B?NGZPejlhY25KSWtsMkZFcWR0SThka2ZHbXdOSGFEQThBOThkL285Ni9kMUtt?=
 =?utf-8?B?OU9jRzdGVW5KVzFMdFZqWXJIdnRCWFlLWU4vd0tqVTdSQ2FHdHA0Ym9lYlVj?=
 =?utf-8?B?Mmhodjh5d0FoSnBkdkNBejZSMTBQY2lyUER1aTNkMW14WGZIMnppWEZRenNk?=
 =?utf-8?B?RjV5azRXd3QxUEx2eUU3UG0xTjdzbkM4Q2dXYUJvbDFVZUdZWExORURBc0dQ?=
 =?utf-8?B?S3lVRWd5K0s4bjZtemJDZG0rdC90Y2VNYkdQeUY5RXhKNVpSekFGMERPUkpR?=
 =?utf-8?B?NjhNS3JEbzAzYURQczBOMkVqZnBrNHE3Ky9kaVdXZUVCMlZrQmFWanE2RFh4?=
 =?utf-8?B?c0dOODJnZWpMN1c4WDB2SmFlMmlsRENJK0FYb0FBWWx3Z01SRTJ1Z1d6VTFa?=
 =?utf-8?B?OU1mTTUyS0tWNVBoWUlRMTh0dGpHRUsycWt3SExXMDhmWWtjRFJJSzdpemFD?=
 =?utf-8?B?TC9mNEFpUDFYTUxqZFdldnlyc2VaYlhsK3lRZXBueUR2SVNrOVloWHFtQno1?=
 =?utf-8?B?c0wxZTV5cWJTUGFxdFk4ZWVBT21TS3c0MzhrcmQvSllPVzIrQXdOZDRtRld4?=
 =?utf-8?B?OVBOZDB4YjBwU0ZwWk5jTVBHNkVDRTAvTzZGRk5pVXdiTFVhQ2pVZms0K1po?=
 =?utf-8?B?VklZWE1ocmlqZExvT2lScW1rdTBSY1J0RWhGRnhySTNxNDZHcDlsZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC806A66122AA74389E279BDE736DADB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF67FA1A8F8.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f9e08d-09af-4830-b37b-08de63481905
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 17:17:24.1366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Od48rrlaxQ0t29uGBFWdjsWMooj/xiH1Ish3PWo3e1WDtrwzV/n9egUU1VekFt+fvlRP2uQBxvd2Lee87Tv8VlD3U6RXJtZKqVctsPQAN8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7928

T24gMS8zMC8yNiAwNzo1MSwgUnlhbi5XYW5uZXJAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4gT24g
MS8yOS8yNiAyMjowOSwgSGVyYmVydCBYdSB3cm90ZToNCj4+IEVYVEVSTkFMIEVNQUlMOiBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZQ0KPj4NCj4+IE9uIFRodSwgSmFuIDI5LCAyMDI2IGF0IDA5OjI4OjUxQU0g
LTA3MDAsIFJ5YW4gV2FubmVyIHdyb3RlOg0KPj4+IEhlbGxvLA0KPj4+DQo+Pj4gSSBhbSB3b3Jr
aW5nIG9uIGtlcm5lbCB2Ni4xMiBhbmQgdHJ5aW5nIHRvIHVzZQ0KPj4+IGF1dGhlbmMoaG1hYyhz
aGEyNTYpLGNiYyhhZXMpKSBmb3IgYSBUTFMgY29ubmVjdGlvbi4gVGhlIGRyaXZlciBJIGFtDQo+
Pj4gdXNpbmcgYXRtZWwtYWVzLmMgYW5kIGF0bWVsLXNoYS5jIGJvdGggZG8gc3VwcG9ydCB0aGlz
IGFuZCBJIGRpZCBwYXNzDQo+Pj4gdGhlIGtlcm5lbCBzZWxmIHRlc3RzIGZvciB0aGVzZSBkcml2
ZXJzLg0KPj4+DQo+Pj4gSXQgc2VlbXMgdGhhdCBhZmFsZyBkb2VzIG5vdCBjYWxsIHRoZSBhdXRo
ZW5jIHBhcnQgb2YgdGhpcyBkcml2ZXIsIGJ1dA0KPj4+IHNlZW1zIHRvIGNhbGwgYWVzIHNlcGFy
YXRlbHkgZXZlbiB0aG91Z2ggYXV0aGVuYyBpcyBkZXRlY3RlZCByZWdpc3RlcmVkDQo+Pj4gYW5k
IHRlc3RlZC4gQ2FuIEkgZ2V0IGNvbmZpcm1hdGlvbiBpZiB0aGlzIGlzIHN1cHBvcnRlZCBpbiBh
ZmFsZz8gRnJvbQ0KPj4+IHdoYXQgSSB1bmRlcnN0YW5kIGFmYWxnIGRvZXMgbm90IHN1cHBvcnQg
aGFzaGVzIGJ1dCBjcnlwdG9kZXYgZG9lcy4gSQ0KPj4+IHNlZSBjcnlwdG9kZXYgY2FsbCBib3Ro
IHNoYSBhbmQgYWVzIHdoaWxlIGFmYWxnIGp1c3QgY2FsbHMgYWVzLg0KPj4+DQo+Pj4gSSBkbyBo
YXZlIENSWVBUT19ERVZfQVRNRUxfQVVUSEVOQz15IENSWVBUT19VU0VSX0FQSV9IQVNIPXkNCj4+
PiBDUllQVE9fVVNFUl9BUElfU0tDSVBIRVI9eSBDUllQVE9fVVNFUj15IHRoaXMgaXMgYSBTQU1B
N0c1NCwgQVJNIENPUlRFWC1BNy4NCj4+Pg0KPj4+IEkgYWxzbyB3b3VsZCBsaWtlIHRvIGtub3cg
aWYgYXV0aGVuYyhobWFjKHNoYTUxMiksZ2NtKGFlcykpIGlzDQo+Pj4gc3VwcG9ydGVkPyBJIHdv
dWxkIGxpa2UgdG8gYWRkIHRoYXQgdG8gdGhlIGRyaXZlciBhcyB3ZWxsIGJ1dCBkdWUgdG8gdGhl
DQo+Pj4gaXNzdWVzIEkgaGlnaGxpZ2h0ZWQgYWJvdmUgYW5kIG5vIHNlbGZ0ZXN0IHN1aXRlIGZv
ciBhdXRoZW5jIGdjbSBJIGRvDQo+Pj4gbm90IGtub3cgYSBnb29kIHdheSB0byB2ZXJpZnkgdGhl
IGRyaXZlciBpbnRlZ3JhdGVzIHdpdGggdGhlIGNyeXB0byBzeXN0ZW0uDQo+Pg0KPj4gSXQgY2Vy
dGFpbmx5IHNob3VsZCB3b3JrLiAgSSBzdWdnZXN0IHRoYXQgeW91IGNoZWNrIC9wcm9jL2NyeXB0
bw0KPj4gYW5kIHNlZSBpZiB5b3VyIGRyaXZlciBhbGdvcml0aG0gaXMgcmVnaXN0ZXJlZCBhdCB0
aGUgY29ycmVjdA0KPj4gcHJpb3JpdHkgZm9yIGl0IHRvIGJlIHVzZWQgaW4gcHJlZmVyZW5jZSB0
byB0aGUgc29mdHdhcmUgYWxnb3JpdGhtLg0KPj4NCj4gDQo+IElzIHRoZXJlIGEgb3B0aW1hbCBw
cmlvcml0eT8gSSBoYXZlIHRyaWVkIHNldHRpbmcgaXQgdG8gNDAwMCBhbmQgMzAwDQo+IGJvdGgg
Z2l2ZSB0aGUgc2FtZSBiZWhhdmlvci4gSSBkbyBzZWUgdGhhdCB0aGUgQUVTIGFjY2VsZXJhdG9y
IGlzIGNhbGxlZA0KPiBidXQgbm90IHRoZSBvdGhlcnMuIE15IGFzc3VtcHRpb24gaXMgdGhhdCBB
RVMgaXMgdG9vIGhpZ2ggcHJpb3JpdHkgdGhhdA0KPiBpdCBvdmVycmlkZXMgdGhlIGF1dGhlbmMg
YWNjZWxlcmF0b3I/DQo+IA0KDQpBbm90aGVyIHF1cmVzdGlvbiBhYm91dCBhZl9hbGcgYW5kIGFs
Z2lmX2FlYWQuIEFyZSB0aGVzZSBzdXBwb3J0ZWQgYnkNCm9wbmVzc2w/IEkgYW0gdXNpbmcgb3Bl
bnNzbCAzLjIuNCBhbmQgb25seSBzZWUgYWVzLSotY2JjIHN1cHBvcnRlZCB3aXRoDQp0aGUgY29u
ZmlnIHRoYXQgSSBtZW50aW9uZWQgYWJvdmUgaXMgdGhpcyBjb3JyZWN0Pw0KDQo+IFRoYW5rcywN
Cj4gUnlhbg0KPiAgPiBDaGVlcnMsDQo+PiAtLQ0KPj4gRW1haWw6IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFu
YS5vcmcuYXUvfmhlcmJlcnQvDQo+PiBQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5h
dS9+aGVyYmVydC9wdWJrZXkudHh0DQo+Pg0KDQo=
