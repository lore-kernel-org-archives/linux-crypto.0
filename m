Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11012045.outbound.protection.outlook.com [52.101.71.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3CC2236E8;
	Wed,  2 Jul 2025 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751441941; cv=fail; b=kpEC5Mn1jK10yL2IqTnHkUDLbId524NctYkEJVtEgcMsuBtWrJe4a/GvqIEzR7lE086k0IWsvzjx/DQiRBnQCe1XuPp+IudDReYHBaZBp1FWIXZ8Y7hBgkDcC7ZlfKWiUUHLEhsmaBslpyDi+23lL/2yTXR61xAAEkqUCi/kBzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751441941; c=relaxed/simple;
	bh=9Ky7zSBSuxzt5fJz9HXyu92W+UTWA1vD0tBpqr72auY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D1RYc4oVu9OGQyBPVkr8+umjHlEU9ztxaxi+0F60Ttd6F5jmPUlH8B2x0SDNnMbUriyK/PLUq2QHOpt1lM6t1mlz/Sliwu8v9IaMqYayvYHua8mqz8ONN+/+cZW4L+FwqOeJan1T1i+f0KRGCvoG4vkE8lW6YKkyV26S2EyVfH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=XNytxICP; arc=fail smtp.client-ip=52.101.71.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="XNytxICP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EzXCXElIY6nFmI32tCczPhygzGJ9pH5QxMl2ZVWCmXODiaT19wVAqjw7zmPwLK6LRUNqe20++KDeNO80ZE+INat+iIB4P3gg/qoOMnAxXHSoBrm6kXE3y9x9NGGRKo8HKMuBFwFodq5bboM30HkfA7bycRc2mrgz7ZQoSDKCIGBLvYoDwThl0BAdVjTYdrsu6Yo+rDsq5X/RsTaE9nxhqZJobwAYtIEDSeRT3N0uUQT3M+zAkR9FU+L5/4QyBzO42S2dKBskTJjBUSMm4BBD/XeTCF4aHeYS8naTLULDulbYCFkrSyismEmmuCb5drOjmOmcHdE+qEWOo9AnCD5xoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ky7zSBSuxzt5fJz9HXyu92W+UTWA1vD0tBpqr72auY=;
 b=fLjUVG35RBv87pP8wAtx8BCvQkFTXWOfp6CusqrOOlsuN8BceGqDz0QLggBmvlqdNGHwpNo15VuAkT7xmlykdRWgxJ+lTeEVS0PmCK8oMjHi9qkUvM0jKcM/LvHjJWV4HI6b+k5tK2K2UCMYOR+GxU5TCfNGbUSrsh7CtQWf9C0otrZg3NRBgjESbR/eU3y9rbpEpB+lqmHr6Da1eeq0NbFIgM1rvrsnH4LWteDLz/7s5Snm0y608QuQIok3GpNVK2NegKI5Lt5v2dJ8jL+dACxvHkKduGsJd0NPd0ZURRLEqDr2pL2JBQWH0qybTzrdNtE5t1dIP9KgjiB2JZgFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ky7zSBSuxzt5fJz9HXyu92W+UTWA1vD0tBpqr72auY=;
 b=XNytxICPmZ1nH9CSRosS4Gq4Ft/DMN1B65+pjYbzdiNm4OwCEwxTQ0QFMeqD2DLrDPFxg8b9e+BSoJA/uJKrZ1yBF5vJqL1Y25lFrDLZVSGW2Pfjx8RiDpp7F10Z2yDa56rmnO5HG7XM9of4TIjU3btJSzyRvEvQq6sO0eub+COs2/W0YtbGKSFnYrOPNILRCugzDr8xW3ORGqcFp1KWg+uHI41M4PHjdyjdhOkIbSxKJ0XClPvoPXFBhbeufzZdpMN2TGLWls2tWeuwS9gL9QGqpNSeP7m7kJelOsUIPWgfcagvMDczT+9lO4BPI5JuNNmpmg3uGI2uMSf3kljc1Q==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by AS8PR04MB8200.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 07:38:56 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%3]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 07:38:56 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Lukas Bulwahn <lbulwahn@redhat.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lukas Bulwahn
	<lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] crypto: caam - avoid option aliasing with the
 CONFIG_CAAM_QI build option
Thread-Topic: [PATCH] crypto: caam - avoid option aliasing with the
 CONFIG_CAAM_QI build option
