Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028BE7BAF3
	for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706708064; cv=fail; b=IHrZh2J3yDfiv+KZ35QPyp7/KPDtUxPOXtXKfIgBIBJLgN9XvWxQuVrZOs23sXRhQR+z714D1/+ZPYFPgMVuQRHGAf4XuR7frMC9/AxjNuwwFvnWTZkOVuPReNrf0uluyZ8wKKpb2MVokUUVx7Yraf+EFprdAC1ApB76Kj1HwXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706708064; c=relaxed/simple;
	bh=FgEGcGNVH2xB1K7w/43nr3CMbQ3fTXL7waPLRFdUQP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KF3IXH4iTCrM+OvlI5dJ34DDnq3OujYa4eHsq6U8S5ljFVd7X4+12xoavPfJMI4RknPVrzdq6XFu3cxWoNl+t+hp4ln4XBITiyXWLeSpKvEUFvpXmn3NE18WW0fVvF3+tPMmgBGTSsnuNBkzcmcPVcRxl/BuLTU9c4QDX6s/yCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=GhInbi8v; arc=fail smtp.client-ip=40.107.21.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GhInbi8v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0cjHpuh6QBKMMp94n2aW5zpaM5nUYaJk+0CMU03vWrpbfmKeZ6WicX/Kn4oKJfsBMj5mElJfsZngBylRvqhXL95ksU5Ya6DNpK0n8Y5C9Z+dsv2qK7+sIkWviIVXle1J9BGNK8Xm+mjo398kgmZz3CkzuC7j370Hec4nacKs/5a3kLULqcq5RIqnu54cGF2rpCrV1eog1UyEsaV6vkBsYLaI7efQN6hCs41fEDQXgxMDpu4Rm7G0YnHUsZp/8JXFCEPH5+a6Jf6LP5SKvnQkDAcgOVNM2DpgasG1ST5R8gWqjTwsVlat293siljp/I7UkKQO3VRkEvqa1xdNqIdgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgEGcGNVH2xB1K7w/43nr3CMbQ3fTXL7waPLRFdUQP8=;
 b=Cf5X+TC10w9Y3nFwhxnls7ZOUmDfTUGHCYMqmjtZFqxOfIwWqiKU8NFeNYChApllzWQCasmhFWhoei29cCdjvw9USeAbY+cXpoRA4ilne4DBlNy9VLsdx6K81SIiDiT9XqraZ1uepG3VcqD3hizCHUecp7vu2+LwU0C8mboav08WKMCBFJrJ4o2IvgAsevBmLDntcQP9E5u1r1IR92AWLwfOFyA1QN/TIR2dgVdlSQQmX/nC8BDcstyTkyoPPfrXkw+rHqH+8J8aQI3XfMZlUgvP7WQ74iw2MGGI5tCKQ1SKddpEHe/jQAOvefBn4I71VpeX6MAOdk5++iq8XY/7yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgEGcGNVH2xB1K7w/43nr3CMbQ3fTXL7waPLRFdUQP8=;
 b=GhInbi8vmryRv1O9Vu0fxs2H1U02cpcFbpt8WzVgclQvGlxqiOfROTdDOLRTIfq928OPoNyc387BM2bnhLgQzOYuXQyrjvKsJWYaZPKW13Oo3waG2fUbg1D5LoiudTtwHB9tX35yTGV0WaRYgTY4I/Y4aaIGkJujHnUEgkGLU70=
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PAWPR04MB9813.eurprd04.prod.outlook.com (2603:10a6:102:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 13:34:17 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::9378:fa46:1278:b356]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::9378:fa46:1278:b356%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 13:34:17 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Kun Song <Kun.Song@windriver.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>
CC: Gaurav Jain <gaurav.jain@nxp.com>, Varun Sethi <V.Sethi@nxp.com>, Aymen
 Sghaier <aymen.sghaier@nxp.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"filip.pudak@windriver.com" <filip.pudak@windriver.com>,
	"heng.guo@windriver.com" <heng.guo@windriver.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Meenakshi
 Aggarwal <meenakshi.aggarwal@nxp.com>, "richard.danter@windriver.com"
	<richard.danter@windriver.com>
