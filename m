Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5317CC43381
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 08:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273D764E2E
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 08:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhBBI7f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:59:35 -0500
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:33203 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhBBI73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 03:59:29 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 03:59:27 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1612256281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1meVVN45xIgy0f13oreAyy3YHe8hbdh8pctoeH4w5M=;
        b=S8FWmNXjSO6Auxl8EoU61EcD+Vs3H2DbN0QlIUJCxPypzTunvgpVlTzx9gQ8Y20ILfNbt8
        oSI2akfwpJrItBgc7B+Y8k6xv9dLEIBM9L0toBpkg7erMuQPh6uHyGhHDmwv9bgi4t0heB
        CY/G2Z/qmaaMjVlD0ZwFwBDMzNtAnw8=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-ba8pL0_dOhiceoJOQU_bsg-1; Tue, 02 Feb 2021 03:48:53 -0500
X-MC-Unique: ba8pL0_dOhiceoJOQU_bsg-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY1PR04MB2363.namprd04.prod.outlook.com
 (2a01:111:e400:c617::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 08:48:50 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::65b0:c01a:47ed:13af]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::65b0:c01a:47ed:13af%6]) with mapi id 15.20.3763.019; Tue, 2 Feb 2021
 08:48:50 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Maciej Pijanowski <maciej.pijanowski@3mdeb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "pascalvanl@gmail.com" <pascalvanl@gmail.com>,
        =?utf-8?B?UGlvdHIgS3LDs2w=?= <piotr.krol@3mdeb.com>
