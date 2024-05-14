Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414318026
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 05:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665340; cv=none; b=TiA+NjwyojT7AfrW5LrRPoA9K/9E+7Pft+vWt/hBx5xbMAG6w9fYVb3b34xHGcglkOThuVxNVzTk8WVTuPmdhyVG3UFRdPXHMbmsz3GsB7o0ITxRjiWi9FvpOT37pygEPPCxas3U2g6XfBDwvnPKQTcyanHT/SFl574jptp9ryg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665340; c=relaxed/simple;
	bh=NV+RKllgW4MfDzgJ3TMIxNxUBbHxwtsBD59kkdTT2P4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EMHhmmsS/fI0xlOxEslIa5K4ve8ozObUbZQ0CdeVH9asUgBe4iw6TWM24rgUOXwYZUR4nmaBDfHldor5sbbiq9q/AAFH5cCieJJGujK+szw5+AcoYY+CUi7hg3eUuUjsfJRSIJ8NkDdGL6a9KMnk1ziyMj9UTRww9Hj/LNeKMc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnmN6ckR; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnmN6ckR"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a59c0a6415fso1386724666b.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 22:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715665336; x=1716270136; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ghNup/0cb2n25xmrVjov+0XGCdmbyoDz8Ij++yEdNjA=;
        b=NnmN6ckRuGATYDvFD8oNyNnEkzP3V1Y4Rnkux6ftC0kTua8FTrFHb5/JKnOY/Qpk+p
         wjwDDLKfMJ9OavQ9WFWr3+yq65tg/Y/JEjrZa9SzZR3QlG1jM/zV9MaMEchvWMVRXKse
         xrj2iCtsj57QrT6Tv08akA0cp2BSKGDSX/+Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665336; x=1716270136;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ghNup/0cb2n25xmrVjov+0XGCdmbyoDz8Ij++yEdNjA=;
        b=UwwHo9i1nfABeqeLvHVPw+2C2eEDKGkk+KmSmrU18fqyuHQryL9mgyLK6vOzlH8++V
         Vi9unz1XP2rRs/eN0+WxDmIhwk5w+7WAUs9Owky68Pdq5EZazCVbjbSvPy33Oq8EQGdh
         AorfQKF0vZGnOVsBDIZV1SxG/xCFKMjiSeD5krm882wsXPJzTJnS2rIWy2/46B4GheOI
         767dW+t6CkvvAvjk008961KrXudthfuM6pPGnIKl1du14oo8Lsr/UvjeZ4usenu+Pvj0
         rbla1pUhfegIK6fwAh1wxxg+FJTu4h4lMo5BqA8Hz+SFzy0bU1CQ/mJs5daUx3S0tXAj
         cnwA==
X-Forwarded-Encrypted: i=1; AJvYcCVITZwbA1UgBMJxSp+S1blYGmTchhIaqNIGsPlHgMfpVoYO77K0nrHxvcyi3bApZ5rgP0jFJTZpPHBwqMFNsmMU93ydOW342CnvvOSm
X-Gm-Message-State: AOJu0Yyotx4Doa1axBiRwaGCjBw8v6XxYdPQsNM2a20FP2eNr8iK83eQ
	szrWMCZBThxeB3CifRTqYvLblmVDdlDcX4pqXkbKeoJltV0gQqaYRekdEGWSRqlBhLz5BErPVDT
	FxVT0Rg==
X-Google-Smtp-Source: AGHT+IFPkpSJQ0tl4VdaDnRREkZS2KM1OWABbwU6bfHaweuNWnX+fpiCJENslGeP4aENuIyidK0n0w==
X-Received: by 2002:a17:907:7b8a:b0:a59:9b8e:aa61 with SMTP id a640c23a62f3a-a5a2d5c9303mr1004742066b.35.1715665336595;
        Mon, 13 May 2024 22:42:16 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781e97bsm673258866b.32.2024.05.13.22.42.15
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 22:42:16 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59b49162aeso1284104566b.3
        for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 22:42:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWVMdITFbaZUdFBhADyw0oLrS2gjJXSPZfpvM9QzjW8XFN/ZrqfBMa8S79zOLy1+SXT+OMAkZ2DJUKtSrSxfXM7JXLPY3c1rAL21Div
X-Received: by 2002:a17:906:903:b0:a5a:81b1:6cab with SMTP id
 a640c23a62f3a-a5a81b1716dmr81680366b.51.1715665334991; Mon, 13 May 2024
 22:42:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au> <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au> <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au> <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au> <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>
 <ZkLz31t6ZJmbsj3o@gondor.apana.org.au>
In-Reply-To: <ZkLz31t6ZJmbsj3o@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 May 2024 22:41:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>
Message-ID: <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.10
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 May 2024 at 22:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Yes he did try this out:
>
> https://lore.kernel.org/all/20240302082751.GA25828@wunner.de/
>
> It resulted in an increase in total vmlinux size although I don't
> think anyone looked into the reason for it.

I think the basic issue is that the whole 'assume()' logic of "if (x)
unreachable()" is very fragile.

Basically, it *can* generate the exact code you want by basically
telling the compiler that if some condition is true, then the compiler
can jump to unreachable code, and then depending on the phase of the
moon, the compiler may get the whole "I can assume this is never
true".

BUT.

The reason I hated seeing it so much is exactly that it's basically
depending on everything going just right.

When things do *not* go right, it causes the compiler to instead
actually generate the extra code for the conditional, and actually
generate a conditional jump to something that the compiler then
decides it can do anything to, since it's unreachable.

So now you generate extra code, and generate a branch to nonsense.

> However, this patch still has two outstanding build defects which
> have not been addressed:
>
> https://lore.kernel.org/all/202404240904.Qi3nM37B-lkp@intel.com/

This one just seems to be a sanity check for "you shouldn't check
kmalloc() for ERR_PTR", so it's a validation test that then doesn't
like the new test in that 'assume()'.

And the second one:

> https://lore.kernel.org/all/202404252210.KJE6Uw1h-lkp@intel.com/

looks *very* much like the cases we've seen with clang in particular
where clang goes "this code isn't reachable, so I'll just drop
everything on the floor", and then it just becomes a fallthrough to
whatever else code happens to come next. Most of the time that's just
more (unrelated) code in the same function, but sometimes it causes
that "falls through to next function" instead, entirely randomly
depending on how the code was laid out.

> So I might end up just reverting it.

I suspect that because I removed the whole 'assume()' hackery, neither
of the above issues will now happen, and the code nwo works.

But yes, the above is *exactly* why I don't want to see that
'unreachable()' hackery.

Now, if we had some *other* way to tell the compiler "this condition
never happens", that would be fine. Some compiler builtin for
asserting some condition.

But a conditional "unreachable()" is absolutely not it.

               Linus
