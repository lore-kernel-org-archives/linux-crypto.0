Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05476358D32
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 20:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787948418; cv=none; b=LY6kZtkXpPrOBl3hQNX6Fo/o/KHxAG26T02J1hNcZ6bGqTpz0tP7c32OG6lrQjHd6D1QGZVP4Lr7/kzYpF+ovSMlF66Z4PO8H6FPHi8oXCJx8dLUtZ7zpObM8P+c54D/8C9+gzYip5R/sCAj8NKpTKVtoAswxiRQNwbONZYYOmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787948418; c=relaxed/simple;
	bh=IU15COOIedvrqR3tTewNzNa90X8qER45TX94YE7xJlw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hrThl1bAxWjR1GG6Faw8znLvwCzgF1qBiT9t7BbF8YKSbW3qrNEIoWOumUc6UBTIgug0kDNjSrUP8y4VJGipqQnlO+ZMOzwts22IXFA9eTveX2TJUkWIRTkKm1q/w947Tk4Ht9AYZKQwr7oQyPC5a5YhheAGnaxjHLYH88A3uzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/nXajXM; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/nXajXM"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c253425b253so242112166b.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 13:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787948414; x=1788553214; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lIHXIPftemB3srbWmY6HZdyrjAWi5GoKfLbjecbVLqI=;
        b=Q/nXajXMr7Hr/SyGsG5/suOf6HjMqD9803KIr8mDW/5NEAFIQT96uVYjbrXUOak1O8
         JMTR79NWammfOtRAN+sOUofy5femKQf7cacZYJhnXi8djIGWWBltOafiy+ZVDcn3Duxb
         Ge7LTwiVufoDZ+KNfuApSk3HZYPXrBYEYHn9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787948414; x=1788553214;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lIHXIPftemB3srbWmY6HZdyrjAWi5GoKfLbjecbVLqI=;
        b=WDH3tqgIj4x2BxlEl0u5F5C/HtAxQgNHn4D0/FjHQtZE35DFCMZ9a5tcVxXLx/ojJu
         tmNkouJTHUGcZlRTAKa6bC5WKMPf8nbgOxD0aYYHIZ9FtObkO4Nsmp+sud2EhwsEu7Eo
         p73hPfTC+fwWwPPrP3uKSeuuke29YvG9MrbV1R9Wulev3yQj0Uzlz7bQijgkeQyFbCrc
         Jx+SaUO2TyW0H/EatwRQmj2wp09WK4kwRWIpcd5ZZ2XoVdfjrjTXJkch9iSML55PIdT3
         vFDEGI3B3GcvraOtRDoo/6+c9+M2hgnzTXHVM7gKq9mGLkROGqqS/Xmj5/dShjQMl0k0
         fJYg==
X-Forwarded-Encrypted: i=1; AHgh+Rr2SJUnfSGMxP3bSolxLr/VEVOqZWXrxefTqEeMf3fchGKTr1OhWsXHrkCALJ0I6c5Cgi5vQcFDNs/gvDY=@vger.kernel.org
X-Gm-Message-State: AFuF++n79cFBepQ5eBFfWbA02D59bprA8m75JENSYohyZK/MKfuU5Fxj
	MvUeKD5EFnKYlDmkONNef7/3DwNH7X8CDczpiRz16Uo0kwQSYzKsJvj0V69aYletiRGcFZgugML
	OLYFxvqo=
X-Gm-Gg: AR+sD11hzooGktbMUtNw5nQqXRuXX2uH/dUNYeI69lNuWvIupWg6czSftSA49gWbXNJ
	aB9jwSsKYijCgjB6QilLIGMfwL6DctKZbAL0hTiifG6j9n4LgqrP42FOL4TPrGfKpRWlDIbC4W6
	anSQ+Bex7LXfKWNtuiA17O7Mdt1B5vY0gFkGt9iiu/ckQWv5RtQnyd5q4fdBvGZYHDxHoXCo42M
	t1Tsn3YUUzRsTa7u6BKqsNtJEbNwDKZ0k54fxcEUAmGteosd0pmdQQ5ASadtlsrB3I1GQqhlTL/
	FIfkz/3fygkS0RPobpcRe4BHgmp73jATBput6aEsksZObllCwbo7KQBHD4t/mKbHXgMl+1ncI72
	tdMmtDCNwONyRaTOCQqwTI/ZXSceAWM5Lla4WM7SQ1Cn3kFDg0JmUnsFxTtmdy19YlRM4NtQP8/
	AmVYm4SoQgQjaf06L3kQQd2TZbgrzpHeFeqBgLogFE2xcGvblyXmmcG2y8BQOIYCJdYnPAmlL2r
	oYuyL5LCB9wK7ensFFQ/6NtAFJlcgs4uweeWRbpXnV8Qt+I
