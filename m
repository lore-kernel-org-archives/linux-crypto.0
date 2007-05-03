From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
Date: Thu, 3 May 2007 10:32:33 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0705031024530.23274@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au> <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
 <87r6pyqg2b.fsf@pelargir.dolphinics.no> <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
 <87hcquqajl.fsf@pelargir.dolphinics.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Arne Georg Gleditsch <argggh@dolphinics.no>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seahorse.shentel.net ([204.111.1.244]:37533 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162037AbXECOjA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 10:39:00 -0400
In-Reply-To: <87hcquqajl.fsf@pelargir.dolphinics.no>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> > Besides, based on the actual binary representation of UTF-8, it's 
> > extremely unlikely for any ISO-8859-1 string to be detected as UTF-8. VIm 
> > already does this: UTF-8 it handles natively, but open up one of these 
> > unpatched files in VIm and you'll see "[converted]" at the bottom of your 
> > screen. Should happen if you open the attached .patch.bin file in VIm.
> 
> Yes, I agree that heuristics can be used to determine the coding
> system used with a high degree of probability.  I'm just suggesting we
> make the coding system explicit, in order to spare other applications
> that do visual presentation of Linux source code having to perform
> their own heuristics.
> 
> But hey, if I'm the only one wanting to see this particular bike shed
> painted blue...

In any other case, I would agree completely, but like I said, the entire 
tree will be one encoding anyway, which will be UTF-8. Many tools would 
already have these heuristics, and even if they don't, the code itself 
will be perfectly legible no matter which encoding is used to view it, and 
only some things like circuit diagrams and peoples' names may be slightly 
mangled. Any byte which is 0x7F or less is identical in both encodings, so 
all normal ASCII is unchanged.

It's an issue only in transition. No new non-UTF-8 patches should be 
accepted, of course. And I won't be doing any changes that break anything 
other than a live person reading it and wondering why it looks weird if 
they don't have the right tools.

A line in <Documentation/CodingStyle> explicitly requiring UTF-8 sounds 
like a good idea. I shall submit one later if I remember. Many mail 
clients do this conversion automatically, which causes me headaches and 
requires me to attach the patches separately. Quite annoying really. I'm 
exploring the possibility of hacking together a simple SMTP client if 
that'll help me with these fool binary patches.

Or maybe setting up a little mini git repository with UTF-8 changes is a 
good idea? Hmm, I'll research that, and try it. Then I could just cc it to 
trivial and the list and they can just pull it in one go. One more week 
until summer vacation! I shall have time to do this then.
