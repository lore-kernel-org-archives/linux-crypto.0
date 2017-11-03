From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto: Convert timers to use timer_setup()
Date: Fri, 3 Nov 2017 22:27:41 +0800
Message-ID: <20171103142741.GQ9011@gondor.apana.org.au>
References: <20171025101842.GA145495@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171025101842.GA145495@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
