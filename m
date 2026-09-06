Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022138.outbound.protection.outlook.com [52.101.96.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2A434A3A5;
	Sun,  6 Sep 2026 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721246; cv=fail; b=SH3z4SLt3PzPGzAN5SK1sfWDZ9fBt4Fu3q9K084QriW3WXcBspDypx/77SvDDVyuuvz6z7S5v+jC2g0MVjkGg3uyy0T4sG6PYXjU1XtQVi1zuajXX9QSqE2/3T0sHTjrZhnEronetax0FQB9xgFVQBO001v2vGCV98Q2h9PQs1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721246; c=relaxed/simple;
	bh=Jb+7ozdHZdQWFWxG+WsNKqEe4OEF/rXN+ygCmD3JIJQ=;
	h=Content-Type:Date:Message-Id:Subject:From:To:Cc:References:
	 In-Reply-To:MIME-Version; b=aamtQKQcY/tOevytfN+3wnuP+ZN231hJh++juVJzF26UzKKpKhm3PFR0tZ2Mems8iN/a9GD/wPFpRdX+1aCRANYmftza+6WyCThwWN8AHBmhFJchrbXqkAybbDJPzO8r5mqL7T2cxFNbdiLR7Jtr8kzr9wT/A/EKd0Ey2NMBg4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=iI738XwQ; arc=fail smtp.client-ip=52.101.96.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="iI738XwQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFtrqCSB//pBTQ2ncQG0hIElPFdR8oywO/+cBo5vgyXuSu5coAd2GV3SVijtK+r/fEdf17TmFX7JGT6vwCAstw8D6TvtiX6UnD/aWPpO44/nw0sx3j/QwrpoyD1J0eiLjOngE3DcAibujyWtnmUkP8dUxKe8IuwQ5bkuCeKluTNNcswBhidk4bEngTvnDmotyebZdth+4V3gbaMjoiyCeCQFIIjd10OF6LX9eBn/A0FTiYNFadta+fPLZmfgSe0iuvzIMQgPZLVdLEDFwgrFo9I4Va2ikfNta1IOz17Hu9nbV93g/HNsEs9e3kUmWIj2Ozv2vNHAwLKAnwbtX6iJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRVvdl8RO1NtOOriZqqBirj3HBsxdu0NGCByzSyr9N0=;
 b=aH1yHL0kP5wKncOQM1gJJl67McDgK97S2Lm9C3smRCBC0uuh3z5zaHXkTIQelTaObl1oo5+IiVXp3R94rXkb3fsGJZ5XHMrwdj7DSLJ8SRxmOKGVj8ILZO1Eg+s5s7NT5TgOAcisXZ8PWKxUNH74z+COqaWQiv3bYMn1HdDqfOAMjq9uDvgpLE9FjI0t7cQ5nBbPOiCTN+lbN4vtyhijA6Uk1b+T84bc4sLaAq6hl49KTRqGxdIlPQoZZGUK+RSohbhgYCvptqjKB9T07aZ/OQ9XO4EIdCBG0m1Nm81wKV1wENTTSgWXIfuYR0QrtvPueciD9yO0Q4bS57QNsFzcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRVvdl8RO1NtOOriZqqBirj3HBsxdu0NGCByzSyr9N0=;
 b=iI738XwQOew2Unc5kp59R4fN2upEGxBWV2sT8V3KDqZfi3u2f+lO3zggd53XSEGfleXDxEDtFGf0jbBqGdNbgY0qO3gF4n2eCkfLXmJLGuFZyLb52caIB631b5R7GTJaXtPxLMsz1CvERhH8aFl4NDATryPOXljKilpkW3UtYcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO6P265MB7113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 19:00:38 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 19:00:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 20:00:37 +0100
Message-Id: <DL8GRCH5DTRQ.KJE7HHIOKW8A@garyguo.net>
Subject: Re: [PATCH v2 7/7] greybus: Add Rust UART node driver
From: "Gary Guo" <gary@garyguo.net>
To: "Markus Probst" <markus.probst@posteo.de>, "Ayush Singh"
 <ayush@beagleboard.org>, "Jason Kridner" <jkridner@beagleboard.org>,
 <robertcnelson@gmail.com>, "Johan Hovold" <johan@kernel.org>, "Alex Elder"
 <elder@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Eric Biggers"
 <ebiggers@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Ayush Singh"
 <ayush@beagleboard.com>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Uladzislau Rezki"
 <urezki@gmail.com>
Cc: <greybus-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
 <20260827-gb-uart-transport-v2-7-a03bb1f5fbd1@beagleboard.org>
 <08c89a754cd7cd43b0cc6d5f1e84cd6df7253c68.camel@posteo.de>
 <40f71ade-9266-4373-b584-634d91bdf670@beagleboard.org>
 <2dd208b5371196804b1adc3fd00e5265dc0e814c.camel@posteo.de>
In-Reply-To: <2dd208b5371196804b1adc3fd00e5265dc0e814c.camel@posteo.de>
X-ClientProxiedBy: LO4P123CA0681.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::15) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO6P265MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba0e630-ebe9-4210-769b-08df0c4923fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|10070799003|7416014|10067099003|6133799003|3023799007|4143699003|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	+3WYxTIYI2thcP1rEOhew9n+zBDEurIVeFWEY+9x+ID18jk+Sz3ksBXVCY0UM+d1HpFIHALVvw2Ra7Nwo6dQ1qTX6dbUSNAr7FPdVLHrZXhlZ4nxErvWgwrULduFoGThTaF9dTpN5XQP8aQ+05v8HN8YS0Doo90ILj43OBMXbcKpl4kR/7RHNZrb1G/6kxMMZijIlxOa7/JbV1eshz2GdRMujqyq0mADysvP/5CYBVNWcKHgZQ8pcqWzkEQDR1KtbEpH+NqfDsSltPny8XS1ytm96fzKG+Pjvn3OIICHAPD5KNq/79zNjH4e4J52N6/dEGft7tlrH0GXJWQPHTGSEXfW2oiCFJYksEHd7WNTJioQPmXEA5egZtKBRpBGRgibU2dwNRedcQ3difGfgvdhO9FJ4JM2K/ZtyeUsL4IGljPQBZwHSAa0unfJRzVN0jLxMk6RBPXdxNDQZp/hdc0MZjZezeb9XnTySyHhLlrPWsZOHXBNuwm0ywQ1xXGGtl05K9o5CoEy1c0dY8Yh//l9JKauM6gJknZkhqnSfFFASF3cCEMO9Pa1Oq4DW6nKxl5WVNGrSil5D7cceV00V2yxtZCIv0mK8byCftFPu7tkF2YGb/iOQuVog5DSbfrZKAM2GWS1suoIESBvod4tXMfu+1/G2t1muf2jNVp5KoTjCjCTa6+sq4CN3DIbS8zLcav/e1PKFsxjzZFdnr4UMCLjyA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(10070799003)(7416014)(10067099003)(6133799003)(3023799007)(4143699003)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnFNcjUwelZXMVVvSUFJREpqMWRnVWY3Z3RUa0JJL0hjclY4RzN0RUxFS2I2?=
 =?utf-8?B?aThtUWt1VUVIaU1TMkNzRzRHMHhZazk1NHBVdXdNVDNDMGErVDdDVkFtYjQ3?=
 =?utf-8?B?WldZOE5KRkdDTHBveWtUdkpyZUNnaHBGU0E1N0FPMVlzNnl5ZkpvVWFXNDkr?=
 =?utf-8?B?Z2RXNnM3bGJmWVRaSnRUZXJZdng1Sm42ZDJoSXRBSUJEU1V0TVY4TlY1NkFj?=
 =?utf-8?B?ZURKMzA4UC9TeTNwMTZNbk5lUXE2YmlUWHlRaHhydE9qOXd1ZHdnck1FcERP?=
 =?utf-8?B?SUlFc2pZVVowZ0kyQUsrSnVXcTZIUjJFc0hBaFJ5VVI0TUtxaS81VlNHNVFS?=
 =?utf-8?B?dFVGTSswbUtrc2Z4UUYxYUw1aFBKckdSeFZtTGlmNGVORVlJdm5HTXo0cUNZ?=
 =?utf-8?B?TUV0aGZtSTlqejFUbU5EN1lkOXNYVUdsdHMvWmkwdXZZbkhiQU44cHgycmQw?=
 =?utf-8?B?OWpJaE8xcWtnRTJiMFhLa29XOFY1U3U4TWlleWVtaWdiU0E1Qmx1cFZ5bTM5?=
 =?utf-8?B?V3FFK2ROZUJlclF6TFowTVZXekNxL3pTOUhRa3dKeEdpNFR4cW14RXFQZjgz?=
 =?utf-8?B?ZUJoR2pPM1pNZjAyVmFuaUNiSGJyVERtRTI0Zyt1elF1Zzd3NTczMEY2YjFC?=
 =?utf-8?B?d1l4cHh0Wi9JR0xKQ1ZpSUovMDVpdzJic0hGRmlYTWh3clFrdHViUWs1Tkp1?=
 =?utf-8?B?MXd4MHNScng4WGhtRU5CTWRTeTRPQnIxbW41UjhNeTZtSW9Deld3RGVCQjdR?=
 =?utf-8?B?K1ZiS1lJZTZHemZhT2xKYzlpUUpqd0NFbksxLzBSdmR3VTNGUk4yM1dpK1lV?=
 =?utf-8?B?SXdXZW1jRFp5dk1sc0hqRS8wMHd1TTVtQ0tyMFMvL1ovQkJpcTBrSDNZNTBF?=
 =?utf-8?B?Rzg2RjRzektvTUExeHpwTDRxaUhtemtJWWFZSWJwcmNYaThnYUZybDVoM2NQ?=
 =?utf-8?B?VnVPcU5HU0xTZmo1WHM5eWhCeWVjMWs5L0ZGTDRnUWpGVkFFdWxtZDJ2SHNG?=
 =?utf-8?B?TGR3cFl5bkc5cHlFV0ErSVVlQ2JBYWE3S1FMVE44cHpqK2lMZHZWOXpUOUJY?=
 =?utf-8?B?OWZrcWp5Z2VtUkhXMmpGYm5WdEpXbEthUXVEUExqUFVJUzcycUlGSldZeHoy?=
 =?utf-8?B?TzFDeGtUbm9TaVlBZzdMVTNVQlBxSllERkFDY09JUjdVamhyaWhpZlZ3ZEpI?=
 =?utf-8?B?ZFd3UFpJQk9RczJXQllHVFNOZXlUbzZHdEhzOTU0a2Jrek5tT0Jic0hSQ1p2?=
 =?utf-8?B?TXdWLzE3blRzRG9QZkRWRDVORmEwQzNVVno0QW5kLzMwbkFxb1E2K2lkMnFa?=
 =?utf-8?B?NVdrR3dWVG5OWGJXRnZia2I1RmRuNGhZYldOQ2lHcy9ocVZya1IzNmcxUUJz?=
 =?utf-8?B?QUhzWndDWHpOMjNNbHlocXE4ZXEvMGhBeWRGTW8xRU1jWXZwQWxUK01sOHgv?=
 =?utf-8?B?RXk4SGxoK1VnVXlOYy81dFVzUWxQa1RKQk4rVGJiSENDeDgrTUUxWVNRaFBE?=
 =?utf-8?B?clRhTmNwQmRxUldQUzQ2T093clBpMnEybExjTGU3OFB6bUJzMTg3bGlOVDJJ?=
 =?utf-8?B?bTFQME83Mkt5SWZ3cWpYU05OQTI2V2ZUMzFQL2I5TlgzYm1Qb0xtbkw1UTdi?=
 =?utf-8?B?ZWxjOU5oTG9Na0U4dE9rQnlFREw4UUltYnpWb0N0UzA5RFpVb2VhODJTOW5a?=
 =?utf-8?B?RXkxMVR2RFRnbk5pclN3N3hLRVorVXpTWHRTS2J6YUttZC8yd1BsSVBSN3BD?=
 =?utf-8?B?YnZWSWwrRkJWTXBwYkRlN1pVL0Zma1RNY2pzVjdzRm1wbnBUWHlBcTRQS2JJ?=
 =?utf-8?B?VmcvaW1Eem43aFlocmpkcUhlRElWekZoSnBKYWRxN2RtQ1lRdkU3cnBDbEpx?=
 =?utf-8?B?UGVYdUxoL3Q3T0txQmVtZEFLTjFVV2pVSXk0Vko3QjM5UHhxN1dWNlczOW5U?=
 =?utf-8?B?ZXlFZEFxUU0vWDdpd0orZDBsMXhEN3NuZEVrYmtPNnVsZ053YThJVnpwOG1V?=
 =?utf-8?B?aDVWR0VCb2tHMGYrREF6RzIxOHNOc1NESVV5Q1M4RFdwT0htUHFWcmt3MnRV?=
 =?utf-8?B?UnNLNENyQXN4d3g2QlJpN21ucGlLdU0zL2w5RmtMSW5ST3dZZUdpbXN3Z3lX?=
 =?utf-8?B?QzV0c2FESlRHRTJPR3d6WjBZeE5BTUhFeFlVVElKL0RTVnpPQStYaFVkZTQy?=
 =?utf-8?B?UnhIWmxZSWtacWFZb0FTbE0yZjFOM0J3eHpLanE5NSt0S1BzbDR6bnhXTGtm?=
 =?utf-8?B?YTNoNU01OGp2WkxMN2dDR3JsMnBoeW02UzcvUWhheHd6WGh6Z1dHRmpIL3k0?=
 =?utf-8?B?bGZoNUpMdUhBYXdWNlcxYU94VCtyb3FxbFZvUHAvWkhYd1FPeUc3QT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba0e630-ebe9-4210-769b-08df0c4923fb
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 19:00:38.6846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKXVp6fs2Al40hHYW7QbEodcR0pbmkuO17CKkdtSvHx1IXf96NddVqD09MTSxs2oJfKg2WRZ1XbLyU8L+MSyVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB7113

