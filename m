Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7CFC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA1621D92
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="f6KvbS2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJBNfa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:35:30 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:60770 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387927AbgJBNfa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 09:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1601645727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z3YULbPhGQRK4xb1e+1fjoWjMHNKbZSr9DfoG/VCoQY=;
        b=f6KvbS2wi8XwLCPOloKDiN8hrPQHbd0gSS8n422nzy1gQbxki9z1pzvbQsuX9cGB6q0o5Q
        jpMPX+sjxFYNJD+62ioDEpG8IwjooiBoXu3PwCtq848vkeV/Xcv7HMLYJcecbWe5DZNXiW
        6Loe8vF+xYAOUFPq/a8ywYzNzbZuIvA=
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02lp2059.outbound.protection.outlook.com [104.47.38.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-DETaHws_NeWMTVM4HeZtHg-1; Fri, 02 Oct 2020 09:35:24 -0400
X-MC-Unique: DETaHws_NeWMTVM4HeZtHg-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0646.namprd04.prod.outlook.com
 (2603:10b6:903:e5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Fri, 2 Oct
 2020 13:35:18 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 13:35:18 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHWj+30K9pLzYDH0UOZg+dE4DU5IKmEUggAgAAOGOA=
Date:   Fri, 2 Oct 2020 13:35:18 +0000
Message-ID: <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
In-Reply-To: <20201002123836.GA14807@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a835919-85ca-4356-b8a1-08d866d800eb
x-ms-traffictypediagnostic: CY4PR04MB0646:
x-microsoft-antispam-prvs: <CY4PR04MB0646E2674EAD15B012DD9211C3310@CY4PR04MB0646.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KVc85QsiiaDPKWUlk/SD6auXHA5w+3+wHdWEP5GqwjQvT/Jv5lVnM76mlsyfRSlZwIcUL9kuALbeicQFzlOB02OK35ULlxpH7JEAYLroeeEsZ8bJ28NhjehoPYIeZrGpIVazA7aW7a+6o5O6SBLp5/nZoMwjL885b+OcH8X5Gaxtt2J0/8Vry7CKkwJcxElqef2srDlg8os1ipP1R+bcp/1h/mKgMvYC3lNXc75AU8clYTELgs8jSt59qst4zTMEPhXekoTqKio2YVisY5qJ07Qunq/zxZFg5LN185HwqZXU2WVbakpwuxZ9O+WH6U9w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(346002)(366004)(136003)(376002)(71200400001)(7416002)(7406005)(76116006)(8676002)(6506007)(478600001)(52536014)(2906002)(33656002)(66946007)(66446008)(53546011)(8936002)(64756008)(66556008)(66476007)(7696005)(4326008)(5660300002)(83380400001)(66574015)(86362001)(9686003)(110136005)(54906003)(316002)(55016002)(186003)(26005);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: WhmBOTwsk6f8yUpDS5MOsCM/yIr2qVkUNTWhc92zBdjBTJvyBVmYdvtw1gbxp7r96dCLWWuS0ocoNuDk4v44BdQpI8U1TXzs18kuzYbe2jBN0YN38zGeIlA96dLQaeoZ0gzwdOzePVj5DdvSbY/zu0WE+SDnqtbNcSMNzXqn+H4aSDSkzBmEmJTMYJ6yUSuFIeRgIqJGvE0ZB8GtxoBYUi5+MKLdBrLs6uG6VatBcdXlp3+2P7+dfoexp16BLngQ5SUQyiVxaMm3c7Fd5Aw65kWBk1MsXdkYhYLgZh7OHzau3KPfIuHfQfT2BKD1YFWb7d7p1Lz3H4mxiHOHcPGVVykeZ0FEJ94FJqfy35VJJ2rz4xUwtthH6GmNm+MdJbtN6jsQyXWf19nLb4Mhca/D+viAGAvKdSfFb8FLGTPcwnilN8b7CFSRH8jxbkHCO7SdUvRzJAjqWI1GAQUfxWEeyfHOw1PH5LKigmbAYO5GO9+Rp4SWI21IGHx0A79J+ES/FJRFRh/npSvkGaxkx0cLFwgskKcB62JEAThokwGBphsDGF3Wvl1dtStyaLxG4fAkxWRs4jmOx/29YAeQraW5W+s1FeopvsnCeFGzmbUxY0B7WVDqCx7Q3sWprB/WkQ7ZxiXnkgIUBduTNGdQKPA9WA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a835919-85ca-4356-b8a1-08d866d800eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 13:35:18.5743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pTMhdFTONw5t3o4ncMl/SRjoWIBkdNKN1HfaSFq8rrrPwsqo4OPswYdUSuYGidKVxd7HLPIgb7sYRq0YH7txHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0646
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

VG9yc3RlbiwNCg0KT2ssIGlmIHlvdSBtdXN0IGhhdmUgbW9yZSByZXBsaWVzIHRoZW4gSSdsbCBi
aXRlIDotKQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRvcnN0ZW4g
RHV3ZSA8ZHV3ZUBsc3QuZGU+DQo+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAyLCAyMDIwIDI6Mzkg
UE0NCj4gVG86IFRoZW9kb3JlIFkuIFRzJ28gPHR5dHNvQG1pdC5lZHU+DQo+IENjOiBsaW51eC1j
cnlwdG9Admdlci5rZXJuZWwub3JnOyBOaWNvbGFpIFN0YW5nZSA8bnN0YW5nZUBzdXNlLmRlPjsg
TEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4NCj4gPGFy
bmRAYXJuZGIuZGU+OyBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPjsgRXJpYyBXLiBCaWVkZXJtYW4gPGViaWVkZXJtQHhtaXNzaW9uLmNvbT47IEFsZXhhbmRl
cg0KPiBFLiBQYXRyYWtvdiA8cGF0cmFrb3ZAZ21haWwuY29tPjsgQWhtZWQgUy4gRGFyd2lzaCA8
ZGFyd2lzaC4wN0BnbWFpbC5jb20+OyBXaWxseSBUYXJyZWF1IDx3QDF3dC5ldT47IE1hdHRoZXcg
R2FycmV0dA0KPiA8bWpnNTlAc3JjZi51Y2FtLm9yZz47IFZpdG8gQ2FwdXRvIDx2Y2FwdXRvQHBl
bmdhcnUuY29tPjsgQW5kcmVhcyBEaWxnZXIgPGFkaWxnZXIua2VybmVsQGRpbGdlci5jYT47IEph
biBLYXJhIDxqYWNrQHN1c2UuY3o+Ow0KPiBSYXkgU3Ryb2RlIDxyc3Ryb2RlQHJlZGhhdC5jb20+
OyBXaWxsaWFtIEpvbiBNY0Nhbm4gPG1jY2FubkBqaHUuZWR1PjsgemhhbmdqcyA8emFjaGFyeUBi
YWlzaGFuY2xvdWQuY29tPjsgQW5keSBMdXRvbWlyc2tpDQo+IDxsdXRvQGtlcm5lbC5vcmc+OyBG
bG9yaWFuIFdlaW1lciA8ZndlaW1lckByZWRoYXQuY29tPjsgTGVubmFydCBQb2V0dGVyaW5nIDxt
enhyZWFyeUAwcG9pbnRlci5kZT47IFBldGVyIE1hdHRoaWFzDQo+IDxtYXR0aGlhcy5wZXRlckBi
c2kuYnVuZC5kZT47IE1hcmNlbG8gSGVucmlxdWUgQ2VycmkgPG1hcmNlbG8uY2VycmlAY2Fub25p
Y2FsLmNvbT47IE5laWwgSG9ybWFuIDxuaG9ybWFuQHJlZGhhdC5jb20+Ow0KPiBSYW5keSBEdW5s
YXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz47IEp1bGlhIExhd2FsbCA8anVsaWEubGF3YWxsQGlu
cmlhLmZyPjsgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPjsgQW5keSBM
YXZyDQo+IDxhbmR5LmxhdnJAZ21haWwuY29tPjsgRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJu
ZWwub3JnPjsgSmFzb24gQS4gRG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5jb20+OyBTdGVwaGFuIE3D
vGxsZXINCj4gPHNtdWVsbGVyQGNocm9ub3guZGU+OyBQZXRyIFRlc2FyaWsgPHB0ZXNhcmlrQHN1
c2UuY3o+DQo+IFN1YmplY3Q6IFJlOiBbRElTQ1VTU0lPTiBQQVRDSCAwMC80MV0gcmFuZG9tOiBw
b3NzaWJsZSB3YXlzIHRvd2FyZHMgTklTVCBTUDgwMC05MEIgY29tcGxpYW5jZQ0KPg0KPiA8PDwg
RXh0ZXJuYWwgRW1haWwgPj4+DQo+IEFsbW9zdCB0d28gd2Vla3MgcGFzc2VkIGFuZCB0aGVzZSBh
cmUgdGhlICJyZWxldmFudCIgcmVwbGllczoNCj4NCj4gSmFzb24gcGVyc29uYWxseSBkb2VzIG5v
dCBsaWtlIEZJUFMsIGFuZCBpcyBhZnJhaWQgb2YNCj4gInN1YnBhciBjcnlwdG8iLiBBbGJlaXQg
dGhpcyBwYXRjaCBzZXQgc3RyaWN0bHkgaXNuJ3QgYWJvdXQNCj4gY3J5cHRvIGF0IGFsbDsgdGhl
IGNyeXB0byBzdWJzeXN0ZW0gaXMgaW4gdGhlIHVubHVja3kgcG9zaXRpb24NCj4gdG8ganVzdCBk
ZXBlbmQgb24gYSBnb29kIGVudHJvcHkgc291cmNlLg0KPg0KSU1ITywgSmFzb24ncyBzdGF0ZW1l
bnQgaXMgY29tcGxldGVseSBzaWxseSBhbmQgc29sZWx5IGJhc2VkIG9uIHNvbWUgcGVyc29uYWwg
YmVlZi4NCk9idmlvdXNseSwgdGhlIF9hYmlsaXR5XyB0byBiZSBjb21wbGlhbnQgd2l0aCBGSVBT
IHRlc3RpbmcgZG9lcyBub3QgcHJlY2x1ZGUgdGhlIHVzZQ0Kb2Ygbm9uLUZJUFMgY3J5cHRvLCBp
biBjYXNlIHlvdSBzaG91bGQgY2hvb3NlIG5vdCB0byB0cnVzdCBhbnkgb2YgdGhlIEZJUFMgcmVj
b21tZW5kZWQNCmltcGxlbWVudGF0aW9ucy4NCg0KRmFjdCBvZiB0aGUgbWF0dGVyIGlzLCBtYW55
IGFwcGxpY2F0aW9uIGFyZWFzIChpbmNsdWRpbmcgYnV0IG5vdCBsaW1pdGVkIHRvIGRlZmVuY2Us
DQppbmR1c3RyaWFsIGF1dG9tYXRpb24sIGF1dG9tb3RpdmUsIGFlcm8gc3BhY2UsIC4uLikgaGF2
ZSBhIGhhcmQgYSBoYXJkIHJlcXVpcmVtZW50IG9uDQpGSVBTIGNlcnRpZmljYXRpb24uIFNvIG5v
dCBzdXBwb3J0aW5nIHRoYXQgd291bGQgZWl0aGVyIHJ1bGUgb3V0IHVzaW5nIExpbnV4IGFsdG9n
ZXRoZXIsDQpvciBzdGVlciB0aGVtIHRvd2FyZHMgb3V0LW9mLXRyZWUgc29sdXRpb25zLg0KDQpB
bmQganVzdCBydW5uaW5nIHRlc3RzIG9uIHlvdXIgZW50cm9weSBzb3VyY2UgY2FuJ3QgcG9zc2li
bHkgYmUgYSBiYWQgdGhpbmcgYW55d2F5LA0KZXNwZWNpYWxseSBpZiB5b3UgY2FuIGNvbmZpZ3Vy
ZSBpdCBvdXQgaWYgZG9uJ3QgbmVlZCBvciB3YW50IHRvIGhhdmUgaXQuDQoNCj4gR3JlZyBjbGFp
bXMgdGhhdCBMaW51eCAoa2VybmVsKSBpc24ndCBhYm91dCBjaG9pY2UsIHdoaWNoIGlzIGNsZWFy
bHkNCj4gd3JvbmcuDQo+DQpXZWxsLCBJJ20gbm90IGdvaW5nIHRvIGFyZ3VlIHdpdGggR3JlZyBh
Ym91dCB0aGF0IDstKQ0KDQo+IEFuZCB0aGlzIGlzIGFsbCA/Pz8NCj4NCj4gVGhlcmUgYXJlIG9w
dGlvbnMgZm9yIHN0YWNrIHByb3RlY3Rpb24uIEkgY2FuIHNlZSBib3VuZHMgY2hlY2tpbmcNCj4g
YW5kIG90aGVyIHNhbml0eSBjaGVja3MgYWxsIG92ZXIgdGhlIHBsYWNlLiBBbmQgZG9pbmcgYSBz
aW1pbGFyIHRoaW5nDQo+IG9uIGVudHJvcHkgc291cmNlcyBpcyBhIHByb2JsZW0/DQo+DQo+IEFk
bWl0dGVkbHksIGlmIGVudHJvcHkgc291cmNlcyBmYWlsLCB0aGUga2VybmVsIHdpbGwgaGFwcGls
eSByZW1haW4NCj4gcnVubmluZy4gTm8gYmFkIGltbWVkaWF0ZSBlZmZlY3RzIGluIHVzZXJsYW5k
IHdpbGwgYXJpc2UuIE9ubHkgc29tZQ0KPiBjcnlwdG9ncmFwaGljIGFsZ29yaXRobXMsIG90aGVy
d2lzZSB2ZXJ5IGRlY2VudCwgd2lsbCBydW4gb24NCj4gdW5uZWNjZXNzYXJpbHkgd2VhayBrZXlz
LCBwcm9iYWJseSBjYXVzaW5nIHNvbWUgcmVhbC13b3JsZCBwcm9ibGVtcy4NCj4gRG9lcyBhbnli
b2R5IGNhcmU/DQo+IFRoZSBOSVNUIGFuZCB0aGUgQlNJIGRvLCBidXQgdGhhdCBkb2VzIG5vdCBt
ZWFuIHRoZWlyIHNvbHV0aW9ucyBhcmUNCj4gYXV0b21hdGljYWxseSB3cm9uZyBvciBiYWNrZG9v
cmVkLg0KPg0KPiBUaGVyZSBpcyBub3cgYSB3ZWxsIGxheWVkLW91dCBzY2hlbWUgdG8gZW5zdXJl
IHF1YWxpdHkgcmFuZG9tbmVzcywNCj4gYW5kIGEgbG90IG9mIHdvcmsgaGVyZSBoYXMgYmVlbiBw
dXQgaW50byBpdHMgaW1wbGVtZW50YXRpb24uDQo+DQo+IFdvdWxkIHNvbWUgbWFpbnRhaW5lciBw
bGVhc2UgY29tbWVudCBvbiBwb3RlbnRpYWwgcHJvYmxlbXMgb3INCj4gc2hvcnRjb21pbmdzPyBP
dGhlcndpc2UgYSAiVGhhbmtzLCBhcHBsaWVkIiB3b3VsZCBiZSBhcHByb3ByaWF0ZSwgSU1PLg0K
Pg0KPiBUb3JzdGVuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAg
QXJjaGl0ZWN0IE11bHRpLVByb3RvY29sIEVuZ2luZXMsIFJhbWJ1cyBTZWN1cml0eQ0KUmFtYnVz
IFJPVFcgSG9sZGluZyBCVg0KKzMxLTczIDY1ODE5NTMNCg0KTm90ZTogVGhlIEluc2lkZSBTZWN1
cmUvVmVyaW1hdHJpeCBTaWxpY29uIElQIHRlYW0gd2FzIHJlY2VudGx5IGFjcXVpcmVkIGJ5IFJh
bWJ1cy4NClBsZWFzZSBiZSBzbyBraW5kIHRvIHVwZGF0ZSB5b3VyIGUtbWFpbCBhZGRyZXNzIGJv
b2sgd2l0aCBteSBuZXcgZS1tYWlsIGFkZHJlc3MuDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55
IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGll
bnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFu
ZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRo
aXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZv
cndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRh
Y2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJ
bmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

