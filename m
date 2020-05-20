Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E62CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 15:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D64A20708
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 15:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="K193NDNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgETPmV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 11:42:21 -0400
Received: from mail-db8eur05on2106.outbound.protection.outlook.com ([40.107.20.106]:51767
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbgETPmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 11:42:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xk6YGNCtIZQc06q3HAiv9UshFxNQJXQi/cV+GszszEnJqrD7xAYb+jtmshfEiZ4r9kJ2ycxECZS2bNN3ApVYdeYo/6WBtBgY6skPzzNRwwNWqzmIlOnzk09Q0tk9MD8cOsokfmlkKt7Iyd3FIRv6nSUxt6ZK4C45L1FpTWyTX1/0I/azUz4lnpb8hlZFUB5/hZHL2gma/xUKIvyYd5gL2aFFxHAJ9ypQ59smQeWJq4Rb8xr1o6xj4yb9TojIFGf7Etpqn55ExXhBaUWrFgMziweHSokhcQur5FCBEAZn2NBAYJuBBW9mXU5K+uZ0DomLzW1Cdu9OplDzQ3FELCqNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQUkz8x58t4OhVKcHEhH3U7e1KDD6eGusT0wHZXHnd8=;
 b=ULTN+Jg2Q3RKfTHOFpEJ68z+s5YZCjAaPFoqgd/rXw5sCCR9AdmJJyWKad/wiTBIf5ZRMhjXb+KarxIIxu1dn0AmfZVlvWVcv0vx4FpeJ3S7FmbzosjultF14J6K34pxbZbWdyskoCURSs5gxTjZykvH6cd6JpcC1AmAjX6p7pwceHd0PayGMk+VRdktx4xZ9kHkYg6nbmCu1tHlzRdlCNcWh7L6GYo1tXq/bBgUdt96LI7loOmyo8/7nrHZGNYn3amgkI/9HHq9mwIvvIUBMRGi7le+HaYN4MbP+wbZNROdhEFIADM+uLLSfW3M0hR6mRd8ngnaS8zu8e3J88xmOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQUkz8x58t4OhVKcHEhH3U7e1KDD6eGusT0wHZXHnd8=;
 b=K193NDNdsuaJQHBtol1IkyNJHaEd8S8pIvKi8TEyRFbq86FMenqtFx9zcf0IZVDZnBqfpSk1r4Sw26OdgRESYEIYeVw+lO4nnywH5bGzVPl56qcj6hH+J8bJuyFPbxh80NukexMAmnKm4ZKdDkjB1fJhrve8Rgf9kThQcZKZWmc=
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB6260.eurprd07.prod.outlook.com (2603:10a6:20b:15a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.12; Wed, 20 May
 2020 15:42:17 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db%7]) with mapi id 15.20.3021.019; Wed, 20 May 2020
 15:42:17 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "dinghao.liu@zju.edu.cn" <dinghao.liu@zju.edu.cn>,
        "kjlu@umn.edu" <kjlu@umn.edu>
CC:     "mpm@selenic.com" <mpm@selenic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "rfontana@redhat.com" <rfontana@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] hwrng: ks-sa - fix runtime pm imbalance on error
Thread-Topic: [PATCH] hwrng: ks-sa - fix runtime pm imbalance on error
Thread-Index: AQHWLqrc5p0U1ZS6x0GMW4HdJHCe3aixHSWA
Date:   Wed, 20 May 2020 15:42:17 +0000
Message-ID: <ab400cba7523e69b15360b0928cb8fa8b9432d86.camel@nokia.com>
References: <20200520132957.18776-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200520132957.18776-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: rowland.harvard.edu; dkim=none (message not signed)
 header.d=none;rowland.harvard.edu; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc38129e-8166-45ec-e135-08d7fcd46067