Thread-Index: AQHb6no2vx1VfesUD0C7Eksx8njdsLQec8WA
Date: Wed, 2 Jul 2025 07:38:56 +0000
Message-ID: <6a8c3e5b-bb6b-400f-a338-9320e20ad2f6@nxp.com>
References: <20250701112045.18386-1-lukas.bulwahn@redhat.com>
In-Reply-To: <20250701112045.18386-1-lukas.bulwahn@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|AS8PR04MB8200:EE_
x-ms-office365-filtering-correlation-id: abfe5527-abda-401a-c691-08ddb93b8065
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?blA2SmFJUmE2RUFzai9XWDFsZWVXQzFpVTRtaTNUaDA2cjRUcEt1dUh1Y3JN?=
 =?utf-8?B?Sm5FS0ljMnJxN29NMWoyM3NXK1JVTGxoNzhRZVhzb2h4em43WXZ5MEZtcTFI?=
 =?utf-8?B?RVM4VDZ3RkN4ZWVhYzI4dzMyUEVWS3dTZzVzdVhzeDhnS0ZiUDhmbzlZVm8x?=
 =?utf-8?B?NnhZMVpCZFNNZllWR1hZWDF2MW13WS94WXVLUmlMc2wyV3cybWhSUjZOSEhE?=
 =?utf-8?B?Z2l4V0wwSHB6bDZTbXQ5SDlJZUJYK0JTVit0Mk9nNHlxUkljS3h5dmhJKzhx?=
 =?utf-8?B?ZWlKVWY0ZXhaWmhvaFUzWUI3ZGpJTkV5ZGhmZGdoUXNFb0tJNkhXZllLOWVy?=
 =?utf-8?B?R1BWYVROcGN6S3FpLzF0TkttZnY4WGVDUWNsN0VEcVNSR3VpVGs2K0V6WE5H?=
 =?utf-8?B?WTd6NTZ3cjBEWkxiZzNqUEJnOFNzNEtkMTdvd2crcTYzMDIrV2t2UENtOGU5?=
 =?utf-8?B?VXZ4YWtldEZvVFd2WEhQNmJOT0ppeDN2c2tZOHNCMVhEd2hPcld2RTgrL1pz?=
 =?utf-8?B?ZG16WktxMlA2c0dsVEtqN01EU2ZVSzljV2xHSXRaZGM2dXczS2czU0U2QWt6?=
 =?utf-8?B?RjlTdjhFQ3Z3ejhtRy9nOUs3SHhaOU1jU2pXMzFkM2ZMczZDSmpNTFUwWU5E?=
 =?utf-8?B?Umt5OUp3cDRhZ0tRVzBTMjJ2dnVaVjZzeFNVaUlIMGhRbXgwSW9jNnlEWmVJ?=
 =?utf-8?B?NW5WYWI2eENQa0hBRG5aVkNKYi9laDN1bEFRbUVaRjVjckFRVlhaaWVMeGYz?=
 =?utf-8?B?UVF5WEh6bEdpL2tvKzdLWkFvOWJmV1IrVnFWWEpJU0kzVjZTZk85cmxMalZI?=
 =?utf-8?B?MWJxOEo1MTQwWnRZK2NKMTYwRFNqZHNSZ0lhcXBPVkhNbmVva2lXci9YNWNS?=
 =?utf-8?B?b3VLMURLUGhNT1BjRzI0bFgxbnF5RXRUamwxYndUN3pPRGNJZEhHTmxvY0Yy?=
 =?utf-8?B?RHZrd0Z6MkdPTm5FSG5QNjdmMkVpOHdEVlVNaThKYUhWR2RJQ0J1ZkdrTks2?=
 =?utf-8?B?RThKTXcxUURpZ3pMVTFndmMxOUV4OTU0enVLTFJwbWlIbVpZY2Y5ZSs4OVlE?=
 =?utf-8?B?cHRaUUE1V2dzZ2FMdUZyelZ0MUNnQXdMWlJZYmhxdlA1SEtNbWsyNGxHR1RP?=
 =?utf-8?B?andPZjZVVXJKbEFQQzZINzFobSt2RzExU0ZidEJYMmJMKzhSbmNpZU9jZ2w0?=
 =?utf-8?B?bTlrc1VqZ0h4K2J5VWdSKzBndmo0S1o4ayswSHRKSEJ2R2w4ZkoxTWRFYVF0?=
 =?utf-8?B?U2xGdFpaZ2xYTlNxT21oMVYxMGRjZVZFcURMMjRFM21LS0o4WWwvN3RuWTE1?=
 =?utf-8?B?ZkQ2S1k0VEhGTjIwazJRTXduVW14YVZJWGxwSUkzSnBNdWV2ZURYUktNNXRF?=
 =?utf-8?B?UmlZR2FyQ1gvL0FYbjUrMnk5ZXZUVkdielEwKzUrekF2RnA4TkdBS1lTYmtz?=
 =?utf-8?B?RTBkTFhEV2t4Rml5SkZhSTNGaXl4cTdIUXNXTEd5RjRvMy91ZlY5QXBZVFFZ?=
 =?utf-8?B?ZmhyUXRsc0I0Z2lFejBsZm05YzZVS1ZDYVdVcEtHQzVML3k3UmtCQ1dUWHRl?=
 =?utf-8?B?VEZaZlpKVFVNMkpxQVAzR3hoOUJkNm9oOURGWGlZeE4wc2tSRXlPNi9rd1Qy?=
 =?utf-8?B?b2lHVVZ1NlplZFR6cUFaTCtKZzE0WkJqa3BxS3ZHY0cyS1FPM2ViQU94RnU5?=
 =?utf-8?B?ZGFYZlBreFdXbXZkMnhYVGt0UDcrTGVNS0FXQ3RaeWNSZEJEWE55Q2hLNnc0?=
 =?utf-8?B?dElqVUk3T0dVU3FsSkJ6VWNVdW52Y3FVMFZkQzdQUWhIVXJRNVkvTm1jbzhH?=
 =?utf-8?B?SkFYTUh5TzgrMTZIQmF6ZFBha0lIdDFsNThPdWJ6dUo4UkYzSjhCL2p6UCtZ?=
 =?utf-8?B?aDRVMklaZGM4dlRZVDFOazdndWExSmN3RHhtQWRFakk4V1cwMUtKU0ZGQmNs?=
 =?utf-8?B?WmNaZmRObWoxYXgrQTNRTkZ0dHhNb2o1dUU5aC9rRlpBdUFNVDZjNU1tbVVU?=
 =?utf-8?B?RmtxMitJRklBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q1hLTndpOG1RcnFEcjJLMk8wcm1hdjJvU09BQUhCWi9wdmZhL0pvQUZ1bXoy?=
 =?utf-8?B?VjZZaXYwc0g0WnUwZE8zZTlaeFZRTzhOMFEyckQ3dWI1bWovN1Nqc0tpNGN4?=
 =?utf-8?B?M01FY1VaY3loaTNJY3M3Yk5HcTlvMEludWk4YjduNVFUT1BsRG45U1A5c2JJ?=
 =?utf-8?B?djJaWEptNkJwSE1LSUw0anlNUy9kRWFDNkY2SFI0TUlZeEdlblA3NGFyaHJT?=
 =?utf-8?B?cjloSVh0OTF6Qy8xaStWK3VYUE5BeHAzVXBQZEJZMlFsa2dmQnRaSUowbER3?=
 =?utf-8?B?QUNCTEZuQjFnUnRWWHBob09QUE9NdXpTSEZ4MjZsY3RGRkE2MjBkZ0Joajda?=
 =?utf-8?B?dmRLeit4ejZDaUszdHgzVjROZ3k3eHNKbFRRWXFSU0lxWCt3M3poRUFZbjZh?=
 =?utf-8?B?OGMrM3JJNWdTclpLbTVCemNCZSt5YTFGZ0d6NmNTaHppYWVrMmVaRGQ2ak1u?=
 =?utf-8?B?Y1lXZkNOM2p1YmxSWmNIajB6QWNya0k4YkIxSGV5WnNWWldhaFlaR0ZyVWhH?=
 =?utf-8?B?Vmt4aUM3MllFVnk3SWZQd1pVeE1QTmQ4d0Y0N20yaXZRemVqR2wwMkFzOFpK?=
 =?utf-8?B?cmF0Mm96aU45K0ZYRkY1RWhxZml6UTI0bnRjaGJoenhSYkZSNCt0MGJoTkxO?=
 =?utf-8?B?cXRWWUhRS0psZGtOT2czOGYxMGphbDhmV0Y3Rjc2Z0NXVS9SalNNT1h2WmNH?=
 =?utf-8?B?My9kaHdyS2tKaTdiKzhQd0ZhODVzYld0SW9lNzQzOVZicmdDOWxqNmRrL3NX?=
 =?utf-8?B?dVdoNlQ0TVV3cVhvNytSMlF2SEd0Y0N5MFdlV1Nqd3NWR2toR2JycVpwN01W?=
 =?utf-8?B?Tkc3OEFSbUNIa3BWNUpoMjF1V011bDNwZTBzaDUrSjRvY2l0NGNUSlFrL2JX?=
 =?utf-8?B?NTFBU0M3cGQyaXFUZU9RMUttYU80U3FmTERUZFQ2d1duVlgwMi9XdE41RnBs?=
 =?utf-8?B?cGpKOFpFUS9BQlRYMlRMSHVRSE5yZlhFeUg5Y1M1MUlhNDVuL0oyTDVSSDZ3?=
 =?utf-8?B?OHZoNFpsS2lUUFRCQVdZTkY3THhDR2M1REhPYnBQYTlpNkVWdG1XaTAzQ0tM?=
 =?utf-8?B?VmdFUWpiZjRtcVFkVGludmkvNHVQMC8xT0NSZUpvYitRSHhWQ0ZyVmN2a1di?=
 =?utf-8?B?T0c5L09YMTdON2FxWTQxbmdnS2xLY1M4NEN3Wkl3ek5Db2RST2JHTkN4VEJi?=
 =?utf-8?B?UWg1TG9BcHdTZHZPZ3MvNXhtNVpidFRMZ1VMaWVUODAxQnhiL3dJQWZkRXd5?=
 =?utf-8?B?N1NEWFc1V3phbW9jRFlFOTlXcnl6VHUxSFV3VFdnVUxIb0RJZXBQSUlQdUxB?=
 =?utf-8?B?ekxxWVkzSVZwaGd1THhlUk10M2I2bVdDV2JteGUvVkNNOUxMS1lRejN6ZHh1?=
 =?utf-8?B?MEM5Rjc5NUJQanh4ZXhBUkFYMUJTb0RmN2F4MU9jS3RvN3NjVnp6QzJEVFN5?=
 =?utf-8?B?d3RCV0UraE9zTjdnK08xQzF6YmE4dFg4RDBWb09WVDR3ZkZEdnE0dnFkQkNM?=
 =?utf-8?B?ZU03SXpTZU8rVXlkN1pLVjZDc3g0eVpEeFZBREt0TDZHbzlodjdaaTUwYWx1?=
 =?utf-8?B?WEx3TmF1VVVrL1ZZaDg4U0g3aTlSdVlIc3VFaGwyMWJEb1BkR1dFQWJ3VjMv?=
 =?utf-8?B?NXFnV2gxSGNGcDdWSUl0YjYxY0dNb0didWpYWGxsSHB2WldBYTdINlRxM3NY?=
 =?utf-8?B?U0ZHdnlwRTEzRWtXREMwR0t2alVhSEo1c0d3Wmx5am9MbnN0dFI0Mmw1UGtJ?=
 =?utf-8?B?NjVhYkxIMlVOc1VwcG1xWnh3cG4ySnlTcUlONlFKM1BPUVBpa2FWNjVqL3lk?=
 =?utf-8?B?WmdLZzlCdGFKNFRoWW5tWEhJc0dUNDF6YUJDcFZ3RTUxQnZ5Nm5XRjJWL1RF?=
 =?utf-8?B?Nk1QV3BtOFF4cWRyQnBpK0FjQUloYjRGanJPajVJRDREZ1ZmOXM1UjNqaGVL?=
 =?utf-8?B?WnV3cDNyYWVNd29TSTBvTXFtT2JDa09yYlg2SUlrL2tuWG0ydHErdTdneHJI?=
 =?utf-8?B?ekVzK2s5YUkramxOU0NubkptUkREVmRUMW4ybkVERWczUHZOb21NM3hzVlRS?=
 =?utf-8?B?cEdnbkJwWUYzeHB1eGNTazdpcDJTL1VYOE5kb1QyTGhMa3VCMVRTSHh5cVB4?=
 =?utf-8?B?bzI1bXdHa1hLWU5VVW9FVVdVVnRoOTJIV2RRdXpPU0o2aUNMS3kxRUZhTmVz?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FE15A5F20C0004D91DBFB3989C19BA8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9709.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfe5527-abda-401a-c691-08ddb93b8065
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 07:38:56.4020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3e9tMT8uib0xO5KFiS17kXUPHAI3SAfHvBTku8KQpINbDc4wgJ80FOFBSgzINp4gxHSUAedpKGWw0AokH96i7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8200

