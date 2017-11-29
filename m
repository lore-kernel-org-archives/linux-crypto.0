From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Wed, 29 Nov 2017 11:28:43 +0100
Message-ID: <2780580.3j7i2QamZF@tauon.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <1970731.rxTGvFCgCz@positron.chronox.de> <20171129102234.GA24171@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129102234.GA24171@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 29. November 2017, 11:22:34 CET schrieb Herbert Xu:

Hi Herbert,

> On Wed, Nov 29, 2017 at 11:17:26AM +0100, Stephan Müller wrote:
> > @@ -111,6 +111,12 @@ static int _aead_recvmsg(struct socket *sock, struct
> > msghdr *msg,> 
> >  	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
> >  	size_t processed = 0;		/* [in]  TX bufs to be consumed */
> > 
> > +	if (ctx->more) {
> > +		err = af_alg_wait_for_data(sk, flags);
> > +		if (err)
> > +			return err;
> > +	}
> 
> So what happens when sendmsg hasn't been called at all? In that
> case ctx->more would be zero, and we would skip the wait right?

Right, but wouldn't that be the correct order of operation? If somebody does 
not call sendmsg, he simply did not send any data. And that is yet a proper 
operation (for encryption) as it obtains the tag for the "null" data.

In case we have decryption and yet we received "null" data (e.g. sendmsg was 
not called) which implies the kernel received too little data (decryption at 
least requires the tag), aead_sufficient_data will return the error.

Ciao
Stephan
