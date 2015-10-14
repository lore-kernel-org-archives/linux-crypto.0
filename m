From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.3
Date: Wed, 14 Oct 2015 09:03:04 +0800
Message-ID: <20151014010304.GA12430@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20150916103014.GA12315@gondor.apana.org.au>
 <20150926200133.GA19035@gondor.apana.org.au>
 <20151013121750.GA6408@gondor.apana.org.au>
 <CA+55aFz0ZdjpC_FpM6h=z_boK8HeKzgt_7Zm14TnrZYqx1SaUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50217 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbJNBDc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 21:03:32 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFz0ZdjpC_FpM6h=z_boK8HeKzgt_7Zm14TnrZYqx1SaUQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 10:23:39AM -0700, Linus Torvalds wrote:
>
> Hmm. It looks like you also quietly added a ahash fix this morning.
> 
> I took it despite it not being described or in the diffstat. But
> please send new pull requests when you update a branch you asked me to
> pull.

Oops, I should've waited for you to pull the previous one before
pushing this one out.

Anyway, this one is meant to fix a potential crash that can be
triggered by user-space but only if you have the relevant hardware,
in particular, Marvell CESA on ARM.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
