Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90FCC433EC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE802067D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="Hv2uOc0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGPIvI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:51:08 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:42641 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgGPIvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 04:51:07 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 04:51:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1594889464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wf1JSyT8wPrVdJMztdjChy5RiImEGiV2n1G9/o8pcBo=;
        b=Hv2uOc0BeK4Y3YoRWy2Lgrhr8zEP6EO0QZgsIu+PnIYZHeti7xkH7n8+zMlm1vvMnzScve
        AJCQ9qeNXVnISsnYDDympM+x4ANcNTd6odO0rogC3Vpndsmd/uOfTnxZQrKSahouvTeXTV
        5p9RP//h7k9lT97iDiL5BqU26CDG+/A=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-osQ9QZlmPv6nswTq2f70IQ-1; Thu, 16 Jul 2020 04:44:25 -0400
X-MC-Unique: osQ9QZlmPv6nswTq2f70IQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0487.namprd04.prod.outlook.com
 (2603:10b6:903:ba::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 08:44:23 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8%3]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 08:44:23 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sven Auhagen <sven.auhagen@voleatech.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH 1/1] inside-secure irq balance
Thread-Topic: [PATCH 1/1] inside-secure irq balance
Thread-Index: AQHWVTnF8yi2xZXtHEanK4X4ohcC6qkJ2QOAgAAWhUA=
Date:   Thu, 16 Jul 2020 08:44:23 +0000
Message-ID: <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
In-Reply-To: <20200716072133.GA28028@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10af8a4f-c26c-4a0b-4ef6-08d8296470d1
x-ms-traffictypediagnostic: CY4PR04MB0487:
x-microsoft-antispam-prvs: <CY4PR04MB0487303618F674E298CDB0DDC37F0@CY4PR04MB0487.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NbvQ8zMgtPL5eeOOebQ/PQ2gFMcLtP/5gIPKd4PiKgjkhCE6QC7909zgOEEhB8RBkcPKtuMX8V7VTnDraxXL0vyj5FHIpVYeTG7I9A3Ihpx/NNE9VpOplxE+V4n0PHPpbpP9cGealATj7L1u/0E0iLUkVbtmBLr9xT6XeT/6PahnzjTabjzzalLLr8BIuVloTodCr2m0nTQjpqoWbo1JLSLDQngTwwAMZbaLQKaElITv6KBLYCwSsh6QqNRS6FGuPzlouOhQt1mfjAfUFp+70xfOU3b51JhHsC7RwoYH/k93pgzREZqc5Wgqqj0XQWAvXcmVudVFPVmW1tz/JVSL9UizBS6PkiHwIFGFVOvLK9q2FzGH1FNu56l+5AxTO/BwAQ4umNvrEXJaf+92EQHfeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(396003)(39850400004)(366004)(52536014)(66446008)(64756008)(66556008)(66476007)(4326008)(66946007)(53546011)(6506007)(26005)(7696005)(76116006)(83080400001)(5660300002)(186003)(33656002)(83380400001)(86362001)(8676002)(9686003)(8936002)(55016002)(71200400001)(110136005)(2906002)(966005)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BlP+vkIlQ1OP0NayK/AxJiVLJBwZE7HswrQCdhvtTIT7+vRbuWm0MzWrUYC7476chRUr84Xw4nD4hNXVfAQOVuFj8dWJyKv3cHsfDX7RLQ0XCsXKrb+jgtpMsziKnagPi3Id/RPvx1sBrp6e5BIP5Ipl45ssPo+O6iX/p/K7ePsj0ZYFMxxzCmM3G4YCwOS+WkqalHvy0FahWBS5PQ7VKZBP56EkVoK0xdEa8fbfDCIA8Htz/ohiQiDsdw7peLeOszSQcS5mGl7Od0RFNtQWt02j95AV0AgkQQ/o5kV+7j/oDc0q6P9/iPmEN5i6A2ir3NLNM+NDXRXCr6JxkABIh9DVl29WsMT3HdRcCwtpPaKEf516HCeVQH6CUiimsIn/4hzaiz0TUteW1K1q4GavydeUA7ND2FLEfpdt+AqEi0Qkm/O1+sJy5kg2sUfRFcimFLQZqfUj1aM/IEQIjbKJcfZHexbMhUYvJtcGJ6HZSPScGRcQp7NgXiDxMqScYHIJ
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10af8a4f-c26c-4a0b-4ef6-08d8296470d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 08:44:23.8079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xIbfQ3QM4yLS//urMhMwBrqy+2copRsC7dzbLGneV8zY8qgsz79kLZdKT0z3KvKI5HPtvprl8o8izMtuj5UfQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0487
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgSGVyYmVydCBYdQ0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAxNiwgMjAyMCA5OjIy
IEFNDQo+IFRvOiBTdmVuIEF1aGFnZW4gPHN2ZW4uYXVoYWdlbkB2b2xlYXRlY2guZGU+DQo+IENj
OiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8x
XSBpbnNpZGUtc2VjdXJlIGlycSBiYWxhbmNlDQo+DQo+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4N
Cj4gU3ZlbiBBdWhhZ2VuIDxzdmVuLmF1aGFnZW5Adm9sZWF0ZWNoLmRlPiB3cm90ZToNCj4gPg0K
PiA+ICsgICAgICAgLy8gU2V0IGFmZmluaXR5DQo+ID4gKyAgICAgICBjcHUgPSByaW5nX2lkICUg
bnVtX29ubGluZV9jcHVzKCk7DQo+ID4gKyAgICAgICBpcnFfc2V0X2FmZmluaXR5X2hpbnQoaXJx
LCBnZXRfY3B1X21hc2soY3B1KSk7DQo+ID4gKw0KPg0KPiBUaGlzIGRvZXNuJ3QgbG9vayByaWdo
dC4gIFRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0IHRoZSBvbmxpbmUNCj4gQ1BVcyBhcmUgdGhl
IGxvd2VzdCBiaXRzIGluIHRoZSBiaXRtYXNrLiAgQWxzbywgd2hhdCBhcmUgeW91IGdvaW5nDQo+
IHRvIGRvIHdoZW4gdGhlIENQVXMgZ28gZG93biAob3IgdXApPw0KPg0KDQpPaywgSSB3YXMganVz
dCBhYm91dCB0byB0ZXN0IHRoaXMgcGF0Y2ggd2l0aCBteSBoYXJkd2FyZSwgYnV0IEkgc3VwcG9z
ZSBJIGNhbiBzcGFyZSBteXNlbGYgdGhlDQp0cm91YmxlIGlmIGl0IGRvZXNuJ3QgbWFrZSBzZW5z
ZS4gSSBhbHJlYWR5IGhhZCBhIGh1bmNoIGl0IHdhcyB0b28gc2ltcGxpc3RpYyBmb3IgZ2VuZXJh
bCB1c2UuDQpIb3dldmVyLCBoZSBkb2VzIGdldCBhIHZlcnkgc2lnbmlmaWNhbnQgc3BlZWQgYm9v
c3Qgb3V0IG9mIHRoaXMsIHdoaWNoIG1ha2VzIHNlbnNlIGFzIGhhdmluZw0KdGhlIGludGVycnVw
dHMgcHJvcGVybHkgZGlzdHJpYnV0ZWQgQU5EIHBpbm5lZCB0byBhIGZpeGVkIENQVSBlbnN1cmVz
IHByb3BlciB3b3JrbG9hZA0KZGlzdHJpYnV0aW9uIGFuZCBjYWNoZSBsb2NhbGl0eS4gSW4gZmFj
dCwgdGhpcyB3YXMgdGhlIHdob2xlIGlkZWEgYmVoaW5kIGhhdmluZyBtdWx0aXBsZSByaW5ncw0K
YW5kIGludGVycnVwdHMuDQoNClNvIGlzIHRoZXJlIGEgYmV0dGVyIHdheSB0byBhY2hpZXZlIHRo
ZSBzYW1lIGdvYWwgZnJvbSB0aGUgZHJpdmVyPyBPciBpcyB0aGlzIHJlYWxseSBzb21ldGhpbmcN
CnlvdSBjYW5ub3QgZml4IGluIHRoZSBjcnlwdG8gZHJpdmVyIGl0c2VsZj8NCg0KPiBDaGVlcnMs
DQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+
DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvDQo+IFBH
UCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0L3B1YmtleS50eHQNCg0K
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

