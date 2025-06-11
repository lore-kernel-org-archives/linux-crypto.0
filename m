Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AAD27CCDB
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749668381; cv=none; b=oWyjo27O0NJ61mi4b71DloJu6z1UbDAh9Aba73CuUug/eEjFmK+papXc3TEP7gsxDmXvPNaBuLalDy8L7sq6Oex0BWnQpbUaNSve/KcOkfrc3K1gYGMgahnLkQ/FvTM46HKeHf69abi5/jlVon4u61AV37fRgufP6xmPxg16bVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749668381; c=relaxed/simple;
	bh=novuMTuhYNzqynSwAmnzr3dM+uqQhwQCtXMewPa/Wkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JkJ3j8W8WQ/rHkATiLvdCI00E1139sV2K7mvyFM2QFNKBIdTw68DYfJJ+8apECviltYAC1cQJ1NShz8TfauMffOEyrG7Hty/j54rDVPEK73eoBTY28ytD4jRRsB2npbMF+JZUXbzANhRtQZnNVyVWrQJGVICC60LYaRdeGnPWI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CGUwc5Lc; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CGUwc5Lc"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60789b450ceso410258a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749668378; x=1750273178; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p4nKI6dictu7VKkBmue+gE/ANqM7N/0dOk6jpGABvHA=;
        b=CGUwc5LcY/RKYUQmw1G93Y6GCRtWiXcYG7pedu+cPr622ChpXEu1BMslwTpWid2zPC
         74d1mPILRllHcn9IiEzRHs2eSI3KKNIO8PuLrpQNXeIEtUTGQzBF82oTDwfR59Qskcoe
         jsf3AP1ejl4BxquhUL1OIR3QgRCjcDq9BSDSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749668378; x=1750273178;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p4nKI6dictu7VKkBmue+gE/ANqM7N/0dOk6jpGABvHA=;
        b=LJbhrE/cvt/eZgZ/qmQs0BvXpWDfB352P3evMqQJDELMVdlLPwnnDfPQisfuPW1diL
         SAr0vxegaiA5a4YWcWUEgpTf/Q4aav08ssZQsBxrCJ8oJBEmaOzmDXtc5hALbBqRkVS7
         pxVqO53vea6Op25Y1O2nhyIY4nVPDplHXWgzh9YjpZo2TYZ8bDn4ukdS93Iq5D2jzrmH
         /RRn+54hl4eC+fyATsMThISwwbMBCRZwlIn0mS9kQ2PVHtpGot1x/ZckWH0f7pftz+3Y
         FNxr9TKnsR2bFAN7NyunAwxbAioMO6m6NOnGM2OUMZlE3dZ3d5cl/bQSQ/bt6MKO+l7W
         2toA==
X-Forwarded-Encrypted: i=1; AJvYcCWpoR4m/tLEXjYLzzQXcRkLEnYZqeAmNm0iOy9Z9E8t38AX1FI3x3NMYgUjP4NsgOxs/zRT4bEoPE5il/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzreY2nN9b/29jiKcBq1x3QQT9E99GZJY6Hr3hMx1sFDXqzJq3h
	zzTFS9u+k5uMNBkv+9rbcoMsA5NtDMQblX3cthNoINRO+TJbb4MOqnCSMRRuRGbRGUALfsfViZ2
	lCEMMoGY=
X-Gm-Gg: ASbGncvsJ7z0MmEf1l7Fybk7RB9/biC1krAztfGiEU6WMhh0xuIYsz749Kt3zEa91eB
	VUFkaZ6k/v1EgX/ByEnYsrndltu7Z6AwhF+pRgXAIBIelEIqRnaoh8O74rbL/Gz3AZsWwErRD0M
	ZYcZIJ7TEONgxSt0xqxfvnWKrw+gqCP//RLA/objImWFAdbv8ZqnhJlRnHyqygDxrP4P+gxQUJL
	V1N7sZMAV3m5MwkPWq+OIky+ikDN0WJmmU8x5ge9+hIfeRI5ngok86Fb+e8sO4356yK7VRVuMmf
	TGSKohpDuFQA71Bz6UhSEC5LHOs87Y+u+tBYKlTFVxrPaxy9QrujSb07NijbazvSYN5KuVs9XO6
	ll/hLSZ34RozPB4zrA3aN6Z7vSXoJQjwhZFys
X-Google-Smtp-Source: AGHT+IG37zc8zktMbvksf1YPYc9otl7YcUkfXVhfngQ0l1KAfAmryj7v8JfSVV1J+uk3nC+xJQEXpg==
X-Received: by 2002:a05:6402:524c:b0:602:ef0a:cef8 with SMTP id 4fb4d7f45d1cf-60863b0502emr1109569a12.18.1749668377914;
        Wed, 11 Jun 2025 11:59:37 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6086a551246sm5844a12.8.2025.06.11.11.59.36
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 11:59:37 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so431211a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 11:59:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUH1wSSvvImA9bCu8uoFoj3y0+D/55vutNC9b65hByG114uAOC0OdskmSlkTnJ4opYLWKsXC/qIGYCZs/I=@vger.kernel.org
X-Received: by 2002:a05:6402:2344:b0:607:77ec:fa8c with SMTP id
 4fb4d7f45d1cf-6086382094emr984600a12.1.1749668376614; Wed, 11 Jun 2025
 11:59:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <301015.1748434697@warthog.procyon.org.uk> <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
 <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com> <382106.1749667515@warthog.procyon.org.uk>
In-Reply-To: <382106.1749667515@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jun 2025 11:59:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgBt2=pnDVvH9qnKjxBgm87Q_th4SLzkv9YkcRAp7Bj2A@mail.gmail.com>
X-Gm-Features: AX0GCFtsLno8Yfd-XNr8pAuQD_5-TGkXF-CBKKMqVdzdI6GXK5Wl1KZHm9JyRfA
Message-ID: <CAHk-=wgBt2=pnDVvH9qnKjxBgm87Q_th4SLzkv9YkcRAp7Bj2A@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
To: David Howells <dhowells@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Jun 2025 at 11:45, David Howells <dhowells@redhat.com> wrote:
>
> Do you want a signed tag and git pull for it?

Particularly during the merge window that makes sense just to make it
trigger my usual "git pull" pattern, but now that I'm more aware of it
I can just take the patch directly.

Anyway - done just to get this behind us. But for next time, just do
it as a signed tag pull request, _particularly_ during the merge
window when most other emails get much lower priority.

             Linus
