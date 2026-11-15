Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794724271;
	b=g1wZ/ha91WuipcZjJu3neFgeN5JVrQ7PrdusDlYxV6coAKm9mgHvJjNuZFr6KVvaoNTC
	 ExwNjRgoBf/TjKZq58/fg+SvZ3jnBLQaysSTwb0XQJ1ClRJQdTg1wP6GB1x+bmj5JMnlh
	 2LXEALHfd8TD+7Wwxw4AYEOFb35jXUm/kDCF3zWY9Vf/JoYEx1yCJa5kIm2vGcZ/KnUSl
	 J8y/fh6OgIBrgGK8d5D+D1zbu+jUkJbWH66fbGlcD1Rm2ZxV3gPEsIdSjM6bUGLWXomG5
	 q1gDNLeyhaz66VFkFJiHzKTBvbO5Uq+K/MW5iKJjv4GE0KVI2AnfCsILHE03pPOzqPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794724271;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=TRLI9Td+RNJwtBm4+tKQD4CjycAG9GxlD246x0jzIC8=;
	b=Pobl25kWb2fJlFDSNb2yw+Myj4qjCvrF8wuoe6X72dVir0wuTnLN+bFI+BccI44PxQeT
	 6Y5/NxI2cvb2lFH3rFRAAkj+kqLFugNamlohQqL3EJamOZz3vcrXFBjpoyg+U1T8cwPzF
	 0rpMBYL7aK/CW4VCPAl/WQgrGy9nXkJwy4HIvAI6tM4ieQdIw7c8zeWsKT4ieT3UHJ6iW
	 pp7FIojVqU0UjjxtIAZl1gNd0dkayUCTcuZtt/J49ZEloWxIGAkYHN8Xh6C1LojNyRrn3
	 yAvyB0eYWWZQWU0PSNpqUtn+TGw78pzBKwzTuBT6RH8LUBYFMw5AkGp3PtLYDav8Qkg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BlBeN1S8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA30606A323
	for <linux-crypto@vger.kernel.org>; Sun, 15 Nov 2026 06:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AA30606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BlBeN1S8
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b71b012e3cso2833635a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 22:31:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794724270; cv=none;
        d=google.com; s=arc-20260327;
        b=m78dnqsSrSmEa9rZyHsvhLPWu/hhqFsiNF2VoDkvQlrnQe3eeL0H/aW2p5Ijq28rSx
         ++KW8Y0QXSel2ASzXgewHnuI+E7J4F1FKrFLWQ9f9aZFoRxLKKRGOM5pt/gxjKdY1XNr
         T+NaY39VhJ5rwph/ZSbYP0Y+nUuChl8trxq3YYKuxnfZTGPg6Fahym01CemE4m6i9OZ3
         fzWPQJqLPczRJSMPiG4YsZGJeBAJbIRrPN8yQpP219io5Pm1NCHReI8t9P1KJlpJ4jBn
         rtC0Kj8jCN1LXLnHxyPHL+mRnBIVfY4vaiUq6jh4AWx01RkIDWLVR12/KsTG25u1cFLI
         eO4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :dkim-signature;
        bh=TRLI9Td+RNJwtBm4+tKQD4CjycAG9GxlD246x0jzIC8=;
        fh=FwziCo1Das6ekfIT2zNHlp4jstipmiwQhopxSbH9XoY=;
        b=B2Exn5TuUlyBJl8oFQaPvHfg3tMonjr8GakDk0vHI5H9uvhyXhXtKhQW1Jd75xPcEL
         tjm8GcrKMqVxvOdsaN+hH2UPproSyxTo10Xt190Hpiddj3mOpKoO3ovBd6l3pALao1JK
         RTREEa+ObBOUik7fpE5eWOHR5htCelmb+qtBJ23YmMkzWjciqW2cMnHhjtZ5/8D7I3aA
         5P6JYV6anbgkqTLXtE6XjG1uSjaAAWwIZcHuDPeFp4UcHP4Db7dm0Jsb+/ubZbdotAXC
         QaEaZAr+ZIG+IJ3/Hed4iVK3wykUGj5Q70UhbHzmSgZCUMYLqoQxFTG77SBKhlnQM4P7
         2WPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794724270; x=1795329070; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRLI9Td+RNJwtBm4+tKQD4CjycAG9GxlD246x0jzIC8=;
        b=BlBeN1S8rxcZ8yHOolgoiuyhMXqgdxn5IUTUR4vu1neep3YC6Nrms9TuiacukJbDIQ
         4Ao4jHPx5XOu8x8KY+n6o0tRgK7B6wZsW5Qg0DB297HV/i28F0+navu+6k3y7W1HJWYE
         ABZCpHvPcq7YmTMebkJ4CpyDq4tOMsoMXWuuZOxglaIOOAHTf9eukAMlvJUSxiG72Z1c
         +XtZ7g47yej1b9xctL3w7HLwQ/NamA4ZkgEzIZD8jL8IRrRnzt2RbghrfhSruHET0Qor
         TfYIl01uqJ0xc8a+lEjf7htkqSHScjFhOMVIjqI0Ls3uEAjetq2v9mDw5WJ7XZ20vU4r
         RX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794724270; x=1795329070;
        h=content-type:cc:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TRLI9Td+RNJwtBm4+tKQD4CjycAG9GxlD246x0jzIC8=;
        b=dTIWo2FjQZVep+SQKCczfK2p9x2q2pWAZ9NNe1I4KVRmYxieM7Cq4U7n7A25iKtGKg
         TgOF6Phh83vUZERtie874pP9fprZZnuX/3fWDitJhkvZdoQwTb8ll1r85m5/A/eFnqNy
         mv/oBOT5Rkq4yL/a1zM3eMTmcyNwVygZOC598H69ExTAjD9mxpIIOQuIKCZq7s8McAXF
         /r+quQUtGw+lRxYZpoKKz52Eg0bcAsyDRVo48M7/yEzxULBUbTPscTruUB5OqpkRERvu
         2IqPvhX84P9sN+lMxKh7WUsmyvGhdmz9y6vngObD+I7E4oQtyqt308nflY24a+Rn2cVS
         KWcA==
