Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B176B2C0F96
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 20:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765830185; cv=fail; b=jV5siLG6RKSWe/1AZZ1lQJWo89XrcYOJadts6ZJHrjKV1mI+NwWuoPr4uHWw6/MNUIXgDLb9/wApfBrkr+w29XXLDadrdYie7NDUdGQuLPcpagABghRdPJ18KkCNRrWTG+wsBUlKCyIAHsAm31mxZcy254qfSrpeavboqYZ0WWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765830185; c=relaxed/simple;
	bh=25DCNjpa7iceTriBhWCGb3zdl4KyxJzJhnS9qKAWL/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RDho7zLKf5iNmHIyrLt0p7NXMmux8YfKyiPHmPd6BtqPz9oK6aqb/WlD1Oh4WMQMsClnK7H9aQnXhIMcwhJIsca94dcVjnvJ5yKP1k85D/Q901wfyLD+zXEEBO6Ypdu3iz/yhMrhWjKOufgMgxTguGzddQp0AWOzVC1xlhq/pw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X1cGMIaU; arc=fail smtp.client-ip=52.101.85.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X1cGMIaU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Npn6z49qhIhGJfzuVqzwHTZfaqIK55ZpOjbU+lmLjZZ3+A4ubDntGAAiAnzzV1/ubJ1EtSnufnePRpEPpcFP8lXqLAE/KSJ/cHco5ZxLGYy3UgIHfATRA4m2AElR0IVVtO5vj/5Yr3QaaXRtGmBGOL1VRDJ1lXsgtyV4A/WGxbe041MMajVb0X+c0pYy+9EclrVzbkByaiN/0CwPEdEtfdIrfMSjwAQPi8QTGBOp8vdcYghn2dH9sa7uGA7jfeVi5U6rm/uH4wfXN/PDDkezVceEvQXhVfXrwzcdgJZxLWkc4ZvzxHElxME7+LXSy5EcbWeVnsM/xH8axW8skKjOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25DCNjpa7iceTriBhWCGb3zdl4KyxJzJhnS9qKAWL/U=;
 b=oCB3cQmdr7hh45zqeLzS20/yCSA1IXibclf+Y69+2goy6LExzucaQPyGX6pH96kDEfJxqQmwTa0HUVe49FvLXhcgYHtWDAhsxrVogS5Z+Zi4laDaXto48+BpzddFkbOgNQSLF8AuC+w81Lu4pe78onlIp6ubrFzKqC0pG4N41UwJhRAxzsM2+GHLTI2e9zNXcmj5h8Joz+tkgPE29hueGojdoFEIA2vXqL2D2iPRn0g29JdvOlf4s8f3lveEiDFuClsB6vW4Wr+RoVZHgxgCxthQpuF6iQ6HNmd4KZ7UMPguLp2SDBX6VWnjhnUQy2Zz/kjm607RLQRrzUsz5yiuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25DCNjpa7iceTriBhWCGb3zdl4KyxJzJhnS9qKAWL/U=;
 b=X1cGMIaUettCanPdE1wJdvZoONcMRjnTmJruCWuvCfZuJhCIhQ43EBnrkqwRaw5r3y8d96RdHNLhrkjnO4HRLTG9zR3sSRElNasXD0JTwppbp40kVw6QLnqjTk9rEat/86Y4Ixu8e8nUZ+otyeN53t57kYQEB4Fx/QbeIQcL265CuCiqBYWvMYdfTJ9T+GPGQeIdMO97vA4cPdPmwUfSQZdW18b47sgWtP28OrgxByPBwV3icaKJLiyLjGfEkAhglOWP1tFNTdrxV6ZmTHMq8pxIMmrSNwliAbCwgjajCrdb4UHUulgFDwJfEPowvRhKtlxXJf+kW9XKDX59jp3mDg==
Received: from BYAPR12MB3015.namprd12.prod.outlook.com (2603:10b6:a03:df::14)
 by PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:22:56 +0000
Received: from BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::19f9:cabd:6da8:7e94]) by BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::19f9:cabd:6da8:7e94%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:22:56 +0000
From: Ron Li <xiangrongl@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: David Thompson <davthompson@nvidia.com>, Khalil Blaiech
	<kblaiech@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	Vadim Pasternak <vadimp@nvidia.com>, "ilpo.jarvinen@linux.intel.com"
	<ilpo.jarvinen@linux.intel.com>, Hans de Goede <hansg@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Nvidia PKA driver upstream needs permission from linux-crypto team
