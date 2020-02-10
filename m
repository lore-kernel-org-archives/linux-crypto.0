Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A8AC352A4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 08:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F3F208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 08:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="LFsVrnq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgBJIFj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 03:05:39 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:23138 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgBJIFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 03:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1581321930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=evX3pVhU8Qbop22KDjAIyj6KN63O+CH3TMDI1IC/Czk=;
        b=LFsVrnq+qSK8WRuo5Abwfydfu+mvlrI7wBuYLXlu2BF/Q0CiU4qUYQwbErnjYR85o/1arC
        0E3SD5DqUGn+BDDoQJHaHU3HYu27Imfd5vbCRPJyHpWJfwEZ8+Hw2pdPy4659uwwKU435C
        Oo6NdpSqY8GtjttUeLTGOb6IPlgEiO8=
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-EkHzGhJ1MvCOt78QCLzzfg-1; Mon, 10 Feb 2020 03:05:29 -0500
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com (52.132.97.155) by
 CY4PR0401MB3587.namprd04.prod.outlook.com (52.132.99.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.27; Mon, 10 Feb 2020 08:05:26 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda%3]) with mapi id 15.20.2707.028; Mon, 10 Feb 2020
 08:05:27 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
CC:     Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: RE: Possible issue with new inauthentic AEAD in extended crypto tests
Thread-Topic: Possible issue with new inauthentic AEAD in extended crypto
 tests
Thread-Index: AQHV1Ohtfj6tA7gaZ0uNkoHJDpcQdaf/XTuAgAARvQCAAD8mgIAA510AgAwnTACAAqlrgIAACBWAgABYvKCAAs/JgIABkRbg
Date:   Mon, 10 Feb 2020 08:05:26 +0000
Message-ID: <CY4PR0401MB3652D991DB5576F89118326BC3190@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
 <20200207072709.GB8284@sol.localdomain>
 <70156395ce424f41949feb13fd9f978b@MN2PR20MB2973.namprd20.prod.outlook.com>
 <SN4PR0401MB366399E54E5B7EE0E54A7E0BC31C0@SN4PR0401MB3663.namprd04.prod.outlook.com>
 <CAOtvUMeFZXwxxYT1hz=e09CaBrv1qBXvWcRCghA=wRGwZZ9S3g@mail.gmail.com>
