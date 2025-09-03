Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4551B3935
	for <linux-crypto@vger.kernel.org>; Wed,  3 Sep 2025 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756894591; cv=none; b=jYos+9Y5aRWXJPC19yYeGN5ou6dH8V3Cqx72qVcgT+SZTWydJSiaXK93UlBtteKQ6WYnIo8ayj3qYDVUCFh/sDYOHu0bniBRVln59XYhzSqPVhEa+X145j8iZA+JURwDJwhGFejiZBEqU3QNZw/g14Vqq1e5ko4SO03fbpzFqGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756894591; c=relaxed/simple;
	bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfWBBK37ZoWwUr3e8pMbKxI+JLf1xHjfZYzmNiNFFZdiaWxWtL8HvX/4jYK3pvEJxZ6GarIapZi3F/ZRRMyRgMKzdrMC6op0pkbPUp7/mgertBct7jn3k1MoAt6OXOwU+0Wcx9G0tWDyzA2DB86WTYECR5Q6maH298eG90hpW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2tlQAxc; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2tlQAxc"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-7211b09f649so14249566d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Sep 2025 03:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756894589; x=1757499389; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
        b=A2tlQAxcaqgPbfxuj0cjdT8ubz0gSevPDx3k+mhSkxb6cAtrK7Cf802ZOdEFayP8Lp
         LYAx7l/cXYzOcHl9GQCpU+Rm1MHXAsLhxOQGVymHuyf1WBa9WmqbsZQuIkA5W3pBJ7N1
         S8cWxIlturU2VVAgCEl9to4Omo8x1efhfdeMQHNExx2wpTQGJhu/r3Uc3RY7ko8nqmnt
         +yeuCq0LhRR/CYwlCqZCcnf7ktqtmoDP85OgozU4L2DWjc4qoGj0s4msJ0Ha6qOKp+II
         VwVS9wWm/swWdTFHxYCxKZg5fX+SCSSWBlfLyJEWBpxesRADvlACeFKW/u3dnMHvoliB
         zwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756894589; x=1757499389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
        b=tgly0F1QcoalZEjmAeUV97Mbn1dvI+rI4inmOiQvI4us5IB301dIXV/N83jHyUaWj8
         ASdvWOe8E3jfAJ9LLbDFY+Ytc2WEI01JHaeZFjZ7AhSfs1XqoB2diJhPkDF9bQ7XWzeu
         ZeuWN5WPRFVJuC58Yz8Xt9KxWkwiI7qaAWY4R4HQbOL9Mmwy0gvNtgxksVb2zJwvVfEw
         nXumJDNRv7Ljv3krXWPpZ0S2oOjnR8bPjrHM7vjnFYhSoZvJww7Xn2D5Qkqb+neVrf5v
         nr6FYb+t033KpsYAkCQ4M8DqXJUESaxIc9l5fGOciIB7c53F1Arw0tOk3/ih/oMmwZ4Z
         huGw==
X-Forwarded-Encrypted: i=1; AJvYcCUMJaiptLvxb7fpeBq2Ux7jecEXjlg6DW8ivmt53mFFrjxu265Y2Tvr2oJ4/wfqVZkrdHPrDyGKezj5i1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMmZJsNyLhiidPgcjA5QkaVwK9t0IsTZlfK9K7CKjTGrr1XZp6
	Qu21xKunEB9PPz+DyqaaJbJ90AmSFlzJ7tSZBsiSxJqCmrP26LO43GpZbLM3JHhP1BT7qdNjf7K
	goTLA+xUMZt/Y7dRQ31YniIxEqpnEriYK1F+Djq3T
X-Gm-Gg: ASbGncsrqBhYZ3XsLt7vFx2+CJkUmXHq5a0rf7UFNkdtzO018zNuJfnG6LpSPk2dS17
	rj4t2bf5D9P8VMjvyMHmx9TcMeRccZxw1IMHpnWfRe6dPZTyRbv53qgSBdEye8TNmTnjeC5ZqxJ
	d77FNBioYVHpVC2wscOxypXMn9hE0ySqQf52R6yuoyZCHLZGavKpYjCfFVH1M0nzS1Hz2CTRVkT
	OQqPocMBoe940BBxMTbXaDNb61uB9BHcCnybtQyHi0=
X-Google-Smtp-Source: AGHT+IHwBiV9LKyHeujCf++SDvt/C0wOTrdrnbCdEByYNIzOd4yKfC34b8rjHF/8NpB89aPcS9hAgwqlaAjIQWQUY38=
X-Received: by 2002:a05:6214:1316:b0:720:4a66:d3e7 with SMTP id
 6a1803df08f44-7204a66de85mr63437046d6.26.1756894589045; Wed, 03 Sep 2025
 03:16:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 12:15:52 +0200
X-Gm-Features: Ac12FXymppW_352dPk8Sx6ooy74nYo3Wzf5MB3L6oworaHp6lw6JSbbxp82YL4k
Message-ID: <CAG_fn=WNHYR0J2oehz4gO8TB2HADb8qG0q++y153Jg1d2GLfYA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 2/7] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> + * kfuzztest_parse_and_relocate - validate and relocate a KFuzzTest input
> + *
> + * @input: A buffer containing the serialized input for a fuzz target.
> + * @input_size: the size in bytes of the @input buffer.
> + * @arg_ret: return pointer for the test case's input structure.
> + */
> +int kfuzztest_parse_and_relocate(void *input, size_t input_size, void **arg_ret);

Given that this function is declared in "kfuzztest: implement core
module and input processing", maybe swap the order of the two patches?
