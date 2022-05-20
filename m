Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E9DC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 20 May 2022 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbiETFlU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 May 2022 01:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbiETFlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 May 2022 01:41:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2B13E19;
        Thu, 19 May 2022 22:41:13 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nrvNn-00FhmD-Us; Fri, 20 May 2022 15:41:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 May 2022 13:41:04 +0800
Date:   Fri, 20 May 2022 13:41:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.18
Message-ID: <Yocp8BaZacpvwJEL@gondor.apana.org.au>
References: <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au>
 <20210929023843.GA28594@gondor.apana.org.au>
 <20211029041408.GA3192@gondor.apana.org.au>
 <20211112104815.GA14105@gondor.apana.org.au>
 <YcKz4wHYTe3qlW7L@gondor.apana.org.au>
 <YgMn+1qQPQId50hO@gondor.apana.org.au>
 <YjE5yThYIzih2kM6@gondor.apana.org.au>
 <YkUdKiJflWqxBmx5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkUdKiJflWqxBmx5@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v5.18-p2 

for you to fetch changes up to 16287397ec5c08aa58db6acf7dbc55470d78087d:

  crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ (2022-05-13 17:13:38 +0800)

----------------------------------------------------------------
This push fixes a regression in a recent fix to qcom-rng.

----------------------------------------------------------------
Ondrej Mosnacek (1):
      crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

 drivers/crypto/qcom-rng.c | 1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
