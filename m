Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793723070;
	b=aDSnn2b8TlGlNIMA5/XGT0vPwJzCIRCeRzBoU8qaG9m5KIOITSWWtcGfxjJfee+A0dmL
	 IxE1IRREU76mDvn/3+nJOXDUvwq9HofQtwMIGmGM1RCugOCkZvYSdaBXwnILAlxn3v9wj
	 /hPT+VbOht2gwSNK9LcNSboNLJVloWNvwzG0AP3g9+GNXUuBJLlos+pE3kVYxfuh1cc45
	 uxFTSoxSsr5MMSlAVOLuvuR6T0mqbjDs9S8iiykdwNjfct5aY0zBpmBjxA3uo/lh5TM5i
	 DyBApSWYlR8GkXoz3QcMnkffE1TfAhtIalvNyLCa64UjOLhnNBpbD9KKm1ji9o3HOgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723070;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=us2Z18GiPGwHJOIixZDUrHXWZaU++0cbRZKDA50yxE8=;
	b=g0e66VELp0YFSo0rLS42CEoY9LoXYTE0Xj6M+J/odF1K/pP6HyYjGt05RGwd2xP3B4SC
	 Aep9TQAt3AlDqKiubLA+EaSTyM4ynO8/dvXNn3Y6p5UKGhCl1Zywl6X0dfki9FmCElyZX
	 iBXcraFGLJ468c1rIWlgf3c3qwMrgZYkulcnPTXwtD+fTGErKU4eWAO90KRznuBV/YLDk
	 8vtsA+e30f3UW6E32wXWWl9+TlEoB8nWAflcSOZvOvpuPnOR0MK2A2wcjPZ4HfUzl4Uu2
	 kglalBL4OMuSKm06RdEDzyVfU2ZJZ3WX1+iCQbsLYizTz5Xl7Oya5LV/NUjqltM+y8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=f+17jHoO;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Y3pTUw35;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7F2606D81F;
	Tue,  3 Nov 2026 16:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E7F2606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=f+17jHoO;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Y3pTUw35
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A3E7p413735208;
	Tue, 3 Nov 2026 10:22:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=us2Z18GiPGwHJOIixZDUrHXWZaU++0cbRZKDA50yx
	E8=; b=f+17jHoOEwLCDNDITDJ1bRQaCLAmhgEmndX7N1sWWyQkSZGqgImL/cumz
	AUyq2erhqgsk4FJa8jZnzBulB9TBb07wvXv9uJnqdxnUHGe3AfcCGLIEb5HEzDix
	utP/z1l626f7dndOlBqZotHdMK41AtJxEx8xx1GwZfufDvgs2Y7u1eM+BaWBIShD
	zox+llwsWvTQDzxsW/sLFzneV6UdKHavnmBO6v0cCn2U/3AYwYrjF1zp8XhgsVnp
	i6OQTH4nChNsN1iJ5GK73p9wCq/TfdNB+MP+dhpvzRJNC4cgK2zXiwMydy44onwQ
	aVb5v4b0oe6uGHWD90H8xaWIqUN2g==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqbaejwmb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 10:22:48 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA0i3nxWdZ8OMMbf4e0lnvc0Ih5ZjZTTeXe2EdkO72l7PBb3iNge3JQganaKU4BiHdjaSUzcL/T0N7Hl69veqHpz23FS8BnUKeMeRZ6L+RQm72rrc92Z0m1OmIx9sSNxGxJ1OM/n7kyzh9TThQKp/a77DFtCUPZluhA8rcq4nVyLJztBLLUkDP5WO6IEMAbj4XRz7p8H8cT+mLGqfT9nDFMguVASQI/bkxuH62H55iK1b+8MfR8mPZEbvS06EbnunLH0IS0ARjn3mO/HbupVUOfu5gY1LmXxw+mZmTXiVtpHINkL+d/LdNjqdukr7k1kTsQyPdXJyW1GfydZJSFwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=us2Z18GiPGwHJOIixZDUrHXWZaU++0cbRZKDA50yxE8=;
 b=hsVgMY4b0TNUA7e2fBZjIKmyBd5wNV/u5NC8e7hfMfZVxuceo9e1AKbfUIjbIOF6JCPxwWhm1aerUtayPPr9JLfRi+cw5S7+pf1Hs3yCZ8D7ou0uOp735yNEKKzp5dvEt3X5mwTzjWpIOCc6kJ8H+7oOOeDkg8t9o2OSJ55jm6msKkt2J9D5oCRe1sSB3RKKtP1GippYTzsXwY1iB/rtz6yk0HdNBwpw6rBsXDLSQUU6f6vRP0phwL5+IdGOs+/jOI1XzZQNBE5h77rcg/+NjKgsvo+FzajXpO3vpvUYJDOD3c+nMpA60gTYD3RgCoDdMJCfjq80IzJZN2MvIp/z+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ti.com; dmarc=pass action=none header.from=ti.com; dkim=pass
 header.d=ti.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us2Z18GiPGwHJOIixZDUrHXWZaU++0cbRZKDA50yxE8=;
 b=Y3pTUw35K+HD+H0+35qMYTrOC/abuZJDvaNLm3HEhyMIVnumIF0BwuITpA6pxEs2WgHa7XhZUNlZ5xN/s1h+pQmUeoo/vRTCEw+/hIgrwDo6+KLezVgz+RD8Bi9f6upNVmtCbCLkgWilGnaZNTXYmrXfKMH2cXzJDaCpq6O/JME=
