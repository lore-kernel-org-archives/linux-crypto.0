From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree - avoid implicit enum conversion
Date: Thu, 11 Oct 2018 10:47:20 +0300
Message-ID: <CAOtvUMezOMmyE=FW+nRqrR+r2NsNOCCXWwp0fja9gF7j-xQAnw@mail.gmail.com>
References: <20181010214006.21304-1-natechancellor@gmail.com> <CAKwvOdk+JmBP4TBAG+DfhehofM0sO0vWRXbAbEifYy+T+u_SVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: natechancellor@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: ndesaulniers@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdk+JmBP4TBAG+DfhehofM0sO0vWRXbAbEifYy+T+u_SVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Nick,

On Thu, Oct 11, 2018 at 2:49 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> $ grep -r set_cipher_config0 -n
>
> shows a healthy mix of DESC_DIRECTION_ENCRYPT_ENCRYPT,
> HASH_DIGEST_RESULT_LITTLE_ENDIAN, and DRV_CRYPTO_DIRECTION_ENCRYPT
> (all enumeration values of different enums).
>
> >
> > drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
> > from enumeration type 'enum drv_hash_hw_mode' to different enumeration
> > type 'enum drv_cipher_mode' [-Wenum-conversion]
> >         set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
>
> Looks like a lot fewer call sites using DRV_HASH_HW_GHASH; same value
> as DRV_CIPHER_OFB (different enum), but can a block cipher mode and a
> hash be valid values for pdesc->word[4]?
>
> >
> > Since this fundamentally isn't a problem because these values just
> > represent simple integers for a shift operation, make it clear to Clang
> > that this is okay by making the mode parameter in both functions an int=
.
>
> This also looks like the simplest fix to me, assuming the values of
> all of these enums are valid for whatever pdesc->word[4] is.  Can the
> maintainers explain what is CC7x-DESC what the comment makes reference
> to?

They indeed are. CC7x-DESC is a shorthand for "CryptoCell 7xx
Descriptor" used in the hardware documents.
These descriptors are comprised of fields with context sensitive
meaning, hence this "overloading".

Given this overloading of meaning an  "int" type is indeed a better
suited type here.

Thanks,
Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