Subject: RE: safexcel driver for EIP197 and mini firmware features
Thread-Topic: safexcel driver for EIP197 and mini firmware features
Thread-Index: AQHW+Mtrjxx5oEQ3cUa747FPS0pm36pEjNyA
Date:   Tue, 2 Feb 2021 08:48:50 +0000
Message-ID: <CY4PR0401MB3652D787A7DE6E19E937A392C3B59@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <d90956cf-5340-cbe4-1254-771c18b7e46d@3mdeb.com>
In-Reply-To: <d90956cf-5340-cbe4-1254-771c18b7e46d@3mdeb.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c7dc9cb-9c63-4d3f-d1d9-08d8c7575cbc
x-ms-traffictypediagnostic: CY1PR04MB2363:
x-microsoft-antispam-prvs: <CY1PR04MB2363E5E205EB073207006FA7C3B59@CY1PR04MB2363.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pg+3fIkh04inFkdZrT051QSm3Y/7r/YpWol9jpAvftcK5KkUySJwxpqw9D67GiJbclKk9LXJc5C95Cw3tMkNgLta6OpXkrJePuYONoFGVQH2jL+nHxiIT+EsqTjq+uGtogPJE/lWSZ1LxD/q8aYZmzhgKZmx8ns6rrUr7wylpDZQUZiBC1jrbWZHnmcu072A+d1oLcLC0N+NScPQZyptD7Lxm8SP6zygje5y9zriTT49qABVQDkzBNkZRmuacUT33chpduds+7pyJc3/KvvR8UMjhiPHHcvwV/HN4P+hWVXisr6eusTsMlDwn6bERVHwNSA1i+iyp773FR4pddf2o22Jr+wo5Nx+B5tLQvCoLYGDewED9pmeXak27Kqnnejetf0p59/SRbHu5US88sXuDOCuBzPboDiBwDS0OwV4NwQmlJsqY2U6oSBm6Ofz0IpRA5jW7fdMhCU+JHx2TRbCA6MicmAtJreIrO3HW5XsgRaEFI62/xbc3aC0aZjIBEFRYMyj8AZRffph/sb5gVjWzJZCQwQn7FXrWHjGsF2akR1sGuYtfgIjh3mocwhoYT90DA6OC2JFASrcHvJt9NT4K2cm3kKxyG9fRlGp9UAKvGE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39850400004)(366004)(136003)(376002)(5660300002)(110136005)(33656002)(316002)(966005)(54906003)(52536014)(64756008)(71200400001)(66446008)(4326008)(6506007)(53546011)(66556008)(186003)(66476007)(83380400001)(7696005)(66574015)(8676002)(478600001)(86362001)(76116006)(26005)(66946007)(55016002)(9686003)(8936002)(2906002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: =?utf-8?B?UGc3aVpPZkhpbWhYK21WNE9uVktKREhpZVpaQ1Zlb05QZkhqaVYvSXlxRDVj?=
 =?utf-8?B?RDR0enpyK3VITzA3SVk0MWV4U1NBa0VBcmhoYXJBMUVGeFVhd2NJUnRoZmZ1?=
 =?utf-8?B?cHNZTVR6aVBScUZac2FwZG05MkpwVFNQU1BxdlBndzF1anhkYVBVWUxDekVD?=
 =?utf-8?B?cEI1c1hvaHkwWnJIYmRuTU1PenZWSVNhRzZZODZIZ3FDT09vK0xvMG9qd3Jw?=
 =?utf-8?B?Y25hWUxEZDErUUpRR1dWeHN0eXUzbjlwQzFtUXFmYnNkMGxhWVpXZjRzY05Y?=
 =?utf-8?B?bVJSV3pSTkpDTlMrTFh6aU9XaVpEUDRtK29tbVc2dUNZQ0JvWVFmVHk4QWt0?=
 =?utf-8?B?UlR6eW50aXpQaklnbUE3MWFhb0d4TkdBUnlOSTRnaDluNWZLNHpyVVNhckhm?=
 =?utf-8?B?UHI2U3BvU29LNVhCTWlDR3VwNnkrMStieUZwNmFnWFBGZmJPMVNHWkNWdk1k?=
 =?utf-8?B?eWtITmRpd3FjVmhLS1R5NHBENElreEcwaWtab3JVU0w0R294dEFtMDQ3S1RI?=
 =?utf-8?B?bENxenFQUDI3c3hVU2hKa2pWcnZ2WFJPeENubDJ2bjg3S0YvSFVFYUM3VVpS?=
 =?utf-8?B?WFdreUdTaWpSWVA1L3BiL0JhLy9vdWY5QjRETEkyei8zN3hMSjhkREh5cUty?=
 =?utf-8?B?aHdLdGRQQmprc28zb1J1ekl6VENhUzVIbFk3blMxZXJIQmxzeEFPMDVvSTg5?=
 =?utf-8?B?dG9jSmZRWCtGa3phcFd3NXl0Uy9ocnl0WXpZcjhMTFRyVDUxYW81UmlFaC9i?=
 =?utf-8?B?cEZrenhUQ1h0ZGo4WXFoNmI4b2dmZHNSMDJHcVNBbjZCeFVMUDhVR01pQjAw?=
 =?utf-8?B?SjRMQ01JU0FYaGFlVTNsSTRpN1VVODlmYWJQRHpEVkJGU0ZpR2hNeitNSnFH?=
 =?utf-8?B?eFZuaDdZSFFCVmJyYm5KanBLR1RJb3lCcytDb1FBVVhvNkZHNkVYNjBuNy9p?=
 =?utf-8?B?SWpMOHZBNjVuTHJmWkpJMnQ0a0VMSmlvSXYyS29tZDBBRVcxZnpmVEZmbFda?=
 =?utf-8?B?bk9NRmNvY2lBMUl6SDI2ZHplSCtyR3VINW5RQk5ldm9tQzNHMUNJaHBISFVB?=
 =?utf-8?B?WDlLb0YrRnRMa3B3cFU1RVNBZGlBRzVrbFFheU5SdHpyY204dWdCZFI0MzhP?=
 =?utf-8?B?ckd0ZkFiMDlqbG5ZdEttbXNra0dIZ3M0S1RGRXpjanh0b3M1MjU5WlJ5a2RF?=
 =?utf-8?B?WWRYenFib1NtcnhXa1JUN0U0dU9hbzV0VDBtSUU4ZVBvRjZncWFzdWtSWWhB?=
 =?utf-8?B?NDZyczFqb3hmUXoxbkNJdE1pb2Vjck9UUTR6TnVqNmM5VWJPZ2MybElaeDRO?=
 =?utf-8?B?NnBGK0lyVS80bjN6NzYvYzEzdFBLU3hqWmJDWjZtRVc5K1ZJbjlXRm1DZG02?=
 =?utf-8?B?bi80dHZGaXFZWUcvc2h0TGt1RkZicnd6b1pDSzk2dW9jeHM1ZXkzT1EwSDFs?=
 =?utf-8?Q?vCkn1y8E?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7dc9cb-9c63-4d3f-d1d9-08d8c7575cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 08:48:50.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7RNa8GRt8k9GcdBQbfLqU9xCSBc7UuFJTQdA0tltbdLK9fqeiNn2gbRCImP3N6P0yg9ZT8xXjA5rDVMHQxwfOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB2363
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

SGVsbG8gTWFjaWVqLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1h
Y2llaiBQaWphbm93c2tpIDxtYWNpZWoucGlqYW5vd3NraUAzbWRlYi5jb20+DQo+IFNlbnQ6IE1v
bmRheSwgRmVicnVhcnkgMSwgMjAyMSA3OjUzIFBNDQo+IFRvOiBsaW51eC1jcnlwdG9Admdlci5r
ZXJuZWwub3JnDQo+IENjOiBhbnRvaW5lLnRlbmFydEBib290bGluLmNvbTsgcGFzY2FsdmFubEBn
bWFpbC5jb207IFBpb3RyIEtyw7NsIDxwaW90ci5rcm9sQDNtZGViLmNvbT4NCj4gU3ViamVjdDog
c2FmZXhjZWwgZHJpdmVyIGZvciBFSVAxOTcgYW5kIG1pbmkgZmlybXdhcmUgZmVhdHVyZXMNCj4N
Cj4gPDw8IEV4dGVybmFsIEVtYWlsID4+Pg0KPiBIZWxsbywNCj4NCj4gSSBhbSBpbnRlcmVzdGVk
IGluIHVzaW5nIHRoZSBFSVAxOTcgY3J5cHRvIGFjY2VsZXJhdG9yLiBJIGFtIGF3YXJlIHRoYXQN
Cj4gaXQgcmVxdWlyZXMgYW4gTkRBDQo+IHRvIG9idGFpbiB0aGUgZmlybXdhcmUgZm9yIGl0LCBi
dXQgSSBmb3VuZCBvdXQgdGhhdCB0aGVyZSBpcyBzb21lIGtpbmQNCj4gb2YgIm1pbmlmdyIgYXMg
d2VsbA0KPiBpbiB0aGUgbGludXgtZmlybXdhcmUgdHJlZSBbM10uIEkgZm91bmQgbm8gZGVzY3Jp
cHRpb24gb2YgaXQgLSBJIHdvdWxkDQo+IGxpa2UgdG8gbGVhcm4gd2hhdA0KPiBhcmUgdGhlIGZl
YXR1cmVzIGFuZCBsaW1pdGF0aW9ucyBvZiB0aGlzICJtaW5pZnciLg0KPg0KQWN0dWFsbHksIGZy
b20gdGhlIHBlcnNwZWN0aXZlIG9mIHdoYXQgdGhhdCBmaXJtd2FyZSBub3JtYWxseSBkb2VzLCBp
dCBkb2VzIG5vdCBoYXZlIGFueSBmZWF0dXJlcw0KYXQgYWxsIDotKSBPaywgZXhjZXB0IGZvciBj
YWNoZSBpbnZhbGlkYXRlcywgd2hpY2ggdGhlIEVJUC0xOTcgcmVxdWlyZXMuDQpJdCBqdXN0IGJ5
cGFzc2VzIGV2ZXJ5dGhpbmcgZnJvbSB0aGUgaW5wdXRzIHRvIHRoZSBpbnRlcm5hbCBjcnlwdG8g
ZW5naW5lLCBlZmZlY3RpdmVseSB0dXJuaW5nIHRoZQ0KRUlQLTE5NyBpbnRvIGFuIEVJUC05NyB3
aXRoIGNhY2hlcyAmIHByZWZldGNoaW5nLg0KDQpCdXQgdGhhdCdzIE9LIGZvciB0aGUgTGludXgg
a2VybmVsIGRyaXZlciwgYmVjYXVzZSB0aGF0IHdhcyB1c2luZyB0aGUgRUlQLTE5NyBpbiBFSVAt
OTcgYmFja3dhcmQNCmNvbXBhdGliaWxpdHkgbW9kZSBhbnl3YXkuIEl0IGRvZXMgbm90IHN1cHBv
cnQgYW55IGFkdmFuY2VkIEVJUC0xOTcgZmlybXdhcmUgZmVhdHVyZXMuDQpTbyBmcm9tIHRoZSBw
ZXJzcGVjdGl2ZSBvZiB0aGUgY3VycmVudCBMaW51eCBkcml2ZXI6IG5vIGxpbWl0YXRpb25zLg0K
DQo+IEkgc3RhcnRlZCB3aXRoIHVzaW5nIGl0IG9uIHRoZSBEZWJpYW4gaW1hZ2UgZnJvbSBib2Fy
ZCB2ZW5kb3IgWzJdLiBUaGUNCj4ga2VybmVsIGhlcmUgaXMNCj4gNS4xLjAuIFRoZSBmaXJtd2Fy
ZSBpcyBsb2FkZWQsIGJ1dCB0aGUgQUxHIHRlc3RzIGFyZSBhbGwgZmFpbGluZzoNCj4NCj4gWzE0
Nzg1Ljc1MDI0Nl0gY3J5cHRvLXNhZmV4Y2VsIGYyODAwMDAwLmNyeXB0bzogZmlybXdhcmU6IGRp
cmVjdC1sb2FkaW5nDQo+IGZpcm13YXJlIGluc2lkZS1zZWN1cmUvZWlwMTk3Yi9pZnBwLmJpbg0K
PiBbMTQ3ODUuNzYyNzY1XSBjcnlwdG8tc2FmZXhjZWwgZjI4MDAwMDAuY3J5cHRvOiBmaXJtd2Fy
ZTogZGlyZWN0LWxvYWRpbmcNCj4gZmlybXdhcmUgaW5zaWRlLXNlY3VyZS9laXAxOTdiL2lwdWUu
YmluDQo+IFsxNDc4NS43Nzc5NzhdIGFsZzogc2tjaXBoZXI6IHNhZmV4Y2VsLWNiYy1kZXMgZW5j
cnlwdGlvbiB0ZXN0IGZhaWxlZA0KPiAod3Jvbmcgb3V0cHV0IElWKSBvbiB0ZXN0IHZlY3RvciAw
LCBjZmc9ImluLXBsYWNlIg0KPiBbMTQ3ODUuNzg4NjYxXSAwMDAwMDAwMDogZmUgZGMgYmEgOTgg
NzYgNTQgMzIgMTANCj4gWzE0Nzg1LjgwMDYwNl0gYWxnOiBza2NpcGhlcjogc2FmZXhjZWwtY2Jj
LWRlczNfZWRlIGVuY3J5cHRpb24gdGVzdA0KPiBmYWlsZWQgKHdyb25nIG91dHB1dCBJVikgb24g
dGVzdCB2ZWN0b3IgMCwgY2ZnPSJpbi1wbGFjZSINCj4gWzE0Nzg1LjgxMTcyMF0gMDAwMDAwMDA6
IDdkIDMzIDg4IDkzIDBmIDkzIGIyIDQyDQo+IFsxNDc4NS44MjM3MzRdIGFsZzogc2tjaXBoZXI6
IHNhZmV4Y2VsLWNiYy1hZXMgZW5jcnlwdGlvbiB0ZXN0IGZhaWxlZA0KPiAod3Jvbmcgb3V0cHV0
IElWKSBvbiB0ZXN0IHZlY3RvciAwLCBjZmc9ImluLXBsYWNlIg0KPiBbMTQ3ODUuODM0NDM5XSAw
MDAwMDAwMDogM2QgYWYgYmEgNDIgOWQgOWUgYjQgMzAgYjQgMjIgZGEgODAgMmMgOWYgYWMgNDEN
Cj4gWzE0Nzg1Ljg4NDU2OF0gYWxnOiBoYXNoOiBzYWZleGNlbC1obWFjLXNoYTIyNCB0ZXN0IGZh
aWxlZCAod3JvbmcNCj4gcmVzdWx0KSBvbiB0ZXN0IHZlY3RvciAzLCBjZmc9ImluaXQrdXBkYXRl
K3VwZGF0ZStmaW5hbCB0d28gZXZlbiBzcGxpdHMiDQo+IFsxNDc4NS45MDE4MzZdIGFsZzogaGFz
aDogc2FmZXhjZWwtaG1hYy1zaGEyNTYgdGVzdCBmYWlsZWQgKHdyb25nDQo+IHJlc3VsdCkgb24g
dGVzdCB2ZWN0b3IgMiwgY2ZnPSJpbXBvcnQvZXhwb3J0Ig0KPiBbMTQ3ODUuOTI2NjkzXSBhbGc6
IGFlYWQ6IHNhZmV4Y2VsLWF1dGhlbmMtaG1hYy1zaGExLWNiYy1hZXMgZW5jcnlwdGlvbg0KPiB0
ZXN0IGZhaWxlZCAod3JvbmcgcmVzdWx0KSBvbiB0ZXN0IHZlY3RvciAwLCBjZmc9Im1pc2FsaWdu
ZWQgc3BsaXRzDQo+IGNyb3NzaW5nIHBhZ2VzLCBpbnBsYWNlIg0KPiBbMTQ3ODUuOTQ0NDMwXSBh
bGc6IE5vIHRlc3QgZm9yIGF1dGhlbmMoaG1hYyhzaGEyMjQpLGNiYyhhZXMpKQ0KPiAoc2FmZXhj
ZWwtYXV0aGVuYy1obWFjLXNoYTIyNC1jYmMtYWVzKQ0KPiBbMTQ3ODUuOTU2OTc4XSBhbGc6IGFl
YWQ6IHNhZmV4Y2VsLWF1dGhlbmMtaG1hYy1zaGEyNTYtY2JjLWFlcw0KPiBlbmNyeXB0aW9uIHRl
c3QgZmFpbGVkICh3cm9uZyByZXN1bHQpIG9uIHRlc3QgdmVjdG9yIDAsIGNmZz0idHdvIGV2ZW4N
Cj4gYWxpZ25lZCBzcGxpdHMiDQo+IFsxNDc4NS45NzM0NzJdIGFsZzogTm8gdGVzdCBmb3IgYXV0
aGVuYyhobWFjKHNoYTM4NCksY2JjKGFlcykpDQo+IChzYWZleGNlbC1hdXRoZW5jLWhtYWMtc2hh
Mzg0LWNiYy1hZXMpDQo+IFsxNDc4NS45ODYxMDNdIGFsZzogYWVhZDogc2FmZXhjZWwtYXV0aGVu
Yy1obWFjLXNoYTUxMi1jYmMtYWVzDQo+IGVuY3J5cHRpb24gdGVzdCBmYWlsZWQgKHdyb25nIHJl
c3VsdCkgb24gdGVzdCB2ZWN0b3IgMCwgY2ZnPSJ0d28gZXZlbg0KPiBhbGlnbmVkIHNwbGl0cyIN
Cj4NCk9rLCB0aGF0IGlzIHVuZXhwZWN0ZWQuIEFsdGhvdWdoIEkga25vdyB0aGVyZSBpcyBvbmUg
cGFydGljdWxhciBrZXJuZWwgdmVyc2lvbiB0aGF0IHdhcyBicm9rZW4uDQpTbyB5b3UgbWlnaHQg
d2FudCB0byB0cnkgYSBzbGlnaHRseSBuZXdlciBvbmUuDQooSSdkIGxvdmUgdG8gdHJ5IDUuMSBt
eXNlbGYgYnV0IEkgZG9uJ3QgaGF2ZSBhY2Nlc3MgdG8gdGhlIGhhcmR3YXJlIHJpZ2h0IG5vdywg
d29ya2luZyBmcm9tIGhvbWUpDQoNCj4NCj4gSSBhbSBnb2luZyB0byB0ZXN0IGl0IHdpdGggbW9y
ZSByZWNlbnQsIG1haW5saW5lIGtlcm5lbCBhcyB3ZWxsLCBidXQgaXQNCj4gd291bGQgYmUgc3Rp
bGwgbmljZSB0byBsZWFybg0KPiBhIGxpdHRsZSBiaXQgbW9yZSBhYm91dCB0aGlzICJtaW5pZnci
LCBpdCdzIGZlYXR1cmVzLCBhbmQgd2hhdCBjb3VsZCBiZQ0KPiBwb3NzaWJseSBhY2hpZXZlZCBv
biB0aGlzDQo+IGJvYXJkIHdpdGhvdXQgcHJvcHJpZXRhcnkgKGFuZCBiZWhpbmQgTkRBKSBjcnlw
dG8gZmlybXdhcmUuDQo+DQpFdmVyeXRoaW5nIHRoZSBrZXJuZWwgZHJpdmVyIGN1cnJlbnRseSBz
dXBwb3J0cy4NClRoZSByZWFsIGZpcm13YXJlIGlzIGZvciBkb2luZyBmdWxsIHByb3RvY29sIG9m
ZmxvYWQgKGxpa2UgSVBzZWMsIERUTFMsIGV0Yy4pIHdoaWNoIHRoZSBMaW51eCBrZXJuZWwNCmRv
ZXMgbm90IGN1cnJlbnRseSBzdXBwb3J0IGFueXdheS4gKHVuZm9ydHVuYXRlbHksIEkgbWlnaHQg
YWRkKQ0KDQo+IFRoYW5rIHlvdSwNCj4NCj4NCj4gWzFdDQo+IGh0dHBzOi8vd3d3LnNvbGlkLXJ1
bi5jb20vZW1iZWRkZWQtbmV0d29ya2luZy9tYXJ2ZWxsLWFybWFkYS1mYW1pbHkvY2xlYXJmb2ct
Z3QtOGsvDQo+IFsyXSBodHRwczovL2ltYWdlcy5zb2xpZC1idWlsZC54eXovODA0MC9EZWJpYW4v
DQo+IFszXQ0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9maXJtd2FyZS9saW51eC1maXJtd2FyZS5naXQvY29tbWl0L2luc2lkZS0NCj4gc2VjdXJlL2Vp
cDE5N19taW5pZncvaWZwcC5iaW4/aWQ9ZWVmYjVmNzQxMDE1MGMwMGQwYWI1YzQxYzVkODE3YWU5
YmY0NDliMw0KPg0KPiAtLQ0KPiBNYWNpZWogUGlqYW5vd3NraQ0KPiBFbWJlZGRlZCBTeXN0ZW1z
IEVuZ2luZWVyDQo+IEdQRzogOTk2M0MzNkFBQzNCMkI0Ng0KPiBodHRwczovLzNtZGViLmNvbSB8
IEAzbWRlYl9jb20NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBB
cmNoaXRlY3QgTXVsdGktUHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5DQpSYW1idXMg
Uk9UVyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5zaWRlIFNlY3Vy
ZS9WZXJpbWF0cml4IFNpbGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWlyZWQgYnkgUmFt
YnVzLg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFkZHJlc3MgYm9v
ayB3aXRoIG15IG5ldyBlLW1haWwgYWRkcmVzcy4NCg0KDQoqKiBUaGlzIG1lc3NhZ2UgYW5kIGFu
eSBhdHRhY2htZW50cyBhcmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBp
ZW50KHMpLiBJdCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZpZGVudGlhbCBh
bmQgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBvZiB0
aGlzIG1lc3NhZ2UsIHlvdSBhcmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5nLCBm
b3J3YXJkaW5nIG9yIHNhdmluZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQgYXR0
YWNobWVudHMgYW5kIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KDQpSYW1idXMg
SW5jLjxodHRwOi8vd3d3LnJhbWJ1cy5jb20+DQo=

