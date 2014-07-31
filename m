From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: properly label AF_ALG socket
Date: Thu, 31 Jul 2014 21:55:59 +0800
Message-ID: <20140731135559.GA5777@gondor.apana.org.au>
References: <20140728150958.23156.75132.stgit@localhost>
 <1406659269-8346-1-git-send-email-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, selinux@tycho.nsa.gov,
	pmoore@redhat.com, stable@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406659269-8346-1-git-send-email-gmazyland@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 29, 2014 at 06:41:09PM +0000, Milan Broz wrote:
> Th AF_ALG socket was missing a security label (e.g. SELinux)
> which means that socket was in "unlabeled" state.
> 
> This was recently demonstrated in the cryptsetup package
> (cryptsetup v1.6.5 and later.)
> See https://bugzilla.redhat.com/show_bug.cgi?id=1115120
> 
> This patch clones the sock's label from the parent sock
> and resolves the issue (similar to AF_BLUETOOTH protocol family).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Applied to crypto.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
