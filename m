Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4437D38425A
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787764265; cv=pass; b=HXXdKRKenqRstL1svdmjKPPO7xwnjTFEy2MyuoKlMzpr63IwO7CUw+WsSbWCvCoF8mMRX6Bi8s6DYfYCCI3zgQjqr9DOSc469lLj0YdTe74i9lGH99M7KDVd9dFdtScZd2FhO+6IlQ0/7gu4BQGWtF4S59XNshERzZLCk3XdPyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787764265; c=relaxed/simple;
	bh=zpRXAe/tk52AlzcBOEsFifQ2bzrJm/4BiZ+5Fwp0hxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=clZirKb4zT2cbEKvEgPiE2HqY4wwF1aPmU+VSFl3ajHzmivagyyh8+NQYd84u6DIWoYXqQ8uJUOsMalQQgz5uMY5PH7Muxh9Av3xp82Yzcv8Fi/hfZUITf9S1C6I7UIRi/NaKoFI3C15O4XHn57FtEtMbYSHc1vIuAqyaUtBBPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sO7hteWt; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sO7hteWt"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47db714766aso87996f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 10:10:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787764250; cv=none;
        d=google.com; s=arc-20260327;
        b=oA0ZVYwA0IQdJn+dCugRHgYfqdKjqrdlCQuHXgW64z5TNZrzajInnBRXyTI9UFkIm/
         DUwIOx6muirgZFNaRvATmG+7YQyxGXA/SExb3g+fbMU+3DQP9jxJuSgGUmTYZSpHrgyN
         /E6EZfhryXM194H6+VRr383HVFbJ4OMzJeaiQ3S21isOZHtglFJ1ZJdY2khCrNYbf90i
         xMfzQ/ZBvC0ejj38OfPeTqLn0JyCnWPPZM4VF7iCBwzsgUtqKCevsmFNsEnekfoCciTP
         eLPSXseIstnQpaLvnBei5dOCtaKpVI9q7oCbTaIK5b8xVDNxgVMTdndTR6XCVddmdr9C
         IB9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C33/RTr3a45MhCrcAOe4IXwcMFotPZnSUAEPINGFBDg=;
        fh=JdaJUd1pRJnuHdJ93Rqh1e431ZCtAu4uncHxb54eRWE=;
        b=pi7ZmDbtMwnbmjhFDDpAVDplRhoN1/mwioPceZ/wB+u+CzRqtNb5GVUeCZmnydITsh
         JXgnqqrIKRbVe6jGeA1/UpyqIP27u0h4gCqk3Qo56S6y1W8oJEa4CqgFs7WCeatNd1b/
         ShBAuyEzWhxizi62tlmOGSTkA4ETvC0E/q+VVhlTxi2cGG9RVCFDbvGUg/rSjqFY9lhD
         TPc5I7l1x3u67NWb53+1wFDHAaemu2EPcr/7bkmYkCksfNvQfC26hyVCBMgjPwdsy8E1
         VTooM+HVXyCEGCvKEbHZwDbbwtkVDb1qI1xiYJMnLhIGQplUaOyPP8d1w1aELRbUv+pG
         Q27A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787764250; x=1788369050; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C33/RTr3a45MhCrcAOe4IXwcMFotPZnSUAEPINGFBDg=;
        b=sO7hteWtQBIRfpcJEk78Avuz+RjD1GI3txY5K9r0dCukDfr+3ImEdBxiBJ+tDgafnG
         JHMX7vznlMVbvWvHJbRN+wBlAdi2/G01r14SsSGh6/iZEqaA/fC32dv+82xpI+X5dFUS
         vScJFOIGJX0pv2LAIEPLmRmIkXO1q7qMAI5Bq9iwbrshe0t4li1dQ/q/m6l76iDzUz5s
         YVsbQq3DZjpZtQAYXkoTLdKgTL+A2v57Qr2lmLMiVw+diAswiCp0zdxToLvCNkeenaUO
         UV00KfBYA4LSAdfHY8Ze/n20aprQLWi46fHgEu5Kl2csKI9yBHSvpomvDi5Kl71hEyu4
         KQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787764250; x=1788369050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C33/RTr3a45MhCrcAOe4IXwcMFotPZnSUAEPINGFBDg=;
        b=Imiok8ffsb39pwYP4lpRYmlDk+sxP4/ilmTmDm9v3/f+7uTCKzAL3MqRCmrfP3WgUu
         M7JJ65aLOJlLyQTsF0B/Cux+H8n3OCqf4Ngaj9nUGqPIjBJwuRddtY/mgn+3PKVxtm93
         qR1TKnWJe3MtCkLrkJx+NBiUQHIwTZ8+brU3HjHb9vHNqIWfUHZVnWioDc9e97QkxKVz
         Zd9Yaq1hFNt9E9TyWWO5RDfD5J/DbGN1TdM7kcvcD50cTb9gJ0ndBNv7l51i9d+3dLQ9
         e/45F3FNtNLaV29ZgRQaev/IS6i4hG3UY4PJbKmKMHwNs2OIFTeZaTOp5OTLyOJ+vdBH
         tZ0g==
