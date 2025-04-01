Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738D1F09A1;
	Tue,  1 Apr 2025 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743506457; cv=none; b=my0LL14LU09E5RE1jkWsAs6pcLbDD6cARSz0RF+ymNWWOaKrOY3GwnDeXS/4Wt1dq7w1IpV+bRTUa3f1emtF7TtY9f/Bp5e5wT89p6KXmUzO4+Nd7VtyerPkf+9ofW23jmOv0i6EdGX2huj8yb7zwtDTEZ9wxOoDvH2wMdiKurQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743506457; c=relaxed/simple;
	bh=eiGtsQFzAxF57nNUAs9/1Tr4sRdk24379Nfq9qrZFco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFbZjz0rLDujkf9EklyII8YdXl39WyMjj5lWakprNh1DRPj1+qyLTrWiAQ1YZBUouesUwgRxrsAeUMWStPfY/shJmRiPtwo+unEliIr3YL3do2bySOVH3iUbs/sPDXqTLD9rdBNIwh0jfXU6tNoJd+hDz6od7k8WAjga53zGpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F9KT85Q6; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9KT85Q6"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e8f254b875so50166026d6.1;
        Tue, 01 Apr 2025 04:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743506455; x=1744111255; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zyYvK18sL7Sms9HOD6wLOj02iesaKqNDYnihADT8IVI=;
        b=F9KT85Q6V+sNoeUC3pzzb5pRvIueA2JYa15FUzTnKXwgG5qANt3Wh/JGheAYECvRbN
         qPCPht0dXWwFkCWwAoEEz0wRVB1a3ahomS7NOZck2q9b5fTPy6GW+PliQBQ3zoi9LBr4
         lUl8bgMMyY91PaQLQEtlvokkxCH9sXzlibl8r7Heyb3RUp7cPInh0S9xuKv7go1iRrUx
         VH2eHDFEWidKIz1r+Kvw1UGi+jkzyrIMoGhjvOzafQ5Wt/BjAW7EvOf5EZc5BB59h2gH
         i8Vzs2rsuZrvsnob/13jFY9mGQnRlHWDcG831B+ACF3HmpNm9D0nC70kmankjG7pBVoC
         fn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743506455; x=1744111255;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyYvK18sL7Sms9HOD6wLOj02iesaKqNDYnihADT8IVI=;
        b=R+adh4t+bbH5GGiHHy0qXvt7j3zROeGgq7ufi1xlpF9UtPFszSp0ZReojdpwrYeCUx
         UX2QDk+vzJICqjqR74iwCclxVsHF6dYeKv9JVLdsKcIlcYpwqxVgAk5MHV8MihibXpF3
         Jo/qn7YaEGDp1bBiKse/UciZNdmqaxpuDRLmFtgzrOfOiCOvss5drx44yfG1byEjiOue
         SdLcDMUEdILAe3ZTwiO6V5giB+ZyP9YUZWNpL7mnXKv3flcq2yRtGul9Uh2JaZAl9NIv
         mX1m3UUIiUjFJ4HC8ugTB3888FZ8gp1vIhznOzyoaTenZdH9Q1UH9WD70IKYmld3NF6T
         DfaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6Ivgy6EwfCmW+GyPAW40EyJjRThLU9MHhhrvw3j2b8s4a2jlnqaBveeckfmD0hUsMZsQ56JscWMe0OHlM@vger.kernel.org, AJvYcCWCSX9jqpUFDUs8kqHuqaQLPG5JEW6/l+SgHCLlTC+CsMljLe5NRKzBYeUcKVJHN2utvSmzLFmWydsf@vger.kernel.org, AJvYcCXsvcfVsFJE1yqV0lHfw8kEePpLMmp/dECiFCTOcFeMx8v56Y2hQgGeyxGtwbV0TG76hcM45zGYD0YGZht8@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/vCzV+Ka8CQukFLy/j63bpn2KlYMV+W0Xk/qod8GvsfFVey6B
	JLTW8/ih3MD3VbIZhvQrLp0VL+z+jmoP0vxz5wvN5mOQznUOtZeTk3fhtli5lOZTIek3EH3NZyV
	TNaCwx1K9uT7CVJDf2tLj6OeDR/s=
