From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/18] crypto: talitos - fixes and performance improvement
Date: Thu, 12 Oct 2017 23:19:59 +0800
Message-ID: <20171012151959.GI31122@gondor.apana.org.au>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37368 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdJLPUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 11:20:25 -0400
Content-Disposition: inline
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 06, 2017 at 03:04:31PM +0200, Christophe Leroy wrote:
> This serie fixes and improves the talitos crypto driver.
> 
> First 6 patchs are fixes of failures reported by the new tests in the
> kernel crypto test manager.
> 
> The 8 following patches are cleanups and simplifications.
> 
> The last 4 ones are performance improvement. The main improvement is
> in the one before the last, it divides by 2 the time needed for a md5
> hash on the SEC1.
> 
> Christophe Leroy (18):
>   crypto: talitos - fix AEAD test failures
>   crypto: talitos - fix memory corruption on SEC2
>   crypto: talitos - fix setkey to check key weakness
>   crypto: talitos - fix AEAD for sha224 on non sha224 capable chips
>   crypto: talitos - fix use of sg_link_tbl_len
>   crypto: talitos - fix ctr-aes-talitos
>   crypto: talitos - zeroize the descriptor with memset()
>   crypto: talitos - declare local functions static
>   crypto: talitos - use devm_kmalloc()
>   crypto: talitos - use of_property_read_u32()
>   crypto: talitos - use devm_ioremap()
>   crypto: talitos - don't check the number of channels at each interrupt
>   crypto: talitos - remove to_talitos_ptr_len()
>   crypto: talitos - simplify tests in ipsec_esp()
>   crypto: talitos - DMA map key in setkey()
>   crypto: talitos - do hw_context DMA mapping outside the requests
>   crypto: talitos - chain in buffered data for ahash on SEC1
>   crypto: talitos - avoid useless copy

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
