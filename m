Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD12C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE10E208CA
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="eApgvg9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfE0KE7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 06:04:59 -0400
Received: from mail-eopbgr130102.outbound.protection.outlook.com ([40.107.13.102]:1921
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfE0KE7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 06:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ox/rkZT/tJ3Lp8kq5r4+v7xwkST+s6WFD3+fKTRu4O4=;
 b=eApgvg9mm9xZtWiXNhRcYXPBJBG41AH5RQVlHKr6Y+KbN6NAnBeM+C1/nm0XqKprp5u0OLV0ZsTlRG5iaPM1jMuVKawhzeTS4wPOI02AbL6WT48mehDGPg58UkPQC13R7mTTawUy8n+WV5LhcCTNMq6mQgcLdmAOHBeS/Nq2gYI=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3271.eurprd09.prod.outlook.com (20.179.244.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Mon, 27 May 2019 10:04:51 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 10:04:51 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFCAAAQtAIAAAZkA
Date:   Mon, 27 May 2019 10:04:51 +0000
Message-ID: <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
 <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
In-Reply-To: <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2416e68-dbda-45dd-326c-08d6e28ac25e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3271;
x-ms-traffictypediagnostic: AM6PR09MB3271:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3271DCB16BAD0FB06E160DA7D21D0@AM6PR09MB3271.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(39840400004)(366004)(199004)(189003)(66556008)(66476007)(73956011)(64756008)(305945005)(66446008)(486006)(6246003)(53936002)(4326008)(15974865002)(9686003)(476003)(99286004)(11346002)(229853002)(7696005)(446003)(6116002)(3846002)(33656002)(76176011)(66946007)(55016002)(7736002)(6436002)(74316002)(186003)(5660300002)(76116006)(8936002)(66066001)(7116003)(6916009)(26005)(71190400001)(71200400001)(478600001)(316002)(54906003)(52536014)(14454004)(81156014)(6506007)(2906002)(3480700005)(25786009)(256004)(86362001)(14444005)(81166006)(102836004)(68736007)(8676002)(21314003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3271;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dkI0kHfTQ1iZ7Uqe/t3j4gNB14zccQHqFM1VzcyxvWfZ15nTz/hXZ2ihFzKkvYawGqwHLHLE7J3pxYulbm6NrBdCQQxgiw9aVcC6cnioVFIXqhvJT8PxUmWWig+ZaM84uSbt7P2wQdD5i/OV8+XbkdHAg8maTg6n3+Vlf2YXCXq3RxtSZYBM2DCer1GblaV88hfUNxFeQgSIhfZ/1bCCIZa9H0RgqGA5VcNbkF8loa4jYMuLsN8+lh/8wsy2kix4yp06D/PEeGfOX8tAQrGuyXQhvyzByLOucH8Iw9KEX+lj5hFnHuWduYCgwOFgdto2LXXLAc243jbvNhhq8a/aIXUEoYyieYLXBL1njvhJ/5D8ZpALycRwqL1Ta7rY7o2mr1QgL4tSnGeZkmW1J0LtEIzerFy0XImZmrYTsRT7p/4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2416e68-dbda-45dd-326c-08d6e28ac25e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 10:04:51.1992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3271
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IFdpdGggYWxsIGR1ZSByZXNwZWN0LCBidXQgeW91IGFyZSBtYWtpbmcgYXNzdW1wdGlvbnMg
YXMgd2VsbC4gWW91IGFyZQ0KPiA+IG1ha2luZyB0aGUgYXNzdW1wdGlvbiB0aGF0IHJlZHVjaW5n
IENQVSBsb2FkIGFuZC9vciByZWR1Y2luZyBwb3dlcg0KPiA+IGNvbnN1bXB0aW9uIGlzICptb3Jl
KiBpbXBvcnRhbnQgdGhhbiBhYnNvbHV0ZSBhcHBsaWNhdGlvbiBwZXJmb3JtYW5jZSBvcg0KPiA+
IGxhdGVuY3kuIFdoaWNoIGlzIGNlcnRhaW5seSBub3QgYWx3YXlzIHRoZSBjYXNlLg0KPiA+DQo+
DQo+IEkgbmV2ZXIgc2FpZCBwb3dlciBjb25zdW1wdGlvbiBpcyAqYWx3YXlzKiBtb3JlIGltcG9y
dGFudC4gWW91IHdlcmUNCj4gYXNzdW1pbmcgaXQgbmV2ZXIgaXMuDQo+DQpOb29vb28gSSB3YXNu
J3QuIE5vdCBvbiBwdXJwb3NlLCBhbnl3YXkuIFBvd2VyIGNvbnN1bXB0aW9uIGlzIGEgbWFqb3Ig
c2VsbGluZw0KcG9pbnQgZm9yIHVzLiBJZiB5b3UgZ290IHRoYXQgaW1wcmVzc2lvbiwgdGhlbiB0
aGF0J3Mgc29tZSBtaXN1bmRlcnN0YW5kaW5nLg0KTXkgYXJndW1lbnQgd2FzIHNpbXBseSB0aGF0
IHRoZXJlICptYXkqIGJlIG90aGVyIHJlcXVpcmVtZW50cy4gWW91IGRvbid0IGtub3csDQpzbyB5
b3Ugc2hvdWxkbid0IG1ha2UgYXNzdW1wdGlvbnMgaW4gdGhlIG90aGVyIGRpcmVjdGlvbiBlaXRo
ZXIuDQoNCj4gPiBJbiBtYW55IGNhc2VzIHdoZXJlIG9ubHkgc21hbGwgYW1vdW50cyBvZiBkYXRh
IGFyZSBwcm9jZXNzZWQgc2VxdWVudGlhbGx5LA0KPiA+IHRoZSBoYXJkd2FyZSB3aWxsIHNpbXBs
eSBsb3NlIG9uIGFsbCBhY2NvdW50cyAuLi4gU28gTGludXMgYWN0dWFsbHkgZGlkDQo+ID4gaGF2
ZSBhIHBvaW50IHRoZXJlLiBIYXJkd2FyZSBvbmx5IHdpbnMgZm9yIHNwZWNpZmljIHVzZSBjYXNl
cy4gSXQncw0KPiA+IGltcG9ydGFudCB0byByZWFsaXplIHRoYXQgYW5kIG5vdCB0cnkgYW5kIHVz
ZSBoYXJkd2FyZSBmb3IgZXZlcnl0aGluZy4NCj4gPg0KPg0KPiBUcnVlLiBCdXQgd2UgaGF2ZSBh
bHJlYWR5IHBhaW50ZWQgb3Vyc2VsdmVzIGludG8gYSBjb3JuZXIgaGVyZSwgc2luY2UNCj4gd2hh
dGV2ZXIgd2UgZXhwb3NlIHRvIHVzZXJsYW5kIHRvZGF5IGNhbm5vdCBzaW1wbHkgYmUgcmV2b2tl
ZC4NCj4NCj4gSSBndWVzcyB5b3UgY291bGQgYXJndWUgdGhhdCB5b3VyIHBhcnRpY3VsYXIgZHJp
dmVyIHNob3VsZCBub3QgYmUNCj4gZXhwb3NlZCB0byB1c2VybGFuZCwgYW5kIEkgdGhpbmsgd2Ug
bWF5IGV2ZW4gaGF2ZSBhIENSWVBUT19BTEdfeHh4DQo+DQpXZWxsLCBJIHVuZGVyc3Rvb2QgZnJv
bSBzb21lb25lIGVsc2Ugb24gdGhpcyBsaXN0IHRoYXQgQ1JZUFRPX0FMRyBjYW4NCmRvIGFzeW5j
IG9wZXJhdGlvbnMgaW4gd2hpY2ggY2FzZSBJIHdvdWxkIGFzc3VtZSBpdCBkb2Vzbid0IGJsb2Nr
Pz8NCg0KSSB3b3VsZCByYXRoZXIgc2VlIGEgZmxhZyBkZW5vdGluZyAiZG8gbm90IHVzZSBtZSBp
biBhIHN5bmNocm9ub3VzDQpmYXNoaW9uIG9uIHJlbGF0aXZlbHkgc21hbGwgZGF0YWJsb2Nrcywg
b25seSB1c2UgbWUgaWYgeW91IGludGVuZCB0bw0Kc2VyaW91c2x5IHBpcGVsaW5lIHlvdXIgcmVx
dWVzdHMiLiBPciBzb21lc3VjaC4NCg0KQnV0IHRoZW4gYWdhaW4gdGhhdCB3b3VsZCBzdGlsbCBi
ZSB0b28gc2ltcGxpc3RpYyB0byBzZWxlY3QgdG8gYmVzdA0KZHJpdmVyIHVuZGVyIGFsbCBwb3Nz
aWJsZSBjaXJjdW1zdGFuY2VzIC4uLiBzbyB3aHkgZXZlbiBib3RoZXIuDQoNCj4gZmxhZyBmb3Ig
dGhhdC4gQnV0IGV2ZW4gaWYgdGhhdCBkb2VzIGhhcHBlbiwgaXQgZG9lc24ndCBtZWFuIHlvdSBj
YW4NCj4gc3RvcCBjYXJpbmcgYWJvdXQgemVybyBsZW5ndGggaW5wdXRzIDotKQ0KPg0KSWYgdGhl
IHNlbGVjdGlvbiBvZiB0aGUgaGFyZHdhcmUgZHJpdmVyIGJlY29tZXMgZXhwbGljaXQgYW5kIG5v
dA0KYXV0b21hdGljLCB5b3UgY291bGQgYXJndWUgZm9yIGEgY2FzZSB3aGVyZSB0aGUgZHJpdmVy
IGRvZXMgTk9UIGhhdmUNCnRvIGltcGxlbWVudCBhbGwgZGFyayBjb3JuZXJzIG9mIHRoZSBBUEku
IEFzLCBhcyBhIGhhcmR3YXJlIHZlbmRvciwNCndlIGNvdWxkIHNpbXBseSByZWNvbW1lbmQgTk9U
IHRvIHVzZSBpdCBmb3IgYXBwbGljYXRpb24gWFlaICBiZWNhdXNlDQppdCBkb2VzIHRoaW5ncyAt
IGxpa2UgemVybyBsZW5ndGggbWVzc2FnZXMgLSB3ZSBkb24ndCBzdXBwb3J0Lg0KDQpSZWdhcmRz
LA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9j
b2wgRW5naW5lcyBAIEluc2lkZSBTZWN1cmUNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
