From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 10:02:40 +1100
Message-ID: <20171128230240.GA17611@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <20171128053738.GA2383@zzz.localdomain>
 <6174444.U6zRo7pOhC@tauon.chronox.de>
 <1943686.EAKghbSqDq@positron.chronox.de>
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
In-Reply-To: <1943686.EAKghbSqDq@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 10:33:09PM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> I verified the correctnes of the patch with Eric's test program.
> Without the patch, the issue is present. With the patch, the kernel
> happily lives ever after.
> 
> Changes v2: change the submission into a proper patch
> 
> Ciao
> Stephan
> 
> ---8<---
> 
> The function af_alg_get_rsgl may sleep to wait for additional data. In
> this case, the socket lock may be dropped. This allows user space to
> change values in the socket data structure. Hence, all variables of the
> context that are needed before and after the af_alg_get_rsgl must be
> copied into a local variable.
> 
> This issue applies to the ctx->enc variable only. Therefore, this
> value is copied into a local variable that is used for all operations
> before and after the potential sleep and lock release. This implies that
> any changes on this variable while the kernel waits for data will only
> be picked up in another recvmsg operation.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

> ---
>  crypto/algif_aead.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 7d2d162666e5..4ba13c0b97ca 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -110,6 +110,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
>  	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
>  	size_t processed = 0;		/* [in]  TX bufs to be consumed */
> +	bool enc = ctx->enc;		/* prevent race if sock lock dropped */

This is wrong.  You can't fetch ctx->enc before you wait.  It has
to be done after the wait as otherwise ctx->enc may not even have
been initialised.

In fact the position of the wait call is just wrong.  You should only
ever do at most one wait at the start of the recvmsg call.  Once you
have enough data from that wait no further waits should be done for
that recvmsg call.  The original commit had it right with just one
wait at the start of recvmsg (400c40cf78da).

Fetching of ctx state should be performed after this wait.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
