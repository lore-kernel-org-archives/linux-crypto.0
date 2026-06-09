Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EF3CF205
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038286; cv=pass; b=LvOZlxiBpfZsw/rcyIDrtbVAj1uFYEwS/WBOal7uelj9PZkcrEvmL1xhk/uuftwYWh9rNOMheHsC2ij7yLTi6tJYHfHLRZZCWgOuefEW1Bofx/b3kBQHK2d7eo0kAC8ep6uZVCHazSQRpM9L2wxFQhaIOhlvaliBBCgwYIBtFLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038286; c=relaxed/simple;
	bh=ClSxD1K8vkCAPi9iT3k7i66zbSZFdEC01r3506BJNO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/uTJmxjLjzAcl+7Zxncf8vfumiFc/rJRV8Sx/RGgJqQWi1jCI1OsOgV9u8D7KWN4DECKHQQlV0UKXm8RgG4xsIQzU2ppnUwIzm046M207QfJGtJ2Urd1dwswcSql9DCV3HnUWwNoYAJDAKSLlaiVnRlkorJhAW6e09/3UedwAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o+mWQHWJ; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o+mWQHWJ"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6607e80a846so6087294d50.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 13:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781038284; cv=none;
        d=google.com; s=arc-20240605;
        b=hDh2dFXudJnwH5FmbbESVUSNMop7VfzAd5E12NsOtPaLeFn1ggaDRL0AbTUC7cjY7s
         1I+e8NzJ5FrYlWptLrvTAqh5lfJhfAmeC8fWxZY7bxl+htekfbAHzAHNtoNw1FVtcP0p
         cZczPEKZKdv0gDUw40VStd6ry5jruXBMZwX1FIpKuCNXT+bpSQY2swrao0fBjER9PRkm
         /RiZW7NfWGT53zkCuMVMozVfJKI4VrTbkLuNC+iqaa63xNwnm2147H/rusaQI0Latrzs
         tnYK9Zy/yPZLHotIzecck7lTQpZx8qvkEz7tOfqyhpjITAc7JMEyVssvA895pDLyLspI
         E/+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ClSxD1K8vkCAPi9iT3k7i66zbSZFdEC01r3506BJNO8=;
        fh=KTBqDYmjxCqh8tCLEAdpCfxdV0UXTgq+Dnbi1t3pp0I=;
        b=SMyBuayFLR7EmMzZzGnzeqQatirWAxDSO3jPzI+g+rQUgmK8Q6aW5GPSKUpzI0u2mT
         TFhToaGw0ckhyol86N+Y8DhXQCkVAsAg/P96HIC/AFCFTVvd2J0PQ7C24qMtZyj8FPtR
         VsxaiKi3H4tf3eBhnwpWgjGKm/S4by47k2aLI+sC6y/cxCD/hONDDjTgPlldVmELhBfB
         +j7cyufJRAe+uPrC0Uth/yM4D0UGIOGvI1ff1YerT5ws5V9rZ2mvBhG1sS+7orX4O+C2
         W0FBS7H60PEUZ+MIIw0hSwPFIqqJrRfFg8x9AA+NTMISPrrmU7Q1XZ7y0f5kj/ZUZ8oY
         N/LQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781038284; x=1781643084; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ClSxD1K8vkCAPi9iT3k7i66zbSZFdEC01r3506BJNO8=;
        b=o+mWQHWJH/5bR2urViOAyK2d2M38ROwXi80BTiLb9iCMsYqrjPoWnnoOZdEkIGnPxU
         ++iJD5vi6QdDs1mS0slel2x/6M3XbfWyZ4wl8RTYRtUl4US+teGLx5dIawXdMsFuXtv3
         xrbu2bAFXjHg6R8cPG6qgKUTApEZsWJfhp9PmzQNfO163pTO1Pe64QNdHN6V3jU6+kHe
         drH1HZGEueRakCcw1/v1wDvxsf+AWyoXv4/KIla5Eb9/0Maoo+vu85gQVSoqD2/WRyJa
         +KytKXA7+Fx5Zd6KJ04FBg6/r2EAVW27tNB/g6Slj0fp6tMh6jmS7EkCLYU/ykHIO5eY
         QXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781038284; x=1781643084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClSxD1K8vkCAPi9iT3k7i66zbSZFdEC01r3506BJNO8=;
        b=KykvQtKAeMAKsh67K0Wa2gIBUcdZAv+Hrm5FZLBXLyPUibL2NrJ3CCNovh2DLJz+Nf
         TnZ34Nbkm2CNEBrcp04In1aQJ6tKzWC4iynllXGTOejW/zTHSv2ikqtcoHW7S2ypE/e6
         OwoMqD+Kk/gCiX/dUUYqiqwQEbzEBAL4yxVNf4hazr12A15/TgvI2l0ecZOEW89nzpwg
         Qn6UQzItDQ30ySmnsq1awNpOwWDvP9mlIXZEGJlao2Y/iQrtyh2rnxDP/xyUizbmMmAn
         oiNRNn67UvhzuDL+vg2ACHivIaK3flwrk3yVQothda2ECWHvJRVLJNkPiiADxGUG0Ald
         WnNg==
