Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B8637D13E
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 22:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773095625; cv=pass; b=QD5LH5/OrlJxUHZHNoVFg8+tDFOvwCCN70OwHbfDnDK1ku5H7DunzpDSymhDv7SPQ7yBgEGikOU6Alu+d3J3h5SGcPqIqRh0ieuA2zxHaxmRvtFbMKRVTK3RYFtlAjOtRR8h4qd2cS1vD0M6WSjoFu2FlTmL7M4Ceg2GAtUeAtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773095625; c=relaxed/simple;
	bh=HeCuT0qaD2Mz3WqutFMT+DaMPNeNHFoumbw+GPdvZOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myET5Jg4vKJI3BEn6e7h5bmiQ2KIIO4Yfl1G0ZIYMD4Xew+CxaUEd7bIEyxIztEJDq9n/cnLG/dMcWDTaO9rSSm+AUkdbe/z2ml/auwpROLBbKgjSLt1ePDOzklZL8/QeQrSAJNyiYMNviY3k7GqjrXHqP+NSiNPCdDJ8qrKGRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGJwRnfl; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGJwRnfl"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1279eced0b9so11757603c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 15:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773095624; cv=none;
        d=google.com; s=arc-20240605;
        b=g4zp6aFqsCZsWJpJRCYj6lDmcb0rwuriRgFoMlA4LjCun9iw1w7kIOaSpzXnPZ6oTC
         g2SEAhkJVmcpyVWs55ooTh9ivorheXVOzpnwcKDKb1iUfbh950fhS6i+cxkVvQvLFZmw
         OclYELsUYwxxEV6yHa1yQHPe5TUaz5pvQbVm5cB2a4eIiIw3Xk3Ry4wn5pTk1TZTI9R/
         VALJ/DKXynQbKyOle4owykfIVL0M/ft9YGq+IDKh3yNOIc4whINKGfBZ+AgeaJHKLuVb
         swWIkJlUfa9Y0Lb4+CGgTRmrGk4pKBGgpsSVJU96kiDIo/4XF32SeEAyWwhTznGWnAXi
         aM2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z13FcCDa40AsQczoQ3KuiTGusPMfhLwXRIZQf4kS9Mc=;
        fh=vpJdWBp8cVNLlrYDWxlVtkxeRTNRJErQ5AiorR2EHaA=;
        b=DZEFooViNwqsn2wvi0UxBAiZUviTiVGuaMZuzC6y35khEf9JePtD7KUXBVLhTY70hC
         lgfHEwBe9LKh9hjzC5OY/5nEPzeYxQ0b/rwLVwAv4OuIgDSx+VGhKysMbGtK+RWJ4m+r
         SVt/qxihgAgxiwNSQ42jTVoDLeMLsI7onp++OclG+YnkU2+7zHR6y3ogX/z5wLWtnW+y
         txeNLtoooLcx1XSOst07cV8bVnNjuw+lBZ23pz5zYJPJoelLm4f+JyyTluaTFNngTLfM
         MN0KL3wAz1O85ifS6toNuj81T1hdOMs/kZTzMA1JxvRLTltWBLrv3SPkVXCJT0fIHfO6
         aPXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773095623; x=1773700423; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z13FcCDa40AsQczoQ3KuiTGusPMfhLwXRIZQf4kS9Mc=;
        b=OGJwRnfltv7w3ugBl0Ur5n1uflh2kM1Fvd4abzcwTZVCCPJ6o+rc1avYcvrpz5B3aC
         4WT7lKbLuxyGrS7Dg7rhFpxrCoUrtLj/xnPmqrzmYC3VBNRrLyTtiHJlSi9Ts9UCKjDa
         hPsyfnARMf1d1N8LyoMnds5Qinnyft2OL0QNC7PuFz/aMMy5qLaujhSq7ElDu2Ra6dxP
         pJJO2Yuqhdu5Cb8lBmkyDndk35xdBXPzXrxwDGiRHoz0uSgQValflhWM3816ZT4oSw5Y
         w+XIKAWHU1n+Qo9VN90z8W0v61pnyJzDUjhLiQxSCMsIoURjCqO/mC9JA+mdZGc1Vq0H
         Kxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773095623; x=1773700423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z13FcCDa40AsQczoQ3KuiTGusPMfhLwXRIZQf4kS9Mc=;
        b=s3SAOlOaamqkhCJ46/eV9j7aIOVSuLkwYRiRiWCX4gCRIjRMEAQ+iHcGU3ochoQvdP
         iPGsNTWj0kAyBNaMTSkIdiGlF7GvpcYbAqEKq2FmiKNf8N5tWmk+m7X28LEzT4uW163K
         mveARiweOu4e6uLVYZPmrvqLgBzwGsfkZ5aWa7o5BIJ/TSLnUwFaWRIbMmX2uCPVsJJw
         h3oHmGUSwGnGqJ8gEZFLM5aRufciO5FfebfaFvCoeayLGj4z5N4yUqq5np7PQYyZradA
         48nEdm0CKW1dfJos3fqPx8tHb1xRn13lcTgFcWGPUrs254KCV7ZyXasXPNBb36iGv1GC
         wtVA==
