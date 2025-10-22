Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D35319851
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761128065; cv=none; b=AMm/AvgrmYOJIq/MfP6kkmJbQui7R5Tzb4djG1Xp6Tb0ayn02IzOjAYUjGCLgTEBghckO2HXdVrYCUxIHcLYkdJKhZJ7izTFh0piKQpJf7aBEjTAae5tPe6+O+ZPHD3ZnGynU98MgM1gtW56p1igRp9Va9L4u6r9hDGKTR97aWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761128065; c=relaxed/simple;
	bh=BksiNg7tpyriGQ1hysmu056HRi6UuHZRkqrmwRvyfJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RxFWAA61UCvFNibO7G7E0PPzijjhGQhXMSHPWeQRHc7BRSoLk1iNLyDCprIoRzFsxKVd3D5gRnDEdjA8C97+u4oKy9e0ijnVToqlQ8CIIdPG27AMB1wzMtJV6jzZaOJmG+VmQy7iGOLt1uAtM5arTErHcqWApMtsiLTnGmXvFp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFXjCo9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFXjCo9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B36C4CEF5
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 10:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761128064;
	bh=BksiNg7tpyriGQ1hysmu056HRi6UuHZRkqrmwRvyfJk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MFXjCo9zcnJWPm3i/uME/Gos6Kai5pOUtMmkZaCxIxH4f1G2iBNWO6BsteyH6XnGr
	 4Zd90D2WOq3UrIzDnGJbyKY0uVCIqubFuVODaRpPtAkeHAAJ6guyVzzV+PSkBIh6nV
	 CGRlEUSdJHnegkag5S2Q8n1D884BHBrlZpy2HLc4DpDdwmg/gr5CIevhsYFWNUIjVW
	 zgNO7y35aGfa12tpEh2Rs78q1h4n0/bbmWAnmahO/cxQJh+1iUay2OwuY0G82vngzM
	 96vZQ1/6qgpLFmEm6HnzdnnfwmliORhfR6i5038HTOM5kmzD1TuTpgn9l5GUmz1dWp
	 o0yUB5Qj65/GQ==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-591eb980286so2278837e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 03:14:24 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz7lOI6wuq/b3TMaZ7/NVprgHgzpyOWDLKyJSb4nD5p7b98XCST
	IQr10yLQ2JmYe1eJqKG7i9TdhuKYsuHEkZBHhpKIThXHsbk1eVoqQafvK/cuivNrsEpS+si6kgW
	OT6ck6ua1dfCkcAoXDRjkOlRrHVnaJOE=
X-Google-Smtp-Source: AGHT+IG8iUUMQF0D5yVhMfUk3f49gl16EpRj2WucDueAbKHKmqKh7iUJiKFsggwb9AdxMipBw35mRZegqZ8u7W964wc=
X-Received: by 2002:a05:6512:3d92:b0:57b:5794:ccda with SMTP id
 2adb3069b0e04-591d84faa97mr5623451e87.20.1761128063284; Wed, 22 Oct 2025
 03:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022033405.64761-1-ebiggers@kernel.org>
In-Reply-To: <20251022033405.64761-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 22 Oct 2025 12:14:11 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEjihuC1Wa8fWUqsvsJM6YJZ0wmuhkqicNAfQiHvnWkYw@mail.gmail.com>
X-Gm-Features: AS18NWBSXzD203ZzkosAKi9Rr6vw53-JkbJxJJd1qk8yGMrx1SL9k2NwvTwhKzM
Message-ID: <CAMj1kXEjihuC1Wa8fWUqsvsJM6YJZ0wmuhkqicNAfQiHvnWkYw@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: poly1305: Restore dependency of arch code on !KMSAN
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Pei Xiao <xiaopei01@kylinos.cn>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Oct 2025 at 05:37, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Restore the dependency of the architecture-optimized Poly1305 code on
> !KMSAN.  It was dropped by commit b646b782e522 ("lib/crypto: poly1305:
> Consolidate into single module").
>
> Unlike the other hash algorithms in lib/crypto/ (e.g., SHA-512), the way
> the architecture-optimized Poly1305 code is integrated results in
> assembly code initializing memory, for several different architectures.
> Thus, it generates false positive KMSAN warnings.  These could be
> suppressed with kmsan_unpoison_memory(), but it would be needed in quite
> a few places.  For now let's just restore the dependency on !KMSAN.
>
> Note: this should have been caught by running poly1305_kunit with
> CONFIG_KMSAN=y, which I did.  However, due to an unrelated KMSAN bug
> (https://lore.kernel.org/r/20251022030213.GA35717@sol/), KMSAN currently
> isn't working reliably.  Thus, the warning wasn't noticed until later.
>
> Fixes: b646b782e522 ("lib/crypto: poly1305: Consolidate into single module")
> Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/68f6a48f.050a0220.91a22.0452.GAE@google.com/
> Reported-by: Pei Xiao <xiaopei01@kylinos.cn>
> Closes: https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
