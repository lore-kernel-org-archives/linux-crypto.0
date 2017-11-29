From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Write in sha3_update
Date: Tue, 28 Nov 2017 17:53:47 -0800
Message-ID: <20171129015347.GA24001@zzz.localdomain>
References: <001a113a788209b77e055f0aebaf@google.com>
 <20171128205845.GF45321@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+6f724d52da8e3ff8872545bd8444f50f0d174c5f@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171128205845.GF45321@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 12:58:45PM -0800, Eric Biggers wrote:
> diff --git a/crypto/hmac.c b/crypto/hmac.c
> index 92871dc2a63e..82436db6b6a6 100644
> --- a/crypto/hmac.c
> +++ b/crypto/hmac.c
> @@ -196,6 +196,11 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	if (IS_ERR(salg))
>  		return PTR_ERR(salg);
>  
> +	/* The underlying hash algorithm must be unkeyed */
> +	err = -EINVAL;
> +	if (crypto_shash_alg_has_setkey(salg))
> +		goto out_put_alg;
> +
>  	err = -EINVAL;
>  	ds = salg->digestsize;
>  	ss = salg->statesize;

I messed this up; it needs to initialize 'alg' first.  I'll send a fixed
version.

Eric
