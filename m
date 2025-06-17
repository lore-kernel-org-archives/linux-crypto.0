Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B621D00E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 18:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750184977; cv=none; b=uHnkb1M4CWVWZ2y5hTLkJWfs0oOFuoE6urR1oettmZKu7StMCsyI7WPY8byUuBQOrbkKZA3kIveVYNmD++Gc4+rxuwiyzoZxyPkS28/ID1VuQ/UWSxBxSmErXY7eolqhYiYr+mcSG+zysqWVfyAI1i50PoTBOiQYlAx7NDozim0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750184977; c=relaxed/simple;
	bh=4D7DO/f/TIDpTtJg/TTFmgQrH4mAxp5ug7V7AlGUGEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pF1NF3wTV6hc1QWYNGsK+NVml85UgUj0jHYXQhOp2M66Y9077t26sp6xrxnxlFlSCJBfvLnZBEJjwngCEjTD2rNMypOkgD5ZSkis9lhycp31kAb2sCFqiDBp04dAyZo+d77PnhLY30YjLHI9gqtvrN45vBBwBikeh22c+QUI2+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZULnhdeA; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZULnhdeA"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6077d0b9bbeso11158512a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 11:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750184973; x=1750789773; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BpmH32X+ubnFGRkDpBaCqaiio/3lQgXW15x6m1ucLKk=;
        b=ZULnhdeAZv+Trzzq5xzt/azn4/Dh+J6LuQR9TATLOD8coIES4JnNPqeaeQoN9LvgF7
         KlhVBrAk0Cfljg1ouLWQuEcxHXE7DC1msQ7pxvlQSiCXEUa30IGvcPvAjUZTxyLf0wDC
         NI7XXjEZCn4CwdSwugKLYQxp2JqqUnoa4XBm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750184973; x=1750789773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpmH32X+ubnFGRkDpBaCqaiio/3lQgXW15x6m1ucLKk=;
        b=KAdyuXuHL0Xw8szWuAuwIMJJd/R/rIsLUWro7Z0DOn86u0iKC0q8iNObCsOS3L5ilN
         23UBMzODbywdXfvSviaUcS21CUk4hY50J70Pe0td2ia6fbjL9hPoS8fbabBQIoEK514y
         TqLbObywC9ApERlkyU2MU8SBMDStormdO9cmmy3McmQUsLsFt475VdrdZcvMkpCWwsrN
         5jQxG/7nR7lt+mMNJJRDbTq6qY/EGz4poNGDqTvXCwBrQWCjqUsAwKGPBuDTH+4bwXuP
         GW0/RzQ/M0TLMs1735dDAE+5OJidw+ysx1Km8fKAPvk2SkZq8ZCMTYnMITo8OlgoB++5
         ZvgA==
X-Gm-Message-State: AOJu0YyFXbO8m/MIhBEcSOju5C2XHCm4kk6GL1ag7YinU/yPUCEkd0j7
	DuKXC4OepxWramHfw1esFO33o5nwlIFJIjlOmCPmwBDhN6VU+LblmuglZto0k9QXgY6MTNafvjL
	MgCpzsMU=
X-Gm-Gg: ASbGncvaeumhGRLSwwhZZiRXqGN4TiWZ55BQQJy/t+0A75lLKntfpeJvsjYsnpRhEkb
	wy12ZA3adgRcMAs44+rv3LsRld5pZ1fJRcaCWkMM9doHXWdwLACgFZLL/YSlLOgr7B2SSh5uCMj
	R65LfnEQ8gS9LQIgdP0EicnF0DPxL5/ma+ibcyXMiuofT6SPRb+h5oIn10j4totFtTm/VZO9RW3
	G/47g5ZiigwSn/c8n0Z6WNiJvFb5CyRbrI613ZlY60U0r2s2+pIf4gMMU1KfDnzVK4i4HTevrZj
	MpnmMDpA9/J7lBAbRhZDo8k62fHtH3qTcxiHLhAjg5YNv5Fqi5mLXRuBz3nmuzeE9Yx4u+TWS4P
	1eGS/tM8dic89TTdwVum3eqXeDflebrNe6ecE
X-Google-Smtp-Source: AGHT+IH8LxGg9OvscuxkkK3SUI//goI+TbXfeCakYh2sFy73ElOG9oBqLrPmRYWH4Izd647ghKxkZw==
X-Received: by 2002:a17:907:2d91:b0:ad2:3f54:1834 with SMTP id a640c23a62f3a-adfad451601mr1279486366b.40.1750184972719;
        Tue, 17 Jun 2025 11:29:32 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec88ff249sm889889066b.82.2025.06.17.11.29.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 11:29:32 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so11675860a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 11:29:32 -0700 (PDT)
X-Received: by 2002:a05:6402:40ce:b0:5ff:f72e:f494 with SMTP id
 4fb4d7f45d1cf-608d099f37bmr12876236a12.31.1750184971733; Tue, 17 Jun 2025
 11:29:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616014019.415791-1-ebiggers@kernel.org> <20250617060523.GH8289@sol>
In-Reply-To: <20250617060523.GH8289@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jun 2025 11:29:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com>
X-Gm-Features: AX0GCFsDpDEWkWJGZUHtM58JGRAX5cSPaq4yB3fqNYhO8hMv3GVq-qz3C44LzlI
Message-ID: <CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] SHA-512 library functions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Jun 2025 at 23:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> An additional note on testing: [..]

Talking about testing - when adding test scripts, can you do it as a
separate thing entirely - either before or after?

As it is, this code movement is hard to judge just because the stats
are all messed up with new tests:

 77 files changed, 4012 insertions(+), 1756 deletions(-)

that's 2k+ new lines of code that pretty much entirely hides the
question of "did this code movement result in a simpler / same / more
complex end result".

So in general, I'd really prefer big re-organizations to be *separate*
from new code changes.

It's just a pain to review renaming when it's mixed up with other
changes - whether renaming variables or whole files.

And that's as true on an individual commit level (we try to avoid
renaming things *and* making other changes in one go) as it is on a
pull request level.

If I see a pull request that only adds new tests, it's a no-brainer.

If I see a pull request that only re-organizes the code and the
diffstat just just renames with some small updates for new locations,
it's a no-brainer.

If I see a pull request that does both, it's a pain in the arse,
because then I need to start to look into individual commits and go
"which does what".

            Linus
