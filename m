Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890881A0712
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777660438; cv=pass; b=XXHV6xHKZDrL/ASjfjiNnKTQCYmoQhKp2j4SWToZBSeCqmmKzrI41xp//YSINcctM2LVNxjLaS9oCOxkpESRw6JjFeU6f54duNWRGBn5OgNNP/pGs7E0wvnVLLAKykduvnfJWCdoyZelmv3amwjYW+6ogLVdRxiM3qlFYeFieks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777660438; c=relaxed/simple;
	bh=fqg3WAk9fcb68sFfknqpiSw4c3xDKlkyGKAWTbUwpGU=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8tAQL7bktecLcWWkKmyYeFeF88tzJQ5S1R+HTlvwB6AKsUXiNOuwFOKvxUx2Zty1x/DvNQoCmADXrxF+rCE6ikqztJbzfsnIB7wxhfQDP8VOhoMi4TEyTetEv4HcLP8gIDTbQMp66MirJ+xuOjOAzF9vmOR6wRmVSo0w4qc8wg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vIKlddL9; arc=pass smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vIKlddL9"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-95cd8b71105so1009289241.1
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2026 11:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777660435; cv=none;
        d=google.com; s=arc-20240605;
        b=BsBRgj4pBEL+qaJY5GBzD+i4rjzs/nTrV7CdspSnRtglBlGRDmdkJCjrkjqMgdV7SY
         Y3gcBCnmEJUsta5bVp2pl6u88lPdtDCU2Bm/0M1y3V+KEY/gQ3bFXO+5feF4SlB/J2dQ
         Zg96E1kA1sTOBV94C4GkeaEZ8AlQBtvNgcquv4HFHqaDiS7/Un7q2I10yYY9F6DFgDBo
         akTT6OeBfzLqju7AlN2iM2r3qPcU9A6aBCrkUHz4FYSY9tJOWkH2c1ZvF6Tce2XJ/81x
         NZ5NuUWDHb/jqgtW/iL6YXgUhc77iA/8gqPqB/SMCO/O+da1BF1Pgtgihd+9vqPxkA3j
         FLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Bav75grk2ITDinFEb+etsys3gj6sTaCIDR0vYHpkPhc=;
        fh=SfSb8LQySu76a76jdb/UvwXda2R8mJjxKESAqL1ueBk=;
        b=KGEJecBCr7F34AuJrlFABH3/dpQ9HS/YWx3ariu7cx3z14phX2k9acUIfGYMQU8Mb8
         uPatsAtAPrb7/r/X/DDjjgRtUxIFf681kNDPHsaRCWQ+V/5QKiXNbl8YRe1KUTPof0+l
         o9YVkh1O3qc7UJSNhsY3J+Yc0Q7nKg4n6wlmUVGK7Iweavr6gs25FWavi10x5GIsbBz3
         Jk+BsprXjIb2q40NG84UnKiHSHhAkTtr3cSVigxp4UCjNdRYGsIp0AnL9TxJmQzEIzhk
         AN5wzRgfFGvDKFdzllawIr5hI4m/0eXnUXCJZU34rMmD7/IIR+RV8hhJ6FwkT/OSe1j5
         PEEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777660435; x=1778265235; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bav75grk2ITDinFEb+etsys3gj6sTaCIDR0vYHpkPhc=;
        b=vIKlddL9RmLprrsjfvX2rQR8+RLEk82QfXQOCF3EIgeSjUYnxBIl+qhC4QTQnsHS+/
         XkNK/LnrdPBOsxgaPIxXOhJWkTtRXgZhVuY3Z6Q5Yay41kOfhXCVoeqCC8jxH4UEoBHD
         zMflQtdWfR116LeFGPHeSFGO/xLpYoIYJpswO2O85nfFpIbBLLI4/fDIp3H2tmFCj0oc
         PQhjDbE3A07xq70Jkcisw68FxL+TL16yIKCJ4AIR8DqwfLCr7XABw7LLltyqZk3vHAi8
         qko6YLijfRXB6QSVhmPJT2R3J7VjaGKmh4MJttIkFAUDO38RhR3IOpCYUTAfhstSCCL/
         N7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777660435; x=1778265235;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bav75grk2ITDinFEb+etsys3gj6sTaCIDR0vYHpkPhc=;
        b=AMJldKbiQPGBVvcJ4VQb99+zTiguGm+ht0Yyw/Xq5XLt7OOYsNNrKXkMTUwwVpTk4y
         g/HUrmP/tkz+Li93+RN9vJ1aGnjE+zFs1UTnP/M18Eg/7r1gUIc1XGQ9HZtUZpMFakZM
         Lg1SXpCYJ9X5JXn4c9F90WKWyotYP5C17462QPTarDPaPKTZ/LxlC5wrLUM+RXONmqRz
         HWfi3ZP4tjZvsVTdFX1qgt9qlDYcxof0Oz6XVdW9otxqjk3leC7OfEs7ZYwIOw2xLio1
         lsaWcIrZjrkg5RfckX/zjRC20bGlmQeiN2qHTM+aFS/yCzrhMjvq95grCA60C6ZUdPFE
         61Uw==
