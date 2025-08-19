Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3B952F99;
	Tue, 19 Aug 2025 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633289; cv=fail; b=jZoEtUOC3UWVrFNVqROm50TzgLRf9+8XU2qhG2YbCx/65kwR8roa9gyz78asX+WwvMMRea5F5MIEFrpgHq6/Oef2QWZ5HNXRE1EjbALWkbF8evSbW4i3t3Kt+jONrJJ3fwb+AbGYYNQSmZxjN7ZofxuwafH4cIZRfTBIIQ7AXY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633289; c=relaxed/simple;
	bh=sRNtf72i50C3gvgAKgPIJ/gTriLlYuBrioWiR6RVgaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T2iyvSQUmXll8XaD3AZJ6niyOdZZTulQenNQ+2O/zYeFP5/KGPg/5ZhMO4CtNPISi5YTdrFQ+VORhAHGD7+8a4voH1nmdxmc83SYEgSMaJFxeixsa52+10YlMenzcvi1Q4pfeHw8iRe6S5ZilIz1UC4oktp2r/ixKHuJHMxnHfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YSYBwsKo; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YSYBwsKo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONdejiEX5+4jAum65l57JE/G58W7rXziwcdQE98O50dGW8etXG3Rh58nI+a4Amyfewbe0rfeqbPdG3hRcBDgQXdW4cjH7XgLgbVSgnhfgWAEBjNmU5Tu51ZrtAZwe29anqFhUzjyNwczFSvqRw3beTMabKOEdyNUXgfUMwG+CysobjtseJR2LEDvOqD8ooD/hXLjAtw6cugOXVal/4gtanql2yGt6mMqj26qfsXYXKvpcAYbuWo2KHVB2nqlVUi1s2dmxGqgVKiYtvixj50exxGREdMm0lS+OcrEkeRiTWwoVZctu98SEsO5/uyd76bGNQrcdevpUmNcVQTDnN0uBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRNtf72i50C3gvgAKgPIJ/gTriLlYuBrioWiR6RVgaw=;
 b=r5ZwVl5p2XzmPzKwTtmZ+bBcHW5pVzwW3FeEJ8bfQq8X58EVsq5nzEQWFVDuDKavVW1gvsrfq1SFK6fMxr8MSFrntmNzCcykTzQgoWP5utQEYgBUAMxlfhXCgfC3KZPa6QLS6ZwF6ZWgkvvrPnsoWhOXuPABKpkRykpE3pixs0xsjgDvNduGmfhISgTH+KW+dIFSCffq+5hHJDbW/wKzmA2cj/rooGyTNf4aotH+IwBXHpXCnKtk7mMpgw75x9H+PmbWe/sEzYTkdfiVwBscSioN03ni++dTvS0yNNMS0Jv2mDu0hI4viGW1oJpG7zU9vI2pwLJ1Y1FNj0cfTErCww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRNtf72i50C3gvgAKgPIJ/gTriLlYuBrioWiR6RVgaw=;
 b=YSYBwsKoVqFD4VlNPLI+txP51T/r/N1IfR/OMYrfEMHSMDSt36bRN5mZdHLiykZIHIRwo+10YrBuYNjaW35Xhd8QI4644koQPn+Cmqtk4xK42WwOwq+xJPNOiHonMhHoL1cr/7DDGIGh7gfOJ6DKKjec0bPHV4xJMNdU2bwNWZw=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 19:54:40 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 19:54:39 +0000
From: "Limonciello, Mario" <Mario.Limonciello@amd.com>
To: Yunseong Kim <ysk@kzalloc.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>, "Allen, John"
	<John.Allen@amd.com>, "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: Fix typo in psp_populate_hsti function name
