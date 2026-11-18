Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794993978;
	b=Y1ci+EzDobDmNw9mDUj3fpvYXVVWNklG6uuxZylMlqcqq5Ov6VH+Um4sN0AuDTTwjGpC
	 hzAJrkl6vKGzn5WyaZeYWHDzInTMCU44a2xy2oWOiFm8G/HoynaWP/eEeSR5Nd/JsBKKo
	 hbRuvABKrKlONd7qx/AebHxgbxXD66zDlVJP0Dw21RmyRit6kBzAWqMXJ8t84AJG4Mnjz
	 FHhUhCjC9YGNPAvl9V/l4U3nyovvvSNRbqIT6DitV79jP2sSPRL3r6kFHs87/1IGqlPXr
	 WP3Xd7joIVsEU4XSrWaWot8KX2WO/65S791OG3C/oXTr0EHNdcRiF9dhSW33ZcwGNOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993978;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ld-processed:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=tiXZ7Bb8uJdTor9JWR6wdp0zJlMc2oZJHYiICGFONsY=;
	b=wyNUL/6Sx5tjSGbQYcnw8n27NuMsW1Z1tW+K0CZijGri8atD0N6kN+8T1JrvyBJB2Nzp
	 jmFTk3B38/0zonyZSevBvoGQ4lBJdY9WD4bz52oFJjOBymWho9MdKARKZPLXCgg537cnI
	 W9AtPzrSGlcwNhnDS8qF1NY40lWX5K02q3CbvuIAN+Iy+9pDcxisJyI8zZkCpe0P2qgcU
	 VBGaON5mvEU/R+ieWH8f3IzocepjVX9Fq5aZ2UFutwD3ifjnVISezYROwxsVgmdB4FGyT
	 w/WDQs3AlbPoL5QVZEGF13gBtvPnTBkS5hiqpQ2ugYXgKsV6GmHq3Ph2WwZbAeECgRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VerP9A69;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=DI3VslOT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6FA606A33A;
	Wed, 18 Nov 2026 09:26:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC6FA606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VerP9A69;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=DI3VslOT
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AI7Y4SR1505415;
	Wed, 18 Nov 2026 03:26:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tiXZ7Bb8uJdTor9JWR6wdp0zJlMc2oZJHYiICGFON
	sY=; b=VerP9A69iy5hVPCHbbqxM8Orh40qNwd7kaTxgsQiwZfCM+XD8/nxjrxxy
	uwDWrfWnD7Tc41rVCupbExluZxxkyXXUc0VOU3eLiQUg8SewXZwyjvc1DuLrV657
	xl+U2eWcUQ0/OPByE/MF/FMuarPXi1xWInFkRa/LSN+oXHMVm+jtmpouYVLFM5zk
	1Yy+GTu3A5CS0RGBWgcKo+iMrbBmY66Y8VjI4eLEDR89OMnohjR64SwvvPj/3pDG
	OI0gg5b905dRn0z/i4xtVvOA7AqnLugs6LimNBWNQvxMgAW6rk6hE3fAlySGVJNU
	flEGpnQ+BXRgx6RTEelJptBtSPbGA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011043.outbound.protection.outlook.com [52.101.62.43])
	by m0380145.ppops.net (PPS) with ESMTPS id 4j0yuvb5gx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 03:26:10 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oXZH3RjpUnfhBQudSOU/RYF9xQnPRQ6DEBlZKAfJdhgTQePT0A5epUp/ooMqmhi8H393WpDEvrSSlLq/txLFtM2Lx+mDbC4y6AcSidgRs9t0UevV++3KGlU6bolKvxm6Yo39avDE3tSzllIXTO9hd8Pufqt1tR7H52aDxvmB/ZWaaxIiUTxtSMX+B0yIXD+LGxWCHGE2cvYVZT8CVqoWFTDi5IBJVTPKBSDi8xeXSXCPTm9y+csV2jBcvwO7uHvmRRuXt7VSGSM7hgg/roDcMIG0fRvy7tjsXSCg6bT0JutcGO26OR6V2o3woj+HNJyB9iQr8pcioqMH/ewXHaqeyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiXZ7Bb8uJdTor9JWR6wdp0zJlMc2oZJHYiICGFONsY=;
 b=anjaNaBQqy03r+VOon2pxFOHfpU+t++HSgczVKasDpcRecTuJmgJNEQ9IW28S+UlOHejugNAcgSJytYDmw2e7hTKZyfcYoZjeoYgcoR+tnIuJuWDC8q0tCbDgu+QfNMNshurDwdTgchh0bz0XHWy+e+UeQuVfFuX51X9yS9j+LKS3V2uTuvdYute+I4rWFoaUqrswCOEfQBqjw52D7MLf5shxQbtnlpmHsV+YLb67GeRh7BRN9AfDdgSqpZvnxEKnEpypkdPL0oowLS+hdiYHH18hrhy2qupqQfauq6Dfl7+8gMGGNQWWWXrQ85be5D+RglNMzTMA6+PFY+HguYM0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ti.com; dmarc=pass action=none header.from=ti.com; dkim=pass
 header.d=ti.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiXZ7Bb8uJdTor9JWR6wdp0zJlMc2oZJHYiICGFONsY=;
 b=DI3VslOTYIdMMGLYqkR6r18N/H73n2+dVmpHNOkH26HowOrwJ/AYUzp5SbElhdDCpa4pYEuNQjGEz/i9rKsh1fBOqziu+Jt/rurFEx0YSWqX94U3go4eCrh/TYi4YpmOyliwJY7oVQn/IhqffBT9MIWP9mUfQq42xFFH4iTBWvo=
