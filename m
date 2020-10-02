Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C85C4363C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 15:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89362074B
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 15:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="TcKNVBzT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgJBPjp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 11:39:45 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:50095 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733260AbgJBPjo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 11:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1601653182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yvny9zXRpwzy1mR2os4AUulOvgG8EjS9qhLXLj0cqAg=;
        b=TcKNVBzTjniDgXaXzdG0v4F0d4VyORyVED4O3RUNXlvEREEStbiWG7MowoC9gj20Fvvbw3
        c2C8VdtD7mYF4Pz3yV7oWrOO3gqDCIM1wx5yHih2wI/5MGuV0udj3G5tK6JQrEF2SkqnCw
        yo7XxpgMx4IdOQne25gWvOyHG2MBmFs=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-kaItjCNTNsq11NTgeCWCug-1; Fri, 02 Oct 2020 11:39:39 -0400
X-MC-Unique: kaItjCNTNsq11NTgeCWCug-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3651.namprd04.prod.outlook.com
 (2603:10b6:910:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 15:39:35 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 15:39:35 +0000
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
Thread-Index: AQHWj+30K9pLzYDH0UOZg+dE4DU5IKmEUggAgAAOGOCAAAnmAIAABuCggAAMRgCAAAGwIA==
Date:   Fri, 2 Oct 2020 15:39:35 +0000
Message-ID: <CY4PR0401MB3652EA0FFA3CD9679172B02CC3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002140428.GC3475053@kroah.com>
 <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002151300.GC5212@kroah.com>
In-Reply-To: <20201002151300.GC5212@kroah.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d4c2b41-81e0-41b5-a1e1-08d866e95d57
x-ms-traffictypediagnostic: CY4PR0401MB3651:
x-microsoft-antispam-prvs: <CY4PR0401MB36514BA804B7A72F813F2B0BC3310@CY4PR0401MB3651.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: rMP+a/OLzwNrJZU7+k6FQB1JHDpBR/Zrx7VmHqokxQxgXA3qn1UWFRhu9HS46TtUp3Y9kyTxkx/2wNpij229BsMLtH7KH701BzGocXo4g3RcRWN0deRU1WySCd7/fh2tjcvBMRQShr2af180Sw28bzSej9MfPk7Kp1JoH35yV5kh6wpTTEuJC9HIA3XxBIhkxM8M+9eldiTGwUAx4nncwO4YmbhJwxfQDKzaGIU04i3bQQ0avBPSLZQrTGrdJP1gVmRstr4oG6iA9JvFQcwVcE93xeYfWJvkU1MRVCWdOIivNCBD4jiGyGTEFlOyBJqg1h1fSEs3xXT/QQI18jcvIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39850400004)(136003)(366004)(66574015)(7406005)(55016002)(9686003)(7416002)(2906002)(71200400001)(66476007)(66556008)(66446008)(7696005)(6916009)(66946007)(6506007)(53546011)(4326008)(86362001)(83380400001)(26005)(54906003)(8676002)(5660300002)(52536014)(8936002)(186003)(316002)(64756008)(76116006)(478600001)(33656002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: y51EhH3U+1Jfz4LoidxbBJo/PW2dm0syPLsYdYa+WIsj4C+s27xFqOQIYzI0FoXEoIeSC4kgjspQlv9zqEd43IVIHfJU/nlWfsGOGD2XX1qu9WLogyq3tlhuxjnFATLTndeCzfy/aJq4RU0VjT2j68E2mbXgz5TDnmcRErTi9rmWPPjzgrPdeXk+VTrRdq3al3CctdhRguoSnZNTRMSOLiXlVyjMAKjSCOphw1T89R0Jler+6fQyT6cUfHL6IV0FHDjCPHvWzmyVn/7zrU+mWEnmONTZKy+OMRDDdzoehRISp2UhaBSOzqqX6DxUJQ3ibdquLCncF/ukGb4w+FgC9RtLsQzJ1yzUU7TF2rjIbd3IZM5Nmd+s2sSF6MDQAxu8THj+pg/nDwlF2abrz6tU1snNYCKVciQ0HmQ/7QKHOSIIQ1sN4PggZwt4244k3wTEd6S3HfZFEMYcCbuyP0ll9wO8SGgKvC4DZfAUlZg7fJ1fE803/zvMfqrMq8cpqegCgxeOoIeUMP1VhXSSO3b/tq8WMiHi6tGeHYXjOV2+YaVPQjjqYPQ8vpsINM5ha5mB+LFxQs+epAV/98aWmbenACQ40jz75fWDT+ooSxnskrlSCBDt3PF6aMepZZ2YaR7UTgZXttJb6Jl+Kn6xIsGwrA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4c2b41-81e0-41b5-a1e1-08d866e95d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 15:39:35.0313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6QnVq5s5MjKOar6OQQql8JeJ3Uuxj2ohIMRNRnvWHQgsVjl5VhN/bp9GSoizmeajYQb3E9kCSf315aXz9AQzew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3651
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4g
PGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIgMiwg
MjAyMCA1OjEzIFBNDQo+IFRvOiBWYW4gTGVldXdlbiwgUGFzY2FsIDxwdmFubGVldXdlbkByYW1i
dXMuY29tPg0KPiBDYzogVG9yc3RlbiBEdXdlIDxkdXdlQGxzdC5kZT47IFRoZW9kb3JlIFkuIFRz
J28gPHR5dHNvQG1pdC5lZHU+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBOaWNvbGFp
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
Cj4gT24gRnJpLCBPY3QgMDIsIDIwMjAgYXQgMDI6MzQ6NDRQTSArMDAwMCwgVmFuIExlZXV3ZW4s
IFBhc2NhbCB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4gPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPg0KPiA+ID4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDIsIDIwMjAgNDowNCBQTQ0K
PiA+ID4gVG86IFZhbiBMZWV1d2VuLCBQYXNjYWwgPHB2YW5sZWV1d2VuQHJhbWJ1cy5jb20+DQo+
ID4gPiBDYzogVG9yc3RlbiBEdXdlIDxkdXdlQGxzdC5kZT47IFRoZW9kb3JlIFkuIFRzJ28gPHR5
dHNvQG1pdC5lZHU+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBOaWNvbGFpIFN0YW5n
ZQ0KPiA+ID4gPG5zdGFuZ2VAc3VzZS5kZT47IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc+OyBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgRXJpYyBXLiBCaWVkZXJtYW4N
Cj4gPiA+IDxlYmllZGVybUB4bWlzc2lvbi5jb20+OyBBbGV4YW5kZXIgRS4gUGF0cmFrb3YgPHBh
dHJha292QGdtYWlsLmNvbT47IEFobWVkIFMuIERhcndpc2ggPGRhcndpc2guMDdAZ21haWwuY29t
PjsgV2lsbHkNCj4gPiA+IFRhcnJlYXUgPHdAMXd0LmV1PjsgTWF0dGhldyBHYXJyZXR0IDxtamc1
OUBzcmNmLnVjYW0ub3JnPjsgVml0byBDYXB1dG8gPHZjYXB1dG9AcGVuZ2FydS5jb20+OyBBbmRy
ZWFzIERpbGdlcg0KPiA+ID4gPGFkaWxnZXIua2VybmVsQGRpbGdlci5jYT47IEphbiBLYXJhIDxq
YWNrQHN1c2UuY3o+OyBSYXkgU3Ryb2RlIDxyc3Ryb2RlQHJlZGhhdC5jb20+OyBXaWxsaWFtIEpv
biBNY0Nhbm4NCj4gPG1jY2FubkBqaHUuZWR1PjsNCj4gPiA+IHpoYW5nanMgPHphY2hhcnlAYmFp
c2hhbmNsb3VkLmNvbT47IEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJuZWwub3JnPjsgRmxvcmlh
biBXZWltZXIgPGZ3ZWltZXJAcmVkaGF0LmNvbT47IExlbm5hcnQNCj4gPiA+IFBvZXR0ZXJpbmcg
PG16eHJlYXJ5QDBwb2ludGVyLmRlPjsgUGV0ZXIgTWF0dGhpYXMgPG1hdHRoaWFzLnBldGVyQGJz
aS5idW5kLmRlPjsgTWFyY2VsbyBIZW5yaXF1ZSBDZXJyaQ0KPiA+ID4gPG1hcmNlbG8uY2VycmlA
Y2Fub25pY2FsLmNvbT47IE5laWwgSG9ybWFuIDxuaG9ybWFuQHJlZGhhdC5jb20+OyBSYW5keSBE
dW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz47IEp1bGlhIExhd2FsbA0KPiA+ID4gPGp1bGlh
Lmxhd2FsbEBpbnJpYS5mcj47IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNv
bT47IEFuZHkgTGF2ciA8YW5keS5sYXZyQGdtYWlsLmNvbT47IEVyaWMgQmlnZ2Vycw0KPiA+ID4g
PGViaWdnZXJzQGtlcm5lbC5vcmc+OyBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNv
bT47IFN0ZXBoYW4gTcO8bGxlciA8c211ZWxsZXJAY2hyb25veC5kZT47IFBldHIgVGVzYXJpaw0K
PiA+ID4gPHB0ZXNhcmlrQHN1c2UuY3o+DQo+ID4gPiBTdWJqZWN0OiBSZTogW0RJU0NVU1NJT04g
UEFUQ0ggMDAvNDFdIHJhbmRvbTogcG9zc2libGUgd2F5cyB0b3dhcmRzIE5JU1QgU1A4MDAtOTBC
IGNvbXBsaWFuY2UNCj4gPiA+DQo+ID4gPiA8PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+ID4gPiBP
biBGcmksIE9jdCAwMiwgMjAyMCBhdCAwMTozNToxOFBNICswMDAwLCBWYW4gTGVldXdlbiwgUGFz
Y2FsIHdyb3RlOg0KPiA+ID4gPiAqKiBUaGlzIG1lc3NhZ2UgYW5kIGFueSBhdHRhY2htZW50cyBh
cmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkg
Y29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzDQo+ID4gPiBjb25maWRlbnRpYWwgYW5kIHByaXZp
bGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQgb2YgdGhpcyBtZXNz
YWdlLCB5b3UgYXJlIHByb2hpYml0ZWQgZnJvbSBwcmludGluZywgY29weWluZywNCj4gPiA+IGZv
cndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRh
Y2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQo+ID4gPg0KPiA+
ID4gQXMgcGVyIG15IGxlZ2FsIGRlcGFydG1lbnQgcmVxdWVzdHMsIHRoaXMgaXMgbm93IGlnbm9y
ZWQgYW5kIGRlbGV0ZWQgb24NCj4gPiA+IG15IHN5c3RlbS4uLg0KPiA+ID4NCj4gPiA+IEhpbnQs
IGl0J3Mgbm90IGEgdmFsaWQgZm9vdGVyIGZvciBwdWJsaWMgbWFpbGluZyBsaXN0cy4uLg0KPiA+
ID4NCj4gPiA+IGdyZWcgay1oDQo+ID4gSXQncyBhdXRvbWF0aWNhbGx5IGFkZGVkIGJ5IG91ciBj
b21wYW55IG1haWwgc2VydmVyIC4uLiBub3Qgc29tZXRoaW5nIEkgY2FuIGNvbnRyb2wgYXQgYWxs
IDotKA0KPg0KPiBUaGVuIHlvdXIgY29tcGFueSBjYW4gbm90IGNvbnRyaWJ1dGUgaW4gTGludXgg
a2VybmVsIGRldmVsb3BtZW50LCBhcw0KPiB0aGlzIGlzIG9idmlvdXNseSBub3QgYWxsb3dlZCBi
eSBzdWNoIGEgZm9vdGVyLg0KPg0KSW50ZXJlc3RpbmcsIHRoaXMgaGFzIG5ldmVyIGJlZW4gcmFp
c2VkIGFzIGEgcHJvYmxlbSB1bnRpbCB0b2RheSAuLi4NCkdvaW5nIGJhY2sgdGhyb3VnaCBteSBt
YWlsIGFyY2hpdmUsIGl0IGxvb2tzIGxpa2UgdGhleSBzdGFydGVkIGF1dG9tYXRpY2FsbHkgYWRk
aW5nIHRoYXQgc29tZQ0KMyBtb250aHMgYWdvLiBOb3QgdGhhdCB0aGV5IGluZm9ybWVkIGFueW9u
ZSBhYm91dCB0aGF0LCBpdCBqdXN0IHNpbGVudGx5IGhhcHBlbmVkLg0KDQo+IFBsZWFzZSB3b3Jr
IHdpdGggeW91ciBJVCBhbmQgbGVnYWwgZGVwYXJ0bWVudCB0byBmaXggdGhpcy4NCj4NCkVoIC4u
LiBHcmVnIC4uLiB0aGF0J3Mgbm90IGhvdyB0aGF0IHdvcmtzIGluIHRoZSByZWFsIHdvcmxkLiBJ
biB0aGUgcmVhbCB3b3JsZCwgbGVnYWwgYW5kIElUIGxheQ0KZG93biB0aGUgbGF3IGFuZCB5b3Ug
anVzdCBjb21wbHkgd2l0aCB0aGF0IChvciBoYWNrIHlvdXIgd2F5IGFyb3VuZCBpdCwgaWYgeW91
IGNhbiA7LSkuDQoNCkknbSBhbHJlYWR5IGZpZ2h0aW5nIHRoZSBnb29kIGZpZ2h0IHRyeWluZyB0
byBrZWVwIGNvbnRyb2wgb2YgbXkgZGV2ZWxvcG1lbnQgbWFjaGluZXMNCmJlY2F1c2UgSVQgd291
bGQganVzdCBsb3ZlIHRvIGdldCByaWQgb2YgdGhvc2UgKHNpbmNlIG5vdCB1bmRlciBJVCBjb250
cm9sIC4uLi4gb2ggZGVhciAuLi4pDQpBbmQgb2J2aW91c2x5LCB5b3UgY2Fubm90IGRvIGtlcm5l
bCBkZXZlbG9wbWVudCBvbiBhIG1hY2hpbmUgd2l0aG91dCByb290IGFjY2Vzcy4NCkl0J3MgYW5u
b3lpbmcgZW5vdWdoIGFscmVhZHkgdG8gcmVxdWlyZSBJVCBzdXBwb3J0IHRvIHByb3ZpZGUgZXhw
bGljaXQgcGVybWlzc2lvbiB0byBvcGVuDQp0aGUgdGFzayBtYW5hZ2VyIG9uIG15IG93biBjb21w
YW55IGxhcHRvcCAuLi4gZ3JtYmwuDQoNCj4NCj4gdGhhbmtzLA0KPg0KPiBncmVnIGstaA0KDQpS
ZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Q
cm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYN
CiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2ls
aWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUg
c28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUt
bWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFy
ZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBj
b250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJ
ZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91
IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2
aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90
aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cu
cmFtYnVzLmNvbT4NCg==

