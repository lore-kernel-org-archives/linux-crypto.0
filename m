Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866C18E25
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 05:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180800; cv=none; b=fleh13rbufJxgPDQROt84zf5flSsQLG8JKnNYbahzZzljzZBGiuv5Mk0Kew60zUsdygV3+09pPGwL755KIWyvx0Ek12ZtphGxsQFjLqAnFfLg9l9yhdIarmLxkYamDqhApVh/o/Ycw9PlSI11wKG3z/yYGgM5UTUvp2IFz+hjJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180800; c=relaxed/simple;
	bh=cNpexK0gYLKJRIuFuvBQvfRygLN0nqihJVhA0Z5pjA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3yIZxY/cQGQtG7v5tf1igq3yx+TNCqoJLzBGwIomnMW0zOA4HkdFBnZMvK5jV7wfU8ZVbgsa7CVGXTGVVoDLmAcIXqEX5ZuTea9Ix4qSp+ZFSYzOIUx74ziNFWDaYd4/7dwX1PG7WgF8RoQwJnR+edYYy5Rot7O0P7/wXqkN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUjC5seR; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUjC5seR"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-530c2e5f4feso1647348e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 22:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723180796; x=1723785596; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7hNxMOxRImHUEOq3bVTIVz0sAYs3zie6co3XWWllxuc=;
        b=SUjC5seRtO7x+R2MeAvRV2YKEQSdQ/Rrg8W3J97QQbLmjeUQxNQIMa8K15+S+CrZ6C
         ++R79hNzfQ9ZWfPfV3DObJumsOdJ4G97hhN/sU5FZIVRjcBYTDAyuuYhBpBuDGfgB4vO
         acB1maT8swQJxhPH/BE+aPV0PecuKGZZnn/5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723180796; x=1723785596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hNxMOxRImHUEOq3bVTIVz0sAYs3zie6co3XWWllxuc=;
        b=bjcSF0BKDjqNA2cc7Vo5nIjMNzEQKAz62y6LVVyBm1bxJiTBwZivCLnG5yaETvZRxc
         LagIpvhwqjs7bTLOwaXb8qk8xDNKX8MSNHARUGT2ahuHpSkcB1viKgr9OF7gULZ3sAPF
         1SHkmN3DAMFBwR0pFf6Jl8cyBxO43NS+4cqnd8m0q7Cf7HKKXC8SllSAirE3p9nsEstF
         8/uBGWsfu0Pz0+Y2zma6GwKE6OXwmEjiEFXFFEi26XfmC/W9T7kK4YKbq3S4cqvRZcvK
         1FGTbG8NIxoUzj2w+edd/O/N2VGLgcSTd3tdRtVATdWNu5BwQaMptXBTzZUMvyelHoeD
         /cQw==
X-Forwarded-Encrypted: i=1; AJvYcCWCA0gbIfn43HTg5AAQC8Qb7ij8JcZCkbZun8qtrDt1likkyWp8VG8v2uWFO2TETKrr4kTPNAFheo/F5muQ8/it+EK+a1+m9b/5h92U
X-Gm-Message-State: AOJu0Yw/4VkKA6WMFVjX+M35YKPv6ZTU5Dws6LoAjEldO4xywrL2nWtE
	JaeiIhgT36DSWafBFZtPEMpTo66it/S28oMzTl0C0ZMLVxFcYzfw/wSZl1t8XJ7fSdptb9i7YQ2
	FGSC9Ow==
X-Google-Smtp-Source: AGHT+IEE/Cc+tcQ3tyx1DYvCvYFOpop/otC7X5MHPEHEUsjId95SEsfSf84U+W48RLjObiY7ib9JlA==
X-Received: by 2002:a05:6512:2204:b0:52e:9f76:53dc with SMTP id 2adb3069b0e04-530ee8c075bmr314673e87.0.1723180795328;
        Thu, 08 Aug 2024 22:19:55 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-530de481efesm856304e87.286.2024.08.08.22.19.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 22:19:53 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-530c2e5f4feso1647324e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2024 22:19:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWVil31VsjiucCJkOkmpkd08J4JY9vQMByH0AUxCFmQjuL4azJahyYD4YUKg3CCxjL/5IEyMCh6dpZwLUnmH3wSKHHL+Urq++cg1jvY
X-Received: by 2002:a05:6512:1110:b0:530:ab72:25ea with SMTP id
 2adb3069b0e04-530ee9d0b66mr251790e87.28.1723180793439; Thu, 08 Aug 2024
 22:19:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk> <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au> <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
 <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com> <ZrWdx5cL1vKrMBbs@gondor.apana.org.au>
In-Reply-To: <ZrWdx5cL1vKrMBbs@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Aug 2024 22:19:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wguRaBM_urKAgvxG5-dD9RT=07+zZznRZjwTDSOp9=eGw@mail.gmail.com>
Message-ID: <CAHk-=wguRaBM_urKAgvxG5-dD9RT=07+zZznRZjwTDSOp9=eGw@mail.gmail.com>
Subject: Re: [BUG] More issues with arm/aes-neonbs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Ard Biesheuvel <ardb@kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Aug 2024 at 21:40, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The immediate cause of the recursive load is the self-test system
> (if it is not disabled through Kconfig).  The algorithm registration
> does not return until after the self-test has successfully executed.
> For the algorithm in question, that involves loading a fallback
> algorithm which is what triggered the recursive module load.

Ahh. I tried to figure out why it would load the same module
recursively, and it was very unclear to me.

> We had an issue when algorithms were built into the kernel, where
> due to the random of registration calls, a self-test may invoke
> an algorithm which is built into the kernel but not yet registered.
> There it was resolved by postponing all self-tests until all
> algorithms had been registered (or when an algorithm was first used,
> which would trigger the self-test for that algorithm there and then).

We don't have any generic module "do this asynchronously after you've
been loaded", but I guess the crypto code itself could just do
something like that when a new crypto algorithm has been registered?

The keyword being that "do this _asynchronouysly_" so that it doesn't
hold up the module init itself..

> Russell, is it OK with you if we only resolve this in the mainline
> kernel or do you want a solution that can be backported as well?

I actually had what I thought was a cunning plan, and thought that I
could fix this by reorganizing the module loading and relying on the
module_mutex itself to avoid the race that happens when you release
waiters early.

But it turns out my cunning plan was just me being stupid, because we
really can't hold the module mutex over the initcall itself, and
that's the part (well, _one_ of the parts) that needs protection.

And in fact, as part of shooting down my not-so-cunning plan I
convinced myself that I don't think this recursive load actually ever
worked at all, and it would always hang on the recursive module load.

But before that commit 9828ed3f695a, that hang  was in
module_patient_check_exists(), and it would be interruptible.

So any signal would then cause the nested module loading to break out
with an error, the first module load would finish happilt, and at
least it wouldn't hang forever.

End result: I now have a new plan - I'll make the
wait_for_completion(&idem.complete) be interruptible and return -EINTR
(and I'll have to clean up the wait-queues etc).

That should make all this work the effectively the same way the old
path in module_patient_check_exists() used to work (and still does,
for the non-file-load case).

That should be a distinct improvement, and at least get us back the
old historical behavior. It still doesn't make the recursive module
load _work_, but it won't be the "hung forever" disaster (and
regression) that it is now.

But considering how not-cunning my first plan was, I'll sleep on it
first. I think this plan actually works, but I'm not going to start
implementing it at 10pm.

And then the crypto layer fixing the actual recursion issue will fix
the underlying problem.

               Linus