x-ms-traffictypediagnostic: AM0PR07MB6260:
x-microsoft-antispam-prvs: <AM0PR07MB6260FC377AECCE53D99AFC6B88B60@AM0PR07MB6260.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S5/KZdiGEkzl8qTqBUeQq8In2XURDkhuxyU1JcfeiTGhfNrKIdnmbXd7J8bfzSKEm7jq7SjHTJVVf5tWmzgD9h1VxetRgvq8XSCperfF53lzRdjuZ7W+7w4rdJymzmN/N6Rsr5yvlsWZUcz50izivqIQnL80y9e+wzAMSU8xNjkO50bIk4geXS+61Q8fXmWBeZkK33Q5ZgaqwJkNEGrs0T0RRPRgVsTQmw4AWBVOd6Wy71XC4+DA29EXmt1z7GlL4xBL1EMlpvCLBPAaWLWFPwjGNY7SbLLmDFI4BPqGNckZh6JRaaB2fA2fesMPh2u715JFy2TQutqMUsldlA26Lw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(66446008)(36756003)(8676002)(6512007)(76116006)(64756008)(86362001)(66556008)(8936002)(7416002)(66946007)(66476007)(91956017)(478600001)(316002)(5660300002)(26005)(6486002)(6506007)(2616005)(54906003)(4326008)(2906002)(71200400001)(186003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FWsn7Bdpjy1JK9PpkSat+A8PnsFXqt/FESF6kZbG+8wzxGn9NawGqneayTMrKvMgPuz99QMT1HZAsWYn/mHlZJ/TGoJkx2NkFRSRS5feA1zk5Y+A59SfxNw+66vLeRkx3dEBBxCZr06rQ/9xCcrJn3KpfXGXIbsRUrPnYi4FswmTULVqa6iAv7Ll4GKHx5KK96Y6XGHdXcxWgda07YI2XeBcFV4YqqYuT1opeASiZrDS98lU2JyCh9JZQz0VufVYwm8y3sumXElP714vbD7BjBb4zRZgu3Em9bEniu9decbCiMMwmX3hTaamsxBwtzrrAegKLWGJPLQ3mYfIA7WSzhw6k8rsI345MnbsEktdbgfVh1Wui783+IAXhd32bWP/f1DIbbSRsr2xOBUcgJHWbsblkAogwXak/3PU3EhQOp5AZ0TNCy3kiGcL2iLroW5kNR8R7teNlUoJMClWUxX9VLC9Q8srEJSLrllXPfXStqY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCD2A50CC19AFE479D3DF980CBF50299@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc38129e-8166-45ec-e135-08d7fcd46067
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 15:42:17.5792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODD24Uc/XI8l/YjAuUMkkQbJoccz3N0NElKdYIbMvoMq+kSQnNmEilZGRyu6e7oKwuZfpyBWgIjrcHWw1Yi3G4K5J59ji9gV3uoHom+DvZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6260
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gRGluZ2hhbywNCg0KT24gV2VkLCAyMDIwLTA1LTIwIGF0IDIxOjI5ICswODAwLCBEaW5n
aGFvIExpdSB3cm90ZToNCj4gcG1fcnVudGltZV9nZXRfc3luYygpIGluY3JlbWVudHMgdGhlIHJ1
bnRpbWUgUE0gdXNhZ2UgY291bnRlciBldmVuDQo+IHRoZSBjYWxsIHJldHVybnMgYW4gZXJyb3Ig
Y29kZS4gVGh1cyBhIHBhaXJpbmcgZGVjcmVtZW50IGlzIG5lZWRlZA0KPiBvbiB0aGUgZXJyb3Ig
aGFuZGxpbmcgcGF0aCB0byBrZWVwIHRoZSBjb3VudGVyIGJhbGFuY2VkLg0KDQpJIGJlbGlldmUs
IHRoaXMgaXMgdGhlIHdyb25nIHBsYWNlIGZvciBzdWNoIGtpbmQgb2YgZml4Lg0KcG1fcnVudGlt
ZV9nZXRfc3luYygpIGhhcyBvYnZpb3VzbHkgYSBicm9rZW4gc2VtYW50aWNzIHdpdGggcmVnYXJk
cyB0bw0KeW91ciBvYnNlcnZhdGlvbiBidXQgbm8gb3RoZXIgZHJpdmVyIGRvZXMgd2hhdCB5b3Ug
cHJvcG9zZS4NCkkgdGhpbmsgdGhlIHByb3BlciBmaXggYmVsb25nIGludG8gUE0gc3Vic3lzdGVt
LCBwbGVhc2UgdGFrZSBhIGxvb2sNCm9udG8gY29tbWl0IDE1YmNiOTFkN2U2MCAiUE0gLyBSdW50
aW1lOiBJbXBsZW1lbnQgYXV0b3N1c3BlbmQgc3VwcG9ydCIuDQoNCj4gU2lnbmVkLW9mZi1ieTog
RGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+DQo+IC0tLQ0KPiAgZHJpdmVycy9j
aGFyL2h3X3JhbmRvbS9rcy1zYS1ybmcuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9rcy1z
YS1ybmcuYyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20va3Mtc2Etcm5nLmMNCj4gaW5kZXggZTIz
MzBlNzU3ZjFmLi44NWM4MWRhNGE4YWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY2hhci9od19y
YW5kb20va3Mtc2Etcm5nLmMNCj4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9rcy1zYS1y
bmcuYw0KPiBAQCAtMjQ0LDYgKzI0NCw3IEBAIHN0YXRpYyBpbnQga3Nfc2Ffcm5nX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJcmV0ID0gcG1fcnVudGltZV9nZXRfc3lu
YyhkZXYpOw0KPiAgCWlmIChyZXQgPCAwKSB7DQo+ICAJCWRldl9lcnIoZGV2LCAiRmFpbGVkIHRv
IGVuYWJsZSBTQSBwb3dlci1kb21haW5cbiIpOw0KPiArCQlwbV9ydW50aW1lX3B1dF9zeW5jKGRl
dik7DQo+ICAJCXBtX3J1bnRpbWVfZGlzYWJsZShkZXYpOw0KPiAgCQlyZXR1cm4gcmV0Ow0KPiAg
CX0NCi0tIA0KQWxleGFuZGVyIFN2ZXJkbGluLg0KDQo=
