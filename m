Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384833254A9
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 19:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766171532; cv=none; b=YIHA/md7N17+ZLrz+t0tnvKoF+MlG1XQtlSrjVWczHb5LuztR+z9OirTNLmxZ36doCgZ1i9Fe2YwLdlyWFeDx1tVvsyZakJC/ixll9nVwod08myzmHoTnGNwFCtkdkexq6FbrrHstnDSef2gGzGHO5MZWl8pMd5A0Kh6lkkgbG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766171532; c=relaxed/simple;
	bh=UocQTd03vlm/TCD4q+onIixekG5jfPJUbAZfFLkbKEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5k93sG+l11q8nXcm8o7h6dppFrFfSNIaHFIIGO2HXqEWvzvQ5jLn3ITMK3c78sR7ikPkkMegNyS4nSbyggSVigiTfobvdxf+9X0aTRKxN55i/rvjT1FhDTrBrjuxRvmlCJvkfuI+tgZ7+JaYPEp+byj3Co0pFEd0LrzhMXvQnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ahqGziDC; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ahqGziDC"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so20121415e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 11:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766171527; x=1766776327; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBMt69sCffmrONEUk9HcTp6E3Zeeun0qAoojziALA+o=;
        b=ahqGziDC3myGZk6tugmwclXX1yxrNy14VTeaJXwYwhVJ2ZF0Hq5XfdUOFojeh0nq9G
         MJ48oY1tuSmGMMRj9c79E3aETH9HxmgZUvT+bTbCQDaVX+ZZcE5oSA2amD6PhlTLlTNh
         nzekfvFZ2OX+zXZLOZtvQz8n9DrgAjMqO8RvPlFgzlftfHI5Ofps/ax5wO3HNr3j6PJX
         orSNHO1qfj+xYyv7tS2zVdmvE8Hr16hI2gLeDKosV+NVy+OwYKseEVGqN7PcL3MZSh1l
         qIw1AanlNH9wUK4ood1oOkTTSwzYC03tJl4G37nrXDKAcxKIG+NEHrdj6AUM2q1iYNu5
         kHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766171527; x=1766776327;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xBMt69sCffmrONEUk9HcTp6E3Zeeun0qAoojziALA+o=;
        b=g2e5tkSa1dTjlpXqVZR+jXqoSvJldfBFnL40taflrPDKemfSf1y6hwZ/hJUEkbyYjV
         2b9snogVqR50IGTDJBFtxCWGa+DRlxBKSj5MT3mtSbCcIWQ2Ys3+pFBsNh6oi/QsFrGv
         R4Blo5KPgfDTqeR+9j+hssFrHJ1Frj08UT1lZhsxRAdT3xf2nsLx85E9S9Yvec/bvdt+
         6zXX/fnuk6IyBa7GMgcUYzcq7Ym6DHwZsJjGfNqGbF2lm2ljm/gdlKbBkxkJyluI51BW
         785uf5enzMP6N1FOeZpIJTwxB4ImSVlM8bnRCnYF5KR3I1WKZtCsaZ+kW30VqgEa//9J
         GD+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzN0B7gmdQciG8K03CE5+YEzbWW98hoiy2zZUxw+67sOCSAXpoHilfw0jY3Ks9OXmQmL+oUlJQW5Qb9As=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVtDOgi63zrJq5mCMXzzVyyjBHFI+T3hJd32Yr7FjxPMy2Bd6s
	iaCnQbxQHPnr/ownf99CuPWG9WHSGLgOm6Oh3w0SRzTUYDlBcf6ugNjJH5oSU1cu1A==