X-Received: by 2002:a17:907:1ca6:b0:c21:9cf4:e1b0 with SMTP id a640c23a62f3a-c2556baf875mr639589966b.3.1787948414218;
        Fri, 28 Aug 2026 13:20:14 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f2534b9sm121247666b.59.2026.08.28.13.19.58
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 13:20:02 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso187948366b.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 13:19:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ronn5geW2zgt8y1p4LdLF6BEEgwtU2CwhyVg5ye8k7E3Imj1t1Kox1T4mEDrWwIp1/aNk+DsQW4QkjgADk=@vger.kernel.org
X-Received: by 2002:a17:906:9fc8:b0:c25:1a5:62a4 with SMTP id
 a640c23a62f3a-c2557164d51mr735875966b.17.1787948395977; Fri, 28 Aug 2026
 13:19:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2026 13:19:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZf9=X+qKkO9_pQzbLdOnbMw5yO8gu0TkahegVW3cC-g@mail.gmail.com>
X-Gm-Features: AcwNN1W9j0cj8sg0G3qrQ14m_E9ZWKm8kk74zjqNYRC9rRyEB-3MQ_ctKWT-9mM
Message-ID: <CAHk-=whZf9=X+qKkO9_pQzbLdOnbMw5yO8gu0TkahegVW3cC-g@mail.gmail.com>
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per context
To: Usama Arif <usama.arif@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, David Sterba <dsterba@suse.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nick Terrell <terrelln@fb.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, yosry@kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kernel Team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"

[ Sorry for breaking threading - I have turned off IMAP access to my
mailbox, and so I have issues replying to lore messages sanely ]

On Thu, 27 Aug 2026, Usama Arif wrote:
>
> On 27/08/2026 03:39, Eric Biggers wrote:
> >
> > Why not just use cpu_feature_enabled(X86_FEATURE_BMI2), which compiles
> > down to a static branch?  All these issues are caused by lib/zstd/ using
> > its own custom CPU feature detection code, instead of the normal CPU
> > feature detection code that the rest of the kernel uses.

Yes, please. The zlib code is just broken in how it makes up its own
random inine asm that is actively worse than what the kernel already
exposes.

> The only issue I saw with that was that zstd is a standalone library that
> is imported

Let's ignore that part, and just make it work right. The Zstd people
should think about this problem on their side.

> Keep the existing raw CPUID fallback for preboot and other builds which
> cannot use the normal x86 feature infrastructure. Also retain the early
> return when dynamic dispatch is disabled.

No, this is not great, that whole

        cctx->bmi2 = ZSTD_cpuSupportsBmi2();
        ...
        if (bmi2) ...

model in zstd needs to just die.

For the kernel, the whole dynamic "test a variable" model is simply wrong.
It should expand to

        if (cpu_feature_enabled(X86_FEATURE_BMI2))

because for the kernel, that becomes a simple static branch.

When zstd goes through that variable, it loses that entirely and
instead turns it in a static assignment and then a dynamic test (well,
not "entirely" - with inlining it could still recover the right code).

So zstd really should be fixed to get rid of that bad

        #if DYNAMIC_BMI2
            if (bmi2) {
         ....

pattern entirely, and be taught to have a *helper* macro that just turns
into 0 for when DYNAMIC_BMI2 is not set, and turns into using that stupid
flag in user mode, and for the kernel it should just turn into that
"cpu_feature_enabled(X86_FEATURE_BMI2)"

Why does it check for both BMI1 and BMI2 anyway? And Arif added an
extra check for ABM. That all looks bogus. You can't have BMI2 without
having BMI1, so all this code looks completely bogus to begin with.

Nick? David?

                 Linus
