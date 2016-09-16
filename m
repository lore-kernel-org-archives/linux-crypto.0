From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix sg dump
Date: Fri, 16 Sep 2016 13:49:43 +0000
Message-ID: <DB4PR04MB08477BD1439B77894D18381F98F30@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1474016787-5792-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto-owner@vger.kernel.org"
        <linux-crypto-owner@vger.kernel.org>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Cata Vasile <cata.vasile@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr50059.outbound.protection.outlook.com ([40.107.5.59]:18624
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934882AbcIPOVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 10:21:43 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/16/2016 12:06 PM, Catalin Vasile wrote:=0A=
> Ensure scatterlists have a virtual memory mapping before dumping.=0A=
> =0A=
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c | 65 +++++++++++++++++++++++++++++++++----=
------=0A=
>  1 file changed, 50 insertions(+), 15 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 6dc5971..49f1ea7 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -111,6 +111,41 @@=0A=
>  #else=0A=
>  #define debug(format, arg...)=0A=
>  #endif=0A=
> +=0A=
> +#ifdef DEBUG=0A=
> +#include <linux/highmem.h>=0A=
> +=0A=
> +static void dbg_dump_sg(const char *level, const char *prefix_str,=0A=
> +			int prefix_type, int rowsize, int groupsize,=0A=
> +			struct scatterlist *sg, size_t tlen, bool ascii)=0A=
> +{=0A=
> +	struct scatterlist *it;=0A=
> +	size_t len;=0A=
> +	void *buf;=0A=
> +=0A=
> +	for (it =3D sg; it !=3D NULL && tlen > 0 ; it =3D sg_next(sg)) {=0A=
> +		/*=0A=
> +		 * make sure the scatterlist's page=0A=
> +		 * has a valid virtual memory mapping=0A=
> +		 */=0A=
> +		buf =3D kmap(sg_page(it));=0A=
Even though driver has been updated recently to use threaded irq instead=0A=
of tasklet, there are still cases when you are not allowed to sleep here.=
=0A=
You should check this and use kmap_atomic when needed.=0A=
=0A=
Horia=0A=
