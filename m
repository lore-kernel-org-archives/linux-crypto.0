Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAB71A682C;
	Thu,  6 Aug 2026 05:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994846; cv=none; b=kVED7W+IXaY1NxvVtEhIzQJyuMsHc0DVFguxwN9vR2+/ipm5uiPlL9BfKyq47ZndYnj25XRElJhpv7zfErJsp8yhX8BVIOLb+FEWiOX3Casl1JlrCzZRsjvu7l03msTxl7bIl/w7sYl0ffMMXGd5p0FaL1UEGouSToR7+H9mzX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994846; c=relaxed/simple;
	bh=P2o0TYOBLISMwHgXd8gbFTZnQu4yoh1oPvfgCULtm+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mB8DIS0fWnUPG0BcBKPCkHTydPtkHcNatJYs5fxloPoXy+ovRdBov+O7hj1MKkplcySXp+YMqQWfGWi5oYTFrpas61n7BfKbVBN1FlXBK1InxxykoPVdO133jSsAX4YGRtbrFcHN0bjizJVASebpwkVs4dnVJXFC46GWjip6omE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It7fVb6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It7fVb6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A372C1F000E9;
	Thu,  6 Aug 2026 05:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994844;
	bh=GL2uvj2+bpxs8fn3EFdSWgtIfrNxcZibPOjtAg56ZWo=;
	h=From:To:Cc:Subject:Date;
	b=It7fVb6ZUVHDPyWYCLny+I03z/CVc1hcpvAUUFtyh9dJjy15nufvPfM+naTOCxmep
	 88kZZvG1eVvmAMCGFcZ3eYz7Uhdn7zFK3jGvCNfa8SE5GY43dwh2A1uos602upclC9
	 +bZJG+IFqDg3nNuPB/zhn7z5emwP5Hj45eZr4nQdLI0iIRCo82WyjphvHGksPS9Wia
	 ebQ/Ift8rsSwmnforq1UzMeBKBkjSj4RVTGNQ2Zy/UnC4oInaOOUkES0hH/cr62pOL
	 wSc5T2WbOcFROnj9XRfFW2NPmlfOkZQB2rE6BLbVQCR9yjt+09SXPM5qUmVm1WQ26F
	 mI0uaIAUGqfew==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] kunit: irq: Unregister on-stack timer and work from debugobjects
Date: Wed,  5 Aug 2026 22:38:04 -0700
Message-ID: <20260806053804.106724-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In kunit_run_irq_test(), call destroy_hrtimer_on_stack() and
destroy_work_on_stack() to unregister the hrtimer and work from the
debugobjects infrastructure (when CONFIG_DEBUG_OBJECTS_TIMERS=y and
CONFIG_DEBUG_OBJECTS_WORK=y) before the function returns.

Found via code review; the lack of the unregistrations didn't actually
cause a warning, since the objects are inactive upon return anyway.  But
they should be there, otherwise debugobjects keeps tracking the objects.

Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 include/kunit/run-in-irq-context.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
index 3802b6fb218ed..b46fa1696360c 100644
--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -137,6 +137,8 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 	/* Cancel the timer and work. */
 	hrtimer_cancel(&state.timer);
 	flush_work(&state.bh_work);
+	destroy_hrtimer_on_stack(&state.timer);
+	destroy_work_on_stack(&state.bh_work);
 
 	/* Sanity check: the timer and BH functions should have been run. */
 	KUNIT_EXPECT_GT_MSG(test, atomic_read(&state.hardirq_func_calls), 0,

base-commit: 4bceb5614e0fc0338d6787f39df5472bfd72eaab
-- 
2.55.0

