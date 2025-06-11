Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C05221260
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749664268; cv=none; b=AH+D04GR595KgiyqHHJ399Yxn8ExqUyDI96XJSF43NMU022Gcq5YoMtaV7H03LHpiPUJak6SyrIRhXH98RJWJg2/lZF1esKOaEPGLvparzj+c7bZOGIoWD9F2KHr+odg1URgX+DUTAqFLxwbYotTXraSrhtkzd6cRFwg4+3DMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749664268; c=relaxed/simple;
	bh=eGNFqynuBIFAxQfgXXE+O2+YXzwRJnVxUyYET5WrhRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tPPevGIhpwbVO/ev49hJ0JW9OEtb8Wq1ROHzpWXIzcUsI53qVcz5X4pwWenPdkoNNm3VqJ6C4k6NAgy0O15s8sUALXm9lXp+4Pc/AisBJPKQ2Um0Gc2of8OIIqk/ctlSRtPrmx4fxwiQqsbB70LCModZLdLcFsysCt9dXElSUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eeP5QqJ1; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eeP5QqJ1"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-addfe17ec0bso240862166b.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 10:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749664264; x=1750269064; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sNMRIvDjI5OxxkQoJ1BipcgVGMNLMdRP7oKxRHfqUb4=;
        b=eeP5QqJ1b6ERSQKr1GBNBQKslYpzvk9LwnkRhPaZ2m5glIcw0t4tByAVZqWGmTNz5U
         3fxh5rBma6XHiwkNFKO22zyl6S2YDaIdl6cF8pG8HRSa3jVE8y129w90mfIoBLTgOgQg
         n3yagfjaBDWlnqiDPpvR4LQi39Et18L9gGh9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749664264; x=1750269064;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sNMRIvDjI5OxxkQoJ1BipcgVGMNLMdRP7oKxRHfqUb4=;
        b=jGOTOb2P+Z0OEvoxc4cbOkKzFWaUuo3nwlvllvTCPAYxxkgPnLRGbNl7u0cP5SCYqZ
         D84/I2PSOi0uqNMGOWT3heiwYt6O6X3yu5dafdtNJDOlDEVRIUOK1FICMnxtQVfe2RQe
         pDV97sGx+PB6EJy5yBFlwU9E+rct2hKkC3Jn47DvKlfy2oysn/EFdZ+xIQgapuf2NrI6
         iKH5MBGO1Xi2vSsjJx4L4rSakfqWObBYPL/HSkE6TfGQATtS/4knrDCclm1ZXVwQFC3L
         yjlW/KgmLfls+YLP3PbbjzhlYbi+X9M5shhBu3eP8cLoLQm0LvaHpCbKtEv0ExyV+eDC
         ozyA==
X-Forwarded-Encrypted: i=1; AJvYcCU7pr6NFNgRUSFNq8k/bPTQQ7Mvz88esyBEps2Eu51t327UicrGJpqLGnySg8WcZkL93TK1q8vZOqTAtIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP9MKYrIpLuxcRmKo15xGlfxsoz8xvtlLG/4bqO/b27DPl13Ln
	ICKu5SFPLFBK+2YRP8Nd7wzCoKpfrTg9mR1Ui3OY4K+dnnd6nnkumucAUSC85Yhfsoz+I8AbaaE
	V5S7SYgw=
X-Gm-Gg: ASbGncsfMl102cee6l+hXMAkgt+9NMNOzlEOi7kzheP33FUG59a3IVYCYBxIfmqRPM+
	N1Y1+hJX+FZvzm5QOc7Wfhmajd0xLyWGBGQGr/tcwScz1XE7f4Biy+Yntr/FXWiSWUmkylY+mFW
	Oc4xs9XtEXxkpfky1N99iPgpAbKVG8SELHjfCC00tgzNyMUpKLLEs0/q0U6yGfixlxcN+ACunDS
	/HZPzjm3S1Zj2qAdvRaJBRW/vWYl/Ac+s+zBOtPhQT19hGNJJBUZCgbUnJCSSFR5WtEm5lNqwYY
	wi4PMBI1GOzZFelOXLEnJ6zib0gHILkyt77al+sUvtzedbKbcdatZWmHH8lu3tXQXrovUAVgKUN
	SQXIXmXMxlerUsFJt69st8b8Xc9VnJrw35CJl
X-Google-Smtp-Source: AGHT+IFFYIUcE5opqZCMGCQRgnxOIgsKPqvn7QgNGUv5jpbB2IbH9nZ9Yx5Ll5tLoKAe0udcsEhoJg==
X-Received: by 2002:a17:907:9809:b0:ad8:af1f:938e with SMTP id a640c23a62f3a-adea569eff2mr34890966b.23.1749664264260;
        Wed, 11 Jun 2025 10:51:04 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1db55ab8sm926801466b.64.2025.06.11.10.51.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 10:51:03 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-607873cc6c4so169164a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 10:51:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVYfQzqA3bGSQSns0p7QghzNDUsoXqh+HuTtPD9+dm6CqTclCqsTmyf0ktZWlprK/vUYo4caTmbqQWupME=@vger.kernel.org
X-Received: by 2002:a05:6402:430a:b0:602:a0:1f2c with SMTP id
 4fb4d7f45d1cf-608666342e7mr349953a12.9.1749664263059; Wed, 11 Jun 2025
 10:51:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <301015.1748434697@warthog.procyon.org.uk> <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
In-Reply-To: <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jun 2025 10:50:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com>
X-Gm-Features: AX0GCFvhYmOiGos_n7MIyKSpEE5Y2P1Gb8BenhLqBoBcFZYUdrTRYSzOg_XV1WU
Message-ID: <CAHk-=wjY7b0gDcXiecsimfmOgs0q+aUp_ZxPHvMfdmAG_Ex_1Q@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
To: Paul Moore <paul@paul-moore.com>
Cc: David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Jun 2025 at 17:23, Paul Moore <paul@paul-moore.com> wrote:
>
> It doesn't look like this has made its way to Linus.

Bah. It "made it" in the sense that sure, it's in my inbox.

But particularly during the the early merge window I end up heavily
limiting my emails to pull requests. And then it ended up composted at
the bottom of my endless pile of emails.

I guess I can still take it if people just say "do it".

            Linus
