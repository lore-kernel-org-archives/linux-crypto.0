Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558207;
	b=FRZjIXtTlsc8nUOysYxqmG7YnCAUvJ134kFexDrgIWPJyZsmgyq8rcnKSCCWS5FbCwk/
	 WtXGt7OhgmktNhMSP75s9RQfCFAy5SftqhdzzY4uTS2xjIi4F9u2j6MhagGBHa2DE6BiS
	 iZUcy4QV1YKYuhjD5Dzu0NKx9CBpZgBHnfP2K1J+tFXW7SfKA3Qb6DAhoivZXnj6QCJzX
	 Az8bi1Yb9lfrm5zQ0CkvLk6EdAF3Mo9+heb3dNAgfo/GNwIFDWn8yk09bqZY66pNvO2dm
	 nsHynO2UaK3CEjTQhUuPmi4JIYBW4mEiUbRvTHkZAaTsk8c2rHCxjKy8sdW8HSjT+IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558207;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=uws9udfa5adxCOqS10/CzLqccmroeJZWnY6ioU46GUA=;
	b=JQkYhW9dy2Qsq+aLL7Yzh1uVKoIx1zY0wo8+AW0VbxatcP8su9+ZOT+7oOXPvwh785Ut
	 87z58zs17iDF5W6Nz3DNsAn1XrF2s4MFtJIAUGB5JFYdWgeqAgMevSz1K/6VDhDwnByaN
	 5ZW63ygpWfq+QKkLUp/TmdPkngiDb50MYT5GGPOKXKYSriQt3CxK/bLc6TYuruX1iIEu7
	 pbMQB+/b3StPHa9VJGSrfKgjQJOzW1qy64Jb4tFJmtaY4WoJ0NDNH28J0UEm2cZs8565G
	 86EFhlkauuZvhMEswTz/IORmARdlluUNY/p8R0TjUoZ9pA1zNskkcqzbqC7tx2NZC2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZCFIgb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5614606A884
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZCFIgb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89091F000C8;
	Fri, 13 Nov 2026 08:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558207;
	bh=uws9udfa5adxCOqS10/CzLqccmroeJZWnY6ioU46GUA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=kZCFIgb+C+M14fT8GT+7w3lwKw0U62zWbhKxjM6HW4sHlZnK5OK5zCkoKqSXI4V0/
	 ps7XCr94u85konlRQiMJhYKUk0axeMWUh0rA994mEycZy81dLHItRqPv7VF9qGliau
	 Hiq2LyWF5qzyafVScoigIfa9miJUocEvZVVGp/rwfRvYiCldlqEAAWQCe4cEYtl7/W
	 JPaWtgGshzCmfk4F9aBGE/dxN0PNXqRZvCIkfLN5PEJq+2FXQrDZawV2SZEpCJWZmc
	 T15/4kdB/r70CqQJ45u8tU1RtNq+W9m1tVQrqIcu5UitCUxAt+tsPrqaWW9I9/kxEj
	 D7IT9mxF8Iz+g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2D6F2198003A;
	Fri, 13 Nov 2026 03:23:25 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:23:25 -0500
X-ME-Sender: <xms:-8j2aqx0alojUggD-TyY75cRCW6wyvsIQvCpWBQSaCyeiKJwU-HZ5w>
    <xme:-8j2ahEJRba2QXRnkRRo0oqwDkBzv7fsjq9BseCS1_ijQENTnJq0f5lvGknzsG324
    jTBKfxuUDWte8cNhcKxxK5BbYsZ7T3vc1LdR2rtd3Nj7tLuRz4PjDo4>
