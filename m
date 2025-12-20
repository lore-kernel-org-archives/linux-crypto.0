Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467F27FB2D
	for <linux-crypto@vger.kernel.org>; Sat, 20 Dec 2025 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766235131; cv=none; b=Ga7rIB817eZUCNedeGmw+bt3OusfPfojwH54g5/+T8ADXp2jsn3fF6fLYPo2NWZJMc4EASLekk8soBrIhNjj5URz6tAFD6LS7cLscj9YaB+u7s6qEY6lIjxT8frqcpOHz/gp40JHDZ4z7s0benVWsNBgVCVphxAzbopKy0397XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766235131; c=relaxed/simple;
	bh=wkv3Ho3KGiVJkt5Z4uain5drk7TOMSZYfvI9aQbzCrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nyxex3lSW5zFvstyxT1Zn/WDbYlVjT1IG6ygrCP2+ygz91es5TnexuO6SHOxy9rVcLgCq0VNzeHAVeqPk85k4PvMOd+coyamal4UXvjYFC7LQwpwjKiDvg59mDHHDt/nSaEe4BbeOLg7tle9e9AubzIp+LNxHLrFTRpoE6vcJks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fKfKSKv; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fKfKSKv"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0833b5aeeso35672705ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Dec 2025 04:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766235127; x=1766839927; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+dbDPICBAvFxThOmxuLLN+XESg+4otRZJCktLSd/IHI=;
        b=4fKfKSKvM1SC6Tzv/bJ7SpdOWrpUGOe+n+A0s4HucJnyJXoUvg0bBqgs3cJDHd9d0P
         fxyPZ1jO4LYfkUJb/NShyPV2B7ey2yft+RzlVDNvS34KL0lvRtgDj8MYBTSJ4uB11TOb
         kJgeX/fWH4r3ZoBCu5rGx9tgC0Almi31+Rg7noxwgSeyltZaSWzD5G26BrXB4I3DxRCX
         yQDd1uSFawTeGBdhklItdKxkhJ5GeWzKj2oZPIE5K/jf9Jg5LMnqMxEaFGTIiDw+BYK0
         QnIBI5evkUDynqRI//PJWAeBUCPNPRR5RX5+KOrMK+tZHSGNK+Co9jfADrmS1yHAKKBU
         /Q9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766235127; x=1766839927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dbDPICBAvFxThOmxuLLN+XESg+4otRZJCktLSd/IHI=;
        b=wvkCCPUestc8/t8U7MIBxNryHpJl1hJRbo/NPhD/tZaVXWY9ZuJXsQU7/kuHnDjAsi
         M4DLMD+Voll9QmDqKZAuvcvwCyIzcAAZq+7JjlJ+OmPDtt7ZqiwqgtUSjlUJdBDVr+we
         Rh0iHxUkbiX26TSObA3ww28wZWYZA3IyVU/FkgtyAQA/uV4D2THNmWbkoKvi4QPEctYu
         vvn7fbVSKZZve5uZ0SEEBwr9ZjQBjpk7NC0dopsvsI7krfV2/eY+qNaC+ckGM66VwuUs
         wSmcVE8T56pw0nDml+W05+1a7zUCXIe5EIRlJ9A9a1FnCpucr9pahDoFpCMXimNfk1O9
         AjRg==
X-Forwarded-Encrypted: i=1; AJvYcCVQDSxMUIc7IsjWTOzk9bAHvMf7fgsfFa2smoAS8ID5HPGDo8qPdn+YASzPWZjLUdC2kb4SUZdi9usjnqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YytkgEeR2m6aXBURG3oFcy9lVBXq/g8GfYGUJdqeamZrIakUIip
	9iOaeODbGNqnVf8b0ZpGY8Jbpb9y/FH74Haa8B2mfauAZ+CHYFfyb1VoDNO8QNkEUqBAlhk301W
	vy4RbbnsVmhLK5EsCFX9lWy4DEgEGn7KJbpZriOVQ
