From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Fri, 10 Nov 2017 22:37:30 +1100
Message-ID: <20171110113729.GD26163@gondor.apana.org.au>
References: <20171107061951.861-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107061951.861-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 06, 2017 at 10:19:51PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> doing modular exponentiation in mpi_powm() without rescheduling.  If all
> threads do it, it locks up the system.  Moreover, it can cause
> rcu_sched-stall warnings.
> 
> Notwithstanding the insanity of doing this calculation in kernel mode
> rather than in userspace, fix it by calling cond_resched() as each bit
> from the exponent is processed.  It's still noninterruptible, but at
> least it's preemptible now.
> 
> Cc: stable@vger.kernel.org # v4.12+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
