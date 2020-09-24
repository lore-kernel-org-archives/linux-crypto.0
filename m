Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E9DC4363D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 12:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91529235FD
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 12:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="dC9GTjDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgIXMvb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 08:51:31 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:44621 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbgIXMvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 08:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1600951875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+M1Y1ehR/qfZkWbrH1VzLaIFUpj+G5gsLN/oMF/QjY=;
        b=dC9GTjDhuma1J23njeP/CLDWrU1iopi6hIS0ApNE1SAjKu9ku4oQuIfm9W5qzb8nIVwOXI
        WCUdsC4u8+RCr4LKhIjwEYGV/M5mH52CUejs6akqGU5Q4Aze+Afo1cydhqrMHpPyt9XbBV
        ODMi6GLazX/JzjAV6hS+NwqgEOeT+as=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-MFKX99PKNv-tN-tNbvRN1w-1; Thu, 24 Sep 2020 08:51:14 -0400
X-MC-Unique: MFKX99PKNv-tN-tNbvRN1w-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0489.namprd04.prod.outlook.com
 (2603:10b6:903:b4::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Thu, 24 Sep
 2020 12:51:11 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.019; Thu, 24 Sep 2020
 12:51:11 +0000
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
Thread-Index: AQHWhPjdSpcGgYTiMUOu7ID5mrD0iqluCCwAgAAMa6CAAAVIgIAABV7AgAkXuQCAADvR4IAAYcqAgAAA/SA=
Date:   Thu, 24 Sep 2020 12:51:11 +0000
Message-ID: <CY4PR0401MB36528881D714296074EF135AC3390@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
 <20200918065806.GA9698@gondor.apana.org.au>
 <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200918080127.GA24222@gondor.apana.org.au>
 <CY4PR0401MB365268AA17E35E5B55ABF7E6C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200924031154.GA8282@gondor.apana.org.au>
 <CY4PR0401MB3652E2654AE84DC173E008E2C3390@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200924123559.GA10827@gondor.apana.org.au>
In-Reply-To: <20200924123559.GA10827@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df331d36-a158-4dfd-fd5d-08d8608883f9
x-ms-traffictypediagnostic: CY4PR04MB0489:
x-microsoft-antispam-prvs: <CY4PR04MB048943C5463C0182B3B61ED1C3390@CY4PR04MB0489.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: G5rWXCK6hdA3Foyd0/dkv/JPqe1wVXxP5DYR2Yxac6wgQzK0ocwomQ5dlzpdisw9bUP2Gf3R0gg48MUX6G8E3AxLn2WPNBD60m2bM5fHaLvuMH4vAbSlr624anGVsUWbXJD8QDbFEGl/i/FuLkS6n5nx/MWjvKAPfoL0TtuXKs23vzmoXcWoF/SJRsTFf71EWjhRZ6ISkJgMG0D9tLdrjLQR5esVAaRoKrgqNXk2j5tNuuy831k0rh9n3GAGXJOWLulhxXAKkOMHRDQBXYy/cYPKSaAf6DyWrj+dpkF3wmnntCUMKMd+yaAsRWrtCKS3DVY0jjZMdEIc4zQoeyJ2RtW06oWBMQDjY/X4kGheS1oi2D12JmL26GevKE1J031LmFwWPSIZreQdwGSvAOL54BDYldDla1/1B42YIWZOsgJNfMvdxgRB48MyqpjPgnQUGWTM/2z2chmlMSh1zUSLAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(376002)(366004)(396003)(346002)(55016002)(33656002)(9686003)(83380400001)(4326008)(5660300002)(83080400001)(66946007)(71200400001)(66556008)(966005)(86362001)(8676002)(7696005)(66476007)(64756008)(76116006)(8936002)(52536014)(316002)(2906002)(53546011)(478600001)(6506007)(186003)(54906003)(6916009)(66446008)(26005);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: HwpIajen/9Eaqmdr9YJTDvPSLl4a6knpQfwdVVFYkCwcuzZp+2LjAsWNubPQzL5K+NbKiFeSooAgUI3PvUBkmYuduoE1cQVAj1nhpcFsLtgTpU4Qk7kRookz1hHiNSLhxetWReqyN8lKNbOXxc/ln0Ubo7xEaKMJ1PCUulNwaDNfov5atEam7ti5IB0N2TpKDPATpCOqpU4S+tWCSQS9/734wgHuukf7VzqxAFd/20ejnMnDrC87zT9ER3gG7sOfbvYcsoBzdJQqxC6bQKXbM3rkQVYiMC35DhImxgVd3BSwPXy95oz9gSc9VLI0sBRydeRsPxds/oKlmpOkXpJ5ZTJ2jbm/5GIRawz7y3Pv2GHAl9QXxswQgbvJh85mR4h8CzoKnmrtl0Byf9gm/53QhtVHXa/6fEvhlqyISc5F4FHdZfIn+Yv7JEM1jaqyZVLvtOLeijyswlTYv/TeyXx7fOrPY/l/N9sF6Fut9B6Pf76uR0oHG11tp1MENHuxfFhOjGWzaElwiEBr6o8wsf5HjGTAoPi5S8fA76ugEFoSnWJl8HQ0YponTrE+3Dom8YVvN46GQEXiPwUHoTh8atiJyIXlolj+wuOXCOXxjb4oV1uRLAMvl1cfCaK87sfn656oRRp23bCNJ26n+P6L6VbJfA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df331d36-a158-4dfd-fd5d-08d8608883f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 12:51:11.7203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UPe9JmHWe6CAGvq5fxYLtJqcf0rrlqZzvVUHMoV448CWsEbZCBkiarbMIPLFo/ysRo3RumPGpo+qRA3U+ECNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0489
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAyNCwg
MjAyMCAyOjM2IFBNDQo+IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1i
dXMuY29tPg0KPiBDYzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgYW50b2luZS50ZW5h
cnRAYm9vdGxpbi5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IEFyZCBCaWVzaGV1dmVsIDxhcmRi
QGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGNyeXB0bzogaW5zaWRlLXNlY3Vy
ZSAtIEZpeCBjb3JydXB0aW9uIG9uIG5vdCBmdWxseSBjb2hlcmVudCBzeXN0ZW1zDQo+DQo+IDw8
PCBFeHRlcm5hbCBFbWFpbCA+Pj4NCj4gT24gVGh1LCBTZXAgMjQsIDIwMjAgYXQgMDg6MDg6MTJB
TSArMDAwMCwgVmFuIExlZXV3ZW4sIFBhc2NhbCB3cm90ZToNCj4gPg0KPiA+IFRoZSBmYWN0IHRo
YXQga21hbGxvYyB1c2VzIGl0IGRvZXMgX25vdF8gcnVsZSBvdXQgdGhlIGZhY3QgdGhhdCBpdCB3
YXN0ZXMgbWVtb3J5IC4uLg0KPiA+IEFuZCBhcyBsb25nIGFzIHlvdSB1c2Uga21hbGxvYyBmb3Ig
ZmFpcmx5IGxhcmdlIGRhdGEgc3RydWN0dXJlcywgaXQgc2hvdWxkbid0IG1hdHRlciBtdWNoLg0K
PiA+IEJ1dCBoZXJlIEkgbmVlZCBhIGNvdXBsZSBvZiBmYWlybHkgc21hbGwgYnVmZmVycy4NCj4N
Cj4gVGhvc2Ugc21hbGwgYnVmZmVycyBhcmUgZW1iZWRkZWQgaW4gYSBzdHJ1Y3R1cmUgdGhhdCdz
IGFscmVhZHkNCj4gYWxpZ25lZCBieSBrbWFsbG9jLiAgU28ganVzdCBwdXQgeW91ciBidWZmZXJz
IGF0IHRoZSBzdGFydCBvZg0KPiB0aGUgc3RydWN0IHRvIG1pbmltaXNlIGhvbGVzLg0KPg0KSWYg
eW91IHdvdWxkIG1ha2UgdGhlbSBmaXhlZCBpbiBzaXplLCB0aGVuIHB1dHRpbmcgdGhlbSBhdCB0
aGUgc3RhcnQgaW5zdGVhZCBvZiB0aGUNCmVuZCB3b3VsZCBpbmRlZWQgYnkgYSBiaXQgbW9yZSBl
ZmZpY2llbnQgKGJ1dCBvYnZpb3VzbHksIHRoYXQgZG9lc24ndCB3b3JrIGlmIHlvdQ0KZHluYW1p
Y2FsbHkgc2NhbGUgdGhlbSksIEknbGwgcmVtZW1iZXIgdGhhdC4NCg0KQnV0IHlvdSBzdGlsbCBo
YXZlIDIgcG90ZW50aWFsIGdhcHMgKGZyb20gYnVmZmVyIDEgdG8gYnVmZmVyIDIgYW5kIGZyb20g
YnVmZmVyIDIgdG8NCnRoZSBvdGhlciBpdGVtcyBpbiB0aGUgc3RydWN0KSB0aGF0IGFyZSBsYXJn
ZXIgdGhlbiB0aGV5IG1heSBuZWVkIHRvIGJlLg0KSWYgZXZlcnlvbmUgY2FuIGxpdmUgd2l0aCB0
aGUgd2FzdGVkIHNwYWNlLCBpdCdzIGZpbmUgYnkgbWUuIChmcmFua2x5LCBJIGRvbid0IGtub3cN
CndoZXJlIHRoZXNlIHN0cnVjdHMgbWF5IGVuZCB1cCAtIGd1ZXNzIG5vdCBvbiB0aGUgbWluaW1h
bCBrZXJuZWwgc3RhY2sgdGhlbj8pDQoNCkkgb25seSBkaWQgaXQgdGhpcyB3YXkgIGJlY2F1c2Ug
SSBhbnRpY2lwYXRlZCB0aGF0IHRoYXQgd291bGQgYmUgYWNjZXB0ZWQgLi4uIGd1ZXNzIEkNCmNv
dWxkJ3ZlIHNhdmUgbXlzZWxmIHNvbWUgdHJvdWJsZSB0aGVyZSA6LSkNCg0KUmVnYXJkcywNClBh
c2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QgTXVsdGktUHJvdG9jb2wgRW5n
aW5lcywgUmFtYnVzIFNlY3VyaXR5DQpSYW1idXMgUk9UVyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4
MTk1Mw0KDQpOb3RlOiBUaGUgSW5zaWRlIFNlY3VyZS9WZXJpbWF0cml4IFNpbGljb24gSVAgdGVh
bSB3YXMgcmVjZW50bHkgYWNxdWlyZWQgYnkgUmFtYnVzLg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8g
dXBkYXRlIHlvdXIgZS1tYWlsIGFkZHJlc3MgYm9vayB3aXRoIG15IG5ldyBlLW1haWwgYWRkcmVz
cy4NCg0KPiBDaGVlcnMsDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXU+DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUv
fmhlcmJlcnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0
L3B1YmtleS50eHQNCg0KDQoqKiBUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBhcmUg
Zm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkgY29u
dGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZpZGVudGlhbCBhbmQgcHJpdmlsZWdlZC4gSWYg
eW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBvZiB0aGlzIG1lc3NhZ2UsIHlvdSBh
cmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5nLCBmb3J3YXJkaW5nIG9yIHNhdmlu
ZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0YWNobWVudHMgYW5kIG5vdGlm
eSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KDQpSYW1idXMgSW5jLjxodHRwOi8vd3d3LnJh
bWJ1cy5jb20+DQo=

