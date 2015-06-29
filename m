From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.2
Date: Mon, 29 Jun 2015 16:32:28 +0900
Message-ID: <20150629073228.GA11020@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <CA+55aFwvyJkQXxTLzgtwv4wMmvwVtKdPMsNa05CgaKop9vQ1NQ@mail.gmail.com>
 <20150627065638.GA29497@gondor.apana.org.au>
 <CA+55aFzLESDmcCEO+N93y8=eF5t7Y0xA0+JnCPvpctXm4hvgGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60418 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbF2Hc7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2015 03:32:59 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFzLESDmcCEO+N93y8=eF5t7Y0xA0+JnCPvpctXm4hvgGQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 27, 2015 at 09:40:24AM -0700, Linus Torvalds wrote:
> On Fri, Jun 26, 2015 at 11:56 PM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
> >
> > So I think Tadeusz's patch is the simplest fix for 4.2.  Could you
> > please test it to see if it makes your warning go away?
> 
> Seems to silence it here.

OK I'll apply this patch for 4.2.

> I get the feeling that the patch is still wrong - why are not the
> *tests* run at late time when everything is properly set up, rather
> than forcing ordering at the code init level - but at least I don't
> see the annoying error, so it's certainly better than it was before.

That's what I was exploring but I think it'll take a while so
it's best to postpone it to 4.3 or later.  The two alternatives
I was toying with are 1) delay the testing until the first time
the given algorithm is used; 2) perform testing for all built-in
algorithms at late_initcall.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
