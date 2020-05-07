Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDE4C47257
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 00:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356FA2064A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 00:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgEGAo1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 20:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgEGAo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 20:44:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02258C061A0F;
        Wed,  6 May 2020 17:44:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58FB9127813B4;
        Wed,  6 May 2020 17:44:25 -0700 (PDT)
Date:   Wed, 06 May 2020 17:44:24 -0700 (PDT)
Message-Id: <20200506.174424.138140249817623255.davem@davemloft.net>
To:     shiva@chelsio.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next 0/5] Crypto/chcr: Fix issues regarding
 algorithm implementation in driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505031257.9153-1-shiva@chelsio.com>
References: <20200505031257.9153-1-shiva@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:44:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Devulapally Shiva Krishna <shiva@chelsio.com>
Date: Tue,  5 May 2020 08:42:52 +0530

> The following series of patches fixes the issues which came during
> self-tests with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
> 
> Patch 1: Fixes gcm(aes) hang issue and rfc4106-gcm encryption issue.
> Patch 2: Fixes ctr, cbc, xts and rfc3686-ctr extra test failures.
> Patch 3: Fixes ccm(aes) extra test failures.
> Patch 4: Added support for 48 byte-key_len in aes_xts.
> Patch 5: fix for hmac(sha) extra test failure.

Series applied, thank you.
