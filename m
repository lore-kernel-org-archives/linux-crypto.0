From: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 15:34:11 +0100
Message-ID: <49A556E3.1000309@suse.de>
References: <49A54C23.8090209@suse.de>	 <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
	darrenrjenkins@gmail.com, Greg KH <gregkh@suse.de>
To: Thiago Galesi <thiagogalesi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:34917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZBYOeO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:34:14 -0500
In-Reply-To: <82ecf08e0902250629n6a190165u557c21b0ebe797d5@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thiago Galesi wrote:
> If you write static char output[1024]; (even inside a function) it's
> not allocated on the stack.

Oh, yes i misunderstood Herbert, sorry. But anyway isn't
it preferred to kmalloc such arrays?
Greg, i thought it was you who told me so, is that right?

Thanks,
Frank

