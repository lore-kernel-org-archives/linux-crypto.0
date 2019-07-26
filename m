Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEE1C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584C3218D3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ijFdnebp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfGZOMJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 10:12:09 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:6855
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727422AbfGZOMJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 10:12:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2MwByCjIO7euzeoXswsm1N71O1SxZYsfzuugXRoOOjOjxUhePucBSb2djWbo0Dfe9ezMLEfuc2tcvo1Q7s6E2OMjeasGcdip2DQKo8DW2OopmpEAfktIBsLRjIEu/m7IoaNzGGMMrHN3LDDIE+v7fzZfShc2tu0FtLaFQqZ88g5XGfqzVLMYEuSeAdvASxKejoj3tNcqnvvNvECI+NVoQV135bBpEMc5ML3sFTRwMB1TNeTW35F9MXRLsu+zaSjWxF4vkQ9Wa54s/zle3WPgSUCyp0yCSCFuwc/IANpt61zl6ZiapzXFdzUc24W638Mqt7y6hASOlY+lgsf5ifW3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTVGJvNtEgqWPGxCeeDB9w6IrL8ICLTdAXyd6jal07g=;
 b=YDfU5cbOWUWq1MuAFVvXribT7hqU3Y1ZqiJMWRDL5jqsHDX86p92Dk25+johb1xOG+vQJvmreDY7sKUH0oH9dJP7jOMjqYlafLvbZ9RmgiXH/28mniItxnPhmRP/0HrJI+2WEE+iKh2z2Bqa6iO0Z0Tl+QBfO6vrsBneRXeVmdSz4fimnhTbctdZHIqHHbngtJFhP96U5/ces5OEVFsNzebpEzD2LqoGzPVPe7feUh6MC4LBMbYF5KzAUPPucajfXyY7v9UdI/M4jH6fw599bHCOIllU1RErVkIe7HH6fY5dQufX8Zc8oYGydR/9E12jRNIGpNI4Tx11yhapsuPxNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTVGJvNtEgqWPGxCeeDB9w6IrL8ICLTdAXyd6jal07g=;
 b=ijFdnebp2g0WcGqzvjqV7r+i8/m7l7UXgyT3r6PuPw78fmNmK8igqlaHXpoBavFkoVaqEwNeXTQFT2x7A/yAIGOr2Nv0ljJJwx4qwyzG1AK9wbRH8NfNscCI27t7+CutI6YzlBaX7cVkG0WS31nq/riu73htIjT9SnFckgZc0vE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3856.eurprd04.prod.outlook.com (52.134.16.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Fri, 26 Jul 2019 14:12:04 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 14:12:04 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 1/2] crypto: gcm - helper functions for assoclen/authsize
 check
Thread-Topic: [PATCH 1/2] crypto: gcm - helper functions for assoclen/authsize
 check
Thread-Index: AQHVQu+ClTocs+b6ykKe3pUqr8+viw==
Date:   Fri, 26 Jul 2019 14:12:04 +0000
Message-ID: <VI1PR0402MB34853F503F9FA2B4F64AEEB098C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564062431-8873-1-git-send-email-iuliana.prodan@nxp.com>
 <1564062431-8873-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fca1043-4fb6-4d83-1849-08d711d33c9c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3856;
x-ms-traffictypediagnostic: VI1PR0402MB3856:
x-microsoft-antispam-prvs: <VI1PR0402MB38563892DA38E89D760FE43498C00@VI1PR0402MB3856.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(199004)(189003)(6116002)(4326008)(53546011)(5660300002)(71200400001)(71190400001)(55016002)(99286004)(6506007)(66446008)(64756008)(86362001)(4744005)(66946007)(26005)(52536014)(486006)(66556008)(6246003)(2906002)(91956017)(14454004)(68736007)(256004)(33656002)(76116006)(66476007)(7696005)(81156014)(14444005)(81166006)(476003)(6436002)(44832011)(102836004)(186003)(446003)(53936002)(9686003)(305945005)(478600001)(25786009)(66066001)(7736002)(8936002)(316002)(110136005)(74316002)(54906003)(3846002)(229853002)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3856;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gGha6SmGPp0NB36JroWMbIRQshoTzSOsqntmmAot7MG6voz2xlEPF4YbshoXTMsN/qZITxISAvfkSVQDvKLPWrgy8qduCEnuqZRgh5X5rFdFJtW8BxQceTeraF5kkd4upb6NA31fw9JCN9hdW7WIQffBxLlaUvO7MuyJstvn96ckz9eO+WhE2op1hYAeMwKkuDojLUwj7We0tKTODVy4hbKR8kCeMNK2yo5kLlnPvwCpPGG0B6RWRw9R2Ek9UoooYWrh50CJ5aOJyGNVzXi1029ov+dT7/VlxNX669PJVAHbsJNudRCNYDkDVPLPYnVIN/vyQf3NN4jUoTga94Cwpa8OJbvHwHR4DX68khW9BwvcR4nLlpUl8ImRRSsuB6eGiRFEfP3hZz7NORMMVqm7KrwPncAeXyBil3Ly3v4duew=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fca1043-4fb6-4d83-1849-08d711d33c9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 14:12:04.7859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3856
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:47 PM, Iuliana Prodan wrote:=0A=
> Added inline helper functions to check authsize and assoclen for=0A=
> gcm and rfc4106.=0A=
Also rfc4543.=0A=
=0A=
> diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h=0A=
> index c50e057..9834b97 100644=0A=
> --- a/include/crypto/gcm.h=0A=
> +++ b/include/crypto/gcm.h=0A=
> @@ -5,4 +5,57 @@=0A=
>  #define GCM_RFC4106_IV_SIZE 8=0A=
>  #define GCM_RFC4543_IV_SIZE 8=0A=
>  =0A=
> +/*=0A=
> + * validate authentication tag for GCM=0A=
> + */=0A=
> +static inline int check_gcm_authsize(unsigned int authsize)=0A=
I'd prefix the helper names with crypto_=0A=
=0A=
Horia=0A=
