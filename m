From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v0 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Thu, 29 Oct 2009 15:46:37 -0700
Message-ID: <e9c3a7c20910291546r2603e191g87a23023c32f1b1b@mail.gmail.com>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
	 <1255588866-4133-2-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Kim Phillips <kim.phillips@freescale.com>,
	Dipen Dudhat <Dipen.Dudhat@freescale.com>,
	Maneesh Gupta <Maneesh.Gupta@freescale.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:42271 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbZJ2Wqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Oct 2009 18:46:32 -0400
In-Reply-To: <1255588866-4133-2-git-send-email-Vishnu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh <Vishnu@freescale.com> =
wrote:
[..]
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index b08403d..343e578 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -192,6 +192,8 @@ config CRYPTO_DEV_TALITOS
> =A0 =A0 =A0 =A0select CRYPTO_ALGAPI
> =A0 =A0 =A0 =A0select CRYPTO_AUTHENC
> =A0 =A0 =A0 =A0select HW_RANDOM
> + =A0 =A0 =A0 select DMA_ENGINE
> + =A0 =A0 =A0 select ASYNC_XOR

You need only select DMA_ENGINE.  ASYNC_XOR is selected by its users.

> =A0 =A0 =A0 =A0depends on FSL_SOC
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0Say 'Y' here to use the Freescale Security Engine =
(SEC)
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c47ffe8..84819d4 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
[..]
> +static void talitos_process_pending(struct talitos_xor_chan *xor_cha=
n)
> +{
> + =A0 =A0 =A0 struct talitos_xor_desc *desc, *_desc;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int status;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&xor_chan->desc_lock, flags);
> +
> + =A0 =A0 =A0 list_for_each_entry_safe(desc, _desc, &xor_chan->pendin=
g_q, node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D talitos_submit(xor_chan->dev=
, &desc->hwdesc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 talitos_release_xor, desc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (status !=3D -EINPROGRESS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&desc->node);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&desc->node, &xor_chan->i=
n_progress_q);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 spin_unlock_irqrestore(&xor_chan->desc_lock, flags);
> +}

The driver uses spin_lock_bh everywhere else which is either a bug, or
this code is being overly protective.  In any event lockdep will
rightly complain about this.  The API and its users do not submit
operations in hard-irq context.

> +
> +static void talitos_release_xor(struct device *dev, struct talitos_d=
esc *hwdesc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *c=
ontext, int error)
> +{
> + =A0 =A0 =A0 struct talitos_xor_desc *desc =3D context;
> + =A0 =A0 =A0 struct talitos_xor_chan *xor_chan;
> + =A0 =A0 =A0 dma_async_tx_callback callback;
> + =A0 =A0 =A0 void *callback_param;
> +
> + =A0 =A0 =A0 if (unlikely(error)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "xor operation: talitos er=
ror %d\n", error);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 xor_chan =3D container_of(desc->async_tx.chan, struct t=
alitos_xor_chan,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 common)=
;
> + =A0 =A0 =A0 spin_lock_bh(&xor_chan->desc_lock);
> + =A0 =A0 =A0 if (xor_chan->completed_cookie < desc->async_tx.cookie)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xor_chan->completed_cookie =3D desc->as=
ync_tx.cookie;
> +
> + =A0 =A0 =A0 callback =3D desc->async_tx.callback;
> + =A0 =A0 =A0 callback_param =3D desc->async_tx.callback_param;
> +
> + =A0 =A0 =A0 if (callback) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_bh(&xor_chan->desc_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 callback(callback_param);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_bh(&xor_chan->desc_lock);
> + =A0 =A0 =A0 }

You do not need to unlock to call the callback.  Users of the API
assume that they are called in bh context and that they are not
allowed to submit new operations directly from the callback (this
simplifies the descriptor cleanup routines in other drivers).

> +
> + =A0 =A0 =A0 list_del(&desc->node);
> + =A0 =A0 =A0 list_add_tail(&desc->node, &xor_chan->free_desc);
> + =A0 =A0 =A0 spin_unlock_bh(&xor_chan->desc_lock);
> + =A0 =A0 =A0 if (!list_empty(&xor_chan->pending_q))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 talitos_process_pending(xor_chan);
> +}

