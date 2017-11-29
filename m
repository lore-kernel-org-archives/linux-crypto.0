From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 12:05:13 +0100
Message-ID: <2034920.efhAd224kL@positron.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <2865588.MNjhcg78tp@tauon.chronox.de> <20171129071049.GA23023@gondor.apana.org.au>
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
In-Reply-To: <20171129071049.GA23023@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 29. November 2017, 08:10:49 CET schrieb Herbert Xu:

Hi Herbert,

> 
> It sort of worked for skcipher because it didn't care if ctx->enc
> or even ctx->iv changed midstream.  But even there I don't think
> we need to wait a second time.  In fact waiting a second time could
> result in a dead-lock if no sendmsg call came around.

Shouldn't we then create a patch for the pre-4.14 algif_skcipher code that 
moves the wait out of the while loop to the beginning of the function in 
recvmsg?

Ciao
Stephan
