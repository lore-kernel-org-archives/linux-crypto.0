From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: un4i-ss-cipher.c warning
Date: Fri, 21 Aug 2015 06:08:18 +0800
Message-ID: <20150820220818.GA2850@gondor.apana.org.au>
References: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
 <55D5DC97.1040209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Suchanek <hramrach@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54364 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbHTWI3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 18:08:29 -0400
Content-Disposition: inline
In-Reply-To: <55D5DC97.1040209@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 03:56:39PM +0200, Corentin LABBE wrote:
> 
> Thanks for the report, strange that I do not have that warning.
> todo is always initialized, since oleft and ileft are always > 0 at start.
> But setting todo to 0 is a simple fix.
> The following patch will suppress the warning.

Nack.  Please do not fix spurious uninitialised warnings in this
way.  Not only is this pointless but if someone introduced a real
uninitialised bug later on we'd never catch it because of this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
