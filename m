Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739FC38D3F9
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782236907; cv=pass; b=oWLGZxgT2oq3wfzG8hyjbOK7zFD3cGENosGl5jAdIbP8rbGFujUNsO9mSYMf1E/yBM3jWeOn3yI6PAiWB7SNZM333csw2d+hrOltA4D4mShH5T4pBdPBmY2OHDPsQf2DrzQxIRBmtbzSs7tWfpTbIgX7hVHn+Zajr41hxU9r6rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782236907; c=relaxed/simple;
	bh=Y9+yQ6m2SHjTMQK+C809Y49D4LsiLBGTR1bcbiYo9aM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5qmIXKQuGgKFyIPvF6LBFoc8WDJ2cxCYa8wTRGfpwxoYYtoS6s0bmKrcwYeejcZ9CUoHwRWBq9q/vcGBNaEHpZ/Xt3w3uNVeaQfRD1vTDBycf252i29IL590Ono08JLvzTWNxt7LwGenkSQsTQko9ed2PiLZmUnEt5u+Ky7SVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhhWaiYD; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhhWaiYD"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bec423a5265so18926666b.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 10:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782236905; cv=none;
        d=google.com; s=arc-20240605;
        b=L61UeJ+yg9e9sTFi6UMdl7gR43H5WuZeCi0D4v1K9knU4j7XHuelr4vRpXF7atvJI/
         pl2ZD9e62qplzM7OVF65zjf7ahy5WsanqCPKLPiCMjpkFXrgDeKVjfgKBgtrY0ymfFqp
         63rMwJYd3E9+kmBwNUmfNYydtBe7vLU0yXvyN2XIcDTIt8syySFiRv8zy+9jEmDAZs5b
         LL9/6RSAApzfx9jP6bJVcr2AF5UHCmbXH/MqrwmBUHnWuqAsGYs2w2b0/qXbzwFNeC7R
         fAU3gws1ZeDQ60lSVx2yMIaRpUf0jriFooPaW8d8cBvjOpd0qS3O9+2BRwfOckQwCpJg
         Tuqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Y9+yQ6m2SHjTMQK+C809Y49D4LsiLBGTR1bcbiYo9aM=;
        fh=lAa8PGiJ9o6fhYvJDFTEWTfFyeA5VWgU9Q4RBG2SJK4=;
        b=ACkH1u/P3u/whaUw7Neg7/n8ilUsBkge3HKOIBXbjVitvfSDRPliscsHLoMZF/W5r5
         KKnHyoJnxzzd+oBfmTRmFzQ50ukcJbw8tYbEreZLLFA/h+W60kUS09+EdcmPlAslnr2e
         P/hS/rZ+ALb1WQdqvd4L5AVgSSsTw+aPpRGVn33QcX/RSdFkYta5kCvhHZw2ASjXEW1V
         hfGSPJ7NtrgwS6w3W3viKwkwXh+M42UZKraCG8wU9Vqc07n+ffMztV772AuQg5LQf9L/
         ULpIJxnoRTEILpvLccagB/uVSEE+Q8r01tdVdnJwRXuFJHo85KueRZul5lPYkLQy9xVu
         xSlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782236905; x=1782841705; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9+yQ6m2SHjTMQK+C809Y49D4LsiLBGTR1bcbiYo9aM=;
        b=dhhWaiYDMzmVCqcZLo1Ww3Q6RIeRFokXwQ4T1o8H/LynuZqN4Z7RyHZfdXFkeFFidq
         ubPPHyqZQLpsLaqcqa924TbJKj4h4xfhYsUXX+VB4M/+nET5Qzz3YLiGsTC4Thgi1BWy
         PhxiT6s0tCFa6xb/wfz31ZCcdfdj9nQWhKqehJG5ghg70fLZrBfqmt9veN9c6Wa7GlTO
         ADP/Md7DuZuxljNyx05b1jFCB/x4YcvkgrlCrVCmvKX7DYdTzCnju7qmu9mZzRmKlYzh
         S0asHwr7I0Hg/B2mu8qtekrOqBl4ZWlfrdGWmgWp9vKCYTLF3FXzEfoyi/Nk4cqn7I2F
         ehWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782236905; x=1782841705;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9+yQ6m2SHjTMQK+C809Y49D4LsiLBGTR1bcbiYo9aM=;
        b=fNx6wtUNSHuPTwjrIiZUNgDDVyADoq67aHCN2GarkwmbZsCh0J+2jUEeVk5BYSfRrq
         DYvFxA6TS43k8MaOW0cMtw+8TPhVLY+xXoGbzY9DCr3BpjfkGtsItZpXgRue/CfxEEEn
         b7NDhH3iKrh8upbhmeh1dqxudw1bTmRAZMHtLGY19DbGW7xb7WEGUvzFw9BPeQQK//kL
         oYT2cvyy0dpTCHQnt0ESERSDOu02/GWUpRFzGU3XaSe1P2VN9uDzKvRMM+BD9htHunGp
         vr1e8H+DfJGPbkKxLuYMAvSpIExs1dlVA3B3xNUFq0hVXYncvfunCQ4CsweJK3xD0yfb
         iBWg==
