Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32F6E776F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjJCDoD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJCDoC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:02 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88431B7
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:43:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWKA-002wPe-MW; Tue, 03 Oct 2023 11:43:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:43:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/16] crypto: Only use common fields on skcipher spawn algs
Date:   Tue,  3 Oct 2023 11:43:17 +0800
Message-Id: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The lskcipher conversion broke essiv.  The superficial reason is
that it was missed during the lskcipher addition as it does something
similar to cryptd by being capable of both creating skciphers as well
as aead algorithms.

However, this also revealed that users of skcipher spawns were
dereferencing fields that may be specific to skcipher_alg.  This
is invalid as the underlying algorithm may be an lskcipher_alg.
Only fields in skcipher_alg_common may be used.

This series adds the necessary helper for this and converts all
users of skcipher spawns to use the new helper.

The first patch is a left-over from the previous series and simply
converts arc4 to an lskcipher.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
