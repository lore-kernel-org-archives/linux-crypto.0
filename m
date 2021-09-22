Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80645C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 10:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5990B61214
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 10:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhIVKoz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 06:44:55 -0400
Received: from 82-65-109-163.subs.proxad.net ([82.65.109.163]:41196 "EHLO
        luna.linkmauve.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhIVKoj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 06:44:39 -0400
Received: by luna.linkmauve.fr (Postfix, from userid 1000)
        id E2B92F40B68; Wed, 22 Sep 2021 12:43:02 +0200 (CEST)
Date:   Wed, 22 Sep 2021 12:43:02 +0200
From:   Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ash Logan <ash@heyquark.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
Message-ID: <20210922104302.22pgaoy2vspranqj@luna>
Jabber-ID: linkmauve@linkmauve.fr
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
 <20210921213930.10366-2-linkmauve@linkmauve.fr>
 <CAMj1kXF6RpaAsN2zUgkO0NW7gMwwhXMHEEM-wpQXxeNJbGJ79A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vea675oaejr3mtdt"
Content-Disposition: inline
In-Reply-To: <CAMj1kXF6RpaAsN2zUgkO0NW7gMwwhXMHEEM-wpQXxeNJbGJ79A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--vea675oaejr3mtdt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 22, 2021 at 12:10:41PM +0200, Ard Biesheuvel wrote:
> On Tue, 21 Sept 2021 at 23:49, Emmanuel Gil Peyrot
> <linkmauve@linkmauve.fr> wrote:
> >
> > This engine implements AES in CBC mode, using 128-bit keys only.  It is
> > present on both the Wii and the Wii U, and is apparently identical in
> > both consoles.
> >
> > The hardware is capable of firing an interrupt when the operation is
> > done, but this driver currently uses a busy loop, I=E2=80=99m not too s=
ure
> > whether it would be preferable to switch, nor how to achieve that.
> >
> > It also supports a mode where no operation is done, and thus could be
> > used as a DMA copy engine, but I don=E2=80=99t know how to expose that =
to the
> > kernel or whether it would even be useful.
> >
> > In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> > aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> > speedup.
> >
> > This driver was written based on reversed documentation, see:
> > https://wiibrew.org/wiki/Hardware/AES
> >
> > Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> > Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U
>=20
> This is redundant - everybody should test the code they submit.

Indeed, except for the comment, as I haven=E2=80=99t been able to test on t=
he
Wii just yet and that=E2=80=99s kind of a call for doing exactly that. :)

>=20
> ...
> > +       /* TODO: figure out how to use interrupts here, this will proba=
bly
> > +        * lower throughput but let the CPU do other things while the A=
ES
> > +        * engine is doing its work. */
>=20
> So is it worthwhile like this? How much faster is it to use this
> accelerator rather than the CPU?

As I mentioned above, on my hardware it reaches 80.7=C2=A0MiB/s using this
busy loop instead of 30.9=C2=A0MiB/s using aes-generic, measured using
`cryptsetup benchmark --cipher=3Daes --key-size=3D128`.  I expect the
difference would be even more pronounced on the Wii, with its CPU being
clocked lower.

I will give a try at using the interrupt, but I fully expect a lower
throughput alongside a lower CPU usage (for large requests).

