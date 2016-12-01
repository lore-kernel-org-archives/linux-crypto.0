From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: set error code when kcalloc fails
Date: Thu, 1 Dec 2016 21:21:56 +0800
Message-ID: <20161201132155.GE2249@gondor.apana.org.au>
References: <1480557883-18844-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480557883-18844-1-git-send-email-bianpan2016@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 01, 2016 at 10:04:43AM +0800, Pan Bian wrote:
> Fix bug https://bugzilla.kernel.org/show_bug.cgi?id=188521. In function
> skcipher_recvmsg_async(), variable err takes the return value, and its
> value should be negative on failures. Because variable err may be
> reassigned and checked before calling kcalloc(), its value may be 0
> (indicates no error) even if kcalloc() fails. This patch fixes the bug
> by explicitly assigning -ENOMEM to err when kcalloc() returns a NULL
> pointer.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