X-Forwarded-Encrypted: i=1; AJvYcCXDAC1Z9G0lXGwy4yc1qupDSaJt9AXKXRAIewosB84d4UXkQ+EWbc6LxONY+VAbWJeNe7sJcDS2STY44sE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0UJkoSShcpD9pNjogWqbCpw7eC6ukBil+jv1gOrbRuWOjhs42
	TtXWu34mpOxezj+fuHIFpZuHVzLp4ptxQ+VvAPl5o4fq1E3eyvWgmsdjFMauOtsPNRVv8GiGe5e
	gf7JFOPB67W6v1s+nd09CfQJEn+I/aATY6JNZ
X-Gm-Gg: ATEYQzxOVMU1puOsic8WNLNyGpxum+SeYu5ZVq3F8FCYdwD44poCnbribm5Y7sv/aqm
	QYjvSEGOI0Y7/oEhLMszE5gE5UDl87mtk6JW0hl7Y4SPGkj6/cyzfZlg3wSC0xWu/Vm20G9CY6d
	WeBDu9oSIUayisWYB7r+3O/KZF2wmzPfRFBJIvMtyd4lYhCU7U7lUm/i9pWB4mckxkSDR1h5KWm
	2hC6FVD1K8F9gNqFGmAwlgciB6yxN/0Py66BpaEWTrgRBKd1RswVSTYgZKdVdF4mLvGimXsw0ym
	BI9/1fd+Wv4rjqg4Cttdm1judtlA+E9mW9KAha8f
X-Received: by 2002:a05:701b:260d:b0:128:cbc7:4c1d with SMTP id
 a92af1059eb24-128cbc74efbmr1834952c88.44.1773095623430; Mon, 09 Mar 2026
 15:33:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307224341.5644-1-ebiggers@kernel.org>
In-Reply-To: <20260307224341.5644-1-ebiggers@kernel.org>
From: Dmitry Safonov <0x7f454c46@gmail.com>
Date: Mon, 9 Mar 2026 22:33:32 +0000
X-Gm-Features: AaiRm50YZNa3BlkrQoNvVl8CLwjNIEvdQsMgwcFHWkf_GtPJxxRS7byEM1NSEyo
Message-ID: <CAJwJo6YhhK63tMQnMoN=9gsYcO4UCXovhK9S4GOdo8bw9B-49w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Reimplement TCP-AO using crypto library
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Sat, 7 Mar 2026 at 22:46, Eric Biggers <ebiggers@kernel.org> wrote:
[..]
> This series refactors the TCP-AO (TCP Authentication Option) code to do
> MAC and KDF computations using lib/crypto/ instead of crypto_ahash.
> This greatly simplifies the code and makes it much more efficient.  The
> entire tcp_sigpool and crypto_ahash cloning mechanisms become
> unnecessary and are removed, as the problems they were designed to solve
> don't exist with the library APIs.
>
> To make this possible, this series also restricts the supported
> algorithms to a reasonable set, rather than supporting arbitrary
> algorithms that don't make sense and are very likely not being used.
> Specifically, this series leaves in place the support for AES-128-CMAC
> and HMAC-SHA1 which are the only algorithms that actually have an RFC
> specifying their use in TCP-AO, along with HMAC-SHA256 which is a
> reasonable algorithm to continue supporting as a Linux extension.
>
> This passes the tcp_ao selftests (tools/testing/selftests/net/tcp_ao).
>
> To get a sense for how much more efficient this makes the TCP-AO code,
> here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:
>
>         Algorithm       Avg cycles (before)     Avg cycles (after)
>         ---------       -------------------     ------------------
>         HMAC-SHA1       3319                    1256
>         HMAC-SHA256     3311                    1344
>         AES-128-CMAC    2720                    1107

I like the numbers that you achieved here and tcp_sigpool riddance.
If you want to measure the throughput difference, there are iperf
hacks I made at the time of upstreaming TCP-AO:
https://github.com/0x7f454c46/iperf/tree/tcp-md5-ao

We certainly have to support AES-128-CMAC, HMAC-SHA1 and HMAC-SHA2.
For the last one, we specifically had an RFE from a customer.

It's a little pity to go from ">> Additional algorithms, beyond those
mandated for TCP-AO, MAY be supported." back to "The
mandatory-to-implement MAC algorithms for use with TCP-AO are
described in a separate RFC [RFC5926]." as I've always enjoyed Linux
(and opensource in general) that provides more flexibility than just
strict mandatory required options - that's why I originally
intentionally gave a user options to use not only mandatory
algorithms. Well, that's sentimental, and yet I see that other BGP
implementations already allow these optional algorithms.

I.e.:
"Of course, TCP-AO key contains a shared secret key. It is specified
by the option secret as a text string or as a sequence of hexadecimal
digit pairs (bytestring).
Used cryptographic algorithm can be specified for each key with the
option algorithm. Possible values are: hmac md5, hmac sha1, hmac
sha224, hmac sha256, hmac sha384, hmac sha512, and cmac aes128.
Default value is hmac sha1." [1][2]

I guess that may cause a regression for an existing config.
So, I don't know, could we get your big speedup and yet let the user
choose what algorithm they want to use? Basically, making
tcp_ao_hash_skb() a callback with optional algorithms implementation
and a faster mandatory algorithms that will use
hmac_sha1_init_usingrawkey(), hmac_sha256_init_usingrawkey(),
aes_cmac_preparekey()?

[1] https://bird.nic.cz/doc/bird-3.2.0.html
[2] https://github.com/CZ-NIC/bird/blob/0ee9f93bd076c5cc425ceaec9acedbbb7c9021ec/sysdep/linux/sysio.h#L246

Thanks,
             Dmitry
