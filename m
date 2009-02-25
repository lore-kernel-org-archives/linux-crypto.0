From: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 15:54:32 +0100
Message-ID: <49A55BA8.2060205@suse.de>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <20090225142744.GA4331@gondor.apana.org.au> <alpine.LRH.2.00.0902251529440.15476@vixen.sonytel.be> <49A55771.1050408@suse.de> <alpine.LRH.2.00.0902251542010.15476@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Frank Seidel <fseidel@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com,
	Greg KH <gregkh@suse.de>, Frank Seidel <frank@f-seidel.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZBYOyf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:54:35 -0500
In-Reply-To: <alpine.LRH.2.00.0902251542010.15476@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven wrote:
> On Wed, 25 Feb 2009, Frank Seidel wrote:
> Wel...
> 
> Using kmalloc() increases code size, makes the code more complex, and increases
> the risk of introducing a memory leak now or later.

Ok, admitted.

>> I just stumbled over tcrypt on the make checkstack output and as also
>> the kerneljanitors todo advises to reduce this footprint where possible
>> i just wanted to help out here.
> 
> Reducing stack usage is fine. However, for a loadable test module without
> concurrency issues it's far easier to do that by just making the data static.

Is PATCHv3 then ok for you?

Thanks,
Frank
