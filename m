Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4534D930
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159231; cv=none; b=PoFqVJhjw8ZgiaQCdoeT5UxxkcQk2HwSyaKrezMWTGq0MQVRBvyxSrgJiDrT6qOhx/ViMqrJj4xESuNvZomQxjuwMv0CBzjlkiNERshEnbA/AnfvJxERAKTTLdX2z1/e6bw8/LOK2QlZ6aeD2qTYqbaNbRiVpFOUjtoBGkNb1DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159231; c=relaxed/simple;
	bh=6rdkhgIhrcuHAfDwpQsS1f4aMCHAzfeNjskQV2PQ154=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=il+uc0QzpQrN7AzKgF0fHB75qBz82D0a+f9CE4DP54Ptw++FiraoLfQp2k8aEG558qJFwQLxQLLFcshFuDt7TN1jPFSwDNOS1/6OLxBy7P46C4IIT5/hLnQFgUj36OkaaoQnUz/STB5i/UC5hcKnV/sBccffv3tc1JywDxpGswg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EyvIUvYT; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EyvIUvYT"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f57cd2caso1623485f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159226; x=1766764026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTy18ZdTqK3/SC0lGMdEXuAKkcRsuvgQuaMHd3BFX3Q=;
        b=EyvIUvYTsSxYqQbGcJqqRe7q4y3tfoPTcOuHGVkLs0oayf4Y37CteCMzp5yfrsnqhd
         TOGXVAEGYIHgXq9DkeLvuvojE1Bot5YQqMWudjk9+8p8TZU+Av5L//6egx99Dl3hq9cq
         SKAGPnHMPU/NltUthUuo0kQXnbwXprdRaEn3QYW42nA8AhdTx2W8pCICycqcgeA0vaz0
         ffDnzOMK+EgcT4udNv6OedIZ5e9AY4I4ZU9XiMg8wqhDJTaMdHnDqGgeK2kfrMU9buIx
         ymh99UpahVnZN0D70gzVmKQnKJACxe0JYzv4aw6zbSe0R2q2PpDZKXa8BWmS5J8vl6mo
         4BkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159226; x=1766764026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTy18ZdTqK3/SC0lGMdEXuAKkcRsuvgQuaMHd3BFX3Q=;
        b=UgoLEYEj12aRzTPmOvqX+H0ggj7EldPdPzoXwS2J7Bn0UIVOWAtoHsYWb5YXLBlDrA
         Ql98qEBpoyPfUm9oBl/0d38pqNI+ggoICfcNifeFvE9IxTTwS3WZSqnn6FPDj2mHa11k
         tXEAVT0+KK9y2D3ncovOruU3nGPl4NgR+A8LmHCxg9dLgbPcg4m9QefW72wSTJRCh9L4
         EUwsvbsa7BTC1YMG/okXuZ+4Gn46dZym8VknOYG6WFxPsbY0uvZNft86EV5qqrRBiUsW
         inCBDtHsmWpwmfbkylOBsPV7/V9WjD5vyufBXnxvcsiRxcYHkr5OzcBp8Nrb0oOuVQDa
         1VxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6qmYVdzI/WFGgOD4pQcRLmeZSKeg2z/tvpoureqW3BlwvYMu612//17zo+lTQYGDc5Hhc/JYrSFcbalE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG/NIshB6pRRGcnYwKXyenLj/U0whwJJuQ06lkSoI/4Ov2r9jz
	2HAQK4tuklNfk9YQtZO+8UZkcaPfYmQlospI9QGsn2n55UGSwNLoHtdtUvqrWquBH4XKGyJBK1K
	JTw==
X-Google-Smtp-Source: AGHT+IF24T4xLk8zHfaxGfwTVEzbsV+GAmr+3MEnl5nQxzQxPnKeM3cpUzi9Ro4WJge4y08O2O0BEUfdhg==
X-Received: from wrbay2.prod.google.com ([2002:a5d:6f02:0:b0:430:f3bf:123f])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2886:b0:42f:dbbc:5103
 with SMTP id ffacd0b85a97d-4324e4fda18mr3897372f8f.35.1766159225487; Fri, 19
 Dec 2025 07:47:05 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:14 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-26-elver@google.com>
Subject: [PATCH v5 25/36] compiler-context-analysis: Introduce header suppressions
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

While we can opt in individual subsystems which add the required
annotations, such subsystems inevitably include headers from other
subsystems which may not yet have the right annotations, which then
result in false positive warnings.

Making compatible by adding annotations across all common headers
currently requires an excessive number of __no_context_analysis
annotations, or carefully analyzing non-trivial cases to add the correct
annotations. While this is desirable long-term, providing an incremental
path causes less churn and headaches for maintainers not yet interested
in dealing with such warnings.

Rather than clutter headers unnecessary and mandate all subsystem
maintainers to keep their headers working with context analysis,
suppress all -Wthread-safety warnings in headers. Explicitly opt in
headers with context-enabled primitives.

With this in place, we can start enabling the analysis on more complex
subsystems in subsequent changes.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
---
 scripts/Makefile.context-analysis        |  4 +++
 scripts/context-analysis-suppression.txt | 32 ++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 scripts/context-analysis-suppression.txt

diff --git a/scripts/Makefile.context-analysis b/scripts/Makefile.context-analysis
index 70549f7fae1a..cd3bb49d3f09 100644
--- a/scripts/Makefile.context-analysis
+++ b/scripts/Makefile.context-analysis
@@ -4,4 +4,8 @@ context-analysis-cflags := -DWARN_CONTEXT_ANALYSIS		\
 	-fexperimental-late-parse-attributes -Wthread-safety	\
 	-Wthread-safety-pointer -Wthread-safety-beta
 
+ifndef CONFIG_WARN_CONTEXT_ANALYSIS_ALL
+context-analysis-cflags += --warning-suppression-mappings=$(srctree)/scripts/context-analysis-suppression.txt
+endif
+
 export CFLAGS_CONTEXT_ANALYSIS := $(context-analysis-cflags)
diff --git a/scripts/context-analysis-suppression.txt b/scripts/context-analysis-suppression.txt
new file mode 100644
index 000000000000..df25c3d07a5b
--- /dev/null
+++ b/scripts/context-analysis-suppression.txt
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# The suppressions file should only match common paths such as header files.
+# For individual subsytems use Makefile directive CONTEXT_ANALYSIS := [yn].
+#
+# The suppressions are ignored when CONFIG_WARN_CONTEXT_ANALYSIS_ALL is
+# selected.
+
+[thread-safety]
+src:*arch/*/include/*
+src:*include/acpi/*
+src:*include/asm-generic/*
+src:*include/linux/*
+src:*include/net/*
+
+# Opt-in headers:
+src:*include/linux/bit_spinlock.h=emit
+src:*include/linux/cleanup.h=emit
+src:*include/linux/kref.h=emit
+src:*include/linux/list*.h=emit
+src:*include/linux/local_lock*.h=emit
+src:*include/linux/lockdep.h=emit
+src:*include/linux/mutex*.h=emit
+src:*include/linux/rcupdate.h=emit
+src:*include/linux/refcount.h=emit
+src:*include/linux/rhashtable.h=emit
+src:*include/linux/rwlock*.h=emit
+src:*include/linux/rwsem.h=emit
+src:*include/linux/seqlock*.h=emit
+src:*include/linux/spinlock*.h=emit
+src:*include/linux/srcu*.h=emit
+src:*include/linux/ww_mutex.h=emit
-- 
2.52.0.322.g1dd061c0dc-goog

