Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29882F5A32
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763570822; cv=none; b=bhs7QalGXN6QyGyNrS5NQqiHdCqe1JtQAuytI+w3eQK/UqIIfNDcSFhhqEEek4sewYfAca1b2zREBAYfhPt8yEbOswTVAHTBQ1xAlOvJWePZgcnSGnUSA7CLUEXrwAPVPvNqeAEQpLiZ6Q5GnylpNgzI+UUDs69WlPZu11m/01o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763570822; c=relaxed/simple;
	bh=0xLkFu3uiKHeufhwFRrEKuhWGUjK/Zc7ICOSmHpmYFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Igl+JqLP8VUzBKGfC/E0+cMUguBEj3u5ITYUmkasJsud+DnFq6iRwsdhUE087dESIvSneqWIAmY7SMep98ABUYkp+0huqcs6iMnEM+e2WppudvYoO3khQwf5q0jSyjjs3iPWVTtY7E2SFUK7NL+BOqbQq4R2nU5FKO5jBXBqmbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=AEU38NiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AEU38NiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0601DC4CEF5
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 16:47:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AEU38NiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763570817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3MZQMEyTMoJJe5B6+/49BuW6c9r2k3u2lv8xbzmwcJI=;
	b=AEU38NiHP7to5gfFGyw7G3EHoZxPUnwds6ET5h6ZWF/lVs5wVCX5FN2bY2moGtdnVY86Ji
	DKGibSDnJLoGDvT10ceevu0zl8sAPTErhvGilkmyWDdJlZhamGMa5y09NvwmokAbCbeKqE
	+ZKdBzHFmLNKGzx+fACfgPEcOc525Pw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b0098eb1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-crypto@vger.kernel.org>;
	Wed, 19 Nov 2025 16:46:57 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c77ed036c3so526167a34.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 08:46:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVgMBkocjj4RCpTGDj6pplWYIZJgjHNxI8/8dws3yfUJbxs6iMreGHTvD7b7G9OjATmvQQ0GQ4l61rLHQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI/QV1l7FiJoeg9owvsNiAHDI9P16HSVAmOOdJL8N6dOfk2cbs
	CMnTSWDiP7AWcleqmu2A8nUZ10WLUVCLCdWVrFBMx52szWOx6rNCcASufLbUW/+vv9GaEz7rwpQ
	9hNgCXHakrXT6nSi/ntfQnyon8eYKpC8=
X-Google-Smtp-Source: AGHT+IGojZcTh0K4+4JFRFqF58UTXS5CNSGxA5ZrvnRwlgAfjWt1k4AmVJZdufTl0VMncRxTw03BC0aT5sARgwwsdoA=
X-Received: by 2002:a05:6808:4448:b0:450:cf2d:c11c with SMTP id
 5614622812f47-450f0fc8bb0mr1433626b6e.12.1763570816214; Wed, 19 Nov 2025
 08:46:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118170240.689299-2-Jason@zx2c4.com> <202511192000.TLYrcg0Z-lkp@intel.com>
 <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com>
In-Reply-To: <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 19 Nov 2025 17:46:44 +0100
X-Gmail-Original-Message-ID: <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkX0Uk7FoCtwK4HB0XGwfz2L8ZkD_zXRpQAc3ZV0_HqFHiIeZlwsy8i_Xc
Message-ID: <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Linus,

On Wed, Nov 19, 2025 at 5:29=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  On Wed, 19 Nov 2025 at 04:46, kernel test robot <lkp@intel.com> wrote:
> >
> > >> drivers/net/wireguard/cookie.c:193:2: warning: array argument is too=
 small; contains 31 elements, callee requires at least 32 [-Warray-bounds]
>
> Hmm. Is this a compiler bug?

It's not. It's a 0day test bot bug! My original patch had in it some
commentary about what a bug would look like when it's caught by the
compiler. In order to provoke that compiler output, I mentioned in the
commit message that this diff will produce such and such result:

diff --git a/drivers/net/wireguard/cookie.h b/drivers/net/wireguard/cookie.=
h
index c4bd61ca03f2..2839c46029f8 100644
--- a/drivers/net/wireguard/cookie.h
+++ b/drivers/net/wireguard/cookie.h
@@ -13,7 +13,7 @@ struct wg_peer;

 struct cookie_checker {
        u8 secret[NOISE_HASH_LEN];
-       u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];
+       u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN - 1];
        u8 message_mac1_key[NOISE_SYMMETRIC_KEY_LEN];
        u64 secret_birthdate;
        struct rw_semaphore secret_lock;

It looks like the 0day test bot just went through the email and
applied all the `diff --git ...` hunks, without taking into account
the context area above where the actual patches start.

So, if anything, this test bot output is showing that the compiler
feature works as intended.

Jason
