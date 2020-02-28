Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB70C3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 11:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB40246AA
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 11:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eC+wi4uG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgB1LEJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 06:04:09 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:13739
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbgB1LEJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 06:04:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ee2Y9UhKVIjG0RBs+Qe3X6W/NBMBhrvge+sw56N3w4gIHnp68UsN9r6qJibMNd++6cyiNnLOaWTE9Bt8X2rZspHB76K3CZIKU7W0qPIXcjKY/4IQYjucCrrk1pVMjM/32IgvVlQ0vNotjpG9XQFrv8mKZUpvvU3PXqaU/Vl8h7Wq4QWL9ENQeHSGIzZ2ZF/I/8CPLHrCYaRBqz8ZmRB4x/Vcp1zQU9QHay91jbmkaACOy1MkVVaBMSFNxHt4RG3GQKTh4MFZDZ/gVlVUKczpkkF/c657Mr9pitaIxtUjEUml1nzRUBgqK5filpog8mz92F2FbrY203EisqpV1gddOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwuF2f1bIWW8VKod7CBeZEoaF5xZofIOokvgWhOlyqs=;
 b=iEuoXbXi0SxygqGxW2IACytPC2iA+3DBLaAOQuPMczPw0++uxxxcAmL+c7y3/roFMiMQ4Kp4XgFBlkutmhuV25SzIRYJQdLXSekXoZGPlKyTND0V/ABdRWwXY1EFNS4bcsk3uHfbIp8DGCDCORJBfP4SIUoJ2Eu5fdTXMcRkgZXMADftqTbovmT6y6x0xNqMf6+cBAzRHGWb0ZGPZl2HUT2Cce7+gGD/NV3hvV544Digvly4qtCINpL94bHm0shdtpTZoD9B9nZkM8ugevGjxRepkOI/cJOgrT/qvvUksrWKCFGDyceeL3Cc53CPkHZg4JkAmOPZnT7TH6cUtc3fkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwuF2f1bIWW8VKod7CBeZEoaF5xZofIOokvgWhOlyqs=;
 b=eC+wi4uGhECopSatlUHD3CnDW4/gRDtXzN7ini29SKyq8UwbvWl3XZYhXXog9JfifV6vKMAIzZRIyVzTLvq//CK0/h33N16QLnPDuL5959gblLMMVnV9OJVy9toTIuJU19IheyoP2hj5CARnLM0xfTf9UAamGw5WHIqyZPdsJS8=
