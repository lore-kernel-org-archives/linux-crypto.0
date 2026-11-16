Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.85
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794869549;
	b=2ggVBlg6fOCaS8Z9XlQEGwoZNcZkkHTa8CJDV1YSkwBnR9AvouP7bOv/sX/Nzfou2TWw
	 Cwae5dmbU/eIdtj+eo3D7i8pqKs9yyCQJnMy20ZPwUkL2cWmwssCxslKFHJJKL9Bs0V0d
	 SOBBPx8BfNEzkG7+2bi9J4ZnJsW18lLlX5d4cvt11EFw7WwBio1c8uPKg6EH5wyiWDvhl
	 V5mHmgTX0/UYwfPvjVYQinl7BIwpxIDffc8MiYrLoXL0Yrb1eRNcZHqcvl/moucZbqqn+
	 19z6Rz/M/fGb7+mN3oN2glS4hjyrsOpp4gqokTvU5XuiEsxrFGCt7RLQbO2h167DxQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869549;
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
	bh=E1VTK4oJYRrvWcSnK2r8Pc1f/i3tTwi2y1VMmaZ2H/g=;
	b=zCJUJnBYAIL0IXyn5yxDn4Xxf+9xPtm/VC3X122WSHElkpXPWtcCdOABkTMDQY5BsV2r
	 wBLVqivavQenHO92IC/7aCF19FrHDc56wvY+gCMSTLhFgxP7bCIfoS0IoUG+NyWR39y5m
	 +q6qXzLgMxet1iTCcniI7qKKfSBtY5HOdu0t022pZjw6HPFxA2MyRpWA7pTSYfzMSGJlt
	 s+1UtsDQhnTmAxIPW7fN6n+c452bYOVvhZbWjqwE5YLs5fWqCdLWg6DRrl94SYy6fmWEI
	 eb3uFaQfSZpigQdnIHZfeafivLF1jR1JKJynPcZamjwSdmjyu+flyTkgPW+drh7BQXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=l4hpRWdY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.85
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020085.outbound.protection.outlook.com [52.101.201.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A7C606A31C;
	Mon, 16 Nov 2026 22:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61A7C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=l4hpRWdY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B1N454HHI+PRO6opTTjSIJHHjxyD07TWE2DNinQ8tZmUcSWbO6EGWVxaIUKhCLd01l/gMU1mAXWMaz7i5eqTD9Kk8knmkFD8BvxHhwA9SwFeNNL3bcx/vqXwbeIW2AD3gA7ANtYHZyCShtqETbqYV9bG+JGs6Zpuli1+JAa3jtZdhE35hV6xSMm2PXQY/W/QslSLcTXnSAvPiqOaWdiIjUtlaSG40SiZLIYXUTQaFudB5TzuNZFjC6czcRCf5fvY7FYRy5pAQcErQslw+zQuoa82v+uthXNpnxXFcmPOM9GHKYJbO+YwB7dSpMZrkdb60pTeFllAHYylXQg3PlVmwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1VTK4oJYRrvWcSnK2r8Pc1f/i3tTwi2y1VMmaZ2H/g=;
 b=pdX9lkmpRgklYy+k+Upp/OHlOBKmJ1JvicWRTCCbIJiiqshBkrKTFOlbdoCPfd+tntzp/cf5uRwOP3PmDJVlGvv7smc/TmZfAiymBG0vuH2Gnmch6w25mcXxdoFTOP3UXV5EXaO39WRD46nNbgslW62i3E3tOuDxqx5wn+k3KVMXmC3IOW1HIqiSXB2WY+7mojrKQQa9XdIsA3J40yFSjdELRnAuK+epi1GVyuDzlL1O/ARqYbvFUKx3E5uOt3F79gLvQ0hc7UvH1X87xlT4Ym+kO5cKYmMq1N+3LopOWKDfyMGVYfLCRzVk8zzQWvMEUKSTngLYhJm05QynibaPWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1VTK4oJYRrvWcSnK2r8Pc1f/i3tTwi2y1VMmaZ2H/g=;
 b=l4hpRWdYZKK8AQLv6NmmBylNNVd4+O7Roz5NzmdySTv7sai+Os5oye1m37mixtUB129WtmvkaTXCJjtiDDYzLM+Z9hAmZjTqX83d9OkJsH1oFb+MmBQOTG8wa+9agheFCz8kUNQ7z+qMpMXZ47vvIwsl3hYjWiPio71bHJYlbrtsArNNV+P4R6/YWt93HYPRR4LCkpQR2K+yUU+F5oTw9lwvJ4fge+lsgaxOzqZ4HvlftC2540c2Phw3tOZnUiAznlxzpOhy5T8MuoiZjikuvZdjB2yFaeoo/gVEfiVEZDZ7AbewGu9m5ZJOz++7kB4xVKBidzVZieB3jAztO8zOWg==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by PH0PR04MB7415.namprd04.prod.outlook.com (2603:10b6:510:18::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 22:52:27 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 22:52:26 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>, "Wittenauer,
 Joel" <Joel.Wittenauer@cryptography.com>, "Nguyen, Thi" <thin@rambus.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	<krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
	<rdunlap@infradead.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v8 2/5] crypto: cmh - add core platform driver
Thread-Topic: [PATCH v8 2/5] crypto: cmh - add core platform driver
Thread-Index: AQHdcTPv3CpPtr8Hb0SYqB37I1+L6bcnlZGAgAnBluA=
Date: Mon, 16 Nov 2026 22:52:26 +0000
Message-ID:
 <SJ0PR04MB84066047ADAB0F643E908AF1D77C2@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-2-4cea8ebc1d40@rambus.com>
 <sashiko-outbox-207521@kernel.org>
In-Reply-To: <sashiko-outbox-207521@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.14.1.396
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|PH0PR04MB7415:EE_
x-ms-office365-filtering-correlation-id: be2de984-d634-449c-551d-08df4434494c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|921020|11063799006|56012099006|10067099003|4143699003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261022075727099003|261022113327099003|38070700021;
x-microsoft-antispam-message-info:
 wnLmPic4F01c4ROnjS2U3/ERLFGq2XlHdbuPGVZeEfm2hzJ+fc+NjF7/0O/Xo0tmrlbxL2DxegUH8AcO/aTSijL0ThZ1Y91yzyajR5v0zm8geZ1ePstEq2xsU1nWA09cqq9hGnTM469KBollViJSwGLKLCviXqQlz7iHJL4e5+/TP8don3PL2YDOMmMrq0oVk3ovqDqetxTnZ8iPsMF6vEn6IbgM/Viux8ol+mk5hP8MF6NgWYkR/7zEhUgNxs1BQr4KZtKdiA+r+otq78rBAmYzHV14h3fAOfWUirUrS6qCu2161cgOVu5IWO0Z6cOzBd1ORZomy6GttGn58Ik3bqPaXEvathiXJXdt1h6aFPd/+IKMREYOYjccGnpffGYp/rmxkJWuxBYLSD5if3qwxbXoi6Byx1g8JhlD9bUZiTEjUJ594gGodozE9AkB7OiSvnNjMGMD4erVGlUr5O3VYH+6m0HRu3mVnYIBNKbitFc/RG0AdjH29LDevU20ltQW0Kh+eO9r4pwRuER3xXi3j7RVkJ51EX5turvJ/MznCTtPC35yflZ7j8Sb2GIVSVdGZNoRbRqyc/e4+Pn7q3cWlr88jN0W1wYKu4UluDauAHEk8K984V80w6pyYAZr3609uachrA3RG4u0EGyGZgNjcs7f0bgsjglCnESm7C0mSJmhad35TFr9xKi55PVbh8RZBGC4hLmofZcfWD6+gw5FCb+ivkDsB3YzCXYfMcK37mAUB2XS2/E3GXnkHlJhvdC7
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(921020)(11063799006)(56012099006)(10067099003)(4143699003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261022075727099003)(261022113327099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lBLkl9x8mEUmdOBzataKIbbuzntcs3f8vxFlZfqYpGolysqmOOZRSBQ4dZYT?=
 =?us-ascii?Q?dIGbLMCFCiVrxexCfPyY1OGl3fy//7bA4i+ToAZqoGu4gf3gimXTnd/Tlep+?=
 =?us-ascii?Q?aOwT4lPOnNDg84ORqgJ940/iXcoAnsYUL+umvK+nBn8rHTcYRqS0C3/xRK3Q?=
 =?us-ascii?Q?FEjjNSxDm67/PJpkDE2Qhat6A/hvKEJANVaZOiCsmlLdiHA9gLof4uvSAOCZ?=
 =?us-ascii?Q?j6S1eA0ssTUQ7SxylcSxtqxuvoJxz3sw3zVqeAIZVLjHgKOf4ZfyV0JsRnp7?=
 =?us-ascii?Q?Lh64gCVH5yZur9ysbFKWDnCGUzX+nZ5pVCONX2L8ImWz9Kx00hRmgWglhZMR?=
 =?us-ascii?Q?dKpIBQfZfmSiGM6CD0Oc+LRaYf38KBYvuawexIyNxm9p0wS3YrVpqbkxwW03?=
 =?us-ascii?Q?SpfcHzbdFLMX03LgI4ICs3QYG3VR/u7hsRw0gkuvl8MetF62LOZ6qNpgCZsk?=
 =?us-ascii?Q?Qik7nObmNFeqCUIqn8whD66dYTANzXac6ajjESR7tk21x/qHQsdmiBhg3eAd?=
 =?us-ascii?Q?yFK8226Uk4ApeBdwMqMHptbHYLgxe/CDIKKzV4FhIm2Novg2zUOJRBiNZAoN?=
 =?us-ascii?Q?x2CuuFeVHuQAm5MRMz1M8LA5mGzSn0H0jVX2w/4u4AmifY3tLVD3QznBNJ87?=
 =?us-ascii?Q?tMs1W0wUjZtkOqccSUODB81Au7tnFSdyYDSvEy8NsREgNU7rO7X8UgCizR+V?=
 =?us-ascii?Q?hN0K77uX2NqZrvRZ45JH0NlFB8xY7AdCStWzor/aULsOwsnfgFOYm8hKiv2w?=
 =?us-ascii?Q?ntvFbn59HP6ocz26Wmpb+TpzcruCgOq1MbV5K72R/GIHCvHzfJkj2LwD6FNz?=
 =?us-ascii?Q?U/8dZWaRSeObfp5CUFE5YLcnwGESb4uF3fe+UksSpLsV+T6lcAWuuIgka1tC?=
 =?us-ascii?Q?sho1ZTJNwUzllA7LKMQgchvw5LkgSq0iptHdzCpdSoBUrWTlkD8Z3sukP1u6?=
 =?us-ascii?Q?SdWlO4K9M/R33kin5IujadTcbyGztP20SCr/bCZz+FhTt1MV2/9dBwIx+moa?=
 =?us-ascii?Q?NFR8+YLUnpzjASUUoT3mL5fgcbxRBF3mIwp4Ey7afxnC4bnsD/tLbMyGRNrD?=
 =?us-ascii?Q?V/7BAblNBlhlMceCYjk9BiUtKmVV91h58mQmi0WkdM1dT45nJAbPMtEGUWgf?=
 =?us-ascii?Q?BgKB53oxv/2dzUJRgkUMkgxRD/MA+s5HmtyvCgmduGoctRl0PHYmAZMFe76n?=
 =?us-ascii?Q?RyFYcNRljWuCwmYt7H2Jp+1TH/prdyZ1+uFvW9GNwPaTQXGtiYlIWuY1f51Y?=
 =?us-ascii?Q?eEMsUGXgsjQTbTbfGMFV60VX7tyNfSSGoxkhjuLNZkKr4xe6IUXX8Zg9FDgu?=
 =?us-ascii?Q?HQXsYLd7o0NcPovwhkTgseIJugI5ovs/NF9u/xiXrN6EeFxJMVRWOgTe4gvD?=
 =?us-ascii?Q?sJXeUM3xqhyejZwoC5OXqKw2DiEuybT0C/gwF8fHfEjlkuEES0pQoJ4kdlYI?=
 =?us-ascii?Q?3OaYAtu3Z00LWDW/UCSOR0s6To9ZWeiuRVGCeSqk3UW0IKYUolP2oKi919zc?=
 =?us-ascii?Q?a7NoMeMb+seW91hOUYbYZuoIodu4iezMg22NkpvlG21T2/DIpHJgPd/JCrNb?=
 =?us-ascii?Q?ded8p9OzXC3amOY1Z9VS0OhOM4XFvC36ghVDyu+u/ZHHUobDnB6/S5vClwAs?=
 =?us-ascii?Q?V7JUtf2gxtH78IzN6wHeL6jl2IfLB0GUEXipE+DliuCHXi0kbuborbO4eUzh?=
 =?us-ascii?Q?aPPxnbGQFDC0N4i0owxiRG6YjU9efDQzoZ2xLPVpwsdQdArwbGHL0bdUNziB?=
 =?us-ascii?Q?YGgeZSPKtA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2de984-d634-449c-551d-08df4434494c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 22:52:26.8606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxjDSZq5H4R/RFsKaPyjhkNud2SuNQtGyp7OLEmtf218RIiKT9J/uUQC6lu4avZMyE6J00omjAiIQuungHtWi505NxnU/f1ULcdMTOyyb04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7415

On 10/11/2026 17:50, sashiko-bot@kernel.org wrote:
> - [High] crypto: cmh - race in cmh_tm_try_cancel_command() during CMQ
>   backoff
> - [High] crypto: cmh - unaborted sync timeouts and missing watchdog
>   escalation
[...]

These are addressed for v9, apart from the two points at the end

Cancelling a timed-out synchronous command is now decided under the
command-queue lock, so a command the transaction manager holds is
finished undispatched instead of being submitted later.  Commands
submitted with cmh_tm_submit_sync_tmo() carry their timeout, so the
watchdog escalates them on the device.

The recovery findings (FLUSH/RESTART reissue, FLUSH on an error with an
empty queue, wedged mailboxes skipped, last_head and abort-stall
tracking, the probe/teardown FLUSH), the dma_live and quarantine ones,
and the completion counter are fixed as reported.

Suspend with recovery pending waits for the mailbox's requests like any
other, and the watchdog resumes the recovery after resume.  A
synchronous command cancelled before dispatch still returns -ETIMEDOUT.

Alex
