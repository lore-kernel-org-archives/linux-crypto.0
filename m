Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DED01E5725;
	Tue, 15 Oct 2024 10:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728989714; cv=none; b=RalCGk0mIuz4VVj+agUmlNhrdGzQ76QN6SRr9mGo7zjbye1+lxGLYQQwdcbaDyIM40T+wA6M5O7KI86O7qn37y+cEHwWS41SRGTzzhAZ0Ji0Ly4D49u67gPPKb0VGFsDfquFhO6gG67RHFod9FCBshVf5Gv6Knz5FU+sQv/vgfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728989714; c=relaxed/simple;
	bh=cYSOxjg/LeJUP3imGMsgTT48CuEfRzFTjko9o68LeRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtRIsZx/QiSZqnjASVAgB+s/wWj2ts4JrUqsjfOYOnq/HqAFgPS+vIIdBaIJHAnAbuAf2ccGxG784ipSOm/87MZ7tzI0NKq14odlyuQIQGwq2eyxzp2QwcpYYHnP2FmoMowizWk3TtPVw+sMV2rrPqgOHmc0zu34t/D5tSwSYPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1gYA1bL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1gYA1bL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BEBC4CECE;
	Tue, 15 Oct 2024 10:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728989713;
	bh=cYSOxjg/LeJUP3imGMsgTT48CuEfRzFTjko9o68LeRQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=G1gYA1bL4O094zpcI1sYILfzgnyrJcowFyIMN20KW2lmvDmohTcy+38OvdDVEEbKN
	 RZkdQ7QuCbeBfuog0PboFBSCoHaD5EwBmHUVq0t4dzVp4RJTBo8bP8OOiOEGw5+C97
	 KV/864p/hsqonwuiXChb84W7+yn8fm85ioMZNdoVCGN62qF7SFIDGk3SMxQgPz56tK
	 hsb4hgfUw694BygpRE7Os2CU5s2wrmygrUVaiZ4sWZLQpHr+ismoyC9X7E1m6YOLhp
	 PBzN7PUyXwsK0UQ6Q3Xkg3yzY9pOm2iaedLdu8czdIV53dE+Dg1Zn+k26ZekUuyXlt
	 D8K4xDZDdk4rA==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539f72c913aso2187691e87.1;
        Tue, 15 Oct 2024 03:55:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRKeQM7YNmssVLXpr1H+UCh85ZbR14Ymsqa+OHtfEzbTdPejt0uQtoKrNFnBdApHeXq/bulC8wETuFb7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8ZZsMYPlA7KYfJBBRjCgm34isumlzpzVqLOwvOcFfzptE8oNm
	n1Wcd7YY9yCjfztm4VvEvrGNs0EsLNasoTCA6kJidHRPVkyJVhnokZUlu5yNXdR1f18cQ0bW9PC
	6R0POVSaBwkAq2ezSUOym+nqM2z0=
X-Google-Smtp-Source: AGHT+IEslnn9HH04V5zULjP1WFfLCL4tGtY6Be+uyu6RPq5kNtrF/6ncdmTKRRQwxiGNu4W+5yUB7tQDxLe6BdfLtFs=
X-Received: by 2002:a05:6512:228e:b0:539:e0fa:6ee8 with SMTP id
 2adb3069b0e04-539e0fa6fa2mr7043257e87.6.1728989711875; Tue, 15 Oct 2024
 03:55:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014042447.50197-1-ebiggers@kernel.org>
In-Reply-To: <20241014042447.50197-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 15 Oct 2024 12:55:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFsyPdL_P-y3Qw51GA0aUQQoURLW_5JNc8KAiKwk8nUPQ@mail.gmail.com>
Message-ID: <CAMj1kXFsyPdL_P-y3Qw51GA0aUQQoURLW_5JNc8KAiKwk8nUPQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: x86/crc32c - jump table elimination and other cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 06:25, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series cleans up the x86_64 assembly implementation of CRC32C to
> reduce code size, improve performance, and eliminate the use of the
> outdated and problematic jump table idiom.
>
> Eric Biggers (3):
>   crypto: x86/crc32c - simplify code for handling fewer than 200 bytes
>   crypto: x86/crc32c - access 32-bit arguments as 32-bit
>   crypto: x86/crc32c - eliminate jump table and excessive unrolling
>

Nice cleanup

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