X-Forwarded-Encrypted: i=1; AL+hErGHSNTRk8gHMP7dZ6tqUP1sJBjr7wzJI+aKhbxhBu0kcpIH2ym6XvvjUAXxR/mU9m89bWQG6VFB5tZh10U=@vger.kernel.org
X-Gm-Message-State: APuU4Z9jzyVL9DmQZLhx67FCCFMO/zRefU85Nynd2Z7Ks320jRJPcOEk
	yFNDrMRkvJwXy7trzU9P4jbhMkdyNAc9wudVzHQrywcw4EzrwAdrJt3Rh+TKfzyzTgoxBQAfatN
	ofcE3fCmpayjtrX9mOtTeoouW88It5yg=
X-Gm-Gg: AYBFou23JhEaR0KWwTR/RPcBVzb2b/RozONzqbO6doD+vmZQ8tqY7ffDGXRXlUdDD++
	/HyiCcAS1KDf7DGJXUF6L3lzdnlK6/S4wGdv8Q5f6FDdOQf7xaZk0DaneZCpwnw5mZtRU0VLkSY
	U9Wz6Icex3LADjkp7KBpP2V60Tqcz9wcqNZ/1zCVkAlCrDotlXwp4aiMRZ9D6fzCdoQRG2XVLRp
	UVMb9GkaPdRxQ1bWesxxIlDNJQ6m9nS4xACbqDezoZCXEt0RBg/klaBMR9j1YMpsH6KRbQPA07d
	NJntiWoRyfrbJblcq4+n2QP5pIC/7JMJPLuZgF4p/pmo/fzze02BiO+EQxtSH9IsnOMoI8uY/Bk
	8LIPnh+LXqJOBuAc6zGsLATkX73K7dFC5tbh8Zarogk/DRpA23252nToVofIYFthH1C2P1v1B2b
	Vwvn3rMfAFWb90MCg2WWi8RK+T7TJULZC+NCvPtxCPfnDHvPCTRuaX0GM=
X-Received: by 2002:a05:6402:4404:b0:6b7:82cf:f69e with SMTP id
 4fb4d7f45d1cf-6b7c08b4c7emr4946620a12.2.1794724269570; Sat, 14 Nov 2026
 22:31:09 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Reply-To: ludloff@gmail.com
From: Christian Ludloff <ludloff@gmail.com>
Date: Sat, 14 Nov 2026 22:30:57 -0800
X-Gm-Features: AclHuK_unVTggCaoPUML0eK717T84qUSQdruqbjfPhZrS0xnHYClig_DE2lhj_Y
Message-ID: <CAKSQd8XsZg7VooNs+MK2=YWOvXii8oOC6ULmbusubAk0aQxAYA@mail.gmail.com>
Subject: Re: Turning on DOITM at last
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	linux-crypto@vger.kernel.org, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Continuing this summer's thread...

  https://lore.kernel.org/lkml/14962fdf-66e9-4b64-a37e-0e697c875cc0@citrix.com/

The DOITM U/S spec arrived, as mentioned on the gcc-patches list.

  https://gcc.gnu.org/pipermail/gcc-patches/2026-November/738803.html

  https://www.intel.com.br/content/www/br/pt/content-details/932747/user-doitm-and-sup-doitm-extensions-architecture-specification.html

In section 3.1.3 it proposes two changes to the published DOIT list.

  https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/resources/data-operand-independent-timing-instructions.html

Namely, for shift/rotate and for rep stosb.

How is this not problematic? Will Intel do the required SW work? How?

And what good is a DOIT list... when it then changes under one's feet?

(Other insanity: the naming prefix/suffix mess and the cpl1/cpl2 mess.)

--
C.
