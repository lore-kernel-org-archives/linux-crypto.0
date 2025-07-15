Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4217427510A;
	Tue, 15 Jul 2025 09:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752570105; cv=none; b=LIZpICW9BMtuNJdvpFS+lna+IcrALbsm3O4eP1rIvdVU5BxZhBVWrAstnnPWIhZkmYDLOklx6eN6t3ibh/+n3PQ8AuzQ8SQaUjoZ7Tims7NyD4py0oLKWo8xBRT62H9FKXPGm3du89zLxRyMWe7KG2NVlYdTFKdf0A/nQGuxGVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752570105; c=relaxed/simple;
	bh=fuOd3nnpezQ3sfAoEmbX/8c5F8SHT/InXaoj+BjRxiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwYIgj1zdKNeqH0CJtli+4DqkdK5YKCuKMqLt2Y8qYFgKBkWtpHo5mjiQYLdVtfgWtoOrTeSp+lbZ1L+3w0oIvM56OmPwDHbUc+gT7gW759uJY+PJHF0gKUiC/vzBQsk2pJGb78UFoZlo+7hccP3T9eJgINnuW+xSh6mxhopAGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XS8crzsg; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XS8crzsg"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4555f89b236so36709755e9.1;
        Tue, 15 Jul 2025 02:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752570102; x=1753174902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FYOrY3C9uX5DWx2tcaLyd3fYk/JwOj1/lQiUcN/Y4qY=;
        b=XS8crzsgEeG5FJist7ljemLeSLJE9TL+c6AfgZ6iooVVPOtBeODrGvsDbr4YXFtdfE
         oBG37T2ZwqP9KcwHKfWRFZarqlT/kXDSO/aAv9d6f+/VvoVgkSg9Yep3MobIERySivsC
         v5wdw/uhhCAJE/wozZf0xhiHesf/hC6Wn2Yh92/QJa80TIiBLlHQ1LRKCIjmiUYY4Ip1
         LmdBpAaadGrRYX6TV7ryw6ETnIrYk49Ahn/junyOQXombG6BZCGMGVRebmoQBc7H7JDU
         xfLDys6Lb6gjlhnVDv2VdOgGA/x2Dmyq0jwSMwD0anoofNZCv+EUjhoTb6yTlFdRFDKm
         UGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752570102; x=1753174902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYOrY3C9uX5DWx2tcaLyd3fYk/JwOj1/lQiUcN/Y4qY=;
        b=LpNjcYifOfRjN+t/kycJqUvLz51pflMLV/2DBESW54tXKoYNAnoOL0oChhcIe8sLQj
         Za2TISrSiZRtSLsPFt98YUP8ymMmg0TfvK8W4h6VCdp4oDIzrUA49f8P6vh+qnzcJtXJ
         DuhwGbrtt3MThS4tLHN4xYfUIWJTwXAFuU5YYrk8Jt2hMUWlEmwLlfKLNLmFLjYMnz0k
         qpxPeMtvf2umAOIn9SQ16MnBpRmeVbEpCeJzk2Kv5SWs3fT+e2QT7fwPBA0B0JdjiACb
         JU+rZ87MvYgVyz0ulWBqGJyv3bvzlyCwS/WkUXc7PS7srWanV5d8k/oD1VR4iYtZf4cT
         N31Q==
X-Forwarded-Encrypted: i=1; AJvYcCVrfMnCmK9csYjwVkpYBUMq6bWtKzH+tOT3PkdwqHWfKaKpQPH6um6z58lcz9e498vAEWvqZp7ZyOG6KBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWQTPWK4tXGSBnDyOawvkPRxoM4wNIURxTGGXBzXLSZF9uZy+L
	juWPvLHLBNB88SqvqDVG+M6PeBltUk2OnhafCPmaBUOY3MLetQq3BvodRCOhUWKZdZtrJfLA0YC
	3YNSiTN893Fy+MYgKB1IfpyQlTRkw6eZHn0F6H4I=
X-Gm-Gg: ASbGncsg8ICh2Kr1Q863puZ5ZGoYZqfgqm6Dun7JAIDCcaWjdc+iwyNV5J9+abWZ93q
	u5bJQvNb9u+zJSh/lIRBarS+Tobl4/WO15j2pI3Qy4DP2y4w59haNl11XCHrt7OY6qNt7Q66Ib7
	93OYEVZQLCthn7DMfkvJMYcdXMrXmy7kdKfkEtd/DDFEV/7TtgNRDJJ+mlUOR+akl4ueFh5nhkf
	R61KA==
X-Google-Smtp-Source: AGHT+IHDmi5vNdNNW4a38pbOpn2VCkEAdlo/cmBFuJR6I4EJyMkyEM1iCQtYRQ6SwnQXzk4v65iTHdFjdW0oCgsEQqY=
X-Received: by 2002:a05:600c:350f:b0:456:11a6:a511 with SMTP id
 5b1f17b1804b1-45611a6a7e3mr70569675e9.20.1752570102130; Tue, 15 Jul 2025
 02:01:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715062401.172642-1-shaw.leon@gmail.com>
In-Reply-To: <20250715062401.172642-1-shaw.leon@gmail.com>
From: Xiao Liang <shaw.leon@gmail.com>
Date: Tue, 15 Jul 2025 17:01:04 +0800
X-Gm-Features: Ac12FXxHgKYTi5qQjpp56bjSKoZPDexSCED2PmJMggXkM5ipk4gm0nExMKdu2pU
Message-ID: <CABAhCORLzrKc6urUp_UOL-OybdbHUs+y62DTp2XxR9LobOqEig@mail.gmail.com>
Subject: Re: [PATCH] padata: Reset next CPU when reorder sequence wraps around
To: Steffen Klassert <steffen.klassert@secunet.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/kernel/padata.c b/kernel/padata.c
> index 7eee94166357..ebb52c6db637 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -290,7 +290,11 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
>         if (remove_object) {
>                 list_del_init(&padata->list);
>                 ++pd->processed;
> -               pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
> +               /* When sequence wraps around, reset to the first CPU. */
> +               if (unlikely(pd->processed == 0))
> +                       pd->cpu = cpumask_first(pd->cpumask.pcpu);
> +               else
> +                       pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
>         }
>
>         spin_unlock(&reorder->lock);
> --
> 2.50.0
>

Another question:
Do we even need a per-CPU reorder_list? It's always used
with a remote CPU id and spin-lock. Would a plain array of
struct padata_list be sufficient?
