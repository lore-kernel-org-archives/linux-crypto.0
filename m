Return-Path: <SRS0=1Yk9=S5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F2BC43218
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 07:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2C92067D
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 07:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mJBFx9+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfD0HRg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Apr 2019 03:17:36 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:46456
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfD0HRg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Apr 2019 03:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kX8QHC/ENOd7EQcvhnhfs088qVdCDV/CoQoemHJKPBA=;
 b=mJBFx9+PD9YfCNvTMZfsfw8fNn7IaLywD/PEnr6XEELpJ0liOxvIn55IhAYvzLdOTRpSMQsa3wCOZrmBFVynftfjTUtWvFMX4orbN4qRZ54fivZk5H7gGYvf+goQ5yW7+rrRQEP6kndpPSiQp5t4fcwlzbxJKpjhEubLQuo/qb0=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1PR04MB4174.eurprd04.prod.outlook.com (52.134.30.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Sat, 27 Apr 2019 07:17:32 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071%7]) with mapi id 15.20.1835.010; Sat, 27 Apr 2019
 07:17:32 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Topic: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Index: AQHU+4N3KfEkOR20+UOGTJBs1BJyXKZPmmWA
Date:   Sat, 27 Apr 2019 07:17:32 +0000
Message-ID: <VI1PR04MB513455960753AA04259CBAA4EC3F0@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c4ca113-3cbb-4fe7-7cc9-08d6cae06a87
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4174;
x-ms-traffictypediagnostic: VI1PR04MB4174:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR04MB4174EE20B25E419501C101D6EC3F0@VI1PR04MB4174.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0020414413
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(376002)(346002)(39860400002)(189003)(199004)(13464003)(110136005)(66476007)(66946007)(64756008)(76176011)(102836004)(186003)(6506007)(76116006)(73956011)(26005)(66556008)(478600001)(316002)(966005)(81166006)(99286004)(66446008)(66066001)(81156014)(4744005)(446003)(7696005)(8936002)(54906003)(476003)(11346002)(68736007)(486006)(86362001)(8676002)(2906002)(55016002)(229853002)(71200400001)(4326008)(44832011)(97736004)(5660300002)(6306002)(71190400001)(3846002)(53936002)(9686003)(256004)(14454004)(305945005)(7736002)(74316002)(33656002)(6436002)(25786009)(6246003)(52536014)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4174;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NMXEgTJnV5+jOphuMYAKdXEQ30XptifAC6As3qypEMCtP6dvlOqcJijE3goNKsmplBaYZ4Ys1aV8/LlKwxOyROdHxF4ZY+78L24/QypMiE1kdbNKX8O2hX3cyKKW7AUclAPSRdV3EcEYO3Tlfvmccagc9/t0VD0VP5qdWfH3A64NDI8DEKQgU8WT2gTioSWWiUu0xsOQebR4WG3O/CVNOYX3pKEfy4Lq8ut0Fz8htkkRZXGbKoS1nvKr9uHKJPVDIwu6qWQBq9l8fT3NujQd+WDhT/IAQq9oCUQbIXs4/m+2T/lm8SndJYi6kJ8S3NkaXw6+O2zDsUIy5sCPH3toQU9g09GjB2b2MmiJg1Or01ceeVHT/r45Wiei02vRDYNG+8h81LboV/bqbBOMUvCKjJaJ0yv8FMBoK0tn5XJLo8c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4ca113-3cbb-4fe7-7cc9-08d6cae06a87
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2019 07:17:32.6892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4174
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgSG9yaWEsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSG9yaWEg
R2VhbnTEgyA8aG9yaWEuZ2VhbnRhQG54cC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAy
NSwgMjAxOSA3OjI1IFBNDQo+IA0KPiBUaGlzIHBhdGNoIHNldCBhZGRzIHN1cHBvcnQgaW4gY2Fh
bSBkcml2ZXJzIChjYWFtL2pyLCBjYWFtL3FpLCBjYWFtL3FpMikNCj4gZm9yIHRoZSBjcnlwdG8g
ZW5naW5lIHRvIHdvcmsgYmVoaW5kIGFuIElPTU1VLg0KPiANCg0KW3NuaXBdDQoNCj4gDQo+IGku
IFBhdGNoIDkvOSAoY3J5cHRvOiBjYWFtIC0gZGVmZXIgcHJvYmluZyB1bnRpbCBRTWFuIGlzIGF2
YWlsYWJsZSkgc2hvdWxkDQo+IE5PVCBiZSBtZXJnZWQsIHNpbmNlIHRoZXJlIGFyZSBjb21waWxh
dGlvbiBkZXBlbmRlbmNpZXMgb24gdGhlIHBhdGNoDQo+IHNlcmllczoNCj4gKCopIFByZXJlcXVp
c2l0ZXMgZm9yIE5YUCBMUzEwNHhBIFNNTVUgZW5hYmxlbWVudA0KDQpGWUksIEkndmUgc3VibWl0
dGVkIGEgdjIgb2YgdGhlIHNlcmllcyBkcm9wcGluZyBzZXZlcmFsIHNvbWUgcGF0Y2hlcyB0aGF0
IG5lZWQgYWRkaXRpb25hbCB3b3JrIGJ1dCBpbmNsdWRpbmcgdGhlIHBhdGNoIHlvdSBkZXBlbmQg
b24sIHNlZSBoZXJlOg0KDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGlu
dXgtYXJtLWtlcm5lbC9saXN0Lz9zZXJpZXM9MTEwODk5DQoNCi0tLQ0KQmVzdCBSZWdhcmRzLCBM
YXVyZW50aXUNCg0K
