Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30169C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 10:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0905F61247
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 10:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhIVKM0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 06:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234233AbhIVKMX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 06:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D96760F21;
        Wed, 22 Sep 2021 10:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632305454;
        bh=XZApaAHK+8eKA8jUnLJ2HYEY5F8KHUNinsnPqP3/24g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VvBsCRHhNQXooQ+nE/JbVKrAtI8qZ3rIKd2UX5zQsxXCS1FChs0NCWdOxt/iUR5hU
         RpSBM3egVAXYWoMHchTl9NFDp6LW4bQeG8g4hY0DUh6nb6PXTsJUclRK38HQOipLTL
         gERVX696OG0+pKkkEBdWj3/lTj6kbkUknY4m3Iu1uKBPPKRssAPDvwpdkPZPRXxFcb
         dlU78Aj0x5w5TLIapsn3Hm6bMd6MtnOb6fwrlJaTrvKMYJgC4IN5XlQPfy2LqJmfK4
         lbommSYIeOAhtD/lPbqShYbJ8VGIzNn3rKgijWgOqXsaToVWEX7YOhFFLxTDHjCz3O
         Go4czYXY0ICCw==
Received: by mail-oi1-f177.google.com with SMTP id r26so3701079oij.2;
        Wed, 22 Sep 2021 03:10:54 -0700 (PDT)
X-Gm-Message-State: AOAM532n5sgA9FMbS0sr9QyPB71w1abkxVqCe8+2YM+QnQ+CsYEO24xX
        hprGGIT5zyIMLhK58KVaeXe6znL3Jt7b/ohMZmc=
X-Google-Smtp-Source: ABdhPJxY7RKemNzkKOmobzDTMPzrir9yE57gTkEGgw1n0WEteHo51nxZbrdEiulNM8zOF818yvNv0Zi7qLU/m+UGbQs=
X-Received: by 2002:a05:6808:1148:: with SMTP id u8mr5295141oiu.33.1632305453483;
 Wed, 22 Sep 2021 03:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210921213930.10366-1-linkmauve@linkmauve.fr> <20210921213930.10366-2-linkmauve@linkmauve.fr>
In-Reply-To: <20210921213930.10366-2-linkmauve@linkmauve.fr>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 22 Sep 2021 12:10:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF6RpaAsN2zUgkO0NW7gMwwhXMHEEM-wpQXxeNJbGJ79A@mail.gmail.com>
Message-ID: <CAMj1kXF6RpaAsN2zUgkO0NW7gMwwhXMHEEM-wpQXxeNJbGJ79A@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
To:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ash Logan <ash@heyquark.com>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.ne@posteo.net>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 21 Sept 2021 at 23:49, Emmanuel Gil Peyrot
<linkmauve@linkmauve.fr> wrote:
>
> This engine implements AES in CBC mode, using 128-bit keys only.  It is
> present on both the Wii and the Wii U, and is apparently identical in
> both consoles.
>
> The hardware is capable of firing an interrupt when the operation is
> done, but this driver currently uses a busy loop, I=E2=80=99m not too sur=
e
> whether it would be preferable to switch, nor how to achieve that.
>
> It also supports a mode where no operation is done, and thus could be
> used as a DMA copy engine, but I don=E2=80=99t know how to expose that to=
 the
> kernel or whether it would even be useful.
>
> In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> speedup.
>
> This driver was written based on reversed documentation, see:
> https://wiibrew.org/wiki/Hardware/AES
>
> Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U

This is redundant - everybody should test the code they submit.

...
> +       /* TODO: figure out how to use interrupts here, this will probabl=
y
> +        * lower throughput but let the CPU do other things while the AES
> +        * engine is doing its work. */

So is it worthwhile like this? How much faster is it to use this
accelerator rather than the CPU?

