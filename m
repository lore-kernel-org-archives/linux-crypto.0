Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB72C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 04:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5375460241
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 04:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhDSERb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 00:17:31 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16642 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSERb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 00:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618805822; x=1650341822;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=McsUGMuKvrDeIA3yiCor6sJnnKw6deehpFoFc7ZGu6E=;
  b=sagvzia0YWTGoerqNvadlFe4ExTuBQTacWe4TBF5xeTYef7c5iY6hgTj
   6p/t1ZwHaY7XDLUFUJ+j0u58QVe+Cc45Fde6GCNWNPGlxKrslIuKoM4kL
   sIMe7y9/l+I7caW0QkRnAO5HZHybxNEXO8aoEJBImyiJueU3P4xkYib+0
   o=;
X-IronPort-AV: E=Sophos;i="5.82,233,1613433600"; 
   d="scan'208";a="106773150"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Apr 2021 04:16:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id BFD58A1A43
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 04:16:14 +0000 (UTC)
Received: from EX13D46UWB001.ant.amazon.com (10.43.161.16) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Apr 2021 04:16:14 +0000
Received: from EX13D46UWB003.ant.amazon.com (10.43.161.117) by
 EX13D46UWB001.ant.amazon.com (10.43.161.16) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Apr 2021 04:16:13 +0000
Received: from EX13D46UWB003.ant.amazon.com ([10.43.161.117]) by
 EX13D46UWB003.ant.amazon.com ([10.43.161.117]) with mapi id 15.00.1497.015;
 Mon, 19 Apr 2021 04:16:13 +0000
From:   "Mothershead, Hailey" <hailmo@amazon.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: jitterentropy - change back to module_init()
Thread-Topic: [PATCH] crypto: jitterentropy - change back to module_init()
Thread-Index: AQHXMkfbGHH2KUsBa06bT7LoVPktnqq6yAYAgAADiYA=
Date:   Mon, 19 Apr 2021 04:16:13 +0000
Message-ID: <4C32DE1B-7EED-432F-8BAE-4BA890ADAACC@amazon.com>
References: <9A0645BD-E7B0-4A7B-BB8F-80C5616502FE@amazon.com>
 <5289E5EC-C15F-44EB-BC5F-C5A515FFF272@amazon.com>
