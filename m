From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algapi - convert cra_refcnt to refcount_t
Date: Fri, 5 Jan 2018 22:17:21 +1100
Message-ID: <20180105111721.GC16156@gondor.apana.org.au>
References: <20171229160046.23661-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49994 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbeAELRc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:17:32 -0500
Content-Disposition: inline
In-Reply-To: <20171229160046.23661-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 29, 2017 at 10:00:46AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Reference counters should use refcount_t rather than atomic_t, since the
> refcount_t implementation can prevent overflows, reducing the
> exploitability of reference leak bugs.  crypto_alg.cra_refcount is a
> reference counter with the usual semantics, so switch it over to
> refcount_t.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
