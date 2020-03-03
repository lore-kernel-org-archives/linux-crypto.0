Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA520C3F2C6
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7756C2086A
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="gANrYOsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgCCNDh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 08:03:37 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:55646 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728496AbgCCNDg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 08:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1583240614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLV2zMe6hbN0+MRxExgy8pJsTWtxchwYRNVXwewA9vo=;
        b=gANrYOsIwwtTZgwcBfQRgbpAS0+mZBTFli4d5pgKOixFiLuUeSOVPMqO1kbE3fR4FvRkQ/
        BLWGVNffO4N6aHNfujsNXg6R2c8V7D/To1/gkhp11e/Wn828UbFABg01PtpQpCwHhDqrSe
        ScvrJ/W16Hic80qcR6WxQ5hS8tCJZGs=
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-64VPDK7RMMyxNWOqYB3gnA-1; Tue, 03 Mar 2020 08:03:32 -0500
X-MC-Unique: 64VPDK7RMMyxNWOqYB3gnA-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3617.namprd04.prod.outlook.com
 (2603:10b6:910:8e::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19; Tue, 3 Mar
 2020 13:03:29 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda%3]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:03:29 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Andrei Botila <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] crypto: xts - limit accepted key length
Thread-Topic: [RFC] crypto: xts - limit accepted key length
Thread-Index: AQHV8Gr7c7FFE6Bn/kS7vrAYuVJAN6g09vgAgAHYvYCAAAViQA==
Date:   Tue, 3 Mar 2020 13:03:28 +0000
Message-ID: <CY4PR0401MB3652AA8D2AC4190E8205C678C3E40@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <72e1866a-9202-8d5b-f67b-8d9a63d888a7@gmail.com>
In-Reply-To: <72e1866a-9202-8d5b-f67b-8d9a63d888a7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac3956bf-1fee-4d33-dd45-08d7bf7344c7
x-ms-traffictypediagnostic: CY4PR0401MB3617:
x-microsoft-antispam-prvs: <CY4PR0401MB3617D16D638292405ED83A4DC3E40@CY4PR0401MB3617.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(346002)(376002)(366004)(189003)(199004)(9686003)(52536014)(55016002)(316002)(8936002)(71200400001)(478600001)(81156014)(81166006)(8676002)(66476007)(33656002)(76116006)(54906003)(110136005)(66446008)(66556008)(66946007)(64756008)(4326008)(26005)(186003)(86362001)(5660300002)(53546011)(7696005)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3617;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ULp57hQGO5ZRy0wX658sinqPJLeXVggFqXMVbTUWEDhhSSEQjuVHsVbik6fP9ohsm0eBEDmbvKPn9dJxsUNqfsmLsNuh4NVREZpm9PERbbJVwox0CylQnbgoklN/Wra1j5kMstfhtqF3rwPhF8kleCj0sA4HKtrNBwJr2soOokWmKpd8banTlsEDMn2OVVShgjTd3DpY9RMWrr+dVAUDjxClkq9XK4LDt81VTUXA2gFEmr+Fa4GgekShnT3AVupepvviYx0JT1L2eSjCm0rev4U+PDX+L4o0nQT28wy89fXiUebcbjLYw81ISx2VuMoGmxd40rWudBp//NrLe9klQFaPpCLlt7JMfBv7jgU+Ci5VXtnc299FyAESX/Ixv7pX1S/N4kCKjwLzygk8A43pdh127JfjuNIGiUXheMmygAFq48N6NhtxOwKcAmbVp1aQ
x-ms-exchange-antispam-messagedata: jwW97GD9wZLfNzNVUtlASUUZh61am8yYNrDmkv+mkU00w8rIi5yjjG8rWDBUnnWjwc4UJKEurzqoKjnggvVMEwxVAN1/g+CzAY6hftQLLzl8GyvTMUdpgr2/yCFV7mO2e5Xytr45nglsbqlHadVGRw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3956bf-1fee-4d33-dd45-08d7bf7344c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 13:03:29.0978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6273Aob4xLUljLolhC2YhsJnEMIt7flCuAW0tjn3CVmbAsQPT7ZaTCy14uwo69Df6no3IMZkXV7l+Bj1tmbyvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3617
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWxhbiBCcm96IDxnbWF6eWxh
bmRAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAzLCAyMDIwIDE6MzYgUE0NCj4g
VG86IFZhbiBMZWV1d2VuLCBQYXNjYWwgPHB2YW5sZWV1d2VuQHJhbWJ1cy5jb20+OyBBbmRyZWkg
Qm90aWxhIDxhbmRyZWkuYm90aWxhQG9zcy5ueHAuY29tPjsgSGVyYmVydCBYdQ0KPiA8aGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1PjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0Pg0KPiBDYzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQ10gY3J5cHRvOiB4dHMgLSBsaW1pdCBh
Y2NlcHRlZCBrZXkgbGVuZ3RoDQo+DQo+IDw8PCBFeHRlcm5hbCBFbWFpbCA+Pj4NCj4gT24gMDIv
MDMvMjAyMCAwOTozMywgVmFuIExlZXV3ZW4sIFBhc2NhbCB3cm90ZToNCj4gPiBIbW0gLi4uIGlu
IHByaW5jaXBsZSBJRUVFLTE2MTkgYWxzbyBkZWZpbmVzIFhUUyAqb25seSogZm9yIEFFUy4gU28g
YnkgdGhhdCAgc2FtZQ0KPiA+IHJlYXNvbmluZywgeW91IHNob3VsZCBhbHNvIG5vdCBhbGxvdyBh
bnkgdXNhZ2Ugb2YgWFRTIGJleW9uZCBBRVMuIFlldCBpdCBpcw0KPiA+IGFjdHVhbGx5IGJlaW5n
IGFjdGl2ZWx5IHVzZWQoPykgd2l0aCBvdGhlciBjaXBoZXJzIGluIHRoZSBMaW51eCBrZXJuZWwu
DQo+IEp1c3QgRllJIC0geWVzLCBpdCBpcyBhY3RpdmVseSB1c2VkIHdpdGggb3RoZXIgY2lwaGVy
cy4NCj4NCj4gVGhlcmUgaXMgYSBsb3Qgb2YgTFVLUyBkZXZpY2VzIHRoYXQgdXNlIFNlcnBlbnQg
b3IgVHdvZmlzaCB3aXRoIFhUUyBtb2RlLg0KPg0KPiBUaGUgc2FtZSBmb3IgVHJ1ZUNyeXB0L1Zl
cmFDcnlwdCwgaGVyZSBzb21ldGltZXMgaXQgaXMgdXNlZCBhbHNvIGluIGNpcGhlciBjaGFpbg0K
PiAoYm90aCBuYXRpdmUgYmluYXJpZXMgb3IgY3J5cHRzZXR1cCBjb2RlIHVzZSBkbS1jcnlwdCB3
aXRoIGNyeXB0byBBUEkgaGVyZSkuDQo+DQo+IFhUUyBtb2RlIGlzIGRlc2lnbmVkIGZvciBzdG9y
YWdlIGVuY3J5cHRpb24gb25seSAtIGFuZCBhdCBsZWFzdCBmb3IgZGlzayBlbmNyeXB0aW9uDQo+
IEkgaGF2ZSBuZXZlciBzZWVuIHJlcXVlc3QgZm9yIDE5MmJpdCBrZXlzLi4uDQo+DQpNZSBuZWl0
aGVyIC4uLiBidXQgSSB3YXMganVzdCBwb2ludGluZyBvdXQgdGhhdCByZWZlcnJpbmcgdG8gdGhl
IElFRUUgc3BlYyAoZm9yIHN1cHBvcnRpbmcNCm9ubHkgMTI4IGFuZCAyNTYgYml0IGtleXMpIG1h
a2VzIG5vIHNlbnNlIGlmIHlvdSBhbHNvIHN1cHBvcnQgb3RoZXIgYmxvY2tjaXBoZXJzIG5vdA0K
bWVudGlvbmVkIGluIHRoYXQgc2FtZSBJRUVFIHNwZWMuDQoNClRoZSBtb2RlIGl0c2VsZiBjYW4g
b2J2aW91c2x5IHdvcmsgd2l0aCBhbnkgMTI4IGJpdCBibG9ja2NpcGhlciwgd2l0aCBhbnkga2V5
c2l6ZS4NClNvIGFueSBsaW1pdGF0aW9uIG9uIHRoYXQgd291bGQgYmUgcHVyZWx5IGFydGlmaWNp
YWwgSU1ITy4NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNo
aXRlY3QgTXVsdGktUHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5DQpSYW1idXMgUk9U
VyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5zaWRlIFNlY3VyZS9W
ZXJpbWF0cml4IFNpbGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWlyZWQgYnkgUmFtYnVz
Lg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFkZHJlc3MgYm9vayB3
aXRoIG15IG5ldyBlLW1haWwgYWRkcmVzcy4NCg0KKiogVGhpcyBtZXNzYWdlIGFuZCBhbnkgYXR0
YWNobWVudHMgYXJlIGZvciB0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChz
KS4gSXQgbWF5IGNvbnRhaW4gaW5mb3JtYXRpb24gdGhhdCBpcyBjb25maWRlbnRpYWwgYW5kIHBy
aXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQgb2YgdGhpcyBt
ZXNzYWdlLCB5b3UgYXJlIHByb2hpYml0ZWQgZnJvbSBwcmludGluZywgY29weWluZywgZm9yd2Fy
ZGluZyBvciBzYXZpbmcgaXQuIFBsZWFzZSBkZWxldGUgdGhlIG1lc3NhZ2UgYW5kIGF0dGFjaG1l
bnRzIGFuZCBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseS4gKioNCg0KUmFtYnVzIEluYy48
aHR0cDovL3d3dy5yYW1idXMuY29tPg0K

