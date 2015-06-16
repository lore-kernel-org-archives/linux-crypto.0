From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 09/11] crypto: caam - Fix incorrect size when DMA
 unmapping buffer
Date: Tue, 16 Jun 2015 14:41:30 +0800
Message-ID: <20150616064129.GB22176@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-10-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52928 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbbFPGld (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:41:33 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-10-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:57PM -0700, Victoria Milhoan wrote:
> The CAAM driver uses two data buffers to store data for a hashing operation,
> with one buffer defined as active. This change forces switching of the
> active buffer when executing a hashing operation to avoid a later DMA unmap
> using the length of the opposite buffer.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
