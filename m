Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4882BC3B18A
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 10:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E03F24676
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 10:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="YUNgJDIH";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="YUNgJDIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgBMKVy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:21:54 -0500
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:62789
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729428AbgBMKVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 05:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQtVeKfnjii8GxMU2BJzy484UaBkq08p4WOs/NnQnM=;
 b=YUNgJDIHNNMaB42dktUKfKxbXnlfz50I35HxukGLkO0wJbrR8dGryS882TPXWEZeHEZi00gJEXJQbUEUW4NMMzb3k7NuYAKElCN6IBF/zLynL3qdkcqOtWfBCt78QWeJtg/JwX8eTzUgIxe+OQQi7rv7WD+YRP8pM132OaDAOAE=
Received: from VE1PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:803:104::14)
 by AM0PR08MB5316.eurprd08.prod.outlook.com (2603:10a6:208:185::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Thu, 13 Feb
 2020 10:21:48 +0000
Received: from AM5EUR03FT025.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::204) by VE1PR08CA0001.outlook.office365.com
 (2603:10a6:803:104::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend
 Transport; Thu, 13 Feb 2020 10:21:48 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT025.mail.protection.outlook.com (10.152.16.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Thu, 13 Feb 2020 10:21:47 +0000
Received: ("Tessian outbound 846b976b3941:v42"); Thu, 13 Feb 2020 10:21:47 +0000
X-CR-MTA-TID: 64aa7808
Received: from 07dc25a05e12.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2CB782D6-D7C7-4420-9126-E833E6BDD718.1;
        Thu, 13 Feb 2020 10:21:42 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 07dc25a05e12.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 13 Feb 2020 10:21:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ma0t5tR5z1HY0wxs7JyDgfHx3VTHBWTmutt2/9/FDxMkLAikNfVMsG3oVqROnkGokS6aFtPPyFC6REfWDuzzQczKNMTo6lO+Eiy8ZsEEriyxkPrDb/5VHQ1dSAqCcixlGwCg3Ye5NnEngkej5VyOmn1UsqT8IYXVSV1Z3TOs7dLiSciuT+ZNp5j1CY5F1OpIEzsjSivG8IO15JhsFfDT0LIf5zUr53XaWdkzWCbdWdWSmzGJbozu7gfYGM6wD3qN/DI2FsGgopdW93fVA0oIz+IKbJAD0LXUdlY+2ttkLxy3QWypalh2764gHHEQSh5RubOb0t22k6cTuXAKYb5y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQtVeKfnjii8GxMU2BJzy484UaBkq08p4WOs/NnQnM=;
 b=n6osyCDbGY77Qc0oF0JONnA4DRGYVW9uydJjhQAD5hp0oSvCWZkMyl7DVrhzPK9kvv3oYMMkFIKmYT5vAg5Q9WmKM6tNeP8pCbXFgc0x2FNv/DMIVSOngmyCpPGcxiR3PrGtFL/92htPezHAQoy3rF852+9q0B7FqjIZypEUWrSxIemR6njtaSyaohBXErdu5T0Qjw16/i0vAkWz2SZWZGqOWkVHsFH4BMiUeQ+v/n5hVFXEOf1wXuhClohzUa2njNfnIxJ+lUm4JusTKZO5eHOzNWN8qGFUSvHaPBT/KRubYiKuFJmOSpRjDzb+szGc5iRIMql9AAd8QSFPZyEDkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQtVeKfnjii8GxMU2BJzy484UaBkq08p4WOs/NnQnM=;
 b=YUNgJDIHNNMaB42dktUKfKxbXnlfz50I35HxukGLkO0wJbrR8dGryS882TPXWEZeHEZi00gJEXJQbUEUW4NMMzb3k7NuYAKElCN6IBF/zLynL3qdkcqOtWfBCt78QWeJtg/JwX8eTzUgIxe+OQQi7rv7WD+YRP8pM132OaDAOAE=
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com (10.172.251.12) by
 DB6PR0802MB2341.eurprd08.prod.outlook.com (10.172.229.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 10:21:37 +0000
Received: from DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::3d38:d1e6:f2d:77f6]) by DB6PR0802MB2533.eurprd08.prod.outlook.com
 ([fe80::3d38:d1e6:f2d:77f6%2]) with mapi id 15.20.2729.024; Thu, 13 Feb 2020
 10:21:37 +0000
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
Thread-Index: AQHV2cyT/dIlbzGZbUmtbw6BHjqlYKgOisiAgAQId3CAA85rAIACmAKA
Date:   Thu, 13 Feb 2020 10:21:37 +0000
Message-ID: <DB6PR0802MB2533EEED9A552E96AC40184CE91A0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-2-git-send-email-hadar.gat@arm.com>
 <20200206185651.GA14044@bogus>
 <AM5PR0801MB16657EDAA54655B7CBA46AF5E91E0@AM5PR0801MB1665.eurprd08.prod.outlook.com>
 <CAL_Jsq+F8mW7oUBCXMgzEVb3Bz2pHxU=bFjo97QisMZN92PaQw@mail.gmail.com>
In-Reply-To: <CAL_Jsq+F8mW7oUBCXMgzEVb3Bz2pHxU=bFjo97QisMZN92PaQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: c1c6807d-e3f9-45ae-8ad8-197c6ddb4765.0
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
x-originating-ip: [217.140.106.29]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c79a15b1-f847-4097-1bb6-08d7b06e889a
X-MS-TrafficTypeDiagnostic: DB6PR0802MB2341:|DB6PR0802MB2341:|AM0PR08MB5316:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB53169C880DED2F5844D26F7DE91A0@AM0PR08MB5316.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 031257FE13
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(189003)(199004)(33656002)(4326008)(7696005)(5660300002)(26005)(186003)(966005)(7416002)(6916009)(316002)(478600001)(8676002)(9686003)(81156014)(52536014)(8936002)(71200400001)(86362001)(81166006)(54906003)(64756008)(66476007)(66946007)(66446008)(66556008)(6506007)(2906002)(55016002)(76116006)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2341;H:DB6PR0802MB2533.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gGBwgtSITbQ/grZP6nO366JwF13ajUhOnUeyPid9ntryMtaS56ou/2AspCf8ptI4h9NNcl2bBzZl7+PSpaEMD5z14eJyXrBDFKOGt8ae0iOgkC7IaNsMDvVj2IM5u4O7GPSFyUrr1Hvta/E9olUFtNszLaeCoGtK1rDvgm6FSiiOVLaxT7Ln2vjeQOQbByoBETtvj2sFgnCiKzAD6rKqe3AV0vk+LJDQhqE57DT0wlLQy27MFCD1Bi7PK+L09O0FxwKYRiRRkQ0TvKWSKADPDxBuSZSpCmo9tDfkYXDSfFRLm+kmTDdXQMwnXZuvk97/2AEgvaEk/Im3lRrJ8Jq01v1jpOCS7u8uckODPYgAegtj7qmByD5K/YKWWmAIcNse/2VK4ggYx2MTBPBrX2+ssFdkpp2dNAIDS7ioeYsePTsZt+GsvrMmepoXjYpI6Bj0kLWDA8pI1rP67zI4L/WSQ1ThjJWkC4QgVqVoRjJ7A2hDpNaMSXxt/7CFASTTFhM4AGLCM0wxvijN2Sl5OHy5DQ==
x-ms-exchange-antispam-messagedata: EyS/iIn2XIRd2mJKQSB96K2McWLPi0kMrDaGX3QMRnDV4veuCD3dE8/4jxzRdPSMutDd6lSMeP8Ch8vEKukLBo3WinP7UZWIaG8aByOuhce39VvVvBIK3a0b4I1IeDWYSd00qDl7fGoUrURLCBR+SA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2341
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Hadar.Gat@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(9686003)(8676002)(6506007)(53546011)(81166006)(36906005)(356004)(81156014)(2906002)(6862004)(4326008)(450100002)(55016002)(7696005)(336012)(33656002)(478600001)(966005)(316002)(8936002)(26005)(86362001)(186003)(54906003)(70586007)(70206006)(26826003)(5660300002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB5316;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0f3131b7-070c-4ba0-2905-08d7b06e823f
X-Forefront-PRVS: 031257FE13
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3pKtDfiUgYy84MoINjMY3Lj7hpykFxSgFRW4SeDPPF1PMelTzIe7O8BzfKmmhONhCXiwowdTJwea0rgkXikm5jgynNl9vrN1uMV1Cwvyq5y/68u7twigWuTmm94WmMzHXForSnTMGL1vwRysYCdF5ddIxCYXgyyA5YLvFQCOnrsAvzL3kjqQu6zZz/xmDAjG/B6KfVLuIuYQXzKMAjThBijdExUamQE0ye0JUUZPy4JXRyYCjDszXnOJ8+jyE7TGkYCEQBqzVQlY6pMciTez2VUdk+6AvWO4ek0rhmoZgVnQgIEaISyHWadLemOYgCLQ/3j5idXMiHEa7aU0wFmRWBAix9AHXGzUeJjuX/iU5jSjWVMOunX8iEleqt0OE7pFs7i9ppLRKx+9ihs+Qp48iyxUT4dSoXWO0TT28J1GTPuS9IIwh+p4WjHlIRfWAjF3xGNZ5N+f9fl/f0i9GoYdnoiUVkVqi3UzZgvomHjM049WosAuzoqYPmduaJfDHpK6eF2Sk9UGGJPIYfbprdBGA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 10:21:47.9835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c79a15b1-f847-4097-1bb6-08d7b06e889a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5316
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhhbmtzIFJvYiBmb3IgeW91ciBjbGFyaWZpY2F0aW9ucy4gSSBzdXJseSBsZWFybmVkIG1vcmUg
YWJvdXQgLnlhbWwgc2NoZW1hLg0KQWxsIGZpeGVzIHdpbGwgYmUgYXBwbGllZCBpbiB0aGUgbmV4
dCBwYXRjaCB2ZXJzaW9uICh2NCkuDQpIYWRhcg0KDQo+IE9uIFN1biwgRmViIDksIDIwMjAgYXQg
MzozNCBBTSBIYWRhciBHYXQgPEhhZGFyLkdhdEBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+IEhp
IFJvYiwNCj4gPiBUaGFua3MgZm9yIHJlbWFya3MuDQo+ID4gUGxlYXNlIHNlZSBteSBhbnN3ZXJz
Lg0KPiA+IEhhZGFyDQo+ID4NCj4gPiA+IE9uIFN1biwgRmViIDAyLCAyMDIwIGF0IDAzOjI2OjU5
UE0gKzAyMDAsIEhhZGFyIEdhdCB3cm90ZToNCj4gPiA+ID4gVGhlIEFybSBDcnlwdG9DZWxsIGlz
IGEgaGFyZHdhcmUgc2VjdXJpdHkgZW5naW5lLiBUaGlzIHBhdGNoIGFkZHMNCj4gPiA+ID4gRFQg
YmluZGluZ3MgZm9yIGl0cyBUUk5HIChUcnVlIFJhbmRvbSBOdW1iZXIgR2VuZXJhdG9yKSBlbmdp
bmUuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEhhZGFyIEdhdCA8aGFkYXIuZ2F0
QGFybS5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3Mv
cm5nL2FybS1jY3RybmcueWFtbCAgICAgICAgfCA1MQ0KPiA+ID4gKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKykNCj4gPiA+ID4g
IGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+ID4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3Mvcm5nL2FybS1jY3RybmcueWFtbA0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWwNCj4g
PiA+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL2FybS1jY3Rybmcu
eWFtbA0KPiA+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+ID4gPiBpbmRleCAwMDAwMDAw
Li5mZTk0MjJlDQo+ID4gPiA+IC0tLSAvZGV2L251bGwNCj4gPiA+ID4gKysrIGIvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9hcm0tY2N0cm5nLnlhbWwNCj4gPiA+ID4gQEAg
LTAsMCArMSw1MSBAQA0KPiA+ID4gPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MA0KPiA+ID4NCj4gPiA+IER1YWwgbGljZW5zZSBuZXcgYmluZGluZ3M6DQo+ID4gPg0KPiA+ID4g
KEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpDQo+ID4gPg0KPiA+IE9rYXkuDQo+ID4NCj4g
PiA+ID4gKyVZQU1MIDEuMg0KPiA+ID4gPiArLS0tDQo+ID4gPiA+ICskaWQ6IGh0dHA6Ly9kZXZp
Y2V0cmVlLm9yZy9zY2hlbWFzL3JuZy9hcm0tY2N0cm5nLnlhbWwjDQo+ID4gPiA+ICskc2NoZW1h
OiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiA+ID4g
Kw0KPiA+ID4gPiArdGl0bGU6IEFybSBacnVzdFpvbmUgQ3J5cHRvQ2VsbCBUUk5HIGVuZ2luZQ0K
PiA+ID4gPiArDQo+ID4gPiA+ICttYWludGFpbmVyczoNCj4gPiA+ID4gKyAgLSBIYWRhciBHYXQg
PGhhZGFyLmdhdEBhcm0uY29tPg0KPiA+ID4gPiArDQo+ID4gPiA+ICtkZXNjcmlwdGlvbjogfCsN
Cj4gPiA+ID4gKyAgQXJtIFpydXN0Wm9uZSBDcnlwdG9DZWxsIFRSTkcgKFRydWUgUmFuZG9tIE51
bWJlciBHZW5lcmF0b3IpDQo+ID4gPiBlbmdpbmUuDQo+ID4gPiA+ICsNCj4gPiA+ID4gK3Byb3Bl
cnRpZXM6DQo+ID4gPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gPiA+ICsgICAgZGVzY3JpcHRpb246
IFNob3VsZCBiZSAiYXJtLGNyeXB0b2NlbGwtN3gzLXRybmciDQo+ID4gPg0KPiA+ID4gRHJvcC4g
VGhhdCdzIHdoYXQgdGhlIHNjaGVtYSBzYXlzLg0KPiA+ID4NCj4gPiBPa2F5Lg0KPiA+DQo+ID4g
PiA+ICsgICAgY29uc3Q6IGFybSxjcnlwdG9jZWxsLTd4My10cm5nDQo+ID4gPg0KPiA+ID4gSXMg
J3gnIGEgd2lsZGNhcmQ/IFdlIGRvbid0IGRvIHdpbGRjYXJkcyB1bmxlc3MgeW91IGhhdmUgb3Ro
ZXIgd2F5cw0KPiA+ID4gdG8gZ2V0IHRoZSBzcGVjaWZpYyB2ZXJzaW9uLg0KPiA+ID4NCj4gPiBL
aW5kIG9mIGEgd2lsZGNhcmQuIEl0IHN0YW5kcyBmb3IgZWl0aGVyIDcwMyBvciA3MTMuDQo+ID4g
U2hvdWxkIEkgZml4IHRoaXMgdG8gdGhlIHNwZWNpZmljIHZlcnNpb25zPw0KPiA+IE9SLA0KPiA+
IFNpbmNlIHRoZSBzcGVjaWZpYyB2ZXJzaW9uIGRvZXNuJ3QgbWF0dGVyIHRvIHRoZSBkcml2ZXIs
IHNob3VsZCBpdCBjaGFuZ2VkPw0KPiANCj4gTWF5YmUgbm90IG5vdywgYnV0IGJvdGggd2lsbCBh
bHdheXMgaGF2ZSB0aGUgc2FtZSBlcnJhdGEgYW5kIGZlYXR1cmVzPw0KPiAyIGlzIG5vdCBhIGxh
cmdlIG51bWJlciwgc28ganVzdCBkbyAyLg0KPiANCj4gT2YgY291cnNlLCBlcnJhdGEgY2FuIHZh
cnkgYnkgcmV2aXNpb24uIE1vc3QgQXJtIElQIGhhcyB2ZXJzaW9uIHJlZ2lzdGVycywgc28gSQ0K
PiBhc3N1bWUgdGhhdCdzIHRydWUgaGVyZS4gSWYgbm90LCB3ZSdkIG5lZWQgcGVyIFNvQyBpbXBs
ZW1lbnRhdGlvbg0KPiBjb21wYXRpYmxlIHN0cmluZ3MgaGVyZS4NCj4gDQo+ID4gKGNoZWNraW5n
IG91dCBvdGhlciBybmcgZHJpdmVycywgSSBzZWUgdGhpcyBleGFtcGxlIGluDQo+IFNhbXN1bmcs
ZXh5bm9zNC55YW1sOg0KPiA+ICAgLSBzYW1zdW5nLGV4eW5vczQtcm5nICMgZm9yIEV4eW5vczQy
MTAgYW5kIEV4eW5vczQ0MTIgKQ0KPiANCj4gV2VsbCwgdGhlcmUncyBsb3RzIG9mIGJhZCBleGFt
cGxlcywgYW5kIGFsc28sIHNvbWUgU2Ftc3VuZyBiaW5kaW5ncyBhcmUNCj4gZGVjbGFyZWQgdG8g
bm90IGJlIHN0YWJsZS4NCj4gDQo+ID4NCj4gPiA+ID4gKw0KPiA+ID4gPiArICBpbnRlcnJ1cHRz
Og0KPiA+ID4gPiArICAgIGRlc2NyaXB0aW9uOiBJbnRlcnJ1cHQgbnVtYmVyIGZvciB0aGUgZGV2
aWNlLg0KPiA+ID4NCj4gPiA+IERyb3AuIFRoYXQncyBhbGwgJ2ludGVycnVwdHMnLg0KPiA+ID4N
Cj4gPiBPa2F5Lg0KPiA+DQo+ID4gPiA+ICsgICAgbWF4SXRlbXM6IDENCj4gPiA+ID4gKw0KPiA+
ID4gPiArICByZWc6DQo+ID4gPiA+ICsgICAgZGVzY3JpcHRpb246IEJhc2UgcGh5c2ljYWwgYWRk
cmVzcyBvZiB0aGUgZW5naW5lIGFuZCBsZW5ndGggb2YNCj4gbWVtb3J5DQo+ID4gPiA+ICsgICAg
ICAgICAgICAgICAgIG1hcHBlZCByZWdpb24uDQo+ID4gPg0KPiA+ID4gRHJvcC4NCj4gPiA+DQo+
ID4gT2theS4NCj4gPg0KPiA+ID4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gPiA+ICsNCj4gPiA+
ID4gKyAgcm9zYy1yYXRpbzoNCj4gPiA+ID4gKyAgICBkZXNjcmlwdGlvbjogU2FtcGxpbmcgcmF0
aW8gdmFsdWVzIGZyb20gY2FsaWJyYXRpb24gZm9yIDQgcmluZw0KPiBvc2NpbGxhdG9ycy4NCj4g
PiA+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ID4NCj4gPiA+IElzIHRoaXMgYW4gYXJyYXk/DQo+
ID4gPg0KPiA+IFllcywgYXJyYXkgb2YgNC4gKEknbGwgbWVudGlvbiBpbiB0aGUgZGVzY3JpcHRp
b24pDQo+IA0KPiBEb24ndCBuZWVkIGEgZGVzY3JpcHRpb24gYXMgdGhhdCdzIGNvbnN0cmFpbnRz
IHRoZSBzY2hlbWEgc2hvdWxkIGV4cHJlc3MuDQo+IA0KPiA+ID4gTmVlZHMgYSB2ZW5kb3IgcHJl
Zml4LCBhIHR5cGUgcmVmIGFuZCBhbnkgY29uc3RyYWludHMgeW91IGNhbiBjb21lIHVwDQo+IHdp
dGguDQo+ID4gPg0KPiA+IERvIHlvdSBtZWFuIGluIHRoZSBuYW1lPyBpbnN0ZWFkIG9mICJyb3Nj
LXJhdGlvIj8NCj4gDQo+IGFybSxyb3NjLXJhdGlvOg0KPiAgIGFsbE9mOg0KPiAgICAgLSAkcmVm
OiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzItYXJyYXkNCj4gICBtYXhJ
dGVtczogNA0KPiANCj4gPiBJIGRpZG4ndCBmaW5kIGFueXRoaW5nIGFib3V0IGl0IGluIHRoZSBk
b2N1bWVudGF0aW9uIG9yIGV4YW1wbGVzIGluIG90aGVyDQo+IHJuZyBkcml2ZXJzLi4NCj4gPg0K
PiA+ID4gPiArDQo+ID4gPiA+ICsgIGNsb2NrczoNCj4gPiA+ID4gKyAgICBkZXNjcmlwdGlvbjog
UmVmZXJlbmNlIHRvIHRoZSBjcnlwdG8gZW5naW5lIGNsb2NrLg0KPiA+ID4NCj4gPiA+IEhvdyBt
YW55IGNsb2Nrcz8NCj4gPiA+DQo+ID4gT25lIGNsb2NrLiAoSSB3aWxsIGNoYW5nZSBjbG9ja3Mg
LS0+IGNsb2NrKQ0KPiANCj4gTm8sIHRoZSBwcm9wZXJ0eSBuYW1lIGlzIGFsd2F5cyAnY2xvY2tz
Jy4gWW91IG5lZWQganVzdCAnbWF4SXRlbXM6IDEnDQo+IGlmIHRoZXJlJ3MgYSBzaW5nbGUgY2xv
Y2suDQo+IA0KPiBSb2INCg==
