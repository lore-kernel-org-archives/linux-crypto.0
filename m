From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx - fix concurrency issue
Date: Wed, 14 Aug 2013 20:49:40 +1000
Message-ID: <20130814104937.GC13403@gondor.apana.org.au>
References: <1376344177-7205-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376344177-7205-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 12, 2013 at 06:49:37PM -0300, Marcelo Cerri wrote:
> The NX driver uses the transformation context to store several fields
> containing data related to the state of the operations in progress.
> Since a single tfm can be used by different kernel threads at the same
> time, we need to protect the data stored into the context.
> 
> This patch makes use of spin locks to protect the data where a race
> condition can happen.
> 
> Reviewed-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
