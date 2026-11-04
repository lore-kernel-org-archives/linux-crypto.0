Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793797646;
	b=b47A3wcHatYCIlXEH56iXbtXHL7u93DebLz3Q83NOzq3f51cJf0pu5fHECZ9pn96qjEg
	 MY50gSPwXbYGuUKN0vWdYyCF9OYh7qMO5HHsZ2ThJVCKoHhj5F5fI9JFL4DdrjK0KqDQY
	 kcNqo8AcSbFLoKico03lC7jWRluofB7a4qatQkD8N/lkUFfqG8BJWMn40ACXrchQ093x9
	 HQIfG/MbdCbaET2abE9cpc6rkS0Ck/gHJC7kVVwGn48AMh32nGcXauxNBtG8CqJWKznDk
	 AYERLyPjgDYpF4fmbKca/3w9EJNzGMbjxlFCAT/0oJ2qBq2X7HKLZIPWnlBSCbd5SKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797646;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=tyyZ4vVAy+tQh3Dy8/uh+JBkr7PRmogoJmALWTniQ3g=;
	b=akG4g/dfDx4tYUZcmAtNAuE00BvAY8hNg8OmqIacA+625GoSxWJVQAycMC3iIS2CrBMD
	 qAyVB1OkhjCdaANv0GwCbjRfPilIT70Ram6VspABllCWjgHxUG2yU+qcdtSjg/wgFvVNo
	 BJXHKsxYQi5/zQc6mZeg90Ncr4/5BpSSXCtKzA0jVODkIeEHCl/tZJrlDW1FQZK03taWQ
	 g3YJigpnpw4VsiBLtGaygN4Cu4ZOt3tENkc8bx2H25M3AqkP7yqJczgfNsBG2+PFSn+BB
	 eKX9ibjT1weUNECUe7u4LFEvsrOWjDgTYKXbcZfGXzaWhY6t1rHzE4kWpW4ZQSMLiLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="WjFVS/6z";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="sUf6b/ck";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D49606A31B;
	Wed,  4 Nov 2026 13:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02D49606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=WjFVS/6z;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=sUf6b/ck
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A4BbpXg3864830;
	Wed, 4 Nov 2026 07:07:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tyyZ4vVAy+tQh3Dy8/uh+JBkr7PRmogoJmALWTniQ
	3g=; b=WjFVS/6zoqqipSWG3FFHF2xEx2XRhYni5p5dz87/hxCYGB70xJYrwDqHz
	85xfyE0WWh0m9jYLr9fBKV5xzZ4CGPODusf23Zdry4VD/td276Wryh6vEhZWmH9D
	ulmf+Qh4qbL51kO7Ijgo3tM/Wn+CzBGM8kDSPBqcKZ2nj12ouej0Wm7rfjgcHSKo
	fp3VK+1NTsRfECbIkf8r6K665vLb31B20S6FTEsO8/Fi7/fwNAWoTLB7bzFLew/i
	a6xuKIYYJbhyxdHuMEHknvskgdu/4jBR/cOM9OZqzYP4q5r//3edX4Litw6jTTxU
	OMH3s4k0cao0PmpTBie4zpLav2u6g==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hr2528yv8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 04 Nov 2026 07:07:21 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqDZMuMfvs8Tjsa95CMjPoTIGj+L5yLAjK9g0a7ZxS8Rvx+u280BCaUk5l9q6qvioh33nWLhO/uWcnzDlY9oefoQSzIziDJx1aMIA4IeAWHb9vf39H0fBmsS3coLhhz+IH1MjAzFtH22/VFNdFEjI+2Rui5p9PKBiLvZwcfvHaXDiAOl8mOb2IXAWFK5uGHdmsDIYl2So/U9OIe3qiw9fstywUnHGqd1kzParYMtMFB8JpnSfrI8X6e6euH89n2rTJ6eD8gdiwawLQ1G5kPsroBFGf/fpeGaCP7ef96m/m+Z2rdmKeFvTo3EeLEbu4RKNR2+LmpVIwg7lNNPJgia/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyyZ4vVAy+tQh3Dy8/uh+JBkr7PRmogoJmALWTniQ3g=;
 b=IrLas+xttN5C7pgjaxF3X14iU/o8YiOSr3NMs2fAikHe2zJb2rNXmt4Q2ocVPfW2LSrCqF+bXQXr5WeChajaNkyjAH2WJLqbMyDHyt7hdUqAO2nYDyNL45SKCevJ4Tdk1Sa6WFxxVBTtwZCPeV3tV7hGod8fH7K/KcSk16KCCz4oLTg7LjCusBOY6uje6XG0QX5RsuBMnx0f10gjcroOLMFhI7lbrNNLRTrt6l7iKweD+Z8yNsIZgxeNIOkFjtlLHOQCe6ZpA6ptzLAelpCpIABQFiXUkUWmubZP4MGbZVh0MovNO/wB8tlnfS/OBz6GPFmmuBlQHZoqiBOyK3PJiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ti.com; dmarc=pass action=none header.from=ti.com; dkim=pass
 header.d=ti.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyyZ4vVAy+tQh3Dy8/uh+JBkr7PRmogoJmALWTniQ3g=;
 b=sUf6b/ckne4coRDj4+Qz3lxujpMq+qGqVjx8H2gVyxE2ONqUOl4EdwEeoxyoNpiddVPYgOnOmx8hqe4Djlzo2XfP4iEH9SoGQFbipYIINne2Cwf92xl3XcTFTQ2nZu/KzTwjww9wYAUe4dk39OgoNWOiVXG4c16YhNA/v4QzrWc=
