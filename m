Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12E4C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C96821019
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="txBMZFBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfAVP3P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:29:15 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:28192
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfAVP3P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwavNdIf3WWOlDFoILBvnvIADun7xTPkUXMePiL1j84=;
 b=txBMZFBp+8zUoMrvfpJmZxODHIx/YoA2NW3HuUQ+5Ubt6q7oV4d4+DDkP8gt9Sg5x/UGi8mZ0hqJk0lSgsifL0lgC6xRMtY574GtabXBLCp1gONNEJpBrJTCUuzsgRcNUkZphkfFVQEadquGFPqMa4gnuSpJtWMVNQTY7P3aDzI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3456.eurprd04.prod.outlook.com (52.134.3.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Tue, 22 Jan 2019 15:29:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%5]) with mapi id 15.20.1537.031; Tue, 22 Jan 2019
 15:29:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH 7/7] crypto: caam: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH 7/7] crypto: caam: no need to check return value of
 debugfs_create functions
Thread-Index: AQHUsmU8hJFbfBDjIka0oA4Q3MDdpg==
Date:   Tue, 22 Jan 2019 15:29:12 +0000
Message-ID: <VI1PR0402MB34859A9B45BCA851C71CE15898980@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-8-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3456;6:P0mX3L8MpwyVjpNkDhVb7wv4NwwXD9py+9Ih0WXIu4086Mt+H4WvCFn2n4hTcb1ULNt61tkvfYNH8To70FW7zB2/887+Bc2VHUOcFUcCnErRoDXVXsmi1XqWD7/0cH/caOwHsyB9U3zupK7NoZhIDLjo+tgxwN7NwgUGZQfCG+Qniy1ItdDpAEez1BJBSgH5HX5ufsNggNqHKi0iyYLlOZHCUO6uSsFDL/nCRXUsQy5Y//IPNLWRSEBGJAwrmpLymBoUTaip8tLkpiqDRzNi08WTUUSJIv/uJiqBp+HyIFPHcRG5At8RD2DIFT+i9y27otybM3uw37qkc6eacqhXQmB2vkXj91cRiZodFviqCWY/CzJ7ADoAAc3+45XnCCEUgEXZuGVovEUD98lOE0oYootUbj9dv1tkorVKldWv6mMEPfyf3wukIExfLmvl8a3/DJJ0LX6loShIsiDv5Bcpwg==;5:NxVqn8MurR4xVgKWq9sG/dPGoiCDJ0IOyWozW9Tr7QjbqxLDmauXFWTtt7VqtSu8sMm7mMfVHgbfFeIWdKjZ5lBger3167EzUMMGb/UIWZn/7yguJES7duxrnsRQpMADaDMaLySvy7jlxeHDX2O1oWP82v5e3pHGC1ozN6EgZPEdzxFIyFyN804kCqyQg0xieOPCt87tJpY5+Z2y6FYlAQ==;7:NVUI37YiXr0vcyA2s5I0CfdxHJUaMxltjVnQ3UTjRkpH8ohMvNWbJeVjQsXcuTI/T3G8f/w1dD1lAhBDUXXPhs3/kqOie74OQnYYSu8ApaXymERaSkhzLzGja48mZ/w3nT3pkKjNEtoFpqnOn3vJ/A==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 261bfe68-58e5-4c40-042b-08d6807e5c6c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3456;
x-ms-traffictypediagnostic: VI1PR0402MB3456:
x-microsoft-antispam-prvs: <VI1PR0402MB3456E9615A8165BFFFD8CAF698980@VI1PR0402MB3456.eurprd04.prod.outlook.com>
x-forefront-prvs: 0925081676
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(366004)(396003)(376002)(39860400002)(189003)(199004)(7696005)(6506007)(53546011)(106356001)(110136005)(33656002)(102836004)(316002)(8676002)(14454004)(76176011)(9686003)(68736007)(7736002)(55016002)(305945005)(99286004)(478600001)(54906003)(66066001)(97736004)(105586002)(229853002)(2906002)(3846002)(6116002)(6436002)(74316002)(256004)(86362001)(53936002)(486006)(476003)(44832011)(4744005)(8936002)(71200400001)(71190400001)(25786009)(6246003)(4326008)(81166006)(446003)(26005)(81156014)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3456;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oDJz61ORFaEnMPfRxgJ71yyKu2v3hsJeuZjKrz5kXJwWquWYCqval6dyfkzXT+CJqEO1uLrM9/b27xPRUGQ8v9STCKNsQZwWbE0YA1R4jGhOBCTvmGdrZ8xGwSpuVYQAvnHR3kY8JUQcKSgsea0GJrwHaivuO0I3rhFiY0p7vAJ3/KhHpSAbnI4k3WyGzvONHrnJdeHbNgUMJcTw/gzpKXLaF9ZxhNmBxTUaWpdmqTFJ/8ZRGfqywGj8oqX3QNFXYrXfNZi5kmtpQ7PryHpDxJu4Dx3PNGiznH8DtkYxFwRRtHgz9O9XVd2RZYkmAZ/y9UyWrkVDt17yj+1ydOlqcEj/R0pRd7RXhhPSg14wTizTo2Wx991sTlH+bcYNmLnmYMJPVz3F9A2demOp+vfGCymESmzTckMi7IZhQDSzSqM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261bfe68-58e5-4c40-042b-08d6807e5c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2019 15:29:12.3071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3456
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/22/2019 5:14 PM, Greg Kroah-Hartman wrote:=0A=
> When calling debugfs functions, there is no need to ever check the=0A=
> return value.  The function can work or not, but the code logic should=0A=
> never do something different based on this.=0A=
> =0A=
> Cc: "Horia Geant=E3" <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
