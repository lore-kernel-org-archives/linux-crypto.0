Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C71A3166
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759940172; cv=none; b=blRPIJdgzsCAnFFJ5RAZ6T70d1pjW2/lF7RkQaGhIqobBfNb5+CzEutbq75b7OoWIAc/CsRq6H+5OodAsOaLfa54+nOyIjiXOwgJY586Yk8by8LwEwk4GF2UnAsuGaprSedMG1ELoYKdk4LbDXAGZgw+NsfMV9GZrrZ33kR2NN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759940172; c=relaxed/simple;
	bh=uEGenzvUyzBkuEtUVn+BvDaUco6V3TK5byPQuBV+0Co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HKbQ7fwJLvEw3oYOuqQPi0ZQSPZMjiHy+tD0/i4T0/HLytCKGOk7KPQNxJl7qAshSPJQU6Q6RoaBL4Ozav0lQ8/SUhwr+PYfi0n//3eJ51HVN2TzTqWho/vRd0sBIbns64UnjF9FgR5xryNagsPjy4lU4DYOfB477tACM8Tacf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g3//sxsB; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g3//sxsB"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so11287304a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 09:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759940168; x=1760544968; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wafGHdomjeTMWOaW1CHD+uCxSHknTrB56S6k0QVoIaI=;
        b=g3//sxsBOJ3PMgYtlhMwKsBs6AfWLzsigWrztQDQ/hFS2C3r4LB+SlwZF9wC9CIqHD
         htaAHjIW4v18gKlrP5qFf4CwX8k1qX7lDU3POlhUgB29Zv0Rxg+6Ss8NCAA7JeUe86AE
         ta6yVBwZAcgoHbLsf4azynepDkvl9GpftKVxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759940168; x=1760544968;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wafGHdomjeTMWOaW1CHD+uCxSHknTrB56S6k0QVoIaI=;
        b=LcAFU7DfgSLmjWFMxosrRZjG6aNyoviYhZNGHyA3c9mMSd888kr2ExmGa17N3Ml9fQ
         eUZCw7T1Z3tPjO68J2nmM2Kx1sj0ow1m6AngSn34NuDgkMYrUzjPsNWqKTceW6uiIQCh
         ynpADvw6pVTNIcmA5nF6Oo2MpQygmKOCUlxZ6/UBcJ6ouoJ8UALrBYanHN6Y3zSbUZmQ
         OW7sZAMhxTn8vnWcRz/c0ArNzcvq7iEqNhQlnFSOl4EgSgIzMtAYbLhlcdXLVHjoGEdr
         cE3ZHGyjMeg0bhURNYD1skTDOb1USE8tBdRmrQ/SIpgiNLII1fi1c08q8BTxmMkHYzHW
         gBjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX56i8auyxTMOT5KfjHCGn56a+xLi0s77N/j4Jej8HLKCV7KTOG0Xo/kSsycKSvsATaTZlUck7hQykveGs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3CaG4IM7KQBxznON05bAeFHxjjWsd4HaAeqcML87XoDGNluW9
	SAPXwZTqPPkKsaGTeI8GvwQtpk/JkCvdEY3YI4icgkp+CQ3DEVgGchjzBcqxIf6h1SS4axTntu9
	85TgCTnM=
X-Gm-Gg: ASbGncuLLqLWvCUNxGjwJII0nRU7UeZSZPqAJLglZfgplpkG5hjnCMxfGn1oz2YYCpG
	kz9fmAkUk0Kky6iLKChiaL8dDHcOXP42WcVFqZkYHRr+pUGr8f9XMVwIG63OzHYnBflcjvO869M
	9XcFDTG8TeIFLI5q8PixZijp7BK8pJwFpH92ZmXiAbkCvyUyhzAXgLCtTVSbI0gCm2rg2Rlu48/
	QKIU4U3sPuZcM5kFjH0wJ0erNS3BCBvbfa9AoTxwcz2lH2pe3nK/2UGIVy3nT5ap1GPsfzLNvRK
	cYnJKjEUhz9IRjRDZnpJjD+pMQBpVhGNETh0X+qmJInXKQ88gsaM5YhM6JqEFX0To+qeGBov7u+
	ho1aTgWqBYXcctY9OR8uKUrZ+nldkR6h/UAYa7MluUijZpW7J/7lRPy/xtxH/AVpY6uVyUIDUmh
	nHbJaKFRopQR7Ndj+Ehkuq
