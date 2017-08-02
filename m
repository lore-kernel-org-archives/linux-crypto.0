From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v3] crypto: caam: Remove unused dentry members
Date: Wed, 2 Aug 2017 08:44:12 +0000
Message-ID: <VI1PR0401MB2591DCDD3AECC19FFB2480B298B00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1501595101-13919-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:19508
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751120AbdHBIoO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 04:44:14 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/1/2017 4:45 PM, Fabio Estevam wrote:=0A=
> Most of the dentry members from structure caam_drv_private=0A=
> are never used at all, so it is safe to remove them.=0A=
> =0A=
> Since debugfs_remove_recursive() is called, we don't need the=0A=
> file entries.=0A=
> =0A=
> Signed-off-by: Fabio Estevam <festevam@gmail.com>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
