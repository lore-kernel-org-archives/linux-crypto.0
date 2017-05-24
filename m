From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Wed, 24 May 2017 09:32:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1705240931170.2983@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>, kbuild-all@01.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57876 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934544AbdEXHcL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:32:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please check whether an unlock is needed before line 454.

julia

---------- Forwarded message ----------
Date: Wed, 24 May 2017 12:16:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] crypto: engine - Permit to enqueue skcipher request

CC: kbuild-all@01.org
In-Reply-To: <20170523120903.31637-2-clabbe.montjoie@gmail.com>
TO: Corentin Labbe <clabbe.montjoie@gmail.com>
CC: herbert@gondor.apana.org.au, davem@davemloft.net
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>

Hi Corentin,

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.12-rc2 next-20170523]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Corentin-Labbe/crypto-engine-replace-pr_xxx-by-dev_xxx/20170524-061949
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
:::::: branch date: 6 hours ago
:::::: commit date: 6 hours ago

>> crypto/crypto_engine.c:454:2-8: preceding lock on line 444

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 1d8d483820540c10cd7056015fa0309e27c0b0e7
vim +454 crypto/crypto_engine.c

735d37b5 Baolin Wang    2016-01-26  438   * Return 0 on success, else on fail.
735d37b5 Baolin Wang    2016-01-26  439   */
735d37b5 Baolin Wang    2016-01-26  440  int crypto_engine_start(struct crypto_engine *engine)
735d37b5 Baolin Wang    2016-01-26  441  {
735d37b5 Baolin Wang    2016-01-26  442  	unsigned long flags;
735d37b5 Baolin Wang    2016-01-26  443
735d37b5 Baolin Wang    2016-01-26 @444  	spin_lock_irqsave(&engine->queue_lock, flags);
735d37b5 Baolin Wang    2016-01-26  445
735d37b5 Baolin Wang    2016-01-26  446  	if (engine->running || engine->busy) {
735d37b5 Baolin Wang    2016-01-26  447  		spin_unlock_irqrestore(&engine->queue_lock, flags);
735d37b5 Baolin Wang    2016-01-26  448  		return -EBUSY;
735d37b5 Baolin Wang    2016-01-26  449  	}
735d37b5 Baolin Wang    2016-01-26  450
1d8d4838 Corentin Labbe 2017-05-23  451  	if (!engine->skcipher_one_request && !engine->cipher_one_request &&
1d8d4838 Corentin Labbe 2017-05-23  452  	    !engine->hash_one_request) {
1d8d4838 Corentin Labbe 2017-05-23  453  		dev_err(engine->dev, "need at least one request type\n");
1d8d4838 Corentin Labbe 2017-05-23 @454  		return -EINVAL;
1d8d4838 Corentin Labbe 2017-05-23  455  	}
1d8d4838 Corentin Labbe 2017-05-23  456
1d8d4838 Corentin Labbe 2017-05-23  457  	if (engine->skcipher_one_request && engine->cipher_one_request) {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
