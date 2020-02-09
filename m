Return-Path: <SRS0=Lfag=35=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7A6C35250
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 09:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 297B9207FF
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 09:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="uXlBtCuN";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="uXlBtCuN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgBIJeD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Feb 2020 04:34:03 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:13472
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgBIJeD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Feb 2020 04:34:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwklXwcnLHZ8DkOqCIxfqX+X27Arzi00wTpq5ZNoks=;
 b=uXlBtCuNPSEFbcVVsdxKPuCh3Tvjy8WZePBJBuZvXN/JCBW1WxQ0o1h6GMwxaxYWvd67lqMcAZoOdbog3NAjJtuz2lFklkK6DfhL9262gSCtFAKcSqx9SXdh5cLsnUOSX2PCqsXvb40N9Bfb6FMeSYt6qxIvgXL1b2aI/GPaLcs=
Received: from DB6PR0801CA0065.eurprd08.prod.outlook.com (2603:10a6:4:2b::33)
 by AM0PR08MB4050.eurprd08.prod.outlook.com (2603:10a6:208:12a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Sun, 9 Feb
 2020 09:33:53 +0000
Received: from VE1EUR03FT035.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::207) by DB6PR0801CA0065.outlook.office365.com
 (2603:10a6:4:2b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend
 Transport; Sun, 9 Feb 2020 09:33:53 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT035.mail.protection.outlook.com (10.152.18.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Sun, 9 Feb 2020 09:33:53 +0000
Received: ("Tessian outbound d1ceabc7047e:v42"); Sun, 09 Feb 2020 09:33:52 +0000
X-CR-MTA-TID: 64aa7808
Received: from 42115b886695.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1825D2EC-AC3C-4B34-B420-12499C7A94D0.1;
        Sun, 09 Feb 2020 09:33:47 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 42115b886695.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 09 Feb 2020 09:33:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8TanFTWjVdM89oykgKXe3u6PxZ/2nyURamiCjRyxPIQg5qv7VY6vEB2ymtWt7GMAH7y71mxeETXDp53QCDjFwzEKjSIsoqtE59B9YGVhFg3ni8SjL57dJww52HakvGZ8TLNBJjR4v/mK2hierglLFFNxQOTczmbAAH6fVQXlN8XwAvt6yKhmIrvPLBslMkj5tn5GOvr8aNhCC+GNmO0/2FyLjSdMpjeqMsZtoQWnS30sku95P8U1EqP2y7pX/W8LT7d9zTFx2TNQBUYfFOAGmXW5Zk/ffSlznvRDtAXv+1UYl/rjvk/bx5DafOORxkqERteb88WGyd6Wthi4dQLSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwklXwcnLHZ8DkOqCIxfqX+X27Arzi00wTpq5ZNoks=;
 b=i0CYPU2skmHbPdaqR6+Iw/IdtXy+xwEyZXk/pQPv+5owF1Gt232y9Tp1Sah8nCBEM+hkCJzlBv+2Y1AjNpoTlojcibYKtWylTVQddTXdqTXpwD7yWT6iBi4vqdGQO5WapFirjhVUdk4pfP19Bl42UNgBngj6h8BOo9hzSyvUqFV4vGyZaymPlLFXcy7CjcM1rotlyxJPITDyMzmlT9HZQq9KDGepbJTz3Hty+212FLkt0IT1vdGh2k+bmxG2xaLkqKNLahyChBzUSNCfMWeb007AendYKoMZfC3bsGkw2VUFtU/s1rIf63ostUVOxxXQ1pYGZEAPeaQyUivVclB/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwklXwcnLHZ8DkOqCIxfqX+X27Arzi00wTpq5ZNoks=;
 b=uXlBtCuNPSEFbcVVsdxKPuCh3Tvjy8WZePBJBuZvXN/JCBW1WxQ0o1h6GMwxaxYWvd67lqMcAZoOdbog3NAjJtuz2lFklkK6DfhL9262gSCtFAKcSqx9SXdh5cLsnUOSX2PCqsXvb40N9Bfb6FMeSYt6qxIvgXL1b2aI/GPaLcs=
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com (10.169.247.15) by
 AM5PR0801MB1650.eurprd08.prod.outlook.com (10.169.241.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Sun, 9 Feb 2020 09:33:45 +0000
Received: from AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec]) by AM5PR0801MB1665.eurprd08.prod.outlook.com
 ([fe80::a9de:d56:93b9:46ec%6]) with mapi id 15.20.2707.028; Sun, 9 Feb 2020
 09:33:45 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Rob Herring <robh@kernel.org>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v2 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Topic: [PATCH v2 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Thread-Index: AQHV2cyT/dIlbzGZbUmtbw6BHjqlYKgOisiAgAQId3A=
Date:   Sun, 9 Feb 2020 09:33:44 +0000
Message-ID: <AM5PR0801MB16657EDAA54655B7CBA46AF5E91E0@AM5PR0801MB1665.eurprd08.prod.outlook.com>
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-2-git-send-email-hadar.gat@arm.com>
 <20200206185651.GA14044@bogus>
In-Reply-To: <20200206185651.GA14044@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 3da1d48d-98e4-4e78-b54b-0e2934f31949.0
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.106.29]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eb290dce-b563-4ceb-9034-08d7ad432d7e
X-MS-TrafficTypeDiagnostic: AM5PR0801MB1650:|AM5PR0801MB1650:|AM0PR08MB4050:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4050527097F4AA38978D8399E91E0@AM0PR08MB4050.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0308EE423E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(346002)(396003)(366004)(136003)(189003)(199004)(9686003)(86362001)(55016002)(6506007)(966005)(186003)(478600001)(26005)(81156014)(81166006)(8936002)(8676002)(7696005)(54906003)(316002)(71200400001)(66476007)(66556008)(66946007)(64756008)(76116006)(66446008)(2906002)(33656002)(5660300002)(4326008)(6916009)(7416002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0801MB1650;H:AM5PR0801MB1665.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RF8N6ZlI6J+IqKG7LJwhd25UPWOLUBnCfvdNhZs2RAoB0ST1gEu7M3u1d4PQvKfz66IqGfxsUv0Zd+8wvYNEgnduBfKDCNV1bVAbIpPEDcRQmb8uhMsrDalye+NQThpWQ/1mugx0zlZ15DtRvH1y99hx5EvgcuC9CUG2ayZlLAq8vsFZ/Jpl4yczoCkh9PDv++FC0/Mzvxd9xtoEFMI7Xv8PwKke3KydM37N1EoB725aCWNnj0aSX5kthoiu6DQD6ItW5yj2+t1ZM4rEcFSxggOHsQuc0RWrIqryQL3ek49slPFJGllXzaGCEX7SyyKTyjOlnoKJ/yGO+bBGRsOee9jE3c34p6wOFUCQtD7WLK41Mqz9LnSqmcTEjS6cqtOF9PgKk0xPg1z8T2GkBkDW/tue5CNO3T0chU17sicULGlV4PNVXbwoe9RCdSmb1ZwW+BXrm2O39sM6fhMskLRdSixekmf/4UV5JCveLtLoyUyW3wXGAeT4g0RiBXs95L/pQcTzcIKFg6juqcou/2qh2Q==
x-ms-exchange-antispam-messagedata: JVsojlSxsf4s8Z/s2LpHLNmKVtdmp1w3JUeIaUkpqB62IMRufwrFYgBf7yghviNGOK2NyTZ1Nn5AO3ORhG90/BgZUpSt2bQ+GvTongB2/nBzRq+qzACiG0izUwSCFecu5cRT4kyRdmd1FXnbdbY33Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1650
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT035.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(376002)(136003)(189003)(199004)(336012)(186003)(5660300002)(8936002)(6862004)(54906003)(4326008)(26005)(6506007)(8676002)(36906005)(81166006)(26826003)(81156014)(2906002)(450100002)(966005)(316002)(7696005)(70586007)(70206006)(9686003)(33656002)(52536014)(86362001)(55016002)(356004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4050;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 04c6e93b-5cd5-46d2-b72d-08d7ad43289f
X-Forefront-PRVS: 0308EE423E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJjMesXBBBcFS7N0SRu6bK/fvVym84hihqMC/Ga3e1oP/2thIliVbzZkSww/WvC0kl50JiZKfA1tYv4e11MV0pR7EGltQSeN7U6P4XLNr4lAEIf9u+T0HS3D+SyipXYa+bs7UDzjGpMX+hssf8LItozRSpkGxbxb2NsZgTNvW9h2p2zC2I6xntGPUbx/kCK6+95WpOl+xnd4Tg4eGme5N+MEqbmIFssRHKGzM0Ks7Kto63Bunw2r3uxuAcXg00GNq/0fyhlrA1TF4NArWS8x1nJWWJXlPMrwVQkeQ+NPfwihzyHUdLWt6z5okEwj59jrql/PEd2r+eYIsrQNFAaUdDXBbwXyVPWxRXRv/D+sQQk28viaX0D9lJAC+czEi6IR0EZC1kkLYPJ72HHB/XZEW+Gv34CuSubNoGCfWTPBVyx6k41msROIj6m87Wd/kdUULYFxGkw+2GUqvwF/xH6y0mYIv3F8G/Gj6xM8ZLrCjqOQ2lhuv5PoxwR+9dGcj4Z8fgHUpipsy1Fwfd3RwyNxkg==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2020 09:33:53.2066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb290dce-b563-4ceb-9034-08d7ad432d7e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4050
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgUm9iLA0KVGhhbmtzIGZvciByZW1hcmtzLg0KUGxlYXNlIHNlZSBteSBhbnN3ZXJzLg0KSGFk
YXINCg0KPiBPbiBTdW4sIEZlYiAwMiwgMjAyMCBhdCAwMzoyNjo1OVBNICswMjAwLCBIYWRhciBH
YXQgd3JvdGU6DQo+ID4gVGhlIEFybSBDcnlwdG9DZWxsIGlzIGEgaGFyZHdhcmUgc2VjdXJpdHkg
ZW5naW5lLiBUaGlzIHBhdGNoIGFkZHMgRFQNCj4gPiBiaW5kaW5ncyBmb3IgaXRzIFRSTkcgKFRy
dWUgUmFuZG9tIE51bWJlciBHZW5lcmF0b3IpIGVuZ2luZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0QGFybS5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWwgICAgICAgIHwgNTENCj4gKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKQ0K
PiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3Mvcm5nL2FybS1jY3RybmcueWFtbA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvYXJtLWNjdHJuZy55YW1sDQo+ID4gYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3RybmcueWFtbA0KPiA+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMC4uZmU5NDIyZQ0KPiA+IC0tLSAv
ZGV2L251bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5n
L2FybS1jY3RybmcueWFtbA0KPiA+IEBAIC0wLDAgKzEsNTEgQEANCj4gPiArIyBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiANCj4gRHVhbCBsaWNlbnNlIG5ldyBiaW5kaW5nczoN
Cj4gDQo+IChHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlKQ0KPiANCk9rYXkuDQoNCj4gPiAr
JVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hl
bWFzL3JuZy9hcm0tY2N0cm5nLnlhbWwjDQo+ID4gKyRzY2hlbWE6IGh0dHA6Ly9kZXZpY2V0cmVl
Lm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sIw0KPiA+ICsNCj4gPiArdGl0bGU6IEFybSBacnVz
dFpvbmUgQ3J5cHRvQ2VsbCBUUk5HIGVuZ2luZQ0KPiA+ICsNCj4gPiArbWFpbnRhaW5lcnM6DQo+
ID4gKyAgLSBIYWRhciBHYXQgPGhhZGFyLmdhdEBhcm0uY29tPg0KPiA+ICsNCj4gPiArZGVzY3Jp
cHRpb246IHwrDQo+ID4gKyAgQXJtIFpydXN0Wm9uZSBDcnlwdG9DZWxsIFRSTkcgKFRydWUgUmFu
ZG9tIE51bWJlciBHZW5lcmF0b3IpDQo+IGVuZ2luZS4NCj4gPiArDQo+ID4gK3Byb3BlcnRpZXM6
DQo+ID4gKyAgY29tcGF0aWJsZToNCj4gPiArICAgIGRlc2NyaXB0aW9uOiBTaG91bGQgYmUgImFy
bSxjcnlwdG9jZWxsLTd4My10cm5nIg0KPiANCj4gRHJvcC4gVGhhdCdzIHdoYXQgdGhlIHNjaGVt
YSBzYXlzLg0KPiANCk9rYXkuDQoNCj4gPiArICAgIGNvbnN0OiBhcm0sY3J5cHRvY2VsbC03eDMt
dHJuZw0KPiANCj4gSXMgJ3gnIGEgd2lsZGNhcmQ/IFdlIGRvbid0IGRvIHdpbGRjYXJkcyB1bmxl
c3MgeW91IGhhdmUgb3RoZXIgd2F5cyB0byBnZXQgdGhlDQo+IHNwZWNpZmljIHZlcnNpb24uDQo+
IA0KS2luZCBvZiBhIHdpbGRjYXJkLiBJdCBzdGFuZHMgZm9yIGVpdGhlciA3MDMgb3IgNzEzLg0K
U2hvdWxkIEkgZml4IHRoaXMgdG8gdGhlIHNwZWNpZmljIHZlcnNpb25zPw0KT1IsDQpTaW5jZSB0
aGUgc3BlY2lmaWMgdmVyc2lvbiBkb2Vzbid0IG1hdHRlciB0byB0aGUgZHJpdmVyLCBzaG91bGQg
aXQgY2hhbmdlZD8NCihjaGVja2luZyBvdXQgb3RoZXIgcm5nIGRyaXZlcnMsIEkgc2VlIHRoaXMg
ZXhhbXBsZSBpbiBTYW1zdW5nLGV4eW5vczQueWFtbDoNCiAgLSBzYW1zdW5nLGV4eW5vczQtcm5n
CSMgZm9yIEV4eW5vczQyMTAgYW5kIEV4eW5vczQ0MTIgKQ0KDQo+ID4gKw0KPiA+ICsgIGludGVy
cnVwdHM6DQo+ID4gKyAgICBkZXNjcmlwdGlvbjogSW50ZXJydXB0IG51bWJlciBmb3IgdGhlIGRl
dmljZS4NCj4gDQo+IERyb3AuIFRoYXQncyBhbGwgJ2ludGVycnVwdHMnLg0KPiANCk9rYXkuDQoN
Cj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsgIHJlZzoNCj4gPiArICAgIGRlc2Ny
aXB0aW9uOiBCYXNlIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlIGVuZ2luZSBhbmQgbGVuZ3RoIG9m
IG1lbW9yeQ0KPiA+ICsgICAgICAgICAgICAgICAgIG1hcHBlZCByZWdpb24uDQo+IA0KPiBEcm9w
Lg0KPiANCk9rYXkuDQoNCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsgIHJvc2Mt
cmF0aW86DQo+ID4gKyAgICBkZXNjcmlwdGlvbjogU2FtcGxpbmcgcmF0aW8gdmFsdWVzIGZyb20g
Y2FsaWJyYXRpb24gZm9yIDQgcmluZyBvc2NpbGxhdG9ycy4NCj4gPiArICAgIG1heEl0ZW1zOiAx
DQo+IA0KPiBJcyB0aGlzIGFuIGFycmF5Pw0KPiANClllcywgYXJyYXkgb2YgNC4gKEknbGwgbWVu
dGlvbiBpbiB0aGUgZGVzY3JpcHRpb24pDQoNCj4gTmVlZHMgYSB2ZW5kb3IgcHJlZml4LCBhIHR5
cGUgcmVmIGFuZCBhbnkgY29uc3RyYWludHMgeW91IGNhbiBjb21lIHVwIHdpdGguDQo+IA0KRG8g
eW91IG1lYW4gaW4gdGhlIG5hbWU/IGluc3RlYWQgb2YgInJvc2MtcmF0aW8iPw0KSSBkaWRuJ3Qg
ZmluZCBhbnl0aGluZyBhYm91dCBpdCBpbiB0aGUgZG9jdW1lbnRhdGlvbiBvciBleGFtcGxlcyBp
biBvdGhlciBybmcgZHJpdmVycy4uDQoNCj4gPiArDQo+ID4gKyAgY2xvY2tzOg0KPiA+ICsgICAg
ZGVzY3JpcHRpb246IFJlZmVyZW5jZSB0byB0aGUgY3J5cHRvIGVuZ2luZSBjbG9jay4NCj4gDQo+
IEhvdyBtYW55IGNsb2Nrcz8NCj4gDQpPbmUgY2xvY2suIChJIHdpbGwgY2hhbmdlIGNsb2NrcyAt
LT4gY2xvY2spDQoNCj4gPiArDQo+ID4gK3JlcXVpcmVkOg0KPiA+ICsgIC0gY29tcGF0aWJsZQ0K
PiA+ICsgIC0gaW50ZXJydXB0cw0KPiA+ICsgIC0gcmVnDQo+ID4gKyAgLSByb3NjLXJhdGlvDQo+
ID4gKw0KPiA+ICthZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCj4gPiArDQo+ID4gK2V4YW1w
bGVzOg0KPiA+ICsgIC0gfA0KPiA+ICsgICAgYXJtX2NjdHJuZzogYXJtX2NjdHJuZ0A2MDAwMDAw
MCB7DQo+IA0KPiBybmdALi4uDQo+IA0KT2theS4NCg0KPiA+ICsgICAgICAgIGNvbXBhdGlibGUg
PSAiYXJtLGNyeXB0b2NlbGwtN3gzLXRybmciOw0KPiA+ICsgICAgICAgIGludGVycnVwdHMgPSA8
MCAyOSA0PjsNCj4gPiArICAgICAgICByZWcgPSA8MHg2MDAwMDAwMCAweDEwMDAwPjsNCj4gPiAr
ICAgICAgICByb3NjLXJhdGlvID0gPDUwMDAgMTAwMCA1MDAgMD47DQo+ID4gKyAgICB9Ow0KPiA+
IC0tDQo+ID4gMi43LjQNCj4gPg0K
