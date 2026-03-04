Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB53822BE
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616864; cv=pass; b=o5bBVTO9uQdySuQuvY0j9aJjCeuqf+zfKLH0LdKv3IScucnZRQOHPglmmXGdfUdC38HCnQ40dOymzce+81vdRWJCc9UqZOLsQ5NOhHP+LwJvXwfRCimkLbYIQu9Udx368GKgLKOVAplnk8n+h88WO2caACfmeDcndlKgANnm8pU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616864; c=relaxed/simple;
	bh=y/IodG72ain56etKDWqgOhWo0kDWmLIz80nuiwZ60Lc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=br1jpLkkSTBsUHigjozl68sYE3PB4k09rtBcCqdO4HxpcZOgW2+dJErZv66nxz7pDVI5QL50Rtgow17+NCr69lUwCl42KkM+g+BGYGpZF/2mZWECjEY6Fp9SC9bOhoHP5R1UCsL7/OiJQNUPOS5Bn7Xwgwm6KhpIF4nja1MYEwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UuqmGmN5; arc=pass smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UuqmGmN5"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-415e568a7ecso802404fac.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2026 01:34:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772616862; cv=none;
        d=google.com; s=arc-20240605;
        b=GO8k1cGrtJcaPXPGFbvgP6goY8m1zJ/sNWvnt20xZd1jYFuISlkjolIWiaylKykgwH
         +QteoqZsAT3BnjoC6gRYisCwZX9blj6CtFWD3P3S5RPWXUp0WLqvY5oKGUVzmwdH23y3
         8lcH857wpCgRsqPTbc3TWKWyyj0Jo2oyKVYuUsshWTiHI381ZRPsu9EYqwyVxi4mgE/g
         8ckTqrvOJ9OA7Vq7cXekho9LPGKlnWFQsAvBgGoovL0XVBZkkwV8216KZyBz2QfJyXQ5
         p77rAiJvYlQ2BGDHnMcD7DxVhSnovEscPuC0KY+M3MC4EtI7brWREDh8+Fo5z4ww2sXW
         o9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7hb6fY86/FrgvHUqwzAV8MUgbDVO/vkX1bjsm+eW84g=;
        fh=OfpdFOyKhp3P7PBsjdC3r21L8XDw3RQvB/TP4afepaM=;
        b=Xu8DyENxdAHB6dFiVVHP4dcFF262QqwrMmFdxT1MumBG5NtoKqYqq9TJ/rUgdRCyXY
         +FBT1jUdJu3u6elDcPHnZtCkuNfNErDPSsJ0CPdIIVeWfKvWbNGzrFDKmKPGRR2lpXuu
         t0lFgcO0LU+qzQbWAGx2RnfJu26AdC8BbBZWyBCV147q/Z/n27kLqxkNw2UMu91N0Dn9
         uEUfVpAD9PyFBbHEhXNJYmo9uAV6zxK64Oh3bLL7ArQOrIvxEx/+8kB+wu+DXGMFqxKp
         x3IWXFzpvp0ps6b6H7jpTqc7kHufOIdgT+9OfxiSbDpr7iPSoo1z05OY5TdzScfKyvoE
         rj6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772616862; x=1773221662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hb6fY86/FrgvHUqwzAV8MUgbDVO/vkX1bjsm+eW84g=;
        b=UuqmGmN519Um9aPROx/g8S+jeBN1tF314VUZy9ssa3PfdszifQDtJhjAJ2y8np6S6G
         Fd0QWpDbIfDPrGPE/pyl7cIIqe+DJaDMvJYHWZtjmWvvcRHe6cNNeG1JkaCA8LiB+AuO
         n3NNWNthW2QlwzCpsX99pm+HtA23ayfPuvojIySqM+ccXK1IFHDxDPeKPkmyu+I9wnWL
         VySncUA8bV6E9S/PyqzH/Is7MMIum3ztli15jPs6XI49gzsI+NVuOhAasFHgz8bf+nlW
         XHFoqQnxM4xmOEvCrk69MC0t5m87o8YeMMdrr7zJcovhQ1f9XpisXQRGxYEIR594lt+R
         Q11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772616862; x=1773221662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7hb6fY86/FrgvHUqwzAV8MUgbDVO/vkX1bjsm+eW84g=;
        b=nudsjQTFfB9qDgrTqx/rn+wCeHZtLjnec8O1KwUMbRcrn8gagTqcFd5p6bWgXnHcw4
         bDD4Cv8xojqxgongcwQ1wT7IXcX4UQxzp2jkP0LFHzJhuI4q0EVIpESrE8JyQiRIqBih
         BB9o8VMDR6AEtjN+GEI3IfiQncx+5O1UGGNqgUcz7VRCCcuQftyKrpm0UA6Bwt9lkfyo
         Hkt18INuzimhjDzSQK9B8x4r+HXZHqzQ56UvCxe3I6KpyMd1QdwbzOLnMKpQkygyfqr2
         mBXc1aQPewM9gUYgDB3oiK9Q7n88EMV8GneYhKqnDyGBzyM7tTiBcr0lob1EzGijhz+F
         h4TQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8v2XISyNGMJgGOIrfRrawfaQhAJ4OP1MVNbMwfWR9utLgUcqZ41kSNEurtOyc4uD6dDl8Xa0GZj77xdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeWV5IJcOUVQqETiIClzA8eTPE787vPl0wb3O4BUQYsYPPbUrt
	rRWj9XajaWZT0N8i4aTMmqVmHwm5ezqFORTmFmPmY8dppnTHtbg3wcKzuy/wxPiiWiJMk3tLgPI
	uE308XCQtQtrF6ZMxP/3Wtxwl5WDh9SlOeasitMPgaQ==
