From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and
 restoring sahara_ctx
Date: Tue, 2 Feb 2016 11:41:56 -0200
Message-ID: <CAOMZO5BE49yzqpEy3TAGAyY52XR_sq6NtFa6e1fdkDAP9Xt4Ow@mail.gmail.com>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
	<20160125140728.GA8414@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36251 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbcBBNl5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 08:41:57 -0500
Received: by mail-io0-f169.google.com with SMTP id g73so17164579ioe.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 05:41:57 -0800 (PST)
In-Reply-To: <20160125140728.GA8414@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, Jan 25, 2016 at 12:07 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:

> Very good.  Not only is it a waste, it's a gaping security hole
> because modifying the tfm from import will corrupt it.
>
> But this is not enough, you're still copying things like the mutex
> which should not be copied but instead should be reinitialised in
> import.

So import() will look like this?

static int sahara_sha_import(struct ahash_request *req, const void *in)
{
    struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);

    mutex_init(&rctx->mutex);
    memcpy(rctx, in, sizeof(struct sahara_sha_reqctx));

    return 0;
}

Thanks
