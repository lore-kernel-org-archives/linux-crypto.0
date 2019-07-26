Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACF8C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF39205F4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="B9jkHQz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388024AbfGZP20 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:28:26 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:49284
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388441AbfGZP2Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bvt0sYi+ZPbizoCwyKqGamD8R1N/yIXBQjYoeWP9A7oPdLpQvgXz4HzJSBPwS5vbIy29pwfTPEQmW7uToUstox1S1OwUzkk+haZdnAzd//nG2Gb+pa+3ZG7F0sLxFyrcalXtrZsfoikhelL1uFKr9Gh9uAm8qZYHmbsrlC059VZQCkRihcaurZKfli/TYBVSKi4XgYo+GW+n6Jl4UkpSezzdr1SH2qbkJRUx9V+10z6ntDGGnqIC3G+58P8uziwm0fDny2fVxXyVH2LNLX6ZKx5bwamWYIhVeaey2+kZpMj706ZETtffdTH5JX9iBUbYmGkVxyWRE0JCvsWCM1QA1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLjvjOdOrza6DN2eKp9twaq8zicSPEYLNkPVUh2Ut/s=;
 b=NgWHD+LazFPiv36JWP8W/NWxkS59OVP4UMt4+E2j3xKB5MusFE4kp3tuo6+L1gP4RLl7IjaC/qWB9bIMFsws4+l8fHlnsSeLBn0AJP+/2L51pWUMm+aKc8SFD9ZL+cOtwqW07B9Ie8jTpvSyvATSvPmjSH7pGqJZzla2LkGRpsIZQso9D1SBaIXqLk+5kuXnj/kYonLqe4VfyBPgo1tOFVy4wVkyClu40hyWxPX8oewdNOJdJhx8Pg7T57IvfDIP1MzA6fZDqsLhJ2MLObS9ncCzN56juvD9qbKD1V8Zll34Y1ClvcaVOUQLlBz7gLs8c/8IRVmBjgU+ptCanlU+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLjvjOdOrza6DN2eKp9twaq8zicSPEYLNkPVUh2Ut/s=;
 b=B9jkHQz13fpl17p2H+S7IvOrGBz5hRwEmtfAojdn41uB9gdwLV5jqWik4bTM7wbNcnT2yxYBLSFzf6tIBxeUzQlJa5MTzUzghAvP4TdyYU3pPiwvXelS3UeERSYcJukbZgKwQrQIP1/5cJyR2Zj6AVG9MEXH8kekjstnnFdCgwU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3631.eurprd04.prod.outlook.com (52.134.7.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 15:28:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:28:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 06/14] crypto: caam - check assoclen
Thread-Topic: [PATCH v3 06/14] crypto: caam - check assoclen
Thread-Index: AQHVQvEQJzJNMDz6nU6UAqFvjUrpUg==
Date:   Fri, 26 Jul 2019 15:28:21 +0000
Message-ID: <VI1PR0402MB3485E88DEB954E2BCB22DD7498C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa30ee8d-0c99-47fa-7283-08d711dde483
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3631;
x-ms-traffictypediagnostic: VI1PR0402MB3631:
x-microsoft-antispam-prvs: <VI1PR0402MB363113E7A01A87A4D3B84DA798C00@VI1PR0402MB3631.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(3846002)(6116002)(53936002)(81166006)(6436002)(9686003)(81156014)(99286004)(6506007)(86362001)(55016002)(316002)(478600001)(25786009)(26005)(71190400001)(71200400001)(6636002)(6246003)(14454004)(8676002)(54906003)(4744005)(8936002)(44832011)(66556008)(66446008)(76116006)(74316002)(66476007)(52536014)(229853002)(66946007)(5660300002)(66066001)(102836004)(7696005)(110136005)(476003)(446003)(186003)(14444005)(256004)(76176011)(68736007)(486006)(7736002)(33656002)(305945005)(4326008)(53546011)(64756008)(91956017)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3631;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TrSHEQ75c1CInAYjwg5721pX9JDh2tlsR4BicCrT2cYSJr2p4EoSuv0MVi+R6BOP3TzyqzkJzHWG6nSubo5+AXX/+th6GsGuqDu0VYh8sn7ANsA3ONbBXHWpBIHvEDc+oh4qtYEy0hU83px36TwWomoEJh/mpQcWhiC69wViaDTEHx5pjtGCs3XskyGzMYXdmAWnhv1btZyy8pf3N9ul7ryeml6wO8dl2B3ZA5/8dCK3pL91HcKh2R6SvfSLw2dSji2tYlncuX5V86uubqDLyxq69wIJ78BYo0OG8DPr4kPTp/eegbmYSXllGz3UwT44xHCeJiDkMLjXVJVlf+9xyodEWKAYKjr/5dkwxATRQCBT5gUEL3RYxl8Am5PbGbETHrhAD0avnLvnxOUalkoBBY2332vKRr8az0PBiFrPFVc=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa30ee8d-0c99-47fa-7283-08d711dde483
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:28:21.4409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3631
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> Check assoclen to solve the extra tests that expect -EINVAL to be=0A=
> returned when the associated data size is not valid.=0A=
> =0A=
> Validated assoclen for RFC4106 and RFC4543 which expects an assoclen=0A=
> of 16 or 20.=0A=
> Based on seqiv, IPsec ESP and RFC4543/RFC4106 the assoclen is sizeof IP=
=0A=
> Header (spi, seq_no, extended seq_no) and IV len. This can be 16 or 20=0A=
> bytes.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
