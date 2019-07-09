Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B16C73C46
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 16:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AF520656
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 16:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="F9zxye+n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGIQH7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 12:07:59 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:25689 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbfGIQH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 12:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1562688477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6oeUiFUtPMJHtvhTt1jrjfrqn288awWgLrP/0NAE6Wc=;
        b=F9zxye+nyYRcT0Sc1y0ZtmFopy5eI5GDg2508WVMXgme3HSez1i3hIYViTAcarcGCP8g9q
        7EET7Vi+p7FC0I3RuvfY/OKTrM2axrRBUeqQf5l/ycwZJmfe7kXA50bO66fwBANe4UbYef
        g1QhtL9JnizXGRhw0hfpt8nsDNzfL4g=
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-Y7krjNzeOI-wsX9IYjw6HA-1; Tue, 09 Jul 2019 12:07:55 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM (10.169.44.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 16:07:54 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 16:07:54 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftAAKJweAAAjpxDA=
Date:   Tue, 9 Jul 2019 16:07:53 +0000
Message-ID: <TU4PR8401MB0544C80A8F678CF1DF2BCDF5F6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com>
In-Reply-To: <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.104.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93457e24-949e-488d-27a8-08d70487999f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0607;
x-ms-traffictypediagnostic: TU4PR8401MB0607:
x-microsoft-antispam-prvs: <TU4PR8401MB0607BB883C37A59F6AD47392F6F10@TU4PR8401MB0607.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(13464003)(6602003)(51874003)(199004)(189003)(53754006)(99286004)(6246003)(55016002)(316002)(52536014)(53936002)(76176011)(7736002)(74316002)(33656002)(55236004)(102836004)(305945005)(26005)(66066001)(8936002)(9686003)(7696005)(6506007)(53546011)(186003)(6116002)(8676002)(3846002)(486006)(256004)(9456002)(11346002)(81156014)(476003)(4326008)(25786009)(5660300002)(68736007)(78486014)(73956011)(66946007)(478600001)(7116003)(2906002)(81166006)(66476007)(66446008)(64756008)(66556008)(71190400001)(71200400001)(6436002)(229853002)(3480700005)(446003)(86362001)(76116006)(6916009)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0607;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9un8A/bbFlsd8fk1f8HULPxcmRSyRsnXr0Zd4P7jv2OdVJXL/NHj3ExL1iyJiJBRXkDreZ8cWHVdd8+iixmolHpMF+yjax+1QSEc0epTq1gnANWOekgovwNqkaZMDmTMszzK8VD8zZSz276+v4zsh6WJRKh12DIUgkJLxzxmcA+a900eH1Xyo51DoKEJdtuvweWACXEEwQsbKdQdYCQyHCDcAkFQ+tK9rJyJfE4WpanlKzQk2JN02kwwjOaXZ8WAK7WYMRRlXWwYEobX4ueOII57b6n5z4HWMyOtHncB6WcETlUGpRjcWLq/6biawXCj5lgYR13u7wsMGE2bVsI/VCahpEPX9eF0QEgH8GI+zN3nT5x/IehMJu3TIdjWYbLkipv75uS6B3z5OsOkrhrwTlNZvLJmMfRQZxh0EVOwalA=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93457e24-949e-488d-27a8-08d70487999f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 16:07:53.9554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0607
X-MC-Unique: Y7krjNzeOI-wsX9IYjw6HA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgR2lsYWQsDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHRoZSByZXNwb25zZS4gSSBhbSBh
biBlbnRyeSBsZXZlbCBlbmdpbmVlciB3aGVuIGl0IGNvbWVzIHRvIExpbnV4IEtlcm5lbC4gIEkg
aGF2ZSBnb25lIHRocm91Z2ggdGhlIHRlc3RtZ3IuIEkgYW0gbm90IHZlcnkgY2xlYXIgb24gaG93
IHRvIHVzZSBpdCBmb3IgS0FUIChLbm93biBhbnN3ZXIgdGVzdHMpLCBNTVQgYW5kIE1DVCB0ZXN0
cy4gDQpBbHNvIEkgYW0gbm90IGNsZWFyIG9uIGhvdyB0byB1c2UgaXQgd2l0aCB2YXJpb3VzIHRl
c3QgdmVjdG9ycyBmb3IgQUVTLCBTSEEsIEhNQUMsIERSQkcgYW5kIFJTQQ0KDQpJZiB5b3UgcG9p
bnQgbWUgYW55IGV4YW1wbGUgb24gaG93IHRvIHVzZSBpdCwgaXQgd2lsbCBwcm92aWRlIG1lIGEg
ZGlyZWN0aW9uIHRvIHVzZSBpdC4NCg0KVGhhbmtzIGluIGFkdmFuY2UsDQpKYXlhbGFrc2htaSAN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IGxpbnV4LWNyeXB0by1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uIEJl
aGFsZiBPZiBHaWxhZCBCZW4tWW9zc2VmDQpTZW50OiBUdWVzZGF5LCBKdWx5IDA5LCAyMDE5IDU6
MDQgUE0NClRvOiBCaGF0LCBKYXlhbGFrc2htaSBNYW5qdW5hdGggPGpheWFsYWtzaG1pLmJoYXRA
aHAuY29tPg0KQ2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBD
QVZTIHRlc3QgaGFybmVzcw0KDQpPbiBUdWUsIEp1bCA5LCAyMDE5IGF0IDk6NDQgQU0gQmhhdCwg
SmF5YWxha3NobWkgTWFuanVuYXRoIDxqYXlhbGFrc2htaS5iaGF0QGhwLmNvbT4gd3JvdGU6DQo+
DQo+IEhpIEFsbCwNCj4NCj4gV2UgYXJlIHdvcmtpbmcgb24gYSBwcm9kdWN0IHRoYXQgcmVxdWly
ZXMgTklBUCBjZXJ0aWZpY2F0aW9uIGFuZCB1c2UgSVBTZWMgZW52aXJvbm1lbnQgZm9yIGNlcnRp
ZmljYXRpb24uIElQU2VjIGZ1bmN0aW9uYWxpdHkgaXMgYWNoaWV2ZWQgYnkgdGhpcmQgcGFydHkg
SVBzZWMgbGlicmFyeSBhbmQgbmF0aXZlIFhGUk0uDQo+IFRoaXJkICBwYXJ0eSBJUHNlYyBsaWJy
YXJ5IGlzIHVzZWQgZm9yIElTQUtNUCBhbmQgWEZSTSBmb3IgSVBzZWMuDQo+DQo+IENBVlMgdGVz
dCBjYXNlcyBhcmUgcmVxdWlyZWQgZm9yIE5JQVAgY2VydGlmaWNhdGlvbi4gIFRodXMgd2UgbmVl
ZCB0byANCj4gaW1wbGVtZW50IENBVlMgdGVzdCBoYXJuZXNzIGZvciBUaGlyZCBwYXJ0eSBsaWJy
YXJ5IGFuZCBMaW51eCBjcnlwdG8gYWxnb3JpdGhtcy4gSSBmb3VuZCB0aGUgZG9jdW1lbnRhdGlv
biBvbiBrZXJuZWwgY3J5cHRvIEFQSSB1c2FnZS4NCj4NCj4gUGxlYXNlIGNhbiB5b3UgaW5kaWNh
dGlvbiB3aGF0IGlzIHRoZSByaWdodCBtZXRob2QgdG8gaW1wbGVtZW50IHRoZSB0ZXN0IGhhcm5l
c3MgZm9yIExpbnV4IGNyeXB0byBhbGdvcml0aG1zLg0KPiAxLiAgICAgIFNob3VsZCBJIGltcGxl
bWVudCBDQVZTIHRlc3QgaGFybmVzcyBmb3IgTGludXgga2VybmVsIGNyeXB0byBhbGdvcml0aG1z
IGFzIGEgdXNlciBzcGFjZSBhcHBsaWNhdGlvbiB0aGF0IGV4ZXJjaXNlIHRoZSBrZXJuZWwgY3J5
cHRvIEFQST8NCj4gMi4gICAgICBTaG91bGQgSSBpbXBsZW1lbnQgIENBVlMgdGVzdCBoYXJuZXNz
IGFzIG1vZHVsZSBpbiBMaW51eCBrZXJuZWw/DQo+DQo+DQo+IEFueSBpbmZvcm1hdGlvbiBvbiB0
aGlzIHdpbGwgaGVscCBtZSB2ZXJ5IG11Y2ggb24gaW1wbGVtZW50YXRpb24uDQoNCkFyZSB5b3Ug
c3VyZSB0aGUgbmVlZGVkIHRlc3RzIGFyZSBub3QgYWxyZWFkeSBpbXBsZW1lbnRlZCBpbiB0aGUg
a2VybmVsIGNyeXB0byBBUEkgdGVzdG1ncj8NCg0KR2lsYWQNCg0KDQotLQ0KR2lsYWQgQmVuLVlv
c3NlZg0KQ2hpZWYgQ29mZmVlIERyaW5rZXINCg0KdmFsdWVzIG9mIM6yIHdpbGwgZ2l2ZSByaXNl
IHRvIGRvbSENCg0K

