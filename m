From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Wed, 13 Jun 2018 14:30:31 +0800
Message-ID: <20180613063030.bsrq3xmufcw4zi52@gondor.apana.org.au>
References: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>, hadar.gat@arm.com,
        Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 07, 2018 at 12:02:04PM +0300, Gilad Ben-Yossef wrote:
>
> I'd be really happy to get a review on this patch - not so much what
> it is doing but
> rather the rational behind it - how is a tfm provider supposed to
> handle copying the
> last block of ciphertext into the request structure if the ciphertext
> size is less than a
> block?

Which algorithm is this? In general we disallow requests which
are not a multiple of a block for block ciphers.  Obviously this
doesn't apply to stream ciphers such as ctr(aes), but in that case
it doesn't really matter as you cannot chain such a request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
