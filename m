Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D89DC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 04:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2A8F60E93
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 04:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhGWDv2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 23:51:28 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23007 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhGWDv1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 23:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627014721; x=1658550721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pns/gHSR9DUQmNHnEPDfq90OSQvj/a1tN3VbCi+EUa0=;
  b=GmFNribpJYO5If9WFH0cK54AUQvSYDsoOA4wEr7m3B43gIxgWgZ4PJtf
   1ztPTPa5Mq86sPDDxFA3C1u6gHe5d72RU0Hrpw/OR6HCLKGCUaWdkO9CP
   XQDC+L0TrC0S4GtqiG3Hznqf1NV0ftm5l6ZxAZeMQ3o0ipw0H+fXsmvIm
   o54gWu4N8AVNIK1636UPm2ryToe6JJqQXGEJGH+ihjzLiIxQ1QWyse1xd
   IXKJXy8RPVR7tjogHV8cwK+zmbeV6WveiOgLqzUSB2TR4Vmmw0QUkaVAI
   R/0EJwt7w4F0cwWBulZvedbTgf1D1nTSAp96cJA5k3X6bTXDVMMA7U6tC
   A==;
IronPort-SDR: dhrC9uuKqN7cal+EESYLLexlDr361NQ6cxwqFDHLXtzQ2l4VL574bh+OOWIMGnrraKYSnsAni9
 tX9h0O6M4u64xFjOSajqZh8Vgft0+6HkV/v28Cruv2u5hQeIQJgWk4x8fIGP8DsMg+mW2Uiwv9
 j7XOAvLkr5PYMq77uQDzqjS1alA8fXwsh2WmqyTugzLf7mFR+jYD9q7B2uFuwVofDiXYokyhxb
 MDmri2nmVmb1cUdAHoreIftPs7m+Ppr8GYTHh6vaNHO2ENr21EMl8kZiaQ9iFqocV8XVDxsBUm
 /rd4XX7M/5MMW7QumD0q4K8b
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="137205781"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2021 21:32:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 21:32:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 22 Jul 2021 21:32:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPCD+7yHEY9Ym2yyXmCObzVXU2FYK3TiaE3TZwbyj1cBcicMupUeLRpSPravWcGcouzk51ph1Q5th8EUYjKBTGroeOH1NUYnuiXf/hZHP5vlDQ4gxIUnUTmqWDI+f0s/l1xfHuyCaKQm5sjcjSFn4gZBk+otAloB4tPfVTQBQ1TpvtzmaqQ12DC+m08zfA0sJOvLZjjBrnWkAx+JVfgIg5WiaJFpPGythl4U4QBGAQvFtOuvM5Y3xqo8PIwpCE+RVsxQQYploJhN/5kujXIdmLR2H2DdWjihd8izgk2IpHbIcEywkB+hg/gLUCsiejCRKhENxYL/QQfYopYVneSItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pns/gHSR9DUQmNHnEPDfq90OSQvj/a1tN3VbCi+EUa0=;
 b=AFEy9B8DxxKXlICjypNIwZTVc78wCAb6Jjhm7MHAdHNMed5xcKtq7az/GiYkYKdviZ5H8f9oal1D84iMKVs/77z2kYivfjWxF6U8Za/FNS06jd9rRxnTP1VG/qGPAfx0OhYITX/3sHwsM/YEBOyodifv1sTZfi4CTS8Z+g+khytp4rr+Gc1baVKlhPlmqSB8kxvHvB0A23WKVgq+0GhaKvvdqyp2VkvztzU/1ClQ5BVrE4a2iuWS0g7dmjQtazcEBmruKF2e3e4E0UOS91QJJfqeC0mjOIQbVWcbhf5xWfF+YIGDDphaSoAvHXFuNXkD5ltPcMFqui4+VqnXkytbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pns/gHSR9DUQmNHnEPDfq90OSQvj/a1tN3VbCi+EUa0=;
 b=e2053QgtzKSmk5HPenKJ1Tq5sqlOC0bn1PtVnBe9JbY2J4a6iAMseDmqKOTVmkvZUsYx4pYI27fn0Rt9liDAif/DkWrFFhSXmHYlHH2beYOvm7tNS0GczXanZYokjr/BmCXcZAnuzCk8mgwjm1Nwxyt6gziXu7eDXNk84thJ/ck=