T24gNy8xLzIwMjUgMjoyMCBQTSwgTHVrYXMgQnVsd2FobiB3cm90ZToNCj4gRnJvbTogTHVrYXMg
QnVsd2FobiA8bHVrYXMuYnVsd2FobkByZWRoYXQuY29tPg0KPiANCj4gSW4gdGhlIE1ha2VmaWxl
LCB0aGUgbmV3IGJ1aWxkIG9wdGlvbiBDT05GSUdfQ0FBTV9RSSBpcyBkZWZpbmVkIGNvbmRpdGlv
bmVkDQo+IG9uIHRoZSBleGlzdGVuY2Ugb2YgdGhlIENPTkZJR19DUllQVE9fREVWX0ZTTF9DQUFN
X0NSWVBUT19BUElfUUksIHdoaWNoIGlzDQo+IHByb3Blcmx5IGRlZmluZWQgaW4gdGhlIEtjb25m
aWcgZmlsZS4gU28sIENPTkZJR19DQUFNX1FJIGlzIGp1c3QgYSBsb2NhbA0KPiBhbGlhcyBmb3Ig
Q09ORklHX0NSWVBUT19ERVZfRlNMX0NBQU1fQ1JZUFRPX0FQSV9RSS4NCj4gDQo+IFRoZXJlIGlz
IGxpdHRsZSBiZW5lZml0IGluIHRoZSBzb3VyY2UgY29kZSBvZiBoYXZpbmcgdGhpcyBzbGlnaHRs
eSBzaG9ydGVyDQo+IGFsaWFzIGZvciB0aGlzIGNvbmZpZ3VyYXRpb24sIGJ1dCBpdCBjb21wbGlj
YXRlcyBmdXJ0aGVyIG1haW50ZW5hbmNlLCBhcw0KPiBzZWFyY2hpbmcgZm9yIHRoZSBpbXBhY3Qg
b2YgQ09ORklHX0NSWVBUT19ERVZfRlNMX0NBQU1fQ1JZUFRPX0FQSV9RSQ0KPiByZXF1aXJlcyB0
byBncmVwIG9uY2UsIGFuZCB0aGVuIGlkZW50aWZ5IHRoZSBvcHRpb24gaW50cm9kdWNlZCBhbmQg
Y29udGludWUNCj4gc2VhcmNoaW5nIGZvciB0aGF0LiBGdXJ0aGVyLCB0b29scywgc3VjaCBhcyBj
cm9zcyByZWZlcmVuY2VycywgYW5kIHNjcmlwdHMNCj4gdG8gY2hlY2sgS2NvbmZpZyBkZWZpbml0
aW9ucyBhbmQgdGhlaXIgdXNlIHNpbXBseSBkbyBub3QgaGFuZGxlIHRoaXMNCj4gc2l0dWF0aW9u
LiBHaXZlbiB0aGF0IHRoaXMgaXMgdGhlIG9ubHkgaW5jaWRlbmNlIG9mIHN1Y2ggYSBjb25maWcg
YWxpYXMgaW4NCj4gdGhlIHdob2xlIGtlcm5lbCB0cmVlLCBqdXN0IHByZWZlciB0byBhdm9pZCB0
aGlzIHBhdHRlcm4gb2YgYWxpYXNpbmcgaGVyZS4NCj4gDQo+IFVzZSBDT05GSUdfQ1JZUFRPX0RF
Vl9GU0xfQ0FBTV9DUllQVE9fQVBJX1FJIHRocm91Z2hvdXQgdGhlIEZyZWVzY2FsZQ0KPiBDQUFN
LU11bHRpY29yZSBwbGF0Zm9ybSBkcml2ZXIgYmFja2VuZCBzb3VyY2UgY29kZS4NCj4gDQo+IE5v
IGZ1bmN0aW9uYWwgY2hhbmdlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVrYXMgQnVsd2FobiA8
bHVrYXMuYnVsd2FobkByZWRoYXQuY29tPg0KUmV2aWV3ZWQtYnk6IEhvcmlhIEdlYW50xIMgPGhv
cmlhLmdlYW50YUBueHAuY29tPg0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
