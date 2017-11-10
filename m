From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Fri, 10 Nov 2017 10:41:05 -0800
Message-ID: <20171110184105.GA99710@gmail.com>
References: <20171107061951.861-1-ebiggers3@gmail.com>
 <20171110113729.GD26163@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:40363 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbdKJSlK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 13:41:10 -0500
Content-Disposition: inline
In-Reply-To: <20171110113729.GD26163@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 10:37:30PM +1100, Herbert Xu wrote:
> On Mon, Nov 06, 2017 at 10:19:51PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> > largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> > doing modular exponentiation in mpi_powm() without rescheduling.  If all
> > threads do it, it locks up the system.  Moreover, it can cause
> > rcu_sched-stall warnings.
> > 
> > Notwithstanding the insanity of doing this calculation in kernel mode
> > rather than in userspace, fix it by calling cond_resched() as each bit
> > from the exponent is processed.  It's still noninterruptible, but at
> > least it's preemptible now.
> > 
> > Cc: stable@vger.kernel.org # v4.12+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Patch applied.  Thanks.
> -- 

If it's not too late can you fix the stable line to be just

	Cc: stable@vger.kernel.org

As Mat pointed out KEYCTL_DH_COMPUTE was actually introduced in v4.7.  Also I
think the code is also reachable through RSA by adding an x509 certificate using
the "asymmetric" key type, although that appears to be limited to 4096-bit
inputs rather than 16384 bits.

Eric
