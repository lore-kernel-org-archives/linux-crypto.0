Return-Path: <SRS0=w3rH=Z6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB532C43603
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Dec 2019 05:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E9320700
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Dec 2019 05:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfLHFmb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Dec 2019 00:42:31 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37846 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfLHFmb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Dec 2019 00:42:31 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idpKv-0001vT-OT; Sun, 08 Dec 2019 13:42:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idpKv-0008Qx-Bc; Sun, 08 Dec 2019 13:42:29 +0800
Date:   Sun, 8 Dec 2019 13:42:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>
Subject: [v2 PATCH 0/3] crypto: shash - Enforce descsize limit in init_tfm
Message-ID: <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
References: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands we only enforce descsize limits when an algorithm is
registered.  However, as descsize is dynamic and may be set at
init_tfm time this is not enough.  This is why hmac has its own
descsize check.

This series adds descsize limit enforcement at init_tfm time so
that the API takes over the responsibility of checking descsize
after the algorithm's init_tfm has completed.

v2 addresses the issues raised during review, including adding
a WARN_ON_ONCE to crypto_shash_init_tfm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
