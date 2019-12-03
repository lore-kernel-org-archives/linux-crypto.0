Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4BEC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 18:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E0342073B
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 18:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="zvi8re4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLCS3V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 13:29:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38031 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfLCS3V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 13:29:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so4978819wrh.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 10:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from:cc;
        bh=izaN34JmJS+n1M1NHqECtRm+b+Hrz3/REW2P27r0Cl8=;
        b=zvi8re4d8FbzaLTO3YznPaNKAX/6rORnmDge6mrSzuGlcTIeyU1K/wythjB00aUxhw
         U+KVimceYJk0k9SjhJBkGvkqqhxgWOA8vZzsRVG9vKrqNBJdbnEoNKu0R3washCACfdp
         LZ8FfmKzwo5/feZJxIxJyualgj9mNQb+cdrEk33NH+5jl63yFcbmmEcq2MqBnYfI0Dmq
         buE8+n1H+mAWw210NwrOj2hjBYOWw3ywS4TlRRy3b3dL6kXg1Ivv+A6FwR+tn0y37n5q
         NMr0uzpNl5dXtHLMYey6unlLwsLTA9dlt6pgraAed2Bsj9swoyoHBsfSFbbD1V3HXQMm
         GM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from:cc;
        bh=izaN34JmJS+n1M1NHqECtRm+b+Hrz3/REW2P27r0Cl8=;
        b=alNq3VKL6yiaUT4ehwH6QEXA6fjYwKozQ+dir0HuA0/DhnaIDiFfiEeXymoEJqAU+P
         FhDw4sHBl9PFIwdpxXuSZyCkNKOaeomJCVFjdKtZbSSe2gwGbZDB6FyeL0upPzCXmkcI
         EnXOY+jJcN17VSHO2Qqlr1/ZWvuhd0ihWc7zoS65+idnJCTHyf6LdBK5Eo1EVGxxh8SO
         Vq8E8gDjAC+pPlboHhP1jMMpYPiP/IQOsd4PmEbUJ9FROmw7xEwFUKIcA/44npKfG7C7
         f4osiHWYY4LrRLaHEQlbTIoaSnzu8M1YwUvqFw4wyfYLCUuBdM/Yzir6AwtxwgN9NlIU
         ocTg==
X-Gm-Message-State: APjAAAXocaHt2B/9lGhEdA/GHFTZegKQ6jvNSp4O/6nXryPP7Ba2uRpm
        qpm1BmwS8Hm11p9ROMEFkFFo2A==
X-Google-Smtp-Source: APXvYqzBc3aTfWdtvsffqAHGFcl8oQT1EAbnBqIfbH6wvtlUeG3D5PvilkdWueBAbSdKRoHh+JKvtA==
X-Received: by 2002:a5d:6901:: with SMTP id t1mr6351011wru.94.1575397758768;
        Tue, 03 Dec 2019 10:29:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z7sm3711973wma.46.2019.12.03.10.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 10:29:18 -0800 (PST)
Message-ID: <5de6a97e.1c69fb81.21c1a.34e9@mx.google.com>
Date:   Tue, 03 Dec 2019 10:29:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: bisect
X-Kernelci-Kernel: v5.4-9340-g0fbf7aea0d8b
X-Kernelci-Tree: ardb
X-Kernelci-Branch: for-kernelci
X-Kernelci-Lab-Name: lab-collabora
Subject: ardb/for-kernelci bisection: boot on bcm2836-rpi-2-b
To:     broonie@kernel.org, khilman@baylibre.com,
        guillaume.tucker@collabora.com, tomeu.vizoso@collabora.com,
        mgalka@collabora.com, enric.balletbo@collabora.com,
        Ard Biesheuvel <ardb@kernel.org>
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* This automated bisection report was sent to you on the basis  *
* that you may be involved with the breaking commit it has      *
* found.  No manual investigation has been done to verify it,   *
* and the root cause of the problem may be somewhere else.      *
*                                                               *
* If you do send a fix, please include this trailer:            *
*   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
*                                                               *
* Hope this helps!                                              *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

