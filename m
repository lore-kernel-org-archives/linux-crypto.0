From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Wed, 29 Nov 2017 21:22:34 +1100
Message-ID: <20171129102234.GA24171@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <20171129071049.GA23023@gondor.apana.org.au>
 <2948680.ShXD61QQGe@tauon.chronox.de>
 <1970731.rxTGvFCgCz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1970731.rxTGvFCgCz@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 29, 2017 at 11:17:26AM +0100, Stephan Müller wrote:
>
> @@ -111,6 +111,12 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
>  	size_t processed = 0;		/* [in]  TX bufs to be consumed */
>  
> +	if (ctx->more) {
> +		err = af_alg_wait_for_data(sk, flags);
> +		if (err)
> +			return err;
> +	}

So what happens when sendmsg hasn't been called at all? In that
case ctx->more would be zero, and we would skip the wait right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