Thread-Topic: Nvidia PKA driver upstream needs permission from linux-crypto
 team
Thread-Index: AQHcbgCY1oUB4fkdrkCoSHJ1hAiZxA==
Date: Mon, 15 Dec 2025 20:22:56 +0000
Message-ID:
 <BYAPR12MB3015BB37C50E4B9647C268ADA9ADA@BYAPR12MB3015.namprd12.prod.outlook.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-3-xiangrongl@nvidia.com>
 <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
In-Reply-To: <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB3015:EE_|PH8PR12MB8430:EE_
x-ms-office365-filtering-correlation-id: ebef4b3a-8e9c-4aa5-52f9-08de3c17bb89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Tlh5Q1dhWXA2bVFSdEYvWEhhcHJIalRUZFcyZjFSdDIvaXorRStGRzNYbVFU?=
 =?utf-8?B?ajBWZE8yMG1uYjd4MjJOOXFOMXFBWUViTzY3ZU13WkM5VXFxWTNlRzBKYkl3?=
 =?utf-8?B?bWVGam82VWZwSmtZQU9GbzJaRVJ3Y095VHlVMC9qaFh3Q3NHTDh0TG11TXdJ?=
 =?utf-8?B?QUZ3VjNKN21uakFtcS80RkFidElVenRwS2puMW9XbHM5ellIclZwajVKWTMz?=
 =?utf-8?B?U3RnOXpzYUx6WS9OSnc3M0NaNG5ZaHU1L01VRG5tVTc5N0QyNWFGblVQQUsx?=
 =?utf-8?B?K0h2SGkvQ0pOeUhqeG9vVkp6Y2IxbXFsdW9qU25veTdwKzJCOUVTMmd1M2hu?=
 =?utf-8?B?RXhUVTB6VWhtejV6eEEyMGM3cGJiN3lTSGZHeVNpdGFjZENYNm45Wlh5UkQ0?=
 =?utf-8?B?VlpDemlWd0Q4OFFqd1JYK2hoZkNQVGdPV09OSmdOVGRHbStoSG9aNWYxRC91?=
 =?utf-8?B?bEMvNjhMNDAwTkJDZjNWSU5tamJXMURvMkFHcXg5OFpNQzJXSVRkSHRWUmh1?=
 =?utf-8?B?eUNzVElBdXZDYnUvVzdDdStkNUxTMkZTRWQrU29IVmt3VWNWSHlva1YzWXZs?=
 =?utf-8?B?VXRuZjRwdXM1SFF3V09uZUIvaHk2Y1FGUVJ2aC81S1ZQdzhSVW5Va083WVZC?=
 =?utf-8?B?UlhDQU5JUWxVai9LVERRSEs4MDVDTDNFdFVyOU45RnR3QUxKZmNtVEF2ZzJO?=
 =?utf-8?B?M1JENEFSRzRNNCswakJzMGw4Q01HMHhRdWdXdnVFNW9ncC92ZkdKSnVCUmFT?=
 =?utf-8?B?ZEFYeGFVZVY0aW5kQzlPSUtmL0pOUUJUWGJXZjRLRmdaeUVOd01MeWJ2V05m?=
 =?utf-8?B?OEVZVGRzSkFBNnRyelNNN3dGMHA1ZVBSbjJNcUluMitwOFE2TzZnYjV3Q1Fn?=
 =?utf-8?B?NjdxczRxOXdQNTZQdnVrY2ZxR3IzcnJXd0xlRml0UE5MdGlRQ3p1OFVrak1P?=
 =?utf-8?B?WlJlYmY2YVVWRGxaaUhaTmtwTnoraExYZlVpOEltbnRPVUExRTBuaU1QSWgy?=
 =?utf-8?B?cG9YYjB4aERSWnhwRGVXRHpDTjVmL1pxdmR4NEJldFhGQnpMZXRySnpObC9O?=
 =?utf-8?B?YTRUWXpmUjM0ZnlHZlBmS2ZnWStFM1BSZjZ4ZE5FaWltaXg3YUhGTTAwZ3hE?=
 =?utf-8?B?cXlrM3laSVZrOFk1S3UrN0tFcnlaN2FyRFNUOGNCakNLbkN0RWtLc1ZzWUEz?=
 =?utf-8?B?NDliV2ZBMmFPRzlJemI2ZWZoUFNNL2d4MW9aZVRyeEFpalVoMkpsL1JlTWY2?=
 =?utf-8?B?cjU1VGpzRU90a1pCbVVpR21IQ1R0eU1TNkNRci90bEw1WXJiZFNOakExRjVo?=
 =?utf-8?B?eFlzWlkwNEhJQktrTDFZWU53OWZiejNJbEVOeXd0Q0tBa0RTcHpYYXVzOUhI?=
 =?utf-8?B?Nzkza2VuQlJlenNjK1ZraEVYYTUrMGNEb0NDUURqYjFSOTAwdW0zREY1MzlP?=
 =?utf-8?B?c3VBNUJoSTcvL0ttZHJ0QXk4S3pYZmxFenpOQ2I1NVdORXBxWUhmZTlTVHRB?=
 =?utf-8?B?OGZaMUp2YVNSSCtobkVZS2J3T0xqblgycmJ0MVFzc0ROeXBtbEZ4YTFkMU9N?=
 =?utf-8?B?LzE3Sks5YkNTSG1UOUh0aUd1UjZhbXRvZGl1cEFKeTdKUy83NHdlelJ6cTNE?=
 =?utf-8?B?b1ZFUXc0c0Fubks5RnZHNUpRM0dDK09uMkZpVEdvL0RzV2ZjdjdoTFVRemJo?=
 =?utf-8?B?aU9oVnpNeE1pa3lHZ2ZXcXpGSS9vbjNyV2p4RzQwOFFQZjkzZTc1TzYwV3hT?=
 =?utf-8?B?RFI0TGlkS3Q1VG1ncy96MitWQUNOaDFINDQ4c0EwQlFkVU1KZmdZRHNHRURN?=
 =?utf-8?B?M1o0clNtZWVqVEQ3ZFNiYzcvbTlla2Q5RkZPOVR3THFMZlBPMC9yVU91TXls?=
 =?utf-8?B?QmZoS0YxMDN5azE5MjFpYmtLYkpUTWVPajRCa2E5MllQUjlFVWpDZWFUaW04?=
 =?utf-8?B?UVFtZVl3Mmx2cjI2dnpxYzFOMHVvendsNUQvWlE5ZmFab3UyOENRNTJwZFhr?=
 =?utf-8?B?Z3B4VE9GWVBnSm5KbjU0OGRmR0krR2I3Z1RJQUJTRXdtOE1jZVRDT1YzVjZ6?=
 =?utf-8?B?ajdrbzZJQlcrSWNQNzdhckx4OG9RTGp5ZW1hdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3015.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZTB3TlZacUNYNzAzNm85ZEtuTURxSTAyQWZnNG5yYmhpb1ZWRXpvWmxYL2FH?=
 =?utf-8?B?RlVTVktlWisxNFdHU2JPSTEzT29EU2RXeDR3aW1VWXhTNXlxeG1Td3pSZ1Ay?=
 =?utf-8?B?NW1LZzZJL2gweWFGc1hVeTRTelkzS0c4MDZXV2xTZzNyUUdOS1Z0akp3Tno2?=
 =?utf-8?B?azd1Y0FJR2NUeGlHWjlmUXNHZzgvK2NEL01qTWg5SGg2WEY0VlJVTG1hUU9L?=
 =?utf-8?B?dHkxUmUwL0dQak9IRGtaTTRHZzhZMHMvYXRTNzNIZHFrNzZRcWs2NHNvVytk?=
 =?utf-8?B?ZG9oS0dxR1dtbEZzSFBidFVuYXhkaHFGcW93RjFpeXhBdHdjVkRFdERPL2FU?=
 =?utf-8?B?eDE1b0RDekVZQ25FREVPRlZvaTV1Qk5oNVo2dGw2UWpRMG1ieXJ5eThxSlBw?=
 =?utf-8?B?ZVJocGgyTnRobTFTSWdYeEYrRG1sQ0RzZEw0TkhWejEzbnpTREtrUFh4RUpH?=
 =?utf-8?B?Um5pOXRlZGpmT2p3UmhlcUhWdXlWWnNNSkMzN3piRzlnSnZYNDFITWZqTnlY?=
 =?utf-8?B?aDNZS0dVOGZFeWJ0OFU1dnFDdHhHUkNMUjVUcUdaSmd6RTc5N21leHloVFNJ?=
 =?utf-8?B?ZFhtNk91OGM0ZzgxMVh2ZXcyR0R4THZHcGJlUDRUK3prOWRKUmJIcUkxbm9K?=
 =?utf-8?B?bHZTVlpIeW9RZU9rc0EzY2ZtYi9IeXhCWnh4RDZWeHRaZDNIU0hUelJDSFdV?=
 =?utf-8?B?OW5DYkprWkVvYnphVjFlM2VXbGI0RjRwUjZZY3hSRnhNODhtSWNwZWJqV0I5?=
 =?utf-8?B?bUJYS3ZPMmduYm41Y2EzUzJIcUVHSnBEaG94R0wwSW9wK1ZKYy9RdXNzSERT?=
 =?utf-8?B?MTg2YXpEbFpCSm14MXg5MUFVUE1nMHZTR0xSYkh2b2pSQUlYckw0dGZuTUkx?=
 =?utf-8?B?QkFjNGNVQU9tZnB4bE1ZeFNIak9LcTh3bmxkencrWElaSFhsdHZuSm5ITWRZ?=
 =?utf-8?B?VHpzczljL2NFOGhIQndoTFBnTU16RGErdGF1dVdlS3VodU9xcTBDQnh4UmF2?=
 =?utf-8?B?ZURmbWRncFFnekpGNHRGSjM0bktnZWhNTzJ3bFRxUnNEMCt1d21ub0xxcnJ2?=
 =?utf-8?B?VTRiNkxkNHdUNms0U3RJUkNnTk1oblZPNW5tUjJVdkdackMwZGVoV0laNEo4?=
 =?utf-8?B?NlB1MEp6L2gxYytrZU1waWUvQ3crVjJVelJWQVFPN0Y1SXVyMFBsWmcydGIy?=
 =?utf-8?B?cGpZMmloUFlNbTZOL0Nxbk1qa0RSaTZnZmc2Z2QvRjVYUFBid1hnVjg5b2ph?=
 =?utf-8?B?VUJvbFRubUtqajU3M0FoRmZqTyt0Z1I0MXpIV0xBdXhaeFNDaGwwK0xLdzhR?=
 =?utf-8?B?WG81Um5NNnpUUlA0bmpvRmg3Qk50cE91VlBNNGZXeTYzNTJQbktlOVZXbTlX?=
 =?utf-8?B?YnVLWVlQWGpNZWtnL1ZPVWVPQWl1VUx2QlhYNW1aRFF1Q0s0d2lFYjh6ZzZ5?=
 =?utf-8?B?OE05NXhRQm42dlY3aEZLa1NDUlJKalErVTBOeUthTERnUGpWK0xEOGxPc0tk?=
 =?utf-8?B?ZEU0ZE9PWldTUE0wZ04wWkpuRmlvcmF4R0Uyc1VjbU83b1laUHBKZFRWSjc1?=
 =?utf-8?B?OThDZURYNTMwTzJ6RnhYQTh0YmROaEt6aDFNN2xPeTZmOXIzTVR2dElvYklO?=
 =?utf-8?B?aERIY3hIbDZQcFBKOVBTRFJzTUVJZmdGc0cyVXNES2dGdlNabFphVWVJeS8x?=
 =?utf-8?B?eXNaLzk5SEVlbGdoMHpCM0s0VHlxd0h5TW96LzRKQ1FjUU96bFUrOGhVampO?=
 =?utf-8?B?L3gxVi9tdjVNelN4TWxZM3E3dVpJaUcySTR2UnF1U1V4VDVLRHFrMnNqVXdn?=
 =?utf-8?B?SmdSNXQrV29MS21Scnk5UXZSSXBmd1d4cTkxRnBjSjY3R2UyUUhKcE5ORUw5?=
 =?utf-8?B?ZEtXMWZ4dEcyNFhzcFhWVmNLdnpQN3V0UGw2SkRrQkY5QnVBNG0wdnROV3A3?=
 =?utf-8?B?aC9nWHJkVTdJOVFZNzBPdlhVSEJ6ZmxQdGZKOWVPV212Smd0OGpYaStScEVl?=
 =?utf-8?B?UXJueWpnWXpPSjhWVlg1am9JYkVTN1ZRZTNaK1QwTTVDWVhzRnFQVE9CSk14?=
 =?utf-8?B?ZWJPeXc5RUhmVmZYZ1FtMm9DTjNMM1A4OXBzdjZRczg2K3VNL0hGbU1kd1Ax?=
 =?utf-8?Q?gsdwwurLq8osNEfE+SO7AWHNZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3015.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebef4b3a-8e9c-4aa5-52f9-08de3c17bb89
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2025 20:22:56.0879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +tLHcxtduGvS8EiNf+aKUxt2vTsQIjEZOmdbExbzMT1NIWXYeOXkvOzE5vLqmtXeKf2YWERdIQWQ3LGMJ8kIug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430

