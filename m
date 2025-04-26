Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F525C6FE
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 15:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745680676; cv=none; b=VSrJAe9WQaWI67EZ/vo3Ae/eDYC+otWAdKm5+JbaDzDgr9rnl75W1v9McVkuGQr9sBrFka1expR4UIJzBRsp8euBaIKKIop6Zu0vRTd+K7BsIuQOJeH2gg1bgQA84AbNdri/tyzKuRdfm7GwpwEgTkeh3eCnBEj1UiuEffn3hSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745680676; c=relaxed/simple;
	bh=lwUT3Iv8t9p6mwjxLMSSqUxpKJyupbTKnPyyqPO3ZNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ca0fXqlqU05m/R15N613opIBTHG7YhgIqkZVT1Oz7Gq/ovByhvbLdDEgwVrbw+k9cSyYx+KDBMT07n037CSRRV4TZQ3LCluy7zL4M4ptING6EMIHih/tUkpTHiwMPj4iAaAK0ZfrECPEReHFKHEriG15yKtDobxc63Gsf9dwMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GFfa5EIf; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFfa5EIf"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e61da95244so5851585a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 08:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745680672; x=1746285472; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BNlY1Kyobnrt/7plmlszUhTRPyZa/aNAr5+UYAUEWpg=;
        b=GFfa5EIf2St03hFCcTCErav4/8fHMSzg55cjpzu3/ZspmEy+9eVcq35NWPidR5F+Nr
         VIsnUMp+Y4v1efVipXvyOyex6WrKfCgyN2QI9OpQegIjcVDtkfpi6M3ssHBKhYJNRMfi
         SRZVMg7aXPANkyWImpE8OzEUYf64QvhEbdsIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745680672; x=1746285472;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BNlY1Kyobnrt/7plmlszUhTRPyZa/aNAr5+UYAUEWpg=;
        b=uVQL+2A+y8H7Cq2aYFquiTjnAEI1xYrjZykiR69Qln/3DMlM+37Z10QFX0uoRMghg2
         nleluGz4UBfAjLMU0HKzFjgeioIchgzOn+7nBqEXrEoAthgSDEIfVhLuxKEoefyXSkm0
         wYm7Fhb+OtpmL5wMEUkE34/bPxkzaTTBUcJp8DtO47LG15EMIUYOm9gxEjqrL3LbCS0Q
         w0Pb5hBSj1dPze02XKDf8PkMVWzsLTu07cZiamxX4Sd0JH88xELdNwXzPRg4FBXlDKPz
         ac3HPXMeSIZccTRShOqc8c3roPdmeKiEXiZDK9RC0WXZ8+IMDfxtRLXz4Z5vr1a/8UIi
         Go6Q==
X-Gm-Message-State: AOJu0Yzy7a93ZcK5T0aLL1Q2mE7pu6uCzIz1HWmNMd0mvI3DYjcQ1ZNr
	fthjO4FlmFFWewpBkX5Tgv1cI77/VjYN3PkQ/J9JXr8AeEDy79uuU0rjg7cCxtMLBQQ7nC/HWTI
	o0h4=
X-Gm-Gg: ASbGncsVkQ5B8erXWlTlKPL2vMGGywJXaYu97N/aHIjtK8s9UTcLbdPu+bc5jKnX0op
	YgwHkqWZmQZS57PXIssJZEewlQuqW12bicRBg99DXRkXKz7wT7aJ24li3nn1F4YDsFK3dzbDHKE
	yWXgJcPcGdmWoXQEh//EccDBxQeOY4QRjqCv2OLUTPSJhWSlOrb13WIKlakoqhdrLbVcRvWzzHM
	fdrmbE6AgmXX+U55OKAMo27V0NMpTOhNM+8SVBXt/qINTB1q6yj1/NG/N279tFQYhISkbOveAZO
	36p8phKHUCvTKPIx1GBUvjKIOTAR+mMFjNGmXmqnB4T1pooFksqr912u41CxXI2IcSC8ewKbNQM
	5MfeaaE+S2OzaNEE=
X-Google-Smtp-Source: AGHT+IG6hm67oP834Xp3QItelUL7k0pWH6CWE5vlRoCGSxM85bzHRfurdlj/itD9FL86KQiibC/4kA==
X-Received: by 2002:a17:907:7f22:b0:abf:6cc9:7ef2 with SMTP id a640c23a62f3a-ace84adc17dmr255093866b.42.1745680672488;
        Sat, 26 Apr 2025 08:17:52 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41cb35sm301988066b.31.2025.04.26.08.17.51
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Apr 2025 08:17:51 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5f435c9f2f9so4310886a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 08:17:51 -0700 (PDT)
X-Received: by 2002:a17:907:7e95:b0:ac3:8895:2776 with SMTP id
 a640c23a62f3a-ace848c0439mr259814066b.5.1745680670908; Sat, 26 Apr 2025
 08:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250426065041.1551914-1-ebiggers@kernel.org>
In-Reply-To: <20250426065041.1551914-1-ebiggers@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Apr 2025 08:17:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_ArMFL9E9SehR2Z3pfV5QPut0XwbJs9mYWkRvcZcSRw@mail.gmail.com>
X-Gm-Features: ATxdqUFbLPq86s-2TFMi3kWckNkp7TWtoBPlYGSlRtiuXxSXCOJQKui7bzYM-j0
Message-ID: <CAHk-=wg_ArMFL9E9SehR2Z3pfV5QPut0XwbJs9mYWkRvcZcSRw@mail.gmail.com>
Subject: Re: [PATCH 00/13] Architecture-optimized SHA-256 library API
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org, 
	linux-s390@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 23:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Following the example of several other algorithms (e.g. CRC32, ChaCha,
> Poly1305, BLAKE2s), this series refactors the kernel's existing
> architecture-optimized SHA-256 code to be available via the library API,
> instead of just via the crypto_shash API as it was before.  It also
> reimplements the SHA-256 crypto_shash API on top of the library API.

Well, this certainly looks a lot simpler, and avoids the duplicated
crypto glue setup for each architecture.

So this very much seems to be the RightThing(tm) to do.

               Linus
