Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508E8C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2657C21773
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pfuhM5we"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfEUOb1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 10:31:27 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:7493
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728053AbfEUOb0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 10:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Csw3E5QMmLE2lumGQdhf4R36gYgAVmFlPYOU4ZPb/LA=;
 b=pfuhM5wes5fEZjCqcaOFv03T7K2KwbEfFaakuWVCzDK9R+dc/cpWrx5L2l82Jk+IppIrs/oi4+gfPLbZeRDOtJYcd0ZJupLAlKhGqEP3lQD+XmHDN5PaZXiRt91i8stMNjzOr6rn/IU0SHVWsH81hhh8n9/7W4LLRelYHhcEPXg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3407.eurprd04.prod.outlook.com (52.134.2.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Tue, 21 May 2019 14:31:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451%3]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 14:31:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] crypto: caam: print debug messages at debug level
Thread-Topic: [PATCH 2/3] crypto: caam: print debug messages at debug level
Thread-Index: AQHVDJL8mmT01przhESHS2q17fhpQg==
Date:   Tue, 21 May 2019 14:31:23 +0000
Message-ID: <VI1PR0402MB3485594CF5ECFD6F08AF7FA298070@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
 <20190517092905.1264-3-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 740529ca-f60b-4a6d-ab14-08d6ddf90023
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3407;
x-ms-traffictypediagnostic: VI1PR0402MB3407:
x-microsoft-antispam-prvs: <VI1PR0402MB34078F8A176BE26D13B59F1F98070@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(446003)(44832011)(76116006)(66476007)(66556008)(64756008)(66446008)(6506007)(53546011)(486006)(73956011)(476003)(66946007)(305945005)(110136005)(102836004)(99286004)(186003)(76176011)(68736007)(66066001)(26005)(7696005)(8676002)(81166006)(81156014)(7736002)(8936002)(6436002)(229853002)(478600001)(15650500001)(9686003)(14454004)(53936002)(316002)(25786009)(256004)(55016002)(2501003)(33656002)(86362001)(74316002)(5660300002)(71190400001)(52536014)(2906002)(71200400001)(6116002)(3846002)(6246003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3407;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2VKeio1j+VED/ZEeJhr8S7HZlYuEippoH1ORcahiaaIuwfSGl9mLHcg7AI/TXuxWU4GJ2q9QaPtaKsjblZHQGontCyCmgn+HB3HHoh6GJOHPqvyjsN5L8gJe8FhzlwOErELrOZ7EmpNQN+x1FDLaXjzEppBHLsK5l3Vzr9BcnDMnGIk3+rf/eSU3kOl3LvL7Fk3P0Ac4hlZrZFmDqk3xmk0OJTY/67b63T5sdwwooiHUMt2Oae/vXWanM0WM+OHnmicg34sb/M3VbCVxr8Y5T5NBDEyfvWY44Fkgg30q71BDFcw7ea3UzcXe8DlAJxjT1jHBYP3w2CNtHAQeVRhmfUSCsNQgxCOe9LKPk0OeuA/x+QlwEah82lXDuwnWC+q4GK0q+BT9ozI466YBTDHaNrgsi5yf74fK9cOrikRJ2Vk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740529ca-f60b-4a6d-ab14-08d6ddf90023
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 14:31:23.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/17/2019 12:29 PM, Sascha Hauer wrote:=0A=
> The CAAM driver used to put its debug messages inside #ifdef DEBUG and=0A=
> then prints the messages at KERN_ERR level. Replace this with proper=0A=
> functions printing at KERN_DEBUG level. The #ifdef DEBUG gets=0A=
> unnecessary when the right functions are used.=0A=
> =0A=
> This replaces:=0A=
> =0A=
> - print_hex_dump(KERN_ERR ...) inside #ifdef DEBUG with=0A=
>   print_hex_dump_debug(...)=0A=
> - dev_err() inside #ifdef DEBUG with dev_dbg()=0A=
> - printk(KERN_ERR ...) inside #ifdef DEBUG with dev_dbg()=0A=
> =0A=
> Some parts of the driver use these functions already, so it is only=0A=
> consequent to use the debug function consistently.=0A=
> =0A=
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c      |  95 ++++++++--------------=0A=
>  drivers/crypto/caam/caamalg_desc.c |  71 ++++------------=0A=
>  drivers/crypto/caam/caamalg_qi.c   |  36 +++------=0A=
>  drivers/crypto/caam/caamhash.c     | 126 +++++++++--------------------=
=0A=
>  drivers/crypto/caam/caamrng.c      |  16 ++--=0A=
>  drivers/crypto/caam/key_gen.c      |  19 ++---=0A=
>  drivers/crypto/caam/sg_sw_sec4.h   |   5 +-=0A=
>  7 files changed, 113 insertions(+), 255 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 007c35cfc670..1395b4860f23 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -575,13 +575,11 @@ static int aead_setkey(struct crypto_aead *aead,=0A=
>  	if (crypto_authenc_extractkeys(&keys, key, keylen) !=3D 0)=0A=
>  		goto badkey;=0A=
>  =0A=
> -#ifdef DEBUG=0A=
> -	printk(KERN_ERR "keylen %d enckeylen %d authkeylen %d\n",=0A=
> +	dev_dbg(jrdev, "keylen %d enckeylen %d authkeylen %d\n",=0A=
>  	       keys.authkeylen + keys.enckeylen, keys.enckeylen,=0A=
>  	       keys.authkeylen);=0A=
> -	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",=0A=
> +	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",=0A=
>  		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);=0A=
The alignments should probably be taken care of too, even if it adds a bit =
of noise.=0A=
=0A=
Thanks,=0A=
Horia=0A=
