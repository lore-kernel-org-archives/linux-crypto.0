Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943803438BD;
	Fri, 17 Jul 2026 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308749; cv=none; b=XlPYwRmsaaQ+Erkws9YkW6IoPjGj0tVra0sj7eb1FzbqOeI8OrO/FQ8UXfmXPY9jks9sGVFBcAgLGIEnrm/Ugf8U4VgsHKsXbDB5+UvjENJMFCLB8L3sv0AShMFPpKtDSl3fV5/S5OaZ8O+0MJo8JhkaqkX+wxiXvVh71aLTBBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308749; c=relaxed/simple;
	bh=gy2q0RK7WDIkIOGW93hsTcCDqk61g8WyUGqOEI/CueU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObTfHd2OLp4A/W3fCUqpAuaq8CPaY5EgTjkFiijsnr00Pk8tzw5JmqvgQ1X6WtrykEofdv+kI6WHGZ1MF5OyUAXpSfDjQugIc4HBvF4cBLJaDKpzep+44tOwZpwtiUkM7VJOTZs9jHtoY7N1WypkqKt5h41/pIJScEe+pyTUl1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRf0u4qE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRf0u4qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9811F00A3A;
	Fri, 17 Jul 2026 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308748;
	bh=UnHkVLMCAQLQ4+B9er/X7SytQ44lCRGiRd6XPR5oP94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRf0u4qE80aV1ogajGbTyHdXWPlHKbE/VDn6x8aVweD54mvFOkEHhUTXxOFlJx7TF
	 38wNt/63GXdBRVHUq+8rkUzmgcBrVH7/zYeCkmi5ovM2ZSiMOU2v2HiSzHWpRhA7aX
	 P/xzZfB12XnJ7K2G3IBa3UFxi8q/j4gd/k9z/o90d451S1pAw4C0uo6wQ90XC8bY4z
	 fcJBzDTkCASxwiTspwIsq2jrywly81dyDcAvZK+w9sT4VyLNzRyIu/jUJ480umW5Ly
	 Eji2UGevleFA1PobcZzS7lmRyKgib0I4c5Jx+O8gRRQRKenUWu/5kzi709ygeG0PSH
	 XHaBIP0fzQh9A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] padata: Mark remaining code as __init and data as __initdata
Date: Fri, 17 Jul 2026 10:18:30 -0700
Message-ID: <20260717171831.27994-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717171831.27994-1-ebiggers@kernel.org>
References: <20260717171831.27994-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the serialized job support was removed from padata, the remaining
code is used only by the multithreaded job support, whose public
functions are __init.

Therefore, also mark the internal functions as __init and the internal
data as __initdata.

This makes them be discarded after the kernel boots.  It also eliminates
the need to mark padata_work_init() as __ref.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 kernel/padata.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6eb130d31024..e7f89e3e44e9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -31,9 +31,9 @@ struct padata_work {
 	void			*pw_data;
 };
 
-static DEFINE_SPINLOCK(padata_works_lock);
-static struct padata_work *padata_works;
-static LIST_HEAD(padata_free_works);
+static __initdata DEFINE_SPINLOCK(padata_works_lock);
+static __initdata struct padata_work *padata_works;
+static __initdata LIST_HEAD(padata_free_works);
 
 struct padata_mt_job_state {
 	spinlock_t		lock;
@@ -46,7 +46,7 @@ struct padata_mt_job_state {
 
 static void __init padata_mt_helper(struct work_struct *work);
 
-static struct padata_work *padata_work_alloc(void)
+static struct padata_work *__init padata_work_alloc(void)
 {
 	struct padata_work *pw;
 
@@ -60,16 +60,8 @@ static struct padata_work *padata_work_alloc(void)
 	return pw;
 }
 
-/*
- * This function is marked __ref because this function may be optimized in such
- * a way that it directly refers to work_fn's address, which causes modpost to
- * complain when work_fn is marked __init. This scenario was observed with clang
- * LTO, where padata_work_init() was optimized to refer directly to
- * padata_mt_helper() because the calls to padata_work_init() with other work_fn
- * values were eliminated or inlined.
- */
-static void __ref padata_work_init(struct padata_work *pw, work_func_t work_fn,
-				   void *data, int flags)
+static void __init padata_work_init(struct padata_work *pw, work_func_t work_fn,
+				    void *data, int flags)
 {
 	if (flags & PADATA_WORK_ONSTACK)
 		INIT_WORK_ONSTACK(&pw->pw_work, work_fn);
@@ -98,7 +90,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 	return i;
 }
 
-static void padata_work_free(struct padata_work *pw)
+static void __init padata_work_free(struct padata_work *pw)
 {
 	lockdep_assert_held(&padata_works_lock);
 	list_add(&pw->pw_list, &padata_free_works);
-- 
2.55.0

