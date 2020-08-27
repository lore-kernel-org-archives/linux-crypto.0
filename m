Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F25C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A9AB2054F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="QaoHuHjr";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="QaoHuHjr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgH0ONA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:13:00 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:41793
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728104AbgH0OLv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 10:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PexhGmkEVGUaU+zph1zt8VBxP58UJ5U1E2ZhDe/8reE=;
 b=QaoHuHjrXWpntUsU0ZjploO50xlgPUmZFJuvBGVD79GL1zd7H8EpHLIugGHsCA4hmlfWanmOuP3IbZIkCPPttahqv7f5PzoD0fE3lH+ltV/1sIs6v78UdPAW7DDS8e48yAxkN+QhXNfa+Z0QihPS0ZzJI0yzBQRXGYju1kI6qdE=
Received: from DB6PR0601CA0044.eurprd06.prod.outlook.com (2603:10a6:4:17::30)
 by HE1PR0801MB1676.eurprd08.prod.outlook.com (2603:10a6:3:81::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 27 Aug
 2020 14:11:40 +0000
Received: from DB5EUR03FT009.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:17:cafe::4d) by DB6PR0601CA0044.outlook.office365.com
 (2603:10a6:4:17::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.20 via Frontend
 Transport; Thu, 27 Aug 2020 14:11:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT009.mail.protection.outlook.com (10.152.20.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 14:11:40 +0000
Received: ("Tessian outbound a0bffebca527:v64"); Thu, 27 Aug 2020 14:11:40 +0000
X-CR-MTA-TID: 64aa7808
Received: from 474df233d212.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E6DE7BA1-D6CB-466B-AEF5-E0D98DDC13D9.1;
        Thu, 27 Aug 2020 14:11:35 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 474df233d212.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 27 Aug 2020 14:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rf2WJ+aPG52pxIerUZaxn9xc7RY9OcxzuWHfzpvo/clvGIiTASsUqs1GA4MJ6VMistaUy9t9L2rzNYn21Ip0z0PA7LknRhezv8U9x/mLZFb8Vg+IyoTHhK/pQ92eFllpZ9eKIO45pU88+S4LOSUNJaBUAKJaNU8sPXRjim6zOnFab8odtgf4ttOBg4tjpbRbuUvVyKJ5PtZ0lpZpcR/8rxazfNV6szb+SjSNDslpU65uIZIdMzbiOTk/7hhouSh+wTnMdNlEywH0PWpc1+2dcgxJZ5h8DOabOOqVItrXhT9a/sH8TwpZifTLJdQ6WwLDrXshNDUZIWtbU8O7pwCgHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PexhGmkEVGUaU+zph1zt8VBxP58UJ5U1E2ZhDe/8reE=;
 b=HGo5JWRcjaRYjVvhQPEA7xH2dE7ri+9mDHSDQAKyVa/7/vtPtjik62lYW0ZPUdzh8g5Txyg6WGr69SMxyU9pmhDz39Nj1mNB1RbMDoxzLGr1nfc5CfjZWtAsDn5ZFm8ZfdUvgqoj85/VGMWFazmYVWn67xB7EI0Gdzx1CHi9AI8ncJL/tBTrG5jHkT7k3zGUkKN/ESEGxs4mfKyPmU513K4ZbYJVJHA+3XznGcydvlm9sPQKzldK+HRd6vn/dywdaYeWgdOlROSXBNDTeSfUlR9i9omHfOeVvELh8nxtACQ+g1MnyzWOSwaCkgT1H+5R5pep9pcO5lwk2jWbmsMHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PexhGmkEVGUaU+zph1zt8VBxP58UJ5U1E2ZhDe/8reE=;
 b=QaoHuHjrXWpntUsU0ZjploO50xlgPUmZFJuvBGVD79GL1zd7H8EpHLIugGHsCA4hmlfWanmOuP3IbZIkCPPttahqv7f5PzoD0fE3lH+ltV/1sIs6v78UdPAW7DDS8e48yAxkN+QhXNfa+Z0QihPS0ZzJI0yzBQRXGYju1kI6qdE=
Received: from DB7PR08MB3003.eurprd08.prod.outlook.com (2603:10a6:5:1b::14) by
 DB8PR08MB4106.eurprd08.prod.outlook.com (2603:10a6:10:b2::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Thu, 27 Aug 2020 14:11:33 +0000
Received: from DB7PR08MB3003.eurprd08.prod.outlook.com
 ([fe80::5a8:4786:3f53:36f3]) by DB7PR08MB3003.eurprd08.prod.outlook.com
 ([fe80::5a8:4786:3f53:36f3%6]) with mapi id 15.20.3305.031; Thu, 27 Aug 2020
 14:11:32 +0000
From:   Hadar Gat <Hadar.Gat@arm.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     nd <nd@arm.com>
Subject: RE: [PATCH] hwrng: cctrn - Simplify with dev_err_probe()
Thread-Topic: [PATCH] hwrng: cctrn - Simplify with dev_err_probe()
Thread-Index: AQHWe75bvgrc23OBAkWrJCyjR+unL6lL/5DA
Date:   Thu, 27 Aug 2020 14:11:32 +0000
Message-ID: <DB7PR08MB300375061ADC2E6A40C6CDDFE9550@DB7PR08MB3003.eurprd08.prod.outlook.com>
References: <20200826153233.27586-1-krzk@kernel.org>
In-Reply-To: <20200826153233.27586-1-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7603BFC3411208478D7D37141E8EA05B.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [77.127.50.46]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48ce4f77-0620-4632-5ba5-08d84a931e62
x-ms-traffictypediagnostic: DB8PR08MB4106:|HE1PR0801MB1676:
X-Microsoft-Antispam-PRVS: <HE1PR0801MB1676C3EA7700FFFC578A38DBE9550@HE1PR0801MB1676.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2089;OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xHxtAoBluC67cPf1ONFWsx6OIzVv1mzLVbeU5J307qUvdUcgP+OAk4hUonivXA0yMv9/h6CnLf41cRYGyasH3uoqqFTnWJBfL2YrNRU6JL7rN8K126bz4AZLPl84KXaLDjmWXoQ3ZuZK7KsrDaCbgnSWMuOkHysT08ZQ6asB5Swg08BmqPpSDDGWs+m9/FN/ejeZ2MYKbUyWcRtquOFe6VuG5Yv0LcrW6E20zURIuV2pHT8e6OpH7w0Bjht1E+fZE1+rkpVjxqvyglhxxWjVE8Idjp9Hu2ZcFz9HFUPLQZN16WeZqqcS+Ne9+2IxADJrt8kozA2SnEV0oTgyas0RdA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(7696005)(33656002)(66476007)(316002)(66946007)(64756008)(478600001)(66446008)(6506007)(66556008)(86362001)(83380400001)(71200400001)(26005)(8676002)(186003)(110136005)(52536014)(4326008)(55016002)(9686003)(2906002)(76116006)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /zl/Wsna/nVB2S1EgEaRef4XOJH2fRTVmWzQ6/+A9NM7hfTvIuxK1E8ZJh2Gk2XuMLCCc19R4cEnoxc9K6CCPB0XUzRrYCqVyr1kG+aXe4j4QQ3XOURDzCebfFXQxIziP9TT8QtVFtRlQUL6kUrzkVWmBu/N69aMO3JjdmbdICjHW75SMSf/roWwxjjI73Dk30NiCESi9ONGmtuJ/qw9x/KNNPVgnj3nEVcd65wmahx9vtocJHr47gFzhlDyLP5KbvZyejko1805YUH+2d6VlLjmNMoJB1KlpvQzInvXrvw8c8DlZEW5WLyBKFl2H3v9KAvcHyzdWajXiUXVPUjyJd1r8klqc8rHRl6GCR3R/076Il9xpp+ZYoQKHYJ7mQw0+8x1kun7NwKIuYtVTf2ueZYIwj1Z1JZTuApk4RSsuZx94jV3ErEsmuZ4NEDF7IuFAUfRoq5bhal5stfnd7oOzNYK888m65V2wckdNiP5Yuxn4zqFOWaQlc1YD3YmoXksIxGUTaQMFBPk/Apy9e0bvrJaCcAhGCOzEBvfkl9omT1C47JNA7Ie3hHrnli4WSS3vffYSY8zEpVnaSlseRZ0IivVj31BtHfO/k/3919VS2x6nl65USbxwfYuxFaXxoz6kePMgI8lL8ASOfyu02pFKw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4106
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT009.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c7381f60-684d-417e-e518-08d84a931a01
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hVvk/4v/mqIPhah52Cjo6JjyOL8QYioJ5SlYbE518MfHHIAYr7I8OF0qhKY6fVFjHv+xWEMqK97n8bzFnIUtocnD/aWg6E4+nmhW3SJdy3yT3Gv1j9K9P/9dUHz6D2BolvEJumgtvMKm7qO6rWlbgUKuHBSfHl/UAko4qAWw7YCBSID8MaE/dcuebSX4NfQzOxuMPoDBpj3zAm6sb8lExiWaAiowX9X3wWqVMXZCi636CtDBg2SEK9ulzCNYtAkKMCO/XCABlLhgLN1xCIYLZGAnJdgIcvqlrF2qhfZcCbXgAS4dGp8Us/488Vm0iAwf9zj1V2ieiJvKaJu6D8aaQoQaLaO0ikT9Y0iaV8Y2S0p79L8c1A++J0cEXl9+EH2oelLQWqHGhbvdPTa6Ti4eaQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966005)(70586007)(478600001)(7696005)(316002)(356005)(8936002)(8676002)(4326008)(82740400003)(70206006)(81166007)(5660300002)(2906002)(33656002)(55016002)(450100002)(336012)(52536014)(47076004)(110136005)(26005)(83380400001)(6506007)(86362001)(82310400002)(186003)(9686003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 14:11:40.3245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ce4f77-0620-4632-5ba5-08d84a931e62
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT009.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1676
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQo+IENvbW1vbiBwYXR0ZXJuIG9mIGhhbmRsaW5nIGRlZmVycmVkIHBy
b2JlIGNhbiBiZSBzaW1wbGlmaWVkIHdpdGgNCj4gZGV2X2Vycl9wcm9iZSgpLiAgTGVzcyBjb2Rl
IGFuZCBhbHNvIGl0IHByaW50cyB0aGUgZXJyb3IgdmFsdWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnprQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVy
cy9jaGFyL2h3X3JhbmRvbS9jY3RybmcuYyB8IDkgKysrKy0tLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvY2hhci9od19yYW5kb20vY2N0cm5nLmMNCj4gYi9kcml2ZXJzL2NoYXIvaHdfcmFuZG9t
L2NjdHJuZy5jIGluZGV4IDYxOTE0OGZiMmRjOS4uN2EyOTNmMjE0N2EwDQo+IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2NjdHJuZy5jDQo+ICsrKyBiL2RyaXZlcnMvY2hh
ci9od19yYW5kb20vY2N0cm5nLmMNCj4gQEAgLTQ2MywxMSArNDYzLDEwIEBAIHN0YXRpYyBpbnQg
Y2NfdHJuZ19jbGtfaW5pdChzdHJ1Y3QgY2N0cm5nX2RydmRhdGENCj4gKmRydmRhdGEpDQo+ICAJ
aW50IHJjID0gMDsNCj4gDQo+ICAJY2xrID0gZGV2bV9jbGtfZ2V0X29wdGlvbmFsKGRldiwgTlVM
TCk7DQo+IC0JaWYgKElTX0VSUihjbGspKSB7DQo+IC0JCWlmIChQVFJfRVJSKGNsaykgIT0gLUVQ
Uk9CRV9ERUZFUikNCj4gLQkJCWRldl9lcnIoZGV2LCAiRXJyb3IgZ2V0dGluZyBjbG9jazogJXBl
XG4iLCBjbGspOw0KPiAtCQlyZXR1cm4gUFRSX0VSUihjbGspOw0KPiAtCX0NCj4gKwlpZiAoSVNf
RVJSKGNsaykpDQo+ICsJCXJldHVybiBkZXZfZXJyX3Byb2JlKGRldiwgUFRSX0VSUihjbGspLA0K
PiArCQkJCSAgICAgIkVycm9yIGdldHRpbmcgY2xvY2tcbiIpOw0KPiArDQo+ICAJZHJ2ZGF0YS0+
Y2xrID0gY2xrOw0KPiANCj4gIAlyYyA9IGNsa19wcmVwYXJlX2VuYWJsZShkcnZkYXRhLT5jbGsp
Ow0KPiAtLQ0KPiAyLjE3LjENCg0KVGhhbmtzIGZvciB0aGlzIGNvZGUgc2ltcGxpZmljYXRpb24u
IDotKQ0KDQpBY2tlZC1ieTogSGFkYXIgR2F0IDxoYWRhci5nYXRAYXJtLmNvbT4NCg0KSGFkYXIN
Cg==