>=20
> > +       do {
> > +               status =3D ioread32be(base + AES_CTRL);
> > +               cpu_relax();
> > +       } while ((status & AES_CTRL_EXEC) && --counter);
> > +
> > +       /* Do we ever get called with dst =E2=89=A0 src?  If so we have=
 to invalidate
> > +        * dst in addition to the earlier flush of src. */
> > +       if (unlikely(dst !=3D src)) {
> > +               for (i =3D 0; i < len; i +=3D 32)
> > +                       __asm__("dcbi 0, %0" : : "r" (dst + i));
> > +               __asm__("sync" : : : "memory");
> > +       }
> > +
> > +       return counter ? 0 : 1;
> > +}
> > +
> > +static void
> > +nintendo_aes_crypt(const void *src, void *dst, u32 len, u8 *iv, int di=
r,
> > +                  bool firstchunk)
> > +{
> > +       u32 flags =3D 0;
> > +       unsigned long iflags;
> > +       int ret;
> > +
> > +       flags |=3D AES_CTRL_EXEC_INIT /* | AES_CTRL_IRQ */ | AES_CTRL_E=
NA;
> > +
> > +       if (dir =3D=3D AES_DIR_DECRYPT)
> > +               flags |=3D AES_CTRL_DEC;
> > +
> > +       if (!firstchunk)
> > +               flags |=3D AES_CTRL_IV;
> > +
> > +       /* Start the critical section */
> > +       spin_lock_irqsave(&lock, iflags);
> > +
> > +       if (firstchunk)
> > +               writefield(AES_IV, iv);
> > +
> > +       ret =3D do_crypt(src, dst, len, flags);
> > +       BUG_ON(ret);
> > +
> > +       spin_unlock_irqrestore(&lock, iflags);
> > +}
> > +
> > +static int nintendo_setkey_skcipher(struct crypto_skcipher *tfm, const=
 u8 *key,
> > +                                   unsigned int len)
> > +{
> > +       /* The hardware only supports AES-128 */
> > +       if (len !=3D AES_KEYSIZE_128)
> > +               return -EINVAL;
> > +
> > +       writefield(AES_KEY, key);
> > +       return 0;
> > +}
> > +
> > +static int nintendo_skcipher_crypt(struct skcipher_request *req, int d=
ir)
> > +{
> > +       struct skcipher_walk walk;
> > +       unsigned int nbytes;
> > +       int err;
> > +       char ivbuf[AES_BLOCK_SIZE];
> > +       unsigned int ivsize;
> > +
> > +       bool firstchunk =3D true;
> > +
> > +       /* Reset the engine */
> > +       iowrite32be(0, base + AES_CTRL);
> > +
> > +       err =3D skcipher_walk_virt(&walk, req, false);
> > +       ivsize =3D min(sizeof(ivbuf), walk.ivsize);
> > +
> > +       while ((nbytes =3D walk.nbytes) !=3D 0) {
> > +               unsigned int chunkbytes =3D round_down(nbytes, AES_BLOC=
K_SIZE);
> > +               unsigned int ret =3D nbytes % AES_BLOCK_SIZE;
> > +
> > +               if (walk.total =3D=3D chunkbytes && dir =3D=3D AES_DIR_=
DECRYPT) {
> > +                       /* If this is the last chunk and we're decrypti=
ng, take
> > +                        * note of the IV (which is the last ciphertext=
 block)
> > +                        */
> > +                       memcpy(ivbuf, walk.src.virt.addr + walk.total -=
 ivsize,
> > +                              ivsize);
> > +               }
> > +
> > +               nintendo_aes_crypt(walk.src.virt.addr, walk.dst.virt.ad=
dr,
> > +                                  chunkbytes, walk.iv, dir, firstchunk=
);
> > +
> > +               if (walk.total =3D=3D chunkbytes && dir =3D=3D AES_DIR_=
ENCRYPT) {
> > +                       /* If this is the last chunk and we're encrypti=
ng, take
> > +                        * note of the IV (which is the last ciphertext=
 block)
> > +                        */
> > +                       memcpy(walk.iv,
> > +                              walk.dst.virt.addr + walk.total - ivsize,
> > +                              ivsize);
> > +               } else if (walk.total =3D=3D chunkbytes && dir =3D=3D A=
ES_DIR_DECRYPT) {
> > +                       memcpy(walk.iv, ivbuf, ivsize);
> > +               }
> > +
> > +               err =3D skcipher_walk_done(&walk, ret);
> > +               firstchunk =3D false;
> > +       }
> > +
> > +       return err;
> > +}
> > +
> > +static int nintendo_cbc_encrypt(struct skcipher_request *req)
> > +{
> > +       return nintendo_skcipher_crypt(req, AES_DIR_ENCRYPT);
> > +}
> > +
> > +static int nintendo_cbc_decrypt(struct skcipher_request *req)
> > +{
> > +       return nintendo_skcipher_crypt(req, AES_DIR_DECRYPT);
> > +}
> > +
> > +static struct skcipher_alg nintendo_alg =3D {
> > +       .base.cra_name          =3D "cbc(aes)",
> > +       .base.cra_driver_name   =3D "cbc-aes-nintendo",
> > +       .base.cra_priority      =3D 400,
> > +       .base.cra_flags         =3D CRYPTO_ALG_KERN_DRIVER_ONLY,
> > +       .base.cra_blocksize     =3D AES_BLOCK_SIZE,
> > +       .base.cra_alignmask     =3D 15,
> > +       .base.cra_module        =3D THIS_MODULE,
> > +       .setkey                 =3D nintendo_setkey_skcipher,
> > +       .encrypt                =3D nintendo_cbc_encrypt,
> > +       .decrypt                =3D nintendo_cbc_decrypt,
> > +       .min_keysize            =3D AES_KEYSIZE_128,
> > +       .max_keysize            =3D AES_KEYSIZE_128,
> > +       .ivsize                 =3D AES_BLOCK_SIZE,
> > +};
> > +
> > +static int nintendo_aes_remove(struct platform_device *pdev)
> > +{
> > +       struct device *dev =3D &pdev->dev;
> > +
> > +       crypto_unregister_skcipher(&nintendo_alg);
> > +       devm_iounmap(dev, base);
> > +       base =3D NULL;
> > +
> > +       return 0;
> > +}
> > +
> > +static int nintendo_aes_probe(struct platform_device *pdev)
> > +{
> > +       struct device *dev =3D &pdev->dev;
> > +       struct resource *res;
> > +       int ret;
> > +
> > +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +       base =3D devm_ioremap_resource(dev, res);
> > +       if (IS_ERR(base))
> > +               return PTR_ERR(base);
> > +
> > +       spin_lock_init(&lock);
> > +
> > +       ret =3D crypto_register_skcipher(&nintendo_alg);
> > +       if (ret)
> > +               goto eiomap;
> > +
> > +       dev_notice(dev, "Nintendo Wii and Wii U AES engine enabled\n");
> > +       return 0;
> > +
> > + eiomap:
> > +       devm_iounmap(dev, base);
> > +
> > +       dev_err(dev, "Nintendo Wii and Wii U AES initialization failed\=
n");
> > +       return ret;
> > +}
> > +
> > +static const struct of_device_id nintendo_aes_of_match[] =3D {
> > +       { .compatible =3D "nintendo,hollywood-aes", },
> > +       { .compatible =3D "nintendo,latte-aes", },
> > +       {/* sentinel */},
> > +};
> > +MODULE_DEVICE_TABLE(of, nintendo_aes_of_match);
> > +
> > +static struct platform_driver nintendo_aes_driver =3D {
> > +       .driver =3D {
> > +               .name =3D "nintendo-aes",
> > +               .of_match_table =3D nintendo_aes_of_match,
> > +       },
> > +       .probe =3D nintendo_aes_probe,
> > +       .remove =3D nintendo_aes_remove,
> > +};
> > +
> > +module_platform_driver(nintendo_aes_driver);
> > +
> > +MODULE_AUTHOR("Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>");
> > +MODULE_DESCRIPTION("Nintendo Wii and Wii U Hardware AES driver");
> > +MODULE_LICENSE("GPL");
> > --
> > 2.33.0
> >

--=20
Emmanuel Gil Peyrot

--vea675oaejr3mtdt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEjrVT1SzTln43kCLJOWgfYkb2LpAFAmFLCLMACgkQOWgfYkb2
LpBfJgf7BY7Zqe1if2b1NeTahrk2Y9jpro4a0pqR8DWdmNrcqrIscPXqWyT9lA4L
xfI9vYPgrlLsdY3AUHmcGEb7RG+knxhIsqgRzp+z8bM6MGOYoQmwKx2+/OQpVlfz
zOFWL6kUqdlKmyOCeVy2mtbhhVc+dVLBDsozYvsMZmchpQoIh61+nlG2AASZZ0xn
W0qcIZM+tBmer2A4WbGT0ef7/ARH+3vqP7yNaeYQYVwTkgjyCLC/R9c8+Tcxhi8/
NQ9GeICpH+mTYso9zOqQy0QeEuLCRObF9Oa7ntCRDkzn3d+6YJ/vAbWVFOJ3g3UN
HSk3v05XiCj0SAhKwLSxDitRxRqQ9g==
=ZiKk
-----END PGP SIGNATURE-----

--vea675oaejr3mtdt--
