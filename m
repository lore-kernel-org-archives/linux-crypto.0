Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AA2C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA14D206A5
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="efCcDP8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbgJBOfQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:35:16 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:38749 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388248AbgJBOe4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1601649294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRitCyawNjmPFy3ucLzZz9iTGeUnjOWcj9HbHluvaB0=;
        b=efCcDP8es8VBNjnlzuKxj3Bwx4eCVHdzuqElRC66qAF8IAezutdA7j+Y90Aktfy/AApoLk
        lPpiZ+GlRSAmKa7kGcXmFRJniHl37McVQeXU8ZOCLC7wIK/x6KrztzjfzEvqSWhQnj2R5x
        bvXUFUhhcj+gRM72wB0quo+wgQ9m2mA=
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-O1bi5yyHNZOcBrYMCkp49A-1; Fri, 02 Oct 2020 10:34:51 -0400
X-MC-Unique: O1bi5yyHNZOcBrYMCkp49A-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB3718.namprd04.prod.outlook.com
 (2603:10b6:903:e8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Fri, 2 Oct
 2020 14:34:44 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 14:34:44 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?utf-8?B?U3RlcGhhbiBNw7xsbGVy?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: RE: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Thread-Topic: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Thread-Index: AQHWj+30K9pLzYDH0UOZg+dE4DU5IKmEUggAgAAOGOCAAAnmAIAABuCg
Date:   Fri, 2 Oct 2020 14:34:44 +0000
Message-ID: <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002140428.GC3475053@kroah.com>
In-Reply-To: <20201002140428.GC3475053@kroah.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ffaa2e1-2354-4bb1-8094-08d866e04e2f
x-ms-traffictypediagnostic: CY4PR04MB3718:
x-microsoft-antispam-prvs: <CY4PR04MB3718CCE9A2DC5B3E7BEA0C50C3310@CY4PR04MB3718.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uUHgQ8Ap9VnaBglit0CHG1YLVOsP1U/2HtbnVQXpfuSgMfoWxoeid9hCTimgl85/xHsDt+S0fPqbSfAiyp3YeIayAV6d/YIqjSIb6XWjIW+VMJdVyGUZdJbo62f0YFE0TAbzvbqjBzqO4JmVAM9/nLZq2oySME5zbN+oV2HLW7HWnc6WPEZRG1x3SOPP7LkfiLVkujlK74fk3YgJLYMSkrllDtRhLLP9Ur9kTNIVyRXJEkzPTpEwIMjOC4ojrYhxvcxqQq8r8lEWN/+S6M1rMHYQ5phmv7woaIr7JCWsUrTe1lYs/55P1tYcs1piMfmt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(136003)(366004)(346002)(8936002)(66476007)(7696005)(8676002)(66556008)(64756008)(66446008)(66574015)(5660300002)(54906003)(9686003)(55016002)(478600001)(7406005)(186003)(6916009)(4326008)(26005)(33656002)(52536014)(86362001)(2906002)(7416002)(76116006)(53546011)(71200400001)(6506007)(83380400001)(66946007)(316002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: ZL1eWV40djGS3UIyTLY2aDqvplmF7ov/uqrSAjdS952fpN8N/tDPO4e++GvUpGmMfJhXmLwjq4KdV3jaXJzmJ63VMc6Gfb1fbKKA8Wq9+Qn+L1SWQQtOTMo5fzTNi+/sX6Bk3MS0Vij6Uq0aaQjv61fe+mdodBK7q3h4yZflA5KYQtHUl1srgSkTAs2btqItJtyk5pbdxK6LFYriHmAUXiqvU4xRc+Q48uLuTaa6E5YF/efE8A3wnBhBbTTCBDGtFCt60IAD/kTXfrPWL6AyWryYA3rZ7LwD4FvFecY5ic0cVqKPeU/E2IpP9TPgH/HoKIZSuHOm+tz8Uy96TaxMigObx/b8fY4jyqEfUsx5+xdh16QowNUI6YvYkeZ0MEBsmMvXs0/8dMleF7Kx8NwD1JyTsnu9DEiA2RoPVqcOYUUMeFMbsveG8YzTZVJ2yfAukRZzW5S0obMI85jtQPOqE6hlQqhg1AySb/ob2PJNaY4/SgRY3RCO1KfqUSqH1Oehuz/fgCzyWzMTqO2DVIy+M8G2ApQEUgYzBV2LAOoRWh1hIe/ZllOoayISjwyANY4LYBvVm4tlglkntFeJsgwnuDS4PGqV0WQoLTZN1Yc5KVdDgnSYCesfCAa5TexsPNoudBYP/eurQVXakmATg6aBxw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffaa2e1-2354-4bb1-8094-08d866e04e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 14:34:44.1309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifnfStmr7FXfXZrdzCyC3DAKTKDOTdLLMC98AGCZL7yTd3YnehmkURiTkOYB42fEVuQf2gCHSCQNuiTydxFUCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB3718
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

DQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBGcmlkYXksIE9jdG9i
ZXIgMiwgMjAyMCA0OjA0IFBNDQo+IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdl
bkByYW1idXMuY29tPg0KPiBDYzogVG9yc3RlbiBEdXdlIDxkdXdlQGxzdC5kZT47IFRoZW9kb3Jl
IFkuIFRzJ28gPHR5dHNvQG1pdC5lZHU+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBO
aWNvbGFpIFN0YW5nZQ0KPiA8bnN0YW5nZUBzdXNlLmRlPjsgTEtNTCA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBFcmljIFcuIEJp
ZWRlcm1hbg0KPiA8ZWJpZWRlcm1AeG1pc3Npb24uY29tPjsgQWxleGFuZGVyIEUuIFBhdHJha292
IDxwYXRyYWtvdkBnbWFpbC5jb20+OyBBaG1lZCBTLiBEYXJ3aXNoIDxkYXJ3aXNoLjA3QGdtYWls
LmNvbT47IFdpbGx5DQo+IFRhcnJlYXUgPHdAMXd0LmV1PjsgTWF0dGhldyBHYXJyZXR0IDxtamc1
OUBzcmNmLnVjYW0ub3JnPjsgVml0byBDYXB1dG8gPHZjYXB1dG9AcGVuZ2FydS5jb20+OyBBbmRy
ZWFzIERpbGdlcg0KPiA8YWRpbGdlci5rZXJuZWxAZGlsZ2VyLmNhPjsgSmFuIEthcmEgPGphY2tA
c3VzZS5jej47IFJheSBTdHJvZGUgPHJzdHJvZGVAcmVkaGF0LmNvbT47IFdpbGxpYW0gSm9uIE1j
Q2FubiA8bWNjYW5uQGpodS5lZHU+Ow0KPiB6aGFuZ2pzIDx6YWNoYXJ5QGJhaXNoYW5jbG91ZC5j
b20+OyBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz47IEZsb3JpYW4gV2VpbWVyIDxm
d2VpbWVyQHJlZGhhdC5jb20+OyBMZW5uYXJ0DQo+IFBvZXR0ZXJpbmcgPG16eHJlYXJ5QDBwb2lu
dGVyLmRlPjsgUGV0ZXIgTWF0dGhpYXMgPG1hdHRoaWFzLnBldGVyQGJzaS5idW5kLmRlPjsgTWFy
Y2VsbyBIZW5yaXF1ZSBDZXJyaQ0KPiA8bWFyY2Vsby5jZXJyaUBjYW5vbmljYWwuY29tPjsgTmVp
bCBIb3JtYW4gPG5ob3JtYW5AcmVkaGF0LmNvbT47IFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZy
YWRlYWQub3JnPjsgSnVsaWEgTGF3YWxsDQo+IDxqdWxpYS5sYXdhbGxAaW5yaWEuZnI+OyBEYW4g
Q2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+OyBBbmR5IExhdnIgPGFuZHkubGF2
ckBnbWFpbC5jb20+OyBFcmljIEJpZ2dlcnMNCj4gPGViaWdnZXJzQGtlcm5lbC5vcmc+OyBKYXNv
biBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT47IFN0ZXBoYW4gTcO8bGxlciA8c211ZWxs
ZXJAY2hyb25veC5kZT47IFBldHIgVGVzYXJpaw0KPiA8cHRlc2FyaWtAc3VzZS5jej4NCj4gU3Vi
amVjdDogUmU6IFtESVNDVVNTSU9OIFBBVENIIDAwLzQxXSByYW5kb206IHBvc3NpYmxlIHdheXMg
dG93YXJkcyBOSVNUIFNQODAwLTkwQiBjb21wbGlhbmNlDQo+DQo+IDw8PCBFeHRlcm5hbCBFbWFp
bCA+Pj4NCj4gT24gRnJpLCBPY3QgMDIsIDIwMjAgYXQgMDE6MzU6MThQTSArMDAwMCwgVmFuIExl
ZXV3ZW4sIFBhc2NhbCB3cm90ZToNCj4gPiAqKiBUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2ht
ZW50cyBhcmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJ
dCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzDQo+IGNvbmZpZGVudGlhbCBhbmQgcHJp
dmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBvZiB0aGlzIG1l
c3NhZ2UsIHlvdSBhcmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5nLA0KPiBmb3J3
YXJkaW5nIG9yIHNhdmluZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0YWNo
bWVudHMgYW5kIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KPg0KPiBBcyBwZXIg
bXkgbGVnYWwgZGVwYXJ0bWVudCByZXF1ZXN0cywgdGhpcyBpcyBub3cgaWdub3JlZCBhbmQgZGVs
ZXRlZCBvbg0KPiBteSBzeXN0ZW0uLi4NCj4NCj4gSGludCwgaXQncyBub3QgYSB2YWxpZCBmb290
ZXIgZm9yIHB1YmxpYyBtYWlsaW5nIGxpc3RzLi4uDQo+DQo+IGdyZWcgay1oDQpJdCdzIGF1dG9t
YXRpY2FsbHkgYWRkZWQgYnkgb3VyIGNvbXBhbnkgbWFpbCBzZXJ2ZXIgLi4uIG5vdCBzb21ldGhp
bmcgSSBjYW4gY29udHJvbCBhdCBhbGwgOi0oDQpBbmQgdXNpbmcgc29tZSBleHRlcm5hbCBTTVRQ
IHNlcnZlciB3b3VsZCBub3QgcGFzcyBvdXIgZmlyZXdhbGwuDQpTbyBmcmVlIHdlYm1haWwgd291
bGQgYmUgbXkgb25seSBhbHRlcm5hdGl2ZSwgYnV0IEkgaGF2ZSBhIHRob3JvdWdoIGRpc2xpa2Ug
Zm9yIHdlYi1iYXNlZA0KdG9vbHMsIGFzIEkgaGF2ZSB5ZXQgdG8gY29tZSBhY3Jvc3Mgb25lIHdp
dGggYW4gZXZlbiByZW1vdGVseSBhY2NlcHRhYmxlIHVzZXIgaW50ZXJmYWNlLg0KDQpSZWdhcmRz
LA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2Nv
bCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03
MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJ
UCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2lu
ZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBh
ZGRyZXNzLg0KDQoqKiBUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgZm9yIHRo
ZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkgY29udGFpbiBp
bmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZpZGVudGlhbCBhbmQgcHJpdmlsZWdlZC4gSWYgeW91IGFy
ZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBvZiB0aGlzIG1lc3NhZ2UsIHlvdSBhcmUgcHJv
aGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5nLCBmb3J3YXJkaW5nIG9yIHNhdmluZyBpdC4g
UGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0YWNobWVudHMgYW5kIG5vdGlmeSB0aGUg
c2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KDQpSYW1idXMgSW5jLjxodHRwOi8vd3d3LnJhbWJ1cy5j
b20+DQo=