On Sun Sep 6, 2026 at 6:39 PM BST, Markus Probst wrote:
> On Fri, 2026-09-04 at 10:48 +0530, Ayush Singh wrote:
>> On 9/4/26 2:19 AM, Markus Probst wrote:
>>=20
>> > On Thu, 2026-08-27 at 13:24 +0530, Ayush Singh wrote:
>> > > Add a driver for Greybus nodes attached over a plain serial port. Th=
e
>> > > node is registered with the software SVC (gb-softsvc), which handles=
 the
>> > > SVC protocol on behalf of the AP, so no dedicated coprocessor runnin=
g
>> > > SVC firmware is needed.
>> > >=20
>> > > Greybus messages are carried over HDLC framing on the wire. Each fra=
me
>> > > carries a one-byte address (0x01 for Greybus) and control byte, foll=
owed
>> > > by the 16-bit CPort ID and the Greybus message itself.
>> > >=20
>> > > Port parameters are taken from the firmware node: "baudrate" if
>> > > present, otherwise 115200, with flow control and parity disabled.
>> > >=20
>> > > Since gb-uart-node imports types from gb-softsvc, Rust to Rust calli=
ng
>> > > setup from nova-core [0] is being used.
>> > >=20
>> > > [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773f=
c977@nvidia.com/
>> > >=20
>> > > Signed-off-by: Ayush Singh <ayush@beagleboard.org>
>> > > ---
>> > >   MAINTAINERS                     |   1 +
>> > >   drivers/greybus/.gitignore      |   1 +
>> > >   drivers/greybus/Kconfig         |  15 +++
>> > >   drivers/greybus/Makefile        |  48 ++++++++
>> > >   drivers/greybus/gb_uart_node.rs | 245 ++++++++++++++++++++++++++++=
++++++++++++
>> > >   5 files changed, 310 insertions(+)
>> > >=20
>> > > diff --git a/MAINTAINERS b/MAINTAINERS
>> > > index d047090be5f4..49c6dac72748 100644
>> > > --- a/MAINTAINERS
>> > > +++ b/MAINTAINERS
>> > > @@ -11339,6 +11339,7 @@ M:	Ayush Singh <ayush@beagleboard.com>
>> > >   L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
>> > >   S:	Maintained
>> > >   F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-f=
reedom.yaml
>> > > +F:	drivers/greybus/gb_uart_node.rs
>> > >  =20
>> > >   GREYBUS SUBSYSTEM
>> > >   M:	Johan Hovold <johan@kernel.org>
>> > > diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
>> > > new file mode 100644
>> > > index 000000000000..ff9c4a3539b4
>> > > --- /dev/null
>> > > +++ b/drivers/greybus/.gitignore
>> > > @@ -0,0 +1 @@
>> > > +exports_gb_softsvc_generated.h
>> > > diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
>> > > index 381d1a6ee135..34de913af287 100644
>> > > --- a/drivers/greybus/Kconfig
>> > > +++ b/drivers/greybus/Kconfig
>> > > @@ -60,5 +60,20 @@ config GREYBUS_SOFTSVC
>> > >   	  To compile this code as a module, choose M here: the module
>> > >   	  will be called gb-softsvc.ko
>> > >  =20
>> > > +config GREYBUS_UART_NODE
>> > > +	tristate "Greybus UART node transport"
>> > > +	depends on RUST
>> > > +	depends on GREYBUS_SOFTSVC
>> > > +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
>> > > +	select RUST_CRC_CCITT_ABSTRACTIONS
>> > > +	help
>> > > +	  Select this option if you have a Greybus node connected over a
>> > > +	  serial port. The node is registered with the software SVC, which
>> > > +	  handles the SVC protocol on behalf of the AP, so no dedicated
>> > > +	  coprocessor running SVC firmware is required.
>> > > +
>> > > +	  To compile this code as a module, choose M here: the module
>> > > +	  will be called gb-uart-node.ko
>> > > +
>> > >   endif	# GREYBUS
>> > >  =20
>> > > diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
>> > > index e6f594128802..81151963c01e 100644
>> > > --- a/drivers/greybus/Makefile
>> > > +++ b/drivers/greybus/Makefile
>> > > @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+=3D gb-es2.o
>> > >   obj-$(CONFIG_GREYBUS_SOFTSVC)	+=3D gb-softsvc.o
>> > >   gb-softsvc-y			+=3D gb_softsvc.o gb_softsvc_exports.o
>> > >  =20
>> > > +obj-$(CONFIG_GREYBUS_UART_NODE)	+=3D gb-uart-node.o
>> > > +gb-uart-node-y			+=3D gb_uart_node.o
>> > > +
>> > > +# Export Rust symbols from gb-softsvc only if gb-uart-node actually=
 references them.
>> > > +gb-softsvc-export-deps :=3D $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)=
/gb_uart_node.o)
>> > > +
>> > > +rust_needed_exports =3D \
>> > > +	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS=
__"; \
>> > > +	  $(NM) -p --defined-only $(1); } | \
>> > > +	awk -v fmt=3D'$(3)' ' \
>> > > +		/^__DEFINED_RUST_SYMBOLS__$$/ { defs =3D 1; next } \
>> > > +		!defs { if ($$NF ~ /^_R/) needed[$$NF] =3D 1; next } \
>> > > +		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
>> > > +			$$3 !~ /_(init|cleanup)_module$$/ && \
>> > > +			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
>> > > +			$$3 in needed { printf fmt, $$3 } \
>> > > +	'
>> > > +
>> > > +quiet_cmd_exports =3D EXPORTS $@
>> > > +      cmd_exports =3D \
>> > > +	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_SYM=
BOL_RUST_GPL(%s);\n) > $@
>> > > +
>> > > +$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-sof=
tsvc-export-deps) FORCE
>> > > +	$(call if_changed,exports)
>> > > +
>> > > +targets +=3D exports_gb_softsvc_generated.h
>> > > +
>> > > +$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated.h
>> > > +CFLAGS_gb_softsvc_exports.o :=3D -I $(objtree)/$(obj)
>> > > +
>> > > +ifdef CONFIG_MODVERSIONS
>> > > +# The C export shim declares Rust symbols as `extern int`, so reuse=
 its export
