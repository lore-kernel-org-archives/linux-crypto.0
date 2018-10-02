From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 11:49:25 +0800
Message-ID: <20181002034925.5zbhoiq7yj44dy6d@gondor.apana.org.au>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au>
 <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason:

On Tue, Oct 02, 2018 at 05:45:20AM +0200, Jason A. Donenfeld wrote:
> Hi Herbert,
> 
> > I agree.  I don't have any problems with the zinc code living in
> > its own git tree.  But any upstream merges should definitely go
> > through the crypto tree because the inherent ties between the two
> > code-base.
> 
> I can send you pull requests then if there are development cycles when
> there are in fact relations between the two trees. I'll update the
> commit message describing Zinc to include this.

I think all merges should go through the crypto tree so that the
kernel crypto community has oversight over the crypto implementations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
