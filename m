Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C6A1E51D;
	Wed, 27 Nov 2024 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732721011; cv=fail; b=mCQx4P1V+a257gmTQ7nZtFFABw8gD4puf2718ZPgZ2GDErf1R2pc1jsJ9+CxcSgH7HcxvPfF97jDHTB/dtHPLo8wNyWWWviyRMIARpzAF3n71XliAr+p3c8g9KjVzhj5/fyzcCDBzNeeiQa5LzbYwKQBoBGI/aW6QfRNtSwsUP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732721011; c=relaxed/simple;
	bh=NCyMYlq73PElw70CKFF9qojNv5BTzO/gwoQsR+lXrBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mTQZcwAij+pR1Z/ClBng9qH+p7SwVZK6oJLFCtj4XZCNje5MT+HhzBoi1oRowfDh0BkMiCNKmzjr4ouAA1Xc6USWCccZUAqB5QzPbdfWGRdpqJ4UybgfbiAAugMgdjMNxT3228uZoz0pWF+neNDcIraF2BYQZ16wrMUlePzIDWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=At7PgdAq; arc=fail smtp.client-ip=40.107.21.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="At7PgdAq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzjO75+YmwiRerXp2+Thuoo33TZoIrf58q+1cFMqSt3LD3QIEucSM0so1J/w5/vi9iAoXOyH1BUs4jYDfVLJheCwZIQYS+GBC2OmJ8MUNZUmuBbmeiIHop41/gUXVAXBgMOzChUBtAs8B9Ue71rgm6T6VL3Of5BT+SehI3bM2dRruw7xO8xC2rYdwIAdlPDsam4u2DC/bbRFOVDsM8x0kzH7X6w+bG8172+Ka0I0KrZxXsS41B8S9VeUVAMvl/wRrekUQIn2Hyx26sQjI4/4QbOJ4aREz6sm8nyLQ52plbIeyJZxpWgLvs1/V534MPx8E7p1TOa/rlouiLdBZHACMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCyMYlq73PElw70CKFF9qojNv5BTzO/gwoQsR+lXrBY=;
 b=rqgbBCa0WScNKUxE4tLNqXNmgrMxiZLjOuZV4w8Yf4ChTZuMQ7ds9aUrW4je0f8O9hOrgpt2ylUVxKK5Xc1e/DvZaYvjkXPeTbijiXj5zyhhYQ0pXAav4fl012rOJ3FNrj+SAnt8aKkN3Ju2Ve1J8WoRMASl7JyzCd60aNY0QI4WLJJ9nEcJc4APyBl5Y4ihQwV7hA4RZIMbIHMgKG2diA4VrHSakk1gdL3ffN2HECPjMex7swA7ubwyZ5GQmEPphASJ7CUxkn9h23Fyx1l4gNTyfWwdWuXamUjaIOhPs62eoszIKTfCL8eF+ISOg+ONJDgr3F+x746OOAA1CkY2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCyMYlq73PElw70CKFF9qojNv5BTzO/gwoQsR+lXrBY=;
 b=At7PgdAqlZsZscHUIGFsEpZ9q4MSm3on7gDWhGrKAneqSv7zpDa/7RxLoIanRwi76I+G6Sr3xvAF+A0dY7oQdyFpaSpzyWuuSz+pSLMWWK6W6iatpsXmOqZM8mKGwafTgG5TFNUbbmEN2Fhct/YQeklkaa8AWZvAz96lfMDt41YyXBXZyUN7xQa50c/7+Yocwln8X3Z3CJ0mthvDoJ31zzpBJZS9Mm2JnwNzpgI0WSnS31RpJrGtQKxCJywLjYTNMjs8xtgozPnGTvtX48bEltlzkK2Yld/FF9ID9ILqLTZ2xxZI17KTiHGjHmpA9uYahDzjBcLyDgPDPGrN+w7w2g==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PAXPR04MB8334.eurprd04.prod.outlook.com (2603:10a6:102:1cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 15:23:25 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8182.019; Wed, 27 Nov 2024
 15:23:25 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Gaurav Jain <gaurav.jain@nxp.com>, Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Sahil Malhotra
	<sahil.malhotra@nxp.com>, Nikolaus Voss <nikolaus.voss@haag-streit.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pengutronix
 Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2] crypto: caam - use JobR's space to access page 0 regs
