Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D820423E9F
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137204; cv=none; b=UCprUHLQkvseO2DSksWJ16YwzRx3vp2aLqzIA9TfHjf5+WhzfXdxnTfJ7MaiyIduSrB9RmgqS041IkYrg4lk/F107KTQiWB5spdJPuKkpLlrg3YacauNjhdvBi2eRLaLSpqy97xbxDNH9J61NU/rvRxBPlqrWAAvK/aJPCI/wqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137204; c=relaxed/simple;
	bh=B4IzSxY5F+HMjumQYpLQgv1VgHUd/a3qHH2cQv2H0rc=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JN1rpHdSguR9sdlPXtuxvW3lvEijQyk9Q3ExBucOBTkr4L4vjhov+p0D+KqAtLDhhoU6rBYsQ26MvC4HXPyJdgh3/vZ3fDj27VBzXBysqwiDCbQcF+Ibig8NU/jGKsHk4eInwiQDJc02/5Ruao29haT9cWJHsjOuL2U1VmbGPSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dT5tTDMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dT5tTDMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5021F000C5
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792137201;
	bh=B4IzSxY5F+HMjumQYpLQgv1VgHUd/a3qHH2cQv2H0rc=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=dT5tTDMVwARRICgF/BJtr/AAl0dIOaT24SeXD5WFiEgDpxXdnXhjnBVsg3GZLDih2
	 Z6CPE9XFxQmC7TaQjQGhJUJwPMR39f6/UZh5pKalCqhaRZz2IFMXKEjeLUfOhgemmy
	 mJxSF57AAHR3yeSudCXeaeufm5LomhHETaK77JWwFYpfMoTbGNCWptuzjT6ZHA1S/e
	 Stqe+TUw6gfJm47IcgWoW69FRg/zeyO9GTOQQbcRQezTFXn4M2GmTIg1BD6G8o2cs/
	 sdc1LZzU3KLFdP2AlS8bdZD85bXP3zluUnCfCRgP6/8Yp8fcb4G6UqanZpqYwkQNt7
	 REUgWELe6y61w==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so4398400e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 00:53:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzMbIwXE9edZwwb7b6zIT59RBanl/zByBS/yY1N9fhUk0mrTjXFOFDIGavJXcQ6ZovwcQiwBuuIIjs3Sww=@vger.kernel.org
X-Gm-Message-State: AFq9FYIucAVeBdvt0jZvJQ/XVzhhoXsugEr8vkmaP0JbbYzUBwaeBr21
	ExGslYM6LDFk0I6nRD5hmdbZXhiWtvV/+f2fJUH20RaBN+LP4qiRnntKcx4Z2ppBDZio2KjWaiv
	zlGUHzBVrB8ACBRI6dNcE4Mtl/QZjy/XatlhF20y2YA==
X-Received: by 2002:a05:6512:2399:b0:5b8:f9b0:5779 with SMTP id
 2adb3069b0e04-5bcde35b9f5mr7386749e87.8.1792137200300; Fri, 16 Oct 2026
 00:53:20 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 16 Oct 2026 03:53:19 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 16 Oct 2026 03:53:19 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <atGIRTRuhFILV9pz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
 <CAMRc=MejhYpC6QNXwK_cG_NuJs5XpOviK2NPsEwtnK0RxDi61Q@mail.gmail.com> <atGIRTRuhFILV9pz@gondor.apana.org.au>
Date: Fri, 16 Oct 2026 03:53:19 -0400
X-Gmail-Original-Message-ID: <CAMRc=MeNk8RSRPvd7u6ZsrTk=yT6nWiEGuB8ARb_mV8tDdpWHQ@mail.gmail.com>
X-Gm-Features: AclHuK8gYInkzaF2IUtMPvsqDxyb_UtfI2wLBn_4ZvR4nTK7V8zh1xtSkrWeKJc
Message-ID: <CAMRc=MeNk8RSRPvd7u6ZsrTk=yT6nWiEGuB8ARb_mV8tDdpWHQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/14] crypto: qce - Fix crypto self-test failures
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Thara Gopinath <thara.gopinath@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 04:13:25 +0200, Herbert Xu
<herbert@gondor.apana.org.au> said:
> On Thu, Oct 15, 2026 at 10:49:37AM -0400, Bartosz Golaszewski wrote:
>>
>> It came back with some more issues. And seems I have a build failure midway
>> in the series so that needs fixing too.
>
> How about breaking the large series into smaller chunks?
>
> Just make sure that each fix is independent and makes an
> improvement without regressing.
>

Yeah, makes sense and likely will get the changes upstream faster.

Thanks,
Bartosz
