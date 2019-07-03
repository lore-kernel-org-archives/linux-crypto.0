Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7312C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8813121852
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCSvy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 14:51:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCSvy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 14:51:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 751483E2B7;
        Wed,  3 Jul 2019 18:51:48 +0000 (UTC)
Received: from redhat.com (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with SMTP id 39A3D3795;
        Wed,  3 Jul 2019 18:51:43 +0000 (UTC)
Date:   Wed, 3 Jul 2019 14:51:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gonglei <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 06/35] crypto: Use kmemdup rather than duplicating its
 implementation
Message-ID: <20190703145109-mutt-send-email-mst@kernel.org>
References: <20190703162708.32137-1-huangfq.daxian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703162708.32137-1-huangfq.daxian@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 03 Jul 2019 18:51:53 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 04, 2019 at 12:27:08AM +0800, Fuqian Huang wrote:
> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

virtio part:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
> Changes in v2:
>   - Fix a typo in commit message (memset -> memcpy)
> 
>  drivers/crypto/caam/caampkc.c              | 11 +++--------
>  drivers/crypto/virtio/virtio_crypto_algs.c |  4 +---
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> index fe24485274e1..a03464b4c019 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -816,7 +816,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  		return ret;
>  
>  	/* Copy key in DMA zone */
> -	rsa_key->e = kzalloc(raw_key.e_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
>  	if (!rsa_key->e)
>  		goto err;
>  
> @@ -838,8 +838,6 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  	rsa_key->e_sz = raw_key.e_sz;
>  	rsa_key->n_sz = raw_key.n_sz;
>  
> -	memcpy(rsa_key->e, raw_key.e, raw_key.e_sz);
> -
>  	return 0;
>  err:
>  	caam_rsa_free_key(rsa_key);
> @@ -920,11 +918,11 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  		return ret;
>  
>  	/* Copy key in DMA zone */
> -	rsa_key->d = kzalloc(raw_key.d_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->d = kmemdup(raw_key.d, raw_key.d_sz, GFP_DMA | GFP_KERNEL);
>  	if (!rsa_key->d)
>  		goto err;
>  
> -	rsa_key->e = kzalloc(raw_key.e_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
>  	if (!rsa_key->e)
>  		goto err;
>  
> @@ -947,9 +945,6 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  	rsa_key->e_sz = raw_key.e_sz;
>  	rsa_key->n_sz = raw_key.n_sz;
>  
> -	memcpy(rsa_key->d, raw_key.d, raw_key.d_sz);
> -	memcpy(rsa_key->e, raw_key.e, raw_key.e_sz);
> -
>  	caam_rsa_set_priv_key_form(ctx, &raw_key);
>  
>  	return 0;
> diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
> index 10f266d462d6..42d19205166b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> @@ -129,13 +129,11 @@ static int virtio_crypto_alg_ablkcipher_init_session(
>  	 * Avoid to do DMA from the stack, switch to using
>  	 * dynamically-allocated for the key
>  	 */
> -	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
> +	uint8_t *cipher_key = kmemdup(key, keylen, GFP_ATOMIC);
>  
>  	if (!cipher_key)
>  		return -ENOMEM;
>  
> -	memcpy(cipher_key, key, keylen);
> -
>  	spin_lock(&vcrypto->ctrl_lock);
>  	/* Pad ctrl header */
>  	vcrypto->ctrl.header.opcode =
> -- 
> 2.11.0
