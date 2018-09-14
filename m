From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/aegis,morus - Do not require OSXSAVE for SSE2
Date: Fri, 14 Sep 2018 14:11:43 +0800
Message-ID: <20180914061143.e6ljdil6mdx3dn7v@gondor.apana.org.au>
References: <20180905072641.13677-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Zdenek Kaspar <zkaspar82@gmail.com>,
        stable@vger.kernel.org
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905072641.13677-1-omosnace@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 05, 2018 at 09:26:41AM +0200, Ondrej Mosnacek wrote:
> It turns out OSXSAVE needs to be checked only for AVX, not for SSE.
> Without this patch the affected modules refuse to load on CPUs with SSE2
> but without AVX support.
> 
> Fixes: 877ccce7cbe8 ("crypto: x86/aegis,morus - Fix and simplify CPUID checks")
> Cc: <stable@vger.kernel.org> # 4.18
> Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
