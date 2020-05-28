Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A20C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 09:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5869E208E4
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 09:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="aF2Ya9KZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgE1JGG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 05:06:06 -0400
Received: from mail-eopbgr20090.outbound.protection.outlook.com ([40.107.2.90]:33954
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbgE1JGG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 05:06:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHMNE1GJSgOEi6szWaTZQtIxIc1jN/Bs5BQx+zpt1FLQtEfWH5/DNK+wotIx7iCOanpXL+6VgD9YQODF45kx/tfaKLtOz2roeKAYrsI5t8k8SYILiLJGxssMyeVyD28qyXHLM7Ms4mGHiehs5GSdMShOolpfJQ4S9glNZaJFLu0BVIzOBcFKHAmzqXvssYPA3ap4V9CP0h5EaR96MWS4P1VX/BAsW6zQLH6KFiMHIQ6d1rl1GplB2A/MmkjRsjNux74z/VLDgCrW14PnB2rVOhk2mzipsOhZvNvyhrW5mGb+o2snfOzOVRPKO13/slh7yt8iRZ3Acoo56FBlj1NSoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkezDt131EPJYG5chw2hWW4RkYqjVomz7cpkispl9Ps=;
 b=DwbtPYavRn8qnkVsc2b2a4UHiCwFgvaOU5YrEnKSTJrkmvuhm53taoZrLHrpmHx4Ch/3tDBH+2V/dBWJjbPuhuClgFbw9zE6261DDACXtKI7rTF3zuzvmLBBhV1TDu75Oh2XJTA16Ysshvqjx5cjZ1Fia72EOvUKabq+rev/jdbUwy8y2wCA+8zX8cETzIAN6BR/wGP3IVuN7r9YTICzQJ8WY/lzqp5ZVNNko1uPxepXOsjAFzI1zrCOHAnytm2RJTaXgxFMJ4gDhECUYItTrFdV9N/0cHxTOOgqbOzzpdCMhp2cYFe2gXvCvrb6bSVCvcE8uI0Hxzdseu0RUzEYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkezDt131EPJYG5chw2hWW4RkYqjVomz7cpkispl9Ps=;
 b=aF2Ya9KZl8pvGDeTi4thuswz9HVAri0oymMy2b1+a2UepaU3BVRZkAb0toYU3nVhSJl6ZLAl5W1uiyLOIFDsyLg8HMy1549QlPnvSjUoBg/tGkK4tAV4wX1pk52zkbwIXoRFWt1x2rL6jL2n3G1P05XWg8CKfGcpdPvoUqC0av8=
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB4018.eurprd07.prod.outlook.com (2603:10a6:208:48::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8; Thu, 28 May
 2020 09:06:03 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82%4]) with mapi id 15.20.3066.007; Thu, 28 May 2020
 09:06:03 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "dinghao.liu@zju.edu.cn" <dinghao.liu@zju.edu.cn>,
        "kjlu@umn.edu" <kjlu@umn.edu>
