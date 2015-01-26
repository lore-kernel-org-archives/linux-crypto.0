From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/3] SHA256 for PPC/SPE
Date: Mon, 26 Jan 2015 11:18:43 +1100
Message-ID: <20150126001842.GA18477@gondor.apana.org.au>
References: <5ad377b3-e491-4c35-8b89-de1dfd0749a6@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54856 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAZASs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 19:18:48 -0500
Content-Disposition: inline
In-Reply-To: <5ad377b3-e491-4c35-8b89-de1dfd0749a6@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Markus Stockhausen <stockhausen@collogia.de> wrote:
> 
> [PATCH v1 0/3] SHA256 for PPC/SPE
> 
> The following patches add support for SIMD accelerated SHA256 
> calculation on PPC processors with SPE instruction set. The 
> implementation takes care of the following constraints:
> 
> - independant of processor endianess
> - fallback to generic code if called from interrupt context
> - disable preemtion only for short intervals

Thanks for the patch! Unfortunately the interrupt context test
is a bummer because that means your code won't be used by IPsec
at all.

Would it be possible to relax the conditions similar to sha1_ssse3
on x86? If not how about going async with cryptd?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
