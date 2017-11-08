From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Wed, 8 Nov 2017 11:18:04 -0800
Message-ID: <20171108191804.GA74965@gmail.com>
References: <20171107221527.98433-1-ebiggers3@gmail.com>
 <25888.1510145417@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:50744 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdKHTSI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 14:18:08 -0500
Content-Disposition: inline
In-Reply-To: <25888.1510145417@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Wed, Nov 08, 2017 at 12:50:17PM +0000, David Howells wrote:
> Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> > On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> > largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> > doing modular exponentiation in mpi_powm() without rescheduling.  If all
> > threads do it, it locks up the system.  Moreover, it can cause
> > rcu_sched-stall warnings.
> 
> Do you want this to go in immediately, or I should I push it to James for the
> next merge window?
> 
> David

This probably should be grouped with my series "crypto: dh - input validation
fixes", as this is also a fix for Diffie-Hellman.  I was actually expecting
Herbert Xu to take these patches, as Diffie-Hellman is now part of the crypto
API (crypto/dh.c); none of the patches actually touch security/keys/.  If you'd
like to maintain the Diffie-Hellman implementation(s) you should get yourself
added to MAINTAINERS for the relevant files.

As for the criticality of the fixes, the code is new in v4.12, so I doubt many
people have CONFIG_KEY_DH_OPERATIONS=y enabled yet.  syzbot doesn't actually
have it enabled either (we should turn it on); I just happened to find these
bugs by running syzkaller myself.  So it may not be particularly critical to
take these fixes immediately.  However, at least the fix for the double free bug
("crypto: dh - Fix double free of ctx->p") shouldn't wait for too long...

Eric