X-Forwarded-Encrypted: i=1; AFNElJ9dh71WaLCImNc/XnHbxf34hdZnaQhjKP24z34mRAKkb/gB6d9aGAxVGANDAaDfsTBILo6zTp8qiSffPGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLLPKBqj3oE2bCFboTxUJo22ONZ1OPOPl7rkfczbkDZyUooGNH
	ln0pvlRDhG++OLGeckAIanyi8dN3PB38Tc/i4jeQWoRmBllVzmnbttaToRhi8an9rHd4YSnKqu9
	qRWQrhTCXhOANd8PC3Aa4oZAGtGHUI2Gs+i2Q37c6
X-Gm-Gg: AfdE7cnJ1nu+FGEMCeLOt2q9XzY8EcPLtgXMlFDaevwF8VuzKQfB+EsUTE4DT2NoKuc
	tPL8Hl2wlY7646NrdkyhY1RA/ngjkixU0wY3jNZUGQ3DmGDoBpiWq/AkNTkYsoevaVoBpyVM0il
	4rj8x+gjyUC3kB1BPlWjUV9Bektty7x4vCjRP3IU//Fr1Fm2sWAfm2B4pDipzxd5pqtmlUsPHED
	KwjcL1+Iq8eL9+B49fG8mA8TDdouYTlci71WtR/QR9EGqn+N+UeXyAwJVzXnEhkgMmQBTnjiqZf
	NilG751FF+cWTrJe70lde0CPk6ajozBbsvF5UkLEspa8fC7IE+JLnzGtYICMzEv86QZ4bg==
X-Received: by 2002:a17:907:60cc:b0:c0d:5466:ce4c with SMTP id
 a640c23a62f3a-c0d5466d9dcmr844180966b.1.1782236904428; Tue, 23 Jun 2026
 10:48:24 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 10:48:22 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 10:48:22 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com>
References: <cover.1781419998.git.ashish.kalra@amd.com> <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 10:48:22 -0700
X-Gm-Features: AVVi8CctYJVp25OwZWeFxJ-OUwcfHXzFhyslZieHlTKLg5vqXDjAr-hhZP5Iwqw
Message-ID: <CAEvNRgHDNGCETxLsy0v-_cBO1=1U+tXtOXWEFrXLU7pYz7U9ow@mail.gmail.com>
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is active
To: Jethro Beekman <jethro@fortanix.com>, Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org, 
	thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Jethro Beekman <jethro@fortanix.com> writes:

> On 2026-06-15 21:49, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The SEV firmware enumerates the CPUs at SNP initialization and is not
>> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
>> hotplug can diverge from the firmware's expectations and break SNP.
>> Disable CPU hotplug while SNP is active.
>
> I think this is too broad. If I have a hypervisor that supports SNP virtualization, a (non-confidential) L1 guest running Linux should still support CPU hotplug while also running confidential L2 guests.
>
> --
> Jethro Beekman | CTO | Fortanix
>

Were any other solutions considered other than disabling CPU hotplug?

Is this temporary until something else is implemented?

I'm not sure how commonly CPU hotplug is used, and if people are okay
with trading in CPU hotplug to get SNP.

Is it that fundamentally the SEV firmware can't support hotplug, so
there's no point in keeping it enabled anyway?

Is there some way of supporting hotplug for CPUs that won't be used with
SNP, for serving non-SNP VMs on the same host as SNP VMs, or is that too
complicated?

>>
>> [...snip...]
>>
