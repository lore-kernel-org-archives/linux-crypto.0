From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: crypto: ux500: Fix logging, make arrays const, neatening
Date: Tue, 23 Jul 2013 00:35:55 +0200
Message-ID: <CACRpkdaUQaDbtr5rOyob_G5ggSZLUVOWU+TmhL51Jw_c0S+T0A@mail.gmail.com>
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
	<1374003464-32302-1-git-send-email-standby24x7@gmail.com>
	<1374008808.1949.37.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Masanari Iida <standby24x7@gmail.com>,
	Andreas Westin <andreas.westin@stericsson.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46442 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GVWf4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Jul 2013 18:35:56 -0400
Received: by mail-oa0-f51.google.com with SMTP id i4so9782183oah.10
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2013 15:35:55 -0700 (PDT)
In-Reply-To: <1374008808.1949.37.camel@joe-AO722>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:06 PM, Joe Perches <joe@perches.com> wrote:

> Logging messages without newlines are possibly interleaved
> with other messages.  Add terminating newlines to avoid
> this.
>
> Other miscellaneous changes:
>
> Make arrays const to reduce data size
> Add pr_fmt to prefix pr_<level>, remove now unused DEV_DBG_NAME
> Coalesce formats, align arguments
> Remove unnecessary OOM messages as dump_stack is already done
> Remove unnecessary cast of void *
> Change kzalloc(sizeof(struct)...) to kzalloc(sizeof(*var), ...)
> Reduce indents in struct definitions
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> On top of Masanari Iida's patch:
> https://patchwork.kernel.org/patch/2828273/

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Have you tested this on hardware or is it compile-tested only?

Yours,
Linus Walleij
