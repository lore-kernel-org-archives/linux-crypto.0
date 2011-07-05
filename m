From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Tue, 5 Jul 2011 10:15:08 +0330
Message-ID: <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
 <20110126070939.GA18150@gondor.apana.org.au> <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
 <20110126233315.GB26664@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1GEGpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2011 02:45:39 -0400
Received: by bwd5 with SMTP id 5so4513024bwd.19
        for <linux-crypto@vger.kernel.org>; Mon, 04 Jul 2011 23:45:38 -0700 (PDT)
In-Reply-To: <20110126233315.GB26664@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 27, 2011 at 3:03 AM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
>
> On Wed, Jan 26, 2011 at 11:20:22AM +0330, Hamid Nassiby wrote:
> >
> > Do you mean that different IP packets fit into one single Block Cip=
her tfm?
> > Would you please explain expansively?
>
> We allocate one tfm per SA. =C2=A0So as long as ordering is guarantee=
d
> per SA then it's guaranteed per SA which is all that's needed.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Dears,
Referring to my previous posts related to a hardware AES accelerator (t=
hat is
to be used to accelerate IPSec block cipher operations) driver, I would=
 like to
ask you about an possibly algorithmic problem exists in our solution.
As I said earlier our driver is inspired by geode_aes driver, so assume=
 that we
have defined our supported  algorithm as:

static struct crypto_alg shams_cbc_alg =3D {
        .cra_name               =3D       "cbc(aes)",
        .cra_driver_name        =3D       "cbc-aes-mine",
        .cra_priority           =3D       400,
        .cra_flags                      =3D       CRYPTO_ALG_TYPE_BLKCI=
PHER |

CRYPTO_ALG_NEED_FALLBACK,
        .cra_init                       =3D       fallback_init_blk,
        .cra_exit                       =3D       fallback_exit_blk,
        .cra_blocksize          =3D       AES_MIN_BLOCK_SIZE,
        .cra_ctxsize            =3D       sizeof(struct my_aes_op),
        .cra_alignmask          =3D       0,
        .cra_type                       =3D       &crypto_blkcipher_typ=
e,
        .cra_module                     =3D       THIS_MODULE,
        .cra_list                       =3D
LIST_HEAD_INIT(shams_cbc_alg.cra_list),
        .cra_u                          =3D       {
                .blkcipher      =3D       {
                        .min_keysize    =3D       AES_MIN_KEY_SIZE,
                        .max_keysize    =3D       AES_MIN_KEY_SIZE,
                        .setkey                 =3D       my_setkey_blk=
,
                        .encrypt                =3D       my_cbc_encryp=
t,
                        .decrypt                =3D       my_cbc_decryp=
t,
                        .ivsize                 =3D       AES_IV_LENGTH=
,
                }
        }
};

And our encrypt function, my_cbc_encrypt, looks like:

static int
my_cbc_encrypt(struct blkcipher_desc *desc,
                  struct scatterlist *dst, struct scatterlist *src,
                  unsigned int nbytes)
{
        struct my_aes_op *op =3D crypto_blkcipher_ctx(desc->tfm);
        struct blkcipher_walk walk;
        int err, ret;
        unsigned long flag1, c2flag;
        u32 my_req_id;

        spin_lock_irqsave(&reqlock, c2flag);
        /*Our request id sent to device and then retrieved to be able
to distinguish between device responses. */
        my_req_id =3D (global_reqid++) % 63000;
        spin_unlock_irqrestore(&reqlock, c2flag);


        if (unlikely(op->keylen !=3D AES_KEYSIZE_128))
                return fallback_blk_enc(desc, dst, src, nbytes);

        blkcipher_walk_init(&walk, dst, src, nbytes);
        err =3D blkcipher_walk_virt(desc, &walk);
        op->iv =3D walk.iv;

        while((nbytes =3D walk.nbytes)) {
                op->src =3D walk.src.virt.addr,
                op->dst =3D walk.dst.virt.addr;
                op->mode =3D AES_MODE_CBC;
                op->len =3D nbytes /*- (nbytes % AES_MIN_BLOCK_SIZE)*/;
                op->dir =3D AES_DIR_ENCRYPT;

            /* Critical PSEUDO code */
              spin_lock_irqsave(&1lock, flag1);
                 write_to_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock1, flag1);

              spin_lock_irqsave(&lock1, flag1);
                ret =3D read_from_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock1, flag1);
            /* End of Critical PSEUDO code*/
                nbytes -=3D ret;
                err =3D blkcipher_walk_done(desc, &walk, nbytes);
        }

        return err;
}

As I mentioned earlier we have multiple AES engines in our hardware, so=
 to
utilize hardware as much as possible, we would like to have the possibi=
lity to
give multiple requests to device and get responses from it as soon as o=
ne
becomes ready.

Now look at that section of my_cbc_encrypt, commented as "Critical PSEU=
DO code".
This section gives requests to device and reads back responses (And is =
the damn
bottleneck) . If we protect write_to_device and read_from_device call, =
by one
pair of lock/unlock as:

/* Critical PSEUDO code */
              spin_lock_irqsave(&lock1, flag1);
                 write_to_device(op, 0, my_req_id);
                ret =3D read_from_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock1, flag1);
/* End of Critical PSEUDO code*/

then we would have no problem, system works and IPSec en/decrypts by ou=
r
hardware. But ONLY one aes engine of our hardware is utilized; Good(sys=
tem
works), Bad (only one engine is utilized) and the Ugly (throughput is n=
ot
awesome). So we must change the section to:

/* Critical PSEUDO code */
              spin_lock_irqsave(&lock1, flag1);
                 write_to_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock1, flag1);

              spin_lock_irqsave(&glock, t2flag);
                ret =3D read_from_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&glock, t2flag);
/* End of Critical PSEUDO code */

and preferably to :

/* Critical PSEUDO code */
/* distinct locks for write_to_device and read_from_device */
              spin_lock_irqsave(&lock1, flag1);
                 write_to_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock1, flag1);

              spin_lock_irqsave(&lock2, flag2);
                ret =3D read_from_device(op, 0, my_req_id);
              spin_unlock_irqrestore(&lock2, flag2);
/* End of Critical PSEUDO*/


Here, it seems we must have no problem, but as soon as one TCP flow sta=
rts
the system hangs.
=46inally, I request your guidelines about the problem.

Thanks in advance,
Hamid.
