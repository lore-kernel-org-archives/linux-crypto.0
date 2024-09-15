Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7510A0C
	for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 08:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726389638; cv=none; b=MDfi7tXTYHnJgAiMUjsN6K4CUWcGvIqxxrCGmZSoKrzui9PrEPv02ueLrEXr/OVGfEwqmLdArRhTCpugeD/vFkCEcuVDLZbTsjCfhAm7WJslqX3wiB9EsTkRckSJSnaszRQwikyRkz8CZ51gQutrbdfyjAzpqU+rRO0Y3Aw63aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726389638; c=relaxed/simple;
	bh=7W4dXzHo6ZsXChruk3vokDJnvUK3D1xdySswkG1oy0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUL3hc3WJsW5fiFCG9Uog93uQY/dLYBSTtL0oxM8lqf5xqabTu4ov0TnhZ0rxnf41zZcrKgOJhA4hkQiGMTH9dpb5KQlY8KDfvOetkntbkcmmNvCCe1AURRvXAoq41dK0v8jmIu9c5quWo3VKsREwWYKaD3QKieR3umTu8shguQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6yRrWLa; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6yRrWLa"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c255e3c327so4359576a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 01:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726389634; x=1726994434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IDDAsPUl2QeVKALO8ENGYLR9AUDsg9hKmMIPotwlIM8=;
        b=F6yRrWLam+fKgeR8gbnXbOQcBeZmm7nZWbGY1/8XCIL1LcDP7Ym11iXQHIGZ5jG+Mz
         Nd9Q0eR3d8VAXQKbGVZee7rzvRgnW402q591O3vhT06YLYc5z7zfG0e498R0eMC71Ys7
         Yh4bchsDMMZJfK4FC/QsY54d2QeUBSu5JZ1SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726389634; x=1726994434;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDDAsPUl2QeVKALO8ENGYLR9AUDsg9hKmMIPotwlIM8=;
        b=YJMtzhgr0LnhtLLwKIigg9FiGMNLjUxoYd+aZcrGJbjiMJXfXh/pLaDR8rqztApLKB
         jt/bUMSlRzja2hEF6A//pZEkY85ad8OiXXayFTVGI7XUifl1uTYKOlCFARMjWtK0TEWV
         ayPXvtmjGq9+Mo9RS8AZ/SOi9x2MXbjuvNIaidFPwicHM4MwM0+hzhWyfLZ6bJDuVnt+
         9dVP/j1JDWk5R5QFzh170vgeQH64VG+ewEiwBB10JvY9F5jUQPmTeshnjUDN31JUsYxe
         W1sZO2BX36Cj5KDne2IeC1el5qrYLXkR7U/VPGaF56lM01prIToB3oNLl3Q5gF3oeHyJ
         lTkw==
X-Forwarded-Encrypted: i=1; AJvYcCXxISnZbUT+SG17pazcuaaR3wmY6ZfHSEgxEvXQI1KythOY+tuaX+5zn0nkQ6DHesnOyP68EKNIdKzEkiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOtQU5fckxFFMRqaKOA4lg9iMrQdIbIcYRtUxHb/kWAlNXb7ei
	3XxAsK7spJivZKG8jmMRSxHexH5TjlejC5+kAJMBUA7WBkvMYRxO5M6xpHkJhMT3fKZj6L68FoA
	BIgkfpw==
X-Google-Smtp-Source: AGHT+IGQR4wP+6ON+iVuqz1YZo1evqavRUIFdvT+yTVtWrmjuBvDtB9xWOubUIfFvrjwWRPvEsGZEw==
X-Received: by 2002:a17:907:94c4:b0:a83:9573:45cc with SMTP id a640c23a62f3a-a9029435987mr1307301866b.14.1726389633425;
        Sun, 15 Sep 2024 01:40:33 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df770sm172541066b.145.2024.09.15.01.40.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Sep 2024 01:40:32 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c42f406e29so1146210a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 01:40:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWRCNanWbSdSP7E2IkUCtJTSDTO7aT2qds1iZwYFjIc++qSj07PSg8DlnNkY6CyGqqm6mUkoLkzPea/urk=@vger.kernel.org
X-Received: by 2002:a50:9b57:0:b0:5c2:58f7:fe95 with SMTP id
 4fb4d7f45d1cf-5c413e5164emr9626495a12.31.1726389632541; Sun, 15 Sep 2024
 01:40:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZuPDZL_EIoS60L1a@gondor.apana.org.au> <b4a3e55650a9e9f2302cf093e5cc8e739b4ac98f.camel@huaweicloud.com>
 <CAHk-=wiU24MGO7LZ1ZZYpQJr1+CSFG9VnB0Nyy4xZSSc_Zu0rg@mail.gmail.com> <ZuaVzQqkwwjbUHSh@gondor.apana.org.au>
In-Reply-To: <ZuaVzQqkwwjbUHSh@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Sep 2024 10:40:15 +0200
X-Gmail-Original-Message-ID: <CAHk-=wgnG+C3fVB+dwZYi_ZEErnd_jFbrkN+xc__om3d=7optQ@mail.gmail.com>
Message-ID: <CAHk-=wgnG+C3fVB+dwZYi_ZEErnd_jFbrkN+xc__om3d=7optQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] KEYS: Add support for PGP keys and signatures
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, dhowells@redhat.com, dwmw2@infradead.org, 
	davem@davemloft.net, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, zohar@linux.ibm.com, 
	linux-integrity@vger.kernel.org, roberto.sassu@huawei.com, 
	linux-security-module@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 15 Sept 2024 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> If the aformentioned EFI use-case is bogus, then distro package
> verification is going to be the only application for PGP keys in
> the kernel.

So I haven't actually seen _that_ series, but as mentioned it does
smell pretty conceptually broken to me.

But hey, code talks, bullshit walks. People can most certainly try to
convince me.

                   Linus
