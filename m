Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4418232BF44
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757702089; cv=none; b=KoTu8n31k7L4uqM0v0wsiNHnKc78LPCxwh49wM4xcuHSEqVEPn2zUFp3RoWlWqvCx1Gi7ldoJsNSuMJ/yQAU7YOkE5u+JGGuR8G28JCKtEBZ/wIrFH13NqKuJwJ5FEbpnUXwSaZpMk48rqdZWT0ErTe0byaazT3oxnS6NwFjJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757702089; c=relaxed/simple;
	bh=KuQWDXlaZpYBi3YGWW3fX7XI+CI/DvkYxbxrWv9oMYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DHv4ZexyrPWm+zgAI3xGMiBLhfyExGU9ieg6tg+PNMHpVX+MibAfWAriAsIfXMfpOmDlzmI/AE2UHU0Yo0f1PEU+fYWcPVZpWHz0R7DbvCSsEKz1C/anArvCjd/xD0ziOUe4cstYJlZ/B12MQ3sTsGGlDPpGFSaMcMl97fbVBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yeql+5pk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yeql+5pk"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77615e6ee47so985652b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757702087; x=1758306887; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9avk6DW0uWC9sgvdAlpenzteq4S17YKKxa+B5Lkt+c=;
        b=yeql+5pkxplmh/nJUlq+CqmQCtp8syEh6HVD4D5/vcJh7Y3s0H5hVO3c+IuXroFNqX
         idBmU+athEhgKH05hz8DW+ysDzpG+k7KB5icO9BzR94LndO47cZo6DK6LFC6sxQ4Nqoc
         wkYMdNhwWFICvV3+ZX4dEfOd1kkc79WA0hqcKUeg/PPQOX9HeO9GN/Gh2rI8v9yqgbql
         nPfogIisUpAa/QQVkn/pIPnPH42cBMNGi7JleydAlYQDxtFhSrSe4k4cQv66Tnre16Lv
         ilkMmG97ChhKzb8YrLuuK9EagzaqiBqO8wr1vDBRP+/7QcgIiVgJjv77J1fAfUoETGg0
         VX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757702087; x=1758306887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k9avk6DW0uWC9sgvdAlpenzteq4S17YKKxa+B5Lkt+c=;
        b=tV0o4432wUKEYdMDdBvIhmgXJqTX8Vtc29BxIVPANtyk+2+H5U2ZxDeg0Nd+eu/B7R
         i7ooS6IE7E2T7EKkPm28WpdWquVETfm/ukKbgxRU7d1Z8X29+yIt6o+/aOzM+7bBueiI
         EtPbiRsjBWOzqe/PMFI4ioNc+Fll4sFpwvLS6jXNZE2UgqV1hLpDAfOhietFPJ/+IIp7
         4QfrtwBU3jgrFSNXkIzptFJHBNhF36hS/KEGtc2cmWBQpWbgionvE4hhxbJIQaOPjvnc
         +E6GQeZ7XZNBOqColohOLv+aMtDGHL2cASttTTDmuDy5X3p/cNNpMZYVZI+R9I+WMAHr
         6UXg==
X-Forwarded-Encrypted: i=1; AJvYcCU3ufbHus+t7cz5ZPyQ63CI6k+uzIBZ9ci5XWtFZsnZRDL4VJmSpPLGFumaS74n3xNv4x56RSvTHSX/wfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCStZ3c243C+De88wwsejOTWMKRDq39uVBZZ4Ot/M6rifBPeE+
	rrLffgD/4K+yFt1CgI90SQcsd02XDq3Pnu/T+925Q70hsDLpnNBj0AMWf2gHpsEjLjQuWG7QKST
	TJ9hSXA==
X-Google-Smtp-Source: AGHT+IFC7L13Y1FixY/H8lG9g0gfOdqBGxTPBHdlSsZpTSHjgZKbvR4Fyaf6NT57DoOlfRvzKDn0PGQH4Tw=
X-Received: from pgcc10.prod.google.com ([2002:a63:1c0a:0:b0:b52:19fd:897f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9189:b0:24d:d206:699c
 with SMTP id adf61e73a8af0-2602ce1be2emr4906126637.53.1757702087337; Fri, 12
 Sep 2025 11:34:47 -0700 (PDT)
Date: Fri, 12 Sep 2025 11:34:45 -0700
In-Reply-To: <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757543774.git.ashish.kalra@amd.com> <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
Message-ID: <aMRnxb68UTzId7zz@google.com>
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org, 
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 12, 2025, Borislav Petkov wrote:
> On Wed, Sep 10, 2025 at 10:55:24PM +0000, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
> > pages, it does not make sense to dump RMP contents for the 2MB range of
> > the page(s) being leaked. In the case of HV_FIXED pages, this is not an
> > error situation where the surrounding 2MB page RMP entries can provide
> > debug information.
> > 
> > Add new __snp_leak_pages() API with dump_rmp bool parameter to support
> > continue adding pages to the snp_leaked_pages_list but not issue
> > dump_rmpentry().
> > 
> > Make snp_leak_pages() a wrapper for the common case which also allows
> > existing users to continue to dump RMP entries.
> > 
> > Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/include/asm/sev.h | 8 +++++++-
> >  arch/x86/virt/svm/sev.c    | 7 ++++---
> >  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> Sean, lemme know if I should carry this through tip.

Take them through tip, but the stubs mess in sev.h really needs to be cleaned up
(doesn't have to block this series, but should be done sooner than later).
