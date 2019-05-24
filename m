Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060A5C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC9521773
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="ET7VXLdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389942AbfEXJ5M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:57:12 -0400
Received: from mail-eopbgr80132.outbound.protection.outlook.com ([40.107.8.132]:51866
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389782AbfEXJ5M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOQtsA6ILMtHT17rPRsDPrSpFTX27/BUu7d6id3cb4w=;
 b=ET7VXLdCepzjNDcVMSt6oNA/RwiBDcKiip+r2apWBGY3rgHLe2F6NZBA8iE3hTGyPVCEsGqTy6i1spPcR9wLocQltdMuvLsVNMicvVP2vXAslxGbjN/KXnib9b0Wmc6CBKxvfW5d2DZ1v4P+dygz1bk6bKzRbTDLYrKtadka/2A=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2581.eurprd09.prod.outlook.com (20.177.112.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Fri, 24 May 2019 09:57:08 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 09:57:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAAAYtA=
Date:   Fri, 24 May 2019 09:57:07 +0000
Message-ID: <AM6PR09MB35232C98F70FCB4A37AE7148D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
In-Reply-To: <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e828bf1-a9b0-4b38-bd9b-08d6e02e2f02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2581;
x-ms-traffictypediagnostic: AM6PR09MB2581:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2581CA2E202E561E58C26F81D2020@AM6PR09MB2581.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(366004)(396003)(39850400004)(199004)(189003)(76116006)(66946007)(99286004)(4326008)(73956011)(102836004)(6116002)(3846002)(7736002)(25786009)(3480700005)(66066001)(15974865002)(7696005)(76176011)(53936002)(9686003)(14454004)(476003)(5660300002)(486006)(68736007)(55016002)(86362001)(6506007)(7116003)(446003)(229853002)(6436002)(26005)(11346002)(186003)(66476007)(54906003)(8676002)(71200400001)(81166006)(71190400001)(81156014)(316002)(52536014)(74316002)(2906002)(256004)(66556008)(64756008)(66446008)(305945005)(6916009)(8936002)(478600001)(33656002)(6246003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2581;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DJRTF8GmQcGt3Sz6N+q0pk7kvBzXxCcFZX8ZgNqJqnk8KwNgMU2dEKNBGMyzjbgoHqVnWWw1xItmoK881nkulbmnZ5tk3uFezarF3a3sBBFTBkW3J/qOAxZUIwwpGzgT21Xlr8f6XPnlBIx1Hkuk/9r3A5KVE/4Jnh3bZEie5apFGBbMBiiAHvBINlpPpCcilvjXHtaLCUOTnBNeJl0RJShyWkHq7d6N5cvkngi6Uw6O5LGW/ysHxVm0DVb4O9YZUFyRAVmVFDS8FngfH2XQkF2jQvqkh3OpYr2/WZYQ3YD0VUkc8kBXqVV9zT/KFdLNZgjJiXzVPKIIkP7ZpK2nOdpR3JVAOFPsboBY2uPVeA/vSUwf720XRxEJ8itAYdZmwJ8i2C+akf39oN0pVjkkXUJ0gTpahEEukkkIPzY3QBM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e828bf1-a9b0-4b38-bd9b-08d6e02e2f02
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:57:07.9730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2581
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBBZ2FpbiwgeW91IGFyZSBtYWtpbmcgYXNzdW1wdGlvbnMgaGVyZSB0aGF0IGRvbid0IGFsd2F5
cyBob2xkLiBOb3RlIHRoYXQNCj4gLSBhIGZyb3plbiBwcm9jZXNzIGZyZWVzIHVwIHRoZSBDUFUg
dG8gZG8gb3RoZXIgdGhpbmdzIHdoaWxlIHRoZQ0KPiBjcnlwdG8gaXMgaW4gcHJvZ3Jlc3M7DQo+
IC0gaC93IGNyeXB0byBpcyB0eXBpY2FsbHkgbW9yZSBwb3dlciBlZmZpY2llbnQgdGhhbiBDUFUg
Y3J5cHRvOw0KPg0KVHJ1ZS4gVGhvc2UgYXJlIHRoZSAib3RoZXIiIHJlYXNvbnMgLSBiZXNpZGVz
IGFjY2VsZXJhdGlvbiAtIHRvIHVzZSBoYXJkd2FyZQ0Kb2ZmbG9hZCB3aGljaCB3ZSBvZnRlbiB1
c2UgdG8gc2VsbCBvdXIgSVAuDQpCdXQgdGhlIGhvbmVzdCBzdG9yeSB0aGVyZSBpcyB0aGF0IHRo
YXQgb25seSB3b3JrcyBvdXQgZm9yIHNpdHVhdGlvbnMNCndoZXJlIHRoZXJlJ3MgZW5vdWdoIHdv
cmsgdG8gZG8gdG8gbWFrZSB0aGUgc29mdHdhcmUgb3ZlcmhlYWQgZm9yIGFjdHVhbGx5DQpzdGFy
dGluZyBhbmQgbWFuYWdpbmcgdGhhdCB3b3JrIGluc2lnbmlmaWNhbnQuDQoNCkFuZCBldmVuIHRo
ZW4sIGl0J3Mgb25seSBhIHZhbGlkIHVzZSBjYXNlIGlmIHRoYXQgaXMgeW91ciAqaW50ZW50aW9u
Ki4NCklmIHlvdSAqanVzdCogbmVlZGVkIHRoZSBoaWdoZXN0IHBlcmZvcm1hbmNlLCB5b3UgZG9u
J3Qgd2FudCB0byBnbyB0aHJvdWdoDQp0aGUgSFcgaW4gdGhpcyBjYXNlICh1bmxlc3MgeW91IGhh
dmUgYSAqdmVyeSogd2VhayBDUFUgcGVyaGFwcywgb3IgYQ0KaHVnZSBhbW91bnQgb2YgZGF0YSB0
byBwcm9jZXNzIGluIG9uZSBnbykuDQoNClRoZSBjYXRjaCBpcyBpbiB0aGUgImFsd2F5cyIuIEJ1
dCBob3cgZG8geW91IG1ha2UgYW4gaW5mb3JtZWQgZGVjaXNpb24NCmhlcmU/IFRoZSBjdXJyZW50
IENyeXB0byBBUEkgZG9lcyBub3QgcmVhbGx5IHNlZW0gdG8gcHJvdmlkZSBhIG1lY2hhbmlzbQ0K
Zm9yIGRvaW5nIHNvLiBJbiB3aGljaCBjYXNlIE1ZIGFwcHJvYWNoIHdvdWxkIGJlICJpZiBJJ20g
bm90IFNVUkUgdGhhdA0KdGhlIEhXIGNhbiBkbyBpdCBiZXR0ZXIsIHRoZW4gSSBwcm9iYWJseSBz
aG91bGRuJ3QgYmUgZG9pbmcgaW4gb24gdGhlIEhXIi4NCg0KPiAtIHNldmVyYWwgdXNlcmxhbmQg
cHJvZ3JhbXMgYW5kIGluLWtlcm5lbCB1c2VycyBtYXkgYmUgYWN0aXZlIGF0IHRoZQ0KPiBzYW1l
IHRpbWUsIHNvIHRoZSBmYWN0IHRoYXQgYSBzaW5nbGUgdXNlciBzbGVlcHMgZG9lc24ndCBtZWFu
IHRoZQ0KPiBoYXJkd2FyZSBpcyB1c2VkIGluZWZmaWNpZW50bHkNCj4NCkknbSBub3Qgd29ycmll
ZCBhYm91dCB0aGUgKkhXKiBiZWluZyB1c2VkIGluZWZmaWNpZW50bHkuDQpJJ20gd29ycmllZCBh
Ym91dCB1c2luZyB0aGUgSFcgbm90IGJlaW5nIGFuIGltcHJvdmVtZW50Lg0KDQpSZWdhcmRzLA0K
UGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wg
RW5naW5lcyBAIEluc2lkZSBTZWN1cmUNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg==
