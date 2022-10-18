Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C51C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 20:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiJRUEt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJRUEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 16:04:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EA028E01
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84762B81F12
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 20:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69FFC433B5;
        Tue, 18 Oct 2022 20:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666123478;
        bh=MVStoeot+9N481gE+IzlwIXraNYXd9DYcPzHHvi46mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP1NI2N0eYGt+NG1l+J9mG66e2+ClaHI8XfDrfu3kOil5zmpzSnLInTF54UW7LUZA
         0pNY7r7SSH6MLt6WfRfZR+lIC9oUnJzFD98qKKZAYW2yHBJ0cTj6cAvzzszXO1PL13
         /Ee/XsEaKX5txTkbetj8TGAJrkKkdJMrjxGAkvyUyqpyOh690Nhj0Wy1AZlJK1zVX6
         uvuHp2Do2MfKWPKun0AT8Ktfn0Dm4By4cx9ueKLd4nAtUPAZ7LmoytaI0jjL1mAZGD
         Eqx3FY0GbsirSmzoQu18ioKH6NP5pevlHOvEF0lWHi/sGIYqtR5EmLJeQ3ouc/mnFK
         HXaQi3r5MCabA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     keescook@chromium.org, ebiggers@kernel.org, jason@zx2c4.com,
        herbert@gondor.apana.org.au, nikunj@amd.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 1/3] crypto: move gf128mul library into lib/crypto
Date:   Tue, 18 Oct 2022 22:04:20 +0200
Message-Id: <20221018200422.179372-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018200422.179372-1-ardb@kernel.org>
References: <20221018200422.179372-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2469; i=ardb@kernel.org; h=from:subject; bh=MVStoeot+9N481gE+IzlwIXraNYXd9DYcPzHHvi46mA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjTwbB0vEsO+UUZuKB7qbu1LDJGNo0I6eQ1XIqe/mZ RwGA+96JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY08GwQAKCRDDTyI5ktmPJJ2ODA CzpKqOcxqbWKEsMOqTlNNNDhne786zvI/6KPWRts8eFO6WoJFJdvCnNJbilvcBXoam+WCUXVt+lkmX k97ylURwH71fT56A2AeFyempCRxEmWJRI7MKCq97lMoU+k+0Wk8seLTKEi9VZJlxiz3NFn75ZIVf5t ihThRDxf1yuNKHdqM8gIpN3UJx9Hk5I/qEixW2GqYk0wKdChqrxfZbo00OW/XckbtmMlNUXNH5vvTh Luhucm4j4CWzpnMmQO3qTvWCA/Is5SIa56DiBD+GwynotJEj8X11uh9kijAfr2W+8T6FMBxacc1wny AJ9dWt7w+YDHEkea2NTC0wI4trMhS0srjtHcsG33uiaJndSGEQsngmMXuObWQBrBISPT2nsVFWElB1 goSiNOg+8fKvi9FUCAc7k8YmVROMiyNi5CPGDDYhY+UV2atGjMdp8ZyNjsQnhCYNOZjSMPA9vb/0Dm INv5SJpP6Pr+KXaFaLDmqUxaH8EYZ+OA34S3XKRz1jGHA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gf128mul library does not depend on the crypto API at all, so it can
be moved into lib/crypto. This will allow us to use it in other library
code in a subsequent patch without having to depend on CONFIG_CRYPTO.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig                    | 3 ---
 crypto/Makefile                   | 1 -
 lib/crypto/Kconfig                | 3 +++
 lib/crypto/Makefile               | 2 ++
 {crypto => lib/crypto}/gf128mul.c | 0
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2589ad5357df..a466beb64a69 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -175,9 +175,6 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 	  This is intended for developer use only, as these tests take much
 	  longer to run than the normal self tests.
 
-config CRYPTO_GF128MUL
-	tristate
-
 config CRYPTO_NULL
 	tristate "Null algorithms"
 	select CRYPTO_NULL2
diff --git a/crypto/Makefile b/crypto/Makefile
index 303b21c43df0..d0126c915834 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -85,7 +85,6 @@ obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
 CFLAGS_blake2b_generic.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
-obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_CFB) += cfb.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 7e9683e9f5c6..2a4b57779fd7 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,6 +8,9 @@ config CRYPTO_LIB_UTILS
 config CRYPTO_LIB_AES
 	tristate
 
+config CRYPTO_GF128MUL
+	tristate
+
 config CRYPTO_LIB_ARC4
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index c852f067ab06..60bb566eed78 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -10,6 +10,8 @@ obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
+obj-$(CONFIG_CRYPTO_GF128MUL)			+= gf128mul.o
+
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
diff --git a/crypto/gf128mul.c b/lib/crypto/gf128mul.c
similarity index 100%
rename from crypto/gf128mul.c
rename to lib/crypto/gf128mul.c
-- 
2.35.1

