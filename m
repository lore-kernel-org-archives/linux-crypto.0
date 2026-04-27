Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA43EF0A8
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777316958; cv=pass; b=YUnp75tThY9lPDN0waT7Bqwx2SaP+XpgYbOY3CO202sOi2NWjega7fDlPasL8oUsQmmhdoTmZD9YE7PSOmG5l9MHde05JA0nPvn9A77Pr4meFVnC5czADinK0Uj3T1fS+TySFpt0q4zeUDJN26ztNNxCMCPuqjgIo8dDllRYg5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777316958; c=relaxed/simple;
	bh=p/vF9FXJAY2FJjUaiQjVVoGdbPVUxh18dW+tUAsV5TI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hpo37l/EXJXTbkxChDkSihhbQG3NPjAgczftG7rei40QRpRTuNbPzbIZIgE401Rd8IBDxqDybYfYlFNcEKipsuivguls96okFaUm2JIwF3ewDX8+731zu0OdpQwaEB/tetxfLeSoLyXOUo/+Ogvib16KOGd5mj65yaPMh1kO0Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLZiLVWJ; arc=pass smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLZiLVWJ"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2d8ffdc31d0so1626949eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 12:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777316956; cv=none;
        d=google.com; s=arc-20240605;
        b=h1usBXcF+s8wa5k7hWN40jReYL6f8ssIW8sULx85qN7Y8UsAG7thumYq5RHUAdzFdA
         bdMJDGrGHKKBfgjKko/DcSGTxT4T9H4T7IOTEYyI2GkMEopBRVX223jZdd8lSL5uTwgC
         6ubwX49gaDEO1NBOl6cdGyoJdVs1lS+8w6lYbu26FNozax8BeqXMjO5NqfN4ay/C51b8
         h5HnoIidoqUST9+YTYrW1CkKvUDeTlbhilzpIaX7JYN5YkwDQUv+NPWiQs+aVo8PTAdq
         SjEN9K1iDl4xM+FRsdxJNE2Py/swKF4ahhGwbldw279mByZfu7g2B+1fWAUqyBnOToHR
         j3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gh4OLudKU7A0KCBedauzIRRUsQHgWNMMPIUWXm1xatw=;
        fh=gNRAfGZzjWijDZIC6rgTB+8LEm8os4+6aNkDDDUuvNg=;
        b=EjE5S3usrLyed1e8LzKEht0BttTtCsG6ent2RUg9HmCWJcplOZFyW2j1SqVvbETemw
         vtI8A9Jwq4cXexYqL2PTw3utICgskCQg4znxPgyjddUU3fMVi8Zx8pQvooxG40SsFG8R
         rPgPTzN57Oe0EgBNCdGcEL5uSsZleiPFaqX+zj/J/x88dTQB1UOYa99xGDe+6goeuAQA
         g7/JcxHOOnMWrDiWQmRR02IgyCIaQPqaVBps8SU4dTcts/lmEDXtaTtZjMvHxxcLm1d5
         /kaZrYAINE2lpcPhA9QwqXRGpn1Aks2ufwXbMNtE0CTRa17UEzZZoq2+j8rTeIj3L/Wz
         VVNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777316956; x=1777921756; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gh4OLudKU7A0KCBedauzIRRUsQHgWNMMPIUWXm1xatw=;
        b=VLZiLVWJ9Uvn+JTdQghPX5qdyhD+36nGwrmTSgCAqHg24MOC6ku2+dngC2hU116Xrm
         xeO0MHwg0ZIYhqSw/Hslcze1d3GgjTqnbff3D4omHQoZaxcRICJgPunj/5vtPFCgxmqo
         fjfW31mtLwxxlfCocqf8SulgB0KcigHEbZ1W4jr3kTTnAlHWzeGimGVxQA5IZBTwiAIe
         pAUwYyw8ar7dlPC/QlloD8K7VMQ+AxgGPbYH/jv82RZzQMfSTQAu2JWQDr2x8SLCfbKf
         BeJQWpw8QOSo6naUTPa3hHtnj072lfDV/fu5WYbPaaQW3wx9vsWFOCApZrFASrjL0C0W
         WwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777316956; x=1777921756;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh4OLudKU7A0KCBedauzIRRUsQHgWNMMPIUWXm1xatw=;
        b=a1qRU4yJtpjpM9/V/IY5SycR9Pqg3CvT9zVa4XT9ijWW20KdseTkSf1KhKbfL4pBd2
         DpkZnnxNUVVMAWQA69XYG/iTMPKRJXdJy6kOut0/otE6hcwEjGofKbo80tOpKuk7aeCC
         eyAsKK9us375njXGgaDzhQb3J0QOTuHlWoju8B/DdFw0Al/ra0ZPE2ceiGgnt7JmzeQv
         HW1NwsUMzCm4C9fbH5aRG65S497Qn/i7AzLm0ZaDW/izmygFFU3BGS4qns9IfX9Ov8Dv
         U9e4iShsY6U9BPA04CK5WQxY5gzIgUrrRiCAmKmdSSY9la2xGHMAsFMPGnqYMhBa0wcT
         FDDA==
