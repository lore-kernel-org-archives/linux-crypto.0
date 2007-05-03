From: Arne Georg Gleditsch <argggh@dolphinics.no>
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
Date: 03 May 2007 15:52:30 +0200
Message-ID: <87hcquqajl.fsf@pelargir.dolphinics.no>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
	<20070502044345.GA29384@gondor.apana.org.au>
	<alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
	<87r6pyqg2b.fsf@pelargir.dolphinics.no>
	<alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from poesci.dolphinics.no ([81.175.23.36]:45049 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161909AbXECNwc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 09:52:32 -0400
In-Reply-To: <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
> Besides, based on the actual binary representation of UTF-8, it's 
> extremely unlikely for any ISO-8859-1 string to be detected as UTF-8. VIm 
> already does this: UTF-8 it handles natively, but open up one of these 
> unpatched files in VIm and you'll see "[converted]" at the bottom of your 
> screen. Should happen if you open the attached .patch.bin file in VIm.

Yes, I agree that heuristics can be used to determine the coding
system used with a high degree of probability.  I'm just suggesting we
make the coding system explicit, in order to spare other applications
that do visual presentation of Linux source code having to perform
their own heuristics.

But hey, if I'm the only one wanting to see this particular bike shed
painted blue...

-- 
								Arne.
