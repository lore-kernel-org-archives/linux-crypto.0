Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FD8C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 16:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BEF0205F4
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 16:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PJbVa0lX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfCEQnx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 11:43:53 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:55538
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726854AbfCEQnx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 11:43:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql/lU2CFihvQNkbh8I8g5+AZk35zPN5sBLP0g1RlLCc=;
 b=PJbVa0lXQci4nEr/mLtKY9qhJmT+x7wVI/7s9Y8rBqyV8PDbTyz3IPscDDho8J6IzhER4xTHlo9XhEAPnl1Yt7jaA0kQP0N3KUOOqLhSG7aSvj40k5hVTi55gFT3A5DfkS9fkgsGOJkiLRe+YKc2eVJU2h12pvIvD6cmDrjAHfQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3776.eurprd04.prod.outlook.com (52.134.15.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Tue, 5 Mar 2019 16:43:49 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1665.019; Tue, 5 Mar 2019
 16:43:49 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Index: AQHU0yEvYfnJy4m6QkW0mfkgeeAyJw==
Date:   Tue, 5 Mar 2019 16:43:48 +0000
Message-ID: <VI1PR0402MB3485BD912D8FA0E1A33CBA5298720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190305065820.13072-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7219be4-1616-4a7f-0351-08d6a189be0d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3776;
x-ms-traffictypediagnostic: VI1PR0402MB3776:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3776;23:LDO5MrkEeUcUc725tcI2bcpOFP3o6s3+FvloOf2?=
 =?us-ascii?Q?GiIm/bI0qBZcXQvBG77OReRJxiJt9TVXIDqDu8pc8GXLwDND6W7aLmKHFSwU?=
 =?us-ascii?Q?hISMGU1us/TLJg81RPzAKNl8IBAv58BvhCO3IQyqL4t4+4AWxg0ERpT3VYxd?=
 =?us-ascii?Q?8Obif8GdyZ8BYOpTbcq+rg9OWZk+hJUm9jvxzdV9RlEzMy0ZgdjlhwfHjiml?=
 =?us-ascii?Q?/DSYY+mf1jQ1fNUzQvRAuAyjn/BMSj70R8FdxvfVPKcrcWSzodT4ml00QwuD?=
 =?us-ascii?Q?0RfwLGtthK0tpGxZm3ELKyDXSNZoklYP1wfambrSic8Q0M3j0p0G2vQ3n1RE?=
 =?us-ascii?Q?k3TwLR9LoobVIQ99lkbeRIhEUF+zrpzMwn8sSb7V9dlNtewiCSFx57+Fy/g4?=
 =?us-ascii?Q?UumvKCbw0AzL7fJ9VsnhVnmosXi2Sy9pJxAhd/YokwoUyYh3DZHoSrDn2D/9?=
 =?us-ascii?Q?mYK1ZiVYsIkgDRtHsvMBu0KT1bTuSc8QgZi5h1alQbQnO4wl1LPKrdAWUf0K?=
 =?us-ascii?Q?7+YEZ42tPvXDqfMlKRq1qOjoHyVWjoYe0dDxxlDRKv8Rmn+x3+6NlPMaKQIi?=
 =?us-ascii?Q?ELRM5VZTPT+4GKJ1lcOPQm8eSX6EhOT6HBgDGs+YED768kqYHgsHKOD69doD?=
 =?us-ascii?Q?VuEefVZxS82Ih826s+U8jo3a16F430P/3kyfcz+MYYMQiOW+kx4uR4YhZ4yT?=
 =?us-ascii?Q?/415k03J+fvgFoWiX586LQHdFpZboUFddKTCz35hN5+qxUNNBDNEwaXQ0GTk?=
 =?us-ascii?Q?XtgygsSR/70wLkeKWMrtGmfQJ+FtDhFHPGf7AVC3akVld8z93xo4SEEgxmbe?=
 =?us-ascii?Q?oZTIPTo26ztyi3ieJXeVMpiLUtw9cvdvpeG9NDRrsb14XMNuc8ZTd4OrOLSn?=
 =?us-ascii?Q?gUQzOULbLFdizcZd0Uj5VnvIRShdQOc+0VNib5ZIVKO+RNnj7ssbOeJ4dGwQ?=
 =?us-ascii?Q?5bAnEbBu+wqm2EeexKBGDdSCTviFp2+0GzsznQNEhWACoLHwcV2C0VMhXJeP?=
 =?us-ascii?Q?gU57mgDnLd5ONjtptlQN/YRiQ8O9T3KFzLW0kpZjV7CwGzb0CYTffLWlyXWs?=
 =?us-ascii?Q?mnl1sQWOgZri/MMhb4yFem1p8L1Zq1upM5vP/MjvJiTkvSRKCW/yNjq3bmz4?=
 =?us-ascii?Q?Yr2UbYqD9EW4TfAa2gxtldAqtUjlWssm4msCkbreOwUCUz5Ekq40wBc9dX6b?=
 =?us-ascii?Q?W6ZfFOSNcC2yCKd/VU0O6Hl/mxVxUCkVedYM2aNyTOFDk42J+LkL9XyScZfG?=
 =?us-ascii?Q?yFKuEm5Mwu1pdMhGyrEM=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB37765A195334CDC758E41ECC98720@VI1PR0402MB3776.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39860400002)(199004)(189003)(7736002)(102836004)(3846002)(316002)(6246003)(8936002)(54906003)(105586002)(81166006)(8676002)(110136005)(25786009)(6116002)(81156014)(74316002)(52536013)(76176011)(26005)(4326008)(97736004)(106356001)(66066001)(14454004)(53936002)(478600001)(256004)(7696005)(9686003)(229853002)(6506007)(2501003)(55016002)(6436002)(53546011)(68736007)(2906002)(5660300002)(86362001)(33656002)(186003)(305945005)(71200400001)(44832011)(446003)(99286004)(71190400001)(486006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3776;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +aunPqMAQl/WbaaGc3EdaIEs/LjJ3UToHOLl1jeAnMRdwnhArtDAx9MGCzb8iUlV3Wl6vEC0WIJolGNK3K410U/51MnB9XjasxlFDVKoNcchrU4WteJEMV7cHFmWE+AzhHF88uqelp0prTuSwxC05yL8C8lkvMaeeT9hED7LNmCoCqNTvq42BcJLaDHbKtf2/3KI1S62uh2pTqTXEpZp10RMoHmzECmIbQ/JoIoY0zkvFsrcS4jjYeHJKXltij+Df1UJWYAp9AKw1P62ZQpFONY05ddv3QjQvVcT+RjouWoxdoC8zyS8ND8c7ezJG7HFS1IxcArdqpnptDIuw4oIiZTjDHvTP9+X1meFPmD/Z4ecCJwrsgb3bM6fV93cTjNA6eQHObvIAWlA/BcOvYgEcWimiG1X8o0vcHIrgtavcXc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7219be4-1616-4a7f-0351-08d6a189be0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 16:43:48.9718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3776
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/5/2019 9:00 AM, Vakul Garg wrote:=0A=
> Instead of reading job ring's occupancy registers for every req/rsp=0A=
> enqueued/dequeued respectively, we read these registers once and store=0A=
> them in memory. After completing a job enqueue/dequeue, we decrement=0A=
> these values. When these values become zero, we refresh the snapshot of=
=0A=
> job ring's occupancy registers. This eliminates need of expensive device=
=0A=
> register read operations for every job enqueued and dequeued and hence=0A=
> makes caam_jr_enqueue() and caam_jr_dequeue() faster.=0A=
> =0A=
How expensive?=0A=
Please share the case you benchmarked and performance improvement you notic=
ed.=0A=
=0A=
Somewhat related: it seems that after commit a0ca6ca022ac ("crypto: caam - =
one=0A=
tasklet per job ring") the "outlock" spinlock could be removed, this being =
a=0A=
good candidate for further improvement.=0A=
=0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/intern.h |  1 +=0A=
>  drivers/crypto/caam/jr.c     | 12 ++++++++++--=0A=
>  2 files changed, 11 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=
=0A=
> index 5869ad58d497..b6d96e2ecf4c 100644=0A=
> --- a/drivers/crypto/caam/intern.h=0A=
> +++ b/drivers/crypto/caam/intern.h=0A=
> @@ -59,6 +59,7 @@ struct caam_drv_private_jr {=0A=
>  	int out_ring_read_index;	/* Output index "tail" */=0A=
>  	int tail;			/* entinfo (s/w ring) tail index */=0A=
>  	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */=0A=
> +	u32 inpring_avail;		/* Number of free entries in i/p ring*/=0A=
Locality: this should be near the other enqueue-related structure members.=
=0A=
=0A=
Nitpick: use "input" instead of "i/p".=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
