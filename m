From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree - avoid implicit enum conversion
Date: Thu, 11 Oct 2018 10:39:01 +0300
Message-ID: <CAOtvUMcwR6r24u0XEm4o_C5oPW-8wyuiQ++YHs=gioP9C4Wm1A@mail.gmail.com>
References: <20181010214006.21304-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        ndesaulniers@google.com, Yael Chemla <Yael.Chemla@arm.com>
To: natechancellor@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010214006.21304-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Nathan,

On Thu, Oct 11, 2018 at 12:44 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another
> and this happens in several locations in this driver, ultimately related
> to the set_cipher_{mode,config0} functions. set_cipher_mode expects a mod=
e
> of type drv_cipher_mode and set_cipher_config0 expects a mode of type
> drv_crypto_direction.
>
> drivers/crypto/ccree/cc_ivgen.c:58:35: warning: implicit conversion from
> enumeration type 'enum cc_desc_direction' to different enumeration type
> 'enum drv_crypto_direction' [-Wenum-conversion]
>         set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
>
> drivers/crypto/ccree/cc_hash.c:99:28: warning: implicit conversion from
> enumeration type 'enum cc_hash_conf_pad' to different enumeration type
> 'enum drv_crypto_direction' [-Wenum-conversion]
>                 set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN=
);
>
> drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
> from enumeration type 'enum drv_hash_hw_mode' to different enumeration
> type 'enum drv_cipher_mode' [-Wenum-conversion]
>         set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
>
> Since this fundamentally isn't a problem because these values just
> represent simple integers for a shift operation, make it clear to Clang
> that this is okay by making the mode parameter in both functions an int.

Thank you. We actually had a patch fixing this in the pipeline but
your fix is simpler. :-)

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
