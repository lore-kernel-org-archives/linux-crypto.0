Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24571DED57
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jan 2025 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190534; cv=none; b=HBOzv5iUEjykAlbh2V8tjZl69y0UjRQNoqB87aP2ch5jp7VRpRylB6UcVS21Bleu3WUIHatGget3k4n2djSVWYBrT31rWewXfvPgyPPLsej79Zqb6Q7U3pJD0a4vkBkuFXWZSwfNONpm4YVmcUsa1GZT9XEFYDS2GwMSqDtWKrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190534; c=relaxed/simple;
	bh=d8IFcpPqpi8j+hDN/5XCv39i3O3L1ryXcw792Dxz0/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GRVdoEYaeqr5J4aPjQBeTIXNYy0P/gLASWKAlyMHw6rtB6V/euWllDDe/Y9skFXVm1bWo3lWSlhZqdzoPWBmQgx4dOQKd+wxrgY5ZMU/nE+mc8DSYd10JXmbY+lcim0QUV7t2AuWnGSK35/H+zyiDAYPkZ2O87YpALhp3tkqqmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ydaPHKE3; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ydaPHKE3"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d84179ef26so1638610a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 11:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736190531; x=1736795331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8IFcpPqpi8j+hDN/5XCv39i3O3L1ryXcw792Dxz0/8=;
        b=ydaPHKE36MNbP3y3Xx5ReCcJI3QTFc+7xqT1MslkWKWhPFvzl+w+j6GHe12Wt6IlNx
         Ft4B4YwqNwypKd+Dr9D19SUpy7OCUKqnKRH+snRYDPdswrRsvjY5iQCTIFM6KQHvkD5k
         YCPpfEBkGwAvdb73plPTyJofUEpjL855SLFR+w+HS+4jwvRA79EGSnbs64HHKGF+AONc
         1pKMWuOLhVz0Q25hTNrfFvCPZ+5AMO/+pB7QH2gjqZ5zKu+VaUwXYsaRZ+Qnlxesffhu
         dFHlch8Q0fX1aq/dyi8dmz+fYVeIDiMgPvtuO+zWSxAzRU2Ce9P47BSlyyotP6xvIsL5
         F6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736190531; x=1736795331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8IFcpPqpi8j+hDN/5XCv39i3O3L1ryXcw792Dxz0/8=;
        b=h4MsoGdvSnbwqRAXqwCqV4jppiHZhLtGbULl1LzAkrPj4JsEL2CPTfShqZy9tJYPfh
         wqPn4UpDpZaB6qsYsEWDiGas2Ts8zYbdmqLuPGmqhh/d5B44h0BDnpKI85GPds1j5jYe
         I/P16dCYQPGLxGNxg2TJ9CbjVXkL5pxRtQrocT6RTJCUmfDoNaYTRMnik4UWq3no9NYA
         OJo5qvcFBntJeNHyFVPFpbiWT2BIaUL8zS1OCBnATAN02A0vYp7JItQAnzKCQt8yGUbf
         UUH8EGQKchCkxIiEyl6HJcmso1chWrxFwe9jiQRbvW134k+Rjs4K+yMqMlAYWtw1h1t3
         Cjzw==
X-Forwarded-Encrypted: i=1; AJvYcCWvR8wBwZSuvk2TMfsXPNgCASbhdYU/nMfvUcJv09epGL79c7gGxwzMFXPVN8TQDc0l625ZG2F9PZFCcjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx14lHjzkltsLp+z9foURyPhEVcyl15+ipFvf2V9t/OFIQQD0Kq
	9a2kUMEhH4F8ydl51o3NuLdYoLTW4UzvqnBC1tgcQSHuBghXS7aLXfWD+CLYckLJyrNGfrfVqlm
	vP1UXXwpqqsc/ym6xJMNnu4RB3zH52owQtznJ
X-Gm-Gg: ASbGncv8Z3m/J0yHa+10c3ukXt7+cER9om6iFPTMpR+gtTVaD4yhnoYSGFMPGYgctmI
	I5onX2/MPl7g228bnMT+2e6D+Ky91R6ZMT6NGzVo=
X-Google-Smtp-Source: AGHT+IGcQaUm2xusETP245F3UmHTIFSyoDHcBqk2tnwBwiaufDKBsyp+BjJtK+E4o8YHQV3okUTIH8pylljhKcy7Pl8=
X-Received: by 2002:a17:907:d87:b0:aa6:7933:8b33 with SMTP id
 a640c23a62f3a-aac2ad82d0bmr6409005766b.15.1736190530983; Mon, 06 Jan 2025
 11:08:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <674affc649968994f95b6259f162d5f0732b102c.1735931639.git.ashish.kalra@amd.com>
In-Reply-To: <674affc649968994f95b6259f162d5f0732b102c.1735931639.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 6 Jan 2025 11:08:39 -0800
X-Gm-Features: AbW1kvZ5-G9CNDDevePk78j3h9GxJgbYj_mnqJjsDLSApjXGAyO5ptX7OVqMJcw
Message-ID: <CAAH4kHaiU8W7zb5oEWghrHTC2XvC4e__cD+6pYMprH9c=iddUA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
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
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down
> SNP in PSP driver when KVM module is unloaded.
>
> Currently the SNP panic notifier is being registered
> irrespective of SNP being enabled/initialized and with this
> change the SNP panic notifier is registered only if SNP
> support is enabled and initialized.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