Subject: Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Thread-Topic: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Thread-Index: AQHaM/CZvLMsVNff10WmiRFbzfbcf7D0LH0A
Date: Wed, 31 Jan 2024 13:34:17 +0000
Message-ID: <5be20cd5-8758-452c-81a9-6452df7aedeb@nxp.com>
References: <20231221093209.984929-1-Kun.Song@windriver.com>
In-Reply-To: <20231221093209.984929-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PAWPR04MB9813:EE_
x-ms-office365-filtering-correlation-id: 80e49d0b-7720-4521-42c9-08dc226152b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ieTMnct4htF8HBBi98Zpc69/PMaKqbm0Xucl6ElfelQPO2FruD2Ujyfz1tdkIGOINmccpA1sMMCtEuT4gDJO4ginYif+4hOTPnMamMwjT8J5EQQzR2o/pcBdJI/Hv3+8dzOStu3yS06tqqPKuF+fuOc77j6d2u2WYXKnzo3hSe33Zsa/2wf3YNO/xUU8HbQG4HYgdVlREe+xnyQsQ7kIwps8xhcMrvXSCQojTn6MlVTZ36iTTTxFGD8j7oFLkxa2aq059WxMPKbV/tc/Qcs32FQOUVC9WcXkdYnL/S4IglfVKOpKQCI9kvZ/8vu+eMRV7b178DkLqCYDn/lwexYHCOJJqUxvSxjATJdRtgM+WufliwEKpFqYDZrEb+NHvjeQf8932B4e5p+zlCVwV4yHWZe/8mtZKor5P9b2dA3q/bTkhOPu02S1jbw3VZnOYFyUZIfZawnMiXHmejdzZN2V34ptxszNk3nyjAV7p30cnLiJEoim6OmEQwzGsS6onMW/1sqGf87/6dCC/vsK4m9hRbko7+Esj5lVZeWvLLS6gUR9VvuU34OZPECqWyIKbWGMQrkHl9NWqSnBWi97i4QAVXv+Jf7GuNNyDNS5STf4hAVU0vgtGh7+3gPRIi4Rw+pOM8ToY3WMEhol88x+5PjKFdIRkM2+LpONnfgxelsh3do=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(346002)(396003)(366004)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(41300700001)(83380400001)(6512007)(2616005)(26005)(38100700002)(122000001)(76116006)(8676002)(8936002)(4326008)(44832011)(5660300002)(45080400002)(478600001)(6486002)(2906002)(966005)(53546011)(6506007)(71200400001)(66946007)(55236004)(110136005)(54906003)(64756008)(66446008)(66476007)(66556008)(316002)(38070700009)(36756003)(31696002)(86362001)(31686004)(66899024)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M3NORXIxYndZMEFyOXdlN2hIZWkrOEtERHJKbXk3TGhQZmQ3emdLRzR2a2lh?=
 =?utf-8?B?aVFVV3dFUkxkTDU3aTM5d01UWk40Z3k3QlQ5azlDU2dRK0ZONC81WWhINmdz?=
 =?utf-8?B?VnRvZ0tVNzhSZ3lqUzBXd1FaNXVzOXA2eTZEUkgzRlBtend1c3NyVjNqc3pm?=
 =?utf-8?B?Rk9OMUl3Ukl2TnRSZUtxc2xHcE43c0dGRVFoMk5acVptV1pqR1c2cHF0Y2tG?=
 =?utf-8?B?VXkzVG5aZSsvNStXTFZxTFhCUWh4b1d6WkVUdWkzYmlldkFpNnlKYVA5SFZm?=
 =?utf-8?B?YktyaXI1dEZHNTZvZWhmRzhuamlEd3BnVktNS1lnbUx4RU5QL1YycVZ6TERr?=
 =?utf-8?B?aXlHYWlKQklFWTFIVnhmZXMyWTkrSUVKVklDb29GZ2ZPY1c0WjhDaUZ6WVpT?=
 =?utf-8?B?Qk9zbUpyQ05STk0zcko0V0ZKVzhsOUJ4L2tvUjlBdHluZENZSUhybHhXZmpT?=
 =?utf-8?B?RHV5TW1oQVBMaVFGbXJqZWVaVjJIcEpzcXZCSW5vdFg1VXA4azltRm5pNTZw?=
 =?utf-8?B?NGV5UFNjSUxTcmw4UlQ1dDNjTEN3b21tUHlKNmxoSU1JclFURGNKSlFYcHhx?=
 =?utf-8?B?V3l0eG1TRHE4YXBKMXlRemNlMTBEM21IaytFSEN0Y1JIZlRUMlJuQ08wU2R6?=
 =?utf-8?B?T2xGNk44ZnFzaVlRV29UZlovS29uYks3VXJBUHhHYkdxMXRPZERIbHhlWUpH?=
 =?utf-8?B?WVFvdE1pWmFtSE9mSGhETEp0RHFBOXdmcnRERkR4WkI1cWFZNUlFU1RuTHRK?=
 =?utf-8?B?bk52RTJuTVlWdk5Ua1dzWnBCTXdqajgzejNpaStDTFdVWWdJWFFRbDY0WHZj?=
 =?utf-8?B?ays1YS9UUkgzaWh4TUZmd0tYRGpvNmdsTitwS3dGa0xpL3ZqZzh0ajlBODBI?=
 =?utf-8?B?eXZJZXFHQkJNdnlBRUZCaGpzTndocWszaWpkQzc0WWk1cUZudFYzUEZORTFO?=
 =?utf-8?B?a201VmJITTJJOEFlK1pDVEx2eXRJMVMxQy85cDU2U3NUZnRRcEcyQTlVUU5z?=
 =?utf-8?B?Y05YNWY3QytkTEdwYkZwRUFGdGIyOHJIRDYzVStINURJWU9UL0s3ZHA2b0Fk?=
 =?utf-8?B?emI4azV3Tm5SYnVnbWJianRpL2V1elYvbnk3WmpvbkpNM292ZmJ4WXBsdXZy?=
 =?utf-8?B?bzlQcm1nZkpwTFF2QTBHQUlRRnhoRnBBYy96WHlUdnVOejZhWDhWS05jWjlI?=
 =?utf-8?B?U3JqSmhVNDBMR2RZWE5YZVJ0S3lIM00rcURiRFQ4M3lleSsxdktLZUtnNFNl?=
 =?utf-8?B?VHdBK0tCdGJ3VG9TWUdOUWxYellNN2Z6MkoyNFlJUnVPbkIzczd5VjN3akVY?=
 =?utf-8?B?ZWlTS09mVXBpYzdLNW9KVlFZcW42M1dXQ2dOWkxpY1BtRjZ3bDd1MVpLT1hq?=
 =?utf-8?B?dVVwTkE3LzBDVU85eTlHWk16dUJuYjR2eVhjVEk0MXJjR0dtL2txeGlZWms0?=
 =?utf-8?B?M2FkaFlzUjFjMGEvZVc1c25aNktXQXNOaFdhMjlqcTZFclVkRWd3R29KNmFI?=
 =?utf-8?B?SVRuRmpBR1UydFJMaUpkcCtlVmNKOE9VM24rTDZMU0NzOFJuQmFpNVRQS2I1?=
 =?utf-8?B?MzA5UXpHaCt0M1pwQjBSdVZDbzkzVE1KWDVQWEQ2MklMSnRsbndaN040WUc0?=
 =?utf-8?B?Q2RhdnkzTmJPZ2hndlAvV2RncG8rY3J1OUpFdFJnbkx6dHVDMFV5cDRzeHAr?=
 =?utf-8?B?MEN2Qkxwc0hEZno1Tkx6T1RQQXBSSVppamhFcFc4bkc5aHlpMWVrdlRQOWJQ?=
 =?utf-8?B?MDhCd0lSOVByRzhBSmMva0JkeGlWMVhvcXEzS2ZwWFZHV05GUFJLblJvZXlu?=
 =?utf-8?B?RW9LY3dKa01xWDBHVGNqSTBZSHQrdDRtL1Fxc0pZK3d5c3psdXpxdXVmOUtD?=
 =?utf-8?B?Q3JsdXd3bVUwUi85Z09uV1BYOCtIcU83SGRPR21vdnpSaE4vYVIrRGNsNUsr?=
 =?utf-8?B?QXowNWNGUVpzMEx6bVVQU0dIajZ0am0xdGFkcU9vNFFCSXZ4R3RmbXREVkJG?=
 =?utf-8?B?R2NhbVlDd3luS2wyMHVYSGU1VXNGc3FyU042b0lvNzdDZ3FSQUd3NEVPWXE1?=
 =?utf-8?B?NG9GUll4SU04ZDRlK2lqSy9kRzhwbEtkd0k0UE9TU25VRTJLSVNGZHRjWXdS?=
 =?utf-8?B?SEVNUFFoNDZyZTJ4MU9DRW1UbEtnQVpLQXo2MDJ5L044VnBqVS9tRnhJTXZm?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF1EEB04972FC548B79CBBE6C2B14E5D@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e49d0b-7720-4521-42c9-08dc226152b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2024 13:34:17.4344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3lE8xZiVob6AjPpZo22Gc5vTi5k1hHxVVeidrrKfr93eZ5Ny1YXpobZ7hyqAVufQRa5hlP5hYbMzMmPA2TDy6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9813

