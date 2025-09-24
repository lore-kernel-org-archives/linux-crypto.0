Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE5526E719
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758742851; cv=none; b=oQLh2DgyLhX38Omn2AOT1RqIsgRswG8nhaAobRxiEHMrwLQt5VjWKl33aj+91C1KtC7nPSNyyabo8j+ZEAFOTroiYtsfF+5aem5cDkv93KdxTs/ugSTs5aJi4rSyZ4Kp90l44QSn34tc++X0LpkA0Q5LYDj6IjSqpaXlQTmyKTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758742851; c=relaxed/simple;
	bh=AFOZkj2TG0Be/KXXpalR/RLNcoDJKbSXopPQd3sWv2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a54mmRRS2WvtXNl155icwGodDH4o1Bi3uN0HsohMFdpquuJFNkRYYoj8HJ5mKMPzoIs4cmj0A3hB8qT2+le435pXhn33SgWxNcTXSjUEiDVp+iugr8VxOhu9hITSCrrQwqeya6Lm+3W7s4ChNRwXZlMSguqjQ4jRvKfTkpkuwMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7N4uhhC; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7N4uhhC"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62faeed4371so217173a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758742847; x=1759347647; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1+Zm+Mmot6AwL4K5F9sieXv45xvE31gzhvdEZdWA+A0=;
        b=B7N4uhhCKpBnCLRHG9spBnclZnPd7D0HfHGPD0BHG5KRUrKBBPzEZp+mTd8JzqVIrq
         wr+M4IJYI7R+BBV8VQxrk8DaB5PIQMDSJ3z98rtKq/xvThM5lvblodbd/dcQWofTejP5
         6Msue4aCL72Azjobh+xbGHJdWPHKqwMNlIpmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758742847; x=1759347647;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1+Zm+Mmot6AwL4K5F9sieXv45xvE31gzhvdEZdWA+A0=;
        b=K0i4D7jbq49XHfz53KCgyv310aPm4R+m3A/igwuGRpBpVVD22jq9JeIlwSE8V0q+X0
         J9VUeGdi0SIQeQxBBZnsCY2pnh9svDWTa6o2g91enEOfhB2Ys43TcBxJpSFDBNO+tke3
         uMmaU2xE3heE0kF72ygVrtCfTOYxv90HEMz4OGkagHzpuQ2sbO55nwV2apIJ9Ny0V0ZX
         KVDV5lzdSgW0QQ9HIWV58PtXVQXfiZBKeyoDswIABCWssdSdWvFD4eAdckOk91Uyfky9
         z/mz5L3TaVOCBA3Wwyjo5BVhQ+K8Wa0K1ciKshVm97GZ+Pjmk8/A9ninWEQlXXhZyjQQ
         eEkw==
X-Gm-Message-State: AOJu0YycBKbpKuVuJK0Wt91blO/JYKZvoqfrq0yT+rlqKQeZNUr91yEA
	iVoVwkX/k3D2i3qwJjnvNO0YrNgHonO8JeITSjs8nYUJqihUf6xLtRBbm7PAihK0KWrznW1Rz68
	FPwmpJ3s=
X-Gm-Gg: ASbGnctodaf1T4xl0lg5Gp4TIcpX+yJZkhFqcV3Sq3QQQENxe0thQEH/87OuDrXvh/R
	D9prTBLQwCWWk+Z41hUXTbzTYLd6nZlJENpW7IWNxsE0lhR456qiDMmoZsLw5cW9AM8sgB2kpQb
	0VPuf/DwdhLVIzRt+oQVGlxvhSR/ztWf1moXG/0wu9zmQLPRtxo1wrIE3twvRm4mOQKr7poqiYz
	M3fl97SaEQlxIzdox6sDX7tks4ZV6X47erJycGYh/nv76vm+T/hGQBLP5414ysHUiz1bXXj7xu8
	7chk1NFRb7AwDnTATm3bvLnYXNQ9Wrpv2dK1NydELLW6wtZOlTym9q/yIXCmdFfnLowPK608NUd
	BDweDDVJLxvx2lcMtW3JvYehhZ2y81R10qY2ljHpx9F819pacGZFouGR9Ic1B220QpjW3XUMH
X-Google-Smtp-Source: AGHT+IHgOXuoKjdz/3eZJmt/e6QlJ98Qts3VaFuY/wyY7H02S2W/+icY501dWJF2eHYy4sbmf2FTbw==
X-Received: by 2002:a17:907:6897:b0:b32:825d:1aa6 with SMTP id a640c23a62f3a-b351b7af5a5mr27548966b.32.1758742847422;
        Wed, 24 Sep 2025 12:40:47 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b35446f6904sm3001866b.66.2025.09.24.12.40.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 12:40:46 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63053019880so330958a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 12:40:46 -0700 (PDT)
X-Received: by 2002:a17:907:3e0d:b0:b28:b057:3958 with SMTP id
 a640c23a62f3a-b34be100c78mr100247466b.48.1758742845971; Wed, 24 Sep 2025
 12:40:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924192641.850903-1-ebiggers@kernel.org>
In-Reply-To: <20250924192641.850903-1-ebiggers@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Sep 2025 12:40:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wieFY6__aPLEz_2mv-GG6-Utw9NQOLDzi4TF93xFAnCoQ@mail.gmail.com>
X-Gm-Features: AS18NWD9qiI7hge6j2kywiKpkeIcPfny81AeITA2ton2nw7pONLugyyBMzBP1WY
Message-ID: <CAHk-=wieFY6__aPLEz_2mv-GG6-Utw9NQOLDzi4TF93xFAnCoQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 12:27, Eric Biggers <ebiggers@kernel.org> wrote:
>
> -       u32             more:1,
> -                       merge:1,
> -                       enc:1,
> -                       write:1,
> -                       init:1;
> +       bool more;
> +       bool merge;
> +       bool enc;
> +       bool write;
> +       bool init;

This actually packs horribly, since a 'bool' will take up a byte for
each, so now those five bits take up 8 bytes of storage (because the
five bytes will then cause the next field to have to be aligned too).

You could just keep the bitfield format, but change the 'u32' to
'bool' and get the best of both worlds, ie just do something like

-       u32             more:1,
+       bool             more:1,

and now you get the bit packing _and_ the automatic bool behavior.

           Linus
