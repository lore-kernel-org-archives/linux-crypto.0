From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ablkcipher - fixed style errors in ablkcipher.c
Date: Mon, 22 Dec 2014 23:04:25 +1100
Message-ID: <20141222120425.GA21073@gondor.apana.org.au>
References: <1417755976-19514-1-git-send-email-Joshua@cybercrimetech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Joshua I. James" <joshua@cybercrimetech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58999 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaLVME3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Dec 2014 07:04:29 -0500
Content-Disposition: inline
In-Reply-To: <1417755976-19514-1-git-send-email-Joshua@cybercrimetech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2014 at 02:06:16PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style errors reported by checkpatch.
> 
> WARNING: Missing a blank line after declarations
> +       u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
> +       return max(start, end_page);
> 
> WARNING: line over 80 characters
> +               scatterwalk_start(&walk->out, scatterwalk_sg_next(walk->out.sg));
> 
> WARNING: Missing a blank line after declarations
> +               int err = ablkcipher_copy_iv(walk, tfm, alignmask);
> +               if (err)
> 
> ERROR: do not use assignment in if condition
> +       if ((err = crypto_register_instance(tmpl, inst))) {
> 
> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>

All five patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
