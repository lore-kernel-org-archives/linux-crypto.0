From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Is kernel optimized with dead store removal?
Date: Thu, 25 Feb 2010 19:24:26 +0100
Message-ID: <4B86C05A.9010604@s5r6.in-berlin.de>
References: <4B85A49E.6000803@gmail.com>	<19334.22971.970220.245930@pilspetsen.it.uu.se>	<4B8693B9.3060102@gmail.com> <19334.40943.479593.304961@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Roel Kluin <roel.kluin@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58862 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab0BYSY4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 13:24:56 -0500
In-Reply-To: <19334.40943.479593.304961@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mikael Pettersson wrote:
> It's only vulnerable if the data leaks to a less trusted domain.
> There is no domain crossing in your user-space example.
> In the kernel case, the domain crossing would be as I wrote: leaking
> recycled and uninitialized memory to user-space (and those leaks of
> uninitialized memory are frowned upon and quickly fixed when discovered).

Quickly fixed when discovered, but not necessary quickly discovered...
-- 
Stefan Richter
-=====-==-=- --=- ==--=
http://arcgraph.de/sr/