Received: from VI1PR04MB6031.eurprd04.prod.outlook.com (20.179.28.145) by
 VI1PR04MB5040.eurprd04.prod.outlook.com (20.177.52.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 11:04:04 +0000
Received: from VI1PR04MB6031.eurprd04.prod.outlook.com
 ([fe80::f83e:18d7:202a:b080]) by VI1PR04MB6031.eurprd04.prod.outlook.com
 ([fe80::f83e:18d7:202a:b080%5]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 11:04:04 +0000
From:   Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH v2] crypto: caam/qi2 - fix chacha20 data size error
Thread-Topic: [PATCH v2] crypto: caam/qi2 - fix chacha20 data size error
Thread-Index: AQHV7gOAR7Kg8RmjgkWLoPWuqbp0eagwcHHw
Date:   Fri, 28 Feb 2020 11:04:04 +0000
Message-ID: <VI1PR04MB6031FD0D117FF3DD7C4B6289FEE80@VI1PR04MB6031.eurprd04.prod.outlook.com>
References: <20200228065123.13216-1-horia.geanta@nxp.com>
In-Reply-To: <20200228065123.13216-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valentin.ciocoi@nxp.com; 
x-originating-ip: [46.97.170.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 107a9213-2c4d-4c19-2fc1-08d7bc3decca
x-ms-traffictypediagnostic: VI1PR04MB5040:|VI1PR04MB5040:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5040D82E99AE9A33A53B497FFEE80@VI1PR04MB5040.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(86362001)(316002)(71200400001)(52536014)(8676002)(54906003)(478600001)(8936002)(110136005)(2906002)(81156014)(81166006)(5660300002)(9686003)(55016002)(66476007)(33656002)(7696005)(66946007)(66556008)(66446008)(53546011)(6506007)(186003)(4326008)(64756008)(26005)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5040;H:VI1PR04MB6031.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vf5+zPROkYdE1KjvQ9KbCHj0ooeSTMtiKMRKBXoumfTm7B+kT6wsyLW49vXbMb2jWUcW3eiRQs/VokZt3OavD1v6EVUWD0r9ItGJz6oFClqH+pJmNkk90XWqz6ApRv8yGPrK3+4phgyGTxoyD3BhysWcmoP2UqBs+IPNA+/yLHq0RfxmgUIJfSQKVDaPRhIKtzmHOEDvwCMIRGIP4JFrNwqjbxGRfGz1XVscAQknrUCx7l90lt8CeQGWuJ2X2lt0WQcNYMN8PmlL8mI8vXG11CT/e5mZSbukUNLAoI3xDsMBzvIxaayC5FhHKI1lbIFglvEV1xR/U3YxE2atnC4PdluZMqS3iGWCqkSmUN9n0dBfRG+EB1BtXArKQupUJR5b6FsHdHhGs/0zubtp8wtx/q8Y7ces/a4qa2+WzeZ+Tjb7oXDKkfrluyPUAVpiiJNn
x-ms-exchange-antispam-messagedata: TmVyzgC3HXZpobQ3YeQT766g0mKlRTB3BJD1LZVvR8UEAt/okCNDP+mnko8pgG91EKlmYFIbEs62P7krHBXcH6JN6E6KCsQ/CnWqjKShPzIJETe2Em/2a1ar3b0a60PVL6AM5K0Z3G+OpAoSJUrIrA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107a9213-2c4d-4c19-2fc1-08d7bc3decca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 11:04:04.5786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0l6zr2cg+SL3pXjOc0w/dPi3Ha6t/6DQC+MyEJeJi+V61CGubOOaoDgW1Ap1IEYUL6yLBeRwJrRvMlEjijIMgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5040
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIb3JpYSBHZWFudMSDIDxob3Jp
YS5nZWFudGFAbnhwLmNvbT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyOCwgMjAyMCAwODo1
MQ0KPiBUbzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQXltZW4gU2doYWllcg0KPiA8
YXltZW4uc2doYWllckBueHAuY29tPjsgVmFsZW50aW4gQ2lvY29pIFJhZHVsZXNjdQ0KPiA8dmFs
ZW50aW4uY2lvY29pQG54cC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBkbC1s
aW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjJdIGNy
eXB0bzogY2FhbS9xaTIgLSBmaXggY2hhY2hhMjAgZGF0YSBzaXplIGVycm9yDQo+IA0KPiBIVyBn
ZW5lcmF0ZXMgYSBEYXRhIFNpemUgZXJyb3IgZm9yIGNoYWNoYTIwIHJlcXVlc3RzIHRoYXQgYXJl
IG5vdA0KPiBhIG11bHRpcGxlIG9mIDY0Qiwgc2luY2UgYWxnb3JpdGhtIHN0YXRlIChBUykgZG9l
cyBub3QgaGF2ZQ0KPiB0aGUgRklOQUwgYml0IHNldC4NCj4gDQo+IFNpbmNlIHVwZGF0aW5nIHJl
cS0+aXYgKGZvciBjaGFpbmluZykgaXMgbm90IHJlcXVpcmVkLA0KPiBtb2RpZnkgc2tjaXBoZXIg
ZGVzY3JpcHRvcnMgdG8gc2V0IHRoZSBGSU5BTCBiaXQgZm9yIGNoYWNoYTIwLg0KPiANCj4gW05v
dGUgdGhhdCBmb3Igc2tjaXBoZXIgZGVjcnlwdGlvbiB3ZSBrbm93IHRoYXQgY3R4MV9pdl9vZmYg
aXMgMCwNCj4gd2hpY2ggYWxsb3dzIGZvciBhbiBvcHRpbWl6YXRpb24gYnkgbm90IGNoZWNraW5n
IGFsZ29yaXRobSB0eXBlLA0KPiBzaW5jZSBhcHBlbmRfZGVjX29wMSgpIHNldHMgRklOQUwgYml0
IGZvciBhbGwgYWxnb3JpdGhtcyBleGNlcHQgQUVTLl0NCj4gDQo+IEFsc28gZHJvcCB0aGUgZGVz
Y3JpcHRvciBvcGVyYXRpb25zIHRoYXQgc2F2ZSB0aGUgSVYuDQo+IEhvd2V2ZXIsIGluIG9yZGVy
IHRvIGtlZXAgY29kZSBsb2dpYyBzaW1wbGUsIHRoaW5ncyBsaWtlDQo+IFMvRyB0YWJsZXMgZ2Vu
ZXJhdGlvbiBldGMuIGFyZSBub3QgdG91Y2hlZC4NCj4gDQo+IENjOiA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4gIyB2NS4zKw0KPiBGaXhlczogMzM0ZDM3YzllMjYzICgiY3J5cHRvOiBjYWFtIC0g
dXBkYXRlIElWIHVzaW5nIEhXIHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBIb3JpYSBHZWFu
dMSDIDxob3JpYS5nZWFudGFAbnhwLmNvbT4NCg0KVGVzdGVkLWJ5OiBWYWxlbnRpbiBDaW9jb2kg
UmFkdWxlc2N1IDx2YWxlbnRpbi5jaW9jb2lAbnhwLmNvbT4NCg0KVGVzdGVkIG9uIExYMjE2MEFS
REIgYm9hcmQgd2l0aCBjcnlwdG9kZXYtMi42IHRyZWU6DQpyb290QFRpbnlMaW51eDp+IyBjYXQg
L3Byb2MvY3J5cHRvIHwgZ3JlcCBjaGFjaGEyMC1jYWFtIC1BIDUNCmRyaXZlciAgICAgICA6IGNo
YWNoYTIwLWNhYW0tcWkyDQptb2R1bGUgICAgICAgOiBrZXJuZWwNCnByaW9yaXR5ICAgICA6IDIw
MDANCnJlZmNudCAgICAgICA6IDENCnNlbGZ0ZXN0ICAgICA6IHBhc3NlZA0KaW50ZXJuYWwgICAg
IDogbm8NCg0K
