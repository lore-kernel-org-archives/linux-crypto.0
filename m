From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/20] crypto: caam - driver updates
Date: Sat, 30 Jun 2012 01:18:51 -0700 (PDT)
Message-ID: <20120630.011851.1964175776825322391.davem@davemloft.net>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
	<20120627065144.GD22920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kim.phillips@freescale.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:41132 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2F3ISw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jun 2012 04:18:52 -0400
In-Reply-To: <20120627065144.GD22920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 27 Jun 2012 14:51:44 +0800

> While using the NAPI concept definitely makes sense, I'm still
> unsure about using napi_struct directly in crypto code.  Dave,
> did you have a chance to look at their patch to use NAPI in their
> crypto driver?

So I think using the existing napi context is overkill for a crypto
driver, there is so much stuff in that structure that will not be used
and just end up being wasted space.

Better to create a crypto_napi struct that caters more closely to
just what crypto driver need.
