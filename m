Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B98331159C
	for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 23:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508498; cv=none; b=npvvG1W7VThIqms7bAhuZOISTZ5/KFTw+cNKdKkXTC6AYTinINndJiHgcDaxODhugoxY8npm2p3oua0Y4MUGxkLge9DvgXhcKjoFEhRzcse7FQ5aeAJP3VV8u/ae9AW/w1d5Oo12pxzpe4fCXFmXMXHuUNbIPa0apjLZQn1nQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508498; c=relaxed/simple;
	bh=JYIbD/xHf4kvTELApTN0Qkn6sDe5a5c/t+pHwdB7H08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eob70IfyXbfXGOhbERVF096+zKLDWjvHDt9C5u7t20m0dOQfzwJg70JMXhTWl5AvgVGwWjvqn3TYT2pOPUl0An2Q4aQ1SVn9YtL4JxYlyvmtW4sH6vM0N7W9MLh3bftda1JbHHZtlkEP4qKgG6x0RDAtUUVPHuzEESHrXK3uzj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3PVvovF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3PVvovF"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958c80fcabso166319565ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 15:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508496; x=1764113296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSftY5ci1EGKLIUFb5TDQb6i/yPGJWA8JO8vUwt2+ks=;
        b=V3PVvovF+5jhoWT69gWOUa79lejK6YMNxB4kVxr1EhHUhadJSnhLTRKQ9CbJlQJipo
         qL6GS44Gl7/7HVbkNJcNZpPTKK6+UAlHI7oLjSeobphEgxXTPL+pt8trexuP5kP1nB5r
         kC6Ob4Yi1O5LX09kooSNECm2WbvOilA4+ICFL+0bmdDzJp4MidVi9v5xw0s3dix3XPl9
         600lBNetSqrQhANIyrOui0c6H34zkCXUtZQagh36dC0sZ65TrGIfKaKZ5WyD+9x6qKez
         opOWQqgPr+kCHLAwC1oGH05Xinv+9uvNz849lSkltI0ketPP83gTa/G7+uLDVhP2oF7v
         YmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508496; x=1764113296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSftY5ci1EGKLIUFb5TDQb6i/yPGJWA8JO8vUwt2+ks=;
        b=dST6bQ1OCadr5OKcKbF/FhKKrPt71qd+FovoW719P92FlSMp6ImVvqN6MNe8KObfI9
         uYUSdrRfLHKzvWvwOOlRHwEejGWDorfCfoNY5ZVEFQmoTIX9tXSpZ6mDzAARyR5gA2Ia
         DDyicOjR76c/gVEV/qzB/IxpIlkrpEFrwWLrl0Q4UKtFjnTXRgb7YOeKwRul0h/H59/k
         XNUo0yE9R4nAK73el3dgjKodZgaXStQeXI9pT1cZ3TM/erjvrqXLT6VTBnvcUeWNe4Jf
         O4X+Wty+434d4EidbYJrJveSlpSbqpPOuiOyeZr038d0ghpcPqpDlRqMtl0s3ywE3jhU
         AHrg==
X-Forwarded-Encrypted: i=1; AJvYcCVDorgfiWU1NevWuN/FK3zF5a6n8YgeeSQevdVPps1bBPYf8l/gOpzkWoUBYsRcX/UU8C80bFWszM9bXIU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKsV6J0pliVtiowJ+7BzOL82+Dbt9/ibDEK2hy2E7q7tzRE4uL
	HaTL+Nrxt+p4f80I0MmLzsnwHB4bl3htFqP/IdO6vRhLUyig5bfEw/1QGmbPO88DVF3JnDUqtMs
	DtbBsuQ==
X-Google-Smtp-Source: AGHT+IGn2JswFn4UeOAKifKE9H8f5r8980lrAWB1rQnFeljdA8CZmCPwX9Z+MUOeK8ZXWSwcX3f1f+kkIrA=
X-Received: from plpw11.prod.google.com ([2002:a17:902:9a8b:b0:273:8fca:6e12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f0e:b0:295:8c51:64ff
 with SMTP id d9443c01a7336-2986a7420ebmr202776415ad.29.1763508495956; Tue, 18
 Nov 2025 15:28:15 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:48 -0800
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350811296.2284106.5037458299764023896.b4-ty@google.com>
Subject: Re: [PATCH v4 0/4] SEV-SNP guest policy bit support updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-crypto@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"

On Mon, 27 Oct 2025 14:33:48 -0500, Tom Lendacky wrote:
> This series aims to allow more flexibility in specifying SEV-SNP policy
> bits by improving discoverability of supported policy bits from userspace
> and enabling support for newer policy bits.
> 
> - The first patch consolidates the policy definitions into a single header
>   file.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
      https://github.com/kvm-x86/linux/commit/ce62118a2e48
[2/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/c9434e64e8b4
[3/4] KVM: SEV: Publish supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/7a61d61396b9
[4/4] KVM: SEV: Add known supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/275d6d1189e6

--
https://github.com/kvm-x86/linux/tree/next
