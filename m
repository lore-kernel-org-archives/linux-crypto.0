Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665A2383C86
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 05:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791782598; cv=none; b=JhCwbWAOHSZ7E4s07CHQaT4Xrjdwi9+M6wsNWW1h45+4kE8Qj32WaMZMqSY6VAVKjT6EYcQlJv7CXD7yDNkZirztHBXXTCRPueD4DyZUo3Y5V2/8oSqc0lDIl/KxuWSz7srQLVoDXGU4qyLiiZhz3NHHR/PSKYqQyDuViv6Uz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791782598; c=relaxed/simple;
	bh=zYKmmn2b/wtCJyFUMdeUOpw8HN4SFNQuxQch0HtXZr4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=a/geQJl8rijcB69VamANSxQAl1EJ66Fmj07onUiroQ4LNN07p/WjAD8PGhLY/pGZSWHiLwiv8jqTNKFx6/hkLZnstdpQ2wXD3xBptVbMdQU32g8xCXIZAzNKYcMZ7qka8R8S1cBRPSo4H1lrdmmrlPCO7UTR6kXeNPDkRQfiEd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=La6fAbo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="La6fAbo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9831F0089C;
	Mon, 12 Oct 2026 05:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791782597;
	bh=W8ctU+epez/DyrKN9gMmGMQbJarmdhH+/vElms0uPLo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=La6fAbo2rxZt1U8JCqWcbpynxrCkJjVCGLIG4gJKREc6UG/YPKsrj1GiEUEokFZ7J
	 4ZLHygryI99rlaV07YHfrHjpp7QoRPZdk0Lsy7MSNGMktMXmjvn5n6TbFnUDrRCOlA
	 qBrXukc8nAWV7rzHpSioiMlCoVAqhJRqio8DsPaET5z9do1dsN2JMHV5vTTCx3pkQz
	 3XuSorxGLNb7+cT2fK3YXxILk+comKSB4orDLsXR/ZrmxWMMTk2d7wSwSp26WWBcB2
	 4+s+yrr+LVBOtbDsYLZ+sMALmFN+T1VV/MRWZWLzC8laF64Tu1Hx+0p9SigxgOD0TH
	 U1ZJ8mjqzkCLg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E656C198003A;
	Mon, 12 Oct 2026 01:23:14 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 12 Oct 2026 01:23:14 -0400
X-ME-Sender: <xms:wW7MauC7I9HdKVm-4MvG-nHD5JrJvjOA3K1RxIGWiK9KsqS4HEQzkw>
    <xme:wW7MajUSEXW5mvZCNtQ7i7CJ8Yo_lZ2j_Eb7VtfAD6Nyk20aQr1r22pafTY1YqtTF
    T14OAKLAaZVyIeC1bI6Y-uQN1SvVcnaEnDe0AlvCvhKe5QG1TLVbF0>
X-ME-Proxy-Cause: dmFkZTF9ik9PDwmgTnw6Wnz0+F91R2sK81KXVbqYkIEZwQe+sgDfcHaMo24ig+1Y9DAEJF
    DaPiO0fshZs3W5re80biKaHSFk4Yuq1CHe9eCZMPuSE8IXLkPYDV2LeKZke+sdy3wwGJ5f
    aK16lM+koZ0SE8UiIO6z/Wvsw2ZAjj2KqbIcz65Iik1ROssAdG8vlOVTqAUoTstwMB/dbM
    7oqshRT1IDFiCrbxcb/c3I17zhD7NLuEC7j454mNtR7Pnww4MYdS6bb5T0dXp/L2BzJnuY
    6JDiD4uFNK9pqQzqNxynYzSBltrYeqYAf9GRBMFQa82VQxyR1oiOpXARKHV/7V1+GWqris
    sKV2C2zhlbCVAfnj8ic4kjIhJ4H5/jUzXC/pzEovHp8OwRm7xHhFLLJKBiBo3QNEOmZmou
    aEOGHIcDMoS/MkTFtvR1cvvLfXzCJGp6m/znYIcoRQjzhJ2GgdWXVJpUNtbakCXJvPrmfa
    8rJsu8idVRKNIYxH0zL21wwprHGIM//ssvrYx70XBma6X3tBneyY7BXysuKozhtK2HTSLw
    IeOuv3t1NIpg5mSLfsvhRnZLY67U8VRNu4P50MQcMu8++6hID6sYlZZpTYBLlNsaS1sQBE
    1LqWqeW+8zRb2a1LVVpjUcybFLdwYZqRyNVFaprKQBlyCbkeH83po106TuJw
X-ME-Proxy: <xmx:wm7Mav0niS2mruZxp_jEJWoFz79bQiB38ZeLLpRIO533HxL7nDSTAw>
    <xmx:wm7MahyWANho8MQuEw0boTLZrOIKbovkCxjVEk8icrSSRlbGXgMpqg>
    <xmx:wm7MaptssHEsPs2HCqQS69f0vVl12qxK50tdZ1gb2ZXOAAqJ3bq7iw>
    <xmx:wm7Marzvglat1V4sxxPtT49qXfR2UEyO9nUMHwxrc44PemSV4EjKnQ>
    <xmx:wm7MakDK6OjeEUp2ss_4bo1yry4vyvLh7Y9-HTIKoKfCIX5zPK3FuIUq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E0F48F8008C; Mon, 12 Oct 2026 01:23:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 07:22:51 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <040d549f-a5ef-454d-a796-b4d432543fd9@app.fastmail.com>
In-Reply-To: <20261011134843.166585-1-ebiggers@kernel.org>
References: <20261011134843.166585-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/3] lib/crypto: x86/sha: Follow the normal %rbp convention
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sun, 11 Oct 2026, at 15:48, Eric Biggers wrote:
> This series updates the x86 SHA-1, SHA-256, and SHA-512 assembly code to
> set up %rbp before pushing GPRs rather than after, so that the frame
> pointer unwinder will generate call traces reliably.
>
> This doesn't matter much, given that the ORC unwinder is the default,
> and the fallback to scanning the stack made call traces sort of "work"
> anyway.  But it annoyed me that these assembly functions use the "wrong"
> %rbp convention, differing from the C code.
>
> This series is targeting libcrypto-next.
>
> Eric Biggers (3):
>   lib/crypto: x86/sha1: Follow the normal %rbp convention
>   lib/crypto: x86/sha256: Follow the normal %rbp convention
>   lib/crypto: x86/sha512: Follow the normal %rbp convention
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