Received: from DS7PR10MB5926.namprd10.prod.outlook.com (2603:10b6:8:86::10) by
 SJ5PPF4D4E723EA.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Wed, 18 Nov
 2026 09:26:02 +0000
Received: from DS7PR10MB5926.namprd10.prod.outlook.com
 ([fe80::9f2:2f8c:c52e:b048]) by DS7PR10MB5926.namprd10.prod.outlook.com
 ([fe80::9f2:2f8c:c52e:b048%3]) with mapi id 15.21.0615.012; Wed, 18 Nov 2026
 09:26:02 +0000
From: "T, Pratham" <t-pratham@ti.com>
To: "Chawdhry, Manorit" <m-chawdhry@ti.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "J,
 KEERTHY" <j-keerthy@ti.com>,
        Colin Ian King <colin.i.king@gmail.com>
CC: "Davis, Andrew" <afd@ti.com>, "Gurudasani, Kamlesh" <kamlesh@ti.com>,
        "Kumar, Udit" <u-kumar1@ti.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 20/30] crypto: sa2ul - handle transform initialization
 failures
Thread-Topic: [PATCH v2 20/30] crypto: sa2ul - handle transform initialization
 failures
Thread-Index: AQHdbB/HO4VoOsKSEkG2pMFwq1nvKLczpWYA
Date: Wed, 18 Nov 2026 09:26:02 +0000
Message-ID: <0ce0ffdb-d86d-4d3a-842b-e960ddf19a9c@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-20-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-20-15ab90b3f9c2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ti.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5926:EE_|SJ5PPF4D4E723EA:EE_
x-ms-office365-filtering-correlation-id: bf951435-facd-4563-22da-08df4555f6d5
x-ld-processed: e5b49634-450b-4709-8abb-1e2b19b982b7,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|6133799003|4143699003|10067099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021121427099003|56012099006|261102123227099003|38070700021;
x-microsoft-antispam-message-info:
 Oin2gFAHewZf7CG/cHbV9rVC7kAH/0NFRtDJGzYhQPfYbEn5EGcQ72OUTsW+p9ZvaY9OY1Dcj8PBsXVmJdsinXJlmRCT1GvyV+Mu2P/oICFDDZCF0MUfGo4g4sUVeQ4yupq+EtB4k1Jhwmex2rI0hEoBo/w+D1qtRN2lC/cnOX0K1xWgwSKr5N/sJUZ7E9Tw+EMxYWNbOmh4HRiyjrgxvO2lhDb7UYLU7EaCCXdtqLNwyG4MBUnSTV+MDvzlueo1srJFyfgzGk16bvheIM49wSGKiI5zWvAOJEXzgs/j1XhaY6s/hJ4IZO+E3g8hECbVIeKkquzDFmqdpFDgmdlFsgtURSHKBw2mDSJs+QhgWX2j4fN1wy6TnbAVX6+qpilPf7zEV/KVgUfpxMnBbmFMB4niKDfjgKmwztGSd52moNKNmac1TYRobImz66goz+OlyHxJyKkO80//MnSU+vnva+wJ9rYy3MO7j70QwgqeV07WW3W6lfZkgLz8qa5yD8EQ5AqfNsx4+kMTSHJgJN8fYnZ7zLv0t2tSA8jpjuZU8YAac3VHHBCGaipYmE2eztoLQSWakeDb2tnhy3bM15ua6lkXjTGykCwzCXLfosILgkSLMkOnW65sVvzBhcEoFsd6dPG2f6Mz222X2pa0GvhQY4/t+Q1V0LuyBdwGwUWtoVG8aCKJEAKo4EBbrz3yQqozPRtAA5AtstOKJ56ZPHca18yO36vX/5ZUGKZANyKAgpg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(4143699003)(10067099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021121427099003)(56012099006)(261102123227099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y0Fkem5CYTZNSEkzc0ZJS0lKcVVFOGRkaHJNb3VSOEY0WUlWczg1dkpLSW1V?=
 =?utf-8?B?MFh0elJIcmcrNkt0cjhzU2RlbS9vMW1pOTIwZkFwZUFBZXpuR29WRk1hNGcy?=
 =?utf-8?B?a0RtTk5mTStDUkJBZ0xYUlpXQXYwVW00K1BaOS8wU242MTE3d3Zqa0dZdC92?=
 =?utf-8?B?TGx3QXRwS05NTSsrU0dwQjZpenhEL1VTaXVWTXlzZjFDUXVHOWNnSmxJaCtM?=
 =?utf-8?B?bk5haEUyMzE3cUJWZFdCd0dRTWM1U2JoT0Flc3NHL0hiRmp1eHhid0h4YzVh?=
 =?utf-8?B?b0J1bmVNWHVqdURYaUxvQVFHS1dQaHZDMlE3WkVmZ1c5RGpEeVdKODhZQytG?=
 =?utf-8?B?MDBoNFJUYnZQWmlEellwTVpyVW1HMUl2ZlFOM0JMV1AxSTYwZ0o5S0k3Q09H?=
 =?utf-8?B?TWdoajR4akV0RC9CSkIrbmR6T1FDSHF3aFVZMUtPMEtON3JPWmNCc0tmcmFw?=
 =?utf-8?B?QnpYU0ZGYVVpY3BWczVINTlid1V4Uk0reUNlNEY5b0FjdktJdTJjNEF0YW1B?=
 =?utf-8?B?NXpyb0pCU0RPajZ1V25XaG5aVTZ6QVViRzFrVFNtYk5QOUpad2pRL2s0bzNW?=
 =?utf-8?B?Mmk4WmxLTzZoK25WaVhwZEtKOVYyZzhaTFhieFRGYVpqa0NRQ05pSnlNMmt3?=
 =?utf-8?B?c0NZY2ViVkR3ZWU3RFB2VjhUK1ozZmwwTXMvVEpodmtuQkp5ZlhLVlJjTm1M?=
 =?utf-8?B?dnRjYjFlOTNJUWtwWklUWjNka3hYRGZMNlNRNGVCTnV3MFhzaTNkMENreU9x?=
 =?utf-8?B?cjJwcm1hZ0hUNElyT0RxUnFLZit4cXBVQzBCakxocDQ3MnZ3bDRtanljZE5V?=
 =?utf-8?B?Ym4vNWlySW9NVEZVbUEzUGVENjA4MEgvL2RURTlHcXdJVUZUd0VmYWNzWUFK?=
 =?utf-8?B?bTBLNXVwVWdRd09rR1VWUE1Dd3d1MDlBV0x1SWlZVzNBcC83aTlWUzZneW40?=
 =?utf-8?B?bndSeFJ1NDBDSVNVK0tpTEJhM3ZWZHQzZC8xZzZwYTJDZjU1bkM2cDlMak5w?=
 =?utf-8?B?QjVZbUkyWkN4S29FTW5nSGx1eXdDZ29zUlhvZUlMaHdPb2tjRHBFQ0laMkZG?=
 =?utf-8?B?NGs5MnJRK0xFVmplY0pETDZlUUF3aTFWbHdMK1VPT3UyNXBEeWUzRTJqbFhn?=
 =?utf-8?B?ZFBGb2tQUnUzMU5HeFAvT3E0Mm1LeWw1clFVT05qQmJlQXZFSFpJQlNmVjdX?=
 =?utf-8?B?QzhQUUlXMVl6R2VHT0UwYTA0QjBSOWtkUzNYRm1LTnZiUS9zVGhzK21haDJI?=
 =?utf-8?B?MXd3Nko1NEUya3lIdWNNbFhNcnNpby94bERTNzhiNnZ1Z3RzbjcrUkpLaHJw?=
 =?utf-8?B?am1LTXBseHlyWUtWcGdyT0lodFNmWkJHZTF2YXRPK016UzhCa1BlbWNncklR?=
 =?utf-8?B?dUNwNExZb01TNzV6V0hiTnYyZWZEY2VHMGtNZFZGaERhNjUxd0dHRkQ0d3JP?=
 =?utf-8?B?dHFwV1dSRGo5VTBlSXBTeEVVRW1JMnRPWWMxMG1SSjZGNlJLSXkrNkROQkZh?=
 =?utf-8?B?cGZ1U3dWYkxTd3h5cFU3S0hBT0prR0pvUER5cEE2SkVYVUo3SG5vWEN5K0VH?=
 =?utf-8?B?Y2h1amZqNWZWT2k2cWMzQTBiQkF5RXZsdGJLNXJHUjFZbVFINTAvUk9EVEZT?=
 =?utf-8?B?eEkwU2dCM1BaeWF6M3VSSFBxRkpDd1U4ZzFjMTRFNHRYanhMb2UydzVTTzNn?=
 =?utf-8?B?b3EydDQrRGVIckdsaGpoNzR1SkpYZlpJYVRjSzVhSUMrd0VkOHM1VlNZZElL?=
 =?utf-8?B?YTVFaktYZmJKVkZGZDRiZWloQWQwdndhaUFJd01iWkdCL1NOM2xpZE9YUHow?=
 =?utf-8?B?U0kvTmg0Wm1oSWIwUzZPZ0hZdnFIN095b2NyYjVrK3NMZFhhak1ZZmZjK1Fv?=
 =?utf-8?B?RVNnanpqcGpoYjFTRUpUcEtVd2JtSkZzNGRCdFBqTjlkM0syTDZNRFdSRi82?=
 =?utf-8?B?NU9rTCtXN3U1ZWJBODBSb2JaOUUxSmx2SEtQaVRCRnI4R05MR2xYOW1aUkxo?=
 =?utf-8?B?cHBoMUpVQjNHdnpSWTdwNEtiMjIxbUNKc2hnRkpEaVNISm9sT3VyRk9jNDlJ?=
 =?utf-8?B?eWtQOXRLS2oyN3BZZTF5a0VTSVcwcUQ0QTJLaUpZOTJNNW1qVWEyNXZ4ZU1Z?=
 =?utf-8?B?WDIyOW5QN2dHeHAwb0Q3eHkxYTBMVGd3SWJBWXdIc0VvZDVYdy9uRi9TUDB6?=
 =?utf-8?B?UDgyUEtnVUh1YkJiMW9XVFJwRUZUZG1ESEo3L1FRUm1IMFgySlpCUFJVQ0NH?=
 =?utf-8?B?T2dmN2l0SGdpVUdYUTZLK2RvUExoNEZiZmlSUEJDL2pVVE83Q2NwRUdqMXR4?=
 =?utf-8?Q?OWgWWFzlJXAFw8+6/K?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <425FE449CA70164EB388E08D284C47DA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	T7HLATHQs+wljW2EXY10mf67Xn2XttOjy0SpdzqtpoUu6B6nhmaITRaKRJisGg0+VwEeLb7Wc2TsAw79EBY6/RA5I1UaKMokIUtEuek+dtETwDP6A9QDnvN7sZIIrCrdnkf0rsIVnVHfwCIcUsv3+4OR9FR3uYaPEbLdyAfEn8Gr/AVr6IPszxpi38hUO0rD2aY08gyKe7FrhNE9Jrt4rfmEVhIZ0xk12DCHWcd0X0Q6y03dxs20DTbYlG4Wqek1F7Fw0Q0ND1X2FPQFJCDkyAqRlZQLedcdIbbhuxE66PZRrZ1S7om+zXHI7OjRiPt6KSmXrjZ/lBHWSABKRAGN9Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf951435-facd-4563-22da-08df4555f6d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 09:26:02.5474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNJI0IY4e60a14Pjko8lnFDgWuKK2dehhIZYQXLXXYg72vX70j3ZWSQR39y6c5auU2NgZxk8+IKmAh1pw/XUeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D4E723EA
