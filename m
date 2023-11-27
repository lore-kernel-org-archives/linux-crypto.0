Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="U0MvI4S/"
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1AE12F
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:16 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5c2ad6a5515so1045038a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068836; x=1701673636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AQWefridDFzEX+S3QZsEdRxceu5Syx5iK5d77pjmdM=;
        b=U0MvI4S/Fs3gjOilMQuu49WHu6Aof9dzgAdbM5Gsk8W2BqwNx80zFGD484TPqf1t1u
         VX6fURDhE6Xyt2X5Wqw4IqvWlNuldcazkBUpcL6P1C+peZcn/qbD+irTxJ3OZ/XbC8Od
         r+Y9F/wjZe+ke/gjwQF3IJ4xclvHIMEc7zIlxVAb53S90NFgYS/+V+eaj37ztdMXvwt0
         pa6NaxRroYqM1FK6Oy0vbX5zt19f1YXjVJ2XP/DbsDN3hhOSRx/mjg2ZkenjuTiFlKRc
         E8LFZV1h8EuWLPOmsY/pgCi14KZ+vAybmubgh4dcIMWehM4v741xreEDFeTA75jy38+3
         SpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068836; x=1701673636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AQWefridDFzEX+S3QZsEdRxceu5Syx5iK5d77pjmdM=;
        b=ruSsDlExjof3lzNQwfIwYNHDe8DtzGQH90AhxSOVPNpwO8IkEQDN7PxuXDiCy2dYXZ
         EnL9l+6GKyQJmjBGNu7EuaDhjpY9pl8h3OEOanL1zhvey2DlR7xofWGTZsWqzX6IdobL
         reBzhtbe0mq73LhMG0ZvmRC8T0WTOO9Ff/j9S5FPmgVhOl1Mk2LlF/d2TtFFfJBHJ7Ig
         JqI1UgXy7i1vnsnGIUmWOaskXzGSKMtplSCPeImTnWd9wTIl+G+dWXIwGSWN7NLiVqXO
         U+Qr4cMSX2ukpPd8R8eOH6DdvcrE2bbN0KPhVvy4N/q2H2dwz2EdRI7aC3CobXi9Z/fA
         XZDw==
X-Gm-Message-State: AOJu0YwaXovKKEbnOYw5/4JXUzHeOw8JE4Z7W05QvfYeCzdK1MZPNSI5
	SawPL69IoU2R8aUdXwAQ4xPx9Q==
X-Google-Smtp-Source: AGHT+IEfgbssJ61TZlq0d2dhxDtdtwhMhkAYzY1cvNJK6+MKTZHhqLX3gJHGHb4gNjKA9hC/r5Pzfg==
X-Received: by 2002:a05:6a20:d48e:b0:187:3b1f:219c with SMTP id im14-20020a056a20d48e00b001873b1f219cmr12639143pzb.10.1701068836407;
        Sun, 26 Nov 2023 23:07:16 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:16 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 01/13] RISC-V: add helper function to read the vector VLEN
Date: Mon, 27 Nov 2023 15:06:51 +0800
Message-Id: <20231127070703.1697-2-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231127070703.1697-1-jerry.shih@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

