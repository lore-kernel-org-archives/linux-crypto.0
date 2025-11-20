Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A8365A14
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651640; cv=none; b=HxTewuz53PTDzc1qeO2w5AWembEZEMiQfRU/Oy4nBmAHfUFUhB3/4lRT1Wu/QmkCcY+rYg67ujn1nF8C1TBeJiDV4Cysxfi6y2dh+XufkdYnv0l4PRmTGMCel33EaVsrrsYISmeswqPc5kxEt1hmmmnzOxO+PYg0tptQCLLmf5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651640; c=relaxed/simple;
	bh=JSFE6OXplsVQRasUjLyJp87wPLoBhJo5boc6e5TlRPY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Do7Q3/8V5Dxflqf7cIR7RNXm3z5uYQh63uOK9LUW06zOiobpj3LAyp30FaP2B3B38JUnHl99wJfKtgzc/F4H4z9wLyijarQESDw+/adNwzvSrpiIuixsznU5UN3oWcPTdVT4FrsTI/3zZgX0BZ5RHkfJW5XgONGaLpGjG1op/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iCLMPfCc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iCLMPfCc"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso4054635e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 07:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651613; x=1764256413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xNvl5AadBnBbkNqIZ5ePr/ep+DGb1qTLi02EcnmaTpQ=;
        b=iCLMPfCc7jWhEpnYhobvI2CKA2SElpM9LR0+higIlNVPix1drSCs++UbXykawgetXH
         UiK2Mlropxx9wOJeRRbYAassEHRQmIuimGssASlfFCMIHugwhSwj3b/fCzNmiq9VN+nt
         nfzqFiywxCAnOPudXpRx+zUking//m8pTDAm28RHuO9pbcxIIYZA7l9QX4pAUeSVZbPP
         eh6Nz4aythN+TVoBhg44bsA9fQEmI3pG42o6MSQ0gaXXDnwhtpTIkNZOQZ7qHP+DY1pe
         pc31FewAdejDaVASt7E7NmYup1vOHoofrZHC3welUeiAxyB3/Q+FX0BPWg8UOt8wyTVB
         +5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651613; x=1764256413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNvl5AadBnBbkNqIZ5ePr/ep+DGb1qTLi02EcnmaTpQ=;
        b=BN6OhSCBgtYcRHERHUpfzd/0fpnb/IExM4JTFofsF7VaWHTosmvFxXSQuhas+NgsSj
         ft7Qij8C67WibubaaBXz7vlqYopcQtCokxg1YVCCCiex/tMwx/TUIEVvL5Ctl7EgZlnk
         1Ejjtgj7ipuJa2qPqr6iqvyHiVA23uCxoNICnCOYP0UUPUAXXLlABTNJceR5xrIOZaKr
         idHoQJb2GRpNvIrIWIIMMfLRUMQm2yfsEt5vOpNp6llycrPbAkJRcCkpll73ubiPwA9q
         oat4EIiKHGG3DNBQndycDPLGf63D/NRhsPyiz4OOGqmyLtQZDz4wIc5AdFRiwNXmqx39
         CKaA==
X-Forwarded-Encrypted: i=1; AJvYcCVVErE/B5/e71pWY5fi2i5MKMyuupzvdbGwvNPmvJ2vN6KEcgMsImxf2zGGOEBSM26dci3SVxVLbRhzs2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmxux1qb+vHf2ldqWE6jCPY8h20Ta2ixXXQJJBi0xzowjp3Nb6
	yp+h3HmXi++DqEfp7CV3cdhKWFKl6A8Noujcq22hliFkPFEmecnhs2NgxT5mrBlV7fscs9kvrJ+
	pRw==
X-Google-Smtp-Source: AGHT+IF9W56E3BCf4ycfyNzV0Jbt7zmYcg646z2GlS6yDnrRg6LpKFxf4hnN1dp2GqjQ6ITkpBqUZJJJqw==
X-Received: from wmbbd8.prod.google.com ([2002:a05:600c:1f08:b0:470:fd92:351d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1516:b0:477:14ba:28da
 with SMTP id 5b1f17b1804b1-477b9ea8f78mr18741385e9.5.1763651612613; Thu, 20
 Nov 2025 07:13:32 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:51 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-27-elver@google.com>
Subject: [PATCH v4 26/35] MAINTAINERS: Add entry for Context Analysis
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

Add entry for all new files added for Clang's context analysis.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
v4:
* Rename capability -> context analysis.
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e64b94e6b5a9..0445478f74c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6029,6 +6029,17 @@ M:	Nelson Escobar <neescoba@cisco.com>
 S:	Supported
 F:	drivers/infiniband/hw/usnic/
 
+CLANG CONTEXT ANALYSIS
+M:	Marco Elver <elver@google.com>
+R:	Bart Van Assche <bvanassche@acm.org>
+L:	llvm@lists.linux.dev
+S:	Maintained
+F:	Documentation/dev-tools/context-analysis.rst
+F:	include/linux/compiler-context-analysis.h
+F:	lib/test_context-analysis.c
+F:	scripts/Makefile.context-analysis
+F:	scripts/context-analysis-suppression.txt
+
 CLANG CONTROL FLOW INTEGRITY SUPPORT
 M:	Sami Tolvanen <samitolvanen@google.com>
 M:	Kees Cook <kees@kernel.org>
-- 
2.52.0.rc1.455.g30608eb744-goog

