Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793341139;
	b=MkqGPeE7vzeTC8rl04pr/IEgIU6bwzMZnfH1DMNnCanNakvjFbfM6vEKHjwt+OyJUNrf
	 WYOocAFurMRPS0PqpmYl0ilIzZ6cW0nuNDAlF/6oqtQ5E7p0K+KA0Ras/EAeq+DDYWW3c
	 0dY9pHwP6+uLS3imYw8F0vQxyTg9ivo2UaErSJYrYm3WGkdiMvvCqMbfT+Zm4mPvfmBBX
	 pdxmE8CnLX6ULeTRYTMVoWWF4xS0xa3K90zWMsSm5bXMxGm1DYTD+o8vElKFXLmDv0vD8
	 eI+EGsxlwXw3u9twmGzQcMTZykS8eXs78y29ZFsR2Idp51BadMOyljXi2wJq0dGVUPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793341139;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
	b=5GnYoOzlaY1+h3tyfbGYJODSsBghfEOwQ4UHZv7G5YDvHpCxTYQfFSudy3j+soSjuN0F
	 Hvf8Vl/H4HUmJBZ+KqFr1hWROjRk3KOcF/I5YmlGNW6d07Dlu2R4eCWc5utjARhe+d1fN
	 PzaZHMgjDxQcgn8/n6t/ZRqnonl51iWhMLTxu8zdB6E/9ewBHHuR/to/PRq/gNzz37D4S
	 RQpvkBRhhVnIZp35rWpIXAiRw6KE4sNDNoqqPevvsLAFfHsd0CJputzNzx9ewZkIPwoza
	 SLHkWxOW+S8BVEyR0NWJmWmVpFsvTioIpCn7SMz13uwFD9/9RO0eK3TxZOGbgNDxZUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sjp603sG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F0606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 06:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 501F0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sjp603sG
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be416e603cso274908e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 23:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793341137; cv=none;
        d=google.com; s=arc-20260327;
        b=JaWlkxvvBo/KDfWODHEeaeCQhl1cQq8QCBnzZBUBs6quZD9xtRS3Sk5EVl/KvBC77Q
         X2qGcTwgHUvxvqKK9F/BWxV5aOKOMiJjn5EaM+zaJioxhQlPVibycNv0TFoTfJjwhsxn
         WqO/1aQShX3jdEETQYESTcSywX4dJ9sqBUu2daISmhT7GellldEn+tYYtiQGRVszeqH5
         EZ9htzvLkfKpt9K/UBcJiOMLH2/TUEMCweqt/34rjQ/DQ/od0+NrGLV7F02scZ+L61gG
         c0IovFjeAiDk3s8xg6Er70o3dFhvzAiex9yyyyybena0K6hdPkDy611i78OkaL3kwCot
         HVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        fh=Oo13vic3md/S92u8s1vMuYfRiylaECspseV9d4Hgd50=;
        b=RiOJ291TTgH2aqMiz6k3eImfkDB1D0S0EKvBiUOZhAmtX7/KvQ7E0t+Pv+tcvB+xay
         ZZl8ZsYj+OSMH79eYuO3SPSzdDtQJYOjZZ7RjfKvxY9vcTvWh7CLKIwvL0s+/cR9pxm2
         cSj+AUuXtwTOcl6FbAXVLpskytlnQ5xrW2tIy2A0zKjNd+x9ZWb+E5rNJwL+6nTWeH0c
         hK1U7EnQ25v8vioMxkp/Qs6c2PIF0+El099LMBBXVf4k+QGeDjUkHmQ1iE6/IkRpyh0B
         DouZ1hB2mdPfGP5reEx8e6oRIH97eyv7ulSkb7Ld79vMyLb2SBxlzqpy861qGSudYPz1
         vEBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793341137; x=1793945937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        b=sjp603sG8kyGOYb1dXyZC7cHwcVMz0aNzr9pOwsQAYZPwY7dUlQtDKridGH5ZyqLtx
         MrUMKpktq58bm0qEe+SKtVSBpuIbP6by+m4t5ZAAHpIiaS5ElbUYzWZzWi8ZOGLN0qxZ
         dvBWFFrVfofQHj2Zf4W1CmUuB5RcBO30Ew9cUeAtPL9UTTUH9f/F0NhqDmX9z2Ds1OwW
         mu1fMc+Chh/cVaA9diO8FQUhU7rtaTJWdD8utm31BG8ksi/Hk2DQv2oRcD/zlHxavMCs
         qxZaHo+Kxy84Nrxlk1HmGqwOch1jgZh0oivyI6strzWih5UDCzrVWSQZReNbwd4VxmgE
         WgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793341137; x=1793945937;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        b=09pcEO8VKS3Jr3O0fjfaHP+SAoTg5nsF+9r5dyKcAtut18z/suitnlbacR1Jd+t/mz
         X7YkVijIJNogAT4d/dhhbG6zOCYBYOWg+6JHguN3IRSmSKibaeZxfjza1CEivbrM6N0e
         aQ03aevjolY6fN06a+GtgNxZXc+AWw2pNasCAaF9ORt/3bZL8damNxrN7nhvmsXWkapT
         qIFMybfJ0LvDidMGbPuT6xz9DKcSPdBRL3U/0GO6xobh1XeONUDo8+oJVFLNxZxNHUcF
         uEdGbK01qd7F7gAPn1SLJ0dwh/zcKppPgclAIFY6DLjTNuvkK8pNBcZRy3h+3mFSEUFZ
         bcHw==
