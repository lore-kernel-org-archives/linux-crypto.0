Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16CF1D432D
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 22:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752187558; cv=none; b=Y+Mw7iA9g25R7oLs6rl0SK5ySwta2me/pFz3nikUNapU+aEfJyNZZWseFInD/14JYH7Opy8gemtWizv8WHHJdEM9Gin8sB63YXN3KOZod/wgJ6l4p1RIJCboqgO79Tmdi6WYP6tObIJrMLmeZtjZNDmi5oB9/MtLBJAb7ZAkq8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752187558; c=relaxed/simple;
	bh=ASuthF9LWI0NYc2lvvZiPPexlWyLf6OJpDYK25Z9I1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WFi1O8DM9f4e8yxzvNkstF9HCVz08WDFz9oJOJHiAhQz8FMINDUKwww1uGcbSbUqwrQAAUevTWEfpDeOyGOjz6RawM4W1k1f3WlY31Fm8dMf5by3Z6jPJTQBEW5nNGb7M4/1GEYqdYEcUAkN6wTXXalR43Vs4Ikpil7swFHSqaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OQmviEOF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OQmviEOF"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fab41f4bso1995129a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 15:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752187556; x=1752792356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fwKKtCrQ1LTqQDaAmH0rDuR3xsbJlV6bm4J01KtR8OU=;
        b=OQmviEOFcdmrNkbbhqt6p8QRfc2vIHVBd8+V+A4Ivglfg9x50JYLcI3mB9RGoHULKd
         RjsiGlZEtFKOG+IIQHTfw5Q1caij7NdxanlPdrb1X/XI6VEGBjO0gaCa7VrfVt4AFjGE
         BJJn2kI4J7szysXHS/alo+LLTn19JyEYrzpVNeyFnCxXRuLBUfHJXCGFOCEwz4AbyQUy
         WUw/6QLes0rk65cE5Wvq5ENNboVi6wupd/Efuzr1mj2FCqvlEHci+aEsohsKnJC53Bml
         kOiZHND/5iPHcWAq+pA98/um8QXxNNpZwsSisMatsRgubO8PdUfmJ5YrEzZxbp9xLOux
         TREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752187556; x=1752792356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwKKtCrQ1LTqQDaAmH0rDuR3xsbJlV6bm4J01KtR8OU=;
        b=OfQ9WKEUxy8C9WeCClBrmW1aNq97ZmwchLp2I7e7huk1KJ54aPNG7iRuGb4zSbegg1
         m6tl/gZE7qQcEmHg66zMKseUNi3AuZkp0qgLmAm5dAt8NDnNEFSePJs/UWNpCyyBAaLM
         q/oXn5pB+x6iBQjyP9XKpASDe6DXyKWHWHQh/1MM08gOCt23zcEteqDiQguZCvGv2GDL
         P6i/hPJmtgwshOlKYx/K13zRN3VOXJpDrLo3LwEWQWsAOmwRkIHdegL2HV/wLxDnrPr0
         eFPHhYLsGyilEyG+3QfujmMR827+8t3EIoPP8znR5SemZKduP1g+51q1++2fKPR4d0Pj
         8j+A==
X-Gm-Message-State: AOJu0YyqIr2x8OaFkCJLSJTISa9pGP7Qw3vcZBgzuD7Qky4g9rU+VjtC
	+LwD0zVVRLG3OBNdFyZa2KeSnuab0W4XauLCKm8NkdIqnTnjJA/8vU3lU5hJ17juUuRazuRt8Zm
	I1jiJ/w==
X-Google-Smtp-Source: AGHT+IFQLQws1wpWWj98zj6rPS2OtIN8GnmNDuftIFZrOMVh3t4f8o5j5+Wr0jCvHRAFb/wHyUgHGLmdh74=
X-Received: from pjbqo16.prod.google.com ([2002:a17:90b:3dd0:b0:312:14e5:174b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d86:b0:313:d6ce:6c6e
 with SMTP id 98e67ed59e1d1-31c4ca845e2mr1681544a91.8.1752187555916; Thu, 10
 Jul 2025 15:45:55 -0700 (PDT)
Date: Thu, 10 Jul 2025 15:45:54 -0700
In-Reply-To: <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630202319.56331-1-prsampat@amd.com> <20250630202319.56331-2-prsampat@amd.com>
 <aG0jxWk1eor1A_Gd@google.com> <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com>
Message-ID: <aHBCosztx8QWC4G0@google.com>
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com, aik@amd.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Pratik R. Sampat wrote:
> Hi Sean,
> 
> On 7/8/25 8:57 AM, Sean Christopherson wrote:
> > On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
> >> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> >> can be used to query the status of currently supported vulnerability
> >> mitigations and to initiate mitigations within the firmware.
> >>
> >> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> >> more details.
> > 
> > Nothing here explains why this needs to be exposed directly to userspace.
> 
> The general idea is that not all mitigations may/can be applied
> immediately, for ex: some mitigations may require all the guest to be
> shutdown before they can be applied. So a host userspace interface to
> query+apply mitigations can be useful for that coordination before
> attempting to apply the mitigation.

But why expose ioctls to effectively give userspace direct access to firmware?
E.g. why not configure firmware mitigations via the kernel's upcoming
Attack Vector Controls.

https://lore.kernel.org/all/20250707183316.1349127-1-david.kaplan@amd.com
