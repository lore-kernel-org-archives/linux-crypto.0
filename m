From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch 1/1] add cast to regain ablkcipher_request from private ctx
Date: Fri, 22 Jun 2007 15:06:47 +0200
Message-ID: <20070622130647.GB28000@Chamillionaire.breakpoint.cc>
References: <20070612162023.GA25764@Chamillionaire.breakpoint.cc> <20070622123916.GA30017@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54792 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbXFVNGu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 09:06:50 -0400
Content-Disposition: inline
In-Reply-To: <20070622123916.GA30017@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-06-22 20:39:16 [+0800]:

>On Tue, Jun 12, 2007 at 04:20:23PM +0000, Sebastian Siewior wrote:
>> This cast allows to regain the struct ablkcipher_request for a request 
>> from private data.
>
>How about just passing the ablkcipher_request instead of the ctx?
Not pretty/possible/wanted.
I could write now 20 lines of text that explains it. Instead I defer it
until I post my source for the driver what is hopefully soon.

>Cheers,

Sebastian
