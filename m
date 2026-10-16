Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010028.outbound.protection.outlook.com [52.103.23.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149EB3D3334;
	Fri, 16 Oct 2026 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170546; cv=fail; b=rEEyJg2xIrYlbVxe6RJResEBLo+ndByigOoZLpZA3rOWTze0cbqbHgggNAp1kksvjbaOQCHoscOUF6/NNe5bKLQ3rglVduIwGlAf3qfu9/sy0t/W5uzNPE03ILJQK35qSKIjeKT52U/PkF1hhQgY+CkWtREvF6rFy4QHkMkrYXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170546; c=relaxed/simple;
	bh=692rPzSNrzgi/RzaZDXq1mkICCNmnXomC7ip6vFJzx0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=U+GoVdd/ZNzfAYfKNUAeWuLNrNNK6WAVbrJ0zPe/yHowpJVqFqxJZThCWakLTtcCkRU0iShY1sncanveZ0Nb9PlaT66nnX3K63Pb4yeXmZYV08J639/mYSI1Mi9hTSAeBBDpAHi+rX00FjsUemksWxTb4eMK9lcR+XyEe8Ehu2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=qbwAHMmN; arc=fail smtp.client-ip=52.103.23.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="qbwAHMmN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/qwZrCToQ84RgzHR1OqQbDsBUGnm/wbo0omb5Zgi7IgP6Zb1ywi2QyEAbNAp0PcdeRuSBTBdTTyrTt5MvTAmtLx2mwKmoixEFdP0aUU6gv2WuWdi6GdM7d56m5uzTp3CMK/HliNBELDOHCIga4rSSCV8nlL6izC0+/tNF8JgInSuEzY7itYbsn94SjXIOOl+JqEIg1J2xEzPkeWsU4KQafKQPj/UcPSJXIlZB3INexOhNJhm/YPs7ajpeC9wRowpRzf9pR5ZJkgaUdbBhJzXAXIln/6Ub4RHj4hxtw+ltyF/ouoEbHB1L+iPGotIQ4rzofyyDHIqjR4Mvs7zTOB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=692rPzSNrzgi/RzaZDXq1mkICCNmnXomC7ip6vFJzx0=;
 b=Kh/h2ZE/6hqZPFow2GgkZ2OR4Wxz/auxDRYtrWZyoMjaTl9OeoWseDYD8kDaMz+KWBeJ0dIOBq2HS6eXdziY9uLn3Ict5vZNNzMbFHdSWTIEHUeh3KlNlQWskVvqA0vpXYPZ4ODTuiYyW/Iw+aI/Slljs1tw+cG3BEnq37Qj+RCDpd2KraIZygzU99+un5Jyqx3RVrz2goCFD9Ka7hqTtpitespPrzndjTHEHF5vZdkXRRME4vN5zRhKRhtr9NdIWZ9and/xzAm9LcNJF54tAX5qiwFrrVvE7BAysEV9/7mpqoNJlqjoZmcmWyuWNIlBrqiTFywtnJx5GhEB9ZN22w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=692rPzSNrzgi/RzaZDXq1mkICCNmnXomC7ip6vFJzx0=;
 b=qbwAHMmNSw1SaLEDY0Y06A6puld4naOyeHDY+BmIlT5uCQPhEzFMg/u1GtpXQwZpSgtAix3UdFOvUh+bFfngUglR9GRSOkkuGA6Ay9ArdXX/xsS0gvvxDi/TSNcL1JO9IKYRBWeobTaWl+Gp0YjyDWQ1a19LVVd0yK+AANHjELIy+MIJkkaJA/oBAucN4DSL3eQqz/gYmArN4Hq2m0zHhj6Zk6PsfLTFr2vFAI5clD1Yb8MTMax2fH0fNsGRlw5dUN6evktzzCKvflPajzHYHAfMHyvQxdbXb8UHIqn31Rmvme2LkB6xph3XPEjwd6hGKrpD2ZQ9dODcB+egmcx4fw==
Received: from DM4PR84MB2048.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4f::20) by
 CH3PR84MB3571.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:610:1ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Fri, 16 Oct
 2026 17:09:03 +0000
Received: from DM4PR84MB2048.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f006:8d9e:955:892b]) by DM4PR84MB2048.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f006:8d9e:955:892b%6]) with mapi id 15.21.0522.016; Fri, 16 Oct 2026
 17:09:03 +0000
