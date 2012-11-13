From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] crypto: testmgr - remove fips_allowed flag from
 camellia-aesni null-tests
Date: Tue, 13 Nov 2012 13:53:27 -0500 (EST)
Message-ID: <20121113.135327.233861174184226180.davem@davemloft.net>
References: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2KMSx2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 13:53:28 -0500
In-Reply-To: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 13 Nov 2012 11:47:32 +0200

> Remove incorrect fips_allowed from camellia null-test entries. Caused by
> incorrect copy-paste of aes-aesni null-tests into camellia-aesni null-tests.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
