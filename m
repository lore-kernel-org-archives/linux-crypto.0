From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] [crypto] testmgr: add xts-aes-256 self-test
Date: Tue, 31 May 2011 15:24:42 +1000
Message-ID: <20110531052442.GB17068@gondor.apana.org.au>
References: <1306348377-14494-1-git-send-email-jarod@redhat.com> <1306511973-650-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50020 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1EaFYq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2011 01:24:46 -0400
Content-Disposition: inline
In-Reply-To: <1306511973-650-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 27, 2011 at 11:59:33AM -0400, Jarod Wilson wrote:
> FIPS compliance requires a known-answer self-test for all approved
> cipher and mode combinations, for all valid key sizes. Presently,
> there are only self-tests for xts-aes-128. This adds a 256-bit one,
> pulled from the same reference document, which should satisfy the
> requirement.
> 
> v2: properly increment vector count definitions
> 
> CC: CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks Jarod!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
