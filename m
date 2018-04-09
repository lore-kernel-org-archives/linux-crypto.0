From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] AF_ALG: register completely initialized request in list
Date: Mon, 9 Apr 2018 09:51:13 +0200
Message-ID: <CACT4Y+bGDOi-+vVs=-eD=wHaUbFz2ZVO13yF8hq4cU4dkGXorg@mail.gmail.com>
References: <00000000000092ad87056950ef9e@google.com> <3337259.MW9pfDCdka@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3337259.MW9pfDCdka@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 8, 2018 at 7:57 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Hi,
>
> May I ask to check whether this patch fixes the issue? I cannot re-create
> the issue with the reproducter. Yet, as far as I understand, you try to
> induce errors which shall validate whether the error code paths are corre=
ct.

You can ask syzbot to test by replying to its report email with a test
command, see:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communicatio=
n-with-syzbot

Note that all testing of KMSAN bugs needs to go to KMSAN tree, for details =
see:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs




> The fix below should ensure this now.
>
> Thanks a lot.
>
> ---8<---
>
> From 8f083e7b0684a9f91c186d7b46eec34e439689c3 Mon Sep 17 00:00:00 2001
> From: Stephan Mueller <smueller@chronox.de>
> Date: Sun, 8 Apr 2018 19:53:59 +0200
> Subject: [PATCH] AF_ALG: Initialize sg_num_bytes in error code path
>
> The RX SGL in processing is already registered with the RX SGL tracking
> list to support proper cleanup. The cleanup code path uses the
> sg_num_bytes variable which must therefore be always initialized, even
> in the error code path.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reported-by: syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com
> ---
>  crypto/af_alg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index c49766b03165..0d555c072669 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1156,8 +1156,10 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr=
 *msg, int flags,
>
>                 /* make one iovec available as scatterlist */
>                 err =3D af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen=
);
> -               if (err < 0)
> +               if (err < 0) {
> +                       rsgl->sg_num_bytes =3D 0;
>                         return err;
> +               }
>
>                 /* chain the new scatterlist with previous one */
>                 if (areq->last_rsgl)
> --
> 2.14.3
>
>
>
>
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/3337259.MW9pfDCdka%40positron.chronox.de.
> For more options, visit https://groups.google.com/d/optout.
