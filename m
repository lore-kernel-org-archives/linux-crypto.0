From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/mpi: clean unused SHA1_DIGEST_LENGTH
Date: Tue, 20 Oct 2015 22:19:39 +0800
Message-ID: <20151020141939.GA7625@gondor.apana.org.au>
References: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
 <1444934124-3883-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46114 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbJTOTo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 10:19:44 -0400
Content-Disposition: inline
In-Reply-To: <1444934124-3883-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 08:34:53PM +0200, LABBE Corentin wrote:
> The define SHA1_DIGEST_LENGTH is not used anywhere, so remove it.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
