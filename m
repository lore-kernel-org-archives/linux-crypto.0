Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE46224AED
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770699; cv=none; b=m4Ivj2/oe8IIuaWNIPm/NBDfRmyDcGVhU8cdatTsfTdccVLU5prb5RSpPHzHiIJLgPiSwzbdVBaLVruX00qj9SlN0RoRK8YLvdUi1PqpcLOKkp/o08vfbYg5qMKN+RnErXt99/58vdzTksGSkpG9VwjDoHM+MalO4pqzYmz5XjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770699; c=relaxed/simple;
	bh=zKkTa7ZhmrpRX4yKjc3XCfiejGSkZfXEDNwW1ZmtDtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GQLIZi6smmv8ACzF1gh/l2pLUe6g1NNu6bn6SKpjwDqSH+MNOTFrpgZ/F1TBmsUczwHM+3qjaeDEOHa/JwsCZ3Q4vNRTEQYKmQNjpis1lOkWNW8fuKnWFT472BIiz4+zSAMn7svX7IdJCyTpIEKCNMJR0Gcn7L6ubrcYXuB9VFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TiDnrW6Q; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TiDnrW6Q"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6398ff5fbd3so2878991a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 10:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759770695; x=1760375495; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ON0py5Pr4Nz6NW5O8PJrqmYAOhtAM3BBfWdJdJiOtZI=;
        b=TiDnrW6QvlhwnSPoxSED1SuuJn97AsMAKc7Y+MemQZrE8j0+XkIUqYGbNOMO0FYGMd
         7h7c7SUpotegdcQ2W9cP9mA9+TiX7TNnca+VNTcEN+dyAxkvYs7DCIUQy4+2igSV2xPB
         fCs90GCCEZnd1UPiYmNkkPCSFiBcD96i8SB4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759770695; x=1760375495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ON0py5Pr4Nz6NW5O8PJrqmYAOhtAM3BBfWdJdJiOtZI=;
        b=KnxLpoXtcWoGZ6fiVWU+s0/Bg6BdSXwkGXCVcsojmPULq6ySNf7xfIsPXEliy/Gh/4
         RU0vO+/voUu3aBtAIJvtl1HOGzJsv43z9JTETmxq6s8vz1ILkoI0xHThjL0vOse0xQdq
         dBqOCXAVCxggZZmuxT35U9qbKUmxYNo3ZjlPgv0r33ycPC7dW39UiImwkNDCaME1j1eW
         MS1legmKVQ//1Vp9QYXzdSrt5jSsXbGjZSLFUNmL7DT2hdmS033OCgnRrWtfFzcUoYQl
         CJU78wp77bPyp1xlE2q2FE5jRfL7EpNoKO0G4BVU7d+H8kRwctkAJuhNSQHwqD8k9Omy
         GLzw==
X-Forwarded-Encrypted: i=1; AJvYcCWEaAulbWcd4busf9/3PD3MeDi5IFjASHU9/vrQ8/vQSxLbjkNSMWsjVd6ePcsbMcgpTcnPhnHwZ+rM8B0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO4awo5zuGztq59WqDK4EQXvgwS7H40Rsytaa5ovLRtN6txJCd
	xrKKiBWNY+zh8De7EPphEcXRIIpNtIDfWinj/uEtrYe1+uCB0tcEkPU/rdfLQ+3c/UX4QRw4sSc
	ED1TRAxg=
X-Gm-Gg: ASbGncuS4OZox47hxDmfsV/R+9ptSwzSbAgiMwIyNwTKtExC5J167C5QR6fezxCYu/I
	PPXLcD+UpfMd7nWQid1O5kumjGz0VE8+sZXo0W0rbC1yM3PdOBfCH79gX6q4wnqnOwwfQ4Nba39
	PQfcqYN1el9gKHDCpiImO2M5wUsGFCFMjPxXCERwiBF8S4/73CV3k3PG/J2W1S5HgWYgEEP8Gs6
	/tRnPGL/YkW1f7iw+ll0rtJQEYWIh1nFxMtADIj0p99Zv/H25EFtsuJ0Wov9scrhBnGVuh8Yxuv
	LpdHiAUTWEksGV3FgnfOdcLRRlZwgPwpRRCLuErfzaS6u7Gif7jYQSAVRVZjnmMg4cTRLtdDVw9
	4IL02GjWNYY4Q5b+t9MJVsHYm2Ho1gNvSWRW/64QsnD1I+m+SNJAYwgT8VI8fEJ7iePRveDni24
	mijeSUTy3NG/TKSO/udabYbZqb8t7gmdQ=
X-Google-Smtp-Source: AGHT+IGFJBBW50H/kf0F8n/V+Yw8Ozf6XuW4aHhScEEP/jqQSe/KRiG1818gBQEV4KUVYpYrqNM2Eg==
X-Received: by 2002:a17:907:9692:b0:b45:a84e:8b88 with SMTP id a640c23a62f3a-b49c4498b98mr1444149466b.58.1759770695015;
        Mon, 06 Oct 2025 10:11:35 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4fd92sm1178163266b.74.2025.10.06.10.11.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 10:11:32 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6349e3578adso9356501a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 10:11:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX4V9ECvr5c405ymssAfDjDjiJiHSvc36p0948QNqw7buKqECdF1E7RxoKMmZxfnKB/BmwVvbJBXThqqNI=@vger.kernel.org
X-Received: by 2002:a05:6402:788:b0:636:7b44:f793 with SMTP id
 4fb4d7f45d1cf-63939c42c3dmr10575986a12.36.1759770691962; Mon, 06 Oct 2025
 10:11:31 -0700 (PDT)
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
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
In-Reply-To: <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Oct 2025 10:11:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
X-Gm-Features: AS18NWCXa0wSJ6_VpJSDmpZcgomwitAo1Hggc1PbqkhjmqP5uTQVk83I_Ms3YkQ
Message-ID: <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
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

On Mon, 6 Oct 2025 at 09:32, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
> Okay, so I get that we don't like fips=1 around here (I'm not a
> particularly big fan myself), but what's with the snark? fips=1 exists
> in mainline and obviously has users. I'm just trying to make sure it
> remains useful and usable.

It literally caused non-bootable machines because of that allegedly
"remains useful and usable" because it changed something that never
failed to failing. That's how this thread started.

So that's why the snark. I think you are deluding yourself and others
if you call that "useful and usable".

           Linus
