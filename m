Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371D5C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 08:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB3821582
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 08:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="fgp4k4kM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIRIVx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 04:21:53 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:31292 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIRIVw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 04:21:52 -0400
X-Greylist: delayed 2350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 04:21:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1600417310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCRBvZs2vizSPY57wMQEVMf4nxUlnYDw4fiYyVsg0c0=;
        b=fgp4k4kMQGXwDJfl1dfGF5xflP5mIoRbapzKqi/cxiTZWh0WY1KG2GptCgrFZBSnD9s/8R
        KUr2twtpZO6rs8oUVWdiixMON4XXLjntuwR9p2l+7Jh78XNXqx1LlhntFTBwQp48GGVmHF
        D6yStNrdKJ/XXD7/J1umv5sIHVUvqWE=
Received: from NAM04-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-miakAPINPgKpft8mqgqryA-1; Fri, 18 Sep 2020 04:21:48 -0400
X-MC-Unique: miakAPINPgKpft8mqgqryA-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0680.namprd04.prod.outlook.com
 (2603:10b6:903:ea::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 08:21:45 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 08:21:45 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Topic: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Index: AQHWhPjdSpcGgYTiMUOu7ID5mrD0iqluCCwAgAAMa6CAAAVIgIAABV7A
Date:   Fri, 18 Sep 2020 08:21:44 +0000
Message-ID: <CY4PR0401MB365268AA17E35E5B55ABF7E6C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
 <20200918065806.GA9698@gondor.apana.org.au>
 <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200918080127.GA24222@gondor.apana.org.au>
In-Reply-To: <20200918080127.GA24222@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d15d397c-1638-494f-b9a8-08d85babe156
x-ms-traffictypediagnostic: CY4PR04MB0680:
x-microsoft-antispam-prvs: <CY4PR04MB0680F281DFEDFE4FE8DE0440C33F0@CY4PR04MB0680.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Dtl7f3eOc033LpaEqyl8gXfl1XJZHxKbXw9Iugct/58LZx5Id/MgbGG2xroC+Qrsql16drIy/eEQjjQjeHaJSV4P7I68kDa0HsWv7vXSq76oS8QDjd0P5F1Kv1LOFwNYXJMMWxwpgpE6ZBjInLUkIFuNFbTn1GWSbn9b9OST9Cva7sFyfW6efV/sihnf+vi9qxi8dT8hbz1Z7Aa8gLwzG/LwlMxL+TkXG1UELKkAjlAI6a5aNG3GPetN1ehU8mAn4pfAZR7SyoPGL1Re1LTn7EkhpPDeuYCEQuQgLAj2Lp4AjQ1PG7rPnugUiTbqk0rD3E0gBfw9711wflHQUAlnB4QjHC4xzVtK14qjUXRtOb55V6pVJpWIhmGAsVxzZ3NTqgzFtC5177wyJkhzKn1Yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39850400004)(83080400001)(83380400001)(86362001)(9686003)(4326008)(8676002)(6916009)(8936002)(55016002)(33656002)(66946007)(66556008)(478600001)(966005)(2906002)(66476007)(76116006)(66446008)(52536014)(6506007)(53546011)(186003)(316002)(5660300002)(64756008)(54906003)(71200400001)(26005)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Is2ucYNoGP7YEbkqSlZmGildrylfDkLLrie2Puyfq+JqQydmA54heiggGV2jXQa3dTH977+EdptVpb5rK3dDOxSrj6wGv5idWwzBpBISzNNpHOoiV2K7GwbYRU1pPTo65pgDywPg24VYiGEQMdcvjYAf7+mi4Y7FMEpIEoquXf1vovxOAIBQDJ1eeT3jmaUy62O/pTUzOpGnPa2WO9LBhrvuAHlAJBSEEjPk4D1QcGv7FpbrPEFcuiBbXKYk1er9HTFRTE0NyiT8cZhZoYRVhQ1Ej9NrkTSfOjTGtghPDHpB97EYxuLkJv7A9X7g4Sxl709TtpgvKn+vIZ28umOg01IkfP3OkWifwwnM+hY8N5KYLxgN+ldpbxMOIaCyXTSqYkygYW87RwaWXhnjAsCgTqwCWv+8pSAdCm1QPVRmc3FJSKBQOZLSBw4Yf0/N68Q9osC+mjsFAnjPkjREx4Bo/pnJu90H71vhqczEx6rI/9GusXFoFgNdi3IBNbw2sfByuTlh7fqEjgC14LkZ8+/i+/91v5dEckJfMWQY/NiKGiDPjRJBcL043So5S2wBeiXgYb179jEPT6opXulDsyJYXPN1OYKLWJbMzL7Uw6xyLbPjsSgcZuXobYerMNaSXejSCE3D5EpWUzCyN12Q0EBbcg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d15d397c-1638-494f-b9a8-08d85babe156
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 08:21:45.0218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ikFMfAJGlMywMpBxdQH5EekgxY9NgfCF/+0qF77C4HkJyavNglIM02zHRYrQl6ZOBGvVJ4ua/xY6tBQVe53L2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0680
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0
QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIw
IDEwOjAxIEFNDQo+IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1idXMu
Y29tPg0KPiBDYzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgYW50b2luZS50ZW5hcnRA
Ym9vdGxpbi5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtl
cm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGNyeXB0bzogaW5zaWRlLXNlY3VyZSAt
IEZpeCBjb3JydXB0aW9uIG9uIG5vdCBmdWxseSBjb2hlcmVudCBzeXN0ZW1zDQo+DQo+IDw8PCBF
eHRlcm5hbCBFbWFpbCA+Pj4NCj4gT24gRnJpLCBTZXAgMTgsIDIwMjAgYXQgMDc6NDI6MzVBTSAr
MDAwMCwgVmFuIExlZXV3ZW4sIFBhc2NhbCB3cm90ZToNCj4gPg0KPiA+IEFjdHVhbGx5LCB0aGF0
IGlzIHdoYXQgd2UgZGlkIGFzIGEgX3F1aWNrIGhhY2tfIGluaXRpYWxseSwgYnV0Og0KPiA+DQo+
ID4gRmlyc3Qgb2YgYWxsLCBpdCdzIG5vdCBvbmx5IGFib3V0IHRoZSBMMSBjYWNoZWxpbmUgc2l6
ZS4gSXQncyBhYm91dCB0aGUgd29yc3QgY2FzZSBjYWNoZQ0KPiA+IGxpbmUgc2l6ZSBpbiB0aGUg
cGF0aCBhbGwgdGhlIHdheSBmcm9tIHRoZSBDUFUgdG8gdGhlIGFjdHVhbCBtZW1vcnkgaW50ZXJm
YWNlLg0KPiA+DQo+ID4gU2Vjb25kLCBjYWNoZSBsaW5lIHNpemVzIG1heSBkaWZmZXIgZnJvbSBz
eXN0ZW0gdG8gc3lzdGVtLiBTbyBpdCdzIG5vdCBhY3R1YWxseQ0KPiA+IGEgY29uc3RhbnQgYXQg
YWxsICh1bmxlc3MgeW91IGNvbXBpbGUgdGhlIGRyaXZlciBzcGVjaWZpY2FsbHkgZm9yIDEgdGFy
Z2V0IHN5c3RlbSkuDQo+DQo+IENhbiB0aGlzIGFsaWdubWVudCBleGNlZWQgQVJDSF9ETUFfTUlO
QUxJR04/IElmIG5vdCB0aGVuIHRoZQ0KPiBtYWNybyBDUllQVE9fTUlOQUxJR04gc2hvdWxkIGNv
dmVyIGl0Lg0KPg0KSSBkb24ndCBrbm93LiBJJ20gbm90IGZhbWlsaWFyIHdpdGggdGhhdCBtYWNy
byBhbmQgSSBoYXZlIG5vdCBiZWVuIGFibGUgdG8gZGlnIHVwIGFueQ0KY2xlYXIgZGVzY3JpcHRp
b24gb24gd2hhdCBpdCBzaG91bGQgY29udmV5Lg0KDQpCYXNlZCBvbiB0aGUgbmFtZSwgSSBtaWdo
dCBiZSBpbmNsaW5lZCB0byB0aGluayB5ZXMsIGJ1dCBiYXNlZCBvbiBtYW55IGRlZmluaXRpb25z
DQpJJ3ZlIHNlZW4gaW4gaGVhZGVyIGZpbGVzLCBJIHdvdWxkIHNheSBuby4gQmVjYXVzZSBpdCdz
IG9mdGVuIGp1c3QgYW4gYWxpYXMgZm9yIHRoZSBMMQ0KY2FjaGVsaW5lIHNpemUsIHdoaWNoIG1h
eSBub3QgYmUgdGhlIGxhcmdlc3QgY2FjaGVsaW5lIGZvciBfc29tZV8gc3lzdGVtcy4NCg0KSW4g
YW55IGNhc2UsIGFsaWduaW5nIHRvIHRoZSB3b3JzdCBjYWNoZSBjYWNoZWxpbmUgZm9yIGEgQ1BV
IGFyY2hpdGVjdHVyZSBtYXkgbWVhbg0KeW91IGVuZCB1cCB3YXN0aW5nIGEgbG90IG9mIHNwYWNl
IG9uIGEgc3lzdGVtIHdpdGggYSBtdWNoIHNtYWxsZXIgY2FjaGVsaW5lLg0KDQo+IENoZWVycywN
Cj4gLS0NCj4gRW1haWw6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4N
Cj4gSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+aGVyYmVydC8NCj4gUEdQ
IEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvcHVia2V5LnR4dA0KDQpS
ZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Q
cm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYN
CiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2ls
aWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUg
c28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUt
bWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFy
ZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBj
b250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJ
ZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91
IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2
aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90
aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cu
cmFtYnVzLmNvbT4NCg==

