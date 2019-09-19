Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B271C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 17:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F50214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 17:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xB/vMcdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfISRAp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:00:45 -0400
Received: from mail-eopbgr820058.outbound.protection.outlook.com ([40.107.82.58]:22763
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfISRAp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 13:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Piq49f9N80pNwQjeafztVBS7JFmn5TN6rx7p8Xy6aEbnC+IbUGB3dSqV8KImYasPppsBw6591VRYVPMlmI3lw2n/EP9Pvn+I9UWI0YfmWtgWIafqgmGsmeqC7nCf+2KNqsiIHfgHfY6I8TCsJmyznZWIpF6/gXkGtkxoCUovFS7sqyY/EpYd9B0sKfZ+cxJSd8hSLW1pq/hLypom2Vf5ypSNyYJrWz9PtiicusZp1duYxc9WwkG3BXBwEnfzMUjbinb+lP+rViql62gVoKSvXn2aFgcla1aVf8ZJbmYyb7Ptqtq4k5hKIcgA4O+uiYua5vy9S2Ibo/RZ8/7oVpCi+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUjG2l5IW6N5XsYmCFfZm0v9sn9nL1hn/SA3Iw6M/8s=;
 b=Zcy0Tb/FRebNFLUp2jDnKccPm1V2oI7Q3WHm7XdNG8YO/8uY5EKz06ZI7Es86MjMFLGWhLXRaDGb4YmsdR3ZLGZUHPMVEun3Y+uNPuACtgtuyP+Lv/nOKwlUYzZi6bjinF6V7Lg045fRtEC3YwFnvpCg3R0CPXV8jcwHfMdocxvo2OwDlEX7fs1GouRXWqCaLTSaFRyE9qK6j3GILJT45KlKEDO/iiRu35soNeC/xDjDJfcvZ2A6dRvq1z3q7XS0iaf7aa6Tk3+J9cxEc+NM3eIKpIeP3uisnsaJgmodgBcDiW1mq7id8fOUfUGfkX0lHNkoGVEIWcf6glRIM4qauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUjG2l5IW6N5XsYmCFfZm0v9sn9nL1hn/SA3Iw6M/8s=;
 b=xB/vMcdbDXwLqh6qbKWvlop/1rKFAvK7yWlNqi8C2GYKSHJqFZ8NxWLieTIJQIVi1kCa09TG7eynjjk8CYr3K35LwBGewqnpfRUwjxCed0J2D/eV/927pw0mthBI93R/zhV2ZL8PvxtMvYppsnJ2b8yiy/9MzM2w4pMZ2yDSrPA=
Received: from MWHPR12MB1455.namprd12.prod.outlook.com (10.172.56.18) by
 MWHPR12MB1935.namprd12.prod.outlook.com (10.175.55.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.20; Thu, 19 Sep 2019 17:00:39 +0000
Received: from MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a872:70bf:908d:cfe4]) by MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a872:70bf:908d:cfe4%10]) with mapi id 15.20.2263.023; Thu, 19 Sep
 2019 17:00:39 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
CC:     "emamd001@umn.edu" <emamd001@umn.edu>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp - Release all allocated memory if sha type
 is invalid
Thread-Topic: [PATCH v2] crypto: ccp - Release all allocated memory if sha
 type is invalid
