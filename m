From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when
	checking whether copying is required
Date: Tue, 3 Nov 2009 10:32:33 -0500
Message-ID: <20091103153233.GB9186@gondor.apana.org.au>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com> <20091028072559.GA15131@gondor.apana.org.au> <20091102172650.6af2d177@katamari.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754027AbZKCPce@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091102172650.6af2d177@katamari.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 02, 2009 at 05:26:50PM -0500, Chuck Ebbert wrote:
> crypto: padlock-aes: Use the correct mask when checking whether copying is required
> 
> Masking with PAGE_SIZE is just wrong...
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Applied to crypto-2.6.  Thanks Chuck!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