Thread-Topic: [PATCH v2] crypto: caam - use JobR's space to access page 0 regs
Thread-Index: AQHbP877P6BuNn6jKU6FtN0FLX7F17LLQPsA
Date: Wed, 27 Nov 2024 15:23:25 +0000
Message-ID: <8dbeff8a-6497-4aba-b02b-f2f5e6129f61@nxp.com>
References: <20241126064607.456633-1-gaurav.jain@nxp.com>
In-Reply-To: <20241126064607.456633-1-gaurav.jain@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PAXPR04MB8334:EE_
x-ms-office365-filtering-correlation-id: 88c030df-0ed8-48c7-73d9-08dd0ef76fe3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|921020|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WTJZSjVaV2lreVhhcmlpdy9yeGNDbTk4NUhzVGdYVjVqQXlMcHVscmlVM3Z3?=
 =?utf-8?B?YmpabjVnYVBMOVlXK24yeFZuRW9rMHRFeGg4UHMxQmlwZG9BdEo0S1RCeHN1?=
 =?utf-8?B?OXd1VXRyblBUTTNGOGdiYk0zWEN2SGJpdVRBemM3bnlaUll0MHgreU9SczRs?=
 =?utf-8?B?cE9Ybmx5STNlQmo3cnlzSFhoeTVkdkZuanhQeGFjTWR4Q0lhM2F1YXUzN0F6?=
 =?utf-8?B?L2ZIVktpZTcxb3hmNDBDb1NmSEJqZ0hlelo2MnZPTE5kSnZDMUlpaUswRHdv?=
 =?utf-8?B?QXIvM290UGdTQjdjMWEvaFhIWTVraXJMT3gydVlML0I0elBpdk9LbDlzaUtq?=
 =?utf-8?B?RnNPVDF0TTN5NzVsVkRVZzdyY0xCYWpTaGhQSVpvUEpmRnQ5ckNncHQ5RjR4?=
 =?utf-8?B?b3VqZHhieEhucERGeFYwanQxMitmVUh3c21lencvNjB5bFdXQU1sbEJCc05i?=
 =?utf-8?B?M1B2Z3lPaEloZ1ZMRWZ2N1NmZk1qcXV6TC8rYko4RDlLZ1ZxaGJINlBxL1k5?=
 =?utf-8?B?SnVJcHFSSkRUNTE5SXk2dHVjMUZPS0JaUjNxTVZuQjBqNEs5eUNDdmJkaFU0?=
 =?utf-8?B?SmxOSTNrVWxmY1pFT1owdkgzeTZhY3R1YWgzWVY3enh1MmtYWStEL3Q2NUNO?=
 =?utf-8?B?UzdieGZFTnpkUm03ai9TU1BUK1B6NHZaT1Z4b3Nid1NUZHlXNVBlT3JEK1F1?=
 =?utf-8?B?cTFadjl1SnpPRXIrNWVyczBIeFpEMmtxUHEwWmVabnhiT3VQYzN2bldtNE9K?=
 =?utf-8?B?ME8yOE5QME9MV1JIUHRRVHNoRW8wMHlqREdxQzNpeWlLdWxSN2N4SUhYUXkz?=
 =?utf-8?B?d0FWRTNnNU94UENBSUNqU1F5azFiSmtFZXFvYmdVeTJnbkFsRVZ6VmhYSjY0?=
 =?utf-8?B?M3o2NDFaenhPMDJyYTBGeEsyVUlVdzBkSTJJZytwTlRkdUs4UlN1MStHb1Zt?=
 =?utf-8?B?M2NzVTUvK2x3eFNBVWZ3d3FtLzlZd0F6cGxxc2s3WW5qckpLaTFqaWpwN3Fh?=
 =?utf-8?B?a1JuYmNtV2FvWVJxbEEvQWVCd2JOd2ZHZ2c2MWQ3UEErZm5BKy9KR3dZaUUv?=
 =?utf-8?B?YXhLbFoyaVZHQXV5d3VVVk5vanY4MXNCRm9SY1lBWFJ5d0dJUlROM0xQTG9n?=
 =?utf-8?B?T3AwWjFvZjg5VTRMVXFQNGxTNlFYWDJ2V1Vvd0hyaFd0Y2ZUT05HUXlYeStw?=
 =?utf-8?B?L0pNWlp1NXdKYjJSK1VLUUViUHBBUmRZOVA1YXdoRkFCcW4xUDgyS0t3NWx5?=
 =?utf-8?B?dUtjbGdZUUhxUHh2VnZwSmIyUGQ1S0t2dFZmME1WZ29weFlCV0N4MUljNHV3?=
 =?utf-8?B?UFJOTnh3Skhoc29tSGM5eUYwNkVvVFo4aXI5eTVjRTI5bjBDOTdXNFgvT0Zm?=
 =?utf-8?B?N1lrUGF5NG9wbFNMaExjdnRPNE1UTDlTRjhydUhRWS9ydno2Z0gzbmRhR25X?=
 =?utf-8?B?Tkk3V09NSjhZY1M2dzJ0VDJ1UWVoL2Y4R1ZhS0VqY1dJK3BkaFNQTTd2czZu?=
 =?utf-8?B?Nnk5b1ZnbTBhQmlldXBrd2FobzR6d2c3YmVkMzBIaUZxOUdwLzNQdyt6OGwy?=
 =?utf-8?B?RWxBRFpmSVpzNWdUUjVJb2s3RzdDZktVK2xmeDA0MVJ6VkFlN3lHMGZhMzNR?=
 =?utf-8?B?dTI3L1pRRmFVYXc4U3VvcUhXbHd6Mnh3V3J1RGVjdVdWWXJoQi9JQnFES2tM?=
 =?utf-8?B?MWpGeUdkeUJ6L2NWTWdtVUxVbTI2ajA1ejBhRGUwWDMxZkRSTTZ5SWc5aDQ3?=
 =?utf-8?B?amRKVVU4aDFFVVV1NmJ4KzdIZStVcCt4Mk9QZktXU2JkOU51czI5MlJtNU1X?=
 =?utf-8?B?TmUzbTlPY0JLb2xOMHU3UXJEVUphWFU0YkFNNm1JaUN6WVVjOWdvSXlpWk5o?=
 =?utf-8?B?Ym10M1ZoV01iLzBQUXh0eGVFN1ArNXArdjc2aUFVQ2loazdvdS9FVXJnQXNM?=
 =?utf-8?Q?wX7H6tiaSc8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2w3dXBwVXE4Q1dvNlcxUU93L2pWZ3Z2Y1RIL3BDb2NQR1lEcjFsdnFRR29P?=
 =?utf-8?B?czFyakdtY2lKdjJKbHNzek9RYjg3b05ZR2R0c3Q3RmM1VUF4N051ZjgvclZ5?=
 =?utf-8?B?aXhXMVV5cDlJQ0swd2w2cVlyVVdUaHR5dzVkeGRlRGRsTmFqQzRiMm12OElt?=
 =?utf-8?B?aTRsZ2FhSkVjZklpOUd3OXJya3RhOGFOVUVzVVgvdFQwbzdONFRpRktTcWFO?=
 =?utf-8?B?NXlBUy9nUnRoQXhjVUNPUENGTVZoQXRWdVdiYVFod2pLVGQzYkhoUGYyWkNv?=
 =?utf-8?B?WWJVRHNLeUM0cE5uQm44OFpKc2hvTXN4QjIzMDNHRlBLcjdSRTlrajdUdjlJ?=
 =?utf-8?B?RDE1ZHhMSjlLbXRrNXJ5R3B3YVg2OEl4TzkwQktKVW5rOTN5RFc3RjVrbE5D?=
 =?utf-8?B?eWY0QURlOVRwckVIdHB6Q2NkenVXUDJFdExxTklhNXUzeFNCU1ZsMnNxdjE5?=
 =?utf-8?B?MDJoSDhzaWQydnEyaVd2d1E3eHZTdEdxZkpnSGdrcDlnMEx3TjBTTVFJcUpP?=
 =?utf-8?B?SlI3aEl2OHZHbFY3cEhEb1orZTVxWUpMdlQzN1R1bnJHN3BOTmpUS1dPUWll?=
 =?utf-8?B?bTRWeUhKc2FUb3E0bk1BTUIyQS8zUDBoakprVVdEdzJiWm01OURBLzAvaDQx?=
 =?utf-8?B?ZnRpMUJmdGN5M3N4Tm9KbEVKa1pLT0JYcktjOHVaMjFDRXVKM2hjSXJPU3JD?=
 =?utf-8?B?TVdDT1VPTUpSVUFGUVVNeS9KdkdRanVIR1RSQWhvMjgwTUV4THFIVjBGZ3A4?=
 =?utf-8?B?emQ1V1JIQXFkSUE4M2ZNU3ZsOU96YnJ1cnh1cFB1Tm1ZZEVMZHNUVGRiSVZl?=
 =?utf-8?B?Ni9lQTAwQmZQYUR6WnRJNVZXbkQ4VUEwU0IwcFd0QnlEcGtSZXVqNTk3ZnRz?=
 =?utf-8?B?M3VVNW95ZGVHczdYd2RFQTZxVVhNMkFjTkNWSmpoOWFyYVBmVWZZVkFmRldG?=
 =?utf-8?B?V3lpWXpUOEdvWnBtaU14N3daek5DdURLNncwK3hLMjRVWU1xSC9lVG9YMFFk?=
 =?utf-8?B?MTRqemdRNFhFMXdBbjdaZEFTcHlpcmZwZUNrT2cwczlIUXVINVJvdG11UEd0?=
 =?utf-8?B?czVHcVRkNkRhS0NPc0tUUUt6YjNHeWlEYm9iSWI2VGEyL1Y4UWNyck0xdnlT?=
 =?utf-8?B?SFZWc0lGdCtWQVJlVzBMY0czbVRhandRMjNwNlZlMlQrTTRuOWpUS0ErZ21w?=
 =?utf-8?B?S3piaC9CQTRVNE1pcGZxVUpGQm9jdDdiWDlobEYxVE00aTVQam5nUmRxbW0y?=
 =?utf-8?B?ZS9kSnFTVFFnSTNVZE8xeVp0UE44RlhTMHBTV0FyeXRCdUFPSVZ2RzBFaU05?=
 =?utf-8?B?OGU1bUJxcktGYkVWeFdWc2NRRW9mRm51U3AyL1BIM1d1UEZWcHhQSjFHZ1Nv?=
 =?utf-8?B?d2tTQWJKRTdmd3FBcHJFdWlhQUtWd3VYdlNTak9CSDVtV3hyZmNIZ0FPRW1x?=
 =?utf-8?B?NlBtMFl3R1RkelZHam5PRTR6cDVTaE9IVXMxZkRhaVl5bVYzVHNPaktxRTJG?=
 =?utf-8?B?c1NWZUpudjVqZy9NdDRFOHpkcGE0MFMwMmhGcVl5TVNTcU9wL2lhWWRVZkFJ?=
 =?utf-8?B?bGllWUNrcitQTXF6R0tpd2p6ZmpBWGNZa1lORlRlUzNYZVlnTDk4TEJOeGR6?=
 =?utf-8?B?RXlMNzNRWHdSZ1g0d2o4dk92STErcVI4ZU4xVHFRWjdyVVJkNzRXOEZVUnEr?=
 =?utf-8?B?ektKcS9YYmRhQW5ENklIU2F6NVBlS1RsMVoxZnZRdzE4YWI5U2syR0NzeUVX?=
 =?utf-8?B?QWplbEZyYnQwbkozWERVem92ekFRNkc0eVZNNHBLTVlwWjg3OEVPdWZ2K3Fl?=
 =?utf-8?B?RjR1REhIbWRDOUg5TEVRZTJWZWx1Zi9WZVR2Z2xjQWtwMEkydm1Qb0U4cjBP?=
 =?utf-8?B?b0dpd0taY3F4eWlYcGRJa1FKb2pzNmpNMlE0QjBEQzZodGE2NnpVL2lhV0xS?=
 =?utf-8?B?UnY3Z0hURkdDNHROZEs4WW5tSk9aMGdTN3FVRlVtMUErcEZFT3VjSWsvMGxq?=
 =?utf-8?B?cnlZN0JKQkpSMVc3bERIVmlGeFdmT045WWo5dGFrMWFYTlp0MEN4QUFMZmZ1?=
 =?utf-8?B?VjRSL3Z6U1BWRFlsV0VDeGhiRnhRUXhYM0V6cUhpVHZBM0czRjZRWnZ0RzR3?=
 =?utf-8?B?SzZTWjNxcGI0NDQ5VDFVSURNb3hOSHJmS1Y2c3hzUnFNclpUcGN5T0VXN3gz?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <630CDBF9F80FD64A8EC504E8557512AC@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c030df-0ed8-48c7-73d9-08dd0ef76fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2024 15:23:25.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOUnomBeO6UfWKcmGgQgG+aLT5x1kLUIlqK+Pl1B6LkKyXtrsuYARiKmYIVGHQESILfXJkHhC9qUkr3rjFHHIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8334

