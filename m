From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 28 Mar 2017 10:55:01 -0700
Message-ID: <20170328175501.GA117775@gmail.com>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170328054349.GA1023@zzz>
 <CAKv+Gu8P8ET541OPGa=cqPt4qLd4dkiNAztoOZ2mSR47KDYE7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "nico@linaro.org" <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36190 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbdC1RzY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 13:55:24 -0400
Received: by mail-pg0-f67.google.com with SMTP id 81so22973783pgh.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2017 10:55:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8P8ET541OPGa=cqPt4qLd4dkiNAztoOZ2mSR47KDYE7g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 28, 2017 at 09:51:54AM +0100, Ard Biesheuvel wrote:
> On 28 March 2017 at 06:43, Eric Biggers <ebiggers3@gmail.com> wrote:
> >
> > Just a thought: how about renaming CRYPTO_AES to CRYPTO_AES_GENERIC, then
> > renaming what you called CRYPTO_NEED_AES to CRYPTO_AES?  Then all the 'select
> > CRYPTO_AES' can remain as-is, instead of replacing them with the (in my opinion
> > uglier) 'select CRYPTO_NEED_AES'.  And it should still work for people who have
> > CRYPTO_AES=y or CRYPTO_AES=m in their kernel config, since they'll still get at
> > least one AES implementation (though they may stop getting the generic one).
> >
> > Also, in general I think we need better Kconfig help text.  As proposed you can
> > now toggle simply "AES cipher algorithms", and nowhere in the help text is it
> > mentioned that that is only the generic implementation, which you don't need if
> > you have enabled some other implementation.  Similarly for "Fixed time AES
> > cipher"; it perhaps should be mentioned that it's only useful if a fixed-time
> > implementation using special CPU instructions like AES-NI or ARMv8-CE isn't
> > usable.
> >
> 
> Thanks for the feedback. I take it you are on board with the general idea then?
> 
> Re name change, those are good points. I will experiment with that.
> 
> I was a bit on the fence about modifying the x86 code more than
> required, but actually, I think it makes sense for the AES-NI code to
> use fixed-time AES as a fallback rather than the table-based x86 code,
> given that the fallback is rarely used (only when executed in the
> context of an interrupt taken from kernel code that is already using
> the FPU) and falling back to a non-fixed time implementation loses
> some guarantees that the AES-NI code gives.

Definitely, I just feel it needs to be cleaned up a little so that the different
AES config options and modules aren't quite as confusing to those not as
familiar with them.

Did you also consider having 

	crypto_aes_set_key_generic()
and
	crypto_aes_expand_key_ti()
	crypto_aes_set_key_ti()

instead of crypto_aes_set_key() and crypto_aes_expand_key()?  As-is, it isn't
immediately clear which function is part of which module.

- Eric
