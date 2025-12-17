Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04D1EE7B7
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 01:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765933794; cv=none; b=KyFAGg2yu7eP09nwrum/oXS0kSjN/Oki4DFTBEihm/kYIkiFN0JkPtxvQ0RSd84K3+7Dvv4dDY3WUJkP+L/vTcnT43weeP43SablxKGt9Ea0WPT3nKltHriJU7DQ+asyYcgvn7CF1qPEjylP5BokAqEWYGAKEYJvNp6RlW3m0QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765933794; c=relaxed/simple;
	bh=pL22TsrtuXZBSzafO+zjFl7qzfncOK7EzR22IjIJGI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Me1cSP58JybOy9BQ9VwkgJ5FVVgIF24zOM2vSzSXyo72ttaauB5z5wbVxessTxMRMDIsIHKqDrou5eRTysknpB6+glmT1F7hxhLu/V3YggFePd7+0k8ap9/QXK3dDDdcREBF1uRpeGPgn4dtiBQl4NKWzOHArcrdVIPOogPloAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illinois.edu; spf=pass smtp.mailfrom=illinois.edu; dkim=pass (2048-bit key) header.d=illinois-edu.20230601.gappssmtp.com header.i=@illinois-edu.20230601.gappssmtp.com header.b=NIQI46RA; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illinois.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=illinois.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=illinois-edu.20230601.gappssmtp.com header.i=@illinois-edu.20230601.gappssmtp.com header.b="NIQI46RA"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8888a444300so39067786d6.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 17:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=illinois-edu.20230601.gappssmtp.com; s=20230601; t=1765933791; x=1766538591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZf/eYpssSDfJG49JiyiKh6ythPIDtWBJCMznOyLz/w=;
        b=NIQI46RA/5trR3iiRu+Ns2HWsBvw/A9Q+Ne0eXMIhKxb9iR0Oh+Iu36olqRMh7yD4I
         aberLKUuDIyEb+KeGOS3l8Ey7GoCMUOPQpWiSazIBXOoC82XuYVuvOJl6RIYS3APp++W
         06izVHBRPRzC34dK5x6FMerFXs32+6M70u5fyG8c5KwQMlCooVeuyEJ39PUiYnOs3NNg
         vh1PvIejIUsP/fLaNG/zedNNak3VM1/SblYi1ET0hIdth2jOxGZhmnG6SxDBh4Gcgypt
         N1yn88J5Az7k14GD+saf9oTiovDNLpbUKMjW3BXylWw6mV2SFpbV/JqiifFtd76AP+pt
         l06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765933791; x=1766538591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZf/eYpssSDfJG49JiyiKh6ythPIDtWBJCMznOyLz/w=;
        b=OCZOpBAKtSR21xIrY4ZVedQSGutHcHiATzJmkc9m4ux+KPRiDi4FE85z72VGlVyrMN
         zsaoUXgljh61dOz43zbijadBuBeHiwFN5iSwv/h+t3o9/zX3QmXRrDdUbX06ItPsUuLH
         zuXySVnxgMP4irNDgFUG6/iw6W5CBZqJ0hlO/EKK3zDMeJxYOU3XEYmA4ssxB0sRuggn
         u/GFIvjCD48VmdOWk+ox2C5CI1giKCjr3f2vDGAqNXJ5v5KwEwvwMgvQOqHydaXtF3Qk
         07pwd5i84jwaObtaiqspGaqefoVPlFg+cZWsBt4WCwKaX5a9jJbmcodYqpDUQozgWDZa
         r9mQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLEUrOQjpSXno1PnWUJMzYx7SXlJTQ64k6rV0XVPe0oiB0aSTvkpk/0tepP0FdhQssyPCUhTfrBNYKOHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWrZ0eiU5YOP7ZkTW/1yFlqYYN72zM9vSaghGew5YvF8/i1RB4
	NFar6aeVJPXUY1/EZyfzo7hLZq1JfMP+GIcCj/THBLioMfuj5SxVObHzShPWzfBuuw==
X-Gm-Gg: AY/fxX4EiZuSCe9hPkSL31JuDSBjXAb6ctsfIjZgkAErV2BH7J32b2DmTwKG/V6A1PU
	vpXrF9TFZ/8nUXYxo2TDDWZCbjtOFBvQCRFOtuWgle7Koehh/etzK8ex/cda+sXJj2byUrr3Eoi
	WPLMjT0QljDe4nBnwyixx2Ss3X3DU9FpMt9aBMKVOfM2yrFTD23sv15OzTyakqA55yIObX4e+m0
	s+6JWQIVyklb/LQdKZbZuvL9XsbcQYXiiochqEKiBqQlLr+Xs4J80j33qSC16oOx8ffqs4cUmUd
	acJrJFvFRtwvopQ0GLDn+Nt2+HmKXFhU2eoCzn2j0gXRuNkGZyo7oggrrgAOuQJwkOpJXkxu7DD
	pBe2qm194jrBj/xyTaGikhNQ9QVBH6Th/ne+47261F6GusXjzG9rNthJCPQxMRLMieqrpajnhKS
	QBqiO0HZoNOeU9p6zvdpzwairC760qSU2f4WLXpV53m5ZJ7vDs+Q4Iot4YyZfEzy6xzLdu4N3gX
	ORIZTSqM6SETQWWvwbqk1okDga2NNGsuxVfXg==
X-Google-Smtp-Source: AGHT+IGjDFK1S6VyM/fYfOLilAfvt70skQ1RowZxJxQP6nlHFavUZNX8qMKoQ5ih8VuDr+Ib7S1xwQ==
X-Received: by 2002:a05:6214:509b:b0:793:dce5:4540 with SMTP id 6a1803df08f44-8887dfec0a2mr293576516d6.2.1765933791524;
        Tue, 16 Dec 2025 17:09:51 -0800 (PST)
Received: from wirelessprv-10-192-243-69.near.illinois.edu (mobile-130-126-255-83.near.illinois.edu. [130.126.255.83])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be31c75b79sm290605685a.53.2025.12.16.17.09.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Dec 2025 17:09:51 -0800 (PST)
From: Wentao Zhang <wentaoz5@illinois.edu>
To: ethan.w.s.graham@gmail.com
Cc: andreyknvl@gmail.com,
	andy.shevchenko@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Wentao Zhang <wentaoz5@illinois.edu>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Date: Tue, 16 Dec 2025 19:08:53 -0600
Message-Id: <20251217010853.54863-1-wentaoz5@illinois.edu>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ethan,

This looks interesting!

On Thu,  4 Dec 2025 15:12:39 +0100, Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format

Do you have any idea how this could be extended to target more stateful
functions?

> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
>
> The core design consists of three main parts:
> 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
>    macros that allow developers to easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>    complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>    emitted into dedicated ELF sections to allow for discovery and
>    inspection by userspace tools. These are found in
>    ".kfuzztest_{targets, constraints, annotations}".
>
> As of September 2025, syzkaller supports KFuzzTest targets out of the
> box, and without requiring any hand-written descriptions - the fuzz

Do you happen to have some numbers on coverage, convergence time etc.
before and after KFuzzTest?

Thanks,
Wentao

> target and its constraints + annotations are the sole source of truth.
>
[snip]