X-Gm-Gg: ATEYQzwzZEpYKgM5PiR+JZLhu4uGawcf5nk/oOK75SCiKdYl9J1wbytAEsJdPxMhulP
	3PVyaARGmRm7Buxemt45SiEh940BVfLiBPOVAChImTD/dKtE507TbLAyw78GStR9xBVR9k8mpBR
	4iwAodghn6xmFxFwhzDB7I9stErA+3m5ORnOecbAyaKkzYFmGvuo5eXIpIa+NAh7TfsKDngAJMF
	YCoi5kHHacU3Bqfeh39TE4A/FLubpehkB7MN825Avi4Yxa4jVhn7jGGGtE99nyX42iEfpmpIuIt
	Bsl1AgcWspNxRIW3RPSQPM8HKsQ8g0r1Iki7viuR2ehGZF/e
X-Received: by 2002:a05:6871:112:b0:3e8:8e56:671e with SMTP id
 586e51a60fabf-416abc3c442mr740209fac.54.1772616861704; Wed, 04 Mar 2026
 01:34:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126-optee-simplify-context-match-v1-0-d4104e526cb6@linaro.org>
 <20260126-optee-simplify-context-match-v1-1-d4104e526cb6@linaro.org> <aYrAeEiqG7iwXm_w@sumit-xelite>
In-Reply-To: <aYrAeEiqG7iwXm_w@sumit-xelite>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Wed, 4 Mar 2026 10:34:10 +0100
X-Gm-Features: AaiRm52FcW-OAyIi-wAaObIfx0MwPHh0zbRqzlqQxviphSbb0F7X9gKg8pS94SE
Message-ID: <CAHUa44G1+C47KY8UCV5+ype-NCjYPfgxFs_tivmsOA=R-H1C8g@mail.gmail.com>
Subject: Re: [PATCH 1/3] optee: simplify OP-TEE context match
To: Sumit Garg <sumit.garg@kernel.org>
Cc: rouven.czerwinski@linaro.org, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, op-tee@lists.trustedfirmware.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-rtc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 6:22=E2=80=AFAM Sumit Garg <sumit.garg@kernel.org> =
wrote:
>
> On Mon, Jan 26, 2026 at 11:11:24AM +0100, Rouven Czerwinski via B4 Relay =
wrote:
> > From: Rouven Czerwinski <rouven.czerwinski@linaro.org>
> >
> > Simplify the TEE implementor ID match by returning the boolean
> > expression directly instead of going through an if/else.
> >
> > Signed-off-by: Rouven Czerwinski <rouven.czerwinski@linaro.org>
> > ---
> >  drivers/tee/optee/device.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
>
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

I'm picking up this.

Thanks,
Jens

>
> -Sumit
>
> > diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
> > index 950b4661d5df..4c85b04d6004 100644
> > --- a/drivers/tee/optee/device.c
> > +++ b/drivers/tee/optee/device.c
> > @@ -13,10 +13,7 @@
> >
> >  static int optee_ctx_match(struct tee_ioctl_version_data *ver, const v=
oid *data)
> >  {
> > -     if (ver->impl_id =3D=3D TEE_IMPL_ID_OPTEE)
> > -             return 1;
> > -     else
> > -             return 0;
> > +     return (ver->impl_id =3D=3D TEE_IMPL_ID_OPTEE);
> >  }
> >
> >  static int get_devices(struct tee_context *ctx, u32 session,
> >
> > --
> > 2.52.0
> >
> >
> >