X-Gm-Gg: AY/fxX6NEOq3vKYzJDa/thfKmBng8p1pOHS8NdE/ptQMiYwO0uP938d2B6SZiJVZsh3
	MKQzxWaFOo5bOLIKuomSyJV6l7wVUd4qN001F1D8drB5vzLxyoQgHq3s+rontzj67K/7ZaV7KYA
	2uOKhnt+EzE4/HRVbaQiv1NjxmWzGGATQDEUtxHreLUWLgdiHRE1wtcKGbuvtuWSvUxx9YsmCK4
	9+DSgHdjUD/fE2TdSmf2pDOCJo1C1xJbl1gGGWsmq/MdIW2g/oVLaHcuYojTNsAUF/p10loN3oW
	N9Cu9oSan5qoWJDD/XaJim2hHrw=
X-Google-Smtp-Source: AGHT+IFK+Y5PBS3dXibTZfBS01UEAFChnwqe6iaCyTB/4jIaIz5ZwPF8qLO8d7Qf00M2Z85ZCatTVKEE522UP0jz/Ik=
X-Received: by 2002:a05:7022:6291:b0:119:e569:f61e with SMTP id
 a92af1059eb24-121722e12e7mr5961881c88.23.1766235126461; Sat, 20 Dec 2025
 04:52:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-25-elver@google.com>
 <9af0d949-45f5-45cd-b49d-d45d53f5d8f6@gmail.com>
In-Reply-To: <9af0d949-45f5-45cd-b49d-d45d53f5d8f6@gmail.com>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Dec 2025 13:51:30 +0100
X-Gm-Features: AQt7F2ppWjAa_1uLXQb3ar2W4qqqhjA5uP_vsvi-YrCuihuPYztcukGp4Yjpido
Message-ID: <CANpmjNOUr8rHmui_nPpGBzmXe4VRn=70dT7n6sWpJc6FD2qLbA@mail.gmail.com>
Subject: Re: [PATCH v5 24/36] compiler-context-analysis: Remove __cond_lock()
 function-like helper
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
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
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Dec 2025 at 22:42, Bart Van Assche <bart.vanassche@gmail.com> wrote:
> On 12/19/25 8:40 AM, Marco Elver wrote:
> >   Documentation/dev-tools/context-analysis.rst  |  2 -
> >   Documentation/mm/process_addrs.rst            |  6 +-
> >   .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +-
> >   .../net/wireless/intel/iwlwifi/iwl-trans.h    |  6 +-
> >   .../intel/iwlwifi/pcie/gen1_2/internal.h      |  5 +-
> >   .../intel/iwlwifi/pcie/gen1_2/trans.c         |  4 +-
> >   include/linux/compiler-context-analysis.h     | 31 ----------
> >   include/linux/lockref.h                       |  4 +-
> >   include/linux/mm.h                            | 33 ++--------
> >   include/linux/rwlock.h                        | 11 +---
> >   include/linux/rwlock_api_smp.h                | 14 ++++-
> >   include/linux/rwlock_rt.h                     | 21 ++++---
> >   include/linux/sched/signal.h                  | 14 +----
> >   include/linux/spinlock.h                      | 45 +++++---------
> >   include/linux/spinlock_api_smp.h              | 20 ++++++
> >   include/linux/spinlock_api_up.h               | 61 ++++++++++++++++---
> >   include/linux/spinlock_rt.h                   | 26 ++++----
> >   kernel/signal.c                               |  4 +-
> >   kernel/time/posix-timers.c                    | 13 +---
> >   lib/dec_and_lock.c                            |  8 +--
> >   lib/lockref.c                                 |  1 -
> >   mm/memory.c                                   |  4 +-
> >   mm/pgtable-generic.c                          | 19 +++---
> >   tools/include/linux/compiler_types.h          |  2 -
>
> This patch should be split into one patch per subsystem or driver.
> E.g. one patch for the iwlwifi driver, another patch for the mm
> subsystem, one patch for the rwlock primitive, one patch for the
> spinlock primitive, etc.
>
> The tools/include/linux/compiler_types.h change probably should be
> left out because it is user space code instead of kernel code and
> the rest of the series applies to kernel code only.

AFAIK, the user space version is just a copy of the kernel version to
support headers that are used by both. See
4bba4c4bb09ad4a2b70836725e08439c86d8f9e4. The sparse annotations were
copied in ab3c0ddb0d71dc214b61d11deb8770196ef46c05.

And there's no point in keeping it around given it's all gone:

% git grep __cond_lock
<nothing>
