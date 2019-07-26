Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0720C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA6F82166E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="PvHjgGbT";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="PvHjgGbT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGZN0e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:26:34 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:31652
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfGZN0e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESqHjEql3PBpiwCHD7oMtAYya2uwGymYUbv54hmulI0=;
 b=PvHjgGbTrX5MqiJOBXm30vfSvnZIYWy3l2JcUDQjui0i3skt7Lq1bZQSZdjsOlpSvIP8520WdmpmBL24DQp2sp88TrtXwgRt4GIyk6qi6L0EJpYP8CJ3w+HgV8XkRHZv0/nBao2cqB+woBKBRcIQbVUt/bP842gxRF7iQ99hSq0=
Received: from DB7PR08CA0021.eurprd08.prod.outlook.com (2603:10a6:5:16::34) by
 DB8PR08MB4953.eurprd08.prod.outlook.com (2603:10a6:10:ef::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 13:26:27 +0000
Received: from AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::204) by DB7PR08CA0021.outlook.office365.com
 (2603:10a6:5:16::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.10 via Frontend
 Transport; Fri, 26 Jul 2019 13:26:27 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT027.mail.protection.outlook.com (10.152.16.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18 via Frontend Transport; Fri, 26 Jul 2019 13:26:26 +0000
Received: ("Tessian outbound 578a71fe5eaa:v26"); Fri, 26 Jul 2019 13:26:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c3b8dc55a5f56b90
X-CR-MTA-TID: 64aa7808
Received: from 270b42b215b4.1 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.10.57])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id AA3A952F-A107-496E-BD22-4B9E4A1DFF71.1;
        Fri, 26 Jul 2019 13:26:20 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2057.outbound.protection.outlook.com [104.47.10.57])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 270b42b215b4.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Fri, 26 Jul 2019 13:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiY86JDiEvTPORzZU5V+SCzP4P8JXtJBeZR+MscvFwr0PBw9ofAIFnNdwyLAw9XmQefBBAqLT1HGtCG3V/h7Fgf1T/Plb+kPxWxt8lleLo7XU3u68G4p306AosBPBHwmFHOOjIY74b56VxtKOHntBLqjgppE5iZRaF3/ffnj0l+Lofj0aelP9lbk0LQCYv0OziLSOVHI1zBHm4KL3yiBbp3ckk6gQKMxiB3sddSTMQiNlsF1ki793XXt2XhdhlNpp8evuI56cXFTXg8chPTfNMcltJIxeiO5epT1qc94TFyWu5J+nOH3zCyRKtY+mMxHGGDyPw8KH3MYIPZK5zv+WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESqHjEql3PBpiwCHD7oMtAYya2uwGymYUbv54hmulI0=;
 b=nZBf/SAa4PSSNlA0WRc02+JJpqXL7waydPu9Al7ImeZnzvI2JUXuFgY/p/UJzQJwFV0kSsTYYDtF5s84uS7r3UPVRhTOd6FEso8/9r+QAuRJyZScNDfM++ns8ocekPjLY0MtMh1y+qNMQ448bnCHEQLCrwLbF+6Se/DImHoCkO+C2WfehdE8gX868ZzYnWN/3OcsOK6+SwXjezFb3V1FpSQ+JXRyWwKVgGZVAP1dMZ51xbf9v+aviYmMEKrnvDlDcRFKSTqdvo5+S+gKTARBK3N/oMGhYQgA9EoZ4Fx5vzQKy0HtD7znIKO6mp64ewKWmtr+OwgYk6k2nscbU+yD2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=arm.com;dmarc=pass action=none header.from=arm.com;dkim=pass
 header.d=arm.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESqHjEql3PBpiwCHD7oMtAYya2uwGymYUbv54hmulI0=;
 b=PvHjgGbTrX5MqiJOBXm30vfSvnZIYWy3l2JcUDQjui0i3skt7Lq1bZQSZdjsOlpSvIP8520WdmpmBL24DQp2sp88TrtXwgRt4GIyk6qi6L0EJpYP8CJ3w+HgV8XkRHZv0/nBao2cqB+woBKBRcIQbVUt/bP842gxRF7iQ99hSq0=