X-Google-Smtp-Source: AGHT+IHzDLpw5HHPMkH9M8XtgR/uyWhyv8x2D+av7RHLo68ZW/MJn3y5L58Ob3E9HC0Ilp4hIVU/4Q==
X-Received: by 2002:a05:6402:5203:b0:636:7e05:b6c0 with SMTP id 4fb4d7f45d1cf-639d596e3f1mr3833418a12.0.1759940168102;
        Wed, 08 Oct 2025 09:16:08 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-639f30d51c7sm349631a12.11.2025.10.08.09.16.07
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 09:16:07 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so11287279a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 09:16:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX3TyP3m9yZxFz0CCxOl3T2wKEOp1u21jmse7UcjXK9noVU81SdIfhok9M8dX+hWS3G2/R/jj9eWJFtxWQ=@vger.kernel.org
X-Received: by 2002:a05:6402:1ed0:b0:639:e469:8ad1 with SMTP id
 4fb4d7f45d1cf-639e469a2e6mr1978291a12.20.1759940166695; Wed, 08 Oct 2025
 09:16:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com> <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com> <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
 <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com> <20251006192622.GA1546808@google.com>
 <0acd44b257938b927515034dd3954e2d36fc65ac.camel@redhat.com> <20251008121316.GJ386127@mit.edu>
In-Reply-To: <20251008121316.GJ386127@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Oct 2025 09:15:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whTKNg8+F5EUP2oxcfr14P7geOOpaPBwhxF7a0jjBm2GA@mail.gmail.com>
X-Gm-Features: AS18NWCvIhnESJ0gUsT-9HGa5XjpSt2eBl3AMS3_hBGymdQg0Vd76BELyTS6HCA
Message-ID: <CAHk-=whTKNg8+F5EUP2oxcfr14P7geOOpaPBwhxF7a0jjBm2GA@mail.gmail.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Simo Sorce <simo@redhat.com>, Eric Biggers <ebiggers@kernel.org>, 
	Vegard Nossum <vegard.nossum@oracle.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "nstange@suse.de" <nstange@suse.de>, "Wang, Jay" <wanjay@amazon.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Oct 2025 at 05:13, Theodore Ts'o <tytso@mit.edu> wrote:
>
> If there is something beyond hard-disabling CONFIG_CRYPTO_SHA1 which
> all distributions could agree with --- what would that set of patches
> look like, and would it be evenly vaguely upstream acceptable.  It
> could even hidden behind CONFIG_BROKEN.  :-)

Maybe just

 (a) make it a runtime flag - so that it can't mess up the boot, at least

 (b) make it ternary so that you get a "warn vs turn off"

 (c) and allow people to clear it too - so that you can sanely *test*
it without forcing a possibly unusable machine

and then

 (d) make the clearing be dependent on that 'lockdown' set that nobody
remotely normal uses anyway

would make this thing a whole lot more testable, and a whole lot less abrupt.

Christ, if even FIPS went "we know this is a big thing, we'll give you
a decade to sort things out", then the kernel damn well shouldn't make
it some black-and-white sudden flag.

So we should *NOT* say "FIPS says turn it off eventually, so we should
turn it off". No. That was very very wrong.

We should say "FIPS says turn it off eventually, so we should give
users simple tools to find problem spots".

And that "simple tools" very much is about not making it some kind of
"Oh, what happens is that the machine is unusable". It should be that
"Oh, look, now it gives a warning that I would have a problem in XYZ
if it wasn't available".

                   Linus
