Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245C4C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 18:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjJYShN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 14:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbjJYShG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 14:37:06 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F370C18D
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-5aa481d53e5so89031a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1698259023; x=1698863823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMA+62ieF0dHRmbCC9GfwETOr1r4110ste5ly+nBz6U=;
        b=FyWciSEhZaGJi8lq7OaF4XxWpflQgxldWhG6M26PCik/FEGWr34IA6SU/ZdBsMIHTX
         Oyy+CKsNHq4yAY72nJdPnnqTEHomF4+Plx1qJo10VfZk6kBZ3ySTdt/s7tfTi43MdpZR
         2QfHo2UlX8dm4jA9mZ+Vxk2SSn50k8wCOSD1zZPGtoISqSFeqmP/pAj9Ki3bwNLMWCyg
         LELHMhQWVZCFg5Xa6HBqakc7k4kxSs1uTcO67ZVNLphRIwNODEnUyo/WSNy9pw9zWnnw
         42XvCPdhdSlob8q2WnfGH9l8iWjBxsb6JnpPu8vYwCxT27+DeLD+9KNYSbriEfcKs1I1
         Og2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698259023; x=1698863823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMA+62ieF0dHRmbCC9GfwETOr1r4110ste5ly+nBz6U=;
        b=cNf580UlRCUzLDqsuPG9kF8S5BpsmYxt3P786KWCCPzDsyvprqU5LVLcgWlTWnpyXI
         wz/VhyPMpWwMI9iDhjRzj+x0vbHtyAp5hZ6yuYym+UUlHnhOR/kzIr/22VWqVM+m0g7l
         ThEYIdJqi1VMhU7CDXDPOxe5ZOb8QhneJpVV8L5Rt1qJaT5iST26aWgoZpXju5+TU1Pz
         zLMn+wXXnK2MQZZrmSjit70VWzFVyoNbuAQc2vWeA4CeDzEpoY+9Blv7o+HzIsZ4QbXv
         46jRkY5d48vW3WxDqHQHKidQNiM9psbyvRf5ETpgp4DOin11mTeJUq7sqDnmctp8m6zh
         FaaA==
X-Gm-Message-State: AOJu0YwLaDDrBk3bSHRIWQ02qrWIb1TS0p+rwrXwFwvFcVzw7lshJjHh
        ath/SwJFeOJf3AwXIjkZTrzmKQ==
X-Google-Smtp-Source: AGHT+IGWiBP6XA7K/f/VG9hs7DTTqjpeQ8mNNk//GZj6Js6XKPfQH2D4dC63vtWJoNHA/uNws80I8A==
X-Received: by 2002:a17:90a:7889:b0:27d:1dc:aa5a with SMTP id x9-20020a17090a788900b0027d01dcaa5amr15159894pjk.23.1698259023367;
        Wed, 25 Oct 2023 11:37:03 -0700 (PDT)
Received: from localhost.localdomain ([49.216.222.119])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090adb0300b00278f1512dd9sm212367pjv.32.2023.10.25.11.36.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Oct 2023 11:37:03 -0700 (PDT)
From:   Jerry Shih <jerry.shih@sifive.com>
To:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     andy.chiu@sifive.com, greentime.hu@sifive.com,
        conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
        heiko@sntech.de, ebiggers@kernel.org, ardb@kernel.org,
        phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 02/12] RISC-V: hook new crypto subdir into build-system
Date:   Thu, 26 Oct 2023 02:36:34 +0800
Message-Id: <20231025183644.8735-3-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231025183644.8735-1-jerry.shih@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

Create a crypto subdirectory for added accelerated cryptography routines
and hook it into the riscv Kbuild and the main crypto Kconfig.

Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 arch/riscv/Kbuild          | 1 +
 arch/riscv/crypto/Kconfig  | 5 +++++
 arch/riscv/crypto/Makefile | 4 ++++
 crypto/Kconfig             | 3 +++
 4 files changed, 13 insertions(+)
 create mode 100644 arch/riscv/crypto/Kconfig
 create mode 100644 arch/riscv/crypto/Makefile

diff --git a/arch/riscv/Kbuild b/arch/riscv/Kbuild
index d25ad1c19f88..2c585f7a0b6e 100644
--- a/arch/riscv/Kbuild
+++ b/arch/riscv/Kbuild
@@ -2,6 +2,7 @@
 
 obj-y += kernel/ mm/ net/
 obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
+obj-$(CONFIG_CRYPTO) += crypto/
 obj-y += errata/
 obj-$(CONFIG_KVM) += kvm/
 
diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
new file mode 100644
index 000000000000..10d60edc0110
--- /dev/null
+++ b/arch/riscv/crypto/Kconfig
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
+
+endmenu
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
new file mode 100644
index 000000000000..b3b6332c9f6d
--- /dev/null
+++ b/arch/riscv/crypto/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# linux/arch/riscv/crypto/Makefile
+#
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 650b1b3620d8..c7b23d2c58e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1436,6 +1436,9 @@ endif
 if PPC
 source "arch/powerpc/crypto/Kconfig"
 endif
+if RISCV
+source "arch/riscv/crypto/Kconfig"
+endif
 if S390
 source "arch/s390/crypto/Kconfig"
 endif
-- 
2.28.0