Received: from VI1PR0802MB2528.eurprd08.prod.outlook.com (10.172.255.7) by
 VI1PR0802MB2189.eurprd08.prod.outlook.com (10.172.12.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 13:26:19 +0000
Received: from VI1PR0802MB2528.eurprd08.prod.outlook.com
 ([fe80::4464:1e9b:e85f:ec90]) by VI1PR0802MB2528.eurprd08.prod.outlook.com
 ([fe80::4464:1e9b:e85f:ec90%8]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 13:26:19 +0000
From:   Dave Rodgman <dave.rodgman@arm.com>
To:     Hannah Pan <hannahpan@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     nd <nd@arm.com>
Subject: Re: [PATCH] crypto: testmgr - add tests for lzo-rle
Thread-Topic: [PATCH] crypto: testmgr - add tests for lzo-rle
Thread-Index: AQHVMSPmurNzTRaU3UWjVM7sggJAIabdCRuA
Date:   Fri, 26 Jul 2019 13:26:18 +0000
Message-ID: <6b2263b1-c977-2b96-4d42-6e7d7312177f@arm.com>
References: <20190702221602.120879-1-hannahpan@google.com>
In-Reply-To: <20190702221602.120879-1-hannahpan@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.140.106.53]
x-clientproxiedby: LNXP123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::17) To VI1PR0802MB2528.eurprd08.prod.outlook.com
 (2603:10a6:800:ad::7)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=dave.rodgman@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b6f45798-eed1-4fa3-2b89-08d711ccdc43
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0802MB2189;
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2189:|DB8PR08MB4953:
X-Microsoft-Antispam-PRVS: <DB8PR08MB49533C3742795332DE06A90D8FC00@DB8PR08MB4953.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-prvs: 01106E96F6
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(6116002)(31696002)(81156014)(53936002)(81166006)(6512007)(6486002)(66476007)(25786009)(316002)(6436002)(478600001)(110136005)(36756003)(6246003)(71200400001)(7736002)(86362001)(52116002)(305945005)(3846002)(2906002)(4744005)(44832011)(14454004)(64756008)(26005)(2501003)(5660300002)(31686004)(102836004)(66066001)(186003)(8936002)(476003)(2616005)(256004)(11346002)(66556008)(53546011)(68736007)(4326008)(229853002)(76176011)(99286004)(71190400001)(486006)(386003)(8676002)(6506007)(446003)(66446008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2189;H:VI1PR0802MB2528.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: zD55VRwuLLdo+HbswlyZHYs9bIruV7jo7KEk0S/3PSZI26z4IKufs+j/qoikhQBVdRzXU/43e5dGybwa+pT7AsDq1CE3gA4EptZPD02yr2jJjzQ5lJ+Dy9zd9mFXgaWGlNycbFkTXrWfQXJf5z+hIIM+JGpCGOjGYe0ATF9wQprrD34IuPcDRdZdfO8tuLlf+IpV1SzYcV+azP/ngVGPe2Nutm7uZVQ44bo8gy//OucWDomJfqPF6rmr2l+U8W4RxQhP+1PIqmghq8FAZVhRVhTD8npn1fP5rHRx83cr+95nBzFM4Do/7b0ZBNmIXA0PMppPJ0zC4jkaC7CU6ydR7NbL/ePUlK0u9tSr83RHdjiR+7BiOga4FDV5OMgzLzNMh6deZD5dtWBXth7UFJYq+W+durGp2kmQJsJbyioUosw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B22077DBC1FFDF488E7E1E5986960D97@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2189
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=dave.rodgman@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(2980300002)(189003)(199004)(6486002)(44832011)(6512007)(486006)(26826003)(66066001)(2501003)(6116002)(8936002)(2906002)(186003)(31686004)(110136005)(47776003)(22756006)(102836004)(76176011)(25786009)(2616005)(478600001)(23676004)(53546011)(6506007)(2486003)(386003)(356004)(11346002)(14454004)(26005)(81166006)(336012)(63370400001)(86362001)(70586007)(4326008)(50466002)(8676002)(446003)(31696002)(99286004)(305945005)(76130400001)(316002)(5660300002)(126002)(6246003)(3846002)(36756003)(4744005)(7736002)(229853002)(70206006)(36906005)(63350400001)(436003)(81156014)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR08MB4953;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ef870915-7b49-49b1-ff5d-08d711ccd7c9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(710020)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR08MB4953;
NoDisclaimer: True
X-Forefront-PRVS: 01106E96F6
X-Microsoft-Antispam-Message-Info: gUorAhGlQ7sfTe54ogES80cKTrCAX2ueyQ8Y2xpZ+QgJuo8Wws+4DAhH7hPIkfcJ6oKKWJFzdn+uHNFTHHr79mQkck9CVdrDcQyDGx1BDC4BrZjyadO5zmzMVzob1xy7YLh4leJNVMkUraxBaQ4wnNGbAa9KKcmmZsmfVzCoXHZuJ8beAcvuFA3f1G4eEYNeOG6gflO5YEeYurFS9QFKMhkQihhn5A14PZb/JYwqgcXRjKKBGyHmy4PgN78XngeuDJVQAf8GNv+s2GrmdkrGldj5OcysXSY6If3iOu8h2v3vKB+dv4sfwGHNvmYmThS5EgvbPWcVwWNqVXLPnAbF8U28O5w/KCv29r+eGqQwnJcPDxDZQdkWjgAwPRIRi5z/wZdcfKiKODL8aa4Oo4BsRvkBYbE/2te/nCqEbCM9EpI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2019 13:26:26.1844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f45798-eed1-4fa3-2b89-08d711ccdc43
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4953
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMDIvMDcvMjAxOSAxMToxNiBwbSwgSGFubmFoIFBhbiB3cm90ZToNCj4gQWRkIHNlbGYtdGVz
dHMgZm9yIHRoZSBsem8tcmxlIGFsZ29yaXRobS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhhbm5h
aCBQYW4gPGhhbm5haHBhbkBnb29nbGUuY29tPg0KPiAtLS0NCj4gIGNyeXB0by90ZXN0bWdyLmMg
fCAxMCArKysrKysNCj4gIGNyeXB0by90ZXN0bWdyLmggfCA4MCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgOTAgaW5z
ZXJ0aW9ucygrKQ0KSGkgSGFubmFoLA0KDQpUaGFua3MgZm9yIGFkZGluZyB0aGVzZSB0ZXN0cy4N
Cg0KSXQgbG9va3MgbGlrZSB0aGVzZSB0ZXN0cyBkb24ndCBpbmNsdWRlIGFueSBydW5zIG9mIHpl
cm9zIGluIHRoZSBpbnB1dC4gSW4gdGhpcw0KY2FzZSwgbW9zdCBvZiB0aGUgbmV3IFJMRS1yZWxh
dGVkIGNvZGUtcGF0aHMgaW4gbHpvLXJsZSBhcmVuJ3QgaW52b2tlZCBhbmQgaXQNCmJlaGF2ZXMg
ZXhhY3RseSB0aGUgc2FtZSBhcyBzdGFuZGFyZCBsem8uDQoNClRvIGdldCBiZXR0ZXIgY292ZXJh
Z2UsIEkgd291bGQgcmVjb21tZW5kIGFkZGluZyBzb21lIGlucHV0IGRhdGEgd2hpY2ggaW5jbHVk
ZXMNCnNvbWUgcnVucyBvZiBhdCBsZWFzdCA0IHplcm9zIChpZGVhbGx5LCBpbmNsdWRpbmcgc29t
ZSBlZGdlIGNhc2VzIGxpa2UgYWxsLXplcm8sDQppbnB1dCBzdGFydHMgLyBlbmRzIHdpdGggYSBy
dW4gb2YgemVyb3MsIGVtcHR5IGlucHV0LCBldGMpLg0KDQpSZWdhcmRzDQoNCkRhdmUNCg==
