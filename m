From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Tue, 30 Jan 2018 15:04:31 +0100
Message-ID: <7126458.a7BSgrabqH@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com> <11410454.xUfCo2NHDh@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Harsh Jain <harsh@chelsio.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59044 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbeA3OGB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 09:06:01 -0500
In-Reply-To: <11410454.xUfCo2NHDh@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 30. Januar 2018, 09:27:04 CET schrieb Stephan Müller:

Hi,

> +/**
> + * af_alg_put_iv - release lock on IV in case CTX IV is used
> + *
> + * @sk [in] AF_ALG socket
> + */
> +void af_alg_put_iv(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct af_alg_ctx *ctx = ask->private;
> +
> +	if (!ctx->iiv || !ctx->ivlen)
> +		mutex_unlock(&ctx->ivlock);
> +}
> +EXPORT_SYMBOL_GPL(af_alg_put_iv);

Having this function implies that ctx->iiv must be set once at the beginning 
and cannot be toggled for a CTX thereafter as otherwise the release of the 
mutex is racy. This implies that the inline IV patch needs a slight revision 
to prevent toggling the ctx->iiv value.

I will send a new revision of the inline IV and the lock context IV patch 
covering this issue.

Ciao
Stephan
