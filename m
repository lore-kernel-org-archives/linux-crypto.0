From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 11:33:58 -0500
Message-ID: <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com>
	 <19334.40337.651079.440912@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19334.40337.651079.440912@pilspetsen.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 25, 2010 at 10:56 AM, Mikael Pettersson <mikpe@it.uu.se> wr=
ote:
> Roel Kluin writes:
> =C2=A0> Due to optimization A call to memset() may be removed as a de=
ad store when
> =C2=A0> the buffer is not used after its value is overwritten.
> =C2=A0>
> =C2=A0> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> =C2=A0> ---
> =C2=A0> see http://cwe.mitre.org/data/slices/2000.html#14
> =C2=A0>
> =C2=A0> checkpatch.pl, compile and sparse tested. Comments?
> =C2=A0>
> =C2=A0> diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
> =C2=A0> index 0416091..86de0da 100644
> =C2=A0> --- a/crypto/sha1_generic.c
> =C2=A0> +++ b/crypto/sha1_generic.c
> =C2=A0> @@ -49,8 +49,8 @@ static int sha1_update(struct shash_desc *d=
esc, const u8 *data,
> =C2=A0> =C2=A0 =C2=A0 =C2=A0src =3D data;
> =C2=A0>
> =C2=A0> =C2=A0 =C2=A0 =C2=A0if ((partial + len) > 63) {
> =C2=A0> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 temp[SHA_WORKS=
PACE_WORDS];
> =C2=A0> -
> =C2=A0> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 *temp =3D kzal=
loc(SHA_WORKSPACE_WORDS * sizeof(u32),
> =C2=A0> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GFP_KERNEL);
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (partial) =
{
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0done =3D -partial;
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0memcpy(sctx->buffer + partial, data, done + 64);
> =C2=A0> @@ -64,6 +64,7 @@ static int sha1_update(struct shash_desc *d=
esc, const u8 *data,
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (done=
 + 63 < len);
> =C2=A0>
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(temp, =
0, sizeof(temp));
> =C2=A0> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(temp);
> =C2=A0> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partial =3D 0=
;
> =C2=A0> =C2=A0 =C2=A0 =C2=A0}
> =C2=A0> =C2=A0 =C2=A0 =C2=A0memcpy(sctx->buffer + partial, src, len -=
 done);
>
> At best this might solve the issue right now, but it's not
> future-proof by any margin.
>
> One problem is that just like the lifetimes of auto variables are
> known to the compiler, allowing dead store elimination (DSE) on them,
> there is development going on to make malloc() and free() known to
> the compiler. I don't think it's complete yet, but once free() is
> known, the sequence "memset(p, 0, n); free(p);" will obviously be
> DSE:d just like in the current case with the auto variable.
>
> And as soon as gcc can optimize malloc() and free(), you can be sure =
that
> some eager kernel hacker will mark the kernel's allocators accordingl=
y,
> and then we're back to square one.
>
> I fear that the only portable (across compiler versions) and safe
> solution is to invoke an assembly-coded dummy function with prototype
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0void use(void *p);
>
> and rewrite the code above as
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 temp[...];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(temp, 0=
, sizeof temp);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0use(temp);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> This forces the compiler to consider the buffer live after the
> memset, so the memset cannot be eliminated.
>
> The reason the use() function needs to be in assembly code is that
> with link-time optimizations soon commonplace (LTO in gcc-4.5),
> a compiler can possibly discover that even an out-of-line function
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0void use(void *p) { }
>
> doesn't in fact use *p, which then enables (in theory) the
> preceeding memset() to be DSE:d.


Would barrier() (which is a simple memory clobber) after the memset wor=
k?

--
Brian Gerst