Received: from IA1PR10MB6122.namprd10.prod.outlook.com (2603:10b6:208:3aa::16)
 by CH4PR10MB8098.namprd10.prod.outlook.com (2603:10b6:610:238::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 16:21:09 +0000
Received: from IA1PR10MB6122.namprd10.prod.outlook.com
 ([fe80::adbc:118f:b10d:46fb]) by IA1PR10MB6122.namprd10.prod.outlook.com
 ([fe80::adbc:118f:b10d:46fb%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 16:21:08 +0000
From: "T, Pratham" <t-pratham@ti.com>
To: "Frank.Li@oss.nxp.com" <Frank.Li@oss.nxp.com>
CC: "imx@lists.linux.dev" <imx@lists.linux.dev>,
        "vkoul@kernel.org"
	<vkoul@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S.
 Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea
	<claudiu.beznea@tuxon.dev>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Jia Jie Ho
	<jiajie.ho@starfivetech.com>,
        William Qiu <william.qiu@starfivetech.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Thorsten Blum <blum@kernel.org>, Frank Li
	<Frank.Li@nxp.com>,
        Pan Chuang <panchuang@vivo.com>,
        =?utf-8?B?TWF4aW1lIE3DqXLDqQ==?= <maxime.mere@foss.st.com>,
        "open list:CRYPTO
 API" <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/Microchip (AT91) SoC
 support" <linux-arm-kernel@lists.infradead.org>,
        open list
	<linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM CRYPTO DRIVERS"
	<linux-arm-msm@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE"
	<linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Thread-Topic: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Thread-Index: AQHdaumubW5inhTdSk6/yrACY/bYEbcciNQA
Date: Tue, 3 Nov 2026 16:21:08 +0000
Message-ID: <1d412546-5119-416c-b948-523adff01a41@ti.com>
References: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
In-Reply-To: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ti.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB6122:EE_|CH4PR10MB8098:EE_
x-ms-office365-filtering-correlation-id: 0edf9679-e961-4a7b-e82c-08df39c677e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|18002099003|22082099003|261102123227099003|261021123027099003|261009223027099003|261021121427099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 u8E8ujM28jrNn67C0NaH9VhL/v2B+it8sKIssyxZT1Fd4NbWo1GDnWHH9npuwoEw7VopGAFqoyQWcyDIlhoMfo7ueneZocOoYAqQi5xugH/Do3hfyfHKhTY4wQm21jyYC5Sn2uQX/fff6gjHeFU5Ehaxs7z8AoNP3h1yaS774On+6xG0N+a3uHL+dLuzuPuVGggfuIh78FOmJVE2TdC2ICY6f6hs5UtFpJ4HlsXSFJ4rgQk/JT+mdStcpzakncBipZ4UBSBxb4OeU4u4cb56wosNKOXHslGkvFp65O0rLBXmVYAWRW/SK6HXuuxYRAC7CNpJLNcAUcz+TlywVyP/P6yCgYGXIBNbPwAnRXEBPo/n9w+1dq700BkobwUu4gNkGNvgGFPsmhOCnNXBDUjJKtWx82BgHbQ5RTqcgIsLTtingA9rAHbMIX67stkimsLtomo4j9PTuV22ALWChG4tu3IBAlSrRj8M8+GJB+twwikLMFYvBCBtfjXjmK3g60jpmkbWsS/7506Bw9MTJPSldKluiaO2KKTfhAHxwXptqEsePLq0O5AEeYcPhfOeSLSQtjMYVTrNxoav/fXvrSY21eJU1qc+Wh9eeiPilPGoC96PaynRFzUPXmwsm+lOt7bcUKl/R8n+s1uSd7Ez2/+/96V7lBerq6rrljRfzpEPZ1+dHlBDPqKFjcF+PVQ6CIteS1J3lj4lHOsPDJ2l6nVxON6MdkD/XI/lnIlVxs0MPkU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6122.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(18002099003)(22082099003)(261102123227099003)(261021123027099003)(261009223027099003)(261021121427099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OXQ5L0M0bERyamZqekRBc1EycDJzNGFQd1F3VkdZRXFmbmFnUHlYdTZxc2g1?=
 =?utf-8?B?ZGx0RVJoTzlOa0sxZmtQZUMwSU9UVXpvWGFMZ2ZxUEhJNHdITUhFc0o4Z1lx?=
 =?utf-8?B?T0YyTjZZYWpHZlJ0QTU1SlZGVkY4L1VoQzVUNHV1K3VpSUh1VSt6bnFCbU1n?=
 =?utf-8?B?K2wzUEJHTEZNQTZwVFRQQzFOSWI3eHpOZ2xNOHplMlFCcm9UN05SQnhLSUhm?=
 =?utf-8?B?TzhIZi9XQ3BBdzBpNkVVb1BINEJOTEgzZGk2SHVWNldROEF2djkxTlpxNXZD?=
 =?utf-8?B?Snp2SWdEZlIrSzlyRHJSQ0JDZFFKdGJTcnVtRjVrRkt5clZ6S1d0eWYrMklv?=
 =?utf-8?B?dE1ycWZNZXZLczlZZDgwMVc3TzNMQ0RuaVJuNE1idWdTREU1UUQxZk1PaWdu?=
 =?utf-8?B?N1hGSUJPU0c0c3kvWmo5TkQ2dDRNVGFmbmJqVkpHbGo2UldxQTJLVzNIUTFR?=
 =?utf-8?B?Qkx0Z1NGM3FPQnlqT1g5UzRLK3ZVUEpEUERuOTM0eXdZd2ZRMnNRSHdPYUl6?=
 =?utf-8?B?SDRDYTg3SlhzeEJtR2RENzNVS0JXNHFEZEhoQTNwUi9XNW5VM1d0NmF1WjV2?=
 =?utf-8?B?ekNFNXdnVjZsTk1MeUJFamwyVFAyVyswMnJLOTJxZUNncGJ0UE1YU1ZKbzdJ?=
 =?utf-8?B?NTNNOGJJd0tGbDJ5Z0RMSWZHYVNGei9tZkxUZ3pDQ2ZWQXF4TVU1RndlVEtk?=
 =?utf-8?B?NEhPU0RGQlhEeWtQTmtWcGZ2MXdZUXF1eHhLd0xLQ1l6dklZRWMwSU9YcXU4?=
 =?utf-8?B?UTlSQUYzTzMrTG5lQ2RrR2gxZWdnRnkybXMvdVY0a0psQ3JETzMyTmFMbUJa?=
 =?utf-8?B?bmtSb2JxS1pGRUUyS042T3FOMWg3WmhrK08reXlNeU1GamVMUDU3U21YRndF?=
 =?utf-8?B?K1pDQjRiNGNMTHNTTUtmUXZkQ2tzMGZKeERMMEo4UFUvOHlBU3VHdGF2cVNX?=
 =?utf-8?B?ZkxyVE1mTGN4RXdkOWRoUWxQN0k0U3g2djFyWlQ4MlZIemdFeWdNcndlY2o3?=
 =?utf-8?B?WXk4OVRRemRYL3hRcjFDbUEyT0tVWC9uZ1kvVW1xUSs5YzVPRUlPZ1BvMlBw?=
 =?utf-8?B?Rm5vazQwM2xrbCsvMjA3eDlZMld3K1ZFTGliUUZqMzdPN3VCdWZveGpCdHIz?=
 =?utf-8?B?dEtNcWRMYytuY3hoc1Z5ZjNhR0FaSm9peDU4Z1A4Zy92eGY0M2NENmRaT0Y3?=
 =?utf-8?B?dkM2aWE2UTlLSEZpRG9rWVNnLzcwV0x2b0xFcDBWb3hGbG9KbmFaSkttWjFD?=
 =?utf-8?B?ZzhTTDFzYWtGTmVaeDFYQWR0VzhJY29oQU1QWk4rUUIrNVJla05CRkJRMHZX?=
 =?utf-8?B?UTFOa092NUZMeDlvVGxJdzdsY1R3d1NISXFMRzM2TXhGblJhOEh2cFVsUHJs?=
 =?utf-8?B?dHQxK1B4ckpxZGVhV2RVQVV5VEFlS1czV3lWSFhiUFpZaU4xeEhTek5QZFhM?=
 =?utf-8?B?TVZPbHk2NXZ4TU5wdGQ4WHl6NWR4TkRyQm94REwrYXpkZkg1ODYxY05UeVM1?=
 =?utf-8?B?TWJhNjZFcTlMRFIzZGViRUkyc2dYMGRtaWRDMi9lekovSUF6cWVEaEQ5NGo4?=
 =?utf-8?B?YUtvWkxWTzlBN2dVY0NYTURJZExjemR3Y3VOZGgxb0RhYWFoWUxLMXlSUFds?=
 =?utf-8?B?RGp0VlQrdGNCQitWdjg0M2swWjFHTTFxK2hwUGFXSXl2UlJXQlBUVHl3Mjhu?=
 =?utf-8?B?SlozSnA2eUdlaExFTHlZMGFnbnhVSHhwbktCUzY1MXAxQ2cwbEVsQzdNeW0y?=
 =?utf-8?B?bkhBMUtBS3FLTG03Um83V1ViKzA2NW9xZHlGalZnNGRFMVI2eXNBUkNiMnNE?=
 =?utf-8?B?OXBWbkg5eDVtbjY4ZWQ0eWJSSmg5c2s3SHdFbmxMMHRMK29MMTU4S3JXMmp0?=
 =?utf-8?B?M1p6U2JGNlQvUzdEbVN1TGRCUHY5ZW9GMTA5MEFiYks5YXdUdks3OVhsbmF1?=
 =?utf-8?B?RExzdjFKc09nMTBpUm9MK2t0UUJZWVpKRDN0T01nUTVOTy9EakhtdjdZTS8w?=
 =?utf-8?B?WjJrcXAvU3VHdGxpdjBONTNpWTlySzFldk5VUG52VnQwMDBiUmk4TUZ1OVNM?=
 =?utf-8?B?SHEzc3hHUDlKTVllVTA4TW4xVk1MU2FTMnVNb0o2YmErUHBaQ2Z4M2FUOFd6?=
 =?utf-8?B?c2JvS2U2Y2orR0J1YnBYdzQ3L1RHdnFWbFYrMEhJcGV6bVNrUGkxc3ZUcmtw?=
 =?utf-8?B?N1JMRitTNVpEMG84WnBnT1VCb0lHZWpQbnZOZ1hrWHNBc1BpeDBZbDVaVGRw?=
 =?utf-8?B?d2xqdDZSaXRhSDYveWNXSTV1SG1rZXF6emlHV3lRRzMxNDlENitOUndXajZv?=
 =?utf-8?Q?88qisQSlhnfOsW7rPk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E9384CC49862043A28FA5EBA2B8323B@namprd10.prod.outlook.com>
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
	yU3uiCWKKYg63k+WqNWcygNx/tHURKCOL7rns/gE1xz7JFwXkvQ8Y6olV+uWJj6SB6excl7dAfG5JGiHVZ0ItoZEr64eZ39G5ZnA43OJESA2uP8Rpg/pnK9HMlerSO3uRiG15xlNi2cu5BkS1rAXQMk63r4EJBi6URUKbVopHDug8exkBzn8pfC2iOCokPALgkTIE2kTrDa96WI1h8g7iZyjopStLQWw3J7om3DzkoKlauELPATtP+VziYhZFTjJZHM5iqxbPaStLuBunNERYjoLAmjqNZ0pTJDI4ie6DPtSibcMtBVfmRt/d+8VzYxdUdIF2dXy1MY0YMdb+K18iA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6122.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edf9679-e961-4a7b-e82c-08df39c677e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2026 16:21:08.7536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/Hjeo6DRj2n9zrKeLlnpCrgT4d3tmfiGQpbuSEufMpVWUERDLx1P+M+Z2Z73aqwd94vbiG6MnUbBFuJnPesBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8098
X-Proofpoint-ORIG-GUID: wG_I1e05Qk7NhBrDFYy3gzHBXTcpOdyq
X-Authority-Analysis: v=2.4 cv=eYGo7LEH c=1 sm=1 tr=0 ts=6aea0a58 cx=c_pps
 a=QnZ2uEdZlRAtgHxfLCbJPw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=8AirrxEcAAAA:8
 a=sozttTNsAAAA:8 a=yugM23XqmQLCJm96DuAA:9 a=QEXdDO2ut3YA:10
 a=ST-jHhOKWsTCqRlWije3:22
X-Proofpoint-GUID: wG_I1e05Qk7NhBrDFYy3gzHBXTcpOdyq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA2NSBTYWx0ZWRfX1wJ3sg+Gu2j5
 Ar58OzACzeIVGdiN9uXNg7KUgs0ycsR0NVIHb6icROdkInjWK0UWJRdJvGlih5Uc5JX+A0ivcK9
 OKN/OKsz7k1aefT6yAVU6RRXvcNt092StJceaV5xLYYNDBdXFndzzpr0y2loH8/eICnwluRDkuJ
 xzjzSh+iiCSz4kPliQHvrvB7OhwxMODcpFsv1o+jELQu+qDDNG9ZBlPqVt4yEXEjMeLcJhgTDaB
 /ZDBlwcaFghOFrLYTY0SS/FAk1cZ9qbZIMCQ3+cYdnQDfGxhlJzqYxm2ISklGtYf86hHb+SqNoP
 Y7NKCUS+sc2aviu8dLXvnt+owADl63s1y/zSWo5QDkOA3oj2z+cEO1w+9GMXRlMwY529j3aA3Jo
 RPUGmEeRfsOGI/nt9qk/YQ6PVh2kSoj+UsC86I49WgB9exiVQ1mSFrEAk0ybNMruRP2C1t5fkA5
 PNaRv8qmRoeQ9Sn/L2g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA2NSBTYWx0ZWRfX/ARxtcp1bNT2
 mixfGfKCy6YPufFFJpO8GJGLKdZdXAYGr8wbwmqPqMeTGr/RVi7R6yBWkwdmj5Zm9HIgzL3qm42
 wL7B7Y2HoAlS2SYA3gPp07+le2Tj87U=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_03,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030065

T24gMDItMTEtMjAyNiAyMjoxNSwgRnJhbmsuTGlAb3NzLm54cC5jb20gd3JvdGU6DQo+IEZyb206
IEZyYW5rIExpIDxGcmFuay5MaUBueHAuY29tPg0KPiANCj4gUmVwbGFjZSBvcGVuLWNvZGVkIGFz
c2lnbm1lbnRzIHRvIGNhbGxiYWNrIGFuZCBjYWxsYmFja19wYXJhbSBmaWVsZHMNCj4gb2Ygc3Ry
dWN0IGRtYV9hc3luY190eF9kZXNjcmlwdG9yIHdpdGggY2FsbHMgdG8gdGhlDQo+IGRtYWVuZ2lu
ZV9kZXNjX3NldF9jYWxsYmFjaygpIGhlbHBlciBhY3Jvc3MgdmFyaW91cyBjcnlwdG8gZHJpdmVy
cy4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLiBQcmVwYXJlIG1ha2UgdG8g
c3RydWN0DQo+IGRtYV9hc3luY190eF9kZXNjcmlwdG9yIHByaXZhdGUgdG8gdGhlIERNQSBlbmdp
bmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBGcmFuayBMaSA8RnJhbmsuTGlAbnhwLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL2NyeXB0by9hdG1lbC1hZXMuYyAgICAgICAgICAgIHwgMyArLS0NCj4g
IGRyaXZlcnMvY3J5cHRvL2F0bWVsLXNoYS5jICAgICAgICAgICAgfCA2ICsrLS0tLQ0KPiAgZHJp
dmVycy9jcnlwdG8vYXRtZWwtdGRlcy5jICAgICAgICAgICB8IDMgKy0tDQo+ICBkcml2ZXJzL2Ny
eXB0by9pbWctaGFzaC5jICAgICAgICAgICAgIHwgMyArLS0NCj4gIGRyaXZlcnMvY3J5cHRvL29t
YXAtYWVzLmMgICAgICAgICAgICAgfCA4ICsrKy0tLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9vbWFw
LWRlcy5jICAgICAgICAgICAgIHwgNSArKy0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vb21hcC1zaGFt
LmMgICAgICAgICAgICB8IDMgKy0tDQo+ICBkcml2ZXJzL2NyeXB0by9xY2UvZG1hLmMgICAgICAg
ICAgICAgIHwgMyArLS0NCj4gIGRyaXZlcnMvY3J5cHRvL3NhMnVsLmMgICAgICAgICAgICAgICAg
fCAzICstLQ0KPiAgZHJpdmVycy9jcnlwdG8vc3RhcmZpdmUvamg3MTEwLWFlcy5jICB8IDMgKy0t
DQo+ICBkcml2ZXJzL2NyeXB0by9zdGFyZml2ZS9qaDcxMTAtaGFzaC5jIHwgMyArLS0NCj4gIGRy
aXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyeXAuYyAgICAgfCA5ICsrKy0tLS0tLQ0KPiAgZHJp
dmVycy9jcnlwdG8vc3RtMzIvc3RtMzItaGFzaC5jICAgICB8IDMgKy0tDQo+ICBkcml2ZXJzL2Ny
eXB0by90aS9kdGhldjItYWVzLmMgICAgICAgIHwgOSArKystLS0tLS0NCj4gIDE0IGZpbGVzIGNo
YW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQ0KTEdUTS4NCg0KUmV2aWV3
ZWQtYnk6IFQgUHJhdGhhbSA8dC1wcmF0aGFtQHRpLmNvbT4NCg0KLS0gDQpSZWdhcmRzDQpUIFBy
YXRoYW0gPHQtcHJhdGhhbUB0aS5jb20+DQo=
