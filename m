Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC64C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 12:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F05922DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 12:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="WfhN3Iqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfHTMBn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 08:01:43 -0400
Received: from mail-eopbgr730084.outbound.protection.outlook.com ([40.107.73.84]:59930
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728657AbfHTMBm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 08:01:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHqBUQFh76t9onF/2vXVHvGQpmh3Zd0WgvUifgwiWlooJ1Kj3fuVoaRUS2f8ulwj5a499pjLmq8h7LE9+ytCSiFf2zlkpnOZi0WyB/0lHtdUKln/tyF57LdNLuZp53/o5Fb9Fzg+Ntn3yfpkXH85MLnyyiyWLoeb2Iu+MQ682BKubbl4+K35HoMyZTkDLJS8QpM2A4a83saj99cO2x7Gxfm/CBatKtzfxOxsPyL20BUeI3ntFqYCDuzZYU9FjeVJzCreEL9qQ13KRrZElGPDbSHdU/vxTfy+9SaZbgrQ6Vcn+mQYChLvZalKvZ0xek84zVlpPq3/VkTIGnvLHKe5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JImOHFUiOoREowg/KzSnUeUWuL06EcjTVSps9NGJGf4=;
 b=Syoq1XKdj+72JlRCYkLGE3XUPYGOPYUdHwNn3RHMZIXElPW8lSFLcq92tQp2v2CbfzPQyyq0YfTHgxIBeLQG4zUXyHbDPzuvs9JjOmd+LA5fimtQHD5ziYD+N7ZC5QUYIp1rIOQ/DBW4cNiMCiqvWd6aqBill4eXdS98IOBbsiJmAfgPv6CMSQAfhJwLaQtR01KNRnC0QiOwiNQcLcUlv4dEmR4AlMl5WtOL3gFe5zqKXqBfrhQ4GIHQ8hEqOv0x4bz32rZa4n/8zlRjAcL6LkM44wgMvyAXFkrapoBV6PaD5FyzuI9OzBFEWy4muYv81qx4mPyO8cLyl0cMOTHCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JImOHFUiOoREowg/KzSnUeUWuL06EcjTVSps9NGJGf4=;
 b=WfhN3IqtV4FNRTy3GJ4AFhXj7TqhGThqhPx7ysmMIB6y/K1YujZYvXTkftFnEd0/J3Z67HZKzlyfxlbci95Wog8ca7rsufQEvsPPvnuOUu5/xhPoaeOn/ksLbZk4Uaw6Ua+5nuHs60/MuagxanTQor0TWlXGS8iSF5j1YZAhzPo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2863.namprd20.prod.outlook.com (20.178.252.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 12:01:36 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 12:01:36 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Josh Boyer <jwboyer@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     Linux Firmware <linux-firmware@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
Thread-Topic: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
Thread-Index: AQHVTFYdBTGcyhV0m0CpxLDQb9nj26b8IaoAgAfeoqA=
Date:   Tue, 20 Aug 2019 12:01:36 +0000
Message-ID: <MN2PR20MB297310E2E089219DF583E6E5CAAB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
 <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com>
In-Reply-To: <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae50b478-a487-4d53-6267-08d7256626e4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2863;
x-ms-traffictypediagnostic: MN2PR20MB2863:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2863CAD831A4415598799203CAAB0@MN2PR20MB2863.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(13464003)(6506007)(478600001)(53546011)(76176011)(54906003)(110136005)(66066001)(4326008)(7696005)(14454004)(8676002)(102836004)(966005)(81156014)(81166006)(33656002)(15974865002)(8936002)(26005)(186003)(316002)(99286004)(229853002)(476003)(11346002)(446003)(76116006)(2906002)(6436002)(86362001)(9686003)(55016002)(6306002)(256004)(53936002)(3846002)(6116002)(25786009)(6246003)(486006)(71190400001)(71200400001)(66476007)(66446008)(64756008)(66556008)(66946007)(5660300002)(52536014)(74316002)(7736002)(305945005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2863;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W9reW7XquzFBgEauwlAZLAOK1J/vzf+NxmWfC8FhQzQ7EpVHdyKpaAqAoYLrBx0D/J1XeYUSKyQdn5C79R3mzoQCX+qChHJyoEIO4Pi4/LnvB3i1EU9O7b+Up2QY9ZQOH7wcFkEXW7xNvxqI8rC3kZLp25qZPm+kKQeeX9oXyh0KpL1dYmxrNgniJrO8wN0+n6CWB63spCvqXA0pIAFuI/YPFAHUk0JhOBbnQJnFR+meFbgP9hCytJ434eEVD+ydd8QS/Xz6S5ciXrpQt23Kj05+i7OtA8yQJp652w580JM3c7PnMc3nmbtfCcdRAPkh+sondnF+lpeFUgkqbefRRSRC1CWQ6Hu9jwN75AoehgqfvYpIYMoTrC2YaoB2Gf1hV1xBtpzMzmJIlC0/ZvcpzZll/Gum+4uOSDEF1hjOEPI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae50b478-a487-4d53-6267-08d7256626e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 12:01:36.4398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QNc6GKSXq5QRFdJH/1dmJwrNffrLXPsBCL5O1ieYVi0CmP+enwZKYUzMLNVUWDEjw+oQPOIKUd9iNKz+7hS0e89PauGCAwnSUXxUxzkfU4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2863
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YNCj4gSm9zaCBCb3llcg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDE1LCAyMDE5
IDE6MzMgUE0NCj4gVG86IFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+
DQo+IENjOiBMaW51eCBGaXJtd2FyZSA8bGludXgtZmlybXdhcmVAa2VybmVsLm9yZz47IGxpbnV4
LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtHSVQgUFVMTF0gaW5zaWRl
LXNlY3VyZTogYWRkIG5ldyBHUEx2MiAibWluaSIgZmlybXdhcmUgZm9yIHRoZSBFSVAxOTcgZHJp
dmVyDQo+IA0KPiBPbiBUdWUsIEF1ZyA2LCAyMDE5IGF0IDg6NTQgQU0gUGFzY2FsIHZhbiBMZWV1
d2VuIDxwYXNjYWx2YW5sQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGUgZm9sbG93aW5n
IGNoYW5nZXMgc2luY2UgY29tbWl0IGRmZjk4YzZjNTczODNmZTM0MzQwN2JjYjdiNmU3NzVlMGI4
NzI3NGY6DQo+ID4NCj4gPiAgIE1lcmdlIGJyYW5jaCAnbWFzdGVyJyBvZiBnaXQ6Ly9naXRodWIu
Y29tL3NrZWdnc2IvbGludXgtZmlybXdhcmUNCj4gPiAoMjAxOS0wNy0yNiAwNzozMjozNyAtMDQw
MCkNCj4gPg0KPiA+IGFyZSBhdmFpbGFibGUgaW4gdGhlIGdpdCByZXBvc2l0b3J5IGF0Og0KPiA+
DQo+ID4NCj4gPiAgIGh0dHBzOi8vZ2l0aHViLmNvbS9wdmFubGVldXdlbi9saW51eC1maXJtd2Fy
ZS1jbGVhbi5naXQgaXNfZHJpdmVyX2Z3DQo+ID4NCj4gPiBmb3IgeW91IHRvIGZldGNoIGNoYW5n
ZXMgdXAgdG8gZmJmZTQxZjkyZjk0MWQxOWI4NDBlYzBlMjgyZjQyMjM3OTk4MmNjYjoNCj4gPg0K
PiA+ICAgaW5zaWRlLXNlY3VyZTogYWRkIG5ldyBHUEx2MiAibWluaSIgZmlybXdhcmUgZm9yIHRo
ZSBFSVAxOTcgZHJpdmVyDQo+ID4gKDIwMTktMDgtMDYgMTM6MTk6NDQgKzAyMDApDQo+ID4NCj4g
PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gUGFzY2FsIHZhbiBMZWV1d2VuICgxKToNCj4gPiAgICAgICBpbnNpZGUt
c2VjdXJlOiBhZGQgbmV3IEdQTHYyICJtaW5pIiBmaXJtd2FyZSBmb3IgdGhlIEVJUDE5NyBkcml2
ZXINCj4gPg0KPiA+ICBXSEVOQ0UgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTAg
KysrKysrKysrKw0KPiA+ICBpbnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaWZwcC5iaW4gfCBC
aW4gMCAtPiAxMDAgYnl0ZXMNCj4gPiAgaW5zaWRlLXNlY3VyZS9laXAxOTdfbWluaWZ3L2lwdWUu
YmluIHwgQmluIDAgLT4gMTA4IGJ5dGVzDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5zaWRlLXNlY3VyZS9laXAxOTdfbWlu
aWZ3L2lmcHAuYmluDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbnNpZGUtc2VjdXJlL2VpcDE5
N19taW5pZncvaXB1ZS5iaW4NCj4gDQo+IElmIHRoaXMgaXMgR1BMdjIsIHdoZXJlIGlzIHRoZSBz
b3VyY2UgY29kZT8NCj4gDQpPaywgSSBhbSBub3QgYSBsYXd5ZXIgc28gSSBkb24ndCBrbm93IGFu
eXRoaW5nIGFib3V0IHRoaXMgbGljZW5zZSBzdHVmZi4NCkkganVzdCBtZWFudCBpdCBpcyBmcmVl
IHRvIHVzZSBhbmQgZG8gd2hhdGV2ZXIgeW91IHdhbnQgd2l0aC4NCkdQTHYyIHdhcyBhZ3JlZWQg
d2l0aCBvdXIgbGF3eWVycyBmb3IgdGhlIGRyaXZlciBzb3VyY2UgY29kZSwgc28gSSBqdXN0DQpz
dHVjayB0aGF0IG9uIHRoZSBmaXJtd2FyZSBhcyB3ZWxsIChub3QgbG9va2luZyBmb3J3YXJkIHRv
IGFub3RoZXIgdGltZQ0KY29uc3VtaW5nIHBhc3MgdGhyb3VnaCB0aGUgbGVnYWwgZGVwYXJ0bWVu
dCEpLg0KDQpJZiBHUEx2MiBpbXBsaWVzIHRoYXQgeW91IGhhdmUgdG8gcHJvdmlkZSBzb3VyY2Ug
Y29kZSwgdGhlbiB3aGF0IG90aGVyIA0KbGljZW5zZSBzaG91bGQgSSB1c2UgdGhhdCBtZWFucyBm
cmVlZG9tLCBidXQgbm8gc291cmNlIGNvZGU/DQoNCk5vdGUgdGhhdDoNCg0KYSkgSSBhY3R1YWxs
eSAqbG9zdCogdGhlIHNvdXJjZSBjb2RlIChubyBqb2tlIG9yIGV4Y3VzZSEpDQpiKSBUaGlzIGlz
IGZvciBhIHByb3ByaWV0YXJ5IGluLWhvdXNlIG1pY3JvIGVuZ2luZSwgc28gd2hpbGUgd2UgZG9u
J3QNCiAgIG5lY2Vzc2FyaWx5IG1pbmQgcHJvdmlkaW5nIHRoZSBzb3VyY2UgY29kZSwgd2UgZG9u
J3Qgd2FudCB0byBwcm92aWRlDQogICBhbnkgZG9jdW1lbnRhdGlvbiBvciBhc3NlbWJsZXIgZm9y
IHRoYXQuIEFzIHdlIGRlZmluaXRlbHkgZG9uJ3Qgd2FudA0KICAgdG8gKnN1cHBvcnQqIGFueSBv
dGhlciBwZW9wbGUgbWVzc2luZyB3aXRoIGl0LiBNYWtpbmcgdGhlIHNvdXJjZSBjb2RlIA0KICAg
ZWZmZWN0aXZlbHkgdXNlbGVzcyBhbnl3YXkuDQoNCj4gam9zaA0KPiANCj4gDQo+ID4gZGlmZiAt
LWdpdCBhL1dIRU5DRSBiL1dIRU5DRQ0KPiA+IGluZGV4IDMxZWRiZDQuLmZjZTJlZjcgMTAwNjQ0
DQo+ID4gLS0tIGEvV0hFTkNFDQo+ID4gKysrIGIvV0hFTkNFDQo+ID4gQEAgLTQ1MTQsMyArNDUx
NCwxMyBAQCBGaWxlOiBtZXNvbi92ZGVjL2d4bF9tcGVnNF81LmJpbg0KPiA+ICBGaWxlOiBtZXNv
bi92ZGVjL2d4bV9oMjY0LmJpbg0KPiA+DQo+ID4gIExpY2VuY2U6IFJlZGlzdHJpYnV0YWJsZS4g
U2VlIExJQ0VOU0UuYW1sb2dpY192ZGVjIGZvciBkZXRhaWxzLg0KPiA+ICsNCj4gPiArLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gPiArDQo+ID4gK0RyaXZlcjogaW5zaWRlLXNlY3VyZSAtLSBJbnNpZGUg
U2VjdXJlIEVJUDE5NyBjcnlwdG8gZHJpdmVyDQo+ID4gKw0KPiA+ICtGaWxlOiBpbnNpZGUtc2Vj
dXJlL2VpcDE5N19taW5pZncvaXB1ZS5iaW4NCj4gPiArRmlsZTogaW5zaWRlLXNlY3VyZS9laXAx
OTdfbWluaWZ3L2lmcHAuYmluDQo+ID4gKw0KPiA+ICtMaWNlbmNlOiBHUEx2Mi4gU2VlIEdQTC0y
IGZvciBkZXRhaWxzLg0KPiA+ICsNCj4gPiBkaWZmIC0tZ2l0IGEvaW5zaWRlLXNlY3VyZS9laXAx
OTdfbWluaWZ3L2lmcHAuYmluDQo+ID4gYi9pbnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncvaWZw
cC5iaW4NCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLmI0YTgz
MjINCj4gPiBCaW5hcnkgZmlsZXMgL2Rldi9udWxsIGFuZCBiL2luc2lkZS1zZWN1cmUvZWlwMTk3
X21pbmlmdy9pZnBwLmJpbiBkaWZmZXINCj4gPiBkaWZmIC0tZ2l0IGEvaW5zaWRlLXNlY3VyZS9l
aXAxOTdfbWluaWZ3L2lwdWUuYmluDQo+ID4gYi9pbnNpZGUtc2VjdXJlL2VpcDE5N19taW5pZncv
aXB1ZS5iaW4NCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLjJm
NTQ5OTkNCj4gPiBCaW5hcnkgZmlsZXMgL2Rldi9udWxsIGFuZCBiL2luc2lkZS1zZWN1cmUvZWlw
MTk3X21pbmlmdy9pcHVlLmJpbiBkaWZmZXINCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdl
bg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0
cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
