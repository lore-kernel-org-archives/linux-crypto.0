Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28962C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED2C206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kW3Ok9e8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfG3LuN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:50:13 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:47421
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfG3LuM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:50:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUXE4dCyhnhr6MSn8Pc7A0H2KKRb8B3Hke4ZMD50LVYbsi14zKxcwg7PRrX4RZahWzvswYzeO8pDGWL1orLcWb1/4jIRP6XLloWtyGG7x0eIHXKEXKaWOuacpjDEu0geMH8DEI9+VcMYWTQL8NCkD1NUAOqJIXkYbO05mwwZL/n6oYKpK3C/lHwGsqd5Ro1N+i4qT4NozeiV7iOOWUXgOs24j/F+yj1bnAJks3xFzVHKC8AHCT3DPTj91h9ETL0+2W28kayw1WcLtQPztoJtzKx/T31R/sEZGJzU7s4fzEeKpYMKEl95qOcwjK/LcA4KgBUjypngRocafUB69tiufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/CTQ+5XniSQxdO9EdqKARKlOY60dB0+x+RHXSYNhfA=;
 b=ab6LzYQQNs1XeMUNhD9DRQexS1Ppn1G/WkLrBq46JH6dE31H0VZAo11e+Kzv2PH+3lWlmUZCpwdOmHE490sLe6sQ1v8Lop0jsVqKtDDxgl+ObuA0rTDD6YXd+QCGPqH1isb+kWkf6Eox03ftgpq8d77Zz6AAorUVBNVosEaSNg0jSwjxGaKssBJBYsuXjFaG1DpuecAmEz43sB8+nQg3IyW4NI6dg9nHJZx9+ZFP5OPDhqGWMIv9DIbQypG6iWs3a0HLkG2jtEKf+5EphpzKujUNlqTRM5kwRLbA5sZqUADH+0jVMvA7pZb6MLg7CJ3J2t42JXjOOqxgNjejRAiuDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/CTQ+5XniSQxdO9EdqKARKlOY60dB0+x+RHXSYNhfA=;
 b=kW3Ok9e8EgrVqpvtZpMZ5Ne+kwoleAIXrCof5F3syblK3DmiTp4KIdMpm21e7bOo9gsKR2W4r5LbdbjkWvwiz7q/DVA4eTgMzKd/y2sUoXpfvses6EPHGji/TDpu0/eZQpOThJFdDSw09fkw9ztLke2dSohL9t6rXTULX2kIxeE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2735.eurprd04.prod.outlook.com (10.175.23.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 11:50:08 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 11:50:08 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3] crypto: gcm - restrict assoclen for rfc4543
Thread-Topic: [PATCH v3] crypto: gcm - restrict assoclen for rfc4543
Thread-Index: AQHVRsZerF9ZNFVjE0av/0yPv9d+JA==
Date:   Tue, 30 Jul 2019 11:50:08 +0000
Message-ID: <VI1PR0402MB3485631639ADE29D91C4B6C298DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564484077-27727-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f25c55da-1bd2-4b30-82a4-08d714e41213
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2735;
x-ms-traffictypediagnostic: VI1PR0402MB2735:
x-microsoft-antispam-prvs: <VI1PR0402MB27354B6E692EE461FF44697998DC0@VI1PR0402MB2735.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(189003)(199004)(68736007)(53936002)(99286004)(9686003)(256004)(81166006)(81156014)(14444005)(8936002)(55016002)(14454004)(478600001)(8676002)(66066001)(4326008)(5660300002)(33656002)(110136005)(54906003)(6246003)(2906002)(86362001)(6436002)(476003)(305945005)(26005)(486006)(7736002)(6506007)(71190400001)(186003)(71200400001)(44832011)(102836004)(316002)(76116006)(66446008)(25786009)(91956017)(446003)(74316002)(52536014)(6116002)(3846002)(229853002)(64756008)(7696005)(76176011)(66476007)(66556008)(66946007)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2735;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iJ1dMgBmAmmZ0jge/TKFha4ame7aUukXT2nmZXruRkyXd5U8Dz7XE+Qrh+siHo4iKcSJWbOKfhjIf/VluFd+ar0eqFb4cKYe7mI2Rcnyt45QDUpDsyzIOQFDdZgSyUaWs6p1AzUkR4a7opzODo8oQQanhVImzgopp94o5EKORVZk6t+jGmgVH4CqqrLu3JpM/nsE1/R5D7SpTXSRm35aIUUXjCJGZ8UKK4a7uTJmOiLIEU0fD7UJbrKPbMqvvzL3X1Owcjvl2hbKHraLHFi8/4WQyaW5adxalBoIdsGt3fU4xNVMF+AqdLSi7C4PZtTVk07C1COGBUw4SstrYEY0ORu0mLh3uh4uNL2OlC38UTCn87C/uiSMcg3asrELYhoHTHad5rUhdIkEhbFUD25R1x3eaE7mlehkXb2ckk+ijjQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25c55da-1bd2-4b30-82a4-08d714e41213
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:50:08.3362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2735
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 2:03 PM, Iuliana Prodan wrote:=0A=
> Based on seqiv, IPsec ESP and rfc4543/rfc4106 the assoclen can be 16 or=
=0A=
> 20 bytes.=0A=
> =0A=
> From esp4/esp6, assoclen is sizeof IP Header. This includes spi, seq_no=
=0A=
> and extended seq_no, that is 8 or 12 bytes.=0A=
> In seqiv, to asscolen is added the IV size (8 bytes).=0A=
> Therefore, the assoclen, for rfc4543, should be restricted to 16 or 20=0A=
> bytes, as for rfc4106.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
[...]=0A=
> diff --git a/crypto/gcm.c b/crypto/gcm.c=0A=
> index 2f3b50f..7eb5ced 100644=0A=
> --- a/crypto/gcm.c=0A=
> +++ b/crypto/gcm.c=0A=
> @@ -1034,11 +1034,23 @@ static int crypto_rfc4543_copy_src_to_dst(struct =
aead_request *req, bool enc)=0A=
>  =0A=
>  static int crypto_rfc4543_encrypt(struct aead_request *req)=0A=
>  {=0A=
> +	int err;=0A=
> +=0A=
> +	err =3D crypto_ipsec_check_assoclen(req->assoclen);=0A=
> +	if (err)=0A=
> +		return err;=0A=
> +=0A=
>  	return crypto_rfc4543_crypt(req, true);=0A=
>  }=0A=
Could as well be:=0A=
	return crypto_ipsec_check_assoclen(req->assoclen) ?:=0A=
	       crypto_rfc4543_crypt(req, true);=0A=
=0A=
The same for decryption.=0A=
=0A=
Horia=0A=
