Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8637A305E19
	for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 10:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769509087; cv=pass; b=se0J2s65SvF9fgAmv3YVTh8pQ1R94T1sloLWN3VfagcC14Rc2PvW9OknnK9zvMG4rCNRe4nkT7LG2HhiRsU4URzubbDRToGvSVvAjScz0uBYMnenI6x8M0houBXYcRhXNF+XADNN2+LRBT7tjtAxxkq8h8WwylgtqaUoKY5danM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769509087; c=relaxed/simple;
	bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZPDqQ+ROpjASTLaLpLnCh9eI3bKCYqo9WpWL3Q1FvqoRA86xeX8Qs/6CGFuuwfrsY+BPkXN82IIUbK4o9DgyI1q9k/nTr85ki6kr8/Ozo6xHAh8AUgt4R9gwyv4xhZOsPdhiFdNnt9FRTD+0kelDVSTtOzFWI8OWNEa6QzOolcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0CBOsHD/; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0CBOsHD/"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12332910300so2129449c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 02:18:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769509082; cv=none;
        d=google.com; s=arc-20240605;
        b=byh2iTjGNkhrBtlqiLT+bRfmGVl/rcxAbytCUUoTssdd7ye3/GgNyX3BCbQCPHjqXo
         FeS9FNxVOwW4hw8dmVwCeYQtPsEymG80RMjnlBwnp4QPZnyxiWROU6SKtfYceXSBsvgy
         7J/DK1eLJb7QKGDUbhsEBkNghk4ig/7G59d1PAZAhIk49VZTTDETvXubA6t6bSVRZ0Gg
         AT1br0nI1a+aIQ1wb5dqv9cRtCDjxkbTFDHAjZg5Fc1vcJ6OQv1RslgJDeekjHTJRJec
         DZFfzE+k20KggwR7+IzOnm7uSfDHX/1cxAV/KcH3ZIfx2hzfwIz9ewdGltDKyeGIQ4Ad
         S1rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        fh=o8PVFmI6uiAaXzo5aBVxd96VSe7CZ3Vbyx2mpLyE6gE=;
        b=AvaBmHQUS4J0hwKl4hgV1c5QrQfREQksXqBPutpBzE8V8bnvMIpX5TohHfMyrik5Zm
         B6wsH5sfyEpIc8GEdRNqmUdKpigs8xGKWV9jzywu8mFcs5g+PsNKHNN5asV1cuNYzaiw
         O4fM3GAPUafkUH6VYDiV9kU79k7P/pvSqC8qN52ix/SGXTfWNQKmlBu/lKBmvUXrfLyT
         SohYG8itd7wMY519wgyzuk8Nxol7gucigRO6KiGzqwmB7k0nEVYY9pCkHTY5UD2/wFNV
         kJ1ECKBrrFFTNMaICnY2onNk5o4kDP5hxsF0lXr83981RirEV9koL6HmY9DIJWTnqrkW
         uuKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769509082; x=1770113882; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        b=0CBOsHD/uKOv95aR8OTAbtRyWBxyLJ6N1fESKzC2veqVx9JPRAR/Gsg+n8VRUW2Hp3
         EG6v3t7dFFHmx4Qe9/enHqvAYc/MN+zbW34Q0dIEP/dBnHyBwmTXLN/s4AgkzfrYowyK
         TS9/3JGwU153BB0kkOIvZ5Xtjd+Bp8Z4TnxiAJfhMEvuCB4na3T6n77gyhHa/UDpEb0b
         IgALtOGmCw2o5+TNyDxryyFP5U2h1On49wPhmsdnKC83ra3MXi1Xx96djhullUZFhEEf
         Bu8bIyKcXqPDpnJ079sq0S/S0xkr66rrSYp7sxWe3EDfxUs2fpKiC1ykKYevzeLX0nO4
         YmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769509082; x=1770113882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eWZA1QTRdZDTddGYL8SlE552QBQW/sLGGoi37wJCfo=;
        b=exfRF174x+NHXFVhsP/vAGFM5Q+9sEKH3nnB9sUKiB6ulGg0i2lvGwvmshR/rBFaUo
         KLbPo7J0uke5y1rVW5aeiFnUsizlaghh4h0IcJdKTlgUoVwsB76nRCUopqEV/XPIUvo0
         1BeSa/D0vwmrNDmjL1liVEm3teqUr5+iRDYbWe7dX83GIuUpykd5VexZbqW3rGRvy+KW
         MplKq8Rl20OqH29uhJ2CXKAEGa4ou2EgHmJmK254ihoqksRAdZhIGeBvWQMvPbelcWKD
         c7XKhoHS0wBc0ZMAQEEdGr6nbjiPyV0SHZ4D3dYmrB0BXD2Tl/YwRJORqy0WbF9bwceL
         1uIg==
