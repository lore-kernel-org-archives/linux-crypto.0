From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 1/2] crypto: Fix out-of-bounds access of the data buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 11:28:27 -0800
Message-ID: <9910967.v2CO5Rsaj0@js-desktop.svl.corp.google.com>
References: <20171219221750.34148-1-junaids@google.com> <20171220044259.61106-2-junaids@google.com> <20171220083616.GB6565@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:44588 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755501AbdLTT2a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 14:28:30 -0500
Received: by mail-io0-f178.google.com with SMTP id w127so18492301iow.11
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 11:28:30 -0800 (PST)
In-Reply-To: <20171220083616.GB6565@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, December 20, 2017 12:36:16 AM PST Eric Biggers wrote:
>=20
> Did you run the self-tests (boot with CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> unset)?  The second patch causes them to start failing:
>=20
> [    1.169640] alg: aead: Test 7 failed on encryption for rfc4106-gcm-aes=
ni
> [    1.178308] alg: aead: Test 4 failed on encryption for generic-gcm-aes=
ni

Thanks for the pointer. Let me run the self-tests and see.

>=20
> Also, don't the AVX and AVX2 versions have the same bug?  These patches o=
nly fix
> the non-AVX version.

The AVX/AVX2 versions are used only when the data length is at least 640/4K=
 bytes respectively. Therefore, the first bug doesn=E2=80=99t apply at all.=
 The second bug does exist, but it won=E2=80=99t cause any ill effect at th=
e present time because the overrun will be covered by the data bytes. Howev=
er, I am planning to send out a separate patch series that allows for non-c=
ontiguous AAD, data and AuthTag buffers, which will cause the AAD overrun t=
o manifest even in the AVX versions, so I am going to include the AVX versi=
on fixes in that series.

>=20
> > +# read the last <16 byte block
> > +# Clobbers %rax, DPTR, TMP1 and XMM1-2
> > +.macro READ_PARTIAL_BLOCK DPTR DLEN TMP1 XMM1 XMM2 XMMDst
> > +        pxor \XMMDst, \XMMDst
> > +        mov \DLEN, \TMP1
> > +        cmp $8, \DLEN
> > +        jl _read_last_lt8_\@
> > +        mov (\DPTR), %rax
> > +        MOVQ_R64_XMM %rax, \XMMDst
> > +	add $8, \DPTR
> > +        sub $8, \TMP1
> > +        jz _done_read_last_partial_block_\@
> > +_read_last_lt8_\@:
> > +	shl $8, %rax
> > +        mov -1(\DPTR, \TMP1, 1), %al
> > +        dec \TMP1
> > +        jnz _read_last_lt8_\@
> > +        MOVQ_R64_XMM %rax, \XMM1
>=20
> Doesn't %rax needs to be zeroed at '_read_last_lt8' so that the padding is
> zeroed?
>=20

Ah, yes. It actually isn=E2=80=99t needed for the first patch, as in that c=
ase the result returned by this macro is masked appropriately at the call-s=
ites anyway. But that is not the case for the second patch. That is probabl=
y also the reason for the failures that you noticed.

> > +	# adjust the shuffle mask pointer to be able to shift either 0 or 8
> > +	# bytes depending on whether the last block is <8 bytes or not
> > +        mov \DLEN, \TMP1
> > +        and $8, \TMP1
> > +	lea SHIFT_MASK(%rip), %rax
> > +	sub \TMP1, %rax
> > +	movdqu (%rax), \XMM2		# get the appropriate shuffle mask
> > +	PSHUFB_XMM \XMM2, \XMM1		# shift left either 0 or 8 bytes
>=20
> Is there any way this can be simplified to use pslldq?  The shift is just=
 8
> bytes or nothing, and we already had to branch earlier depending on wheth=
er we
> needed to read the 8 bytes or not.

I am not sure if we can use a simple pslldq without either introducing anot=
her branch, or duplicating the _read_last_lt8 block for each case of the or=
iginal branch. Do you think that it is better to just duplicate the _read_l=
ast_lt8 block instead of using pshufb? Or do you have any other suggestion =
about how to do it?

Thanks,
Junaid
