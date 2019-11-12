Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5A1C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 12:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B1A9222BD
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 12:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="S6RNhfQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLMT1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:19:27 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52622 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfKLMT0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 07:19:26 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: FmVGawcAA0XNel20hPKrxspqs2ebyVaSL+DNBA91GFkCDS9eTWO7VB3Xu6xrpALGoRE0146M70
 rQV/8ynQn/i61DEWwB7r24MaOz6p5vFM6mOLquk5ss4CjTHdvJLj81Z/SyQnehhvhScTHr0N4Q
 YUf2TTpAosW+eah0i9dDc3ci5v/Y02GXOVlO9rHt1NpV6YOVRJDhDvAvw75vMexlQZ1C+DgFI2
 Cs8BsFMrpRuZifI3NBlfhDM6cXBDNjT4OtJinhfm1m50EbFANWxuid1Nk0Uhnt0mRAhTI+Y+eK
 1sg=
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="56663512"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 05:19:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 05:19:24 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 05:19:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3dxzQMyvpofqyArY2W0ai5RspRTwFKmReVTRkA+xGd/vW47q9TPqq42c9drFzuZlIDe1VCEWN8TKyQnbN7fMkOwNTenzBZlf3nOXLNXuXYwpXfeQPWS3Rxuf0UnM6EnQfrboeCgY5ADJ+3WpSGwFodGhJc4qmIOU9CxZ3RE6FZmYscQMYu4KEx1u7N9DQ85v0eIBVD3CdCTfjwNg6nWFQlAu+oJCbB/hWrBJVQ8nJy1A3bEVuZoTGo1MkM3khD3ahLb5fcZvP91r/IkBk5l8DCNCNkJNDjteX3HJ8YamWEYtXsPqtcqkVsVQdsuaYTqN3Ld/GG0teH1dOUltHmvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6IYTv1UZ8yzV5MdEvnBFSgw1qW/fzIwZXXWAdCbWfo=;
 b=kFzJitzPgGC3oEByqz7ksS8Ai+KakEWPWg/5kHcpDIEGEWF6Kxd8B4ctKFySHmP4ioBr1R5xoRzcXjq8odTwWBW20xdc6UhX5V1EAjZie6w3TVBSE37mryboNZsLk4qrh7DKKLeh8uiL7IFafQl9RVRPPu3QKax1LsSO2lXD5g6+2sDFyaZb6nb42p4AAbspfn2C8gaTowu3ExE8JaFQA9833VnYGnfdPmjFEyMhSTbF+9hgixLAik31qkfG4TdDws/P6GhaA+KX/CTYhwx69iiZ6JJu6+CmVghVYOZNqQUP4b8DdqPZzPJQ4xNh/nig1JxvqOI6DabVWPxEveev/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6IYTv1UZ8yzV5MdEvnBFSgw1qW/fzIwZXXWAdCbWfo=;
 b=S6RNhfQrNb3xpnHg+7QlS7JIYI3wFl/lct9FVNOobZj0esN8JsvEe/8ZDg9hhcb0ep/eYtnrPsNLLhPj6TZGe4fhK+SXSoBcyB7U8yUElvJjjVhF5aTwAuZhKQ4BM7seD4ahefT+ZjAL51XmLYWeO8Db2b6L2FldMdeVERlHsvg=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3790.namprd11.prod.outlook.com (20.178.253.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 12:19:23 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 12:19:23 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <yuehaibing@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <cyrille.pitchen@atmel.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 -next] crypto: atmel - Fix build error of
 CRYPTO_AUTHENC
Thread-Topic: [PATCH v2 -next] crypto: atmel - Fix build error of
 CRYPTO_AUTHENC
Thread-Index: AQHVmSqxwebvg2efp0OwclA6xCpycKeHdHUA
Date:   Tue, 12 Nov 2019 12:19:23 +0000
Message-ID: <810b0a9b-d749-b351-18a3-234b3d7ae464@microchip.com>
References: <20191111133901.19164-1-yuehaibing@huawei.com>
 <20191112072405.40268-1-yuehaibing@huawei.com>
