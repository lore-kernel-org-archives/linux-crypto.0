Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795393527;
	b=Zu7YqyyqdhZ2NwGMahn4l58ULdiKOB2rkcA2mqklLKbakavD9tForkftbCQYkRUIWi5q
	 eW4P+E+Tkyc+Xp/fQtqIg5LKsWMBNr9e1kTc0+WNpq1OPhfeoAsakQcZKTglebZoTHea5
	 WEGtUnjYUrU2u1H3yXdVK5CtCdHw/JIyOSvE4UAclBL1Wx20XcVz+6UhXjipXnHm1xJIw
	 tnj8rj7IOoy8V3stV8Tuz2pyMFXXbPP+zusYM5rqxqBiX5Pm2Zu5d47NiMviQ1eAX0qsG
	 Ui7RrwlXkl1JsKneVBdTil7J3p8IqnhGanyIqQEj69xkz8XVDRAFiW+EOKSkyTobUCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393527;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OXn1Mf50jglpquacOWjJ7uVOXz554Aye5yQhvyRBksc=;
	b=1OkZiJzNSfjUhqsGQ9e20jQJ8bTMJ50+DEF6xdx5QnSff/0wavrClEwlhNn1sNcIrtmY
	 569q6bMekQTwfoNlzw0Yy2WQwEm/UUaK7DpBTfvRb3k5OUjKQjy+MHLK3NAlAhot7Bd5C
	 Hj3i0CybAy/eliFOUZvs/GmO/Cy8LGTbLyeXVVr+w1vTfXks43Ce1vjE33eAXdIT69H0+
	 VMM+NnqiFJKYmDl/CegINTspH/Qy5i3kIQGe8eLbbfrllgUE5vYCT+Q5UHP5FSUckq/3j
	 vkoFBMyg9zZmhhevjtd/eyY4vCPERgHXOCY8phK4/j0B0X8md09CZ2D/T9h13o3Ih5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UF+ZLfDS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F03606A69B;
	Mon, 23 Nov 2026 00:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UF+ZLfDS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795393527;
	b=eQSjQPJaZufao/U1Kk8+s9vF8xSH01p6pir6b4M9HC473daNeL+dLH2oj2Mz6emW6U3Z
	 mhsM+Rarrn+fyG7hXnM0ha89gPg9uy6w0OnKOz3BBJFsmObtHBWzT5c/ZJ1QmEieGxSE0
	 jc222rv6unE7LRmr/kP58ZK/k28dlG94bL8RVKFeGV83GRCPt6tocuDuVhviM/UxYFF8V
	 yPukTw3YTkBJuBISEw1UtbFcRebQz/Qr+P6X4Z4LZw3xxS9g/kqEYo3dLKsIbUryba2gd
	 0Wr24Ntp3YyVUnke5YV968xlb0Hz/70HRKRIhNMhFQr/UyG6I0oWNX8BgQjfBcwdu+w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795393527;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OXn1Mf50jglpquacOWjJ7uVOXz554Aye5yQhvyRBksc=;
	b=TsojS+TltAGLgpMGJpwuWAvm4dhf/knhWi74LmDGKtij/MGd9Gma8lZvy9MCCkLN8jy2
	 oGWqsE8eAVst0fRGgF37prGpj8b50Q0f4qGZ5FjcCgTeFnpT24jVq0rD2vtwcKHsvkvmv
	 M8HpplCUorh92Y9uFdaiCMbJQVBE9A3jR0LrMswqA8F1ACW6OLpS6sIZr7fYBX9doWpE0
	 Can3b/aONIv4Jk4reWqusrOOqsRwAkJDUAZ0eileqK3VD6GInr2KY6kFwcA8BUDhb69nl
	 F/f+oy7jsnYc1GIbZgNWnjkoB3plbN5+cMAJ/C/HxawRUejlQMPtTxWJmR0kkNSS7Jw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 845B61F000D0;
	Mon, 23 Nov 2026 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393527;
	bh=OXn1Mf50jglpquacOWjJ7uVOXz554Aye5yQhvyRBksc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UF+ZLfDSI7sOEM/hJPbPo41mzntHf89lJNHelhohLOXfXeQzB3vpB06+EMceSQT4/
	 ov3PMskEap1XIRKXcyiB04lgQJeWqXTyQEpmpM1AOOUYUorQwWpr0n7nRHyaRFZcx5
	 V3m27h9V0ePUbFbYlpukVXOx5ihO+jcoXC4nMqN457+JB0ZTxjHfUx+wYAcVy45EtC
	 A80KLIHGHyYe0allPBK9U2VGNax+BTeoE7OqulGAs0ixjD/iIJWJzpgHOjJp4336h0
	 MIhpM4ubmvzhT3t85bS0QmAsd+hfRTm1yJrS8YHr5G6qf4i20bE6X/i4ko101CLjOW
	 CjtN/okVkq6kQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 11DE64C25D;
	Mon, 23 Nov 2026 00:25:13 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 22 Nov 2026 19:25:15 -0500
