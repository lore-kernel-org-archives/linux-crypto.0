Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F7D1E9B07
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089504; cv=none; b=hyM9Fbct7GKfVb+IdKrLcmGsg9N9Qey5osHTzH/33D43KOPUubiXwW2iIv9cU83x8RszHJK4u/xN3EAtxhG66V9yqerFC4ccgRnWTVFJul+gxRmbp6FVL3l7NL5VokuUJ34psKimifip4wy9o2Ti9wqDawx5CEKcYTUaIiZRWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089504; c=relaxed/simple;
	bh=XoQ9YNrhSqddyyvTwy9PGAcc33M/ALNhUIP4UPWv6bU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTct2+prdEPunhQyI8IiSeKYfiMhodPZWJiOpwexva19+a/CpO1Gv4Z9GC3dM/DT4jkN5doHdPMLqI8g+6XlJNhgbdHDYMMkxnRqb4VI+pvsfqOMhOwSWEsBKi/8shyLueR5adCzXgg9rOH++POVqYNHnTruNJR1TGHdY8wIUes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUTitxb1; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUTitxb1"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fc4418c0e1so4496238a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 14:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740089502; x=1740694302; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uxsIjlZZ4NvCMtUBbUKBaSillRpgb0iDSMQ6jrfUP4s=;
        b=cUTitxb17CVOZ65WqYbOURmx9+U9mtcDcGUW8KnMeH/9Yk8X9fCSvF8+MZdz3jiJ0t
         cpbjFDR2alhSXIK3+w9YtWgdB63OOjJUbNYCMsU5JFRzxnsgwB319rIPwVpuI3h/wSpg
         9EOjtjhjEmrN3yIwvmn3bAh+sjmjz+4lLNtJNAooxncnNKmhflruQrb3eCTuhHjbn9Wb
         +obM9/Clv0OvQMJMxXoQ0hob8NCg9UBTYPeDxv5sAKe2kLhk0uUYpoHGzghcTuCdP31w
         8YG12Mw0Xfh/co+MtybvONvXq3wzQl8Yev+OASOmXO3RV1FaUSkV2Kkfyvn9qd7WIUFO
         6w0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740089502; x=1740694302;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uxsIjlZZ4NvCMtUBbUKBaSillRpgb0iDSMQ6jrfUP4s=;
        b=qiF1+lhkXcH30vV7SJLbjqfmNDImsyBsuAsmJpoWbnEz16KYe6LAVacRPLfm2mlxpz
         sG+ILwEflpze5BSbNCrBFk2RLoDgCwj/Dvgfl/wroe876NZc4Wu2u2i6UdKJxNgq87xq
         sB+UYFg5L26t2m98bsjrEn5Q01etkX990LpKhil5LY3bcA0YmHzy5PBvZbFDJNAEIxUe
         H8zMpQNaddNdF0SVJ5SA4y/gTBPwlDxZ/vylqxwKH2NR6X7lcPFyVNUkJbPGEaeroO2p
         mZsK3CY8mmi7s9aZjAZaq+lD51BDtcSyWo8KelE6Dpm/JcFhsS81en+u6b8uwgqPLR5J
         MD1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkrXHtPAzQT2TkVNOBkk1tfc7WuQRvJNhZH8BjSgyiJXrIj2xn1s+mtZxFX/va12s6344lKN9oCBRb+f4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF6gZCXXzongH8MtwZTAcVoPm/yholjVCmO4hJV+kdDz5m/boY
	6VQyI5rId+H7T9rC2nBRLVkFbg72WG/iV2w0Lh+G5VvsSq0ngBcTzxVZsxtUcQjG30d7zsLtrto
	nVKMLphCyR0TcEiPon3QTVk+DBXT/8pWW7/ef
X-Gm-Gg: ASbGnctdz1iXNLfXqlz/sPXHN7W0WzJw5ZMEPQY5pOtjrQextrxz3Sd6QdnB7fEJ3ch
	87QvlA8XKoA/ibGni68sFayMpoGJJtCTyt+kITAb0r37yBG9xKUkN8UrWGQEvwfMPZsqwgHTGoc
	ZYE/Sy/EaWUGzf/U/pbk7PDWv5oDVa
X-Google-Smtp-Source: AGHT+IEIWdX9z1JOma8AW9llag/RxdGA7fLsY2vLgpN0yC7kc+omWzG4eOOU8H13xunLk2NWo3uoV4TbIB9wngAORbk=
X-Received: by 2002:a17:90b:56cd:b0:2fa:22a2:26a3 with SMTP id
 98e67ed59e1d1-2fce7ae91d9mr1293778a91.6.1740089501933; Thu, 20 Feb 2025
 14:11:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com> <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
In-Reply-To: <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
From: Marco Elver <elver@google.com>
Date: Thu, 20 Feb 2025 23:11:04 +0100
X-Gm-Features: AWEUYZlmUbD3zD2pKUzd_1_BxaT4jGAHcCF6wIRviSAHlg-jN4GDUIL9VOeu9Kg
Message-ID: <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
To: paulmck@kernel.org
Cc: Alexander Potapenko <glider@google.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
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

On Thu, 20 Feb 2025 at 23:00, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Thu, Feb 06, 2025 at 07:10:09PM +0100, Marco Elver wrote:
> > Improve the existing annotations to properly support Clang's capability
> > analysis.
> >
> > The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED.
> > However, it does not make sense to acquire rcu_read_lock_bh() after
> > rcu_read_lock() - annotate the _bh() and _sched() variants to also
> > acquire 'RCU', so that Clang (and also Sparse) can warn about it.
>
> You lost me on this one.  What breaks if rcu_read_lock_bh() is invoked
> while rcu_read_lock() is in effect?

I thought something like this does not make sense:

  rcu_read_lock_bh();
  ..
  rcu_read_lock();
  ..
  rcu_read_unlock();
  ..
  rcu_read_unlock_bh();

However, the inverse may well be something we might find somewhere in
the kernel?
Another problem was that if we want to indicate that "RCU" read lock
is held, then we should just be able to write
"__must_hold_shared(RCU)", and it shouldn't matter if rcu_read_lock()
or rcu_read_lock_bh() was used. Previously each of them acquired their
own capability "RCU" and "RCU_BH" respectively. But rather, we're
dealing with one acquiring a superset of the other, and expressing
that is also what I attempted to solve.
Let me rethink this...

Thanks,
-- Marco