CC:     "mpm@selenic.com" <mpm@selenic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] hwrng: ks-sa - Fix runtime PM imbalance on error
Thread-Topic: [PATCH] [v2] hwrng: ks-sa - Fix runtime PM imbalance on error
Thread-Index: AQHWNMCb9mSYDuCNCEaSWl1hJI18sKi9NOoA
Date:   Thu, 28 May 2020 09:06:03 +0000
Message-ID: <8592887a502e174b076f16846704fac43885aa5b.camel@nokia.com>
References: <20200528072106.5191-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200528072106.5191-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a48336d-458d-4f5c-24b8-08d802e6590a
x-ms-traffictypediagnostic: AM0PR07MB4018:
x-microsoft-antispam-prvs: <AM0PR07MB40181AC34E8DAC4B7D718A87888E0@AM0PR07MB4018.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TNeVCTFWnm4PhsV1Fy4syUZ88s9mc5UxXlocxPD+8Z8+d0+VZGgO8XJE4MXriqrpHH/oSMiWXG6TeKOisjwXLJLUWFmdng0Tbd9kms4svCejJpDhJlgpe2WXKL4p9mzIsgdFd+/I9MWHc7UbClsk4hZQuztLYbd5MRd80lGSgiY7CxPlDvaOU26fG5OFob9b7Kb8zYTVQmNYRXs4CajJnamfThSAbjvxziQ9XwuZ4zJBUNz7cU8co4PpvvN1hGf4i9u80+4dUjVXn5PsH6gzDxQMYjeUK/vxYVhScAKavIrmeBIAGvdGVnQgJUs3sW9FbefLiY7JgTpZ52/p4S0Ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(8936002)(54906003)(6512007)(110136005)(36756003)(2616005)(478600001)(4326008)(6486002)(5660300002)(71200400001)(8676002)(2906002)(6506007)(316002)(86362001)(186003)(26005)(64756008)(66476007)(66446008)(66946007)(66556008)(91956017)(76116006)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3ALc/5LmaSlq7TcPrdEEQBIYJqHYxilfNX75B89nraBOaz3xpfD0l0pVPYif0BbNh9lmkcfzs5+bYyXsYZ6N3hAFSAvh2ElJeKF2vyS/jKNzIXk7mKYVLuHvKW9CbO2bnv2RYziBklHkOjIniEzmlAgCSi1lSqGqMNGk1Z7Otw4HpThOj616VuTX5v9uwATtEm3aUtbXm0WPQC5/7wP2+ao3aSQ414molZbMVcGa7DT/E1CQuKVTXFtuwlFXgIaDg6+tGiX9Iwo4FbjOYiZqxAq9kT/mfOnIfBN3u0qHnLCTDe+Tz99nPPdQlf89OhyJswhyuCts2zoI+f9XPf9/orwSS5RcW7/dTRfoZvVHiInIjFhzLKy39tb1ELFBi9pmLHog78vkrx89Ret9ZLOgGZBcmKeqmdfFxsCtxoDPVdQSPaq6x+7YYdyLe3h00Ro+lrRun8tlJOg9NAGcCDzf09nT7SrVHKegPVD4abUjjbY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4326AC2BF077EC4999B0E514A237761A@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a48336d-458d-4f5c-24b8-08d802e6590a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 09:06:03.1686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /9wO0mlP0A/uwM/sJpbQ86uQxFUTQiKgF79vfOOuB6XhOXHqZRdXe19A4fv2paY+DEqV1y4SpCK1+YS21sc0bbvoSSRMRjbVzJuRBvJhC0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB4018
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gRGluZ2hhbywNCg0KT24gVGh1LCAyMDIwLTA1LTI4IGF0IDE1OjIxICswODAwLCBEaW5n
aGFvIExpdSB3cm90ZToNCj4gcG1fcnVudGltZV9nZXRfc3luYygpIGluY3JlbWVudHMgdGhlIHJ1
bnRpbWUgUE0gdXNhZ2UgY291bnRlciBldmVuDQo+IHRoZSBjYWxsIHJldHVybnMgYW4gZXJyb3Ig
Y29kZS4gVGh1cyBhIHBhaXJpbmcgZGVjcmVtZW50IGlzIG5lZWRlZA0KPiBvbiB0aGUgZXJyb3Ig
aGFuZGxpbmcgcGF0aCB0byBrZWVwIHRoZSBjb3VudGVyIGJhbGFuY2VkLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+DQoNClJldmlld2Vk
LWJ5OiBBbGV4YW5kZXIgU3ZlcmRsaW4gPGFsZXhhbmRlci5zdmVyZGxpbkBub2tpYS5jb20+DQoN
Cj4gLS0tDQo+IA0KPiBDaGFuZ2Vsb2c6DQo+IA0KPiB2MjogLSBVc2UgcG1fcnVudGltZV9wdXRf
bm9pZGxlKCkgaW5zdGVhZCBvZiBwbV9ydW50aW1lX3B1dF9zeW5jKCkuDQo+IC0tLQ0KPiAgZHJp
dmVycy9jaGFyL2h3X3JhbmRvbS9rcy1zYS1ybmcuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRv
bS9rcy1zYS1ybmcuYyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20va3Mtc2Etcm5nLmMNCj4gaW5k
ZXggZTIzMzBlNzU3ZjFmLi4wMDE2MTcwMzNkNmEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY2hh
ci9od19yYW5kb20va3Mtc2Etcm5nLmMNCj4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9r
cy1zYS1ybmcuYw0KPiBAQCAtMjQ0LDYgKzI0NCw3IEBAIHN0YXRpYyBpbnQga3Nfc2Ffcm5nX3By
b2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJcmV0ID0gcG1fcnVudGltZV9n
ZXRfc3luYyhkZXYpOw0KPiAgCWlmIChyZXQgPCAwKSB7DQo+ICAJCWRldl9lcnIoZGV2LCAiRmFp
bGVkIHRvIGVuYWJsZSBTQSBwb3dlci1kb21haW5cbiIpOw0KPiArCQlwbV9ydW50aW1lX3B1dF9u
b2lkbGUoZGV2KTsNCj4gIAkJcG1fcnVudGltZV9kaXNhYmxlKGRldik7DQo+ICAJCXJldHVybiBy
ZXQ7DQo+ICAJfQ0KLS0gDQpBbGV4YW5kZXIgU3ZlcmRsaW4uDQoNCg==
