From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Fri, 17 Feb 2017 20:30:35 +0100
Message-ID: <2417522.uQb4Sb1iXM@positron.chronox.de>
References: <1781086.PMKVUsvYzT@positron.chronox.de> <3126581.xcUJNzAaop@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59692 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755721AbdBQTai (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 14:30:38 -0500
In-Reply-To: <3126581.xcUJNzAaop@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. Februar 2017, 22:21:44 CET schrieb Stephan Müller:

Hi,

> +static unsigned int skcipher_count_tsgl(struct sock *sk, size_t bytes)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
>  	struct skcipher_ctx *ctx = ask->private;
> -	struct skcipher_sg_list *sgl;
> +	struct skcipher_tsgl *sgl;
>  	struct scatterlist *sg;
> -	int i;
> +	unsigned int i;
> +	unsigned int sgl_count = 0;
> +
> +	if (!bytes)
> +		return 0;
> +
> +	while (!list_empty(&ctx->tsgl_list)) {

This is wrong, it should be list_for_each_entry_safe(sgl, tmp, &ctx-
>tsgl_list, list) {

I will send a new patch shortly.

Ciao
Stephan
