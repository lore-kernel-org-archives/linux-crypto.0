Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4B937C91A
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792986; cv=pass; b=EdrkPvj9OHp1QsQbKn2I6T9gbD10fP6Vw8SArI6JPtt7/SfgabpVxoZGmWvotCD9pYSqPZ+P+Mzb937Ij4vVAfaPbsYOTsxkSO3r4SyRcx3wADl3mfput7PC+XnbTbwM7o9sj+5/Be0yEyOML16QDRFUUUxJaUrHt9Rr/IH/bRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792986; c=relaxed/simple;
	bh=gECJK7cPixDrAk2Npfu12wCevFuyOXPtoop7lI+zuNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ff2IStd0PKFgCdxTa8ZGkTEjek2fjglJOIBLqHt2e45A2PvEqDh6lJxLClgY0BWUEVQzqceATNQHqm7t6Cirk3R04orZ99Yhh1ZIn1/zGWiXe2ML3Sp5WYoq7XAsTbiUEoNjBAaBmi41j8mRV8m7hzEsD0nhPeEK7//UhJAXTF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPciZQiM; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPciZQiM"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12732165d1eso9983954c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 02:29:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772792984; cv=none;
        d=google.com; s=arc-20240605;
        b=eUO1duUBZoHJOGdsuzFLf7Q+dsO7BD+bTuBlPvQ4OauXVtZDMD54DJJWfgQiDhNylK
         +49FyqmbRiFm31Eo3kCvrmX4LIoTONoFURJGZ2+JNTxccLRlpiVcOd9CHQBRJgX1/Eek
         gphTK7rangZEENaf7ynO5W/DSMnQP1VW/m5FPpwQ4n7eyTMhIFC5CUAvI3MlOiLDXWK1
         NarbnZvbGCcBIJriFlb93Ubnl+NriOJnRUTUwIki/djNaMM1oav7/LFVJ4E80u89xCxs
         08HATaMvKIIwUra6mhwpYHNc19khaz0Yk/42R+40QDGJtGUC+UQvPNQdZwHW7zkSBNZF
         7zoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        fh=JL0DJC6opBkpA7T240pl/YnfSeS1GzOkI1HQ7GKN9Qw=;
        b=dtKyD59qDukLh7fQYjJdnooVFHnu8/5AU9BD4IhgxafKLHeh57lpjjOZTsDZxDOEnB
         PTjVO7sHvNDWCsqJBmvkRmE4wnh2r0y3lQPG1AVOSmjvETN6AC3UAiFIdl4sTWtEhH+D
         rsBteB2GvvUWYSLyFhzp1Z7O+YgjYgNwTL39KWB3zRgq9UstAAjfTGFCfx7i9lW4MO/p
         83Z5ObaJ8lMveUVuvE2UAomUE+StP7g5EaiiTLzptj2ONUQBeFAsbaXavx4TLdhyzxpy
         bTj8N5a86fRvjc1uMTFOJIDe7JudAO6xnfxH8eiR3ETOCAEiIKnio9XmQzXcc7FSVYVV
         AXXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772792984; x=1773397784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        b=DPciZQiMKD5tpYD5JOPfy5XWO8h5E7J2NXB0TFwoULSdkTCh6HvyGVr63+boZzIHZs
         vFd+Ga8e98Xu9TZncfRmHXkZs7AJODc4sBPJbb/X+0fc/1v9T4do2B3Yu5C6VOPyHnq9
         vwiwI5b6sPuQiOtaUxnH7RSwDlGvQV9he5NbfXQwnv5bRDEfq93zvF4qKYxoMSTz/j6S
         MTXhVfqZgAyP8oa1OMv3m579DkmauSp54LU3vdllxtGB0j6m5cJ28wXBjZxzUCXvUbh8
         099EtVgyIpgeNYg2iRoIvKlNtULifmppEV6kG1gCFKKLUYQWj/l/4B9k9wWgUXFaAVVw
         9U8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772792984; x=1773397784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        b=p1PuAOPcPwWOYgUnVzHBXJZNAVAIMB7AiFhWzxzngDM6lh0/UB1OAgrnPIJdApbfoc
         vB3ijjgS2sz1tplNrFuuH1u2g5RcSWeKXk5OMFU7TkBOr/GDujemgOvYu4J2xu+cs0Ku
         shkX2VQ5QlpeCmJ1wIzXJ//hNmTQIGA3KRSry5CJ00wbDHyd2/QByDcMaZME39NNpC4F
         pEv9+YxC8PCTVpZ+EMOOg26sIWhcWWg8BRg8h+F4ilg63/WCGusOv+2/nKbgqd1ixR/w
         0VNwLeHYr8ueqlpAKnGtVAe0nqeMGfeMnhTjWRKq03lnwftNrBAAIaUjgtmjwgMSR4lc
         7vAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX82JB5y23EfF4mmRlaAWSGM2pftbDC/+KqH7hk2NtKBbJ5E+ezbPsbPxBFC7UwCQrJeWsnvoAZxG6dwdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrwvKlBdljbjO0LYBiiwjdXM9sHc2iEfwgWxoswxPkHaDknd6m
	yjtfkGQEIcju7fSk77CEX3Bftb8uUC1m4Byi9zqmyML2RSPwtbEc9fchwO6B9zHribHTGEg0zGl
	tD952kqyVAhIZ/gHXdOyoGpF3ssunimI=
