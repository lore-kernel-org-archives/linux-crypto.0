Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D2674E25
	for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2024 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713190690; cv=none; b=gXGmEzWDgOARzJJljSgY3N5ghCgM2gogU4jZjF3TDsVOKAT514B3V1jd2erN9HuEQqr4dGBFcWu5EvpqZvPKo1PG38ppA2JMtky5BnSculpJu1ecMOV3jGY4VOSGCzSaomdZu8d0iSQz1jmexPfs059i5VsKoDatfgC0FPab8ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713190690; c=relaxed/simple;
	bh=s7Xj9xi+J3VOaPxS9cliZyr2iTz57B5HKKp5IrSvKlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mk4XgFkBBd7YthUjvKnmuWipSmLYC91r2w10aJeTvMJm6X+pbOod0+uYYSajt1oXckluRoa/vlOxsfJq9IlO5mZ2XDlvNHSKILb0pkDzUbVLLrkT7yrRaiwRtAvNXVYHYTH8Pwv76JTruRkAiTRkAwnhOO4Jov9K+fC/LMT9P78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GxYCA+wE; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GxYCA+wE"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-617f8a59a24so29360007b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2024 07:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1713190688; x=1713795488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqqqjCa8OZ82zdxbWAvkpK8zvR3ppQ2NndSIF2x4rXo=;
        b=GxYCA+wEVdEIjjWzJWYg+WtDHHIliDSd8tKsr7BV7/MNn1GAfzIGGsjaYd1K1nC47x
         vSDYX4sAGl3dWOguqWAOzQsiR3l2a5GCXoMgNM60CbTbnQU4DYOtkdtqEGzpNJ1M0YZG
         uQw5KNJcmYoJdcaPUXYHVNp3fe+w7CGUJ/SPJ96v3rXFwkPh6f3QXK91XZOF32M12JQC
         Ji8q8ysobl0MyXu0MqYf8ztHm+RuXlZSrC84cqaRtpeht1x8CxcwMPIAYXaT4Z+hGC7+
         rVG2YJ4JyNKKpzlG7HNhuL8+NZugo/5Ayugwl9nKzsB0LSuLDrRKrkXS0JcMorbjGX6N
         OF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713190688; x=1713795488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqqqjCa8OZ82zdxbWAvkpK8zvR3ppQ2NndSIF2x4rXo=;
        b=YCbetlP1/5qcgeIfGfGBrkzsL7pUN+c2KQE5oBrBecb+Old2jBTR/J8Hhep6W4ZZt7
         GXdLRdkQoWNVJAUvshtrV0hPKicoFATYLvoy+ejtXAsysBReOuVT1UL/8P3WQGVZrMCo
         2qrP/gLGY4Cs6P9jlA1+A60jxH1zn19O9Zfgz/0nBvj4brNTkay54TR6pW7WASpC9k5I
         n5X81d9W6OC8wLDefOzYdZafdrcErGXR9jOR5O3xIfRQ8jju1aDpICeF/zbCjTQyKtDz
         GDYUEXrh5CAdykOxqx+hfOP5XSQyAIs5qMByOb+Cf1sYZI59zre0MJJK0lTf4OXa61jI
         43dA==
X-Forwarded-Encrypted: i=1; AJvYcCVg8oE+lCu13Uxf8MxU0lDDR57UERxGaENZiFyBlxLP9bV5tWSbuJRUMsjUK0moKpeTU11QCmE4s2Lj7z+1TDtR63uW+jpzOV67+hoL
X-Gm-Message-State: AOJu0YwGUdR6B5fU/Kp0O0avLjapEejMZ0bvD9dl6rBfZJ2iLPsnYssG
	BvMVTG6DJwbUNW5qM7JE+jJ9rbqUyjwZzUN4+z4lc6nKsaNi3IIlo6h282VywMbqvNSZgB0y8ec
	OR31N5I2uMpNhDQIwiSDHt1GxeUqcERo8Bo4Y
X-Google-Smtp-Source: AGHT+IFLkqpounEUU/2bE6dJh6q9whX/HjDtCGadHGTvaVHifyPAFZys4Iq+yJ+GbVJMCc2FKsEdAoulZVngTb0CJTg=
X-Received: by 2002:a0d:eb02:0:b0:615:3996:5c86 with SMTP id
 u2-20020a0deb02000000b0061539965c86mr9873358ywe.21.1713190688256; Mon, 15 Apr
 2024 07:18:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
 <CGME20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483@eucas1p2.samsung.com>
 <20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com> <20240415134406.5l6ygkl55yvioxgs@joelS2.panther.com>
In-Reply-To: <20240415134406.5l6ygkl55yvioxgs@joelS2.panther.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Apr 2024 10:17:57 -0400
Message-ID: <CAHC9VhTE+85xLytWD8LYrmdV8xcXdi-Tygy5fVvokaLCfk9bUQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] security: Remove the now superfluous sentinel element
 from ctl_table array
To: Joel Granados <j.granados@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 9:44=E2=80=AFAM Joel Granados <j.granados@samsung.c=
om> wrote:
>
> Hey
>
> This is the only patch that I have not seen added to the next tree.
> I'll put this in the sysctl-next
> https://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl.git/log/?h=
=3Dsysctl-next
> for testing. Please let me know if It is lined up to be upstream through
> another path.

I was hoping to see some ACKs from the associated LSM maintainers, but
it's minor enough I'll go ahead and pull it into the lsm/dev tree this
week.  I'll send a note later when I do the merge.

--=20
paul-moore.com
