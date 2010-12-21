From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: fix af_alg memory_allocated data type
Date: Tue, 21 Dec 2010 22:22:59 +1100
Message-ID: <20101221112259.GA26409@gondor.apana.org.au>
References: <20101216173745.264eb2ca.sfr@canb.auug.org.au> <20101216101800.36529e89.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101216101800.36529e89.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 16, 2010 at 10:18:00AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change data type to fix warning:
> 
> crypto/af_alg.c:35: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.  Thanks Randy!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
