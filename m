From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] crypto: add test vectors for skein256/512/1024
Date: Sun, 02 Nov 2008 20:44:40 -0500
Message-ID: <490E5788.4080300@garzik.org>
References: <20081102161506.GA21940@havoc.gtf.org> <20081102201518.GA23620@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34123 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYKCBor (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Nov 2008 20:44:47 -0500
In-Reply-To: <20081102201518.GA23620@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Andrzej Siewior wrote:
> I grabed them from http://www.schneier.com/skein.html. The last test vector
> (3) in every category is currently deactivated because it failed always.
> It is unlikely that I made a type because I copy+pasted the tables + vim
> magiced them. So maybe code may missbehave on requests lengths which are
> not a multiple of 4 or the vectors can not be used due to some other
> limitations that I've overseen.

Another thought:  did you verify that the test vectors' output sizes 
matched the Linux kernel's?

My implementation assumed a 256-bit output size for Skein-256, for 
example, but it is quite possible that Schneier and co. ran tests where 
the output size differed from the internal state size.

	Jeff


