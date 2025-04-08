Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2044.outbound.protection.outlook.com [40.107.241.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363EF25F96E;
	Tue,  8 Apr 2025 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744097962; cv=fail; b=lPtzTfaRhy6OqsPX860y8/ptRZs60UfT154AdJf5iLJxq/2tiXT+jM//WLGzrdmPxYdMPZWhByTn8VdncnEOiw+1Sy0jnyJ4Hk8wuigVnVmGS6Z3tjfc3q7vzMhMRYAONs4VLRXLIwczUKWOZTUnkixcyolloWdBUePWKx60MlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744097962; c=relaxed/simple;
	bh=F/zutKpE/IsuzARmKwww4haq9uRQ1BAlWQWakT0+34Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hd4A2zrqiZtmpjt/CxC8wKLw3u9BC4rANZK1MUC993iKbanfhEcaNx2YiGx/hicXZQDDbSUc0zth+NqJ5DDCkCnbdWpCviak+4wGTp4xjAN2w0QwFXN5nZFuCQ069pboQAfA2Isb1P1idnuMvTLwMSvW69Ako5GU+4D+73Ohvl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=kW+sIX4h; arc=fail smtp.client-ip=40.107.241.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="kW+sIX4h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iy+WFr2yIaXc34Ai7/prTr8vNL6VoNf/nesJAcPhdws8HslXBn1KI4LGCp5cKLNFOSphHc9gH89w8IiiPrqPTxjzjkrxA6J5/WbjHa7WC9ujRXsLvC3EFpn8RBdrxdM/Qn0BiZey+2Yo8cTgyZ8l4guHT7/Q4G+G/vWtHWo2gc4yAuXlR6J6aS602QWoi+0Md4p8WCOtkMxlhM2oh00bMWFoKQRCYSLLJ0HFAVsubOlettCVLEV+flMuC7g/xzbSVXOpnuGCH9z/1kAojE005CKOdDrvgCPorG5WTCeTg/jxaa1Q6ghr/r7KZ/jiBvbD2J0SDPx3pBRZ+tSoCGPSXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/zutKpE/IsuzARmKwww4haq9uRQ1BAlWQWakT0+34Y=;
 b=Qfy9H70/fgybc9cTEoOpsP1eWfNcXuFHjCXvtc/yi2/xEXLIv3CS6JV0I0SbGtu6wyOMVnGF/+KK4MG4L4oujC77b8eFRf/F1GC/A+MAMHlDoaxDyggSRbusMNvBtO2HcCGu6mfUUUOv9LTQfu9kTr0429DaSX5Jgbek+KgahPP8u5J0uJY+Cu/BAomVFFYorKKukSMyNtuRBVrbIGVItf3ubF1hjx176ES2hk9JNoQCQaZinZ6pgPfnVDUp/ferpt1ydYv5GH5b5VVszkppixqXPpiin9UdHQID+NiuSThbt3aRQsh+YNOGpxwB/Decg2HkeSJuLteLgTD5AqZC7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/zutKpE/IsuzARmKwww4haq9uRQ1BAlWQWakT0+34Y=;
 b=kW+sIX4hQashTF6kINhBZNdwVZeCeRPU/M8kaRSbGsqKn3vN7KoPynNihr8jSEKw6J/yDRKfy1fwCBFQ09Zp/vU4pOQh7ijP50iqBSnfxVosLHTDw+DW99sGDNnXPRTT6nSDgyXNk7ymLUoKYOI0GQNAOVDbBWJOLlRt/tZbPK2QYtKNhoCnEA94JVBXOj6ITWYIfkVpewM/0Bq++QgD27Nu6f969xRL1FARUpdMzyEESZBYURbU+BTMhZy+fWiQJKSNuFsP5FHGrXjgjYEHEBVg1+meX7x1yfqZcYDFnNycUxZkgTRloGZAqJpH4Qvo9++m9OztI6WOzHk7SqizzA==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS5PR04MB10044.eurprd04.prod.outlook.com (2603:10a6:20b:682::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Tue, 8 Apr
 2025 07:39:15 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%4]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 07:39:15 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Thomas Richard <thomas.richard@bootlin.com>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
CC: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Varun Sethi
	<V.Sethi@nxp.com>
Subject: RE: [EXT] [PATCH] crypto: caam: Add support for i.MX8QM
Thread-Topic: [EXT] [PATCH] crypto: caam: Add support for i.MX8QM
Thread-Index: AQHbp+Ms6CUWg7DpWEexJwoBpkoPhrOZW1PA
Date: Tue, 8 Apr 2025 07:39:15 +0000
Message-ID:
 <DB9PR04MB840981357AE2926B8E2662FDE7B52@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20250407-imx8qm-caam-support-v1-1-181cf01a14ec@bootlin.com>
In-Reply-To: <20250407-imx8qm-caam-support-v1-1-181cf01a14ec@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS5PR04MB10044:EE_
x-ms-office365-filtering-correlation-id: 8fc24859-dabd-4827-03fc-08dd767076a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RVhzMmVpVnU2ZjdTcGRPQzk3Y2NIczZQUHh4eEs2bkxKdkhaclhJMkw1L3Yv?=
 =?utf-8?B?T3RENlVLeWdXQS9sY0hXQklhMGV3d3kyWHNlQ2pabkwxUlRvQmU1bm9FS3g5?=
 =?utf-8?B?QjRkMWcyUUIvZDZrWG5uSklLREY1QlFOYVZtQjU1WTRpUUhKaTVBTytIMWN1?=
 =?utf-8?B?UjZDTVVpS0s5NjJCdVBkZXZpaXl4NFpkQnVWNVpnWFJycUkzcHFTUWU2U3hq?=
 =?utf-8?B?ZHg2VFgzc09PY0w2bjlqVjJXanZIVVphK0RaOUJneC9wblAxK1AzRWVmOTg4?=
 =?utf-8?B?a3JvNXRqYXVzTnFIMHZjdHhueXJPSXYyaFZmM3Z5cHgzaHhDSlVKeXFsK1U2?=
 =?utf-8?B?WXdweldkNEViMjJoRTBUQytPS0F6TW1ubDYvTXJWSEl5NG54QnVJZGJQRWVR?=
 =?utf-8?B?ZURDUEtFR0xmV24vTEh5UDNOQm1pYVBTTFFZbFQ0cGN2OVVKV0lCRmxBbWZE?=
 =?utf-8?B?R2l5OTk0THhrSjluNm5FN2hCKzl3Y1J4QkJVYXh5aHE0UHQ0NTlheWg4NDR2?=
 =?utf-8?B?NFFLTitVMElROHhML2dYSFl6cUlCK1NNZ1ZWS3AxeXp6RFk2dENrb3AyZUhU?=
 =?utf-8?B?SS8ra29SQWpPcFQ5cHBBYkEyLy9zSGRHK1Vva3ZBY2xFYmoxbUJnQUp3NEFu?=
 =?utf-8?B?KzJNUWVFd3FvNlJycWEyMTlUWk5pU3dxbkt6aW1OM2YycW9XTlNRZHduR2lK?=
 =?utf-8?B?UVVlai9lRllSUEs0eE00Tml4QW5ycGZBNHRmNEJVdVVJY05STEsvYkpRbUVr?=
 =?utf-8?B?NFFrTFd4ZmpJWElFdVhmbU9xdFh2R0VJaGpXQ0V6dlVsaC9nWkNQdkxYWGQv?=
 =?utf-8?B?ZmVjc1pxTE1mOUE2TXE1eDRqTm91MGxQYThPYWUyZ1JVNGtLMm9mMWVxcnBP?=
 =?utf-8?B?MjMzM21OK2p1Z0k5TmMvaHlTdnVHb2NKQXBFMHBtd2xFVHNtZjJJR2ZZYWcr?=
 =?utf-8?B?dkEzMmNDYks3YTc1c3dpZXkwVysyUWx6QnVvNjRXZTRSM0FsbHBOU0RrMEtG?=
 =?utf-8?B?QS95N0FZQmV0RnN4Rm9hSGtTNytKcFpuV1hCd2hSM0VWaWV3UXplbktRc1BB?=
 =?utf-8?B?eE1nR0VIbEE1dUZ1V2tZT0tIaWxMeEJld1FWM3RUdDFjR1J3UXhsaW9OWGpi?=
 =?utf-8?B?YXRHOTFOZGFSK1NTdnl1V01Fc2FjQ21oUXBHN3d5MFlDYlU2ZGZMRFdyK3ZV?=
 =?utf-8?B?SG8rY2pwNHBLL0FXVDhIS2Vyc2lOMlJKMjIwVnJGZEtVbTRwVjRabEY1M25L?=
 =?utf-8?B?K1lkRitYWGM1THdweS9mRHpMY2JBaVBVS1BZSWUrVGNmSW54SnQyelhZblBL?=
 =?utf-8?B?RlF3ZWVuZWs0b1NDUkJNUlFqQmlvUS9ES0svcjZwdTFkank1WjdBK01Rb1Mx?=
 =?utf-8?B?dk1RYUtLUkVqYnZ1Q2NOSDZTaStxbWdOT2ZheFlLNm00YUtqT1U5VGJNeHF1?=
 =?utf-8?B?N2VzQUFDdHFENUhaTVQ1TWpMTlJ2MzU2T3JCY1RpQ0VvcHZlZTBtVlBqMHFE?=
 =?utf-8?B?cDIrU2hDOFZyYlU4RTBiUlliWFpodVcxalVyb2NEdjIxeWJiRzV4V3lGd3ZR?=
 =?utf-8?B?MjNadk5NeG1VL0luN3dGWG01K2Yra2xISjZMODNJRnJHRnAzMDFXVVJwRzl6?=
 =?utf-8?B?bVk0dzNWeW0xMW16UzhCajNZby85TW96U25YR2E2cExCSGJvRzFKcnpLNlFU?=
 =?utf-8?B?RDJYKzBNQkJHNEdlSXZBR05UejUxbFRNejdpVjd1YkFPOVl4aW9SdWYzb3NY?=
 =?utf-8?B?aWNneFcrTWFqbVphZWF4QnlLSm9OQmpucWFWeUxobUtVM3FFK3FvNmFzZFRK?=
 =?utf-8?B?NGxvMXJrN1NFK0tRTE9ucVNubTh1eXM4T0R0WkZMKzNTQzF3YVhBMzFmdWdB?=
 =?utf-8?B?eE5CczZzVVNHRHRxYkwrMi9xbjV4M094VEYyWTRwKzFIa2lJcjlWOEsxdU8w?=
 =?utf-8?Q?1McptZ+Ej7GgMwK/sqCBx8j84gh46Tw3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVIzQy9OZE9TbWMxYVpEZ1pLTy9ObGk3U0lpVWlkSnYxSDFkNTNkZitQak4x?=
 =?utf-8?B?Z2VXeWFFYmpjbmFRZHpLcFpiQlVkT01QZ2RXRkdRcWkzVGd0bmVKMnJzVU5v?=
 =?utf-8?B?Tm8vUWFDdTl2M1VGc3M0bHlqWElnd0ZWeG5aaHRTeXlueDNsdnZMV1hDc1px?=
 =?utf-8?B?bVlaVk9UbXNSeitCN2hWUklwOG5wU2ZaTlQ3ODQvS3kzOGVkSWZTVnc3M0tC?=
 =?utf-8?B?bXZNeUJxN0g3TkF6MXBDMEpCRDU3V0s2cXh5djhmTWtFR3k4MThScUE5TzdP?=
 =?utf-8?B?THRJZThlZjdBdUlUUjlTNTZoM1lQUEtOK3kzMW9nZ0xIVDVaWU04dWhCZ0RD?=
 =?utf-8?B?Tlg0cXdzTW5UNjBmMDlCNXE3QStqcVZiTGs1d0dpZE9MOEdkSWs3UXdBWWY1?=
 =?utf-8?B?MmtTUEloNHM1U3NtaGd0WW9RVWYyald4RDRvY3pSZ0V1NS9jOFdkNFRQeW44?=
 =?utf-8?B?QXNFSENpSXhHMWR5bnpaUkJBNFRLTG9VOGZkMndrakhpYlNqYkVuSGU3MGdC?=
 =?utf-8?B?ZGxWc2lsRUVHeS9sZ3YrUTNFS2U1NG1iV0xPQW1FWVhEN2dVQWFsbkZMUVJL?=
 =?utf-8?B?Q2RXMExCdGRNSVZQM2kzN0wrWG5jQmY0ZHdkYnRYTGIyZ3QzZkFGODdUbHZz?=
 =?utf-8?B?N2ZZWitGUEVMVzlzT3hRTTZJbVQxUnI5OTBnd2VwNDRKWHZZU3p6RmxFb0dj?=
 =?utf-8?B?MExjL09wMHJzUzFPU2ZUWnlTZk11ZXpzai9kL1VSaWQzeXVsMCt3ajYvdExD?=
 =?utf-8?B?V2JIMGhQNlJSamkyYXE1RU9LMExtUGh0QkU2WnBBVGdVYmtiV0tLUk1HTTND?=
 =?utf-8?B?ODBrS3NiY1p1TjhOaXZpODl1Ukk3NG02V2JEMjJTS0hOWVIrejlQZ2RreGVK?=
 =?utf-8?B?OG0xU3BuMTdzWTFNR2xGdU1USTdjRE9wMUxPa3BnSmtlQjdCMmk1MFJxRFBw?=
 =?utf-8?B?aXoyWE5YRFZKVzgreGVEVmpYSEwyRTZNNUVGZlY4VWo5Q0tLVk5xNTlDTm44?=
 =?utf-8?B?aDFGenhpc0xTNlNrWVh2TWZ1cGJkakJ3WVdoVGFhV2FjckRXVVVUd28zZmxi?=
 =?utf-8?B?L3I1MXRnVGFvRENhanJjd2c2VG8wNmEyYzVuQ2M1TGUvMFF1R0dNd29SZmVH?=
 =?utf-8?B?ankvdTdaV1VxRDRKZmNIdjBrclV1dEpKcHIrN3dYYTZiTGtya05uRTl6S0hL?=
 =?utf-8?B?L2V2UURKQmVFRU1jUGYramVwQmdzU0VFNklRcHhjbFNqRDlMUGhCTnUzRzBm?=
 =?utf-8?B?Ky84MlhoWHdndFZ6V0xaMEFGam9sd1Y5c2xOdGwzSGFmbHRjdjFnYk5tdlNP?=
 =?utf-8?B?UWt1SFk0cmFSYlNocWt0eWN2VXN6VzJESzYxUkxoOVVBbjRIQ2hKZXJGUDdU?=
 =?utf-8?B?RXEzdW5BVXZ6V3crVG9jMFNlOHBjeFFiOWJ6Zm5lL0x4WGFBZFMwTnh5Q2Ji?=
 =?utf-8?B?eEtyWkhDOE5oUXBoSkRaM2haZ2NsSjY0Z3BJU1pwNVkwVWtnMExlVGNQVTFY?=
 =?utf-8?B?TVlVV3JuVjNjdWJiZXFMd2sxRUJNOHFtOGptZnkrSlpiNVVFMTlFbkVFNkdo?=
 =?utf-8?B?QXJ2L3lpblRETDJDWFAyQk9CekNvYWhKRndnMWdScldNbnVkRE5qWGZCUTNm?=
 =?utf-8?B?NEVNcHFicFpqZTdrdTh2a0JCa2ZuMyt6OFRwK0wzSTBKM2h3SEQ2NkhWbnFk?=
 =?utf-8?B?ZjhYOFJYMXZBM0kzQUhiN21mOW1lblRhOC8xRWw0RXo1Zi9SZFpXR1JGaDcw?=
 =?utf-8?B?dVRpS09MRkhIdTdxUUdpOVFqNmFCTHN2VzJvWnk5aXFvVkVDTjQySFB2UWt2?=
 =?utf-8?B?VTlKK1FXcFA0Z2JDWUlnbWhyOVVJbS9xb2NPWXByZkc5ZnJNbHZ0YWR3Tkp0?=
 =?utf-8?B?MllKNUpzRG9lZU9hOVpIOFUzc2pEdHIyOTJHSFYwTktZdHJvaXFEME45amFt?=
 =?utf-8?B?aVg0My9rOXpnZkV6OE8xczhkQlpVN0NURGxucFNxMjBCVVBpS0RZQnA3SFRK?=
 =?utf-8?B?UmNLOStxWEhQbHRHUDZqRm9lQVF2c1F4K1VJVWc1K1RtSlN1WTFCYUdWRGRV?=
 =?utf-8?B?Q00wRkhQdHZ0aUdTdkRDcXkrUW00RXM3ekdyQmh3cDNCcWVrZUhnQ2VkaWE4?=
 =?utf-8?Q?/xyMbewz7kFqGlCmEXoKRkEMD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc24859-dabd-4827-03fc-08dd767076a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 07:39:15.5560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oxUYSGQCx5h1XWPFLEe5uHwYjiuxQSDFibtWBOhQR+mmJIPHY6CZcQ7diSgpSz7L8PALh4eXugHIAubqTiZUQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB10044

UmV2aWV3ZWQtYnk6IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAuY29tPg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRob21hcyBSaWNoYXJkIDx0aG9tYXMucmlj
aGFyZEBib290bGluLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBcHJpbCA3LCAyMDI1IDExOjAzIFBN
DQo+IFRvOiBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsgUGFua2FqIEd1cHRh
DQo+IDxwYW5rYWouZ3VwdGFAbnhwLmNvbT47IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAu
Y29tPjsgSGVyYmVydCBYdQ0KPiA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgRGF2aWQg
Uy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogVGhvbWFzIFBldGF6em9uaSA8
dGhvbWFzLnBldGF6em9uaUBib290bGluLmNvbT47IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBUaG9tYXMgUmljaGFyZA0KPiA8
dGhvbWFzLnJpY2hhcmRAYm9vdGxpbi5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFtQQVRDSF0gY3J5
cHRvOiBjYWFtOiBBZGQgc3VwcG9ydCBmb3IgaS5NWDhRTQ0KPiANCj4gQ2F1dGlvbjogVGhpcyBp
cyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3aGVuIGNsaWNraW5nIGxpbmtz
IG9yIG9wZW5pbmcNCj4gYXR0YWNobWVudHMuIFdoZW4gaW4gZG91YnQsIHJlcG9ydCB0aGUgbWVz
c2FnZSB1c2luZyB0aGUgJ1JlcG9ydCB0aGlzIGVtYWlsJw0KPiBidXR0b24NCj4gDQo+IA0KPiBP
biBpLk1YOFFNLCBjYWFtIGNsb2NrcyBhcmUgdHVybmVkIG9uIGF1dG9tYXRpY2FsbHkgYW5kIExp
bnV4IGRvZXMgbm90IGhhdmUNCj4gYWNjZXNzIHRvIHRoZSBjYWFtIGNvbnRyb2xsZXIncyByZWdp
c3RlciBwYWdlLCBzbyBza2lwIGNsb2NrcyBpbml0aWFsaXphdGlvbi4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFRob21hcyBSaWNoYXJkIDx0aG9tYXMucmljaGFyZEBib290bGluLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2FhbS9j
dHJsLmMgYi9kcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyBpbmRleA0KPiBkNGIzOTE4NGRiZGIu
LjM4ZmY5MzEwNTliNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMN
Cj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4gQEAgLTU3Myw2ICs1NzMsNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IHNvY19kZXZpY2VfYXR0cmlidXRlDQo+IGNhYW1faW14X3Nv
Y190YWJsZVtdID0gew0KPiAgICAgICAgIHsgLnNvY19pZCA9ICJpLk1YNyoiLCAgLmRhdGEgPSAm
Y2FhbV9pbXg3X2RhdGEgfSwNCj4gICAgICAgICB7IC5zb2NfaWQgPSAiaS5NWDhNKiIsIC5kYXRh
ID0gJmNhYW1faW14N19kYXRhIH0sDQo+ICAgICAgICAgeyAuc29jX2lkID0gImkuTVg4VUxQIiwg
LmRhdGEgPSAmY2FhbV9pbXg4dWxwX2RhdGEgfSwNCj4gKyAgICAgICB7IC5zb2NfaWQgPSAiaS5N
WDhRTSIsIC5kYXRhID0gJmNhYW1faW14OHVscF9kYXRhIH0sDQo+ICAgICAgICAgeyAuc29jX2lk
ID0gIlZGKiIsICAgICAuZGF0YSA9ICZjYWFtX3ZmNjEwX2RhdGEgfSwNCj4gICAgICAgICB7IC5m
YW1pbHkgPSAiRnJlZXNjYWxlIGkuTVgiIH0sDQo+ICAgICAgICAgeyAvKiBzZW50aW5lbCAqLyB9
DQo+IA0KPiAtLS0NCj4gYmFzZS1jb21taXQ6IDBhZjJmNmJlMWI0MjgxMzg1YjYxOGNiODZhZDk0
NmVkZWQwODlhYzgNCj4gY2hhbmdlLWlkOiAyMDI1MDQwNy1pbXg4cW0tY2FhbS1zdXBwb3J0LTVm
MzE3ZWM4OWRkZQ0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBUaG9tYXMgUmljaGFyZCA8
dGhvbWFzLnJpY2hhcmRAYm9vdGxpbi5jb20+DQoNCg==
