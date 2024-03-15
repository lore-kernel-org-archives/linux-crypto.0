Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFE912B82
	for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2024 21:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539530; cv=none; b=IwqxVzJagnyc8ytt2Wg9nUDRYvmxF4HD+4qMBxcPvWZfUdgB8N8Pa2b4LrK1TyxuM4fHNpqFOpHdzkx+J4tUnJPao6g6viWwrAbsauKZLo+aAPdul0PHsb7WKiCmAHkdZo6fLOpEm7mnDBFms1zu7fgZJSivYnJa1wWhRZjE5EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539530; c=relaxed/simple;
	bh=IyIpIH288LBLHuUuNbtFcXDqgJgXrcBCDbQP3frm8Wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KXbiOtK1mQFvgwks70lkiaZ7QO7aTQQl5IGN1PvaIsMYse7fAaB55SLA34cwES123mSzNx2tuWZ7vL5V82uuMWzDsA/qSw30mUnbBSkusnDx1FK6M7foFvR4sjBzX8x96cFGK+zFYgiKWOkGBYpKNRZ2eW10i7p0LB3KC+n+EQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMVFqIX5; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMVFqIX5"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a466f796fc1so308195966b.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2024 14:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710539525; x=1711144325; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mTlz3zPOeF7VRKW7iDziXL9MnFItMolhxGcmkvxBX3k=;
        b=VMVFqIX5ZDR+2tOoMCYzsx0dn2fQhH5+58WSp+xRyFiaFVJCVm7Pxtf9qy0Jh8ZYt2
         xAFsmIFLEy6q4O6SdvSfz67fgdLPsH+zxFid0KBNJWOC6ftZ7qEJAuCScUZHHoDWGQ4J
         jcXBFN7mqQJzm9eMQRBMFbBMk3nsrJkfG2fKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539525; x=1711144325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTlz3zPOeF7VRKW7iDziXL9MnFItMolhxGcmkvxBX3k=;
        b=aygRpAXsycIKqIQ+UpPJQ5eCoB0wWUSEYuSQxYR5Qr5TdSkj/KkOo9KCVO92PVmhdF
         5Ic5mhyGDRO3Sq2xLr63Cl3Ips5d8cdvRJP5nhEPmyXZi8z2DhZFOaLSgdklM2I3CKW9
         vXgUQsOntNMnnnONHVTTkpwG/q4vdvQycZxQj460Cj3uXhu5Yt1fnT/jyE3+4Xp6TRqj
         SJA3oSttW5Wf2t6JItJf/MH+omKA9IpZ+WmI1c5RAT0oTGFvHiKeM9DT3qGqhLixSF4d
         efVrJEIbGo3QMGoMagizb506YAWv/UKtc+hmtOG+1EqqgWqEl/4iAK9ezZbEy7eFm8k/
         +jGw==
X-Forwarded-Encrypted: i=1; AJvYcCV0/pfLV6Zw2IF/0NYeWkr4cQrWJsjvGSLAcoJ9XR9kd+1vWCSy7ZL2ZLwkQxt3BWhJV/AUzdimdXjnv4DN7ELLEJqzyo1Xuqzktb4o
X-Gm-Message-State: AOJu0YyzfGxMWjC5Z67QUGn5n4kYnUmrp3EJlIvtGYs9dkpKDcLs4J60
	K5mFAgNjIVD0CW3J1tpzz4F9jdtxYvbCIC0ZgYnJOIMHZs9V7uk5tNbevF3T2vd+gorhnwhA/+A
	Rm7DCFA==
X-Google-Smtp-Source: AGHT+IGZC5Lj5R1Tm/7xgoWggpid1t0/7VQ6HX2diFKnXcapNeLr6RfMhVfBIYF3lkvWpFjVsadb1Q==
X-Received: by 2002:a17:906:3b10:b0:a46:9f04:5073 with SMTP id g16-20020a1709063b1000b00a469f045073mr371515ejf.9.1710539524954;
        Fri, 15 Mar 2024 14:52:04 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id x23-20020a170906711700b00a43815bf5edsm2056524ejj.133.2024.03.15.14.52.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 14:52:04 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a466f796fc1so308194466b.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2024 14:52:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWUZnhPoVNVOmYmHuuoVdDs7iCF5LRM3WoirkUNu/mIUw3V7EF13fCihxIvCmZg7CCF77lVPPtnEc3XgNVPPukVpbvHlHa0x7X5IFqZ
X-Received: by 2002:a17:906:d104:b0:a45:7946:8782 with SMTP id
 b4-20020a170906d10400b00a4579468782mr4083903ejz.1.1710539523611; Fri, 15 Mar
 2024 14:52:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YpC1/rWeVgMoA5X1@gondor.apana.org.au> <Yui+kNeY+Qg4fKVl@gondor.apana.org.au>
 <Yzv0wXi4Uu2WND37@gondor.apana.org.au> <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au> <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au> <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au> <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
In-Reply-To: <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Mar 2024 14:51:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wirkYjV=-R0bdtSTLXSAf=SkcsXKCsQeKd0eSbue1AoDA@mail.gmail.com>
Message-ID: <CAHk-=wirkYjV=-R0bdtSTLXSAf=SkcsXKCsQeKd0eSbue1AoDA@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.9
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Mar 2024 at 20:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Drivers:
>
> - Add queue stop/query debugfs support in hisilicon/qm.

There's a lot more than that in there. Fairl ybig Intel qat updates
from what I can see, for example.

           Linus