ardb/for-kernelci bisection: boot on bcm2836-rpi-2-b

Summary:
  Start:      0fbf7aea0d8b enable extra tests by default
  Details:    https://kernelci.org/boot/id/5de6679c1d38df5638960f64
  Plain log:  https://storage.kernelci.org//ardb/for-kernelci/v5.4-9340-g0f=
bf7aea0d8b/arm/bcm2835_defconfig/gcc-8/lab-collabora/boot-bcm2836-rpi-2-b.t=
xt
  HTML log:   https://storage.kernelci.org//ardb/for-kernelci/v5.4-9340-g0f=
bf7aea0d8b/arm/bcm2835_defconfig/gcc-8/lab-collabora/boot-bcm2836-rpi-2-b.h=
tml
  Result:     0fbf7aea0d8b enable extra tests by default

Checks:
  revert:     PASS
  verify:     PASS

Parameters:
  Tree:       ardb
  URL:        git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git
  Branch:     for-kernelci
  Target:     bcm2836-rpi-2-b
  CPU arch:   arm
  Lab:        lab-collabora
  Compiler:   gcc-8
  Config:     bcm2835_defconfig
  Test suite: boot

Breaking commit found:

---------------------------------------------------------------------------=
----
commit 0fbf7aea0d8bccba3d00706f46c89716fa982f9c
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Tue Dec 3 12:29:31 2019 +0000

    enable extra tests by default

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5575d48473bd..36af840aa820 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -140,7 +140,6 @@ if CRYPTO_MANAGER2
 =

 config CRYPTO_MANAGER_DISABLE_TESTS
 	bool "Disable run-time self tests"
-	default y
 	help
 	  Disable run-time self tests that normally take place at
 	  algorithm registration.
@@ -148,6 +147,7 @@ config CRYPTO_MANAGER_DISABLE_TESTS
 config CRYPTO_MANAGER_EXTRA_TESTS
 	bool "Enable extra run-time crypto self tests"
 	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS
+	default y
 	help
 	  Enable extra run-time self tests of registered crypto algorithms,
 	  including randomized fuzz tests.
---------------------------------------------------------------------------=
----


Git bisection log:

---------------------------------------------------------------------------=
----
git bisect start
# good: [b94ae8ad9fe79da61231999f347f79645b909bda] Merge tag 'seccomp-v5.5-=
rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect good b94ae8ad9fe79da61231999f347f79645b909bda
# bad: [0fbf7aea0d8bccba3d00706f46c89716fa982f9c] enable extra tests by def=
ault
git bisect bad 0fbf7aea0d8bccba3d00706f46c89716fa982f9c
# good: [25cbf24a7eec7c3dee4113b2e98b572e128009b7] crypto: aead - move cryp=
to_aead_maxauthsize() to <crypto/aead.h>
git bisect good 25cbf24a7eec7c3dee4113b2e98b572e128009b7
# good: [7b19c7a82950ed034645fa92adce29cd6163ed3e] crypto: testmgr - check =
skcipher min_keysize
git bisect good 7b19c7a82950ed034645fa92adce29cd6163ed3e
# good: [062752a354aaf03b46b86cba5fdaa2fd5c932860] crypto: testmgr - create=
 struct aead_extra_tests_ctx
git bisect good 062752a354aaf03b46b86cba5fdaa2fd5c932860
# good: [2cd56a00fff8584e342164c65e6b55da61f79c4a] crypto: testmgr - genera=
te inauthentic AEAD test vectors
git bisect good 2cd56a00fff8584e342164c65e6b55da61f79c4a
# first bad commit: [0fbf7aea0d8bccba3d00706f46c89716fa982f9c] enable extra=
 tests by default
---------------------------------------------------------------------------=
----
