From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Tue, 19 Jun 2018 22:27:13 +0800
Message-ID: <20180619142713.dzipyarpb23a7qne@gondor.apana.org.au>
References: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
 <20180613063030.bsrq3xmufcw4zi52@gondor.apana.org.au>
 <CAOtvUMdtafGwXJFD0Tm1tx1q+TxRsB4nwEKxumE7=--_PMCZrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>, hadar.gat@arm.com,
        Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMdtafGwXJFD0Tm1tx1q+TxRsB4nwEKxumE7=--_PMCZrQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 17, 2018 at 01:06:42PM +0300, Gilad Ben-Yossef wrote:
>
> It was ctr(aes). I wrongly assumed that we are supposed to unconditionally
> copy
> the cipher-text block post operation and let the caller do with it what it
> wants and so the
> code now does that for all cipher operations unconditionally.

For CTR it doesn't matter whether the last block is less than a
block, you should still increment the counter.

> So what is a good description of what we are supposed to provide in that
> field post operation?
> The next IV? but as you stated, that is not necessarily useful for all
> ciphers.

When in doubt, please refer to the generic implementation.  If
that is still unclear or if it seems wrong, please post to the
list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
