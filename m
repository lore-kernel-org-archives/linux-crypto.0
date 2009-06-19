From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 19 Jun 2009 22:38:43 +0800
Message-ID: <20090619143843.GA20415@gondor.apana.org.au>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38446 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751231AbZFSOim (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 10:38:42 -0400
Content-Disposition: inline
In-Reply-To: <20090619125500.GA18153@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:55:00AM -0400, Neil Horman wrote:
>
> Thanks!  Thats definately an oversight.  Likely I included it because I was
> implementing it as part of the FIPS effort.  The CPRNG definately works fine,
> even if fips is disabled.  Although I think the relationship should be reversed,
> not just removed, as FIPS support requires the use of the CPRNG.  Something like
> this:

Thanks, I'll add your patch on top.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
