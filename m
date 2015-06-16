From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 08/11] crypto: caam - improve initalization for
 context state saves
Date: Tue, 16 Jun 2015 14:41:16 +0800
Message-ID: <20150616064116.GA22176@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-9-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55095 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbFPGlT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:41:19 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-9-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:56PM -0700, Victoria Milhoan wrote:
> From: Steve Cornelius <steve.cornelius@freescale.com>
> 
> Multiple function in asynchronous hashing use a saved-state block,
> a.k.a. struct caam_hash_state, which holds a stash of information
> between requests (init/update/final). Certain values in this state
> block are loaded for processing using an inline-if, and when this
> is done, the potential for uninitialized data can pose conflicts.
> Therefore, this patch improves initialization of state data to
> prevent false assignments using uninitialized data in the state block.

Applied to crypto with stable CC.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