> +       do {
> +               status =3D ioread32be(base + AES_CTRL);
> +               cpu_relax();
> +       } while ((status & AES_CTRL_EXEC) && --counter);
> +
> +       /* Do we ever get called with dst =E2=89=A0 src?  If so we have t=
o invalidate
> +        * dst in addition to the earlier flush of src. */
> +       if (unlikely(dst !=3D src)) {
> +               for (i =3D 0; i < len; i +=3D 32)
> +                       __asm__("dcbi 0, %0" : : "r" (dst + i));
> +               __asm__("sync" : : : "memory");
> +       }
> +
> +       return counter ? 0 : 1;
> +}
> +
> +static void
> +nintendo_aes_crypt(const void *src, void *dst, u32 len, u8 *iv, int dir,
> +                  bool firstchunk)
> +{
> +       u32 flags =3D 0;
> +       unsigned long iflags;
> +       int ret;
> +
> +       flags |=3D AES_CTRL_EXEC_INIT /* | AES_CTRL_IRQ */ | AES_CTRL_ENA=
;
> +
> +       if (dir =3D=3D AES_DIR_DECRYPT)
> +               flags |=3D AES_CTRL_DEC;
> +
> +       if (!firstchunk)
> +               flags |=3D AES_CTRL_IV;
> +
> +       /* Start the critical section */
> +       spin_lock_irqsave(&lock, iflags);
> +
> +       if (firstchunk)
> +               writefield(AES_IV, iv);
> +
> +       ret =3D do_crypt(src, dst, len, flags);
> +       BUG_ON(ret);
> +
> +       spin_unlock_irqrestore(&lock, iflags);
> +}
> +
> +static int nintendo_setkey_skcipher(struct crypto_skcipher *tfm, const u=
8 *key,
> +                                   unsigned int len)
> +{
> +       /* The hardware only supports AES-128 */
> +       if (len !=3D AES_KEYSIZE_128)
> +               return -EINVAL;
> +
> +       writefield(AES_KEY, key);
> +       return 0;
> +}
> +
> +static int nintendo_skcipher_crypt(struct skcipher_request *req, int dir=
)
> +{
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +       char ivbuf[AES_BLOCK_SIZE];
> +       unsigned int ivsize;
> +
> +       bool firstchunk =3D true;
> +
> +       /* Reset the engine */
> +       iowrite32be(0, base + AES_CTRL);
> +
> +       err =3D skcipher_walk_virt(&walk, req, false);
> +       ivsize =3D min(sizeof(ivbuf), walk.ivsize);
> +
> +       while ((nbytes =3D walk.nbytes) !=3D 0) {
> +               unsigned int chunkbytes =3D round_down(nbytes, AES_BLOCK_=
SIZE);
> +               unsigned int ret =3D nbytes % AES_BLOCK_SIZE;
> +
> +               if (walk.total =3D=3D chunkbytes && dir =3D=3D AES_DIR_DE=
CRYPT) {
> +                       /* If this is the last chunk and we're decrypting=
, take
> +                        * note of the IV (which is the last ciphertext b=
lock)
> +                        */
> +                       memcpy(ivbuf, walk.src.virt.addr + walk.total - i=
vsize,
> +                              ivsize);
> +               }
> +
> +               nintendo_aes_crypt(walk.src.virt.addr, walk.dst.virt.addr=
,
> +                                  chunkbytes, walk.iv, dir, firstchunk);
> +
> +               if (walk.total =3D=3D chunkbytes && dir =3D=3D AES_DIR_EN=
CRYPT) {
> +                       /* If this is the last chunk and we're encrypting=
, take
> +                        * note of the IV (which is the last ciphertext b=
lock)
> +                        */
> +                       memcpy(walk.iv,
> +                              walk.dst.virt.addr + walk.total - ivsize,
> +                              ivsize);
> +               } else if (walk.total =3D=3D chunkbytes && dir =3D=3D AES=
_DIR_DECRYPT) {
> +                       memcpy(walk.iv, ivbuf, ivsize);
> +               }
> +
> +               err =3D skcipher_walk_done(&walk, ret);
> +               firstchunk =3D false;
> +       }
> +
> +       return err;
> +}
> +
> +static int nintendo_cbc_encrypt(struct skcipher_request *req)
> +{
> +       return nintendo_skcipher_crypt(req, AES_DIR_ENCRYPT);
> +}
> +
> +static int nintendo_cbc_decrypt(struct skcipher_request *req)
> +{
> +       return nintendo_skcipher_crypt(req, AES_DIR_DECRYPT);
> +}
> +
> +static struct skcipher_alg nintendo_alg =3D {
> +       .base.cra_name          =3D "cbc(aes)",
> +       .base.cra_driver_name   =3D "cbc-aes-nintendo",
> +       .base.cra_priority      =3D 400,
> +       .base.cra_flags         =3D CRYPTO_ALG_KERN_DRIVER_ONLY,
> +       .base.cra_blocksize     =3D AES_BLOCK_SIZE,
> +       .base.cra_alignmask     =3D 15,
> +       .base.cra_module        =3D THIS_MODULE,
> +       .setkey                 =3D nintendo_setkey_skcipher,
> +       .encrypt                =3D nintendo_cbc_encrypt,
> +       .decrypt                =3D nintendo_cbc_decrypt,
> +       .min_keysize            =3D AES_KEYSIZE_128,
> +       .max_keysize            =3D AES_KEYSIZE_128,
> +       .ivsize                 =3D AES_BLOCK_SIZE,
> +};
> +
> +static int nintendo_aes_remove(struct platform_device *pdev)
> +{
> +       struct device *dev =3D &pdev->dev;
> +
> +       crypto_unregister_skcipher(&nintendo_alg);
> +       devm_iounmap(dev, base);
> +       base =3D NULL;
> +
> +       return 0;
> +}
> +
> +static int nintendo_aes_probe(struct platform_device *pdev)
> +{
> +       struct device *dev =3D &pdev->dev;
> +       struct resource *res;
> +       int ret;
> +
> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       base =3D devm_ioremap_resource(dev, res);
> +       if (IS_ERR(base))
> +               return PTR_ERR(base);
> +
> +       spin_lock_init(&lock);
> +
> +       ret =3D crypto_register_skcipher(&nintendo_alg);
> +       if (ret)
> +               goto eiomap;
> +
> +       dev_notice(dev, "Nintendo Wii and Wii U AES engine enabled\n");
> +       return 0;
> +
> + eiomap:
> +       devm_iounmap(dev, base);
> +
> +       dev_err(dev, "Nintendo Wii and Wii U AES initialization failed\n"=
);
> +       return ret;
> +}
> +
> +static const struct of_device_id nintendo_aes_of_match[] =3D {
> +       { .compatible =3D "nintendo,hollywood-aes", },
> +       { .compatible =3D "nintendo,latte-aes", },
> +       {/* sentinel */},
> +};
> +MODULE_DEVICE_TABLE(of, nintendo_aes_of_match);
> +
> +static struct platform_driver nintendo_aes_driver =3D {
> +       .driver =3D {
> +               .name =3D "nintendo-aes",
> +               .of_match_table =3D nintendo_aes_of_match,
> +       },
> +       .probe =3D nintendo_aes_probe,
> +       .remove =3D nintendo_aes_remove,
> +};
> +
> +module_platform_driver(nintendo_aes_driver);
> +
> +MODULE_AUTHOR("Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>");
> +MODULE_DESCRIPTION("Nintendo Wii and Wii U Hardware AES driver");
> +MODULE_LICENSE("GPL");
> --
> 2.33.0
>
