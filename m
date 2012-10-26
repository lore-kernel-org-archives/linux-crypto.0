From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] [v2] crypto: camellia-x86_64 - share common
 functions and move structures and function definitions to header file
Date: Fri, 26 Oct 2012 14:47:22 -0400 (EDT)
Message-ID: <20121026.144722.1375937559078031487.davem@davemloft.net>
References: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
	<20121026114856.3373.67242.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2JZSr0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2012 14:47:26 -0400
In-Reply-To: <20121026114856.3373.67242.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Fri, 26 Oct 2012 14:48:56 +0300

> Prepare camellia-x86_64 functions to be reused from AVX/AESNI implementation
> module.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