From: Sean Snider <ssnider5@outlook.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/lzo: check output space before writing the RLE header
Thread-Topic: [PATCH] lib/lzo: check output space before writing the RLE
 header
Thread-Index: AQHdXZELIX2LR1Dwb0y3UMeV56pNiw==
Date: Fri, 16 Oct 2026 17:09:03 +0000
Message-ID: <20261016170857.44908-1-ssnider5@outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR84MB2048:EE_|CH3PR84MB3571:EE_
x-ms-office365-filtering-correlation-id: 0a52732d-1501-471b-526c-08df2ba82df0
x-ms-exchange-slblob-mailprops:
 ScCmN3RHayHq8QFbWW6Ra03gxaeZK6u4uf5jw7L8y/duKwnpwVOFuX8UYvCulzMv8sxhk8NAmglFWi90oFLYpiqRRVyxwOkYn3sRkBl8osKZWnpmou+lku5zejVIjZZYNfskwwR3JRBXL9uNXmEzdyYZxiElMkZGk8JZWBhrIsGyVdZGbn5XkvVjFQj8CLhnxFSYP8VrjQiEQHE7DTkr4gpgr6JEmV16cIcgRukTftrSGGPJmCk1oqo8ny/vr05n8nmHnZIrCB5gn2FgkqqsZVxqfxze2CnNu2C5cERnoJ7S0dJFOeyAACJV6WJCpa7YzLOa7cH5HjLiUMBLWiVS5LObHVNSWXx49yNf7fQA4XzC6rGMPzY1Tmcrb8s60qwKVVaV0z5WKCuMFGDcgeLytJb1uZucNPHcDfWH+OM+F7DexDlRlF4IR2vx+fGJA85c7SAjQSdRgI/JOPWYcmP9QhltlLMgbIZGWBD55LNW3DUV8NvbhVaeagQijHKpiPPWYyTObDcR4UUBQhaP+StO9+umJKN9WsywvgyzILRlxI03zGTyaBThdsgGMMI+qg65dAeQsV2/U7hayagngMPTByI3GsW+Hef3OH2oiB2X5SUA6lFBRmuzTTnyFdLetub9W3yXA3QABvTAD2vXi/8VEhUNJ3vzeKCIWld7pmiXj1fcYZnquCTKkKEaSW0F3ScxoW24Cj0pXz+7+BIH0vzvRNS0G5pH2Kl2Q9CRVLISJYQ=
x-microsoft-antispam:
 BCL:0;ARA:14566002|25010399006|20031999006|15080799012|24021099003|4140399003|38102599003|8062599012|19110799012|12121999013|8060799015|39105399006|31061999003|40105399003|102099032|440099028|3412199025;
