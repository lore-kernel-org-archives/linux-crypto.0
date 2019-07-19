Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C75DC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5821A2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="nSiY+8un"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfGSPyC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 11:54:02 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:24485
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727927AbfGSPyB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 11:54:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3CL5jDCzNUDIUNOaV73DN8B3kyqC0Gm+f+y8qbvaSuF8wwqnzgxqaJQ/1meBc9owQCID29iWWDjoqpANC3w22SIojc7mEsZXnXWmrJowQHpO9xuS00Qk8nKDiGcyYlh/QvxPIhUStS3UECNFrtx46KK4vEjngVKYIfMZgK2IjT+uWX3Q3CSBf0RwjcGwZ3M2lFD5PkIC4zk9LME92+3JOYiBUVIT8lllBi8OQkliA7e1AzgQksGRYiEa0u0Alas+uSQiBdo87v04uM9l4QVoljTGKjpPRb9yxMgyJCRQxDNeEVZMqmt4sHJIlRUW5MTPNWRUwond8OdFP9WOx7/mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljUdsTerhXURISW6KYfDbGWQ5hkppm6fOqFnOZbAmyc=;
 b=IXvX6MSL5my2AfDqOTO02PVw7fBA8Wt51wp+LvX9PQ6/CRS4H+/Tnr9nPsv5znuVq3CZmwZqE+OqGFHclhYwBurPQvgHsXZO9wamWEhqnUfOmQo1EZUAudjCO3R44k9WGlBunXeDbAzFOXL/ULo+dI51IKO9tuo70vwc5/do+ks4+itVJvm5BMjr7g1ixPAxvm/DftWSfsuV61b+zSIK1bn1t3x8xCM118sVnQqtw6qwAR0NmFFf+JHwhCljf9HkMMv8fm5IHRNEzg+etETzWfZjWk/lkzsU7WLzgdfcLvLW81CBmn5rxHsD6Ve9rY9Udg0DxvKqR+hW7HJqi4+JIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljUdsTerhXURISW6KYfDbGWQ5hkppm6fOqFnOZbAmyc=;
 b=nSiY+8unQ7xaZK2QDKlmqLMKmQ8/pMRNv6rcdGJl+UDRmse+H7suab6OqP+VtkSyUEh6/MerunHH0FHMj1F+okF1tQiJehmQUkWBOPUfqmK/CN3vmxE4lgXLoTOYBGACrk7u+6JwC7I/xIcvXH8uhvhjLsbPwnB3zvzX28S7Bj4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2830.eurprd04.prod.outlook.com (10.175.21.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 19 Jul 2019 15:53:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 15:53:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 11/14] crypto: caam - free resources in case caam_rng
 registration failed
Thread-Topic: [PATCH v2 11/14] crypto: caam - free resources in case caam_rng
 registration failed
Thread-Index: AQHVPcSsWvTQBfAmgEuDvU1d/uopWA==
Date:   Fri, 19 Jul 2019 15:53:57 +0000
Message-ID: <VI1PR0402MB34854E7338BACFC9F531BAD098CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-12-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 451c700f-f507-476d-bfc0-08d70c614f2c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2830;
x-ms-traffictypediagnostic: VI1PR0402MB2830:
x-microsoft-antispam-prvs: <VI1PR0402MB283097FFAD59C18BE088AD0C98CB0@VI1PR0402MB2830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(199004)(189003)(53546011)(44832011)(6506007)(4326008)(4744005)(486006)(316002)(76176011)(2906002)(71190400001)(71200400001)(478600001)(76116006)(91956017)(55016002)(9686003)(66476007)(66946007)(476003)(6636002)(8676002)(6436002)(86362001)(446003)(256004)(14444005)(99286004)(7736002)(229853002)(7696005)(26005)(66066001)(102836004)(54906003)(6246003)(8936002)(66446008)(110136005)(66556008)(64756008)(186003)(74316002)(33656002)(14454004)(68736007)(81166006)(305945005)(52536014)(81156014)(6116002)(3846002)(53936002)(25786009)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2830;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Qf5M3zbDtTGzmGOFhK1xSKEwssbgBimvqBR/QB6bYyPvYxX5O/I74xI+l73d/Z81iYk3t5BpOp4DTsOuy71lmYACLe69kDrfWoPtANCbKXxlF/fc86E/2XG/5XMHFFvEvoYiRskGgAw4LHUCSvs9mGYfuTsixVA7M+L4lSD40yxdcJyrDDElCgHd7HpgxEzQxjrE4TVZoefNqrRueWOvpUGQmLobfe4tlP02FgzsOFdKn3PKraJcOl15D57JxWIoYug31sN3sO1VqS0mvMoCSYe1mhftR3B+CfACdBMJnbAsYUNKrnZtpc/sZHGPBD6vA/fUv25mnH5vvp8Cv0R0yyOyMmx83QHNjRvgBES8DnMNRKlOnxVHaHW0ZXM2DKs/nMqLlkMzn5TXnhJM2qH9e4BwxczJYF7Byor7vEy5Ccg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451c700f-f507-476d-bfc0-08d70c614f2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 15:53:57.4728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2830
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> Check the return value of the hardware registration for caam_rng and free=
=0A=
> resources in case of failure.=0A=
> =0A=
> Fixes: 6e4e603a9 ("crypto: caam - Dynamic memory allocation for caam_rng_=
ctx object")=0A=
This should be:=0A=
Fixes: e24f7c9e87d4 ("crypto: caam - hwrng support")=0A=
=0A=
since there are resources leaked (like DMA mapped buffers) due to not check=
ing=0A=
the return code of hwrng_register() even in the initial caamrng commit.=0A=
=0A=
This doesn't have much practical value, since we haven't seen this failure=
=0A=
in practice and we don't intend fixing previous kernel releases.=0A=
=0A=
Horia=0A=
