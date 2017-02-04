From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sat, 4 Feb 2017 13:27:12 -0800
Message-ID: <20170204212712.GB5621@zzz>
References: <1486050988-20407-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170204212038.GA5621@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36377 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdBDV1Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2017 16:27:16 -0500
Received: by mail-pg0-f65.google.com with SMTP id 75so5205131pgf.3
        for <linux-crypto@vger.kernel.org>; Sat, 04 Feb 2017 13:27:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170204212038.GA5621@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 04, 2017 at 01:20:38PM -0800, Eric Biggers wrote:
> Unfortunately this is still broken, for two different reasons.  First, if the
> pointers have the same relative misalignment, then 'delta' and 'misalign' will
> be set to 0 and long accesses will be used, even though the pointers may
> actually be misaligned, e.g. 0x80000001 and 0x90000001.  Second, if the pointers
> have a relative misalignent that is not a power-of-2, then 'misalign' will be
> set to the wrong value.  For example, with delta=3, it's actually only safe to
> do byte accesses, but the code will set misalign=2 and do u16 accesses.
> 

Correction: for the second issue I think I mixed up ffs and fls, so that part of
the code was right.  But it may still be a good idea to separate out the
different cases.

Eric
