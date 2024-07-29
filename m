Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E9A15666D
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2024 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722264606; cv=fail; b=jB2bZgkSmna3zMtl/iyrK+MIP6PH7zyOBVmCR0mTHV07Na3OG+igXPTYKlRa13/l0GFtkwLtpUr8zC9QJpmvXsH/BlIzE1E6iJE/9rHopLcCbr9x1WrX/G5jt2zzkt9qXMHPJ9WtuNk7UAZzWev7o1UwAiV+DF5Ets5N1BmMReY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722264606; c=relaxed/simple;
	bh=KT4z7j9YkpfaSgt1TOnBdz/OB8+7YURbyfPIbgaVCCg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ep2CbElWLTF8Ksr6AqBdzdy5dO9GJj2W3P11uKeOFCI6MkhJZNN0/ZcfK3JMGEoGjKGncYgcJjiBKQackqorHvN8hcIq5QhSdPu4+y43ebvzDuQSk1IwLp10YE3FrkpSp42zzEN0Joa/7Uw6QuoLu8bYwdVkou/8wepouAuxnZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=Nigg4X9J; arc=fail smtp.client-ip=40.107.22.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="Nigg4X9J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=In8yDW/jTWtNFZIq/uzsnItKoYpcVpGGf3inrxzsOzAOHSLb7vq3kukZykY84evFv1iILMTGHaITzKYFIomMihTiHcuYdq1Ule6ZDoL/1vs9iQEXGBDq729ioSJythwDBvmSX9LZXOMYMIoqFWTq/XytZzPyE8nuDt2QZEMcjoMhz13FQP8banXz0uw+/FlzAWxjv8updgho0hHED9z90dER3eZYe181z1GKSxDUcH84OzqXO/fYyZzaMFm7Ydf7fG+biB9PwtGr7546yi+EOp6/88z792E/CZK2tJt+EfRyusPGyjirg0q2JhFXZHgSnLy0bGLPkWBX719bVsjnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KT4z7j9YkpfaSgt1TOnBdz/OB8+7YURbyfPIbgaVCCg=;
 b=Mp+WAdkF7lyWSJSNAnKOKFnZ31ebGS+htKUgUEzTSxvzhl7ziWWfKWMqXi60JZdg5aI2gg7Yjfne1cwZWkYd5fdaKMEORDtI64sF+x5Xfk7GvdqVVZh7LVgZ+jJ74cMF/WulVR+b3UHWHnfBDsqaCpRz//fJE5XIXhER4PcPQuairX5Yg3+gVA/d/o3GuUfl/3K9/p9JZHXFY1AEtK01+sbTlnko+zsHPAxX5LAqLlBpUk0iR6yoZLpD1Ext0gIb4g/oyT+pEoNhIZYTMZoPPlWxBmKY7i8eFmsGmVQA+/MMafzPCzpwhsnja6zJF3y4E/A/dxSZ9LGRjAC3iX25+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT4z7j9YkpfaSgt1TOnBdz/OB8+7YURbyfPIbgaVCCg=;
 b=Nigg4X9JkADPrtdevmTQNqRT+RSxXFJPkgCKqf89GOSaH4RHyugKZD1YfSYDcy1p/oE9J9I35Akpbzo59Zrr7kYVkdCKL18HgPVJ2fHQP1q4C41yN3GGs6iQfLbIcWBU0NhFH2mS6lU6k78D9pkHqaYvU6k0BSmglVeIFpMT/4hIAT28WQDd7MRS2pXt4VHef0HcawuHWcrZgYFfJ2YNO7ogdJKRigwpHgyYLFLHL0V48xpbwBTlTJEp5N1sy87UvgxC4uUxH3HkTn5NcqeN7gs4Y3Tz3io75xM80vaKEnPly1hQbCdfy8nn5fC6y/T3MsCkWnUge+pMJaTGwomPsA==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PR3PR04MB7257.eurprd04.prod.outlook.com (2603:10a6:102:93::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Mon, 29 Jul
 2024 14:50:00 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%2]) with mapi id 15.20.7807.026; Mon, 29 Jul 2024
 14:50:00 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav
 Jain <gaurav.jain@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi2 - use cpumask_var_t in
 dpaa2_dpseci_setup
