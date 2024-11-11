Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6F7F48C
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 05:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731302907; cv=fail; b=PDtSH8HhcZJKu7Asq63YiPZk0mPYh7C0vhcbT11KbSQantrEeGpEHE/4S07a/Xg2UQTEta/9ldbBlHugesJFM1D/1BdgU1OnYYvC+9hBzLEasFqZ5xfHYMQXofoxolSUJVUh8W91st2b6gMCLovpp1Z54qZlyUJBqXxt/HJV6xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731302907; c=relaxed/simple;
	bh=Igbqzbm2szzzoJJt51rnYNqn1SOydOBZzWR1Opj912I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QkAzQGNJp8Y2LbfTWsrriBeg0vdWFt4gb/bOJkDOfgtlVpffYyUXHa3GWJvN6w/BKg7RWYVvAzAQAJTD4TpN0UimqLNhQPXN7eBuvSA5/Zf+RitDJMqOiwvSFuRXQ+OHHp3jv5QYpC1AN8vnOcSpUAJrakoF20phThma8ZY24wI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=IC55rJjU; arc=fail smtp.client-ip=40.107.21.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="IC55rJjU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OBewGya9YhuBB2if3EYbbBDqXP2p5RlgAKPviHdWstyBdJIacPJ//7pC+XBfGaNtPF+XgwnNHfgMOQyBDkRpVnT0pE+KZI3fxA0vR98AqvVvnUwMtqgLpp6E5Ry3TSW5rBQ+r2kHo1IZC+jFBnAUhT96pU24OGM5Ucvy5A93qyKu1NyFgzNVGO07vBn8X04LjK0YL8+KjK/CJjlkTVyaXs3rrUTAnj33q5EMAyc/AlTO/LCUdRHrvLu104TZ28SBjk6aO6KAZ9tocUEk7SQoYTGSib5ZlqFwjhLq5PeUb1H7JADPjqnTxYCrSzFdvnev2j1ggLcwBa6SdOcaq6ztpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Igbqzbm2szzzoJJt51rnYNqn1SOydOBZzWR1Opj912I=;
 b=RntAtDRhcdW03pLw8Duyk7BIiTO31wFc59K4zgNM1Q2/Ma2t/wXmNjeK6ghPQwp4GWuN0wsUV0wBGyLLnwp3zs2suGXuPW6wB2tZOpK7wG2o0VbgtTIUmQxn2tyrYuXq9RFVVfw3le0Ztkc5R46afkqluuyyH31pu/Jxf/qNwsaM80iZ+KMuzfGua+pMls3fsOPhhQ0vO255grsmEp7eKm/w4pJVJ6UW4Rw0KU1tt/l630HSAh+R8HviaJxzxg3DEd/Uc1NeHt6JxSki3erSAszaGhS9gHJx4idN9E/i7XCFhAqGcMNYz7IIIZIM90gq9KNUYBaaPd4iJeEY/n85Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Igbqzbm2szzzoJJt51rnYNqn1SOydOBZzWR1Opj912I=;
 b=IC55rJjUAY08QphEruEHyi6Omk5OIYHYcYjfI5JFD9Vf/g3jXWvcAETp7nim7517ThtgrfvpGVq43Dj0ZBb7yYvfcp1BmbalYFj+C/9kV7nvqgtapZJkjZOnNE+5/Rc0jxtKCTQsyPhmy3/STg2HCyTB3X2LiSbKseH0AKgIh4MUxtr+wHbk3cdIMiuOC7+3cMBa9ugw3vM0saE/jpKDdUUp1jnKm4B6YWUUMCs3VF1NiQF4WG171m+r1kDKjQBGCl6kndTJUGEwAD6xAsBFpMQ0R/tDmSOBbM6x2VBwgjVlGH0MIqCFqtkD0N8ekj9LdWg789V9EIKFSRVq8rxmlA==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS8PR04MB8625.eurprd04.prod.outlook.com (2603:10a6:20b:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 05:28:20 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 05:28:19 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: chenridong <chenridong@huawei.com>, Chen Ridong
	<chenridong@huaweicloud.com>, Horia Geanta <horia.geanta@nxp.com>, Pankaj
 Gupta <pankaj.gupta@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"tudor-dan.ambarus@nxp.com" <tudor-dan.ambarus@nxp.com>, Radu Andrei Alexe
	<radu.alexe@nxp.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"wangweiyang2@huawei.com" <wangweiyang2@huawei.com>
Subject: RE: [EXT] Re: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
Thread-Topic: [EXT] Re: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
Thread-Index: AQHbM+Bo52mf9vD+ok+6XkYN9w5s/LKxjREw
Date: Mon, 11 Nov 2024 05:28:19 +0000
Message-ID:
 <DB9PR04MB84099C545C1DF175030214F7E7582@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20241104121511.1634822-1-chenridong@huaweicloud.com>
 <15bedaeb-245f-4748-9560-cdc081050f44@huawei.com>
In-Reply-To: <15bedaeb-245f-4748-9560-cdc081050f44@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS8PR04MB8625:EE_
x-ms-office365-filtering-correlation-id: 68c980b2-bf89-4120-df93-08dd0211a727
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZG5XMDljMnNNaDI2Vnh4UHNwS1lHZ1d5MEVCVzZ6cjd1RGhsMXo1b0JLSTl6?=
 =?utf-8?B?VUZ6VzZvdTVGaFhZYlJmVldqTVNGZlc3UEcwK3V2d2NobTRvVDMxM0dOMUdD?=
 =?utf-8?B?TFhVUTdtM05lakF1bmo2cUZvbWUvb3c2YzQwS2lkaWgvRDFNU1dxSENleFBh?=
 =?utf-8?B?YUxLTGlUUDdUY3pwWnBib2YvRzQ3VTN4bG1Ka0J0RjR3Z0Z1d2JZTzRTWUM1?=
 =?utf-8?B?LzVRcGpjZVFZR3ZIZzM3Wm9idlpPVTR6R0c2YWYzcUtNMElDb1YwamxLT3NZ?=
 =?utf-8?B?c3MyaGN3TkYzZlhnVFBYejBOVkErTUhpZHBGQ0FsajE0SGZnN01sTnlnT0pS?=
 =?utf-8?B?N0NPWXdhMFRUVUhLeVpZb1NneDBuNTZjTDcvM0NWWnNmd09KTnZhTUZpNndz?=
 =?utf-8?B?SjY0aVhQK2VzWmFxSjBzS3BoRUIyTnpVWFV5bWNEWlFuSkJ4M0taNGJoNVFB?=
 =?utf-8?B?aW9mWVBGUUJ0a2RiTU9SdW1nV2pEM3RKMEZFdnM5bTZBa3BKcElIbk1Kd0ZL?=
 =?utf-8?B?aUlVUkxJNi81eEhKQjA5Q3pMbzhhWisrUGY1b1VXWnIrdWt3TkZWYXRXMEd2?=
 =?utf-8?B?REJQQVhYc1NMRXQyeXcxbktHRnE2a2sxYmVCZmdCV3dyUmJWQURLN3hKOWNu?=
 =?utf-8?B?cmxaaThaN2dpdnB2akJlOFVDR2psTlRlR0pRdzZYOCsrbnAwZ0tNbWxGN25k?=
 =?utf-8?B?NldkbVRKRnlYbTZYc2JSbjBhZmV5VHRhaHBlTEZrZnNsejk0aXNzYmNtODJG?=
 =?utf-8?B?MWU3TzFWbDhCOERwR28vQmNXZ1NvcVZwR1J1aFdSdUNQZVlrQXhDdDJWTUVt?=
 =?utf-8?B?cWdHK0tCK040WjMxRW5rd0tyZUhQaWdycHJjTExvRFgyYjB3TzlvOTRjSjlZ?=
 =?utf-8?B?b3FCRHBFaDg2ZzdUNU9lWWlJeEdOdlV3WWpySURIdzVjU3VycGNVams5NUUv?=
 =?utf-8?B?ckpwRlM2V29zSkhKS2lkQWVlcjlQdFJNV205TDF4clVCV09Qa1lsc1FuSklV?=
 =?utf-8?B?bjlwSENkNVpTR3VoNkQrS0k2Rk1nRFJKelU0KzVHeG9zbi9ZYndFOUt1S1R3?=
 =?utf-8?B?dVRXT011aGpNWENFSkZBKzdxMXFVYUh1WTdRRWVaMGViWVpLT04yZVp5Qjhs?=
 =?utf-8?B?TDlIc1NVdkVSeDVVUDA4UVBQcGdwakNLeE5kejFlS1VNY25TSHFWelNxN1Ji?=
 =?utf-8?B?NzQ2cjRFcUJjVFhOUjdsUGQ2cFhtZzg0QzNJcE9ZOTZmVU9tNVlZNGFlNVlu?=
 =?utf-8?B?ZnNlOVBjbEFqTFZOMWNmSXFkVDcwQzRlVzhPQUtlQm5YeHFOeVRxTFF5Vk1W?=
 =?utf-8?B?dUwxbWZMd3F1Qk9YUnkraDg4bEdNYlRxRnpmbVl1NVpLeTZGQitVcS9YVXhT?=
 =?utf-8?B?VDNGSXpxbUhuZ1gyOCsxOGNHOWtEalNGRUxjV0U4Q0ZnMkpkSkgxWVU2NDZR?=
 =?utf-8?B?aGlYS0QybjFGcUJSMnlXejl0ajdsSENpRWFCY3J0RjZ0V0JXSHUvcmhmNm1i?=
 =?utf-8?B?MmVOcWgvMENzY2dYOVVLalgydU1jNTlxZWxLWDNTbzgwcWxDMDIwT2dZNlRT?=
 =?utf-8?B?MVFKMTZpZkRyQWQ3eWV3YjNEdU5EbjlkMzZjdC9hWFBkUEhmeFN5WjB0WTM3?=
 =?utf-8?B?NEhmZGY4U3g0OUk3bVl1MGhGQ0FwZVp1R2tVZVZoVGV4bW9oWHNzL3lTOGJL?=
 =?utf-8?B?N1h4TmlNMGxxYmVqUCtuVWIybDVGZHBBVkRDMGhiRVRINWxFZWdUNGRQS0NR?=
 =?utf-8?B?YzRTazZ5eFlQb0lTUUJVQ0xZMjVXcG5KZW9CbHhVcU1Ub3p2bXNvUnNoVzBy?=
 =?utf-8?Q?omV8znlgiJGQZhiX+voMsz0KLOUME9FIQcjU8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VHRnVmNMTHgrbC96MjJLM3plYTBteGxQdEdmdHlTVXdOeGF0cnJVQVZoVmhH?=
 =?utf-8?B?eDhPbHJ3OGVlVGkrOFNLWVVadzFyd2JuYmdOQXN2ZlBEeXlhNjFrV05DU2JD?=
 =?utf-8?B?Rit0eXp0OGhETUhFVVEzYTZLaTAwN0g4akJmOGIxcmNWVHFkOVhyOHk3elRH?=
 =?utf-8?B?S0V3VzZkY3grcSt5K2c2cjBEMi8zMC9mcGdCUEdBWTBOVGtyMWdJV1pidFZs?=
 =?utf-8?B?Q2V6TXpKYU0ways0Sk4wS0ZWcXIxbWRmalJpZThZYUdxclkvTE5VMlp0Z2ll?=
 =?utf-8?B?Q0QzNkFQKzFTOTg2L3B5TEUzOStVaENoUUkxQ0tJS1VMa3QxRmIrSEx5S1pa?=
 =?utf-8?B?QlZodEhKd1lMT29UeFhweStTNWFKVzU0M2pMZ0ZvbnJvZHRtZEZucEFxZ2hC?=
 =?utf-8?B?UUd1RWc2cnRsNVJ1Y0w0c1g0YjJUTUE0YXpWK3lLUjN1N0ExWjRqWDZ5MjVG?=
 =?utf-8?B?ZVR0YzJmVk5RVndaUkNaeEtTZitlZUdnTTZKa2tHNXAxZWxkUW50TVd2MDV6?=
 =?utf-8?B?SDlYKzR5NFZWMzJBNFNyMDFmN3BzTk5NM0orcUlXMzdzT2lJckZxRmFpL2hu?=
 =?utf-8?B?am42NUpHZDNrenhNaGZORXZTVTVndGNXK0dvaWkrdGpWOFhrTmxlbVA5SHY2?=
 =?utf-8?B?OGhkRlVxaGFrNnczdHVCUXJlSE1TMzY3R0wvM3c2QVJvaHJBMGswWWNvMXl2?=
 =?utf-8?B?S1U1NUNObENWNWx3ZW1kWGZoSHRDWVhVWUo4cXZRNm1sNEkrL3l6NWpKTTN6?=
 =?utf-8?B?WkNrZHVnV2F4ckNRMzg5bEpKVG8razloWmJXZzFWeThDc1NsYlBnV3dBQzI2?=
 =?utf-8?B?dDdJdkhtZ1hMSEhrVUlpelExeGxsMnFqcUdnTytVV2U2OEcwZ2d3amxQK1pY?=
 =?utf-8?B?L2o1Q2hTQ1ZJUWlEV0NUcTh6Vk1xVkNjbHVjWHBKWDZyalo3Qis0SXV4YUJE?=
 =?utf-8?B?aGNGV244Q1Bsb0I2SGdXL1Vhci94Yk5XVkNKSWJwNEVUamVsTEc1ZUtwMk9r?=
 =?utf-8?B?NXpueXY5ckl3bzVrWllLZWVuQjRXa1p4czI5TC8xTmI3Zk1RNFk2Z2NXc2tr?=
 =?utf-8?B?c1FFbWNBcGtjank0UlJUSW9qbWlNN2h3S0FLaWFSTWpxQUxYeFpHNFBtdDdh?=
 =?utf-8?B?SGp4cUVXbU9SUzNFcEs0aGdaN1BpMEd5T0dpQ0V3a0FqWFZTQW1SdFI0TE5w?=
 =?utf-8?B?eWx6Mm9hV05NRHduRExiRlVrOXlDSzBUeXY5VGJna0J6dXRFbjJvWlFIY3R4?=
 =?utf-8?B?VnlvdUFGSlFzaERGeUJ0ejArODQxK2FCanR4cG9WQjhqbmdxUVo1RytoNzds?=
 =?utf-8?B?KzFFR24yaWViQ0JRWCs4RWJiNkFXUzN4ZTVmRGUzUUdKUk1Cc3RrWnJjcmNK?=
 =?utf-8?B?ODBkSGlMd0hwTVZBM1FrNUxaditMV3pUK0w2YTF0SUhFeTYrRktnZUdqY0c3?=
 =?utf-8?B?UVB6WmJlNDB2OFBIb1IyQnJuZko0dkxtbFAwc3RSeS81dDJUWUF3ZDRyc2gr?=
 =?utf-8?B?cEgwTUJ4bkM5ckhSYmdNZUhpV3dONEFQUFFlQUoxYUpTeHFtcml4VEp0dm9m?=
 =?utf-8?B?TzNOekhIRzJrRStnNGpuZFlYWVFhNUsreDRtWjNTZDRTdkduS3VrSkNGSkVn?=
 =?utf-8?B?LzM2QjlEVi83d1ZvemVvYTcwWkErZ1VNRHAyYXp0VE1QeFRVWEErRHVraFFC?=
 =?utf-8?B?NDJNSjBXK1Via1dZYXBDSHRObjNIald6Rzh3UUZVVWRYVjdoZXVMWUd5QnNW?=
 =?utf-8?B?Z29Bc3FMazFaRWhQWGN5TlRPNmU3Y01KU094Q2J4S1N1WlNkSFhIb3ZSdjNM?=
 =?utf-8?B?U1ZVOU80SG5wRUlqSWdxSkhBYzZwdWxPR2x0VEEvVzEyZzVsZ2RoeldnQVBr?=
 =?utf-8?B?c2d0SDFJa0ltYzlrVmlGNUpQbmxqN05oT09seGF0NWVXc1dzdmVoUndwd1Rh?=
 =?utf-8?B?Q2RUak5tWndpak5UdFlFOS9nV28zTHdjNWRPWDVVVWxWNnpGSytKU2hQUW1j?=
 =?utf-8?B?SHJQQTQremVsZTNiM29PMnBkZ0kxWEZrWFVQOVgvVUQyZjBhdXdNY1ptK2dp?=
 =?utf-8?B?WUhLemxkWCtmbEtqemVkZmpNblE1dld3bTgyamd3QVNSTzZDazJkeVFqSzUz?=
 =?utf-8?Q?AwSqR1SuP/JYdlKLNHssvVS1R?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c980b2-bf89-4120-df93-08dd0211a727
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 05:28:19.8346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YFyMMZPdxeSXsBN+LHBbuxl0mbJ8QGI23klcnNSPE5HI7YZNDwsHa/F+ufnxF5FxgFAF6muphmkvUTZfAK+9zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8625

UmV2aWV3ZWQtYnk6IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAuY29tPg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGNoZW5yaWRvbmcgPGNoZW5yaWRvbmdAaHVh
d2VpLmNvbT4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAxMSwgMjAyNCA3OjUxIEFNDQo+IFRv
OiBDaGVuIFJpZG9uZyA8Y2hlbnJpZG9uZ0BodWF3ZWljbG91ZC5jb20+OyBIb3JpYSBHZWFudGEN
Cj4gPGhvcmlhLmdlYW50YUBueHAuY29tPjsgUGFua2FqIEd1cHRhIDxwYW5rYWouZ3VwdGFAbnhw
LmNvbT47IEdhdXJhdg0KPiBKYWluIDxnYXVyYXYuamFpbkBueHAuY29tPjsgaGVyYmVydEBnb25k
b3IuYXBhbmEub3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyB0dWRvci1kYW4uYW1iYXJ1
c0BueHAuY29tOyBSYWR1IEFuZHJlaSBBbGV4ZQ0KPiA8cmFkdS5hbGV4ZUBueHAuY29tPg0KPiBD
YzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgd2FuZ3dlaXlhbmcyQGh1YXdlaS5jb20N
Cj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSF0gY3J5cHRvOiBjYWFtIC0gYWRkIGVycm9yIGNo
ZWNrIHRvDQo+IGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtDQo+IA0KPiBDYXV0aW9uOiBUaGlz
IGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4gY2xpY2tpbmcgbGlu
a3Mgb3INCj4gb3BlbmluZyBhdHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRoZSBt
ZXNzYWdlIHVzaW5nIHRoZSAnUmVwb3J0DQo+IHRoaXMgZW1haWwnIGJ1dHRvbg0KPiANCj4gDQo+
IE9uIDIwMjQvMTEvNCAyMDoxNSwgQ2hlbiBSaWRvbmcgd3JvdGU6DQo+ID4gRnJvbTogQ2hlbiBS
aWRvbmcgPGNoZW5yaWRvbmdAaHVhd2VpLmNvbT4NCj4gPg0KPiA+IFRoZSBjYWFtX3JzYV9zZXRf
cHJpdl9rZXlfZm9ybSBkaWQgbm90IGNoZWNrIGZvciBtZW1vcnkgYWxsb2NhdGlvbg0KPiBlcnJv
cnMuDQo+ID4gQWRkIHRoZSBjaGVja3MgdG8gdGhlIGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3Jt
IGZ1bmN0aW9ucy4NCj4gPg0KPiA+IEZpeGVzOiA1MmUyNmQ3N2I4YjMgKCJjcnlwdG86IGNhYW0g
LSBhZGQgc3VwcG9ydCBmb3IgUlNBIGtleSBmb3JtIDIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IENo
ZW4gUmlkb25nIDxjaGVucmlkb25nQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
Y3J5cHRvL2NhYW0vY2FhbXBrYy5jIHwgMTEgKysrKysrKy0tLS0NCj4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDcgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYw0KPiA+IGIvZHJpdmVycy9jcnlwdG8vY2Fh
bS9jYWFtcGtjLmMgaW5kZXggODg3YTVmMmZiOTI3Li5jYjAwMWFhMWRlNjYNCj4gPiAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYw0KPiA+ICsrKyBiL2RyaXZl
cnMvY3J5cHRvL2NhYW0vY2FhbXBrYy5jDQo+ID4gQEAgLTk4NCw3ICs5ODQsNyBAQCBzdGF0aWMg
aW50IGNhYW1fcnNhX3NldF9wdWJfa2V5KHN0cnVjdA0KPiBjcnlwdG9fYWtjaXBoZXIgKnRmbSwg
Y29uc3Qgdm9pZCAqa2V5LA0KPiA+ICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ICB9DQo+ID4N
Cj4gPiAtc3RhdGljIHZvaWQgY2FhbV9yc2Ffc2V0X3ByaXZfa2V5X2Zvcm0oc3RydWN0IGNhYW1f
cnNhX2N0eCAqY3R4LA0KPiA+ICtzdGF0aWMgaW50IGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3Jt
KHN0cnVjdCBjYWFtX3JzYV9jdHggKmN0eCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc3RydWN0IHJzYV9rZXkgKnJhd19rZXkpICB7DQo+ID4gICAgICAgc3RydWN0
IGNhYW1fcnNhX2tleSAqcnNhX2tleSA9ICZjdHgtPmtleTsgQEAgLTk5NCw3ICs5OTQsNyBAQA0K
PiA+IHN0YXRpYyB2b2lkIGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtKHN0cnVjdCBjYWFtX3Jz
YV9jdHggKmN0eCwNCj4gPg0KPiA+ICAgICAgIHJzYV9rZXktPnAgPSBjYWFtX3JlYWRfcmF3X2Rh
dGEocmF3X2tleS0+cCwgJnBfc3opOw0KPiA+ICAgICAgIGlmICghcnNhX2tleS0+cCkNCj4gPiAt
ICAgICAgICAgICAgIHJldHVybjsNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0K
PiA+ICAgICAgIHJzYV9rZXktPnBfc3ogPSBwX3N6Ow0KPiA+DQo+ID4gICAgICAgcnNhX2tleS0+
cSA9IGNhYW1fcmVhZF9yYXdfZGF0YShyYXdfa2V5LT5xLCAmcV9zeik7IEBAIC0xMDI5LDcNCj4g
PiArMTAyOSw3IEBAIHN0YXRpYyB2b2lkIGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtKHN0cnVj
dCBjYWFtX3JzYV9jdHgNCj4gPiAqY3R4LA0KPiA+DQo+ID4gICAgICAgcnNhX2tleS0+cHJpdl9m
b3JtID0gRk9STTM7DQo+ID4NCj4gPiAtICAgICByZXR1cm47DQo+ID4gKyAgICAgcmV0dXJuIDA7
DQo+ID4NCj4gPiAgZnJlZV9kcToNCj4gPiAgICAgICBrZnJlZV9zZW5zaXRpdmUocnNhX2tleS0+
ZHEpOw0KPiA+IEBAIC0xMDQzLDYgKzEwNDMsNyBAQCBzdGF0aWMgdm9pZCBjYWFtX3JzYV9zZXRf
cHJpdl9rZXlfZm9ybShzdHJ1Y3QNCj4gY2FhbV9yc2FfY3R4ICpjdHgsDQo+ID4gICAgICAga2Zy
ZWVfc2Vuc2l0aXZlKHJzYV9rZXktPnEpOw0KPiA+ICBmcmVlX3A6DQo+ID4gICAgICAga2ZyZWVf
c2Vuc2l0aXZlKHJzYV9rZXktPnApOw0KPiA+ICsgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ICB9
DQo+ID4NCj4gPiAgc3RhdGljIGludCBjYWFtX3JzYV9zZXRfcHJpdl9rZXkoc3RydWN0IGNyeXB0
b19ha2NpcGhlciAqdGZtLCBjb25zdA0KPiA+IHZvaWQgKmtleSwgQEAgLTEwODgsNyArMTA4OSw5
IEBAIHN0YXRpYyBpbnQNCj4gY2FhbV9yc2Ffc2V0X3ByaXZfa2V5KHN0cnVjdCBjcnlwdG9fYWtj
aXBoZXIgKnRmbSwgY29uc3Qgdm9pZCAqa2V5LA0KPiA+ICAgICAgIHJzYV9rZXktPmVfc3ogPSBy
YXdfa2V5LmVfc3o7DQo+ID4gICAgICAgcnNhX2tleS0+bl9zeiA9IHJhd19rZXkubl9zejsNCj4g
Pg0KPiA+IC0gICAgIGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtKGN0eCwgJnJhd19rZXkpOw0K
PiA+ICsgICAgIHJldCA9IGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtKGN0eCwgJnJhd19rZXkp
Ow0KPiA+ICsgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAgICAgICBnb3RvIGVycjsNCj4gPg0K
PiA+ICAgICAgIHJldHVybiAwOw0KPiA+DQo+IA0KPiBGcmllbmRseSBwaW5nDQo+IA0KPiBCZXN0
IHJlZ2FyZHMsDQo+IFJpZG9uZw0K
