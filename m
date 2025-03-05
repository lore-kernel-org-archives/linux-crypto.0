Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA65E202C24
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 09:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741166038; cv=none; b=u2bOEBJR8bGnXgAjRjkOSHCBHxTUmU4Fk3An4QNzXwMINRHIwQpx54xAMnW1blRsP7+PlLWiRS1YnlbCuB3ec+YWjkWmRC3EAWoF9LbYd/xVuXfvF85ivXe+6ua+xN38nXKqPmIOr4rGahSTivaI8DOX1LVtUf0h+VgZaEkmCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741166038; c=relaxed/simple;
	bh=EOEdPWIPXhYnJjUhm7qwGkUHilTR1xlGtYvOLl5TcvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghPP+w99ZDl+CQNovQslybw/vAE+Go17MYSDzC4022Jw75TLCcToKgmt2T7iN8AdhWedPe+qRarwauZLEfeVO4/vwIndhLiD17JC7JSLJm10OcOaK5+5OCYzzq8kjSlATcF8VQ552SbmMBIsbuPC8BjKftuhsHO1Q46OWpPsA7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0rPLFzwV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0rPLFzwV"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-438a39e659cso44243645e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Mar 2025 01:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741166034; x=1741770834; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cBjuy2PLDHX7EYpa/ALszjDhP6sn2qNCfw9I5BYuy8=;
        b=0rPLFzwVeftt/ZgtAMb716GptgL9ElMUz7Jcoww8RuTTES+Ci9tvgSzBHZp2PB7/aI
         rZevOdDheyHYBkrAHC6tvsIlWzX/v+tx1F5x0U3hWtYRqsIDj+dFMhQJp3w5tVbKmMrU
         bYgzPdMQ68Gpp3pQYiIqca5y9CRgE34pdRx616C3iz0abVsdx3G0GGyWidZrhD0T0Vba
         UDgRP5gkIIj4bHmFo4i8+zDG08/EpUgycpWkA9iJj1jAORgHKnz4/PH3dSGBj6zxYmvY
         oHNo4ZoquVUIPIYg2uZKuEji/wfgrdmXdrCSr+Bhlec/hgwitXHVcjn6SNef01d83aNc
         1UyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741166034; x=1741770834;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cBjuy2PLDHX7EYpa/ALszjDhP6sn2qNCfw9I5BYuy8=;
        b=rhpMgS4HjCGXw1mBuILVebFfPe95UGiBTg+Wl58Y3icJqpTX5yYKciCJ55zFaSR/HT
         AdLB+gt3LhDIivNb46cCM7qwiJBZG7T+LLpccr5VyF5HzXKR1DLyZzWZPsd5pO9vLfXn
         VuiHFLccjGP4XO8kX6JsgYAoJ3VDVCOVkS49HyONC6n7ZagEX68F4wL2XQJzmrOfUVaN
         F1Usj5mKk16vEc8Tmt0K4sxI2qHPYpw89CgVy5z37y6jmgpTLz858Wdp+LfJ0EfrjXHK
         q90BJHc8m5aqXEtfk2/2XXYJ44HXH3YDNTv1zFyChvS0eG2UFYv+dn8CHV0dZwBsrcO2
         IDng==
X-Forwarded-Encrypted: i=1; AJvYcCXJ5lGiDoPtvHym/YBRg/8OKfYw0N1Ae8+3a6iAmv2cZC4qowSS3ezNT1zE5o09+VqKUNEcSrO+hUZohMw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfle4PD3KB95E8VcYTqQHWK+u2EZfDtXMHnCGdSBwnWCDb4k3B
	pM/vWxDgtkbeiB2VYkRZsD56bCUUves+jinQwOV0jTnnVHJ8I87BK05YTiik7w==