X-Authority-Analysis: v=2.4 cv=MaT5KJ/f c=1 sm=1 tr=0 ts=6afd6f32 cx=c_pps
 a=mKNYdAcvaxCE01og5pBKbQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=YqOBY3CX-6z5GlzVCRkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: YmgmtRJENo_xOOWTnY3D97V2xK60QTOt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzNyBTYWx0ZWRfX9b/Vf/86oL2r
 xZBqGljaSmO1dKOATRVEaR5scjLwBBcME6b0z3DhJA1WCazoD0sdKFOk5G76BqxwLvTU9bLfWku
 jTFYwL9hrHNP8UIIhyWblO0EprpnnVaQtxCFXBlf7dSSgP5E5YtCn+CkfP3WIfC2rtSvmRP78rk
 JTI01sPOxdF11LOTUp4mFUDjNrQe3RUcA6kpRW05e+pCYqemVPlqv5BAjthzjMC9DrdWPxeDxbB
 pjhFDmMn/y6Sp04HJDErfQm8fo5BQ8o3LgYrMIFX95//tGfsiCYQAfeEXfr468qYItfW2HSrCCg
 mKLy/dxjN2Tiy/7R88AG4rGcnd4IByurwdCx+/B2bP0JmqjbTxQNAWQRABWXYQOjhEO2u2VgM5f
 4D/SveHD/8GPiyg87y6oICauhCnBfkIUCet61DEqzzymVYJd9UcoLgfn7LT37LqA8mQsHga9nrG
 HawayRz8PNv5URr2XJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzNyBTYWx0ZWRfX7kNMD7b24VnZ
 V8VTRu9/yQ3nNJ09JpXOUgDWdlfi8yHWnWx1ktXmEnYLeg1qE3wSUpe/R5pmeKQdAXUyxBKrvTW
 y0HpDveVrcSNvLP98j/R0Jp0aVeb2a0=
