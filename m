From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: skcipher: remove static declaration of export
 function
Date: Mon, 18 Jun 2018 10:28:03 -0700
Message-ID: <20180618172803.GA8022@gmail.com>
References: <20180617174959.29864-1-efremov@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
To: efremov@linux.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180617174959.29864-1-efremov@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 17, 2018 at 08:49:59PM +0300, efremov@linux.com wrote:
> The function skcipher_walk_next declared as static and marked as
> EXPORT_SYMBOL. It's a bit confusing since export symbol means that
> we want others to use this function. The area of visibility for such
> function is its .c file and all other modules. Other *.c files of the
> same module can't use it, despite all other modules can. Relying on
> that such behavior was not the original intention, the patch just
> removes the static keyword.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Why not remove the EXPORT_SYMBOL instead?  It has no users outside the file.

- Eric
