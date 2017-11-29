From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 07:48:53 +0100
Message-ID: <2865588.MNjhcg78tp@tauon.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <1943686.EAKghbSqDq@positron.chronox.de> <20171128230240.GA17611@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128230240.GA17611@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 29. November 2017, 00:02:40 CET schrieb Herbert Xu:

Hi Herbert,

> > --- a/crypto/algif_aead.c
> > +++ b/crypto/algif_aead.c
> > @@ -110,6 +110,7 @@ static int _aead_recvmsg(struct socket *sock, struct
> > msghdr *msg,> 
> >  	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
> >  	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
> >  	size_t processed = 0;		/* [in]  TX bufs to be consumed */
> > 
> > +	bool enc = ctx->enc;		/* prevent race if sock lock dropped */
> 
> This is wrong.  You can't fetch ctx->enc before you wait.  It has
> to be done after the wait as otherwise ctx->enc may not even have
> been initialised.

All ctx variables are initialized in aead_accept_parent_nokey. Thus, if no 
sendmsg call is invoked by user space, at least a valid operation is 
performed.
> 
> In fact the position of the wait call is just wrong.  You should only
> ever do at most one wait at the start of the recvmsg call.  Once you
> have enough data from that wait no further waits should be done for
> that recvmsg call.  The original commit had it right with just one
> wait at the start of recvmsg (400c40cf78da).

I am wondering about the wait call inside the while () in af_alg_get_rsgl: 
this has been taken from algif_skcipher. It would seem that moving the wait 
call to the beginning of the recvmsg call would be applicable to skcipher as 
well. I.e. the wait call should be removed from af_alg_get_rsgl entirely and 
placed at the beginning the recvmsg function in both, the aead and skcipher 
code paths.
> 
> Fetching of ctx state should be performed after this wait.
> 
> Cheers,



Ciao
Stephan
