Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237ABC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E66D92087F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="j3KinMXb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfG3L3z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:29:55 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:37685
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfG3L3z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:29:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNXsl0YmbDfVAavm6yOj8Z2smMfYAyqAkUdYoxpLxXcA8x7Ivr82nxV6AxjR3NDJ4ukYLbdy0gmAnn9ZJPJFXoC0oxJy9XpDNPjSzXCi6OWvWf5AlJt2Z4BoTM3Cb1pa7pTW0Kw5pW6uDuqKUUUAgxGiSWxyC0YB6ZxGsFAXMaAx4MzqksMvK1uxNlUk8sevCZ5kYRrxuqMaQVWtcGc18CzyAt/ioI6ktoF0ZlxRL7eBNTVwvJ9AWnUr+3RefIQhigEGZes1tz9TSIPLMnXVGoX9ZsCFrDu6DkcGTvYxlJN/kEW+ZEya4GqICpCq7WfQlNlzR+2tM+TPMQbM/axyYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPeH7A1dw9YnTzMqOv8V+/KHIkGjGgAb1kRGV8ZueNU=;
 b=XIeN/w08BvIv4Ykfvtj3ma/QklU9fHoPhUoF0LXxgo1GIdsuziqZbkCHXnjVcWixxkYLBzPK+IMDtiyNg523yFqPsCWql53yxgHlwWZWHTQ+HVnMSUfz1nSYH48F8s52kYYCTvQGbkMXCUxWyQBMO98Pt5h0DAyCSojW9e2+lmm4WgMf9UJLkJbivDBF2e9uLnk9zcQ0xi43N0hG2mrjnEQv1amZl7puKKTqcNPJUPKvpdPU33ZQwHJwzra2H0UGV/aKqgWnujv8fRiRHFDP2chD9k+PXrj4Weiy1wBEJZHjoT5dJ8MeXxc99cEC/KJX5oQlSQeUGHCWyZ6i8HS30Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPeH7A1dw9YnTzMqOv8V+/KHIkGjGgAb1kRGV8ZueNU=;
 b=j3KinMXbHm12lEKdWUyvN58+Bl4ZCyliUqBxjI0c5cl4prF8gZDlD20qy7MPahQRNuUD9gDhx2HdBiyfCBohKKP/9+69O5v0XExpiK5E/EBtMccCNhNG1vdAgWU+AzEH13jTaLrywEs21wRO32OtBbeXlq6fFlS56t5p8IvDH/0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3950.eurprd04.prod.outlook.com (52.134.17.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 11:29:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 11:29:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
Thread-Topic: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
Thread-Index: AQHVRsJGjJrvlx+J+E+468QqPTLh1Q==
Date:   Tue, 30 Jul 2019 11:29:51 +0000
Message-ID: <VI1PR0402MB34857CAE5CA386DED98CA5BC98DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com>
 <1564482824-26581-3-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a33e0029-6958-4289-79e8-08d714e13c83
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3950;
x-ms-traffictypediagnostic: VI1PR0402MB3950:
x-microsoft-antispam-prvs: <VI1PR0402MB3950CDEDFDB6D8A8887F377D98DC0@VI1PR0402MB3950.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(199004)(189003)(110136005)(76176011)(3846002)(66446008)(64756008)(76116006)(71200400001)(25786009)(446003)(33656002)(66476007)(66556008)(44832011)(316002)(7696005)(6116002)(26005)(91956017)(486006)(6506007)(53546011)(2906002)(66946007)(71190400001)(229853002)(86362001)(102836004)(99286004)(476003)(8676002)(55016002)(54906003)(478600001)(7736002)(74316002)(558084003)(14454004)(66066001)(53936002)(5660300002)(4326008)(6436002)(81166006)(186003)(68736007)(9686003)(52536014)(6246003)(256004)(8936002)(81156014)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3950;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gDJx6RAShg7WjsATnCkBe1pY14ATyzW9F1YSjvfn6jjGqhsCNqv5tkiMl988M1WfxmdrXnT5RSGb16FqAxdWbgsBB8IK/hpen2Y3eGP2HO+CmhJw6mWAYm2XagkJRaWTRwBl6PC4qPttHA0xvSCll3+A4FOGjLwyYKzWalPgFyQUxRTLRh2eiWK3MCnEbvSFLFbPjjGIynQFReRxXUoRvivT5qz1yOfUNcWW7+9DmqAFHQvUNrDZtpXiasW1Swr9kxstpGdljYctPA3jWit33FPXYKAHSMq2QbMD1OgZA/HHsJs38Dgyx9Htf8gpXpJRuuqxM+xZQMhTJtliuMEfL5BhpExuG909q9B3Agysqw9AjSqQdnRMPcp10xdShGsTTjuxkv3vcS9H0wyBfCCWWsWm7/JTyE4ky9q2Z/cqu5k=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33e0029-6958-4289-79e8-08d714e13c83
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:29:51.1321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3950
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 1:33 PM, Iuliana Prodan wrote:=0A=
> Add inline helper function to check key length for AES algorithms.=0A=
> The key can be 128, 192 or 256 bits size.=0A=
> This function is used in the generic aes implementation.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
