From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/12] crypto: x86 assembler cleanups
Date: Sat, 19 Jan 2013 10:39:50 -0500 (EST)
Message-ID: <20130119.103950.1071013942843164207.davem@davemloft.net>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3ASPjw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 10:39:52 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Sat, 19 Jan 2013 13:38:45 +0200

> Change x86 crypto implementations to use ENTRY()/ENDPROC() as linux/linkage.h 
> recommends use of ENDPROC() for assembler functions.
> 
> While at it, also change jump targets to local labels for some implementations.

For series:

Acked-by: David S. Miller <davem@davemloft.net>
