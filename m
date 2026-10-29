Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793253850;
	b=1sOc43sD20AKHzJBm0fj8AKrZ87irJwvwPoAbbsMQr9GV5baBoC0sOkAGzuw8M0uy53Y
	 3bVeHL5JP+erUCVLAXFEa/Xxpps4KpPGM7SI05wLDYgjQkr2OREOTrMuPb0UPeKH0hF1n
	 DKHzx8cjmKOHNrzSVOy3ale4pNgiWuokmTCD3NqTWzb3D1ffEeBOh4hDXh2SSrGEkNYDn
	 cIORINByZv0KfGJ/E8ivzjxQsROnd8zP7peJJPz9xChcuAk+o7/ypqpHYqTTksOfxjcOy
	 WPcyb7Cy0MQpI1K3r+zliWfKvWHXRU2CM7yaFRVw5BQwtdC1TKqdiA4vshruGt2gKvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
	b=ot8xuu/G/2q4DOJk/p2fgUqOl9NN0lVRRVqqpMzfmA3UcF/SoWWusXMvbIgwzzZ9sX46
	 oIofNixfH5HlNpDHOS0K94jBZ9Spuy88jRT/0ZkZXrhltKAMHRrAsw4xHymOaNiN6HFpN
	 keFTPIyBfAgQPw6upX0SKJLsl0VE8m9U3M3D5WuOpquzFtuD7Ta06mC78bTpyYmVs+XUu
	 RkE14h+QUlsRIIl4wDwT+0bTcsCOmaiPOMNEugmcnL7Zmf68oW9XH8LwUdAqKsoxLIlfB
	 uukFWQNYPqLLIzcKsXYIP+Uo03yMkbIEkzBS319u34zeeh0fAiN05HFwKdT+qhoVz1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fW8vYyeu;
	arc=fail smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C71606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8C71606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fW8vYyeu
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be4c78e8caso1847631e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 23:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793253848; cv=none;
        d=google.com; s=arc-20260327;
        b=JJnCB0uJp1SmkxfMHrLUOhs1cgOcGRIb8nrxxI6FJLPzooPKK19mGkv86aO3HRFv+S
         vY3forKPyX9JUVwYt7GGZjhQeolyj6+sh5B7hXem7wVwK+7oDHGPR94TeyDrHOOAyPOZ
         Rwq+YnTkJpdXsW7ebny12f/ObpGUWkRvohGRgVTtbYE7SIJiQI9QqAIQxYjwafGnbEcO
         lCM6n3P7RkKzPkHXOW369f11AXxB8R+ttrurGxy384rGx8LrdRLSdYkNVYUS8dou2VUs
         nVI0Dn047x/I+sERmBSCq1QfDjpOTaBZhTjMf1ugfi7P5kHXZIG9Vz9W1DbbINsIhcDy
         qBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        fh=O8tiQJ0KAr9cC9RuHaYxeEzr5rciMhAjzNgXOf8RKwg=;
        b=KRhf+i8ibC64RXAFtIpptG5N3TROTEYX6EztX/7XuVaooWhhw59HLpxsOTUFmsJ8qa
         ue08q8u36bVMeBlcwqUeqPgxLcnrRk17uxieOu/dlVtJLCqaMgiC2HRYFwjo0K4pu1oO
         AbdBYOdY6QvBoMB+CPSLG8ththr/T3k0MzmrZLUZZ0Pvarxje3iLngyjhxfmfgFJsSs9
         xzEWExSEdHG8p+vmtffQeHYimc06YJ91X0aawJpDFyxkHNIs9KNlIVHTmMJsAfRKLgq+
         goLqoQTFsKaem2Ou2Jj888pcS0SxGmdZrPSjZlcx08ekAI6gSP5hyscKEy4ckf5mSpV8
         HI6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253848; x=1793858648; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        b=fW8vYyeunhocd9sjuKg16HrN8GscPbXAmgUUkt+wKaB7wM5dW/9/ceUv5QA0I8lTaj
         zehouVvQ833IBwRnv/SWWwmSFjyA9XXcEDcwdQiSDGvKLmvQTHXj0TTre1b6kq7UAOUj
         JWfy3cxTDrXWEpeO2xfVL572xmdbHbQ+A2wggh/md5Hf95UaYwb3sehaPCyicmL3iTLU
         mywsP7ux4A3dfZ1N13UsM0lCUbKc2YnrL1o3O4luKawGAR/3u+yDB6nZBq0RY/vdZVHw
         B56XTUfcB4ipjkcvi6P4eKxcrzq/jZXlLBvxGi7MKCAu1umYjSnZQ06cHHGlilJJRNsf
         1o6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253848; x=1793858648;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jyY0mISq30/hBaQ7vdW5SKnqvf4R26xAX2ccXy18/70=;
        b=bMsFtE6kEwPTvdVg6429GgW4cG0Y4XyhQ7LVhqVgq7kfVelL+49HUbV/C44bEQDSP+
         zXez6R5qHXOkKwdlzCQthuWLVJy+8APmThsXp+hp9nxzIwn38iSzR6mB29SuSEJQ2wyR
         foIC4ex8Ehqb0w9h3OAcWkvusL55OIIXtZZDLqfKlkv8rh2Q4fFZTUC5nB78cXbOd5FS
         bTZin2gh4d+lZ6XgUEreQ4BRBowYK2FFgX00Dhs8o+gIBX5jgv6aTbVrsEbcCfgDLT1m
         PKqhBm3Mi1O5VI8IcKXmFsZi0EL5Hg193zRpalCJZXfVpKYDubVNmOJNvzJcnxbeas1g
         dkTQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7J3Butrc3zODK7kqVGKkaU85iiK9a221cSkjLnoaCTPKtxVic6nmom2v4MGK3yXjBsbKHeq03oohwmYg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJV6Zl7qRbiV2spglgoSQ4+MA3AAFqLXDXxWAzBCRfxoBKn1JDR
	tSsOicVWkd55va4isGlz8qs1YDScNzlTMY16kcITkDgWLantWU2+y/CwlJFAbyDyPVXWe0ty93r
	1SI+P84fIjlDDPH39ufWwjPEtQxJL/dY=
