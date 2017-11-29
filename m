From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Wed, 29 Nov 2017 21:42:30 +1100
Message-ID: <20171129104230.GA24369@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <1970731.rxTGvFCgCz@positron.chronox.de>
 <20171129102234.GA24171@gondor.apana.org.au>
 <2780580.3j7i2QamZF@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40932 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbdK2KnO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 05:43:14 -0500
Content-Disposition: inline
In-Reply-To: <2780580.3j7i2QamZF@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 11:28:43AM +0100, Stephan Mueller wrote:
> Am Mittwoch, 29. November 2017, 11:22:34 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Nov 29, 2017 at 11:17:26AM +0100, Stephan Müller wrote:
> > > @@ -111,6 +111,12 @@ static int _aead_recvmsg(struct socket *sock, struct
> > > msghdr *msg,> 
> > >  	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
> > >  	size_t processed = 0;		/* [in]  TX bufs to be consumed */
> > > 
> > > +	if (ctx->more) {
> > > +		err = af_alg_wait_for_data(sk, flags);
> > > +		if (err)
> > > +			return err;
> > > +	}
> > 
> > So what happens when sendmsg hasn't been called at all? In that
> > case ctx->more would be zero, and we would skip the wait right?
> 
> Right, but wouldn't that be the correct order of operation? If somebody does 
> not call sendmsg, he simply did not send any data. And that is yet a proper 
> operation (for encryption) as it obtains the tag for the "null" data.

Well no.  Up until now we have supported (although to a limited
extent) having two threads do recvmsg/sendmsg in parallel.  So
if the first thread executed recvmsg it should wait until the
second thread executes sendmsg.

Obviously this support is not complete as we have seen with ctx->enc
overwrites but we shouldn't break what used to work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