X-Proofpoint-GUID: YmgmtRJENo_xOOWTnY3D97V2xK60QTOt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180037

T24gMDQvMTEvMjAyNiAxMToxNCwgQ2hhd2RocnksIE1hbm9yaXQgd3JvdGU6DQo+IFN0b3AgaW5p
dGlhbGl6YXRpb24gd2hlbiBzZWN1cml0eS1jb250ZXh0IG9yIGZhbGxiYWNrIGFsbG9jYXRpb24g
ZmFpbHMsDQo+IGFuZCBwcm9wYWdhdGUgaGFzaCBzZXR1cCBlcnJvcnMgaW5zdGVhZCBvZiBleHBv
c2luZyBhIHBhcnRpYWwgdHJhbnNmb3JtLg0KPiANCj4gVW53aW5kIGFjcXVpcmVkIGZhbGxiYWNr
IHRyYW5zZm9ybXMgYW5kIHNlY3VyaXR5IGNvbnRleHRzIGluIHJldmVyc2UNCj4gb3JkZXIuIFJl
bGVhc2UgdGhlIGhhc2ggY29udGV4dCBvbiBmYWxsYmFjayBhbGxvY2F0aW9uIGZhaWx1cmUsIGFu
ZCB1c2UNCj4gdGhlIGhhc2ggdGVhcmRvd24gcGF0aCB3aGVuIGNvbW1hbmQtbGFiZWwgc2V0dXAg
ZmFpbHMuDQo+IA0KPiBGaXhlczogNzY5NGI2Y2E2NDlmICgiY3J5cHRvOiBzYTJ1bCAtIEFkZCBj
cnlwdG8gZHJpdmVyIikNCj4gRml4ZXM6IDJkYzUzZDAwNDc0NSAoImNyeXB0bzogc2EydWwgLSBh
ZGQgc2hhMS9zaGEyNTYvc2hhNTEyIHN1cHBvcnQiKQ0KPiBGaXhlczogZDJjOGFjMTg3ZmM5ICgi
Y3J5cHRvOiBzYTJ1bCAtIEFkZCBBRUFEIGFsZ29yaXRobSBzdXBwb3J0IikNCj4gU2lnbmVkLW9m
Zi1ieTogTWFub3JpdCBDaGF3ZGhyeSA8bS1jaGF3ZGhyeUB0aS5jb20+DQo+IC0tLQ0KDQpbLi4u
XQ0KDQo+IEBAIC0xNDA3LDcgKzE0MTAsOSBAQCBzdGF0aWMgaW50IHNhX3NoYV9jcmFfaW5pdF9h
bGcoc3RydWN0IGNyeXB0b190Zm0gKnRmbSwgY29uc3QgY2hhciAqYWxnX2Jhc2UpDQo+ICAJCWlm
IChJU19FUlIoY3R4LT5mYWxsYmFjay5haGFzaCkpIHsNCj4gIAkJCWRldl9lcnIoY3R4LT5kZXZf
ZGF0YS0+ZGV2LA0KPiAgCQkJCSJDb3VsZCBub3QgbG9hZCBmYWxsYmFjayBkcml2ZXJcbiIpOw0K
PiAtCQkJcmV0dXJuIFBUUl9FUlIoY3R4LT5mYWxsYmFjay5haGFzaCk7DQo+ICsJCQlyZXQgPSBQ
VFJfRVJSKGN0eC0+ZmFsbGJhY2suYWhhc2gpOw0KPiArCQkJY3R4LT5mYWxsYmFjay5haGFzaCA9
IE5VTEw7DQo+ICsJCQlnb3RvIGVycl9mcmVlX2N0eDsNCj4gIAkJfQ0KPiAgCX0NCj4gIA0KPiBA
QCAtMTQyMCw4ICsxNDI1LDE0IEBAIHN0YXRpYyBpbnQgc2Ffc2hhX2NyYV9pbml0X2FsZyhzdHJ1
Y3QgY3J5cHRvX3RmbSAqdGZtLCBjb25zdCBjaGFyICphbGdfYmFzZSkNCj4gIAkJCQkgY3J5cHRv
X2FoYXNoX3JlcXNpemUoY3R4LT5mYWxsYmFjay5haGFzaCkpOw0KPiAgDQo+ICAJcmV0dXJuIDA7
DQo+ICsNCj4gK2Vycl9mcmVlX2N0eDoNCj4gKwlzYV9mcmVlX2N0eF9pbmZvKCZjdHgtPmVuYywg
ZGF0YSk7DQo+ICsJcmV0dXJuIHJldDsNCj4gIH0NCj4gIA0KPiArc3RhdGljIHZvaWQgc2Ffc2hh
X2NyYV9leGl0KHN0cnVjdCBjcnlwdG9fdGZtICp0Zm0pOw0KPiArDQoNClRoZSBmdW5jdGlvbiBk
ZWZpbml0aW9uIGNhbiBiZSBtb3ZlZCBoZXJlIGluc3RlYWQgb2YgYSBmb3J3YXJkIGRlY2xhcmF0
aW9uLg0KDQotLSANClJlZ2FyZHMNClQgUHJhdGhhbSA8dC1wcmF0aGFtQHRpLmNvbT4NCg==
