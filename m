Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F81FCF62
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080344; cv=none; b=IamBPrkgXji/qFCKtsE808oEKjIZTBRPMJy9YaUdhCLHpGXxPaC58mEUfgJ1SvDvCsYcv72X4e9IE6Q+9+1Z4Z4f315YVScB5qCmRN2SmWJvH+5iO6nhzcOj7/FPQcNMmcjniCvT3qI4IWqdvH+/uNz4jMLpMOTSDFbad7wlXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080344; c=relaxed/simple;
	bh=A7gPHEZIEQYCG49NjQ38GqM0IYCU29sZ4kgbaVoDh5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bz7httjbC2TgrJZpr0mOCAUB3SfpvjIE8dcTd+Z8vXbAb2/JMwyrAkayixGHcLPRyQ0KMuWXb2StwIoAEFgAcmpzL4aAa25K2kpCAVp1IW7cZmez12Q7i8ilrlrqjzEbYrRo+xH42W8SsL05h/g4gclv57h0MigVclzyotFMYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qW8kpVch; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qW8kpVch"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e550e71d33so2000194a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080341; x=1741685141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4NsOo3OXCYTu9WQHyv5ORZtwu1IzgjlVv8TtoKqxnnY=;
        b=qW8kpVch/2lef4718yfMZbrKvq8oqvrMJ1Zs8wJZ3cysiWvrEDmP2vqWHjc0bO3sEf
         IqbhcoBfsyEN9LnXVnKlu2nf89pRJmfEvIbKLV14FhpeqBu/R4TWhXY9jTyqasrhiI8A
         OcMvg+rE/VYrVYqgDnK0cDqO3tbiyHDA5y2FMzHTuaA73KEoNBYqD9zZqVaZNS8up7D7
         kNcAbm0h3mTS5eIbs6nb/v2cela2VnQXqwYlr08LEfsgz+FeSbuNmJ4p/U9PazsM6+xd
         o0m21zGV8/LL7CB4DlomPWCcjBxU6mQhI8QY9PQTR8M6FIF08dZVjgwyikEtSicg0MO1
         XNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080341; x=1741685141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4NsOo3OXCYTu9WQHyv5ORZtwu1IzgjlVv8TtoKqxnnY=;
        b=A6pVmwt5HyNlbriqtwNhFyLAwrsm3FbwMhliDWDt6Um+w7XBZXDFjghKD6KLZmCz2X
         9TmywrsoxAbNZkt9iLEP5aNgnHnXwYfsqhKlTDZAIjp4jR8r0TjN4x5YFPezugTYizDX
         cVPT57o1FJEh4mPyAYE9uiTg5ExrH4TWF6APoLrBFHYwOX675g1Q/eSaVf4x54mlOvWh
         zfmY9+9JZfONjpMHgUCnoAovaAkdpZk+Wu/QbJQlhd82m49IOaucfs/gpu4ODI5OpZ6j
         Gjmuk+7dSZbQpwXFT6t5ne44+YcmNY72nYB7GFLgFkCLNmzObeDts/kmqf4HAbKaUW6x
         X45A==
X-Forwarded-Encrypted: i=1; AJvYcCXxAljeQnuRNnQRKbAA86ttILG1Ii6z5GVY1z3dC2+QWbK90sybJunvtCAdOSHt2GSRLmu4WLhxwlXDLZA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+qsI5NYqwoHUv8+ioJ+pMsn12lREeNlgyjQM2WNx/VId5Vkb3
	1/06+yuSPbMX/jdGLfnUl7PPHUhLvKEiHZ6u6r+4yd9bN+zLpvmnH339Akqw5hBvANepnswdhg=
	=
X-Google-Smtp-Source: AGHT+IGvHnVCTmDxfH/8wK0cbMQMdd2+QC7Cg7+dh1AXOrq291KoSLxad8RL5shMmiF0TMtX3LbCMTR8+g==
X-Received: from ejctb11.prod.google.com ([2002:a17:907:8b8b:b0:abf:60e8:559])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:43c6:b0:5e0:7ff3:20c
 with SMTP id 4fb4d7f45d1cf-5e4d6b0cb67mr18149547a12.17.1741080341679; Tue, 04
 Mar 2025 01:25:41 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:11 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-13-elver@google.com>
Subject: [PATCH v2 12/34] bit_spinlock: Include missing <asm/processor.h>
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Including <linux/bit_spinlock.h> into an empty TU will result in the
compiler complaining:

./include/linux/bit_spinlock.h:34:4: error: call to undeclared function 'cpu_relax'; <...>
   34 |                         cpu_relax();
      |                         ^
1 error generated.

Include <asm/processor.h> to allow including bit_spinlock.h where
<asm/processor.h> is not otherwise included.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/bit_spinlock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index bbc4730a6505..f1174a2fcc4d 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -7,6 +7,8 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 
+#include <asm/processor.h>  /* for cpu_relax() */
+
 /*
  *  bit-based spin_lock()
  *
-- 
2.48.1.711.g2feabab25a-goog