Thread-Topic: [PATCH] crypto: caam/qi2 - use cpumask_var_t in
 dpaa2_dpseci_setup
Thread-Index: AQHa4ZgAWnZ1KPszCUG2GVfRIlyw3bINyfuA
Date: Mon, 29 Jul 2024 14:50:00 +0000
Message-ID: <39d32499-d41d-4cbd-be3e-25f92ebd8df9@nxp.com>
References: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>
In-Reply-To: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PR3PR04MB7257:EE_
x-ms-office365-filtering-correlation-id: ad9042b6-d6d8-4c99-8141-08dcafddb90a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z0dMM2laNHQyaW1xOWQ0b2pualh0T2M4b3ZvTkoyME9xcjdlUVlodFdKMU1O?=
 =?utf-8?B?S093SDRyZzQ3TTQvclhRWiswNUVqTDd6bkE3dkNHeklHd3BoWVcxVjQ3K3BN?=
 =?utf-8?B?TGd2YTBxZTJoZzcyNGZteW5kcWl0M09ON2phd3Z3V1NNWDliSHYwT1ZEM3hn?=
 =?utf-8?B?T2wvelJLK1RycEpFWjNqRWJvaGs4bUZJYTJCMUxFSXRFSS9RL3VlTnArUmpr?=
 =?utf-8?B?ZXUrM0gwcFZpQTVZcytCR0swclVWTFQzK3ZpUkoybGltZFhlRjdzeS9Dc25M?=
 =?utf-8?B?dnV5bldySFFjcG4wbWNTK28wYlRPenhoVFZBZzg0cUY4cER6S0tkL1AxUWNF?=
 =?utf-8?B?NWI5dy85K01udTljVTM1UXpmbXorOUVqbHJlQTNtRlM0REcvekZMeEduRjE0?=
 =?utf-8?B?cmNYeExzSE9UZkRETjJXZm5vYVRGM3VsSTF6OWVWYkFPLzA1UDlMMndwWHQy?=
 =?utf-8?B?c1MzWFNrek15bUMvNHc0b01UTDNaaVkwUmx1d3lRREt1UzdEVU1ySFRVelZY?=
 =?utf-8?B?K2E2ZFZVc0RVUTN1ZTVSWlliemVWSms1cGlrdEFtR3JPYnFCUGlqRU1PRzcw?=
 =?utf-8?B?aUQrMmt0akQvVHFkVVZOMEM4cW0zWDkzTkRrbnZNUW1Xdk94TVM0YmtGdG92?=
 =?utf-8?B?YUJ0ajBNaG1Ta2dDd3RtNEsyL1d6ZENqUzdHWEhTQWF0M2JpOWhhbW8vWjB3?=
 =?utf-8?B?L20xTVBielFyYTFrNkVLUnJIeWM2Rnc4L3M1Y2N2Vkc2UVpuY0F4NTVCSDVl?=
 =?utf-8?B?V3JKNFcxTjJaYU9OU2ozZzlDaU5RMXhXUU5qdzg0cGVacm51alRUSmV4MDRN?=
 =?utf-8?B?UU41WkpZZ0plRnJUcUZHd1VoWGluampWUmQ3N0J1ZFhvRWhvdzd1Tml2WHpN?=
 =?utf-8?B?RHpTaFEwbVQ4K3owY0RIUDc1eEI0R093cndVOG8ya3pnSk5TSXdwajVsWi82?=
 =?utf-8?B?aWdad2pmZzBuTGhESDFURjArVTVEME9ORHd6MWZ4SW5rdlJzMk92WVZuTkFU?=
 =?utf-8?B?MzhxZFdCVHU2WDdpRTlrUXdMbVFFUDBVRjNtY2d0TGwyNXBsTmxEdDR6clU3?=
 =?utf-8?B?Y2JKSDBCSm5NTm9SWW9rajFPVVdHYW5iL044Y0xHYkJpQmdhNkViSnZuZG1I?=
 =?utf-8?B?U1VETWt6Sy95Q3F1UlBOdmRkbE91ZUZPU1NpL0ErcWtUc01CZU9oNlU5Y0NW?=
 =?utf-8?B?TnBVLzNXaGtkNlNBOFZ3UTVFeVhiZGNUc0VZRC9Uei9WWlgyUFFQakM0Smsz?=
 =?utf-8?B?U3NqYU9Jdkh2VE5XTXdwSnc5cjBKOXgwakJnSkxqN09TVkFlRXNYK25uM3Rl?=
 =?utf-8?B?c2xoU2svV1BOb01qc0Nwd05EQktlZzJDVlhERmhLNk52ZktEQXBVK092OHlQ?=
 =?utf-8?B?ZDVvMi80RFNWSkF0Z0Fic2JZS203eHRIUjZ2Z3Jsb3BMZjVTR3pybHpwek90?=
 =?utf-8?B?SDhJZ3FKcXI3SlhhRWJMdzBGV0VCVzgwM2hZb05NRGVTK1NFbUZDMy9pRzhV?=
 =?utf-8?B?UXUyekNnQkNMdXJta3kwUnZYNU9kMWhyUTJEMXUzbGhJaW5kV0xMQVI5U3di?=
 =?utf-8?B?YkozU2ZweW1nZGhKSUpmLzdmeCs1V0F4SFlRUG9IT3dVNkIzMEFSb2FyNXRx?=
 =?utf-8?B?Ui83QWlkdkZkdEI1MFN5b3RFZUpKQWhNQ3ZORUFVSU5ReUNRWGUxaWtZMnJt?=
 =?utf-8?B?eTU0UkdkUlZCRS9qMnJGT2FKTmJOK3FYVnJFeVl2MjEyUjlqL2RsN1pweUYx?=
 =?utf-8?B?ZE13N01tNWZJOWdCMGswNnFnS25jUG82WlpkNy9vWGtUODhqbkVuQmlxUW9v?=
 =?utf-8?Q?u2A5yUteJbSrcBcuGSSImH++QCeYMPlmbZoWg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NXNEckMvQXFCSlpjQkNPMzI1Z3ZDSENCSHRaNEJndVFLQTdUd1Y2c0RmZDhz?=
 =?utf-8?B?c2JqSURKSUlwKzlvYzhZT0dLTlBzdXc4UlhQQ2Q1dWFpZTNkZnJaVWxJZkNS?=
 =?utf-8?B?RnZWbjlYdlEzTlBKSExwQUQrK2VPZmJpUG9JMVNDY2o0UnZJY204dmxrU3hp?=
 =?utf-8?B?YVdpWmo0WDJhQ2pNazUzZDNDZzVLSHhOK2YvTEZyalBzSWJ0dGdGL05HMkhj?=
 =?utf-8?B?YWh6bEQvbVZVK2grOXdEajZXWGdLNC8xTzluck9PWCtMU2tUa0RUUCtiVnJB?=
 =?utf-8?B?Zmx2SUFVMnZDNGtyNmpIcTZGLzVvakNKTi8rMW9wOVNxRUM3WC83bSs4aHN6?=
 =?utf-8?B?ZVdsNHNJSWpUOElIK01ZZGk0Y0d2cFlkYldQSTdUbkhrRHQyQ05qazhwdzV6?=
 =?utf-8?B?Y09uVVVoYU5aNkJkeEpITzl1OCtubEc0YWs4YmVZdEpOa0lTc0FLRUswcTB3?=
 =?utf-8?B?MDhaT0ozUGdyaUpqM0ZFQWIybmx0Zm42WGFDUUhSL01xaDZ0akEyWHUyeDFL?=
 =?utf-8?B?ZmdsS1hMQ0ZsbEVVU05oRW1yRUt2OE5FT2N2am90YU5vdnNRY1ZYd2ptWnlq?=
 =?utf-8?B?M1gwQkJDTlllaEFBVmpjVS9zOUdLUXd2WTlUejBRcVYxSWRKQ041ajR5dm41?=
 =?utf-8?B?NW13bm9OZlB0MGRFajUvU1VwVDMxNDVFU29HcHlRdnJhUHFiZlpub2JkQyt1?=
 =?utf-8?B?TXhzbXYwc1prSG15NEdkNWo3b3ovTXFLRnJ1dGFDQU9HTVhzM3NWOWJyWEhS?=
 =?utf-8?B?Q3BwZHl2b09SS1pYVEZOeWowNE9uaTQ3ajhRdmhRMXJKTDBNUWtHK3ZJN0Nh?=
 =?utf-8?B?ZHpSblpRVmVjVkczOHZsZFhqanA4eXVkaEdscVFnanJIeXE0eUxvRzNuUmZn?=
 =?utf-8?B?U3BqeWZsVmQ2MFBmejVrV0huQ3lCd053NndLRk5xMDZPRW9wQVUrRm1DaW5N?=
 =?utf-8?B?c2tBbGpIN2sydUdmMkx3QnhPeGs5N3BadnBETnEzS2Mvd3BldERTSDdXaXo4?=
 =?utf-8?B?TEtLWVlubzZkTnRaZHpqMVlHSW9ndFE0a0dDYW1QdmdJR1gzZXQ5Mnk1Ymkz?=
 =?utf-8?B?cjBhMURpQXRCZFFTSzJKZkdHU1AxZ3pEVDJpMkpXSTJrVTB2c0huV3lmRm9j?=
 =?utf-8?B?ZmZzempOcGlnaENQQkRjVTVtNEZWM0pZclZSZ1pKK3BKbWR3cGV1WTVmb3FZ?=
 =?utf-8?B?RVE2SE0xN1hMQUUyOUNOV0ozTXNPcGNpZFk3RE8xNFV6bW5DTStoSS9pMmE1?=
 =?utf-8?B?YitMSHpZV3g4a2NOdUNyaHlJUk9aRDVZMnA4QmMvQ1B0MEkwTmdQVlFlL0FV?=
 =?utf-8?B?NDQ2L2hxcUxPVVM5YUl4QXF5VHRmazdqMTJhMjltRjhaMlUzbWIyU2FaZTBK?=
 =?utf-8?B?dVdUUS9wZ0JDcUlmOStCTHhIOWVCcTdXazRkcVZyaDBZZjNtcHFOZ2ZYMFZ2?=
 =?utf-8?B?NnJET0VyQTlNZlJYZzdXSG1tU2w2akVkSzlNck5DN1RlYjZ0OGZkNnhzMTRC?=
 =?utf-8?B?YVF1TEtIYnlBUDNLOE5KU1J2bGNLUUdEQjdWZThMZHpjSU5EZUF4dWliZnNP?=
 =?utf-8?B?RDkrVG43V0V4WWlTaDJaa1N1dmpzSDZXbEZwYVNMRVFYMjB4cUNCSlZKOHM4?=
 =?utf-8?B?MnMreVhQZWQyTWxuZWhnbHBoS2F5VjAydm1IaWQ2bGcrY2NQb0pUNVVuL3JZ?=
 =?utf-8?B?cE9wRzN0aTNNaVpzL1A3QllrNmQ4MERHSHJBYXBFNUg0akFObi94ZHNOTTMx?=
 =?utf-8?B?WWVHaWtIMHd6RVJidEZJeEZ6dDFJL3B5U3pMcFh1bjJQbUhMd05Oem5BMEZU?=
 =?utf-8?B?NUdDNmU2TnFDcTgxYkQ0TG1IVTRvb3kzS3k4ZTRFMlBtRmtGd0lLYS9SWTlU?=
 =?utf-8?B?N2dJazh0dGlrc0VLWmpKVThBaHFZaENFbW9KQ3M3eGx2dzRpZjFUckZ3RXN2?=
 =?utf-8?B?THBZY1JPOUdYWlJnUlFENTFpVnV3YWJMOFp5dm1NYy9YbmM5VzkvT2tHVGhz?=
 =?utf-8?B?V2RGeFRSSVRHUmNQclNjcHV5ZTJ5cTl3enczRHNLbWE5N1BvNzhtSVRpYXNL?=
 =?utf-8?B?VWpzcmlDcTB2eEQrZjVWZk1TdVZDa1EvWWtPMGhlYTBERlhnZ3VrQmw3SDlk?=
 =?utf-8?B?WHM4Q1lQeVl6Q1hoOU83dkRyVXNLaFZvSUVpcU5mREJzeWlUQU01N2p0eW45?=
 =?utf-8?B?b1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63B23928A48EE842A81FFD4DE2FA5A9A@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9042b6-d6d8-4c99-8141-08dcafddb90a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2024 14:50:00.6462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJXQhx8YGTOkILzw7Fw+Ox7sHU0clHqP2/r/e7QMqkx01NrzdEpbxUG5v/sQ+6oFrBk+kJlHk30gj26FDaZA6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7257