X-Gm-Gg: AY/fxX63MvDGO4EJULP5t/gDAtf8d6ghmopRYmfQ1LyAOe0H5Z3/UJ777+oru/eu4k5
	lv6r5MbpeCT9Yz+ssvvFRETpKhUbPZHw9j0MbYs3nINzG1BKzjMf9qnAy6OQrQMB1zNO9CiowAg
	Q4bmOeyMsQvmLKxn+WPiLF1/Pg170M/TVpPrAxcKFytQmgEId7+XTULQ1j1drV9DuVurQm6r1TG
	daa7/5vPd3hCcQ4sEO7VT+tXssTAmw16cjbPAlZK3tDwpP2P4RSws8NV/XMjBKayPyGdt3wxMPt
	0FXHXM74vana7xkY329NnTYR1A8TMOV1bO/gtXb++VAZb4uI7feZNon32RsafYCiaIIcnXDjkCv
	wFU7ft8dYRiCY+ulk/gnBB45cdiYiN02P6swAdVGnyJpDGxbYCsCWyU2id/JuX4vcExmgS4u85I
	NuhBifIdioGjqZV2/B0oA0pPRz8zwKYzKFOd74xAwbWOXHMk+9CvQlEVY0R8U=
X-Google-Smtp-Source: AGHT+IH9HIskBRHlFIQr/Osyy9yIUKVMwuoBBZxTrb8MCYHFqdOsUtEusA5GjiNqRLtoiyidJxfWVw==
X-Received: by 2002:a05:600c:3506:b0:477:a246:8398 with SMTP id 5b1f17b1804b1-47d1953b774mr34567195e9.2.1766171527309;
        Fri, 19 Dec 2025 11:12:07 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:f7c5:1bb4:fb06:fd5e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2bdfsm6628486f8f.32.2025.12.19.11.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:12:06 -0800 (PST)
Date: Fri, 19 Dec 2025 20:11:59 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
Message-ID: <aUWjfxQ1fIZdxd-C@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-3-elver@google.com>
 <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
 <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
 <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Fri, Dec 19, 2025 at 11:04AM -0800, 'Bart Van Assche' via kasan-dev wrote:
> On 12/19/25 10:59 AM, Marco Elver wrote:
> > On Fri, 19 Dec 2025 at 19:39, 'Bart Van Assche' via kasan-dev
> > <kasan-dev@googlegroups.com> wrote:
> > > I'm concerned that the context_lock_struct() macro will make code harder
> > > to read. Anyone who encounters the context_lock_struct() macro will have
> > > to look up its definition to learn what it does. I propose to split this
> > > macro into two macros:
> > > * One macro that expands into "__ctx_lock_type(name)".
> > > * A second macro that expands into the rest of the above macro.
> > > 
> > > In other words, instead of having to write
> > > context_lock_struct(struct_name, { ... }); developers will have to write
> > > 
> > > struct context_lock_type struct_name {
> > >       ...;
> > > };
> > > context_struct_helper_functions(struct_name);
> > 
> > This doesn't necessarily help with not having to look up its
> > definition to learn what it does.
> > 
> > If this is the common pattern, it will blindly be repeated, and this
> > adds 1 more line and makes this a bit more verbose. Maybe the helper
> > functions aren't always needed, but I also think that context lock
> > types should remain relatively few.  For all synchronization
> > primitives that were enabled in this series, the helpers are required.
> > 
> > The current usage is simply:
> > 
> > context_lock_struct(name) {
> >     ... struct goes here ...
> > };  // note no awkward ) brace
> > 
> > I don't know which way the current kernel style is leaning towards,
> > but if we take <linux/cleanup.h> as an example, a simple programming
> > model / API is actually preferred.
> Many kernel developers are used to look up the definition of a data
> structure either by using ctags, etags or a similar tool or by using
> grep and a pattern like "${struct_name} {\$". Breaking the tools kernel
> developer use today to look up data structure definitions might cause
> considerable frustration and hence shouldn't be done lightly.

Fair point. In fact, it's as simple as e.g. (just tested with mutex) as
this:

diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index 80975935ec48..63ab9e65bb48 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,8 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-context_lock_struct(mutex) {
+context_lock_struct(mutex);
+struct mutex {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +60,8 @@ context_lock_struct(mutex) {
  */
 #include <linux/rtmutex.h>
 
-context_lock_struct(mutex) {
+context_lock_struct(mutex);
+struct mutex {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;

So the existing macro does support both use-cases as-is. I suppose we
could force the above use pattern.

The reason it works, is because it forward-declares the struct anyway to
define the helper functions.