X-Forwarded-Encrypted: i=1; AFNElJ93bQEJB5x53mKKfoMBRr9KcV7iOScT7WeLHAWeXdeIHgL01b9yeJgU9GiuK+QjT56fqvTbmKaoi0urrHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwARZ2QVg8mEH6+eEDneVp89zy2TSiN0BrbvUoLDICmpeEr9/xm
	Y3vAFLXcHxp4BkCFwfaibUSstDPrzx6E3QLNMPzFSUjoT5JC9TYrVdfXI2UXdl/85caMoLUxh6z
	oL0e1GMfXgIjig1ECuCtItf4P8hlQ+C1hrs6aXkpl
X-Gm-Gg: AeBDieus7LmuJeLE10zE3gGaPWlWVmqRuTSrWCfyqq6NJW5J4EYQvCl7jtEfEPljIVE
	3MD5kEfVqIFq0Vmd85MJ9fm3fJeKm/UZkea40Bo65BT4s/5pPXsXK/CGBde7LH/rBZzfC6oPpXQ
	aTbYfIF5kO29bYrGypympPBlP8XUhoPsO0gEo1tb4cAfal/s+KzNIO0GybKY75Pw61kyDW3on6p
	5MpTr7pKUc5O7a0tAS1EAbhMX1DvkbOgUzFVQMJckcQmQ6dgVD0wEb2ULuI0YNSQuweGE9ggQLA
	ftemMF37BrJzEzxI3kUIoxszqMfo/sPwPkq6H7dUjdtOqZjveejgJWgphzez0bNAeQ2Ltc6PL9P
	jAzjHgLj70fDu1mc=
X-Received: by 2002:a05:6102:2d0d:b0:610:76c6:b74a with SMTP id
 ada2fe7eead31-62d868151a0mr372350137.14.1777660434999; Fri, 01 May 2026
 11:33:54 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 11:33:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 11:33:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <662ddafc74fa90be6fdf7dba09bccc53f821f328.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com> <662ddafc74fa90be6fdf7dba09bccc53f821f328.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 1 May 2026 11:33:54 -0700
X-Gm-Features: AVHnY4KBx_0gaB7DjfqkDfKW0Ew0L3t0R6FaDd_9Z8Ub7GHIEHP6tTt4gOQ4jX8
Message-ID: <CAEvNRgHE1kVUq4vdFMLGM1jiQGnTMDehkDK1oJTx3vN29-7rxQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Ashish Kalra <Ashish.Kalra@amd.com> writes:

>
> [...snip...]
>
> +void wrmsrq_on_cpus(const struct cpumask *mask, u32 msr_no, u64 q)
> +{
> +	struct msr_info rv;
> +	int this_cpu;
> +
> +	memset(&rv, 0, sizeof(rv));
> +
> +	rv.msr_no = msr_no;
> +	rv.reg.q = q;
> +
> +	this_cpu = get_cpu();
> +
> +	if (cpumask_test_cpu(this_cpu, mask))
> +		__wrmsr_on_cpu(&rv);
> +
> +	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
> +	put_cpu();

I think

  on_each_cpu_mask(mask, __wrmsr_on_cpu, (void *)&rv, true);

is more readable than get and put cpu.

I understand Dave wanted to remove the ugly casting earlier, but perhaps
it's okay now that the cast is wrapped in a function like this?

Just my 2c, feel free to go ahead either way.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
> [...snip...]
>
