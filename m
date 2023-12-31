Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3AFBA2B
	for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2023 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="TGiNmJG7"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d3ea5cc137so63357165ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2023 07:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1704036483; x=1704641283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuCoCK+SW4zawUSFFv0erKPf4OwGQ3cihPvdb62nAAQ=;
        b=TGiNmJG7kgiO6iwMkVvaOG55cZTPy7o/ffaBqUuSV7X3owlmL2WcNqb2+mRm9eUGok
         CqeySdUs1AaREkBpiYR80ANy8w1bmGixtosjtWS32TzZzGHm1A0UNdGMU9x3MxTl8xSB
         yRTurWDUnV9Kf3n3tT6Sl5xvBgJdjCt/0HZ5FJYLZm/Rc8X/v9Eq5xmU9er4t4K4UcqJ
         6dJJEMaZOqsxSk0AK14HPj82am5teiZNlt5v4RD+WP2l4myQavcS3DtGMqKi2544/F1i
         EEXLBU7v9dNk5R2PwmsGEswSq7B1pz6WPAsopj20rwUWSPgSeM05L9SOTK/wAMPl6WxQ
         QjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704036483; x=1704641283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XuCoCK+SW4zawUSFFv0erKPf4OwGQ3cihPvdb62nAAQ=;
        b=l4Io6WPSyJjjBg97VO9fyhSnmKIsyUxNVs5+5QH4LGEfq/M6oJqg6PdWVM9n2Lxm+3
         HBckKHP2PKpbTrbtUp+vWWdNmh9pMcjK7ykMdp3vwGjO60vOrAswvOyv2+k53TImvRSs
         Q6Fdc4Ct2v0SKNKH6u9gM094TQg4BrqaJ07aqjCpbik3C23imWzeyZay7uZsvx6T+n5b
         0GV4TzKcXzspM5RX8WWrhgzYq5j5XgScTjevwHCCqP6zEuKN0lC6Q0MEG5B3y2UFs+mu
         bFCM8NuhKrBNPwWKRN+wfH4dj18KQgZntQ6DASyxYDx/lnybmwtH/NnYyT9QXopUmxt8
         M3IQ==
X-Gm-Message-State: AOJu0YyyJYJVWv2iVYhiS9PoHxjkcCt5BMU8g3PujGv8WRHhUA/vmsWG
	92Cb+OPHKQzrFJ4pFXnJZw4phRaVe0hnOg==
X-Google-Smtp-Source: AGHT+IFrXdhgAdCMZNHHFRjvOLoIEeS5k4qN1vslTS4fA+aVRSXmXy/wbfSG12vHdQUE2i/D13D4aw==
X-Received: by 2002:a17:903:1ca:b0:1d4:25ec:5975 with SMTP id e10-20020a17090301ca00b001d425ec5975mr20365331plh.10.1704036483091;
        Sun, 31 Dec 2023 07:28:03 -0800 (PST)
Received: from localhost.localdomain ([49.216.222.63])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902e54400b001cc3c521affsm18624430plf.300.2023.12.31.07.28.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Dec 2023 07:28:02 -0800 (PST)
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
Subject: [PATCH v4 03/11] RISC-V: add TOOLCHAIN_HAS_VECTOR_CRYPTO in kconfig
Date: Sun, 31 Dec 2023 23:27:35 +0800
Message-Id: <20231231152743.6304-4-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231231152743.6304-1-jerry.shih@sifive.com>
References: <20231231152743.6304-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLVM main and binutils master now both fully support v1.0 of the RISC-V
vector crypto extensions. Check the assembler capability for using the
vector crypto asm mnemonics in kernel.

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 arch/riscv/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0a03d72706b5..8647392ece0b 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -636,6 +636,14 @@ config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
 	  versions of clang and GCC to be passed to GAS, which has the same result
 	  as passing zicsr and zifencei to -march.
 
+# This option indicates that the toolchain supports all v1.0 vector crypto
+# extensions, including Zvk*, Zvbb, and Zvbc. The LLVM added all of these at
+# once. The binutils added all except Zvkb, then added Zvkb. So we just check
+# for Zvkb.
+config TOOLCHAIN_HAS_VECTOR_CRYPTO
+	def_bool $(as-instr, .option arch$(comma) +zvkb)
+	depends on AS_HAS_OPTION_ARCH
+
 config FPU
 	bool "FPU support"
 	default y
-- 
2.28.0

