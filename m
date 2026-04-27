Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8787C2EBBA9
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777324814; cv=none; b=o8F185vi1SBvXVP5KHQwj6MsqN8aSO5OZO0pBmRgMTxlZXiQoQMIiFxVTtc03vywJBWM28wCIaN3YCot7ai4pczq3Y/Niz53/AYwvXv9NBEbmnbdxbpbKjMlNllFr5EVJWOU7+eRyo9zspBRRfKlxvl2YH6TZ1537Krk6HlxOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777324814; c=relaxed/simple;
	bh=wCXqIOOlIDnSn6wujP2KbKL2ztP/1h1QOB0MF5jkUzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NPNx4ka9pjFN7AlroRU+6anD4nxKUVgvs4w3ot295ois7OPvb6F7FPciZ4MT6Cn892xqusAVu5Eg8dV/0M3XIaxNrLhgXdP+StJm1qS+hbBz8YVWyj0jgEh1q4xrp9TqupYCWVfiorQfKKvOr2qVNPGsmafsskWrCUg3zdStYjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S0ltqXpB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S0ltqXpB"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f2138a9e0so6564218b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 14:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777324812; x=1777929612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/MdLtT/yrkXJOR0VhZtn2A+WvIE3I+Wl3TlhiqBWNg=;
        b=S0ltqXpB/1X5RzLmttfSNPuKUVDOgZNT/ZNx4LZJ5lrYLCRPb+WNJp8NKpDsV1rv1A
         p4F2WcT/qB3uVk19pUgJH5+/ZeBdnzHaBWy9F2oBn/ZZlxYlMAu+ooB5Mc00Sm2UCblT
         BpFXTbttLSQqKz/mCRc+T89+FhRa831hCglH77YDMSXfue+Cn1YlkFjqwJgpPe1Fyo5N
         Gerh0PE1Ie0PRe1XU16OXrI/ag3s2DP8VXBSukJFGOltSYKLS8AQ6+40eSGDeF7YQpI6
         XhJIbWL+GJ5zY//Kp9sa8XHO0ars3PS7a5amowYGe6TnNEq4Ve94frChExt0DWsuX4tV
         OhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777324812; x=1777929612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/MdLtT/yrkXJOR0VhZtn2A+WvIE3I+Wl3TlhiqBWNg=;
        b=KqTxzE/Zj0wH9gtc1phu7EjgA1ZGZF+Q0ew7HYjlWZKjuE3hqqafsM9busn+Hc7nI8
         AqwWYTaCgM1PHpCG98Q0z1ECSLzJ7qBql3Z698c/pTtINo2jtA6chdqNNyKd0XSwIYeF
         +LFN7qCRRQEIFe3E3sl6DMfrmD7nrjlZ1Quknk6k97Pb2mqQGTx6TcwdSrHJIcK8hPjS
         EwLK9wnsJbm/H7NOgwC0uHD1TKnSOwabhuWxMUqkgJkyqA3XN6W2/fW5P5Qhn6YRrDcz
         UGz4RMtjU5tIEvuoKQIyapKkgmIJGuZsv1+K7sC7NTf15tGENvDoiQCTysCrrQb5taCG
         PsQw==
X-Forwarded-Encrypted: i=1; AFNElJ8gqkQFRouAB6SRklKiyzVbJHmwGpquO2WvxLQmuIJx3nzNRPF2ZZaPSkvPR9FnRemCXqBigFcVy+G+wYY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGS9Egdu47BxZay2bUU/L+V+eCsRmGqFKvRh12pHQOrUCEAwfo
	jXX8AdsfkwuXc2hAy7Y0h3dXAiVrezNF637JHjlYlP767pSa0umwL8OE+2elmwOunwfgmHEOp2F
	3pOCVJg==
X-Received: from pfoo23.prod.google.com ([2002:a05:6a00:1a17:b0:82f:aad4:3985])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:408b:b0:82d:29f:d003
 with SMTP id d2e1a72fcca58-834ddb0bbeamr173477b3a.12.1777324811618; Mon, 27
 Apr 2026 14:20:11 -0700 (PDT)
Date: Mon, 27 Apr 2026 14:20:10 -0700
In-Reply-To: <20260427204847.112899-4-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260427204847.112899-1-tycho@kernel.org> <20260427204847.112899-4-tycho@kernel.org>
Message-ID: <ae_TCofu4bHP_Ch-@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module parameter
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Li RongQing <lirongqing@baidu.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 27, 2026, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Add a user-visible way to set the RAPL_DIS bit for SNP init.
> 
> Since setting RAPL_DIS affects the whole system, put the module parameter
> in kvm_amd instead of in the CCP driver to hopefully make it more obvious
> to admins.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 5 +++++
>  arch/x86/kvm/svm/sev.c                          | 8 ++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 4d0f545fb3ec..2b50eed8664c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3207,6 +3207,11 @@ Kernel parameters
>  			max_snp_asid == min_sev_asid-1, will effectively make
>  			SEV-ES unusable.
>  
> +	kvm-amd.rapl_disable=	[KVM,AMD] Whether to disable RAPL
> +			(Running Average Power Limit) when initializing the SNP
> +			firmware. This disables the counters for the entire system until an
> +			SNP shutdown command is issued.

I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
RAPL for the entire system.  That needs to be a power management thing.  KVM then
needs to communicate (and enforce?) the policy to userspace.
