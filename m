Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0361FECB0;
	Mon, 14 Jul 2025 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752471340; cv=none; b=dsM1Rjitw84K9ybm8Fz9EOPcjwawfZ+xCaO4R0r2/WR/inaPjzfDwYnlZNHGab3D3GGKdWP15rJOfVVKJwceQ77aM6XEIaK+o/0qDZmXgmEd71ORmJRz2t1bmOzt2CkoIPJ5NbuWT3ADHU6L79tvmM8gejGkyz0MLtD3pVuHiaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752471340; c=relaxed/simple;
	bh=AhfXLPJit+nq2sVNcl1gEor+RQLrJZeeiC7pziqeDIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDs0VnD5Z+WpvuSXlqtW/7rb5/+uMXHCNGcr29ha6ZizN7ahGRQ3YQmUXF9tVWSTLMweXWd6HOlBICqTYCoIDRLvwroa3uUsUMNylwvqzW7pI/hVlOx5vHkBPjyWbI+EFHzKp3wXaA/BeBBQvqZscQNmVNmvakc26XksD/RuiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddZ8zxEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddZ8zxEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4EEC4CEFB;
	Mon, 14 Jul 2025 05:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752471337;
	bh=AhfXLPJit+nq2sVNcl1gEor+RQLrJZeeiC7pziqeDIc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ddZ8zxEAQWvd2uKLTx/MqCvkHdYlE8+ZFaOGxa95LxGvIIkbQ4Qa/Lv1MA5Fkba2O
	 U40OTw/aGVt7sa2Q6wSFCr37Q6zODj+hin6CXBjNYrmqi0ISPOdiAEw2FurPK+lTOk
	 lIKvMov9H2RLtzbEkhEksubFKmGSZPgiWtc9hk5Twt6Q3/fvK2Nz/vMMlrSe6tbMUw
	 bR7KfhZ/kmm8UeCa0vyxW6v2/wVpZj0UBFve9r5vEhGdUhFqLbrQQ0+e+03MPI1vKW
	 SlZ/d8E+zuuRFVXg/qlq/iPODaql6PW/zMDX8vFIPo8HXkzRis9ABBg6J9aDT+m/mf
	 eaptsVz2ztrBQ==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32b43cce9efso31067841fa.3;
        Sun, 13 Jul 2025 22:35:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX6AVekZv0tK2rCNYVe00cQcp1YfxNqkEc8QsoEGVb5pJ702CVcq2b/wZplSdLkVIJlmmmHHh2Z4aCIh54=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG4+ttV+HIXSDnTs1wUkTsXQJmIVxzLLOy0eP6vhIdu/AB7WyS
	SWFRtveO6v05kPiqIp7Mtq+3PyuNWqQMyUxuMpDfHcHQ/wAOiRm1OPZsZNb+MH88dIhJ5W52bGC
	SwBMR0MkzYax+0Z1YHnmOfE0z9JON/vw=
X-Google-Smtp-Source: AGHT+IE/n3Pei1+hhhJWAvyg52eVap2Ik9HDTQdu5m0wlgA5Mu6mp4EgrZtImkRCLoTgZJ0lGSuxGUxQmYFDqW6fybA=
X-Received: by 2002:a05:651c:542:b0:32c:a097:4140 with SMTP id
 38308e7fff4ca-33052f70c5amr31941361fa.0.1752471336076; Sun, 13 Jul 2025
 22:35:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709200112.258500-1-ebiggers@kernel.org>
In-Reply-To: <20250709200112.258500-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 14 Jul 2025 15:35:24 +1000
X-Gmail-Original-Message-ID: <CAMj1kXGzz5hGiq5ebj9kxzXa3uHOt0eTBx3JHk7kP3S_+acwLQ@mail.gmail.com>
X-Gm-Features: Ac12FXwp7Fbb6COXkH-2bqBOjCIG6h27XjbFFg53HLlKFRHW0DIqtcRf-rDbuAQ
Message-ID: <CAMj1kXGzz5hGiq5ebj9kxzXa3uHOt0eTBx3JHk7kP3S_+acwLQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] KUnit tests for SHA-2 and Poly1305
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Jul 2025 at 06:04, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is also available at:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-kunit-v5
>
> This series adds the first KUnit tests for lib/crypto/, including tests
> for SHA-2 and Poly1305.
>
> Changed in v5:
> - Moved hash_irq_test2_state from stack to heap
>   (fixes https://lore.kernel.org/r/202507081257.9sV2D0Ys-lkp@intel.com)
> - Replaced HRTIMER_MODE_REL with HRTIMER_MODE_REL_HARD to make hardirq
>   context be used on CONFIG_PREEMPT_RT (fixes a WARN_ON_ONCE).
> - Removed an unnecessary initialization in hash_irq_test2_func()
> - Added comments that explain kconfig option naming
> - Added link to Poly1305 paper
>
> Changed in v4:
> - Added Poly1305 tests.
> - Split the addition of hash-test-template.h and gen-hash-testvecs.py
>   into a separate patch.
> - Added two more test cases to hash-test-template.h
>   (test_hash_all_lens_up_to_4096 and test_hash_interrupt_context_2).
> - Simplified test_hmac to use a single consolidated test vector.
> - Lots of other cleanups.
>
> Changed in v3:
> - Split from SHA-512 and SHA-256 series, as per the request from Linus
>   that the tests be kept last on the branch.
>
> Eric Biggers (4):
>   lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py
>   lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256
>   lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512
>   lib/crypto: tests: Add KUnit tests for Poly1305
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
