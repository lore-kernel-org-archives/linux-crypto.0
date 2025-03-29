Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1594F8F49
	for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743272380; cv=none; b=QZKUmdqmUuWsO9EiNVHSdqgxzNuarimXPja4C/hLYJlK6uFN01VWs7VcGRWeQuQ+xKZIqMF+oBnSXOBSMjpzZwjNSJNGXT5qNaQRne39iZXHf+iDPwxhRlWUMCJcquQfo4KtD2aIrHzSDHulkdoZG5DVYhabaz4q1rfSsCNbE/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743272380; c=relaxed/simple;
	bh=sFdOZX1pb/yqN0Jss7k63caIvwp9BeCbNz+hWl1QYDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jVGZSHbd6KaySBvOKCeP7r6ta3C1YXEscJuDhxlk8B5l0G5S744WBdFn8W1RY3yjj1G8kmEHubAIU4IoP99ijxBOW/0VqLoYjKZbOSTo688FXDIoRELeKTjWmKpGLxgG1soSHrPhSK/lmvL+F3FN8T0F/WgjGZgOybqiFRprT9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B2nOg2GO; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B2nOg2GO"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so5962597a12.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1743272376; x=1743877176; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yCy7w6bxMCSPIFn2dLOuLyXOfcR7syri8fVJ0KwW6ZA=;
        b=B2nOg2GOy9fNkhxOqV9CwS1xtOI6dlc84WCJPH310rxp7jOzd+RtoCxyRuhUYcNvnd
         vre+asSm5jI2dWTgbHOKseGdEeEYqJdMp81i+sKlJFdQkAEKMILL0X1K2+W+NyU9LOkT
         p0QGcyNGSEOTwFaOAlFD14CO+skYNH8dkVaBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743272376; x=1743877176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yCy7w6bxMCSPIFn2dLOuLyXOfcR7syri8fVJ0KwW6ZA=;
        b=Xc8nJy+LvXxk47lYoLodBVG4nMEeTOu28x8RCCf2yosoSp+fqGw0zbCgmTErrKQTy3
         zal1G7E5F/sfu4a7eQtJY88lhwPJU6NdYL4ADEmrrdtM2ayA4P4WLaEJKhPKeofBpQAl
         12FfIpqNN4wQkMN/CHbeib4mb6B6s5LJJWW7Z8RzDAXS0hY8HGofg0oBONo/FmLhusQJ
         dUaygdC8ipwkEF5VXBf1Id4R26FTIggBqnYHHH0Wh9sMa3cf4AIMoHkU6+yAriwkd4Xk
         jAGJdz9394Iol9waIYjPE6TtZFtNibHNtEnBU/Q+u4WYpxdp999vWfgXQcU4BH+WJiTv
         zuAw==
X-Forwarded-Encrypted: i=1; AJvYcCUpQ59saENsMlPIAKYvraX/KHR+XM/NApfmV6yEdUrQap3yrnkSbmzpBR2qqEajx+/otgHxJPBOJds7PmA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjMrrK/EWZ+2JO6qpmHVbunqBOyMYeLi5Le9sgAfrqrV301ubg
	nu9QK0liIXfFJ/BSWB4NTH6i/76PLZTEqHL4bt99xVgUYwxUG6e093JQc330LcKMkhARKQfOWlW
	4DHg=
X-Gm-Gg: ASbGncuTiQh3XY610Y7JWE5S8AXSNooyzhHIW4/nqRKdAZNuvN4Ryg8aMsf3tNwZJIq
	8BR0qXNk4evBhuH9H5/U6hjW0YRnLgFfbs1zenEs7ZXSGGaAlWznlf+GM3CYCYxy2E3GD272pjF
	hZgKlCjQkVD9DF2b1eMG3G9WMbLOMu1pWrIEoak7QIqtr/kF2hRLPQeT1u+f0qqs3ImPudKi0cO
	MFRfRItHyVMb2oRcpbIKSfLBGAAd4BERcSPKXg9TIDq36/GGt92IPPULqRmhAjMZ30afnw753+p
	jbKyiTYlNK0WJ37GncyWM2efCHQsTxeAD58z4kxKV/Jh300l1PsryoM8JgYTuRtgYWC3QwJ0004
	OhVtIqRyhuBdtABt9zlk=
X-Google-Smtp-Source: AGHT+IEo+7UfRx0o8aUpjckBXybH/6g1M800sZeIxJ2FyqafptyGJallL23vk9g4l98cNyQLM6HdyQ==
X-Received: by 2002:a17:907:97c9:b0:ac3:3fdf:d46f with SMTP id a640c23a62f3a-ac738975de7mr296235566b.8.1743272376130;
        Sat, 29 Mar 2025 11:19:36 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922b9b7sm372964266b.17.2025.03.29.11.19.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 11:19:35 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abbd96bef64so508273366b.3
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:19:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmXe0nwcn5z+2nnpEklivesplNttvtNGGy6jsGT87gZ3NpM76Sx83Pb5rt9djCo1tKoJXkfdHkt+svfoA=@vger.kernel.org
X-Received: by 2002:a17:906:c14e:b0:ac4:76d:6d2c with SMTP id
 a640c23a62f3a-ac738bae46fmr268991066b.40.1743272375207; Sat, 29 Mar 2025
 11:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au> <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au> <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au> <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain> <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
 <20250329180631.GA4018@sol.localdomain> <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
In-Reply-To: <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Mar 2025 11:19:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiA0ioL0fonntfEXtxZ7BQuodAUsxaJ_VKdxPrnKx+DAg@mail.gmail.com>
X-Gm-Features: AQ5f1JpE91a6ThtQF6-oBNe9LzuODVuNbOWM5dekqqynxRKsAhb6YqLAueICYfA
Message-ID: <CAHk-=wiA0ioL0fonntfEXtxZ7BQuodAUsxaJ_VKdxPrnKx+DAg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.15
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Mar 2025 at 11:17, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I happened to just merge the rdma updates a couple of minutes ago, and
> they actually removed the example I was using (ie the whole "use
> crypto layer for crc32c" insanity).

Heh. Looking closer, the "they" was actually you who did the patch and
Leon who applied it.

            Linus
