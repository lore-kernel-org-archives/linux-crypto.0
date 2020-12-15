Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D81C2BB48
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD5822D07
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLPABc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:32 -0500
Received: from mail-eopbgr670044.outbound.protection.outlook.com ([40.107.67.44]:32288
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgLOXyX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJBnPaSkpAmRK0QyC9OhYRDvrz8oHAo4B8ZsUoF76IEgU6huvpgPBGD/bzGZN/8vk7xzJWAJKrofsXLyOmcHRuY3F1vWrRUVaUAapCanpJuqkVqJU3JpgEnoAIr8hLxsfxFEK27ZudfW4Cp8FCHSaCX1W8zYERuDFvbTy1x0BG4dVYJC2mDvPyz2DMnh8/RlvdNoY0RMaZwW5lMRj3o2lsaFj4eastDBkp4DGKYiraTGADG1CRHnvengr4C1jVCyBuxktLYMsMh7wH2Bdrq7j5kgbw6QU7D72KHfm5gtz81XhaQ1U3gD34dSI99cWNQUyNSKMaBneb4rQGBsy+HNEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeRT43FzFpO5xxFh0Dia+10iPLx7RH4JqsSXH9iNi5k=;
 b=Yeum0DogLZ7jE7L/gqa2SlOqfC4Iybqy1nJAY2U8G4IJC4muGwA0JJ8qLTX2MizeMBv4zNixGI75f744V1CHqWXi+PYOzpihhYwBQta8mUduppkcwjgUWt0n7w6UBLX6fy5cmZakbpssDVGQ5lsMkniyF7PXbXGAhWfRHSCLRiOOf4QUAXivXBnThU7Jp6GI8E5+EzEtJq0z3tNbLajdT363lH294mc+alEFPfi0e7HL7G0y+QEEYBc9/cZqt6I7SMiJzvRlNsZMPErC/eYmslXdtb0FyiPFzXkFS8xTUmXJE+iQbYsnoMCvLMTXOUGF3vRYBJ9nnfOOxHgpRJ2+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeRT43FzFpO5xxFh0Dia+10iPLx7RH4JqsSXH9iNi5k=;
 b=M+Di0pfcr6uelb4XiBch4dCoTxpYbsYgjOgmCvc9ZXpqm1O6ONqCucVVprQ5pVIBGE1hhDpMVV5M7/aNQUyOA7Xv3EX4jCVzeMn9h0t1o14GF8OUFbuXe2AJxOvn749ryWqjNP18iCrmfhrgE8P38/q0kbG21Bi3E5AAX2XBuNI=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2858.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 23:53:40 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::dd1e:eba1:8e76:470b]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::dd1e:eba1:8e76:470b%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 23:53:40 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "aymen.sghaier@nxp.com" <aymen.sghaier@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>
