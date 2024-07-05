Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE66146598;
	Fri,  5 Jul 2024 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720172364; cv=fail; b=PsZn6P6CAuC8QW83flUN6tnitgnOudV2yj08iobQlx3HczX4L8oYKg9ruXdj57qPkbE4MDAUsFvPPQ0Bt5tRpkuOAjoLsc/y1/Yy+Z1EnmnWPpy87nVZG4jKIyiJAx3act2EAZVzDrGe3lCLCVtZjjLDWpTqg1yCQzdVR2Ydyp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720172364; c=relaxed/simple;
	bh=HC6e+5VNEGzhGAs5RAYDQN4MWtVP9yMr5zMni1IWLrU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YW4MR5+057leibawSb6swIBpVp47LmrZyDak1Upsb0+k/I1z1KM97sKcFUOeAWv/+qTZ48StzIdd1Q8fGT+10y2K06F6W/Z7P1ScFmZWqq1XV1Xxv2afSCd5dS2ZHmiHaX72PuAm/1sESv8RJ9/fjKvlCi2Eur82i5sTosPMcls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=Wy6ScqVH; arc=fail smtp.client-ip=40.107.22.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Wy6ScqVH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwuRTitt2t0nntgaltenNVNyRscAXJU1gftsFmrIQr8l8tYx1wCMGQpoVkecre+dEZf1yn40MGz6ff1gqU/ixuALN2xBRLCK80iPwtu74DbTfLtOUuGuDMcb3W4zpaSuWfzBbLV/RQThRqLLPlhdx7GiCcw5ttkJqAiwqOEuA18buKItfLahhnJaEzWXtF5zaY1lLVeIQc+kHpjHkx67iAdSRR4BeKoXI+6Tn+ZMulhPO+p/pd2MxrHlqnJ/HGPU32hV9sr9QBMdBzRFUjjRp6JVEZey0hoTWVvY/dctnH8NxHjRyUl8XiOpfL6ABB0+86ln6nyL/IRpxPcC02vTsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HC6e+5VNEGzhGAs5RAYDQN4MWtVP9yMr5zMni1IWLrU=;
 b=kNIPqPvBjZwuUNrg9ezMXBhYd8q6V/acvTo/zIUflUEmN70cBAoDU3TnAZbINPDAPHp1zwrStkMoXAS62XCYSwKTAGY6WTimnHzVU1pHovg0XAzVCTneGHBlQG9wncP7TtreedMA/eMceCXGFJM7+QqIeN5N2bKfIFu4e9YzdhVAoEDsMQD3qDT4Kfygek75DdazyEESqfPnkazMChnP4d5Lokrp9aX6r2S6qqmrksc26zhdIpiYi7K9ZKdqUkTrDCjUa6SGlvSzD189kmnts8oaL19s8MEECn+ZKXJcM+maa91RQlyovLOmI+fUDUkbAEJ5w3GhPZYZO6F51sT3Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC6e+5VNEGzhGAs5RAYDQN4MWtVP9yMr5zMni1IWLrU=;
 b=Wy6ScqVHfofiV2fFSCrE/0aetzdO5edWkH2aM/EeWmD1tCo38fPFOyB3U7HCpY03nW6LcmmRovKwAC/MEaw1ar037MUsGy4QaWLmvtwS/bDySh4aGr7lGPqBKdatilxBhpa47oiOm4XFJe244+2w9Hmq5KTzKzm6TTqlTPMwZV8=
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PAXPR04MB8376.eurprd04.prod.outlook.com (2603:10a6:102:1bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 09:39:19 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%2]) with mapi id 15.20.7741.017; Fri, 5 Jul 2024
 09:39:19 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Marco Felsch <m.felsch@pengutronix.de>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain
	<gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - enable hash api only on ARM platforms per
 default
Thread-Topic: [PATCH] crypto: caam - enable hash api only on ARM platforms per
 default
