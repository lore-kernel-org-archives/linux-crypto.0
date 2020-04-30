Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15617C83001
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 07:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D7A2186A
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 07:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="x9mTVs1e";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="x9mTVs1e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgD3HkB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:40:01 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:49047
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgD3HkA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 03:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8S/crWBvfLr9jJA9paKCRP8NvxnfdIc+wWPc3lQj5N8=;
 b=x9mTVs1ewHQVN4hSqRiT2UzsYSbB7xnPjd08ac9mXzFEv9AxFMnOwiaADL500vLK0HtfTlCvLC5zcpYwh92igtkfGxSFW68Bvnraffb5MClDRpzRGjXCMb0WTccoEaAFszFGQODEb9fcOihkEozVgZ2eIZoTNv52HyzHYNfKWK0=
Received: from DB8PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:100::41)
 by HE1PR0802MB2411.eurprd08.prod.outlook.com (2603:10a6:3:db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 07:39:20 +0000
Received: from DB5EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:100:cafe::5c) by DB8PR06CA0028.outlook.office365.com
 (2603:10a6:10:100::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Thu, 30 Apr 2020 07:39:20 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT059.mail.protection.outlook.com (10.152.21.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 07:39:20 +0000
Received: ("Tessian outbound e88319d7ccd0:v54"); Thu, 30 Apr 2020 07:39:20 +0000
X-CR-MTA-TID: 64aa7808
Received: from 589ab3dab264.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 90CBE0B6-7567-47E8-92B4-F0BA61946735.1;
        Thu, 30 Apr 2020 07:39:15 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 589ab3dab264.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 30 Apr 2020 07:39:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4dOUNEyxx2YSwDAEnxS8c2XVW3IYVDo7hn3CYjYgr5ahtob8E+fmVXMWUFDquL7uO35RJwfJtO9R+6IBWg7ZlpJx1tkiewG20qm3Ry4idvoIAEstKa6CdMtm7MvA261DlxyXbXSfZTzjyNMCVAdjKdB99H7EORpZdH1pujipQq5NrHsGJk0yiHhZkYLa8MvS7Bpsufiz4S20bv95s5sPr05QMrjfLNyzOjViiWiJIuGX4plmLe9pdBTbue+gkbyDdn3A+PvMao5yUj1gJ5kVNLaB2x6ipruLwtHIK968RWeldLHiAGEg1fwe5tvNTxdNjqNGZIZbku4zy/8OPLSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8S/crWBvfLr9jJA9paKCRP8NvxnfdIc+wWPc3lQj5N8=;
 b=X5lwBE1s3wsOfFFho0O7CrdiwXrvgyw4n0CuNmA8tjAVHKUy9IfO282iDZEHliyZl42lEsjThp5EY0g0dHXJt65GAOGMDpb9qlEPf04u1cXZUMIttG/0RcU6/9YbijIKFZOzGGurtPoTJnhC10dmg2aiekyfCt3jXIgXB6pEodTk20n4mGs3LD0vo0pUc6c1YdkVpff5AtChbuadAUA9N6DP2baNUQilcnkdrK0KHHl0MzktVBClWfUcbXxyezJggSsF9a4AImq72sVQ3Sqy5KPOaHee7NLZ/LOFsZRv99znGcMm8JjFnmiGhp2iESRMbxfw46eThSQEedWSC8scdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8S/crWBvfLr9jJA9paKCRP8NvxnfdIc+wWPc3lQj5N8=;
 b=x9mTVs1ewHQVN4hSqRiT2UzsYSbB7xnPjd08ac9mXzFEv9AxFMnOwiaADL500vLK0HtfTlCvLC5zcpYwh92igtkfGxSFW68Bvnraffb5MClDRpzRGjXCMb0WTccoEaAFszFGQODEb9fcOihkEozVgZ2eIZoTNv52HyzHYNfKWK0=
Received: from AM6PR08MB2999.eurprd08.prod.outlook.com (2603:10a6:209:44::28)
 by AM6PR08MB3366.eurprd08.prod.outlook.com (2603:10a6:20b:47::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 07:39:14 +0000
Received: from AM6PR08MB2999.eurprd08.prod.outlook.com
 ([fe80::889a:5795:8fec:3bf1]) by AM6PR08MB2999.eurprd08.prod.outlook.com
 ([fe80::889a:5795:8fec:3bf1%3]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 07:39:14 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Topic: [PATCH v3 1/3] hwrng: cctrng - Add dependency on OF
Thread-Index: AQHWHIgZN7YKol1Tq02g1xaDTWU+daiNEe0AgAFkcMCAAAISgIAC0ikg
Date:   Thu, 30 Apr 2020 07:39:14 +0000
Message-ID: <AM6PR08MB2999F52B99066C321837144DE9AA0@AM6PR08MB2999.eurprd08.prod.outlook.com>
References: <1587987364-4566-1-git-send-email-hadar.gat@arm.com>
 <1587987364-4566-2-git-send-email-hadar.gat@arm.com>
 <20200427150658.GA26305@gondor.apana.org.au>
 <DB7PR08MB3003E1459755B853B41490D6E9AC0@DB7PR08MB3003.eurprd08.prod.outlook.com>
 <20200428123007.GA3969@gondor.apana.org.au>
In-Reply-To: <20200428123007.GA3969@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 94bc7d7d-bad9-4720-8ce4-0da89ccbe9b4.1
x-checkrecipientchecked: true
Authentication-Results-Original: gondor.apana.org.au; dkim=none (message not
 signed) header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [84.109.179.203]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44e062b5-b605-4129-55fe-08d7ecd9989a
x-ms-traffictypediagnostic: AM6PR08MB3366:|AM6PR08MB3366:|HE1PR0802MB2411:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0802MB2411A4B0BDC5DF13DE34CE93E9AA0@HE1PR0802MB2411.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3173;OLM:3173;
x-forefront-prvs: 0389EDA07F
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB2999.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(478600001)(316002)(5660300002)(186003)(966005)(4744005)(83080400001)(7416002)(4326008)(86362001)(6916009)(76116006)(54906003)(71200400001)(33656002)(9686003)(7696005)(66476007)(66446008)(64756008)(6506007)(66556008)(8676002)(8936002)(2906002)(52536014)(26005)(55016002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: WMptA537aj58Dvmu4ds65hqe10zOvUFnDPsChr96HEgdaW9kO+QXa2nS3KkpIKbdg0D402YSOBqo6g28lQejKA93yQbS+RxY9Mo8R3f6otvPaPySYdgvQPEhN6CjorLapskRktuw/jmTfsItlEgDx3U7X5uzbZ4hcpnOkVEx8wuLeRvEExO/Vm/R2P1Rhbiu9fFMXcdctf2q6ajxwBByFB2GUSyKT4aDFwEKQDbTr1ZopoIASLKggXoT7AQWBCdVgY05enl0uDDZLXuMaK2nJVxvHPc/ZBGltI1v75Py7jU3e2vW9iOBnHkvvzDEIQTY5wFxuuHnWOofnrEdLDKYY7/Ah914v/tAvPZGwDrHVhZ4+GBEZ9by1SGeMKOmUvmE7Nm0JVUub7FADFmNeSH1cTTkNHjimti8ZLXD+j0KRI/yS2hT7jCK7nMiHVKzSdV5Mp58qyOin8cg4xnAJ4uDs7wG+bhfBlEETWhPXgn5LoJRHAW1WYhpb12drtWl8g/3vx/4ffWJPFerXwb6lxGH1g==
x-ms-exchange-antispam-messagedata: VWKkVXDsEOs1fEhmFgg4Z+ZK4agi1x+gYkAl4UU3z0DhEs32xAiVLM1lilrfWAqJKhFWgtSAUKdbfe2HOQTHXjF5q2geE1EIamcIin/bv56mMobSLhlkKsxpS4TYQpwxMvN9ln3fdkw2K3weZwPkflti6CZ0bFs7jJEKEvmYvM5J2ovKgyWwAaX3m+PyWEJQrzQtFF05FswscMy0TZcgERAfUZ7bVcv+jXbSYhzy+ySLfkPwELnIl/jsjWJx2DobwVUvpanhn7b3KuOW3cAJH2/Yei+ByBb1/E/SHaTr0irRyjR2hwZyUfOkfky7A2cH8wZ//+HDDB2T3FL2MZoUkpzoaMayfSBzZj+pOeVk9KeaK0vA41YkQGyTOOnhrVFEPcKE7IeDdPciKgje3LfoOEKHP4cpOQ2GrH6lhOVjhqJa3ma4qkAsGqX1S+1Q7l6MbdhawVNaWcx5aZ+V8B8AWdsDKtYiZZgcueYUuEczt1ThpGTKuAfCUwy34dvKzAjz/HeR0k5KpTLkM0PIf6fy8pY+hdJ7lxp27bQ/CPxZT72bk84x3N92gcWuMR5ijSnmn+rQoW3cuxDudibGU7qMYJK6r42JIqlSLhE/dYEC1Ntl+6zOJ0R81x55pUEu8uIj8nu04n8flTltigc5oJLhk6UXPRcf/vomDac7Agud8XTvvB/OyldyChgivpc3YgO8Hq7YPZ+XZkBqFSsbciRUZ8C9vqWbAeBblEGGrS41dbzB8FFlHCy7VRuLjl+PDyTcFnzWG3CMLzMwa8xZnqF0BWP1mHMP+m3Qdm6gN24Cb54=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3366
Original-Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966005)(70586007)(82310400002)(316002)(336012)(83080400001)(70206006)(33656002)(81166007)(450100002)(356005)(4326008)(47076004)(8676002)(52536014)(54906003)(82740400003)(9686003)(55016002)(6862004)(966005)(186003)(8936002)(7696005)(6506007)(478600001)(26005)(2906002)(4744005)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: c5110742-4e48-4e5d-7810-08d7ecd994b9
X-Forefront-PRVS: 0389EDA07F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjRsRYssbVyjj3l+pCjqr/CpqGNS3XawmYAv47TeelLyDNk//iPpgBzpSZqNI0HPUOA4QCcxeKrRa0maWtMoWP3ECkZEwu/PbVtaQzUit5HKCgb/yGmirZLFv272DHybY5HbpXQ7wsJDNSX1xtYC40ert58KoiRCKD9C8AslCm3CJnNnhFuaI6QrWIGEXItUGxUUjVVO2KQbG/fgSYXTxOM7fH7dLrsN81eKPmhqh3So8Bsxif1UGj7oX3Y9KpjMmaQ67f9ktX8PDfAtCjV0PGerMwnIDR7bOsAklvUf4zM5Burfl7dowgy2vB+zqOGn4u3jPObxmutLJJqZnxoFJ8mFLWzXS4agdZLMCMgIEFnW1+bzNpRRFfQeYKv106c/DoprKkoWnBfWMoGTr9qPuIRwS//AIFhiYNb/IpTTXgO+EZR8EiG+cjMgaYbUQiY2vKlqt71b+7L07jxglGKa8p8HtVb59hL7pB32BMVBw3PbTSKE1idA16zyEvkRFV1pYGIyYdrxjHOh7zyweF9x5sAnQC2djuo0SUJEd35BCLZkSmaXXOZSnYbBtr8tOQVZIPzFU0JY54zj0zD+z+Zbag==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 07:39:20.8414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e062b5-b605-4129-55fe-08d7ecd9989a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2411
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNyeXB0by1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0by0NCj4gb3duZXJAdmdlci5rZXJuZWwub3Jn
PiBPbiBCZWhhbGYgT2YgSGVyYmVydCBYdQ0KPiANCj4gT24gVHVlLCBBcHIgMjgsIDIwMjAgYXQg
MTI6MjY6MzFQTSArMDAwMCwgSGFkYXIgR2F0IHdyb3RlOg0KPiA+DQo+ID4gSSd2ZSBzZXQgQ09N
UElMRV9URVNUIGJ1dCBjb3VsZG4ndCBzZWUgYW55IHByb2JsZW0uDQo+ID4gV291bGQgeW91IHNo
YXJlIHdoYXQgZG9lc24ndCB3b3JrPw0KPiANCj4gSSBkb24ndCBoYXZlIE9GIGluIG15IGNvbmZp
Zy4gIFRoaXMgZHJpdmVyIGJ1aWxkcyBqdXN0IGZpbmUgd2l0aG91dCBPRi4NCg0KWWVzLCBpdCBi
dWlsZHMsIGJ1dCBpdCBpcyB1c2VsZXNzLg0KSW4gaW5jbHVkZS9saW51eC9vZi5oIHRoZXJlIGFy
ZSBkZWZpbml0aW9ucyBmb3Igb2ZfcHJvcGVydHlfcmVhZCooKSBmdW5jdGlvbnMgIGZvciB0aGUg
Y2FzZSBvZiBPRl9DT05GSUcgbm90IGJlaW5nIGRlZmluZWQgdGhhdCBzaW1wbHkgcmV0dXJucyAt
RU5PU1lTLg0KDQo+IA0KPiBDaGVlcnMsDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJi
ZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+IEhvbWUgUGFnZToNCj4gaHR0cDovL2dvbmRvci5hcGFu
YS5vcmcuYXUvfmhlcmJlcnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1
L35oZXJiZXJ0L3B1YmtleS50eHQNCg==
