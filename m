Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A28C35257
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 19:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F3120795
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 19:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="H87PLcsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgJBTJu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 15:09:50 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:51975 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgJBTJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 15:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1601665787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8YFpeXnyOt+tQPUjwHKwhr2HXhVHx9dlzVU/KhyoYc=;
        b=H87PLcszBLnBBDyuq03Y7Dn/8P6btVKkID3JHFbI4exGpTDJNn64t7j3je1c7jf0GLpzuo
        57UdDqeYQVniywAAhxzRrCrctPIAkh19st2Ikdo/iyIhdO3kI8guDT60Lssk2NfigQ6c+7
        AiqGKAgRgAXX87WhDUjpl4uiogT2BWc=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-6LBYHVL_M7G9qMd_2HVrTg-1; Fri, 02 Oct 2020 15:09:43 -0400
X-MC-Unique: 6LBYHVL_M7G9qMd_2HVrTg-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3617.namprd04.prod.outlook.com
 (2603:10b6:910:8e::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 19:09:37 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 19:09:37 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Torsten Duwe <duwe@lst.de>,
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
Thread-Index: AQHWj+30K9pLzYDH0UOZg+dE4DU5IKmEUggAgAAOGOCAAAnmAIAABuCggAAMRgCAAAGwIIAAMPcAgAAL91A=
Date:   Fri, 2 Oct 2020 19:09:36 +0000
Message-ID: <CY4PR0401MB3652433F8E515A22188C2ADFC3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002140428.GC3475053@kroah.com>
 <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002151300.GC5212@kroah.com>
 <CY4PR0401MB3652EA0FFA3CD9679172B02CC3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002181418.GV23474@mit.edu>
In-Reply-To: <20201002181418.GV23474@mit.edu>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.65.67.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82f13a6c-da74-4f7e-f66d-08d86706b4bf
x-ms-traffictypediagnostic: CY4PR0401MB3617:
x-microsoft-antispam-prvs: <CY4PR0401MB3617AEF4C19E778EAA868787C3310@CY4PR0401MB3617.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JSJ2J+h4RSf48mkbYW6V65di8C1s3SoIl1jXxSyycy7zIu5bAIDSp8LV2cmDL2C9sirGCNHwsL8MB+WXsFxVhzL+9kQHZ30q9+BLC4r17m3EnpAy/EvUA329Lvoiv2pKoFj2Q7MNMhkAuZBh1vsA1W3P/HKk/y9WC/uq6x3F3aNF/Uksh2uZRpBPs06m1u5fDJMH0Sa67Y+ijek3ur8Hffi5ADg3HFKlwM/Z4lYiIWHycZK0tE1J9IQ1HPfJF4+UMPYuuctMnSpoYyW+kSwS+sNADz5/5SW5VQtTlLoZktDtAb6k4kzXSGNBdhfd42lzbsXB+cvRlHfp2xstiRjUWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(45080400002)(33656002)(478600001)(71200400001)(5660300002)(186003)(26005)(66574015)(316002)(54906003)(83380400001)(7406005)(8936002)(2906002)(7416002)(66946007)(76116006)(66556008)(4326008)(66476007)(86362001)(53546011)(64756008)(7696005)(6506007)(66446008)(6916009)(52536014)(8676002)(9686003)(55016002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: R63K0+7A8cRHeAW/Dmwo2mkjveiU6vEOHfGuj2esoofKbWMcM0onVxcj8rjk8vDAWKytj590JOjB+s3AdLN6Pv5FZSWC9D+7sljFYfpcJvszDE+IW829aTD5SzG90ZsuZPKQRaPq34ofqVHsDE/h9J74oUN4mkJX39ltdZ4Rhs+CeT1kaUCM1lCzvjCX3VJEYQZ3HxydaJaOYxOUovQ1Kbw6gufXELY3IlL3hZGDA26pKRzyV1tayEIIwm52W4odceZ5lLzZfnpYerogRyqslzsVuLj9cLOuhZzjVryT0VxfOGsHSkBE9pzWCqPM5QYTyk4aT9NPDwWnEKidhGCAjZHHnSw7whx6vPpPzNW37ruolH2/dOGQljI3Vd6NZFca2V2A0YjkjlZOdnxk+49RqwROeE33Ufjg2IaLkRtUgKBGHfTQcRhSVIYHYJjfoRzS4fd7lizZi9JeS5TvlCfT5BX+IanadHMGU16pG/IPOI2DOrbCPo1NmeAbCMCAgsy5IDqXdjow2P17M4StIZ+le/ZqYX4pmlzyhbMK+X+kPEVXRWNCZIiJMe8ZX+kRWrCsY/bL+CtagENaeqgCZ66JeDWuPwNC6dt1wo86K1QkXWNmJ15GYZYjEB2Ldm9k/a5L4gBddnodVLOnqhIUaBb5Xg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f13a6c-da74-4f7e-f66d-08d86706b4bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 19:09:36.9950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FxWUpYy3uf0DQGAI0jszpY7daj/0Nn1rlU3SKYQezCD7En055kqnfV5nEYOoBg2JowNzw8ZKE06Lt+/fXJvcuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3617
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUaGVvZG9yZSBZLiBUcydvIDx0
eXRzb0BtaXQuZWR1Pg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIgMiwgMjAyMCA4OjE0IFBNDQo+
IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1idXMuY29tPg0KPiBDYzog
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IFRvcnN0ZW4g
RHV3ZSA8ZHV3ZUBsc3QuZGU+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBOaWNvbGFp
IFN0YW5nZQ0KPiA8bnN0YW5nZUBzdXNlLmRlPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZz47IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBFcmljIFcuIEJpZWRlcm1h
bg0KPiA8ZWJpZWRlcm1AeG1pc3Npb24uY29tPjsgQWxleGFuZGVyIEUuIFBhdHJha292IDxwYXRy
YWtvdkBnbWFpbC5jb20+OyBBaG1lZCBTLiBEYXJ3aXNoIDxkYXJ3aXNoLjA3QGdtYWlsLmNvbT47
IFdpbGx5DQo+IFRhcnJlYXUgPHdAMXd0LmV1PjsgTWF0dGhldyBHYXJyZXR0IDxtamc1OUBzcmNm
LnVjYW0ub3JnPjsgVml0byBDYXB1dG8gPHZjYXB1dG9AcGVuZ2FydS5jb20+OyBBbmRyZWFzIERp
bGdlcg0KPiA8YWRpbGdlci5rZXJuZWxAZGlsZ2VyLmNhPjsgSmFuIEthcmEgPGphY2tAc3VzZS5j
ej47IFJheSBTdHJvZGUgPHJzdHJvZGVAcmVkaGF0LmNvbT47IFdpbGxpYW0gSm9uIE1jQ2FubiA8
bWNjYW5uQGpodS5lZHU+Ow0KPiB6aGFuZ2pzIDx6YWNoYXJ5QGJhaXNoYW5jbG91ZC5jb20+OyBB
bmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz47IEZsb3JpYW4gV2VpbWVyIDxmd2VpbWVy
QHJlZGhhdC5jb20+OyBMZW5uYXJ0DQo+IFBvZXR0ZXJpbmcgPG16eHJlYXJ5QDBwb2ludGVyLmRl
PjsgUGV0ZXIgTWF0dGhpYXMgPG1hdHRoaWFzLnBldGVyQGJzaS5idW5kLmRlPjsgTWFyY2VsbyBI
ZW5yaXF1ZSBDZXJyaQ0KPiA8bWFyY2Vsby5jZXJyaUBjYW5vbmljYWwuY29tPjsgTmVpbCBIb3Jt
YW4gPG5ob3JtYW5AcmVkaGF0LmNvbT47IFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZyYWRlYWQu
b3JnPjsgSnVsaWEgTGF3YWxsDQo+IDxqdWxpYS5sYXdhbGxAaW5yaWEuZnI+OyBEYW4gQ2FycGVu
dGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+OyBBbmR5IExhdnIgPGFuZHkubGF2ckBnbWFp
bC5jb20+OyBFcmljIEJpZ2dlcnMNCj4gPGViaWdnZXJzQGtlcm5lbC5vcmc+OyBKYXNvbiBBLiBE
b25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT47IFN0ZXBoYW4gTcO8bGxlciA8c211ZWxsZXJAY2hy
b25veC5kZT47IFBldHIgVGVzYXJpaw0KPiA8cHRlc2FyaWtAc3VzZS5jej4NCj4gU3ViamVjdDog
UmU6IFtESVNDVVNTSU9OIFBBVENIIDAwLzQxXSByYW5kb206IHBvc3NpYmxlIHdheXMgdG93YXJk
cyBOSVNUIFNQODAwLTkwQiBjb21wbGlhbmNlDQo+DQo+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4N
Cj4gT24gRnJpLCBPY3QgMDIsIDIwMjAgYXQgMDM6Mzk6MzVQTSArMDAwMCwgVmFuIExlZXV3ZW4s
IFBhc2NhbCB3cm90ZToNCj4gPiA+IFRoZW4geW91ciBjb21wYW55IGNhbiBub3QgY29udHJpYnV0
ZSBpbiBMaW51eCBrZXJuZWwgZGV2ZWxvcG1lbnQsIGFzDQo+ID4gPiB0aGlzIGlzIG9idmlvdXNs
eSBub3QgYWxsb3dlZCBieSBzdWNoIGEgZm9vdGVyLg0KPiA+ID4NCj4gPiBJbnRlcmVzdGluZywg
dGhpcyBoYXMgbmV2ZXIgYmVlbiByYWlzZWQgYXMgYSBwcm9ibGVtIHVudGlsIHRvZGF5IC4uLg0K
PiA+IEdvaW5nIGJhY2sgdGhyb3VnaCBteSBtYWlsIGFyY2hpdmUsIGl0IGxvb2tzIGxpa2UgdGhl
eSBzdGFydGVkIGF1dG9tYXRpY2FsbHkgYWRkaW5nIHRoYXQgc29tZQ0KPiA+IDMgbW9udGhzIGFn
by4gTm90IHRoYXQgdGhleSBpbmZvcm1lZCBhbnlvbmUgYWJvdXQgdGhhdCwgaXQganVzdCBzaWxl
bnRseSBoYXBwZW5lZC4NCj4NCj4gU28gdXNlIGEgcHJpdmF0ZSBlLW1haWwgYWRkcmVzcyAoZS5n
LiwgYXQgZmFzdG1haWwuZm0gaWYgeW91IGRvbid0DQo+IHdhbnQgdG8gcnVuIHlvdXIgbWFpbCBz
ZXJ2ZXIpIGFuZCB0aGVuIHR1bm5lbCBvdXQgU01UUCByZXF1ZXN0cyB1c2luZw0KPiBzc2guICBJ
dCdzIG5vdCBoYXJkLiAgOi0pDQo+DQpBY3R1YWxseSwgZm9yIHRoZSBsYXN0IHBhdGNoZXMgSSBz
ZW50IEkgYWxyZWFkeSBoYWQgdG8gdHVubmVsIHRoZW0gb3ZlciBzb21lIDNyZA0KcGFydHkgU01U
UC1vdmVyLUhUVFBTIHNlcnZpY2UgYmVjYXVzZSBvZiBvdXIgZmlyZXdhbGwgYmxvY2tpbmcgYWNj
ZXNzIHRvDQp0aGUgR21haWwgU01UUCBzZXJ2ZXIgSSBwcmV2aW91c2x5IHVzZWQgZm9yIHRoYXQg
Oi0oDQoNCkkgZ3Vlc3MgdHVubmVsbGluZyBvdmVyIFNTSCBpcyBhbm90aGVyIG9wdGlvbiwgYWx0
aG91Z2ggSSBoYXZlIG5vIGlkZWEgaG93IHRvDQpkbyBzdWNoIGEgdGhpbmcgKGRpZG4ndCBrbm93
IGl0IHdhcyBwb3NzaWJsZSkuIEF0IHRoZSBlbmQgb2YgdGhlIGRheSwgSSBhbSBub3QNCmEgc29m
dHdhcmUgZ3V5LCBzbyBJJ20gbm90IF90aGF0XyBtdWNoIGludG8gdGhlc2Uga2luZHMgb2YgdGhp
bmdzIC4uLg0KDQpUaGF0IGRvZXNuJ3Qgd29yayBmb3IgX3JlZ3VsYXJfIG1haWwsIHRob3VnaCwg
YXMgSSB3b3VsZCBub3QgYmUgYWJsZSB0byBzZXR1cA0KYSBtYWlsIGNsaWVudCBmb3IgdGhhdC4g
SSBjYW4ndCBpbnN0YWxsIGFueXRoaW5nIGFuZCBJIGNhbid0IGV2ZW4gdG91Y2ggdGhlIHNldHRp
bmdzDQpvZiBteSBPdXRsb29rIGNsaWVudCA6LSgNCg0KRm9yIGluY29taW5nIG1haWwgSSdtIGFj
dHVhbGx5IGJ1bGsgZm9yd2FyZGluZyB0aGUgbWFpbGluZyBsaXN0IHRocm91Z2ggbXkNCkdtYWls
IGFjY291bnQgbm93IGJlY2F1c2Ugb3VyIG1haWwgc2VydmVyIHN0b3BwZWQgYWNjZXB0aW5nIGl0
IGRpcmVjdGx5Lg0KV0l0aCBQT1AzIGFuZCBJTUFQIGJlaW5nIGJsb2NrZWQsIEkgc3RpbGwgbmVl
ZCB0byBmaW5kIHNvbWUgd2F5IHRvIHJlY2VpdmUNCnBhdGNoZXMgd2l0aG91dCBvdXIgRXhjaGFu
Z2Ugc2VydmVyIGZ1YmFycmluZyB0aGVtIHRob3VnaCAodGlwcyBhcmUgd2VsY29tZSEpLg0KUmln
aHQgbm93IHRoZSBvbmx5IHNvbHV0aW9uIEkgaGF2ZSBpcyBmZXRjaCB0aGVtIGZyb20gbXkgaG9t
ZSBQQyBhbmQgdGFrZQ0KdGhlbSB0byB3b3JrIG9uIGEgVVNCIHN0aWNrLiBXZWxjb21lIHRvIDIw
MjAgLi4uDQoNCj4gSSd2ZSB3b3JrZWQgYSBtdWx0aXBsZSAkQklHX0NPTVBBTlkncywgYW5kIEkn
dmUgYmVlbiBkb2luZyB0aGlzIGZvcg0KPiBkZWNhZGVzLiAgSXQncyBhbHNvIGhlbHBmdWwgd2hl
biBJIG5lZWQgdG8gc2VuZCBlLW1haWxzIGZyb20NCj4gY29uZmVyZW5jZSBuZXR3b3JrcyBmcm9t
IG15IGxhcHRvcC4uLi4NCj4NCj4NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2ls
aWNvbiBJUCBBcmNoaXRlY3QgTXVsdGktUHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5
DQpSYW1idXMgUk9UVyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5z
aWRlIFNlY3VyZS9WZXJpbWF0cml4IFNpbGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWly
ZWQgYnkgUmFtYnVzLg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFk
ZHJlc3MgYm9vayB3aXRoIG15IG5ldyBlLW1haWwgYWRkcmVzcy4NCi0gVGVkDQoNCg0KKiogVGhp
cyBtZXNzYWdlIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGZvciB0aGUgc29sZSB1c2Ugb2YgdGhl
IGludGVuZGVkIHJlY2lwaWVudChzKS4gSXQgbWF5IGNvbnRhaW4gaW5mb3JtYXRpb24gdGhhdCBp
cyBjb25maWRlbnRpYWwgYW5kIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRl
ZCByZWNpcGllbnQgb2YgdGhpcyBtZXNzYWdlLCB5b3UgYXJlIHByb2hpYml0ZWQgZnJvbSBwcmlu
dGluZywgY29weWluZywgZm9yd2FyZGluZyBvciBzYXZpbmcgaXQuIFBsZWFzZSBkZWxldGUgdGhl
IG1lc3NhZ2UgYW5kIGF0dGFjaG1lbnRzIGFuZCBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVs
eS4gKioNCg0KUmFtYnVzIEluYy48aHR0cDovL3d3dy5yYW1idXMuY29tPg0K