X-Forwarded-Encrypted: i=1; AJvYcCURpnF4ZsceERl5gxhGXapofn5uXFjM+AGIIAsdngiz9aTu8TnfqAeQ72F5b9D1/tUGjtRL3KlnAww/Jfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB8Aw87ajxkJVwg/jng74aSvhq4nduHqcV9ZihzZ/n7K3dKqOP
	/eiwNjeMi+QT143fIrIpsYOKXdh/emoGIdqWnw04n67/9F8/6IIicMqjgCFZlUIQGsXP372bWCm
	rpMj9CiHHGGdhMnk62N/3BgyUFi6XHP/J2Rf9dQPJ
X-Gm-Gg: AZuq6aIxMvy1fzDv9cVOpIayKQ/njn1wVfQwvArb1rz5rvA2EbsUjxZYeV9Qrj7NIGK
	K8+jtyUNeqC8/kd93v6vsJFGYtWYPSym4z1dlf9fgUlVlrj71P3P+nfU5gHbzOuU5zuiDAHEa6W
	lCGHAJ4V9lIXSAksJZNtWW/aCLMrUMrYT5yU3kwwowRQlRWZpOiMYUdiZvxkrWpehq9DHeTaO2g
	YUv8NSsvspKgjEVMjrJoxOkb1jQgc3w0fYKk+R6YHPbwU4EX7wC4SfWtOT+u0XPgY6uyvZo7bm+
	Gl2AAUoWW6bltIRepF36zmNlMg==
X-Received: by 2002:a05:7022:6985:b0:11e:f6ef:4988 with SMTP id
 a92af1059eb24-124a00cd55dmr806676c88.36.1769509081547; Tue, 27 Jan 2026
 02:18:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-7-elver@google.com>
 <0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local>
In-Reply-To: <0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local>
From: Marco Elver <elver@google.com>
Date: Tue, 27 Jan 2026 11:17:24 +0100
X-Gm-Features: AZwV_Qj2UVNnjgQTvKRMxq0N2rMz8K4yMXQyPWTkZbJrWul7iRYbem2vd2u4cZs
Message-ID: <CANpmjNNHmOzaCSc9hQJNuzNVHXA=LRgXB4Q69FNk6wBuuJGdAg@mail.gmail.com>
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context analysis
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
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
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Jan 2026 at 11:14, Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> +cc Sid for awareness
>
> Hi,
>
> This patch breaks the radix tree and VMA userland tests. The next bots didn't
> catch it but it seems now they're building the userland VMA tests
> (e.g. https://lore.kernel.all/202601271308.b8d3fcb6-lkp@intel.com/) but maybe
> not caught up to the issue this one caused (fails build in tools/testing/vma and
> tools/testing/radix-tree).
>
> Anyway it's a really easy fix, just need to stub out __no_context_analysis in
> the tools/include copy of compiler_types.h, fix-patch provided below.
>
> To avoid bisection hazard it'd be nice if it could be folded into this series
> before this patch, but if we're too late in the cycle for that I can submit a
> fix separately.

Thanks, I saw. I have a more complete fix I'm about to send.
