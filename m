From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Fri, 13 Jan 2017 16:38:41 +0800
Message-ID: <20170113083841.GB22022@gondor.apana.org.au>
References: <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au>
 <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170112201511.yj5ekqmj76r2yv6t@treble>
 <20170112205504.gb6z2w52mektyc73@treble>
 <CA+55aFwkodRf3QM+GLzq5G4F7fp+=ds-cHJRtCgJczMZgVx6Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33827 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751226AbdAMIjM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 03:39:12 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFwkodRf3QM+GLzq5G4F7fp+=ds-cHJRtCgJczMZgVx6Ug@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:40:54PM -0800, Linus Torvalds wrote:
> 
> The 8-byte alignment mainly makes sense when the basic call sequence
> just adds 8 bytes, and you have functions without frames (that still
> call other functions).

The question is does it really make sense to save those 8 bytes
of padding on x86-64 when arm64 apparently also requires 16-byte
stack alignment.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
