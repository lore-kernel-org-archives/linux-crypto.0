Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB1EC7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 11:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4CE021903
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 11:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="b2DOuElC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfGWL4g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 07:56:36 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:54693 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbfGWL4g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 07:56:36 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 07:56:34 EDT
Received: from conuserg-12.nifty.com ([10.126.8.75])by condef-01.nifty.com with ESMTP id x6NBiasc010605
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2019 20:44:37 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x6NBhmf1024789;
        Tue, 23 Jul 2019 20:43:51 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x6NBhmf1024789
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1563882231;
        bh=/7ci0CmFiZ2Zly0qnNZqD07u1JBMYaF6owEbf8vU7TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2DOuElCsPHOagjvbeZmh2LRLoT3tawDTBQDXgJFZpmBkikK127EUVUMtjhg91NrB
         YyaOUgT3PgqAAUZtbK9XJ5cB0azV9IyAHBsDAmmHHPvhbjHbiuFewVg/Qh6DerorCj
         yBCnqj6k7fhsvnutfaeqwlC6zkJx4RBIqm2eBn7zQcFzAsVqiiF88mHva6GRmOAMlX
         rzMSC/Nxs4+McYDHO3aPRqlRy6a0xdJ/dpphs8UoJxVC+wxv8gLe3zJNWEym3UyNNK
         lNH/NJseLvRkM41g3AjOPG+Dfq/ldPxKqpKFohW0FDw5LciPbc0/RMom0LfPUWLv/A
         udvBhwknq/glA==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: user - fix potential warnings in cryptouser.h
Date:   Tue, 23 Jul 2019 20:43:44 +0900
Message-Id: <20190723114344.18622-2-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723114344.18622-1-yamada.masahiro@socionext.com>
References: <20190723114344.18622-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Function definitions in headers are usually marked as 'static inline'.

Since 'inline' is missing for crypto_reportstat(), if it were not
referenced from a .c file that includes this header, it would produce
a warning.

Also, 'struct crypto_user_alg' is not declared in this header.

I included <linux/crytouser.h> instead of adding the forward declaration
as suggested [1].

Detected by compile-testing this header as a standalone unit:

./include/crypto/internal/cryptouser.h:6:44: warning: ‘struct crypto_user_alg’ declared inside parameter list will not be visible outside of this definition or declaration
 struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
                                            ^~~~~~~~~~~~~~~
./include/crypto/internal/cryptouser.h:11:12: warning: ‘crypto_reportstat’ defined but not used [-Wunused-function]
 static int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs)
            ^~~~~~~~~~~~~~~~~

[1] https://lkml.org/lkml/2019/6/13/1121

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2:
 - include <linux/cryptouser.h>

 include/crypto/internal/cryptouser.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
index 8c602b187c58..d98d9b5c1e32 100644
--- a/include/crypto/internal/cryptouser.h
+++ b/include/crypto/internal/cryptouser.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/cryptouser.h>
 #include <net/netlink.h>
 
 extern struct sock *crypto_nlsk;
@@ -8,7 +9,9 @@ struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
 #ifdef CONFIG_CRYPTO_STATS
 int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs);
 #else
-static int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs)
+static inline int crypto_reportstat(struct sk_buff *in_skb,
+				    struct nlmsghdr *in_nlh,
+				    struct nlattr **attrs)
 {
 	return -ENOTSUPP;
 }
-- 
2.17.1

