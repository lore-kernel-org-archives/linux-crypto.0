Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002D3C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 12:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C73522084D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 12:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="eXrMZdPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfKRMFY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 07:05:24 -0500
Received: from mail-eopbgr150125.outbound.protection.outlook.com ([40.107.15.125]:49838
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbfKRMFY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 07:05:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo8568+hWDm0So887Ixjn6HFr+g4YnsEIRg4nz/wOYmdUBLHxSSfxEt9xz+q5y7eg9xNHFo7x9Q0DhdRqxOSxKfQT3t71WmgsUF6he84tKrg2bvl0QPAEozA1lb9VHSVbl7UAyvX95t5ElmrnLextD5R8XKTojNErHUVZHcFiuUA3orlRgK/gy9qR5NYC7ig2loVSEgeIhn9+sRFRoEsmidOCTNT5dUoPRxML2MpPagcoZJDpF3NkVfdTolZGBMmwYO4fGhfn4ut2mSimRvMsk9MbvgycGbPA077uU8qLTlJiTMG4WVrFv3w65DgZkWoDJEhC33Ca/Il2HZ49nqM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCcwnllZMqZVQvMD0RyNhtkYrhTxWJqzfA2STXXlhN8=;
 b=BZiNaeIicrYm3KyIaPEGiMJhTOSfwLjb1PqxBWzv7R691RRnBEYxCMnYMlgI5942fg0Z8Lo8vlwB8k+7VO4b6Jlp4hsmYTzI3Fu1MkBus7sV3VAVPuWLyF+xQwkE8/9W8/Rp7NyiS7m8gViK+4v54HPfWsTgnfzyi7Ak+JgB2KgXygaPVC5tCJ9SZmOK9hWDXwB7+efo/9OH6Siz0FaICUyGP3d+bCkzrkWJcjSYRMoh1XpaHrA4rDWgCGdm2UMNqrHygBI4fC5VqKPNf3FFCF7gHiP0j9sUtkOFrPb9GryEdHg/8JdMrFuqwZudgi0Ujhyf8ugqrgo2zMS+p5kFUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCcwnllZMqZVQvMD0RyNhtkYrhTxWJqzfA2STXXlhN8=;
 b=eXrMZdPfWBtFdR6n4pacm3riYNTfpHTfAnP2nXGVPnmypfFfHlAVnOYvcWS0M2KJJicKdTgiS/ZnBUE5Sn1Bo1ZcsHtWhdHXrRU1m6vspZCNuH5TlimZYVQVaAvWJoRDJIf3hIwvUYukVjChG4ZfKO7xeZsWfVf1dcf6kroXKyg=
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB3853.eurprd07.prod.outlook.com (52.134.26.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.12; Mon, 18 Nov 2019 12:05:21 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f937:f48e:3426:cc76]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f937:f48e:3426:cc76%5]) with mapi id 15.20.2474.015; Mon, 18 Nov 2019
 12:05:21 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH] hwrng: ks-sa - Enable COMPILE_TEST
Thread-Topic: [PATCH] hwrng: ks-sa - Enable COMPILE_TEST
Thread-Index: AQHVnOAUNHp2pE7lv0mW3WjWLAGIk6eQ1zCA
Date:   Mon, 18 Nov 2019 12:05:21 +0000
Message-ID: <85eb79a6-433d-67af-0e40-1cfbdc3db781@nokia.com>
References: <20191106093019.117233-1-alexander.sverdlin@nokia.com>
 <20191115060610.2sjw7stopxr73jhn@gondor.apana.org.au>
 <20191116073229.GA161720@sol.localdomain>
 <20191117004229.xrkvij6vcd3aodnx@gondor.apana.org.au>
 <20191117004344.w4f2k4xcf73ti2z6@gondor.apana.org.au>
