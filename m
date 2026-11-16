Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794852327;
	b=aqr5gLFn/c36Oe/VBeXOBqzKbWcPjjwodNinLQJgMDIfYzj6lrwLAPV7ZP/RNZ+M0pwm
	 kIg84VVANAwdYXT8FcxnbhezI5aWIKN2D33tmQi6PfM9C9rSiw+vAa3H/yVr5fECZjjcb
	 rHg2cVHSa8i0JPoe3jsfHMe2W2D1PqCNl9Jn3aZK5L+ViE3DP2/+Swd5sfjjnIG6bzbbi
	 c5//4vp8oPwd/ZSG6dXy9kH5sbnBzop2nUUacnFMEZkFhtaHIaYpSymHxUMs46cEOfuXs
	 kP3B78bQHechkKnep9M5WtJkAqCC8h7nk6F83NY4ATCsucAbW6ukzes88pz12ciXdBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852327;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Bb0Ua1tj8IBx19c50k+JXUsNy4SZPAYoi5OIpkvUcLk=;
	b=iU+9WuVhnn/aMOPhqPqeeFbA2Vsi8e8HEHc4eirOvQCtm+gvvQ+q6at3I0UfOAR0hgWf
	 3Lj3x7Sz35EsZjginICMW6IQwhamRjfibstM/yPGNyYTQvqi5p/F31qO3zJ3trtlPv5AQ
	 kg/K1u/TgykQfbqZnPSW2K7Z190lo6Ut0IdEr56lhGytnIdGVe3Dj8r3h7BSw6mojKlYm
	 8a09TI96ZEhE3fUYS7MDHfySfc+V3C6CakkGSpX1mfJGalAcHVj9DK3oC7E3mfDJh7EXW
	 aOJ/DoUgMeezkOAYPC2u/VxAAbdkSSwqFpnGRHo8/0rkPJ3R2L3o5nSLItCZT3zMw1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=lVVrfHtX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.24
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E9606A32C;
	Mon, 16 Nov 2026 18:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 643E9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=lVVrfHtX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNFUPXA19p+mKXmzES05NzqOBC1crUDarznZhnH0uJHhWbMn7lo8V0hYwls+pNEWsRyXkPyH5n95vRQFeBK57oFaowYXTM67d2kODQNwS7U6FqdqZT7caQG9WKCsmxBoqpeLcc1NiaRLuIyDEYV9gzjmBeLo6/IobWCQ/I0LcWw9L8/RePBk2k1Dza5EZoii9WWFtylo8f+5MLYXnY7g9TVLGJBbMAREr03FvHf1PRY+tm3XkM1h8GIeIwrgXR93sv26LlB6PMMRUiz9llGosrIFpso2WR9n9mpdVNO5FCw9EU3omDQ9Q30fsHLErfiEVZ7KjpLwzEk5XyL1kjaf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb0Ua1tj8IBx19c50k+JXUsNy4SZPAYoi5OIpkvUcLk=;
 b=GCho/F00j8PEjmt+J+Pfrk3HzA6TXwle8oAip/uCtMS/snXBZR3RFQcCGz7GMJeFeKxJ+kpkHRCuBOCUhvmZxorbq+4YZ361njFVyt8V1r/2QMh13UN9VYRAsbtGJjD0L4HIcqE0WLQSyDKRiJGuFQrBNQ1ptvXNEc5W/0Z2THAeavyGIDw6A3qEKC+w006snvqZaCMIKtc7Trvy8EXslqp6UOSOSd0ciL1WOAsq6dnkf1FWXCaBxrntxphE9jWSNDkOfz4cC6DsL+Vwec0S9EkF4+QNIb0uUY90XP37wAKNpHJLu2gqbQSysnjMTA10Xk64jkc/6qqnbwUauZZUlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb0Ua1tj8IBx19c50k+JXUsNy4SZPAYoi5OIpkvUcLk=;
 b=lVVrfHtXnZtA0cIEnQwS82Gjbl6uUD8rE5Trw0he5qPKs2bwEpogD52rrh9a+k4V0tFR8OLVrhounGgwy66iaCHEtY8HffqfffiqIjjZbHIOA/E2JOwQow0a2aFdznZd6rL7/wgWco0O9Wz+Mu4bQz9whs3UpNhsMX9mUYDi6QpAvW2GBPYMOW/Dx8x9P8cTQlO/Qe5ya4vT7+REj0lj2MShsxhxbHZr/3UasqFOQ5f3nBMXRB4bbQl0eJaV+O1WIDydyeOYQfwimTIDWd4cJ/Yt7g/YEdcJu6TQw5/jQoPCI9sOMJjnOcRhtKYRbA+u91rV1V+y6rLmIlHwQKsBJA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by AM9PR04MB8971.eurprd04.prod.outlook.com (2603:10a6:20b:40a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 18:05:25 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:05:24 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Mon, 16 Nov 2026 19:05:23 +0100
Message-ID: <20261116180523.863575-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114060032.872141-3-changwei.zou@canonical.com>
References: <20261114060032.872141-1-changwei.zou@canonical.com> <20261114060032.872141-3-changwei.zou@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0056.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::27) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|AM9PR04MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7ab334-0859-4673-d2bd-08df440c3022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|366016|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021121427099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	Po0J1spOFkllAB0rh8vNyBpqeQEMiKScwB2fj92VUGmED9p8r66rf4PgkD/tCMXGxfjJ/1COhplM0Miw1CPkjCgJitTtcBGBmaUND1L+cOFtxlE3rHmvRFMJvwVt5+XvITUP8CjsLWMX5zyVxnczg6CcSdfMnrLSvUwvhLwudiJ/MNP2nsqz0/8MtQG6R8Va6jvDUUfpb4YSeCzriyaW9YzWLh2RqYqrD/6XbQ2VvK8ENjpng9CEJXGD8/8aUlTTtDZRjMbWqtx4tDSctxJ4n5OgMk9OMLCBBNuPYiwmLWdtqExsZhCunr34oaesiUIRi0IFofmgIfG42S6ZhxBSQuEij9tVG8u3H8gs0oTNbXdFbXEieQ+/PzITO/hHXdEyvCHWPLsydDMnIk1C+ZLuqdKunRa7DbjFY7QvWmUsHoSmR5IB96jqHqagrBeHfdPekUChH3soWEx52Lfh0lRycCN2sVZS19fxhi8fHNwHXVx2DdfRDrkYd4F2Z2tPyeyqAhA8A5UY5XLp3zuFX63nW6qjO+6T+gX8IKsXeAM4+A1yNMAP/mQFdTWc3A4IGp+n4OZwnnt6+NeqSz7352aG2h532lZsIcIJesUA2iGXOHwdMOmbOepFOEq0ReotlRLH1izPGuYO4mMqwXZoZvvsJYiW615TJA3QkVf/1LyGYZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODdvVzA4a0Z6YTlWREU3cFFxMEphNGo4ZHg4RDZTMHNmSFlFSU5DTk5CRkYw?=
 =?utf-8?B?WFp1TlRoZDRNdXI5YSsxM3pkaDBKZjZ1U2F5TVNZS0lQcjg3YTlSNWpsZ0NB?=
 =?utf-8?B?K2Nod3lQU2F6TkpJYy9RU3NKNldaSUZHeUhYczIyZ2t0a210SUYrZTNwUFFn?=
 =?utf-8?B?V3lqaHhuYWZ4UjZiMUZRdFViU1NBbHh5S1JMeklQdXdRc2o5MGtiOFdmMlNj?=
 =?utf-8?B?UWhxSTRBZTNGeFVGVHZvenJoYlZYNTRzRlUwTlFhQkpoQ1RNMUVjMW5qUHF4?=
 =?utf-8?B?U0JIR2s4TWw5R2JhdURHRWNSUUVlRGFDQk1MUkVxaVhrdnlKdVRhak5HaTBi?=
 =?utf-8?B?Sm5sY09CK1kzWXhIZk01UFZsSDc0S0F0UTNNZTM1T1pHUlQ5akVHZHVCYVBy?=
 =?utf-8?B?cWZiU0FFK1B6Y1BCaWVXZE5VcXBHWDdkWUptNTRDNjFobWM3bkpRVEV2c2pn?=
 =?utf-8?B?czVSVVlvcGpLbnFtTmZZZGdzbDltSmxiQVhnMThMdy94MElWdHdiTlhJNTl6?=
 =?utf-8?B?aHdGc1VQTWYyRjRUTDFQelZiTE5hdWZ0YzFDYXFvWUpIYldzRUovT3JaK2Q5?=
 =?utf-8?B?WUxNamJCZkZEcllJZE5keS8waTZGUXpTVnRCK0srUWY3WFVvZ2VrSDZtdTdP?=
 =?utf-8?B?ZjRaRFZvbE9ZVzdDQXNrWjBva2J6TDdzTlBrMjZyMWp3LzBnUXZLUFNMTWoz?=
 =?utf-8?B?dTE4eE00aHlvTXJ0SVBqNVY3L3JhOEpnUWVOUk5hc010TWduK2wxQS91cWNT?=
 =?utf-8?B?c1VWcDdZRDFjellkY05TRWUyUU5RMHNxQmNJd09pWDBZOGYvTCs5RHUrT0Yz?=
 =?utf-8?B?WVlsQkJxaEMzemFsQmxZbUErRmNtTHlHd2xjL1FmM0hCYmV4cmxzakZWQlBj?=
 =?utf-8?B?dDFZSmNsOFNJMEZ3Q3Byc2hKN1R1eEJ4SWd5UkhCZWkvdnFLWUEvazFpZlRa?=
 =?utf-8?B?Rk5wclN0MGJrNjlsRjY0RjIwMGgrYVltZ1pzMUg2dVZRQjdOWWs4cldGN2RX?=
 =?utf-8?B?U1hIdmgrbjFERnlrL3IxZXJKZ01jUlN0SHJrVVgyN21iUWp2Y0o2dDlSTDIz?=
 =?utf-8?B?cEh6bGFWSHZ0NUpvUWwwMnN5dlA3ZU9qNnI3a1JUOWVqV01YRUdyQUlQRXVw?=
 =?utf-8?B?dmNlRDA4QklYTk1nV1lxeDc1V3M5N1hpVFlnOUNxVGhwWGdZTFY5dVc1N1l2?=
 =?utf-8?B?a1Uza25xUW9Za3oxOGVqczJ2dmthUllvZ0dVQlR0U0gwd01DMlo5RE1MeVlR?=
 =?utf-8?B?U3UwRnZEWGQyT0dyemM5d1Vnci9KYkx4a2NVQm1wUFU2YmlGdEhCVWI1TmJw?=
 =?utf-8?B?WTRVUHBkS3NXaEM2T1ltMEpZbDVZMUxqNXRoZkNHdzRscGJBU1VyM0NpcUpQ?=
 =?utf-8?B?NWtpNkVUeEJzMzZnS0ROdm90K2ZMM293NjdwbEliUXZwTDI4NjkyWDZ4c1Rk?=
 =?utf-8?B?U1NDSVdyR1IxMUc4RVpDUk5qZG83WmtPQUliTE83SmlzaTRLeXY4VVh3blRq?=
 =?utf-8?B?QVJyK2lOVElQWEd5MXMwajN4c1NrTit1L2Rnd0hkaG9LVHc2a2NYbGhoSEV4?=
 =?utf-8?B?QmNVMERDYkgxenVsUEN4MndwSUhTZU1BZURPRXNhN3djMlpSblcwSjNDckN0?=
 =?utf-8?B?ckEydURPajVDSmhacmpURkp1eDVtVFNoRDd5aC9OTDNLSjMweTg2MjdudWI3?=
 =?utf-8?B?WUtMRncyb05aVHZweUxQVW1ZUDhjWGdzclBIRE50Z09oVkwyTHB3RStnTHli?=
 =?utf-8?B?cTNBM1Z2ZUtrV2RvWWMxZjU1TWphb3FybmpHaGJKQWExUXZta3dmUGFGOUs5?=
 =?utf-8?B?OWtCOGtFQWZzUXZRUVgvTU4ybWtiMFViRUtJMHZMYmVNeEdOUkRVVGFiT2xu?=
 =?utf-8?B?U25Ma213OGNpT2NVSExVSXQ5ZkFiNXh0OXdLUEpvREZUWnpvU1pKRFhrbHlD?=
 =?utf-8?B?Q3QrN1BEMUlaOU5VVlI4d1ZIQzRUVHQ3Y2hOODE5RXZRa295TllsYXNwWU00?=
 =?utf-8?B?WjUvUThXeDJLOE42ZjAyTjNRdWUvMXAvQjhWb2EvbXNpL3Ava1YxdlBEUWxF?=
 =?utf-8?B?YTZ5NE0ycTB0ZmR2V2hkN3luR1AzR0QxaE1hYWNxN2xCZTZnOXdIOWtwYlRr?=
 =?utf-8?B?RHRrQ2dISlM4K1hwZmY5ajFIWGFaRmczeEdCamp4aVZ1TldOYmliVkhnUDAr?=
 =?utf-8?B?QXRDOEFTVUVzZHlOeXRMTjhaZGZIV0pHSFdac0Q4d1UxS0VRbGU5MllGLzg1?=
 =?utf-8?B?Q3MyQTZtL0lNMzFnWTU4TDBtLzF2RFFCb2dLWFVGcUx2NmQrNnY0WjkxUktN?=
 =?utf-8?B?VGRLc0FjRXprSEdZeGw0N241d05pd0V1c3g1b0FFSWtkYkZVMGlsRXRaajh5?=
 =?utf-8?Q?Ga/9u8LhRV4fQDKCc1fbEJJjRMqQu9jZyvoDm?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7ab334-0859-4673-d2bd-08df440c3022
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:05:24.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGpRA/J9PIHgyDc7f0ZIfvXbGyf00RJI1e/vtM+8PrIJNsdArKNp1/vffyRfHkPJV0Wb+2hLWwDjmaCFdFLW6z8IYtrKPL/cNjOff3zODeIt/J0gc5N2XbaKlWNowA92
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

On Sat, Nov 14, 2026 at 05:00:32PM +1100, Changwei Zou wrote:
> The rsa-caam driver directly DMA-maps the destination buffer supplied by
> the caller via req->dst without checking whether it meets the cacheline
> alignment requirements of DMA-incoherent hardware such as i.MX8.

Hi Changwei,

Thanks for v6. Using req_ctx->fixup_dst instead of swapping req->dst
makes this much cleaner, and the commit message now explains why the
DMA API does not catch this case.

I re-checked all completion and error paths: the DMA unmap always
happens before the copy-back/free, the -ENOSPC retry and -EBUSY
backlog paths keep the bounce buffer alive, and the new bounce_fail
label also fixes the src-map-failure path.

Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>

Thanks,
Sahil
