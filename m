Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5902D838C
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862383; cv=none; b=Ml+4qawoji2cYtnJIVMAzsdTW+Xul7kI4R3QUU4aMq8H/klWVDKKabu7hEK/jNqeUFthp2UDmBmhEAlu/1RvbBpzJHek2fXFnwSnLR2KY0O7Ftmybi4HsBr61ok6lstuh6X+NUbWOGhJqDP7iMyaP3T6EbOwz4+Sn/JwFh5oWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862383; c=relaxed/simple;
	bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kfwki9llbFfmS5Pp6Ej85PpwdQSrJRVdPrXzQHToOplOHF4ESV67ONb3mh2PjarM6dDT1NTa1TlmXlAIG4yL1IttwmH9wm4a0GgFPo9/BV2I2LGxOXjbtb4ayYue2TQKON5D/lNZl4nYnc0KgYGTJfc5uDpcKlAgRfN8TV7GBG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vuM8hUpZ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vuM8hUpZ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so782840b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862380; x=1765467180; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
        b=vuM8hUpZepRm+848oXGmatgIimjTxAljNiygpmzIIFMaLlnn8xMssWEGrSQ/7oBlch
         ATx4o6+H/JOfDKHeMtipFkIH43PTdALHNElJd8NazRFfKNryf1ru/PJfmALTc27HXWfN
         2Nojoo7Jyto3xbeo4Qlj8g17sbHLLT1RzseK8yWjajTaTSZuvaRozQHcDVLFZcacTt6J
         dhlyXDjqJhlImmKzOyYvO0THWLkX1dHZrHTot4ewaCKvkepM62kqwO8Rz5qrxBwM5m/k
         IKG6X+qphO8Hic77EQBcSLxShZz14TC3e46OJSs4CMRsFy4gNBtK9gtWHr/+A57NNx/p
         Fgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862380; x=1765467180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynmi+F4tSnwM3VjJVfL6w3FFtVt6Ah2F/7BtxBtZ4r4=;
        b=BfceUgLLFJMlj27DGenIam/7QR5tPVMjHsQkIf07hmnqm35RpbGshSozlaaUU+LcvY
         msABf5s5JQhVzFOp19zINK0RS7zKIAluHmaBKh8tLcmnqBL+dhvDk32pDMGIgYs80+B6
         JgNCX0LqWZZK/5x72lKGEKGQwGx8PtHSsUKIPxJYxa9XlFh4LkaPbhnrsHRDI6OOIQ1M
         eJA5yI/dWvl1oeQ0wyrkp2DbKE0P/MGRaxPVesWg99R+w5f5neH8iNszf6Ffe5ngSGzq
         8zXPBrChKnB/jkRsHdmAsO1GcvBLtXN+RibbQGpsu822TLW6Z9bfllpjfhj9edbKhw4s
         fn4w==
X-Forwarded-Encrypted: i=1; AJvYcCUFjaPsMZfigzzlOmBZ8N9tMcUMGBYJwTWtPaOByRTlCa+5E6lBRakgnNNhmu17PbB4dwDjLq5K9o0emsI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1yYz0fmi6CY8FHbRMFWZUuh/1SV0oHlIaCfBIG8MA839aDUzw
	1/UIuIKawpxFCKjpLz/LJHEeyWdHWmGcivMuKqaW+1+G/bnw64MG3mawqGOlm0yYty/zwKb0V9F
	aNApEGE0szm3KP7D84i1LtzrzV3/oXcNs2ptXffg1
X-Gm-Gg: ASbGncv/3xyiUwdUGb9k4Do52VY5lgB16TNBQdNCUsV9Otp9u+NhFQ5Sctga/+QFGcJ
	v/+/DwuI4xK/Yd5xCc9dkWc9xm9tMZJyvs9cBh965u8olTuwX7MS6VufW/c2V744m0WPr96RRqB
	UEWQOmhv3taSuqIbPObN88gmOzpuOr5r9/y9xlOvgoao10j59HjvN8Ihm1sfDhr5J1aKtWY7L6q
	bPt+E3q5Y0e9OXLhPGEuNXC4kYvmuauFk8ouz/Uz+vrtZsTuaqbChejG0pXtPzYmX1KzzY9V5oq
	gguTWyPOtFnXV+labBHaUMM49d3d6UC1z3ZB
X-Google-Smtp-Source: AGHT+IFSJu1kx2gV/3kzOFNWf16TP3D39qXN+kNBoxGpDPrlsv10XRPk9OEjnEDlT2YnChI/oMVZm/G/JgVX43H7mrU=
X-Received: by 2002:a05:7022:3808:b0:11d:f037:891c with SMTP id
 a92af1059eb24-11df64b94b7mr1985453c88.44.1764862379392; Thu, 04 Dec 2025
 07:32:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
In-Reply-To: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:32:22 +0100
X-Gm-Features: AWmQ_bkpU_UzkQY7REuOUbS7OqCEAS3jlYqZDjlCZ9VHlEzHr8ON3cmhrcpo9_c
Message-ID: <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
[..]
> > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
>
> I believe one of two SoBs is enough.

Per my interpretation of
https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
it's required where the affiliation/identity of the author has
changed; it's as if another developer picked up the series and
continues improving it.
