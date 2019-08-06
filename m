Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DDFC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F31216B7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="V43asT2l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfHFQpn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 12:45:43 -0400
Received: from mail-eopbgr680084.outbound.protection.outlook.com ([40.107.68.84]:65444
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbfHFQpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 12:45:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVVHqLfQabHkOXXkqCHp+HpyPUD2M87Rq0BYj00nH+XmU0IEJ17F48+LPaPFTmcqIWcDJ+gQjMtZXbbWhdb0J6KhU8hDSwK/85WHdk08Z7NLEOcUtg7KqJfAU5Dj/sUt9PqNqE7K1F/mWt0ULvXPgKyiwbooYzyFbieC/vGspIu433Rfj5d0+rZwWswjodUTvGNgikE1JWpIPO7jKGOOPqEcilIPiFvcgOxtio/09cY7a1X6x16u0+yPEIerBwsR2+wVpcqQJCyoomaU8BdfUZa7/Mew3njnn71c13GuZpB4RhnI/2AvJX0eJJ+DaO4iNnB/osWJQ0LokZj1fg+5vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFrExHUib0n3CbzGX0ZBk9vx0kFrKBpil1M3jXioBAs=;
 b=ntqEFhlqqf5SMa7QLzu7HzDPBbQ7Mw34tb/OqYhI6yv3HAE3o85F/NKmUcoZwtttrL6GU805j91E6qmrcmkI9qrlSUNFLH857y3Yd5ZMROfQC0d0H2InsCknYAuKSQOtkJ5Ss4i7lU8dAW4bMWSR0tnnIOyV582yi9bV7L784uKtk8XheMjz1QtVt7BN3fpeVIFn3KcCFtXPYv5hLd1fa+RkOXdmTeRK4re8mjx1qbfocfI/DENMAQS0Dc2dEXoWBXZIkGREFBm4BBlYMqsePdDgMU8JR7rgnpfIz+x2WcdH37VE5VEjOYQVr6wYhTzZxan9iFNWkE4L6pqSbZR0gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFrExHUib0n3CbzGX0ZBk9vx0kFrKBpil1M3jXioBAs=;
 b=V43asT2lLrDqDgEZvrXuapwuJNBYwYBY2rMexQ7ME+22Y1GJoSDyN1l/KCePWEOBVTc9lrbILPQxrNAmLTxbRVb9fF45z7dpLr/JKATKbjYcEyt3/WLuCQG8SMIpBNNjCOSTD7gT5xFMzcT6sFWRZ8XgfJ/aUFgUy6QyCCiHbnU=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2503.namprd12.prod.outlook.com (52.132.141.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 16:45:19 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca%6]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 16:45:19 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/2] crypto: ccp - Remove unnecessary linux/pci.h include
Thread-Topic: [PATCH 2/2] crypto: ccp - Remove unnecessary linux/pci.h include
Thread-Index: AQHVSYjnhpx45qjCKUOYm/K/QdJelqbuWZWA
Date:   Tue, 6 Aug 2019 16:45:19 +0000
Message-ID: <6c1c492c-3f06-c2ee-78b8-3506250512e7@amd.com>
References: <20190802232013.15957-1-helgaas@kernel.org>
 <20190802232013.15957-3-helgaas@kernel.org>