X-Gm-Gg: ATEYQzwuumwymQNXuV/OYsrtaT7+ZLPtiiYC6PXCw8XnAxXp/9zCJiSLXVaNtAcCi4/
	F5TsFP1nPPQddHyVpBYHrUf5yqBL6YAWQYAdUoMdkiRBV0fApBbAU+BKE3cjqWma6eXwvWWNeat
	2/H9gSFrI/yuwkx0embR9H18FZu08NZ/UX/Ed6B5oKGsQ6KvpJBWvni7Ny7EJSznVf3OcVm0Db7
	EB8w3/L9BVwYW5NW2TaQG2xiY2BcihEfPNhIZk0n59Kr3rV9VWgFE8P8/2DEEHckU8zK8BL5n4E
	Fjkeu9rSQHuvnv5mFEFfnICdlgq+Dt6vayBupg==
X-Received: by 2002:a05:7022:671f:b0:127:9cad:1a65 with SMTP id
 a92af1059eb24-128c2e1136amr744524c88.14.1772792983223; Fri, 06 Mar 2026
 02:29:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com> <20260306094459.973-1-jiakaiPeanut@gmail.com>
In-Reply-To: <20260306094459.973-1-jiakaiPeanut@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 6 Mar 2026 11:29:32 +0100
X-Gm-Features: AaiRm53Jfg5bSHF6icJs_KFXZYY4iK_phz9SHYzN-JwsHFLACvMKwbEaczno5iQ
Message-ID: <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy.shevchenko@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, glider@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> Hi Ethan and all,

Hi Jiakai

> I've been reading the KFuzzTest documentation patch (v4 3/6) with great
> interest. I have some questions about the scope and applicability of this
> framework that I'd like to discuss with the community.
>
> The documentation states:
> > It is intended for testing stateless or low-state functions that are
> > difficult to reach from the system call interface, such as routines
> > involved in file format parsing or complex data transformations.
>
> I'm trying to better understand what qualifies as a "stateless or
> low-state function" in the kernel context. How do we define or identify
> whether a kernel function is stateless or low-state?
>
> Also, I'm curious - what proportion of kernel functions would we
> estimate falls into this category?

I would define it based on "practical heuristics". A function is probably a
good candidate for KFuzzTest if it fits these loose criteria:

- Minimal setup: KFuzzTest currently supports blob-based fuzzing, so the
  function should consume raw data (or a thin wrapper struct) and not
  require a complex web of pre-initialized objects or deep call-chain
  prerequisites.
- Manageable teardown: if the function allocates memory or creates
  objects, the fuzzing harness must be able to cleanly free or revert
  that state before the next iteration. An example of this can be found
  in the pkcs7 example in patch 5/6 [1].
- Non-destructive global impact: it's okay if the function touches global
  state in minor ways (e.g., writing to the OID registry logs as is done
  by the crypto/ functions that are fuzzed by the harnesses in patch 5/6),
  but what matters is that the kernel isn't left in a broken state before t=
he
  next fuzzing iteration, meaning no leaked global locks, no corrupted
  shared data structures, and no deadlocks.

These loose criteria are just suggestions, as you can technically fuzz
anything that you want to - KFuzzTest won't stop you. The danger is
that the kernel isn't designed to have raw userspace inputs shoved
into deep stateful functions out of nowhere. If a harness or function
relies on complex ad-hoc state management or strict preconditions,
fuzzing it out of context will likely just result in false positives, panic=
s,
and ultimately bogus harnesses.

The goal of the framework is to fuzz real functions with realistic inputs
without accidentally breaking other parts of the kernel that the function
wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
are ones with minimal setup (just passing a blob), have manageable
teardown (like freeing a returned object on success) and don't
destructively impact global state (even if they do minor things like
printing to logs).

That said, I'm curious to see what you come up with! I'm sure there are
other use cases that I haven't thought of.

[1] PKCS7 message parser fuzzing harness:
https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gmail.c=
om/
