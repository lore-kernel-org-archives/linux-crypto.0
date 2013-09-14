From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 2/2] arm64: add support for AES using ARMv8 Crypto
	Extensions
Date: Sat, 14 Sep 2013 16:18:12 +0100
Message-ID: <20130914151812.GJ12758@n2100.arm.linux.org.uk>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org> <1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org> <5234196D.9050101@iki.fi> <CAKv+Gu9fCaaTVyCt-r-ijpqYDo4LTfvzrorzjWWCYMM17QUOQA@mail.gmail.com> <52346EA9.3020802@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nicolas Pitre <nico@linaro.org>,
	Steve Capper <steve.capper@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm@lists.infradead.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54827 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3IOOEi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 10:04:38 -0400
Content-Disposition: inline
In-Reply-To: <52346EA9.3020802@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 14, 2013 at 05:11:53PM +0300, Jussi Kivilinna wrote:
> On 14.09.2013 16:30, Ard Biesheuvel wrote:
> > On 14 September 2013 10:08, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> >> On 13.09.2013 18:08, Ard Biesheuvel wrote:
> >>> This adds ARMv8 Crypto Extensions based implemenations of
> >>> AES in CBC, CTR and XTS mode.
> >>>
> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>> ---
> >> ..snip..
> >>> +static int xts_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> >>> +                    unsigned int key_len)
> >>> +{
> >>> +     struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
> >>> +     u32 *flags = &tfm->crt_flags;
> >>> +     int ret;
> >>> +
> >>> +     ret = crypto_aes_expand_key(&ctx->key1, in_key, key_len/2);
> >>> +     if (!ret)
> >>> +             ret = crypto_aes_expand_key(&ctx->key2, &in_key[key_len/2],
> >>> +                                         key_len/2);
> >>
> >> Use checkpatch.
> >>
> > 
> > Um, I did get a bunch of errors and warnings from checkpatch.pl tbh,
> > put not in this particular location. Care to elaborate?
> > 
> 
> Well, the checkpatch.pl I had stored to brain had become corrupted and kept
> saying that you need spaces around all operators. But apparently spaces are
> just required for assignment operators.

checkpatch is not definitive.  It is merely an implementation of the
coding style.  The coding style is the definitive documentation, and
it says about this:

| Use one space around (on each side of) most binary and ternary operators,
| such as any of these:
|
|        =  +  -  <  >  *  /  %  |  &  ^  <=  >=  ==  !=  ?  :
|
| but no space after unary operators:
|        &  *  +  -  ~  !  sizeof  typeof  alignof  __attribute__  defined
|
| no space before the postfix increment & decrement unary operators:
|        ++  --
|
| no space after the prefix increment & decrement unary operators:
|        ++  --
|
| and no space around the '.' and "->" structure member operators.

So, you're quite right that the above is wrong.  It needs spaces around the
"/" operators.
