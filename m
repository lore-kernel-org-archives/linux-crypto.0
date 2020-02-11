Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7B6C3F68F
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 10:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BFE9208C4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 10:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kkW2qVFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgBKKJT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:09:19 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:40417
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgBKKJT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 05:09:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXpp/KLg72GAUmOjc2jKtVcgrUL0zqXfoNLdUWtvUACOkewC2xvb0sERmhizXkFSjUfP8AR4rfI41MO55heuqn/pId0aePrAJUHHwoJ3oapRoWF0iCW0JRwH1H0cm5Oo3Fe2SLN/ZKZZ3UBdG+wL2MuOANf8pOiS7ATwejvPrU6q/l2dxdavO79Mxm/K/T+BJMCANI4jAHzkIVVyHc0fymuRjMLLg+mecrllPECmOb7zgYxH8uyWS+RyTD43h/tVAkjNKUxqsaNuKRfJwstJXIQLoU1fJi4TOeXeJdTHGTJWcJpQbeDrZczUzgoYtPXpAFQn/I4+jbg/QeGbn/v9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PshmXL9ngftwwofQ6Kv+QwZ3/ajeVyGmyhXbq4vQfvA=;
 b=HVO7tgjTV7FlpaDv4T9cfeVDeFT8/+kUgFjdCpSD2b5QNvdoeYP+Q+vdtWJxBYqDw4JMODPNwX3s29akBc4F44OsLikFbBqltJ6yH63PVkLC0d7VRokYMdKznPWYqn2Av2CxO5fnWd+qc7UrftFeh33ds7NvCkvol/tI2dDtASzYqrq3K+eOq4S19H8K+Bg3sJ2pny1R3sg8KmTF8LoC2A1jHsfoQb6U/tgOnn2UKEts03D3XuVNbEr2/izEUm8SsZO5Hp0PD+fUGBJ4ylI8a5sxgTpZOZQEyuK1Jz82Jy1NKfB59Nd18/6ix4eNfmlU6nD6WlPYjT+nQ210aUpUAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PshmXL9ngftwwofQ6Kv+QwZ3/ajeVyGmyhXbq4vQfvA=;
 b=kkW2qVFZtmyHjlV3tOm5vCwIkdQOOckfGdAFQdXo4BpXCK4siXLirZ1eioawsacjSlnIgo5EEjb64pzhXRQn5bIO6EsaqprFFtaK8/X1SF1pf9Ib482mgHOfP9R4/tezG6jQG9s8gbFqNi/YO7khuzUelvnFD4j9r80ujYCNE0Q=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3888.eurprd04.prod.outlook.com (52.134.16.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.29; Tue, 11 Feb 2020 10:09:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 10:09:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 7/9] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Topic: [PATCH v5 7/9] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Index: AQHV1wcsnAjGUApJB0OklRDElRQKxg==
Date:   Tue, 11 Feb 2020 10:09:16 +0000
Message-ID: <VI1PR0402MB3485055915C1DBA73B8D23AF98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1580345364-7606-1-git-send-email-iuliana.prodan@nxp.com>
 <1580345364-7606-8-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb05949f-51fc-4daa-1b28-08d7aeda73bf
x-ms-traffictypediagnostic: VI1PR0402MB3888:|VI1PR0402MB3888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38883F4B3333087E069D53A098180@VI1PR0402MB3888.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(7696005)(6636002)(316002)(110136005)(54906003)(44832011)(186003)(2906002)(26005)(53546011)(6506007)(52536014)(33656002)(91956017)(5660300002)(76116006)(4744005)(66446008)(66556008)(66476007)(66946007)(86362001)(71200400001)(64756008)(81166006)(81156014)(478600001)(4326008)(8676002)(55016002)(8936002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3888;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jm7b0dTTx2J/F8XBgvtfzuE0NfqNisJlevDJ77aBYCYdiaUq0Leo+fulKz6Qbuhd2ggOwpESSfQZLVUFSkAHvwO8A+0NR2HeguaLI17grYkRSUWDvvEoSO25afCjIKftMmYn6jeht0V8ZpqmcjA8tqL7ZMcW6G5h2KwTA5yyk+jkf33zQuHXHDo92O/7EovueXaoJ4L+pWLPtf/6QBo5fo4XmnVSHYln4QO8c9UcI/GL+MtmL5yYZ3gd3JmGNSDb658v+cO1lHsP2lWjCs9Lr5Ag5GFwWMEvEZBsi7xfeQIIGrUg+GST17fja0zkihCRINM8RtCkm7W0DVzTwVKaFBefaxZqQmN2ko87/EJzoWrEGhB0YOyUEZP4S+D42NV/OHU5GSScTp66WWWCMuOwVEbEXGva+ASHqgVlIQ8vUqX1DE4N4eBYvaQ7ouH9VOj
x-ms-exchange-antispam-messagedata: laD/ytVA96uxvSaa62DGNSQd4RUc+u/Y33C582UCO7F1bKVgAHpMF60JRDxjc9tuVVN3KanZIrAmUmPoy2TSQnYqJ3mbsGQaOLNLhbGaryDekC9sFW3Fn9LlZH98zCAN/6xiOIvxyUFeAXXcrnil1g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb05949f-51fc-4daa-1b28-08d7aeda73bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 10:09:16.3682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muf9fPrKMS8V2x49Zq0aEvMjuk0SnvqAvcYutSRz/L99EnQwOW8mv/EktreSeWkZ/aWXft/JJsl+x2b0gOmN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3888
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/30/2020 2:49 AM, Iuliana Prodan wrote:=0A=
> @@ -1362,6 +1378,10 @@ static struct aead_edesc *aead_edesc_alloc(struct =
aead_request *req,=0A=
>  	edesc->mapped_dst_nents =3D mapped_dst_nents;=0A=
>  	edesc->sec4_sg =3D (void *)edesc + sizeof(struct aead_edesc) +=0A=
>  			 desc_bytes;=0A=
> +=0A=
> +	edesc->bklog =3D false;=0A=
Nitpick (similar to skcipher): not needed, edesc is allocated using kzalloc=
().=0A=
=0A=
Horia=0A=