x-microsoft-antispam-message-info:
 =?utf-8?B?MUJOWmpHUmx0REtBVE9SNHlvNlJKbWkzL2dUeVovK3RLVjJyR1JSdmxNbFpo?=
 =?utf-8?B?UDdyRWRycWtvOVhKTlh6ZlhwQnBuSmlpSkdXbGt0bG02ZWRBUmFFeUJYMFVa?=
 =?utf-8?B?V2c0TDNkbG8wSFZoVkRiZTZMUmdBQjRlbFpYOUpBQjZBMmNFVWRDTHdJNXU0?=
 =?utf-8?B?UytlWW9KdjhKd01ONDBZb2pna08wOXM5Q1QxTGVmMWlMNnZtckxlL1Rxandp?=
 =?utf-8?B?RTYrZysrMzBOUEV4SUdXemxyMGZmU3FoWnJ4M090emhzY3UxcFhVSWgya0RZ?=
 =?utf-8?B?SDJiVnA2ZVRVbC9jc2VwcjdoTElyWXJXbzZTRk9qRkFUVzU0b3c4RG50djV4?=
 =?utf-8?B?TWFBa2taNmMvTlZwbVFjeFAxUmRLSlNScGEvNE9CdEVtWG1LbmVsUXZCT29o?=
 =?utf-8?B?TlNRSU1GUDVyWEdNYnlNcHo5R05PQkNXZmpwYkxVZitUWm5raUZ6NE9ZMVBz?=
 =?utf-8?B?dnM1VUNEbDJhZ2NsVEtaQnlLR2NiNjUvZ2o4NCtRaytmTVJlTzcvVGtIWGs2?=
 =?utf-8?B?M2ttYjluRENjUHV3V3gzM0hjb3phY3FEVVhRbFM0eTdKeERkSVE4N0NINUQ1?=
 =?utf-8?B?TkVXWU9lUy9KeDArYjJQSGIweXY4WjhlVWpKdTZPcklHZ0xWd3VLbm9pVXJ0?=
 =?utf-8?B?NlJkeVk2Q2JmajBzeldRVGtEZytpRFZEWmV1QjRicU5UK3JzYWtFa3FseVRH?=
 =?utf-8?B?QWlxWmF0dmZlNk1RcjFzekk4K3d4TlVRaUk4dmlVY1VOZ2xrY1dPMVRxcVJV?=
 =?utf-8?B?dW1KVG0rWmZMU0toK25nZHJLd0JCcVNINnZBZE1RYnpZWm41Skc4ZHJRdEQr?=
 =?utf-8?B?YUFuNXRQTkRDYS9GRk9iT1dWTC9NTTFHaU53NFJpVTdHclFrOHpqTjNGdnZU?=
 =?utf-8?B?SnRGZjRkOW5BNGUyWnNkMDkwcGU0RlRyREFVMVo0TitWbDlaeGwyLzlSZ0Jx?=
 =?utf-8?B?dFNBSk4rMTREOG95cm1EWVdXdllVU01BSjlTYUl5SmtvZjJjL2FtUkNhenJQ?=
 =?utf-8?B?S0g4MEN1ZDAzV25IU09XK25FUjhjWlZ1eHMxRHhhMVk0RW42VlZSSGxzbmw4?=
 =?utf-8?B?Zzc3Y2hYK0FkUjF1T01hWGxySWtraUx4UjI1aW0ycWhHY3NUa1NPbzNlY0Rw?=
 =?utf-8?B?c3dObmx5WUJFTDFxT3ZNclhLdFFBd2kyVlhlVktyT1dXYzExQStEYkhPWklD?=
 =?utf-8?B?Mm1RUmEydTQ1Qys3MDgvTndrb2FPc2YwVnhuREZ1RC95emtvU3V6UFUwUkdM?=
 =?utf-8?B?NWQyZnBaOFN6Mm4vaTFScHFlemFnbEIxSW1YS25NWEhDSmZtTVg5UDFEWWZ2?=
 =?utf-8?B?S1NkdWIrSXgwUS9XN0E5M0x0WEoreHh0T0JlMDJlRVgzOUJnWXppUXR2eHpY?=
 =?utf-8?Q?cVdTobbAIcnerp0hkZf9B4L57oyshw78=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TE5zbVhzQXpDMjRid1FuYWtWRmFSbFpWelFZL25HMitFVnJlQUZnK2pTOGFl?=
 =?utf-8?B?S0dCcy95UEZlN05WeFpwcWZQWnFDVUF4aDMxN0tOYXBHc0Y5WkE4RkdiQ2o2?=
 =?utf-8?B?cFRwbFU4Z3BETEkxU0E5cSthQVZSRGdwRE14anB2bEJTNTVjcFNsczdqVjNV?=
 =?utf-8?B?VnJsNnh4dkpJQjhURFV2TlF6NjQ2dDRBQStKNnk5bTQyQlJoWjNzWFRwRUJ2?=
 =?utf-8?B?NDd3RkVzMWU5SHFYc1BWbkR3VWsrTmFsS1hmbkd5L3l6U0RtUGF5L1E2Y25B?=
 =?utf-8?B?Qi9NdlhjU2libmRPVlQ5WHgySUwxdjFnSk5USUxHWEFyRFF3cGFTRzIzR0Rl?=
 =?utf-8?B?SVNvaWd4R0QyR3ovc20vNHp0cWhYRVM2dXJNeHVTNEpoV3Y5NTlTTTdrYXdo?=
 =?utf-8?B?L2FFZjhtTXpCMTNQSFVFc1lGSkVuTTViai9FTnNzcmtUcTVCazZwNWlDRW9v?=
 =?utf-8?B?L1VzUS80WW1WMERCNjlYdDNPRStkS2xOMHpINEZQK0FyS28zMzRQYVpKakZ1?=
 =?utf-8?B?Zk5iemVGYTJZZnRMTlpGQjQ5MnJkSzZ4WWY0WFZjUWhVSmkrK2krRloxaHJI?=
 =?utf-8?B?MkpVbWpydU5WRnVZcTJGalNTY0VTekVoeGFlSElCRGN5b1VPS3l5NGFRYWhw?=
 =?utf-8?B?QUVNd09hOTl1Z0kzT2RiazFqM0ZFT1JOM2VlTitqNkw3d3lHN1lqTW92cjE1?=
 =?utf-8?B?dEF3Z05GdGg0Z29yNkN6cndNK25odGxQeXhLdlZxYng1b0N5UmJwbzJKQnNJ?=
 =?utf-8?B?ODZPVGc0cWpCN3F0RXVGMXAyam5pdVc5NXFtWVNXYWxWWEhoV0F4TmM0WVRM?=
 =?utf-8?B?UzJ3VlhVTnMrMVZHWHFCRzVFNkszbXhVT1k5Z0xTaiswWm81cTIrMXlhajR1?=
 =?utf-8?B?Sk5xUVk2TEdNRnI2Rm1oeHY4RU1BVkhuRGJMT01xR1oySEdJNXU3ZHUwL2lq?=
 =?utf-8?B?ZlplNW4wY25MQ2tFYndsOUc5ZnE2aElDSlhrMzZ2OERiSGVxb3hKUTk3ZWlQ?=
 =?utf-8?B?dUtuNWNxR2c5Y1h5cXA2MHhhdTMvSEpHVStIbkJkRXFPL21RS1FKSnMvdnFC?=
 =?utf-8?B?a1gybm05aTM5eU5aeXZ3T0pncWJTS011V3JCMkprV1k1Yi9nYkE4KzI1UGlx?=
 =?utf-8?B?OFUrLzhmRDV3OWRocjBkK0xOYm9lendJYno4S1lNUzBsS1RhY1RPa0xjVjBR?=
 =?utf-8?B?NFRBYlhUVWloYUs0ckxmazVNUWR2NWRrSy9GalpEei9sNWJuTnduL2xtdU9D?=
 =?utf-8?B?dmM4bDZOeGtDcHlJR0dyajJxNFU2ZmpKeGlVT2FWQkM2T2lZS0V4ZmVhUTdh?=
 =?utf-8?B?d1FFWkJZd2tJOWozdmFmTUtTend5azdOTWc4NVdCdTk4S25laW9wbTA0RFFj?=
 =?utf-8?B?cDdocnh0VW9ORDlIdzdsNTBxdXQycGFVL2JyMmM0b1NSSTd1elljY3Q0c3Jw?=
 =?utf-8?B?MEpOVVZMV3F2Y1dGUUxvUk1heUl6SURya0wvOUIvUTJSdi8xUnM0N1pRSDRp?=
 =?utf-8?B?VTJ2Nm9BQm8xbGtOSUxYTE4wVEFZVXB0WmFudUlHQkRRNVVYSWNodXQxL3Nt?=
 =?utf-8?B?VXFhZXM5bTNIVXhadEpjK2xNS3g4RkQ1TURUSXArUDhTOEFrWDJxKzBudFl4?=
 =?utf-8?B?QmJhdkJ2U2I0YjkwQ2ZiWHkrb3JPUnJCcGJPNWpPZHhXOE1kcXhib2JYc0RB?=
 =?utf-8?B?ekgyV3dnM2dWR3ZXcUF1anBWbmwvZWx4SE9MMzNFTXBjQi80RW9jVTlzM0NR?=
 =?utf-8?B?d3c1VVlGYnR2RTE3c2htcWhQMzlBV3E4R3dHaCttV3hCV0UyOWwxdWlhMDRK?=
 =?utf-8?Q?tML7P6uhKqc630cAUp/T9M1nBbBkLGgnaWlkM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB2048.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a52732d-1501-471b-526c-08df2ba82df0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 17:09:03.5012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR84MB3571

