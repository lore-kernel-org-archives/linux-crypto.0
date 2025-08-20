Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFE2F5B
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755648305; cv=none; b=ZyRDqcyGJ07D20HguJOj4O6HNj5Jupbo8yvAfD4fpq1GSP32Wse2brl9Ok/wpFhk+X3h0mjqXW9W4ksbRo5OZTWfUr1tQLcNFRxgVaBNpUVg22nbQlutiphaUw589HfR9mFu4OjtFFvKwkegeTVzm7JUbUEExCXlScD/NrO5K1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755648305; c=relaxed/simple;
	bh=Tfo/19RHyW++txmc1kMnAys7+aIQLnpLmNAqGrRJIgY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mAtLC5XwuAvLsKt9oCInxVO08gf6RuhKSvviehdKdE4sGn4gyCBMoVvjvhsVGAFEoBErf6oyZhT05J3hPj2qCepXaudadlMaMDRqs3NwmQ0SSu9d9iVpHGXLAmRxGsShNY2RM/7IeKXsuDMPBovPkuuVflxP40yKlX0BDhpSwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOcR5Cjp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOcR5Cjp"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4716fc56a9so9603535a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Aug 2025 17:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755648303; x=1756253103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9wXsk4jqFDa9XGwh3suMWyZDPKqbXwjavw0fzoWkQ8=;
        b=GOcR5Cjp4UvbAlbbMNvW7LsVP1Y/bCXJMcJDrTQt8Sas7Zh0+b3ARyzehbIqvD3nV7
         /yTXZDO32zOb1VvH87lwS2whyv1MlMkPoQTM2rs4PsEhAzyoxYoyY2WFqv2Fj23+093D
         PK3jpv4A4/wSKvTa+3JJJKtGyfkKwU2qq1nCcUa7tqOILH8IG3aOJ0b4uskgvMigbyNF
         KYiBS6jUSX7YsXUMVnSNG2E+nS6b4kQTluX1X1O4SXE/B8PwMsQAoLv4Rei64GrjryFN
         RpKA7BVMtlUnUxtTg5hBe1HZbNMn8ZhXvEdwjgbKUjrPiks9NEgRCPFV4PkqxamVl/7S
         Q7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755648303; x=1756253103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9wXsk4jqFDa9XGwh3suMWyZDPKqbXwjavw0fzoWkQ8=;
        b=UvlXOASn7a1izfhHDLmQEFH++bQl1O+Zs6qEJf2Zyp4VZ8iIpeEudAS0tGaGtxpYJG
         IlToCBVENN3iAqL+KAOP4KyCGQUE3nc1/NqqRQy4NiiEdMKYjZRjvn9l9VO5NjnhOYgh
         DkC8eKsGTuu0wio+7VDjY3uwzdJJfr9dpS9E0eQUId3UaEbDAiY9Hnuj2QQ908zbCxkE
         q3Y5Byyt9X4LdIBbIpOGzsZR6VBsTsV0fwypv8b3rJrLS716MnN5U1ZCN0+9Y58YuKkv
         1bn79Wi6Djm09yLrAwlXG9X8P3Gth1Q4FKWihUiiF1kFK0o+CjgOKv8lh00ve4melwxM
         nIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdn9KLhsnHD7YSBQJo6YPwW8R8oG8BPPPyXDyxp1Xk5/fnV9TbPWfz7AM2wjmpzLkXKLJJlNmJYIWrbrk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvz7mdG9Yw9zW7WfUer7JGGUpSr8w7cyusWUnFAOSJhv1ESbIW
	JEouHZaHbm0z+P6ChjgsBELlap7hLcN73tWaFBq/umUrB2zfgIXYqPSBrJt9/nJhR0Z5/HkU+h2
	xFtXS5g==
X-Google-Smtp-Source: AGHT+IEgp2iZQpjhp0IVG/RwRNaEA6kfEIJ5+nTH0IRpQP2O/sqcsBBrA4cu+AlVBTYSA0EfMFq00gIPM7c=
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3394:b0:240:aa15:70ac
 with SMTP id adf61e73a8af0-2431b7decdfmr1666131637.16.1755648302882; Tue, 19
 Aug 2025 17:05:02 -0700 (PDT)
Date: Tue, 19 Aug 2025 17:05:01 -0700
In-Reply-To: <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752869333.git.ashish.kalra@amd.com> <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au> <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com> <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
Message-ID: <aKURLcxv6uLnNxI2@google.com>
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de, corbet@lwn.net, 
	dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com, 
	john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org, pbonzini@redhat.com, 
	rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Borislav Petkov wrote:
> On Mon, Aug 18, 2025 at 02:38:38PM -0500, Kim Phillips wrote:
> > I have pending comments on patch 7:
> 
> If you're so hell-bent on doing your improvements on-top or aside of them, you
> take his patch, add your stuff ontop or rewrite it, test it and then you send
> it out and say why yours is better.
> 
> Then the maintainer decides.
> 
> There's no need to debate ad absurdum - you simply offer your idea and the
> maintainer decides which one is better. As it has always been done.

Or, the maintainer says "huh!?" and goes with option C.

Why take a string in the first place?  Just use '-1' as "max/auto".
