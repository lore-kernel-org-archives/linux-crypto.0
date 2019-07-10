Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099EDC74A21
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 15:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5022064A
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 15:59:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="mSIhWsem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfGJP7J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 11:59:09 -0400
Received: from mail-eopbgr790082.outbound.protection.outlook.com ([40.107.79.82]:16224
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727377AbfGJP7J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 11:59:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLKmD5RCr6vU3hukzOAfhLc0iNuZxnB0FpN1sfvXgPz3INs4YvoUonRBgDsjiEQQJxN7XXIsznY+YeAXu15qUvTrjNamyUH75pMYT+MsHzeB9eRKR7c2e6/IyksUiUWrdTcCJIuIrixk2sa/cXAVst48A2qU5oiyr0ELkLFvxrgiT3R7p09dLa0btjh0Hui0GNBceFtCS94KokEiO8oZHUbkGpwmUElBAyQBhNDIajtdDpECxgwhdfL5BwqijTh0P5PKAH3+wbb2x8UijwliDT6aMeoZT7oDZ0o4p7CpSZwkETpyFDmAoEjU9+eEyn8Ei3t1KBThx+whvYPvzbmbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk+/2YFymKMOBx3oUsrftA7SHC0q4FaQV2G2LbkK/30=;
 b=U5AZx68C25vKPWrm8SwJXyGhatC7os1eGFaCCDkc7EakucLEHoSrvEBD0EzUnDoNQ1fNEp4nJxG+LGDS0lRQGLtLIaQ9iRtiTMSUFzohFApT9KIeaOz/UZ5V6qGd5kba8DgCFFEhuym49/Z9Q3SPAHUo0NtAiMlJOOdKkr7g+IWLkBPc1mKmshmSTJZQQ08WVts167AhAbfBDTtRLYfaRgfRBYCv0C0MURaShWcS0KbEM+IWJitOOo/FrBQhgNKdbIt32Cp/A6OhJcuUDX7DE1NuaZ+wCwkFz7ll2LFcxcnTi76BysAsEw83lAuEUpsXbCxSOqOofvOnK8YoFI/vkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk+/2YFymKMOBx3oUsrftA7SHC0q4FaQV2G2LbkK/30=;
 b=mSIhWsemF+H0CoWxbEN9pDDspqgQt3HeexCDpyL89gzyYgVx4FTM2J/FU2WmTEe7uslKfijUl2Re8r2go7rmxXAAWgpWuZ4WvIl4te8HblYUl6WKIWi3j0P2CwywjtAmKj0WU0zZbEzXVS1KI+WkrZq99Ru4tgVfSTspjO9x/9I=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1481.namprd12.prod.outlook.com (10.172.39.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 10 Jul 2019 15:59:05 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 15:59:05 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Topic: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVNrO6m+NQJFdJik6RYa0T/lhkoKbDGDyAgADrJoA=
Date:   Wed, 10 Jul 2019 15:59:05 +0000
Message-ID: <2875285f-d438-667e-52d9-801124ffba88@amd.com>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
In-Reply-To: <20190710015725.GA746@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:404:f7::25) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61382241-f053-43b9-a75a-08d7054f88d7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1481;
x-ms-traffictypediagnostic: DM5PR12MB1481:
x-microsoft-antispam-prvs: <DM5PR12MB14815B1406BB15CF847C8B43FDF00@DM5PR12MB1481.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(76176011)(66066001)(8676002)(26005)(64756008)(102836004)(3846002)(6436002)(386003)(6506007)(6116002)(66476007)(66556008)(2501003)(6636002)(66446008)(36756003)(53936002)(71190400001)(256004)(14444005)(71200400001)(476003)(2616005)(53546011)(6512007)(66946007)(6246003)(2906002)(52116002)(99286004)(6486002)(229853002)(14454004)(68736007)(478600001)(31696002)(5660300002)(110136005)(316002)(31686004)(486006)(11346002)(446003)(186003)(305945005)(7736002)(8936002)(81166006)(25786009)(81156014)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1481;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v2mV9+0aifbKiii8eJ3Lj7mQupoWL1jq3Ra0ze6CtkNg+Gw71gd8C+YnQy1vxHEDFpXT3Pojq0dpvVEcrD7ElBS7ZvwpVshD2emhLn+SuV7CcxR2VAuGUD4423UqroZ7H+zrUTLSdRHxSab7Xe5Be6vxbhrd772nkfZNjdu74c8eC0+wiB1M8r0M9Xynefj4PpxPmJ7srLM/+a8PTjMALgIz6dh08ST6LkHNCfaY3RamHAnzYqd8RP0+HfjHjtmFawC0Tu0opj/frTy5/K7ik9CRq0HO1ehAtVwIymJrIHAKVZK/sC7KGwRAjXNcZmXWdXlNkKUqVaZLwh/bsxj1SeFgDJf83pFU/H8e4Vjt1RP6EolNI+GYkOpznvRkSZvvtT4DuCdUlJXrLib4321Y50rRwhv/O6aFvx6HT1IFS9Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27882B6A17CD7D4FB2B198FFC5A2F461@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61382241-f053-43b9-a75a-08d7054f88d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 15:59:05.5686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1481
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy85LzE5IDg6NTcgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gT24gV2VkLCBKdWwgMTAs
IDIwMTkgYXQgMTI6MDk6MjJBTSArMDAwMCwgSG9vaywgR2FyeSB3cm90ZToNCj4+IFRoZSBBRVMg
R0NNIGZ1bmN0aW9uIHJldXNlcyBhbiAnb3AnIGRhdGEgc3RydWN0dXJlLCB3aGljaCBtZW1iZXJz
DQo+PiBjb250YWluIHZhbHVlcyB0aGF0IG11c3QgYmUgY2xlYXJlZCBmb3IgZWFjaCAocmUpdXNl
Lg0KPj4NCj4+IFRoaXMgZml4IHJlc29sdmVzIGEgY3J5cHRvIHNlbGYtdGVzdCBmYWlsdXJlOg0K
Pj4gYWxnOiBhZWFkOiBnY20tYWVzLWNjcCBlbmNyeXB0aW9uIHRlc3QgZmFpbGVkICh3cm9uZyBy
ZXN1bHQpIG9uIHRlc3QgdmVjdG9yIDIsIGNmZz0idHdvIGV2ZW4gYWxpZ25lZCBzcGxpdHMiDQo+
Pg0KPj4gRml4ZXM6IDM2Y2Y1MTViOWJiZSAoImNyeXB0bzogY2NwIC0gRW5hYmxlIHN1cHBvcnQg
Zm9yIEFFUyBHQ00gb24gdjUgQ0NQcyIpDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhv
b2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPiANCj4gRllJLCB3aXRoIHRoaXMgcGF0Y2ggYXBwbGll
ZCBJJ20gc3RpbGwgc2VlaW5nIGFub3RoZXIgdGVzdCBmYWlsdXJlOg0KPiANCj4gWyAgICAyLjE0
MDIyN10gYWxnOiBhZWFkOiBnY20tYWVzLWNjcCBzZXRhdXRoc2l6ZSB1bmV4cGVjdGVkbHkgc3Vj
Y2VlZGVkIG9uIHRlc3QgdmVjdG9yICJyYW5kb206IGFsZW49MjY0IHBsZW49MTYxIGF1dGhzaXpl
PTYga2xlbj0zMiI7IGV4cGVjdGVkX2Vycm9yPS0yMg0KPiANCj4gQXJlIHlvdSBhd2FyZSBvZiB0
aGF0IG9uZSB0b28sIGFuZCBhcmUgeW91IHBsYW5uaW5nIHRvIGZpeCBpdD8NCj4gDQo+IC0gRXJp
Yw0KPiANCg0KSSBqdXN0IHB1bGxlZCB0aGUgbGF0ZXN0IG9uIHRoZSBtYXN0ZXIgYnJhbmNoIG9m
IGNyeXB0b2Rldi0yLjYsIGJ1aWx0LCANCmJvb3RlZCwgYW5kIGxvYWRlZCBvdXIgbW9kdWxlLiBB
bmQgSSBkb24ndCBzZWUgdGhhdCBlcnJvci4gSXQgbXVzdCBiZSBuZXc/DQoNCkluIGFueSBldmVu
dCwgaWYgYSB0ZXN0IGZhaWx1cmUgb2NjdXJzLCBpdCBnZXRzIGZpeGVkLg0KDQpncmgNCg==
