Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC9CC433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 13:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E584D20829
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 13:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="Pid85ti/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIBNMt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 09:12:49 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:21700 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727058AbgIBNKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 09:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1599052236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QoE6cNMCdGODw15UUVUr8dNgr7/w9QJmtrheZdMHyN8=;
        b=Pid85ti/khgVpsmF3lInokonnqth3Gm2l2WxY8PoFKKJDrjEmiNdnyJkh4fARRGnknUtzu
        x9a9SOTAwmSIQ60s7LPE1tYwItMvP7yG0xl7WfIUnjS6NTddCxQ/0BCaSUx430FdvLgzYf
        b4oX+OtpZgdsCAn6c40/NslEpxODkiI=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-091kDmb5MhiY4gxy327PbA-1; Wed, 02 Sep 2020 09:10:34 -0400
X-MC-Unique: 091kDmb5MhiY4gxy327PbA-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3508.namprd04.prod.outlook.com
 (2603:10b6:910:95::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Wed, 2 Sep
 2020 13:10:32 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::5156:a625:2439:9efe]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::5156:a625:2439:9efe%6]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 13:10:32 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Denis Efremov <efremov@linux.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Thread-Topic: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Thread-Index: AQHWfD2wL6/f5wfOgEK5sXo0DwsOjKlVWorw
