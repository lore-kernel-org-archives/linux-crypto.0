Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295034B400
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159201; cv=none; b=kIZoA0VJxs6BZnwG+QmoxtSs6HtpDlmMgTLhOCvh1FHLuqrpsMFwAfZT997tc1T++IEro6w4sHeBvz1jUdgFKXiqTrshJ4BNklRx3R7N/rghfGaPG5LlYmt9oFpgdcA6+Gdco4R+FqsBV9QBir9dsidclEyLvjzXs1h9gQ2YaFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159201; c=relaxed/simple;
	bh=ZqqBArB2yoGPi5pRLFHBWVfZ5IhyubnYslnOT+L1Eto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZPl+fCy/v3H80eqNx0uVZ+Oc2QwIrp5aaICfcOTYXCKZ+lYmyEJs/2fje8EwQrWYHDb8r2Zuz4qxPm4zK2Z2yX5qYilh2rbduGz/0mW6xXb2wguXvD3scc94pzYT/Mcy7TmI9kc5Ng3kcGqHnsSXRL2oXrO52VYKd94h//SyyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2WR/Hmn0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2WR/Hmn0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso12101615e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 07:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159197; x=1766763997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnCWdNxOjiV83xbv6/Q1ySENLnYMSFtAYAkCgCH7C/E=;
        b=2WR/Hmn0XZkceSqV5BECw8Nu1JHmqfbv0Ou6CpRlp2vPWa0GPbR4LV24BndLk2nIRR
         8pTZmPHLc3MYELV+LZPjjBD+6Mj3etIprLflB3mBRjTRNJxhnNY2gvQc2ayqGzfh6gkj
         LOer+amJqinrFc1hQHgWbEBX+1P+TWIYW0Vji6CLlzQkIYyfE6Rl0HnOyuPmWzKDUrt0
         t9PvIYW9rEXPMJHMhbmJJE6wp5oJr6jbsDNPb7HdozANnm9kFO4lXrANZ5AsAZtgucU8
         gO1cA79OEB5KwMco4RlW08kLV9WDu6jBrWLcE83RvIQycMDNKcA8p+mUCobLL83+7ONr
         4bmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159197; x=1766763997;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pnCWdNxOjiV83xbv6/Q1ySENLnYMSFtAYAkCgCH7C/E=;
        b=LUkFbvf9dQ2v9bruVzmmdJdgZdLUlN1kZsdjYib79nVN01ugLvdKPitbURsPWMAKcn
         +J78rFvhGN3l7IwR7RT/TOTsk4MT9RQOVHwxzXq4uJ+9D35eL5xsyGf2fFU2OY7cvUcj
         sgAU7BucBhcPmG/MbI8WOIidY0UDdXF+QwHG0DRgsNjs0zZDgkgrMHEL4ymun0Gc4CCO
         TBNH419YoUCexdcWYVgnhTTYLrga9rYw0mFkEetx9z60ojXl00S7zIU+pmPWF8+7TddY
         UtbLVhJp4m3iovhEDRbHnKaM7yIczZr8LLXoLIoegrZRyYKg2QtioPOcL16LpO7V2VGr
         1Vlg==
X-Forwarded-Encrypted: i=1; AJvYcCVhlJHKDwvrfs0dCVXFZ/F9d6Ng9rKAjWPklALxxXuTYHjZGkEfAXabe6rSxsD03XGKMkYkY0SURPGHI0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPw8F+ED7EbRGJunD1RleP0YR5Rxub7eruRR8yUYeQmcA5M5Sq
	+Hl0bj+oeDsxCNWA1Ahb7VfNVBhgWKIUcRspdiajJv2dFeYhQbejd3LtzGnW9MU32yvqg3asLyN
	4fw==
X-Google-Smtp-Source: AGHT+IH94p9GxjeE5eZFV8DN+RguEekXTKbRPlnErvQrVGXfEBJeQJYNzzYoe3WVGxRFHI0q7jnGDkVIDg==
X-Received: from wmcn13.prod.google.com ([2002:a05:600c:c0cd:b0:477:a6e8:797a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:888b:b0:477:9cec:c83e
 with SMTP id 5b1f17b1804b1-47be2999667mr56775795e9.1.1766159196727; Fri, 19
 Dec 2025 07:46:36 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:07 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-19-elver@google.com>
Subject: [PATCH v5 18/36] locking/local_lock: Include missing headers
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
Content-Transfer-Encoding: quoted-printable

Including <linux/local_lock.h> into an empty TU will result in the
compiler complaining:

./include/linux/local_lock.h: In function =E2=80=98class_local_lock_irqsave=
_constructor=E2=80=99:
./include/linux/local_lock_internal.h:95:17: error: implicit declaration of=
 function =E2=80=98local_irq_save=E2=80=99; <...>
   95 |                 local_irq_save(flags);                          \
      |                 ^~~~~~~~~~~~~~

As well as (some architectures only, such as 'sh'):

./include/linux/local_lock_internal.h: In function =E2=80=98local_lock_acqu=
ire=E2=80=99:
./include/linux/local_lock_internal.h:33:20: error: =E2=80=98current=E2=80=
=99 undeclared (first use in this function)
   33 |         l->owner =3D current;

Include missing headers to allow including local_lock.h where the
required headers are not otherwise included.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/local_lock_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock=
_internal.h
index 8f82b4eb542f..1a1ea1232add 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -4,7 +4,9 @@
 #endif
=20
 #include <linux/percpu-defs.h>
+#include <linux/irqflags.h>
 #include <linux/lockdep.h>
+#include <asm/current.h>
=20
 #ifndef CONFIG_PREEMPT_RT
=20
--=20
2.52.0.322.g1dd061c0dc-goog

