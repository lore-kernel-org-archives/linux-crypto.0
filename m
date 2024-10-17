Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B572B9BC;
	Thu, 17 Oct 2024 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123336; cv=none; b=IlCWrvSrGOIyipfs6aYq4Z4f65MZpUVI7xSKxyZ4m6+eK2Z6NGlZOCCrew8johMNyLDoPP307mU6Yx0sTB7FoCgMN+8TXEWQlk6sdEMngRMmEtT/stEteLtjGZdhD9+So+7zn6A1qQUswqCU09bQwNSM95u2GBsPIDIb7tYHZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123336; c=relaxed/simple;
	bh=hYzZxMzvH6bhj9Qc158JhHNrZoSgHCIZdmOezInyl9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVB49+4NKGwQb8lJ63DKNKyvgCKh6kA41KeOzM3FeutEJ+S2W8jSfMyXca1SrHfnPTyKOHPcBbJPVgmImUJ7H01AgrrE+JtO1A08tYpmn/7iRx2TJIbZpd5jKvFgxwGb4ukwASlzt1bFjOb0eMiGysX2NG2RvsYFAN/lKbDIWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRt7VT4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRt7VT4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956BBC4CEDA;
	Thu, 17 Oct 2024 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123335;
	bh=hYzZxMzvH6bhj9Qc158JhHNrZoSgHCIZdmOezInyl9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRt7VT4yqdUDci1D4NMkpyRyDO/GlRMb9tHP63k7yvAOd0x0lBd/jbcoHt+OqG8VY
	 UfoiYKdcseqn2Vc8o35sTKVZTBlvvtDX24a+98NJqP9pu8I4YjwI+pXXuif2627LFz
	 wXHPASgDbLS5wIWioEJi0g0uuE6pF6y0bZVFihOrOYQewSt73amfwG4IW18VupyFrO
	 D5lCm9WLWJlKn/GnM9CHpxOLHu5sH6nOydHBI/CNAmIsNDI4mIPIoZ3pIM/DDmR7tb
	 iTsW85DnTj8E0JxcJQyoOvjkUNDdQyZSeCWngioIzXGvxIKEfxiDKgPD1qGAHtBRoC
	 zabntDlaCf/5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] crypto: x86/aegis128 - remove unneeded RETs
Date: Wed, 16 Oct 2024 17:00:51 -0700
Message-ID: <20241017000051.228294-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
References: <20241017000051.228294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove returns that are immediately followed by another return.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 42f25fea4e082..7294dc0ee7baa 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -276,12 +276,10 @@ SYM_FUNC_START(aegis128_aesni_ad)
 	movdqu STATE1, 0x00(STATEP)
 	movdqu STATE2, 0x10(STATEP)
 	movdqu STATE3, 0x20(STATEP)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
-	RET
-
 .Lad_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_ad)
 
 .macro encrypt_block s0 s1 s2 s3 s4 i
@@ -369,12 +367,10 @@ SYM_FUNC_START(aegis128_aesni_enc)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	RET
-
 .Lenc_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_enc)
 
 /*
@@ -504,12 +500,10 @@ SYM_FUNC_START(aegis128_aesni_dec)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	RET
-
 .Ldec_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_dec)
 
 /*
-- 
2.47.0

