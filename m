From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] crypto: testmgr - make test_skcipher also test
 'dst != src' code paths
Date: Fri, 21 Sep 2012 12:11:50 -0400 (EDT)
Message-ID: <20120921.121150.1604585021528101229.davem@davemloft.net>
References: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2IUQLw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Sep 2012 12:11:52 -0400
In-Reply-To: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Fri, 21 Sep 2012 10:26:47 +0300

> Currrently test_skcipher uses same buffer for destination and source. However
> in any places, 'dst != src' take different path than 'dst == src' case.
> 
> Therefore make test_skcipher also run tests with destination buffer being
> different than source buffer.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
