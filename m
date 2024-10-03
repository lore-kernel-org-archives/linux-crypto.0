Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9CB19E7E2
	for <linux-crypto@vger.kernel.org>; Thu,  3 Oct 2024 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727964302; cv=none; b=hALzZl+7Nb5xeShRy7U20gFGDy07/GPF9+CRwu4Oj7dJSVSlnspWx86R2cIW0U2gYIgR8Th0edG3xI8eXWZm02Lu+AawdararQxPl45aa3SwruBaZF8Qnpf4NsvPzQUrXGu9q9Ze+R1iTSbb4bssBmoc9MV1kz0IxSjIuIJHxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727964302; c=relaxed/simple;
	bh=6UYDcvYBFo7bse1eNkiSx9sfPfs445QzxMV1Apy/jqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fdeAj3aUneFsF3RNDuhsdYDFRM6w43Px39w2mFVRPI/JBOzPE7diyzfCAeu+De1M9PU7p3CfxMJqhnsI4BrJBWteE7t513GzUnKJua9pyF5LgD+Wr8rEBxZ3dD57F960XVPRVpYH03vJeVNc7x8/eiKGCo//g/0cqBgt+1wcnYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=raJMaz15; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="raJMaz15"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2faccccbca7so9877021fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2024 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727964299; x=1728569099; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tx5oPoUn5anZwJRYXD1zf/fnqWWX40jtN18OT3B7mk=;
        b=raJMaz15JLPGl7mYKDwIzJjq1l1oDSz6Bf74Fzgpd2AS0Esgqo05g0D8HSFjUzMZWA
         jZ6dZz5SMFllLlMSmy5rtojeO0rJzpgPvE+wuo/uUyaO3PM+BiZaL5lZEWvQ2kYBCQc5
         PRx2pqKgcxzESHGHGVAB8lMPm+Hp+Zztd2Tw6N9DzYYHNyqXc7WEvtY7fpZDqA0SWUYR
         1zF/+XbIqsPsKd15j6uPnFqLs+QeXyLv6BH3k7v7iPwbNuE0m8XXeK8JkTk9bhoh968n
         WhFkYvzfORiu7Q+W+i62a/R036xTj1Ve9Q6syFEuz5Mw6H97dp8csBjNlldxr4cGUptF
         KQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727964299; x=1728569099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tx5oPoUn5anZwJRYXD1zf/fnqWWX40jtN18OT3B7mk=;
        b=ncQQJM0Z/haT51T81CAJ0z6eIcQn28Hv5vgCWWtjwN+xjAWAWva+F4gmfZL3O4aIGu
         85jOl/9ohGnzCRPhiFIKc+7B3sdraWyfpKE29By5ncrTcqT9ETEiSx9WvMtglJMIkLfq
         JuyW69jI5ZBhXNd3LYdDO9JLzD25LldYZEtJXFvMJkx4hd4OIv9MRX0MkIpKHVdSiLD0
         KSQ0V6anmaCnjF1eXFrLceRySXGNjwMmQrJrCPkeea+KyX2X/tRHizEJyqI8EnYLubKX
         uxjuOmbco80uE1giMDafbrJw+RqMiU5HEMTkvS12ys0fWMFj6cTFwNjJkVrxOnTW170k
         y4LA==
X-Forwarded-Encrypted: i=1; AJvYcCX6iyHtziPFLqB0bOW3LkNwroy++SuFOW/F3i/uDNwJsFwfjMhFCw7cCH5vZvOP4Tnx79swz7r3oswvbBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC35gWzqUjNgT1ZD7TGZ+SpozvjLgPcSSRXYkd3PjMWdkilAO6
	kXU4fhk+A1IvCXfLOHuviqQEkuLpfF2pnvOhlN9kySBZdMCnsd+Ez7ZZY3HbOuorA0yBu+djxN4
	Q1aKkfuCs84h9eAJe9zed0PU9JRf5FOpZP76H
X-Google-Smtp-Source: AGHT+IGgzXdAa7k/k8qWOeb3a60DbipETGQWRCUSmq7GDnHFuqPbeefrwqYaAVUjcZXWCy2XU7w40S12qYMwu7v3GyI=
X-Received: by 2002:a05:651c:1502:b0:2fa:ddb5:77f4 with SMTP id
 38308e7fff4ca-2fae109929cmr44735491fa.38.1727964298159; Thu, 03 Oct 2024
 07:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com> <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
In-Reply-To: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 3 Oct 2024 08:04:44 -0600
Message-ID: <CAMkAt6qP+kuzsXYtnE4MRDUVx4sVpFoa+YwBtBRArMcnAfadkw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> >> +static int max_snp_asid;
> >> +module_param(max_snp_asid, int, 0444);
> >> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Te=
xt Hiding");
> > My read of the spec is if Ciphertext hiding is not enabled there is no
> > additional split in the ASID space. Am I understanding that correctly?
> Yes that is correct.
> > If so, I don't think we want to enable ciphertext hiding by default
> > because it might break whatever management of ASIDs systems already
> > have. For instance right now we have to split SEV-ES and SEV ASIDS,
> > and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
> > enable ASIDs on a system.
>
> My thought here is that we probably want to enable Ciphertext hiding by d=
efault as that should fix any security issues and concerns around SNP encry=
ption as .Ciphertext hiding prevents host accesses from reading the ciphert=
ext of SNP guest private memory.
>
> This patch does add a new CCP module parameter, max_snp_asid, which can b=
e used to dedicate all SEV-ES ASIDs to SNP guests.
>
> >
> > Also should we move the ASID splitting code to be all in one place?
> > Right now KVM handles it in sev_hardware_setup().
>
> Yes, but there is going to be a separate set of patches to move all ASID =
handling code to CCP module.
>
> This refactoring won't be part of the SNP ciphertext hiding support patch=
es.

Makes sense. I see Tom has asked you to split this patch into ccp and KVM.

Maybe add a line to the description so more are aware of the impending
changes to asids?

I tested these patches a bit with the selftests / manually by
backporting to 6.11-rc7. When you send a V3 I'll redo for a tag. BTW
for some reason 6.12-rc1 and kvm/queue both fail to init SNP for me,
then the kernel segfaults. Not sure whats going on there...
