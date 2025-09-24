Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD724A044
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 20:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745052; cv=none; b=oXq/R6ZM29GHmgmWMNPR+wMk6k2iM89vOqqNj/x47PVot9obK7e4YjjvcGUJ8IDPsv11a6sDRPuJx6M8vUpEx651vWi91hxJvffgBCjVOZohU90mc004j3Mmb0beyY4vUm9eAdBOZNhCZ7N2z0kaAqknK6HchsXmeyninZFBspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745052; c=relaxed/simple;
	bh=11LSxohVQLtgYPqV705IwGyhWZ5zTC5qes4PC/XU5NE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dktzVDxqoyiQUEwwhoABibJa3cZwYD0cXJwWwBIJsHNVwQl8MszYycdRLnv6Q/ZLvR/ntlFZ54ySggmlR4kZpUubzjk8HFSrOF7lO75SjLRePswPj4kvEe1c35qNwEaBWA4h0Iizy53ktbLnaqEGlSS4PujvZ2iDJg3EBmWtYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TdtAsioL; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TdtAsioL"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-631df7b2dffso374527a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 13:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758745048; x=1759349848; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KxL1IkdhPFqi7CXmsjucqEYlGYsVkwBpOGWKm6mx5yk=;
        b=TdtAsioLFIvvZ4aD55iuZbLfLlQZ6W4tQTsSymUPQM4a8e5z9/LCH3w6UmgjE87dL/
         7TVp+wsHsEf72FTTaQY699p2GGlsyZWXbUjGVEIJy7wnREtnDnyWor9BNLdfIr5cwWZE
         1DfNfOIKzbER8eiWaRJpg9l9kAtb7/rcVvXms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758745048; x=1759349848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxL1IkdhPFqi7CXmsjucqEYlGYsVkwBpOGWKm6mx5yk=;
        b=g3nyMme4EEVUIQTyRIKwhdCIvL2iSkv11dgrRYqzRvs/iBeCdIHmaSfn9wqqUEznA3
         Vn9DEKeT13LjAA7Pa1u11enxLtpAphY5v4ubFqtAcq9AfoHkZQonb1xKLeXnbjr5uzqG
         pIF+6QbsL8j7+oemAcv7XeLx2dlwNyrABF8NMuypIemtPDQbgyQ6+TH0dYlacCrQH2BX
         OsPuS/DkJj5xHB9wCmhMVaMpukYJEOn/F7xbLlT7g7HTPNfM1k1G6x2sAdY9+w4HN4rg
         wdDD6aHoFuwuuinFtV7cqeoDKWrBlKN6Aqo8Vj3HJFRzUwSWeMBSVcOsjNWhpAnMF+aY
         b5NQ==
X-Gm-Message-State: AOJu0Yx845cQFwSCskwRY5ykOVUQSDeZ9cHDVHolupFmHbynGIVjAJAO
	1ceNlk4FhR4jPcfRs+ReOY5Rog3vN9dxrGGTTaYFa0UIMZKZPSmbhg++ZIv+nfYJ0H4tmQWw7f5
	VmEL7VNg=
X-Gm-Gg: ASbGncvjnoGQbqIsd0oWWFp+2fJyd5XIpJF3fShSRc2cSkbYRj+yzt2C1UQzxUWvN/b
	WdQ9hEZDUpWaBH4Luylz94Vore0puivqa6iPrDXMA/gc44YSR8dpXpJ/7qy0lWYq31N+PCOdeDq
	0Xqe6vrIUmFQm+HtvdxXNJv0aICCW4Uvmu735sceQlTDG0FcxsbPuCzxG2Yp1KYxeKtiR0XYDsJ
	Axvtztl+7+mMAAepAHDk1Vffp1BzeqQDxqxsq/1s+06z2+keBHQz2muygUvunEAveaT9DHC8IXn
	aYc780vBReAvbIvYShVygjSn7GAiXVwXlPai4ME+Cb+nckwqrIG3HUkvUNx1mQYgEp7K2ZFYSh0
	1CXlK7sm8hq+9xYlLB9uvtxX4VW0wGyQxNlIk6mE+LX2XCbkM6SQ88N7+gY2vZlupOHWkH7at
X-Google-Smtp-Source: AGHT+IFOeSHGblJbrnSB2Sgk9Evre3zbUC0q7R4dgSf7MPSa3DiKJ4nxDExh0NNgbx3xxxJLdTJ+Aw==
X-Received: by 2002:a05:6402:234d:b0:634:54f3:2fbb with SMTP id 4fb4d7f45d1cf-634a292cddcmr125467a12.3.1758745048201;
        Wed, 24 Sep 2025 13:17:28 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3ae305csm20513a12.30.2025.09.24.13.17.27
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 13:17:27 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b07e3a77b72so225307166b.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 13:17:27 -0700 (PDT)
X-Received: by 2002:a17:907:7e8e:b0:b07:d815:296a with SMTP id
 a640c23a62f3a-b354ae9a113mr13555466b.12.1758745046911; Wed, 24 Sep 2025
 13:17:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924192641.850903-1-ebiggers@kernel.org> <CAHk-=wieFY6__aPLEz_2mv-GG6-Utw9NQOLDzi4TF93xFAnCoQ@mail.gmail.com>
 <20250924201347.GA4511@quark>
In-Reply-To: <20250924201347.GA4511@quark>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Sep 2025 13:17:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjk5rMWnVt6K_3BSQ=_uEKNaYBs=FZH_fMLKqp9E4G8kg@mail.gmail.com>
X-Gm-Features: AS18NWB-TOLqbEIGYHOdjx4mWxKWbwYfZ2s88AY8lnF0tIKXxGgu95ZpuJakE_Y
Message-ID: <CAHk-=wjk5rMWnVt6K_3BSQ=_uEKNaYBs=FZH_fMLKqp9E4G8kg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 13:13, Eric Biggers <ebiggers@kernel.org> wrote:
>
> I do think the idea of trying to re-pack the structure as part of a bug
> fix is a bit misguided, though.

Well, now it's done, so let's not change it even *more*, when a
one-liner should fix it.

I do agree that clearly the original fix was clearly buggy, but unless
it's reverted entirely I'd rather go for "minimal one-liner fix on top
of buggy fix", particularly since the end result is then better...

             Linus
