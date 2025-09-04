Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF53F2DFA5C
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 09:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756977106; cv=none; b=SwlHAcaZYOMDrvY+AXdoYaYk/s1y11Xh21FhRPbHabbgNtApH9dsz+Y2eq6HIf8a74x6l40pdl6Sv0amHtm0EGdmeO4+K7Ea4km0heTsIINFh6/DJHh99Pc/lbC8eCPMSGkbtgx8/KXl6EpPPsx89p6wRxb2vlDQSBgUYhBMFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756977106; c=relaxed/simple;
	bh=q6GMFvLMIx4ZMmHgQIZ7JoZYDm4z4PXO1qkMil/wUEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WU42sRR7ToJuWnkyXf9nUSDrcmKsriacsIJ3ipfVK7CggEaVhtPXZtKMoIYxgBxzH0NkGJcrm8NNtmHJuRdbzPaZAljWP59L93LfAC++TdaGcZXmSXelE6wmu0FFBvaL6i7VoMZyOpdE35c0Kj5QNpQK1WNjEwhQdL+zcXMMHQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YdvzOCcV; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YdvzOCcV"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-726549f81a6so8077296d6.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Sep 2025 02:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756977104; x=1757581904; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OiBL4xUOfg7gCGVbKRZ2miCXhQoK6jtoEjlt5pZuFFU=;
        b=YdvzOCcV/LQKJwVTqk78eNBBOzUF9nHSiYvBoUGEm/E31K9V9bDpp4EoKstoLhwo5Y
         Csh+Dcb/GVyOdlLBQtX4eEQtkKI3Zm1LNKUGSH+4AQld5WZ5cFYNyaHpomww+FBi0wS6
         +Kh/VW+nsRqf37Pe9F+hfRGLXQd4DPafxEKlxeKjMkRi7z7uVr5CE3L0gqgKns9yyWeE
         LW/WSf7jqlYolwjmZAThTx72osQQfpisj4GTPk6+0H80+UT22ptSGBiaFFT+CtReW1Hf
         w+813V2YA4iIbhBV1o+JerEuF6m4L2AXhkfH7yaTvr83rZSkG1Ii2rbIrX5ErdsFD6NB
         yowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756977104; x=1757581904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OiBL4xUOfg7gCGVbKRZ2miCXhQoK6jtoEjlt5pZuFFU=;
        b=B4+JDN1ZmKerUz7d4i4cjznbFPnBvHnN+AklBnOCqgMmybPCHMF6XJk/bGpsiOthhb
         Kr12q3YmzmyRqoDFXP45XuuDCWMpNFwyVquQqJ4g2rlIpxPdmQU1Diu/KZRE2ykKHP0u
         JkrHhtKLyedGOoAm3y9XpYEQdtNvnFdPAtkAyBxqXrSnIim1nXQNBNJ/32h1lFmMKGwi
         kLB+M4QrlhHM+G2O073cQ9gR5phiY/u/+HK9V2r1GXNYTMBr/FdxtjFhnwTxMM9ZKEPf
         qS+fZSas+cf08ylr0h/fAR+S+R+88zNEJ+nYVjMdL7DFx7sxzlyd9ylPQgiUazqZ8GV8
         kBdw==
X-Forwarded-Encrypted: i=1; AJvYcCURByZBRK2tq1lCgyJvL7CXvtJ1gBP4gPGVfwB/i8WqnHGR/jIx4bzSacckhDOZpO82rVjLjbplqXTo7rM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnBvuklGtJcbvvyL9QBPt32Z9sDuujV/ylAeZj26DiVlfc2aM8
	qGLKYq5iIQwbY1UHzJK2Vak312TBu+yK6cL6lqWvAknj7kKguyInx9b/JtxGLtbmGdvrkZ7C1Zo
	zYDut2mAXJhAIKlp+R3PwcXmDHkIWjHw68oaV4cwt
X-Gm-Gg: ASbGnctnnOOIdgcX9UT9lw6BBXCpruQAZMirNGVkfEbm0yYZNq+4rGn70dZCNhsoSG7
	0gVQseoq4UaMMSbJseP5P52goS4NV5PbbJRUweBVHSFxZ/wRspbxxKVW1gRwS/FE/kv8XAd77Mu
	caivgMTvChh0uMHI21JQWeKWuDMletZWB7gwxzOrJSKAjniwpOj9oZhAE79bjtwShvjb9JRVqSv
	dRB++fqw9V+fWCL9an6LKw=
X-Google-Smtp-Source: AGHT+IFYlGXJ486TQ9EK/95uU3SyFcsBM0z1rBaAV0ho3WsC4leYY3WLao7HT7YaJJ2NIcq6dX8hgE65KVC5TnV8Eb4=
X-Received: by 2002:a05:620a:284c:b0:7e6:572d:abe9 with SMTP id
 af79cd13be357-7ff2869bd22mr2202626385a.37.1756977103394; Thu, 04 Sep 2025
 02:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