Thread-Index: AQHVbwP/iuwCAhY3XEu9GjXpPNVWj6czOXsA
Date:   Thu, 19 Sep 2019 17:00:39 +0000
Message-ID: <e32d4067-f115-5613-f8c8-51449a2bd9b9@amd.com>
References: <7ffc6a77-f4e3-7db9-4ec6-53d6e01d881d@amd.com>
 <20190919160449.4303-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190919160449.4303-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0025.namprd04.prod.outlook.com
 (2603:10b6:803:2a::11) To MWHPR12MB1455.namprd12.prod.outlook.com
 (2603:10b6:301:10::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d7e79f2-180f-42e5-f1d0-08d73d22e5b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR12MB1935;
x-ms-traffictypediagnostic: MWHPR12MB1935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB1935A2CBCAD2962F0A4B719CFD890@MWHPR12MB1935.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(189003)(199004)(6246003)(229853002)(5660300002)(6512007)(99286004)(102836004)(446003)(52116002)(6916009)(76176011)(26005)(71190400001)(71200400001)(53546011)(6506007)(386003)(486006)(14444005)(256004)(54906003)(316002)(11346002)(6486002)(186003)(2616005)(476003)(4744005)(6436002)(66556008)(66946007)(64756008)(81156014)(81166006)(8676002)(66066001)(4326008)(36756003)(66476007)(66446008)(14454004)(31686004)(31696002)(8936002)(2906002)(7736002)(305945005)(25786009)(478600001)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR12MB1935;H:MWHPR12MB1455.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WsvhbAshNfNW31Wnxz+h2r4sIfL+2xZMVrExSqtQ2dUe09j6LwiOCmDHm0Gj+KZFNEB9WlvvnLKF9qG4h+7JNLRsw9WBVFa9zV6uqZP0x/02tsOrumaXKLZ2cYSNSuRgYJ+p7qo29/hXzKQv+Md3fdm3OMuIkMtcs0AJLvl+SCCDuoIgkzBj0bvZ0vTPJ64+abR78gzF78GUU8x21f8+EU7Gd0S0vZ4eFQJs+FYLj3Yw3KE0GI6VxyRCts/Tmu2JzModTiD/xBgvfAbLfrRftpb9761ah3WBbgh6wBlPJgzz/blQs1jiS9utKe1Rd5XejFTVyEA9125zHcaSSTbHb/tkI2TwTwGXgga+5Se9b6Z265mGlIV60wX4hgE50BuFIa1ujpAj6F7UHN0k/xkFYneMneDvpbTq/6zV0E+wlZM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B689106E4259B243AF718D17F6A934FB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7e79f2-180f-42e5-f1d0-08d73d22e5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 17:00:39.1224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KbJ3nA/tk/8g6ysvheHFOcg79qiDmPAErakw32/rAuDDK+bveyXXTctcm1XUDTQA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1935
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDkvMTkvMTkgMTE6MDQgQU0sIE5hdmlkIEVtYW1kb29zdCB3cm90ZToNCj4gUmVsZWFz
ZSBhbGwgYWxsb2NhdGVkIG1lbW9yeSBpZiBzaGEgdHlwZSBpcyBpbnZhbGlkOg0KPiBJbiBjY3Bf
cnVuX3NoYV9jbWQsIGlmIHRoZSB0eXBlIG9mIHNoYSBpcyBpbnZhbGlkLCB0aGUgYWxsb2NhdGVk
DQo+IGhtYWNfYnVmIHNob3VsZCBiZSByZWxlYXNlZC4NCj4NCj4gdjI6IGZpeCB0aGUgZ290by4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogTmF2aWQgRW1hbWRvb3N0IDxuYXZpZC5lbWFtZG9vc3RAZ21h
aWwuY29tPg0KDQpBY2tlZC1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KDQo+
IC0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgfCAzICsrLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LW9wcy5jDQo+IGluZGV4IDliYzNjNjIxNTdkNy4uNDQwZGY5MjA4ZjhmIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cC9jY3Atb3BzLmMNCj4gQEAgLTE3ODIsOCArMTc4Miw5IEBAIHN0YXRpYyBpbnQgY2NwX3J1bl9z
aGFfY21kKHN0cnVjdCBjY3BfY21kX3F1ZXVlICpjbWRfcSwgc3RydWN0IGNjcF9jbWQgKmNtZCkN
Cj4gICAJCQkgICAgICAgTFNCX0lURU1fU0laRSk7DQo+ICAgCQkJYnJlYWs7DQo+ICAgCQlkZWZh
dWx0Og0KPiArCQkJa2ZyZWUoaG1hY19idWYpOw0KPiAgIAkJCXJldCA9IC1FSU5WQUw7DQo+IC0J
CQlnb3RvIGVfY3R4Ow0KPiArCQkJZ290byBlX2RhdGE7DQo+ICAgCQl9DQo+ICAgDQo+ICAgCQlt
ZW1zZXQoJmhtYWNfY21kLCAwLCBzaXplb2YoaG1hY19jbWQpKTsNCg0K
