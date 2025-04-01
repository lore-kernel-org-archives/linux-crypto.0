Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E451F190E;
	Tue,  1 Apr 2025 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743508120; cv=none; b=Q2/w1Vi6kg1x9y3PGmz1P2uqqgpbSjPeV4yW8es22VxMayfXVcUpHyfhBJlmDR+a6Q3pdCjYo/mwVLLc5eTGqcnw1/IiyMKSfH0HUfv0UW1W5anuF3PBuulYTSq7AJ22upX9pjyDCTwjXW4Wj+jcMQzBQzDuWasu9v1YKWPh1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743508120; c=relaxed/simple;
	bh=j4cNwCRlrFpFSBwNGdjlUQbBME13gNUf7IKtJypdu8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Km4XhjeTuA8bt5zgYvvakRqvvo5C7K0Zg8OYyytoCIuB+gWh+Q0OXlpz3M9LoLUXMoAxB6daVv//dX8jEuX4BgZSxXAjnrlqhP8CcAWO+R91NTz9UFv+atzArWyc7JdYcNx4KOF0sBHOJw2Bdsvld6sh+of29r63X5uQVzAbU6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExaicEPc; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExaicEPc"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6e8f254b875so50330686d6.1;
        Tue, 01 Apr 2025 04:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743508118; x=1744112918; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JsXZCePmvudsSqTwIbgn3R1iW6p/klgWKA4FSGxF+zE=;
        b=ExaicEPcXpTmwgVhk/TGk7dvRo0DSLLtsAVv7rco7AGqfmbzLMzLTXK4C5KvYxAZC7
         t3OF47C5axIOdqz79oBjV/2I+E4dX/kkHiJ76y2Pzf8cV4+xN5gNogyv5PM/H+cO2PQm
         3UlxoYKtR1l51roIGBW/hQOpWtkhZ5pf8ytJ+nfRPyf4/2pPimdHuidDC6dMgPl20vbV
         zidg/mgS2jKjliY9ccdAfGel2C4B08N81DXJWqSsvEiL3yLQoIFdiYuxXTIzgYwTSWJo
         bWKrp6xcFTEi7J2XnhYimEAcVODT2PofigZyUdXhzWYh9/xniedpCkLgThtdhcwo3ygn
         5fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743508118; x=1744112918;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JsXZCePmvudsSqTwIbgn3R1iW6p/klgWKA4FSGxF+zE=;
        b=vXvSODBgS8MXD65ytD9ezJUOatOCJgbrXVKuV4YYyKsnOUyOs4xyLl+MY3iK/wYRz0
         v8OL2wMatphQOAKrQiP7iY8GTflOrFe2B3kscDZ33NxAzOg4iskIASJhtjqUMKXrzHxa
         5VQ79I9S504IWhBYB3hU4aXhSYnckSbBOW+7kHnL91/NdpG65BFaaZrAyEzN4kxEPkPb
         GDirdcRGYtLI7ji4DgPHwXV50ONXXTLLeZKVpVZnEyUc9eT6O5psOw9zuxoh+Tmco5K4
         2SJcW6J0zpGuDbh201OAp8TZmnFgFtOYElxzA5R1vMsNhiDBKvjoYQ5B2tXFXReMsXVp
         ji+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUC3SrjFc46Ts7DV9kT7opojnPPOHINwR7gizseUu9+sxCS+qO3iE6u4J1SRO04rgMyGDT0BMR/Qoge@vger.kernel.org, AJvYcCUvj454j+q/wlvq/zyjYeN+EKl1X67GUlzBPRQcdgdgRsA2vc7RpSuOkBjZgF1OkylUUFIDGuQ/o1Z+kgNU@vger.kernel.org, AJvYcCXpYzZ2ah+ZMOGUl/Z+YF5TzYd7VdTapS+gNUgiphLC7kGzukv/Eqq0v9dmDTAX8G5lRjXXO6iLtnnEqn4a@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9EZC0k11P/6gpfN/3SdXxXsrtJcQgWFG+DtrdTa0NvQ2gbmRg
	3KvzndRu8Pi+DJbLzZ65AcXbMxLdpX1f1aKcnMjOWAASOLMCrXNJ45iupsvt1eZSBsFd1u4zD1J
	gRKlNyYC138hXuBl2gMMWTwCt8Mk=
X-Gm-Gg: ASbGncvv1xcm+Nq+JNCx9WWIOeBTdqSJPFJBD4FriYkPMKVducFKV5bbtE63df0qDAb
	9hWzHHLSAvzf3T06ChKHuk+6buCCZlCnt3hD/jgKOPzZKd7gYFqOGMoWNvfXL4Vxe0gnh2vm4bx
	mlX1EPkyIyY2xcdQsiP4nW9ALa
X-Google-Smtp-Source: AGHT+IG0D09JE+clFayUFjRycfEmC0SL9ur+j6S6WyW+b23U2JA1UlXnE/8ZP/mZYwa08jXXmFmpP9tUuDCPqiJa1mw=
X-Received: by 2002:a05:6214:405:b0:6e8:ebfa:42f9 with SMTP id
 6a1803df08f44-6eed5fd6238mr256687496d6.16.1743508118101; Tue, 01 Apr 2025
 04:48:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114123935.18346-1-ansuelsmth@gmail.com> <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-u67D7xl2_SR-hg@gondor.apana.org.au> <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>
 <Z-vGkbmX2PQ_gt7Z@gondor.apana.org.au> <CA+_ehUxCD1+CUJ_6rXa8ra=tZ1Nr1LCZVYQ0X9RhDndJ33F=ug@mail.gmail.com>
 <Z-vO4ImhytEpGEEy@gondor.apana.org.au>
In-Reply-To: <Z-vO4ImhytEpGEEy@gondor.apana.org.au>
From: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Date: Tue, 1 Apr 2025 13:48:25 +0200
X-Gm-Features: AQ5f1JroDBAVkfRzfQBMAA_NED86-2L0fYxvt5U11RRVyvSBoKqVpUH8k40o3-4
Message-ID: <CA+_ehUxO+oJaO0CC2BCr=ydmjpXE1hngxW8b926NG+io5HvEBQ@mail.gmail.com>
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

Il giorno mar 1 apr 2025 alle ore 13:33 Herbert Xu
<herbert@gondor.apana.org.au> ha scritto:
>
> On Tue, Apr 01, 2025 at 01:20:44PM +0200, Christian Marangi (Ansuel) wrote:
> >
> > Sorry but isn't it enough to acquire lock before eip93_put_descriptor to
> > prevent 2 thread?
>
> It would be, but where is the lock? In the other places where the
> same function is used you take the ring write lock.  But not here
> in the hash function.
>

Oh god! You are right, now I'm noticing... The scoped guard is missing!

Let me quickly send a fix-up patch!
