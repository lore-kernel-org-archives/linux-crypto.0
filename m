From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] random: prime last_data value per fips requirements
Date: Thu, 8 Nov 2012 07:20:01 -0500
Message-ID: <20121108122001.GC5859@thunk.org>
References: <1352216153-25359-1-git-send-email-jarod@redhat.com>
 <1352216562-25659-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Neil Horman <nhorman@tuxdriver.com>,
	Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352216562-25659-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 06, 2012 at 10:42:42AM -0500, Jarod Wilson wrote:
> The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
> first use, either on system startup or after an RNDCLEARPOOL ioctl, we
> need to take an initial random sample, store it internally in last_data,
> then pass along the value after that to the requester, so that consistency
> checks aren't being run against stale and possibly known data.
> 
> v2: streamline code flow a bit, eliminating extra loop and spinlock in the
> case where we need to prime, and account for the extra primer bits.
> 
> v3: extract_buf() can't be called with spinlock already held, so bring
> back some extra lock/unlock calls.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Matt Mackall <mpm@selenic.com>
> CC: linux-crypto@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Thanks, applied to the /dev/random git tree.

						- Ted
