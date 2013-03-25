From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH -next] crypto: ux500 - fix error return code in hash_dma_final()
Date: Mon, 25 Mar 2013 16:15:36 +0100
Message-ID: <CACRpkdZYwGhXqZpmu5FovAo=_C6U97_3tcOw3hXJ0sw9gRx2CA@mail.gmail.com>
References: <CAPgLHd94xmvDhOm7xFAV0Ef2O4DFST+npQYN7sfRKVL+y+Msdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: herbert@gondor.apana.org.au, andreas.westin@stericsson.com,
	arnd@arndb.de, rubini@unipv.it, yongjun_wei@trendmicro.com.cn,
	linux-crypto@vger.kernel.org,
	Rikard OLSSON <rikard.p.olsson@stericsson.com>,
	magnus.p.persson@stericsson.com
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ia0-f177.google.com ([209.85.210.177]:52748 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3CYPPg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Mar 2013 11:15:36 -0400
Received: by mail-ia0-f177.google.com with SMTP id w33so2491884iag.22
        for <linux-crypto@vger.kernel.org>; Mon, 25 Mar 2013 08:15:36 -0700 (PDT)
In-Reply-To: <CAPgLHd94xmvDhOm7xFAV0Ef2O4DFST+npQYN7sfRKVL+y+Msdw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 22, 2013 at 2:18 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
