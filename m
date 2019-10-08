Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208A0ECE58C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 01:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0192206BB
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 01:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfJHBAm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 21:00:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:44720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728983AbfJHBAm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 21:00:42 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 3E7B1753A4C8525F0019;
        Tue,  8 Oct 2019 09:00:22 +0800 (CST)
Received: from dggeme711-chm.china.huawei.com (10.1.199.107) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 8 Oct 2019 09:00:21 +0800
Received: from dggeme759-chm.china.huawei.com (10.3.19.105) by
 dggeme711-chm.china.huawei.com (10.1.199.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 8 Oct 2019 09:00:21 +0800
Received: from dggeme759-chm.china.huawei.com ([10.7.64.73]) by
 dggeme759-chm.china.huawei.com ([10.7.64.73]) with mapi id 15.01.1713.004;
 Tue, 8 Oct 2019 09:00:21 +0800
From:   "tiantao (H)" <tiantao6@huawei.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGNyeXB0bzogZml4IGNvbXBhcmlzb24gb2YgdW5z?=
 =?utf-8?Q?igned_expression_warnings?=
Thread-Topic: [PATCH] crypto: fix comparison of unsigned expression warnings
Thread-Index: AQHVd2xXFUZ9TKOpNUGIIEmFgERbp6dGm3eAgAlc8LA=
Date:   Tue, 8 Oct 2019 01:00:21 +0000
Message-ID: <e5210fd7f4b4493593cbbb603d08d52c@huawei.com>
References: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
 <CAOtvUMeaRp08Go7BqdPzOaTFQKLOUTXMZfUE5pTpUNk3vM649A@mail.gmail.com>
In-Reply-To: <CAOtvUMeaRp08Go7BqdPzOaTFQKLOUTXMZfUE5pTpUNk3vM649A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.57.60.129]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGksDQoNCkkgZm91bmQgdGhpcyB3YXJuaW5nIHVzaW5nIHRoZSBjb21tYW5kICJtYWtlIGNvY2Np
Y2hlY2sgQ09DQ0k9c2NyaXB0cy9jb2NjaW5lbGxlL3Rlc3RzL3Vuc2lnbmVkX2xlc3Nlcl90aGFu
X3plcm8uY29jY2kgTU9ERT1wYXRjaCIgDQoNCkJlc3QNCg0KLS0tLS3pgq7ku7bljp/ku7YtLS0t
LQ0K5Y+R5Lu25Lq6OiBHaWxhZCBCZW4tWW9zc2VmIFttYWlsdG86Z2lsYWRAYmVueW9zc2VmLmNv
bV0gDQrlj5HpgIHml7bpl7Q6IDIwMTnlubQxMOaciDLml6UgMTg6MDANCuaUtuS7tuS6ujogdGlh
bnRhbyAoSCkgPHRpYW50YW82QGh1YXdlaS5jb20+DQrmioTpgIE6IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47IExpbnV4IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5v
cmc+OyBMaW51eGFybSA8bGludXhhcm1AaHVhd2VpLmNvbT4NCuS4u+mimDogUmU6IFtQQVRDSF0g
Y3J5cHRvOiBmaXggY29tcGFyaXNvbiBvZiB1bnNpZ25lZCBleHByZXNzaW9uIHdhcm5pbmdzDQoN
CkhpLA0KDQoNCk9uIE1vbiwgU2VwIDMwLCAyMDE5IGF0IDExOjUyIEFNIFRpYW4gVGFvIDx0aWFu
dGFvNkBodWF3ZWkuY29tPiB3cm90ZToNCj4NCj4gVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93
aW5nIHdhcm5pbmdzOg0KPiBkcml2ZXJzL2NyeXB0by9jY3JlZS9jY19hZWFkLmM6NjMwOjUtMTI6
IFdBUk5JTkc6IFVuc2lnbmVkIGV4cHJlc3Npb24gDQo+IGNvbXBhcmVkIHdpdGggemVybzogc2Vx
X2xlbiA+IDANCj4NCg0KVGhhbmtzIGZvciB0aGUgcmVwb3J0IQ0KDQpDYW4geW91IHBsZWFzZSBz
aGFyZSB3aGljaCBjb21waWxlci9hcmNoL2NvbmZpZyB5b3UgdXNlIHRoYXQgcHJvZHVjZXMgdGhp
cyB3YXJuaW5nPw0KDQpJJ20gbm90IHNlZWluZyBpdCBvbiBteSBlbmQuDQoNCk1hbnkgdGhhbmtz
LA0KR2lsYWQNCg0KPiBTaWduZWQtb2ZmLWJ5OiBUaWFuIFRhbyA8dGlhbnRhbzZAaHVhd2VpLmNv
bT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jY3JlZS9jY19hZWFkLmMgfCAyICstDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcmVlL2NjX2FlYWQuYyANCj4gYi9kcml2ZXJzL2NyeXB0
by9jY3JlZS9jY19hZWFkLmMgaW5kZXggZDNlOGZhYS4uYjE5MjkxZCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9jcnlwdG8vY2NyZWUvY2NfYWVhZC5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cmVlL2NjX2FlYWQuYw0KPiBAQCAtNTQ2LDcgKzU0Niw3IEBAIHN0YXRpYyBpbnQgY2NfYWVhZF9z
ZXRrZXkoc3RydWN0IGNyeXB0b19hZWFkICp0Zm0sIGNvbnN0IHU4ICprZXksDQo+ICAgICAgICAg
c3RydWN0IGNjX2FlYWRfY3R4ICpjdHggPSBjcnlwdG9fYWVhZF9jdHgodGZtKTsNCj4gICAgICAg
ICBzdHJ1Y3QgY2NfY3J5cHRvX3JlcSBjY19yZXEgPSB7fTsNCj4gICAgICAgICBzdHJ1Y3QgY2Nf
aHdfZGVzYyBkZXNjW01BWF9BRUFEX1NFVEtFWV9TRVFdOw0KPiAtICAgICAgIHVuc2lnbmVkIGlu
dCBzZXFfbGVuID0gMDsNCj4gKyAgICAgICBpbnQgc2VxX2xlbiA9IDA7DQo+ICAgICAgICAgc3Ry
dWN0IGRldmljZSAqZGV2ID0gZHJ2ZGF0YV90b19kZXYoY3R4LT5kcnZkYXRhKTsNCj4gICAgICAg
ICBjb25zdCB1OCAqZW5ja2V5LCAqYXV0aGtleTsNCj4gICAgICAgICBpbnQgcmM7DQo+IC0tDQo+
IDIuNy40DQo+DQoNCg0KLS0NCkdpbGFkIEJlbi1Zb3NzZWYNCkNoaWVmIENvZmZlZSBEcmlua2Vy
DQoNCnZhbHVlcyBvZiDOsiB3aWxsIGdpdmUgcmlzZSB0byBkb20hDQo=
