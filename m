Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D88C3F2D2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 08:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21BD5246A1
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 08:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="dZzMtOgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCBIdO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:33:14 -0500
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:49870 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgCBIdO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 03:33:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1583137991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttl+70BQd0fheyHjqpEEVI4ZwMYNkmAUu45zpIG1vT4=;
        b=dZzMtOgT1JhU7X9MUKfqvcMnKtxXXJm67J1x5RnvbktjnmSTD3hlbxOn1CC47ZmBYo3mQJ
        S68/WqbCKgXUdW9AekYgzOSTrPUMxLXOGSNeHqK+uAPaPui4JIzcj1lCKlC4K5YidxfaPE
        TBj9Bjo7K+1fU12FLg62WkfVYtHRPac=
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-w5ecXHDmMvq-EBqsuxT3LA-1; Mon, 02 Mar 2020 03:33:07 -0500
X-MC-Unique: w5ecXHDmMvq-EBqsuxT3LA-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3524.namprd04.prod.outlook.com
 (2603:10b6:910:93::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Mon, 2 Mar
 2020 08:33:04 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda%3]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 08:33:03 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Andrei Botila <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] crypto: xts - limit accepted key length
Thread-Topic: [RFC] crypto: xts - limit accepted key length
Thread-Index: AQHV8Gr7c7FFE6Bn/kS7vrAYuVJAN6g09vgA
Date:   Mon, 2 Mar 2020 08:33:03 +0000
Message-ID: <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
In-Reply-To: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51afd906-be08-4c91-c972-08d7be84535f
x-ms-traffictypediagnostic: CY4PR0401MB3524:
x-microsoft-antispam-prvs: <CY4PR0401MB3524EAA074FCB16954DAB704C3E70@CY4PR0401MB3524.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(39840400004)(346002)(136003)(189003)(199004)(478600001)(8676002)(2906002)(66946007)(81166006)(86362001)(81156014)(9686003)(76116006)(66476007)(66446008)(66556008)(64756008)(4326008)(55016002)(54906003)(5660300002)(6506007)(53546011)(7696005)(52536014)(8936002)(110136005)(316002)(71200400001)(26005)(186003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3524;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EHAvptjar3fkwZ2g9cYQ/aEXbNrOQS3PPmFBiCOlrcd28t/l/Fq7DQHiClqj5kRJrhY1UOjQkEY3MMqme1Alynu3alrAnl02IvZOKKNQB5Irm7h9YJEYFOdGzHDyRJ7wWUZ+IAsUV9pHN665njk5iASW3DJ6/kq6o9Mri1Nj4pMvdxta0DUoUCJRTW65mzn7sr5//jKws+TEOJiXC6HFMaT52XPino32jPf5t0qQEiLeDZi7CFXcdaxcKqnrJ1NWZ/05nGZwRefiuHLqzLwpPOZsKl5izQZ98U3AcWjfQJ6gs+FEGFS1wPfVTiIoqGdhSd1Pe2g1sa+KKzaNnlBxbIMKVelZ+mJRWJyavd879bFAD8tol3EmOvAQFpEmyc2VxY0hYIo6AFcpx0Dj8A+hpPBCJj4Oh62IVdtl0imeBPVFOtuc3reUiuf/eRHUzh1I
x-ms-exchange-antispam-messagedata: ITGet9vEyMASvrUpsupyHQLlkdpxRCoRbBrWhzfti/KjgdFpLAXbFc9dTDFt842vedSnKoI2r22PDulgvROgXK7D6IY43tZZBVEK0/qYVH7ZxMT+I6/qIhYEvS5w7szqHG7y+GCPsexB2h5GowcjgQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51afd906-be08-4c91-c972-08d7be84535f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 08:33:03.8972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykyRCbKEn+VAZPN2Jm4Q17zf4S5wYrZmM2L7hq5Pg4Y9ThX3QCwCHnc+SH83inrJR3Sq8eZppIoiSjCxHdFTqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3524
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
ZWhhbGYgT2YgQW5kcmVpIEJvdGlsYQ0KPiBTZW50OiBNb25kYXksIE1hcmNoIDIsIDIwMjAgOTox
NiBBTQ0KPiBUbzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgRGF2
aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBb
UkZDXSBjcnlwdG86IHh0cyAtIGxpbWl0IGFjY2VwdGVkIGtleSBsZW5ndGgNCj4NCj4gPDw8IEV4
dGVybmFsIEVtYWlsID4+Pg0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBv
dXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZQ0KPiBzZW5kZXIvc2VuZGVyIGFkZHJl
c3MgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4NCj4NCj4gRnJvbTogQW5kcmVpIEJv
dGlsYSA8YW5kcmVpLmJvdGlsYUBueHAuY29tPg0KPg0KPiBDdXJyZW50bHkgaW4gWFRTIGdlbmVy
aWMgaW1wbGVtZW50YXRpb24gdGhlIHZhbGlkIGtleSBsZW5ndGggaXMNCj4gcmVwZXNlbnRlZCBi
eSBhbnkgbGVuZ3RoIHdoaWNoIGlzIGV2ZW4uIFRoaXMgaXMgYSBkZXZpYXRpb24gZnJvbQ0KPiB0
aGUgWFRTLUFFUyBzdGFuZGFyZCAoSUVFRSAxNjE5LTIwMDcpIHdoaWNoIGFsbG93cyBrZXlzIGVx
dWFsDQo+IHRvIHsyIHggMTZCLCAyIHggMzJCfSB0aGF0IGNvcnJlc3BvbmQgdG8gdW5kZXJseWlu
ZyBYVFMtQUVTLXsxMjgsIDI1Nn0NCj4gYWxnb3JpdGhtLiBYVFMtQUVTLTE5MiBpcyBub3Qgc3Vw
cG9ydGVkIGFzIG1lbnRpb25lZCBpbiBjb21taXQNCj4gYjY2YWQwYjdhYTkyICgiY3J5cHRvOiB0
Y3J5cHQgLSByZW1vdmUgQUVTLVhUUy0xOTIgc3BlZWQgdGVzdHMiKSkgb3INCj4gYW55IG90aGVy
IGxlbmd0aCBiZXNpZGUgdGhlc2UgdHdvIHNwZWNpZmllZC4NCj4NCj4gSWYgdGhpcyBtb2RpZmlj
YXRpb24gaXMgYWNjZXB0ZWQgdGhlbiBvdGhlciBjaXBoZXJzIHRoYXQgdXNlIFhUUyBtb2RlDQo+
IHdpbGwgaGF2ZSB0byBiZSBtb2RpZmllZCAoY2FtZWxsaWEsIGNhc3Q2LCBzZXJwZW50LCB0d29m
aXNoKS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmVpIEJvdGlsYSA8YW5kcmVpLmJvdGlsYUBu
eHAuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvY3J5cHRvL3h0cy5oIHwgMTMgKysrKysrKy0tLS0t
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4N
Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvY3J5cHRvL3h0cy5oIGIvaW5jbHVkZS9jcnlwdG8veHRz
LmgNCj4gaW5kZXggMGY4ZGJhNjlmZWI0Li4yNmU3NjRhNWFlNDYgMTAwNjQ0DQo+IC0tLSBhL2lu
Y2x1ZGUvY3J5cHRvL3h0cy5oDQo+ICsrKyBiL2luY2x1ZGUvY3J5cHRvL3h0cy5oDQo+IEBAIC00
LDYgKzQsNyBAQA0KPg0KPiAgI2luY2x1ZGUgPGNyeXB0by9iMTI4b3BzLmg+DQo+ICAjaW5jbHVk
ZSA8Y3J5cHRvL2ludGVybmFsL3NrY2lwaGVyLmg+DQo+ICsjaW5jbHVkZSA8Y3J5cHRvL2Flcy5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L2ZpcHMuaD4NCj4NCj4gICNkZWZpbmUgWFRTX0JMT0NLX1NJ
WkUgMTYNCj4gQEAgLTEyLDEwICsxMywxMCBAQCBzdGF0aWMgaW5saW5lIGludCB4dHNfY2hlY2tf
a2V5KHN0cnVjdCBjcnlwdG9fdGZtICp0Zm0sDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY29uc3QgdTggKmtleSwgdW5zaWduZWQgaW50IGtleWxlbikNCj4gIHsNCj4gICAgICAg
ICAvKg0KPiAtICAgICAgICAqIGtleSBjb25zaXN0cyBvZiBrZXlzIG9mIGVxdWFsIHNpemUgY29u
Y2F0ZW5hdGVkLCB0aGVyZWZvcmUNCj4gLSAgICAgICAgKiB0aGUgbGVuZ3RoIG11c3QgYmUgZXZl
bi4NCj4gKyAgICAgICAgKiBrZXkgY29uc2lzdHMgb2Yga2V5cyBvZiBlcXVhbCBzaXplIGNvbmNh
dGVuYXRlZCwgcG9zc2libGUNCj4gKyAgICAgICAgKiB2YWx1ZXMgYXJlIDMyIG9yIDY0IGJ5dGVz
Lg0KPiAgICAgICAgICAqLw0KPiAtICAgICAgIGlmIChrZXlsZW4gJSAyKQ0KPiArICAgICAgIGlm
IChrZXlsZW4gIT0gMiAqIEFFU19NSU5fS0VZX1NJWkUgJiYga2V5bGVuICE9IDIgKiBBRVNfTUFY
X0tFWV9TSVpFKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+DQo+ICAgICAg
ICAgLyogZW5zdXJlIHRoYXQgdGhlIEFFUyBhbmQgdHdlYWsga2V5IGFyZSBub3QgaWRlbnRpY2Fs
ICovDQo+IEBAIC0yOSwxMCArMzAsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgeHRzX3ZlcmlmeV9r
ZXkoc3RydWN0IGNyeXB0b19za2NpcGhlciAqdGZtLA0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBjb25zdCB1OCAqa2V5LCB1bnNpZ25lZCBpbnQga2V5bGVuKQ0KPiAgew0KPiAg
ICAgICAgIC8qDQo+IC0gICAgICAgICoga2V5IGNvbnNpc3RzIG9mIGtleXMgb2YgZXF1YWwgc2l6
ZSBjb25jYXRlbmF0ZWQsIHRoZXJlZm9yZQ0KPiAtICAgICAgICAqIHRoZSBsZW5ndGggbXVzdCBi
ZSBldmVuLg0KPiArICAgICAgICAqIGtleSBjb25zaXN0cyBvZiBrZXlzIG9mIGVxdWFsIHNpemUg
Y29uY2F0ZW5hdGVkLCBwb3NzaWJsZQ0KPiArICAgICAgICAqIHZhbHVlcyBhcmUgMzIgb3IgNjQg
Ynl0ZXMuDQo+ICAgICAgICAgICovDQo+IC0gICAgICAgaWYgKGtleWxlbiAlIDIpDQo+ICsgICAg
ICAgaWYgKGtleWxlbiAhPSAyICogQUVTX01JTl9LRVlfU0laRSAmJiBrZXlsZW4gIT0gMiAqIEFF
U19NQVhfS0VZX1NJWkUpDQo+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4NCj4g
ICAgICAgICAvKiBlbnN1cmUgdGhhdCB0aGUgQUVTIGFuZCB0d2VhayBrZXkgYXJlIG5vdCBpZGVu
dGljYWwgKi8NCj4gLS0NCj4gMi4xNy4xDQoNCkhtbSAuLi4gaW4gcHJpbmNpcGxlIElFRUUtMTYx
OSBhbHNvIGRlZmluZXMgWFRTICpvbmx5KiBmb3IgQUVTLiBTbyBieSB0aGF0ICBzYW1lDQpyZWFz
b25pbmcsIHlvdSBzaG91bGQgYWxzbyBub3QgYWxsb3cgYW55IHVzYWdlIG9mIFhUUyBiZXlvbmQg
QUVTLiBZZXQgaXQgaXMNCmFjdHVhbGx5IGJlaW5nIGFjdGl2ZWx5IHVzZWQoPykgd2l0aCBvdGhl
ciBjaXBoZXJzIGluIHRoZSBMaW51eCBrZXJuZWwuIFdoaWNoIGlzDQpub3Qgd3JvbmcgcGVyc2Us
IGFzIHRoZSBjb25zdHJ1Y3Qgd29ya3Mgd2l0aCBhbnkgYmxvY2sgY2lwaGVyIHdpdGggYSAxMjgg
Yml0DQpibG9jayBzaXplLiBBbmQgaXMgc2VjdXJlIGFzIGxvbmcgYXMgdGhhdCBibG9ja2NpcGhl
ciBpcyBzZWN1cmUuDQoNClNvIHdoeSBub3QgYWxsb3cgMTkyIGJpdCBBRVMga2V5cz8gT3Igc29t
ZSBrZXlzaXplIHRoYXQgc29tZSBvdGhlciBhbGdvcml0aG0NCm1heSByZXF1aXJlLCBhcyBJJ20g
bm90IHN1cmUgYWxsIGNpcGhlcnMgaXQgaXMgdXNlZCB3aXRoIGhhdmUgMTI4IG9yIDI1NiBiaXQg
a2V5cy4NCg0KVGhlIG1vZHVsbyAyIGNoZWNrIHdhcyBqdXN0IHRvIGVuc3VyZSB5b3UgaW5kZWVk
IHByb3ZpZGVkIDIgZnVsbCBjaXBoZXIga2V5cywNCmFueSBvdGhlciBlcnJvciBjaGVja2luZyB3
YXMgZGVmZXJyZWQgdG8gdGhlIGNpcGhlciBhbGdvcml0aG0ncyBzZXRrZXkuDQoNCk5vdGUgdGhh
dCBzdWNoIGEgY2hhbmdlIHdvdWxkIGFsc28gYWxsb3cgYWxsIGhhcmR3YXJlIGRyaXZlcnMgaW1w
bGVtZW50aW5nDQp4dHMgdG8gZm9sbG93IHN1aXQgYW5kIHJlcG9ydCBhbiBlcnJvciwgb3RoZXJ3
aXNlIHRoZXkgd2lsbCBmYWlsIHRoZSBzZWxmdGVzdHMgLi4uDQoNClJlZ2FyZHMsDQpQYXNjYWwg
dmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0IE11bHRpLVByb3RvY29sIEVuZ2luZXMs
IFJhbWJ1cyBTZWN1cml0eQ0KUmFtYnVzIFJPVFcgSG9sZGluZyBCVg0KKzMxLTczIDY1ODE5NTMN
Cg0KTm90ZTogVGhlIEluc2lkZSBTZWN1cmUvVmVyaW1hdHJpeCBTaWxpY29uIElQIHRlYW0gd2Fz
IHJlY2VudGx5IGFjcXVpcmVkIGJ5IFJhbWJ1cy4NClBsZWFzZSBiZSBzbyBraW5kIHRvIHVwZGF0
ZSB5b3VyIGUtbWFpbCBhZGRyZXNzIGJvb2sgd2l0aCBteSBuZXcgZS1tYWlsIGFkZHJlc3MuDQoN
Cg0KKiogVGhpcyBtZXNzYWdlIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGZvciB0aGUgc29sZSB1
c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gSXQgbWF5IGNvbnRhaW4gaW5mb3JtYXRp
b24gdGhhdCBpcyBjb25maWRlbnRpYWwgYW5kIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRo
ZSBpbnRlbmRlZCByZWNpcGllbnQgb2YgdGhpcyBtZXNzYWdlLCB5b3UgYXJlIHByb2hpYml0ZWQg
ZnJvbSBwcmludGluZywgY29weWluZywgZm9yd2FyZGluZyBvciBzYXZpbmcgaXQuIFBsZWFzZSBk
ZWxldGUgdGhlIG1lc3NhZ2UgYW5kIGF0dGFjaG1lbnRzIGFuZCBub3RpZnkgdGhlIHNlbmRlciBp
bW1lZGlhdGVseS4gKioNCg0KUmFtYnVzIEluYy48aHR0cDovL3d3dy5yYW1idXMuY29tPg0K

