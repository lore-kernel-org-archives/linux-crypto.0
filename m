Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792685896;
	b=R695vaEXdIYMipKM/+bh840WDHLpKLKwI8bnnupZU27T7q6yW+0buns/DXN7ObDFCZV5
	 pItl2wXDqUWptH7V10xElDFgFLgOhI6UeqDvffASuT05iqXcWt+AwnZP0rl/Lzag8v1JF
	 a0lLr3ZtxVQ0INd/oEYv+qxKMC5cgLWsPAWB4J34i1dwWlOA7P0K/xPMauxe3MHB1dpAe
	 dCVmHde53YF5GhhT3v0PrF8YOaX6LkOGYlM4nTZ00/mqsQfeNaQyQxwFoNdgMrM/xl5Zt
	 ywT6coAMhcDpbhK4nOANw8RDAjvJPonznCPl6/wCZAOUV6iz63cH9PFvZUQuIxG/4tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792685896;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=lPrIt5d/lpXT6RdQrFgQSFs6TWcV55hoK0YBF0AyJsQ=;
	b=cxMoXguSOo4CkeAtqawTtqw/TRhvW2MO28qZHhEXlxLjn4toWXaWxjMVHNd7pbJzj8NV
	 Sz7mIVInJSHlkzIwb5s5BWOQdgF56r/jC5JP5B8lr7eH91Jxvtcw/ef5IELyRhNOHZ6K0
	 IeuH/evrK7N0w8L7BBPYAX4i2Wwiigf8wZEF4k7Rn5znxhq47h7psrQAqQY6NlzFlkAcH
	 PlThCJ097TaqVOEzhByffm99MB/ZZqcX5SIBAfQlVToROkmSbp45/blpM638LZeNNNuL0
	 yBqzJ9EhLTbxGc6my3JL+Q7mE0Arh4nEOyZ71Wrbd53bWWG8/AX8DorxKxjqzR7wWaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fPFHYWto;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449C606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 16:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7449C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fPFHYWto
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so14763305ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792685896; x=1793290696; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lPrIt5d/lpXT6RdQrFgQSFs6TWcV55hoK0YBF0AyJsQ=;
        b=fPFHYWto/gOYoSz62i25jeKBR8RptwBGV/MkJCEFJ/VG+6P7v5rCdOnqMzrcVdeuma
         led4dSp7DQwpz+yx0S8KmmEFc++hH8HjGkCXzP4lZScrPO3ruKoas3svTVzHPpEUdJrY
         MeQWWuumjYZH5Qb+jWFYaY9GiY7nvbXYzhztW+piSt6TtTG8W+iskapzNlaGiyn80U4Z
         +qKHryj6SuqcoLMSVAwWrLJcpPkpDynu15waA5sERvit2ddNq0e3i1wIfV1BxihEUd1h
         DcUfGkLoNqksLnb+QZnIgSl95BNHA/qztNiHXCNtU/JtPeqQcJz98h9g/poWeCluw3p/
         2T6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792685896; x=1793290696;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lPrIt5d/lpXT6RdQrFgQSFs6TWcV55hoK0YBF0AyJsQ=;
        b=S5d5Aon2VHa1TpfLhP3plkr9+blqgMfpOlhIlWE1fFM9gFkw890jpXHDPtHkIG1YF1
         I+a3OCjrrR4guEQwn0t9C97hLIZa5uQIoEjdtskhjXv/MpC2N91CtpTpo5EGpV0YU9xM
         90aJp/7j+g95expvomFwHoPZzT1BjK6dYtI0B1WUfBRh2QW6bKx0+VoTvbBfASv7A/wl
         8A1GwrvqCouTq8V4YuFRrdWgDaRPDDx17F/nrH/e8EzNqhZISA4/VpqXuZloigfNDY00
         SeNbK/YEcqyv0empGlk9Fr2gXq3ta1Ks+33gFnbpkvXRwQX8hIz+TwO7472nNwWGmVC1
         b6Xg==
X-Gm-Message-State: AFq9FYJ0z+Pu2jYfYOU2sBV+aE0fPttYoByEMZhAUBZXJeEkGtjQ5Tsk
	iEC6NNjsCg8pxWhwXBJxdT0Nh8hf4HjiNOism+hoZ71uEnwI8q3IQcn5CvnbDAykQnM1dOprXFM
	ZxjKiVg==
X-Received: from plso5.prod.google.com ([2002:a17:902:bcc5:b0:2e8:87fd:f180])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:7c01:b0:2e2:e24e:a88a
 with SMTP id d9443c01a7336-2ea43e4ecbamr30817435ad.22.1792685895570; Thu, 22
 Oct 2026 09:18:15 -0700 (PDT)
Date: Thu, 22 Oct 2026 09:18:14 -0700
In-Reply-To: <20261021192434.1924950-2-michael.roth@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021192434.1924950-1-michael.roth@amd.com> <20261021192434.1924950-2-michael.roth@amd.com>
Message-ID: <ato3RnDbCVohujid@google.com>
Subject: Re: [PATCH v3 1/1] crypto: ccp - Make usage of sev_cmd_mutex more granular
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ackerleytng@google.com, thomas.lendacky@amd.com, 
	ashish.kalra@amd.com, aik@amd.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 21, 2026, Michael Roth wrote:
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taken upon entry, and ends up
> wrapping a lot of potentially time-consuming prep work that may need to
> be done before issuing the actual firmware call, which is the main thing
> the mutex is meant to protect.
> 
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state, a
> special fault handler is needed that could theoretically deadlock if a
> malicious user tries to use guest_memfd pages as the source/target of
> previously mentioned copy_from_user()/copy_to_user() scenarios.
> 
> There's no reason to hold the mutex across these problematic scenarios
> however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
> each individual command handler, acquiring the mutex mainly around the
> platform state transitions and firmware command execution.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---

Tested-by: Sean Christopherson <seanjc@google.com>
