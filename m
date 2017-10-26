From: Lars Persson <lars.persson@axis.com>
Subject: Re: [PATCH] drivers/crypto: Convert timers to use timer_setup()
Date: Thu, 26 Oct 2017 16:24:16 +0200
Message-ID: <4621befa-e5f5-182f-e72a-5f3277d4675f@axis.com>
References: <20171025101842.GA145495@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Nilsson <jespern@axis.com>, Lars Persson <larper@axis.com>,
        "Niklas Cassel" <niklass@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamie Iles" <jamie@jamieiles.com>, <linux-arm-kernel@axis.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025101842.GA145495@beast>
Content-Language: sv
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/25/2017 12:18 PM, Kees Cook wrote:
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

For drivers/crypto/axis:
Acked-by: Lars Persson <lars.persson@axis.com>

Thanks,
  Lars
