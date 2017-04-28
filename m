From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 0/5] KEYS: fixes for new keyctl_dh_compute() KDF extension
Date: Fri, 28 Apr 2017 17:56:03 +0200
Message-ID: <2296178.cJbEENo9rQ@tauon.chronox.de>
References: <20170420054633.14572-1-ebiggers3@gmail.com> <791.1493394780@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59338 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2998876AbdD1P4G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Apr 2017 11:56:06 -0400
In-Reply-To: <791.1493394780@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. April 2017, 17:53:00 CEST schrieb David Howells:

Hi David,

> Stephan,
> 
> Eric Biggers <ebiggers3@gmail.com> wrote:
> > This patch series fixes several bugs in the KDF extension to
> > keyctl_dh_compute() currently sitting in keys-next: a way userspace could
> > cause an infinite loop, two ways userspace could cause the use of
> > uninitialized memory, a misalignment, and missing __user annotations.
> 
> Do you want to ack these or do they need fixing?

All patches except patch 3/5:

Acked-by: Stephan Mueller <smueller@chronox.de>

For the patch 3/5 I would send an updated patch shortly which changes the 
kmalloc to kzalloc.

Ciao
Stephan