In-Reply-To: <CAOtvUMeFZXwxxYT1hz=e09CaBrv1qBXvWcRCghA=wRGwZZ9S3g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95f653aa-2254-4b0b-f3f5-08d7adfffd0e
x-ms-traffictypediagnostic: CY4PR0401MB3587:
x-microsoft-antispam-prvs: <CY4PR0401MB3587CAA5106EDF2B7B27B699C3190@CY4PR0401MB3587.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39840400004)(396003)(136003)(346002)(366004)(189003)(199004)(64756008)(9686003)(66556008)(6506007)(55016002)(53546011)(66446008)(186003)(76116006)(66946007)(316002)(52536014)(54906003)(66476007)(2906002)(33656002)(5660300002)(6916009)(71200400001)(81166006)(81156014)(26005)(86362001)(478600001)(8676002)(4326008)(8936002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3587;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2CW/qWmzz4gHcYfPJXKho0Jl8hm7RRmhENFcinuqW4PMllyM/NxMAUJTJxgTB/7DAm3vIGpGtfDi5pf+Ci7DIxFH3dgn1lO2GYoYDKTyNKdsCtuSmeOJRkG7O30e2cIGXeUIaX+U7943r64AbCRLZQDtAPDFR0Yg6RgRIMlLdafj2rFL7TVvu/HfP/htc7S3gvWbkq19Xe4sGiw/UkcW2znrW1fEa9J97ECWM0peIG7mLCBRbZTaOjCy7+VjImkU9JroNi7SHIIV0vUX+qbejfvX95hG/XPKQknxy09u5AqaTWpYWp8PgmfPneT8pl4vj4DdN6tJq7l/P2JAeuPy/EjN2ZOwWi3+90Mcw9t7ZuK5gLxcQY89F+gO4sq28gT7nh4jSTMUQJOq7xgH/q/PJZlcgjipzxXXcx9pcC2o02Zg11qAGc9LrwzulFrtinNv
x-ms-exchange-antispam-messagedata: Bh4NQ6YRs7cQ2V+1hL9g/3NUTy+PTc7Ri7JwzrxFF3ODmAU4mfRAVgtt1Aw8xgvYEETPdgFBumYR24YLvIF52k5Del4JnjPTB2wN1pRCaH020bJeNSRzJK/nTyDplrXF76Df5bcjElNF6+bkCBct6w==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f653aa-2254-4b0b-f3f5-08d7adfffd0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 08:05:26.9346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtRGg99G5j7GUqYvni1Gopq5FBubBX5NyJms6fz3urzxI5Yckp0Jywv9v7SufUZwVMRNSV8kjgWzlNaCSWTjaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3587
X-MC-Unique: EkHzGhJ1MvCOt78QCLzzfg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHaWxhZCBCZW4tWW9zc2VmIDxn
aWxhZEBiZW55b3NzZWYuY29tPg0KPiBTZW50OiBTdW5kYXksIEZlYnJ1YXJ5IDksIDIwMjAgOTox
MCBBTQ0KPiBUbzogVmFuIExlZXV3ZW4sIFBhc2NhbCA8cHZhbmxlZXV3ZW5AcmFtYnVzLmNvbT4N
Cj4gQ2M6IFN0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT47IEVyaWMgQmlnZ2Vy
cyA8ZWJpZ2dlcnNAa2VybmVsLm9yZz47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdT47DQo+IExpbnV4IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0b0B2Z2Vy
Lmtlcm5lbC5vcmc+OyBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPjsg
RGF2aWQgTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgT2ZpciBEcmFuZyA8T2Zpci5E
cmFuZ0Bhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogUG9zc2libGUgaXNzdWUgd2l0aCBuZXcgaW5h
dXRoZW50aWMgQUVBRCBpbiBleHRlbmRlZCBjcnlwdG8gdGVzdHMNCj4NCj4gPDw8IEV4dGVybmFs
IEVtYWlsID4+Pg0KPiBPbiBGcmksIEZlYiA3LCAyMDIwIGF0IDQ6MDcgUE0gVmFuIExlZXV3ZW4s
IFBhc2NhbA0KPiA8cHZhbmxlZXV3ZW5AcmFtYnVzLmNvbT4gd3JvdGU6DQo+DQo+ID4gVGhlICJw
cm9ibGVtIiBHaWxhZCB3YXMgcmVmZXJyaW5nIHRvIGlzIHRoYXQgdGhlIF9leHBsaWNpdF8gcGFy
dCBvZiB0aGUgIElWIGFwcGVhcnMgdG8gYmUNCj4gPiBhdmFpbGFibGUgIGZyb20gYm90aCByZXEt
Pml2IGFuZCBmcm9tIHRoZSBBQUQgc2NhdHRlcmJ1ZmZlci4gV2hpY2ggb25lIHNob3VsZCB5b3Ug
dXNlPw0KPiA+IEFQSSB3aXNlIEkgd291bGQgYXNzdW1lIHJlcS0+aXYgYnV0IGZyb20gYSAob3Vy
KSBoYXJkd2FyZSBwZXJzcGVjdGl2ZSwgaXQgd291bGQNCj4gPiBiZSBtb3JlIGVmZmljaWVudCB0
byBleHRyYWN0IGl0IGZyb20gdGhlIGRhdGFzdHJlYW0uIEJ1dCBpcyBpdCBhbGxvd2VkIHRvIGFz
c3VtZQ0KPiA+IHRoZXJlIGlzIGEgdmFsaWQgSVYgc3RvcmVkIHRoZXJlPyAod2hpY2ggaW1wbGll
cyB0aGF0IGl0IGhhcyB0byBtYXRjaCByZXEtPml2LA0KPiA+IG90aGVyd2lzZSBiZWhhdmlvdXIg
d291bGQgZGV2aWF0ZSBmcm9tIGltcGxlbWVudGF0aW9ucyB1c2luZyB0aGF0KQ0KPiA+DQo+DQo+
DQo+IE5vLCBpdCBpc24ndC4NCj4NCj4gVGhlIHByb2JsZW0gdGhhdCBJIHdhcyByZWZlcnJpbmcg
dG8gd2FzIHRoYXQgcGFydCBvZiBvdXIgdGVzdCBzdWl0ZXMNCj4gcGFzc2VzIGRpZmZlcmVudCB2
YWx1ZXMgaW4gcmVxLT5pdiBhbmQgYXMgcGFydCBvZiB0aGUgQUFELA0KPiBpbiBjb250cmFzdCB0
byB3aGF0IHdlIGRvY3VtZW50IGFzIHRoZSBBUEkgcmVxdWlyZW1lbnRzIGluIHRoZSBpbmNsdWRl
DQo+IGZpbGUsIG15IHVuZGVyc3RhbmRpbmcgb2YgdGhlIHJlbGV2YW50IHN0YW5kYXJkIGFuZA0K
PiB0aGUgc2luZ2xlIHVzZXJzIG9mIHRoaXMgQVBJIGluIHRoZSBrZXJuZWwgYW5kIHRoYXQgdGhl
IGRyaXZlciBJJ20NCj4gbWFpbnRhaW5pbmcgZmFpbHMgdGhlc2UgdGVzdHMsDQo+DQpCdXQgdGhh
dCdzIHRoZSBzYW1lIHByb2JsZW0uIElmIHRoZXkgd2VyZSBpZGVudGljYWwgaXQgZG9lc24ndCBt
YXR0ZXINCndoaWNoIG9uZSB5b3VyIGRyaXZlciB1c2VzLCBidXQgYmVjYXVzZSB0aGUgdGVzdHN1
aXRlIG5vdyBtYWtlcw0KdGhlbSB1bmVxdWFsIHlvdSBoYXZlIGEgcHJvYmxlbSBpZiB5b3UgaGFw
cGVuIHRvIHVzZSB0aGUgb3RoZXIgb25lLg0KDQo+IEknbSBhbGwgZmluZSB3aXRoIGdldHRpbmcg
bXkgaGFuZHMgZGlydHkgYW5kIGZpeGluZyB0aGUgZHJpdmVyLCBJJ20NCj4ganVzdCBzdXNwZWN0
IGZpeGluZyBhIGRyaXZlciB0byBwYXNzIGEgdGVzdCB0aGF0IG1pc3VzZXMgdGhlIEFQSQ0KPiBt
YXkgbm90IGFjdHVhbGx5IGltcHJvdmUgdGhlIHF1YWxpdHkgb2YgdGhlIGRyaXZlci4NCj4NCj4g
R2lsYWQNCg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hp
dGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RX
IEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1Zl
cmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMu
DQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdp
dGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0
dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQo
cykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBw
cml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMg
bWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndh
cmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2ht
ZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMu
PGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

