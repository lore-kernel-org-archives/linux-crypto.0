From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] hwrng: omap - remove incorrect __exit markups
Date: Thu, 12 Mar 2015 01:13:05 +1100
Message-ID: <20150311141305.GB5713@gondor.apana.org.au>
References: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>,
	linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53092 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbbCKONJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 10:13:09 -0400
Content-Disposition: inline
In-Reply-To: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 09, 2015 at 10:36:35AM -0700, Dmitry Torokhov wrote:
> Even if bus is not hot-pluggable, the devices can be unbound from the
> driver via sysfs, so we should not be using __exit annotations on
> remove() methods. The only exception is drivers registered with
> platform_driver_probe() which specifically disables sysfs bind/unbind
> attributes.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Patches 1/3/4 applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
