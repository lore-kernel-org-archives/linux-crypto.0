Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:18686
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfAHJrf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 04:47:35 -0500
From: Horia Geanta <horia.geanta@nxp.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] crypto: talitos - reorder code in
 talitos_edesc_alloc()
Date: Tue, 8 Jan 2019 09:47:30 +0000
Message-ID: <VI1PR0402MB3485608DF1B37BB7C740DD36988A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <5ed91db5e2976a4c260465c3d027acc9affd2d2b.1545445924.git.christophe.leroy@c-s.fr>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/8/2019 8:56 AM, Christophe Leroy wrote:=0A=
> This patch moves the mapping of IV after the kmalloc(). This=0A=
> avoids having to unmap in case kmalloc() fails.=0A=
> =0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Since patch 2/2 is Cc-ing stable, this one should do the same.=0A=
Herbert, could you append the commit message before applying it?=0A=
=0A=
Thanks,=0A=
Horia=0A=