In-Reply-To: <20191117004344.w4f2k4xcf73ti2z6@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.166]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
x-clientproxiedby: HE1PR0101CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:3:77::27) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46b63f04-8e67-457f-08e9-08d76c1f95dd
x-ms-traffictypediagnostic: VI1PR07MB3853:
x-microsoft-antispam-prvs: <VI1PR07MB3853DA4AC2E028DDB07BC00C884D0@VI1PR07MB3853.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(66446008)(26005)(65956001)(6506007)(386003)(6436002)(66066001)(76176011)(31696002)(86362001)(53546011)(5660300002)(65806001)(102836004)(4326008)(6512007)(3846002)(11346002)(6116002)(446003)(2616005)(476003)(486006)(6486002)(4744005)(6246003)(186003)(229853002)(2906002)(8936002)(66946007)(66476007)(66556008)(64756008)(8676002)(81156014)(81166006)(14454004)(305945005)(7736002)(52116002)(25786009)(478600001)(71190400001)(71200400001)(54906003)(110136005)(36756003)(316002)(256004)(99286004)(31686004)(58126008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3853;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x5HTgnLTVfGFyUkGmcwyXUdhTTj/3RLFcp2gx4PT8EgSbPOn60Rjcnx7tzx6MFmaCEej810zW2SgXPTkVeHr+VnWYQWgJ+jbdwovl4asnqdcUvj1auRZjF8Wji1EiPiXuWKjdpBE0wNgO+ztCRht4RYQjZH8vWTcOSJ7KgEaK1oifqJHv62uTDqyF0139w283sdLZoR0K+k8sjH8gG+WP5TQ147b/aUcgyoBrcMVL1rSDYz+D8splYRheRAilVQ4m+blnQv/rmCktKRmWrTtAn3lbQ9RRoIzEYj4ihq1oJCCqwndLWho2lHP5sSw3CaZmvR1FkfPjmZ8XkV5LRE89lpqhvxuC6dzD1Mo1AEAsGwDSJY7YlZs/2cLERvoWqohwYpTM47VhHv/6+jj0VvZhqcaNEW1CuKRqMRRueme/yn0PJQNrU6531OUJYOJ+M9q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4E7601264DBC545881B271A1ACEF33E@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b63f04-8e67-457f-08e9-08d76c1f95dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 12:05:21.1500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLv8tW4HVbKS37Y1Tk8kW/nXBzLqv12jFtlsJxoh9/xMPHK33/Qgaokp/47M0QNB2P0i3/K/PRkSAxAqG8a+Mj5tFkAuCBDvMmQAJCAOzpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3853
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkhDQoNCk9uIDE3LzExLzIwMTkgMDE6NDMsIEhlcmJlcnQgWHUgd3JvdGU6DQo+IFRoaXMgcGF0
Y2ggZW5hYmxlcyBDT01QSUxFX1RFU1Qgb24gdGhlIGtzLXNhLXJuZyBkcml2ZXIuDQoNClJldmll
d2VkLWJ5OiBBbGV4YW5kZXIgU3ZlcmRsaW4gPGFsZXhhbmRlci5zdmVyZGxpbkBub2tpYS5jb20+
DQoNCj4gU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3Jn
LmF1Pg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZyBi
L2RyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZw0KPiBpbmRleCA3YzdmZWNmYTJmYjIuLjJm
M2Q1NWZlZGM0OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9LY29uZmln
DQo+ICsrKyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vS2NvbmZpZw0KPiBAQCAtNDg0LDcgKzQ4
NCw3IEBAIGNvbmZpZyBVTUxfUkFORE9NDQo+ICAJICAvZGV2L2h3cm5nIGFuZCBpbmplY3RzIHRo
ZSBlbnRyb3B5IGludG8gL2Rldi9yYW5kb20uDQo+ICANCj4gIGNvbmZpZyBIV19SQU5ET01fS0VZ
U1RPTkUNCj4gLQlkZXBlbmRzIG9uIEFSQ0hfS0VZU1RPTkUNCj4gKwlkZXBlbmRzIG9uIEFSQ0hf
S0VZU1RPTkUgfHwgQ09NUElMRV9URVNUDQo+ICAJZGVmYXVsdCBIV19SQU5ET00NCj4gIAl0cmlz
dGF0ZSAiVEkgS2V5c3RvbmUgTkVUQ1AgU0EgSGFyZHdhcmUgcmFuZG9tIG51bWJlciBnZW5lcmF0
b3IiDQo+ICAJaGVscA0KDQotLSANCkJlc3QgcmVnYXJkcywNCkFsZXhhbmRlciBTdmVyZGxpbi4N
Cg==