Thread-Topic: [PATCH] crypto: ccp: Fix typo in psp_populate_hsti function name
Thread-Index: AQHcDrpv6FiALc6yg0e/O4+41GZJz7RqaLsA
Date: Tue, 19 Aug 2025 19:54:39 +0000
Message-ID: <d0764649-5309-494a-b173-bc04aca2a054@amd.com>
References: <20250816143028.1111603-2-ysk@kzalloc.com>
In-Reply-To: <20250816143028.1111603-2-ysk@kzalloc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|MN2PR12MB4159:EE_
x-ms-office365-filtering-correlation-id: 1a35967c-3131-4ea8-88fe-08dddf5a3b68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MkVjYTh1Q3B3V1ZzOUpzMG53OEpWcVA0eW9GZFZJU05vZDhZVlU2WmNGcGhZ?=
 =?utf-8?B?azBJek1CaUhKdURuSEFjU1RMU0lRUi95L1NrMjFUcFdsczdEYlJYSFpLcHNt?=
 =?utf-8?B?VVYxYzZkWHRKNk1YMFAxNXZ1Y2duUjhCeHRYN3IzVThxeVBZcGhtWjRyZDhy?=
 =?utf-8?B?ZUpJclVIRjVRZlVqZU1QN0V6ZXVlVmluN2ZyM1dHNXlSNnRPVlhkWTMzWml4?=
 =?utf-8?B?QlV5TkFINXdGMUF6UDBLc1REZUl5VzJvUk9vOEhwZ1RCdmV0c2RSVFlKMk1B?=
 =?utf-8?B?c0JKRUV4TkhIUDBZVDd2RDcrenVXRnpsTG1takIxdHRuMkgyb0Y2YVpXQkh3?=
 =?utf-8?B?WUt4N2NlaU0vbWNPUlRodldpRi85cWs4S0U1V3UvQ3FnRFMrSmxwSmFIZGRw?=
 =?utf-8?B?NEVxK1hCM1haaG05QS9jOHd5UFhmUnI5WGVYdkM5bDJiZ0JNaC93aDdZMHZE?=
 =?utf-8?B?U0RTb2VkQ0s1VGVSaXBCdjIvK0xnYUFTT2dYaXFNSjVwNnJLZ3B1VUprdWps?=
 =?utf-8?B?RU1ZcG9ST3hpRFl2d29iZmYzYjRydkp4V0c4azVnQ2JpOUJhV1c5dVpQUlRu?=
 =?utf-8?B?dU1oS2UrVUFsQjJXZmV5VVBVV3VsZkV0bzRLS2l3anVKSTRIN3YvUjhOOHZK?=
 =?utf-8?B?Y1lMVnByaEhhcXJIQUhSVjR1NCs2czNpVVJzeTdhUVhJNXJNdDZmQjdwaVpp?=
 =?utf-8?B?TFRSVEhUbVFHWHk1NXpaemEwMWIvUjE5NjJsb1FoeGdBdDlRWDJCbjRrUitE?=
 =?utf-8?B?Rmg0UGV3a1R3eHkwYXVtSW0rVHEyS29DdDllY1JjQmhuTkJoaXpMeGJyem9o?=
 =?utf-8?B?dHBEUXhNRDRITGg5QXRXVGs5bm44NzhqNzByZjRzQWNTZU5XV3JBWlpHS1Zj?=
 =?utf-8?B?Y01QbFFNKzdjMkxKQzFXQ2xzR0NrejhMZzZ0Uy9yejhJZENvMXUzK0k3SWZP?=
 =?utf-8?B?eXVZSFV3anZiSHNvYTh6aFhJT0djYUdXMmFaY1hDR0NYSUZoVTJadVpzQ0hB?=
 =?utf-8?B?ZThtTXFiQU5CZFJLN2lpSU9kKy9iUnZ5Q0FIM2xHOWE0UmFoTFIyY0p0WFVX?=
 =?utf-8?B?Y1FpUGd0bXVpM0NpdTZKOGZ3V2M0cnBxWjBmQU1LTVp5OFhCSXozSlp0OFJR?=
 =?utf-8?B?ekxTbjRlcUlBUHpzMVJPd0I1Y1FJcVlqMjljNDZjR1dSWnFmOFdnM01RaGZ2?=
 =?utf-8?B?RHdxMDl6NDNLc3ZVaVZERGRDVUcwaWRJMURDN1RELzF1Y0gvaHBCYllSdUkr?=
 =?utf-8?B?eGtLVTIyWTBUUWdkNUNqTTZHZU5Hc2psWkJ6b252VlV5VUdzNkdmMy9Na05G?=
 =?utf-8?B?MjVzVCtqQk8rTmE3eDlPQTZuM3lDVUcvOUplRHFHR2ZORm5Ibjg3cXdtLzl3?=
 =?utf-8?B?Y1NOTEJ1N052ZVVmL2oza1FrN1VmVnZDYjVkS2xoTUxZNDhvb3VXVysrK0kz?=
 =?utf-8?B?Q2JQbW1xR3AwejFjdSt3cTUvczVJYmtERExaVDFTRTBmRlVEZ05pUzBENFZh?=
 =?utf-8?B?VTB4cEVJcE0xYmQvVUoyc3IxSTBtc2NxZWg2WEhXUm9ITlA2bGNFd2pEUGxL?=
 =?utf-8?B?bG1sdkZValdrQU1QeHdqMS9wN0VhQzc3aVRvWEo3aFVnWFBOTzl4azI4TTJZ?=
 =?utf-8?B?eC9yVm5uWURlZGx5U3Y0OFp0SlFyZ1JrQU5vQjNkUWZWMWJFSmZabVVoYWtH?=
 =?utf-8?B?SEpsSnk1U29sNVl0eE5VUnhZTUd2R28rTDNPQzg5Z0VzRTI3Z0phbWdmSERa?=
 =?utf-8?B?QlFKQUJ6MitDSG9RM1kwczF0NFhxekVUZ3ZSNXRnb1hiNDdZVk9OaHhEc1Rj?=
 =?utf-8?B?R3NjU2hQWXlHL3V5eHJTclRUbklnQjN3bHZsZi9uZ21aK1JWT3MxMkIvSVls?=
 =?utf-8?B?MU82aHEzNFRuTldnb1g2SGFtUk5xVDNNRVFMdFo5amRVOTFIWW1BOUpkU3Bi?=
 =?utf-8?B?N1pTWUg3N3I0eGJLa05nQmkyZWNKeGlMSXdBbTR3d3Z5eVRYNTh2N08zeGZB?=
 =?utf-8?Q?fro7EUjfO6tUuOqQGJ1WJz1mRTeMzY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXBsSXE4UjJRSFVpNzhtZFFiQ2l0Z3l4U0dseElYYUtWTFZRQmMzSmt5T1Zh?=
 =?utf-8?B?REN1cHhFeU81MGV3M1ZxaGNyYlRtMkd1UkpFNXZSMmJXdnYxQmdML0x6cVZV?=
 =?utf-8?B?TmtVbEhOV1VpaVdWQ2k2dXdocjJsczAwRUM5QzkyN3liU25TVE9Yb0VsSllu?=
 =?utf-8?B?cXVEb3VLZXNlL1F0d2lCTlpwMHRWd1JaNVFzRmJpMTZwY09FM3RFMk90S2RS?=
 =?utf-8?B?WVp2cEt0a2lMZG14WExYUzhQRUU5amxhekVHZ2tUTFdOeHNaM3ByN2hDUER1?=
 =?utf-8?B?bDlsMHdxd3M2KzhUZTBCYzJ4ZkhvTDhpZlhVRnZ2TTF2ajIxV2ZZR2R3T2E2?=
 =?utf-8?B?SnA1MmlqcGVVcUtrQ0t5ODFvUUh4c2wvMlhYaHlveXU1dk41OXE5YnlaK0NY?=
 =?utf-8?B?UkNKMzBUbWs5MC9BMEhxeEg1Ullpd25oT05FQkplVkpjU2EwNkZnOHAwUm0w?=
 =?utf-8?B?bmRyWVh5VnlWUFdJcTkyeXY5cW9pV2t1NkJEQ2NWMjEwdEJGODgrM1VPQ1ZP?=
 =?utf-8?B?U3N5b3diaHdZVm13ckhQajRoQWo5dnJGMmljQndNeE1JQVNpK2RYTmZRZGFX?=
 =?utf-8?B?WCsvMlFCeG5aSVJHb1FjRkRSeFpNYnhlRmtvdzE3LzZGb1pjanc2dWt4ZDRh?=
 =?utf-8?B?VlNXOW9XQk9XOStpejFULzVETHlaZ1FFUi9wZW5yZnFEQmF4dHFOc2l6azg2?=
 =?utf-8?B?WE8ybDRxbVZOMk1RZUxiRXRXNXk4dklHQ2Y0SklIeS85Smp1V1JTMHdFaDAz?=
 =?utf-8?B?TWhUZVNjbHI0c0k1dFlVVllIMUszOVdrMlNHdVpxdW9GMlorSzhFV0paTjRw?=
 =?utf-8?B?MS9FUTFIS0wvN2dXekl0c2NlazhQWUFJdllhZE9QVVoyRlZCL0tSYzdGTzZN?=
 =?utf-8?B?YWtKcHBYekNCbCtRYndiQktpWWdBak5rZnV5NTdtSUt1V005R0RsbFV3NThu?=
 =?utf-8?B?ajROZEpIN0xXNVY2WnYvWlFhT1BSU0gxakE5RVhxZU9XenV6UVJmZGVlUVR2?=
 =?utf-8?B?dEZZMW90TFNiblUzalJtUG9OUEZQdTFUQUk3ZVIzVklpeEdEbGNDa0R6ai8v?=
 =?utf-8?B?MmtXZ29jM0JWU1pUdGhseDZmd3hpcndRZkw5UXFlZFU2NEx1d0NTZ05oQmJr?=
 =?utf-8?B?Nm9vbk1aZ1dYR3VEVnlkdnBYQjkyTGZNRS8xeitrVm1HSmlsN1ZudjJrUmd3?=
 =?utf-8?B?dlpyMExtNGpDamZWQzVTL3VjTnl3YjFJZTZ5Q1AvdkZrVlIrdk9uV0VhZ1l3?=
 =?utf-8?B?NlVvM04yU3VRRlBVdW1ZUmo0M2QvdHVzZDFRNXZIZ0NpSm54c1FMcTcxT0xm?=
 =?utf-8?B?RXE4eWlPTnphTk5GTUU3RnVwTGU0K0wwVzZwcmVFblBGemROc1gxWmI4SGpU?=
 =?utf-8?B?aDhnUFBPY1A5dWlGRjQ0b0RKYktBQnNNanNndTdiQ1dpOXJWVXNLWHJ3MTR2?=
 =?utf-8?B?akhMUk9ncnFZM3BaNmR0bk80WGFiRFpCL1N1QnJSZ1pvamRCRHBtSTJZY2Fa?=
 =?utf-8?B?SVg5SURjZ1dicGxqVUszc09sUjYrckhDeVdRQmo2YjAzVkF4a3pDcVlQalUx?=
 =?utf-8?B?Um45MXRPSnZPYkh1WDN5d2VQZkZMWEExQXdVQk9ObVF0aEUvSW4rdnE4RHBL?=
 =?utf-8?B?SDVtWlJwUmROUC9LQndMUWhBTHNEVGFlc0dHejJmQ0dLV3JmbC9vQXE0KzRF?=
 =?utf-8?B?TFRPQ3J2cEVmTTdIbDI3V2NOdDVIa0tWRmpvbndtcWFvVXBQZGFoL2ZDK053?=
 =?utf-8?B?NFFXMEt3QStFbmdvRGNET3B6a1FDS2pKYWdwbGtVY2E2MDVFUmRucWZXRXRN?=
 =?utf-8?B?WXhGMnlQNnBwUExBSmljWi9RcFpJbGpTbENjUmJxVWRkUTJCNGFkcFlBUHVD?=
 =?utf-8?B?eE1XZTFQcFRQclhQVU0rYXpVejdEYlY5Rkg2MStBelpIb2ZYanRMZ0dMWFpH?=
 =?utf-8?B?VGNjTXBNZ0IvSSt1VGJlelBRMXZqREFnRFphNmpFekdBVlRlYk9XUTN0NUsx?=
 =?utf-8?B?aGUvUlZKNnJDd2NNZFZjaUZrNGErNGQ0TGRQMU8vY0JIdEwxa2d4dThIeVkx?=
 =?utf-8?B?S1FENDVtTzJvcFBTZHRsNktncjBGOEh1TGN4VzVhYmw1LzJhTzZHYlVMWTZF?=
 =?utf-8?Q?meKU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7FA404B7D65CF44B5FF7FD719132365@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a35967c-3131-4ea8-88fe-08dddf5a3b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 19:54:39.2608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBRutvxhPD4OOVqssTZXFJOel/+edwNVLgh1gSU+umG0vsWvY6PXtdNmonrQypi9QIqWYgHuiurt2ytRfyQzGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159

