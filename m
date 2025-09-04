Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC027A123;
	Thu,  4 Sep 2025 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757017270; cv=none; b=ihCeBKsjDRTwQ9QYY+7SOZEpf8AnOeUmASbTQsJFZB5e4D2ZdmgicMXPolYwY27DoxjFSDN+Ufv1VwlvwESSlDN3jhQawZH0IJV2HvFFcfP4g6zjm56ZVY9hPuIAVMhXa4z2rYtxJDf6KpJDYZnACxuZXIeTTDHjnzFmxxbtP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757017270; c=relaxed/simple;
	bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nhmEGHTIy1ODw3bwWFsetLXhmxHS/ZjFvNi/MxtCCr5u+cm3pQnTPCo7AJXAOfz51eZcEiuGJ/S5sUj7iZp8HYr3MS/nyEBc3D5hYuXRalpZ/pnjPUpRkrtsZ7+tA+UpFzfjgtG/ZGa+1XfIk+nqxYxDdnFMnXjXQwytJeG/xn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3hoLTL5; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3hoLTL5"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-244580523a0so15873715ad.1;
        Thu, 04 Sep 2025 13:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757017268; x=1757622068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
        b=g3hoLTL5uZOcJoIhsYn24yK6DXqOn8KmSzdUqmdNkep4ymDHncDMFQWefi9rPyn09i
         Bhn3pW7W7C7MsqVA6Y/Q8YKcniG4NCQiCQ4F872rHXPAYbQuhLDfaw9WZhrQL77a82wL
         2ACU0xhCY62TiP9PGPPAbbQBbb/VdM0GxsQLvaUTpPp8EDZSPCjLKWyJhm8RuRP7Ti5H
         MOm8nr3FYtLeyGgNGg2HdeeUn2x1bKkkYUVNHi5by6MKB5UFYOmijbAxNgVM/+i7OBzn
         PmCndNtksdFRrOy35Mip+j+zYZsedQ2iBPYUf4pDxvVNMfEyvDApANkpxJNQgdKyjN82
         ptvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017268; x=1757622068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
        b=vL14za3BQQQ8pooI5ffghBSrKX2NL6gzZXqyC1p87g9RyeBOR0EiZcRldlpvrTK2bM
         IVdiBmyRW4riARSzDLqUONsKDb56eP6xsUFuaTTLZhr9R/Kd4PJKBM+hVbIYKSeO5JHx
         EllWyVAr59DozxyFqEBLO1xwRyyvSWeUUOUGfFT+zAyyLP28bCV2c8YWX3QfCjiQiT07
         zSYkWT3qo4hpOHp9fXcQb6NA/2qOVddKZwBDlayv78WcPLLBLhritriBs7vWd2gDykoY
         vlxydwKNvQudXM7nX/Y0AKpfG9hk0q74EhHEWxez1y60WOzOGq3gyiWOhDvGuCZ13tv+
         4XHw==
X-Forwarded-Encrypted: i=1; AJvYcCW83128OGmXPXV1xtW5ZPmaRQgUyCKTN4pnXcsIMkPljl0SpyPgNUybu8A4GWyJ8nPBV4C1pa9B6Vn1ufI=@vger.kernel.org, AJvYcCXmZNiycOkQm4g0bNm8O+kaOtcuLwZit8NpqoKy5vyq11bH/qIRkfuOmlR2VHo+M/soQ2N9w25y9kHF0Hkk@vger.kernel.org
X-Gm-Message-State: AOJu0YyvrWPLdAYTzkUT57uyF4qNdIEFe3sa6mE7QmGvQSxjF+SUeESA
	S/dU+N6XmoBBfS4sr70epua25aa3riPf8Vp/8KqV1kFGLf2BCA/wKIrRK3UPZKvG62gh/Lsj2UZ
	/RRa5OiuR/sHKuzSAVdzyJmnQAugFhiU=
X-Gm-Gg: ASbGncuxTzNLFOHiHnOndnkbK/RYvs3tOMl62NCztxa7bsDfduR8q6VtgOA5D0wQLh3
	G7U6ZlGOzfdgDJ96fM4QO5cjthuvvdeSAyUnCgXKGsEmrD5IfGLshGxllHmM44spLmpGtfCWl7+
	+BNDk6/FcC4KHqBcMdsqAAkQUzzRA31YLSfYejUJptd/QtFRBae3h6Ra9Usx8mSfcpXEaycdC3j
	JyXzOfJ7M/RrjSea0hTEF7w6rAdbxUg5BI9+w==
X-Google-Smtp-Source: AGHT+IEI0YtwNUP5Ckeu7lnXmy0Rk28H9EZkLvS0yGrAkAdCynjENqi0zkQG7ZR9KNGK7GfDI0Z/fifzp2eGgX7XZqI=
X-Received: by 2002:a17:903:37cb:b0:242:9bc6:6bc0 with SMTP id
 d9443c01a7336-24944b73618mr268496855ad.55.1757017268482; Thu, 04 Sep 2025
 13:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
 <20250901164212.460229-8-ethan.w.s.graham@gmail.com> <CALrw=nGkk01xXG7S68FggsWQXygTXnXGz8AvseQuRE9K-OE0uA@mail.gmail.com>
In-Reply-To: <CALrw=nGkk01xXG7S68FggsWQXygTXnXGz8AvseQuRE9K-OE0uA@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Sep 2025 22:20:56 +0200
X-Gm-Features: Ac12FXyXqZdTxVG6TdzkdqBvv0Mcwr4nVECn24stQHwKcyWRqz_jVg7upfdtHW8
Message-ID: <CANgxf6xCfk9uDsGgqWqociv0Q2Ngu0_GBR0vzWHwOAowsO+CVw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 7/7] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, davidgow@google.com, dvyukov@google.com, 
	jannh@google.com, elver@google.com, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com, kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 10:58=E2=80=AFAM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
> nit: can I ask for another real example? AFAIK this subsystem is
> rarely used (at least directly by users). However, one user-controlled
> widely used parser terrifies me: load_script() function from
> binfmt_script.c, which parses the shebang line for scripts. I would
> really like to see what this framework can do to fuzz that.

Thanks for the suggestion! It looks like a promising target.

> I'm a bit worried about the scalability of defining one (visible)
> config option per fuzz file/module. Is there a use-case, where a user
> would want to enable some targets, but not the others? Can it be
> unconditionally enabled and compiled only if CONFIG_KFUZZTEST=3Dy?

That's a good point. I agree it's best to enable them all by default if
CONFIG_KFUZZTEST=3Dy. A fuzzer can pick and choose which targets
it wants to fuzz so there's no downside there. My original thought was
to maintain consistency with how KUnit tests are built, but since
KFuzzTest targets aren't executed directly it makes sense to diverge
here.
