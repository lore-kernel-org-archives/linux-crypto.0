Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013044.outbound.protection.outlook.com [52.101.83.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB2C2040B6;
	Fri, 25 Jul 2025 08:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753430505; cv=fail; b=EPIlC8J1Q27I35gJWbesZGCQQAD2U27LeUkUsa7Ckv921b/IO+ya+Zhr4Q5Wox3tlffj5S6YzI60d/Fm80G+aHbr1SRqlPGq0WB1C+0Idr1bCwXv8KaRnkpp5oek0VcV/z022jhC/ho30eQ1M2R6G/PVn0AhxD4RMk8+171/w/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753430505; c=relaxed/simple;
	bh=W8ryArspubcDT6ilAQQTGzQ5kjGb5EirKGIrq/VBtZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WGlPcsTKJuruoDKrPnHakmaRt3pvSC0wxkyXsb9E/PMMpkJOFfbyyF6hOQ9zyfzx0uRXDJe8b3osBRX115wJOzEcc+N2kddB8KPiq0AtVq/ldf94/jZVAwqXNk7asdt+Tf17wQ/gQD8TPm55ssDR6i5EKbOHRRSVQwajrTWjGNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=FRVvVDFx; arc=fail smtp.client-ip=52.101.83.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="FRVvVDFx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g32FsqAl9by9sAXX66WaJegACmER2T6n0tjjRimyWlWf0RtigRsNbFOuwlThXvvL6bId4pxaJrcHRupOSBOQ6+ojmBXd7dGxMcMrp8GnjmN80UfN+XMJq+3bS7RexxHRaCYdNXWr63X5rt1roChIhraU7wIhXNYSpXMDH+oZFxcLWXJGuxKxhBKLYKkJt+UnTDXZWYhFK5l64cgjo4UIjEB84Wby8OIZN5DG7kKeoxZACQqV/PF4sscCJ4dUQtA4eM5wS+i/kiPIGOUaa0WIvxIFSRa+C0q0lUMyXTsqEj3fDre9Pt43D6JOOzk9/DhYn5EOxiVjMYKNIsMH6tgwFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8ryArspubcDT6ilAQQTGzQ5kjGb5EirKGIrq/VBtZw=;
 b=toksOy7U9C8Sey/lLuerhoJ3k43zdoWOlSc5NfiVqWrbOQzOYjl7We6yNR75elFSCQdcBs/ZrTtp1L7BLA9Us6WgCtK5dfA+Oda32WSGTcjpCaZ7lg3ZBRU5uAYu6JmY11RJ+fnUGsIoMVbTR7koIKwtovCS4YeBA5jcfDwNZYViDZNNS2p9Lz7BBl5l0zwV6fkukd5YTi531Q5BTBL2hmuyiQ9m2Q5ycvgH8qd5d+73f6GCHiPIJts/TpIupdfirc/YQAbFnxmVDvmYT31qJtCrv6CvQAkDDiwd/HqVO4wPOVM5As+qjZCcI7403jdgpNHIhwU/55lb6xuJKBQLIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8ryArspubcDT6ilAQQTGzQ5kjGb5EirKGIrq/VBtZw=;
 b=FRVvVDFxovcKd2G2oQJRK4phEFtEqrDk6KQ3NnOGKo2as4IDFIy1EW72ej4v2Rx30GdSpf32TU2mIgDKbP4dzXJ69gzd3UhwuZz/ASf+h8HlhXX+Axe3ssq7yUvuPQ73FcFiXghczeBTU63yQ2MuPbqOBOu9Rq5LjpzWzi078M3QvcrdVU6lNR0afGdNs6v4UhkcfKodFZQY0IgpimsRs5pItZCbAwrjfiLnaeMGNSiat3QdWX1ibQN2I9EYRtzsfFLog6vBwAC8J0oFDlnYCf//eu//NV4bePsV0yyOyNmHAnPrqy8hkaKH+AEj3FT4fFgzsn4N/arLTOJP5Dz9Ig==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by AM8PR04MB7939.eurprd04.prod.outlook.com (2603:10a6:20b:241::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:01:40 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 08:01:40 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: "zhang.enpei@zte.com.cn" <zhang.enpei@zte.com.cn>
CC: Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "christophe.jaillet@wanadoo.fr"
	<christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v2] crypto: caam - switch to use devm_kmemdup_array()
