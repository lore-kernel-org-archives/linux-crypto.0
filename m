Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6914DC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 01:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48167617E4
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 01:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347328AbhI3BeR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:34:17 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:10046
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229477AbhI3BeR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Sep 2021 21:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QA8+Lew5vcmsU3j3mJSnfx+/Sypt5uMMdoI7hVW05w=;
 b=TRbTBnq0v6GXLqUx98+LHzjRjuzvGsYtpXd0UaNsNQlCEvo7VeuuU0aKS01YKGl+5iXkHZnW1uLdSJ7D/SZmCQnPhpcfOEngHFQeye/isZoqLbpXsKSSdr2ilzee/i3dBhP0+GlFzSNCU38uQ4bZ5Ted7Lhg2WuCbYc/ZhSWiOI=
Received: from DB9PR06CA0023.eurprd06.prod.outlook.com (2603:10a6:10:1db::28)
 by VE1PR08MB5230.eurprd08.prod.outlook.com (2603:10a6:802:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 01:32:32 +0000
Received: from DB5EUR03FT019.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1db:cafe::73) by DB9PR06CA0023.outlook.office365.com
 (2603:10a6:10:1db::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend
 Transport; Thu, 30 Sep 2021 01:32:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT019.mail.protection.outlook.com (10.152.20.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 01:32:32 +0000
Received: ("Tessian outbound a77cafe56b47:v103"); Thu, 30 Sep 2021 01:32:30 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0056d4f357b9.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B435C8DB-0BF8-462E-AF6A-A7F998DC7A65.1;
        Thu, 30 Sep 2021 01:32:18 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0056d4f357b9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 30 Sep 2021 01:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etkeftLcDv5L/MdwOHVoQ+l6bUiKf8I1pCLqrF7s+/bvBqrbG5SGTtJAos3L34Z7FczCukEkj1Eo7svzvfzGEBH7cuWp84sqOBAMlSgQIMNwJNbkMasHv5oqvJCQtvXY9FVJpndpGckjJoxAtWLt2t6s0pQ4TYSlVQashP/wlVfNUth9puE6ECEISF1KodpWjNUKNbr6ATFndedBbbFBLczA18jO17q+BmWdGJ3HyRCfg2rBYixM8hDmGIMYBSSkHkuyHtC9e14OmwK8h77Gzhyf0hvIVVAPtYhVWanIKhzHljHhFcQsWjyTvYR0f7tDpe1YnwIT5W/pnpc9fSCPYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6QA8+Lew5vcmsU3j3mJSnfx+/Sypt5uMMdoI7hVW05w=;
 b=l1muJ+ux4M2rluTBu7r2idqPUUub4nPkugz3eOlJMFE9S6gL2PNmAy/qJ5v5i3F+4t4IJrogrzQ5urd4s29jSDh9n3RtFwVtThs1tQ2dn1t6rZZi6a4SITfiYbG1JNpxN+HvnQ4h9UgbutEeSxwSvqiCpoj5lyEQdWqM38lvvh2ZIIAMHzuLtZ3hvvQz9QPuybjQHwXi60dFO4jh3mOHV0H+cULfih3+2C4iqvx+rUGQJ5b52jbi9RRJdpf51xomFrmKYG4GuzoGDwoaoXWi9/FBARwIhiafp5fdbMeW9Pwhzfu3JB+e7+bwYPxL3UlFYGkOU25ianQcubzis48OIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QA8+Lew5vcmsU3j3mJSnfx+/Sypt5uMMdoI7hVW05w=;
 b=TRbTBnq0v6GXLqUx98+LHzjRjuzvGsYtpXd0UaNsNQlCEvo7VeuuU0aKS01YKGl+5iXkHZnW1uLdSJ7D/SZmCQnPhpcfOEngHFQeye/isZoqLbpXsKSSdr2ilzee/i3dBhP0+GlFzSNCU38uQ4bZ5Ted7Lhg2WuCbYc/ZhSWiOI=
Received: from PA4PR08MB6016.eurprd08.prod.outlook.com (2603:10a6:102:e3::9)
 by PAXPR08MB6985.eurprd08.prod.outlook.com (2603:10a6:102:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Thu, 30 Sep
 2021 01:32:16 +0000
Received: from PA4PR08MB6016.eurprd08.prod.outlook.com
 ([fe80::2567:667e:8f4e:d831]) by PA4PR08MB6016.eurprd08.prod.outlook.com
 ([fe80::2567:667e:8f4e:d831%8]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 01:32:16 +0000
From:   Xiaokang Qian <Xiaokang.Qian@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>, nd <nd@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way interleave
 of aes and ghash
Thread-Topic: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way
 interleave of aes and ghash
Thread-Index: AQHXsESW0x0OVrc26UKxttoWchWUMKu5Ay+AgAD1A4CAAdlKEA==
Date:   Thu, 30 Sep 2021 01:32:16 +0000
Message-ID: <PA4PR08MB60168642B59CCFC91A3F4ABDEEAA9@PA4PR08MB6016.eurprd08.prod.outlook.com>
References: <20210923063027.166247-1-xiaokang.qian@arm.com>
 <YVK1u4BgVAa84fMa@sol.localdomain>
 <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
In-Reply-To: <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 20F0A9F85E80A34BB06F9C0F6E7CAB64.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: f523bc41-ec65-44cf-3d6a-08d983b22c52
x-ms-traffictypediagnostic: PAXPR08MB6985:|VE1PR08MB5230:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5230BE379771B5444E231E13EEAA9@VE1PR08MB5230.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Mzh8SioYVY5BinVtLRJ6WyJftjleWCFjctmLmKOA3dU/JUfRFnbxE2e85THeLtpZniwoGay+8p+LWqrE5guca4uKUxiktGzJy+MroddDm/4aWWH2+1gzc0gmK3HSAl52gXRnch91bQ5MOTI0XHIHrFBlQbL8Vq/iHHivT+WvltFyhImQ3HHPODa9wjowSyAla2EE1FXv31zo6SDSyKEgrvqafhFiXtIWbi+lmfi9W+JjkKuIsi1GvD7KUzkP0V182ERq5+bQtRyl7WIS5Zj+QmFIsJrKqPLkuSaWsk4csNBFuFntz2Nrwuwzl9UNA2UOPj7c+7f52grJlcVhJ0yju3B9TcNyAg+ySMUJujMA1IC+qUA8/8qz2QB3bQQJkJ66E8IkJtjIXbJWCBeo7czog0QC71hy7Cy6HYncZ6MzaON8CLtT3jA6s3TkmVNgG0oOsWuPu7A1hsfkDeCNO3SAdA5FE7e8rkM9zvdb9dLPBH2d+IVzJZ1VeaJJsyGmaPHXaTzpxPyKK/Rig2gf8kYbinPFn2pDqIl/fzaaOSUMsft6qFtm3sVly7Xp+h8N//3m8zCyMX8g3Y0oBhRshzIMSj4VJ2z97FvithvQd0EyIsERVNNJJrFu+ZXNOi0FhuNPmIhpj98wo28sg7t+byRe8I7XGQkPkd9COIMQsPyi1mu2ql+cGelkymFyN+V4YQsCQeAVBPifdC3kXywUbHcxcg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR08MB6016.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(53546011)(6506007)(66476007)(4326008)(8936002)(66946007)(33656002)(186003)(2906002)(38100700002)(7696005)(66556008)(66446008)(64756008)(76116006)(5660300002)(52536014)(55016002)(122000001)(110136005)(26005)(71200400001)(86362001)(8676002)(83380400001)(9686003)(54906003)(508600001)(316002);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6985
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7751ccaa-c401-47da-2b4a-08d983b222ff
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PcEstBFEjgSj6t1U+zs+J1QTjSSVizonn5KeXdiqlMqWP+g0gB9oVmFNLHADq8UfVfgufFZxLo9Wc7Uz4lbQrxb7TGyDnnU7N1vApwSG5GJR27CdTL50MiWdNrsL/IIsAIKPpzvS9lLvz0yIb1E3th4WhLrwkfaiaLa7/RmqrCBu/JLUOT4Mam3sLb1t6WocET7EcBSzI94fkM4Ex2h0uDsl3Pt6iAJQS3ovQ6Isrp4ZCzpn6FpPHhRZ65Gs2Ie91GcZGvkg5SYbytcQVqMhQnNClLo9jAdd4lXDJkrePa8StisAswiChf7+rFm8jIDxdW49ubFgmPG9jVY7NFgOvkxJL0UdVj9HRJa2ZL1CDO4AYRazwRhMWgSHPXaKZ84XN+8C81RNNB/rUv+feZi3hBuckZ1kLmWH+cdimU1QJ0Fii6FgRv/UonEsM/EbiD3pCF42+XhxtGdncDJchfL6mUYOWKCzx+PdJbHdzL//8uYLNsNj0mI2Y+QvTD/S+/eHq+yFoyLCQkktsgvj6jq2Ufig6r0rMFNrkDyVwIsl2dENC3qRScWKuuawg3wo9Iz3XwIeaGpDS519eV8e8sBytO4dEUazKLmbjr/fB5yzInCupJrGKQWhEMVQl30KlTxbDO5/FoD6sUj/SHH9+iXSSTD+OCYNEGNoQ/i4n3p4Rde3UNp40BjOUjmmo9FO2Y5/y7ogPlYHBXBV8WnPwV1mUA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(336012)(4326008)(316002)(55016002)(110136005)(9686003)(70586007)(86362001)(81166007)(356005)(450100002)(70206006)(36860700001)(186003)(82310400003)(508600001)(53546011)(5660300002)(47076005)(33656002)(26005)(2906002)(6506007)(8936002)(83380400001)(7696005)(8676002)(52536014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 01:32:32.0550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f523bc41-ec65-44cf-3d6a-08d983b22c52
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5230
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQpJIHdpbGwgZmlyc3RseSBjaGFuZ2UgdGhlIGRlY3J5
cHQgcGF0aCB0byBjb21wYXJlIHRoZSB0YWcgdXNpbmcgU0lNRCBjb2RlLCBhbmQgdGhlbiAgcGFz
cyBhbGwgb2YgdGhlIHNlbGYgdGVzdHMgaW5jbHVkZSBmdXp6IHRlc3RzKGVuYWJsZWQgYnkgQ09O
RklHX0NSWVBUT19NQU5BR0VSX0VYVFJBX1RFU1RTPXkpLCBiaWcgZW5kaWFuICxsaXR0bGUgZW5k
aWFuIHRlc3RzLg0KDQpBYm91dCB0aGUgMUsgZGF0YSBwb2ludCwgSSBqdXN0IHJlbWVtYmVyIHRo
YXQgdGhlIDE0MjAgYnl0ZXMgcGFja2V0IGlzIGNvbW1vbmx5IHVzZWQgaW4gSVBTRUMuDQoNCg0K
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtl
cm5lbC5vcmc+IA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjEgNTowNCBBTQ0K
VG86IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAa2VybmVsLm9yZz4NCkNjOiBYaWFva2FuZyBRaWFu
IDxYaWFva2FuZy5RaWFuQGFybS5jb20+OyBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBDYXRhbGlu
IE1hcmluYXMgPENhdGFsaW4uTWFyaW5hc0Bhcm0uY29tPjsgV2lsbCBEZWFjb24gPHdpbGxAa2Vy
bmVsLm9yZz47IG5kIDxuZEBhcm0uY29tPjsgTGludXggQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGlu
dXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47IExpbnV4IEFSTSA8bGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnPjsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdCA8bGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZz4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIGNyeXB0bzogYXJtNjQv
Z2NtLWNlIC0gdW5yb2xsIGZhY3RvcnMgdG8gNC13YXkgaW50ZXJsZWF2ZSBvZiBhZXMgYW5kIGdo
YXNoDQoNCk9uIFR1ZSwgMjggU2VwdCAyMDIxIGF0IDA4OjI3LCBFcmljIEJpZ2dlcnMgPGViaWdn
ZXJzQGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBPbiBUaHUsIFNlcCAyMywgMjAyMSBhdCAwNjoz
MDoyNUFNICswMDAwLCBYaWFva2FuZ1FpYW4gd3JvdGU6DQo+ID4gVG8gaW1wcm92ZSBwZXJmb3Jt
YW5jZSBvbiBjb3JlcyB3aXRoIGRlZXAgcGlwbGluZXMgc3VjaCBhcyBBNzIsTjEsIA0KPiA+IGlt
cGxlbWVudCBnY20oYWVzKSB1c2luZyBhIDQtd2F5IGludGVybGVhdmUgb2YgYWVzIGFuZCBnaGFz
aCANCj4gPiAodG90YWxseQ0KPiA+IDggYmxvY2tzIGluIHBhcmFsbGVsKSwgd2hpY2ggY2FuIG1h
a2UgZnVsbCB1dGlsaXplIG9mIHBpcGVsaW5lcyANCj4gPiByYXRoZXIgdGhhbiB0aGUgNC13YXkg
aW50ZXJsZWF2ZSB3ZSB1c2VkIGN1cnJlbnRseS4gSXQgY2FuIGdhaW4gDQo+ID4gYWJvdXQgMjAl
IGZvciBiaWcgZGF0YSBzaXplcyBzdWNoIHRoYXQgOGsuDQo+ID4NCj4gPiBUaGlzIGlzIGEgY29t
cGxldGUgbmV3IHZlcnNpb24gb2YgdGhlIEdDTSBwYXJ0IG9mIHRoZSBjb21iaW5lZCANCj4gPiBH
Q00vR0hBU0ggZHJpdmVyLCBpdCB3aWxsIGNvLWV4aXN0IHdpdGggdGhlIG9sZCBkcml2ZXIsIG9u
bHkgc2VydmUgDQo+ID4gZm9yIGJpZyBkYXRhIHNpemVzLiBJbnN0ZWFkIG9mIGludGVybGVhdmlu
ZyBmb3VyIGludm9jYXRpb25zIG9mIEFFUyANCj4gPiB3aGVyZSBlYWNoIGNodW5rIG9mIDY0IGJ5
dGVzIGlzIGVuY3J5cHRlZCBmaXJzdCBhbmQgdGhlbiBnaGFzaGVkLCANCj4gPiB0aGUgbmV3IHZl
cnNpb24gdXNlcyBhIG1vcmUgY29hcnNlIGdyYWluZWQgYXBwcm9hY2ggd2hlcmUgYSBjaHVuayBv
ZiANCj4gPiA2NCBieXRlcyBpcyBlbmNyeXB0ZWQgYW5kIGF0IHRoZSBzYW1lIHRpbWUsIG9uZSBj
aHVuayBvZiA2NCBieXRlcyBpcyANCj4gPiBnaGFzaGVkIChvciBnaGFzaGVkIGFuZCBkZWNyeXB0
ZWQgaW4gdGhlIGNvbnZlcnNlIGNhc2UpLg0KPiA+DQo+ID4gVGhlIHRhYmxlIGJlbG93IGNvbXBh
cmVzIHRoZSBwZXJmb3JtYW5jZSBvZiB0aGUgb2xkIGRyaXZlciBhbmQgdGhlIA0KPiA+IG5ldyBv
bmUgb24gdmFyaW91cyBtaWNyby1hcmNoaXRlY3R1cmVzIGFuZCBydW5uaW5nIGluIHZhcmlvdXMg
bW9kZXMgDQo+ID4gd2l0aCB2YXJpb3VzIGRhdGEgc2l6ZXMuDQo+ID4NCj4gPiAgICAgICAgICAg
ICB8ICAgICBBRVMtMTI4ICAgICAgIHwgICAgIEFFUy0xOTIgICAgICAgfCAgICAgQUVTLTI1NiAg
ICAgICB8DQo+ID4gICAgICAjYnl0ZXMgfCAxMDI0IHwgMTQyMCB8ICA4ayB8IDEwMjQgfCAxNDIw
IHwgIDhrIHwgMTAyNCB8IDE0MjAgfCAgOGsgfA0KPiA+ICAgICAgLS0tLS0tLSstLS0tLS0rLS0t
LS0tKy0tLS0tKy0tLS0tLSstLS0tLS0rLS0tLS0rLS0tLS0tKy0tLS0tLSstLS0tLSsNCj4gPiAg
ICAgICAgIEE3MiB8IDUuNSUgfCAgMTIlIHwgMjUlIHwgMi4yJSB8ICA5LjUlfCAgMjMlfCAtMSUg
IHwgIDYuNyV8IDE5JSB8DQo+ID4gICAgICAgICBBNTcgfC0wLjUlIHwgIDkuMyV8IDMyJSB8IC0z
JSAgfCAgNi4zJXwgIDI2JXwgLTYlICB8ICAzLjMlfCAyMSUgfA0KPiA+ICAgICAgICAgTjEgIHwg
MC40JSB8ICA3LjYlfDI0LjUlfCAtMiUgIHwgIDUlICB8ICAyMiV8IC00JSAgfCAgMi43JXwgDQo+
ID4gMjAlIHwNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpYW9rYW5nUWlhbiA8eGlhb2thbmcu
cWlhbkBhcm0uY29tPg0KPg0KPiBEb2VzIHRoaXMgcGFzcyB0aGUgc2VsZi10ZXN0cywgaW5jbHVk
aW5nIHRoZSBmdXp6IHRlc3RzIHdoaWNoIGFyZSANCj4gZW5hYmxlZCBieSBDT05GSUdfQ1JZUFRP
X01BTkFHRVJfRVhUUkFfVEVTVFM9eT8NCj4NCg0KUGxlYXNlIHRlc3QgYm90aCBsaXR0bGUtZW5k
aWFuIGFuZCBiaWctZW5kaWFuLiAoTm90ZSB0aGF0IHlvdSBkb24ndCBuZWVkIGEgYmlnLWVuZGlh
biB1c2VyIHNwYWNlIGZvciB0aGlzIC0gdGhlIHNlbGYgdGVzdHMgYXJlIGV4ZWN1dGVkIGJlZm9y
ZSB0aGUgcm9vdGZzIGlzIG1vdW50ZWQpDQoNCkFsc28sIHlvdSB3aWxsIGhhdmUgdG8gcmViYXNl
IHRoaXMgb250byB0aGUgbGF0ZXN0IGNyeXB0b2RldiB0cmVlLCB3aGljaCBjYXJyaWVzIHNvbWUg
Y2hhbmdlcyBJIG1hZGUgcmVjZW50bHkgdG8gdGhpcyBkcml2ZXIuDQoNCkZpbmFsbHksIEknZCBs
aWtlIHRvIGRpc2N1c3Mgd2hldGhlciB3ZSByZWFsbHkgbmVlZCB0d28gc2VwYXJhdGUgZHJpdmVy
cyBoZXJlLiBUaGUgMWsgZGF0YSBwb2ludCBpcyBub3QgYXMgcmVsZXZhbnQgYXMgdGhlIG90aGVy
IG9uZXMsIHdoaWNoIHNob3cgYSB3b3J0aHdoaWxlIHNwZWVkdXAgZm9yIGFsbCBtaWNybyBhcmNo
aXRlY3R1cmVzIGFuZCBkYXRhIHNpemVzIChhbHRob3VnaCBJIHdpbGwgZ2l2ZSB0aGlzIGEgc3Bp
biBvbiBUWDIgbXlzZWxmIHdoZW4gSSBoYXZlIHRoZQ0KY2hhbmNlKQ0KDQoqSWYqIHdlIHN3aXRj
aCB0byB0aGlzIGltcGxlbWVudGF0aW9uIGNvbXBsZXRlbHksIEkgd291bGQgbGlrZSB0byBrZWVw
IHRoZSBpbXByb3ZlbWVudCBJIGFkZGVkIHJlY2VudGx5IHRvIHRoZSBkZWNyeXB0IHBhdGggdG8g
Y29tcGFyZSB0aGUgdGFnIHVzaW5nIFNJTUQgY29kZSwgcmF0aGVyIHRoYW4gY29weWluZyBpdCBv
dXQgYW5kIHVzaW5nIG1lbWNtcCgpLg0KQ291bGQgeW91IGxvb2sgaW50byBhZG9wdGluZyB0aGlz
IGZvciB0aGlzIHZlcnNpb24gYXMgd2VsbD8NCg0KLS0NCkFyZC4NCg==