In-Reply-To: <20190802232013.15957-3-helgaas@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:805:8e::31) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab5b766e-9dbc-4b44-3a89-08d71a8d7797
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2503;
x-ms-traffictypediagnostic: DM5PR12MB2503:
x-microsoft-antispam-prvs: <DM5PR12MB25037A68EFC94E4A5E07BF91FDD50@DM5PR12MB2503.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:56;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(199004)(189003)(31686004)(6246003)(305945005)(476003)(7736002)(25786009)(229853002)(6636002)(11346002)(36756003)(8936002)(186003)(26005)(8676002)(4326008)(486006)(3846002)(6512007)(6116002)(2616005)(6486002)(66066001)(81166006)(81156014)(53936002)(6436002)(2906002)(68736007)(446003)(478600001)(54906003)(71190400001)(64756008)(110136005)(71200400001)(66446008)(6506007)(66556008)(66476007)(316002)(102836004)(76176011)(256004)(99286004)(31696002)(5660300002)(52116002)(386003)(53546011)(14454004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2503;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IoqnzI2ElguKZLqXaQSk9ATpMDlLjAJFfbZpA6D4A/vy+J1avrknPqBH50s5RL96gUqq9UxizT643000MzAs7iEnxVQpXL3hgIOaiZqUWLX1cqU2m2SRd14JDFBvYUOPOwXlmyaNzYXJ4lZyuCOFZAHbf/zMsKgvXcEIcxZ3JzBoI8B8vh2SvyA4jX9LvPD9FiG9xCYonq79/NwMi+uFO1Co3MwMdcPx77QBCdmittx8RrhD7HUsmR4DDPT4Lx1nberca8IAPGVVxZ0VoED44XnVmz32aQyVG7hkCYBP6u4mklIhRlvZgJghowgGyV52KmhUNTqrm/CQG+fDMM76apjUMf+9waJo96wBJQQZ/RjovTQ7dSRZPi63+UbGpiangZAB6jhLouYGgbM3FlrgN+6v52k3v32ubsTcQoEaprQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5EC6B7AFA06E64DB07650397BF5D82B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5b766e-9dbc-4b44-3a89-08d71a8d7797
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 16:45:19.7664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOC8yLzE5IDY6MjAgUE0sIEJqb3JuIEhlbGdhYXMgd3JvdGU6DQo+IEZyb206IEJqb3JuIEhl
bGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5jb20+DQo+IA0KPiBSZW1vdmUgdW51c2VkIGluY2x1ZGVz
IG9mIGxpbnV4L3BjaS5oLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmpvcm4gSGVsZ2FhcyA8Ymhl
bGdhYXNAZ29vZ2xlLmNvbT4NCg0KQWNrZWQtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1k
LmNvbT4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWNyeXB0by5oIHwgMSAt
DQo+ICAgZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjMuYyB8IDEgLQ0KPiAgIGRyaXZlcnMv
Y3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMgfCAxIC0NCj4gICBkcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRldi5oICAgIHwgMSAtDQo+ICAgZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYyAgICB8IDEg
LQ0KPiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmggICAgfCAxIC0NCj4gICBkcml2ZXJz
L2NyeXB0by9jY3Avc3AtZGV2LmggICAgIHwgMSAtDQo+ICAgNyBmaWxlcyBjaGFuZ2VkLCA3IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5
cHRvLmggYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWNyeXB0by5oDQo+IGluZGV4IDYyMmIzNGMx
NzY0My4uOTAzZTc0ZTdhZDFiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWNyeXB0by5oDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLmgNCj4gQEAg
LTEyLDcgKzEyLDYgQEANCj4gICANCj4gICAjaW5jbHVkZSA8bGludXgvbGlzdC5oPg0KPiAgICNp
bmNsdWRlIDxsaW51eC93YWl0Lmg+DQo+IC0jaW5jbHVkZSA8bGludXgvcGNpLmg+DQo+ICAgI2lu
Y2x1ZGUgPGxpbnV4L2NjcC5oPg0KPiAgICNpbmNsdWRlIDxjcnlwdG8vYWxnYXBpLmg+DQo+ICAg
I2luY2x1ZGUgPGNyeXB0by9hZXMuaD4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2Nj
cC9jY3AtZGV2LXYzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12My5jDQo+IGluZGV4
IDJiN2Q0N2VkNWM3NC4uMDk5MjRmMmMyNjRmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRldi12My5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXYz
LmMNCj4gQEAgLTEwLDcgKzEwLDYgQEANCj4gICANCj4gICAjaW5jbHVkZSA8bGludXgvbW9kdWxl
Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPiAtI2luY2x1ZGUgPGxpbnV4L3Bj
aS5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9rdGhyZWFkLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4
L2ludGVycnVwdC5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9jY3AuaD4NCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRldi12NS5jDQo+IGluZGV4IDIxN2U0MWJiYWRhZi4uMGI2ZWYzMzRmOWI3IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12NS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5
cHRvL2NjcC9jY3AtZGV2LXY1LmMNCj4gQEAgLTksNyArOSw2IEBADQo+ICAgDQo+ICAgI2luY2x1
ZGUgPGxpbnV4L21vZHVsZS5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4NCj4gLSNp
bmNsdWRlIDxsaW51eC9wY2kuaD4NCj4gICAjaW5jbHVkZSA8bGludXgva3RocmVhZC5oPg0KPiAg
ICNpbmNsdWRlIDxsaW51eC9kZWJ1Z2ZzLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2RtYS1tYXBw
aW5nLmg+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oIGIvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0KPiBpbmRleCA4OWFlZTA5MDBhMDYuLjU3NzQ5YzVh
NTM3MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0KPiArKysg
Yi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQo+IEBAIC0xMiw3ICsxMiw2IEBADQo+ICAg
I2RlZmluZSBfX0NDUF9ERVZfSF9fDQo+ICAgDQo+ICAgI2luY2x1ZGUgPGxpbnV4L2RldmljZS5o
Pg0KPiAtI2luY2x1ZGUgPGxpbnV4L3BjaS5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9zcGlubG9j
ay5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9s
aXN0Lmg+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jIGIvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KPiBpbmRleCBjNjllZDRiYWUyZWIuLmI1NjVjMDhi
YmUyOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KPiArKysg
Yi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+IEBAIC0xMCw3ICsxMCw2IEBADQo+ICAg
DQo+ICAgI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9rZXJu
ZWwuaD4NCj4gLSNpbmNsdWRlIDxsaW51eC9wY2kuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvaW50
ZXJydXB0Lmg+DQo+ICAgI2luY2x1ZGUgPGNyeXB0by9zY2F0dGVyd2Fsay5oPg0KPiAgICNpbmNs
dWRlIDxjcnlwdG8vZGVzLmg+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNw
LWRldi5oIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuaA0KPiBpbmRleCBjNWUwNmM5MmQ0
MGUuLjgyYTA4NGYwMjk5MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1k
ZXYuaA0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5oDQo+IEBAIC0xMSw3ICsx
MSw2IEBADQo+ICAgI2RlZmluZSBfX1BTUF9ERVZfSF9fDQo+ICAgDQo+ICAgI2luY2x1ZGUgPGxp
bnV4L2RldmljZS5oPg0KPiAtI2luY2x1ZGUgPGxpbnV4L3BjaS5oPg0KPiAgICNpbmNsdWRlIDxs
aW51eC9zcGlubG9jay5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPg0KPiAgICNpbmNs
dWRlIDxsaW51eC9saXN0Lmg+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3At
ZGV2LmggYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtZGV2LmgNCj4gaW5kZXggOGFiZTllYTdlNzZm
Li41M2MxMjU2MmQzMWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1kZXYu
aA0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtZGV2LmgNCj4gQEAgLTEzLDcgKzEzLDYg
QEANCj4gICAjZGVmaW5lIF9fU1BfREVWX0hfXw0KPiAgIA0KPiAgICNpbmNsdWRlIDxsaW51eC9k
ZXZpY2UuaD4NCj4gLSNpbmNsdWRlIDxsaW51eC9wY2kuaD4NCj4gICAjaW5jbHVkZSA8bGludXgv
c3BpbmxvY2suaD4NCj4gICAjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4NCj4gICAjaW5jbHVkZSA8
bGludXgvbGlzdC5oPg0KPiANCg0K
