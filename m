Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB0EC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 580C820791
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="YDUgWJiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgIDJon (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:44:43 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:43292 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728263AbgIDJom (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1599212679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TexJTP66L9k5DXGY9jMxvArYil1Zzoof+NfdzLEbWoc=;
        b=YDUgWJiTH8w92iw7ZhNwnxruQ7go6XhWk3WWqYcAs9kU++XeA/Yw3klmhZIQ3KDeQJURYY
        nSjOOmEaINNKt39+MwTMCpJEWZFV5VB0re10AL1/HJGfI8cNCrMUL0W2QdevI7GmjpcjUI
        fMHH73m+1RAlNqvYFWG/5oH8yc+7opw=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-djjqFWAaOKKHzIhS8xLxCg-1; Fri, 04 Sep 2020 05:44:37 -0400
X-MC-Unique: djjqFWAaOKKHzIhS8xLxCg-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0456.namprd04.prod.outlook.com
 (2603:10b6:903:b1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Fri, 4 Sep
 2020 09:44:35 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::5156:a625:2439:9efe]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::5156:a625:2439:9efe%6]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 09:44:34 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     "efremov@linux.com" <efremov@linux.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Thread-Topic: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Thread-Index: AQHWfD2wL6/f5wfOgEK5sXo0DwsOjKlVWorwgALfPQCAAAiiYA==
Date:   Fri, 4 Sep 2020 09:44:34 +0000
Message-ID: <CY4PR0401MB3652E6096EFE0C82B91F7F06C32D0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-2-efremov@linux.com>
 <CY4PR0401MB3652FFD58D9ED14F4805FC99C32F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <8ac5cb88-7df5-1060-2fac-510541fca48b@linux.com>
