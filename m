Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA630C629
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204344; cv=none; b=UYtFcLhYqXFFdUSuKjs1odX7qciE30ybp5gsnEY0QNIBeWwddQlFYi4iom3wN7eG/AQd/MI9uHdMscmtyHokIerMivcWO+8Mg1Ond+/Wt9u18ATFR+QE7Li8XWWYyhni8aQA9A9L8vxblVgSn3/Vxis1IzBH30ouitJEVV9Wm+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204344; c=relaxed/simple;
	bh=7I7deiu7A0VftYnHpa9uRS6VLyQWs+z9QnxKOZtlYJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kxAENqm/wz3ilrk90Csy7WXDOCZixFLLkam5R8gmpDmu0fi5qd5xzM8ndaSl4Oi4JXYZY84IC9EhG6y8FjvpSQ6v7rjBhtW6EHp8BiF25uzYtMwwF7yXfgnGpkUi3Fqe6Op72VshnbX5dZmz88h56J/3mdxs3HQ/kZbl5PgVSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3M/nceBE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3M/nceBE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso8078335e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204340; x=1758809140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PkIaNFjZ8EE9t4JDBPeqGMTocvjIYd1EXgJAVVa8hvk=;
        b=3M/nceBEa87KFh1n+WL3qEalRkVQ13m7oH6Ia8aWdIx0QltlUsbllSOcftCJx/30zR
         nh7Zy0820Asj/gAgo0gZGaaPkT7vPQtIZlfVLVIFdwKb6XOqkVto8v/uLZuAoUwyNKVt
         5+iovOQm+3Oa0iJoDfwUXrKBxja/asH2rnMUN2B24qT+FcYe0xP7grgQF6eGcFuyWRbY
         MiSRxlVmjZGituH8Mld/t+fqvAgKn0wx0QOUnl14o09qyUiPFfC6DJrHUB+fZCZq9Nq+
         m7EZQkPsOWZtuOQSt5jpzQz5l9qCJ6r/RBH6hT7FbeoFyjQvvsYWQWziS4R0mvRCuJQz
         G/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204340; x=1758809140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PkIaNFjZ8EE9t4JDBPeqGMTocvjIYd1EXgJAVVa8hvk=;
        b=OxV5hv2o0f92rxQ/cYx5PY6I2oTODh645K72K/Uj5TaRE1JiQ0JykF7CmH6+KUmupD
         w/5JX/Tn0dzVTLq6tmtIiOpLzNBpzps9+XJQuXnouqFqv07onbD2Qs+73b/IX0fw4luj
         6z7T6HwbHMGi7FcVWhlLeS8QZLCk0KAk4Z/WwSXwwj3bKLdhYABk019G8aIddFFT5hTU
         Nj/KM476QALl5C92smPYiaojSYgBqs/jCFrELRWnCnOcQz/KZQVqXqMWIbsiCCwFCdzV
         cM37HUJueZDl4/oe3pHcOlu7XGmGiR6vHgbueszPZy/keWXxwbPi3s4Uw609tjTvhoJf
         iD6A==
X-Forwarded-Encrypted: i=1; AJvYcCUBozYpaFFiIyfXObRE8PHeuDpoWbVS7rWznErBZzKcQlvuuYmxa8wj7oW7KINZGL41t018OjVs0kJrPvA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz2r5FZYYU+0D82ECeuD3W0dJHC7tLbyXxkV3RIUXOQSxEGs+O
	CYy0ICBcIiTOWQb+nBG5h72SsDTERVSq64VcO1MRBdXb/MWtnP5VRvjXAN5hbUaL3pqXl93ovcW
	SHA==
X-Google-Smtp-Source: AGHT+IHQzPo8Mj0thMXjE5t0fY5CTZzNk1DcpYE8xx/Ej+3pN7Wv3jLT0CrPQrr0ioychSRPw4fXch23mw==
X-Received: from wmqj11.prod.google.com ([2002:a05:600c:190b:b0:45d:db34:5091])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6018:b0:456:942:b162
 with SMTP id 5b1f17b1804b1-4650503b3e2mr26525245e9.11.1758204339995; Thu, 18
 Sep 2025 07:05:39 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:16 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-6-elver@google.com>
Subject: [PATCH v3 05/35] checkpatch: Warn about capability_unsafe() without comment
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Warn about applications of capability_unsafe() without a comment, to
encourage documenting the reasoning behind why it was deemed safe.

Signed-off-by: Marco Elver <elver@google.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e722dd6fa8ef..532075e67a96 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6717,6 +6717,14 @@ sub process {
 			}
 		}
 
+# check for capability_unsafe without a comment.
+		if ($line =~ /\bcapability_unsafe\b/) {
+			if (!ctx_has_comment($first_line, $linenr)) {
+				WARN("CAPABILITY_UNSAFE",
+				     "capability_unsafe without comment\n" . $herecurr);
+			}
+		}
+
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("ARCH_DEFINES",
-- 
2.51.0.384.g4c02a37b29-goog