T24gMTEvMjYvMjAyNCA4OjQ2IEFNLCBHYXVyYXYgSmFpbiB3cm90ZToNCj4gT24gaU1YOERYTC9R
TS9RWFAoU0VDTykgJiBpTVg4VUxQKEVMRSkgU29DcywgYWNjZXNzIHRvIGNvbnRyb2xsZXINCj4g
cmVnaW9uKENBQU0gcGFnZSAwKSBpcyBub3QgcGVybWl0dGVkIGZyb20gbm9uIHNlY3VyZSB3b3Js
ZC4NCj4gdXNlIEpvYlIncyByZWdpc3RlciBzcGFjZSB0byBhY2Nlc3MgcGFnZSAwIHJlZ2lzdGVy
cy4NCj4gDQo+IEZpeGVzOiA2YTgzODMwZjY0OWEgKCJjcnlwdG86IGNhYW0gLSB3YXJuIGlmIGJs
b2JfZ2VuIGtleSBpcyBpbnNlY3VyZSIpDQo+IFNpZ25lZC1vZmYtYnk6IEdhdXJhdiBKYWluIDxn
YXVyYXYuamFpbkBueHAuY29tPg0KUmV2aWV3ZWQtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdl
YW50YUBueHAuY29tPg0KDQpUaGFua3MsDQpIb3JpYQ0KDQo=