X-ME-Proxy-Cause: dmFkZTFasi1mk7Wg6vwiVKBf/OywSreu1wv+JOwFPo8fJdW3GoQxx5JHsrogrVfeHcW4fQ
    lbCN8q3fdN41dpXnltUWEHmAIxBL/mWTVMNLDmGIKgODLU0PJo4SJXr9AGRY1EcOSsiaCF
    WqB/B1tAYOmeuwlIgFvtcJups27WiWKapW37JCs29lSLVBohtT2zLz+lgFOzcxEMU+FZtQ
    MWZSK4exr8gaYB68OnDPYfOHqOPhsCw/Q56xm2R/9ddSWMseN+st7tEafzy7qU2Rz8SsCU
    X/nJi+NABMr/qQ3I3zkRoNbr9qFHTF2Xy/CjmekLgicnmKWy/BqQMEIfPvaNCGt5HjE5lU
    LwJGyENElv+V32Ts05WL2akjmcx4R/W8d+Jvo4ti5Qw+txJAjHq6wm20brYjPp7oFJS1va
    jInambHAZ2Es0tvRn+NAxGzZ56vPkTnjG6ValS7tWmmVuQYfZy4XuBlcxHA5DYi6fjVu5P
    5PT0YQR34s29UfyPIh7Xo+Ywi6N5l489uDwea5qOc/ejptHZ1vMl+0LCUvqXl5jYzf8teh
    AynXG3v+PPeZD5OdGCmXXr37QFkEbYvbMRzQkSaOe6J3Y39nbVFz+Solb3c5TSkVDSexwe
    qEuwVB7B7h8P40otg+41ox1u+uytosN+Gg8MN1QZSymrIWJ9yLh5FiXH6D2g
X-ME-Proxy: <xmx:_cj2anXLN24syy5Z6karfe5hKha3M4js-XdnyZWEyFmcamsH4T8Otw>
    <xmx:_cj2ah3DNhO7OEGSp47D3kp9-E2_nMcMuHNnopX6ylXrquPWcqfYfQ>
    <xmx:_cj2alr9nFGKCbn3Yr9qU1mEJFX6xe9POEdDloRKezHv-5CxWkkrtw>
    <xmx:_cj2aoUpHvU5r-yC6r5VcdROsO0kYy65ZhGXEabAQ3ZQcLN1q_sm2A>
    <xmx:_cj2agYAdlspQa2uUlC0LcCHFnpKcoGJ_3nYgUsW5aNynf8GjIxpei87>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C3DD0F8008E; Fri, 13 Nov 2026 03:23:23 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A5RLEaK5Drvc
Date: Fri, 13 Nov 2026 09:23:03 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Nathan Chancellor" <nathan@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>,
 "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <bc58b973-3d54-4480-aaaa-f5d5269418ea@app.fastmail.com>
In-Reply-To: <20261112222720.GA188816@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
 <20261112222720.GA188816@ax162>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 12 Nov 2026, at 23:27, Nathan Chancellor wrote:
> Hi Ard,
>
> On Thu, Oct 29, 2026 at 02:50:20PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> Recent Clang has become more finicky when it comes to overriding the
>> type macros that the freestanding stdint.h consumes when defining the
>> uintXX_t types, and so it is time to finally get rid of this entirely.
>> 
>> So instead of making stdint.h (which comes from the compiler when
>> -ffreestanding is set on the command line) agree with the kernel's
>> linux/types.h header, avoid the latter entirely in the compilation units
>> that actually use the NEON intrinsics (which are always leaf functions
>> that are not tightly coupled to kernel APIs).
>> 
>> Note that the disagreements are about long vs. long long on arm64, and
>> long vs. int on 32-bit ARM, so never about types that actually have
>> conflicting representations.
>> 
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Eric Biggers <ebiggers@kernel.org>
>> Cc: Nathan Chancellor <nathan@kernel.org>
>> 
>> Ard Biesheuvel (4):
>>   lib/crc: Don't include <linux/types.h> in NEON intrinsics code
>>   xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
>>   arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
>>   ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h
>
> Who do you think should take this series? It would be nice if it could
> start making its way to mainline sooner rather than later since tip of
> tree clang builds have been broken for over a month at this point.
>

Are the first two patches sufficient for that? Perhaps Eric can take them
through the CRC or libcrypto trees, and I can send the remaining ones
through the respective arch trees the following cycle.

