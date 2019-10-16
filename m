Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A663AFA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B2B2082C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="S1dIOLgH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404952AbfJPLbj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 07:31:39 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:18868 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404936AbfJPLbj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 07:31:39 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GBQG43023848;
        Wed, 16 Oct 2019 13:29:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=LG7dUwNIu0+LFfdXsArrTdZw8lqv6tMm88WzwKR6KrA=;
 b=S1dIOLgHhlnWOXh0gObHc7UsclwUejJlDnyrM1B+IDgosRXzZubyieCbZiLXGnEqlKYL
 hpd61tPz7LkYexBy/HvcgZ45lzNg6K5RFrtQsR1/CsvmQpM0HL/LOKFVqbEJoCrjqRaJ
 /E9EoqdTnfvZ+edK6JdPaQOvWKFGFEXldD9L/94lcNehviIcFV2PYLDKjiVqFaJ1Wjsg
 dwmH1cOV1yvdz2fcgJRj41SW6+7vKlTL7PDE7rlsl1xD4adXDF9AaC3xXAi5DlfpperF
 v7x4omaQWAxF3KYwgM0sjlCaITEkEpA4SQIgW0FP7lZAToaCZOv54Gin4gnBg888vRQx Zw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vk3y9x8wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 13:29:19 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7D01310002A;
        Wed, 16 Oct 2019 13:29:16 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node2.st.com [10.75.127.17])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 38E132074CE;
        Wed, 16 Oct 2019 13:29:16 +0200 (CEST)
Received: from SFHDAG6NODE3.st.com (10.75.127.18) by SFHDAG6NODE2.st.com
 (10.75.127.17) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed, 16 Oct
 2019 13:29:15 +0200
Received: from SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6]) by
 SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6%20]) with mapi id
 15.00.1473.003; Wed, 16 Oct 2019 13:29:15 +0200
From:   Patrice CHOTARD <patrice.chotard@st.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "sbranden@broadcom.com" <sbranden@broadcom.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "eric@anholt.net" <eric@anholt.net>,
        "wahrenst@gmx.net" <wahrenst@gmx.net>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "dsaxena@plexity.net" <dsaxena@plexity.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rpi-kernel@lists.infradead.org" 
        <linux-rpi-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH -next 11/13] hwrng: st - use
 devm_platform_ioremap_resource() to simplify code
Thread-Topic: [PATCH -next 11/13] hwrng: st - use
 devm_platform_ioremap_resource() to simplify code
Thread-Index: AQHVhA8R7X2BGSeJiEmwGCSOAcwdJ6ddADyA
Date:   Wed, 16 Oct 2019 11:29:15 +0000
Message-ID: <d9fd5224-a858-e7ea-eb71-2ed6696a6ffd@st.com>
References: <20191016104621.26056-1-yuehaibing@huawei.com>
 <20191016104621.26056-12-yuehaibing@huawei.com>
In-Reply-To: <20191016104621.26056-12-yuehaibing@huawei.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.46]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3EF5CC03322D04D91346E3040ABD037@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_04:2019-10-16,2019-10-16 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkNCg0KT24gMTAvMTYvMTkgMTI6NDYgUE0sIFl1ZUhhaWJpbmcgd3JvdGU6DQo+IFVzZSBkZXZt
X3BsYXRmb3JtX2lvcmVtYXBfcmVzb3VyY2UoKSB0byBzaW1wbGlmeSB0aGUgY29kZSBhIGJpdC4N
Cj4gVGhpcyBpcyBkZXRlY3RlZCBieSBjb2NjaW5lbGxlLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBZ
dWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9jaGFy
L2h3X3JhbmRvbS9zdC1ybmcuYyB8IDQgKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3
X3JhbmRvbS9zdC1ybmcuYyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vc3Qtcm5nLmMNCj4gaW5k
ZXggODYzNDQ4My4uNzgzYzI0ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jaGFyL2h3X3JhbmRv
bS9zdC1ybmcuYw0KPiArKysgYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL3N0LXJuZy5jDQo+IEBA
IC03Miw3ICs3Miw2IEBAIHN0YXRpYyBpbnQgc3Rfcm5nX3JlYWQoc3RydWN0IGh3cm5nICpybmcs
IHZvaWQgKmRhdGEsIHNpemVfdCBtYXgsIGJvb2wgd2FpdCkNCj4gIHN0YXRpYyBpbnQgc3Rfcm5n
X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICB7DQo+ICAJc3RydWN0IHN0
X3JuZ19kYXRhICpkZGF0YTsNCj4gLQlzdHJ1Y3QgcmVzb3VyY2UgKnJlczsNCj4gIAlzdHJ1Y3Qg
Y2xrICpjbGs7DQo+ICAJdm9pZCBfX2lvbWVtICpiYXNlOw0KPiAgCWludCByZXQ7DQo+IEBAIC04
MSw4ICs4MCw3IEBAIHN0YXRpYyBpbnQgc3Rfcm5nX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpDQo+ICAJaWYgKCFkZGF0YSkNCj4gIAkJcmV0dXJuIC1FTk9NRU07DQo+ICANCj4g
LQlyZXMgPSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9NRU0sIDApOw0K
PiAtCWJhc2UgPSBkZXZtX2lvcmVtYXBfcmVzb3VyY2UoJnBkZXYtPmRldiwgcmVzKTsNCj4gKwli
YXNlID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKHBkZXYsIDApOw0KPiAgCWlmIChJ
U19FUlIoYmFzZSkpDQo+ICAJCXJldHVybiBQVFJfRVJSKGJhc2UpOw0KPiAgDQoNClJldmlld2Vk
LWJ5OiBQYXRyaWNlIENob3RhcmQgPHBhdHJpY2UuY2hvdGFyZEBzdC5jb20+DQoNClRoYW5rcw0K
