Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73360B676
	for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743272259; cv=none; b=IuPnmY5pcJwgCWc3frjtqAqBQ1WufpL4x9zCdMq0+Bf/wgW/4AreWfrXcl7nJgV1Th3/6YANf7yhIAHnvrsIAnsVa1prlulBzL1qB+aqqabsu1ufsJRgCXJm3TC2tFbr8lsmAg55OBqvKtZeqQyt+e/D7n3ggW/mq41OJWpaRA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743272259; c=relaxed/simple;
	bh=tlR+eGGp/o8RP6u86aV4Y1yq1UkeI7Du9iPI4TwgoyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NGnlwNgSo+U+w055V+ze/mv/amMD/dQWKpnyWHagOvuhUMkJEo1t6c0B0ZzDVdFNrS4ClNdOLGTVrGf4Ao7Vxc/5Apd7MqqBtCtdT73FVnKC9NKIXfq8DuR4FpxvS0MaThmWgnBrn5M+SpH09nNvOth0hW77/guyD2ux4FGj1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euH1KCJy; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euH1KCJy"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso646165966b.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1743272255; x=1743877055; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n9yPHJORL4pBLeVppY/n0tJvcTCeRkdiSHd3Zz7N/+w=;
        b=euH1KCJyu0zdFojas8ELJ5/+YHAdDL5Eb/JRaniQ65zEPyEmlnZK+1II3q8EYAKDRB
         6MBkuRl+8XD8/N3Kraxyt4uxpoNSG61zBWICnVhW0iQIvHfTFolrqcNanL4FIuFshLK3
         tlKx6OU22aYj/YZ/SwzOwDV5UoAp87sNjrkzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743272255; x=1743877055;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9yPHJORL4pBLeVppY/n0tJvcTCeRkdiSHd3Zz7N/+w=;
        b=WcJ9N70jNxYP9nzs64xRA/XXAg7ydKjrpWAylAnb+qJOnVFAhN0+m/DF+UefWLT8n9
         zNpNMcFwt626R/EW+MLWy89N9X5gUWL80fzAP46oTCZS7YI9d0tylNay18MRp450c4t7
         S/dHa4Gzj1GWoxyOkb6RCbegPrBTZqQvwNJk9ioP/0QeEFXMn5Kb8YgQrMAZHNmOwuP2
         1/QwsdDKdP2TQiR78rnBRew7oYSLNj9ddKqG1tfZ2IpG9PHgXnK7+0xw1DF/vR0JNi2u
         wBeVGAXU5JtfXpiNym42yYAinXM2z5hlVawlrtRvjOFFef2ElZpLDltVi7NLpho7VFhf
         lf8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtDFPWYJYriVTY830S6MEiGt19vN5ADyH5OBPz+P0LcY7GZQnICTlmVymPveWES9XEG19f7I6JzareupU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCvCvhcfF4oijvF2yK7qA0K+pzqIGvNqIIl8uKGTrz1TyCep1x
	5MFZblmU90AP9zDnKUY06emQiF356QXVWX67J0KNivaix4ws6szYZ6idKbLr4A3dEjn4Vp8/9Iv
	Ac28=
X-Gm-Gg: ASbGnctXu1I+xMbDWbOY9m7Cfrd9DS0GDn+7RCO1eZt5r+DRr2vVJcYi51E9ot24h4+
	jW4g6cEWqLdpxIhXtgeamfJN5N7Zt782TiSmCr3QWPoPqYr6SKIIQ0cBu4ORavuvTmGQC6364vA
	67s1yA6tDQZpBXiTGwnlzwum2Qb3FD8y++rawIx57yJLYzvrVNpkRu2ofVLuhMRhLBSYRZoHWWm
	dbHmWP+0McDg3ZTJL9p5e7u/+yGT7LU1JuZk5VTJbVqGeLYL4GzIAIP6WWbiJAc0rh+LEBYBPOf
	AWj81CXe7Zr8cfu/c8ttTwRi8S29/7rhsx583DhqqFdF9DqW374zO+Yt7MEiWn55qdEwa1GLJRb
	i4X+cNihr02+zkWrFn5s=
X-Google-Smtp-Source: AGHT+IHyLsWnTTjpExqhALWAxRZC20Ow5JEWMGPn/+2igv0+4UcNR8k390c4XDCq8Ic6NLdc2tl44w==
X-Received: by 2002:a17:906:5908:b0:ac7:3a23:569c with SMTP id a640c23a62f3a-ac73a235730mr255961466b.1.1743272255399;
        Sat, 29 Mar 2025 11:17:35 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7196dd435sm360742166b.161.2025.03.29.11.17.34
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 11:17:34 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso646163666b.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 11:17:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtNnxlWbwmWuI2He2hKNorjJ38N+RRt7bYIJecHkGzhwkIIJd7Ckg92HK2tyfnpTATjQldOFVytRo/9WU=@vger.kernel.org
X-Received: by 2002:a17:907:6eaa:b0:ac4:2b0:216f with SMTP id
 a640c23a62f3a-ac738bad2cemr293239266b.43.1743272254023; Sat, 29 Mar 2025
 11:17:34 -0700 (PDT)
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
 <20250329180631.GA4018@sol.localdomain>
In-Reply-To: <20250329180631.GA4018@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Mar 2025 11:17:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
X-Gm-Features: AQ5f1Jrj02nuuU3jVC6wxLZbrb8UO2ZPR4XngM0ocq2feDDCLoOzwqBb1MawlUM
Message-ID: <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.15
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 29 Mar 2025 at 11:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The crypto_shash API is synchronous and operates on virtual addresses.  So it
> just provides a simple way to support multiple hash algorithms, and none of the
> legacy asynchronous hardware offload stuff.  It's crypto_ahash that has that.

Well, it's "simple" only compared to ahash.

It's still a complete nightmare compared to just doing the obvious
thing directly when that is an option.

I happened to just merge the rdma updates a couple of minutes ago, and
they actually removed the example I was using (ie the whole "use
crypto layer for crc32c" insanity).

             Linus
