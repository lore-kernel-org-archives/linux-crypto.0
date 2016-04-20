From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa: Improving code readability
Date: Wed, 20 Apr 2016 18:01:04 +0800
Message-ID: <20160420100104.GA3148@gondor.apana.org.au>
References: <1461078560-30924-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	jason@lakedaemon.net, andrew@lunn.ch,
	sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com,
	thomas.petazzoni@free-electrons.com, nadavh@marvell.com,
	oferh@marvell.com, linux-crypto@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39261 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbcDTKBU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 06:01:20 -0400
Content-Disposition: inline
In-Reply-To: <1461078560-30924-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> When looking for available engines, the variable "engine" is
> assigned to "&cesa->engines[i]" at the beginning of the for loop. Replacing
> next occurences of "&cesa->engines[i]" by "engine" and in order to improve
> readability.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
