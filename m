Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D32197A68
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723220725; cv=none; b=HY2XKgQeSuN5UQZDdU8sljqXLZ2XE0vkDIREAL278wBdYBOwOd/QKZtQoXgSs1BKQeZBx7oiq+DMGHf/xu2fIYn08CrxOcItN1jCggvrU8Y19HJ4Yj/JIozZKlXvnLmsMdeFuDc12uYRclKy973+GgIK01uE6LpcZe/dtFBNQFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723220725; c=relaxed/simple;
	bh=dAgBl/nMjLQRKRBv+fRVFhMHS+spvufXB+yQ9KVvtA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxgO7I5i3jVDbpeisQWDgORHBKObzVBd3h8SkNNsA+Elk+zUAh0jgwhumLN4mLrr9YEk7GRyTUcLqYHijEiJkCe1h3f0lCxHW0wxopJRRxPYelyrnSyZm6VxkiHIXgE2ZohPEmWRjNu5QorgeZ1e7OFcHnYJFHUafzGIIkvfohc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jc+3sjaY; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jc+3sjaY"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52f01b8738dso2129303e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2024 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723220721; x=1723825521; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zqjdcCpHkFdcL2nl1TO3CYdbwI3m4N75MEmN+JaQxiM=;
        b=Jc+3sjaYR6Lj9G5rIy8O1UlYIlbSQrmiT3wxPijDkM3hu7bQ6iKU7VJd3MnTnkxOLI
         lBScr9iQAgoYj6I7GWxN1hb+09Px0AicO+Xrfd9Fows2gDDVNalswdTY/6DnI+i6wZ7V
         dVjcM2UTgRBLUGYYEA/s6RTl5Cc0pg9EUucWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723220721; x=1723825521;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zqjdcCpHkFdcL2nl1TO3CYdbwI3m4N75MEmN+JaQxiM=;
        b=K6rrKvbZA7I8BhBfPkbD/wTts54rFo1tEw9y1J3n4tMtNWPDucxGHaT6kSU7wf2dD1
         jVNgZ+m2yDBm6SIdv8jlYV+iejpN85RDjRuBEOSB5ULVMa3sPn9q+JNBtpY7d3vyZm0v
         aUowg1Un4mzVlhE84G+zCon0/TZwF5R5Xv2f4ted8MtBS32UX3H8UjFH8UwBqAUhRLUV
         RVXT5CYpFqRMpVQLWukrDhdDQtC1onppI9GTdTEr8FIxZ3Ev61Fqsny1CPxknYila2+O
         MjWM/5DqdfFMUjUjbWodP3X19o5qzgOcio9Ew01DQYm/chuxVX+jL/npkuO0F7/Kni8K
         344Q==
X-Forwarded-Encrypted: i=1; AJvYcCVIV3IK/WjdwPC7ifJn+jT3Ud3Quy0FYJTVYzf9fnFIjmwQd0IB/1JluPDCFRVKwFfj5OXNbVfdbrKNUwW5weaijlXM/U/ARNdQ0xUY
X-Gm-Message-State: AOJu0YwKWBRxMEKI8QucqTq2RmF8KjCUNcKS7G9crOTlj6fIBRR/feO/
	8ryLey/KiWcrzgI2krxZULKZNYrDnh9rYqmTGpdip8Z3M9nrueNW5yEO1Hl3MaHiojpdo79xGzh
	kFtL+bg==
X-Google-Smtp-Source: AGHT+IGE225ypMmG9Xicx9dmmcfWta8meVc4OTMX/DYsHcPpbDnPjx0qNxyJminvoRhDH7GK77MkvA==
X-Received: by 2002:a05:6512:3049:b0:52c:825e:3b1c with SMTP id 2adb3069b0e04-530ee983123mr1594627e87.26.1723220721174;
        Fri, 09 Aug 2024 09:25:21 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb2d35351sm1633613a12.60.2024.08.09.09.25.19
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 09:25:20 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso197528566b.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2024 09:25:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV75eI6i4daGqaj+DgqVI5D5hsK/DDeXfmwJ9k7nO11wP80RoTWEijf9ScPNiwBEfDIK5bpmlRr5T7BGIrrSfLmk0DvX3OJULq/geta
X-Received: by 2002:a17:907:9710:b0:a6f:33d6:2d45 with SMTP id
 a640c23a62f3a-a80aa67b05bmr147176166b.60.1723220719559; Fri, 09 Aug 2024
 09:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk> <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au> <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
 <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>
 <ZrWdx5cL1vKrMBbs@gondor.apana.org.au> <CAHk-=wguRaBM_urKAgvxG5-dD9RT=07+zZznRZjwTDSOp9=eGw@mail.gmail.com>
In-Reply-To: <CAHk-=wguRaBM_urKAgvxG5-dD9RT=07+zZznRZjwTDSOp9=eGw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Aug 2024 09:25:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whhz5gqh4nto8kh5r25_W=r339w0WWJEzH8AoUR52y+gw@mail.gmail.com>
Message-ID: <CAHk-=whhz5gqh4nto8kh5r25_W=r339w0WWJEzH8AoUR52y+gw@mail.gmail.com>
Subject: Re: [BUG] More issues with arm/aes-neonbs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Ard Biesheuvel <ardb@kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Aug 2024 at 22:19, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> End result: I now have a new plan - I'll make the
> wait_for_completion(&idem.complete) be interruptible and return -EINTR
> (and I'll have to clean up the wait-queues etc).

.. and that seems to have been pretty straightforward, and creating a
test-module that just recursively does a "request_module()" of itself
shows that it all seems to work.

I've committed it and marked it as

  Fixes: 9b9879fc0327 ("modules: catch concurrent module loads, treat
them as idempotent")

but it shouldn't actually matter for any non-buggy module situation.

             Linus
