Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66F3FD96E
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 11:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755791; cv=none; b=HsneCgMx1SJCijTc9bdTX8E4U75a6sT+0Elia+aTy5dzFl+aTuzFkLBuzeMY/Mg3p0Vw8pMqwTdQlRHpTQNQrUVMrorYLCGh25JCLSv1v4SoxJqbI2KMBCsm0rOrCTWZ+0zz1h1Y6CrtYX/YPpCCCyIfdD8pB+HW+0LHAB0BoYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755791; c=relaxed/simple;
	bh=6gFJrCyKa1FMhYziH+3elrOBaOlZg8lWubZb4hKg1d4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=KpsRRFaMwS88CfqrZN3TUQhFEWaxyfTw4KObzBczcuzD+SmscuuCO1DTiD7lA1flh13EGlgTwmfeAX8NS3afM9fQ8N2BEL9mArFSrFeyCdStSaUr9Y8LG7qkyBKqNkbl+vrgpz5nfRyIXE7K5YyOEbbgz62JqhvENfy6SV03Svg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6SYuZaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6SYuZaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF831F000E9
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755790;
	bh=Dk9he0kZ+7FH4JKyKCt6aMd0UmXYkUxoYBts2IM/kV0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=G6SYuZaQU4JUdbngLmgvHIGipHNUGQhxrpfdm/GSqPe92kwHOStgP0xOW/sC+0iKP
	 rTZaWFfpeKqK3tyLmxlSLqertRcYZun5AWG9VQxSTZX6CpVR7v+dumVB67rSCMBsLT
	 6XRK0nJQyOBCCRHfJirEKW66dSKGy0Ib2iDJ4B5rBpPr0u7K0whno1EAqi5gB79ed6
	 rJN2puNoAWcV0j+UOEdOvwrWrU3uXDKbI96ZmFKpKF/jZx7rP+xm+qRK7xeFy3Inmp
	 bcOvBsJdin+GtnCtt8lXCvncMcas73fyHeY0VEhk0a4qa9U9mZdUhoQBbqpri1GIoA
	 62xV9mYwfSNzg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A618E198007A;
	Mon,  3 Aug 2026 07:16:28 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 03 Aug 2026 07:16:28 -0400
X-ME-Sender: <xms:inhwajS8YuDZuqCzBuule4x38AwC81Serr1CO2jC8G1eBJ-8h28LlA>
    <xme:inhwavmtn7IsNdA6xQ9-uj6luxDV-oyrbg6FvqvCwbYJS8juC-veFIUyfG5ypuK7q
    cChkMPcsy3Ntjg65hiVKInab73A0NC_GQkyDicSdZb8alc4r2T9aOqW>
X-ME-Proxy-Cause: dmFkZTFZr+OzB6WUSgpgRpVhMBY0Rl/zJFB/sJ3YkRl5m83a+vbwtD7qUraEzXN65WH1ND
    pGtKCDZbhpbrSlgM6ul+Ia1tL1fO19t6DATZwcfzO8O9JleMxgS7HkWdJT5cBAPChqlour
    QnBdv31qT4jroqOM+kz5jY1r5hhbj+kwQy2TsALA7m6zV4Nxq77/roy5V+nq3wGiMdNshF
    rdAkiUCFX3SIQwz/tVBI/xPFz/vZY9xUpLqQOseD5f5Uy0lIxnOoLajE/+/xnXvEDuHvNs
    aOvDx9G7nJk3klqBon5+ptvI4VAD4FZMULPdwjxQoWkwk6Sr/YWpVLyz3gpvy/ogZ0sKcb
    hWmzBGWhf8QOmMSyc3BpLz75ufE//oi2PJenuOmt0KS28Bjqe4wWodlN8QREj6iB9Os3aa
    +KjWFEnRSa8D7ur94EWohnYgF+m0XbFqfp2XtorBCgP0jXoDe0/FoaXfCjf2Iei8ethplz
    RB7EPaSAT2LrZpYWwmmVu2d4RcvWdnNd89t9LcFGMeJ6oL/qNRfAPfvwqiR4sWJzPpnQB/
    OOUOUL8dia5UhqzsbJIxIOv+XkRbDOEsvcVYdPypT/NIEnHKqOv/RwPS5BF6ZslDq9HOa5
    GpWn5xkXwCa4b//Z0Lmg2vYlrQ/y1/Qk0lxnHEC7TpNJ80Wiv/ez0fHhNiIQ
X-ME-Proxy: <xmx:jHhwaqIt8wvRmZDRlnri8sQkM4lULmepACjgGTDCRdiw0jN27Yr3Pg>
    <xmx:jHhwai1oka1Ur49ZFmusa2HaG76MdQZuA4l6l4OBNjvIdacPWbMIuA>
    <xmx:jHhwao6dsuE0soK3CkuzoOFa-8fM68JWxw3DZtTSf6VIte_-M6jLKg>
    <xmx:jHhwaj8J0EdHx_jcGBHJcKs4Xg8X7kDK13nyNN62Tpif5SBWZxj-Ew>
    <xmx:jHhwanXl0BeMdVlJ1mSXfHIjcZc0kx1FrRj6WpKXDiKJPKZFQ-qiqjF1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1B036F8005D; Mon,  3 Aug 2026 07:16:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 03 Aug 2026 14:16:04 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, "Thomas Huth" <thuth@redhat.com>
Message-Id: <7a2d30cf-6556-44e9-97ef-35ba39d27270@app.fastmail.com>
In-Reply-To: <20260802233005.161467-1-ebiggers@kernel.org>
References: <20260802233005.161467-1-ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/5] lib/crypto: KUnit tests for AES-CCM and AES-GCM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 3 Aug 2026, at 02:30, Eric Biggers wrote:
> This series applies to libcrypto-next.  It can also be retrieved from:
>
>     git fetch 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> gcm-ccm-kunit-v2
>
> This series adds comprehensive KUnit test suites for the AES-CCM and
> AES-GCM library APIs.
>
> This is a follow-up to the series
> "[PATCH v2 00/13] Library APIs for AES encryption modes"
> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/)
>
> Changed in v2:
>   - Fixed crash in test_aes_ccm_data_len_too_large() on 32-bit kernels.
>
> Eric Biggers (5):
>   lib/crypto: tests: Create test-utils.h
>   lib/crypto: tests: Use per-test-case buffers in hash tests
>   lib/crypto: tests: Add aead-test-template.h
>   lib/crypto: tests: Add KUnit test suite for AES-CCM
>   lib/crypto: tests: Add KUnit test suite for AES-GCM
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
