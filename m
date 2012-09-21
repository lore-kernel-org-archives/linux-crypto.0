From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: tcrypt - add missing tests for camellia and
 ghash
Date: Fri, 21 Sep 2012 12:12:04 -0400 (EDT)
Message-ID: <20120921.121204.1043966198515282180.davem@davemloft.net>
References: <20120921072710.11930.17414.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49499 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2IUQMF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2012 12:12:05 -0400
In-Reply-To: <20120921072710.11930.17414.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Fri, 21 Sep 2012 10:27:10 +0300

> Add missing tests for ctr(camellia), lrw(camellia), xts(camellia) and ghash,
> as these have test vectors available.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
