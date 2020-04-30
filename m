Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEA3C4724C
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1476A208C3
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgD3Vbs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:31:48 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:38147 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3Vbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 17:31:48 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MtO06-1jB6Ge1DyQ-00upFR; Thu, 30 Apr 2020 23:31:34 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH 01/15] crypto - Avoid free() namespace collision
Date:   Thu, 30 Apr 2020 23:30:43 +0200
Message-Id: <20200430213101.135134-2-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:noS1A6Il77uJCdtGIYMZsJck2JXiveiOZSUU5gHZOHPp0AFDTnW
 9BCHOGqOI/yBx5RXfvWRKtYRNyKnpp68SRNe0h2ZYgnKxkFGXPnuHgRgJEc2UGiWM1yLkrz
 xjXPO8iHxtBMWllSKb7JEAeiZkyyjVXq4tHGoHz+gNfvrkNqqKM6/q5A2nBAFqx5g9kd/Ll
 eErk/7Bn10CsNpdrXig3A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:p2C9HxJm+L0=:55xdeEk+6o+d7sn4iF5aNM
 WX4slNCr3MDcqpD29KX/r/SlH3Kr97Ch0/dChnheCMKdIwK0V/wszQIAIUF0QZvi8luTGAu9e
 W6T3DUF/nagJnIfqQW8KlSyAF6kAN7OWOS7GACZoR4H+BAfl8UkRIcYVXddw/jVW1W8to/6dJ
 46zj+1M7sEFtgsAxSjkysZQjbYKWkfKGmf1aUrLlx8MHgyEpvgEwPnqUmmaJeT3p+5rIYm8cA
 Ifee+aDak4AXOzu/dw74j/HxZ+JxmEueA96dUbew6nzc10LyrUIzI5PmDC7DVGaSw2eDvCb/a
 LqMrKYZfi1M34LwUGspwwSrmuBP1QweRvhzr9Pq76+6AuS6C+wbFaXKf4tAItjqMBZELk0F8v
 1sfzreBAGDdiB8P3vrUZRoBHAmiu6HRIURxmQoRaePPhfTa9bh2ID2KlXyTZOc5Tz+DJqMVaJ
 gn7433rGebUp4czo9n9JxAGNbpAZnZMHd6ZBc86EO76fMDkIFMGTapT0nRDFDZO7Efl05WHTx
 59tByoLcrs+YV3WA73Aohwl5Y6RMazRwWflLZ/Qa38yjTPEN24EJCfCfdKaUrpTZMJnd1RhJ3
 nimvoI58oT3txz3u2RL75cenfR0/lVzci9Xn8YM2aDRi6Q52ChU5ndS0gfXcKnFQcYVEaEBhQ
 aIGlyWKHAG0zJXFVXjR1YuRijZmFcJaEi0+P5AKu5rL8+9BrCCmig89HX/3oAlkPsysMTwr/Z
 vRnjNBz0ddQqhs5MMHaWgdk/vx0J1CnnUPCt4X0tv70ApEMRFx+aGR82RPZvn8Woy6AuwRtHt
 gKSBJlrdpj3tbwDFhMaavcMz1aIN5pBzaImRtjSGLW7cym3QW0=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

gcc-10 complains about using the name of a standard library
function in the kernel, as we are not building with -ffreestanding:

crypto/xts.c:325:13: error: conflicting types for built-in function 'free'; expected 'void(void *)' [-Werror=builtin-declaration-mismatch]
  325 | static void free(struct skcipher_instance *inst)
      |             ^~~~
crypto/lrw.c:290:13: error: conflicting types for built-in function 'free'; expected 'void(void *)' [-Werror=builtin-declaration-mismatch]
  290 | static void free(struct skcipher_instance *inst)
      |             ^~~~
crypto/lrw.c:27:1: note: 'free' is declared in header '<stdlib.h>'

The xts and lrw cipher implementations run into this because they do
not use the conventional namespaced function names.

It might be better to rename all local functions in those files to
help with things like 'ctags' and 'grep', but just renaming these two
avoids the build issue. I picked the more verbose crypto_xts_free()
and crypto_lrw_free() names for consistency with several other drivers
that do use namespaced function names.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/lrw.c | 6 +++---
 crypto/xts.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 376d7ed3f1f8..5b07a7c09296 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -287,7 +287,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_skcipher(ctx->child);
 }
 
-static void free(struct skcipher_instance *inst)
+static void crypto_lrw_free(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -400,12 +400,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = crypto_lrw_free;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		free(inst);
+		crypto_lrw_free(inst);
 	}
 	return err;
 }
diff --git a/crypto/xts.c b/crypto/xts.c
index dbdd8af629e6..3565f3b863a6 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -322,7 +322,7 @@ static void exit_tfm(struct crypto_skcipher *tfm)
 	crypto_free_cipher(ctx->tweak);
 }
 
-static void free(struct skcipher_instance *inst)
+static void crypto_xts_free(struct skcipher_instance *inst)
 {
 	crypto_drop_skcipher(skcipher_instance_ctx(inst));
 	kfree(inst);
@@ -434,12 +434,12 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = encrypt;
 	inst->alg.decrypt = decrypt;
 
-	inst->free = free;
+	inst->free = crypto_xts_free;
 
 	err = skcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		free(inst);
+		crypto_xts_free(inst);
 	}
 	return err;
 }
-- 
2.26.0