X-Gm-Gg: AYBFou33JooOfJcvB+PikDp6Nba8zgyv3ZETdq2Ls8vH6YW+Xhw5PWbffziPSzqJma2
	dTlJy+fzl0v57KAgC5CIhxPu8tNULlRxap+tyYT5tdMoqze5EIlHaG4lf00g5FgJwzHxFoM2gZK
	DWB3NdsBCr3+ZRhCFfgmxmsEhXIoWodP4JgHH40kintwl8FJe5SEtM+/kxQLUB/FAHSCK2EPEy/
	Pe4bCW6oBsXxDzJHFwvmf/q92NoFWDnNb0IjCCub5+bnHEUWUZER818UOFpHcSqSS6mwxFhdNs+
	7iQSsxoBvZ6c6WbEoqndSMRNRepd8yj4Ly9CYVSHgRF6zjPK5HWZkNGzTfbuAdRMFYl2sT+Kq6w
	nO37a764xfbhBbmT0F0YgiguXRaIQovTvqeI7
X-Received: by 2002:a05:6512:3f08:b0:5bf:a42d:9115 with SMTP id
 2adb3069b0e04-5bfcad31a26mr1709830e87.4.1793253847632; Wed, 28 Oct 2026
 23:04:07 -0700 (PDT)
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
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com> <auLbyon-KaV5Sw5_@gondor.apana.org.au>
In-Reply-To: <auLbyon-KaV5Sw5_@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 23:03:55 -0700
X-Gm-Features: AclHuK-DCy2JhmM1ocR9rPIODBB_vde0-q1YKusn4WlZiYizVxfQyHZpW4RBSmw
Message-ID: <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 10:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Wed, Oct 28, 2026 at 10:09:35PM -0700, Kanchana P. Sridhar wrote:
> >
> > Herbert, can you please take a look at this and suggest what changes
> > need to be made here, since you are the original developer of this
> > portion of the patch. Thanks.
>
> I think we should get rid of the changes to state->flags in
> acomp_save_req and keep it in acomp_virt_to_sg.

Ok, I will make this change, thanks!

>
> > Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
> > !acomp_req_on_stack(req)) here.
>
> Why do you need !acomp_req_on_stack if you know that the tfm is
> synchronous? IOW, how about just testing !acomp_is_async(tfm)?

I was under the impression that if acomp_req_on_stack and synchronous
tfm, it would go through acomp_do_req_chain(). Please correct me if I
am wrong, and I can modify the conditional accordingly.

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
