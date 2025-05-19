Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazolkn19010012.outbound.protection.outlook.com [52.103.66.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E61026988C
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747642933; cv=fail; b=cY6J5aaFR9jEelnQWGR2yUHRHib8ZjahIBann5s+LV4cQ+tTRndxlTkLyfiF2vLSGFGODr2Zzn0ZjmUtUM0ZgnyFCEh5Jtk28nbsu5U7oMrifp6ulxxVC63LIt1xUPDO/DIu6xKUirq/oiXYeIlYezCDqAkrtH8tdIAH8bF0VA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747642933; c=relaxed/simple;
	bh=mz30VeZrXcvNfFx8qER7v6Pwpz0JvG54YH3vgf3d0ds=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=BYetEUWqCI2D9mszAZa+FSM9HWoxxt+6bk3nEtXvRO5OGjsgYRRHxWGD+nJstcZZ0P9tEwJQ0xZ0zFrbm6UtLScyEidQ/qiek0Fv9BiV2+VJUG221uBWc647uKvC6sW/LFPtvGCvwZ0XFv5wJHf3Z7iQf0r+w8W9/VFQ6mij1fU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=m0eh0R75; arc=fail smtp.client-ip=52.103.66.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="m0eh0R75"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yEaUs9I0ekAJ/THKhG8yGyrkngRwiV5TSsw5Xu3RXVbRoOOLvkpYEtQVji5mmE+0EDk6ZqgylTHwvresbdUJJHWMxlublVT4iHyboqVyGEdhH2s8ToXSOXXSlFbqu90F/feRQgbdQEoNrQ0n3kPZ1pfeZl6+P0ANjyGJ2AUx9Mf5eE5CRA/jlfFwq1wUu06pymkLdAWIaWNTOQq9HJUfjC2tsfHZAuH1C+YlGHKiYgD2gGquxTgEt/71U/M7pGw8eQmadQkp49o3+E6fYOafv5vpgTMv6o/i1eqp3sQ2k7tDGNmTHZkcoaH28i6zE9glEpSqb1nZnewWP/mPO3E3IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0ymBxrjGemgQhqPq4DPOvQ7Zp9ix5rKO1QuMq0RHrM=;
 b=ZDda+7QQ+Q6biqRvQMvSphTlobA7jjtZPFbCZ8zHQzewabF92luBltiJhHsm5ANSUsSDJLOAIz7wP30dqdPSIIGd/rnwkpHQLznFtR1AsuabQx1BbOGGbigeskUIz/NCYdLS0/NphC2ATtA/XGPMXDRtbKMvirxn2B/eLGyJOe4gyn8y1duZ5vN/NRXoy/8hH/BhTKXuo9tKVnB7t+pW0PISRrjaunaDZ2MKrQ0RORtV1I4Mnpmkj9M7OfxZZn1C07Mlc6vNgPej49GsTaeNX2IUgU3GOflxhJrrep4jcDwLd0ZzvFfXiDl2Bh07iIP9v8WRMaRxVG8525XUjWPlow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0ymBxrjGemgQhqPq4DPOvQ7Zp9ix5rKO1QuMq0RHrM=;
 b=m0eh0R75WEhTJUy8WPFa4xlUw/KJ4xO9Snsb1VilZFTint2YYfNacq6gW+Tn4ItSFcDm3hPFRDfqjH+idJFb2+QHx4u8IW1atc3YjxRxNTJgwnndYaAITGnW75vfGDH9ZFUfONBgQjnpDyOlmiQIlq3K4XnE8vrM30mPOsbBPC4CfEmV+8YbSNhPXYntJ0p/LcTsSKtXV9p6gaahPebA61vHD5FnOMONcG0v9a92XWMuRJC3ImnuU/37Ph3g+W9RL34/rLjNqy2jLt/Z5apRqdOpL45U+B+71/IioQ/yJ1cs5wmk+aZR/i0QwLgyuBo+F1cU8GSuokShpCrODTUqSQ==
Received: from TYCPR01MB7577.jpnprd01.prod.outlook.com (2603:1096:400:f6::9)
 by OS7PR01MB11852.jpnprd01.prod.outlook.com (2603:1096:604:247::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 08:22:04 +0000
Received: from TYCPR01MB7577.jpnprd01.prod.outlook.com
 ([fe80::fd42:194f:1f66:7d82]) by TYCPR01MB7577.jpnprd01.prod.outlook.com
 ([fe80::fd42:194f:1f66:7d82%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 08:22:04 +0000
Message-ID:
 <TYCPR01MB75770ECA9EB78E6A58A7E553F09CA@TYCPR01MB7577.jpnprd01.prod.outlook.com>
Date: Mon, 19 May 2025 16:22:00 +0800
User-Agent: Mozilla Thunderbird
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
From: Scott Guo <scott.guo@outlook.com>
Subject: [PATCH] crypto: Add a null check in crypto_free_sync_skcipher
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::22)
 To TYCPR01MB7577.jpnprd01.prod.outlook.com (2603:1096:400:f6::9)
X-Microsoft-Original-Message-ID:
 <2a0bdd3b-8e47-4b61-abff-68286a529a7b@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB7577:EE_|OS7PR01MB11852:EE_
X-MS-Office365-Filtering-Correlation-Id: c04974c0-c88c-4c53-fa9b-08dd96ae3c58
X-MS-Exchange-SLBlob-MailProps:
	WaIXnCbdHrMi34iUpeHrvUBJkG+6rPgnhrPAv6D/EVlp39y5ojOpRl56psDoTl3QVGYktUIjof1NZk24UuD5BTcIFkK0Xcl77s/ICDERtsvCSVFUniZxcCqBUlfTk3z8WFGFhLBFOI27S+GgbKRTSnTXjZwPcD/xrVU+n6lm/LeCK4a1cWVEba+YIGl89yy8ZivClj34pzONZiJiuJylIo7eR2dSNX5IJwFBC4+mzpavkmNsPbHCdoN0zAcd952z/+Y4ze9uDDs+1ZyMZMGkNIzGYozXS2V8lbvxdvtqcFEWY44MCl4JyC9JE7aCZuLY0omFZaYHe6xb1rT9UsdXURDs4of3Agg4Azp+n2Hcmra1HqGX+FBqfK7TVVGYVleMMLInmrginTvlTNOC43/EFLPB+LthfriEEcZn+iE48iiICp7Q7IWRAJb43a79LS73uUA8bBCuqTdj1KZ4i96JkKfe7Ha6f0kwIWraWr7D7zO/PVI55RrxQ7ohy4YbNL1u0quOmsvmD1pPo0sJ5zcqMQbTYlyE2BF0DQogwuvTOH3xZ0Vpyx5YmuM/5y/Jt/4twp3MUxx6MiQXy4m288H2mJcRjjW/j2U0wViTcSIWMGlED2Aukt9gwzzwOavFC1NO80VtRNHR2K8vYNqiMFh3jdld4ZUu5guFC/5YXY0BM1c1QigyC485bdiYTVtwV0ZT8tzBNlmLJJj+C2pReLxB6WQXISD20hoY8XWiGQEReDJ4P7+XNhkltY7pGXlxOwbEhU2uwPN0K2E=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|6090799003|5062599005|7092599006|15080799009|19110799006|8060799009|5072599009|3412199025|440099028|12091999003|19111999003|14041999003|11031999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlJndzFiZ1AvM25kYnlxZXJHTThVaUdFd2tzUXp6RXI2MDVtMFVPbnZEQ2c3?=
 =?utf-8?B?RTRVQjRsZExxY3NXeU9TNjBEOFdXR2U5c1hOUG8vRCsvODFPV2ZNSlprbHU1?=
 =?utf-8?B?R21meE9Ma0Z5RG45V0JpclhzVnRKODBaUjA0ZVFDMEhaMm1haEkyRFJpTEt0?=
 =?utf-8?B?MnNHRnowUzFvdkw0Z1A3Sm9EN25YRko2bEpGK1JzZnJ0MjQrbnFJN0hiWWh5?=
 =?utf-8?B?emw0NkxDSHl0cnlnejVReUk1QS9xeFdOQmt4ampZSzk0VE1WRjV5c2ljTjBo?=
 =?utf-8?B?WmhoUmoyY2M1RUttVTNDSTBmc2c3WFd4K1pRM0ROUGFTRDNKd0VJRVNNNjlV?=
 =?utf-8?B?UXA4Y2ZsdVl6VmZCeElYY3dGM0tWb3JFTzFzamNLcGRJb2RCNWVsRkdHeWQr?=
 =?utf-8?B?UzVHOElZZVVFdjBRVDBBaEpLR3ZjZ3FkNVgvVjZ1by9tTDJGbkVRZ0hzV3g4?=
 =?utf-8?B?TjduV0VUUnhCZmROdkh4ZlNYM25HUEY5OGhEZENZMmd5TEtKYW1QTUFXVTF5?=
 =?utf-8?B?dllsazhrWmpFaGY4ZnUyVnJZYzBHYWFVeGg0cVpZemlTeVh3Z09YSStnb2Q0?=
 =?utf-8?B?UDh0c3NrNWNwVFB4Uk1aZ2lUeTY3Ykg0ZXE1TThZMXB6WUs0SFJDWXQ0S0ZD?=
 =?utf-8?B?QTZBMnRNbkR0dGhTbWt2UWRXLzJQZmhOc2c3S09qTkJnM290bXQ1ZHQwSWIz?=
 =?utf-8?B?NCtiM24reWxnNDRFV0xPMHJaYVNwcUVzLzE1SGlkMm4zRStaQXcwcXhnSWd3?=
 =?utf-8?B?em9xbUh1ZUdzL3VmejBSV3ZxNTZTdHljQWZiRDF6MW9yUWZObEx0NDdhM2d1?=
 =?utf-8?B?VzZNcVdGN28zUC9EVFpjSzBPZ05KUFVVZFlDbExCQWd0NE0yOW1XU3lkL0RP?=
 =?utf-8?B?SEN2N2xwOTBOMExRRW1PQTZaditvU1BoQTN4MVZPcDIxVGRpekRJQ29HWFVi?=
 =?utf-8?B?RXo4NHJUL3R1MVFaa1FvaVBKczZIYWRaUUxhUHFMYm1TbjdZeGN4SjI3emt1?=
 =?utf-8?B?WHhmbThyQ3YxSm1QN0cvczc5YUl0SlNFUXNwY2diZU5nb1dRb1NXWURuTElU?=
 =?utf-8?B?em1NUXdRWExqdVFUejR4MDJFY0FkVFJyWllJS2xzODR4MXFsT1RPMkFoekZl?=
 =?utf-8?B?S0F3MjJmU0t2SFNZWWZoeHdjVU1OcWg5OGdvbkVPVW9RN0QyNTQrNGNYVE9H?=
 =?utf-8?B?b21mUmZRSkQ1Wk8vOFU0dUNGVUJhNDUxNjZGOHZXeDVDbnJ4VHd6TjdiMXJJ?=
 =?utf-8?B?ek55eUZ6WTVDQnd4TDU3dytlSlVzUnNpSzhINFE0anIrRWVnd24rOFZ6c2Rw?=
 =?utf-8?B?UW1PaHdCUCswKzBxY3ZzUHpDRUJ2NG5xR0NMczJRd29jZ0tlaVF3eHIxRE81?=
 =?utf-8?B?WG9HUUtjdTVURldIUXU1Sld3SkdQS0xjYmNvSlRmZzBNSmZROUNwVURWZU1p?=
 =?utf-8?B?ZmRlWXFzZkQ2dC9rTTI2M0JOWVV1MXRDQTBIM0l1TWdJcTNNRUJ0Z3lONDg0?=
 =?utf-8?B?RytnaWNHWi9Da1NuVjRkT1JYbGI3QW1wclZGTG1aV21NdUMraThySmtXZ0Ft?=
 =?utf-8?B?eDZ4NTl3YXZudWFoNEdVYWtLRnJrSWo1T1ZFajFXZjY4cGVNOUpJNm5mY3Bt?=
 =?utf-8?B?RkM1aUZ0RlFreUdvR3gzbzJMZlliQzlpb3Rkc2JRSDgvZzdtMERhb3R4Tzly?=
 =?utf-8?B?WGEyOWNkTXpNZVE2OWE3Z20veFl5ZkVFeUtvOVNRL1dCa1R0SGVnS09vY05o?=
 =?utf-8?Q?AcCLZVrZuuzjYzuSl0=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUl4OXZTc29OV2VKV1NHWnZ5ZHpodzlKRjRwK3ZWU2cxTlUweGpYb0FSOGx6?=
 =?utf-8?B?ZE4zZGJXRGtqN0hqNk96V3VwNkEyWVp5TWdXQS9JTVh0cnZKZUg2MnRWRUJO?=
 =?utf-8?B?TFJDMk80NmdzSWxIVTRieFd4T09uRGd1cHQ2Z25uTnBuOUVrbE8xMmJXZUpX?=
 =?utf-8?B?L29oWUNlQ1l5ZHJWOFAwQTZiU2JPS2RPUGtFSlBqRlhjV1FTSUxTK0JQZHUz?=
 =?utf-8?B?TW1uOHl3Mm03NDI5clN6a3d6YVFlY2ttT1ZmSUNDTmhPN3o0a2U5MGl0d0tW?=
 =?utf-8?B?dWhmSkt1VDNhRG94ZTJyOTdBRzhnZkE2TjdzcGF4L3pjcjFVN2FBcCtseHdm?=
 =?utf-8?B?TnR6UUIxeUpRSllyVjYwU0ZwNDc2cU5qUEh1NGVpWTRnNlpKMnlYN0ljOUk3?=
 =?utf-8?B?cmViMkJYSmx6cjM2aitLbEVKc1pZMCtvbUxvbFRlb1FqZG85UnJxWWxFTHIv?=
 =?utf-8?B?WXNrWW56U2JLNW50bERwRmUwajJUSDQrakYwenVWWVp6UkRWcG1vbmVsS0hy?=
 =?utf-8?B?TUNzalFaQmhhSVFBc3BrTWsyWVRLRU5PZllGOEV4SFlFVU1hSFNzMU9jeXVE?=
 =?utf-8?B?TEI3Znp5SzF4OHhacU5KTkF0dDJSRCtiUHd1c3EzbHBtSGhacVVqZHpoVG1C?=
 =?utf-8?B?TjBJNTZYMU1iUktvMU8vNUI1NlcrRmMvVVlnazJON0E2cWlKL1FtcmQvYUJN?=
 =?utf-8?B?RTZQUjI3eENUWHY3S2tRSFg4eXVSaHhSZTFyQ1lZNXYwOE9CV3B1SUpNay8w?=
 =?utf-8?B?bkxNQ2pQcVMvaHdXNGpldEVBQ2dkL0FLZVJXMGZvdmJVZThTS3d3QlJ6Y0x1?=
 =?utf-8?B?bExqV1NoQXNEa1ZCTFI2NWM0L3REWUNXTU5MeXE4V1V4aVAvVjNtTTJYMmFv?=
 =?utf-8?B?U0VMOTVaTUlZOERoQlMwRWxRdjltcmhhZlZKRUV6UVcvQ1JtaXAxUUh5UFRG?=
 =?utf-8?B?QVJ3TG5ETkZPdXFERG9KWjJjOFl6eG5lK093YmFYWGFGUVhTcHVETHZGY2ZW?=
 =?utf-8?B?OG0wYTdoa3ZSbDBSeStSUzNKNlpPenN1RUs0VG5ZbUFFQlNKWFpBVUkrN3Nu?=
 =?utf-8?B?eHkveE5lYzJDRlcrajE1bnFzTGRuVk9hanNibFpuNnk4WjhOdk5qOE8zb0pR?=
 =?utf-8?B?Y0wwREQ2b0JnU0EwUnBpOFo4KzN4R1BadXdJSGhEZXY4a1c0V20vUUhBWGxQ?=
 =?utf-8?B?UENVekZaTzNYaGVMOTBDS09wc3FJNEYvNElIOGdpYm8zWVBYM2VQUGZ6WGo1?=
 =?utf-8?B?OExrUVJKWTBwZlR2dXhiMHplOVFyMXNGOEV1SWdnNFozOHQxRC9lSUFLNGZJ?=
 =?utf-8?B?ZW1zVGNGd25SeldCblZXRy9MVWtXcnRKbUlRRCtKaHROMzNLRk1jZDhjZ0t2?=
 =?utf-8?B?NmJBdTF0djZsWDJJMEF1akRwRHN3TnBHY25WNFdWMlJnMTV5MWNNRW51T3l6?=
 =?utf-8?B?RWUxdWhUTnRQd1JRNDREZllqY0JMd1Q2eXN5VjBUbTZvV1IrSjVkOGZQUDdZ?=
 =?utf-8?B?N25FM29MRHhydlRPMVhFMVlPc3ViOUtqRXRuRGdyRVhvZnh2THlIaStDL3R0?=
 =?utf-8?B?WlB3RUxFUnRJVnVMaHJhYmRnNVlkaU9QQ1hhbGJmN0JFWkh4NEk2MHNhUEI3?=
 =?utf-8?Q?39eq8PTCS+eI5V3SYFWWT4nbtwX1ARtqeZgplDGsZ4Cw=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04974c0-c88c-4c53-fa9b-08dd96ae3c58
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB7577.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 08:22:04.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11852

 From e2f7cdfd4522c6ccd02a4e7449df2c24a508e2e3 Mon Sep 17 00:00:00 2001
From: scottzhguo <scottzhguo@tencent.com>
Date: Mon, 19 May 2025 15:36:31 +0800
Subject: [PATCH] crypto: Add a null check in crypto_free_sync_skcipher

Commit dcc47a028c24 ("crypto: null - Use spin lock instead of mutex")
allows NULL to be passed to crypto_free_sync_skcipher, which would
trigger a NULL pointer dereference.

Fix it by adding a null check in crypto_free_sync_skcipher.

Cc: stable@vger.kernel.org
Fixes: dcc47a028c24 ("crypto: null - Use spin lock instead of mutex")
Signed-off-by: scottzhguo <scottzhguo@tencent.com>
---
  include/crypto/skcipher.h | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..83660d678e0d 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -331,7 +331,8 @@ static inline void crypto_free_skcipher(struct 
crypto_skcipher *tfm)

  static inline void crypto_free_sync_skcipher(struct 
crypto_sync_skcipher *tfm)
  {
-	crypto_free_skcipher(&tfm->base);
+	if (tfm)
+		crypto_free_skcipher(&tfm->base);
  }

  /**
-- 
2.41.3

