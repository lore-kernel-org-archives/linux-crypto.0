Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11616C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 02:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA53821D80
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 02:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgIJB7d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 21:59:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55814 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgIJBk4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 21:40:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kGAXf-00005a-C3; Thu, 10 Sep 2020 10:34:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Sep 2020 10:34:23 +1000
Date:   Thu, 10 Sep 2020 10:34:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.9
Message-ID: <20200910003423.GA28062@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830223304.GA16882@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes a regression in padata.

The following changes since commit c195d66a8a75c60515819b101975f38b7ec6577f:

  crypto: af_alg - Work around empty control messages without MSG_MORE (2020-08-27 23:20:36 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 1b0df11fde0f14a269a181b3b7f5122415bc5ed7:

  padata: fix possible padata_works_lock deadlock (2020-09-04 17:51:55 +1000)

----------------------------------------------------------------
Daniel Jordan (1):
      padata: fix possible padata_works_lock deadlock

 kernel/padata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