From: David Gow <davidgow@google.com>
Date: Thu, 4 Sep 2025 17:11:31 +0800
X-Gm-Features: Ac12FXxFg-YSHUgrBqJ-5TrzXWGp5KCpZbo80fhtQ-VWPd3R1wCW9QCV-W4F-oA
Message-ID: <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, dvyukov@google.com, jannh@google.com, 
	elver@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Sept 2025 at 00:43, Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
>
> The core design consists of three main parts:
> 1. A `FUZZ_TEST(name, struct_type)` macro that allows developers to
>    easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>    complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>    emitted into dedicated ELF sections to allow for discovery and
>    inspection by userspace tools. These are found in
>    ".kfuzztest_{targets, constraints, annotations}".
>
> To demonstrate this framework's viability, support for KFuzzTest has been
> prototyped in a development fork of syzkaller, enabling coverage-guided
> fuzzing. To validate its end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
>
> -ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> +ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under a 30 seconds from a cold start.
>
> This RFC continues to seek feedback on the overall design of KFuzzTest
> and the minor changes made in V2. We are particularly interested in
> comments on:
> - The ergonomics of the API for defining fuzz targets.
> - The overall workflow and usability for a developer adding and running
>   a new in-kernel fuzz target.
> - The high-level architecture.
>
> The patch series is structured as follows:
> - Patch 1 adds and exposes a new KASAN function needed by KFuzzTest.
> - Patch 2 introduces the core KFuzzTest API and data structures.
> - Patch 3 adds the runtime implementation for the framework.
> - Patch 4 adds a tool for sending structured inputs into a fuzz target.
> - Patch 5 adds documentation.
> - Patch 6 provides example fuzz targets.
> - Patch 7 defines fuzz targets for real kernel functions.
>
> Changes in v2:
> - Per feedback from Eric Biggers and Ignat Korchagin, move the /crypto
>   fuzz target samples into a new /crypto/tests directory to separate
>   them from the functional source code.
> - Per feedback from David Gow and Marco Elver, add the kfuzztest-bridge
>   tool to generate structured inputs for fuzz targets. The tool can
>   populate parts of the input structure with data from a file, enabling
>   both simple randomized fuzzing (e.g, using /dev/urandom) and
>   targeted testing with file-based inputs.
>
> We would like to thank David Gow for his detailed feedback regarding the
> potential integration with KUnit. The v1 discussion highlighted three
> potential paths: making KFuzzTests a special case of KUnit tests, sharing
> implementation details in a common library, or keeping the frameworks
> separate while ensuring API familiarity.
>
> Following a productive conversation with David, we are moving forward
> with the third option for now. While tighter integration is an
> attractive long-term goal, we believe the most practical first step is
> to establish KFuzzTest as a valuable, standalone framework. This avoids
> premature abstraction (e.g., creating a shared library with only one
> user) and allows KFuzzTest's design to stabilize based on its specific
> focus: fuzzing with complex, structured inputs.
>

Thanks, Ethan. I've had a bit of a play around with the
kfuzztest-bridge tool, and it seems to work pretty well here. I'm
definitely looking forward to trying out

The only real feature I'd find useful would be to have a
human-readable way of describing the data (as well as the structure),
which could be useful when passing around reproducers, and could make
it possible to hand-craft or adapt cases to work cross-architecture,
if that's a future goal. But I don't think that it's worth holding up
an initial version for.

On the subject of architecture support, I don't see anything
particularly x86_64-specific in here (or at least, nothing that
couldn't be relatively easily fixed). While I don't think you need to
support lots of architectures immediately, it'd be nice to use
architecture-independant things (like the shared
include/asm-generic/vmlinux.lds.h) where possible. And even if you're
focusing on x86_64, supporting UML -- which is still x86
under-the-hood, but has its own linker scripts -- would be a nice
bonus if it's easy. Other things, like supporting 32-bit or big-endian
setups are nice-to-have, but definitely not worth spending too much
time on immediately (though if we start using some of the
formats/features here for KUnit, we'll want to support them).

Finally, while I like the samples and documentation, I think it'd be
nice to include a working example of using kfuzztest-bridge alongside
the samples, even if it's something as simple as including a line
like:
./kfuzztest-bridge "some_buffer { ptr[buf] len[buf, u64]}; buf {
arr[u8, 128] };"  "test_underflow_on_buffer" /dev/urandom

Regardless, this is very neat, and I can't wait (with some
apprehension) to see what it finds!

Cheers,
-- David
