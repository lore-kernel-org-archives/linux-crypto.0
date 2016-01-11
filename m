From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 2/2] crypto: algif_skcipher - Add key check exception for
 cipher_null
Date: Mon, 11 Jan 2016 15:59:40 +0100
Message-ID: <5693C35C.1090906@gmail.com>
References: <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au> <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au> <568A66B2.4090307@gmail.com>
 <20160108124851.GA5425@gondor.apana.org.au> <568FFE18.6090900@gmail.com>
 <20160109054103.GA11188@gondor.apana.org.au> <5690DD9C.4010408@gmail.com>
 <20160111132650.GA25134@gondor.apana.org.au>
 <20160111132941.GA25260@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160111132941.GA25260@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/11/2016 02:29 PM, Herbert Xu wrote:
> This patch adds an exception to the key check so that cipher_null
> users may continue to use algif_skcipher without setting a key.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 110bab4..4a5bdb6 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -978,7 +978,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
>  {
>  	struct skcipher_tfm *tfm = private;
>  
> -	if (!tfm->has_key)
> +	if (!tfm->has_key && crypto_skcipher_has_setkey(tfm->skcipher))
>  		return -ENOKEY;
>  
>  	return skcipher_accept_parent_common(private, sk);

Reported-and-tested-by: Milan Broz <gmazyland@gmail.com>

Thanks,
Milan
