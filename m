From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] net/ipsec: don't treat EINPROGRESS as a regular error
Date: Mon, 26 Apr 2010 20:11:42 +0200
Message-ID: <20100426181142.GA22245@Chamillionaire.breakpoint.cc>
References: <20091130211531.GK18101@deprecation.cyrius.com>
 <4B144627.7060901@gmail.com>
 <20091204212847.GC28480@deprecation.cyrius.com>
 <4BCB4009.70707@gmail.com>
 <20100418191719.GA2508@Chamillionaire.breakpoint.cc>
 <4BCE125F.30200@gmail.com>
 <20100424144215.GA9057@Chamillionaire.breakpoint.cc>
 <20100425011821.GA5284@gondor.apana.org.au>
 <20100425152928.GA14489@Chamillionaire.breakpoint.cc>
 <20100426011711.GA19734@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34619 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853Ab0DZSLy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Apr 2010 14:11:54 -0400
Content-Disposition: inline
In-Reply-To: <20100426011711.GA19734@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-04-26 09:17:11 [+0800]:

>OK that was my fault.  Steffen had all the requisite EINPROGRESS
>checks in place but I told him to get rid of them.
>
>This patch should fix it.
Excellent job Herbert, it does solve the problem.

Sebastian
