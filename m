From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH] drivers/crypto: Convert timers to use timer_setup()
Date: Thu, 26 Oct 2017 14:54:29 +0100
Message-ID: <20171026135429.sk3s6ama2na7bvim@ash>
References: <20171025101842.GA145495@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:52872 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdJZNyd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 09:54:33 -0400
Received: by mail-wr0-f194.google.com with SMTP id k62so3232515wrc.9
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 06:54:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171025101842.GA145495@beast>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 25, 2017 at 03:18:42AM -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Cc: Niklas Cassel <niklas.cassel@axis.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: linux-arm-kernel@axis.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks,

Jamie
