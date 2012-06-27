From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/20] crypto: caam - driver updates
Date: Wed, 27 Jun 2012 01:17:25 -0700 (PDT)
Message-ID: <20120627.011725.957557737426563044.davem@davemloft.net>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
	<20120627065144.GD22920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kim.phillips@freescale.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40259 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2F0IRZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 04:17:25 -0400
In-Reply-To: <20120627065144.GD22920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 27 Jun 2012 14:51:44 +0800

> While using the NAPI concept definitely makes sense, I'm still
> unsure about using napi_struct directly in crypto code.  Dave,
> did you have a chance to look at their patch to use NAPI in their
> crypto driver?

I'll take a look at it tomorrow, thanks.
