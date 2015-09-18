From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] char: hw_random: Fix module autoload for OF platform
 drivers
Date: Fri, 18 Sep 2015 22:06:00 +0800
Message-ID: <20150918140600.GG9249@gondor.apana.org.au>
References: <20150915164133.GA5642@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
	Matt Mackall <mpm@selenic.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Luis de Bethencourt <luis@debethencourt.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33994 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbIROGQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:06:16 -0400
Content-Disposition: inline
In-Reply-To: <20150915164133.GA5642@goodgumbo.baconseed.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 15, 2015 at 06:41:33PM +0200, Luis de Bethencourt wrote:
> This platform drivers have a OF device ID table but the OF module
> alias information is not created so module autoloading won't work.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