T24gNy8yOS8yMDI0IDEyOjE2IFBNLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBTd2l0Y2ggY3B1bWFz
a190IHRvIGNwdW1hc2tfdmFyX3QgYXMgdGhlIGZvcm1lciBtYXkgYmUgdG9vIGJpZw0KPiBmb3Ig
dGhlIHN0YWNrOg0KPiANCj4gICBDQyBbTV0gIGRyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFsZ19x
aTIubw0KPiAuLi9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1hbGdfcWkyLmM6IEluIGZ1bmN0aW9u
IOKAmGRwYWEyX2Rwc2VjaV9zZXR1cOKAmToNCj4gLi4vZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFt
YWxnX3FpMi5jOjUxMzU6MTogd2FybmluZzogdGhlIGZyYW1lIHNpemUgb2YgMTAzMiBieXRlcyBp
cyBsYXJnZXIgdGhhbiAxMDI0IGJ5dGVzIFstV2ZyYW1lLWxhcmdlci10aGFuPV0NCj4gIDUxMzUg
fCB9DQo+ICAgICAgIHwgXg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KUmV2aWV3ZWQtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlh
LmdlYW50YUBueHAuY29tPg0KDQp0aG91Z2ggSSBoYXZlIGEgZmV3IGNvbW1lbnRzOg0KDQoxLiBU
aGlzIHBhdGNoIGRvZXMgbm90IGFwcGx5IGNsZWFubHkgb24gY3J5cHRvIHRyZWUNCg0KUGF0Y2gg
ZGVwZW5kcyBvbiB0aGUgcGF0Y2ggc2V0DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1j
cnlwdG8vMjAyNDA3MDIxODU1NTcuMzY5OTk5MS0xLWxlaXRhb0BkZWJpYW4ub3JnLw0Kd2hpY2gg
d2FzIG1lcmdlZCB2aWEgbmV0LW5leHQuDQoNCkkgYXNzdW1lIHRoZSBkZXBlbmRlbmN5IHdpbGwg
YmUgZml4ZWQgd2l0aCB0aGUgY3J5cHRvIHRyZWUgbW92aW5nIHRvIHY2LjExLXJjMS4NCg0KDQoy
LiBJIHdhcyBub3QgYWJsZSB0byByZXByb2R1Y2UgdGhlIGlzc3VlDQoNCkkgdHJpZWQgb24gYXJt
NjQgYW5kIGkzODYgKHdpdGggQ09NUElMRV9URVNUPXkpIGRlZmNvbmZpZ3MuDQoNCkkgY291bGQg
cmVwcm9kdWNlIHRoZSBpc3N1ZSBvbiBhcm02NCBvbmx5IHdoZW4gbW9kaWZ5aW5nDQpDT05GSUdf
RlJBTUVfV0FSTj0yMDQ4IC0+IDEwMjQuDQoNClN0aWxsLCBJIHdvdWxkIGxpa2UgdG8ga25vdyB5
b3VyIGNvbmZpZ3VyYXRpb24sIHNpbmNlIHRoZXJlIGlzIGEgc2ltaWxhciBjYXNlDQppbiBjYWFt
X3FpX2luaXQoKSAoZHJpdmVycy9jcnlwdG8vY2FhbS9xaS5jKSB3aGljaCBtaWdodCBuZWVkIGF0
dGVudGlvbiB0b28uDQoNClRoYW5rcywNCkhvcmlhDQoNCg==
