From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: aesni - fix XTS mode on x86-32, add wrapper
 function for asmlinkage aesni_enc()
Date: Thu, 18 Oct 2012 16:34:24 -0400 (EDT)
Message-ID: <20121018.163424.1410529294638285773.davem@davemloft.net>
References: <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
	<20121018202457.30712.52079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	torvalds@linux-foundation.org, herbert@gondor.apana.org.au,
	kkolasa@winsoft.pl, ying.huang@intel.com
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54479 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2JRUe1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2012 16:34:27 -0400
In-Reply-To: <20121018202457.30712.52079.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 18 Oct 2012 23:24:57 +0300

> Calling convention for internal functions and 'asmlinkage' functions is
> different on x86-32. Therefore do not directly cast aesni_enc as XTS tweak
> function, but use wrapper function in between. Fixes crash with "XTS +
> aesni_intel + x86-32" combination.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