X-Gm-Gg: ASbGncsSKiS1S69Kf6A0/pcwjeH1q1PbMrTax6CyDzTsYaAWhYInP5o/E7zZquajbzU
	aJw9VG8AFJNMgumwiN/a98F21zBXmt/kH47eMifV6CBaRddblO9bzFCzvvviLzOOFskqvzFtGUL
	TUtelO6JR8g6lLhQJrMoxFIiHXFdSO45b0xc3fjCVd7T/4bCqBgmb7fuNlANFAlOG0eIXnxfMxq
	jkxCqoADB/EKz4VMwIIPWA6xvj2wom57gNfSLJELSvwwb5cZgLyVvYAc6CQXMelNpTfnYQt1kLl
	izMaQgDjGdvPy8j03oMnBiFMHAExgzZGJGeuYmVIxlHlziiosRD9DP24GiZKbuTgXO6JjK0688e
	iZbfbtQ==
X-Google-Smtp-Source: AGHT+IFF0lGPHBWULqd+AVLRPIhf489c6sXiFErCWBRvEttV2lhuAn1pCKQ/kfJiJNdoh7SFX/JFGw==
X-Received: by 2002:a05:600c:190a:b0:43b:cbe2:ec0c with SMTP id 5b1f17b1804b1-43bd29c9377mr14815785e9.27.1741166033783;
        Wed, 05 Mar 2025 01:13:53 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:11d6:a25d:6219:d5fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd42c588dsm11275665e9.21.2025.03.05.01.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 01:13:52 -0800 (PST)
Date: Wed, 5 Mar 2025 10:13:44 +0100
From: Marco Elver <elver@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
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
Message-ID: <Z8gVyLIU71Fg1QWK@elver.google.com>
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-2-elver@google.com>
 <f76a48fe-09da-41e0-be2e-e7f1b939b7e3@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f76a48fe-09da-41e0-be2e-e7f1b939b7e3@stanley.mountain>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Wed, Mar 05, 2025 at 11:36AM +0300, Dan Carpenter wrote:
> On Tue, Mar 04, 2025 at 10:21:00AM +0100, Marco Elver wrote:
> > +#ifndef _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
> > +#define _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
> > +
> > +#ifdef __CHECKER__
> > +
> > +/* Sparse context/lock checking support. */
> > +# define __must_hold(x)		__attribute__((context(x,1,1)))
> > +# define __acquires(x)		__attribute__((context(x,0,1)))
> > +# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
> > +# define __releases(x)		__attribute__((context(x,1,0)))
> > +# define __acquire(x)		__context__(x,1)
> > +# define __release(x)		__context__(x,-1)
> > +# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
> > +
> 
> The other thing you might want to annotate is ww_mutex_destroy().

We can add an annotation to check the lock is not held:


diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 63978cb36a98..549d75aee76a 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -372,6 +372,7 @@ extern int __must_check ww_mutex_trylock(struct ww_mutex *lock,
  * this function is called.
  */
 static inline void ww_mutex_destroy(struct ww_mutex *lock)
+	__must_not_hold(lock)
 {
 #ifndef CONFIG_PREEMPT_RT
 	mutex_destroy(&lock->base);
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 13e7732c38a2..1a466b362373 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -516,6 +516,8 @@ static void __used test_ww_mutex_lock_noctx(struct test_ww_mutex_data *d)
 	ww_mutex_lock_slow(&d->mtx, NULL);
 	d->counter++;
 	ww_mutex_unlock(&d->mtx);
+
+	ww_mutex_destroy(&d->mtx);
 }
 
 static void __used test_ww_mutex_lock_ctx(struct test_ww_mutex_data *d)
@@ -545,4 +547,6 @@ static void __used test_ww_mutex_lock_ctx(struct test_ww_mutex_data *d)
 
 	ww_acquire_done(&ctx);
 	ww_acquire_fini(&ctx);
+
+	ww_mutex_destroy(&d->mtx);
 }


Probably a fixup for the ww_mutex patch:
https://lore.kernel.org/all/20250304092417.2873893-21-elver@google.com/
Or extra patch depending on when/if Peter decides to take the series.

> I'm happy about the new __guarded_by annotation.

Thanks!

-- Marco
