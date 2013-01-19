From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - add test vector for fcrypt
Date: Sat, 19 Jan 2013 10:39:08 -0500 (EST)
Message-ID: <20130119.103908.912267263630916931.davem@davemloft.net>
References: <20130119113136.20877.48105.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3ASPjN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 10:39:13 -0500
In-Reply-To: <20130119113136.20877.48105.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Sat, 19 Jan 2013 13:31:36 +0200

> fcrypt is used only as pcbc(fcrypt), but testmgr does not know this.
> Use the zero key, zero plaintext pcbc(fcrypt) test vector for
> testing plain 'fcrypt' to hide "no test for fcrypt" warnings.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
