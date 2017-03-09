From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] Propagate fallback bit for cbc and ctr
Date: Thu, 9 Mar 2017 18:47:52 +0800
Message-ID: <20170309104752.GG7185@gondor.apana.org.au>
References: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 27, 2017 at 09:38:24AM -0300, Marcelo Henrique Cerri wrote:
> Hi Hebert,
> 
> For v2:
> 
> - fixed the memory leakage in cbc.
> - included crypto/algapi.h in crypto/cbc.c for crypto_requires_off();
> - ERR_CAST instead PTR_ERR in ctr.
> - Also propagated the fallback bit for rfc3686.
> 
> Marcelo Henrique Cerri (2):
>   crypto: cbc - Propagate NEED_FALLBACK bit
>   crypto: ctr - Propagate NEED_FALLBACK bit
> 
>  crypto/cbc.c | 15 +++++++++++++--
>  crypto/ctr.c | 23 ++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
