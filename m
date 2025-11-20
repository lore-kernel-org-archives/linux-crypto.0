Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A444E34B682
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651012; cv=none; b=Bs9Z05+gVq4/MYifyWS2TU5RVqt3s0qZQCgZnHWGYIq6y/qKcQx+FrSlpBVYKTCIjQCFTBSJXtU8e3579orWHeUqHzBzQFLpGsiQs69iYB3cF4jXnD+U5yP1KaJ1Fe93etH8YWbJsR3NroAuZN1Wtgff1SL2i1mpvV5lB1pFHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651012; c=relaxed/simple;
	bh=tTGjUHrfXR5isY+lSEFNNwASkyVwRARVzePML9vCCTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BuB4ClCeoVrxNapnNlSpbJ2wRBcRdhxBkH1CjALzAf+zKFrTDUP/NUR7+MJ4l4WV58o9+0y64pX3fmLeRsr1doksRG4ucJ6SGUDDCLW/LDg5ceZQE//YEvPIoDQg1fPs4b/70EPswbzjvRiAGDAwvQs9vt/yRsjrbqvNY0ImEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uYN7U7Ro; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uYN7U7Ro"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64165abd7ffso1295560a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 07:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650980; x=1764255780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTNBohfvQLfYyJiWHtGyLx9FZqAAISthRH9eXaAWBIw=;
        b=uYN7U7Rot2DD0rjsJ+avG5Vgrtsl5pWj2aNXIX1/h5uWcavxFKhKtViUfgnxWJcmiX
         jWtVA6lbA80kzTcgwWYQiNKnoEOPuFABhz2vDegow0eRQAAQntgVXqNIXXpszdCqiY3g
         YUHz28TkBW24bpMJn5Gsda7gRUfCoZ/TLSyaydMQ7HUqYqX8FDZkZl/mBwE2h1Eq6I99
         9l7IpaBfX76VFC9Fcbs+MRHI4U9NrIbUZ3pkFDDvhEvVkvxG6Jvg4lXrnva2HZbiRzN8
         tdNAThE8WdIJ2eWcj0+6MF3T9039lCTiER8RAFRKc9jupfHr1GRAWcMngmSvEFsKG4Sk
         serw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650980; x=1764255780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTNBohfvQLfYyJiWHtGyLx9FZqAAISthRH9eXaAWBIw=;
        b=BXGlFJ9qbn8tYLI8RYL9bToSZJKjJ3jt997R7xVjb2dpQrNCG23RbhqqGQO4/pFB4q
         0D6iCeFhDuS4zvRmLqDeSG4LmZkPj8udeWZrYy1ScIa3nIgWaqGon9SNSGl3wEDWQ0X3
         NJTUqkWWFdPtGiQ/O6OiSXyVGx8S8u696lGvFnu/7MPYMazjhBJpYhAyoFn+FCjJmez1
         xK7CcCSu6k+4hEYXlpwgmKZ1HeMsS7mY6lcUNZI2BmGh0M/q1CxDvTMUrECToe32JyAj
         M5QMI7mfIQH1iPlTgIcgG8B0FgAHKyQSYL60uoP5AIzI+55d8IuZY9z9CiiqIAi7CVdd
         UZZw==
X-Forwarded-Encrypted: i=1; AJvYcCXGOnRFNwb1FqPZKw5DRrEAjVDse2FkhnxWpFxI0ygVWyA/r4cw/Omcjq6rwK77EVNJxkXCYsLxS4e6nE8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy32uSTRcgItOTau/EXDWZGS6kjzctGf98NhG3+oPa1Rc/ENjTQ
	o1YpU4b9/9TK56iU03/t0L270s47rKWRMjJ0bFnrb32C2LduhjBMnGo4D7SwaIL+hOigbY9X09z
	tAg==
X-Google-Smtp-Source: AGHT+IF9OaX/QGeSo05eKeUEdCvjlZVpqfgwLf4/MHL/rv8J5uT/4osVo9PFxwafA3Q6L9NfftMIvUQ5OA==
X-Received: from edb10.prod.google.com ([2002:a05:6402:238a:b0:643:5f58:caa7])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:268d:b0:640:b1cf:f800
 with SMTP id 4fb4d7f45d1cf-6453d084770mr1885049a12.4.1763650978915; Thu, 20
 Nov 2025 07:02:58 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:07 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-7-elver@google.com>
Subject: [PATCH v4 05/35] checkpatch: Warn about context_unsafe() without comment
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

Warn about applications of context_unsafe() without a comment, to
encourage documenting the reasoning behind why it was deemed safe.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
* Avoid nested if.
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 92669904eecc..a5db6b583b88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6722,6 +6722,13 @@ sub process {
 			}
 		}
 
+# check for context_unsafe without a comment.
+		if ($line =~ /\bcontext_unsafe\b/ &&
+		    !ctx_has_comment($first_line, $linenr)) {
+			WARN("CONTEXT_UNSAFE",
+			     "context_unsafe without comment\n" . $herecurr);
+		}
+
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("ARCH_DEFINES",
-- 
2.52.0.rc1.455.g30608eb744-goog

