From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH 5/5] crypto: Add LZO compression support to the crypto interface
Date: Fri, 4 May 2007 13:39:20 +0530
Message-ID: <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
References: <1178030843.5883.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	"David Woodhouse" <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: "Richard Purdie" <rpurdie@openedhand.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:12875 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767709AbXEDIJV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2007 04:09:21 -0400
Received: by wr-out-0506.google.com with SMTP id 76so817802wra
        for <linux-crypto@vger.kernel.org>; Fri, 04 May 2007 01:09:21 -0700 (PDT)
In-Reply-To: <1178030843.5883.57.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> +static int lzo_init(struct crypto_tfm *tfm)
> +{
> +       struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +       ctx->lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> +
> +       if (!ctx->lzo_mem) {
> +               vfree(ctx->lzo_mem);

Heh. What's (why's) this? You _can_ {k, v}free NULL but doing so after
explicitly checking for it is ... ... insane!

> +               return -ENOMEM;

Yeah. Just return -ENOMEM; and be done with it.
