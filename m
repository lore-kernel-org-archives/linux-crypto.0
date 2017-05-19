From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: x86/aes - Don't use %rbp as temporary register
Date: Thu, 18 May 2017 19:50:17 -0700
Message-ID: <20170519025017.GA14204@zzz>
References: <20170517040308.406-1-ebiggers3@gmail.com>
 <20170517204427.lwvzonoa26paoitk@treble>
 <20170517222141.GA60476@gmail.com>
 <20170519015632.byuezk5ky22rqnkt@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35534 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756044AbdESCuU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 22:50:20 -0400
Content-Disposition: inline
In-Reply-To: <20170519015632.byuezk5ky22rqnkt@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 18, 2017 at 08:56:32PM -0500, Josh Poimboeuf wrote:
> > 
> > Hmm, it looks like a number of other algorithms in arch/x86/crypto/ use %rbp (or
> > %ebp), e.g. blowfish, camellia, cast5, and aes-i586.  Presumably they have the
> > same problem.  I'm a little confused: do these all need to be fixed, and
> > when/why did this start being considered broken?
> 
> This warning was only recently added, with the goal of flushing out
> these types of issues with hand-coded asm to make frame pointer based
> stack traces more reliable.  I can take a look at fixing the rest of
> them if you want.
> 

Okay.  I'm worried you might run into one that is difficult to fix due to lack
of spare registers.  But if you're interested in looking into it, please go
ahead.  Thanks!

Eric
