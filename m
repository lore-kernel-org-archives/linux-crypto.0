Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA952ECE93
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361359; cv=none; b=ZxnlXYpGvkceq3+Qkk9rfJtmIQPMq0tb2g1cmv43sPmjas0ERzgdMxn1zHmmc33ZpPKJuP0NBsmmBOafaRAwqhI7shvZH3r0kWHWZsuvM27PxNeUTHPLKHXUmyPJ/eIRg2VGe/fBZHLz5JHlGCbQeqsOIXEZ9omPFdH28ZjGk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361359; c=relaxed/simple;
	bh=6dW+JAuxB4Bg0lJ9WN8fFkd4N5NZoe/+1w+Q139I7zY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KKQS0NSkBTmIA3h8KVHzHyIdVsWq54qjJrRVrwyKUHDx1Td+rVdgg4yPllnr547OcTj0yf8mYHO/vzsWYjRuoCw/t06324I9TsBEII6ftypdhDpAwdX0/kW/6FXPBWfSP9DUGGPpw+wbr1yzC6ihC74K5f0OoPhc7MJ1Tb/YsQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jEns6GX7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jEns6GX7"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c891ed872ddso5168529a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783361357; x=1783966157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=24Bm1f0CNkzkBDhc/3jVoVdYR2LedLwQS2n18W/er8A=;
        b=jEns6GX7g5F6PXLGe5c+ktjH/iti5wwIu1NoFWOP3ywdcq7aOs1Zt78m1bqikzft/A
         FQJjrmvTIWb04jAjouA/s6++yUXnTDXFhjOHFhKB47FOFbEvRuHRBCbVZ4TWCAiTJwUh
         yX1c9s2/f0cEPs85jDjImHrh0iirG/FbbJZEzmbRaW6KVdKCeYnULKelOc4c7v+h1Z+b
         +2KXYYlML/63cKEv/eHNrvuvDhAgea2Tt6zg1gYUQ2+B8/ja7pk8L85X3oqfZ1IFAHqa
         0XB2llfleArthD8wRLR8+LHJnLP7ZOhBT2hUX3gt0BUFn6X10+KKmqa/CEbBNaaAZ/YC
         EhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783361357; x=1783966157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24Bm1f0CNkzkBDhc/3jVoVdYR2LedLwQS2n18W/er8A=;
        b=k84mDNXGWiw80CuzEaFK44IAYIIVzHBL9t6nnoh3D6hJVU8xikdW4FMOORZW3cgcGw
         3r6hQcqm40GaHibvbThiE0beZNNsHS0s2QtQz8wry3I3/WuOPoC7CbWTV/uBatZCOQmP
         hz7e36SbgORn+wU84V6L454v6u7JHMLLKlngnLqw8LU7Je84DaufxiJdmpG5Wk029NaM
         OQzU82Yl04dshejGCQRIaYaECndc3pZlMCqnsbwyVPKpFo3f+UNJueL7fvcVhS9QU5ND
         9yyGoROYF6T+IXMmkKL7NOMhdqp5ljsri+NGiOt2SZAZgohC0q+GIWZc8J43uxXjL4FR
         ABbA==
X-Forwarded-Encrypted: i=1; AHgh+RppTxcDOn8WbZZLFOfm4JTi8ECGJv8gz8zg/sX1XXfNZQHcafglOQMnok8aCm5YgDbcz2kVOA8XUk7qnEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNuT0SxeLcudgM+eng1QXKnQfkJZ4/ASrJ3KzLgz4aoUfevRzS
	HG58Fi+C3rMrG5dMqHz9W395kRGSZIx56cr1Fi9d4oAvs93nKgLIqGghLsWi5rcVDGXO8/s8Arx
	KT5aXcw==
X-Received: from pgbz68.prod.google.com ([2002:a63:6547:0:b0:c96:8ff3:53b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e8b:b0:3bf:6c05:ab
 with SMTP id adf61e73a8af0-3c08efea06dmr2045616637.58.1783361357431; Mon, 06
 Jul 2026 11:09:17 -0700 (PDT)
Date: Mon, 6 Jul 2026 11:09:16 -0700
In-Reply-To: <akdUUggmSSS1a0IW@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
 <20260602-sev_snp_fixes-v3-3-24bfd3ae047c@meta.com> <akdUUggmSSS1a0IW@gondor.apana.org.au>
Message-ID: <akvvTFUAI9tjOXRh@google.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
From: Sean Christopherson <seanjc@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Atish Patra <atish.patra@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	John Allen <john.allen@amd.com>, clm@meta.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	stable@vger.kernel.org, Atish Patra <atishp@meta.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 03, 2026, Herbert Xu wrote:
> On Tue, Jun 02, 2026 at 03:36:34PM -0700, Atish Patra wrote:
> > From: Atish Patra <atishp@meta.com>
> > 
> > __sev_platform_init_handle_init_ex_path() calls
> > rmp_mark_pages_firmware() with locked=false while the parent
> > function of init_ex_path already acquired the sev_cmd_mutex.
> > In the case of an RMPUPDATE failure for any page after the first, the cleanup
> > path would invoke reclaim pages which would result in a deadlock in
> > sev_do_cmd.
> > 
> > Pass locked=true to honor the lock status of the parent function.
> > 
> > Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> > 
> > Reported-by: Chris Mason <clm@meta.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Atish Patra <atishp@meta.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Want to take patches 3 and 4 through your tree?  I'll grab 1 and 2; there's no
dependency between the KVM changes and the crypto changes.
