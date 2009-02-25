From: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 15:24:25 +0100
Message-ID: <49A55499.6090700@suse.de>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
	darrenrjenkins@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZBYOYt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:24:49 -0500
In-Reply-To: <20090225142000.GA4136@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
>> -	char output[1024];
> 
> How about just making it static?

Well, it was static before. But there
are efforts to reduce current stack memory
footprints.

Frank

