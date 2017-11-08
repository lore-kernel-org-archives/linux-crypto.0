From: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH RESEND 4/4] dma: caam: add dma memcpy driver
Date: Wed, 8 Nov 2017 14:36:31 +0000
Message-ID: <VI1PR04MB1325358D7898120FC0BCEBE88A560@VI1PR04MB1325.eurprd04.prod.outlook.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-5-horia.geanta@nxp.com>
 <20171031120423.GS3187@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tudor Ambarus <tudor-dan.ambarus-3arQi8VN3Tc@public.gmane.org>,
        Rajiv Vishwakarma <rajiv.vishwakarma-3arQi8VN3Tc@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 10/31/2017 2:01 PM, Vinod Koul wrote:=0A=
> On Mon, Oct 30, 2017 at 03:46:54PM +0200, Horia Geant=E3 wrote:=0A=
> =0A=
>> @@ -600,6 +600,23 @@ config ZX_DMA=0A=
>>   	help=0A=
>>   	  Support the DMA engine for ZTE ZX family platform devices.=0A=
>>   =0A=
>> +config CRYPTO_DEV_FSL_CAAM_DMA=0A=
> =0A=
> File is sorted alphabetically=0A=
> =0A=
=0A=
I didn't know. I will change the position in file.=0A=
=0A=
>> +	tristate "CAAM DMA engine support"=0A=
>> +	depends on CRYPTO_DEV_FSL_CAAM_JR=0A=
>> +	default y=0A=
> =0A=
> why should it be default?=0A=
> =0A=
=0A=
My mistake. It remained to 'y' from testing. I will change it to 'n'.=0A=
=0A=
>> --- /dev/null=0A=
>> +++ b/drivers/dma/caam_dma.c=0A=
>> @@ -0,0 +1,444 @@=0A=
>> +/*=0A=
>> + * caam support for SG DMA=0A=
>> + *=0A=
>> + * Copyright 2016 Freescale Semiconductor, Inc=0A=
>> + * Copyright 2017 NXP=0A=
>> + */=0A=
> =0A=
> that is interesting, no license text?=0A=
> =0A=
=0A=
Thanks for the catch. The next patch will contain the full license text.=0A=
=0A=
>> +=0A=
>> +#include <linux/module.h>=0A=
>> +#include <linux/platform_device.h>=0A=
>> +#include <linux/dma-mapping.h>=0A=
>> +#include <linux/interrupt.h>=0A=
> =0A=
> why do you need this=0A=
> =0A=
=0A=
I don't. I thought I removed any not-needed header files. I will remove it.=
=0A=
=0A=
>> +#include <linux/slab.h>=0A=
>> +#include <linux/debugfs.h>=0A=
> =0A=
> i didn't see any debugfs code, why do you need this=0A=
> =0A=
=0A=
I don't. I will remove it.=0A=
=0A=
> alphabetical sort pls=0A=
=0A=
It will be done.=0A=
=0A=
>> +=0A=
>> +#include <linux/dmaengine.h>=0A=
>> +#include "dmaengine.h"=0A=
>> +=0A=
>> +#include "../crypto/caam/regs.h"=0A=
>> +#include "../crypto/caam/jr.h"=0A=
>> +#include "../crypto/caam/error.h"=0A=
>> +#include "../crypto/caam/intern.h"=0A=
>> +#include "../crypto/caam/desc_constr.h"=0A=
> =0A=
> ah that puts very hard assumptions on locations of the subsystems. Please=
 do=0A=
