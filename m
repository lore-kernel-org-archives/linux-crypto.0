Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B427B3A1B5
	for <linux-crypto@vger.kernel.org>; Thu,  1 Aug 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722535218; cv=none; b=M8Q8k/x5iykQoWd/c+8E9rzrI/OyHFbVSw40omvQf36FjclGNdxP1vI/qCO11hdivY4uZ/O0yGmMRndQSD87PHQQEV29VBszFOjvhZ+6tEbVfzliFG3AhHShLmNse35MuQ/vWobH4qAGXxArttp3NjDJFLLaurcUivgXnV/cmgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722535218; c=relaxed/simple;
	bh=jhGbP7nHvLdw8c3N8ItR7ROW4JPxGIcyfk2Yqpfr4Sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCG1h46F/w371dYSMJud75Mh2aauN2Qqd5Dlg3AM6q7FO/A9VA8zG8wC5JiqcMvFr2seHnqL6W68/6Qd8bMKSD92QC52iP6KVl1y0fE8rpzpGke5q5MhLk4evPfJAHmx5MFx7YIZ4t+C5wMK0O09ed/OJlYTz1c8vPsqJSXI19o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rVrCivwS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rVrCivwS"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7a94aa5080so40851566b.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2024 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722535214; x=1723140014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhGbP7nHvLdw8c3N8ItR7ROW4JPxGIcyfk2Yqpfr4Sw=;
        b=rVrCivwS3O3AjHMv/89tuTSUEKAwyo0iffsyvAy2tU2t53KjmHheWBK5K+pm75TeOC
         v5fDzpZEkclzFeAQJQRwBhhqFWt12VHfdm2DykqgTmv/zWPBMxBWHAZxHzWNL2C17lsk
         ntNVUdROMXFim1l7+98DNtBBwyihgYr1In9y8BAHD4zmkmN9ebD4sbhMTEjo9vIN4B+4
         mF5mUFGOp2ihp4cfPgETTEvjlc7n26i5/zQSpMEmVs7VMFRe2e24+K+S7VnKleBtOpwm
         QC57HKMdkcHhazA764bJ45dyD067QVM2OPouNGKNzcI2jm/gSnqhORnWl04/x2bEsQg0
         6/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722535214; x=1723140014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhGbP7nHvLdw8c3N8ItR7ROW4JPxGIcyfk2Yqpfr4Sw=;
        b=tTsQfWS5ssYgz/kIRZ43oLDSSI0YluCBsP3F55ybOotBoT0vXD0JRlososCMypHnQg
         EXA75ztqOisuAPgFpBKB627NHMYd1bOJ3W82qKXyfuQ9qLVJlQUgqhkxghkJosjCc6Q8
         ypfiiwOMOP8A2WszHsZgeBo1Jt8vEAND13BdDAqI8nD9+In8Jx+rw9kxi3HBZYbEgXRp
         FIpPm5UZ43GKc37SvDk+kVYo8MJCw/y7KEiPYqrfnv4bGaYlN84Ek6kq909IB8tGJhQ0
         cshNdrVfqyvMl+5YrzXz6KTz45jTXOCnA3VEV0uT/Ec90uhkXiLHfzEU5c2eaMl7WhX3
         ppgg==
X-Forwarded-Encrypted: i=1; AJvYcCUCAX0WMPj8J+q85vYLSACBZ3TpYY8EWPJKpXPz1XrB5EFyw5GLBNLTECtEr3wbOFmXUfoHtt2DVm3SE2PDng4cfFClNb6miPnWU5wV
X-Gm-Message-State: AOJu0YxWBRSkGpoZc5wwczbcZ6c4yHE68Vcu2WduXJXzHs8jsoV4vmus
	DzTguOmvDz2nVyBO80HaR8VaZzHWLLFGQafLlohl3/P5QP2H+sdG7sg8KgoYDhhbqSvJCVjstuB
	/XRFZ6+iB7fZ4xG57iXBPLO/1gqTYR5QpCrIl
X-Google-Smtp-Source: AGHT+IFE0cLdxL3ym8WvsUt9Le3O2EWwnFz8MqEAbRvWcP10izGVT6YQWPv3mZsvMOJaaXqsRYFpmW2RSv8fqGG8Ilw=
X-Received: by 2002:a17:907:3f0b:b0:a7a:a2b7:93ff with SMTP id
 a640c23a62f3a-a7dc51bd262mr73976866b.57.1722535213273; Thu, 01 Aug 2024
 11:00:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-3-michael.roth@amd.com>
 <20240801173955.1975034-1-ackerleytng@google.com> <ZqvMnz8203fJYr5L@google.com>
In-Reply-To: <ZqvMnz8203fJYr5L@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 1 Aug 2024 10:59:35 -0700
Message-ID: <CAJD7tkZM8o=B5mGedFpqNL46RRNdmq8FcTVXzS78BrHjGHBzEA@mail.gmail.com>
Subject: Re: [PATCH] Fixes: f32fb32820b1 ("KVM: x86: Add hook for determining
 max NPT mapping level")
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, michael.roth@amd.com, ak@linux.intel.com, 
	alpergun@google.com, ardb@kernel.org, ashish.kalra@amd.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dovmurik@linux.ibm.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, vannapurve@google.com, 
	erdemaktas@google.com, jroedel@suse.de, kirill@shutemov.name, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, pbonzini@redhat.com, 
	peterz@infradead.org, pgonda@google.com, rientjes@google.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, slp@redhat.com, 
	srinivas.pandruvada@linux.intel.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, tobin@ibm.com, tony.luck@intel.com, vbabka@suse.cz, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 10:58=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 01, 2024, Ackerley Tng wrote:
> > The `if (req_max_level)` test was meant ignore req_max_level if
> > PG_LEVEL_NONE was returned. Hence, this function should return
> > max_level instead of the ignored req_max_level.
> >
>
> Fixes: ?

I think it's in the subject :)

>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Change-Id: I403898aacc379ed98ba5caa41c9f1c52f277adc2
>
> Bad gerrit, bad!
>