In-Reply-To: <8ac5cb88-7df5-1060-2fac-510541fca48b@linux.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f60c3c99-fccd-4674-9aa3-08d850b721d5
x-ms-traffictypediagnostic: CY4PR04MB0456:
x-microsoft-antispam-prvs: <CY4PR04MB0456713C2C1277C409609B6AC32D0@CY4PR04MB0456.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMFwBGd5JQMkXAvufRCZEaTMr4iipObJ7GFpA7I8L/mN8eTilBs5ydDR8ZiLGdfsZ7gGs0qDEpLwHEKp5OWmI1gP5H4iTQNDMwJyW6PhYp3VNsIm6065P++8rB3ks5Sw7YDVZ6hcRVObvXU4Jr7ocHNVlwfIu4QK+37DZHbs617709DfoYPyz8AEqvUA7BF8skITiQHU8r7K2v+MMCUtttKncBOMjyBQyqMLz9VNLiiH9d9z9TBl++BUGVVbFBR8YfJulVcZbwN3xzqE0d2EwKZpNgvqItCnJlAgvq+qgk1z/1E0qAClmZnRxnZUW5hofNPOeM1Z8U/yWKrRmhgnU3tRUATA6wjTpUr3zEXyh9tW7LD3TwlgtES0eONtSN1AI7I91H3/Te1IO97jItrPdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(346002)(396003)(366004)(136003)(55016002)(86362001)(83380400001)(9686003)(52536014)(5660300002)(966005)(4326008)(71200400001)(316002)(7696005)(26005)(2906002)(54906003)(8936002)(33656002)(8676002)(66446008)(66556008)(66476007)(64756008)(66946007)(110136005)(6506007)(53546011)(186003)(478600001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: veEFl/6nQ3gnxtpblynjPPjlQgQMZOgfrNmdN46s3ea03Lo3/k+mVVKzQFEY9lzleVubndDrUpPy8mgVlZf2wNViDYlxbIwSAmVDV2SQegyD8/pirHaITVZm9ppqQ7jkSMu2QrGkGgl4zb8BBlBmvokaqv6icf3MB7M6/lKyDIQrt7L9HX31uRsxDHFkA2+g5roY4jcwsHBNX3ya3q66U9nZW2GeGN93mzuwskT8wVW4cfOE2AyZfbfgA3iFeFEITAjj3hTl10qmD0CGmiGNyrXOgML3Idwmc+t+CvBcYmvpfU9nHc/2XgS+aV3xWSAjjcRe9JMcCG9IfsUQIl+96SVnivsQUd7CUvgwy2CJYIwNlnZVkdnBlq3W84+Pb3Y30nzKNkF6UV2WLEVCcbwv7m6+ehzfpP+ELJ0efDgYBDGq/POV1hURAkg7uJ+Ub+dt9uA7F45YX3COSH5lV7/1jTjViqGShiDnuaO/wQ4r54Y8qfEEkSY4LzsLY3QK8aq9pv9Vr4ITsC4Nnn8hm4FC2H2YGVCDufvu91YcwHPgIYnw6Bfd/rIHNsaRYNqWHflC/bD0+JC4Gt7uaiL3dIslsrCCezkX7rHNxAkoehXBsVWhtXGga1qytcLCbEYjaw2+YRlAEJu4Db9XIefGmXHDTA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60c3c99-fccd-4674-9aa3-08d850b721d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 09:44:34.7850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /n8yqgq+/7FdILcbC7dsBhuGZn27hgvMtFRbF0jzM+S72KMj+HEX+xwxJrkZ32bAzR3AfstgWvwa0KoCLJ+PhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0456
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEZW5pcyBFZnJlbW92IDxlZnJl
bW92QGxpbnV4LmNvbT4NCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgNCwgMjAyMCAxMDo1NSBB
TQ0KPiBUbzogVmFuIExlZXV3ZW4sIFBhc2NhbCA8cHZhbmxlZXV3ZW5AcmFtYnVzLmNvbT47IGxp
bnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IENvcmVudGluIExhYmJlIDxjbGFiYmUu
bW9udGpvaWVAZ21haWwuY29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3Jn
LmF1PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IHYyIDEvNF0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gdXNlIGtmcmVlX3NlbnNpdGl2ZSgpDQo+
DQo+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4NCj4gSGksDQo+DQo+IE9uIDkvMi8yMCA0OjEwIFBN
LCBWYW4gTGVldXdlbiwgUGFzY2FsIHdyb3RlOg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+PiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnIDxsaW51
eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgRGVuaXMgRWZyZW1v
dg0KPiA+PiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI3LCAyMDIwIDg6NDQgQU0NCj4gPj4gVG86
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gQ2M6IERlbmlzIEVmcmVtb3YgPGVm
cmVtb3ZAbGludXguY29tPjsgQ29yZW50aW4gTGFiYmUgPGNsYWJiZS5tb250am9pZUBnbWFpbC5j
b20+OyBIZXJiZXJ0IFh1DQo+ID4+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFtQQVRDSCB2MiAxLzRdIGNy
eXB0bzogaW5zaWRlLXNlY3VyZSAtIHVzZSBrZnJlZV9zZW5zaXRpdmUoKQ0KPiA+Pg0KPiA+PiA8
PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+ID4+IFVzZSBrZnJlZV9zZW5zaXRpdmUoKSBpbnN0ZWFk
IG9mIG9wZW4tY29kaW5nIGl0Lg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBEZW5pcyBFZnJl
bW92IDxlZnJlbW92QGxpbnV4LmNvbT4NCj4gPj4gLS0tDQo+ID4+ICBkcml2ZXJzL2NyeXB0by9p
bnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYyB8IDMgKy0tDQo+ID4+ICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYyBiL2RyaXZlcnMv
Y3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWxfaGFzaC5jDQo+ID4+IGluZGV4IDE2YTQ2Nzk2
OWQ4ZS4uNWZmZGMxY2Q1ODQ3IDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9pbnNp
ZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYw0KPiA+PiArKysgYi9kcml2ZXJzL2NyeXB0by9pbnNp
ZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYw0KPiA+PiBAQCAtMTA4Miw4ICsxMDgyLDcgQEAgc3Rh
dGljIGludCBzYWZleGNlbF9obWFjX2luaXRfcGFkKHN0cnVjdCBhaGFzaF9yZXF1ZXN0ICphcmVx
LA0KPiA+PiAgfQ0KPiA+Pg0KPiA+PiAgLyogQXZvaWQgbGVha2luZyAqLw0KPiA+PiAtbWVtemVy
b19leHBsaWNpdChrZXlkdXAsIGtleWxlbik7DQo+ID4+IC1rZnJlZShrZXlkdXApOw0KPiA+PiAr
a2ZyZWVfc2Vuc2l0aXZlKGtleWR1cCk7DQo+ID4+DQo+ID4gSSdtIG5vdCBzdXJlIGhlcmUgLi4u
IEkgdmVyaWZpZWQgaXQgZG9lcyBub3QgYnJlYWsgdGhlIGRyaXZlciAobm90IGEgYmlnIHN1cnBy
aXNlKSwgYnV0IC4uLg0KPiA+DQo+ID4gbWVtemVyb19leHBsaWNpdCBndWFyYW50ZWVzIHRoYXQg
aXQgd2lsbCBub3QgZ2V0IG9wdGltaXplZCBhd2F5IGFuZCB0aGUga2V5ZGF0YSBfYWx3YXlzXw0K
PiA+IGdldHMgb3ZlcndyaXR0ZW4uIERvZXMga2ZyZWVfc2Vuc2l0aXZlIGFsc28gY29tZSB3aXRo
IHN1Y2ggYSBndWFyYW50ZWU/IEkgY291bGQgbm90IGZpbmQgYQ0KPiA+IGhhcmQgc3RhdGVtZW50
IG9uIHRoYXQgaW4gaXRzIGRvY3VtZW50YXRpb24uIEFsdGhvdWdoIHRoZSAic2Vuc2l0aXZlIiBw
YXJ0IHN1cmVseSBzdWdnZXN0cw0KPiA+IGl0Lg0KPg0KPiBrZnJlZV9zZW5zaXRpdmUoKSB1c2Vz
IG1lbXplcm9fZXhwbGljaXQoKSBpbnRlcm5hbGx5Lg0KPg0KT2suIEFsdGhvdWdoIGZvcm1hbGx5
IHRoYXQncyBzdGlsbCBvbmx5IF9jdXJyZW50XyBpbXBsZW1lbnRhdGlvbi4NCkJ1dCBnaXZlbiB0
aGUgZnVuY3Rpb24gbmFtZSwgSSBndWVzcyBpdCdzIGEgZmFpciBhc3N1bXB0aW9uIHRoYXQgdGhl
IGludGVudGlvbiBpcyB0byBtYWludGFpbg0KdGhpcyBiZWhhdmlvciBnb2luZyBmb3J3YXJkLg0K
DQo+ID4gQWRkaXRpb25hbGx5LCB0aGlzIHJlbWFyayBpcyBtYWRlIGluIHRoZSBkb2N1bWVudGF0
aW9uIGZvciBrZnJlZV9zZW5zaXRpdmU6ICJ0aGlzIGZ1bmN0aW9uDQo+ID4gemVyb2VzIHRoZSB3
aG9sZSBhbGxvY2F0ZWQgYnVmZmVyIHdoaWNoIGNhbiBiZSBhIGdvb2QgZGVhbCBiaWdnZXIgdGhh
biB0aGUgcmVxdWVzdGVkIGJ1ZmZlcg0KPiA+IHNpemUgcGFzc2VkIHRvIGttYWxsb2MoKS4gIFNv
IGJlIGNhcmVmdWwgd2hlbiB1c2luZyB0aGlzIGZ1bmN0aW9uIGluIHBlcmZvcm1hbmNlIHNlbnNp
dGl2ZQ0KPiA+IGNvZGUiDQo+ID4NCj4gPiBXaGlsZSB0aGUgbWVtemVyb19leHBsaWNpdCBkb2Vz
IG5vdCB6ZXJvaXplIGFueXRoaW5nIGJleW9uZCBrZXlsZW4uDQo+ID4gV2hpY2ggaXMgYWxsIHlv
dSByZWFsbHkgbmVlZCBoZXJlLCBzbyB3aHkgd291bGQgeW91IHdhbnQgdG8gemVyb2l6ZSBwb3Rl
bnRpYWxseSBhIGxvdCBtb3JlPw0KPiA+IEluIGFueSBjYXNlIHRoZSB0d28gYXJlIG5vdCBmdWxs
eSBlcXVpdmFsZW50Lg0KPg0KPiBUaGVyZSBhcmUgYSBudW1iZXIgb2YgcHJlZGVmaW5lZCBhbGxv
Y2F0aW9uIHNpemVzIChwb3dlciBvZiAyKSBmb3IgZmFzdGVyIGFsbG9jLA0KPiBpLmUuIGh0dHBz
Oi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvaW5jbHVkZS9saW51eC9z
bGFiLmgjTDM0OQ0KPiBhbmQgaXQgbG9va3MgbGlrZSB0aGF0IGtleXMgd2UgZnJlZSBpbiB0aGlz
IHBhdGNoZXMgYXJlIGluIGJvdW5kcyBvZiB0aGVzZSBzaXplcy4NCj4gQXMgZmFyIGFzIEkgdW5k
ZXJzdGFuZCwgaWYgYSBrZXkgaXMgbm90IGEgcG93ZXIgb2YgMiBsZW4sIHRoZSBidWZmZXIgd2ls
bCBiZSB6ZXJvZWQgdG8gdGhlIGNsb3Nlc3QNCj4gcG93ZXIgb2YgMiBzaXplLg0KPg0KVGhpcyBw
YXRoIGlzIGZvciBoYXNoIGtleXMgdGhhdCBhcmUgbGFyZ2VyIHRoYW4gdGhlIGhhc2ggYmxvY2sg
c2l6ZS4gUG90ZW50aWFsbHksIHRoZXJlIGlzIG5vDQp1cHBlciBib3VuZCBvbiB0aGUgc2l6ZSBv
ZiBzdWNoIGEgaGFzaCBrZXksIHNvIGl0IGRvZXNuJ3QgbmVlZCB0byBiZSBpbiB0aGF0IHJhbmdl
IGhlbmNlDQp6ZXJvaXppbmcgdG8gdGhlIG5leHQgcG93ZXIgb2YgMiBib3VuZGFyeSBjb3VsZCBi
ZSBleHBlbnNpdmUuDQpPVE9ILCBJIGRvbid0IGV4cGVjdCB0aGlzIHBhdGggdG8gYmUgZnJlcXVl
bnRseSB1c2VkLCBhbmQgdGhlIGtleSBwcm9jZXNzaW5nIGl0c2VsZiBhbHJlYWR5DQpjb3N0cyBh
IGxvdCBvZiB0aW1lLCBzbyBpdCdzIHByb2JhYmx5IG5vdCB0aGF0IHJlbGV2YW50LiBOZXZlciBt
aW5kLg0KDQpJIGd1ZXNzIHdhcyBtb3JlIGFib3V0IHdoZXRoZXIgdXNpbmcgIGtmcmVlX3NlbnNp
dGl2ZSgpIGlzIGEgZ29vZCByZXBsYWNlbWVudCBfaW4gZ2VuZXJhbF8uDQpGb3IgdGhhdCwgdGhl
cmUgc2hvdWxkIGJlIHNvbWUgZ3VhcmFudGVlZCB1cHBlciBib3VuZCBvbiBob3cgbXVjaCBleHRy
YSB3aWxsIGJlIHplcm9pemVkLg0KDQpHaXZlbiB0aGUgYWJvdmUgY29uc2lkZXJhdGlvbnMgKGFu
ZCBhZnRlciB0ZXN0aW5nIHRoaXMgb24gbXkgaGFyZHdhcmUpOg0KDQpUZXN0ZWQtYnk6IFBhc2Nh
bCB2YW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AcmFtYnVzLmNvbT4NCg0KPiBGb3Igc21hbGwgc2l6
ZXMgbGlrZSB0aGVzZSwgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBzaG91bGQgYmUgdW5ub3RpY2Vh
YmxlIGJlY2F1c2UNCj4gb2YgY2FjaGUgbGluZXMgYW5kIGhvdyBhcmNoLW9wdGltaXplZCBtZW16
ZXJvKCkgd29ya3MuIEtleSBmcmVlaW5nIGRvZXNuJ3QgbG9vayBsaWtlIGEgZnJlcXVlbnQgZXZl
bnQuDQo+DQoNCj4gVGhhbmtzLA0KPiBEZW5pcw0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1
d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMg
U2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6
IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRs
eSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBl
LW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRo
aXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRo
ZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQg
aXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5k
ZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJp
bnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRo
ZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRl
bHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

