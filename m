From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Tcrypt output for HIFN 795x driver.
Date: Mon, 1 Oct 2007 17:23:02 +0400
Message-ID: <20071001132300.GA13533@2ka.mipt.ru>
References: <20071001124822.GA16017@2ka.mipt.ru> <20071001125105.GA19945@2ka.mipt.ru> <20071001131557.GA21361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59562 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbXJANXg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 09:23:36 -0400
Content-Disposition: inline
In-Reply-To: <20071001131557.GA21361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 01, 2007 at 09:15:57PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Mon, Oct 01, 2007 at 04:51:06PM +0400, Evgeniy Polyakov wrote:
> > Notice that 'testing ecb(aes) decryption across pages (chunking)' fails.
> > I will investigate this further.
> 
> Thre aren't any ecb chunking tests.  Looks like it's the cbc
> test that's failing.

I really do not understand what exactly fails - chunking and
non-chunking output is mixed with hifn debug output, so there is quite a
bit of confusion. Decryption works both in driver and shown in tcrypt
output for ecb, probably the cbc setup is not performed correctly (both
encryption and decryption seems to fail).

-- 
	Evgeniy Polyakov
