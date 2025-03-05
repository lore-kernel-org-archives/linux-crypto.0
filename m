Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9A2E3385
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 08:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741163777; cv=none; b=qeNOabnXydeFnITlIC9jZDSvc+Dw9y+Ojrw8LFqZHt6ueQK5zfAgEk7t48e32U0ct2DPVYWiqvxcV/TbI7iSYLjFy6IN9FuAiYHkLh0xG0Nj7ClyoacGRX0XK31HiI10DK+JA/tMER12Pb39c5VSGLHSfAzEMqcVIDkAFD+o5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741163777; c=relaxed/simple;
	bh=tclfnaQ+78uJUqE4m2J8GwrNwDst3SKOWGjXQTac2LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6ITxUPma2Wo6XpGatgrQawAJulbaCyRjMzqLUF6D+dIgLDpHqW5VubWf0BFd0KZNUjQVHN2XhhRGw/TepMoF7PVtePVdGLNgqnDt91taLAVQ0pm7afQ8lWXZY95w3OJBwSW/pTJP+keUmHH1nhy1yUS2CydAjohHjfG6a1HeT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mRucgZbg; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mRucgZbg"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43bc38bb6baso18593295e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Mar 2025 00:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741163774; x=1741768574; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfQXwUL3Ydz7mR+cjRUeO/xqWRGS7uJqxxJMkaNfgT0=;
        b=mRucgZbgodwpnJ/LEwx6AquTZQHVsPy5Wt7PkYj3/3iuVXlzlfYtpsV5C2wYRBmbjw
         3EoNk2BCWG1GAhSntBmEettOHYWTw2qcwjQFFgUL1MBd4YosDoTysLdpXDjaGw4dS5/N
         Afz6ZJnF3JarVvhJSD/cRh7RFuYL7ulENxsauISFdD0pBKnaBVNiVDZ1LdAb5/NKn++B
         5iWGnQFlmfBbr4Dr/jZayWeKdN15hWB7yQvny/iE3hdmhtMSsRKqZKIQU6aD7hHmimWU
         5BgNaV21Aa7Kck9JS9G6E/zL3yh/A8g5Gr1dvG6j87h9dCZniNs542brkWusvVD9JHQo
         W0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741163774; x=1741768574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfQXwUL3Ydz7mR+cjRUeO/xqWRGS7uJqxxJMkaNfgT0=;
        b=c6koyMeHwVoxCEJuGDz7p/tQys1R2LDuIDYYosdTdla+brHrdh/uExdPtgu731HyVL
         2+2xfx+2wdpQlQnJdVnMYP7PCQHO/UscwwFM8pZ4tepDRjKZ2aeV2O3G7dXpiDdrqIeg
         7lcAjtxWoMZ70RjacnMn5jTkFlkDk0zBumbuoEdECYd5V6LPvyhDsjxeol6rMlv66kML
         gfNrCdh7/bAj4O1bexksnG65h1IyniZFb/+KeLHjoH/Qp/ByUpjfS/7L0cFx8rCfn4qk
         WhhYac7lYtIo7QHKLSU5lQyII7lPKxuV47hl8VqLbUyZbp7nam/asdsuOUF8gc7A2IlY
         t57A==
X-Forwarded-Encrypted: i=1; AJvYcCUx3g4H06Y6B7J9GfX2M34GzGcYBxWB3i6zY16Yyb8VS5NAgdmoRymNsybCf+H6C+5PeqPtAV0SlV71B6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRdlMsU11HJ8z8oMM9NL4SkdlM4BMyZSvFgOZvuGsfG+N/HGwK
	F1C8mzRxgOJBsSt8OrXFjPA5z4SzR1kkTsEnBAzk8JxFyT9QVIFpIbja0gql7C8=
X-Gm-Gg: ASbGncvuDWc6TWyltevRLtEeGiqBPYvmlzqxyA1MQUyFjDQfGIpYoN2rayCPvssw1i4
	s4n//e6WakhPM7cNBiI7/VhStTWpWocfd11jRBxIcIBhPIJAvV3shOk5xU/BjRP8Z3mUzeu6yvs
	A25zPqdWnQ6P76gLHoj62B/k5troZz4vSgY2WWgIKi99WNvOJQPFQVuoN0IhvWjK8okuVoPSr09
	dq2Aiov6H4J+RhYEAvc8LwFGB1n04vivHaiKduvuy5QTY1shBAuHvIY7czpiyWcsdVWJyLmal9W
	C16oVIC9FA1PTMJ+ATg/fQWlpu4Em/bOHTWQ9jCtFmGce1P+rQ==
X-Google-Smtp-Source: AGHT+IG1TdRy5Kvu8p1cmT5U4TYJbrUoCcVGa1tX1dkQIqW9WiR2lgUQPgvjP/3zB9IzHIHCvQwYww==
X-Received: by 2002:a05:6000:184c:b0:391:23de:b1b4 with SMTP id ffacd0b85a97d-39123deb51dmr497486f8f.45.1741163774150;
        Wed, 05 Mar 2025 00:36:14 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-390e479608fsm20564933f8f.14.2025.03.05.00.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 00:36:13 -0800 (PST)
Date: Wed, 5 Mar 2025 11:36:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 01/34] compiler_types: Move lock checking attributes
 to compiler-capability-analysis.h
Message-ID: <f76a48fe-09da-41e0-be2e-e7f1b939b7e3@stanley.mountain>
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-2-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-2-elver@google.com>

On Tue, Mar 04, 2025 at 10:21:00AM +0100, Marco Elver wrote:
> +#ifndef _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
> +#define _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
> +
> +#ifdef __CHECKER__
> +
> +/* Sparse context/lock checking support. */
> +# define __must_hold(x)		__attribute__((context(x,1,1)))
> +# define __acquires(x)		__attribute__((context(x,0,1)))
> +# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
> +# define __releases(x)		__attribute__((context(x,1,0)))
> +# define __acquire(x)		__context__(x,1)
> +# define __release(x)		__context__(x,-1)
> +# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
> +

The other thing you might want to annotate is ww_mutex_destroy().

I'm happy about the new __guarded_by annotation.

regards,
dan carpenter

