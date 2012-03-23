From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: ux500: Add driver for CRYP hardware.
Date: Thu, 22 Mar 2012 19:03:45 -0500
Message-ID: <20120322190345.a357060e6ae9da7f7a10eb1b@freescale.com>
References: <1331714748-25136-1-git-send-email-andreas.westin@stericsson.com>
	<1331714748-25136-2-git-send-email-andreas.westin@stericsson.com>
	<20120320193510.d979777aca3d1af0b6ac12dd@freescale.com>
	<4F6AE6B9.5030907@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andreas WESTIN <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:45108
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757611Ab2CWAFa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2012 20:05:30 -0400
In-Reply-To: <4F6AE6B9.5030907@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 22 Mar 2012 09:45:45 +0100
Andreas WESTIN <andreas.westin@stericsson.com> wrote:

> Hi Kim,

Hi Andreas,

> >> +int cryp_configure_key_values(struct cryp_device_data *device_data,
> >> +                           enum cryp_key_reg_index key_reg_index,
> >> +                           struct cryp_key_value key_value)
> >> +{
> >> +     while (cryp_is_logic_busy(device_data))
> >> +             cpu_relax();
> >> +
> >> +     switch (key_reg_index) {
> >> +     case CRYP_KEY_REG_1:
> >> +             writel_relaxed(key_value.key_value_left,
> >> +&device_data->base->key_1_l);
> >
> > alignment issues, presumably after a s/writel/writel_relaxed/g
> > during development (should make it easy to re-check all occurrences).
> 
> I'm not sure I follow, could you explain what you mean ?

make

writel_relaxed(key_value.key_value_left,
        &device_data->base->key_1_l);

read like

writel_relaxed(key_value.key_value_left,
               &device_data->base->key_1_l);

first with tabs then modulo tabsize spaces to align the & under the
k in key_value.

> >> +static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> >> +{
> >> +     struct cryp_ctx *ctx = crypto_tfm_ctx(tfm);
> >> +
> >> +     pr_debug(DEV_DBG_NAME " [%s]", __func__);
> >> +
> >> +     ctx->blocksize = crypto_tfm_alg_blocksize(tfm);
> >> +
> >> +     ctx->config.algodir = CRYP_ALGORITHM_ENCRYPT;
> >> +     ctx->config.algomode = CRYP_ALGO_AES_ECB;
> >> +
> >> +     ctx->indata = in;
> >> +     ctx->outdata = out;
> >> +     ctx->datalen = ctx->blocksize;
> >> +
> >> +     if (cryp_hw_calculate(ctx))
> >> +             pr_err("ux500_cryp:crypX: [%s]: cryp_hw_calculate() failed!",
> >> +                             __func__);
> >
> > shouldn't this error be propagated to the higher level API?
> 
> Yes possibly, can this be done via crypto_tfm ?

not sure - this driver is registering
CRYPTO_ALG_TYPE_CIPHER / .cia_encrypt which doesn't have an error
path vs. blkcipher (and ablkcipher) methods.  Since this h/w can
err, maybe the driver should then register blkcipher/ablkcipher
methods instead and simply return error status to its encrypt()
caller.

Kim