Subject: [PATCH bpf v2 4/4] selftests/bpf: Test rhtab deletes from inside a
 resize
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261122-bpf-rhtab-irqs-disabled-v2-4-207aedcc2215@columbia.edu>
References: <20261122-bpf-rhtab-irqs-disabled-v2-0-207aedcc2215@columbia.edu>
In-Reply-To: <20261122-bpf-rhtab-irqs-disabled-v2-0-207aedcc2215@columbia.edu>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Mykyta Yatsenko <yatsenko@meta.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, bpf@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, tz2294@columbia.edu, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795393512; l=3329;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=9el2Hu//XF7H7n6wCOTuZBRipgte5y1GXzMdDmYtqDk=;
 b=vBG6LrbpIAr++9Zz215gGlxXCBoIlBOmt54+VaYaziPIIojmkctwADigd28cCzhvBAFxIGn5R
 ft7lXRJQNcaApubwwaYPqBYXjlwOTZxr2QaBULP9qmfI5k+BbhrfoJc
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

Add a kprobe program on rhashtable_jhash2() that deletes key 7 of a
resizable hash map whenever the resize worker hashes it there, while
user space keeps the table growing and shrinking.  The worker holds key
7's bucket lock at that point, so the delete fails with -EBUSY.  Without
the fix the CPU spins on that lock forever.

Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 tools/testing/selftests/bpf/prog_tests/rhash.c   | 34 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/rhash_resize.c | 34 ++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/rhash.c b/tools/testing/selftests/bpf/prog_tests/rhash.c
index 0641bd5b0a9e..5afe07b32289 100644
--- a/tools/testing/selftests/bpf/prog_tests/rhash.c
+++ b/tools/testing/selftests/bpf/prog_tests/rhash.c
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include "rhash.skel.h"
 #include "bpf_iter_bpf_rhash_map.skel.h"
+#include "rhash_resize.skel.h"
 #include <linux/bpf.h>
 #include <linux/perf_event.h>
 #include <sys/syscall.h>
@@ -149,6 +150,36 @@ static void rhash_iter_test(void)
 	bpf_iter_bpf_rhash_map__destroy(skel);
 }
 
+static void rhash_resize_test(void)
+{
+	struct rhash_resize *skel;
+	int fd, i, n;
+	__u64 val = 0;
+
+	skel = rhash_resize__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "rhash_resize__open_and_load"))
+		return;
+
+	if (!ASSERT_OK(rhash_resize__attach(skel), "rhash_resize__attach"))
+		goto out;
+
+	fd = bpf_map__fd(skel->maps.rhmap);
+	/* let the resize worker run after each half */
+	for (n = 0; n < 5000 && !skel->bss->busy; n++) {
+		for (i = 0; i < 64; i++)
+			bpf_map_update_elem(fd, &i, &val, BPF_ANY);
+		usleep(100);
+		for (i = 0; i < 64; i++)
+			bpf_map_delete_elem(fd, &i);
+		usleep(100);
+	}
+
+	ASSERT_GT(skel->bss->hits, 0, "hits");
+	ASSERT_GT(skel->bss->busy, 0, "busy");
+out:
+	rhash_resize__destroy(skel);
+}
+
 void test_rhash(void)
 {
 	if (test__start_subtest("test_rhash_lookup_update"))
@@ -186,4 +217,7 @@ void test_rhash(void)
 
 	if (test__start_subtest("test_rhash_iter"))
 		rhash_iter_test();
+
+	if (test__start_subtest("test_rhash_resize"))
+		rhash_resize_test();
 }
diff --git a/tools/testing/selftests/bpf/progs/rhash_resize.c b/tools/testing/selftests/bpf/progs/rhash_resize.c
new file mode 100644
index 000000000000..5a1076b30bb0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/rhash_resize.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RHASH);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__uint(max_entries, 128);
+	__type(key, int);
+	__type(value, long);
+} rhmap SEC(".maps");
+
+int hits;
+int busy;
+
+/* The resize worker calls this with the key's bucket lock held */
+SEC("kprobe/rhashtable_jhash2")
+int BPF_KPROBE(rhash_resize_delete, const void *key, u32 length)
+{
+	int k;
+
+	if (length != 1 || bpf_probe_read_kernel(&k, sizeof(k), key) || k != 7)
+		return 0;
+
+	__sync_fetch_and_add(&hits, 1);
+	if (bpf_map_delete_elem(&rhmap, &k) == -EBUSY)
+		__sync_fetch_and_add(&busy, 1);
+	return 0;
+}

-- 
2.53.0