Thread-Topic: [PATCH v2] crypto: caam - switch to use devm_kmemdup_array()
Thread-Index: AQHb+3ykORFl57xebEOmC3u4hEVs9rRCfbgA
Date: Fri, 25 Jul 2025 08:01:39 +0000
Message-ID: <877014b1-90f1-4bbc-8a42-37d07b15d760@nxp.com>
References: <20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn>
In-Reply-To: <20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|AM8PR04MB7939:EE_
x-ms-office365-filtering-correlation-id: b96fc2e9-739d-4a6d-99ef-08ddcb517c9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WERSM0Qxc2dsZkYrd21vT1daTTd3WWVNTm1mL2ovNmJYWlJqN2syM2R1QmFH?=
 =?utf-8?B?VU1JMTd5NGNTOGRDNTduYlgyejZmNmRNbnRVYVZDWTVyYXZNMHVpVlFObjNt?=
 =?utf-8?B?WUxIdllCd1JmeE1qR1JielNsQitDYkE3RVpvaEtOaE9wbVZuUmQ5UUxueUVz?=
 =?utf-8?B?TEErend4ZFh0MXU2Rk56WHc5eC9Hd3o3b3Nnb1MwNk9JTExoZ0FPdXRuV2lz?=
 =?utf-8?B?dFJ1c3FTbjQ1K0pGR3ZHVytYa2R0UlRPZm5mYzRoSDQ5OGYrdDZUdE1rSjlT?=
 =?utf-8?B?Yks0c0F5ZlNwVGN6M2Q3UWNzOHMxd1MxdDhNV2Y2M09JbDNVSHM1RWorOG11?=
 =?utf-8?B?eTVjdkJmM1Y0K2R5TGxPd1NlKzZnUStTOWRPSjVCWTJvQTgxejdNMHBGbVc4?=
 =?utf-8?B?MmJLblk5QUxNaXd1eFZJellvendIcWh3cndpOEk2V0xHVnVnUm9FNTN4QVZT?=
 =?utf-8?B?VktyMi9adWt6VTk1WTF4OWdwWTJaVkFHakt3dnNwelRENG5pK3dNeUhjaEI3?=
 =?utf-8?B?SUNSbUdmbnBtdUk0YmRWOE9iTnY0OWg5cGwzL1lYbjFtUDVIM1NLV0dDY3hy?=
 =?utf-8?B?MnRrbjZlWE5lRE9xcExJWFNtS0EyUmpXYXp0eTlKd1VDM3R5MUlvSTBZcGZN?=
 =?utf-8?B?ckhreEF0SW44Wjd5Q2pQb2NadStUWDd5dU00WHJZWGpJMEwxL2haVnY4NWc4?=
 =?utf-8?B?aVlFMlJWeStXeHRndHB3QVlHTWMxdzdpbENsb3hWaktWOUVNTGFLSWsreG83?=
 =?utf-8?B?Um9TT3ZnUTIrM2tiL3dRZU5rbTFRcURTTkdzN1oxNWdUdkZnc0QrQzJzM2pF?=
 =?utf-8?B?NDY4QWxROTRabmNWQnJiU1EvVnlHcVpaaDFTZ0pBbFFCWmNMOGVXTUxtaTUy?=
 =?utf-8?B?d3dwc3ZKMjN0WnFOMUNVQ0doODFudVlQdnd5MzhOVjZqc1JpbDNITEFrckx6?=
 =?utf-8?B?ZTVONnJieGt1UmVBZUIxTlZDdlh6aVZJc2VaaUtPK0QrdlpwbFQxVno3TWQ4?=
 =?utf-8?B?bVl5VkRhcHFVdktDck1kNzh4T3laUlUyMnorYm82c1YzM3JvcmZlYlF5dndC?=
 =?utf-8?B?RkRseXovb3NpaFc0YU14cWc3a0k5SFdTYTZRaHY3a1ZWbWdxaTRQbEN6Nm5G?=
 =?utf-8?B?cjlEelhENzNZbHBnMmc1UG81c2JHVm41T2N6NmM2alNuNlZXRnFBMW5rMVFU?=
 =?utf-8?B?b2lwUkFWL0wvdkdQbSt1V3gxcTMyOUxIcWR0N1FLUmtoa3NleXYrNld0VENG?=
 =?utf-8?B?QnZjcEZGUE9XNUowUi9LRzlQVmJxbWxlR2ZTdFhROU1wVTBGbkdHcFpiT0NT?=
 =?utf-8?B?cUxaYWgrL3FtcW5Ib0JzQnpXeWtFSHhZdGhuMWRCbkVZaHBwc3RSQmdYYkdI?=
 =?utf-8?B?djJwWlR4cnVNVmZNTEJWL0xuQlBxRDBpQzI1SzgzakFaV2JnWnlsYm03TnY2?=
 =?utf-8?B?RkNQYS9nS3FyVjBlL1pPS0dsZS9MQWdpTytySC9Mc3Z6RkRwajVPeTl1VVRF?=
 =?utf-8?B?aFg0SmR2NEM1UU5hRjVrUUZvSThiYVdYR2pMMGx1aCt1TFUvNHZ3Qm5ZRDB2?=
 =?utf-8?B?a2dOL0hmNjFjSnlQRmpsdDh2TDhOa3FRaDBKUU1zc3VLM3c3ZWYrVVkzOTND?=
 =?utf-8?B?Rjd0R3V3eHppcHY1ellNbXFEM1J1MFpzL0NBWmNyT2QvWGhyNEIwbGIyMWVj?=
 =?utf-8?B?b3R1ZXlwRHRzUmwyQkNMY1RxdUQ4aUtTYUhvcHg4djA2ZHYxdW1VcG9yRVA1?=
 =?utf-8?B?Tkl0V25uYndFb3lwUUlwNWFKRWFJY25lTlRValFsdWhxOHV4cHNieHRWTHhJ?=
 =?utf-8?B?cUNQU0lyZHBmYjBoWFBRVVk3Rmc0NnhnYkI1NlRpNmpKVE9GQ2hTUkNRbTdR?=
 =?utf-8?B?YWJVTEtzT1Z1Q3dpaURmNVFzNXV5TEtXMTVteFJsclJXbjRBTFFSUytzeGhS?=
 =?utf-8?B?VTRPckROWm9nSXRLWTBlSC96N1c0YlVPZ00zSU9ZdkR6ek0vZjJhVW9WeTFh?=
 =?utf-8?B?MmtaaHVDMzFBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TjdmNlNycmlsS29zR0VWMWhSbENWdGZ2N2lCK1J0N2dFVWZwaTB4dnpyZnVR?=
 =?utf-8?B?VG1WcWkyaG5kSXJqQjR0SzJuQVpvSG02dFdTZDhncE50amdzdHZhZXlNbSti?=
 =?utf-8?B?bE4vZHpQbE5tMnp6VnNUZCtmN2FEa2UvaUNkeEZOZVZuSE9ZS1NxUzBicGFP?=
 =?utf-8?B?WnpYd05Zc1ZjS1Bhb3lXKzUrVTBlQmRDRFJCMDVDNW5yV3ZBTFZYWnJXWmF0?=
 =?utf-8?B?REx1NzdablJrQmZBNXYzTWc3cUZmUFRvRTNxU1A1aUFhY3lCa01ZcmlacGpU?=
 =?utf-8?B?Ri9mM052dDlFUDFzMk1iK3MyZ1Jaem83SkNuRzZyRmZOdWh3MnJQN2dQTmlK?=
 =?utf-8?B?cGF0bmpCQjI5dEVKSUNISzN0bjI4bW5JSkJxTVhHblgrZmJMcmZBUlJvd0Jq?=
 =?utf-8?B?c2JpQ1R2c2V2eVFVWmM2QXVDSTZqbzd4aWZ5TjVsMHZhRXBLY0dkb2FrV3Q1?=
 =?utf-8?B?MkkydWJuUkdzSFQ0YlAyRTR2MkQrVkNhWTlxT3Bhc3pMTzRFTkg1SlF1RnlX?=
 =?utf-8?B?eURoKzhBY2h0MTlzeW9lYzhlQmRIQXBWQVZnbnJWbDhIekMvMDJrL2ZIWHRM?=
 =?utf-8?B?NzJtR3lSS25lL3JIV290RmpOTElUdzI5bUJtWmd0RHV0b3NHTFo2NEc0czZK?=
 =?utf-8?B?Y1B1TWhKT2xHSWFwd1BxdzBPSWtLalpsT0V1L2tuK2Eva2M0QVZ5SnZwUlZD?=
 =?utf-8?B?emQrNE81RmZadW1kOHVubG42cmFOZkorRGtSUlF5dm1uSnFBaG1rd3JXNDQz?=
 =?utf-8?B?QXJDUllZRDUvSTdOVFFmVlRaMTRUYXZtMFN3aGsvT0ZDUlkwVVhJWjRGenhY?=
 =?utf-8?B?NWcwZ3QzeFVxekJucnlscG45Z2RFWERoY0NjV2FPeGt5UlJLYzNFZ0NIR1Nr?=
 =?utf-8?B?dEEzeGxuZ0pCRTlhaGdrTlBNQWZkOWRwK1U5cEZCcEtpZHVFZzJGTjF2N3R4?=
 =?utf-8?B?UGI1aklVU3VEOWw3ZHdsTFBKaUgxVjlJOHA3bW5GbWZhOUhmdjYzVlMwQlVo?=
 =?utf-8?B?T0xaL0kybUVSbytycmZjTnJGRkJuc3c1MDhiUUNTOHR2Wlp3K1ZQRDZhU292?=
 =?utf-8?B?dGZVTzdVRU5Nd1ZBNUVnV2E0SXkyREFXdEQ2VzdHbTM0OXdhTXM5b3dBUjVx?=
 =?utf-8?B?SGpUanpYa1JRbndRTVcxZkFDbnhKajhTNTdGZG16STJKNi9EUFJrVHdnZFhG?=
 =?utf-8?B?d0kwWE41aGZlOVowREhlam1DOFB5LzA2MXpweE1UQU5BWnBQbXEyNStZR3RN?=
 =?utf-8?B?VWNqSENnbVdOcHk5c3F3d0RKTG1wYyt2SzVRcG1oa2VqdDZqbm1lcWJjRmhJ?=
 =?utf-8?B?RTJQTVJRMzlZdXNqMGhyKzVadXhSN241TXIzZzczWXJ3dUJCM0xqQSt1eVp2?=
 =?utf-8?B?U05xNTFaZ2FxRTJ6SG1QMlkzSHl4Q2p3U1pSWUVIRW5OR2dCSTFqeGQzMWV6?=
 =?utf-8?B?RFZRY1lwYjFTY3kyeUJJZlkwaGF6WFpGQjExV0Ixd3g1UzlPc2dJNmQxKzRW?=
 =?utf-8?B?Zkk0QS9MU2pDNlJyNDlueFIydWQ5bk5rYmdMVWwvMXNoS01scUY5bEdKR2Ur?=
 =?utf-8?B?Z3JPZU10Y0Z0YW5mWHlITk9YU3FDREJtZWZVUmVjWUlKcFpiZUtoNE9TRDVr?=
 =?utf-8?B?OUZkU055UHlQYlNVMTRBWUpKdE5OYytJWGdmME1MRWNOS3FZb1dOdVZPcmdI?=
 =?utf-8?B?Y1RnaVdLZ09zM0J5Zm1sZi93OUVaMW15QlN0RFFVckowWkhYWEpMWUl6Wjdm?=
 =?utf-8?B?ZHB6ZFJHMlpMWFFDR0ozTzRjR0N1NEgxbU8vV00zRnMyaUhmMkt0SW8vQjFt?=
 =?utf-8?B?TkFpZEtRU2JvVkh0NEIxZVg1R2VJSE5Yc2ZpUGViWnVuc3BtTGpacGx1eDFp?=
 =?utf-8?B?YVppSDlBSkZVYlcvQXZmUzlNOGxDdDlqbUFSdFh2NzdZNFh5VzNmbUpIZ2Vj?=
 =?utf-8?B?MGlGLzNCMnJlT0U5Wm1LekRnVXdRQ0JNK09WbmpqNkxUaG9NNnI4TnUxWHZH?=
 =?utf-8?B?NlRDWU5BZlRpZlNXU0YrR25sQm43QmViOTRLbFcrZ243V2M2M1lRb09ZQzV5?=
 =?utf-8?B?SXpqYXhDUDA5ZXVjWmVjRS9YSmxXNkRQS1oyNUluTVdGTUVIMTFsU1FyUTdN?=
 =?utf-8?B?bmZRaHNzQXF6TjBOV3JDNEw5ZGhxRTU1d3FkdlljZWtVNDNEbkh1SXlGaWov?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <74DF7A6DB0A56442B869AD95851C77B6@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b96fc2e9-739d-4a6d-99ef-08ddcb517c9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2025 08:01:39.9548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XB7iNuE6Bz4CXACXTRS+d9M9JVofNQqocaPrB38t19sCVFUM3ZTnJesW8DZRfl5Ae88EYF3ONGsAVbxYhdJZdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7939

T24gNy8yMy8yMDI1IDU6NTEgQU0sIHpoYW5nLmVucGVpQHp0ZS5jb20uY24gd3JvdGU6DQo+IEZy
b206IFpoYW5nIEVucGVpIDx6aGFuZy5lbnBlaUB6dGUuY29tLmNuPg0KPiANCj4gVXNlIGRldm1f
a21lbWR1cF9hcnJheSgpIHRvIGF2b2lkIG11bHRpcGxpY2F0aW9uIG9yIHBvc3NpYmxlIG92ZXJm
bG93cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIEVucGVpIDx6aGFuZy5lbnBlaUB6dGUu
Y29tLmNuPg0KUmV2aWV3ZWQtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdlYW50YUBueHAuY29t
Pg0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
