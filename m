Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183971DF961
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jan 2025 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190902; cv=none; b=Z3QvVUwlqWn/G2ZgcGMP6qmo2EIFgZvIA1jHGAJXXdB0493h5VSf3YHHc6Th79EiVqfryAZBHHSI7aNaoOHQQzVgdsRY5Ps7vPyHh/hmAHg9K9KWPZ+MLxRUb959oucwVn3xNJ44/GpKA6Gb/spRA6zWLbfbTz+DKOQrVru8Fg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190902; c=relaxed/simple;
	bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDU4TFm1IT6tinaEpkvtCF43yrXSHEa/2om7TO5JQJhKfegCtpxSjqhY1CN48v6b/8vLT4iFSDQOAbydCnElg9V9Tz0tTJmQPmwsgIEkTsfqW9tBxshxyWzv0keSsrD7n5gDHXWyoK0nSaKS/9gngbiMyzTJSHhZWxA5lOMx0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTK5aPRC; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTK5aPRC"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so2446562466b.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 11:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736190897; x=1736795697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
        b=GTK5aPRC7/cKa7+d33MjPm9byv/K5iGH9IVp24QrrWVsu1X2HTgeaUUya1ubVBDeqN
         JYVZR+T+xWLjMVbzRTLWczvGUd2N0DT0rSimEJ7JzT/CxVFMz3roXDXLWRsyiCtFDu0j
         isLHXZphsdxfEMP7o7WABVPz7wPoe7Ar+Bt+Jyl5CHt62Ke6PEcwg9lRNkxMzl0XGWla
         qboaovGoZ2GpLzTHIPA6Wdq7TyractE7DNIvF+k1BNQnyj6LF5oivuLWILBBXiswwQmp
         bhbru+tBSFDcBIeoN1WvSdj9jjmu1L69XBY0XZahwwDHnrmjMnOvlxOJAcenNy5KL6DG
         gCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736190897; x=1736795697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
        b=bsNd2m3lyPfK4Mev9wtZRRuoFxKbZR5BFu2/E8slmc8AZ+p0RVkV8cRTiuvd9ggyNc
         Mo0e6+FHKrScczC3LMkloZRmiPT6HHxCdljxb8CWyGHBFvPpEBBg/Aq7vk64nM1i38wp
         DSvS6RTVksYel3al0GqjVhJktP9WWQqnl35b9dQVntMnJ98/ciNuhlUy4E9gaZzgKk3N
         hbR4MmqtTV9MGrczMkirSjdvP5rCvGk6VzYfcNes06OWJmHAfhRy+OyfNs20Iw/WLPqB
         Xzrjv/r3K1zFhAS8CHFoOVAnOGQJPTAEcrz07qsasPh77zrruNZgqcvEs0E5ODJcpPD1
         TsJg==
X-Forwarded-Encrypted: i=1; AJvYcCVqz7GsGsmHtNj8h8vkHhFfA083yTJUyuIg7ovsSlkL1BDbKbimJdzA6x9a4FElZLEj+ndw3mqnB94r000=@vger.kernel.org
X-Gm-Message-State: AOJu0YymNR6UyXeCv5DEz8HfUhbAmFI5EYreOPeQsiJGVR9/xGwJandJ
	cRe6KexyUPWY7PtHK6p3+fRseRDXGeXWiuEotfx2tWdhvJMQadaY+K6UfnpVEcKJjO7SVvP5nnI
	CXeBbV8f9U9uJEEKm5z2WzPScDrcwuX7jKAqP
X-Gm-Gg: ASbGncvXmXXd6Etj5Krl3p35YB2y70Gd55JtB7OItqirtiJMSTiVyyu4pd4JN0SlP4U
	5laIeVZuDTxzltEH2lthShpCaLowy7AU/xQw3KxM=
X-Google-Smtp-Source: AGHT+IFQF+5hodEi32H1hrqQbRqo4lGqqJT4JUu9venDeqnG5Z/fmBuRxtxtizB6jozSHAAECXR5Acsg+MTVa4cBYlM=
X-Received: by 2002:a17:907:8dce:b0:aae:df74:acd1 with SMTP id
 a640c23a62f3a-aaedf74c300mr4344217066b.11.1736190897042; Mon, 06 Jan 2025
 11:14:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <da32918b84ad6d248a0e24def7955c0912c9cce3.1735931639.git.ashish.kalra@amd.com>
In-Reply-To: <da32918b84ad6d248a0e24def7955c0912c9cce3.1735931639.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 6 Jan 2025 11:14:45 -0800
X-Gm-Features: AbW1kvYLvnLWYWHAYDSxy7Fc949x5JRieReC9MaIJohfifoZer-rKc9QHEboxOU
Message-ID: <CAAH4kHYsK8Uc2WePxfpPm=hwCybrABTjJ5Cw8rRGJ8UyAyE3Vw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 3, 2025 at 12:01=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new API interface to do SEV/SNP platform shutdown when KVM module
> is unloaded.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
