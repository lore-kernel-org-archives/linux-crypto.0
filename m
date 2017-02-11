From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: cavium: Use per device name to allow for multiple
 devices.
Date: Sat, 11 Feb 2017 18:56:46 +0800
Message-ID: <20170211105646.GK855@gondor.apana.org.au>
References: <20170206222846.22493-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org,
        Omer Khaliq <okhaliq@caviumnetworks.com>,
        Ananth Jasty <Ananth.Jasty@cavium.com>
To: David Daney <david.daney@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206222846.22493-1-david.daney@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 06, 2017 at 02:28:46PM -0800, David Daney wrote:
> Systems containing the Cavium HW RNG may have one device per NUMA
> node.  A typical configuration is a 2-node NUMA system, which results
> in 2 RNG devices.  The hwrng subsystem refuses (and rightly so) to
> register more than one device with he same name, so we get failure
> messages on these systems.
> 
> Make the hwrng name unique by including the underlying device name.
> Also remove spaces from the name to make it possible to switch devices
> via the sysfs knobs.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