In-Reply-To: <5289E5EC-C15F-44EB-BC5F-C5A515FFF272@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.41]
Content-Type: text/plain; charset="utf-8"
Content-ID: <61E3D59EC234014781E59D08E575249D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8sDQrCoA0KVGhlIHBhdGNoIHF1b3RlZCBiZWxvdyBjYXVzZXMgdGhlIGtlcm5lbCB0byBw
YW5pYyB3aGVuIGZpcHMgaXMgZW5hYmxlZCB3aXRoOg0KICAgICAgIMKgDQogICAgICAgYWxnOiBl
Y2RoOiB0ZXN0IGZhaWxlZCBvbiB2ZWN0b3IgMiwgZXJyPS0xNA0KICAgICAgIEtlcm5lbCBwYW5p
YyAtIG5vdCBzeW5jaW5nOiBhbGc6IHNlbGYtdGVzdHMgZm9yIGVjZGgtZ2VuZXJpYyAoZWNkaCkg
ZmFpbGVkIGluIGZpcHMgbW9kZSENCsKgDQpUaGlzIHRlc3QgZmFpbHMgYmVjYXVzZSBqaXR0ZXJl
bnRyb3B5IGhhc27igJl0IGJlZW4gaW5pdGlhbGl6ZWQgeWV0LiBUaGUgYXNzdW1wdGlvbiB0aGF0
IHRoZSBwYXRjaCBtYWtlcywgdGhhdCBqaXR0ZXIgaXMgbm90IHVzZWQgYnkgdGhlIGNyeXB0byBz
ZWxmLXRlc3RzLCBkb2VzIG5vdCBob2xkIHdpdGggZmlwcyBlbmFibGVkLg0KwqANCldpdGggdGhl
IHBhdGNoIHJldmVydGVkLCBpLmUuIHdpdGggaml0dGVyIGluaXRpYWxpemVkIHdpdGggbW9kdWxl
X2luaXQsIHRoZSBrZXJuZWwgaXMgYWJsZSB0byBib290LiBIb3cgY2FuIHRoaXMgYmVzdCBiZSBo
YW5kbGVkIHRvIGFsbG93IHRoZSBrZXJuZWwgdG8gYm9vdCB3aXRoIGZpcHMgZW5hYmxlZCB3aXRo
b3V0IHJ1bm5pbmcgaW50byBpc3N1ZXMgd2l0aCBjZXJ0YWluIGNsb2Nrc291cmNlcz8NCsKgDQpC
ZXN0LCANCkhhaWxleQ0KwqANCkZyb20gOWM1YjM0YzJmN2ViMDE5NzZhNWFhMjljY2RiNzg2YTYz
NGUzZDFlMCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCkZyb206IEVyaWMgQmlnZ2VycyA8ZWJp
Z2dlcnNAZ29vZ2xlLmNvbT4NCkRhdGU6IFR1ZSwgMjEgTWF5IDIwMTkgMTE6NDY6MjIgLTA3MDAN
ClN1YmplY3Q6IFtQQVRDSF0gY3J5cHRvOiBqaXR0ZXJlbnRyb3B5IC0gY2hhbmdlIGJhY2sgdG8g
bW9kdWxlX2luaXQoKQ0KwqANCiJqaXR0ZXJlbnRyb3B5X3JuZyIgZG9lc24ndCBoYXZlIGFueSBv
dGhlciBpbXBsZW1lbnRhdGlvbnMsIG5vciBpcyBpdA0KdGVzdGVkIGJ5IHRoZSBjcnlwdG8gc2Vs
Zi10ZXN0cy7CoCBTbyBpdCB3YXMgdW5uZWNlc3NhcnkgdG8gY2hhbmdlIGl0IHRvDQpzdWJzeXNf
aW5pdGNhbGwuwqAgQWxzbyBpdCBkZXBlbmRzIG9uIHRoZSBtYWluIGNsb2Nrc291cmNlIGJlaW5n
DQppbml0aWFsaXplZCwgd2hpY2ggbWF5IGhhcHBlbiBhZnRlciBzdWJzeXNfaW5pdGNhbGwsIGNh
dXNpbmcgdGhpcyBlcnJvcjoNCsKgDQrCoMKgwqAgaml0dGVyZW50cm9weTogSW5pdGlhbGl6YXRp
b24gZmFpbGVkIHdpdGggaG9zdCBub3QgY29tcGxpYW50IHdpdGggcmVxdWlyZW1lbnRzOiAyDQrC
oA0KQ2hhbmdlIGl0IGJhY2sgdG8gbW9kdWxlX2luaXQoKS4NCsKgDQpGaXhlczogYzQ3NDFiMjMw
NTk3ICgiY3J5cHRvOiBydW4gaW5pdGNhbGxzIGZvciBnZW5lcmljIGltcGxlbWVudGF0aW9ucyBl
YXJsaWVyIikNClJlcG9ydGVkLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02
OGsub3JnPg0KU2lnbmVkLW9mZi1ieTogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0Bnb29nbGUuY29t
Pg0KVGVzdGVkLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJl
Pg0KU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
Pg0KLS0tDQpjcnlwdG8vaml0dGVyZW50cm9weS1rY2FwaS5jIHwgMiArLQ0KMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQrCoA0KZGlmZiAtLWdpdCBhL2NyeXB0
by9qaXR0ZXJlbnRyb3B5LWtjYXBpLmMgYi9jcnlwdG8vaml0dGVyZW50cm9weS1rY2FwaS5jDQpp
bmRleCA2ZWExYTI3MGI4ZGMuLjc4N2RjY2NhMzcxNSAxMDA2NDQNCi0tLSBhL2NyeXB0by9qaXR0
ZXJlbnRyb3B5LWtjYXBpLmMNCisrKyBiL2NyeXB0by9qaXR0ZXJlbnRyb3B5LWtjYXBpLmMNCkBA
IC0xOTgsNyArMTk4LDcgQEAgc3RhdGljIHZvaWQgX19leGl0IGplbnRfbW9kX2V4aXQodm9pZCkN
CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3J5cHRvX3VucmVnaXN0ZXJfcm5nKCZqZW50
X2FsZyk7DQp9DQotc3Vic3lzX2luaXRjYWxsKGplbnRfbW9kX2luaXQpOw0KK21vZHVsZV9pbml0
KGplbnRfbW9kX2luaXQpOw0KbW9kdWxlX2V4aXQoamVudF9tb2RfZXhpdCk7DQrCoE1PRFVMRV9M
SUNFTlNFKCJEdWFsIEJTRC9HUEwiKTsNCi0tIA0KMi4xNi42DQrCoA0KDQo=