It appears this routine is missing a call to dma_run_dependencies()?
This is needed if another channel is handling memory copy offload.  I
assume this is the case due to your other patch to fsldma.  See
iop_adma_run_tx_complete_actions().  If this xor resource can also
handle copy operations that would be more efficient as it eliminates
channel switching.  See the ioatdma driver and its use of
ASYNC_TX_DISABLE_CHANNEL_SWITCH.

> +static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dma_chan *chan, =
dma_addr_t dest, dma_addr_t *src,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int src_cnt, s=
ize_t len, unsigned long flags)
> +{
> + =A0 =A0 =A0 struct talitos_xor_chan *xor_chan;
> + =A0 =A0 =A0 struct talitos_xor_desc *new;
> + =A0 =A0 =A0 struct talitos_desc *desc;
> + =A0 =A0 =A0 int i, j;
> +
> + =A0 =A0 =A0 BUG_ON(unlikely(len > TALITOS_MAX_DATA_LEN));
> +
> + =A0 =A0 =A0 xor_chan =3D container_of(chan, struct talitos_xor_chan=
, common);
> +
> + =A0 =A0 =A0 spin_lock_bh(&xor_chan->desc_lock);
> + =A0 =A0 =A0 if (!list_empty(&xor_chan->free_desc)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D container_of(xor_chan->free_des=
c.next,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct talitos_xor_desc, node);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&new->node);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D talitos_xor_alloc_descriptor(xo=
r_chan, GFP_KERNEL);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_bh(&xor_chan->desc_lock);
> +
> + =A0 =A0 =A0 if (!new) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(xor_chan->common.device->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "No free memory for XOR=
 DMA descriptor\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 dma_async_tx_descriptor_init(&new->async_tx, &xor_chan-=
>common);
> +
> + =A0 =A0 =A0 INIT_LIST_HEAD(&new->node);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&new->tx_list);

You can save some overhead in the fast path by moving this
initialization to talitos_xor_alloc_descriptor.

> +
> + =A0 =A0 =A0 desc =3D &new->hwdesc;
> + =A0 =A0 =A0 /* Set destination: Last pointer pair */
> + =A0 =A0 =A0 to_talitos_ptr(&desc->ptr[6], dest);
> + =A0 =A0 =A0 desc->ptr[6].len =3D cpu_to_be16(len);
> + =A0 =A0 =A0 desc->ptr[6].j_extent =3D 0;
> +
> + =A0 =A0 =A0 /* Set Sources: End loading from second-last pointer pa=
ir */
> + =A0 =A0 =A0 for (i =3D 5, j =3D 0; (j < src_cnt) && (i > 0); i--, j=
++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_talitos_ptr(&desc->ptr[i], src[j]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->ptr[i].len =3D cpu_to_be16(len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->ptr[i].j_extent =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* documentation states first 0 ptr/len combo marks e=
nd of sources
> + =A0 =A0 =A0 =A0* yet device produces scatter boundary error unless =
all subsequent
> + =A0 =A0 =A0 =A0* sources are zeroed out
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 for (; i >=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_talitos_ptr(&desc->ptr[i], 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->ptr[i].len =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->ptr[i].j_extent =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 desc->hdr =3D DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_=
XOR
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | DESC_HDR_TYPE_RAID_XOR;
> +
> + =A0 =A0 =A0 new->async_tx.parent =3D NULL;
> + =A0 =A0 =A0 new->async_tx.next =3D NULL;

These fields are managed by the async_tx channel switch code.  No need
to manage it here.

> + =A0 =A0 =A0 new->async_tx.cookie =3D 0;

This is set below to -EBUSY, it's redundant to touch it here.

> + =A0 =A0 =A0 async_tx_ack(&new->async_tx);

This makes it impossible to attach a dependency to this operation.
Not sure this is what you want.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
