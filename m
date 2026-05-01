Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1AE35E940
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 19:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777662290; cv=pass; b=Z5I54PSmlPWdozE5Ur5Hve8bWYjgWyAc7po4OM5VsaNeLjh0Ez5Ds/SYFM6u3BQ3T5SKTBJHaUd/XmYX/T9b+7jf9hl2A4lxyaULvCmBKB0l0xaI/pVvwjs2aEyNBAC6F7iFmWn/X5QeB+KoDqCIwuR1CMKrpaamrh3z9niR+as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777662290; c=relaxed/simple;
	bh=bebv1clrkuxRBvZuRjd20Nlr/TDaUWZ2u175JUHDsR4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nd6yM9Mv42/ol12axeIFdWDQZUbwnTSgFXlQjvV4EDFzvb2lmfP0jC6N2kHhDcojNCdGOdXPFNlNmQZBg9/syTazKMHW0yVlYSwp19YLSSHBxURkUMjUPia1YL4Ys2pWFyLyqi/Voxa3VrvnKFH6VucX0gIoPZZ1yUPisbAOV60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J/JgOXN8; arc=pass smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J/JgOXN8"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-94de68feaf4so1311595241.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2026 12:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777662286; cv=none;
        d=google.com; s=arc-20240605;
        b=c3AlQ4ljJeP9Sr9D/m+an+stfFXvjj9at07w62BD3+561HQrRsx6Nuao6lssWk9AKa
         GlJvywRSr4NvCDy+0cRmp8Y4R8igNRldZ15AZhJJjfx8eh0vWO0+H+YqIvUa6KP1D55v
         8gByi+YEr3eLzwx98LkXMtIy0IQkHEH+tgLch9kAOzVyVMCLtcoRwnYt/euSRSv+Hyt1
         o/ww4N+jDuiG8ZkfwsehHQ4A0DBq26+t4ogUnzQEleWAMKFpbyoWdna/3g6s2UOJ7Rjs
         68qPNvlMiKAKc07y55xBpN6ELvvK7gsxKxM87BfHZztF7xRpZ4y2/L2RdgOpYsadbm37
         OiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=bebv1clrkuxRBvZuRjd20Nlr/TDaUWZ2u175JUHDsR4=;
        fh=sVs2ZGmRNNbt5qF1DCJxIhWYs0WD/bl+8J7d2W6IYnA=;
        b=TxImJIKyro0+9rDlYh16K3CQeOT1EcQxIwLTffDdg/xFbErunoXfIlYVh/wF/N69p3
         DfP7Y7CGtnd6j+l0NBHU3gGXO0ZCgeKRW2f/PfOg2j1uBu4nU/6Fi2BJNyDu5yIqt5y3
         rXx2iB+E1ssFXBK5JveSzwiRI2LLsTV/28xQ+fajPqVEZTFf8fuwuUMzT41Km2aL1794
         61Q6MaRii8uZWRYDMtkCQ1fv5p7Uw8hhBrVveeBGt9O5UKLTKCCoRgySfq6smaJ5BTwX
         j0QoxTD1IGK+d/ZT2KN/K/cAcltXAaY7YNAcaeUP+u8K6laj4LPPR4Kdnm9v2C6vdjOc
         W3vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777662286; x=1778267086; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bebv1clrkuxRBvZuRjd20Nlr/TDaUWZ2u175JUHDsR4=;
        b=J/JgOXN88MlABpE97FGlOeUMQ+TdHEvjppvYJWV5S1sir30FGdOmJU27djaS2KaH7U
         sTeop2sUDRwYVFi/hUaXk9Yg9bkxl63SE7++r/96IzOTUOEIa4gpa07GWkHUwoytERSj
         m/qo+HvZt9HCZSmU/LLB3sb0Qi0pVTezhmSyQcNgwBXmqVaWtR3g0MgCzK4Wek/q7MqI
         jwK9ROF8bF/WlT4uEUaubGn9CV0aLgN+k7nRXEpO5NbgcB12lHVAD4YnVUL86PZurl9y
         X99YkWS9fFD0yjaGMQPnZOdDRzxCCCrvxesq99n/FYfgAkG/0+aRM4Dz8020v/ZED460
         LEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777662286; x=1778267086;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bebv1clrkuxRBvZuRjd20Nlr/TDaUWZ2u175JUHDsR4=;
        b=mQZuAfzysKGHDBO+XxIflmOT7j6lvOE2SdDy/yII6fUBHZiJ2MbQPYpRVmLG6HTW+L
         NoFkKaFGMvUUpEDCDtVyzc2kxK/rpKpsy753MXIvEHqVKTG/TM6rbUtPZuPeq2k4OPic
         nZAE3alI+G2YSJEmy4wGPhrSYQgiE1VqKZZiS8XTSEUHDsTdtT+kemz9OlZ9NWrfdEVt
         sXAAI5NCt6jGKSkAqkAu2Pq8yG8GmG+YJ9WORkuUuY3RkB74sC8aRFpodAXMb/XpXTPM
         RY606nYQ9HKtVX4ULPa56Nr3R/1xL/jpJ/RK5Owlp8L6pSjOhNjlXIkRZ1VZjhVyrBg7
         nqtg==
X-Forwarded-Encrypted: i=1; AFNElJ9cwNx2IICG7dRHDvdSTAyPUV0d9bRvI9+XBPtVe8Tf/eHnAIlRnDa4slwafr4Gpn47AfZZwhE3Db5slm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlezRp5FVmlv0Bxj648We5OCTjIB/K31zsI0abmP7x7yl5GHjH
	9m3mIu4Ew65SSxBIrWRCz+AA+7AXTdUEXpriMCPWZzOkVbKTe1W1Ek+igakZAarRSNfSUC0yD0N
	VCntzAWorvee0AKqi28mlt9Han07mQnYkZNSJk3h2
X-Gm-Gg: AeBDietGtXJmPnqMJyGFD1pVt+Y4x3KjddgMhRwu8Eaij6gAK1dcUceFv10aZmUx2C5
	e6GyMx27lwa2O/ulWBD2uM6yfbdr6h9nnDf6HzLJ+pHUIsSRWA8oRX//Rjz/K5ChxlX/YxTRWKA
	wnjHs1nLeX5BYUhw/yo751SPp6xHXEg6y74GmljyvwLJHq03qIaWL+iPMGsVDIVx3t18usdU/15
	l4LhT1fYqffMDAzSfSvQCnauq1pqH/PEIugmPao0gT28z4SZ5ZnofhrypcinP7b5g3hqW3Ct30X
	U9uvCi8P+Zp4MaAFbV9/KsOAOfJWIuRCCZRFqD6z+RACpZh9EjzGEi0V3AzPmdF8sMFuaUtp3DR
	FSADaVlk/lKjk348=
X-Received: by 2002:a05:6102:808d:b0:618:3503:5659 with SMTP id
 ada2fe7eead31-62d86a1cf6amr417508137.14.1777662286010; Fri, 01 May 2026
 12:04:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 12:04:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 12:04:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <112cc1213834de1ac97c71314a565ba7dc4af30b.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com> <112cc1213834de1ac97c71314a565ba7dc4af30b.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 1 May 2026 12:04:45 -0700
X-Gm-Features: AVHnY4JWJ3U3t-qQAMoWKtwBg2sRUlPP1ctl-P2SiKHJIBgo7x_W8ikUl9ZrtSs
Message-ID: <CAEvNRgFVB_-i86RTanqLEeJDHujRXnKo6OnQXduPCwKz8So_kQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] x86/sev: Add interface to re-enable RMP optimizations.
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

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
