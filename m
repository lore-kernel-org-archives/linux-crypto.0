From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/3] AES: group common functions
Date: Wed, 24 Oct 2007 13:50:27 +0800
Message-ID: <20071024055027.GA6331@gondor.apana.org.au>
References: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1193073734-15789-2-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1743 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408AbXJXFua (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2007 01:50:30 -0400
Content-Disposition: inline
In-Reply-To: <1193073734-15789-2-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 22, 2007 at 07:22:12PM +0200, Sebastian Siewior wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> There are three AES softwore modules in the kernel: One C version
> and two arch specific assembly versions. The key expansion routine as
> well as the the four lookup tables which are used during encryption
> and/or decryption are the same.
> This patch simply creates an independent module which shares the
> data structures across the modules.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Thanks, the patch looks fine.

However, instead of creating yet another module like twofish,
how about just making the assembly versions depend on the 
generic version for these functions?

In fact, that's how we should've handled twofish as well.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
