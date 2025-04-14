Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181F28A1E9;
	Mon, 14 Apr 2025 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744652463; cv=none; b=fS4vbPI+Vbh5po64ksmLRR4OBzBHHbPfvjcSre3mlWIqD+ovTEg/PF9IIPCr5WAzx3omJfDYXhy6iGnwdbkavhOGmog2cQuWynR44j7xCO405sMg576DnWqhv3mX7OfTJPXQrBPEScLtyEhNHAlBYEkuiitnwIGtYAfrh7x7x+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744652463; c=relaxed/simple;
	bh=JGtuDrAIZbqWDfcYpvFO724uSw25Op9JJywY8Ih08pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jQdkYNOndRiOhErJ54f4iydwSzvA5Xjz99Ofz8f5UeY1CIqtwHKPzD8wvbZ9gVzV9SPRBFNnYjAJuVaNt/JB4DXhb8GZcjW8z+qLXkvq/2DE6b+45lf9Em+K7PseVxzoJSxVV1hWKQ34/8F+WzYewYzOObl7/BqXm0wF70E45AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDKMhpd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDKMhpd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B8C4CEE2;
	Mon, 14 Apr 2025 17:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744652463;
	bh=JGtuDrAIZbqWDfcYpvFO724uSw25Op9JJywY8Ih08pQ=;
	h=From:To:Cc:Subject:Date:From;
	b=QDKMhpd2GMCOX6pmZd5WG5+sNI8cSFZlUwiTOyQTghliWIWnz1LTl7DUDAd3Ja1+j
	 dS/IVSK5DX1qAUp3FKnScd6WXDWbNME0S7g6cD2qqoDzxOmHgyPB7s8KNUBxUqBf27
	 /+nWgkX5EUubaQshiKQFGIFOJhzaeD1EzatCirxvBpEgJ7fJx41uyq+FqQaM7dM36W
	 vQp1DBWopHfvXybzUG3n+lr/dKCfqgCouN7rCNCbIl+8yyr66QuY5Ir5+YErPuVjud
	 ODFG1sR8NjKVzlqXT1k7Zd3/Rpkh4aQXrZRx7z01GDFmtfN/x+HLXknS5yXPF7mkBM
	 gumiLvCNeUwBw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] arm64: Kconfig: remove unnecessary selection of CRC32
Date: Mon, 14 Apr 2025 10:40:18 -0700
Message-ID: <20250414174018.6359-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The selection of CRC32 by ARM64 was added by commit 7481cddf29ed
("arm64/lib: add accelerated crc32 routines") as a workaround for the
fact that, at the time, the CRC32 library functions used weak symbols to
allow architecture-specific overrides.  That only worked when CRC32 was
built-in, and thus ARM64 was made to just force CRC32 to built-in.

Now that the CRC32 library no longer uses weak symbols, that no longer
applies.  And the selection does not fulfill a user dependency either;
those all have their own selections from other options.  Therefore, the
selection of CRC32 by ARM64 is no longer necessary.  Remove it.

Note that this does not necessarily result in CRC32 no longer being set
to y, as it still tends to get selected by something else anyway.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Please consider taking this through the arm64 tree.  But if it doesn't
get picked up there, I'll take it through the crc tree.

 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a182295e6f08..14073b0094c1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -132,11 +132,10 @@ config ARM64
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select CPUMASK_OFFSTACK if NR_CPUS > 256
-	select CRC32
 	select DCACHE_WORD_ACCESS
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
 	select DMA_BOUNCE_UNALIGNED_KMALLOC
 	select DMA_DIRECT_REMAP
 	select EDAC_SUPPORT

base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
-- 
2.49.0