Thread-Index: AQHazr811FnxcSgpcEmgQU5LBC+qLA==
Date: Fri, 5 Jul 2024 09:39:19 +0000
Message-ID: <258feb43-382d-4ea0-9164-357924350dec@nxp.com>
References: <20240626155724.4045056-1-m.felsch@pengutronix.de>
In-Reply-To: <20240626155724.4045056-1-m.felsch@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PAXPR04MB8376:EE_
x-ms-office365-filtering-correlation-id: 6e4ff9ab-9d78-4a45-5885-08dc9cd65818
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OTJIK01meUxIbEhHNmswS2s2SzNKazl5MXhJblVaTjRoWWR5byt1c1ZiYzFr?=
 =?utf-8?B?RktucXorcjQ5emhGSnRQRDBnQUFzZmxKZ1BRTXZVQjl0ZnpsTUlUUVM4QVVn?=
 =?utf-8?B?SWRaTnd5VVpTU29JY25PYmFRODV3bWJIczJZYnk1UEhjRGhncW9uZlk2blJV?=
 =?utf-8?B?bjRvYitiZ2hLa0hpQStoc3BwMHBLOVhlL2FDUDV0a1p3SkdKSG4rYjU5cXVR?=
 =?utf-8?B?NkEweVh1TjhtZEFncG41TXNoNktRNmFRLzFqZENaZXJwQ0dzYWNuTGFhWFg4?=
 =?utf-8?B?bkRaL0RabGhHMS9TUElGalRNemF1MnhQVmUrMzJUQStLOXZYWlcxYVdjY2NZ?=
 =?utf-8?B?NXArUTBzdVFKb1YreXVwK0sraG5UWW05NTBlVWl3Umhac2JvdDlHYXV0alF3?=
 =?utf-8?B?dFNxckRhU2t3clVEbmYwak1QYmx4ZzdLSi9WdGJSc0xLWHpVbmQ3OFc0MFBM?=
 =?utf-8?B?VC9FYlhMUllBTW1vOHV4K3FJU1dDRlBDVHN6TzlQMlBDMlE5WmN4ZEptL2Rz?=
 =?utf-8?B?Wm5QYU1sZS8za0NlbDhxeTQwVmRRZUd5aDhKcUR5S2VHREUxcTJPNEh5VC9r?=
 =?utf-8?B?YkM4NTNWY1NsK1lORnZYRDc3MXNDb1AxN2ttUVpDZTJEVzdjZ3FRMHhNV3Zn?=
 =?utf-8?B?VEdHN1pKQXEvendwdmVZdXBObGNzM0RFY2tOemIrK1NnUHorWGZPYnlXcFpZ?=
 =?utf-8?B?THdWdlhtRWU2eVF2d1NFeEpTeWE3TXNMb2RVN1RLbFRYaWJrVlhZS0ZlMEpH?=
 =?utf-8?B?YjI3Z3FOVi9RREh3b1E0UmJ0WlBJdTZ2aTJMZ3lKQW1HeWhFYUZYbHFlTnFE?=
 =?utf-8?B?MjBNMmRPSHVpRG9tRmtwNW9TdE1JTUdYR0JzRkF3RktkaHZ3SGE3VnBjaXU1?=
 =?utf-8?B?eXQwQXdTOTVSR2lyRkdqZktZeG9scG5NVkYzTFZlVWloUXRrejNWbmFPZHZ4?=
 =?utf-8?B?Q1RYYnFTUVExUnkwTXdRLzQ5VkIwb2VKSm9mNksxdzNpMnIzT05WMHhLeS9Y?=
 =?utf-8?B?RlM4NnNvREIveGZCV0VJUlNJZ3hxK05GVnRRVVc4NUZNZlJJanpHOXl4VFk1?=
 =?utf-8?B?ZUx6bUdvWTlIVXBzdi83QzNxWHhZNXNLQTFubXNxN3ZMQjNUc2JCclZHYnFy?=
 =?utf-8?B?K0pVdjcrRTBRV0Vsay9oMUF5NitFNGdyS2NIZVdpLzZWTDhDWENkbTJqdVlO?=
 =?utf-8?B?R2U2TEwrS214L3c3enBTL0Y3L3lOZG1INEJ1WUdpUFVkZTJJSzJZYm5HTnVs?=
 =?utf-8?B?M3FBSTdFaUxGTzJPSU54ZEEyK1pzUE9icldlZThmRndscmFxbndKd1hTc3hX?=
 =?utf-8?B?TlFZUzlwKzBPaVFRVDFtU1RxdjZmY2M5VDNDWmswVm1ST2ErZ0pzMEZJRjZP?=
 =?utf-8?B?MWMvanBORCtpODk3WWdZb3J1Zkg3czVkM29LSHhnUE9PMW1KOWo3aHhKaEo3?=
 =?utf-8?B?RVJKaHV4NHN2dE0xZHNrUmk3ajRnbGhad0dDM2VmeFdPeG0yMVlyZW1qeXNr?=
 =?utf-8?B?NmhpdVkrNnFMME9VZW0xelg1UFNwWm1oRE1hbDA1Z2pQdlQ2RFFJYWVFQm1y?=
 =?utf-8?B?MDZMTWtPeWRNcDNmbUFCQlJhOWF4YjRYNW1hQU5CaSs5eS9lTUw3ck1ydFU2?=
 =?utf-8?B?bENwUm12RnNxYlFlTzhRWEUzaGQzYklNUDllQmhoWjRLVVBmeUhFbWhOcm5v?=
 =?utf-8?B?dnZ5NUJ5VngxK2daOGVKbjZBdHhhdmNXOWRGaFBWcm1LWGhjVmpkS2hObjFl?=
 =?utf-8?B?eVVNZFpaSm5KcStVa3hHcE1lbnZsZHhkOUFqQ0N2WHYzRDBkYTJsN0YvVldm?=
 =?utf-8?B?REk2WStnSG5WdXJZYXVIYXpGNUh0eUh3WGNsQWNUek5JWkE1TGg5Qk52bUV5?=
 =?utf-8?B?b1hqSXZEZ05lRkRJblFqZWtXTDI3Yktxanh0Z0x1clZqdXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SW5xM0N1Y2xJcTBycmp5ZWlSZkUzRGc0dXNKZzRsbFVEcjdXWTlKUCs0UmFP?=
 =?utf-8?B?aEVtTmxsSC92YXJlejNXL09sYk9QUEJmdFczeklaSE5xcEFTeGUrRXIrc3N1?=
 =?utf-8?B?RDRkMjJkRnVEdWxFS0Jnd0JrY25TK2FaR09lbXZVcTJsYUc1VEFIaFNza3RQ?=
 =?utf-8?B?eGIvdHZEOVh4aWxEdDNMeWU3dDBhSGtpYjVhWktudm93VlVCUGp2Mk9uSytB?=
 =?utf-8?B?VDJrM3JpTXJHVWx3dWk1QnRyeVdCcWVveGQxeXBkUXFuQ1JmcnJkUzF0WjR5?=
 =?utf-8?B?RjlIaUpYOWw2VDJWTTlxdy9pcnlNdTdyKzUwZ0FGWHA3TzRQNlNIRlRRODZL?=
 =?utf-8?B?QlVsUFlHVWZDWTNKN0ovSGk5a2NuV1NBNXM1SXU2cWp3UjFDdWV4dWRzZ3NV?=
 =?utf-8?B?UlMvSDgzQXU3SGxkTldJeE1PZEY3d1Nybzl1QnVSVE9HNjNXSlZaaVUvTkFS?=
 =?utf-8?B?QllJTDAxSGFaU2U0NDd3c1U5aWZhMlVpYk9LQ3pvNS84MUZOT3NQRnVxRW1Y?=
 =?utf-8?B?SnhxRDdOV0JISjZIMjJLTTNuckQvNDcrY2RQbFEzU3FneFQvcFpOWDVjcXFn?=
 =?utf-8?B?RlZKQXI4TzQxeHB6bzN3Wk5jdlFNeGEvdGNRa0NGd0ZuQzZJZVhUc2ZLa2s3?=
 =?utf-8?B?UXpKd1B4L1RuSXRqZ3J4Q1dQUktXWEZZa0tkR1IvRU9NbTBVcUpadDZTR3Z4?=
 =?utf-8?B?OUZERnVPS2JzL2U4N09yVFVJV0xPZ2VJY1RvK2xoUkNMcHpsVEZTR1RaSXZz?=
 =?utf-8?B?NXpXM2Nib0IrMFpaRm9IYW9ESWhhOEt0dzFvQmtqV2Z4dHVBU0NSWmhDRGdH?=
 =?utf-8?B?SjcyaC95TGJDL3VnNGwzYm91OGNvNE1neVZYdXlxQTBBYlhpMFZKTHVDMGh3?=
 =?utf-8?B?Z2JHK1VmZktqZWwraGdmTUg4MS9nVjEwYlVTYWlYc09Qa2tsSldsTTlKV2hW?=
 =?utf-8?B?RURCZnl5dWk5eUZWcUtaRlczMEpYQlJqblNCei9adXp2SVZDYzBzemYxN00r?=
 =?utf-8?B?MWRDQTBHTGV1SCtpZXRmQ3ZUZWo3Z0RuUVZ0TndyQSthUC9EUTlpWTZCYnJG?=
 =?utf-8?B?R2tWaTlSTDljV3UwdE83KzJhSXcxN1NvWWZ0OUZGUzJvR0QvdHlVRm9zckcw?=
 =?utf-8?B?eWlVZCthdFFHT0Y1cUc1QXpHcDNLbDBneTRabkdJV084UWNPbUtjdytqdjB1?=
 =?utf-8?B?eE5CRWw2WXdTYjd4YU55NnNmMzNLaHp4a3NDU2lzNlFra21SV1NXVGVTcmhl?=
 =?utf-8?B?V3R0K3NRblBzN1ltc2M3WWtnSkhVZWdSbzRhSFVWcS95YmtkSXE5UTBIckdQ?=
 =?utf-8?B?L1VYVWtPSXhPRmdzY3I2VlVLNElURUJHS1kyN0hxUGxpOVJiTkthUUI4SEVR?=
 =?utf-8?B?Y2JFV3RqL3pqM3NIZHZacTFSVXB1aTJYMmtwaWh5ZnpEaE0xbVR4Y3R3MlJX?=
 =?utf-8?B?VGg5dHZwNFBwM1RvOERKRmZQa3Naam9rVzVHb3VQekl1VXlvU0VybS80MTll?=
 =?utf-8?B?VXJra2VwUnNvWDNsdzRQWTIrZHFoSlBIcDF1ZEJZVFJFOXJETjllT0tUQXlM?=
 =?utf-8?B?cjBQTkJ6emdBc3JSdzl3WkVQMWZpU3JMT2dtTzNjMjg1TWZmbmdkZHU1MXAw?=
 =?utf-8?B?OERiSWZsdlZSNjREVHlvUUtoVng5UGI1T0hrRDBXSDRFcGVIRU5DbDhtajlJ?=
 =?utf-8?B?cnQ4ZEZibmJ5Y2NKR3AxWnYvMndFNldPZDRHVU9ZVkNQUTdreXJINUdHbzVS?=
 =?utf-8?B?dTlMalNEZlM5NlcvVGgwSjJFZDA3RERIcGpUMzcyUmJFdUZ1ZjUxdWFqV0h4?=
 =?utf-8?B?dlJ3RDdXYVRyQkU3YnFnS0ZmQXE5eEU2MUljUFo1VVhoaG55Z3RsRzhWYUha?=
 =?utf-8?B?Y3VBOFBuMDlFZXZmNlUvcUZjazFKc1VTZVp6V0xBTGNPZXkxa1dMRUxKWVQw?=
 =?utf-8?B?VHBrYklSa3lva0hZNHJDL1RJZlpZR0l0UTdoVnc3amNabnB4Qk5xT1NXU1h3?=
 =?utf-8?B?cUdPQ3ovWFlNa0FDbEVuemE4QVdwL2VVUlNKTEMvRmpYRUpsSGhVZGVhOGhz?=
 =?utf-8?B?U2o2TjJPelo1MUdIaVlNRkVVc2NyTTRpWm1vMzAxYTRrd0R1Y1Y4VXhSWnZX?=
 =?utf-8?B?MzdCMTFLb2VpNVNZTEhZL041b2ttWnRsVXZtanVmZW12dHdNb1Q1RkwwSDIv?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EECB50B6ECBAE24586A0552D6AF9536F@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4ff9ab-9d78-4a45-5885-08dc9cd65818
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 09:39:19.4581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NEcaMpdpkUUfpoSus4GOPdppqH/EutaNmVJRPTKmi9GoZ4PeCfoDS53wTXYjXB/HoW8tPsP8iVlQAIQmcIsrvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8376

