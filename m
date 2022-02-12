Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45466C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Feb 2022 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiBLXWL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Feb 2022 18:22:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbiBLXWK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Feb 2022 18:22:10 -0500
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 15:22:06 PST
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DEEA5FF08;
        Sat, 12 Feb 2022 15:22:05 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 5036892009C; Sun, 13 Feb 2022 00:13:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4182F92009B;
        Sat, 12 Feb 2022 23:13:33 +0000 (GMT)
Date:   Sat, 12 Feb 2022 23:13:33 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Joshua Kinard <kumba@gentoo.org>
cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH RFC v0] random: block in /dev/urandom
In-Reply-To: <fcab986b-d0bd-c798-de17-266abcdc7da2@gentoo.org>
Message-ID: <alpine.DEB.2.21.2202122309560.34636@angie.orcam.me.uk>
References: <20220211210757.612595-1-Jason@zx2c4.com> <fcab986b-d0bd-c798-de17-266abcdc7da2@gentoo.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 12 Feb 2022, Joshua Kinard wrote:

> # grep -r "PRID_IMP_R6000" *
> arch/mips/include/asm/cpu.h:70:#define PRID_IMP_R6000           0x0300
>     /* Same as R3000A  */
> arch/mips/include/asm/cpu.h:72:#define PRID_IMP_R6000A          0x0600
> arch/mips/include/asm/timex.h:94:       else if (likely(imp !=
> PRID_IMP_R6000 && imp != PRID_IMP_R6000A))
> 
> I'd say it's better to remove the check and simplify the conditional to
> eliminate this corner case.  Maybe keep the #defines around for
> documentation, but even that may not be necessary for CPUs that likely don't
> exist anymore.

 IIRC Ralf used to have a working R6k machine, but I have no idea what has 
happened to it.  No port of Linux has been made for that system though, 
that's for sure.

  Maciej
