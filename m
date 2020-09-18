Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE901C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28DA20DD4
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="FvJcY4BQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIRHtH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:49:07 -0400
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:52715 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgIRHtG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:49:06 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 03:49:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1600415344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axJCGyQDFxdrFCyk6zspFqnmtuRExgFygRb+mE6PY4I=;
        b=FvJcY4BQ47z+JtdJTJlTjhJV8AJgYiti70+5snAAS0y/Gwuc5LoeUBW2zaUgFukeFk0qET
        f/ylmtIa5PY3dYncKxJMItIOzJ6Xxj8ljjZZnBOt8ug/cVWNi9jrKrb45TfKzmtQHLmCD+
        lAV5lPElY9O66E1eEBw2SU8L1wm3JOc=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-f1ju3eTxMb6ITLETdYVLmw-1; Fri, 18 Sep 2020 03:42:38 -0400
X-MC-Unique: f1ju3eTxMb6ITLETdYVLmw-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 07:42:35 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 07:42:35 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Topic: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Index: AQHWhPjdSpcGgYTiMUOu7ID5mrD0iqluCCwAgAAMa6A=
Date:   Fri, 18 Sep 2020 07:42:35 +0000
Message-ID: <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
 <20200918065806.GA9698@gondor.apana.org.au>
In-Reply-To: <20200918065806.GA9698@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c5a83ee-bd40-449b-ed17-08d85ba668e2
x-ms-traffictypediagnostic: CY4PR0401MB3652:
x-microsoft-antispam-prvs: <CY4PR0401MB365228297AEC458AEEEA81BFC33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H78oiItojymD6K51q5eHCcPfS8QzrSj98J3IyYpYNxIDw8amRQ/TWDM1QyJ7sQpes5jLXTzKZjtj5enBpJcvSa33zVRnhs+rLHECkvNnZU3FdT0g8E/94TvT1XxFOs9jNoo4Nvml2RpVDREOX3D3Jcr8p3JvWi4tdFyXyVq46cwCPhYakLS3HJn+zRoe9jv3+/48yyUXvZGL/5fJbPfwApGZvvH4gWXpQNodZEo+F2nhs0azAd0LWdqrMGWBRcfvhluxRLrRzmMsV0WDvyEc+xn4RgpO4CP0tiN7g468T31ZWJNBmAOVKQirR8Gs2a3vYv3Vt1DrkwMYmcmDNpD3PcLa9Mqq+/wiCmJN0pE+L443ibjoe04aOYvvHiSXW3K3wXKW0oLidDEeGWSA1P5xeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(136003)(39850400004)(4326008)(8676002)(9686003)(66446008)(64756008)(66556008)(76116006)(8936002)(66476007)(55016002)(53546011)(6506007)(26005)(2906002)(7696005)(86362001)(186003)(66946007)(966005)(316002)(54906003)(33656002)(83080400001)(71200400001)(52536014)(83380400001)(5660300002)(6916009)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: yZtXXu8UswIO28Ujs1YtutI2ScRh9y/Gdp5WtccAljZAmtu/hGf18iiO+DOb+K1ET7vgf41N8zUuU0qFiTezTKf3v2f8XVvditD43GxSH3azr2xCiMQ1i7K5N/rU4gWl9vnEop9tQlZWbbD+3inpiecYKoJLqWH0eCqD+/tEqmdHpT8xsawjKl2zjGyDFZ1W6f1nAiuo3hAkdq8MZZzaLdk1UXm5KfMRDuYN4YvEMO/Hg7P04zBwqQN92Jy8OVG6HvC5WWYe0qyPPEJw0JKkuWnlVqgHW1Jc1dfN99uQUU6hdZe3MAyqmObj5e8GkxZotiZaTD4hAVDpQThDmCYhipbywpyFm+hC6pjVg0c9MrRC7yjJpDRwevZHauajVsJuZcyOxO1F7+gXmKC0M43r5KUU2Xigz/oPEO8K0MBEscOb2nos3ya4J6mGqDFkv7DQrDIt7IGxsBDEgZqQsxCJx+3pAorwmfI/aKompPFyK3IJk4r75BnvRm0HDQyYIG8EGAAKW8TcOhdl741zpPIH1MA8XpGTOvQpQXiMCfG8cF/GITNOVO9wBszPybM+9f2df7P3H+/+eBJifBm2krIdV0YgwqJ7BHNtvpxyzCKrFHGPqf6FNQSyEXmclstzhHk21+5tko23oxv/p0nOb0nNPQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c5a83ee-bd40-449b-ed17-08d85ba668e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 07:42:35.3947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEkHG3xG1NnvCvXG6JhmFKO7AMcDjBfV+1Qf/PFhU51HPPjyRFCo+/4/zew8CZ45tBR3lZhU+iHfk39ndw6GJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3652
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMTgsIDIw
MjAgODo1OCBBTQ0KPiBUbzogVmFuIExlZXV3ZW4sIFBhc2NhbCA8cHZhbmxlZXV3ZW5AcmFtYnVz
LmNvbT4NCj4gQ2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGFudG9pbmUudGVuYXJ0
QGJvb3RsaW4uY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hd
IGNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIEZpeCBjb3JydXB0aW9uIG9uIG5vdCBmdWxseSBjb2hl
cmVudCBzeXN0ZW1zDQo+DQo+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4NCj4gT24gTW9uLCBTZXAg
MDcsIDIwMjAgYXQgMTA6MTk6NDRBTSArMDIwMCwgUGFzY2FsIHZhbiBMZWV1d2VuIHdyb3RlOg0K
PiA+DQo+ID4gQEAgLTkyMSw5ICs5NDMsMjAgQEAgc3RhdGljIGludCBzYWZleGNlbF9haGFzaF9j
cmFfaW5pdChzdHJ1Y3QgY3J5cHRvX3RmbSAqdGZtKQ0KPiA+ICBjdHgtPmJhc2Uuc2VuZCA9IHNh
ZmV4Y2VsX2FoYXNoX3NlbmQ7DQo+ID4gIGN0eC0+YmFzZS5oYW5kbGVfcmVzdWx0ID0gc2FmZXhj
ZWxfaGFuZGxlX3Jlc3VsdDsNCj4gPiAgY3R4LT5mYl9kb19zZXRrZXkgPSBmYWxzZTsNCj4gPiAr
Y3R4LT5yZXFfYWxpZ24gPSBjYWNoZV9saW5lX3NpemUoKSAtIDE7DQo+DQo+IFNvIHRoZSBhbGln
bm1lbnQgaXMganVzdCBMMV9DQUNIRV9CWVRFUywgd2hpY2ggaXMgYSBjb25zdGFudC4NCj4gV2h5
IGRvbid0IHlvdSBqdXN0IHB1dCB0aGF0IGludG8gdGhlIHN0cnVjdCBhbmQgdGhlbiBzaW1wbHkg
YWxpZ24NCj4gdGhlIHdob2xlIHN0cnVjdD8gVG8gZ2V0IHRoZSBhbGlnbmVkIGN0eCwgeW91IGNh
biBtYWtlIGEgd3JhcHBlcg0KPiBhcm91bmQgYWhhc2hfcmVxdWVzdF9jdHggdGhhdCBkb2VzIHRo
ZSBhbGlnbmluZyBmb3IgeW91Lg0KPg0KQWN0dWFsbHksIHRoYXQgaXMgd2hhdCB3ZSBkaWQgYXMg
YSBfcXVpY2sgaGFja18gaW5pdGlhbGx5LCBidXQ6DQoNCkZpcnN0IG9mIGFsbCwgaXQncyBub3Qg
b25seSBhYm91dCB0aGUgTDEgY2FjaGVsaW5lIHNpemUuIEl0J3MgYWJvdXQgdGhlIHdvcnN0IGNh
c2UgY2FjaGUNCmxpbmUgc2l6ZSBpbiB0aGUgcGF0aCBhbGwgdGhlIHdheSBmcm9tIHRoZSBDUFUg
dG8gdGhlIGFjdHVhbCBtZW1vcnkgaW50ZXJmYWNlLg0KDQpTZWNvbmQsIGNhY2hlIGxpbmUgc2l6
ZXMgbWF5IGRpZmZlciBmcm9tIHN5c3RlbSB0byBzeXN0ZW0uIFNvIGl0J3Mgbm90IGFjdHVhbGx5
DQphIGNvbnN0YW50IGF0IGFsbCAodW5sZXNzIHlvdSBjb21waWxlIHRoZSBkcml2ZXIgc3BlY2lm
aWNhbGx5IGZvciAxIHRhcmdldCBzeXN0ZW0pLg0KDQo+IEhhdmUgYSBsb29rIGF0IGRyaXZlcnMv
Y3J5cHRvL3BhZGxvY2stYWVzLmMgd2hpY2ggZG9lcyBzb21ldGhpbmcNCj4gc2ltaWxhciBmb3Ig
dGhlIHRmbSBjdHguDQo+DQo+IENoZWVycywNCj4gLS0NCj4gRW1haWw6IEhlcmJlcnQgWHUgPGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFw
YW5hLm9yZy5hdS9+aGVyYmVydC8NCj4gUEdQIEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcu
YXUvfmhlcmJlcnQvcHVia2V5LnR4dA0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpT
aWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJp
dHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJ
bnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1
aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwg
YWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVz
c2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRl
bmRlZCByZWNpcGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29u
ZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVj
aXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcs
IGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNz
YWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoq
DQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