T24gNi8yNi8yMDI0IDY6NTcgUE0sIE1hcmNvIEZlbHNjaCB3cm90ZToNCj4gVGVzdHMgc2hvd2Vk
IHRoYXQgQVJNdjgtQSBjcnlwdG8gZXh0ZW5zaW9ucyBhcyBpbXBsZW1lbnRlZCBvbiB0aGUgQVJN
DQo+IENvcnRleC1BNTMgb24gdGhlIGkuTVg4TSBmYW1pbHkgb2YgcHJvY2Vzc29ycyBhcmUgc3Vi
c3RhbnRpYWxseSBmYXN0ZXINCj4gdGhhbiB0aGUgc2FtZSBwcmltaXRpdmVzIG9mZmVyZWQgYnkg
dGhlIENBQU0uDQo+IA0KSSBkaXNhZ3JlZSB3aXRoIGNvbXBpbGluZyBvdXQgdGhlIGhhc2ggc3Vw
cG9ydC4NCg0KSWYgbmVlZGVkLCBhbGdvcml0aG0gcHJpb3JpdHkgY291bGQgYmUgY2hhbmdlZCAt
IGV2ZW4gYXQgcnVudGltZSwNCnVzaW5nIE5FVExJTktfQ1JZUFRPIG1lc3NhZ2VzIChuZWVkcyBD
T05GSUdfQ1JZUFRPX1VTRVI9eS9tKS4NCg0KVGhhbmtzLA0KSG9yaWENCg0K
