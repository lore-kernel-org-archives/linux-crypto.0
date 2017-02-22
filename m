From: Nicolas Porcel <nicolasporcel06@gmail.com>
Subject: Re: crypto: xts: regression in 4.10
Date: Thu, 23 Feb 2017 00:02:08 +0100
Message-ID: <20170222230208.GA5049@nicolas-laptop>
References: <20170221231717.GA7186@nicolas-laptop>
 <fb8a2f22-053e-7b30-6f0f-58158c832ad5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36663 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbdBVXDk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 18:03:40 -0500
Received: by mail-wm0-f66.google.com with SMTP id r18so2950394wmd.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2017 15:02:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <fb8a2f22-053e-7b30-6f0f-58158c832ad5@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 22, 2017 at 12:31:30PM +0100, Milan Broz wrote:
> Kernel 4.10 works with LUKS and XTS in general (otherwise I would scream much earlier:-)

I was surprised that it was still broken in the mainline release. All
the other regressions I had have been fixed. Also, I guess LUKS with
aes-xts is quite standard.

> I guess either there is a bug in some specific dependency missing
> dependency in kernel config. Could you send your kernel .config that fails?
> 
> Do you have ECB mode compiled-in as well?

Nice guess. I had ECB enabled as a module, and I don't think it was
present in the initramfs. Compiling it in the kernel solves the problem.
Thanks for the clue!

I now have the xts(ecb(aes-generic)) driver appearing in /proc/crypto.
I had no xts driver before.

I don't think it's necessary now to copy my kernel config. Also, it's
quite minimalist: make defconfig with a few drivers I need, mostly compiled
in the kernel.

> (See commit description, shouldn't XTS now select ECB as well? This seems to me
> like a bug...)

I was actually confused by the message, I thought it would fallback to
the old implementation. I guess the XTS module should select ECB if
that's not the case. Should I submit a patch for that? Or maybe it would
be easier if a maintainer directly makes the change?

> What mail on dmcrypt list? I do not see any recent mail.

It was a mail from 2012, I should be more careful with search engines...

-- 
Nicolas Porcel
