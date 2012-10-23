From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/3] crypto: camellia - add AES-NI/AVX/x86_64 assembler
 implementation of camellia cipher
Date: Tue, 23 Oct 2012 14:06:59 -0400 (EDT)
Message-ID: <20121023.140659.1424260252079488912.davem@davemloft.net>
References: <20121023180251.6263.14957.stgit@localhost6.localdomain6>
	<20121023180302.6263.83673.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42982 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2JWSHA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2012 14:07:00 -0400
In-Reply-To: <20121023180302.6263.83673.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 23 Oct 2012 21:03:02 +0300

> This patch adds AES-NI/AVX/x86_64 assembler implementation of Camellia block
> cipher. Implementation process data in sixteen block chunks, which are
> byte-sliced and AES SubBytes is reused for Camellia s-box with help of pre-
> and post-filtering.
> 
> Patch has been tested with tcrypt and automated filesystem tests.
> 
> tcrypt test results:
> 
> Intel Core i5-2450M:
> 
> camellia-aesni-avx vs camellia-asm-x86_64-2way:
> 128bit key:                                             (lrw:256bit)    (xts:256bit)
> size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
> 16B     0.98x   0.96x   0.99x   0.96x   0.96x   0.95x   0.95x   0.94x   0.97x   0.98x
> 64B     0.99x   0.98x   1.00x   0.98x   0.98x   0.99x   0.98x   0.93x   0.99x   0.98x
> 256B    2.28x   2.28x   1.01x   2.29x   2.25x   2.24x   1.96x   1.97x   1.91x   1.90x
> 1024B   2.57x   2.56x   1.00x   2.57x   2.51x   2.53x   2.19x   2.17x   2.19x   2.22x
> 8192B   2.49x   2.49x   1.00x   2.53x   2.48x   2.49x   2.17x   2.17x   2.22x   2.22x
> 
> 256bit key:                                             (lrw:384bit)    (xts:512bit)
> size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
> 16B     0.97x   0.98x   0.99x   0.97x   0.97x   0.96x   0.97x   0.98x   0.98x   0.99x
> 64B     1.00x   1.00x   1.01x   0.99x   0.98x   0.99x   0.99x   0.99x   0.99x   0.99x
> 256B    2.37x   2.37x   1.01x   2.39x   2.35x   2.33x   2.10x   2.11x   1.99x   2.02x
> 1024B   2.58x   2.60x   1.00x   2.58x   2.56x   2.56x   2.28x   2.29x   2.28x   2.29x
> 8192B   2.50x   2.52x   1.00x   2.56x   2.51x   2.51x   2.24x   2.25x   2.26x   2.29x
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David S. Miller <davem@davemloft.net>