X-Forwarded-Encrypted: i=1; AFNElJ+v0M9+y5gcqMJLIjrwKhRdghoe83bv8WluZnISbgEmTWXe/rojvVMrXXkOuZ+7YywwthL+CeQkuXQsLWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxJ85ZroG9lvdFJDvzdTSDG9l333It8oRoty5BDXAq2pVoGFvU
	xODTWQNIEykwtkv6M0FAhmEmIBlZeK8/c0239SNFAHX2/JAqExxxuZ7xDXlsDvEA8vtbYCK1y0P
	7AB4SFlg0H0hkviYwqw2+TPIsrM6EaVA=
X-Gm-Gg: Acq92OHIqhJqFLWI2/1xBRztkFGDNqn8ceMRrKhgPsXzuq0DTa9azygu1NGy9bBeDmg
	tDTpkBBNtanfzkac4Ao934ZKcgM9tOTwbU537NRzH09PjkNs4t/P+bSWC1GYNSVO3wEv5KkRtll
	yJFu3YBT3RAu5YeFhqBL15oIsQ04FFb+3boC1aObvAIR8xOON6LjODCjYhF8wasBJU+eUOXs0T1
	oh04d3U6P1Ts94RQiiguJzlOmRKMIwkVMJoJRcC1gJW4m+B5/h6dG2E/wCIyBUEVCe+Ht+w6+u8
	yHCAlnPeeOI+DwvOGmNPpq/KTk/DLAInx919vrkn3s2iuS1Wf4xU
X-Received: by 2002:a05:690e:419b:b0:65d:7ffc:bcdd with SMTP id
 956f58d0204a3-66106e35257mr17892656d50.25.1781038284660; Tue, 09 Jun 2026
 13:51:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260607112435.42804-1-fabianblatter09@gmail.com> <bd992448-8ded-46f8-bf91-97792b9a11ad@linux.ibm.com>
In-Reply-To: <bd992448-8ded-46f8-bf91-97792b9a11ad@linux.ibm.com>
From: Fabian <fabianblatter09@gmail.com>
Date: Tue, 9 Jun 2026 22:51:13 +0200
X-Gm-Features: AVVi8Cca-quA3-J4YfOnSgwRKiBMTcGlOau3J2ehGVNmxbRYhvdM0tXqWBJE5OA
Message-ID: <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: lukas@wunner.de, ignat@linux.win, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Jun 2026 at 20:58, Stefan Berger <stefanb@linux.ibm.com> wrote:
>
>
>
> On 6/7/26 7:24 AM, Fabian Blatter wrote:
> > Replace the software carry flag emulation with compiler builtins.
> >
> > Even the newest compilers struggle with taking advantage of the
> > hardware carry flag. Compiler builtins allow the compiler to
> > much more easily achieve this while still remaining constant-time.
>
> It looks like you made vli_usub and vli_uadd constant-time now because
> otherwise the loops could be ended early once borrow == 0 or carry == 0
> respectively. Are all the other functions that operate on the private
> keys constant-time?
>

Thanks for the reply,

My primary goal with this patch was performance optimization.
I did not add early exiting because the original version didn't either.

To answer your question: No, some other functions in ecc.c
are not constant-time. For example, vli_is_zero and vli_cmp both
contain early exits.

My patch does remove the branches in the inner loop,
however, the original ones were already constant-time in practice,
because the compiler replaces the branches with cmov's.

I am happy to make any changes to this patch if you like.
I could also look into making `vli_cmp` and `vli_is_zero`,
or others constant-time in a future patch.
