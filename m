From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: document correct return value for request
 allocation
Date: Mon, 4 Apr 2016 09:27:22 +0200
Message-ID: <20160404072722.GA856@Red>
References: <1459612496-5094-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459612496-5094-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 02, 2016 at 10:54:56AM -0500, Eric Biggers wrote:
> Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
> ---
>  Documentation/DocBook/crypto-API.tmpl | 6 +++---
>  include/crypto/aead.h                 | 3 +--
>  include/crypto/hash.h                 | 3 +--
>  include/crypto/skcipher.h             | 3 +--
>  include/linux/crypto.h                | 3 +--
>  5 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
> index 348619f..d55dc5a 100644
> --- a/Documentation/DocBook/crypto-API.tmpl
> +++ b/Documentation/DocBook/crypto-API.tmpl
> @@ -1936,9 +1936,9 @@ static int test_skcipher(void)
>  	}
>  
>  	req = skcipher_request_alloc(skcipher, GFP_KERNEL);
> -	if (IS_ERR(req)) {
> -		pr_info("could not allocate request queue\n");
> -		ret = PTR_ERR(req);
> +	if (!req) {
> +		pr_info("could not allocate skcipher request\n");
> +		ret = -ENOMEM;
>  		goto out;
>  	}

Hello

I think pr_err is better than pr_info.

Regards

