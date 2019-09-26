Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65DFC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD3D222C6
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="gSX7O0XH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfIZODc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:03:32 -0400
Received: from mail-eopbgr760051.outbound.protection.outlook.com ([40.107.76.51]:20039
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbfIZODc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 10:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f95nCPNlc6WSxP8TGd2JG0l54+ktxh+yTxxrb7l6Usk0lhXKuLpV4wdrTD6hWjO6pJERhpc25SBxtEARssXkJcpNiMw5KnWnKhjcTr/fSDwt5qhLzHZpJjA/TBgRSN4JABCmO/u3lMwxzSFbqpuUSWzcPQd5ua6MSO4BTJcg7awaGPqJ/GGO0Tb8inpgLVCRoo0+M14473ZdNWuqWgCEEKJ1FDd9WmdjxEyNIET3FLohWVDUvEzL9kpDK9h0ThUhoYodAex+HHaWTPrPpuRIcWfSU9wKmPGvUVKLmM4ulRFnViedfLSjr47itFrWVg41JdDGtIS+TuXCWoC8BIR/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8bzlXYurZZNA/1jc9g1IgsvSMq3rev7stjFF0KSlRs=;
 b=UKjwXuUGddwdCJh5C/ULIo20TrkUJkcax2qS6r4rT6TS2abMVXesi5w2mNbfa4XRw8bQh2c/2AgGfW3PIbBp64o68R80hM96PE0wHs7t46M6AMIz/V4fAHSskwE63U2TADn/wsefDAGayh3LBGzmlNYHXmzQnI8Hwb8gkJZ0ufVHvhEy+QjwnqAtA2nmB5Khwhmkh6osp5Pkric0mUwfQ36vma8VzL8f93CoeSXnDOal6ty5NR0amMBub6aRY2JXjXB7d4kL4J0sDdthirINEMBzl3+W3a7Pr9oOXgZLYRmPyYpZ/dhuVs5QWzDzScMEcBrgZu/OtfPV1iRHEdXUnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8bzlXYurZZNA/1jc9g1IgsvSMq3rev7stjFF0KSlRs=;
 b=gSX7O0XHWdBQ5671Ff7pBoPW/Lhi6aG3UzYb5Jnsz0eedgj9MDeHT4S2HbvVRBsQ8f5Swkjo3syuMb9nLehyM5UP8cFc5lEvBRYFGSaxpZBwmECNmxOUD1NNCWEVMRmEW99DhkaqXjfjnIibGwVe+0FY/8cQnRCCcpRCiKJVWxE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2286.namprd20.prod.outlook.com (20.179.145.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 26 Sep 2019 14:03:27 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 14:03:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
Thread-Topic: [RFC PATCH 00/18] crypto: wireguard using the existing crypto
 API
Thread-Index: AQHVc7w6foOeRxVj+U6Yc++T56fqIac9qd4AgAA0kYCAAAbroIAADDgAgAAKvfA=
Date:   Thu, 26 Sep 2019 14:03:27 +0000
Message-ID: <MN2PR20MB297313B598D8EBBE06477B1CCA860@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
 <MN2PR20MB29731267C4670FBD46D6C743CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_eNK1HFxTY379kpCpF8FQQFHEdC1Th=s5f7Fy3bebOjQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_eNK1HFxTY379kpCpF8FQQFHEdC1Th=s5f7Fy3bebOjQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04442e2a-1aa7-4863-d6ae-08d7428a4e06
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2286;
x-ms-traffictypediagnostic: MN2PR20MB2286:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2286B38051A5B4F202D8D96ACA860@MN2PR20MB2286.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(366004)(39850400004)(396003)(199004)(189003)(13464003)(54906003)(66946007)(102836004)(52536014)(305945005)(256004)(7736002)(15974865002)(53546011)(7416002)(14444005)(26005)(8936002)(476003)(6916009)(33656002)(8676002)(11346002)(14454004)(186003)(446003)(71200400001)(71190400001)(5660300002)(486006)(66066001)(81166006)(81156014)(66556008)(66476007)(6246003)(2906002)(74316002)(4326008)(478600001)(6506007)(7696005)(86362001)(99286004)(76176011)(6116002)(229853002)(55016002)(316002)(66446008)(76116006)(3846002)(64756008)(6436002)(9686003)(25786009)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2286;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fR6bQQmyjPCeVva9OWphj2Tg4vSSsAmEIvKqknlBi2sODLQl/HK5OAnfITU8FpLZvEcUqC4rGNlSVl8ZqYEIXITQ6ruR+U+qY8kK3mgNr7dGX95tWPJYRPEE7dpFTUqej6l3qqaat2m5AdBocct/JoeqmcZieamNYxVkd3bLldwB95bvVtAi9xHWtBCdtg0Civ71PHM41OToIHX67LhVLgqR3uOANL4PxcIEILFCl6C5rsC4+5DAtQ0l3McGDv5bd/W+yzEiQlIZ2T4kcykODLndzI4eFT+Z1B4lJCk4/ahfRcqM8zcUg90JeFde6nTMvELukR0hxJiR3r9QWyriCYo/xis4CNuokTMIFbPk4rW0CgGWTxkBF4ZY6SdppbiAbw0JzHXQnriDlUL6HiEH7G8Sk8NWJ4NSTk+IH014pTY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04442e2a-1aa7-4863-d6ae-08d7428a4e06
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 14:03:27.6696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lXYVUnGMZOvjiG7RDjMCjNbJlqqZ4tlZ8ED3ZK5V2/ubgl6pNOGpY/hztQLAXtNUgiNclpLZGN2dIwpCepj4kczGKuY5wgtEt3KVVnn+bC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2286
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAyNiwg
MjAxOSAzOjE2IFBNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmlt
YXRyaXguY29tPg0KPiBDYzogSmFzb24gQS4gRG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5jb20+OyBM
aW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9y
Zz47IGxpbnV4LWFybS1rZXJuZWwgPGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
Zz47DQo+IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIE1p
bGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEdyZWcgS0gNCj4gPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPjsgTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3Jn
PjsgU2FtdWVsDQo+IE5ldmVzIDxzbmV2ZXNAZGVpLnVjLnB0PjsgRGFuIENhcnBlbnRlciA8ZGFu
LmNhcnBlbnRlckBvcmFjbGUuY29tPjsgQXJuZCBCZXJnbWFubg0KPiA8YXJuZEBhcm5kYi5kZT47
IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT47IEFuZHkgTHV0b21pcnNraSA8bHV0
b0BrZXJuZWwub3JnPjsNCj4gV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz47IE1hcmMgWnlu
Z2llciA8bWF6QGtlcm5lbC5vcmc+OyBDYXRhbGluIE1hcmluYXMNCj4gPGNhdGFsaW4ubWFyaW5h
c0Bhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAwMC8xOF0gY3J5cHRvOiB3aXJl
Z3VhcmQgdXNpbmcgdGhlIGV4aXN0aW5nIGNyeXB0byBBUEkNCj4gDQo+IE9uIFRodSwgMjYgU2Vw
IDIwMTkgYXQgMTU6MDYsIFBhc2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5AdmVyaW1h
dHJpeC5jb20+IHdyb3RlOg0KPiAuLi4NCj4gPiA+DQo+ID4gPiBNeSBwcmVmZXJlbmNlIHdvdWxk
IGJlIHRvIGFkZHJlc3MgdGhpcyBieSBwZXJtaXR0aW5nIHBlci1yZXF1ZXN0IGtleXMNCj4gPiA+
IGluIHRoZSBBRUFEIGxheWVyLiBUaGF0IHdheSwgd2UgY2FuIGluc3RhbnRpYXRlIHRoZSB0cmFu
c2Zvcm0gb25seQ0KPiA+ID4gb25jZSwgYW5kIGp1c3QgaW52b2tlIGl0IHdpdGggdGhlIGFwcHJv
cHJpYXRlIGtleSBvbiB0aGUgaG90IHBhdGggKGFuZA0KPiA+ID4gYXZvaWQgYW55IHBlci1rZXlw
YWlyIGFsbG9jYXRpb25zKQ0KPiA+ID4NCj4gPiBUaGlzIHBhcnQgSSBkbyBub3QgcmVhbGx5IHVu
ZGVyc3RhbmQuIFdoeSB3b3VsZCB5b3UgbmVlZCB0byBhbGxvY2F0ZSBhDQo+ID4gbmV3IHRyYW5z
Zm9ybSBpZiB5b3UgY2hhbmdlIHRoZSBrZXk/IFdoeSBjYW4ndCB5b3UganVzdCBjYWxsIHNldGtl
eSgpDQo+ID4gb24gdGhlIGFscmVhZHkgYWxsb2NhdGVkIHRyYW5zZm9ybT8NCj4gPg0KPiANCj4g
QmVjYXVzZSB0aGUgc2luZ2xlIHRyYW5zZm9ybSB3aWxsIGJlIHNoYXJlZCBiZXR3ZWVuIGFsbCB1
c2VycyBydW5uaW5nDQo+IG9uIGRpZmZlcmVudCBDUFVzIGV0YywgYW5kIHNvIHRoZSBrZXkgc2hv
dWxkIG5vdCBiZSBwYXJ0IG9mIHRoZSBURk0NCj4gc3RhdGUgYnV0IG9mIHRoZSByZXF1ZXN0IHN0
YXRlLg0KPiANClNvIHlvdSBuZWVkIGEgdHJhbnNmb3JtIHBlciB1c2VyLCBzdWNoIHRoYXQgZWFj
aCB1c2VyIGNhbiBoYXZlIGhpcyBvd24NCmtleS4gQnV0IHlvdSBzaG91bGRuJ3QgbmVlZCB0byBy
ZWFsbG9jYXRlIGl0IHdoZW4gdGhlIHVzZXIgY2hhbmdlcyBoaXMNCmtleS4gSSBhbHNvIGRvbid0
IHNlZSBob3cgdGhlICJkaWZmZXJlbnQgQ1BVcyIgaXMgcmVsZXZhbnQgaGVyZT8gSSBjYW4NCnNo
YXJlIGEgc2luZ2xlIGtleSBhY3Jvc3MgbXVsdGlwbGUgQ1BVcyBoZXJlIGp1c3QgZmluZSAuLi4N
Cg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11
bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
