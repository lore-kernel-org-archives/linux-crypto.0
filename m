Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793202610;
	b=W2Hz3X+AhBX/LlNjtiC3Ak2FUvd08O0avrG9dqdcd7AZ3LR/eBgYuEgNQO37LpF8MGTP
	 EVY3LulMDj05ZolrNbOCa1a+gPdP/VuLYNWuY7+Df3WTvEjT1K3WPggfgxtOgzJRp9AH8
	 Bg47bpdO3k9FYbVab1cPt7juiqmZXrNadOJR14LXdUgtCyXdaDSSFtnaB+D/Nt9qg6Y82
	 XyEhZsnKT8vzJwELXeWzYzkRgW+aXQWI2UeqCatmClvvBxQo96fj4eZ1dDaOW48gM3HvB
	 I7rZPNIVghgUaURllj6Grqp2dPYGRuWSlDX5bMftxAQy1LJf91k9zIgij/hbzPSyDfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202610;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 dlp-product:dlp-version:dlp-reaction:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=KoXUPg2+11eZERZ8YLzuk9d7TXgpzSgDj3k8aRzXEL0=;
	b=2a6EuyzkcJRLNAajCthzellQakkwLtx3mvnlm7DaSAVuNeq4LYcwhBws/TnuiayMOllu
	 yLNaTalhgqU9s/RU47mo+p/HC2QKQJqMOjXNH6cHJkHP0XWLAi1ICerHdDHooOs5L5D1R
	 xXl1teaZhqDzJofQ5M+cE14M5qJobcsumlLfojDfF9lHsI89OIHzhJjq/5GiWc6bZL33l
	 YZhkj+GYy4RYs3ghe9XqkaTPYl1qhZBXat/rAI6rKxJSJx4piKrmT/FmCE//Gt7zWOGdi
	 w04TX1GhOkLtrwSAyfC+D9XcdWAwFqn6h/5EVLMz6Px18dC932uUwWBxiimbcf4vJkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=P+3Svnca;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.124
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022124.outbound.protection.outlook.com [40.107.200.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD58D606A31F;
	Wed, 28 Oct 2026 15:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD58D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=P+3Svnca
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYaDkQGm/sz3FTC8gXJJlF+jWSuhDGTPFjJ3f8lE7KYX3dIJxSgLST0dQhK9EXfu9KhENyn/EsIL6N3cKO5rgtPGK73tqJwgdcBPCxfqWxJLYM5VT5yl3sgxnSzymTKBInJVaOAGCJCmV4R0ogs4F9XJqbHxaixlYFiO+MTI0D6E4+jsq7kYJC9lZcHFaYPyuWA+oRzjDfEYDmg8xGjgm0eGkyRQlu5Wl5v8A7ckMxuExwkAWwA8Bq3SY5BeZN+sgCXAK7v2adPHeqR4PHqdH7qTopF7BprNkIO/LOp1PJSZQN1pWLKZXn1orOjQrmqjZWwz6loVm72o5/eWWW+NXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoXUPg2+11eZERZ8YLzuk9d7TXgpzSgDj3k8aRzXEL0=;
 b=qc1QK0RVZyqWO6dqdwSGJeEmn/0f8a3tBRpK+MzXy6TkqTgcsPAIggCcDbREJpshX0i2EB+ZVq1NSa6mK2NgHMFar20YIglfKagMSyCOTeplG1EUMXC0pGkScrmV4GesjiUgy/Uuzs9xgFodrDctriHGJJds7uisT4GdTDQO4Vk07+QWqCBHKS5EOaE1EHkBN0lQ4Bu1rTFMUzjehhUOWxGSID3xXcznM6uSkraXr9v1P0NW3nyovYmqWR++dg+aJEwL9GZnjDqA1J/1nDHs2SK36rKS0YV/1N1NV6BIvtG8zhwzrrn87s55yuIYfSf/qyidT/ywakzUD8QAOTXtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoXUPg2+11eZERZ8YLzuk9d7TXgpzSgDj3k8aRzXEL0=;
 b=P+3SvncaK5eJkOSE9GpDB4tA87k8CgkiZmBfq7X5WqMpnzDdkAsxaJRzsZbOIHG5kCOiERAsCdCrk+S26f4T8cahQW+/5jzrR/P0sgFPso+mnDBYbkohn8Jwcf3L1SsturCs1fAvpKqljJk9NRO+FwXM8Zeewfh4UtrUIhZeVj+VpPbYbo3ct/25fUlsjTg7qz3uMdB8GDuyZvJ2c/1ZnELGa/xRhpcP1jBTjK/FBusJUKmBBzWrHM0pvK2tpQatMutB6SO8OiIm9xH/ba1suf0nUtExk4hQKasyWsHlpHG1kaKMCicKwQ0Z5Eb9dnI5q7ApP/ZYrlv2pJK16jDj9Q==
Received: from SN4PR04MB8398.namprd04.prod.outlook.com (2603:10b6:806:201::22)
 by SA3PR04MB8595.namprd04.prod.outlook.com (2603:10b6:806:2f5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 15:50:06 +0000
Received: from SN4PR04MB8398.namprd04.prod.outlook.com
 ([fe80::4939:9b85:fbf:521d]) by SN4PR04MB8398.namprd04.prod.outlook.com
 ([fe80::4939:9b85:fbf:521d%5]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 15:50:06 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "Nguyen, Thi" <thin@rambus.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v7 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Thread-Topic: [PATCH v7 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Thread-Index: AQHdZYKCcVew0gTTVUOktSq3CoygKLcTDH0AgAAQGTA=
Date: Wed, 28 Oct 2026 15:50:06 +0000
Message-ID:
 <SN4PR04MB83989F3F40A0E03477CE9415D76F2@SN4PR04MB8398.namprd04.prod.outlook.com>
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
 <20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com>
 <76e47b43-2f00-4b29-bf2b-afb6fa0387d7@kernel.org>
In-Reply-To: <76e47b43-2f00-4b29-bf2b-afb6fa0387d7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.14.0.414
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR04MB8398:EE_|SA3PR04MB8595:EE_
x-ms-office365-filtering-correlation-id: 8b4c17b6-397e-43ce-b5b7-08df350b2326
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|261026121527099003|921020|38070700021|4143699003|11063799006|56012099006|261021123027099003|261022075727099003|261021121427099003|261022113327099003|261022105027099003|261009223027099003|10067099003|261028144727099003|18002099003|22082099003|6133799003|261026140227099003;
x-microsoft-antispam-message-info:
 earq1nRbbmV6lZFstPGnu+JmukR6g0snxq9s6iBwUV0BbT1VQNlZFmUvRCfIHEKMpS5Qt8voONTUxlXt1po6P48eeE5GRLA1k3mP2PiNpuiZm1QvUz+eGlnjKJq8f29LfpYuAzIHwLEHNVIqnNOOj5bfumJExBiIlAwqmSk5WFgfzJtZaQ8jcC3jwyeiChjW/3+DKBIFOHgrVM+QDL9nPcnTfo07jaV37bTmvNXITySZLSGY5Cycgge81ZUKlBjEsZXV5hep3Btzy2OILunyU8biznlrLWU7yyyoYkkFnQBJbt9HzqrV+tGxeQ1kxiLgywEKa3X/MXPm+joF3M29f5UuMEMGbRosaTbUXXjvTX8aafwwbSE40OjvGGTMIeDDPzc+27TS3DXDOeC39/n/29oPVhDvpM7DmPugIuynxkDqBh2XGdDW8VfL8vGMTYH1Kc6CBRPf9tEelk5hoMpvb7eAaiKw1o3qhPZkZBO9ZQuixB4EmaAJbgSA7KfYVw1MdLm9oRzE0b15iE+h9IcfLkwrQ8GWiY5dxFUulsumIJrDuJA4Z0ncL04cXFeRNl0rRO1bFT94VMafNSoLPo0MM9fPEjEbwKIHUs0Pv09pvQpXbWsYorzmuKIV2MqUIoWV6Fmb6dLjHNTPKmF7uYm8ltMzxF5VCUfMk0DnJLAYnkCiBEbbJvTBzoQjMnHtgsLP4fqKqpYcKOdsNuOuWIXRrFo33OkgQgcQfqFaYgv9izE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR04MB8398.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(261026121527099003)(921020)(38070700021)(4143699003)(11063799006)(56012099006)(261021123027099003)(261022075727099003)(261021121427099003)(261022113327099003)(261022105027099003)(261009223027099003)(10067099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V1hDT1QzVmZSb0JlVkR2Mlc1cndQdXJpcjFoU0J5NVYwcUJZdFNEcWRVM2Uw?=
 =?utf-8?B?TS9XQmNSYnZ5VCs2anZjU2lNSlFNaG15NENZMXdQTmdFVmF1b3lsNEp4UkMv?=
 =?utf-8?B?b25NN2pqdmdRMmNhSjFQd2UyZnozWG1CcGxONUxiVUozTE1hdHN1UHgwYmFL?=
 =?utf-8?B?ckJtN04zNHhickJqTVM1UG5ONE1xNEE3YS93VnVDanIyK00vV2tkN0tQVkU2?=
 =?utf-8?B?bHgyZjNOaVRLdnBEU3NNWkllOW5XbVhiU0UwSVNycmY0alExNnB6TFU1WCtJ?=
 =?utf-8?B?bW85NG8wLzBMUHpPY1lER09BT2txK3puVklqVjJDRFd5c1NpZ29oTWpZYW9P?=
 =?utf-8?B?WFNpZGtqQURuYWw3VVNNWU12cVJOZDhwcEpnbXZVUENLNXI0aFRtd2theEFi?=
 =?utf-8?B?MER6UDc0SUV1Q01FS090aytMV2tvMzdCSHBzaTBsb3JoRlIxTnQxQzNzblZP?=
 =?utf-8?B?aDYwK2VPMnNWWDJHaEgwVHpENm9mcXA0c0FSOXhkS1Btc2JuNnQ2ZDJCSTgr?=
 =?utf-8?B?ckZ0MTBjYkhUc1VjYnh0OHVSMEU1U1kyenJDOUE3UjZGbUU0Y1dGYVkvMmxw?=
 =?utf-8?B?d3MycHV1VGdsOVRWVWJtbjhiSW5xczRITEdxa09BU2JpcHI0SW1RT0RZSWZy?=
 =?utf-8?B?ci9ETkJXOTJmZ1dnRUNRWGd1dlFVMEVpOVZVMTMwbmo0eU1uM09hRjJDMHY2?=
 =?utf-8?B?OEZpMXhXUmRHQVFwckxrcUxPQXA4STNqYVVoZEZKVENBZExCUWhWR1RUMEZX?=
 =?utf-8?B?VVhGdUVyRkMwWEJsdHhWUTg5Skl6WTV0amNvUEt1UFREZms5YktsQUpDZXd4?=
 =?utf-8?B?YXhodkU2Z3ZrS2V0VmVlekVvU0lnSnRsbkptVW1pdjNsTk1QaWVYRkEyTWp2?=
 =?utf-8?B?dlhidW9RNmxPWW51MWo1dE5EcUlERGVjZkppRTFKOTJkdVhpcVdJam1OY0Fr?=
 =?utf-8?B?dktNU3JySTFGZUpkcHY3VVJGblo2L1Y3ME9yUGZJZEhINWJkWU0ybzhtcldw?=
 =?utf-8?B?V2k3SWZpQU1DNGtmTGZsVWxTVXAwTmo2bXV1aTRrNFlmZTJkUmE3bW9EQ0lF?=
 =?utf-8?B?eUZyWm1ucG53dFc2QWo1NWR2N2xFVVI3ZDNtbXZXZDhnRnBTTDJPV0R5YWNQ?=
 =?utf-8?B?S3FvS1o3Tllxc1ZFWmpKZEt0MG9mUnQ2VHBoM3l5OTEvMDJjMDI2MEFFaFEw?=
 =?utf-8?B?WWNFeEpCbWpENlhqUUwwRHVNU1I3Z2Jaa0FXVDVhd0hmOEZMMlJtK3cxMm0v?=
 =?utf-8?B?MUZzZjdXWnd2cWxwcGZqUnBRaXpvTmwvTDdsak83RkMvNjBvYVhlZW9lRVZR?=
 =?utf-8?B?OHZ0Qm9hd0N5YW0zL01HclNnSzQyVElYM2o3T1RudTY1bzdHTUZIbCtGbE13?=
 =?utf-8?B?WnhiVk9BSFN3dTRuV0srNmR6Nko0ekpTc25KOXo1SWl2MHl6d0hTWEt3Z05u?=
 =?utf-8?B?aGdNVUVYNnl6Z3A1VzVqcGswYmhEMjR3WlZzNHJ5WS9rUUc5ekpJNFBuY1ds?=
 =?utf-8?B?bEV5L016V2VsL2cyS0NtNk51aDBtcklFa0FUVE5jSWI2ZnZ5S1hmanlEL2p3?=
 =?utf-8?B?ZFFlUGtlbGN1MTB5aWRHeVdQS0hXOStPeTV0djJsUXl5c2JEb0FTZmxaN3ZV?=
 =?utf-8?B?cUNaZXg3TGF1SEE2b2F1dElkT3RMZ01GWkRJY0tDVi9OY1hwNENLTDAwRll5?=
 =?utf-8?B?MzJaUFZaMmlnajZwYXYzc2IxazZQMDJPeFc5Um82UGZSSnBReWFKY214QTMw?=
 =?utf-8?B?RTFxaG4xbDlQUEpiK1l4UHFMeVRnT0gycmpLSVZOY21Xc3R2Nnc1OXY4bWpE?=
 =?utf-8?B?UDNIRVBaVkdwWU9FUS9NZFlmV1pyYUJISnR2Y1I4OE8vS3hONTYvYTA2ZzBp?=
 =?utf-8?B?cWEwYUx0MFBmc0pwRWZTQ2p2akR3VUxTQWd0cUUwbStqMHNLMm1saWJEYWRn?=
 =?utf-8?B?ZW11VUdzK0w2T0IxNko0dzZDWm5vWWxZd0wvY2dWNFBiU3R6eXZHRlR5Y01G?=
 =?utf-8?B?WXpyQmdiRzI4YXpXQ090NzBxdXorZHdDRmxuMVYxc1ZZZXkzYUxoQkhWSE5t?=
 =?utf-8?B?aWJyYXVOKzlSYks2S1U1SEg4V1J2V3pabGRDNUp1Q1A1SEdyK3ZhazVpdFZk?=
 =?utf-8?B?Ti9sSjN6Z0tnblVzd1FrSDdHM1FESXJaUTdQRlR6bzk2WU1ldzdpMjJTQ2lr?=
 =?utf-8?B?b3krbnNkUVpCWk1NdzdYUTVwMll3QU5CQkVZU1YzWWJZWklsQS9DdHBOclVP?=
 =?utf-8?B?RlpBamdrOFdQZ004dFZCZXdpekY5bkgwM0s4eHdZV1BwUUpyTUk3c2ZMK1hL?=
 =?utf-8?B?WVN1OTNraUpXWmxGQWVaVnUvanB6Sm1DRWhocFB5akpXaXlRU2Y4dz09?=
Content-Type: text/plain; charset="utf-8"
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
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR04MB8398.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4c17b6-397e-43ce-b5b7-08df350b2326
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 15:50:06.0524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8QYyYvlEQ4y2X08snHZKHEdxhkCgcHt8ohk3ljxNIdn12/Jp9GI1Hto5dvEbgduL8TsOrxXJFrqStRe6o24Hr6P6IXAJ5LK7gVkAqJNe258=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8595

T24gMjgvMTAvMjAyNiAxNTo1MSwgS3J6eXN6dG9mIEtvemxvd3NraSB3cm90ZToNCj4gV2h5IGlz
IHRoaXMgc2VudCBtdWx0aXBsZSB0aW1lcz8NCi4uLg0KPiBBbmQgYm90aCB2YXJpYW50cyBhcmUg
cHJlc2VudCBpbiBQYXRjaHdvcmssIHNvIG5vdCBzdXJlIHdoYXQgeW91IHdhbnQNCj4gdXMgdG8g
ZG8gaGVyZS4NCg0KQXBvbG9naWVzIGZvciB0aGUgZHVwbGljYXRlIC0gaXQncyBhIG1haWwtZGVs
aXZlcnkgYXJ0aWZhY3QsIG5vdCB0d28NCnN1Ym1pc3Npb25zLg0KDQpBbiBpbml0aWFsIHNlbmQg
b2YgdGhpcyB2NyAoMjMgT2N0KSB3ZW50IG91dCB0aHJvdWdoIG91ciBjb3Jwb3JhdGUNClNNVFAs
IHdoaWNoIHRoZSBsaXN0cycgRE1BUkMgY2hlY2sgcGFydGlhbGx5IHJlamVjdGVkOiB0aGUgb3V0
Ym91bmQNCmZpbHRlciBhbHRlcmVkIHNvbWUgbWVzc2FnZXMgYWZ0ZXIgdGhleSB3ZXJlIERLSU0t
c2lnbmVkLCBzbyB0aGUgY292ZXINCmxldHRlciBhbmQgdGhlIE1BSU5UQUlORVJTIHBhdGNoIHdl
cmUgZHJvcHBlZCB3aGlsZSBwYXRjaGVzIDEtNCBzdGlsbA0KcmVhY2hlZCB0aGUgbGlzdC4gSSBy
ZXNlbnQgdGhlIGlkZW50aWNhbCB2NyAoMjYgT2N0KSB0aHJvdWdoIHRoZQ0KYjQva2VybmVsLm9y
ZyByZWxheSAtIHRoaXMgdGhyZWFkIC0gd2l0aCB0aGUgZnVsbCBjb3ZlciBsZXR0ZXIsIGFsbA0K
Zml2ZSBwYXRjaGVzIGFuZCBhIGJhc2UtY29tbWl0LiBObyBjb2RlIGNoYW5nZWQgYmV0d2VlbiB0
aGUgdHdvLg0KDQpTbyB0aGUgYXV0aG9yaXRhdGl2ZSBzZXJpZXMgaXMgdGhlIDI2IE9jdCBvbmUN
CigyMDI2MTAyNi1jbWgtYjQtYS12Ny12Ny0wLTUwMGE4M2ZhZjUwMEByYW1idXMuY29tKS4gSSd2
ZSBtYXJrZWQgdGhlDQoyMyBPY3QgY29waWVzIChwYXRjaGVzIDEtNCkgU3VwZXJzZWRlZCBpbiBQ
YXRjaHdvcmssIHNvIG9ubHkgdGhlIDI2IE9jdA0Kc2VyaWVzIHJlbWFpbnMgYWN0aXZlLiBGdXR1
cmUgcmVyb2xscyB3aWxsIGdvIG91dCBvbmx5IHZpYSB0aGUgYjQNCnJlbGF5LCBzbyB0aGlzIHdv
bid0IHJlY3VyLg0KDQpTb3JyeSBmb3IgdGhlIG5vaXNlLg0KDQpBbGV4DQo=
