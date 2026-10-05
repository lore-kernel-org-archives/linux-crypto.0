Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4218E2E2DDD;
	Mon,  5 Oct 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219766; cv=fail; b=qOo8+0lnaiymGuZvzXTY0cpGG2m0wn8MbJYu3manorjmaDz1FFHFmYhn+O5xME0KgNpLKCWqy0EeDtd+twOpufWnrD7tKIXK7rzQM/HkXhO5hyd3pbey2MuMaKp8MBqyfzQ0dCxOnN3zsp0tLiGdDZJTnCxO+Tj8dOrdCx8mROc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219766; c=relaxed/simple;
	bh=cAU4R6SCt4gOWn+pgw4BCDhuNkodoJ6ZJ9+XYjEPejg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yx5c1VSLOi8LWofx7zWpyJOfE/pQQ7nlVFzciHdvKcKhZuu9TItVdDco5H0ecb+qelq1fs74qyVDtl0xmk8sBDsQQqw3hR3/QhoeBuqD9ww40/Qt6YY02wJPbeXEd4XpOTFHfspbnd+nQbX2HJZ7jYNk+Rg0x+KP+vxyyWJk758=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=VY8z+7SW; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="VY8z+7SW"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695GOoRb1073883;
	Mon, 5 Oct 2026 10:02:31 -0700
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021138.outbound.protection.outlook.com [52.101.62.138])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4h4983ss25-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 10:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gI1qJp6oNS3e7ODlQ1agkg5Z67/SdWuWgtfVuzwGjpaCnwwC7NnlEhKnmnqf1EaOhsrM88YbK4WqelmOmPKc/yrrGy3vt0cjyMnFkHVEcZwG8+8pin5wGwYqN5pvKQEIQKSWjHJOCczGPzs92xvx6Rr1hgdIDhd1BfZDo5NO7ZxeYDyklT8fF5tUsB4mo03LJkDUv909pjmltzwIbsYeVeAk+ink3kNkpeD776FNDQYJelrB4EtnY6cUayEb5A55/4oI074/3Z3x49THi5+hvYS5XGCb2Se0v/NLXCuHHjRSk2jyVbCH88fjmP/54zlq9ZANR0/TZwnS7/zu717uyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAU4R6SCt4gOWn+pgw4BCDhuNkodoJ6ZJ9+XYjEPejg=;
 b=I2T7pRo8uvF1za6+mE5+RVfhSleGhuBSbcFy5eJT2/AoY06fh55hJnry1uA31MIOV7Fp0u5K+paJMQQG2Xm1X/5xb0T95skeKMmBF2tbl97icNeZtgcpB4IbemPbH2GYYbfkTjlIp72VOShchvZWjRz//gDPzo7cHMi5Dd4fXV/P5am7YbaW5uWXmp72XdOLAXSCXajzypYiEfZnhpFX9g7ZcssX9jpgN5Ue2z9PUYtwzukyzwbCG3pm0Tga4oF2fzhko2xEx5o2B/AhmjfqwbGqnM+qTXu2kYTC5Xk4j0FNyC/f9bhf/DM4vZ+wI5RRCW/CkVXnCg6j5yLwJlRhtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAU4R6SCt4gOWn+pgw4BCDhuNkodoJ6ZJ9+XYjEPejg=;
 b=VY8z+7SWiOcOrqowo+nvYlQEAn2mYBMviUGTZGu+0VtSGQfdVh1REKEVmqgd1lihFJ+HYErxw/fus+Od5Za2zgja1MISLo6WXHafBjfC/Dwmqjc161mEG1ceuiB2bx4o/yA4utRfEKb45BhZ9XnBG67Z7vNmbtEr8KH7BX1hkrA=
