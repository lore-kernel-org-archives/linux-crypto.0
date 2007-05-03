From: Arne Georg Gleditsch <argggh@dolphinics.no>
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
Date: 03 May 2007 13:53:16 +0200
Message-ID: <87r6pyqg2b.fsf@pelargir.dolphinics.no>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
	<20070502044345.GA29384@gondor.apana.org.au>
	<alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from poesci.dolphinics.no ([81.175.23.36]:44618 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030949AbXECMNg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 08:13:36 -0400
In-Reply-To: <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
> Did this file individually, per request. Will re-do the whole tree later 
> as I'm still working on my handy-dandy testing and patching tools and 
> don't have a lot of time outside of work until the summer gets underway.

While this is probably inevitable, it would be nice if there was some
way to determine the actual coding system used for individual files.
Especially if we're mixing latin1 and utf8 in the same tree.  Has
something like adding "/* -*- coding: utf-8; -*- */" or similar to the
top of converted files been considered?

-- 
								Arne.