Date:   Wed, 2 Sep 2020 13:10:31 +0000
Message-ID: <CY4PR0401MB3652FFD58D9ED14F4805FC99C32F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-2-efremov@linux.com>
In-Reply-To: <20200827064402.7130-2-efremov@linux.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9da10e7b-f27b-420d-f5cb-08d84f419274
x-ms-traffictypediagnostic: CY4PR0401MB3508:
x-microsoft-antispam-prvs: <CY4PR0401MB35082C057220ECE8E5469C69C32F0@CY4PR0401MB3508.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OXoWZX1p0wcoI/4bS+CCx9i8H813UlF972eFM6mIukH9mW4dj8UAGS7Q8HCAESuxLBM/NolSKQglGQPX7aKmDl9ejTk5AYO/oqVX1Cf65fS9nyvDS2gk4wqo2BhyLijDriLqXb0Wo4f5GL46uahb3AKOJN812v69Oeh2vO8TmIx5hRi/rKTlAK0D4Mue9GZkmtHRUjj+he9o6LL2Ox6x7GeA+M/SUNt4aBWI+AVz8GZPBHO/Km4EbAWS36UIvMrKHTYpfnmDoeokoVJy3rJDqDjPXGpLDfzWee8dihBd44afWQ4trTaVhN2l+E5Bk+SCGLgHWU2EBYoGGFROD7SEjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(366004)(136003)(396003)(376002)(9686003)(5660300002)(478600001)(86362001)(52536014)(4326008)(186003)(76116006)(8676002)(53546011)(64756008)(71200400001)(33656002)(66476007)(66556008)(7696005)(66946007)(26005)(8936002)(2906002)(83380400001)(6506007)(55016002)(316002)(54906003)(110136005)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Tv5TcstombEZBeDFnlF0He9H+Rj2+nlk1BmcJj6oTxdJOYYLyQn1T8tjBXUhDLAsp/sOubZ6/f8dA1jHuNPQlI6PWjhyIrzxmRSBYi9Nssjjf7eQbwoo65r6VtveLi/Nh4Ma6zoOZRsSkDGTnwyB4gpQsmZVTvDsL3h6cjjsSCflOqLQg2dh9aP4uM0bnzn/y7SxJkoLDZ92zWYfGWEEjBQ73lv/KLxF7sU0zSJQinARBhXPUdWJXsZqHutDblesr0djvQcKxOhUG/dMtlh5/7zSsyLDVALIaqHJ0AvDha2amU9ruqG40rzLzVlkSOvWt3dsT+ypCFcB2po3o32ui21ly3BcijafdK4m5K/pZiYjyvHa0IK+1x1ywl8hm8U5QVcEsSBI4UlB0KW0J3c1d/+rwXHuLv1AUjquXCF+RnwbH2l8CtozNmohxBb+qIJrcFhAGRPVkjKCNn4uiUP0LWZPFhib9XqnLYa6t4U8C3Nz183O+mfYcd1anVZUnx4URlihEaqWCXZL7d6W1Am50Db9xkPqXIqq4gcDrALBRyai3FOFRdNjI3qRpDTMNGujiPF7AMz5cmN1FEnIreP4J+mz9dDaG5LgedT+uq6lL0CUnuIaghW9/IV6g/Nr/BNmhfBQA3U/+YQOnvATbMyDhQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da10e7b-f27b-420d-f5cb-08d84f419274
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 13:10:32.0243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4cFqLWXDwAorN0D4vHyzGJ5IbuN/39RCFbv11peUf1V26cO7/aVpaEmou9qhDxeE++ciK+9UZM4H0G37PGTHlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3508
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgRGVuaXMgRWZyZW1vdg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI3LCAyMDIw
IDg6NDQgQU0NCj4gVG86IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IERlbmlz
IEVmcmVtb3YgPGVmcmVtb3ZAbGludXguY29tPjsgQ29yZW50aW4gTGFiYmUgPGNsYWJiZS5tb250
am9pZUBnbWFpbC5jb20+OyBIZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcu
YXU+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSCB2MiAx
LzRdIGNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIHVzZSBrZnJlZV9zZW5zaXRpdmUoKQ0KPg0KPiA8
PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+IFVzZSBrZnJlZV9zZW5zaXRpdmUoKSBpbnN0ZWFkIG9m
IG9wZW4tY29kaW5nIGl0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBEZW5pcyBFZnJlbW92IDxlZnJl
bW92QGxpbnV4LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3Nh
ZmV4Y2VsX2hhc2guYyB8IDMgKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9pbnNpZGUt
c2VjdXJlL3NhZmV4Y2VsX2hhc2guYyBiL2RyaXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2Fm
ZXhjZWxfaGFzaC5jDQo+IGluZGV4IDE2YTQ2Nzk2OWQ4ZS4uNWZmZGMxY2Q1ODQ3IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYw0KPiAr
KysgYi9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2hhc2guYw0KPiBAQCAt
MTA4Miw4ICsxMDgyLDcgQEAgc3RhdGljIGludCBzYWZleGNlbF9obWFjX2luaXRfcGFkKHN0cnVj
dCBhaGFzaF9yZXF1ZXN0ICphcmVxLA0KPiAgfQ0KPg0KPiAgLyogQXZvaWQgbGVha2luZyAqLw0K
PiAtbWVtemVyb19leHBsaWNpdChrZXlkdXAsIGtleWxlbik7DQo+IC1rZnJlZShrZXlkdXApOw0K
PiAra2ZyZWVfc2Vuc2l0aXZlKGtleWR1cCk7DQo+DQpJJ20gbm90IHN1cmUgaGVyZSAuLi4gSSB2
ZXJpZmllZCBpdCBkb2VzIG5vdCBicmVhayB0aGUgZHJpdmVyIChub3QgYSBiaWcgc3VycHJpc2Up
LCBidXQgLi4uDQoNCm1lbXplcm9fZXhwbGljaXQgZ3VhcmFudGVlcyB0aGF0IGl0IHdpbGwgbm90
IGdldCBvcHRpbWl6ZWQgYXdheSBhbmQgdGhlIGtleWRhdGEgX2Fsd2F5c18NCmdldHMgb3Zlcndy
aXR0ZW4uIERvZXMga2ZyZWVfc2Vuc2l0aXZlIGFsc28gY29tZSB3aXRoIHN1Y2ggYSBndWFyYW50
ZWU/IEkgY291bGQgbm90IGZpbmQgYQ0KaGFyZCBzdGF0ZW1lbnQgb24gdGhhdCBpbiBpdHMgZG9j
dW1lbnRhdGlvbi4gQWx0aG91Z2ggdGhlICJzZW5zaXRpdmUiIHBhcnQgc3VyZWx5IHN1Z2dlc3Rz
DQppdC4NCg0KQWRkaXRpb25hbGx5LCB0aGlzIHJlbWFyayBpcyBtYWRlIGluIHRoZSBkb2N1bWVu
dGF0aW9uIGZvciBrZnJlZV9zZW5zaXRpdmU6ICJ0aGlzIGZ1bmN0aW9uDQp6ZXJvZXMgdGhlIHdo
b2xlIGFsbG9jYXRlZCBidWZmZXIgd2hpY2ggY2FuIGJlIGEgZ29vZCBkZWFsIGJpZ2dlciB0aGFu
IHRoZSByZXF1ZXN0ZWQgYnVmZmVyDQpzaXplIHBhc3NlZCB0byBrbWFsbG9jKCkuICBTbyBiZSBj
YXJlZnVsIHdoZW4gdXNpbmcgdGhpcyBmdW5jdGlvbiBpbiBwZXJmb3JtYW5jZSBzZW5zaXRpdmUN
CmNvZGUiDQoNCldoaWxlIHRoZSBtZW16ZXJvX2V4cGxpY2l0IGRvZXMgbm90IHplcm9pemUgYW55
dGhpbmcgYmV5b25kIGtleWxlbi4NCldoaWNoIGlzIGFsbCB5b3UgcmVhbGx5IG5lZWQgaGVyZSwg
c28gd2h5IHdvdWxkIHlvdSB3YW50IHRvIHplcm9pemUgcG90ZW50aWFsbHkgYSBsb3QgbW9yZT8N
CkluIGFueSBjYXNlIHRoZSB0d28gYXJlIG5vdCBmdWxseSBlcXVpdmFsZW50Lg0KDQpBbnkgb3Bp
bmlvbnM/DQoNCj4gIGlmIChyZXQpDQo+ICByZXR1cm4gcmV0Ow0KPiAtLQ0KPiAyLjI2LjINCg0K
UmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QgTXVsdGkt
UHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5DQpSYW1idXMgUk9UVyBIb2xkaW5nIEJW
DQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5zaWRlIFNlY3VyZS9WZXJpbWF0cml4IFNp
bGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWlyZWQgYnkgUmFtYnVzLg0KUGxlYXNlIGJl
IHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFkZHJlc3MgYm9vayB3aXRoIG15IG5ldyBl
LW1haWwgYWRkcmVzcy4NCg0KDQoqKiBUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBh
cmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkg
Y29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZpZGVudGlhbCBhbmQgcHJpdmlsZWdlZC4g
SWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBvZiB0aGlzIG1lc3NhZ2UsIHlv
dSBhcmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5nLCBmb3J3YXJkaW5nIG9yIHNh
dmluZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0YWNobWVudHMgYW5kIG5v
dGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KDQpSYW1idXMgSW5jLjxodHRwOi8vd3d3
LnJhbWJ1cy5jb20+DQo=