Received: from CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9)
 by MWHPR11MB2015.namprd11.prod.outlook.com (2603:10b6:300:28::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Fri, 23 Jul
 2021 04:31:59 +0000
Received: from CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::58e9:43d8:74e1:f266]) by CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::58e9:43d8:74e1:f266%7]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 04:31:59 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <salah.triki@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] crypto: atmel-aes: use swap()
Thread-Topic: [RESEND] crypto: atmel-aes: use swap()
Thread-Index: AQHXf3usVAlERiynyEmqNOW7p1HJmg==
Date:   Fri, 23 Jul 2021 04:31:59 +0000
Message-ID: <4d219f5a-f22c-aa6d-a229-fe43d3ee822b@microchip.com>
References: <20210722170827.GA4362@pc>
In-Reply-To: <20210722170827.GA4362@pc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5efdafe-6529-47f5-f36d-08d94d92cfad
x-ms-traffictypediagnostic: MWHPR11MB2015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2015090282765D35DAE49FE5F0E59@MWHPR11MB2015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CmdY8AiqyYIXDSTrqumQnxgthvugsB8Asrtj6b6/wWkj1pjvq1THfMbs8R5aVzE9CTS7aW32rGlyo/JGHpILUOq4sKDK6LxbDkqNoLGaXDkGXd5mb/umnvnyA+enAsMT+R+LwYlFmRwG8pgKcQKQJNzwvC7f9Gp8iUonqUfIi2d7H8DrUc+RiZdx9SxL7+R4S7OlFv3HkAeiMIVpNdcBC94o6fk67bDsje5YVbCrKsqzbtGLj9lHYykE5ZCoabt/EGWfxlPQcy4iMX21icQwjMWp0SlyKqUx0QquNO0iR7h0cttAsf0CNREcVxVzB6BA/3WmXtffTbWcbKl+38Dnu2zcmzP+gOzJBLZ57RDzL9h7+/TCAw9jwJJaKY4cQwhv2SuWEt07SVEbfn0KdkIHOUOG8EUXnkxMfC9juAn9tAchfr9igxruQLvXeb3nxZtbKTQfauZNiYb4mDV4jbfIxFNjrFl03p+QkkJgQnEoyuZEv+7LghKf5uw0r/hj+b3dhTMn7Tb7/UJMb+QNdN5i38hfqpJrlK/vPFvVryubJrUe6X02zSq9d2zbSuAE5pxFP9+QTvpo3B6qqAjdZN/O268gOvNUNMXtKq6crge3dHhaINjLvYkI8vfTpdYVgwy/SbDYdP40c8Q0i+uCVuVCXo4A0kh1WcYoqkCUHQGHYu9kQLnIWkjYz8RAnfoBI+LX3BQxlTJeUE9SZ1w5rFgdzjX7McTlqL6AOrRghU0QhJ+Qzh3I5JJGVWLdYhahhDx3eOgDF/FQ8TS77ERtYbtBFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4865.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(39860400002)(366004)(6486002)(122000001)(38100700002)(31696002)(4326008)(6506007)(83380400001)(71200400001)(6512007)(86362001)(53546011)(8676002)(64756008)(76116006)(478600001)(54906003)(110136005)(316002)(66476007)(66446008)(66556008)(26005)(91956017)(186003)(8936002)(31686004)(5660300002)(66946007)(2906002)(2616005)(36756003)(45980500001)(43740500002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?My9iK05YaDdRaC9DbUp6TVlKcnNwd0tmNHNMNGRWdDVKazF3R2VxSmVrVFJZ?=
 =?utf-8?B?dFRzOWdGQ3lTZEpVMUl4OWU4QWdFNlFwRmZDczhHVmErdjJrZnRXV3Y0bHVK?=
 =?utf-8?B?bVpVN3YreDF4ZWpjck43Z3FSZytRTnBiNzVqZHpSYW1JcUxhK2JSdUpuUlJn?=
 =?utf-8?B?WWQydkdYajdvekgwekliVVBqeGpPM2RLTE5NbGlLZnFBdnhWRkhqYk9VMzA0?=
 =?utf-8?B?dnJPQk9NUG1RaWh0bEdaVU5UdEdidDBzZWlhd0RwOE5RSGNqc0pHWUtTcXRU?=
 =?utf-8?B?U2FUOCtiaVo1SUNDRFVVVHhodnJ3R21Oa3lxZEV1K01lV1I2VlVSd2NQUzNT?=
 =?utf-8?B?NEhCZGxaL1ViQ0poczBHQ1Y4TlJZR05LQXJMU0NwV0dxM3dwUXgzOU1UQ3RS?=
 =?utf-8?B?YkU3T1BCc3BGZG5seS9xWUJwbDdsdTZhc3VoUkUzZWp6MFJpMXRMV0t1cXN2?=
 =?utf-8?B?SW5JTE94REdxcWpEOWpVanRwV3FZRTRpdGwrODEraFpuaDZsOWxRSWRFNVF6?=
 =?utf-8?B?T3Q0OTVlWUhZQ1RaYm9hdWtCT3haVVY5UWJnalJRMEFTdmNVeTNRWWFhSmhq?=
 =?utf-8?B?OE1OQW9iN2hOK0o2NFZ5UVZTWFNRR1hnU2Zqc0ZLY3lBUFBiSld6aEkyRDZH?=
 =?utf-8?B?dW9QSjdOU1FLVWVGUEtBSWZrcHRPWHRIYVROdHBJQ1lYVkxvRXhKd3pMaDU2?=
 =?utf-8?B?RnNTRFpjdG03bEFYYVhIU296Q0JUeVU4WWZLcllMSG94cDg3S0hZa0lOL3Mv?=
 =?utf-8?B?MnJxazRoQW55eXdRRnB5M3NKMXo0UG9pUDFqTm1CaWljaDN1TUdaWTdoZ09K?=
 =?utf-8?B?MzRNTFhTcjN4Nk1Mc0RtVHVzZFVHZ2dGMU5UQldOVFo1UDBIS3phaFVIYXNz?=
 =?utf-8?B?UzZGTTFpSEdCRFpCYTYzVEg5UWNZNGUzUFNQdXp5WVFCRlpXc3BWMVBoNjcw?=
 =?utf-8?B?d2htUXZyaTlHdVVscUtrOGo5MXZEYWtKeWxPUmFUZmhTTGRDdmVMNHo5L0tz?=
 =?utf-8?B?TjRtazJjNno1KzJHMXNxRTQ0MUZ2eUlZNForYnVZQ3YyNW5qbmt4WlJtNDl2?=
 =?utf-8?B?U29rbVhmd0dzYzVPOHJRZEJ4aE9KNWZrNGRRQnB5R1Z5Ui9PVUpuWENoQ3ll?=
 =?utf-8?B?TElwVlBxaWdlWDRIc0o0Vzl2cXBmeE9GOFovWG1wYVNUcll5SG15NUtLVGlD?=
 =?utf-8?B?Z2xEV2VVNjBSM0xUdW92Yzl2V0RSYm0xa1ZOclp2bmZienNWZWFEM3RWTkVL?=
 =?utf-8?B?a3ZmZU5oT2ZHU0xjd241d09HVnJBcm5SYmVqVzdlTGFDaDZaNHd3VkFHUUd2?=
 =?utf-8?B?R1lnRFNPQ3UxV2hTWEp1TUlBWXdzc1F0a2gyVGlBMFMxOWdkUGNOZS81Zkp3?=
 =?utf-8?B?aGx2dnZQbTlNVkdnbjlCQUVFWk52KytzRFdFWmNWeGtaeDFaUXI4aDUzY0p4?=
 =?utf-8?B?UFk3QW5NNVpRMzI4R0dNcmg4NkNBYjdKaHV0M3Vla01ZS2ppT1ZaTm1UVzcx?=
 =?utf-8?B?aXhvcXUxLzAzVW1rSERIQ0lqOFg1dThTaE9VMkdLTUZBREVBQ1B2QVAydW1L?=
 =?utf-8?B?VFZOMzhGSnhYNW1FTGo1ZEMrNWtQQTVpOUNkK0ZnY2liM1pnMlV0elU5c3N2?=
 =?utf-8?B?RTZvN2xYdFd2dDA1eFB3REtReFZxMThicmxPWlgrTzlMNXFWcjNsU05hWElM?=
 =?utf-8?B?WjlRTVVFclNWckNzUFdySjV5aFo0b2ZUaHA1UW1kM3Raa3ZTVldLaFNudU4r?=
 =?utf-8?Q?xooruw5A4f2QkYe+nQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7C83AACBEF8B64AB3C03F5870BA93FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4865.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5efdafe-6529-47f5-f36d-08d94d92cfad
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 04:31:59.3288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ayB+GVc5NyyQBVTqllhvtV1Frfv4usH5Wo8v+XPu2XSkxEjaS88MxIgIzrnI/KVixXSsqt2WWSCl0HGXQ++hTDiq9C5gxmaQ4Q01QhwxSMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2015
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8yMi8yMSA4OjA4IFBNLCBTYWxhaCBUcmlraSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBVc2Ugc3dhcCgpIGluc3RlYWQgb2YgaW1wbGVtZW50
aW5nIGl0IGluIG9yZGVyIHRvIG1ha2UgY29kZSBtb3JlIGNsZWFuLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogU2FsYWggVHJpa2kgPHNhbGFoLnRyaWtpQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL2NyeXB0by9hdG1lbC1hZXMuYyB8IDggKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vYXRtZWwtYWVzLmMgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC1hZXMuYw0KPiBpbmRl
eCBiMWQyODYwMDQyOTUuLjYwMDQxMDIyYzRmNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlw
dG8vYXRtZWwtYWVzLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtYWVzLmMNCj4gQEAg
LTE4MTksMTIgKzE4MTksOCBAQCBzdGF0aWMgaW50IGF0bWVsX2Flc194dHNfcHJvY2Vzc19kYXRh
KHN0cnVjdCBhdG1lbF9hZXNfZGV2ICpkZCkNCj4gICAgICAgICAgKiB0aGUgb3JkZXIgb2YgdGhl
IGNpcGhlcmVkIHR3ZWFrIGJ5dGVzIG5lZWQgdG8gYmUgcmV2ZXJzZWQgYmVmb3JlDQo+ICAgICAg
ICAgICogd3JpdGluZyB0aGVtIGludG8gdGhlIE9EQVRBUnggcmVnaXN0ZXJzLg0KPiAgICAgICAg
ICAqLw0KPiAtICAgICAgIGZvciAoaSA9IDA7IGkgPCBBRVNfQkxPQ0tfU0laRS8yOyArK2kpIHsN
Cj4gLSAgICAgICAgICAgICAgIHU4IHRtcCA9IHR3ZWFrX2J5dGVzW0FFU19CTE9DS19TSVpFIC0g
MSAtIGldOw0KPiAtDQo+IC0gICAgICAgICAgICAgICB0d2Vha19ieXRlc1tBRVNfQkxPQ0tfU0la
RSAtIDEgLSBpXSA9IHR3ZWFrX2J5dGVzW2ldOw0KPiAtICAgICAgICAgICAgICAgdHdlYWtfYnl0
ZXNbaV0gPSB0bXA7DQo+IC0gICAgICAgfQ0KPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBBRVNf
QkxPQ0tfU0laRS8yOyArK2kpDQoNClRoZXJlIGNvdWxkIGhhdmUgYmVlbiBzcGFjZXMgYXJvdW5k
IHRoYXQgJy8nLCBidXQgSSBzZWUgaXQgd2FzIGtlcHQgYXMgaXQgd2FzDQpiZWZvcmUuIEl0J3Mg
ZmluZSBlaXRoZXIgd2F5Lg0KIA0KPiArICAgICAgICAgICAgICAgc3dhcCh0d2Vha19ieXRlc1tp
XSwgdHdlYWtfYnl0ZXNbQUVTX0JMT0NLX1NJWkUgLSAxIC0gaV0pOw0KPiANCj4gICAgICAgICAv
KiBQcm9jZXNzIHRoZSBkYXRhLiAqLw0KPiAgICAgICAgIGF0bWVsX2Flc193cml0ZV9jdHJsKGRk
LCB1c2VfZG1hLCBOVUxMKTsNCj4gLS0NCj4gMi4yNS4xDQo+IA0KDQo=
