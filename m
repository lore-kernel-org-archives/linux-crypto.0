From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] ERA retrieval and printing for SEC device
Date: Wed, 11 Jul 2012 11:24:23 +0800
Message-ID: <20120711032423.GB5263@gondor.apana.org.au>
References: <1340783261-7494-1-git-send-email-alexandru.porosanu@freescale.com>
 <20120627145604.e9d27b9e8273be53aa4715fc@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Porosanu <alexandru.porosanu@freescale.com>,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:54613 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753282Ab2GKDYY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:24:24 -0400
Content-Disposition: inline
In-Reply-To: <20120627145604.e9d27b9e8273be53aa4715fc@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 27, 2012 at 07:56:04PM +0000, Kim Phillips wrote:
> From: Alex Porosanu <alexandru.porosanu@freescale.com>
> 
> This patch adds support for retrieving and printing of
> SEC ERA information. It is useful for knowing beforehand
> what features exist from the SEC point of view on a
> certain SoC. Only era-s 1 to 4 are currently supported;
> other eras will appear as unknown.
> 
> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> 
> - rebased onto current cryptodev master
> - made caam_eras static
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
