Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942E33398E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723146872; cv=none; b=dom454nRF4RXC5juhn31IcEH2O7hGoVrVypyJCzyCsx8qgOPhWvLMzb04KsO8zFFO/HC5MLkVJDwmxlq6qipmsXyy18VGbhvzAAVMMB6GH29hnbyFcyBw0g8bn+5KoH9CHf9HD0AbB2zR6SY6lwn1sNFWftqoNd93/7IGvWHCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723146872; c=relaxed/simple;
	bh=8ck9stzaxoY/zwqEhcvEsG+wxaQzwrnkAvI4YYr+6ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/DguPTDA2gcYaWe8gH3IJYCPQzK9f/kuj6VZ0mZrBWRB4OJwHQrS+DMSYmMae6yBz+2z/K73IM61swZxCIrik2uXIGJ9emVFvpKWZPkZT0io8o/lPC6Pv+4u7QoCghet/rooFLy4QYdElI3oi7q2RYYiDjt/zlRD6CaWJzhVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTrQZtZx; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTrQZtZx"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7a975fb47eso159241366b.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723146869; x=1723751669; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7SwZ2LyzeAh2LP/WBHvw0dGjR3AssNzuYIz0wycbR0A=;
        b=PTrQZtZxK2K6N0k/7uD+s0DmRcVu13lAnQpoRNziHK8hINL+oaAfpE/urgDTQeHq6y
         bffubApbEhnvYO/hFT9zJFZLKfFyx+2WBv0uR6DyUpcvnXCIt1XlHHV2c0TPeALWQzJO
         SaPvRb/IH5SC/xff9vmdxxAsKw3MsuzyV31gY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723146869; x=1723751669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7SwZ2LyzeAh2LP/WBHvw0dGjR3AssNzuYIz0wycbR0A=;
        b=Lz3s5KEnIa+xpH3hThHmZxmV7u2J8frT1d7xq7aVNTJlm6TIh57nFUnrvKtUBvElFz
         GWT9tjlDZCYtqyzYfo2IxNf+3ubukV/MILydDYifu6KPWWGWvM2CRsSkbz03LMgvzY4u
         ew0F1Z6B1uNdQkxRCNfWrtA50LpM5WhY4qcf+tLQLamitme1TrK9RiY97+AijStvhHRw
         KjCUfvjUp4ige8ue0FruV0Dd6okdNEa4ezyAw0uCjvdPcaHbNSgiXWuz9mAP17yM2eyc
         9a7O/3iILNa0KTmwltViYO+pHAyDg52jxAihJcDEcceHP7x6qggG1ZtDblssryf6f357
         WjHQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Myg/z74Am8RGF/KgHpv97q/AZMzIu56BTCTgwEeXHBbn5jzn53GCkFosqB4Z7B01YSHzZhKiUwwl5zE6Bj/aMUuLQLlbAo868piP
X-Gm-Message-State: AOJu0Yw4Lt7qCy/wva7HXsMZ3mHVVVeTj0mWciGG9FszFzT1pW7q3evQ
	7rOi/bgq7P2TWIRm/YNTuSu9t3tR/YY1yv9paI9vssU0UTp99W+QDAzFIk8G3j35flwpPolnh1q
	Q/y5waQ==
X-Google-Smtp-Source: AGHT+IFz7QpNRQoWJo6BmS0QPEjYjpBcmjeNfE/9tNvmSzlDYynxPFcfzLd7nviIa7s/9F8w0pL1rQ==
X-Received: by 2002:a17:907:1b27:b0:a7a:c256:3cc with SMTP id a640c23a62f3a-a8090f03df5mr193442866b.67.1723146868599;
        Thu, 08 Aug 2024 12:54:28 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9e841a7sm778903566b.179.2024.08.08.12.54.27
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 12:54:27 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7a975fb47eso159238066b.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 12:54:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXtQsw0813HioO/4o4EIFfzUsgEWXoMXoNy/voeW+rK9EBq72KTQ7B+MmoMvZyevLrQoDJwOxmR9r2cvB6yCu/6T6hLWmjII91+H6mb
X-Received: by 2002:a17:907:1b09:b0:a7a:c083:8579 with SMTP id
 a640c23a62f3a-a8090ec605cmr234215466b.62.1723146867065; Thu, 08 Aug 2024
 12:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk> <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au> <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
In-Reply-To: <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Aug 2024 12:54:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>
Message-ID: <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>
Subject: Re: [BUG] More issues with arm/aes-neonbs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Ard Biesheuvel <ardb@kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Aug 2024 at 10:14, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (Please note: ENTIRELY UNTESTED! It compiles for me, but I might have
> done something incredibly stupid and maybe there's some silly and
> fatal bug in what _appears_ trivially correct).

Ok, I fixed the stupid timeout check condition, and I actually ended
up testing this on my system by making the timeout be just 10ms
instead of ten seconds.

With that, I get a nice

    module 'hid-logitech-dj.ko' taking a long time to load

message about the "problem", so at least the warning seems to work.

I've committed that (with the timeout for the warning set back to
10s), not because it *fixes* anything, but because the warning itself
is hopefully useful to avoid having to debug issues like this in the
future, and because it also re-organizes the code so that any possible
"break dependency on recursion detection" thing would be easier to
deal with.

That said, the *proper* fix really is to make sure that a module
doesn't recursively try to load itself.

Because the thing that happened to make it work before the "wait until
the previous module has completely finished loading" was that we
*used* to do "wait until the both module has _almost_ completely
finished loading, then return an error if there was another copy of
it".

And it turns out that the "return an error if there's a concurrent
load" is fundmanetally racy if the concurrent loaders are actually
concurrent (not a serial recursion).

The race is typically *small*, but when I made it bigger in commit
9828ed3f695a, it actually ended up triggering in real life for modules
that had dependencies and returning an error before the module had
finished would then cause cascading errors. So the race does exist in
real life.

In the case of the actual recursive invocation, that race isn't an
issue - it's all serial - and returning an error before fully
initializing the first module is actually what you want (since it
won't _become_ fully initialized if you wait for it).

But basically the old recursion avoidance was not really reliable in
other situations, which is why we don't want to re-introduce the
"error out early" behavior.

I don't know the crypto registration API enough to even guess at what
the fix to break the recursion is.

Herbert?

              Linus