X-Forwarded-Encrypted: i=1; AKwUvBx7dg7AvobWUzzS0V/gbWXsWtkR76qZ8p5X4gEMGUTFaUnlncCQofT2sNUm0DaCdwNnmGXDEAh1rmm04XQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJafEgn9+al2u1P2bk0L8RWrHd+a37MuEUmkazew7kOvaUlC7jX
	9+14xDEDTmSlJVgfpF/AW/rQGP1femrHlPLVkE68mVDacSelhhWOCF1psrgqFHtp95Oc4TQs60b
	mw8pFo2iw6AlzAIdlEUp04IRTkP3oxVw=
X-Gm-Gg: AYBFou1SEAkOkQ4iAE0aOAjR6c0J7G8CFr5jAEo6caak7qjL+8Ej9bdtiDeqvOvT6f8
	D9iN2tncqutLN70vegVsGz/ckl/Ect5mtrd/zE3sGYdP9j5lI33FY5iGix6uZQ4LhAVhYzYrMvB
	l51GWjXaTrksm7rJroYF2n/PvrNun1/v82KRVb+seU7k9GVNHDZjQCuVMtALfEZCi8o91TXPXTh
	6KbW7amrriFRPkixHU40i9GEhean1ldNUUwBcU/KXe8jVpT8ju1TDz1S1P8E2qbn73vnQtSkutX
	tAEfcyy1092w7Ch65X5cFDMmjKgKZiNlk1+z4R+PRVYcuGLHlYOveE8Sg+a7EBF4xV014q5OaMk
	MjW9rCNqg1cpQ8X0wZG4DJAj0lyruOQmpij5F
X-Received: by 2002:a05:6512:4028:b0:5bf:d7fb:dbf with SMTP id
 2adb3069b0e04-5bfd955f145mr364874e87.11.1793341137385; Thu, 29 Oct 2026
 23:18:57 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au>
In-Reply-To: <auQwWgMbBuo0YEBI@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 23:18:44 -0700
X-Gm-Features: AclHuK9qSwZmk6xcNKVjBmbt8Cu41-hCRLHUBZIBg2QtW_8hakGVd1OzTQBnFWU
Message-ID: <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> >
> > This is how it is in the current mainline, and has been for as long as
> > I can remember.. I assumed it was because we need a per-CPU acomp_req
> > to be allocated for the tfm. Can this be done with a single
> > crypto_acomp for a given algorithm?
>
> The request needs to be per-cpu, but the tfm does not.

Great.. we can save a lot of memory this way.

Yosry, should I go ahead and include this fix in this patch series? I
am Ok if you want to take this up.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
