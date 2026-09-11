Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17303D9DA0
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 11:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125305; cv=none; b=vC6+ng3l2Y1AaFmdsn9CCXNdSouf/H+1/cMQ5Zz6ceGgRRCdYl2cHPzvffSKQTzbr6eaMMBXk7PELNMgOVV1j9RkhH83koZOHogGb56GwT5EzWLbd2fv325R5udcmupXQ5KwpiH5GZPbudWQ4OCUjYlOKhv8uWErAhSEsphMcPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125305; c=relaxed/simple;
	bh=LEsCgJDV7Qwh0KR9/MJDd/4pylyjqc3G7vroW6CiIDY=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oLvPy1PFtW6RHziZfh3PWgWEaYnSl2VBr5MKkzB4h9OmS7taoTGJieUvb8Dk0Q/BGXgR3HvKvp3Lqm7c5PFwZaovBWNlH9PGzeOvqAhRehEuaGI5k6Z/EQT/pMvy/yuwogpbRYpiCkBEG9lKQ0genID+MwRi3R533uHd3s5fzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AERez5Ce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AERez5Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB221F0089A
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789125303;
	bh=i6fF001uO3QyWKCI79lM3f6D4gfTdBlCCL5WGnNYy9k=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=AERez5CeVjV3wuixa4uCilDJs0J6i07PyFaLZxv7OCqNyyFTFPY+bWzOqlAaZR9Xc
	 BM0sNUyopzJp3KDHQ7afrI45TSDY4dKYsMXnsLE7k+k/IkXVEtbO7wgYjRobO1tzun
	 9b6+mlfN55y7NwtGLQ72SO7EwJ6EHUhskLNSgylTG0At/Ut6VyOdAS/8PLaSE0n/9O
	 7kXyoVW8A2ds8XqC0Uipiz/2zFrawJ2LIkZEEvKQGg+j+DfTdWnqiICIVTAtsUyfzi
	 33kOvqU6ToOcum1zNCKXwuzX9Pcj/2YCTG/9oZjAekJBHQ5kY+FmsKBIqyuwaLoklZ
	 MOoID3yPyvA9g==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a58f2ce443so6555731fa.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 04:15:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzdQgJyjCUyMzJfonk7t25h48XeQ+tNZdRZMfrwJEg91s+YScNFSsJoqAmMMIa4s8wZE8fZpnjlbYEFpTg=@vger.kernel.org
X-Gm-Message-State: AFuF++nSZb5oG29nHfey1lgJ7ZOlGSf1+sxeIMCcpho1G5E3i3w9pIFR
	Xnrxpn6LLte6WxMyvM1STUlfYQd5tN9B0rPGc+90kaz3ZSr+c3wIib/cpf5igPs0oxnsaAYwJoc
	tFwi/LpkRjHNJ1WjGudVRYLVzPAQI6tWKZ1vgLJ75Jw==
X-Received: by 2002:a2e:a551:0:b0:39a:d7f7:981d with SMTP id
 38308e7fff4ca-3a5a5211074mr3617351fa.12.1789125302047; Fri, 11 Sep 2026
 04:15:02 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 04:15:00 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 04:14:59 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260910143140.GA5719@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com> <20260910143140.GA5719@quark>
Date: Fri, 11 Sep 2026 04:14:59 -0700
X-Gmail-Original-Message-ID: <CAMRc=McDHXWRfYTwRasdBCXMnoVkXK9T7RB+gBNgCsGof-euyg@mail.gmail.com>
X-Gm-Features: AcwNN1VYNh5-_PFnYFaO8t33K-oT78fIcY6HR8IQ9xdQIzFdoo5pwgYwp9o9EZQ
Message-ID: <CAMRc=McDHXWRfYTwRasdBCXMnoVkXK9T7RB+gBNgCsGof-euyg@mail.gmail.com>
Subject: Re: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Sep 2026 16:31:40 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Thu, Sep 10, 2026 at 03:00:50PM +0200, Bartosz Golaszewski wrote:
>> All self-tests now pass.
>
> Have the other bugs that were reported been fixed?  For example:
> https://lore.kernel.org/linux-crypto/20260723202704.GB110634@quark/
> https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
> https://lore.kernel.org/linux-crypto/20260723205342.GC110634@quark/
>

I will get to these too. For now, the series allows the self-tests to pass,
I assume it it's enough to not keep the BROKEN label.

>>  	help
>>  	  This driver supports Qualcomm crypto engine accelerator
>
> As this patch would make the kconfig option visible again and would
> result in everyone running "make oldconfig" being asked about it, it

I don't mind changing the symbol if you prefer it to avoid any accidental
`make oldconfig` carry-overs.

> needs to be fixed to accurately document why anyone would want to enable
> this option.  As you've stated, it's actually just for "testing".  The
> false claim that it's an "accelerator" also needs to go.
>

"Offloader" for lack of a better word?

Thanks,
Bart
