From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto: vmx - Fix sleep-in-atomic bugs
Date: Wed, 22 Aug 2018 08:05:02 +0200
Message-ID: <CAAUqJDsGFpKS7nKfb2vCpXGzT+WBoDUW0G5-O3ZDrv-Ham7f4w@mail.gmail.com>
References: <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
 <20180821151623.26061-1-omosnace@redhat.com> <CAAUqJDu1ib4Rfr6fnV2L001Uf3frkv6KQ-WJz6UvQ=R0VuXipg@mail.gmail.com>
 <20180821164126.GF28751@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: omosnace@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        leo.barbosa@canonical.com, stable@vger.kernel.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
To: marcelo.cerri@canonical.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180821164126.GF28751@gallifrey>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ut 21. 8. 2018 o 18:41 Marcelo Henrique Cerri
<marcelo.cerri@canonical.com> nap=C3=ADsal(a):
> On Tue, Aug 21, 2018 at 05:24:45PM +0200, Ondrej Mosn=C3=A1=C4=8Dek wrote=
:
> > CC: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
> > linuxppc-dev@lists.ozlabs.org
> >
> > (Sorry, sent this before reading new e-mails in the thread...)
> >
> > ut 21. 8. 2018 o 17:18 Ondrej Mosnacek <omosnace@redhat.com> nap=C3=ADs=
al(a):
> > >
> > > This patch fixes sleep-in-atomic bugs in AES-CBC and AES-XTS VMX
> > > implementations. The problem is that the blkcipher_* functions should
> > > not be called in atomic context.
> > >
> > > The bugs can be reproduced via the AF_ALG interface by trying to
> > > encrypt/decrypt sufficiently large buffers (at least 64 KiB) using th=
e
> > > VMX implementations of 'cbc(aes)' or 'xts(aes)'. Such operations then
> > > trigger BUG in crypto_yield():
> > >
> > > [  891.863680] BUG: sleeping function called from invalid context at =
include/crypto/algapi.h:424
> > > [  891.864622] in_atomic(): 1, irqs_disabled(): 0, pid: 12347, name: =
kcapi-enc
> > > [  891.864739] 1 lock held by kcapi-enc/12347:
> > > [  891.864811]  #0: 00000000f5d42c46 (sk_lock-AF_ALG){+.+.}, at: skci=
pher_recvmsg+0x50/0x530
> > > [  891.865076] CPU: 5 PID: 12347 Comm: kcapi-enc Not tainted 4.19.0-0=
.rc0.git3.1.fc30.ppc64le #1
> > > [  891.865251] Call Trace:
> > > [  891.865340] [c0000003387578c0] [c000000000d67ea4] dump_stack+0xe8/=
0x164 (unreliable)
> > > [  891.865511] [c000000338757910] [c000000000172a58] ___might_sleep+0=
x2f8/0x310
> > > [  891.865679] [c000000338757990] [c0000000006bff74] blkcipher_walk_d=
one+0x374/0x4a0
> > > [  891.865825] [c0000003387579e0] [d000000007e73e70] p8_aes_cbc_encry=
pt+0x1c8/0x260 [vmx_crypto]
> > > [  891.865993] [c000000338757ad0] [c0000000006c0ee0] skcipher_encrypt=
_blkcipher+0x60/0x80
> > > [  891.866128] [c000000338757b10] [c0000000006ec504] skcipher_recvmsg=
+0x424/0x530
> > > [  891.866283] [c000000338757bd0] [c000000000b00654] sock_recvmsg+0x7=
4/0xa0
> > > [  891.866403] [c000000338757c10] [c000000000b00f64] ___sys_recvmsg+0=
xf4/0x2f0
> > > [  891.866515] [c000000338757d90] [c000000000b02bb8] __sys_recvmsg+0x=
68/0xe0
> > > [  891.866631] [c000000338757e30] [c00000000000bbe4] system_call+0x5c=
/0x70
> > >
> > > Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX modul=
e")
> > > Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > > This patch should fix the issue, but I didn't test it. (I'll see if I
> > > can find some time tomorrow to try and recompile the kernel on a PPC
> > > machine... in the meantime please review :)
> > >
> > >  drivers/crypto/vmx/aes_cbc.c | 30 ++++++++++++++----------------
> > >  drivers/crypto/vmx/aes_xts.c | 19 ++++++++++++-------
> > >  2 files changed, 26 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cb=
c.c
> > > index 5285ece4f33a..b71895871be3 100644
> > > --- a/drivers/crypto/vmx/aes_cbc.c
> > > +++ b/drivers/crypto/vmx/aes_cbc.c
> > > @@ -107,24 +107,23 @@ static int p8_aes_cbc_encrypt(struct blkcipher_=
desc *desc,
> > >                 ret =3D crypto_skcipher_encrypt(req);
> > >                 skcipher_request_zero(req);
> > >         } else {
> > > -               preempt_disable();
> > > -               pagefault_disable();
> > > -               enable_kernel_vsx();
> > > -
> > >                 blkcipher_walk_init(&walk, dst, src, nbytes);
> > >                 ret =3D blkcipher_walk_virt(desc, &walk);
> > >                 while ((nbytes =3D walk.nbytes)) {
> > > +                       preempt_disable();
> > > +                       pagefault_disable();
> > > +                       enable_kernel_vsx();
> > >                         aes_p8_cbc_encrypt(walk.src.virt.addr,
> > >                                            walk.dst.virt.addr,
> > >                                            nbytes & AES_BLOCK_MASK,
> > >                                            &ctx->enc_key, walk.iv, 1)=
;
> > > +                       disable_kernel_vsx();
> > > +                       pagefault_enable();
> > > +                       preempt_enable();
> > > +
> > >                         nbytes &=3D AES_BLOCK_SIZE - 1;
> > >                         ret =3D blkcipher_walk_done(desc, &walk, nbyt=
es);
> > >                 }
> > > -
> > > -               disable_kernel_vsx();
> > > -               pagefault_enable();
> > > -               preempt_enable();
> > >         }
> > >
> > >         return ret;
> > > @@ -147,24 +146,23 @@ static int p8_aes_cbc_decrypt(struct blkcipher_=
desc *desc,
> > >                 ret =3D crypto_skcipher_decrypt(req);
> > >                 skcipher_request_zero(req);
> > >         } else {
> > > -               preempt_disable();
> > > -               pagefault_disable();
> > > -               enable_kernel_vsx();
> > > -
> > >                 blkcipher_walk_init(&walk, dst, src, nbytes);
> > >                 ret =3D blkcipher_walk_virt(desc, &walk);
> > >                 while ((nbytes =3D walk.nbytes)) {
> > > +                       preempt_disable();
> > > +                       pagefault_disable();
> > > +                       enable_kernel_vsx();
> > >                         aes_p8_cbc_encrypt(walk.src.virt.addr,
> > >                                            walk.dst.virt.addr,
> > >                                            nbytes & AES_BLOCK_MASK,
> > >                                            &ctx->dec_key, walk.iv, 0)=
;
> > > +                       disable_kernel_vsx();
> > > +                       pagefault_enable();
> > > +                       preempt_enable();
> > > +
> > >                         nbytes &=3D AES_BLOCK_SIZE - 1;
> > >                         ret =3D blkcipher_walk_done(desc, &walk, nbyt=
es);
> > >                 }
> > > -
> > > -               disable_kernel_vsx();
> > > -               pagefault_enable();
> > > -               preempt_enable();
> > >         }
> > >
> > >         return ret;
> > > diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xt=
s.c
> > > index 8bd9aff0f55f..016ef52390c9 100644
> > > --- a/drivers/crypto/vmx/aes_xts.c
> > > +++ b/drivers/crypto/vmx/aes_xts.c
> > > @@ -116,13 +116,14 @@ static int p8_aes_xts_crypt(struct blkcipher_de=
sc *desc,
> > >                 ret =3D enc? crypto_skcipher_encrypt(req) : crypto_sk=
cipher_decrypt(req);
> > >                 skcipher_request_zero(req);
> > >         } else {
> > > +               blkcipher_walk_init(&walk, dst, src, nbytes);
> > > +
> > > +               ret =3D blkcipher_walk_virt(desc, &walk);
> > > +
> > >                 preempt_disable();
> > >                 pagefault_disable();
> > >                 enable_kernel_vsx();
> > >
> > > -               blkcipher_walk_init(&walk, dst, src, nbytes);
> > > -
> > > -               ret =3D blkcipher_walk_virt(desc, &walk);
> > >                 iv =3D walk.iv;
> > >                 memset(tweak, 0, AES_BLOCK_SIZE);
> > >                 aes_p8_encrypt(iv, tweak, &ctx->tweak_key);
> > > @@ -135,13 +136,17 @@ static int p8_aes_xts_crypt(struct blkcipher_de=
sc *desc,
> > >                                 aes_p8_xts_decrypt(walk.src.virt.addr=
, walk.dst.virt.addr,
> > >                                                 nbytes & AES_BLOCK_MA=
SK, &ctx->dec_key, NULL, tweak);
> > >
> > > +                       disable_kernel_vsx();
> > > +                       pagefault_enable();
> > > +                       preempt_enable();
> > > +
> > >                         nbytes &=3D AES_BLOCK_SIZE - 1;
> > >                         ret =3D blkcipher_walk_done(desc, &walk, nbyt=
es);
> > > -               }
> > >
> > > -               disable_kernel_vsx();
> > > -               pagefault_enable();
> > > -               preempt_enable();
> > > +                       preempt_disable();
> > > +                       pagefault_disable();
> > > +                       enable_kernel_vsx();
> > > +               }
>
> That doesn't seem right. It would leave preemption disabled when
> leaving the function.

Oh, right! Sorry, I will send a fixed v2 soon...

> > >         }
> > >         return ret;
> > >  }
> > > --
> > > 2.17.1
> > >
>
> --
> Regards,
> Marcelo