X-Gm-Gg: ASbGncsn4lkNqpuz1cHK6hsHyQ+MHjejtEdjghdJfMOXyJwh9jPIWv/NbuKMLHH/hc9
	uR/TxZcR/427TV2Z9UrqJK1C6/MH1wpu7Pxzi5eOw1C9zzEfDOcTEDd7yL1cmfJrj+CkM1QEryp
	gd8/NR1mo+jP06PnqKpNXv8yMj
X-Google-Smtp-Source: AGHT+IGVM4NtvvnMjwPf4ND9jwxgAPzQn9QkZGxSalUZQi1yrmLRglBW7qsxWQ8Z6yPKdl0LpoUdx6JaHEwNgvl0CuI=
X-Received: by 2002:a05:6214:29e3:b0:6e6:6aa5:2326 with SMTP id
 6a1803df08f44-6eed60a792fmr158786426d6.24.1743506455223; Tue, 01 Apr 2025
 04:20:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114123935.18346-1-ansuelsmth@gmail.com> <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-u67D7xl2_SR-hg@gondor.apana.org.au> <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>
 <Z-vGkbmX2PQ_gt7Z@gondor.apana.org.au>
In-Reply-To: <Z-vGkbmX2PQ_gt7Z@gondor.apana.org.au>
From: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Date: Tue, 1 Apr 2025 13:20:44 +0200
X-Gm-Features: AQ5f1JrP9iCrauxAuRFhrzBH1SFUJTtI1qP7DuS86ze821f3jbX2JZfIFOSBW1M
Message-ID: <CA+_ehUxCD1+CUJ_6rXa8ra=tZ1Nr1LCZVYQ0X9RhDndJ33F=ug@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Antoine Tenart <atenart@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, upstream@airoha.com, 
	Richard van Schagen <vschagen@icloud.com>
Content-Type: text/plain; charset="UTF-8"

Il giorno mar 1 apr 2025 alle ore 12:57 Herbert Xu
<herbert@gondor.apana.org.au> ha scritto:
>
> On Tue, Apr 01, 2025 at 12:54:05PM +0200, Christian Marangi (Ansuel) wrote:
> > Il giorno mar 1 apr 2025 alle ore 12:08 Herbert Xu
> > <herbert@gondor.apana.org.au> ha scritto:
> > >
> > > On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
> > > >
> > > > +static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
> > > > +                            dma_addr_t *data_dma, u32 len, bool last)
> > > > +{
> > >
> > > ...
> > >
> > > > +again:
> > > > +     ret = eip93_put_descriptor(eip93, &cdesc);
> > > > +     if (ret) {
> > > > +             usleep_range(EIP93_RING_BUSY_DELAY,
> > > > +                          EIP93_RING_BUSY_DELAY * 2);
> > > > +             goto again;
> > > > +     }
> > > > +
> > > > +     /* Writing new descriptor count starts DMA action */
> > > > +     writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);
> > >
> > > Why is there no locking here? Shouldn't this be under ring->write_lock?
> > >
> >
> > Hi Herbert,
> > this is really to tell DMA that there is new packet to process and
> > gets decreased instantly.
> > The lock is used to track what descriptor index should be used in the
> > ring in the put and get
> > functions.
>
> AFAICS it's not safe to call eip93_put_descriptor simultaneously
> since it doesn't use atomics.  Without locking in eip93_send_hash_req
> two threads hashing into two separate eip93 requests will be calling
> eip93_put_descriptor at the same time.
>

Sorry but isn't it enough to acquire lock before eip93_put_descriptor to
prevent 2 thread?

Or you are suggesting that also

writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);

should be done atomically?

Maybe I can better handle that writel(1) by using atomic_t
value and atomic_inc/dec?
