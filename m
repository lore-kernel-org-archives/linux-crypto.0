Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABF519F41B
	for <linux-crypto@vger.kernel.org>; Tue,  1 Oct 2024 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727818857; cv=none; b=dLDs1+eFISJFjjVHUCZOIh43Ztk6TPUlOWnO2sGVt8/SR/vr+iVkIfOozNHwB+mBB0VB7MXz7yvVFpXudTLmNYnL/GfccT+188j3O1iGxOMIJc9kQhJv/Z7P+M3mS7tJShESyogR8qHH4lzOzuQsh3qp1aPAPYqR2MDh4sA53L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727818857; c=relaxed/simple;
	bh=4IuiZkHpzDuYZ509owtUOMYOMkM28kYX5oMu/9iARSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O1zl2QDqy0Bg9hkVVGYTugEUBcmz/0Cg9tZRuwaBkTR2uCqS8twXxbkS/Zb8C2n2Ao30YhXMJ97Xy8mOljiuhTezbt+E6+3mbmHweuDCGlHhjf99IZSP5DZNZ9lJrEU34Gzl+aSszHHywWtnxKeCm4yBoPigl75EDwGaYnMDEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AjalqvRb; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AjalqvRb"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539885dd4bcso5238312e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Oct 2024 14:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727818854; x=1728423654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6ZUOGkluVo88+h6EwNIX/y68DTEkY3MNYQDDMOZx1w=;
        b=AjalqvRbeABUu9Ale8PFPDHzq3iWfxcJcZKDmOcB28P3LOWGkydsQaCIWRJCUECTvW
         3T2sd69BZ+3m5vBJkseAADU+GKi4lawAxTaU9eK6ZOQ18ZzIe4cul94hnL+SR7kUcyu0
         EJtzZMhMFnxpNvW/0jhool9uXVQfoipBQH+7zvnA7ge2p/saEZu1ryDo3cY7w+T0R4xv
         ZQvpmshwSwJU15fb7vCJoNt1L67c1WDjj3c062PhUPFWhj1QOFC4l7VIpqLluJQfkzqq
         o604hwn/XANSs00kouIGiWwQXfdrxWIO05LCKc+DXd6OLZLNuHb3qo1b+RDIJjIX4/SW
         mImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727818854; x=1728423654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6ZUOGkluVo88+h6EwNIX/y68DTEkY3MNYQDDMOZx1w=;
        b=smZ0E3xJDpoBF34UjXKnLatqcDdR5bp2/qrz/MBZApSD249IbBhjPiGKIzL4wntzfv
         gduYIkLLiR1LmkAC0Pm2Hyc++sj0n0maWXbclqOkpx0qdVNBP1H0FZ/yETKd7KffV1gl
         0NgnNBq72Xx0Jm71gF1A2Ggwk3sPW4Ewl8hC90oqOX5iW6cf75YuZ5tUSc7uZOHVKLRD
         PLRJwvNpg9foCNK1FT/RRd8goSwTJX8KKP4Be6wwo2q/togddK/yecoLyk+MZdVz1vUK
         he/31sxWkHChA+vpOdlTO51GlDiPWWfD+1B5FlNTd0ff+hRxrWGtxNVQp4bjT7T7HTT/
         7l6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiojPoVXXGmlmz02sqv7l+xjVXHmWqxx9qcaiCt2gIPOMUKkuveJZjuklcsS/KhchUGLNq4xyKb/8ICrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT8uX9aaG+IXOr+O6yYqBbwTrcosG7+lBMf4DbVwKs1GeNw/kj
	AACy2NnM11feDms6obzxilrAa0/iK2lY25kfrzDPDP3kwoZPtgKoXJOUiA/BdFe+Shtorc3bigg
	PM+PXYh9epANhljXa7XMuRhd+4mYagFyeGd2t
X-Google-Smtp-Source: AGHT+IGSH4IxcrGWkax0XWAa+E07aDrZCdoXV4Cm4wdNQjcRBI3kNA9B0iPr/+4N5Pw29L77ZUL5oPKDnnuOLyMwlTE=
X-Received: by 2002:a05:6512:10ce:b0:539:8c87:1e3e with SMTP id
 2adb3069b0e04-539a0675f3amr529092e87.29.1727818853622; Tue, 01 Oct 2024
 14:40:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <afd7d4c5192109519ada49885e9585a1699820bc.1726602374.git.ashish.kalra@amd.com>
In-Reply-To: <afd7d4c5192109519ada49885e9585a1699820bc.1726602374.git.ashish.kalra@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Tue, 1 Oct 2024 15:40:41 -0600
Message-ID: <CAMkAt6paBpDpX0w_0WzXp4KhoiryZ0mCvLZJDZUspTxEvS4Skg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] crypto: ccp: New bit-field definitions for
 SNP_PLATFORM_STATUS command
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2024 at 2:16=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
> such as new capabilities like SNP_FEATURE_INFO command availability,
> ciphertext hiding enabled and capability.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  include/uapi/linux/psp-sev.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155b..dd7298b67b37 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -178,6 +178,10 @@ struct sev_user_data_get_id2 {
>   * @mask_chip_id: whether chip id is present in attestation reports or n=
ot
>   * @mask_chip_key: whether attestation reports are signed or not
>   * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
> + * @feature_info: whether SNP_FEATURE_INFO command is available
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_cap: whether platform has ciphertext hiding capabi=
lity
> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
>   * @rsvd1: reserved
>   * @guest_count: the number of guest currently managed by the firmware
>   * @current_tcb_version: current TCB version
> @@ -193,7 +197,11 @@ struct sev_user_data_snp_status {
>         __u32 mask_chip_id:1;           /* Out */
>         __u32 mask_chip_key:1;          /* Out */
>         __u32 vlek_en:1;                /* Out */
> -       __u32 rsvd1:29;
> +       __u32 feature_info:1;           /* Out */

Is this the right way for userspace to check if a command is
available? None of the other commands are detailed like this one is.

> +       __u32 rapl_dis:1;               /* Out */
> +       __u32 ciphertext_hiding_cap:1;  /* Out */
> +       __u32 ciphertext_hiding_en:1;   /* Out */
> +       __u32 rsvd1:25;
>         __u32 guest_count;              /* Out */
>         __u64 current_tcb_version;      /* Out */
>         __u64 reported_tcb_version;     /* Out */
> --
> 2.34.1
>
>
