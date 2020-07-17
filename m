Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5A2C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 08:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20CC92080D
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 08:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="F1KQFwCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgGQI4P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 04:56:15 -0400
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:48248 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbgGQI4O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 04:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1594976172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NbEIlVUm9AB0fjYMMmAJzgnmPLtz35ecm+0xicZO2kQ=;
        b=F1KQFwCaFE6GeKavjJbD4oQ6TLiRI7uEyCNjq3cvMsZnk2WJtw2iov9DQi6xr61W+wUujh
        y7NnU74EdkWGu44CuhCor3Tk/86FcXgtOwOAjvsqbHHmq9meeB3WfqUMhbOalXzIYaO5U+
        KZ0aYw2tD1ZAUsS8AJCg16Bm32iayzc=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-eojpQdzcNseJGyepDfLREQ-1; Fri, 17 Jul 2020 04:56:10 -0400
X-MC-Unique: eojpQdzcNseJGyepDfLREQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0648.namprd04.prod.outlook.com
 (2603:10b6:903:e1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Fri, 17 Jul
 2020 08:56:08 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8%3]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 08:56:08 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH 1/1] inside-secure irq balance
Thread-Topic: [PATCH 1/1] inside-secure irq balance
Thread-Index: AQHWVTnF8yi2xZXtHEanK4X4ohcC6qkJ2QOAgAAWhUCAAAsGAIAALXcAgAEcNgCAAAViAIAAFL4AgAAGTgCAAA+hAIAAEBAw
Date:   Fri, 17 Jul 2020 08:56:07 +0000
Message-ID: <CY4PR0401MB3652ED2BFC2833ACCB272868C37C0@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200716092136.j4xt2s4ogr7murod@SvensMacbookPro.hq.voleatech.com>
 <20200716120420.GA31780@gondor.apana.org.au>
 <20200717050134.dk5naairvhmyyxyu@SvensMacBookAir.sven.lan>
 <20200717052050.GA2045@gondor.apana.org.au>
 <20200717063504.sdmjt75oh2jp7z62@SvensMacBookAir.hq.voleatech.com>
 <20200717065738.GC2504@gondor.apana.org.au>
 <20200717075334.vg7nvidds25f5ltb@SvensMacBookAir.hq.voleatech.com>
