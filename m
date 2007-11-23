From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Fri, 23 Nov 2007 19:59:44 +0800
Message-ID: <20071123115944.GB18862@gondor.apana.org.au>
References: <fd3e431c0711211317rcec242t88fb44fba3def1ae@mail.gmail.com> <fd3e431c0711211339x1f77a11cs7c6bed8501561042@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2308 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664AbXKWL7s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 06:59:48 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711211339x1f77a11cs7c6bed8501561042@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 05:39:07AM +0800, Tan Swee Heng wrote:
> Forgot the attachment... again. :-)
> 
> On Nov 22, 2007 5:17 AM, Tan Swee Heng <thesweeheng@gmail.com> wrote:
> > This patch implements the glue code that uses the Salsa20 x86-pm
> > assembly code written by D. J. Bernstein.
> > Original assembly code is available at
> > <http://cr.yp.to/snuffle/salsa20/x86-pm/salsa20.s>.
> >
> > Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Could you please reformat this so that it's more in-line with
what's already in arch/x86/crypto? In particular, indentation
for the code would be nice :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
