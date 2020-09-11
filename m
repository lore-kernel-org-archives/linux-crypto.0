Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8B9C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84059206A2
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="XBPfQODm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIKQq7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:46:59 -0400
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:28675 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgIKQq0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 12:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1599842782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ixtUPu9SlaF6YBk5xpAJWMctj0stq/d2PrRCB8nU0h4=;
        b=XBPfQODmIkn0g2nIXTPMQOvSj4LXhMpcWalhlIiF9l1//owMgApNgiRWvdG1g0lpFMtcUT
        X8D9oSjtL/f760CF8VRgigYS+Z/1rsN+rWkiQ3thzy8LpQ0cja4c/p4zo1FbTCyw+ejr8V
        MU/yB1ZpebCkmQsqDi05pzTxgDratrg=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-6DmqudOPMoK4OQCqA19uVw-1; Fri, 11 Sep 2020 12:46:21 -0400
X-MC-Unique: 6DmqudOPMoK4OQCqA19uVw-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0903.namprd04.prod.outlook.com
 (2603:10b6:910:57::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 11 Sep
 2020 16:46:18 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 16:46:18 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: RE: [PATCH] crypto: mark unused ciphers as obsolete
Thread-Topic: [PATCH] crypto: mark unused ciphers as obsolete
Thread-Index: AQHWiFRjVQhCDl0wBUmciifAeSWwvaljnRFwgAAD9ACAAASTgA==
Date:   Fri, 11 Sep 2020 16:46:18 +0000
Message-ID: <CY4PR0401MB36522379F8C5AB02D848AAADC3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200911141103.14832-1-ardb@kernel.org>
 <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
In-Reply-To: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a279390-c94e-40a5-b18b-08d8567234e1
x-ms-traffictypediagnostic: CY4PR04MB0903:
x-microsoft-antispam-prvs: <CY4PR04MB0903CF3AA48C84B2982CD2A6C3240@CY4PR04MB0903.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aUxj+vnPu4T5/qvO4sVNOk6lopFj1sFprxyiczPYk5arnVV/6O3r+3zkIAtbIUxl9tlA+cjxB/0d1Z1PRPrdAaQ325cGyc4p7TdIGypjfAKeR2xqzQbWdJKkmhAQP9A4+z9ZMVwjO2O9cxor1qcU5kOxMQRcqsIVo+oGqkrRKO5xSS1ogUk+dFN8W0K4EQyWkl0J1tCDWHcS0y1nY04sAIMdM8XrMAKy5Elc7xFfQLxKNuSVQ/Lem+g9f7yy2opZiHx7lAtI+rO4vppcU2EKdOV9wWhK5dJYGAhmbxAps41ryyW5yjsRlH3iOa8tuWuE31Xx6FqS/FnFAeDG3iqJhklU8B0cnTW43fiDyiRYYDI8tzfDNUAKw83lozxQfBQivuph2hKwEXcOiAURcSI13Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39850400004)(366004)(64756008)(55016002)(5660300002)(66946007)(76116006)(66476007)(110136005)(66556008)(66446008)(9686003)(54906003)(186003)(83380400001)(316002)(86362001)(33656002)(8936002)(52536014)(71200400001)(26005)(53546011)(7696005)(478600001)(6506007)(4326008)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gbF1y3fsIi3WLudkA+AUbzLwcki10/Ic9R8q0eTZo0z4inNHD7XJTHI11h9l3qvdce+I3AbibFokQJsK/lKJxzxto1DYEEVUp/A5RSi9KwyU9tIsG7hO8lCKLvq3df2hUkPa8YBfpuMTSqxAKU9nDjDTqHR6Ax7Xis1IsR13TFqUPCp7a2FRCGsoHovUAFLHe21cUfE1TrK3g7PwoT889k/WeL7+c6HyIaL50ZnauJpc87jzRfZGAcWFgzIXlLjkt8aWed0Wsxh8D4hs8PobIrKOhFoT3ybSREFKN1DnR5/3gXjAcRhWojK0ckr3C7MaTcD+Dkcu19FM69YQLdUiHi46/WofYlYNAV/AORjfE7hteMfnORa11ow/lTx7X0XoLZZQieZUmpZ7ocnp9zXcB1dofpn01iMz+VGIaCi7ZcSNCqCitdhJ150R3WIn7aMRPaBidF/StnfM05WamwmrKRFqlAeUjzBrh5lacNFY7DotXJeWUo9eyI/aH127ou18APWa058uZWKc8zAglvadWtakaoqI0Fxbg5LMmyWOEc8aUvuz3nBpSKQE0XS2KUHpgHG+qZ6WP4ljfaCiIqzGk1i6h+E9XYRYKZVqpTgQanmvYQbf+mQ1HVRYZeq5v6+gEmTSrEUZOop9+3zy17yAsw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a279390-c94e-40a5-b18b-08d8567234e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 16:46:18.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVVUZboGy2UxvT1NAW/r3PohkBflgzbqZsIZQTvij7TcGW2B1eolUF65gxm2v2twtpN+Vrg1FZsNYnAFcY3yqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0903
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0.004
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
YkBrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciAxMSwgMjAyMCA2OjMwIFBN
DQo+IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1idXMuY29tPjsgZG0t
ZGV2ZWxAcmVkaGF0LmNvbTsgTWlsYW4gQnJveiA8Z21henlsYW5kQGdtYWlsLmNvbT4NCj4gQ2M6
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5h
dTsgZWJpZ2dlcnNAa2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBjcnlwdG86IG1h
cmsgdW51c2VkIGNpcGhlcnMgYXMgb2Jzb2xldGUNCj4NCj4gPDw8IEV4dGVybmFsIEVtYWlsID4+
Pg0KPiAoY2MgTWlsYW4gYW5kIGRtLWRldmVsKQ0KPg0KPiBPbiBGcmksIDExIFNlcCAyMDIwIGF0
IDE5OjI0LCBWYW4gTGVldXdlbiwgUGFzY2FsDQo+IDxwdmFubGVldXdlbkByYW1idXMuY29tPiB3
cm90ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206
IGxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0by1vd25lckB2
Z2VyLmtlcm5lbC5vcmc+IE9uIEJlaGFsZiBPZiBBcmQgQmllc2hldXZlbA0KPiA+ID4gU2VudDog
RnJpZGF5LCBTZXB0ZW1iZXIgMTEsIDIwMjAgNDoxMSBQTQ0KPiA+ID4gVG86IGxpbnV4LWNyeXB0
b0B2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IENjOiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7
IGViaWdnZXJzQGtlcm5lbC5vcmc7IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+
ID4gPiBTdWJqZWN0OiBbUEFUQ0hdIGNyeXB0bzogbWFyayB1bnVzZWQgY2lwaGVycyBhcyBvYnNv
bGV0ZQ0KPiA+ID4NCj4gPiA+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4NCj4gPiA+IFdlIGhhdmUg
YSBmZXcgaW50ZXJlc3RpbmcgcGllY2VzIGluIG91ciBjaXBoZXIgbXVzZXVtLCB3aGljaCBhcmUg
bmV2ZXINCj4gPiA+IHVzZWQgaW50ZXJuYWxseSwgYW5kIHdlcmUgb25seSBldmVyIHByb3ZpZGVk
IGFzIGdlbmVyaWMgQyBpbXBsZW1lbnRhdGlvbnMuDQo+ID4gPg0KPiA+ID4gVW5mb3J0dW5hdGVs
eSwgd2UgY2Fubm90IHNpbXBseSByZW1vdmUgdGhpcyBjb2RlLCBhcyB3ZSBjYW5ub3QgYmUgc3Vy
ZQ0KPiA+ID4gdGhhdCBpdCBpcyBub3QgYmVpbmcgdXNlZCB2aWEgdGhlIEFGX0FMRyBzb2NrZXQg
QVBJLCBob3dldmVyIHVubGlrZWx5Lg0KPiA+ID4gU28gbGV0J3MgbWFyayB0aGUgQW51YmlzLCBL
aGF6YWQsIFNFRUQgYW5kIFRFQSBhbGdvcml0aG1zIGFzIG9ic29sZXRlLA0KPiA+ID4NCj4gPiBX
b3VsZG4ndCB0aGUgSUtFIGRlYW1vbiBiZSBhYmxlIHRvIHV0aWxpemUgdGhlc2UgYWxnb3JpdGht
cyB0aHJvdWdoIHRoZSBYRlJNIEFQST8NCj4gPiBJJ20gYnkgbm8gbWVhbnMgYW4gZXhwZXJ0IG9u
IHRoZSBzdWJqZWN0LCBidXQgaXQgbG9va3MgbGlrZSB0aGUgY2lwaGVyIHRlbXBsYXRlIGlzDQo+
ID4gcHJvdmlkZWQgdGhlcmUgZGlyZWN0bHkgdmlhIFhGUk0sIHNvIGl0IGRvZXMgbm90IG5lZWQg
dG8gbGl2ZSBpbiB0aGUga2VybmVsIHNvdXJjZS4NCj4gPiBBbmQgSSBrbm93IGZvciBhIGZhY3Qg
dGhhdCBTRUVEIGlzIGJlaW5nIHVzZWQgZm9yIElQc2VjIChhbmQgVExTKSBpbiBLb3JlYS4NCj4g
Pg0KPg0KPiBJIGhhdmUgYmVlbiBzdGFyaW5nIGF0IG5ldC94ZnJtL3hmcm1fYWxnby5jLCBhbmQg
YXMgZmFyIGFzIEkgY2FuIHRlbGwsDQo+IGFsZ29yaXRobXMgaGF2ZSB0byBiZSBtZW50aW9uZWQg
dGhlcmUgaW4gb3JkZXIgdG8gYmUgdXNhYmxlLiBOb25lIG9mDQo+IHRoZSBjaXBoZXJzIHRoYXQg
dGhpcyBwYXRjaCB0b3VjaGVzIGFyZSBsaXN0ZWQgdGhlcmUgb3IgYW55d2hlcmUgZWxzZQ0KPiBp
biB0aGUga2VybmVsLg0KPg0KSG1tbSAuLi4gZ29vZCBwb2ludC4gV2Fzbid0IGF3YXJlIFhGUk0g
d2FzIGFjdGl2ZWx5IGFsbG93aW5nIG9ubHkgYSBzdWJzZXQuDQpBY3R1YWxseSBmb3VuZCB0aGlz
IGNvbW1lbnRlZCBvdXQgY29kZSBpbiBteSBQbHV0byBzb3VyY2UgKGtlcm5lbF9uZXRsaW5rLmMp
Og0KDQovKg0KICogTm90IHlldCBpbXBsZW1lbnRlZCBpbiBMaW51eCBrZXJuZWwgeGZybV9hbGdv
LmMNCnsgU0FEQl9YX0VBTEdfU0VFRENCQywgImNiYyhzZWVkKSIgfSwNCiAqLw0KDQpHbyBmaWd1
cmUuDQoNCj4gPiBUaGUgcG9pbnQgYmVpbmcsIHRoZXJlIGFyZSBtb3JlIHVzZXJzIHRvIGNvbnNp
ZGVyIGJleW9uZCAiaW50ZXJuYWwiIChtZWFuaW5nIGhhcmQNCj4gPiBjb2RlZCBpbiB0aGUga2Vy
bmVsIHNvdXJjZSBpbiB0aGlzIGNvbnRleHQ/KSBhbmQgQUZfQUxHLg0KPiA+DQo+DQo+IFRoYXQg
aXMgYSBnb29kIHBvaW50LCBhY3R1YWxseSwgc2luY2UgZG0tY3J5cHQgY291bGQgYmUgYWZmZWN0
ZWQgaGVyZQ0KPiBhcyB3ZWxsLCBoZW5jZSB0aGUgQ0NzLg0KPg0KPiBNaWxhbiAob3Igb3RoZXJz
KTogYXJlIHlvdSBhd2FyZSBvZiBhbnkgb2YgdGhlc2UgY2lwaGVycyBiZWluZyB1c2VkDQo+IGZv
ciBkbS1jcnlwdD8NCj4NCj4NCj4gPiBJJ20gbm90IGF3YXJlIG9mIGFueSByZWFsIHVzZSBjYXNl
cyBmb3IgQW51YmlzLCBLaGF6YWQgYW5kIFRFQSB0aG91Z2guDQo+ID4NCj4NCj4gT0ssIHRoYW5r
cyBmb3IgY29uZmlybWluZy4gUmVtb3ZpbmcgdGhvc2Ugd291bGQgYmUgYSBnb29kIHN0YXJ0Lg0K
Pg0KPiA+ID4gd2hpY2ggbWVhbnMgdGhleSBjYW4gb25seSBiZSBlbmFibGVkIGluIHRoZSBidWls
ZCBpZiB0aGUgc29ja2V0IEFQSSBpcw0KPiA+ID4gZW5hYmxlZCBpbiB0aGUgZmlyc3QgcGxhY2Uu
DQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVs
Lm9yZz4NCj4gPiA+IC0tLQ0KPiA+ID4gSG9wZWZ1bGx5LCBJIHdpbGwgYmUgYWJsZSB0byBjb252
aW5jZSB0aGUgZGlzdHJvIGtlcm5lbCBtYWludGFpbmVycyB0bw0KPiA+ID4gZGlzYWJsZSBDUllQ
VE9fVVNFUl9BUElfRU5BQkxFX09CU09MRVRFIGluIHRoZWlyIHY1LjEwKyBidWlsZHMgb25jZSB0
aGUNCj4gPiA+IGl3ZCBjaGFuZ2VzIGZvciBhcmM0IG1ha2UgaXQgZG93bnN0cmVhbSAoRGViaWFu
IGFscmVhZHkgaGFzIGFuIHVwZGF0ZWQNCj4gPiA+IHZlcnNpb24gaW4gaXRzIHVuc3RhYmxlIGRp
c3RybykuIFdpdGggdGhlIGpvaW50IGNvdmVyYWdlIG9mIHRoZWlyIFFBLA0KPiA+ID4gd2Ugc2hv
dWxkIGJlIGFibGUgdG8gY29uZmlybSB0aGF0IHRoZXNlIGFsZ29zIGFyZSBuZXZlciB1c2VkLCBh
bmQNCj4gPiA+IGFjdHVhbGx5IHJlbW92ZSB0aGVtIGFsdG9nZXRoZXIuDQo+ID4gPg0KPiA+ID4g
IGNyeXB0by9LY29uZmlnIHwgNCArKysrDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9jcnlwdG8vS2NvbmZpZyBiL2NyeXB0
by9LY29uZmlnDQo+ID4gPiBpbmRleCBlODVkOGEwNTk0ODkuLmZhYzEwMTQzZDIzZiAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2NyeXB0by9LY29uZmlnDQo+ID4gPiArKysgYi9jcnlwdG8vS2NvbmZpZw0K
PiA+ID4gQEAgLTExODUsNiArMTE4NSw3IEBAIGNvbmZpZyBDUllQVE9fQUVTX1BQQ19TUEUNCj4g
PiA+DQo+ID4gPiAgY29uZmlnIENSWVBUT19BTlVCSVMNCj4gPiA+ICB0cmlzdGF0ZSAiQW51Ymlz
IGNpcGhlciBhbGdvcml0aG0iDQo+ID4gPiArZGVwZW5kcyBvbiBDUllQVE9fVVNFUl9BUElfRU5B
QkxFX09CU09MRVRFDQo+ID4gPiAgc2VsZWN0IENSWVBUT19BTEdBUEkNCj4gPiA+ICBoZWxwDQo+
ID4gPiAgICBBbnViaXMgY2lwaGVyIGFsZ29yaXRobS4NCj4gPiA+IEBAIC0xNDI0LDYgKzE0MjUs
NyBAQCBjb25maWcgQ1JZUFRPX0ZDUllQVA0KPiA+ID4NCj4gPiA+ICBjb25maWcgQ1JZUFRPX0tI
QVpBRA0KPiA+ID4gIHRyaXN0YXRlICJLaGF6YWQgY2lwaGVyIGFsZ29yaXRobSINCj4gPiA+ICtk
ZXBlbmRzIG9uIENSWVBUT19VU0VSX0FQSV9FTkFCTEVfT0JTT0xFVEUNCj4gPiA+ICBzZWxlY3Qg
Q1JZUFRPX0FMR0FQSQ0KPiA+ID4gIGhlbHANCj4gPiA+ICAgIEtoYXphZCBjaXBoZXIgYWxnb3Jp
dGhtLg0KPiA+ID4gQEAgLTE0ODcsNiArMTQ4OSw3IEBAIGNvbmZpZyBDUllQVE9fQ0hBQ0hBX01J
UFMNCj4gPiA+DQo+ID4gPiAgY29uZmlnIENSWVBUT19TRUVEDQo+ID4gPiAgdHJpc3RhdGUgIlNF
RUQgY2lwaGVyIGFsZ29yaXRobSINCj4gPiA+ICtkZXBlbmRzIG9uIENSWVBUT19VU0VSX0FQSV9F
TkFCTEVfT0JTT0xFVEUNCj4gPiA+ICBzZWxlY3QgQ1JZUFRPX0FMR0FQSQ0KPiA+ID4gIGhlbHAN
Cj4gPiA+ICAgIFNFRUQgY2lwaGVyIGFsZ29yaXRobSAoUkZDNDI2OSkuDQo+ID4gPiBAQCAtMTYx
Myw2ICsxNjE2LDcgQEAgY29uZmlnIENSWVBUT19TTTQNCj4gPiA+DQo+ID4gPiAgY29uZmlnIENS
WVBUT19URUENCj4gPiA+ICB0cmlzdGF0ZSAiVEVBLCBYVEVBIGFuZCBYRVRBIGNpcGhlciBhbGdv
cml0aG1zIg0KPiA+ID4gK2RlcGVuZHMgb24gQ1JZUFRPX1VTRVJfQVBJX0VOQUJMRV9PQlNPTEVU
RQ0KPiA+ID4gIHNlbGVjdCBDUllQVE9fQUxHQVBJDQo+ID4gPiAgaGVscA0KPiA+ID4gICAgVEVB
IGNpcGhlciBhbGdvcml0aG0uDQo+ID4gPiAtLQ0KPiA+ID4gMi4xNy4xDQo+ID4NCj4gPiBSZWdh
cmRzLA0KPiA+IFBhc2NhbCB2YW4gTGVldXdlbg0KPiA+IFNpbGljb24gSVAgQXJjaGl0ZWN0IE11
bHRpLVByb3RvY29sIEVuZ2luZXMsIFJhbWJ1cyBTZWN1cml0eQ0KPiA+IFJhbWJ1cyBST1RXIEhv
bGRpbmcgQlYNCj4gPiArMzEtNzMgNjU4MTk1Mw0KPiA+DQo+ID4gTm90ZTogVGhlIEluc2lkZSBT
ZWN1cmUvVmVyaW1hdHJpeCBTaWxpY29uIElQIHRlYW0gd2FzIHJlY2VudGx5IGFjcXVpcmVkIGJ5
IFJhbWJ1cy4NCj4gPiBQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRk
cmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KPiA+DQo+ID4NCj4gPiAqKiBU
aGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0
aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0
IGlzDQo+IGNvbmZpZGVudGlhbCBhbmQgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGlu
dGVuZGVkIHJlY2lwaWVudCBvZiB0aGlzIG1lc3NhZ2UsIHlvdSBhcmUgcHJvaGliaXRlZCBmcm9t
IHByaW50aW5nLCBjb3B5aW5nLA0KPiBmb3J3YXJkaW5nIG9yIHNhdmluZyBpdC4gUGxlYXNlIGRl
bGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0YWNobWVudHMgYW5kIG5vdGlmeSB0aGUgc2VuZGVyIGlt
bWVkaWF0ZWx5LiAqKg0KPiA+DQo+ID4gUmFtYnVzIEluYy48aHR0cDovL3d3dy5yYW1idXMuY29t
Pg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBN
dWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRp
bmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRy
aXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVh
c2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkg
bmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1l
bnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0
IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxl
Z2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2Fn
ZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcg
b3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBh
bmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6
Ly93d3cucmFtYnVzLmNvbT4NCg==

