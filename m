Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886101C862E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294401; cv=none; b=Pe3CUDLQgAXVoM119qGxEgQmN/DO7XdhChEn6GkJqT+Lq1Fnblrm1fFmZg8M848x6q9eGhwhes5zrsHJdyrm9FAXorXcLX5sovdrVvKWHvL/Jz4fl1FFGxoBe91Bgw67Mg39xuDVYlq3/ymEH+fd2dnMkm0DYOnWqhCEpvliBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294401; c=relaxed/simple;
	bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o8n4ibSZ8neJH75Fts1GprXBtgc5YBXQnYw9UX1CyEOcN33FsZKbiE58aalvLGTXiQ0TXHCI0Jypd4RE3pT3IgnU/OU1I1m9+HpgDrSX7J29oDrr5mJYoXBGGx7d7VQiM20cg0eCS00x49qovB/JDcwKhVBXW/T1XHy/tV0cUHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gn6vO+nL; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gn6vO+nL"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-70ba7aa131fso22553116d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294397; x=1758899197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
        b=gn6vO+nLjJcK09NnVY6/EwXtc16UAGnom97Yds9I/gU/ZLFI6sZ2tV9Xq3MnfoHptY
         91dXILumQnl5QQWy7hr8ePI5uSVWT8m1uWxjYJ7QWRFX+mewd+dftuP8Hkn9FnxwUKIK
         AkQxflKQ008azAr6BUEHd46tJdaZX5akIAadsZC3o31fynecKgKc+KtNpvAy3AWEeHu1
         Cz2bUrWobkBPYc6XFYTnpBeypSYurZrOQ8OrFG+lh3wQXTWa2bDaBUOruLXKryxFefxn
         KW4GOWXlL33wQAyAZiTpkmSaxuozS8ak6hn50PdQkpojRaPGfW10p+n0vzFOnSvPT4zZ
         f3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294397; x=1758899197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
        b=XNBF5YBO6j48kWKO/uC234aNp+u6wEJjsNU9WIJ2V6KimRQmGko8EjV7L+5zlnrFIp
         xqlUlsWZ5SI/vuWn9wOxheaCuZXcLd3EkwVXAIEIUXDLkYB+ZCDkGSylRZoOmsToEtZm
         AMkLzuKw0HWkWE7l1Dm6bnqZNPwPK5+uoZ1ucl3mP7CvGdsBHgpA8g5BKByvRWtAq1jP
         Mhu+1/IT8tAuvJGrSfweZcKy1kkPZfvHhaJ2qW7yraMJGYGsalvQkFDNxEBql1rC+w0M
         Ev1CJ20Xp+QcSgbAf7yo4Hh9ilqMt1p2a4DojMThfro/cSWl18AdjRgqjn0+z1q9qRXo
         Lfhw==
X-Forwarded-Encrypted: i=1; AJvYcCWLZ4wSBip6ucwvry54xVKuXn4HKtEW+bf80gt01dJ7qtcpqSor9sULl9iRcnIV/SV9DgUTNjOmzGuRhkI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyOhJGOZI7Cd7UyCSaJSzFPoZA5MJYBacRd3h1Q1lLljLd9RA6
	szWVQV7K1J2Mc+Ei3xEEyyhbmi1F/TnjdTxBwgrSDoBYMj5LvfdqJlSPpip9Dy1B3svkZuWgobZ
	igigt5hbUfInpsw56IT81WTyE8nHaxNxc1gJJ/H2S
X-Gm-Gg: ASbGncsJPpNRQHA6YyI07VSI8lChwFlDkkAu2Zml7gOUkOFOGT2p7XGfntsFmnE4D8Q
	kXtTVEfPyErDt88v0aV4QDZoY9P4OOJg+BCPOYHmluP64Bnq7TSLV8+4E1r1l89l8m+fs8u4M/N
	ADWWCQltQHGguC0vKFlSoAp0nGg6qUEKgXmorKqKHN1CyTiYa4UBZh/38nOxdJZ+z5HPkTcA2BM
	a1UoBL4E1Ok2Z3pYPZRjSGRdBw04LbycX3m/g==
X-Google-Smtp-Source: AGHT+IHAZGtVHgR/T5vgwj/kVG3d+Xvhn85HcOAqMoUr6UVAzkpi/OktlLCwoHTesoJWJTkkDQIa4OfoQDwjclHUNCg=
X-Received: by 2002:a05:6214:212c:b0:798:acd7:2bb with SMTP id
 6a1803df08f44-7991d54f750mr32395906d6.51.1758294396642; Fri, 19 Sep 2025
 08:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:59 +0200
X-Gm-Features: AS18NWA5Hk_dVmA1agOSIAGh1dzuifFPUnlHCTY8eojJWXc2mgupvfI9rEJhlqQ
Message-ID: <CAG_fn=VXNBH-1QDAy+xR_ubUr0rZxmPBpFWov1y+7a65-mtGmA@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce the kfuzztest-bridge tool, a userspace utility for sending
> structured inputs to KFuzzTest harnesses via debugfs.
>
> The bridge takes a textual description of the expected input format, a
> file containing random bytes, and the name of the target fuzz test. It
> parses the description, encodes the random data into the binary format
> expected by the kernel, and writes the result to the corresponding
> debugfs entry.
>
> This allows for both simple manual testing and integration with
> userspace fuzzing engines. For example, it can be used for smoke testing
> by providing data from /dev/urandom, or act as a bridge for blob-based
> fuzzers (e.g., AFL) to target KFuzzTest harnesses.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
