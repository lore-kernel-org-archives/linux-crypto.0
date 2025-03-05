Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A4623
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 00:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133070; cv=none; b=dLuWjNl6IpgheJTo7UfBpJk85KOPCylGWh7n+cGxq6tlRVZ8nla+43X68fqa1lkTWQyE/Pj6/1/fBK0zsuPQGaKp0xPri7Wam/MyQXCohOKCKIT0A2t/o1WrYBqmLD15Qrbw2hlbDr2b7GpkDqN1turjEdD9z22Sya7C7SFAoeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133070; c=relaxed/simple;
	bh=obB0h8AHDTv9/LrRGXUTQqWYXLHGR7G5bwHes9VJzA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGgIy/CW6l5cpEdbk6Rr2z3fonyKPg1ZBzHIfWD8vFl0z0JJlshAxR/uHUMPVsgtDwK9RyNrmuvGK7ajV6YNd/R9ureYX2l+qcLLzYj/Da76r2pq2JBF7P7FtLCyocoWB8lcXesOyY29GHO1/VGIWihpqP882ksSmIkwyK64gaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gm6eIZ0T; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gm6eIZ0T"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2febaaf175fso7916681a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 16:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741133069; x=1741737869; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LM4+VbDeQgzb/55NI3t+9R4dHqP/5jKcZhBFBtOBqBA=;
        b=gm6eIZ0Tz5znH7+Y+X9dk2eBqkHgynYAWQfqsjqVyBF8ETXt8cfDR5xgZFJguu+liJ
         8UrZjVBOhKjFgaGTiE+fgb4SQaOud+QtD4LgHwdAiGikppuFoTcKHFMfO7FErBFvaOU3
         k7sjNIM6Uvw7qe3QlkyhhLQJ2lwbReohwIgL/nuslOM2fdpVaDluJvOh/xKa0L+TxjTV
         Pso6g6MXXTeFjIF3p7rkDHtr/bXIdwR+4YgGLM5Eku29aAb4yxRgjWxEaz4qSFq1NmKI
         USzp48uboOzSHTV5WDm5h6VFxJ65E5qX4Z/cChJ/SLJ2Eine6Bnymdhnynz0ryQFnLOU
         SWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741133069; x=1741737869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LM4+VbDeQgzb/55NI3t+9R4dHqP/5jKcZhBFBtOBqBA=;
        b=mLdzCGLHDBoQ3eaLmaY9YCjmR9lgX5H1myLMApa46awmXOQI4YWQAIFblgg9LdHrcT
         zC2wkHIi5WbvPJHB7ZWAY6AJWXqydpoXQbxoqWHLSZgiiGbSC7o+Nu7GQB+ksMHXR7in
         6NiTw5AC8YVC2WfhfMhsu2alAK7bp3aCfqkSrAeIsnri/RdSlv//J/FlWTyPLVyqIc9X
         A068hGcGzwdWVtQOP6KCiLApFrN4ec050FOcFytwpmT2u/hclRkKZ9eofOZqXePwtxhK
         n9aujb/uDeiNGQHC8AXqnjddEQCKo5WlvK7cICpFioIpI9jdU0zEAalIK6C/PjN+h2m0
         F68A==
X-Forwarded-Encrypted: i=1; AJvYcCV9ITmzCzt+nUxBj2wX2TpBtE+sOuhpxffnDLMVvqBHl1s+bJ8e/pUNSXRJ2HbsaVh5tfmD/JgtfZdZgkc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeiNrJDIWIka4OV/9ckHSrBuqP+WBb/Yw0/AC44yJHPd7K6zQn
	aZ4hEzh3D8mD1iFPKsR4qmPhMQa/tvZlYv8PCCzzj9eXZ/W5Pe9sX9uxa9dGTQr8Rn1fpBLLxed
	w7eCyNS5qCpP1MVLtpGTG989zR3aSfQN8AQs1
X-Gm-Gg: ASbGnctCLOuvtMNKX+y01G7p9Ps8P4wQ5GbRgQXfY43KdBQ3v+DCzUIbKm+wc5UPYx9
	c7zQMqQLeA8RKAacrm0gEiHPy9R68F3QJ2LcMfPH2EFu0NDR5A3G8bnyR779YzhgJSCZqWHHIHQ
	nYjVuxTb1DZSoNP3MQmmSViqgL3jaWG2S+C+JiHflSx8OqWabyu9vESLAv
X-Google-Smtp-Source: AGHT+IEtISi7Tlt5kX4zmOO9FEZtWXEEe9J/QPKTHvSqVUkwchS3k7u+aPOlcVNfd6t4Doh8lMUn/x9+fE5ZVoRcpzI=
X-Received: by 2002:a17:90b:4ad1:b0:2f4:423a:8fb2 with SMTP id
 98e67ed59e1d1-2ff497cce8emr1999183a91.20.1741133068525; Tue, 04 Mar 2025
 16:04:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com> <20250304092417.2873893-4-elver@google.com>
 <41a14b09-9f09-4abe-8caa-89cfe2687562@acm.org>
In-Reply-To: <41a14b09-9f09-4abe-8caa-89cfe2687562@acm.org>
From: Marco Elver <elver@google.com>
Date: Wed, 5 Mar 2025 01:03:51 +0100
X-Gm-Features: AQ5f1Jpv14gcn7aAs4yWXHhRLBF4i5EQTdXxL-iYYKY2gY0B-tX3E5j-KtDZzBU
Message-ID: <CANpmjNMYoRTj3F1L9UCp2gHVbVZw0ieNnk0xPZ8Q--BhFCy7Ww@mail.gmail.com>
Subject: Re: [PATCH v2 03/34] compiler-capability-analysis: Add test stub
To: Bart Van Assche <bvanassche@acm.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
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
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 00:52, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 3/4/25 1:21 AM, Marco Elver wrote:
> > +#include <linux/build_bug.h>
> > +
> > +/*
> > + * Test that helper macros work as expected.
> > + */
> > +static void __used test_common_helpers(void)
> > +{
> > +     BUILD_BUG_ON(capability_unsafe(3) != 3); /* plain expression */
> > +     BUILD_BUG_ON(capability_unsafe((void)2; 3;) != 3); /* does not swallow semi-colon */
> > +     BUILD_BUG_ON(capability_unsafe((void)2, 3) != 3); /* does not swallow commas */
> > +     capability_unsafe(do { } while (0)); /* works with void statements */
> > +}
>
> Is it guaranteed that <linux/build_bug.h> includes the header file that
> defines capability_unsafe() or should that header file perhaps be
> included explicitly?

It doesn't come in via build_bug.h, but via:

  scripts/Makefile.lib -> "-include
$(srctree)/include/linux/compiler_types.h" (all TUs) ->
compiler-capability-analysis.h.

The things pulled in via compiler_types.h are treated a bit like
builtins available everywhere implicitly.
