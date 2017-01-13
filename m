From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Fri, 13 Jan 2017 16:43:49 +0800
Message-ID: <20170113084349.GE22022@gondor.apana.org.au>
References: <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170112201511.yj5ekqmj76r2yv6t@treble>
 <CALCETrXom8aY2XhpAyOtAwQQYF7wftBHJE_px1xr0iRmcYEJoA@mail.gmail.com>
 <20170113031107.mgitq54fmjnrvi6f@treble>
 <CALCETrUFCFn-rKnr+NG3SU7J78ree9siJC=Kz8f_Bk6eG2HyPA@mail.gmail.com>
 <20170113042758.whof5fk6eu7myctq@treble>
 <CA+55aFzRrSwGxxfZk-RUEnsz=xhcSmOwE1CenfCPBWtsS9MwDw@mail.gmail.com>
 <20170113050709.yrdtfet5d4sebubi@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34325 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751222AbdAMIo1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 03:44:27 -0500
Content-Disposition: inline
In-Reply-To: <20170113050709.yrdtfet5d4sebubi@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 11:07:09PM -0600, Josh Poimboeuf wrote:
> 
> Disabling frame pointers didn't seem to help, but I finally got it to
> misalign with a different test case.  I think it had been aligning the
> array, so instead I made it push a register.

Right.  If you start manipulating the stack directly then all bets
are off.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
