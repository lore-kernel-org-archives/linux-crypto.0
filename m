From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
Date: Tue, 15 Dec 2009 00:29:20 -0700
Message-ID: <e9c3a7c20912142329j6603402ah2963d075419efa1c@mail.gmail.com>
References: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, B04825@freescale.com,
	R58472@freescale.com
To: Vishnu Suresh <Vishnu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33350 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZLOH3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Dec 2009 02:29:21 -0500
In-Reply-To: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 14, 2009 at 6:33 AM, Vishnu Suresh <Vishnu@freescale.com> w=
rote:
> The async_tx descriptors contains dangling pointers.
> Hence, re-initialize them to NULL before use.
>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
> o. Rebased to linux-next as of 20091214
>
> =A0drivers/crypto/talitos.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 87f06be..9e261c6 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * talitos_p=
rep_dma_xor(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0dma_async_tx_descriptor_init(&new->async_tx, &xor_chan=
->common);
> + =A0 =A0 =A0 new->async_tx.parent =3D NULL;
> + =A0 =A0 =A0 new->async_tx.next =3D NULL;
> +
>
> =A0 =A0 =A0 =A0desc =3D &new->hwdesc;
> =A0 =A0 =A0 =A0/* Set destination: Last pointer pair */

These two values are owned by the async_tx api, drivers are not
supposed to touch them.  Both iop_adma and the new ppx4xx driver
(which use the async_tx channel switching capability) get away without
touching these fields which makes me suspect there is a
misunderstanding/bug somewhere else in the talitos implementation.
Also that dma_async_tx_descriptor_init() is unexpected in the hot
path, it's only needed at initial descriptor allocation.  End result I
think this driver needs some more time to brew.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
