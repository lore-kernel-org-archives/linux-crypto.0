From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: ccree - avoid implicit enum conversion
Date: Thu, 11 Oct 2018 13:50:31 -0700
Message-ID: <CAKwvOdkUnpxJe+zXMWDHsfozi9D-TpPZgmasciRU-nkCA9xOGg@mail.gmail.com>
References: <20181010214006.21304-1-natechancellor@gmail.com>
 <CAKwvOdk+JmBP4TBAG+DfhehofM0sO0vWRXbAbEifYy+T+u_SVQ@mail.gmail.com> <CAOtvUMezOMmyE=FW+nRqrR+r2NsNOCCXWwp0fja9gF7j-xQAnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMezOMmyE=FW+nRqrR+r2NsNOCCXWwp0fja9gF7j-xQAnw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2018 at 12:47 AM Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
>
> Hi Nick,
>
> On Thu, Oct 11, 2018 at 2:49 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > $ grep -r set_cipher_config0 -n
> >
> > shows a healthy mix of DESC_DIRECTION_ENCRYPT_ENCRYPT,
> > HASH_DIGEST_RESULT_LITTLE_ENDIAN, and DRV_CRYPTO_DIRECTION_ENCRYPT
> > (all enumeration values of different enums).
> >
> > >
> > > drivers/crypto/ccree/cc_aead.c:1643:30: warning: implicit conversion
> > > from enumeration type 'enum drv_hash_hw_mode' to different enumeratio=
n
> > > type 'enum drv_cipher_mode' [-Wenum-conversion]
> > >         set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
> >
> > Looks like a lot fewer call sites using DRV_HASH_HW_GHASH; same value
> > as DRV_CIPHER_OFB (different enum), but can a block cipher mode and a
> > hash be valid values for pdesc->word[4]?
> >
> > >
> > > Since this fundamentally isn't a problem because these values just
> > > represent simple integers for a shift operation, make it clear to Cla=
ng
> > > that this is okay by making the mode parameter in both functions an i=
nt.
> >
> > This also looks like the simplest fix to me, assuming the values of
> > all of these enums are valid for whatever pdesc->word[4] is.  Can the
> > maintainers explain what is CC7x-DESC what the comment makes reference
> > to?
>
> They indeed are. CC7x-DESC is a shorthand for "CryptoCell 7xx
> Descriptor" used in the hardware documents.
> These descriptors are comprised of fields with context sensitive
> meaning, hence this "overloading".
>
> Given this overloading of meaning an  "int" type is indeed a better
> suited type here.

Sounds like they're valid values then.  Thanks for the info.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Thanks,
> Gilad
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> values of =CE=B2 will give rise to dom!



--=20
Thanks,
~Nick Desaulniers
