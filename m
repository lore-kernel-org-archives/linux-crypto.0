From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390/crypto: fix aes,des ctr mode concurrency finding.
Date: Thu, 8 May 2014 22:02:11 +0800
Message-ID: <20140508140211.GE13769@gondor.apana.org.au>
References: <1399474290-2332-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Hendrik Brueckner <brueckner@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	stable@vger.kernel.org
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1399474290-2332-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 07, 2014 at 04:51:29PM +0200, Harald Freudenberger wrote:
> An additional testcase found an issue with the last
> series of patches applied: the fallback solution may
> not save the iv value after operation. This very small
> fix just makes sure the iv is copied back to the
> walk/desc struct.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