> not do that and move the required stuff into common header location in=0A=
> include/=0A=
> =0A=
=0A=
Unfortunately this is not possible. The functionality used by CAAM DMA =0A=
from the CAAM subsystem should not be exported to be used by other =0A=
modules. It is because this driver is so tightly coupled with the CAAM =0A=
driver(s) that it needs access to it's 'internal' functionality (that =0A=
should not be otherwise shared with anyone).=0A=
=0A=
>> +/* This is max chunk size of a DMA transfer. If a buffer is larger than=
 this=0A=
>> + * value it is internally broken into chunks of max CAAM_DMA_CHUNK_SIZE=
 bytes=0A=
>> + * and for each chunk a DMA transfer request is issued.=0A=
>> + * This value is the largest number on 16 bits that is a multiple of 25=
6 bytes=0A=
>> + * (the largest configurable CAAM DMA burst size).=0A=
>> + */=0A=
> =0A=
> Kernel comments style we follow is:=0A=
> =0A=
> /*=0A=
>   * this is for=0A=
>   * multi line comment=0A=
>   */=0A=
> =0A=
> Pls fix this in the file=0A=
> =0A=
=0A=
It will be done.=0A=
=0A=
>> +#define CAAM_DMA_CHUNK_SIZE	65280=0A=
>> +=0A=
>> +struct caam_dma_sh_desc {=0A=
> =0A=
> sh?=0A=
> =0A=
=0A=
It means "shared". It is obvious to anyone who is familiar with the CAAM =
=0A=
system.=0A=
=0A=
>> +struct caam_dma_ctx {=0A=
>> +	struct dma_chan chan;=0A=
>> +	struct list_head node;=0A=
>> +	struct device *jrdev;=0A=
>> +	struct list_head submit_q;=0A=
> =0A=
> call it pending=0A=
> =0A=
=0A=
It will be done.=0A=
=0A=
>> +static struct dma_device *dma_dev;=0A=
>> +static struct caam_dma_sh_desc *dma_sh_desc;=0A=
>> +static LIST_HEAD(dma_ctx_list);=0A=
> =0A=
> why do you need so many globals?=0A=
> =0A=
=0A=
How many globals are too many? I can group them in a common structure. =0A=
But I'm not sure how would that help.=0A=
=0A=
>> +static dma_cookie_t caam_dma_tx_submit(struct dma_async_tx_descriptor *=
tx)=0A=
>> +{=0A=
>> +	struct caam_dma_edesc *edesc =3D NULL;=0A=
>> +	struct caam_dma_ctx *ctx =3D NULL;=0A=
>> +	dma_cookie_t cookie;=0A=
>> +=0A=
>> +	edesc =3D container_of(tx, struct caam_dma_edesc, async_tx);=0A=
>> +	ctx =3D container_of(tx->chan, struct caam_dma_ctx, chan);=0A=
>> +=0A=
>> +	spin_lock_bh(&ctx->edesc_lock);=0A=
> =0A=
> why _bh, i didnt see any irqs or tasklets here which is actually odd, so=
=0A=
> what is going on=0A=
> =0A=
=0A=
The tasklet is hidden inside the JR driver from the CAAM subsystem (see =0A=
drivers/crypto/caam/jr.c). The function caam_dma_done(), which is called =
=0A=
from the JR tasklet handler, also uses the spin_lock. I need to disable =0A=
bottom half to make sure that I don't run into a deadlock when I'm =0A=
preempted.=0A=
=0A=
>> +=0A=
>> +	cookie =3D dma_cookie_assign(tx);=0A=
>> +	list_add_tail(&edesc->node, &ctx->submit_q);=0A=
>> +=0A=
>> +	spin_unlock_bh(&ctx->edesc_lock);=0A=
>> +=0A=
>> +	return cookie;=0A=
>> +}=0A=
> =0A=
> we have a virtual channel wrapper where we do the same stuff as above, so=
=0A=
> consider reusing that=0A=
> =0A=
=0A=
Some of the functionality that the virtual channel might provide cannot =0A=
be extracted because it is embedded into the JR driver (e.g. the =0A=
tasklet). Therefore the use of the virtual channel is inefficient at =0A=
best if not even impossible.=0A=
=0A=
>> +static void caam_dma_memcpy_init_job_desc(struct caam_dma_edesc *edesc)=
=0A=
>> +{=0A=
>> +	u32 *jd =3D edesc->jd;=0A=
>> +	u32 *sh_desc =3D dma_sh_desc->desc;=0A=
>> +	dma_addr_t desc_dma =3D dma_sh_desc->desc_dma;=0A=
>> +=0A=
>> +	/* init the job descriptor */=0A=
>> +	init_job_desc_shared(jd, desc_dma, desc_len(sh_desc), HDR_REVERSE);=0A=
>> +=0A=
>> +	/* set SEQIN PTR */=0A=
>> +	append_seq_in_ptr(jd, edesc->src_dma, edesc->src_len, 0);=0A=
>> +=0A=
>> +	/* set SEQOUT PTR */=0A=
>> +	append_seq_out_ptr(jd, edesc->dst_dma, edesc->dst_len, 0);=0A=
>> +=0A=
>> +#ifdef DEBUG=0A=
>> +	print_hex_dump(KERN_ERR, "caam dma desc@" __stringify(__LINE__) ": ",=
=0A=
>> +		       DUMP_PREFIX_ADDRESS, 16, 4, jd, desc_bytes(jd), 1);=0A=
> =0A=
> ah this make you compile kernel. Consider the dynamic printk helpers for=
=0A=
> printing=0A=
> =0A=
=0A=
It will be done.=0A=
=0A=
>> +/* This function can be called in an interrupt context */=0A=
>> +static void caam_dma_issue_pending(struct dma_chan *chan)=0A=
>> +{=0A=
>> +	struct caam_dma_ctx *ctx =3D container_of(chan, struct caam_dma_ctx,=
=0A=
>> +						chan);=0A=
>> +	struct caam_dma_edesc *edesc, *_edesc;=0A=
>> +=0A=
>> +	spin_lock_bh(&ctx->edesc_lock);=0A=
>> +	list_for_each_entry_safe(edesc, _edesc, &ctx->submit_q, node) {=0A=
>> +		if (caam_jr_enqueue(ctx->jrdev, edesc->jd,=0A=
>> +				    caam_dma_done, edesc) < 0)=0A=
> =0A=
> what does the caam_jr_enqueue() do?=0A=
> =0A=
=0A=
Enqueues a job descriptor (jd) into a job ring (jr). Additionally the =0A=
"caam_dma_done()" function is registered to be used as a callback when =0A=
the job finishes. For more details see drivers/crypto/caam/jr.c.=0A=
=0A=
>> +static int caam_dma_jr_chan_bind(void)=0A=
>> +{=0A=
>> +	struct device *jrdev;=0A=
>> +	struct caam_dma_ctx *ctx;=0A=
>> +	int bonds =3D 0;=0A=
>> +	int i;=0A=
>> +=0A=
>> +	for (i =3D 0; i < caam_jr_driver_probed(); i++) {=0A=
>> +		jrdev =3D caam_jridx_alloc(i);=0A=
>> +		if (IS_ERR(jrdev)) {=0A=
>> +			pr_err("job ring device %d allocation failed\n", i);=0A=
>> +			continue;=0A=
>> +		}=0A=
>> +=0A=
>> +		ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);=0A=
>> +		if (!ctx) {=0A=
>> +			caam_jr_free(jrdev);=0A=
>> +			continue;=0A=
> =0A=
> you want to continue?=0A=
> =0A=
=0A=
Yes. If on the next loop memory becomes available I would like to =0A=
allocate and use another job ring(jr). If there is no memory still then =0A=
it will do nothing.=0A=
=0A=
>> +	dma_dev->dev =3D dev;=0A=
>> +	dma_dev->residue_granularity =3D DMA_RESIDUE_GRANULARITY_DESCRIPTOR;=
=0A=
>> +	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);=0A=
>> +	dma_cap_set(DMA_PRIVATE, dma_dev->cap_mask);=0A=
>> +	dma_dev->device_tx_status =3D dma_cookie_status;=0A=
>> +	dma_dev->device_issue_pending =3D caam_dma_issue_pending;=0A=
>> +	dma_dev->device_prep_dma_memcpy =3D caam_dma_prep_memcpy;=0A=
>> +	dma_dev->device_free_chan_resources =3D caam_dma_free_chan_resources;=
=0A=
>> +=0A=
>> +	err =3D dma_async_device_register(dma_dev);=0A=
>> +	if (err) {=0A=
>> +		dev_err(dev, "Failed to register CAAM DMA engine\n");=0A=
>> +		goto jr_bind_err;=0A=
>> +	}=0A=
>> +=0A=
>> +	dev_info(dev, "caam dma support with %d job rings\n", bonds);=0A=
> =0A=
> that is very noisy=0A=
> =0A=
=0A=
I want to print a line that informs that the caam_dma driver has been =0A=
successfully probed. Do you have any other suggestion?=0A=
=0A=
>> +MODULE_LICENSE("Dual BSD/GPL");=0A=
>> +MODULE_DESCRIPTION("NXP CAAM support for SG DMA");=0A=
>> +MODULE_AUTHOR("NXP Semiconductors");=0A=
> =0A=
> No MODULE_ALIAS, how did you load the driver=0A=
> =0A=
=0A=
It was built in as default. I will add a MODULE_ALIAS().=0A=
=0A=
Thanks for the remarks.=0A=
Radu=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
