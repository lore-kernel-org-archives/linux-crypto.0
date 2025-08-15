Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31183019CF
	for <linux-crypto@vger.kernel.org>; Fri, 15 Aug 2025 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755262852; cv=none; b=mBNytiWmXKZc/cUuaKQAjw5mHYhiqEA1oe9xJgJ+IjS/1EAf8a6MqZrvUhTC0pHI4ztoJ5ihzx6ZnqtVYZZGKzTVyijOwk29L1Dn4mEEVE3byH67yNlBMiPtSBzWvQFajJeGUUu/VPEcjcU4tnRe5y/jFKK2Jpo1zz0GekUpyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755262852; c=relaxed/simple;
	bh=x9Yq5jrTzPbpV71DQp/TR2V6uI5f2sCjN5+3E/ZJ8KI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HEVF+jcn/A6U+XfZVNDvJWfUUJUWwzh4gmjLFDnVt9q+3f0FW7VEZaTjyY3HC9P/egLRwsd7jvT8rrleg0Bv/FLRu0Cnwan4uOXgYVWBMEHqEzj6Ut+UDG/8FptkZAjxmIi3FNt/sHAM9za+p3w8aVWaxqvWjFV70gBVj5z6n6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=ZKhBZYzU; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="ZKhBZYzU"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55ce52ab898so2264329e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 Aug 2025 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1755262849; x=1755867649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5aKJ6EuhxrNInhVNv1lAb8m/GnY8B+pF9rLGMgta08=;
        b=ZKhBZYzU8cv61f1f36n0BFanIeal+DPFqIbffjOOjmW+d4z8Pr51LY4zAzCuL76Zsp
         T+PpN1vt0JFd4gJwjJqemhSYr4d708J3GOKFcbQk2D1Nc+ESUrjIQE5q2GNlrycU4+je
         dfrDHGDtZeUc893U263PYLn0TvsKfuzZlRJhmNEHvdZ8Fp/HXFF0xxltQEa9hT8HvRUo
         NAJI51XmYno2ITvVuTnInyFkR3T8tOHzecCiXtMvPJe4TrIJBxqa63qtPItfjL4OfAuS
         85NmKrQk6DROcX5n0qeWlQ3Akf0vUO2AGZNQYEJR0SidLBT9s8vQYyjhBvdfSKmUtQ7T
         aw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755262849; x=1755867649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5aKJ6EuhxrNInhVNv1lAb8m/GnY8B+pF9rLGMgta08=;
        b=AMQOBhI/OPzUJjVQgGzpaUOZ029v78G6wv/5xhdMvn+a8Bp2XkoXE7rzvwnVpG46XJ
         sas8BsxkEGVnR1ZmayTd2earHd9t9LNAKim8fnfWeFN7BkdWTwqDyz/c6QpgLvfnjnWJ
         Bp1ILaPb2/YoTbslqKeP8A6z9sVt2QfNhEOXrZCOAiWGW+r+h7qoATDcZ0CLThSmvGti
         kJyZHkmqqsbRmIKgq/WKgffWeMMdAt4uSyJ9qrS/PJb1vzG1DNf0b0qctIBBW02zODhb
         O3aPr2yUWnOPwRBRlk9gvvAL4bQ6Uzm99IQSp3OEYvX3BXCM0fDTRtOxLTwQvPFoVtt1
         w0sg==
X-Forwarded-Encrypted: i=1; AJvYcCWLX1O0xZi+koLSAoY/vKgtXDqDDD3eZNMQnOvoe4B5YtI9dcYPmq2h9QlTAwlqMlVKBcx0MzfZfsB6AiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYEH7WN+885cSZQpSbp689WGtJahca3yilNk7hQk7vqHfYwdIX
	uNNLsL623jtXYwwM+03Z3GTRj9ZZetcOQGhSIK8KIMlO9cCKT8xKn/0Q2V51LzK/OigzugAWwYf
	dGlXJ5v2YCPLqyi6MnEcpvYXW8cyagN/5jrtvklk3vA==
X-Gm-Gg: ASbGncugelB+6GdxS+t3cM15IDno8WnAAsZrhw+z1UANNMnKEi3VlTQZ1YjVQ47Fpt8
	0W4zHlXGANcbFay5HmXb6lvxd/ok9Wi6L6XJgyVgl2SbSX6VTBr8fxU7IdPCeDCTucbwvNRMZdh
	/yBCcpt9ehvZvfhyBC+sFD0JW1V5lGIdFVgxAbFw8uGTft+5mxtP5XctE/Q1Bfaj5+CpAmKqKEP
	gAceZB6pZsu4EMmRMOHF4cZQQ==
X-Google-Smtp-Source: AGHT+IFNKOB1rrD+w7VKvQTDOwyeOYLz2abWlq0iGeI3es8w5nvcHLIOmT4MUBEah/yIuNYyhBR1ZRVJ1G+8nKdddYc=
X-Received: by 2002:a05:6512:3c81:b0:55b:8e2e:8cc9 with SMTP id
 2adb3069b0e04-55ceeb2d2c4mr585014e87.33.1755262848871; Fri, 15 Aug 2025
 06:00:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com> <20250815011744.GB1302@sol>
In-Reply-To: <20250815011744.GB1302@sol>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 15 Aug 2025 14:00:37 +0100
X-Gm-Features: Ac12FXxJSZN0OfDcjS8s6OFmiOlXF2SG0blAOcgASCk44-lWBGEmHN2xDuaUJKY
Message-ID: <CALrw=nHcpDNwOV6ROGsXq8TtaPNGC4kGf_5YDTfVs2U1+wjRhg@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 2:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> > Not sure if it has been mentioned elsewhere, but one thing I already
> > don't like about it is that these definitions "pollute" the actual
> > source files. Might not be such a big deal here, but kernel source
> > files for core subsystems tend to become quite large and complex
> > already, so not a great idea to make them even larger and harder to
> > follow with fuzz definitions.
> >
> > As far as I'm aware, for the same reason KUnit [1] is not that popular
> > (or at least less popular than other approaches, like selftests [2]).
> > Is it possible to make it that these definitions live in separate
> > files or even closer to selftests?
>
> That's not the impression I get.  KUnit suites are normally defined in
> separate files, and KUnit seems to be increasing in popularity.

Great! Either I was wrong from the start or it changed and I haven't
looked there recently.

> KFuzzTest can use separate files too, it looks like?
>
> Would it make any sense for fuzz tests to be a special type of KUnit
> test, instead of a separate framework?

I think so, if possible. There is always some hurdles adopting new
framework, but if it would be a new feature of an existing one (either
KUnit or selftests - whatever fits better semantically), the existing
users of that framework are more likely to pick it up.

> - Eric
