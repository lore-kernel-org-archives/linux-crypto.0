From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: un4i-ss-cipher.c warning
Date: Thu, 20 Aug 2015 13:29:03 +0800
Message-ID: <20150820052903.GA26031@gondor.apana.org.au>
References: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Michal Suchanek <hramrach@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56360 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbHTF3P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 01:29:15 -0400
Content-Disposition: inline
In-Reply-To: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2015 at 04:35:36PM +0200, Michal Suchanek wrote:
> Hello,
> 
> when building a kernel with sunxi crypto driver as merged into the
> sinxi-wip branch I get a compiler warning.
> 
> I am not sure this is the latest version of the driver. It does not
> seem to be in mainline yet.

The warning appears to be spurious as the code always ends up
initialising todo before using it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
