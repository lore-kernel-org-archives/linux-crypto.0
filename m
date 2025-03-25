Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679B187FFA
	for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 20:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742935313; cv=none; b=XiXfEsUl6Cnx/4WKlHuxnoD69lNxb72VdKAprzwJGLo14Qo8ngX367roEZfZdm8LAHJNXP6fQRW0q9lUtTVRjSXh8mjYMbdqp59iS+soZXH1/SnZczYFYM1T5YAxJPoeMtnz9C6Ix3e0yQXkWv1/rtesQnNW6gEoKcHxgCdWoCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742935313; c=relaxed/simple;
	bh=GCAhGVtueceq1ubCUXU7aIifbCxnCpAKEuI8oUAtt/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QcaTLjjx6lauYBzpCHHJGYSdknXQ5PZkWUhIXw1j1VEet+OGYTsnZ6MWSkSCajRiekbsCqbJRbSqQhclDgTAtp3HrjdA3ehIG4Og7JgCO5UbVNe6MvZ/K89o9PB63CRQ4Q3ieEtrz6EKnvop2BLn9gwqy4SgnKRw1Jq+JSh65Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJLnPXyP; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJLnPXyP"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so853131866b.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 13:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1742935310; x=1743540110; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=gJLnPXyPnQB7ZVnoOIqfsF73CVu7Wk9KYRSN88W+g3ut2tSfgIcSdkR4+dWnsZLhOH
         +j0uR3S0qYCPdpZQJUCCPYLPGdnQPINNsJ2AQ8/q1PxBkPyWIi3M5Afu2/QfbBvQYwe8
         eEMOvejESYXokDwaVV2Rv2kDvyBLkzbYmO/7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742935310; x=1743540110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=fSQgK3TUsokh34lHa22wBc8Rqj75tCrez4pwUSsnAMIbs4WcWP1nb7C31kJDzbFF4s
         GtFXzbc5zctCcRoHPeslNcce59BaLgQ4VWLSPlElvNKng6mIJe+je2pOCWIza/7TOVRK
         LXBwuXQZst6gST0JlzfOy9upe4FMOwt6/7Z401n/mebnN23hvYZ2wU0tthTZqLd+ijqB
         hAQNcw0a/kf8uNvQyObKpQrAVFO28XFA/njlE+LF/oMq071M3Wp66E4bF85vhgwGsrAz
         DCArSA+K9uNOgo3Iz4MwMTW8tJrutF2a7PHK1k3Ax8zcCvY0w58xfXUiBxi6yhek/S90
         wqpg==
X-Forwarded-Encrypted: i=1; AJvYcCU/3BFiORZqqF0pK/xauFIo8GNkWAZK7+L0jikc9WvVAKyatd1hMjk/eQHvDCdpBrn0Miy8PNVy52tuBoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1ynJmGWrcup3Vv+K0ha8oBdTR1IRm0fFIw/omJkU6eaiPLe/p
	XX7l3XjxuCN3lppPROcY1dC8yVe7/9tiH2tqEzjaf3WnqSpl3EJbZNmJiiuVxW3CXVwhN++ElG9
	zGuE=
X-Gm-Gg: ASbGncsBUVmY2JxStVYosiQ91p36TYbx/K7UdQwzW5VupF22y+aGwL5rwMaJm9LiEb0
	JZLuxNLWchg7k2adgyj2NqBxNYmyWqMvSNnB+jdhoyAhNRBy1iiRLs6VxHr6WVKaPSUm7aUE0x7
	1/4Dp2n2L0pbEZQpq530wfC/BDVbu/yVGFXMBHVBxjnoNYqwrBSzODzlfSnMntx1JFIfkRGuEza
	t4wesrpzonHzkQFOW6LUxhqgDQn/NXQ/aNlkRrlyqpspD5A/+Lc7HBE840vVPzn0kXo5+LcPsOg
	yjUqaWm80fhuS1KjWOxKBaVJg9FqwPsED6Bgn9r2/TFCrNE1cAWDoe/P1T1zT8zpHiEFcFHOplp
	Pc4bL5D92oq1cO3NUGyzGnqBmd2kZYw==
