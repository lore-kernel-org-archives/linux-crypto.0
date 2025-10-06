Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEAC126BF7
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759779011; cv=none; b=TSDbKyLztXzg8qvjkHBduhNsyxhDIcITBznxDdigu5lFB8yEo9Z1DNMtTiUCfHsE2VTEOEO/6D7Q5NaKk7esbm57pdNwmnzImnxl3uZmVXddpEgE8XBk5svQ6tPsyumDBhLPj63vzq34kF6LAQPW3DHJoH72nGQswNyymGa7Iuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759779011; c=relaxed/simple;
	bh=oJtnpIg+R+qK4oiapz5pJH9B6d0O7u0uKM9fGnb29to=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AICxqX/JBR7jzc6WDdvBXhl9XzjJ1dmRt9nDyCGTctxtlMC7JBLoMPoR2l3fqGZ8qi+gpGpSVuh0kjW1PpvlSf3ipMyRvsNoD8w8wvWDGaA8R3zdWWacOQvjraLkFifctIJ2KhmLO/Cp0o4JDKbwFXyAoFlRV2sEBQwFa59jNAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ME4e2KPN; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ME4e2KPN"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4736e043f9so953450666b.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 12:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759779006; x=1760383806; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fx1K28q8EZoOq6NcrsSqSFqNryQpu7AB3eVtIUWzySE=;
        b=ME4e2KPNFiesQDZAgg7zYJ1BVDkGkpF3lHlN0ZWY2R4sX+AMB/sm6bTPaPSkzAceyQ
         qIMcK6VJPyuIrNJecF0pV15+I8gXe28Qv6i4EZkbI9LbdVTivXRgg5vonQgVdnlQgHlY
         MT1c1qA+1Wa3qzLiN1iBpWvGoUXsvJQ0a2mKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759779006; x=1760383806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx1K28q8EZoOq6NcrsSqSFqNryQpu7AB3eVtIUWzySE=;
        b=lK6yf9Zipw5vcUshrdgHwWpLT8Evm1YXM0pisS70RVmB87v4WE7qHEmNWw57wRehNU
         YnPykZaPKvQ7Ezrk1tYE+OhTnnH3T6RvDWpEVY12yoybco7pGyINx/6zNbMnJ4Q4IfSL
         hZHQvDMwIDs4h+u9+yzs9TYMy6FLInSB7/0sfvaPf7NgajtmyOGtlmvPt9pHAzUgO+gK
         iC1n3ahmWCm1Bi1lrtUjxfsKTJEy4EKTh2lOYV+GaAijxw8Se4QWZB5ehehw1y2ggdqo
         CSfY6OJdK9Q9Umgylszbh0q32uAsw9S3BQltyeaWftdUnGSTxSKPaXuuNETKs6J5NcmG
         Ab1g==
X-Forwarded-Encrypted: i=1; AJvYcCWJJgdUOpcfWi781YzdEnbOT8MnxEis8UuMlWJ3M47LmXmiiUh3TpOaQaCPr/gTBJyxomSvh9jI+OTxE6s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2XAiRqGShPtv8FnGc5gwLVjIDFvFbRet2G9KKeKM8UZ2NtxRb
	JzNeLPXqqlqo8Vm1AV/gwHLZN9qpI7otbeFOxuYlVEGb6QAg+0hOWUGXstlCjSSHbRvhrhdLz3R
	zMi2sYFU=
X-Gm-Gg: ASbGncuPeajpO91phACOxWaoEl1V174X3C8YNJHIjbwsq+P5jESF7FqtKxmOxvVvSR7
	Z8GT4yWYVpGuG4SG3fvv0ygsKW+aATSYVtFQJ2mNxCcHDTDkyslqKifUtLrttoATJncO5mdxTmc
	sWUMxxvsYe8/KhAEP6GtZuSV/SI1Yg5usJF0P6DDQARhIXo2Q2RF8yO6xIrnS/YDGO8s09q4+Ob
	lnCiDNNSU66t7L3KyU53+iCpy+IAkjRzjn2+t6/eq1ARTwS4ei/C2AYmXpUuFKHrFwoAjoFNyeo
	+HdRFGAaWgU6j+PpKA2ExgszzQx7pUT0tbP9KztFzozPm8BqE3nUeIC6RJnKD/J+J88O+fKAnet
	+nAERu7vL/LKAX4/5i5wtvS/u9rz11nmTvo0R1yh1BkVKpSTbPu0e4mH3e5URtgdSOKgUDPM4/G
	6Tz/tbwurbrYKm8O7GXgQxxpV+5CcxNXE=
X-Google-Smtp-Source: AGHT+IGWcQ4hv6B/c0UK4JQho8A0vtdlL3uSqX4C4jBZGwtDUBfy1BqBGc9+rRP4RJ3OSopoMI74OQ==
X-Received: by 2002:a17:906:c10d:b0:b46:3f98:6ba5 with SMTP id a640c23a62f3a-b49c2a5778dmr1682952766b.11.1759779005707;
        Mon, 06 Oct 2025 12:30:05 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b23csm1203563866b.61.2025.10.06.12.30.04
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 12:30:04 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-634a3327ff7so10988594a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 12:30:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXZXIpFuQe+HeB4IgvBknUg+bzGDvN09Voa7MIm2EZHYkL1lYXmQdkn5uKJ0Uf/WFlaL2IvdM++OtE97+E=@vger.kernel.org
X-Received: by 2002:a05:6402:3508:b0:634:bdde:d180 with SMTP id
 4fb4d7f45d1cf-639348de6a9mr15286102a12.10.1759779004368; Mon, 06 Oct 2025
 12:30:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au> <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au> <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org> <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com> <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com> <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
 <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
In-Reply-To: <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Oct 2025 12:29:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj7TAP8fD42m_eaHE23ywfp7Y2ciqeGC=ULsKbuVTdMrg@mail.gmail.com>
X-Gm-Features: AS18NWDFEycobIg3uvQ3ZOEKPRIEa2VRgJ-r9kp-mkVxA6gr2b-Ogc2Dp8E1ZOA
Message-ID: <CAHk-=wj7TAP8fD42m_eaHE23ywfp7Y2ciqeGC=ULsKbuVTdMrg@mail.gmail.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>, 
	"Wang, Jay" <wanjay@amazon.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Oct 2025 at 12:12, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
> Yes, thank you, I've already acknowledged that my patch caused boot
> failures and I apologize for that unintentional breakage. Why does this
> mean we should throw fips=1 in the bin, though?

That's not what I actually ever said.

I said "as long as it's that black-and-white". You entirely ignored that part.

THAT was my point. I don't think it makes much sense to treat this as
some kind of absolute on/off switch.

So I would suggest that "fips=1" mean that we'd *WARN* about use of
things like this that FIPS says should be off the table in 2031.

The whole "disable it entirely" was a mistake. That's obvious in
hindsight. So let's *learn* from that mistake and stop doing that.

If somebody is in a situation where they really need to disable SHA1,
I think they should hard-disable it and just make sure it doesn't get
compiled in at all.

But for the foreseeable immediate future, the reasonable thing to do
is AT MOST to warn about fips rules, not break things.

Because the black-and-white thing is obviously broken. One boot
failure was enough - we're *NOT* doubling down on that mistake.

                Linus
