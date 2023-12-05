Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="npuOWRMl"
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4D298
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 01:28:15 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5c21e185df5so3051731a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 01:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701768495; x=1702373295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+Duv2eL4Rh6BmoQvomNjrPNP7WadF4MX+fx63CbvwQ=;
        b=npuOWRMl7QM4Mt3i1dtM3vrIJQJeroBuwn1gjmvWDNQY6qx6lD0SyRMTuU/lLEq8/x
         90lm00lWlHm89Yo4KOdOnePWBUSXN3JLLcNYRwScPja02eOnqzwpELIa7Um7TIPftpho
         3LBCfrJ+uzgOGED/nWL0r7ORz/xms0o1//MPlIDMXv4khxkUJpN6kio4ShhknsO29KHJ
         RYcl5sX9Yd7yXoAB0ryc7A0uJerxYBMCZs3vfMLDKINIU8n67rdkRj6f+ntdkl2kIzPF
         3znjaQIIv0AOqzeaqOKc8PSAOFVa0pOViUsWNUsi6ByycoQ0jyNMmw57JRDVExxM8wpy
         hRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701768495; x=1702373295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+Duv2eL4Rh6BmoQvomNjrPNP7WadF4MX+fx63CbvwQ=;
        b=f07F5gO7tMYnbrc09TD3iOY6SEx84739e9eVwntjJGJZEKqNhAeftAj4E6jQibhuw/
         lTWS5YxdIRmX4QccNsiQHkqTRts+UXaqgwaMJ6/QOa5s4un1/fddOcHCrHtjdwc/6zRR
         UV1GJ4/pFGs3oedEKM2srh1KqXr+CKBSx5TwCXuLDn+PHWfnNrb/dxXpGixQujIUQcty
         fck6ObQMOdbwazp2ljaKSRsHGfcohfNkM/oQIkakqdUbRAHz5SEFammb2yC6plbNLgF+
         fxDXazZpqMNH13ycjTsFKcVXhVN5glpIZCLSDuEtbmm4dhJ2IXAUJmiZFBDqo0icmnuI
         9Q1Q==
X-Gm-Message-State: AOJu0Yxg7Yl8rCSQyDjx8wFfm/BB1p+ck6rb7R0hZiys02V1T4Raa1hb
	R5wwUjfAzbBsS7jo4o85e5GaxQ==
X-Google-Smtp-Source: AGHT+IHo8qyIK+a7xAlqBDFbhHitNbdyhcjGou5e7sEK1zHUFcXdJWS5bgBXVVX5Sw11ZixDo6r/6Q==
X-Received: by 2002:a05:6a20:160a:b0:18f:97c:9778 with SMTP id l10-20020a056a20160a00b0018f097c9778mr7394313pzj.96.1701768494761;
        Tue, 05 Dec 2023 01:28:14 -0800 (PST)
Received: from localhost.localdomain ([101.10.93.135])
        by smtp.gmail.com with ESMTPSA id l6-20020a056a00140600b006cdd723bb6fsm8858788pfu.115.2023.12.05.01.28.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Dec 2023 01:28:14 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org,
	conor@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v3 01/12] RISC-V: add helper function to read the vector VLEN
Date: Tue,  5 Dec 2023 17:27:50 +0800
Message-Id: <20231205092801.1335-2-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231205092801.1335-1-jerry.shih@sifive.com>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
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

