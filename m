Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497222B8B6
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907207; cv=none; b=rYMHfR5zEEvA1BzxReOong6YvzRPeQ1J3jprYb5KjsAAp3ttBBsNThqCDBirko5r6rjaegaUjJR6Ce4J4Nk/CInmJ2BA6w/ErIH8DvREY4weWl7QcvcJRXMhWcOCSn/PRZYm/vYRYm+oMYdK6ewKrOhBytTEb8BEUTxvx3Wy8zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907207; c=relaxed/simple;
	bh=fX9clgG/AwrnKocsdMCV+xHB+ouI4s9+Hm3T3/663k4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJA9N0sXP/w6a4ZB5ME9yjWaQXny+K3gRjMzbOHxnl9dbctcDDf/rHFGAhTEz5cb6iODOq4dKBrhnV3+/lKJ1yJIFfdXZ8kMLeKfNc/A2xfO7UH1gXbfPY6Fc4hcSOQCyuy9iC9J9OYQm6GvOVkqdLCcbJqkSsMfxiwSQ1Cmw04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YAVGLrKR; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YAVGLrKR"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-471001b980eso13667115e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907204; x=1762512004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Xa3/Awesw6OMt3PSs2q2cBtqduLAjKaT7ji9cCCq90=;
        b=YAVGLrKRkzeQSotkiwpeCO+SSVOfJ0dUgCtrAbA0e6UUDwyhKykh4Y3INdlWhio/wj
         pAGyTUKkYM9kc0X4irzBaIfRHj0/cVISJRGxz6DJ1DPeaajmfvdTwkxHCUx5q45P//nN
         NyNdN8pssPmV1tZkLH69HZMhWkb6JA19leWs/RU0uExmWb9ets8NnAUErbL7cowCJTf3
         RrE3kyU7dwyC1iYVkC/buEsVf5bPdYGM1tvY17LoSymp6QVm81HU3qKQVfkp+vKQnR6X
         WQa5dqMpikxdBu2S09g9jTYwOTL1d3UuE/WvbKtlzAqAZZ0deptuhBuXYx0wODSlPRSz
         I/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907204; x=1762512004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Xa3/Awesw6OMt3PSs2q2cBtqduLAjKaT7ji9cCCq90=;
        b=gKJM7ocWGRWFJR1+fhBL2oOSud0MArBf6TF45ISznUQ/HFFOWyMRiynZSGGcJubSY2
         9FKsWIMhyOLCJCW22gk7tWY26RYObAUfooep7VTnj4ELThfmIKWcRxvgL1GjXmP3NK6X
         vHryjf4+lvplRKQ0sEYX8OSeyXnmRziMKhUQuaIWlLPnAZ2xQHEdIVdBURgFxEvgKehw
         ej2WisP3WtLeufM12PkroaM+ZvMmrYWONeYMU9GjzE1MlCNQIIpn1LLnLcWC2fXLMN+l
         7RSeM+2QOU8g+jyaKO9T5WbE++/bvjJkQAbxNqbcHUTwnmo3Oa+jTDgFdEQGa7UjhbQi
         IcwA==
X-Forwarded-Encrypted: i=1; AJvYcCXBE2i7ndQ5acAHKBNK3DiJKq7iDeU1T3pIwGkTZmnNsS0uDG35gsn5Su0kcd0h372VFbSEgllAlG+5hWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwatTCOp5EXqLhXztSvUJlYuX68LQ9b/a1+/uItzOtgqcfeRsSS
	7zH8mVb1pt7LgwAY8bjo7eqP3NhJAI71j3pvtlBJsPQjYRUfdNX2zLmm3UnQLOqPsPs/lqthvQ=
	=
X-Google-Smtp-Source: AGHT+IFG1Dv0rjVcEt2/0GVVIUFS+KzXMYU0UsEadz9yjstPJXyipRoXNOS4eHXBONiuPbDNnDbrnIrq
X-Received: from wmwq8.prod.google.com ([2002:a05:600d:8348:b0:476:4b14:2edf])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:538e:b0:46e:33b2:c8da
 with SMTP id 5b1f17b1804b1-47730890e99mr28895635e9.32.1761907204019; Fri, 31
 Oct 2025 03:40:04 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:18 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1914; i=ardb@kernel.org;
 h=from:subject; bh=JNFlhs5YlNOgtpbYMnFMguYKcFlrOPN7ItLaOkFoa/A=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4r3azVwKvxa+e+bzxvzhjJCoDf0pmzLzjxfveskbc
 3b79c+sHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiL3IY/qmunjvvbXvjWee2
 punuZxcfZXy6++W/uyz//fM8bu+WUnjF8D/61YbAlb+lv9pt6nmpE1ux7mTG++LWrclW3s33r5W svsEDAA==
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-42-ardb+git@google.com>
Subject: [PATCH v4 19/21] net/mlx5: Switch to more abstract scoped ksimd guard
 API on arm64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of calling kernel_neon_begin/end directly, switch to the scoped
guard API which encapsulates those calls. This is needed because the
prototypes of those APIs are going to be modified and will require a
kernel mode FP/SIMD buffer to be provided, which the scoped guard API
will do transparently.

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
index 05e5fd777d4f..815a7c97d6b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
@@ -9,6 +9,7 @@
 
 #if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
 #include <asm/neon.h>
+#include <asm/simd.h>
 #endif
 
 #define TEST_WC_NUM_WQES 255
@@ -264,15 +265,15 @@ static void mlx5_iowrite64_copy(struct mlx5_wc_sq *sq, __be32 mmio_wqe[16],
 {
 #if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && IS_ENABLED(CONFIG_ARM64)
 	if (cpu_has_neon()) {
-		kernel_neon_begin();
-		asm volatile
-		(".arch_extension simd\n\t"
-		"ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
-		"st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%1]"
-		:
-		: "r"(mmio_wqe), "r"(sq->bfreg.map + offset)
-		: "memory", "v0", "v1", "v2", "v3");
-		kernel_neon_end();
+		scoped_ksimd() {
+			asm volatile(
+				".arch_extension simd\n\t"
+				"ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
+				"st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%1]"
+				:
+				: "r"(mmio_wqe), "r"(sq->bfreg.map + offset)
+				: "memory", "v0", "v1", "v2", "v3");
+		}
 		return;
 	}
 #endif
-- 
2.51.1.930.gacf6e81ea2-goog