T24gOC8xNi8yNSA5OjMwIEFNLCBZdW5zZW9uZyBLaW0gd3JvdGU6DQo+IFRoZSBmdW5jdGlvbiAi
cHNwX3BvdWxhdGVfaHN0aSIgd2FzIG1pc3NwZWxsZWQuIFRoaXMgcGF0Y2ggY29ycmVjdHMNCj4g
dGhlIHR5cG8gdG8gInBzcF9wb3B1bGF0ZV9oc3RpIiBpbiBib3RoIHRoZSBmdW5jdGlvbiBkZWZp
bml0aW9uIGFuZA0KPiBpdHMgY2FsbCBzaXRlIHdpdGhpbiBwc3BfaW5pdF9oc3RpKCkuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBZdW5zZW9uZyBLaW0gPHlza0BremFsbG9jLmNvbT4NClJldmlld2Vk
LWJ5OiBNYXJpbyBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4+IC0tLQ0K
PiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9oc3RpLmMgfCA0ICsrLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvY3J5cHRvL2NjcC9oc3RpLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvaHN0aS5jDQo+IGlu
ZGV4IDFiMzlhNGZiNTVjMC4uMmUyM2ZmN2YzYjE4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2Ny
eXB0by9jY3AvaHN0aS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9oc3RpLmMNCj4gQEAg
LTc0LDcgKzc0LDcgQEAgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCBwc3Bfc2VjdXJpdHlfYXR0cl9n
cm91cCA9IHsNCj4gICAJLmlzX3Zpc2libGUgPSBwc3Bfc2VjdXJpdHlfaXNfdmlzaWJsZSwNCj4g
ICB9Ow0KPiAgIA0KPiAtc3RhdGljIGludCBwc3BfcG91bGF0ZV9oc3RpKHN0cnVjdCBwc3BfZGV2
aWNlICpwc3ApDQo+ICtzdGF0aWMgaW50IHBzcF9wb3B1bGF0ZV9oc3RpKHN0cnVjdCBwc3BfZGV2
aWNlICpwc3ApDQo+ICAgew0KPiAgIAlzdHJ1Y3QgaHN0aV9yZXF1ZXN0ICpyZXE7DQo+ICAgCWlu
dCByZXQ7DQo+IEBAIC0xMTQsNyArMTE0LDcgQEAgaW50IHBzcF9pbml0X2hzdGkoc3RydWN0IHBz
cF9kZXZpY2UgKnBzcCkNCj4gICAJaW50IHJldDsNCj4gICANCj4gICAJaWYgKFBTUF9GRUFUVVJF
KHBzcCwgSFNUSSkpIHsNCj4gLQkJcmV0ID0gcHNwX3BvdWxhdGVfaHN0aShwc3ApOw0KPiArCQly
ZXQgPSBwc3BfcG9wdWxhdGVfaHN0aShwc3ApOw0KPiAgIAkJaWYgKHJldCkNCj4gICAJCQlyZXR1
cm4gcmV0Ow0KPiAgIAl9DQoNCg==
