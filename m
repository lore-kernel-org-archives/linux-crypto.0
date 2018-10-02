From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v6 03/23] zinc: ChaCha20 generic C
 implementation and selftest
Date: Tue, 2 Oct 2018 11:15:42 +0800
Message-ID: <20181002031542.dbxu44gvqrughlgw@gondor.apana.org.au>
References: <20180925145622.29959-4-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Jason@zx2c4.com, sneves@dei.uc.pt,
        luto@kernel.org, jeanphilippe.aumasson@gmail.com
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-4-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This implements the ChaCha20 permutation as a single C statement, by way
> of the comma operator, which the compiler is able to simplify
> terrifically.
> 
> Information: https://cr.yp.to/chacha.html
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Samuel Neves <sneves@dei.uc.pt>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>

I don't have any problems with this interface.

However, I'm very unhappy about the fact that this adds another
copy of the chacha20 implementation to the kernel.  Either this
is better than the one that we already have or it isn't.

So if it's better please replace the existing chacha20 C
implementation with this or otherwise just adapt the existing
implementation to this interface.

If we're replacing the existing one then you can either replace
it directly within this patch or in a subsequent patch but please
do it in the same series because otherwise we could wind up with
two implementations for years to come.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
