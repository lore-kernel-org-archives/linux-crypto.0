From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3] AF_ALG: Initialize sg_num_bytes in error code path
Date: Fri, 6 Jul 2018 09:58:10 +0200
Message-ID: <CACT4Y+ZDw9by_Fq5Bi5MtR8FqDjWmW834Pc-1-7j2OZniTXacg@mail.gmail.com>
References: <00000000000092ad87056950ef9e@google.com> <1616306.R4SzcgHSdy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1616306.R4SzcgHSdy@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 6, 2018 at 9:50 AM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Changes v3:
> * Fix syz testing line

Just in case, the syz test does not have to be in the patch. Just an
email to the syzbot address will do.


> Changes v2:
> * Addition of syz testing line
>
> ---8<---
>
> The RX SGL in processing is already registered with the RX SGL tracking
> list to support proper cleanup. The cleanup code path uses the
> sg_num_bytes variable which must therefore be always initialized, even
> in the error code path.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reported-by: syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com
> #syz test: https://github.com/google/kmsan.git master
> ---
>  crypto/af_alg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 49fa8582138b..bd6795ff406a 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1148,8 +1148,10 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr=
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
> 2.17.1
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
d/syzkaller-bugs/1616306.R4SzcgHSdy%40positron.chronox.de.
> For more options, visit https://groups.google.com/d/optout.
