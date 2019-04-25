Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985FEC10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AA752077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="0vdS6RIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfDYHSj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:18:39 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:43339 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfDYHSj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:18:39 -0400
X-IronPort-AV: E=Sophos;i="5.60,392,1549954800"; 
   d="scan'208";a="31016543"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Apr 2019 00:18:37 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 25 Apr 2019 00:18:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPsYbhXJE8dktwG/9sUjlVVq/1wsSA4jBk1rEf8IR1E=;
 b=0vdS6RIK26fVJRG/JqbCns9rcmeWj6VpvflmQVvwu8J2vuVhoAz3ot0G8ihJ4gOmydq3Ex1TRhkRpOFumFxCdtGbTHcDC77HVqF8oCiR8yTJHLH/mftsBp+745K9Honf5sn1SuwKAlWZ+JQkllG6FWPg3PW4tfX7migqAEp3ASk=
Received: from BN6PR11MB1842.namprd11.prod.outlook.com (10.175.98.146) by
 BN6PR11MB1667.namprd11.prod.outlook.com (10.172.23.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Thu, 25 Apr 2019 07:18:35 +0000
Received: from BN6PR11MB1842.namprd11.prod.outlook.com
 ([fe80::35b3:7af:7216:8808]) by BN6PR11MB1842.namprd11.prod.outlook.com
 ([fe80::35b3:7af:7216:8808%10]) with mapi id 15.20.1835.010; Thu, 25 Apr 2019
 07:18:35 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <yuehaibing@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: atmel - remove set but not used variable
 'alg_name'
Thread-Topic: [PATCH -next] crypto: atmel - remove set but not used variable
 'alg_name'
Thread-Index: AQHU+nMrRfC7/5jyzkOhMEv8v0UqX6ZMeUCA
Date:   Thu, 25 Apr 2019 07:18:34 +0000
Message-ID: <dfb78fa4-b1c9-5c70-81e9-2fb6fc9a63f5@microchip.com>
References: <20190424075352.22828-1-yuehaibing@huawei.com>
In-Reply-To: <20190424075352.22828-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:802:2::29) To BN6PR11MB1842.namprd11.prod.outlook.com
 (2603:10b6:404:101::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tudor.Ambarus@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f456477-0742-488a-1efa-08d6c94e3a68
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BN6PR11MB1667;
x-ms-traffictypediagnostic: BN6PR11MB1667:
x-microsoft-antispam-prvs: <BN6PR11MB1667E95EE969BD59EADC3922F03D0@BN6PR11MB1667.namprd11.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(376002)(366004)(39860400002)(189003)(199004)(36756003)(54906003)(2906002)(2616005)(102836004)(2201001)(110136005)(86362001)(11346002)(6636002)(386003)(8936002)(476003)(446003)(53546011)(6116002)(6486002)(305945005)(5660300002)(316002)(486006)(66066001)(31696002)(6436002)(7736002)(3846002)(6512007)(31686004)(6506007)(6246003)(26005)(2501003)(97736004)(71190400001)(71200400001)(72206003)(64756008)(66476007)(229853002)(99286004)(53936002)(25786009)(66556008)(73956011)(14444005)(66446008)(81156014)(68736007)(66946007)(81166006)(8676002)(52116002)(478600001)(4326008)(256004)(14454004)(76176011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1667;H:BN6PR11MB1842.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MwQCzNCv2VHlPknTXd6vxz58QtyX3Qt1EfkAh3dv4Kof3b0dgoruwqpFhDuXGxQuunM1Q0UfQ5P151clxBg7YNobzrYLnbIhRLhfLtZxfnJArBhLwyxDZn66cbPFF8m9LGU7rtAuAG3H4COuz818RU/n1Bx4Ap0APdGTPzkmLRr7vP09gmQIfNqOyfTUEduNLzSdPHK9AWWVvbnw2vTJw2vIJKcREiLU//eWjx3+LQ2Ts1t+PlfjZi2hNuShb86a1HBwp1u0/fe7bffO2SYFbJAOgwY0bsOBST5c3MSeBIwOTBshovriaq/52NEASKn/DPzVXVoRSGF46By1x24gESf9sM8bYyAO8+gXoq/ZkKFkXutbVUn6kpJUYmeKK96PIVgj21SdIbrECV4w2ee2eAZl5C/GG9Qj3+yXwAaUOZw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5490E543587DA44B8347A9002C6B767F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f456477-0742-488a-1efa-08d6c94e3a68
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 07:18:34.8311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1667
X-OriginatorOrg: microchip.com
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDA0LzI0LzIwMTkgMTA6NTMgQU0sIFl1ZSBIYWliaW5nIHdyb3RlOg0KPiBGcm9tOiBZ
dWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+IA0KPiBGaXhlcyBnY2MgJy1XdW51
c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL2NyeXB0by9hdG1l
bC10ZGVzLmM6IEluIGZ1bmN0aW9uICdhdG1lbF90ZGVzX3NldGtleSc6DQo+IGRyaXZlcnMvY3J5
cHRvL2F0bWVsLXRkZXMuYzo4MDM6MTQ6IHdhcm5pbmc6IHZhcmlhYmxlICdhbGdfbmFtZScgc2V0
IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gDQo+IEl0IGlzIG5v
dCB1c2VkIGFueSBtb3JlIHNpbmNlDQo+IGNvbW1pdCA1MmVhM2NkMjkxN2IgKCJjcnlwdG86IGF0
bWVsIC0gRm9yYmlkIDIta2V5IDNERVMgaW4gRklQUyBtb2RlIikNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFR1
ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gIGRy
aXZlcnMvY3J5cHRvL2F0bWVsLXRkZXMuYyB8IDMgLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9hdG1lbC10ZGVz
LmMgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC10ZGVzLmMNCj4gaW5kZXggMTI0OTJkOS4uZmE3NjYy
MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtdGRlcy5jDQo+ICsrKyBiL2Ry
aXZlcnMvY3J5cHRvL2F0bWVsLXRkZXMuYw0KPiBAQCAtODAwLDEyICs4MDAsOSBAQCBzdGF0aWMg
aW50IGF0bWVsX3RkZXNfc2V0a2V5KHN0cnVjdCBjcnlwdG9fYWJsa2NpcGhlciAqdGZtLCBjb25z
dCB1OCAqa2V5LA0KPiAgCQkJICAgdW5zaWduZWQgaW50IGtleWxlbikNCj4gIHsNCj4gIAlzdHJ1
Y3QgYXRtZWxfdGRlc19jdHggKmN0eCA9IGNyeXB0b19hYmxrY2lwaGVyX2N0eCh0Zm0pOw0KPiAt
CWNvbnN0IGNoYXIgKmFsZ19uYW1lOw0KPiAgCXUzMiBmbGFnczsNCj4gIAlpbnQgZXJyOw0KPiAg
DQo+IC0JYWxnX25hbWUgPSBjcnlwdG9fdGZtX2FsZ19uYW1lKGNyeXB0b19hYmxrY2lwaGVyX3Rm
bSh0Zm0pKTsNCj4gLQ0KPiAgCWZsYWdzID0gY3J5cHRvX2FibGtjaXBoZXJfZ2V0X2ZsYWdzKHRm
bSk7DQo+ICAJZXJyID0gX19kZXMzX3ZlcmlmeV9rZXkoJmZsYWdzLCBrZXkpOw0KPiAgCWlmICh1
bmxpa2VseShlcnIpKSB7DQo+IA0K
