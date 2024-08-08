Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5A13DDD9
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723142146; cv=none; b=hSOJjFQMSvEbqgvplUgDhdnRstGatvYo9eAtv9KaE3290NRTztgtPrP+Z6U8sxDJJBgHKpRMd1KjadiFseuH7q0oRTuQUhKmaAAEbjw9cpy/cK4P6p6+z9j+CYebgnwnkACjQHNtwFEVhT7Cju0q5GrV4B9UslBmcRmaV0hLbYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723142146; c=relaxed/simple;
	bh=02kwCYOxv+z8OLO7RIT/t+VnaG6BWgvfG2Dcw80OmZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5xOCkWBECRAIn4CDpiJI/1Qx6GuPzkIV1REbLjIWRkFiGrZnRw0B2o9Osamfgs4SCww/fPzNjBA2Su8xXEgXsI+TKrSKY0ZsOigdnZ12R5Ti9nMfHWx/2BjT/B1B9E9mDZHximScjh+mif3nI3t26UoGU7h0QNBmFvx8XsHqWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QXDyT0tQ; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QXDyT0tQ"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52ed741fe46so1415516e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 11:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723142142; x=1723746942; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+fJFJEPSzrBhC9abcg5k3SeAn9QnXTSYxtGiuAtcArM=;
        b=QXDyT0tQF/gADTMyKhBBMuD/UVBHidiE2GQDDUjutb6q0zIoiqItJega/J1O88VG8j
         rAeBiKDIMotW+iULhkUTkcdmk5b7sMwtvcrbSRFjG+bEuMDdeOAJnDz2Mar3OGJQZNUx
         O9MVh334ukKY1Hab2fB7nwAH8b7yprwhbe+p8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723142142; x=1723746942;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fJFJEPSzrBhC9abcg5k3SeAn9QnXTSYxtGiuAtcArM=;
        b=Z/RtZptxE8Mp9+gm98+ESmXGo8Ce1qn58l+bWPGC34TlutVvAakFAccjaOko4vWFmn
         N8/U0kf5GIkkAELmXuGJlSNUe5qpkbLzmc2uuovnCBEWq88tJrPG3liRxPe14iXb3zgL
         zjVLl2KlxqAaXoijPjto/TmPab+kygtdXy5M9+nif5dgVjyfp/Y8/UEGCqfCmWcfaxFd
         PgILfRiodBOsSexD21szlmhgrq9+qxoESfY5f5ATW6BFWRt6RxyplAFzKak4PysU4X7q
         VgY08btmHiOLA2XAx1YAJZHsohlWwSZKwss8s79cpJEPVNTNXhrmnhi9X+DVbLx9Dwh/
         azhw==
X-Forwarded-Encrypted: i=1; AJvYcCUVPkkH9NPizJWbNBIM03mfUC8IEH7KpKY5pi8Oba22QsfKmqGDBCZVQePU9LPAV8VrnnDOnhx3LHfu7UjusKCXvyNicroO0cN86u9Y
X-Gm-Message-State: AOJu0YzrcfdlL1egJkL6t4gbR42c3ud8rKviuLwNcn1IOWtIPdpBvBtY
	wGm1ljXl0DvwZqVKqk9DnXUW0raZ/ShnhQu4xPRk1uSe5m4xRZX8qQNAP1+zyLhpYgFFCnaIFFn
	bKoBu4A==
X-Google-Smtp-Source: AGHT+IGDKelN0fuXBSpQZUDcYLuCVi6ZThnHsjaypuQxAaGj0+EPYNC4PLr+G/cWhFyilzGoHRk89A==
X-Received: by 2002:a05:6512:350e:b0:530:ea7b:2944 with SMTP id 2adb3069b0e04-530ea7b2afamr285223e87.33.1723142141338;
        Thu, 08 Aug 2024 11:35:41 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-530de478d78sm723367e87.255.2024.08.08.11.35.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 11:35:40 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-530e22878cfso1182632e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 11:35:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX/cl30pzZEn9/tEMC264ptk3i3RW//FSKs2LrL9trclE/ZwIDRUpQhZXO1S+DTHUrvw98MPHQfI/yljHOnbqDkfm0CHBL+2T0rCeBP
X-Received: by 2002:a05:6512:2808:b0:52e:9b92:49ad with SMTP id
 2adb3069b0e04-530e578b384mr2034089e87.0.1723142139967; Thu, 08 Aug 2024
 11:35:39 -0700 (PDT)
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
Date: Thu, 8 Aug 2024 11:35:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKbastNQ1xZOpOkwzjz7Bhb-vPa5OyLeMEsTeQcKpxew@mail.gmail.com>
Message-ID: <CAHk-=wiKbastNQ1xZOpOkwzjz7Bhb-vPa5OyLeMEsTeQcKpxew@mail.gmail.com>
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

It's like I have a sixth sense.

The wait_for_completion_timeout() test was entirely wrong. It returns
the time remaining if it timed out, not an error like some of the
other ones.

So t needs to be

                if (wait_for_completion_timeout(&idem.complete, 10*HZ))
                        return idem.ret;

instead.

Of course, it's only going to cause issues if it actually times out,
so that patch "works" in normal situations where module loading takes
less than 10s. But still - it was completely buggered.

               Linus
