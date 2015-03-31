From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 resend 01/14] crypto: sha512: implement base layer for
 SHA-512
Date: Tue, 31 Mar 2015 21:14:46 +0800
Message-ID: <20150331131446.GA17133@gondor.apana.org.au>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
 <1427708913-29678-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, jussi.kivilinna@iki.fi,
	stockhausen@collogia.de, x86@kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38418 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbbCaNPF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 09:15:05 -0400
Content-Disposition: inline
In-Reply-To: <1427708913-29678-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 30, 2015 at 11:48:20AM +0200, Ard Biesheuvel wrote:
> To reduce the number of copies of boilerplate code throughout
> the tree, this patch implements generic glue for the SHA-512
> algorithm. This allows a specific arch or hardware implementation
> to only implement the special handling that it needs.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Creating yet another module for this is too much.  Please just
add these generic helpers to the generic module.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
