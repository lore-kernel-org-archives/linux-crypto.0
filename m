From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 0/7] crypto: aes - allow generic AES to be omitted
Date: Mon, 27 Mar 2017 22:43:49 -0700
Message-ID: <20170328054349.GA1023@zzz>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        nico@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36615 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbdC1Fnx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 01:43:53 -0400
Received: by mail-pg0-f66.google.com with SMTP id 81so18566072pgh.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2017 22:43:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ard,

On Sun, Mar 26, 2017 at 07:49:01PM +0100, Ard Biesheuvel wrote:
> The generic AES driver uses 16 lookup tables of 1 KB each, and has
> encryption and decryption routines that are fully unrolled. Given how
> the dependencies between this code and other drivers are declared in
> Kconfig files, this code is always pulled into the core kernel, even
> if it is usually superseded at runtime by accelerated drivers that
> exist for many architectures.
> 
> This leaves us with 25 KB of dead code in the kernel, which is negligible
> in typical environments, but which is actually a big deal for the IoT
> domain, where every kilobyte counts.
> 
> For this reason, this series refactors the way the various AES
> implementations are wired up, to allow the generic version in
> crypto/aes_generic.c to be omitted from the build entirely.
> 
> Patch #1 removes some bogus 'select CRYPTO_AES' statement.
> 
> Patch #2 introduces CRYPTO_NEED_AES which can be selected by driver that
> require an AES cipher to be available, but don't care how it is implemented.
> 
> Patches #3 and #4 make some preparatory changes that allow dependencies on
> crypto_aes_expand_key to be fulfilled by the new (and much smaller) fixed
> time AES driver. (#5)
> 
> Patch #6 splits the generic AES driver into a core containing the precomputed
> sub/shift/mix tables and the key expansion routines on the one hand, and the
> encryption/decryption routines and the crypto API registration on the other.
> 
> Patch #7 introduces the CRYPTO_HAVE_AES Kconfig symbol, and adds statements to
> various AES implementations that can fulfil the CRYPTO_NEED_AES dependencies
> added in patch #2. The introduced Kconfig logic allows CRYPTO_AES to be
> deselected even if AES dependencies exist, as long as one of these alternatives
> is selected.

Just a thought: how about renaming CRYPTO_AES to CRYPTO_AES_GENERIC, then
renaming what you called CRYPTO_NEED_AES to CRYPTO_AES?  Then all the 'select
CRYPTO_AES' can remain as-is, instead of replacing them with the (in my opinion
uglier) 'select CRYPTO_NEED_AES'.  And it should still work for people who have
CRYPTO_AES=y or CRYPTO_AES=m in their kernel config, since they'll still get at
least one AES implementation (though they may stop getting the generic one).

Also, in general I think we need better Kconfig help text.  As proposed you can
now toggle simply "AES cipher algorithms", and nowhere in the help text is it
mentioned that that is only the generic implementation, which you don't need if
you have enabled some other implementation.  Similarly for "Fixed time AES
cipher"; it perhaps should be mentioned that it's only useful if a fixed-time
implementation using special CPU instructions like AES-NI or ARMv8-CE isn't
usable.

- Eric
