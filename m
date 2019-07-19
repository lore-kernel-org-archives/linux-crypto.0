Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED224C76195
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C324721871
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FKbO+xCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfGSPGl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 11:06:41 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:24198
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfGSPGl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 11:06:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iffxJp1/zYSZ9rQOOP+na7f4Gx/RtfpNxKIfkknunR/KAw51doIQCGWjNarLYnnO5NeqJYeKOqkfhDSWbHth3qjR+kz30u72qykO5/BSXoTQ7H7lbK7INbehUEZSDPCIFsse3JQJbDSGBgyG1Ut5s8qJ0X7NgWxlAgoTPSBnkVL/rKjpdT3aar0/ieKT2f25Xb1oB2C69sc3XcQChZkgdTHieO16jf6q1YNaJ/Zjf0OgY/xD2bz8laSCp1b/530zkHSnhfhdnz1MhVtyKLCqvju7EUx6vGm5/6Om+H6Zt4HZYSFd/a36fBgl5ZG3LjIhzZalKUL5IVQLNTzI0M9rvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z+3Xm1p3K11WOk1fC41X04qus8b22zfzhUMDmBZsG4=;
 b=PP0b1Hldwq2FAqJYPbfutqg+e9LcM0L1RPi+c0TSQAbPE/Qn0qRge3z5GX2Eofr/6fk4rcR31AtRwJpa2Fu/7waG/2zWdLUl096SG7GS5uU9yRf5DhJptRPq7iOcoG7JabDKK0kqMRC5SuyfP65RKJZmneRvDfSvF+UlBDKs2ifkU7+3WBuJ6czbQoGkmaPOR6cOA9GHwWokoLOqPbngyZSwHjWav0q3+R1pBAUnZL0DYNhLBo2Tyh96M8KtZKIfD9msgsUuGF3iywezGnbuBsdwm8Hk45xWMS9tH2b0F+fvWZkARWU6emcnOB74ZcW1cLSGPmrQFf7xs3lohbeAeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z+3Xm1p3K11WOk1fC41X04qus8b22zfzhUMDmBZsG4=;
 b=FKbO+xCzjIvr8ZuqgVcDrJ9eoclTMfYSj+dNZDku2VP0nSR4sjUxWSY+LcJFlCNPoGvMtR6ipGHBalQzhUucrDed2yPjKqfgX0P6VUYxhIL0YZHDPRl+O/WZRxrhzBmVpqRypX/7QTfDErzdNfTSR2jFjYF8Gkk6RYU3CWQtsP4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3821.eurprd04.prod.outlook.com (52.134.16.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 15:06:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 15:06:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 06/14] crypto: caam - check assoclen
Thread-Topic: [PATCH v2 06/14] crypto: caam - check assoclen
Thread-Index: AQHVPcSrPwrclwKlbUCTKS9P1HlDCw==
Date:   Fri, 19 Jul 2019 15:06:38 +0000
Message-ID: <VI1PR0402MB34850ACE9BD5CC43A150085798CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f46f3fc-aeb4-4584-65c5-08d70c5ab30c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3821;
x-ms-traffictypediagnostic: VI1PR0402MB3821:
x-microsoft-antispam-prvs: <VI1PR0402MB3821F8581C423E8D1392F6E198CB0@VI1PR0402MB3821.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(256004)(33656002)(4744005)(14444005)(53936002)(68736007)(74316002)(102836004)(71190400001)(71200400001)(53546011)(7696005)(6506007)(76176011)(14454004)(186003)(305945005)(4326008)(7736002)(66066001)(229853002)(5660300002)(9686003)(81156014)(76116006)(476003)(66946007)(55016002)(54906003)(3846002)(110136005)(44832011)(86362001)(6116002)(26005)(66476007)(25786009)(8936002)(99286004)(52536014)(66446008)(64756008)(66556008)(478600001)(446003)(2906002)(6246003)(6636002)(91956017)(316002)(81166006)(486006)(8676002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3821;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u/Rzpoq1sOteha7KBWzAcu0MpZeyqKa4WS3Xz+W9o3b45diA8YvFonAFvemSvK9dUy2c+abVNZKoKpNvcw+SgR/9va82JqpMsmQHGRTdISFdx0Pt8Euhcp3zbmt4vAi5CTYHq4JA6BIEfY05zHzZ91IETR5GAuG6YFMExjmSLG2BXngq9ku9PjBJwijyYt3rft9DKi2Q9c3V4p8k5u40V3LykEqhQZwKLADGoIi3Ac2k8VafUAlUIm1HNbOON38Bfp6T+egui9gmyigzxfTvWzDKslF+zUXIqk5dJEgsgIAloS7ta+suW4UlTHto0R/+2hQDfu5vMEKVwFq915VtLe4Eclnj9U8fTrmdQ1+pABPJRx8PZ++o5J3hR1e0aeoOX7bxfQBuc/yHdKXpvUolMjlj+zjvaJekZy58H3pgrW0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f46f3fc-aeb4-4584-65c5-08d70c5ab30c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 15:06:38.6218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3821
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
[...]=0A=
> --- a/drivers/crypto/caam/common_if.c=0A=
> +++ b/drivers/crypto/caam/common_if.c=0A=
> @@ -66,6 +66,23 @@ int check_rfc4106_authsize(unsigned int authsize)=0A=
>  }=0A=
>  EXPORT_SYMBOL(check_rfc4106_authsize);=0A=
>  =0A=
> +/*=0A=
> + * validate assoclen for RFC4106/RFC4543=0A=
> + */=0A=
> +int check_ipsec_assoclen(unsigned int assoclen)=0A=
> +{=0A=
> +	switch (assoclen) {=0A=
> +	case 16:=0A=
> +	case 20:=0A=
> +		break;=0A=
> +	default:=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +EXPORT_SYMBOL(check_ipsec_assoclen);=0A=
> +=0A=
It's probably worth making this function (and even the other ones=0A=
in common_if) inline.=0A=
=0A=
Herbert, is it worth having these checks moved to crypto API,=0A=
so they could be shared b/w all implementations?=0A=
=0A=
This would also provide clear guidance wrt. rules related to=0A=
input parameters length.=0A=
=0A=
Thanks,=0A=
Horia=0A=