Received: from CH0PR18MB4339.namprd18.prod.outlook.com (2603:10b6:610:d2::17)
 by CH0PR18MB4305.namprd18.prod.outlook.com (2603:10b6:610:d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Mon, 5 Oct
 2026 17:01:25 +0000
Received: from CH0PR18MB4339.namprd18.prod.outlook.com
 ([fe80::210a:9dad:297f:3540]) by CH0PR18MB4339.namprd18.prod.outlook.com
 ([fe80::210a:9dad:297f:3540%5]) with mapi id 15.21.0472.015; Mon, 5 Oct 2026
 17:01:25 +0000
From: Geethasowjanya Akula <gakula@marvell.com>
To: Emanuele Rocca <emanuele.rocca@arm.com>,
        Sunil Kovvuri Goutham
	<sgoutham@marvell.com>
CC: Ratheesh Kannoth <rkannoth@marvell.com>,
        Subbaraya Sundeep Bhatta
	<sbhatta@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Srujana Challa <schalla@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Tamar Christina
	<Tamar.Christina@arm.com>,
        Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [EXTERNAL] [PATCH net] octeontx2: use arch_extension to enable
 LSE
Thread-Topic: [EXTERNAL] [PATCH net] octeontx2: use arch_extension to enable
 LSE
Thread-Index: AQHdVOXYzAVs2Ij4PEKxkOeB3PGserbvKwWQ
Date: Mon, 5 Oct 2026 17:01:24 +0000
Message-ID:
 <CH0PR18MB4339032CE91B812F87ABD9E1CD962@CH0PR18MB4339.namprd18.prod.outlook.com>
References: <20261005162137.71397-1-emanuele.rocca@arm.com>
In-Reply-To: <20261005162137.71397-1-emanuele.rocca@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR18MB4339:EE_|CH0PR18MB4305:EE_
x-ms-office365-filtering-correlation-id: 456579c7-d5bc-45d6-7359-08df23024a15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|10067099003|56012099006|11063799006|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 YMlkbji8OI+y16gJrrquHRVJ6YY2NvqtLvpFXVBKAvpSY2xno7ATfYewPY1XotBKL1smNmjmFMPV8HKRmBkN8wjqZEHOhSOrolUigSCVVh+xjXjJgB+U7Ra/eDvXAv2U/gu96EsuM2HwJ3Cq3rs97RtYHVU3AKU+9vua4sZv8vp6/VPwUOKGpB79l4lnn5nD0rgjy/IAOy1M5TWTN3kE0fkesv6Q0mMk+V3ZkJDosLnnBQg1EzrkVCbU5c77M5/YBNL20nNG5iSefSQFQzRQoVH6QIVcPsPPobW8vCD39nNzpcsSaTNEx3piFbQo9l76aB5q1x/btEXlcZekcSG+DzBN0p+3pzbp5tzXxr831NJbyBMJ7z5T6+qRL5Xys3rOswIRIPHEnjwALbk+LuD9UxYMeQ4E/kybTwB6IX/+TuqF8d17Bce0VtSGV30d2zmPe5/8uN1teircIIGXupkwLoCVoYspqzdFe1r3s8Y6jA6Ipu+fLzqJ8kTa2IHKwmdoqtmskRuYiLwfNMIssEPFivpQSXvjoX5au7nuuSoYKiDWsPN7I2AR4EAFQGc+EmxDzHaoyGZhLzmHFvgW4d0GHXwXcewxSQYnzzldwmYmjRJ23Cmxx7TUblECR+5TP9IcE/3ktYbiSNfozYPgiPS5gAFGeKYbjLO4wCyZNKL2LWyobh+f0sByMVmStgaUz0ZX4zsFD5W9WAaZbPPACHUpYHLAIETkZ4wv9pACNnx2ylE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR18MB4339.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(10067099003)(56012099006)(11063799006)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eFlCUmc0TUp0N2c5WW9nZ2xybGRVdSs1R245T2xORFEwejA5eDd4MllJRXlP?=
 =?utf-8?B?UWJPdGZSQWxIL28yUGU5em1aTkZ3dEZGWnptclJONnBNVWlsM2ozVVhWQjlm?=
 =?utf-8?B?ZnY0VFpaRVd3eG5STTNxZmI2UmpDR3lnQUFrRVo2b1JMUTFFdnJKcmk5T0xn?=
 =?utf-8?B?ZktpQUR3TWk2aDVDSGdaZXNBVVlZdmZ5SkgyeWd3bWhwTlA2RnhVMmZ1Z1dh?=
 =?utf-8?B?NHFzbXIvNTA3SWlvWDIzS01oL3ZJSHZFL2N6MEl3cmFoeThwKy9maDg4KzRY?=
 =?utf-8?B?V0REYjRqVmJhMUVQeVNwZVlkaklIRDZhYTNxUWRNaUxWQ1E0NW45UkRjMUhU?=
 =?utf-8?B?TlpSSTZ0RmVEL0sxZUowdTN0K3BNNW0xYzZtdWlvRW9hSGpwMkQwVWV0TnFt?=
 =?utf-8?B?cUFwaFhkL1VFeFlRRXhhcE9UWnQ0TkwzbmJobWpiUHh4SnV3c2tYcDV6ZGFX?=
 =?utf-8?B?RmdMNnMxMkxxK1RzVmlldWlaWGdQcW1DY0txVk14aDVvbEVNbzJJczY0di9Z?=
 =?utf-8?B?S2ZwQWhlREtwUTZQTlpwYWU5MDdKRThqRTg2WWZVek9qOVJvQ05VL3lFaWJD?=
 =?utf-8?B?dTB4ODBOUHFwdDhkcjBwTUlJdlRiNHVUMEpiWjYvL1NxYzg1Q0FOUEREVEpM?=
 =?utf-8?B?a2wyRnJOZHZmRXpjUTBnYU92SHl1ODVGaDYwR2hOTVU2dzlCUGgrL2RSeFlm?=
 =?utf-8?B?YmRnM0FYSVNKZnM0ellhbFR3RGNlY2lCdDZoekpKRzdoZFBUa3ZBL0dpdmVy?=
 =?utf-8?B?WjlxQk42VElOdDNTb3BzVFZ4YnlhUEdvaUZaalRzQ0hMYW5TWXRNbGZvaVV6?=
 =?utf-8?B?c0pOWEZFRlQ0NWk4YXBpN3gxK3RWc0NoNm5zY2l6ZFk2T1dDT2k4aGNjT01I?=
 =?utf-8?B?TlpyMVhwbTlzK2VtalZnQkh6V2dCRXNKTmx6anhxVmNlRk54VEVVYWtFMUJQ?=
 =?utf-8?B?bmhTSG9rVlZ2TzdscUlGbnFrUEJYTGNSWXdTbndRRzAwdHQyREpYZHJmcXoy?=
 =?utf-8?B?YWxHY0pUdmVKSmNnaW5ocDFnNVZxajZyOC95OU14UkZ3U2JrMEhISVJvU1lP?=
 =?utf-8?B?RmI3cmZhV0RuVTB1bW5NUGs1ZDVVWWhHVU5kNGxRSjdNWTJBQWJuRTNnMHI2?=
 =?utf-8?B?dVFISS9Ua1l5bUx1bzNJOHJrbUorMWMyczZ2c3FHTDBYQWo5S1RZVEpXWVkv?=
 =?utf-8?B?TFZTM2xHOTlidSs0WnVwMk5lQUMwWDc0eDZWWTAxbzRPcjVoU0hPNkxoL3dT?=
 =?utf-8?B?Q0IvY0k0SjdDQU1hdHRJZmViMTh4RlF1YzNHWVRrRVBUZ0gwSzE2Zmd3d2F4?=
 =?utf-8?B?aGkvcUtEdTVYcjlESXBmRVFLWVV1VUJRZUlSQ1NtZzJqVFRvNGZ4QndzY1lz?=
 =?utf-8?B?MW1SMjY4L3VyOTNENDVsWkFJTWU1L3F1Q2dRMkt2Nk5oOHNRWUt6Ym94OS9s?=
 =?utf-8?B?S0hJdmozMjZBdjRXWEVhekVOZFF5Q2NCbGhIbWI3KzJhTUNvVTBkTmZQOHBT?=
 =?utf-8?B?L1I3ODJMWWJiY0c5Tkg2Wi9Lclh1KzNrMmlRUGNqREd5a2w5UFlWMTlzZERJ?=
 =?utf-8?B?S3h2eTdqa3RRRC9QTUIzNmNMbFB0U3NUZjNyK2ovVVVzbGtXd05FSjVRRmhZ?=
 =?utf-8?B?ckRvVnVKYVZRTmJhZlB0S2FxSXI0SjNVeGxydnRBSjdJT1hyZXF1bTJDUFNH?=
 =?utf-8?B?Z201clZBNzJnMEdTSWc4dFRjelFIQmdZVTJYLzJadkNNdzFGZ3Q1QWZYZFF4?=
 =?utf-8?B?WWJIZDBYVFdSTlRFNm1jS3g3VkZDQTdWS2VSUHhhN0RET3JXT3EzdW1RM1BJ?=
 =?utf-8?B?N1RGR1BOOE1xZmdSd2hTanc2ZjZiRHZRWDJiakF1V1Q0ODQ0TUsvaGN6ZU9l?=
 =?utf-8?B?OW1tZ3lrWG5mbFhheWk3NFdYSi8xNHBGT1NBUW1YQ1hJRmVRSXZ4UjhPZ1Bz?=
 =?utf-8?B?RVBzZ1JBU3N0SnNGenoyWUNIZ2VETm5rQU1USWhCUGE4S256dDBiTzh6Y292?=
 =?utf-8?B?QzMvSlhCSTlYWnVjVVVRK0kzRm1paTE5UWpTeTR4a1JZazVySFFORXFmSXVh?=
 =?utf-8?B?aGNvYlhIV1QzNzRxMnF0L3NLSVU2RnBvTVV1Z3RpUVlxVURxLysvWWY1em8v?=
 =?utf-8?B?aW0wZG9RdERJbE5mbHdVNEZZa3pyZ0JsMFdJYzBqN1V5VXZERDNKQVBiRTVP?=
 =?utf-8?B?dlFVUGZlQWpRb1RBenpsZXZqQ0o1ZEdoaEJNeEtaZnNhRVgwODEzTWQ3NHll?=
 =?utf-8?B?bnJ2alhhb1JQSXRnQUhJV29oaVBETWNQc2twNHhTd09naWhMd0FER1kyL0pz?=
 =?utf-8?Q?tC7ZckCnJ7jFzjBR0p?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ksZU3U7GSgvFAsAiEhr3qWd6LMp+5nK49DtxjVw6BGF27TEGNjpYSwtvdofpTbAKTeIBOf2q2PEJ/aD32wu2zeHnwZ4dYOTbK39WfpPaRDyTzz7BZ0PPrs1Horp3KjC93x8fOSOUTynLs4FdLebshcjkD11rmzOdnTZGEyi6ALCSSwNBeTz7BnNP6s005ZyngPXPbGJpuXrsabl0gLqhMyFTxHLbUe4ccn4i3qtkrBWMNZEq2iM4G1vSuC/xFxttV3SXi+s8G3OMKpmqovBWAXzm2yKTs1Om8qOucnK44NtOtmaVxbjc20g/j5khFG8UkNtxtiFIPUmrv5IQfPwBZg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR18MB4339.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456579c7-d5bc-45d6-7359-08df23024a15
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 17:01:24.9129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pNgNiR8dxXCsJCos15S7GP/bcjVUqiUWqJkHmPGKxMRG9TqJ0Lz2e0gVFBb8aqbFB0NUyvcJNo+w9EP6Z8x0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB4305
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2NiBTYWx0ZWRfX9FaEvBWutfNh
 GYQ+hwWIZu3fxhEThekEhOKDarDr2o52swH6Rdpln15QrM4JBpVQtMUa04K3KUi4ZVuG8bMYehX
 OLTVSH4K0xj33G1OC4flA97M+v5zgQwswqdv1hBgx6wjtkGUY0KX15WYHPtEx3POvElcNJF8rLH
 X1lJrSgbqNUkETliDvOEt61dVGxa+Ln8vIZe7IaplZs3864/lgPdo19RhNq6F3g3l0zIHbRnF+L
 0Phh7IrW5dAUib4wWzdMLGFbtdPjS5vCRRJ0GqxoGXvKfAnek0vtUWW2lpaC2+4Au2BIBngVDPZ
 aXR/975YN3VkF+fiwUxOx5Ob3uurGAWJ3GcDq+LgmqRTDvkJCT3UlAGMw2wc4N06KsG6U9xV+aO
 EoIvNLXcJBWo7hSFNgnV0IcFFzKHvKj3RB4AZWknC1qPcGNIKkOeadHJyVtsoe4dP9dnqqBvFWH
 YGgHpYCAm8hJl75+7XQ==
X-Proofpoint-GUID: 4wEgYfhGSy2xqZtZ0SLBRXZQ12-wnwx3
X-Proofpoint-ORIG-GUID: 4wEgYfhGSy2xqZtZ0SLBRXZQ12-wnwx3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2NiBTYWx0ZWRfX9oc1pQ0o/KhR
 kTwAxLytBEjvrf/fUuwfW3wSucjv1haP3Wvzvy14KbuP7QoMhQwTUm02K2UXBR69D1NTKoZzc7I
 WoQsbB60A3nqcycXkRomx/6qmY78+Ak=
X-Authority-Analysis: v=2.4 cv=X+nHu2Te c=1 sm=1 tr=0 ts=6ac3d826 cx=c_pps
 a=td2I9qAig9HcJlooGYrYWQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=7CQSdrXTAAAA:8
 a=M5GUcnROAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=JfrnYn6hAAAA:8 a=L3Ky75s1M_vEGjJmoJ4A:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=OBjm3rFKGHvpk9ecZwUJ:22 a=y1Q9-5lHfBjTkpIzbSAN:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEVtYW51ZWxlIFJvY2NhIDxl
bWFudWVsZS5yb2NjYUBhcm0uY29tPg0KPlNlbnQ6IE1vbmRheSwgT2N0b2JlciA1LCAyMDI2IDk6
NTIgUE0NCj5UbzogU3VuaWwgS292dnVyaSBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4N
Cj5DYzogR2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IFJhdGhlZXNo
IEthbm5vdGgNCj48cmthbm5vdGhAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0
dGENCj48c2JoYXR0YUBtYXJ2ZWxsLmNvbT47IEJoYXJhdCBCaHVzaGFuIDxiYmh1c2hhbjJAbWFy
dmVsbC5jb20+Ow0KPkFuZHJldyBMdW5uIDxhbmRyZXcrbmV0ZGV2QGx1bm4uY2g+OyBEYXZpZCBT
LiBNaWxsZXINCj48ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRA
a2VybmVsLm9yZz47IEpha3ViDQo+S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFi
ZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IFNydWphbmENCj5DaGFsbGEgPHNjaGFsbGFAbWFydmVs
bC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj5rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0tDQo+a2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmc7IFRhbWFyIENocmlzdGluYSA8VGFtYXIuQ2hyaXN0aW5hQGFy
bS5jb20+Ow0KPkplcmVteSBMaW50b24gPEplcmVteS5MaW50b25AYXJtLmNvbT47IEVtYW51ZWxl
IFJvY2NhDQo+PGVtYW51ZWxlLnJvY2NhQGFybS5jb20+DQo+U3ViamVjdDogW0VYVEVSTkFMXSBb
UEFUQ0ggbmV0XSBvY3Rlb250eDI6IHVzZSBhcmNoX2V4dGVuc2lvbiB0byBlbmFibGUgTFNFDQo+
DQo+SW5zdGVhZCBvZiB1c2luZyAiLmNwdSBnZW5lcmljK2xzZSIsIHVzZSAiLmFyY2hfZXh0ZW5z
aW9uIGxzZSIgdG8gZW5hYmxlIExTRS4NCj4NCj5UaGUgIi5jcHUgZ2VuZXJpYytsc2UiIGRpcmVj
dGl2ZSByZXBsYWNlcyB0aGUgYXNzZW1ibGVyJ3MgY3VycmVudCBmZWF0dXJlIHNldA0KPndpdGgg
Z2VuZXJpYytsc2UsIGRyb3BwaW5nIG90aGVyIHByZXZpb3VzbHkgZW5hYmxlZCBmZWF0dXJlcy4g
SW4gY29udHJhc3QsDQo+Ii5hcmNoX2V4dGVuc2lvbiBsc2UiIGVuYWJsZXMgTFNFIHdoaWxlIHBy
ZXNlcnZpbmcgdGhlIGN1cnJlbnQgZmVhdHVyZSBzZXQuDQo+DQo+Rm9yIGV4YW1wbGUsIHRoZSBm
b2xsb3dpbmcgY29kZSBpcyByZWplY3RlZCB3aXRoICJzZWxlY3RlZCBwcm9jZXNzb3IgZG9lcyBu
b3QNCj5zdXBwb3J0IHJldGFhIiwgYmVjYXVzZSAiLmNwdSBnZW5lcmljK2xzZSIgZHJvcHMgUEF1
dGggZXZlbiB0aG91Z2ggaXQgd2FzDQo+ZW5hYmxlZCBieSBhcm12OS1hOg0KPg0KPiAuYXJjaCBh
cm12OS1hDQo+IC50ZXh0DQo+IC5jcHUgZ2VuZXJpYytsc2UNCj4gcmV0YWENCj4NCj5XZSBlbmNv
dW50ZXJlZCB0aGlzIGlzc3VlIHdoaWxlIGJ1aWxkaW5nIHRoZSBrZXJuZWwgd2l0aCBHQ0MgY29u
ZmlndXJlZCB1c2luZw0KPi0td2l0aC1hcmNoPWFybXY5LWEuIFNpbmNlIEFybXY5LUEgaW5jbHVk
ZXMgcG9pbnRlciBhdXRoZW50aWNhdGlvbiwgR0NDIGNhbg0KPmFzc3VtZSB0aGF0IFBBdXRoIGlu
c3RydWN0aW9ucyBhcmUgYXZhaWxhYmxlIGFuZCBtYXkgdXNlIHJldGFhIHdoZW4NCj5nZW5lcmF0
aW5nIFBBdXRoLXByb3RlY3RlZCByZXR1cm5zLg0KPg0KPkZpeGVzOiBjYWEyZGEzNGZkMjVhICgi
b2N0ZW9udHgyLXBmOiBJbml0aWFsaXplIGFuZCBjb25maWcgcXVldWVzIikNCj5TaWduZWQtb2Zm
LWJ5OiBFbWFudWVsZSBSb2NjYSA8ZW1hbnVlbGUucm9jY2FAYXJtLmNvbT4NCj4tLS0NCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfY29tbW9uLmggfCAy
ICstDQo+IGluY2x1ZGUvbGludXgvc29jL21hcnZlbGwvb2N0ZW9udHgyL2FzbS5oICAgICAgICAg
ICAgICAgIHwgNiArKystLS0NCj4gMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvb2N0ZW9udHgyL25pYy9vdHgyX2NvbW1vbi5oDQo+Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9jb21tb24uaA0KPmluZGV4IGVlY2VlNjEyYjdiMi4u
YzUyNWM1NTdiMzhlIDEwMDY0NA0KPi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
b2N0ZW9udHgyL25pYy9vdHgyX2NvbW1vbi5oDQo+KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfY29tbW9uLmgNCj5AQCAtNzg2LDcgKzc4Niw3IEBA
IHN0YXRpYyBpbmxpbmUgdTY0IG90eDJfYXRvbWljNjRfYWRkKHU2NCBpbmNyLCB2b2lkDQo+X19p
b21lbSAqYWRkcikNCj4gCXU2NCBfX2lvbWVtICpwdHIgPSBhZGRyOw0KPiAJdTY0IHJlc3VsdDsN
Cj4NCj4tCV9fYXNtX18gdm9sYXRpbGUoIi5jcHUgICBnZW5lcmljK2xzZVxuIg0KPisJX19hc21f
XyB2b2xhdGlsZSgiLmFyY2hfZXh0ZW5zaW9uIGxzZVxuIg0KPiAJCQkgImxkYWRkICV4W2ldLCAl
eFtyXSwgWyVbYl1dIg0KPiAJCQkgOiBbcl0iPXIiKHJlc3VsdCksICIrbSIoKnB0cikNCj4gCQkJ
IDogW2ldInIiKGluY3IpLCBbYl0iciIocHRyKQ0KPmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3NvYy9tYXJ2ZWxsL29jdGVvbnR4Mi9hc20uaA0KPmIvaW5jbHVkZS9saW51eC9zb2MvbWFydmVs
bC9vY3Rlb250eDIvYXNtLmgNCj5pbmRleCBkNjgzMjUxYTBiNDAuLmE5ZDI5ZjVkNmVlYiAxMDA2
NDQNCj4tLS0gYS9pbmNsdWRlL2xpbnV4L3NvYy9tYXJ2ZWxsL29jdGVvbnR4Mi9hc20uaA0KPisr
KyBiL2luY2x1ZGUvbGludXgvc29jL21hcnZlbGwvb2N0ZW9udHgyL2FzbS5oDQo+QEAgLTE3LDcg
KzE3LDcgQEANCj4gI2RlZmluZSBvdHgyX2xtdF9mbHVzaChpb2FkZHIpICAgICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+ICh7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXA0KPiAJdTY0IHJlc3VsdCA9IDA7ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPi0JX19hc21fXyB2b2xhdGlsZSgiLmNwdSAgZ2VuZXJpYytsc2VcbiIg
ICAgICAgICAgXA0KPisJX19hc21fXyB2b2xhdGlsZSgiLmFyY2hfZXh0ZW5zaW9uIGxzZVxuIglc
DQo+IAkJCSAibGRlb3IgeHpyLCAleFtyZl0sIFslW3JzXV0iICAgXA0KPiAJCQkgOiBbcmZdIj1y
IiAocmVzdWx0KSAgICAgICAgICAgIFwNCj4gCQkJIDogW3JzXSJyIiAoaW9hZGRyKSk7ICAgICAg
ICAgICBcDQo+QEAgLTMwLDcgKzMwLDcgQEANCj4gICovDQo+ICNkZWZpbmUgY24xMGtfbG10X2Zs
dXNoKHZhbCwgYWRkcikJCQlcDQo+ICh7CQkJCQkJCVwNCj4tCV9fYXNtX18gdm9sYXRpbGUoIi5j
cHUgIGdlbmVyaWMrbHNlXG4iCQlcDQo+KwlfX2FzbV9fIHZvbGF0aWxlKCIuYXJjaF9leHRlbnNp
b24gbHNlXG4iCVwNCj4gCQkJICJzdGVvcmwgJXhbcmZdLFslW3JzXV0iCQlcDQo+IAkJCSA6IFty
Zl0gIityIih2YWwpCQlcDQo+IAkJCSA6IFtyc10gInIiKGFkZHIpKTsJCVwNCj5AQCAtNDAsNyAr
NDAsNyBAQCBzdGF0aWMgaW5saW5lIHU2NCBvdHgyX2F0b21pYzY0X2ZldGNoX2FkZCh1NjQgaW5j
ciwgdTY0DQo+KnB0cikgIHsNCj4gCXU2NCByZXN1bHQ7DQo+DQo+LQlhc20gdm9sYXRpbGUgKCIu
Y3B1ICBnZW5lcmljK2xzZVxuIg0KPisJYXNtIHZvbGF0aWxlICgiLmFyY2hfZXh0ZW5zaW9uIGxz
ZVxuIg0KPiAJCSAgICAgICJsZGFkZGEgJXhbaV0sICV4W3JdLCBbJVtiXV0iDQo+IAkJICAgICAg
OiBbcl0gIj1yIiAocmVzdWx0KSwgIittIiAoKnB0cikNCj4gCQkgICAgICA6IFtpXSAiciIgKGlu
Y3IpLCBbYl0gInIiIChwdHIpDQo+LS0NCj4yLjQ3LjMNClRoYW5rcyBmb3IgdGhlIHBhdGNoLiAN
CldlIHdpbGwgdmVyaWZ5IHRoZXNlIGNoYW5nZXMgb24gb3VyIGhhcmR3YXJlIGFuZCBwcm92aWRl
IG91ciBmZWVkYmFjayBieSB0b21vcnJvdy4NCg0KR2VldGhhLg0K
