Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8072592;
	Tue,  2 Jan 2024 06:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anPdWyAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD24AC433C9;
	Tue,  2 Jan 2024 06:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704178220;
	bh=nsJfxzeMQv5O8Qx1VjRmXPmszEADwolhj0yHfx5D/74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anPdWyAQc4OldYWoDG3/Qx2GKPTJX8ENGqrwU5HD3FYzCzs5gi7nGGCJhKdadGucD
	 6UYhGgSBEjqq/ybXUmaiGJIR5D2V7/B8r2tKyFqm6EpD/BmihHEe6HhDt4oHKpF/IE
	 P1oOj2MN+Z/n9mzwuViN3bII9vKjRUpX47zdFe9XUI+yE/A71RQSsIXbU9OhTMZhOq
	 gobyOSH5yprvo0759gUY71T0U6NxkOnOrsBq3+f54VmEmcSWz5ATStJ6DQ8iAi2gdJ
	 KajkksRDzd5WVxoGP9WO1qqWMIVhUckvXhzSA4WHBISvzKaZed7GtS/9kslZHeMoSe
	 F+gfVVZ7uBKPA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Jerry Shih <jerry.shih@sifive.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Phoebe Chen <phoebe.chen@sifive.com>,
	hongrong.hsu@sifive.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andy Chiu <andy.chiu@sifive.com>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [RFC PATCH 03/13] RISC-V: add helper function to read the vector VLEN
Date: Tue,  2 Jan 2024 00:47:29 -0600
Message-ID: <20240102064743.220490-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240102064743.220490-1-ebiggers@kernel.org>
References: <20240102064743.220490-1-ebiggers@kernel.org>
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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/include/asm/vector.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 71af3404fda14..ae724e016fe24 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -218,11 +218,22 @@ static inline bool riscv_v_vstate_ctrl_user_allowed(void) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_vstate_discard(regs)		do {} while (0)
 #define riscv_v_vstate_save(task, regs)		do {} while (0)
 #define riscv_v_vstate_restore(task, regs)	do {} while (0)
 #define __switch_to_vector(__prev, __next)	do {} while (0)
 #define riscv_v_vstate_off(regs)		do {} while (0)
 #define riscv_v_vstate_on(regs)			do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
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
2.43.0

