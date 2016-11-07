From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Mon, 7 Nov 2016 12:40:41 -0800
Message-ID: <20161107204041.GC34388@google.com>
References: <20161107191253.17998-1-Jason@zx2c4.com>
 <20161107194709.20457-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161107194709.20457-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 07, 2016 at 08:47:09PM +0100, Jason A. Donenfeld wrote:
> By using the unaligned access helpers, we drastically improve
> performance on small MIPS routers that have to go through the exception
> fix-up handler for these unaligned accesses.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

Reviewed-by: Eric Biggers <ebiggers@google.com>

Nit: the subject line is a little unclear about what was changed.
"make generic C faster on chips with slow unaligned access" would be better.
