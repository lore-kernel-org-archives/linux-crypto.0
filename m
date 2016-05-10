From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: fix caam_jr_alloc() ret code
Date: Tue, 10 May 2016 17:54:12 +0800
Message-ID: <20160510095412.GA15945@gondor.apana.org.au>
References: <1462540733-2170-2-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto-owner@vger.kernel.org,
	horia.geanta@nxp.com, alexandru.porosanu@nxp.com,
	scott.wood@nxp.com, cata.vasile@nxp.com
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55717 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbcEJJyR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 May 2016 05:54:17 -0400
Content-Disposition: inline
In-Reply-To: <1462540733-2170-2-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Catalin Vasile <cata.vasile@nxp.com> wrote:
> caam_jr_alloc() used to return NULL if a JR device could not be
> allocated for a session. In turn, every user of this function used
> IS_ERR() function to verify if anything went wrong, which does NOT look
> for NULL values. This made the kernel crash if the sanity check failed,
> because the driver continued to think it had allocated a valid JR dev
> instance to the session and at some point it tries to do a caam_jr_free()
> on a NULL JR dev pointer.
> This patch is a fix for this issue.
> 
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
