Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2193C07545
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 18:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbjJYShG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 14:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbjJYShB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 14:37:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C29115
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so91978a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1698259019; x=1698863819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AQWefridDFzEX+S3QZsEdRxceu5Syx5iK5d77pjmdM=;
        b=BEk/TZiyK9j8wTcqs7wcZdkD0N+ykp+xXIBbXRNUL9uCTlc9wcGaIJhk3jJ4wlWBmN
         4CyoPG5wg8UnGZLqnLHvjRnfggn3SP7l+ThtNAMXeUWbhmIrZSeuwhJG2/sJlxvi/2Vz
         e9/YTTyBokdGQFJhPDNCXMqnGrQPJYkd7IcIx0WgErwVX623U8vgo5ipUY91SDucXeBt
         7fpqvk2JchFvE2BVh9YQR3VanCGzZ6G1OP+MdDqS7+YtxnX3TZIsz01NBqHYWUEv3ZV6
         9+XPxx1eSBiVkdfyclPoQbAVgIPKKbuiEoYHzi8DmI1oLvQ9uyTIKCVAs2YYfHgddsYE
         b8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698259019; x=1698863819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AQWefridDFzEX+S3QZsEdRxceu5Syx5iK5d77pjmdM=;
        b=rhJwCtGayfhqXQWxcKaZwe83f+ir5hyXzNdFE64w6Rf1rI/pt07y/h64GoPkw4KZjl
         Ks5iCQah3NTK1QHdvT5w94T+WEM2j4VH8ld1VT+jd62G4v0dZkZUAYhbk2g92l4PilaS
         gtgEVKW295n8K82VRjtlVkZt85RSJ3DRYozndSBrHmQQYKvSouh8C1WQ8CjGphum1OxG
         5Bi8SCYJRKMuc4GJ24lOGsCQLleQXBypIgQ183uPwaN40kXbSbgewrSITChZGAKCDRA0
         HXF28dGfE9ugzAE6W48B54sfCjaqNLdK6LjXvqC8UciRfBECQOblfvlnmVHQQr3TUPUz
         9twA==
X-Gm-Message-State: AOJu0YyRtDAkPD9//E6uVt66+uIQZxB/hGnJ+MKFq9ih5TNRgMcHklBt
        vW7jI9NLRZ+3z9q8tQ83u62Z+A==
X-Google-Smtp-Source: AGHT+IFi/NboaaxSjvkdMStkpkrWMbnIqk4WWFJWYRx8koDO2Zab0WQxKwEoeYJQcTe6ecrly6nnFw==
X-Received: by 2002:a17:90a:17c5:b0:27d:2100:b57c with SMTP id q63-20020a17090a17c500b0027d2100b57cmr14411038pja.37.1698259019481;
        Wed, 25 Oct 2023 11:36:59 -0700 (PDT)
Received: from localhost.localdomain ([49.216.222.119])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090adb0300b00278f1512dd9sm212367pjv.32.2023.10.25.11.36.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Oct 2023 11:36:59 -0700 (PDT)
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
Subject: [PATCH 01/12] RISC-V: add helper function to read the vector VLEN
Date:   Thu, 26 Oct 2023 02:36:33 +0800
Message-Id: <20231025183644.8735-2-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231025183644.8735-1-jerry.shih@sifive.com>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

VLEN describes the length of each vector register and some instructions
need specific minimal VLENs to work correctly.

The vector code already includes a variable riscv_v_vsize that contains
the value of "32 vector registers with vlenb length" that gets filled
during boot. vlenb is the value contained in the CSR_VLENB register and
the value represents "VLEN / 8".

So add riscv_vector_vlen() to return the actual VLEN value for in-kernel
users when they need to check the available VLEN.

Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 arch/riscv/include/asm/vector.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 9fb2dea66abd..1fd3e5510b64 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -244,4 +244,15 @@ void kernel_vector_allow_preemption(void);
 #define kernel_vector_allow_preemption()	do {} while (0)
 #endif
 
+/*
+ * Return the implementation's vlen value.
+ *
+ * riscv_v_vsize contains the value of "32 vector registers with vlenb length"
+ * so rebuild the vlen value in bits from it.
+ */
+static inline int riscv_vector_vlen(void)
+{
+	return riscv_v_vsize / 32 * 8;
+}
+
 #endif /* ! __ASM_RISCV_VECTOR_H */
-- 
2.28.0

