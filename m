From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] crypto: testmgr - clean alg_test_null entries in
 alg_test_descs[]
Date: Tue, 13 Nov 2012 13:53:45 -0500 (EST)
Message-ID: <20121113.135345.1177053994589244695.davem@davemloft.net>
References: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
	<20121113094737.25071.88732.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2KMSxq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 13:53:46 -0500
In-Reply-To: <20121113094737.25071.88732.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 13 Nov 2012 11:47:37 +0200

> Currently alg_test_null entries set .suite values to zero, which is unneeded.
> So perform clean-up of null test entries.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