X-Forwarded-Encrypted: i=1; AFNElJ8bpOLIOjtCSTg/yiZu1KOyBHeSg3IrXLBdRyD0qv4yl4p0w12djeOAWg3VyfTDgyEIRZesF6TUoARcU80=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvZKP5bRg8ZOCGNHICjcNJK3lX134lGhsd+7Xmonmq4x2mItI4
	SJLeauBtAQHcHhVSciX7JL5giwgg8tqLPy+p93w7Cmu95fUhNHoqu7nCe5GtFoL4OAkTVhlRRFw
	oq22ItSvF/OUWTmPvyShjsvop4ej7WkQ=
X-Gm-Gg: AeBDievUuS9Ueij/Lk6Q9VIrVnSzx6dtGJwjog2SMJR04NN6OOv6idimmx5FxReIu5q
	xEgZoPtuY6e5VwBnZ9lME1g9YnsruelTKpaoK0po0QxyGFdO6f7I6DhRBgoA0d6bMA08jPezAYg
	+WGl8fLl24VbOvRckDd4y5w/rTat3+h/1JicNg0SR8wO0mz9Wd4xzwXk4yALieRiCBqgPu7dqlQ
	uIX9mbC7SxuhHs9wivVak/uKbUoB85BhbwrBCoMPBJzMM902Bdg7s9HdTJdq/6ch5CK82uD9tim
	bDsGQYRTUW1yIooo6nA4YKZTYsLyzgqS9qdr2QR+GNSFWAMkykUs6l7CGvuIsdDpK9WDPcMOUH8
	l7W/EIGSeJe6eI/ngLLY8e2vi5YwCk8U=
X-Received: by 2002:a05:7300:6144:b0:2de:cc07:e99 with SMTP id
 5a478bee46e88-2ed0a013aacmr84460eec.7.1777316956086; Mon, 27 Apr 2026
 12:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427172727.9310-1-ebiggers@kernel.org>
In-Reply-To: <20260427172727.9310-1-ebiggers@kernel.org>
From: Dmitry Safonov <0x7f454c46@gmail.com>
Date: Mon, 27 Apr 2026 20:09:05 +0100
X-Gm-Features: AVHnY4JJWvpg7bTU7jYNNN2GruZova4uBYsRbdJTLdmZD4F02zLyOKtxs4yCOJQ
Message-ID: <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Mon, 27 Apr 2026 at 18:27, Eric Biggers <ebiggers@kernel.org> wrote:
[..]
> To make this simplification and optimization possible, this series also
> updates the TCP-AO code to support a specific set of algorithms, rather
> than arbitrary algorithms that don't make sense and are very likely not
> being used, e.g. CRC-32 and HMAC-MD5.
>
> Specifically, this series retains the support for AES-128-CMAC,
> HMAC-SHA1, and HMAC-SHA256.  AES-128-CMAC and HMAC-SHA1 are the only
> algorithms that are actually standardized for use in TCP-AO, while
> HMAC-SHA256 makes sense to continue supporting as a Linux extension.  Of
> course, other algorithms can still be (re-)added later if ever needed.
> It's worth noting that TCP-AO MACs are limited to 20 bytes by the TCP
> options space, which limits the benefit of further algorithm upgrades.
>
> This series passes the tcp_ao selftests
> (sudo make -C tools/testing/selftests/net/tcp_ao/ run_tests).
>
> To get a sense for how much more efficient this makes the TCP-AO code,
> here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:
>
>         Algorithm       Avg cycles (before)     Avg cycles (after)
>         ---------       -------------------     ------------------
>         HMAC-SHA1       3319                    1256
>         HMAC-SHA256     3311                    1344
>         AES-128-CMAC    2720                    1107


I do like these numbers quite much! Yet, as I mentioned in version 1,
removing a fallback for other algorithms' support does not sound good
to me. There are two reasons:
- Ronald P. Bonica (the original RFC5925 author), together with Tony
Li do have an active RFC draft to support the additional algorithms
[1], potentially in addition to TCP Extended Options [2]
- There is at least one open-source BGP implementation (BIRD) that
allows using the algorithms that you are removing [3]. Without a
deprecation period and communication with at least known open source
users, it implies intentionally breaking them, which I can't agree
with.

I don't feel like Naking as we don't have any customers using anything
other than the 3 algorithms above (and BGP implementation is
[unfortunately] closed-source, so that would not feel appropriate even
if we had such customers), yet I do feel like it's worth and
appropriate to express my thoughts/concerns.

[1] https://www.ietf.org/archive/id/draft-bonica-tcpm-tcp-ao-algs-00.html
[2] https://www.ietf.org/archive/id/draft-bonica-tcpm-extended-options-00.html
[3] https://github.com/CZ-NIC/bird/blob/master/sysdep/linux/sysio.h#L246

Thanks,
             Dmitry
