Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCFB1DF752
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865885; cv=none; b=PPZvzo2NJRPk4bp0vcGfviz64h0FI4YhABNSeCZqSnDDf6+K7ilDvM3h43Xk0Qb5svPFraDCV9tpGhOXD+UlAvEPAz1dBvMKF9f4q0ttel8iz+42fuhwMu6nsxoVqYCP6vVk4ffNPcTq/R8qfR8H3ur6LE4bdsY5zr/4S4RaSac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865885; c=relaxed/simple;
	bh=OUyhDVr77oUg9Ew94dbfOaYtUgHMDOjvOzaZtS/8oZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t1R6bfy6YnJZhNpS47vwsc3wo89rLM2w13aLD8dI/lx57OgHbHHLXIBAJS00N0U8AKNJTkjiz1wQ0MpKh29YZsSphwEZRJGwmCRff8PoJ9cGvJqVyemBrcpMxSF91VWyYrq2GtriaXZH7DcQJf60BHkFKsJ1myeLdQRTn7cBzL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XqltBCv/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XqltBCv/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361b090d23so7141745e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865881; x=1739470681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VsoCl0Fwo1Ic1mnwHNM6zvZdMp3PVmxgZxLwt6H7/D4=;
        b=XqltBCv/PhH36XyvvGL0gKijrfWt6NFZkgWxlBdjL2PWo9C3koQ3faCtpRQrLO8bhf
         TAK1W6eHQkT4MDRKhDPZDBRQtSAF/YdoPIKr2n6KcTktxDWY1Xm14N1iY0ifgNQbSRKI
         FrdkikeWJS1lpbvZAE0/ZctiCnXnkWGJyMttf239oKIh8NlZP2SgTLnc/rLSbmColp9h
         sFwyH4fl6ddo/wBNWBtyXiIP4+Fcv71X4DDBggAWE4uR78TGDSGpI0PkNSC1vpvvv0H+
         s65A+fGSpkfgbnd2/fITFdQEY9/tVlcFyEWLcbik4rM61HX1gWI5NS+TWpiknzfnYz7w
         gFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865881; x=1739470681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VsoCl0Fwo1Ic1mnwHNM6zvZdMp3PVmxgZxLwt6H7/D4=;
        b=SS3SNz/5noS+1SMiRGm3REdeLYS+0vDVEJ0LsRhh3R5iQLOFtcTsYLtESH54BA0oIL
         ZR3pk7cpUR+5oQ4WXXopYxVjomC50fXy0gXw+IoSyvLvutfLGFtFS/N3sgTv2ys0NCuI
         TUtvx0oNCZtv1TvN9ddJfyqK6WNYD8IiRFwwU//L68hPtSR3QkZYoEfgFMQHTwRQT2rn
         jIe1GoL97nm7yr96RQM40Of09tNoi4tTCnxtftlQ3xmcG2DkM8riR++outV8WxozJwyf
         5S5+XbkQzrcnoYyt0GsA2OWvsy4Hs4a/MZL8ZxA9xkwGwsuzGmHT97M6vu80acbu707i
         dirA==
X-Forwarded-Encrypted: i=1; AJvYcCUQkCRHEbVt5fHo2tBxHeAqE3LWKR7FtEDfeBN+BuRQ/kahOL8r8HWDkDOI0XDGbslG8dxclryCtAEq//g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9jZAoE5mvZrMkVf12qfuKf9O6s/keI3Xs7hPJ8HuD8LcwtmJw
	HihF/tbkcpvd2GxSlLNkjnhAH8dj9H3cmdMi+zxAPwoaX/HPJ8Y/kAr9Fsa5iK9gvNmMa7H/gQ=
	=
X-Google-Smtp-Source: AGHT+IHiTmn6vfthg2vhJ36+4kRebwXf2RJ94SpIllvtOjA4FgWz+fAElpnxs8wxYNVNWceG+v5BwvdraA==
X-Received: from wmbeq14.prod.google.com ([2002:a05:600c:848e:b0:434:e9e2:2991])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e15:b0:434:ff9d:a370
 with SMTP id 5b1f17b1804b1-439248c34e9mr5139685e9.0.1738865881193; Thu, 06
 Feb 2025 10:18:01 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:00 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-7-elver@google.com>
Subject: [PATCH RFC 06/24] checkpatch: Warn about capability_unsafe() without comment
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Warn about applications of capability_unsafe() without a comment, to
encourage documenting the reasoning behind why it was deemed safe.

Signed-off-by: Marco Elver <elver@google.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7b28ad331742..c28efdb1d404 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6693,6 +6693,14 @@ sub process {
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
2.48.1.502.g6dc24dfdaf-goog