X-Google-Smtp-Source: AGHT+IEtX1wf2W0vZH3H9TIaSQ/l24teFLWS3VLk2fpMsPBowdKqILUMp0usEWIxGAt9t3k77jGIUw==
X-Received: by 2002:a17:907:c5cb:b0:ac4:169:3664 with SMTP id a640c23a62f3a-ac4016937dfmr1649998766b.33.1742935309660;
        Tue, 25 Mar 2025 13:41:49 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef93e156sm906662366b.84.2025.03.25.13.41.48
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 13:41:48 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so853126666b.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Mar 2025 13:41:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUo6vq7yH/3/N/+SXAHbiFRyfWet94fc9HLdg8yLNOLRSXB8fAMAuYT4KLoVPUWs0JzxUOQO7r9Aj+jClw=@vger.kernel.org
X-Received: by 2002:a17:907:95a4:b0:ac3:48e4:f8bc with SMTP id
 a640c23a62f3a-ac3f27fd3b3mr1859596466b.48.1742935307883; Tue, 25 Mar 2025
 13:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325121624.523258-1-guoren@kernel.org> <20250325121624.523258-2-guoren@kernel.org>
In-Reply-To: <20250325121624.523258-2-guoren@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Mar 2025 13:41:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
X-Gm-Features: AQ5f1JpwFc7ifwGuAhyrs4E5qPgHx1McCR38KFycRhkLFRMKTveHrmoaWi4zba4
Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 01/43] rv64ilp32_abi: uapi: Reuse lp64 ABI interface
To: guoren@kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org, 
	oleg@redhat.com, kees@kernel.org, tglx@linutronix.de, will@kernel.org, 
	mark.rutland@arm.com, brauner@kernel.org, akpm@linux-foundation.org, 
	rostedt@goodmis.org, edumazet@google.com, unicorn_wang@outlook.com, 
	inochiama@outlook.com, gaohan@iscas.ac.cn, shihua@iscas.ac.cn, 
	jiawei@iscas.ac.cn, wuwei2016@iscas.ac.cn, drew@pdp7.com, 
	prabhakar.mahadev-lad.rj@bp.renesas.com, ctsai390@andestech.com, 
	wefu@redhat.com, kuba@kernel.org, pabeni@redhat.com, josef@toxicpanda.com, 
	dsterba@suse.com, mingo@redhat.com, peterz@infradead.org, 
	boqun.feng@gmail.com, xiao.w.wang@intel.com, qingfang.deng@siflower.com.cn, 
	leobras@redhat.com, jszhang@kernel.org, conor.dooley@microchip.com, 
	samuel.holland@sifive.com, yongxuan.wang@sifive.com, 
	luxu.kernel@bytedance.com, david@redhat.com, ruanjinjie@huawei.com, 
	cuiyunhui@bytedance.com, wangkefeng.wang@huawei.com, qiaozhe@iscas.ac.cn, 
	ardb@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, bpf@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-atm-general@lists.sourceforge.net, linux-btrfs@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 05:17, <guoren@kernel.org> wrote:
>
> The rv64ilp32 abi kernel accommodates the lp64 abi userspace and
> leverages the lp64 abi Linux interface. Hence, unify the
> BITS_PER_LONG = 32 memory layout to match BITS_PER_LONG = 64.

No.

This isn't happening.

You can't do crazy things in the RISC-V code and then expect the rest
of the kernel to just go "ok, we'll do crazy things".

We're not doing crazy __riscv_xlen hackery with random structures
containing 64-bit values that the kernel then only looks at the low 32
bits. That's wrong on *so* many levels.

I'm willing to say "big-endian is dead", but I'm not willing to accept
this kind of crazy hackery.

Not today, not ever.

If you want to run a ilp32 kernel on 64-bit hardware (and support
64-bit ABI just in a 32-bit virtual memory size), I would suggest you

 (a) treat the kernel as natively 32-bit (obviously you can then tell
the compiler to use the rv64 instructions, which I presume you're
already doing - I didn't look)

 (b) look at making the compat stuff do the conversion the "wrong way".

And btw, that (b) implies *not* just ignoring the high bits. If
user-space gives 64-bit pointer, you don't just treat it as a 32-bit
one by dropping the high bits. You add some logic to convert it to an
invalid pointer so that user space gets -EFAULT.

            Linus
