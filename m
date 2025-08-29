Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2F283FDE;
	Fri, 29 Aug 2025 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485989; cv=none; b=Xr3dunf2UOrbeEbZtX67lHOz78zCcGNzJV3KxM+tHevefJug7Z05B+9VN1Q+wX7IUGERqkJYmnp9yTNPoTQbURgPnUpTNZsVaQKqqNr5QxxWnzTvoksh41x/t4fIMBMtFA/iifkbr08f42tljvw5MFhgeISR0x8px7Y1AWv3pWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485989; c=relaxed/simple;
	bh=PVpX8+3IqfXg1/WqFGH/rwOO8yjTxELXA5EvlRBBMZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vFLbAdQmubUMV6TwyCxEZKNfItY/ZB6vWdX+gHasm/8BhtQIgpGknQFRpFkwodfXXahKv0Bv2fryb5qngGpPBq7p7wO9jM/0T6hHOsPCnUi9jaSIiZFERTaEMHwy1IGJn7EfX63hbBsViSH+SGHkUZqHaIiZpFR93PlMpNc04XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7s7Vq4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7s7Vq4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4098AC4CEF0;
	Fri, 29 Aug 2025 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485988;
	bh=PVpX8+3IqfXg1/WqFGH/rwOO8yjTxELXA5EvlRBBMZc=;
	h=From:To:Cc:Subject:Date:From;
	b=D7s7Vq4sTLna4JGv7jkxQ+Glrr41wNqIFZ69f2jS4N2FgRPGmazU+mT1ZYZzT5MVh
	 LwQyyPST7pEiUz3aHpak0Lljjs3HeIDhDI8/GT4d0rdFISmukYSF4Di7IQj7wg9ZnC
	 qGkcxoyXLAwblIEMk/jdBFjlf2lGxe6iU1r69UfzpAXg+noHlUGrshDhdcAoIIz8OZ
	 5YYNaFWce9bM32WI5JN4tExtDaxX8Qwvgmh4VHwZclzus2lxqjkwvOFZwM1tgG9+0j
	 u9koKe3Ideu6bNCDCTWB2yqDzvJEpyHbQ7ebrvFOvN2iIq/kJsNNTVoB9fE/PHICzK
	 gnTUnH8Qg2m+w==
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Cc: Dmitry Vyukov <dvyukov@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Date: Fri, 29 Aug 2025 09:45:00 -0700
Message-ID: <20250829164500.324329-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
kmsan_internal_set_shadow_origin():

    BUG: unable to handle page fault for address: ffffbc3840291000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
    Oops: 0000 [#1] SMP NOPTI
    CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
    [...]
    Call Trace:
    <TASK>
    __msan_memset+0xee/0x1a0
    sha224_final+0x9e/0x350
    test_hash_buffer_overruns+0x46f/0x5f0
    ? kmsan_get_shadow_origin_ptr+0x46/0xa0
    ? __pfx_test_hash_buffer_overruns+0x10/0x10
    kunit_try_run_case+0x198/0xa00

This occurs when memset() is called on a buffer that is not 4-byte
aligned and extends to the end of a guard page, i.e. the next page is
unmapped.

The bug is that the loop at the end of
kmsan_internal_set_shadow_origin() accesses the wrong shadow memory
bytes when the address is not 4-byte aligned.  Since each 4 bytes are
associated with an origin, it rounds the address and size so that it can
access all the origins that contain the buffer.  However, when it checks
the corresponding shadow bytes for a particular origin, it incorrectly
uses the original unrounded shadow address.  This results in reads from
shadow memory beyond the end of the buffer's shadow memory, which
crashes when that memory is not mapped.

To fix this, correctly align the shadow address before accessing the 4
shadow bytes corresponding to each origin.

Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial unpoisoning")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 mm/kmsan/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 1ea711786c522..8bca7fece47f0 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -193,11 +193,12 @@ depot_stack_handle_t kmsan_internal_chain_origin(depot_stack_handle_t id)
 
 void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	u32 *shadow_start, *origin_start;
+	void *shadow_start;
+	u32 *aligned_shadow, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
 	shadow_start = kmsan_get_metadata(addr, KMSAN_META_SHADOW);
 	if (!shadow_start) {
@@ -212,13 +213,16 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 		}
 		return;
 	}
 	__memset(shadow_start, b, size);
 
-	if (!IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+	if (IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+		aligned_shadow = shadow_start;
+	} else {
 		pad = address % KMSAN_ORIGIN_SIZE;
 		address -= pad;
+		aligned_shadow = shadow_start - pad;
 		size += pad;
 	}
 	size = ALIGN(size, KMSAN_ORIGIN_SIZE);
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
@@ -228,11 +232,11 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 	 * and unconditionally overwrite the old origin slot.
 	 * If the new origin is zero, overwrite the old origin slot iff the
 	 * corresponding shadow slot is zero.
 	 */
 	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
-		if (origin || !shadow_start[i])
+		if (origin || !aligned_shadow[i])
 			origin_start[i] = origin;
 	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)

base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.50.1