Received: from CH3PR10MB6692.namprd10.prod.outlook.com (2603:10b6:610:148::18)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 13:06:15 +0000
Received: from CH3PR10MB6692.namprd10.prod.outlook.com
 ([fe80::13c:af79:908f:abc0]) by CH3PR10MB6692.namprd10.prod.outlook.com
 ([fe80::13c:af79:908f:abc0%3]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 13:06:15 +0000
From: "Chawdhry, Manorit" <m-chawdhry@ti.com>
To: Thorsten Blum <blum@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: sa2ul - avoid rollback in sa_init_ctx_info()
Thread-Topic: [PATCH] crypto: sa2ul - avoid rollback in sa_init_ctx_info()
Thread-Index: AQHdbDYtqKqAQi+xakG5Wkw3Tvs7ILcd4h4A
Date: Wed, 4 Nov 2026 13:06:15 +0000
Message-ID: <727fd6fb-844b-4229-86e5-f34a8b518413@ti.com>
References: <20261104082056.47165-2-blum@kernel.org>
In-Reply-To: <20261104082056.47165-2-blum@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ti.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR10MB6692:EE_|IA1PR10MB6218:EE_
x-ms-office365-filtering-correlation-id: 7da8ab8f-b063-4f16-4742-08df3a74688c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|261026140227099003|38070700021|5023799004|56012099006|261009223027099003|261028144727099003|261026121527099003|261022105027099003|261021121427099003|261021123027099003|10067099003|18002099003|261102123227099003|22082099003;
x-microsoft-antispam-message-info:
 6crMsFI2hhXNtcTP1N8sKKv8L5CIEB9NTI8XuANitFGmdKFeKNsxtK63+7w6GYOya3X1l0rTQGCg0kgxFTDMzht9k+D1/NjQ82SY/8BEybXP26Eo3+LXyuPkM52rJ9Y/XwsPvwJKtwDSdn9PsVYVJrOr45D+0U8ZCFGmLb3xa8J54OqQ7k330V+ERGfCthvOO/KYcU2nZSpXDrOAHuRP5tXPKFnxNkeD2jzjmg6N76T8rHqH1BQsvA5W5F4w/x1JLyKRS3TB2GSOdrhSSsvwteIjeLGmzSmGbro8bM/0DbDMAd55pHkSsMKEDcwgd6XnIHdlVsdh0LNQlQzFHPjE/Jc72QwuMq3iVL4aI2ENnjIH+t1ZXakIa1WYgqIuQhvb5XLy6O1KKd2Mz2hapWfkMw68ALLxNnucKiwUT/C5cD+IBY+/zspl3wpjGyOmAysB7J+ScQIA7WjVNg6yjgMjfF79GavUY5au7NK12R5zJb11JFn3MnAYmCNQ4T9Er2df/NGNEK5SZR/ky5ACl9G+IU/1qPbOATGEANfqSFrQ0fIQHhSZ68vynxd3moZt1vQY+QlzuqgD4boZ7d1CB7egbegNjYNL7Aatw4wCWPTi5mwxVpa5OiQMEmEgLyVB07NXL3pSMkdFrYVyr4Yyh6vE7c6hZ8C+5XwPS+KnWRFPZJg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB6692.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(261026140227099003)(38070700021)(5023799004)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261022105027099003)(261021121427099003)(261021123027099003)(10067099003)(18002099003)(261102123227099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U1dEWDIrNERhcVdKakI5R0x3VWxkclhUWnMwWitFNE9yL1dlQWhaK2cwYldv?=
 =?utf-8?B?LzJWTS80c3VXYjE3OW5oVDJIUVNIVmhUTVV4Z3Q3VVMwZ25keTB6RjhnMVEv?=
 =?utf-8?B?M1I4RGhzcWpCcEZDVVI4T3J1eFNmd3RqV2toMUJXeVRpM0d6Qms5TXhDUFNt?=
 =?utf-8?B?Wms4RW1IbG14emRIeU5aeDNSWHJZTzhKSkdpOVlPZ2JBU01ERVVoRHZUbk92?=
 =?utf-8?B?c3Byd2hWSGRLYjEreXFld0lkWE5JRzMwNlZJRFR6NkozdFArZWVyNzZVaWRO?=
 =?utf-8?B?WUdYYzlZd2UyYmhjMkdhS0dsekJmaUR3bk82SlFSMVlmSDd5dGdodzY1QVFz?=
 =?utf-8?B?LzRyemxZUVNIOFlOZEFGTjAwRmZCU0hlSWFSZ3Q0akZ5KzlNNS9JUjNVLy9j?=
 =?utf-8?B?M3ZKcWFmTkp6QU9ZUDRWVDdyWGlTR2kzMkRoZ05tRytjSFZQZUFwU1JjWlRa?=
 =?utf-8?B?RTk0YmJYU2tMVmxHOG5naTdSRndvdGZmV0xNQURRSGh5RzJjVUxyTXoya3U1?=
 =?utf-8?B?ZXpOUExrNkRmTjk4WndvN2I1Z2xlSjRxK3FiZ2NMVFd0WW5JRll4bG5rS1U4?=
 =?utf-8?B?aVBUeTJBdEVXcUVPcHRSaW5UMW5lQ1FCTU9DNWYvVDlyUkx1WStxSzlmZzhs?=
 =?utf-8?B?UDBESGExcllKWnRMS2wvRUR0ZmdLUUJoMm1PbG1WOEVFL3dESHJWdXhjRFl4?=
 =?utf-8?B?d3BpTVh0MThBZlI1aitaUTF3SUhjcFZYbTI3SjYvOHJhdk9oSnIxRGFTRnJT?=
 =?utf-8?B?OUxEN2dVMlI4UFZuUlRlc3lrWVkzc3pJS2FMNnVnMWFZOHJuaVBvNG1kTktO?=
 =?utf-8?B?N3JPWVdHNnhNZXZySHMvMDF3VFV5bEVYMmk1QzUzSHJIdExnd3BTZGUwSkFt?=
 =?utf-8?B?UDdWZEFIUDZhV1hveW1kZGp3eFV2dFE5K2IzQXpVWW1EdzhBTEUvZDI1SnV0?=
 =?utf-8?B?dytnL3ZsVm9ueGpJZDdmeFMzYmRibHRwYW9idkFGNzJuR3ZoSm5pRWhwcjY2?=
 =?utf-8?B?L1hSZjNrUDlXTFdzMzFYNk42K1ZsQ0hzbGtxdEhSMHlrQ3pTSzNkZm5hQW91?=
 =?utf-8?B?NTk3SXh1TXpFekVwRDVzR3hkbTl1amJEcGVzeEF6b3NFMEpnUS9jR2VHS0ZN?=
 =?utf-8?B?Wit0MHFRT3RQSGh3cFZ1R213V25DcTZvZUI0RkhRN244dm1FT2lhTzNxNk42?=
 =?utf-8?B?WHVQSVhHUWdhMzV0dWpjb2doaTVTUHdrbi8xK2ZtU3hITm4vWjVZSDJJQWZB?=
 =?utf-8?B?Y0hhUVBSamFDNkZMcWZOTFV6YXAzSjZudzZHNFQ2WTdYZEM1THRQZEh4NmU1?=
 =?utf-8?B?NFlzWmhralY5WjI2L2pXa2Z1cGJoQjYwWHhUblZha3Q3Q0p4SzFBaG5hOWtW?=
 =?utf-8?B?RGxabW5pUWoxR0VhT2hrdGpCQ01oNXV4N05Mdnc2ZXN6L25kZWxvWDI5U0ZB?=
 =?utf-8?B?YUhGMXNVTGErMDVtdnFDZDBzMzZOV0R4dEg2dUJNT2g0eEhqa2FPNHlUTkR6?=
 =?utf-8?B?RGlPMkNqTHRKRkM2clA3QWMwa3FJWHpZMmI3a3psTXRaOHl3alR4R2hOVDIw?=
 =?utf-8?B?bjVzaU95dHBMdEVoQzlnTUp6bzdXTUNWbzRITlp0dkVsdkJPYjAxVWM1bE5S?=
 =?utf-8?B?TlU3M3lqd3RXNm5nTFhRTm1RZEhKQlEvUFpFb0J2SHRGTmIwY1Q0ZG1NOVB3?=
 =?utf-8?B?a0lZRllwTXd5VHJnaVg2eVVzRGZXVUQ1R2lZY24yT3NONXdlZ3UxZHBRaEk3?=
 =?utf-8?B?N3R5MEI5YSt5UXdjTmNxVllJek1aeGdydWFqdGRNUnViRlozYzNWVTBKcW9X?=
 =?utf-8?B?UkdxUXdxMlpyM0JKbHl3a1dMY09PL1BnM3J1a1dodnZvWlovTVlBWExuM1Rs?=
 =?utf-8?B?K044UWZ0REdJK3VHM3VIRlUzQ05uaHc2UE96NURyQkxyVG4wdE44aDNpNUJj?=
 =?utf-8?B?a3dCSWM0TndGU1Vyc2ZDYWhJdmE3Ykt1SjhhL2dKdUpwaWNNeXZVclJqSHEw?=
 =?utf-8?B?VlVUV3Q5Yi9pMkRhL2Q3ZjA0VlBVMzJBdHFBTVoxN0xvRVo0Q1JzblVJS1lz?=
 =?utf-8?B?N2FhMDdqNXFmY25YSjJNQnhvK2xYYXBFQk4zMGw3Zk13UW1qZjBXQktrczls?=
 =?utf-8?B?UlhKQ1o4QUlaTEQ4aHBxRnlqZTNNRG4rYzFZMG5wN2pzWU1FeGlQb0haUGYv?=
 =?utf-8?B?Sy84aVE5TDdTNEhSMElmMDZJMGdEYWk2MDlRcmhGdlJMdjhsMnFEdG9xZitK?=
 =?utf-8?B?c2ZYV0sycFZJL0tjTGt5M1ZIakZxbDB3bmgvZnJGM0NCSm9KeElnaFo2dGp3?=
 =?utf-8?Q?M92+pq6qYsfR2EvScA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <600AE3B2CF6A67488C6B4E435B0814CB@namprd10.prod.outlook.com>
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
	oPEIBV4FsW/JrRnlMJ31k3buoULpztS6oi3i+ctuCbhea3C052YU1vkRvJbvTV6ongK77RTGntfAJd/ug3dJlcnrukGIvdQv6s5baiLw9uLiHu8/O8NBqGxcDTpjqV7HsdXAP3JC6f1p3z/yB6mqf2W7/26meSNXkKKZy91lFQqhf8IJvoQ67TZF3QHMSNlif5m8tub+/4BQuQWKMtO4ests1n4AGRs0iu8ccJP8PIloBK60wGAQeCOzH+teZ++74XIuUuWhIQVutpD7WQJl/qBLjJsoAX5hb3Xr73fVZPIah7OG/MkW99WgDv63kdIbybkC3hwcSD9NchwrkfpD8w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB6692.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da8ab8f-b063-4f16-4742-08df3a74688c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 13:06:15.4431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Os/UTRE2u/McPwk8zajqwshGLeRpibc1fNx44PZ0mEguAh65tm9wyrq56Ee9KCiWapS0zbvMy44hA/5hKF9dCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Authority-Analysis: v=2.4 cv=DMsacCNb c=1 sm=1 tr=0 ts=6aeb2e09 cx=c_pps
 a=4QVYENZnsEoURNel/cbnog==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=VwQbUJbxAAAA:8
 a=sozttTNsAAAA:8 a=POIXnL_Lw1jeKPM8HhoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5myRSGFRUUEiR5803jJfo6Lmqz4ed42n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA1MSBTYWx0ZWRfXwzliDwFzPuB4
 oUjk8MZEJCGkM2PwELHxWMNzY98RkWqbNHYpxcn4c7Gx133Gl8pFq1Vwz6Iy+GDSp1ykbK8AMxh
 Uh3DFStGdKRzX1eSNidHZw5AiU8nEkjb05/G6bO4E68TNbzPO+CLOGz2siJh8WNdqsgDvgnkUMA
 fnotjubKHjMF38vPhWwbz+zTZZbdSbD+a352dkPEyH5ANqwkcxFzu8bFfy6AoG0YatKpFj4zA7o
 IxyYTGqHBtJzZP3L9xzyyUvuJ17kD38QzUZIhKF9EVfg4/v5x9pt9MyV88y98A5ZghIH1erOalb
 qJnKIJ8ODM1RtAPEz1IWo/UCpVOgnO3VfQm3y5fulu5DhvGNh+gSQUvwawZI0+obfN+YcMoPsZe
 pN8XCvfBiTgMEefze/5KRSPsNOkk+sT5O5Q6PhuwpDTnCVwcR6I/JSX9OLQ+vIraxt8YxqW6dPo
 mC8nOILAsfjYKJKQszw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA1MSBTYWx0ZWRfXwLycJNywvtKR
 ndSXKsOGhBtTEo/zjLxm7JhUooZJZYIdOUfKcur4L7c5Xh/lGVJ3uxWRUb0NJKvSMN4womAEzRR
 BZmuP/EEzTw/3/NKVTUW5L2x83MgsA0=
X-Proofpoint-ORIG-GUID: 5myRSGFRUUEiR5803jJfo6Lmqz4ed42n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_04,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040051

SGkgVGhvcnN0ZW4sDQoNCk9uIDExLzQvMjAyNiAxOjUwIFBNLCBUaG9yc3RlbiBCbHVtIHdyb3Rl
Og0KPiBBbGxvY2F0ZSB0aGUgc2VjdXJpdHkgY29udGV4dCBiZWZvcmUgcmVzZXJ2aW5nIGEgc2Vj
dXJpdHkgY29udGV4dCBJRCB0bw0KPiBhdm9pZCB0aGUgcm9sbGJhY2sgb24gYWxsb2NhdGlvbiBm
YWlsdXJlLiBSZW1vdmUgdGhlIG5vdy11bnVzZWQgbG9jYWwNCj4gZXJyb3IgdmFyaWFibGUuDQo+
DQo+IFNpZ25lZC1vZmYtYnk6IFRob3JzdGVuIEJsdW0gPGJsdW1Aa2VybmVsLm9yZz4NCj4gLS0t
DQo+ICAgZHJpdmVycy9jcnlwdG8vc2EydWwuYyB8IDIyICsrKysrKy0tLS0tLS0tLS0tLS0tLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4N
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL3NhMnVsLmMgYi9kcml2ZXJzL2NyeXB0by9z
YTJ1bC5jDQo+IGluZGV4IGUwMjZmYzE0YTQxMS4uOTY0ZGRhZGFhMjExIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL2NyeXB0by9zYTJ1bC5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3NhMnVsLmMN
Cj4gQEAgLTc0OCw3ICs3NDgsMTIgQEAgc3RhdGljIGludCBzYV9pbml0X2N0eF9pbmZvKHN0cnVj
dCBzYV9jdHhfaW5mbyAqY3R4LA0KPiAgIAkJCSAgICBzdHJ1Y3Qgc2FfY3J5cHRvX2RhdGEgKmRh
dGEpDQo+ICAgew0KPiAgIAl1bnNpZ25lZCBsb25nIGJuOw0KPiAtCWludCBlcnI7DQo+ICsNCj4g
KwljdHgtPnNjID0gZG1hX3Bvb2xfYWxsb2MoZGF0YS0+c2NfcG9vbCwgR0ZQX0tFUk5FTCwgJmN0
eC0+c2NfcGh5cyk7DQo+ICsJaWYgKCFjdHgtPnNjKSB7DQo+ICsJCWRldl9lcnIoJmRhdGEtPnBk
ZXYtPmRldiwgIkZhaWxlZCB0byBhbGxvY2F0ZSBTQyBtZW1vcnlcbiIpOw0KPiArCQlyZXR1cm4g
LUVOT01FTTsNCj4gKwl9DQoNCkkgaGF2ZSBiZWVuIHdvcmtpbmcgb24gYSBjbGVhbnVwIGFuZCB0
aGUgZm9sbG93aW5nIHBhdGNoIFswXSB3b3VsZCANCmFjdHVhbGx5IGRlZmVhdA0KdGhlIHB1cnBv
c2Ugb2YgdGhlIHBhdGNoIHlvdSd2ZSBwb3N0ZWQsIHdpdGggdGhlIGFkZGl0aW9uIG9mIHRoZSBj
aGVjaywgDQp3ZSdkIGhhdmUgdG8NCnJvbGxiYWNrIHRoaXMgZG1hIGFsbG9jJ2VkIHBvb2wgaW5z
dGVhZCB3aGljaCBqdXN0IHJldmVyc2VzIHRoZSBvcmRlciBvZiANCnJvbGxiYWNrIGFuZA0Kbm90
aGluZyBlbHNlLg0KDQpBcmUgeW91IG9rYXkgaWYgd2UgZHJvcCB0aGlzIHBhdGNoICggZ2l2ZW4g
YW0gbm90IHNlZWluZyBhbnkgY3JpdGljYWxpdHkgDQopIG9yIGRvIHlvdSBzZWUNCml0IHN0aWxs
IGhlbHBpbmcgYWZ0ZXIgdGhlIGNvbnRleHQgb2YgdGhlIHBhdGNoIEkgc2hhcmVkPw0KDQpSZWdh
cmRzLA0KTWFub3JpdA0KDQo+ICAgDQo+ICAgCXNwaW5fbG9jaygmZGF0YS0+c2NpZF9sb2NrKTsN
Cj4gICAJYm4gPSBmaW5kX2ZpcnN0X3plcm9fYml0KGRhdGEtPmN0eF9ibSwgU0FfTUFYX05VTV9D
VFgpOw0KPiBAQCAtNzU4LDIyICs3NjMsNyBAQCBzdGF0aWMgaW50IHNhX2luaXRfY3R4X2luZm8o
c3RydWN0IHNhX2N0eF9pbmZvICpjdHgsDQo+ICAgDQo+ICAgCWN0eC0+c2NfaWQgPSAodTE2KShk
YXRhLT5zY19pZF9zdGFydCArIGJuKTsNCj4gICANCj4gLQljdHgtPnNjID0gZG1hX3Bvb2xfYWxs
b2MoZGF0YS0+c2NfcG9vbCwgR0ZQX0tFUk5FTCwgJmN0eC0+c2NfcGh5cyk7DQo+IC0JaWYgKCFj
dHgtPnNjKSB7DQo+IC0JCWRldl9lcnIoJmRhdGEtPnBkZXYtPmRldiwgIkZhaWxlZCB0byBhbGxv
Y2F0ZSBTQyBtZW1vcnlcbiIpOw0KPiAtCQllcnIgPSAtRU5PTUVNOw0KPiAtCQlnb3RvIHNjaWRf
cm9sbGJhY2s7DQo+IC0JfQ0KPiAtDQo+ICAgCXJldHVybiAwOw0KPiAtDQo+IC1zY2lkX3JvbGxi
YWNrOg0KPiAtCXNwaW5fbG9jaygmZGF0YS0+c2NpZF9sb2NrKTsNCj4gLQlfX2NsZWFyX2JpdChi
biwgZGF0YS0+Y3R4X2JtKTsNCj4gLQlkYXRhLT5zY19pZC0tOw0KPiAtCXNwaW5fdW5sb2NrKCZk
YXRhLT5zY2lkX2xvY2spOw0KPiAtDQo+IC0JcmV0dXJuIGVycjsNCj4gICB9DQo+ICAgDQo+ICAg
c3RhdGljIHZvaWQgc2FfY2lwaGVyX2NyYV9leGl0KHN0cnVjdCBjcnlwdG9fc2tjaXBoZXIgKnRm
bSkNCg0KWzBdOiANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI2MTEw
NC1iNC11cHN0cmVhbS1zYTJ1bC1jbGVhbnVwLXYyLTIxLTE1YWI5MGIzZjljMkB0aS5jb20vDQoN
Cg==