T24gMTIvMjEvMjAyMyAxMTozMiBBTSwgS3VuIFNvbmcgd3JvdGU6DQo+IFRlc3QgZW52aXJvbm1l
bnQ6DQo+ICAgTGludXgga2VybmVsIHZlcnNpb246IDUuMTAueQ0KPiAgIEFyY2hpdGVjdHVyZTog
QVJNIENvcnRleC1BDQo+ICAgUHJvY2Vzc29yOiBOWFAgTGF5ZXJzY2FwZSBMUzEwMjgNCj4gDQo+
IENyYXNoIGluIHJlYm9vdCB0ZXN0czoNCj4gICBSZXByb2R1Y2liaWxpdHk6IDElDQo+IA0KUmVw
bHlpbmcgaGVyZSB0byBjb21tZW50IG9uIHRoZSBsb2cuDQpJJ3ZlIGFkZGVkIGFsbCB0aGUgcGVv
cGxlIGZyb20gdGhlIGxhdGVzdCByZXBseSwgaS5lLjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xpbnV4LWNyeXB0by9BTTBQUjA0TUI2MDA0QUVDREQwNDRGMUU2QkYzQjY3MzJFNzY4MkBBTTBQ
UjA0TUI2MDA0LmV1cnByZDA0LnByb2Qub3V0bG9vay5jb20NCg0KPiBJZiBhIGpvYiByaW5nIGlz
IHN0aWxsIGFsbG9jYXRlZCwgT25jZSBjYWFtX2pyX3JlbW92ZSgpIHJldHVybmVkLA0KPiBqcnBy
aXYgd2lsbCBiZSBmcmVlZCBhbmQgdGhlIHJlZ2lzdGVycyB3aWxsIGdldCB1bm1hcHBlZC5UaGVu
DQpJbiB0aGlzIGNhc2UsIG1vc3QgbGlrZWx5IHRoZSByb290IGNhdXNlIGlzIGRpZmZlcmVudCAo
c2VlIGJlbG93KS4NCg0KPiBjYWFtX2pyX2ludGVycnVwdCB3aWxsIGdldCBlcnJvciBpcnFzdGF0
ZSB2YWx1ZS4NCj4gU28gc3VjaCBhIGpvYiByaW5nIHdpbGwgcHJvYmFibHkgY3Jhc2guQ3Jhc2gg
aW5mbyBpcyBiZWxvdzoNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gUkJTIFN5czogUmVzdGFydCBvcmRlcmVkIGJ5IGVwZ2hkKDB4MSkNCj4gUkJTIFN5czogUkVT
VEFSVElORw0KVGhpcyBsb29rcyBsaWtlIGEgc3lzdGVtIHJlc3RhcnQuDQoNCj4gY2FhbV9qciA4
MDMwMDAwLmpyOiBEZXZpY2UgaXMgYnVzeQ0KPiBjYWFtX2pyIDgwMjAwMDAuanI6IERldmljZSBp
cyBidXN5DQo+IGNhYW1fanIgODAxMDAwMC5qcjogRGV2aWNlIGlzIGJ1c3kNCkZvciBzb21lIHJl
YXNvbiwgdGhlcmUgYXJlIHN0aWxsIHRmbXMgYWNjb3VudGVkIGZvciBvbiBhbGwgdGhlc2UgY2Fh
bSBqb2IgcmluZ3MuDQpNYXliZSB0aGUgc3lzdGVtIHJlc3RhcnQgaXMgbm90IGhhbmRsZWQgY29y
cmVjdGx5IGF0IHNvbWUgcG9pbnQsDQpoZW5jZSBzb21lIHJlc291cmNlIGxlYWtzICh1bmFsbG9j
YXRlZCB0Zm1zKS4NCg0KQXMgYWxyZWFkeSBkaXNjdXNzZWQsIGV4aXRpbmcgZWFybHkgZnJvbSBj
YWFtX2pyIC5yZW1vdmUoKSBjYWxsYmFjayB3aWxsIGxlYXZlDQp0aGUgSFcgdW5xdWllc2NlZCAo
ZS5nLiBqb2IgcmluZ3Mgbm90IGZsdXNoZWQpLCBpbnRlcnJ1cHRzIHN0aWxsIGFjdGl2ZS4NCg0K
PiBhcm0tc21tdSA1MDAwMDAwLmlvbW11OiBkaXNhYmxpbmcgdHJhbnNsYXRpb24NCkZyb20gaGVy
ZSBvbndhcmQgY2FhbSBtZW1vcnkgYWNjZXNzZXMgd29uJ3QgYmUgdHJhbnNsYXRlZC4NCg0KPiBj
YWFtX2pyIDgwMTAwMDAuanI6IGpvYiByaW5nIGVycm9yOiBpcnFzdGF0ZTogMDAwMDAxMDMNClRo
ZSBlcnJvciBjb2RlIG1lYW5zIGNhYW0gd2FzIG5vdCBhYmxlIHRvIHdyaXRlIHRoZSBzdGF0dXMg
b2YgdGhlIGpvYg0KaXQganVzdCBmaW5pc2hlZCBpbiB0aGUgb3V0cHV0IGpvYiByaW5nICh3aGlj
aCBpcyBhbGxvY2F0ZWQgaW4gbWVtb3J5KS4NCg0KTW9zdCBsaWtlbHkgdGhpcyBoYXBwZW5lZCBk
dWUgdG8gaW9tbXUgbm8gbG9uZ2VyIHRyYW5zbGF0aW5nIHRoZSBhY2Nlc3MuDQoNCj4gDQo+IERp
c2FibGluZyBpbnRlcnJ1cHRzIGlzIHRvIGVuc3VyZSB0aGF0IHRoZSBkZXZpY2UgcmVtb3ZhbA0K
PiBvcGVyYXRpb24gaXMgbm90IGludGVycnVwdGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS3Vu
IFNvbmcgPEt1bi5Tb25nQHdpbmRyaXZlci5jb20+DQo+IFJldmlld2VkLWJ5OiBIZW4gR3VvIDxI
ZW5nLkd1b0B3aW5kcml2ZXIuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vanIu
YyB8IDQgKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0v
anIuYw0KPiBpbmRleCA2ZjY2OTk2NmJhMmMuLmQxOTFlOGNhYTFhZCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9jcnlwdG8vY2FhbS9qci5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vanIu
Yw0KPiBAQCAtMTM1LDYgKzEzNSwxMCBAQCBzdGF0aWMgaW50IGNhYW1fanJfcmVtb3ZlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJanJkZXYgPSAmcGRldi0+ZGV2Ow0KPiAgCWpy
cHJpdiA9IGRldl9nZXRfZHJ2ZGF0YShqcmRldik7DQo+ICANCj4gKwkvKiBEaXNhYmxpbmcgaW50
ZXJydXB0cyBpcyBlbnN1cmUgdGhhdCB0aGUgZGV2aWNlIHJlbW92YWwgb3BlcmF0aW9uDQo+ICsJ
ICogaXMgbm90IGludGVycnVwdGVkIGJ5IGludGVycnVwdHMuDQo+ICsJICovDQo+ICsJZGV2bV9m
cmVlX2lycShqcmRldiwganJwcml2LT5pcnEsIGpyZGV2KTsNCj4gIAlpZiAoanJwcml2LT5od3Ju
ZykNCj4gIAkJY2FhbV9ybmdfZXhpdChqcmRldi0+cGFyZW50KTsNCj4gIA0KQXMgcG9pbnRlZCBv
dXQgYnkgcHJldmlvdXMgZGlzY3Vzc2lvbnMsIHRoaXMgaXMgbm90IGVub3VnaC4NCkNyYXNoZXMg
Y291bGQgc3RpbGwgb2NjdXIgZHVlIHRvIGNyeXB0byBBUEkgdXNlcnMgY2FsbGluZyBpbnRvIGNh
YW0gZHJpdmVyLA0Kd2hpY2ggd291bGQgYmUgaW4gYW4gaW5jb25zaXN0ZW50IHN0YXRlLg0KDQpX
aGV0aGVyIC5yZW1vdmUoKSBiZWluZyBjYWxsZWQgaXMgdHJpZ2dlcmVkIGJ5IGEgc3lzdGVtIHJl
c3RhcnQgb3INCmEgbWFudWFsIGRldmljZSB1bmJpbmRpbmcgWzFdIGlzIGlycmVsZXZhbnQsIHRo
ZSBkcml2ZXIgbXVzdG4ndCBjcmFzaC4NCg0KSSB0aGluayBIZXJiZXJ0J3Mgc3VnZ2VzdGlvbiBb
Ml0gb24gaG93IHRvIGRlYWwgd2l0aCBIVyBkZXZpY2VzIGdvaW5nIGF3YXkNCm1ha2VzIHNlbnNl
Lg0KDQpOb3Qgc3VyZSBpZiB0aGUgY2hhbmdlcyAodGhpbmtpbmcgb2YgY3J5cHRvIEFQSSBwYXJ0
KSBjb3VsZCBnbyBpbnRvIExUUyBrZXJuZWxzLg0KSWYgbm90LCB3ZSdsbCBoYXZlIHRvIHN0aWNr
IHRvIGNhYW0gZHJpdmVyLW9ubHkgY2hhbmdlcyAoYnV0IElJVUMNCm90aGVyIGNyeXB0byBkcml2
ZXJzIGFyZSBoYXZpbmcgdGhlIHNhbWUgaXNzdWUgd2l0aCBIVyBkZXZpY2VzIGdvaW5nIGF3YXkg
WzNdKS4NCg0KVGhhbmtzLA0KSG9yaWENCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LWNyeXB0by9WSTFQUjA0TUI3MDIzQTdFQzkxNTk5QTUzN0NCNkE0ODdFRUIzMEBWSTFQUjA0
TUI3MDIzLmV1cnByZDA0LnByb2Qub3V0bG9vay5jb20vDQpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGludXgtY3J5cHRvLzIwMTkwOTE5MTM0NTEyLkdBMjkzMjBAZ29uZG9yLmFwYW5hLm9y
Zy5hdS8NClszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vWkFxd1RxdzNs
UitkbkltT0Bnb25kb3IuYXBhbmEub3JnLmF1Lw0KDQo=
