From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in
	fips mode
Date: Mon, 4 May 2009 19:10:10 +0800
Message-ID: <20090504111010.GA4991@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755823AbZEDLKt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200904282118.22823.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> have automated self-tests for counter-mode AES, but people are
> misled to believe something is wrong by the message that says there
> is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> messages if fips_enabled is set to avoid confusion.

This is not true at all.  In our implementation the counter is
set through the IV so it definitely is possible to test counter
mode algorithms in Linux.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
