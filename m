Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794430588;
	b=a/H1iSVqFCja4RXAz0VoyPyl0zGdr1rAvXAhIPK1Hiifhz2JXfDEapvUeTU/L0VyZGpw
	 nPmitMVrKb/R9fAIoQ01yXQ+zKIJm1CjvbbrcZFZliKPWBuSVhFMmbaKXhOSBxb8tQOyv
	 ZAT2gGJaJYxifD+D+YiD857kPAkYg6GNYHNW41YXbGS+D4hgg0qwqXJ+zzB2n9AZrJJj2
	 xtRjWjqVPoWXnr6FFRdDJYt9sQdLZ64P0JcvECGSJPs/2fHIGX4YK/axGet5MgP/m6e8+
	 /SRoWR8Amj35xz+lPMVgNsoAGaC4v2K3V0IwR01GQ5VAtvlJmHgezNFAvV5i/NYftPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794430588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LakMs+wtn1m3CzZ2hkmWvtzX5MOXWNVqhrGKQCuUvkk=;
	b=V/JlUpuRg94Qf4G2EHmcKMbQQ80yD1sBotCchlLvU/dmEbPKQwxHKjX0YO3nBJGaE3mV
	 p7gTpIrlC+TC296kz2IvPWze4H8JDdh5oPHZb2E277jvDO6mJV1dLdBhilBgJmTBM/YyW
	 F9Jz9WYTwPc1Ad9QnQRkD2CFUM/3ccFA/6TbG/uFdYlk+OURf/MUFpwCQQ1305CCbmthg
	 TmsjjKPrsHluRgQeoSTpvhbzIrTuo9CYuJHnnzDfZSkNG2Shh2s8f8rbwVbDU0cLr/+VO
	 wWlmUtchaJxg9ZYms15vdPKmv8Etw8rnIWzfB96Ksjtnj+r9ik7aDlv5+IQJT0QcVNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TV+N+MmM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78662606A32A;
	Wed, 11 Nov 2026 20:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TV+N+MmM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D81F00A07;
	Wed, 11 Nov 2026 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794430588;
	bh=LakMs+wtn1m3CzZ2hkmWvtzX5MOXWNVqhrGKQCuUvkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV+N+MmMe8WlTqQ7YACg+O5jCow9RcMXqYu5CCqNQ5RMkQBlAZjop9Bn6drnrWRHQ
	 PQpxln21cVgx1NzDlO36jK07qkzEvxr7nCq7uQ+M13fwBgTrVRbx+DqRJbHClL4vYI
	 xg+jF9L9cndtSONM7xJvDYbwl42RayO0/AZOsQ/MdUhANNdmJCN/g3MKfS33CQTLKp
	 1J3C7MiZMON+rGrZF1oXZUHRypnlhuTbWMyq7wROoS6Sia/slg0qSdNIh+WMU5UU4h
	 vEi/Y47OVjdwKeUSh9IicQQOsyT3k7/FGRNOTtxLeINcbuy7tZVxOMco1g31ZWjKFD
	 fcjLRzdLdGWDg==
From: Eric Biggers <ebiggers@kernel.org>
To: akpm@linux-foundation.org,
	linux-raid@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] um: Define kernel_fpu_begin_mask()
Date: Wed, 11 Nov 2026 12:56:02 -0800
Message-ID: <20261111205604.47547-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111205604.47547-1-ebiggers@kernel.org>
References: <20261111205604.47547-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define a stub for kernel_fpu_begin_mask() on user-mode Linux so that
lib/raid/ can switch from kernel_fpu_begin() to kernel_fpu_begin_mask().

Note: this causes a checkpatch error due to the macro's value not having
outer parentheses, but it's left as-is for consistency with the existing
kernel_fpu_begin() and kernel_fpu_end() definitions right next to it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/um/include/asm/fpu/api.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/include/asm/fpu/api.h b/arch/um/include/asm/fpu/api.h
index 3abf67c83c40a..ef35d701dccff 100644
--- a/arch/um/include/asm/fpu/api.h
+++ b/arch/um/include/asm/fpu/api.h
@@ -11,6 +11,7 @@
  * UML code tree. */
 
 #define kernel_fpu_begin() (void)0
+#define kernel_fpu_begin_mask(mask) (void)(mask)
 #define kernel_fpu_end() (void)0
 
 static inline bool irq_fpu_usable(void)
-- 
2.56.1