>> > > +# list but generate symbol CRCs from the Rust object instead of the=
 shim's DWARF.
>> > > +$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c =3D \
>> > > +	$(call getexportsymbols,\1) | \
>> > > +	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
>> > > +		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
>> > > +		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=3D.symtypes),) \
>> > > +		$(obj)/gb_softsvc.o
>> > > +endif
>> > > +
>> > > +# Output nova-core's crate metadata for use by nova-drm at compile =
time.
>> > > +RUSTFLAGS_gb_softsvc.o +=3D \
>> > > +	--emit=3Dmetadata=3D$(objtree)/$(obj)/libgb_softsvc.rmeta
>> > > +
>> > > +# Allow nova-drm to import nova-core's types.
>> > > +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
>> > > +RUSTFLAGS_gb_uart_node.o :=3D -L $(objtree)/$(obj) --extern gb_soft=
svc
>> > > diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_ua=
rt_node.rs
>> > > new file mode 100644
>> > > index 000000000000..3eb4f8ab3655
>> > > --- /dev/null
>> > > +++ b/drivers/greybus/gb_uart_node.rs
>> > > @@ -0,0 +1,245 @@
>> > > +// SPDX-License-Identifier: GPL-2.0
>> > > +
>> > > +//! Greybus UART Node driver
>> > > +
>> > > +use kernel::{
>> > > +    alloc::Flags,
>> > > +    crc_ccitt::crc_ccitt,
>> > > +    device::{
>> > > +        AsBusDevice,
>> > > +        Bound,
>> > > +        Core, //
>> > > +    },
>> > > +    error::code,
>> > > +    new_spinlock, of,
>> > > +    prelude::*,
>> > > +    serdev,
>> > > +    sync::{
>> > > +        aref::ARef,
>> > > +        Arc,
>> > > +        SpinLock, //
>> > > +    },
>> > > +};
>> > > +
>> > > +use zerocopy::little_endian;
>> > > +use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
>> > > +
>> > > +const HDLC_MAX_FRAME_LEN: usize =3D 256;
>> > > +
>> > > +const HDLC_FRAME: u8 =3D 0x7E;
>> > > +const HDLC_ESC: u8 =3D 0x7D;
>> > > +const HDLC_XOR: u8 =3D 0x20;
>> > > +const HDLC_EXPECTED_CRC: u16 =3D 0xf0b8;
>> > > +
>> > > +const ADDRESS_GREYBUS: u8 =3D 0x01;
>> > > +
>> > > +#[repr(C, packed)]
>> > > +#[derive(FromBytes, Immutable, KnownLayout)]
>> > > +struct GreybusFrame {
>> > > +    cport: little_endian::U16,
>> > > +    msg: [u8],
>> > > +}
>> > > +
>> > > +struct HdlcRx {
>> > > +    rx_buf: KVec<u8>,
>> > > +    rx_in_esc: bool,
>> > > +    sdev: ARef<serdev::Device>,
>> > > +    node: gb_softsvc::Module,
>> > > +}
>> > > +
>> > > +impl HdlcRx {
>> > > +    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module) ->=
 Result<Self> {
>> > > +        Ok(Self {
>> > > +            node,
>> > > +            sdev,
>> > > +            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_KER=
NEL)?,
>> > > +            rx_in_esc: false,
>> > > +        })
>> > > +    }
>> > > +
>> > > +    fn frame_finish(&self) -> Result<()> {
>> > > +        if self.rx_buf.len() < 4 {
>> > > +            return Err(code::EFAULT);
>> > > +        }
>> > > +
>> > > +        let crc =3D crc_ccitt(0xffff, &self.rx_buf);
>> > > +        if crc !=3D HDLC_EXPECTED_CRC {
>> > > +            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
>> > > +            return Ok(());
>> > > +        }
>> > > +
>> > > +        let addr =3D self.rx_buf[0];
>> > > +        let _ctrl =3D self.rx_buf[1];
>> > > +        let payload =3D &self.rx_buf[2..self.rx_buf.len() - size_of=
::<u16>()];
>> > > +
>> > > +        match addr {
>> > > +            ADDRESS_GREYBUS =3D> {
>> > > +                let frame =3D GreybusFrame::ref_from_bytes(payload)=
.map_err(|_| code::EINVAL)?;
>> > > +                self.node.submit_message(0, frame.cport.into(), &fr=
ame.msg)
>> > > +            }
>> > > +            _ =3D> Err(code::EINVAL),
>> > > +        }
>> > > +    }
>> > > +
>> > > +    fn rx(&mut self, data: &[u8]) -> usize {
>> > > +        for i in data.iter() {
>> > > +            match *i {
>> > > +                HDLC_FRAME =3D> {
>> > > +                    if !self.rx_buf.is_empty() {
>> > > +                        if let Err(e) =3D self.frame_finish() {
>> > > +                            dev_warn!(self.sdev.as_ref(), "bad fram=
e: {e:?}\n");
>> > > +                        }
>> > > +                    }
>> > > +
>> > > +                    self.rx_buf.clear();
>> > > +                    self.rx_in_esc =3D false;
>> > > +                }
>> > > +                HDLC_ESC =3D> self.rx_in_esc =3D true,
>> > > +                _ =3D> {
>> > > +                    let c =3D if self.rx_in_esc { *i ^ HDLC_XOR } e=
lse { *i };
>> > > +                    self.rx_in_esc =3D false;
>> > > +
>> > > +                    if self.rx_buf.push_within_capacity(c).is_err()=
 {
>> > > +                        dev_warn!(self.sdev.as_ref(), "buffer overf=
low. Dropping frame");
>> > > +
>> > > +                        self.rx_buf.clear();
>> > > +                        self.rx_in_esc =3D false;
>> > > +                    }
>> > > +                }
>> > > +            }
>> > > +        }
>> > > +
>> > > +        data.len()
>> > > +    }
>> > > +}
>> > > +
>> > > +struct GbNode {
>> > > +    sdev: ARef<serdev::Device>,
>> > > +}
>> > > +
>> > > +impl GbNode {
>> > > +    const fn new(sdev: ARef<serdev::Device>) -> Self {
>> > > +        Self { sdev }
>> > > +    }
>> > > +
>> > > +    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -> R=
esult<u16> {
>> > > +        for i in data {
>> > > +            crc =3D crc_ccitt(crc, &[*i]);
>> > > +            if *i =3D=3D HDLC_ESC || *i =3D=3D HDLC_FRAME {
>> > > +                buf.push_within_capacity(HDLC_ESC)?;
>> > > +                buf.push_within_capacity(i ^ HDLC_XOR)?;
>> > > +            } else {
>> > > +                buf.push_within_capacity(*i)?;
>> > > +            }
>> > > +        }
>> > > +
>> > > +        Ok(crc)
>> > > +    }
>> > > +}
>> > > +
>> > > +impl gb_softsvc::InterfaceOps for GbNode {
>> > > +    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Re=
sult<()> {
>> > > +        // SAFETY: `GbNode` only exists while its serdev driver is =
bound, so the device is in the
>> > > +        // `Bound` state for the duration of this call.
>> > > +        let bound: &serdev::Device<Bound> =3D
>> > > +            unsafe { serdev::Device::from_device(self.sdev.as_ref()=
.as_bound()) };
>> > > +
>> > > +        let mut buf =3D KVec::with_capacity(HDLC_MAX_FRAME_LEN, gfp=
_mask)?;
>> > > +
>> > > +        let mut crc =3D 0xffff;
>> > > +
>> > > +        buf.push_within_capacity(HDLC_FRAME)?;
>> > > +
>> > > +        crc =3D Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &mut =
buf)?;
>> > > +        crc =3D Self::fill_buf(crc, &cport.to_le_bytes(), &mut buf)=
?;
>> > > +        crc =3D Self::fill_buf(crc, data, &mut buf)?;
>> > > +
>> > > +        crc ^=3D 0xffff;
>> > > +        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
>> > > +
>> > > +        buf.push_within_capacity(HDLC_FRAME)?;
>> > > +
>> > > +        bound.write_all(&buf, 0)?;
>> > > +
>> > > +        Ok(())
>> > > +    }
>> > > +}
>> > > +
>> > > +#[pin_data]
>> > > +struct GbUartNode {
>> > > +    #[pin]
>> > > +    rx: SpinLock<Option<HdlcRx>>,
>> > (add me to CC please)
>> >=20
>> > Instead of using a lock here, it might be a better idea to
>> > synchronize/stop the receive callback before unbind is called in the
>> > serdev rust abstraction. This would allow the abstraction to provide
>> > mutable references to the driver data in `receive` and `unbind`. It
>> > would also remove the Sync requirement.
>> >=20
>> > I will send a patch soon.
>> >=20
>> > Thanks
>> > - Markus Probst
>>=20
>> That sounds great. The lock here was basically only for getting a mut=20
>> ref. I will base the next version on top of your patches.
>>=20
>> I have added your email for the next patch version.
> It appears that "would break the driver core's lifetime design", so I
> have to drop the patch.
>
> You will still need the SpinLock.

You can still do sychronization to allow this, just not using things from
drvdata. For example, if you move this "active: Mutex<bool>" to be part of
`serdev_device`, then you don't need to access `drvdata` to set the active
field.

That'll be actually more inline with what other buses are doing, where drvd=
ata
is exclusively for the drivers, and for the bus.

Best,
Gary