VGhlIHNhZmUgTFpPLVJMRSBjb21wcmVzc29yIHdyaXRlcyBpdHMgdHdvLWJ5dGUgdmVyc2lvbiBo
ZWFkZXIgYmVmb3JlCmNoZWNraW5nIHRoZSBhdmFpbGFibGUgb3V0cHV0IHNwYWNlLiBXaXRoIGFu
IG91dHB1dCBjYXBhY2l0eSBvZiB6ZXJvIG9yCm9uZSwgdGhlc2Ugc3RvcmVzIGV4Y2VlZCB0aGUg
c3VwcGxpZWQgbGltaXQuIEFkdmFuY2luZyBvcCBwYXN0IG9wX2VuZAphbHNvIG1ha2VzIHRoZSB1
bnNpZ25lZCBIQVZFX09QKCkgY29tcGFyaXNvbiBhY2NlcHQgbGF0ZXIgd3JpdGVzLgoKQ2hlY2sg
Zm9yIHRoZSB0d28gaGVhZGVyIGJ5dGVzIGJlZm9yZSBlbWl0dGluZyB0aGVtLiBVc2UgdGhlIGV4
aXN0aW5nCm91dHB1dF9vdmVycnVuIHBhdGgsIGxlYXZpbmcgdGhlIG91dHB1dCBsZW5ndGggdW5j
aGFuZ2VkIG9uIHRoaXMgZXJyb3IuCk9yZGluYXJ5IExaTyBkb2VzIG5vdCBlbWl0IHRoaXMgaGVh
ZGVyLiBWYWxpZCBvdXRwdXQgaXMgdW5jaGFuZ2VkLgoKQm91bmRlZCB1c2Vyc3BhY2UgdGVzdHMg
b2YgdGhlIGtlcm5lbCBjb2RlYyB1bmRlciBBU2FuL1VCU2FuIHJlcHJvZHVjZWQKdGhlIGJvdW5k
YXJ5IHZpb2xhdGlvbiBhbmQgcGFzc2VkIGFmdGVyIHRoZSBjb3JyZWN0aW9uLiBTdWNjZXNzZnVs
CmZ1bGwtY2FwYWNpdHkgc3RyZWFtcyByZW1haW5lZCBieXRlLWlkZW50aWNhbCwgYW5kIHRoZSBl
eGlzdGluZyBDcnlwdG8KTFpPIGFuZCBMWk8tUkxFIGNvbXByZXNzaW9uIHZlY3RvcnMgcGFzc2Vk
LgoKRml4ZXM6IGNjNDdmMDcyMzRmNyAoImNyeXB0bzogbHpvIC0gRml4IGNvbXByZXNzaW9uIGJ1
ZmZlciBvdmVycnVuIikKQXNzaXN0ZWQtYnk6IExMTQpTaWduZWQtb2ZmLWJ5OiBTZWFuIFNuaWRl
ciA8c3NuaWRlcjVAb3V0bG9vay5jb20+Ci0tLQogbGliL2x6by9sem8xeF9jb21wcmVzcy5jIHwg
MSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9saWIvbHpv
L2x6bzF4X2NvbXByZXNzLmMgYi9saWIvbHpvL2x6bzF4X2NvbXByZXNzLmMKaW5kZXggMDE1ODZh
ZjIzLi42MjFiYmI5NjkgMTAwNjQ0Ci0tLSBhL2xpYi9sem8vbHpvMXhfY29tcHJlc3MuYworKysg
Yi9saWIvbHpvL2x6bzF4X2NvbXByZXNzLmMKQEAgLTM0OSw2ICszNDksNyBAQCBzdGF0aWMgaW50
IExaT19TQUZFKGx6b2dlbmVyaWMxeF8xX2NvbXByZXNzKSgKIAkvLyBMWk8gdjAgd2lsbCBuZXZl
ciB3cml0ZSAxNyBhcyBmaXJzdCBieXRlIChleGNlcHQgZm9yIHplcm8tbGVuZ3RoCiAJLy8gaW5w
dXQpLCBzbyB0aGlzIGlzIHVzZWQgdG8gdmVyc2lvbiB0aGUgYml0c3RyZWFtCiAJaWYgKGJpdHN0
cmVhbV92ZXJzaW9uID4gMCkgeworCQlORUVEX09QKDIpOwogCQkqb3ArKyA9IDE3OwogCQkqb3Ar
KyA9IGJpdHN0cmVhbV92ZXJzaW9uOwogCQltNF9tYXhfb2Zmc2V0ID0gTTRfTUFYX09GRlNFVF9W
MTsKLS0gCjIuNDMuMAoK