In-Reply-To: <20200717075334.vg7nvidds25f5ltb@SvensMacBookAir.hq.voleatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c312f362-45ec-4223-a30b-08d82a2f3efc
x-ms-traffictypediagnostic: CY4PR04MB0648:
x-microsoft-antispam-prvs: <CY4PR04MB0648B97EBAD76A1D12E8DFA9C37C0@CY4PR04MB0648.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b7IHoxAvyhawscZSYLDRcqjvdFwRQmEO8OxfeXG+sWqlPQ6t3+BWqCGngzCuz9ch5WD2fOjNBMT31DvvbyLQJFE0GQxTnP26eUTZnfLgQpHGBq2R9120HVGWT+61vZRVc3yhE3ukkrlNCQHZ9vRHCVg3o/kohRVnCAMp6ZwjZQOxgMm0OdBuBjaMGaqX3mrtSyOsbKeRZcU79Ru9Cs5Nt7W73pi6Ga7bWokcS9cGPR2SrG9fpJcDAt7qO6Hperkfx9UrIbrx1jj4GpJDTStUyNw78mhX5Z4CIUuE+n+oI4uQG+Azd7dJ9Du75U2kf1yIcMZtiIaKmuDE+Ivflor3GcD66aRbMXoFWs043SktRI0BrS0njLAsIhH/zv/vw7tXISzdAsInXsM9Mxw6CNPAJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(136003)(366004)(376002)(346002)(45080400002)(71200400001)(478600001)(6506007)(26005)(186003)(53546011)(2906002)(76116006)(66946007)(966005)(4326008)(66446008)(64756008)(110136005)(66556008)(7696005)(316002)(66476007)(33656002)(8936002)(9686003)(83380400001)(52536014)(5660300002)(86362001)(55016002)(83080400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FrCATF5wCNkXQLbeImFFUd/lZNSdu9e3pGOND4bPRtVDvLQ0QFHIRvzt6aTn5K8M6TMOSOwlpgYsUDEnuNt55rAfj1VS4moouPZcW+myF23Zr0Myf3KAUjchUAD12aN3+mx6fe5cWGef4CpSG7f6QSv9RYyqAp37suPof6JuGKsxAGFwqAK7dcaJ31Jk/T2ltHsYPAHJszF9Z69wP4QUG0R57zDqpHF8X0YrhQoqX1ZoqpzhHw4gl8On0Ca5Snh7/fU144Pniotf4INavysPbWUl6UFp+6OpzyCz593XhcBvcUbPwP2eegvoOBy4HJu4JF2nur4aeLO8OjS3HDNtIbjb03firgNYnqkCgxnWQeG6tgDYqgohDQqvoxb3JqKvGC3/V0+blrIsENmxXvfQ5jHY+WeNPNkcKwTqQTkidwSpOrLzR3SbteTmy9PDJOmRKfI7p/0E66Jgpsf8k3Ngv+AYslkuol1SHI1Gzz5g8Mu9sGcTNcxNB1TyXi0AJj74
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c312f362-45ec-4223-a30b-08d82a2f3efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 08:56:08.0029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFm81/TTrqcYqEsThHMW5U2Vi4Mmxq7ff6QF5bYQlxJo/RdrjMnb4i9BAVtf7XhugYb5E366OLq7XuvQGHpypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0648
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTdmVuIEF1aGFnZW4gPHN2ZW4u
YXVoYWdlbkB2b2xlYXRlY2guZGU+DQo+IFNlbnQ6IEZyaWRheSwgSnVseSAxNywgMjAyMCA5OjU0
IEFNDQo+IFRvOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IENj
OiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1idXMuY29tPjsgbGludXgtY3J5
cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvMV0gaW5zaWRlLXNl
Y3VyZSBpcnEgYmFsYW5jZQ0KPg0KPiA8PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+IE9uIEZyaSwg
SnVsIDE3LCAyMDIwIGF0IDA0OjU3OjM4UE0gKzEwMDAsIEhlcmJlcnQgWHUgd3JvdGU6DQo+ID4g
T24gRnJpLCBKdWwgMTcsIDIwMjAgYXQgMDg6MzU6MDRBTSArMDIwMCwgU3ZlbiBBdWhhZ2VuIHdy
b3RlOg0KPiA+ID4NCj4gPiA+IEkgZGlzYWdyZWUgYXMgdGhpcyBpcyBjb21tb24gcHJhY3RpY2Ug
YW1vbmcgb3RoZXIga2VybmVsIGRyaXZlcnMNCj4gPiA+IGxpa2UgZXRoZXJuZXQuDQo+ID4gPiBB
bHNvIHRoaXMgaXMgYWxzbyBiZWVpbmcgZG9uZSBpbiBvdGhlciBjcnlwdG8gZHJpdmVycyBub3Qg
dG8gc2F5DQo+ID4gPiB0aGF0IHRoZSBzcGVlZCBpbXByb3ZlbWVudHMgYXJlIHByZXR0eSBzaWdu
aWZpY2FudC4NCj4gPiA+DQo+ID4gPiBpcnFiYWxhbmNlIGNhbiBvZiBjb3Vyc2UgYWxzbyBkbyB0
aGUgam9iIGJ1dCB0aGVyZSBpcyBubyBkb3duc2lkZQ0KPiA+ID4gb2YgYWRkaW5nIHRoZSBpcnEg
aGludCBpbiB0aGUgZHJpdmVyLg0KPiA+DQo+ID4gSWYgeW91J3JlIGdvaW5nIHRvIGRvIHRoaXMg
cGxlYXNlIGF0IGxlYXN0IHVzZSB0aGUgZnVuY3Rpb24NCj4gPiBjcHVtYXNrX2xvY2FsX3NwcmVh
ZC4NCj4NCj4gSSBkbyBub3QgaGF2ZSBhY2Nlc3MgdG8gYSBudW1hIG5vZGUgaW5zaWRlIHRoZSBp
bnNpZGUgc2VjdXJlDQo+IGRyaXZlciBhbmQgY2FuIG9ubHkgdXNlIC0xIGFzIHRoZSBjcHVtYXNr
X2xvY2FsX3NwcmVhZCBudW1hIG5vZGUuDQo+IElzIHRoYXQgd2hhdCB5b3UgYXJlIGxvb2tpbmcg
Zm9yPw0KPg0KTm93IEkgYW0gbm8gZXhwZXJ0IG9uIGFsbCB0aGlzIGtlcm5lbCBJUlEgYmFsYW5j
aW5nIHN0dWZmLCBzbyBJJ20gbm90IGdvaW5nIHRvDQpjb21tZW50IG9uIGhvdyB0byBkbyBpdCBv
ciB3aGF0IGlzIGFwcHJvcHJpYXRlLg0KDQpCdXQgSSBkbyB3YW50IHRvIGVtcGhhc2l6ZSB0aGF0
IHRoaXMgcGF0Y2ggaXMgaW4gbGluZSB3aXRoIGhvdyB0aGUgaGFyZHdhcmUNCndhcyBpbnRlbmRl
ZCB0byBiZSB1c2VkIGkuZS4gaGF2ZSBlYWNoIHJpbmcgaGFuZGxlZCBieSBhIGRlZGljYXRlZCBD
UFUuDQoNCkFsc28sIHlvdSBoYXZlIHRvIGtlZXAgaW4gbWluZCB0aGF0IHRoaXMgZHJpdmVyIGRv
ZXMgbm90IGhhdmUgdG8gcnVuIG9uDQpldmVyeSBwb3NzaWJsZSBzeXN0ZW0gb3V0IHRoZXJlLCBp
dCBPTkxZIG5lZWRzIHRvIHJ1biBvbiB0aG9zZSBwYXJ0aWN1bGFyDQpTT0MncyB0aGF0IGFjdHVh
bGx5IGVtYmVkIHRoaXMgaGFyZHdhcmUgSVAuIEFuZCBJIGtub3cgZXhhY3RseSB3aGljaCBvbmVz
LA0Kc2luY2UgaXQgYWxsIGhhcyB0byBnbyB0aHJvdWdoIG1lIGZpcnN0IDotKSBJdCBvbmx5IGV2
ZXIgcnVucyBvbiBlbWJlZGRlZA0KQ1BVIGNsdXN0ZXJzIChBUk0sIE1JUFMsIEF0b20gYW5kIEMt
U2t5KSwgbm8gbmVlZCB0byB3b3JyeSBhYm91dCBOVU1BDQpub2Rlcy4NCg0KPiBCZXN0DQo+IFN2
ZW4NCj4NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiAtLQ0KPiA+IEVtYWlsOiBIZXJiZXJ0IFh1IDxo
ZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+ID4gSG9tZSBQYWdlOg0KPiBodHRwczovL2V1
cjAzLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cDolMkYlMkZnb25k
b3IuYXBhbmEub3JnLmF1JTJGfmhlcmJlcnQlMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q3N2ZQ0KPiBu
LmF1aGFnZW4lNDB2b2xlYXRlY2guZGUlN0MxMWVjODY0NTg4ZWE0M2NiMmI1NTA4ZDgyYTFlYjQy
NCU3Q2I4MmE5OWY2Nzk4MTRhNzI5NTM0NGQzNTI5OGY4NDdiJTdDMCU3QzElN0M2MzczMDU2DQo+
IDU4NjY2MTQ1Njc1JmFtcDtzZGF0YT1VMFRSS3Exa2VleTJqb2daeWVsTHd2d2ZTcGo0U2F2SkFo
dW1NNjNwaHMwJTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gUEdQIEtleToNCj4gaHR0cHM6Ly9ldXIw
My5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHA6JTJGJTJGZ29uZG9y
LmFwYW5hLm9yZy5hdSUyRn5oZXJiZXJ0JTJGcHVia2V5LnR4dCZhbXA7ZGF0YT0wMiU3DQo+IEMw
MSU3Q3N2ZW4uYXVoYWdlbiU0MHZvbGVhdGVjaC5kZSU3QzExZWM4NjQ1ODhlYTQzY2IyYjU1MDhk
ODJhMWViNDI0JTdDYjgyYTk5ZjY3OTgxNGE3Mjk1MzQ0ZDM1Mjk4Zjg0N2IlN0MwJTdDMQ0KPiAl
N0M2MzczMDU2NTg2NjYxNTU2NzAmYW1wO3NkYXRhPUZEU2tySzN0OU9NVGFBJTJGUnhNY2dLZ3FV
NHdWQnglMkJvbVNBJTJCVWxadE5nQlUlM0QmYW1wO3Jlc2VydmVkPTANCg0KDQpSZWdhcmRzLA0K
UGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBF
bmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2
NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0
ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0
byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRy
ZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhl
IHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBjb250YWluIGlu
Zm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJl
IG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9o
aWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQ
bGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBz
ZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNv
bT4NCg==

