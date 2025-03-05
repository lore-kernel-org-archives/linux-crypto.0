Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0875202F92;
	Wed,  5 Mar 2025 09:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741166116; cv=none; b=B5s0oNYsgImbzp+zEqm7hnC9GscBSmLirJZCdLi36uH466BtQJ59/0SkIeRUsklyICRwcqysLVMo+Thyi2Sx3UfC4BLVCS033vsprpasA/3SXHIyWQuiFFT0ieljfkW+d2FeF4OuL2GeiwAoY/e3zL/4R4Di+HJ0Tdh0Tlf+2YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741166116; c=relaxed/simple;
	bh=fPXp34JCGg4Bgx0SAp1TyOTkZRGY1FXEf4fNxAoo5DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwuIC+gDGw5P0DQiwmTiuoCc/JrWmohYFdEWMTeEVilBHqjJSdlI+x6FWkCd1/4koGAsXyPrM1acMCquf2QRYyCbCMfnoV7GubctlMZOqxGZlhjGZq2hnpi+3d2RH56gmcPXGFReDcunlgA4ANvjNfQUo+4MB1VMqG76gJFRTLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9QNY17g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9QNY17g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DDC4CEE2;
	Wed,  5 Mar 2025 09:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741166116;
	bh=fPXp34JCGg4Bgx0SAp1TyOTkZRGY1FXEf4fNxAoo5DE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9QNY17gBmSuXZHMsQCKWltYjBmeFmJ+gYw8u4+WwMkqMzUjWFluCRHo93JXnjtvk
	 gdN61IKcFzhxT5H8p0qJuUMS1R+BanKMm36haW+DJYBz+TJqGstUzPnDEiu4aj1a5G
	 3maTucZ96koXQJO0hocB6+9zpbiQGvvepfQQDc8VF5sBZbEtaQNNJ2JphwGH9TFPzF
	 imfPOiHf9cUiXRSujWH3yGHi3JTzLbyvnmClZRfIsIvhnyyFsn+FMPZdKkzLJfnNl7
	 u46/Pdk7GK55LDJFe4JimxZ5lxQjLYMMfrweH6aLIb20PrgV6pu3Ynwh9hpGTTnp4X
	 hFw3YNfpXF7ZA==
Message-ID: <569186c5-8663-43df-a01c-d543f57ce5ca@kernel.org>
Date: Wed, 5 Mar 2025 10:15:05 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/34] drivers/tty: Enable capability analysis for core
 files
To: Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>,
 Boqun Feng <boqun.feng@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>,
 Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>,
 Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>,
 Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-32-elver@google.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20250304092417.2873893-32-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04. 03. 25, 10:21, Marco Elver wrote:
> Enable capability analysis for drivers/tty/*.
> 
> This demonstrates a larger conversion to use Clang's capability
> analysis. The benefit is additional static checking of locking rules,
> along with better documentation.
> 
> Signed-off-by: Marco Elver <elver@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jirislaby@kernel.org>
...
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -52,10 +52,8 @@
>    */
>   void tty_buffer_lock_exclusive(struct tty_port *port)
>   {
> -	struct tty_bufhead *buf = &port->buf;
> -
> -	atomic_inc(&buf->priority);
> -	mutex_lock(&buf->lock);
> +	atomic_inc(&port->buf.priority);
> +	mutex_lock(&port->buf.lock);

Here and:

> @@ -73,7 +71,7 @@ void tty_buffer_unlock_exclusive(struct tty_port *port)
>   	bool restart = buf->head->commit != buf->head->read;
>   
>   	atomic_dec(&buf->priority);
> -	mutex_unlock(&buf->lock);
> +	mutex_unlock(&port->buf.lock);

here, this appears excessive. You are changing code to adapt to one kind 
of static analysis. Adding function annotations is mostly fine, but 
changing code is too much. We don't do that. Fix the analyzer instead.

> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -167,6 +167,7 @@ static void release_tty(struct tty_struct *tty, int idx);
>    * Locking: none. Must be called after tty is definitely unused
>    */
>   static void free_tty_struct(struct tty_struct *tty)
> +	__capability_unsafe(/* destructor */)
>   {
>   	tty_ldisc_deinit(tty);
>   	put_device(tty->dev);
> @@ -965,7 +966,7 @@ static ssize_t iterate_tty_write(struct tty_ldisc *ld, struct tty_struct *tty,
>   	ssize_t ret, written = 0;
>   
>   	ret = tty_write_lock(tty, file->f_flags & O_NDELAY);
> -	if (ret < 0)
> +	if (ret)

This change is not documented.

> @@ -1154,7 +1155,7 @@ int tty_send_xchar(struct tty_struct *tty, u8 ch)
>   		return 0;
>   	}
>   
> -	if (tty_write_lock(tty, false) < 0)
> +	if (tty_write_lock(tty, false))

And this one. And more times later.

> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
...
> +/*
> + * Note: Capability analysis does not like asymmetric interfaces (above types
> + * for ref and deref are tty_struct and tty_ldisc respectively -- which are
> + * dependent, but the compiler cannot figure that out); in this case, work
> + * around that with this helper which takes an unused @tty argument but tells
> + * the analysis which lock is released.
> + */
> +static inline void __tty_ldisc_deref(struct tty_struct *tty, struct tty_ldisc *ld)
> +	__releases_shared(&tty->ldisc_sem)
> +	__capability_unsafe(/* matches released with tty_ldisc_ref() */)
> +{
> +	tty_ldisc_deref(ld);
> +}

You want to invert the __ prefix for these two. tty_ldisc_deref() should 
be kept as the one to be called by everybody.

thanks,
-- 
js
suse labs
