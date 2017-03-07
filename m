From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] MIPS: Fix build breakage caused by header file changes
Date: Tue, 7 Mar 2017 11:34:52 +0100
Message-ID: <20170307103452.GA13056@gmail.com>
References: <1488827635-7708-1-git-send-email-linux@roeck-us.net>
 <20170306232019.GG2878@jhogan-linux.le.imgtec.org>
 <20170307073805.GB15693@gmail.com>
 <20170307093850.GD996@jhogan-linux.le.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34666 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751766AbdCGKf3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 05:35:29 -0500
Content-Disposition: inline
In-Reply-To: <20170307093850.GD996@jhogan-linux.le.imgtec.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* James Hogan <james.hogan@imgtec.com> wrote:

> Hi Ingo,
> 
> On Tue, Mar 07, 2017 at 08:38:05AM +0100, Ingo Molnar wrote:
> > Just a quick question: is your MIPS build fix going to be merged and sent to 
> > Linus? I can apply it too, and send it to Linus later today, together with a few 
> > other sched.h header related build fixes.
> 
> One for Ralf...

Ralf, what's your preference?

> > Assuming it's all properly tested - my limited MIPS defconfig builds worked fine - 
> > but MIPS has a lot of build variations.
> 
> If you have a branch with other generic fixes I'm happy to push it to
> our MIPS buildbot too to double check.

So I have not applied your patch yet (can do it with ack from Ralf), but all the 
other fixes that are pending can be found in:

  git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/urgent

It's these commits:

 bb35e4515411 drivers/char/nwbutton: Fix build breakage caused by include file reshuffling
 80aa1a54f054 h8300: Fix build breakage caused by header file changes
 1fbdbcea8005 avr32: Fix build error caused by include file reshuffling

Thanks,

	Ingo