CC:     "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: iMX6D CAAM RNG problems in v5.10.1
Thread-Topic: iMX6D CAAM RNG problems in v5.10.1
Thread-Index: AQHW0zpjFR0LJiIzBUi6UNkHbuSSeKn41JEA
Date:   Tue, 15 Dec 2020 23:53:40 +0000
Message-ID: <d5e46cd91e6f64575cb3c731643f596379c42726.camel@calian.com>
References: <00b1daa3cbd4b9eada873e5ef95f89fd2e5cee87.camel@calian.com>
In-Reply-To: <00b1daa3cbd4b9eada873e5ef95f89fd2e5cee87.camel@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-14.el8) 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 142ced70-49f1-4f83-cf5e-08d8a154a5ee
x-ms-traffictypediagnostic: YT1PR01MB2858:
x-microsoft-antispam-prvs: <YT1PR01MB2858EDCBDDB4DD1A13867E52ECC60@YT1PR01MB2858.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mufcb0EEXBuk1P8ScwqTTO3DGCfaTlMYB8xdETTI6OeJHRUeTkn1EH4EJtliToUb/PforZA1BJbtyCTlBAOIQKai1cqL5SzJKqxc81qmDw6u9Yk3LbCeJ3CDC5YVpZSdEDuf0+tjngun6+enAnpIhBo8pFUkyAhibKH6mLCpiOlrKpGoJRUhc3UiAo0fyacNuJ5K+tLXyNFh016FXIcAIL86kLh9YmTuTQ51r0KvTIzA+hCYIAwwsSLuTFZin+dTnT+kvRLjJDbccnQhxjoqbxyQUfSFz/WRW9unHZFqt22rrHKCo1jWDUywH680IRDHaK1Zhrj4Sn5Ti6VyoQdih80CUxDg5+HMWM+8Wi0mqyUWeG79xB8XRbu+YAiphGLGuph68fEC+trs121HxlbVwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39830400003)(376002)(136003)(6486002)(86362001)(316002)(26005)(76116006)(478600001)(2906002)(110136005)(186003)(54906003)(36756003)(83380400001)(6512007)(5660300002)(66446008)(64756008)(66556008)(8676002)(66946007)(66476007)(4326008)(44832011)(8936002)(71200400001)(4001150100001)(2616005)(6506007)(99106002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NUsrSmhCcS9sZGIwRm9Zc3JuOVlLaHJNbURLeTZFWTdTenk0RnE4T3g3VHVv?=
 =?utf-8?B?ZXRteHVtMGZTWEloS0Q4WksxVVJPNXJqL0lKbzNEaFVSQmVCWG9qWGtQN2dC?=
 =?utf-8?B?L0NBMVBJOXc1b0ZwV2pldUMvVkM1czgzcHJSYlAyMFp6cXZmaUloQ2ZaQXNF?=
 =?utf-8?B?UVltUXZTRHRlWnJlK3ZKZmVDRDl5TkhNc1BkTWVpZGNpdE1NUUl0SXozdytN?=
 =?utf-8?B?Wmt2MERjeHAybklROS82bEczVDFsT2hYSXhueVNmM0RURlJRdGpMbXJyVkc3?=
 =?utf-8?B?Rkh3YWc5MjFQOG1ZZm0vdkdsNDA4Tk5OVmpXWTFiajhqUUl1ZkNIT2Iwdy9k?=
 =?utf-8?B?a0NjcjVGWVh2ZFpxWk5vblByMWZaN2RSQlBmTWdaMTVXRUVyRk1PZkpHR29o?=
 =?utf-8?B?ZGsyK3pNc3pjRG15UkxSdlU2R2tSTXg0Uy91SXhVcUR0dmp6TDljWUdOTlI5?=
 =?utf-8?B?OXRJV3NucHZhNHphM0NEQTd5SThGSU14U3QvTDdmU28yWXd2bFFxM2VyZzdS?=
 =?utf-8?B?VUtzZjhhbWZLbXRzSjFqUU9CejBXZ1I0YS90aWdTcmpuNXo3N1lBa3ArZnBr?=
 =?utf-8?B?WTgyYmU1U3o4SHZ1TExBSDNhSktqMDdZRDlPaWdpUTRBZVNsdjM0UVUrVnkr?=
 =?utf-8?B?VE1MNmh1cTVObG9DdE5TUlBFYzZHejRDTU80M3V0VW8zK1o0Z3pXemhhMDZi?=
 =?utf-8?B?R3dGRGlaSXQ3UEpybk10cVVpQ0hpVFI5RDliYmN2My9YVURVdWNLc1JndW5T?=
 =?utf-8?B?Y1FkTm1XUmtZN1dVdEhYMDJ3RE1XNldwVkhzSVpGbGd0V0Z2OHRUSmhtWlg0?=
 =?utf-8?B?RXJBaDR4N1lXdlVVSWNacmNnajRFOTA0Qm1MVURqWFloYzhudU54amhXampr?=
 =?utf-8?B?eVlzUUs3Qk1FQmhpWnBDM01GWDBsNGp1U25qUzlQNDMwcFFiLzBpTVB3VHVa?=
 =?utf-8?B?dHI1a0FhVVVXa1FhSWVwcHpRdzdObVFwYjRSeVZNUlJOZkV3TmllbWY2cVM5?=
 =?utf-8?B?SHhnalFmdjFjekpkS3Y0cFNVSXk2K29jOXEydkFOcEY0M2lFZDJScENLY0pC?=
 =?utf-8?B?cVJ5WVJDWUlaNTJBZXlvcGxuNi9oUWdQSTd0cFRwMUFVVDRPdG1tdVJzRklY?=
 =?utf-8?B?L3NmR2tXcVg4dnQ1bmFKSjQ1SnNUOFNnaURZd0N6OVlBUVZUa3h3NGwrcG83?=
 =?utf-8?B?dU1mVVlQeTA2RDA3WURYRVhNZWlaZ3ZkQ1hOUWNKeWgwV1hUZzFGZ0tXN1cx?=
 =?utf-8?B?amo0akEvalJpME8wMDQ2VkRwcklka0Q0L3NVTjhSTGNjZ2VQRDZmam1XVDg4?=
 =?utf-8?Q?T2EedjKNf1FKY7kF6beD1Tmw9OsTdiU4AT?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <037EF0ADCE3633409AF8A44A6EFEBC05@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 142ced70-49f1-4f83-cf5e-08d8a154a5ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 23:53:40.5271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xpF8fqKWuQBYXI3Mxbn2uw+6vjDAYPQMgnVrNQ/Ma0ukcPLTnKBvosFJNq9VmEmCjnUBkw8tqpyeZF9wn0mjJqIniOFp4ThUOtUH5pDkrME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2858
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SnVzdCBzYXcgTHVjYXMgU3RhY2gncyBwb3N0ICJDQUFNIFJORyB0cm91YmxlIiBmcm9tIHllc3Rl
cmRheSB3aGljaA0Kc2VlbXMgdG8gYmUgZGVzY3JpYmluZyB0aGlzIHNhbWUgaXNzdWUgLSBhZGRl
ZCB0byBDQy4NCg0KT24gVHVlLCAyMDIwLTEyLTE1IGF0IDE3OjMxIC0wNjAwLCBSb2JlcnQgSGFu
Y29jayB3cm90ZToNCj4gSGVsbG8sDQo+IA0KPiBXZSBoYXZlIGFuIGlNWDZELWJhc2VkIGJvYXJk
IHdoaWNoIHdhcyBwcmV2aW91c2x5IHVzaW5nIDUuNC54DQo+IGtlcm5lbHMuDQo+IEkgaGF2ZSBy
ZWNlbnRseSBzdGFydGVkIHRlc3RpbmcgdjUuMTAuMSBvbiB0aGlzIGJvYXJkIGFuZCBhbSBydW5u
aW5nDQo+IGludG8gYW4gaXNzdWUgd2l0aCB0aGUgQ0FBTSBSTkcuIFRoZSBkbWVzZyBpcyBnZXR0
aW5nIG91dHB1dCBsaWtlDQo+IHRoaXMNCj4gYW5kIGFsbCByZWFkcyBmcm9tIC9kZXYvaHdybmcg
YXJlIGZhaWxpbmcgd2l0aCBFSU5WQUw6DQo+IA0KPiBbICAgMTcuMzY4MzY4XSBjYWFtX2pyIDIx
MDEwMDAuanI6IDIwMDAwMjViOiBDQ0I6IGRlc2MgaWR4IDI6IFJORzoNCj4gSGFyZHdhcmUgZXJy
b3INCj4gWyAgIDE3LjM3NTcyMV0gaHdybmc6IG5vIGRhdGEgYXZhaWxhYmxlDQo+IFsgICAyMy4y
MDAyNTVdIGNhYW1fanIgMjEwMTAwMC5qcjogMjAwMDNjNWI6IENDQjogZGVzYyBpZHggNjA6IFJO
RzoNCj4gSGFyZHdhcmUgZXJyb3INCj4gWyAgIDIzLjIxNTUwOF0gY2FhbV9qciAyMTAxMDAwLmpy
OiAyMDAwM2M1YjogQ0NCOiBkZXNjIGlkeCA2MDogUk5HOg0KPiBIYXJkd2FyZSBlcnJvcg0KPiBb
ICAgMjMuMjI5MjQ5XSBjYWFtX2pyIDIxMDEwMDAuanI6IDIwMDAzYzViOiBDQ0I6IGRlc2MgaWR4
IDYwOiBSTkc6DQo+IEhhcmR3YXJlIGVycm9yDQo+IFsgICAyMy4yNDM0MTVdIGNhYW1fanIgMjEw
MTAwMC5qcjogMjAwMDNjNWI6IENDQjogZGVzYyBpZHggNjA6IFJORzoNCj4gSGFyZHdhcmUgZXJy
b3INCj4gWyAgIDIzLjI1NzgwOV0gY2FhbV9qciAyMTAxMDAwLmpyOiAyMDAwM2M1YjogQ0NCOiBk
ZXNjIGlkeCA2MDogUk5HOg0KPiBIYXJkd2FyZSBlcnJvcg0KPiBbICAgMjMuMjcyMTA5XSBjYWFt
X2pyIDIxMDEwMDAuanI6IDIwMDAzYzViOiBDQ0I6IGRlc2MgaWR4IDYwOiBSTkc6DQo+IEhhcmR3
YXJlIGVycm9yDQo+IA0KPiBXZSBhcmUgbm90IHVzaW5nIHNlY3VyZSBib290IHByZXNlbnRseSwg
aWYgdGhhdCBtYXR0ZXJzLiBPbiA1LjQsIG5vDQo+IHN1Y2ggaXNzdWVzIGFuZCAvZGV2L2h3cm5n
IHNlZW1zIHRvIHdvcmsgZmluZS4NCj4gDQo+IEkgc2VlIHRoZXJlIGFyZSBzb21lIENBQU0gUk5H
IGNoYW5nZXMgYmV0d2VlbiA1LjQgYW5kIDUuMTAgYnV0IG5vdA0KPiBzdXJlDQo+IHdoaWNoIG1p
Z2h0IGJlIHRoZSBjYXVzZT8NCj4gDQo+IFRoZSBDQUFNIGluaXRpYWxpemF0aW9uIG91dHB1dCBv
biBib290IChzYW1lIG9uIHdvcmtpbmcgNS40IGFuZCBub24tDQo+IHdvcmtpbmcgNS4xMC4xIGtl
cm5lbHMpOg0KPiANCj4gWyAgIDE2LjkzNDI1M10gY2FhbSAyMTAwMDAwLmNyeXB0bzogRW50cm9w
eSBkZWxheSA9IDMyMDANCj4gWyAgIDE3LjAwMDE0Nl0gY2FhbSAyMTAwMDAwLmNyeXB0bzogSW5z
dGFudGlhdGVkIFJORzQgU0gwDQo+IFsgICAxNy4wNjA5MTFdIGNhYW0gMjEwMDAwMC5jcnlwdG86
IEluc3RhbnRpYXRlZCBSTkc0IFNIMQ0KPiBbICAgMTcuMDY3ODkxXSBjYWFtIDIxMDAwMDAuY3J5
cHRvOiBkZXZpY2UgSUQgPSAweDBhMTYwMTAwMDAwMDAwMDANCj4gKEVyYQ0KPiA0KQ0KPiBbICAg
MTcuMDgwMjg5XSBjYWFtIDIxMDAwMDAuY3J5cHRvOiBqb2IgcmluZ3MgPSAyLCBxaSA9IDANCj4g
WyAgIDE3LjExMzQ5OF0gY2FhbSBhbGdvcml0aG1zIHJlZ2lzdGVyZWQgaW4gL3Byb2MvY3J5cHRv
DQo+IFsgICAxNy4xMjAwOTldIGNhYW0gMjEwMDAwMC5jcnlwdG86IHJlZ2lzdGVyaW5nIHJuZy1j
YWFtDQo+IA0K