SGVsbG8gSGVyYmVydCBhbmQgRGF2aWQsDQpUaGlzIGlzIFJvbiBMaSBhdCBOdmlkaWEuIE91ciB0
ZWFtIHN1Ym1pdHRlZCBhbiB1cHN0cmVhbSByZXZpZXcgdGhpcyB5ZWFyIGZvciB0aGUgQmx1ZUZp
ZWxkIFBLQSBpbi10cmVlIGRyaXZlcjoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIw
MjUwOTE5MTk1MTMyLjEwODg1MTUtMS14aWFuZ3JvbmdsQG52aWRpYS5jb20vDQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMjAyNTA5MTkxOTUxMzIuMTA4ODUxNS0yLXhpYW5ncm9uZ2xAbnZp
ZGlhLmNvbS8NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI1MDkxOTE5NTEzMi4xMDg4
NTE1LTMteGlhbmdyb25nbEBudmlkaWEuY29tLw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzIwMjUwOTE5MTk1MTMyLjEwODg1MTUtNC14aWFuZ3JvbmdsQG52aWRpYS5jb20vDQoNClRoZSBt
YWludGFpbmVycyBhc2tlZCB3aHkgd2UgZG9uJ3QgdXNlIHRoZSBrZXJuZWwgY3J5cHRvIEFQSSwg
YW5kIHdlIHByb3ZpZGVkIHRoZSBqdXN0aWZpY2F0aW9uczoNCmh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC9CWUFQUjEyTUIzMDE1N0VEQUM1MDJEMTREN0UwRTU1NDZBOUNDQUBCWUFQUjEyTUIz
MDE1Lm5hbXByZDEyLnByb2Qub3V0bG9vay5jb20vDQoNCkhvd2V2ZXIsIGl0J3Mgc3RpbGwgcmVj
b21tZW5kZWQgdG8gaGF2ZSB0aGUgZXhwbGljaXQgcGVybWlzc2lvbiBmcm9tIHRoZSBsaW51eC1j
cnlwdG8gbWFpbnRhaW5lcnMuDQoNCldvdWxkIHlvdSBjaGVjayB0aGUgcGF0Y2ggYW5kIG91ciBq
dXN0aWZpY2F0aW9ucywgYW5kIHN1Z2dlc3QgdGhlIG5leHQgc3RlcHM/DQoNClRoYW5rcw0KUm9u
DQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zIGRlIEdvZWRl
IDxoYW5zZ0BrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDE5LCAyMDI1
IDEwOjUyIEFNDQo+IFRvOiBSb24gTGkgPHhpYW5ncm9uZ2xAbnZpZGlhLmNvbT47IGlscG8uamFy
dmluZW5AbGludXguaW50ZWwuY29tOyBWYWRpbQ0KPiBQYXN0ZXJuYWsgPHZhZGltcEBudmlkaWEu
Y29tPjsgYWxvay5hLnRpd2FyaUBvcmFjbGUuY29tOyBLaGFsaWwgQmxhaWVjaA0KPiA8a2JsYWll
Y2hAbnZpZGlhLmNvbT47IERhdmlkIFRob21wc29uIDxkYXZ0aG9tcHNvbkBudmlkaWEuY29tPg0K
PiBDYzogcGxhdGZvcm0tZHJpdmVyLXg4NkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjMgMi8zXSBwbGF0Zm9ybS9tZWxsYW5veC9tbHhiZl9wa2E6IEFkZCB1
c2Vyc3BhY2UNCj4gUEtBIHJpbmcgZGV2aWNlIGludGVyZmFjZQ0KPiANCj4gRXh0ZXJuYWwgZW1h
aWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBI
aSwNCj4gDQo+IE9uIDE5LVNlcC0yNSA5OjUxIFBNLCBSb24gTGkgd3JvdGU6DQo+ID4gRXhwb3Nl
IGVhY2ggQmx1ZUZpZWxkIFBLQSByaW5nIGFzIGEgY2hhcmFjdGVyIGRldmljZSBmb3IgdXNlcnNw
YWNlIG9mZmxvYWQuDQo+ID4gVGhpcyBmb2N1c2VzIG9uIHBlci1yaW5nIHJlc291cmNlcywgbGF5
b3V0LCBhbmQgY29udHJvbCwgd2l0aG91dCBpbi1rZXJuZWwNCj4gPiBjcnlwdG8gYWxnb3JpdGht
cy4NCj4gPg0KPiA+IC0gQ3JlYXRlIHJpbmcgZGV2aWNlIG5vZGVzIGFuZCBsaWZlY3ljbGU6IG9w
ZW4vY2xvc2UsIG1tYXAsIGlvY3RsDQo+ID4gLSBQYXJ0aXRpb24gMTZLQiBXaW5kb3cgUkFNIHBl
ciByaW5nICgxS0IgY21kLCAxS0IgcmVzdWx0LCAxNEtCIHZlY3RvcnMpDQo+ID4gLSBQcm9ncmFt
IHJpbmcgaW5mbyB3b3JkcyAoY21kL3JzbHQgYmFzZXMsIHNpemUsIGhvc3RfZGVzY19zaXplLCBp
bi1vcmRlcikNCj4gPiAtIFByb3ZpZGUgVUFQSSBpb2N0bHM6DQo+ID4gICAtIE1MWEJGX1BLQV9S
SU5HX0dFVF9SRUdJT05fSU5GTw0KPiA+ICAgLSBNTFhCRl9QS0FfR0VUX1JJTkdfSU5GTw0KPiA+
ICAgLSBNTFhCRl9QS0FfQ0xFQVJfUklOR19DT1VOVEVSUw0KPiA+IC0gQUNQSS1iYXNlZCBwcm9i
ZSBmb3IgQkYxL0JGMi9CRjMgYW5kIHBlci1zaGltIHJpbmcgc2V0dXANCj4gPiAtIERvY3VtZW50
IGRldmljZS9yaW5nIGlkZW50aWZpZXJzIGFuZCBpbnRlcmZhY2UgaW4gc3lzZnMgQUJJDQo+IA0K
PiBJTUhPIHlvdSByZWFsbHkgc2hvdWxkIHVzZSB0aGUgc3RhbmRhcmQgaHctYWNjZWwgY3J5cHRv
IGtlcm5lbCBBUElzDQo+IGZvciB0aGlzIGFuZCBub3QgaW50cm9kdWNlIGEgc2V0IG9mIGN1c3Rv
bSBpb2N0bHMuDQo+IA0KPiBJIGd1ZXNzIGFuIGV4Y2VwdGlvbiBjYW4gYmUgbWFkZSBpZjoNCj4g
DQo+IDEuIFlvdSBjYW4gbW90aXZhdGUgd2h5IHVzaW5nIHRoZSBzdGFuZGFyZCBody1hY2NlbCBj
cnlwdG8ga2VybmVsIEFQSXMgd2lsbA0KPiAgICBub3Qgd29yayBmb3IgeW91ciB1c2UtY2FzZTsg
KmFuZCoNCj4gMi4gWW91IGNhbiBnZXQgYW4gYWNrIGZyb20gb25lIG9mIHRoZSBsaW51eC1jcnlw
dG8gTUFJTlRBSU5FUnMgZm9yIGRvaW5nIHRoaXMNCj4gICAgb3V0c2lkZSBvZiB0aGUgY3J5cHRv
IHN1YnN5c3RlbXMuDQo+IA0KPiBTb3JyeSwgYnV0IHdlIGNhbm5vdCBtZXJnZSB0aGVzZSBwYXRj
aGVzIGFkZGluZyB0aGlzIGN1c3RvbSBjcnlwdG8gQVBJDQo+IHVuZGVyIGRyaXZlcnMvcGxhdGZv
cm0vbWVsbGFub3ggd2l0aG91dCBleHBsaWNpdCBwZXJtaXNzaW9uIHRvIGRldmlhdGUNCj4gZnJv
bSB0aGUgc3RhbmRhcmQgY3J5cHRvIEFQSXMgYnkgdGhlIGxpbnV4LWNyeXB0byBNQUlOVEFJTkVS
cy4NCj4gDQo+IFJlZ2FyZHMsDQo+IA0KPiBIYW5zDQo+IA0KDQo=
