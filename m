Return-Path: <SRS0=2eH/=3W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7330CC3524C
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 13:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CFB20658
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 13:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="iw1BAjEc";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="iw1BAjEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgBBNEf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Feb 2020 08:04:35 -0500
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:31525
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgBBNEf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Feb 2020 08:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhzTq6bU3tmr4n7/ocJkaXpGfB4eqsZ3atLTT/+zYnE=;
 b=iw1BAjEca4+0vPCJKo65UWqXCO/Nu3P+1+ekjfllZSIFCHP5RSDE1AMthl2Awsbqpnq6LsCAuu7+35rplpJS5GHORbslHWBW/ZINSi1ucqWwSOZ89Mds/BRCpUCc/RXJI1kDjCDHkZrCrPC858QdJvl3dea6C70dpJKD0JSNsJI=
Received: from VI1PR0801CA0090.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::34) by AM6PR08MB3591.eurprd08.prod.outlook.com
 (2603:10a6:20b:4e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32; Sun, 2 Feb
 2020 13:04:29 +0000
Received: from DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::206) by VI1PR0801CA0090.outlook.office365.com
 (2603:10a6:800:7d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.30 via Frontend
 Transport; Sun, 2 Feb 2020 13:04:29 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT060.mail.protection.outlook.com (10.152.21.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Sun, 2 Feb 2020 13:04:29 +0000
Received: ("Tessian outbound 0420f1404d58:v42"); Sun, 02 Feb 2020 13:04:29 +0000
X-CR-MTA-TID: 64aa7808
Received: from 9d15a3a38520.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D014FA81-4ABF-4FC5-98E1-C081986FC9B6.1;
        Sun, 02 Feb 2020 13:04:23 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9d15a3a38520.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 02 Feb 2020 13:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPcI39ZazZre1DdqEAETQBLEN45eWkbqS0y8yEanaxNy4l+h4ONWn9yZ0dBcrotdmf5p61s6sGdYe1lFwM4d6Tb9bpFq97F7ZsmhNXgJarjpStNIthW9ufwrj484d/9FdiX0IcwHzCwD6SId0FpKd0eKeEXAo9Xd7trlEvyi3a6QfTAm3cWUA9sHPB5no7fI/OoatolCa0nFm/SpmynR0+8IZZx5OAh3Pg+9ygC+qk/JdY7t/3//1PrEFkxEE0QflOrqc1PWjANOazH8BXtYRqwS4nhOyEDEzPCexTWerPVvCd87AB9cIf8J3Ks5qAq/BTtOBKE4cAH7xDIvv285kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhzTq6bU3tmr4n7/ocJkaXpGfB4eqsZ3atLTT/+zYnE=;
 b=kPwjdpZpED7Rg+lIleB2sRH36/OW75YvXZID6pl/YX5tZlttipXyGsvvHbD14otQb14xgNUgnc8eYpnH7HLpeJwdzjiLbEt0lunY/yHhpFTxRyD0b2N4DnD9GleIfe88pLvL+BMrBUmSJfSidRUm5auIcX+kIqEChm4HLtJCuQpwCjq9leXqgAxW89H0pQATCP1DQC3cwXLK4pNiv3uwuyWkCu7LgZlwzJHH82cNZl+0NTAHgFfeKlw7ayq7ruXp271MCt2QqQbPSsGnkyita5YAvc3KVzALrAXNFZWtI+XgJE0L2w+YcIkuqqCUSyEGjUiGG0jGwAWuUganAEbkYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhzTq6bU3tmr4n7/ocJkaXpGfB4eqsZ3atLTT/+zYnE=;
 b=iw1BAjEca4+0vPCJKo65UWqXCO/Nu3P+1+ekjfllZSIFCHP5RSDE1AMthl2Awsbqpnq6LsCAuu7+35rplpJS5GHORbslHWBW/ZINSi1ucqWwSOZ89Mds/BRCpUCc/RXJI1kDjCDHkZrCrPC858QdJvl3dea6C70dpJKD0JSNsJI=
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com (10.169.247.15) by
 AM5PR0801MB2066.eurprd08.prod.outlook.com (10.168.159.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Sun, 2 Feb 2020 13:04:21 +0000
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec]) by AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec%6]) with mapi id 15.20.2686.030; Sun, 2 Feb 2020
 13:04:21 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Rob Herring <robh@kernel.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: RE: [PATCH 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Topic: [PATCH 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Index: AQHV1PRnqZEtfroZkkOFtb+Gjzy4pqf+kfAAgAlV1+A=
Date:   Sun, 2 Feb 2020 13:04:20 +0000
Message-ID: <AM5PR0801MB166521BDC556D3725F14CD86E9010@AM5PR0801MB1665.eurprd08.prod.outlook.com>
References: <1580117304-12682-1-git-send-email-hadar.gat@arm.com>
 <1580117304-12682-2-git-send-email-hadar.gat@arm.com>
 <20200127142738.GA31451@bogus>
In-Reply-To: <20200127142738.GA31451@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: e7a4314c-c614-46a6-808b-36fa4962a534.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.106.29]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed38b58f-70c6-43cc-3081-08d7a7e07039
X-MS-TrafficTypeDiagnostic: AM5PR0801MB2066:|AM5PR0801MB2066:|AM6PR08MB3591:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3591B528E185515FA17F9987E9010@AM6PR08MB3591.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:9508;
x-forefront-prvs: 0301360BF5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39850400004)(396003)(346002)(136003)(189003)(199004)(966005)(86362001)(76116006)(2906002)(66946007)(66476007)(64756008)(66446008)(66556008)(6916009)(9686003)(8936002)(33656002)(5660300002)(186003)(81166006)(26005)(7696005)(52536014)(55016002)(316002)(4326008)(71200400001)(81156014)(8676002)(478600001)(53546011)(54906003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0801MB2066;H:AM5PR0801MB1665.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: guLDTh0HF+Yf8j3I6GRdtXRmYu0NoOtMsdg7hTYukUqotzdmTfII2pby5ykhdAs6jxAWY1Efe2pXg9ook9ggBxMMi9orcQb3C9e2XzS0b9qgjC5j1kq0NvI3rmxV8dLiZl0Uy8tIwf52pieizZvezx8lgCpSbBvgOQJvlVPj/QoSFN9bYCKSXYcAapaNQwwBcWAlB5Ad2Juwk9zYgoj1+DzyoK9gkcFRKembDBmFfQs2qUNdWW4wopAlKUqnmMCS9OVWERLJ09XoCl4gzYCQLdMxZc1qN+wp5EleRJQ/vLnCo8gFojuqoU/7XkxUyByutgY7geNNGHxzN3mkB0xKj8St4tlmShkfgR8aNDq4wYbE2YAdlyyOQwzPHlZycPp7qH6h8cZgmOeqDKiE8Vi2Um+n4hXTkxPnaZz6Hn8CB4Lf/fMGBO0pF9u90/8EngLOjGr9KHQnFKkh4hZ75QEuopYxhF+8Rxq2TKSks2mhtY+57rL7Iuhkv7XG0sAayZq4huxCA0RUEhW4XiHAphWr9A==
x-ms-exchange-antispam-messagedata: osOJXpkvRvwYUC+yaUAuSr8+HnhvVxBzIXMYBht4bOV+CTBck4sNCdYNYuyImT2Z7E6Cct5Md8FG1WV//MfJ8EQI7hgRyvKHYU/9sh4ARpBjmX0OpVLvtzoov75JoSQ/5J08+RM59DJKOtdLNeBmjQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB2066
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(346002)(376002)(199004)(189003)(53546011)(9686003)(4326008)(55016002)(6862004)(450100002)(6506007)(54906003)(316002)(186003)(7696005)(966005)(478600001)(26826003)(26005)(336012)(356004)(86362001)(70586007)(70206006)(2906002)(8936002)(81166006)(81156014)(8676002)(33656002)(52536014)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3591;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: a75be843-eeb6-4832-33fa-08d7a7e06b6e
X-Forefront-PRVS: 0301360BF5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLt0pQpqK4v1Ebl3NCJGlK/9LjfQLkThxxPPX4G5dcAR+DTssT9PgfHh8JGyLxWWliDln5MCEZwLh8xTIh13pxNtzTwGDVWRrNsZiWxczMZirD2vKmuHLh21VQYYKSCxcl3vKqCHbUkOwZ8s3iC0RPe18x499sFhqQnKHJxj/jACOUQqayMSun3ZIjybUQyK9ZobnslPfawITJoZkkgzIoeKU4nPofBxrek7e/oNrjazsJtnIzym6TOCK1QU4UwHNt8OzEB8XnFKdTbuBMH0RJZSHGYKi41LQMJc/+mVv9CIdv39qx3e7O5uZpFK4lHI/RgVU1QOjQ/Qx0lV6h1SKXSmAjXdtTHCfPVbjNZvHfRUl9yf+txCbMVALJaSzypMj5zrM3lu6PVO3Mop5NL0ql9QK344PugCzuHk6p/SVkhg3Cu6BS623Ydn1wT0083U4jCtyBjW5TcOr6BIVz2w8a3PzfjWY3gNiQ8Q9xwSRcjRFYPj3IjLFekUXINM5Yl8MrJSOa0iWaWujmnkQVL0Mw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2020 13:04:29.2422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed38b58f-70c6-43cc-3081-08d7a7e07039
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3591
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Um9iLA0KVGhhbmsgeW91IGZvciBub3RpY2luZyBhbmQgbm90aWZ5aW5nLg0KSSB3aWxsIGZpeCB0
aGlzIGFuZCByZS1zdWJtaXQuDQpIYWRhcg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4NClNlbnQ6IE1vbmRheSwgMjcgSmFu
dWFyeSAyMDIwIDE2OjI4DQpUbzogSGFkYXIgR2F0IDxIYWRhci5HYXRAYXJtLmNvbT4NCkNjOiBN
YXR0IE1hY2thbGwgPG1wbUBzZWxlbmljLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9y
LmFwYW5hLm9yZy5hdT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpv
bmF0aGFuIENhbWVyb24gPEpvbmF0aGFuLkNhbWVyb25AaHVhd2VpLmNvbT47IGxpbnV4LWNyeXB0
b0B2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBHaWxhZCBCZW4tWW9zc2VmIDxnaWxhZEBiZW55b3NzZWYuY29t
PjsgT2ZpciBEcmFuZyA8T2Zpci5EcmFuZ0Bhcm0uY29tPjsgSGFkYXIgR2F0IDxIYWRhci5HYXRA
YXJtLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBkdC1iaW5kaW5nczogYWRkIGRldmlj
ZSB0cmVlIGJpbmRpbmcgZm9yIEFybSBDcnlwdG9DZWxsIHRybmcgZW5naW5lDQoNCk9uIE1vbiwg
MjcgSmFuIDIwMjAgMTE6Mjg6MjIgKzAyMDAsIEhhZGFyIEdhdCB3cm90ZToNCj4gVGhlIEFybSBD
cnlwdG9DZWxsIGlzIGEgaGFyZHdhcmUgc2VjdXJpdHkgZW5naW5lLiBUaGlzIHBhdGNoIGFkZHMg
RFQNCj4gYmluZGluZ3MgZm9yIGl0cyBUUk5HIChUcnVlIFJhbmRvbSBOdW1iZXIgR2VuZXJhdG9y
KSBlbmdpbmUuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5j
b20+DQo+IC0tLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3RybmcueWFt
bCAgICAgICAgfCA0OSArKysrKysrKysrKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwg
NDkgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvYXJtLWNjdHJuZy55YW1sDQo+DQoNCk15IGJvdCBmb3Vu
ZCBlcnJvcnMgcnVubmluZyAnbWFrZSBkdF9iaW5kaW5nX2NoZWNrJyBvbiB5b3VyIHBhdGNoOg0K
DQp3YXJuaW5nOiBubyBzY2hlbWEgZm91bmQgaW4gZmlsZTogRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWwNCi9idWlsZHMvcm9iaGVycmluZy9saW51
eC1kdC1yZXZpZXcvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0
cm5nLnlhbWw6IGlnbm9yaW5nLCBlcnJvciBwYXJzaW5nIGZpbGUNCkRvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9kaXNwbGF5L3NpbXBsZS1mcmFtZWJ1ZmZlci5leGFtcGxlLmR0czoy
MS4xNi0zNy4xMTogV2FybmluZyAoY2hvc2VuX25vZGVfaXNfcm9vdCk6IC9leGFtcGxlLTAvY2hv
c2VuOiBjaG9zZW4gbm9kZSBtdXN0IGJlIGF0IHJvb3Qgbm9kZQ0KRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWw6ICB3aGlsZSBwYXJzaW5nIGEgYmxv
Y2sgbWFwcGluZw0KICBpbiAiPHVuaWNvZGUgc3RyaW5nPiIsIGxpbmUgNDIsIGNvbHVtbiAzIGRp
ZCBub3QgZmluZCBleHBlY3RlZCBrZXkNCiAgaW4gIjx1bmljb2RlIHN0cmluZz4iLCBsaW5lIDQ3
LCBjb2x1bW4gMw0KRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL01ha2VmaWxlOjEy
OiByZWNpcGUgZm9yIHRhcmdldCAnRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Ju
Zy9hcm0tY2N0cm5nLmV4YW1wbGUuZHRzJyBmYWlsZWQNCm1ha2VbMV06ICoqKiBbRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLmV4YW1wbGUuZHRzXSBFcnJv
ciAxDQpNYWtlZmlsZToxMjYzOiByZWNpcGUgZm9yIHRhcmdldCAnZHRfYmluZGluZ19jaGVjaycg
ZmFpbGVkDQptYWtlOiAqKiogW2R0X2JpbmRpbmdfY2hlY2tdIEVycm9yIDINCg0KU2VlIGh0dHBz
Oi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTIyOTYzOA0KUGxlYXNlIGNoZWNrIGFuZCBy
ZS1zdWJtaXQuDQpJTVBPUlRBTlQgTk9USUNFOiBUaGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBh
bmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25maWRlbnRpYWwgYW5kIG1heSBhbHNvIGJlIHByaXZp
bGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBub3Rp
ZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZG8gbm90IGRpc2Nsb3NlIHRoZSBjb250ZW50
cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2UgaXQgZm9yIGFueSBwdXJwb3NlLCBvciBzdG9yZSBv
ciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBhbnkgbWVkaXVtLiBUaGFuayB5b3UuDQo=
