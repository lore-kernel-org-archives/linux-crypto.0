From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] New test vectors for camellia, blowfish, serpent,
 aes, des and des3_ede
Date: Sat, 20 Oct 2012 13:51:10 -0400 (EDT)
Message-ID: <20121020.135110.1138754268310415632.davem@davemloft.net>
References: <20121020115050.17179.44149.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46492 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2JTRvR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 13:51:17 -0400
In-Reply-To: <20121020115050.17179.44149.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Sat, 20 Oct 2012 14:52:41 +0300

> Test vectors for camellia, blowfish and serpent are expanded for future
> implementations.
> 
> New test vectors for aes, des and des3_ede are added to test existing
> implementations.
> 
> ---
> 
> Jussi Kivilinna (6):
>       crypto: testmgr - expand camellia test vectors
>       crypto: testmgr - expand blowfish test vectors
>       crypto: testmgr - expand serpent test vectors
>       crypto: testmgr - add new larger AES testvectors
>       crypto: testmgr - add new larger DES testvectors
>       crypto: testmgr - add new larger DES3_EDE testvectors

Thanks for doing this work:

Acked-by: David S. Miller <davem@davemloft.net>
