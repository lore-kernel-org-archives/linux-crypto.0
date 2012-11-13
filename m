From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: cast5/cast6 - move lookup tables to shared
 module
Date: Tue, 13 Nov 2012 13:53:04 -0500 (EST)
Message-ID: <20121113.135304.281580343771830320.davem@davemloft.net>
References: <20121113094314.23872.30309.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47890 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2KMSxH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 13:53:07 -0500
In-Reply-To: <20121113094314.23872.30309.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 13 Nov 2012 11:43:14 +0200

> CAST5 and CAST6 both use same lookup tables, which can be moved shared module
> 'cast_common'.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Does this work if you make CAST5 modular and CAST6 static, or vice
versa?