In-Reply-To: <20191112072405.40268-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0041.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::18) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af26dcb4-9cb7-41ca-d003-08d7676a8d45
x-ms-traffictypediagnostic: MN2PR11MB3790:
x-microsoft-antispam-prvs: <MN2PR11MB379058FA000B4C337791A2D8F0770@MN2PR11MB3790.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(366004)(136003)(189003)(199004)(36756003)(53546011)(6506007)(386003)(81166006)(7736002)(305945005)(102836004)(81156014)(14454004)(8676002)(6116002)(3846002)(486006)(476003)(2616005)(25786009)(31686004)(478600001)(66066001)(11346002)(446003)(26005)(99286004)(8936002)(2501003)(76176011)(186003)(66556008)(66946007)(71190400001)(71200400001)(256004)(31696002)(6486002)(66446008)(64756008)(52116002)(2201001)(54906003)(86362001)(6246003)(110136005)(316002)(5660300002)(6436002)(2906002)(6512007)(229853002)(4326008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3790;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o7xvSqaEfP8R23ckzH0SSxsY1eEu1A7tceRMRVYTUmsitZ51pklhnETj120P4xB3Qg48Yvwsnu5CxROz7L3FhkRW+bAfu+elbdCuKYIOhscxsnYHWDh2aH8CZf2ub0cg4ugahS7e5dEL49gLbAlpHbq/KWdENtdu0gqepTEHEExLUq04yLgOm15jo1IQFTmFWMk6OWryUbGDakQllmEho5GQ4BFk3wo8b0nfC7x+jAWotA3u0IErDMhtNjfyLAUwIJtnBIsfZH8WXld8AHnZDE/GfEPrIbgrD+qoDsDQVBWh4n36eNUX+Fl/lQyazQNqaUbYPaK82za7W8MHVZe5qdHhfE7v2X591nAwnSQdDYZSLXqDvwUtSIkB9CvBpsLfuA+MUSP+ECU7cc+EO+KCeJ13H9wzeFQZGdXR9DcYdIwr22sxYXHTu++YWX+neWj2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <59477B525573B244B9D11D0137874ED7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: af26dcb4-9cb7-41ca-d003-08d7676a8d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 12:19:23.2470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ULb/iRBeZAaPpEqT23kY38gZVXQJF3yECy/++cqXzq6mNdWrocYMft9XG7t22avL795UJJthq3RepnKIayv2HTdkRe6cY70aaOeICPRDi8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3790
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzEyLzIwMTkgMDk6MjQgQU0sIFl1ZUhhaWJpbmcgd3JvdGU6DQo+IElmIENSWVBU
T19ERVZfQVRNRUxfQVVUSEVOQyBpcyBtLCBDUllQVE9fREVWX0FUTUVMX1NIQSBpcyBtLA0KPiBi
dXQgQ1JZUFRPX0RFVl9BVE1FTF9BRVMgaXMgeSwgYnVpbGRpbmcgd2lsbCBmYWlsczoNCg0Kcy9m
YWlscy9mYWlsDQoNCj4gDQo+IGRyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5vOiBJbiBmdW5jdGlv
biBgYXRtZWxfYWVzX2F1dGhlbmNfaW5pdF90Zm0nOg0KPiBhdG1lbC1hZXMuYzooLnRleHQrMHg2
NzApOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBhdG1lbF9zaGFfYXV0aGVuY19nZXRfcmVxc2l6
ZScNCj4gYXRtZWwtYWVzLmM6KC50ZXh0KzB4NjdhKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBg
YXRtZWxfc2hhX2F1dGhlbmNfc3Bhd24nDQo+IGRyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5vOiBJ
biBmdW5jdGlvbiBgYXRtZWxfYWVzX2F1dGhlbmNfc2V0a2V5JzoNCj4gYXRtZWwtYWVzLmM6KC50
ZXh0KzB4N2U1KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgYXRtZWxfc2hhX2F1dGhlbmNfc2V0
a2V5Jw0KPiANCj4gTWFrZSBDUllQVE9fREVWX0FUTUVMX0FVVEhFTkMgZGVwZW5kcyBvbiBDUllQ
VE9fREVWX0FUTUVMX0FFUywNCg0Kcy9kZXBlbmRzL2RlcGVuZA0KDQo+IGFuZCBzZWxlY3QgQ1JZ
UFRPX0RFVl9BVE1FTF9TSEEgYW5kIENSWVBUT19BVVRIRU5DIGZvciBpdCB1bmRlciB0aGVyZS4N
Cj4gDQo+IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU3Vn
Z2VzdGVkLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IEZp
eGVzOiA4OWE4MmVmODdlMDEgKCJjcnlwdG86IGF0bWVsLWF1dGhlbmMgLSBhZGQgc3VwcG9ydCB0
by4uLiIpDQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNv
bT4NCg0KUmV2aWV3ZWQtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWljcm9jaGlw
LmNvbT4NCg0KPiAtLS0NCj4gdjI6IG1ha2UgQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5DIGRlcGVu
ZHMgb24gREVWX0FUTUVMX0FFUw0KPiAtLS0NCj4gIGRyaXZlcnMvY3J5cHRvL0tjb25maWcgfCA4
ICsrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL0tjb25maWcgYi9kcml2ZXJz
L2NyeXB0by9LY29uZmlnDQo+IGluZGV4IGM1Y2MwNGQuLjI5NmU4MjkgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvY3J5cHRvL0tjb25maWcNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vS2NvbmZpZw0K
PiBAQCAtNDkyLDEwICs0OTIsOSBAQCBpZiBDUllQVE9fREVWX1VYNTAwDQo+ICBlbmRpZiAjIGlm
IENSWVBUT19ERVZfVVg1MDANCj4gIA0KPiAgY29uZmlnIENSWVBUT19ERVZfQVRNRUxfQVVUSEVO
Qw0KPiAtCXRyaXN0YXRlICJTdXBwb3J0IGZvciBBdG1lbCBJUFNFQy9TU0wgaHcgYWNjZWxlcmF0
b3IiDQo+ICsJYm9vbCAiU3VwcG9ydCBmb3IgQXRtZWwgSVBTRUMvU1NMIGh3IGFjY2VsZXJhdG9y
Ig0KPiAgCWRlcGVuZHMgb24gQVJDSF9BVDkxIHx8IENPTVBJTEVfVEVTVA0KPiAtCXNlbGVjdCBD
UllQVE9fREVWX0FUTUVMX0FFUw0KPiAtCXNlbGVjdCBDUllQVE9fREVWX0FUTUVMX1NIQQ0KPiAr
CWRlcGVuZHMgb24gQ1JZUFRPX0RFVl9BVE1FTF9BRVMNCj4gIAloZWxwDQo+ICAJICBTb21lIEF0
bWVsIHByb2Nlc3NvcnMgY2FuIGNvbWJpbmUgdGhlIEFFUyBhbmQgU0hBIGh3IGFjY2VsZXJhdG9y
cw0KPiAgCSAgdG8gZW5oYW5jZSBzdXBwb3J0IG9mIElQU0VDL1NTTC4NCj4gQEAgLTUwNyw4ICs1
MDYsOSBAQCBjb25maWcgQ1JZUFRPX0RFVl9BVE1FTF9BRVMNCj4gIAlkZXBlbmRzIG9uIEFSQ0hf
QVQ5MSB8fCBDT01QSUxFX1RFU1QNCj4gIAlzZWxlY3QgQ1JZUFRPX0FFUw0KPiAgCXNlbGVjdCBD
UllQVE9fQUVBRA0KPiAtCXNlbGVjdCBDUllQVE9fQVVUSEVOQw0KPiAgCXNlbGVjdCBDUllQVE9f
U0tDSVBIRVINCj4gKwlzZWxlY3QgQ1JZUFRPX0FVVEhFTkMgaWYgQ1JZUFRPX0RFVl9BVE1FTF9B
VVRIRU5DDQo+ICsJc2VsZWN0IENSWVBUT19ERVZfQVRNRUxfU0hBIGlmIENSWVBUT19ERVZfQVRN
RUxfQVVUSEVOQw0KPiAgCWhlbHANCj4gIAkgIFNvbWUgQXRtZWwgcHJvY2Vzc29ycyBoYXZlIEFF
UyBodyBhY2NlbGVyYXRvci4NCj4gIAkgIFNlbGVjdCB0aGlzIGlmIHlvdSB3YW50IHRvIHVzZSB0
aGUgQXRtZWwgbW9kdWxlIGZvcg0KPiANCg==
