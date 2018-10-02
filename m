From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 11:39:08 +0800
Message-ID: <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jason@zx2c4.com, ebiggers@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 28 September 2018 at 07:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
>> If an implementation enters Zinc, it will go through my tree. If it
>> enters the crypto API, it will go through Herbert's tree. If there
>> wind up being messy tree dependency and merge timing issues, I can
>> work this out in the usual way with Herbert. I'll be sure to discuss
>> these edge cases with him when we discuss. I think there's a way to
>> handle that with minimum friction.
> 
> I would also strongly prefer that all crypto work is taken through
> Herbert's tree, so we have a coherent view of it before it goes
> upstream.

I agree.  I don't have any problems with the zinc code living in
its own git tree.  But any upstream merges should definitely go
through the crypto tree because the inherent ties between the two
code-base.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
