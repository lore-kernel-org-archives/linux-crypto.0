From: Stephan Mueller <smueller@chronox.de>
Subject: Re: hashing bit oriented messages
Date: Mon, 12 Feb 2018 08:04:14 +0100
Message-ID: <2213507.qOU7YnA10s@tauon.chronox.de>
References: <CAEux+EMLLZVj3nA31nHAtFica2HTdSAb=E=7g6WR3z45sXoZ8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: lullajd@yahoo.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:21785 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbeBLHEQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 02:04:16 -0500
In-Reply-To: <CAEux+EMLLZVj3nA31nHAtFica2HTdSAb=E=7g6WR3z45sXoZ8g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 12. Februar 2018, 07:18:20 CET schrieb Jitendra Lulla:

Hi Jitendra,

> Hi,
> 
> the following NIST link has test vectors for SHA1/2/3.
> https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/se
> cure-hashing
> 
> They have test vectors for bit oriented messages also e.g. a message
> of 7 bits for example. [grep "Bit-Oriented" on the page, bottom of the
> page]
> 
> Some sw implementations do support computing SHA* on such messages
> which are not byte aligned.
> 
> e.g. libdigest-sha3-perl and  libdigest-sha-perl  (tried on Ubuntu)
> Some example runs at the bottom of this mail.
> 
> I have following queries, could anybody please help me with them:
> 
> 1. When would one want to compute digests on such messages eg. a 7 bit
> message or a 133 bit message? Any practical use case?

There are no use cases in the kernel that require non-byte aligned ciphers

> 2. testmgr.h doesnt have tests for such messages. Does linux kernel
> crypto framework support it or have plans for it?

No.

> 3. Does any fips certification mandate bit-oriented tests to pass ?

No.

Ciao
Stephan
