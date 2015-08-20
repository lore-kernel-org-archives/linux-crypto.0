From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: un4i-ss-cipher.c warning
Date: Thu, 20 Aug 2015 14:44:26 +0800
Message-ID: <20150820064426.GA26787@gondor.apana.org.au>
References: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
 <20150820052903.GA26031@gondor.apana.org.au>
 <20150820063900.GJ30520@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Suchanek <hramrach@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56999 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbHTGog (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 02:44:36 -0400
Content-Disposition: inline
In-Reply-To: <20150820063900.GJ30520@lukather>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 08:39:00AM +0200, Maxime Ripard wrote:
>
> Not in the dev_dbg call line 258. If ileft was negative or null, todo
> isn't assigned to anything.

If ileft starts out being <= 0, then oleft == ileft will also be
<= 0, in which case the loop never executes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