X-Forwarded-Encrypted: i=1; AHgh+Rp4DnCS8A+7FYDubNxArf+JJ2aZ6bQfDLgGJesqGJXmeAcY74Z9h76cg74knxpoZPMIZtYNuHRx0LR5bqA=@vger.kernel.org
X-Gm-Message-State: AFuF++mh5qqxZeJkUnBa++iQjHVzeXtqgHJJDT51fI4GG4W709QmVR8T
	XZiF4hGnXwgQf1pQHkws+tOX/mx09jRxotIrSShysCiXbSztCyxaKLtmi1fGe7lgROKCDeRRHrB
	L4c+VkNatNrAMqjkCA1FP70ECi0AAdgs=
X-Gm-Gg: AR+sD12X+jM2oVFwancFZ5o5JWKtRN0IyB7Mdv+xUfv++HV2+GvcDYGayKOkhP+/JvL
	CMxSWzA9dvrwoPClJArpMPxL+phiTZ+5ozyHB2c1CsVVSe6WHBlh6n6J/Tpllz+qqXRjKkIpNuS
	UgJZFFDfkUoT6Bf4PVHLEwVCRL7SM78Qp9EcAZW26tRoxWn7q1sFEXCLD+/uDgF/klNtRaXluog
	QQXt2xtGE2i9qpKG6UIdUW9Tv4INHt+/OuPf46iM6QFHm2nny7nVfb5WwP1L+oN7R9bbEX+CjTb
	+KSucT9Go2QGTTupz93Id1cY2iETopnqPSnNZ+6Sj5iWCvzS4J8xjDWRnaxvd40vmFGSq0crVcA
	2iA==
X-Received: by 2002:a5d:6f0d:0:b0:47f:71a0:c060 with SMTP id
 ffacd0b85a97d-482eab5ff3cmr634773f8f.2.1787764250208; Wed, 26 Aug 2026
 10:10:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826122558.2662013-1-usama.arif@linux.dev>
In-Reply-To: <20260826122558.2662013-1-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 26 Aug 2026 10:10:38 -0700
X-Gm-Features: AcwNN1UY_oOpB_Wq3_fowiaqVP0X_Osa5KQ5Tfmau1VqN-lIGJIFBmzzrbkdcK8
Message-ID: <CAKEwX=NRXuqRTg9L3AjBVeaXhm5bxK_rHe8d7d_GUOGKjxC3xg@mail.gmail.com>
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per context
To: Usama Arif <usama.arif@linux.dev>
Cc: dsterba@suse.com, linux-kernel@vger.kernel.org, terrelln@fb.com, 
	linux-crypto@vger.kernel.org, yosry@kernel.org, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, shakeel.butt@linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 5:26=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> zstd picks between BMI2 and generic code paths at runtime, and issues
> CPUID to decide every time a compression or decompression context is set
> up. The answer cannot change while the kernel is running.
>
> It is not a cold path: squashfs calls zstd_init_dstream() for every block
> it decompresses, and erofs, btrfs, f2fs and crypto/zstd all initialise a
> context per operation. Each probe is two serializing CPUID instructions
> on x86.
>
> Patch 1 routes ZSTD_initStaticCCtx() through ZSTD_cpuSupportsBmi2()
> instead of open-coding the probe, which also fixes it testing for BMI2
> without BMI1 - the bodies it selects are tagged
> TARGET_ATTRIBUTE("lzcnt,bmi,bmi2"), so both are needed. No CPU in the
> field implements BMI2 without BMI1, so this is latent. Patch 2 skips the
> probe when DYNAMIC_BMI2 is 0, where every consumer ignores the flag
> anyway. Patch 3 caches the result.
>
> A 4 KiB crypto_acomp benchmark [1] in a one-vCPU KVM guest, twelve boots
> of nine 30,000-operation rounds, median per-round mean over 108 rounds:
>
>                     compress     decompress
>   unpatched         16,756 ns     3,455 ns
>   patched           13,646 ns     1,002 ns
>                     -3,110 ns    -2,452 ns
>                      (18.6%)      (71.0%)
>
> The main reason is because CPUID is an unconditional VM exit.
>
> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c

Awesome! I'm no zstd expert, but this looks very nice. Thanks for
fixing it. I'll defer mostly to Nick (is the fb.com email still
working?) and Herbert for correctness checking.

BTW, I think this has been reported in the past:

https://lore.kernel.org/all/CAJxJ_jhvyMukPLThpgcdCMHwbp3b3bFvc4Va1cK79_3z6u=
bhwQ@mail.gmail.com/
