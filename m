Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655910;
	b=DryQpE8hwUqMVgP+vBf5yF4/7mzlbGb4wnEckUMyINS0aGcg3138FThIwv/V6GzcGnSO
	 nZ6UwbYR5eAT51v0wP4UgimZkC+XynGwebChkb7dFqzZxHXkVi6GSNThAHNNmF7mUCt2s
	 xO0aqiM6XfQjG7FlYLMmc9QTIBM8+ujj+6hSk9O4ibYpQFBVra3BNBLPRu0Igwwrd2Cc+
	 1DRuATgaPncbkcVOJZA+8ST/VucNKrA6DTB46GDRvTbJvgUQmdyCCEf8G7dD6OKem28og
	 m/z80C66Y8vP+K+9qv2BIuOh8ny0yQJwM9rnN0yD2g/SVGUPQxAI/Xfk3BcWs63QfLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655910;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:Received:Received:From:In-Reply-To:
	 MIME-Version:References:Date:X-Gmail-Original-Message-ID:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=DOGsbHPV9Q6LEJI4bp7YU9lC5DA9e4STqXoDKb5ejb0=;
	b=uFEBROFk4Ykt1Ir+U7Vt0sdXTKpHVRmffRrUywZHJ7w0eLj4beDYXv6BAtlHld7xC9Sv
	 o1j5Zp8ye8rzffBMsrCkoNGmrPkC9HKcsXnQj4w2iaYKijF5NQrI2uHEHYMbAbEEZas3y
	 DIxZ/+dkVffYRGRVcsiwd61Rz1HzTjLJlGGeGnP/stagN83V+ebdJJlFt6y5aRzarDXBI
	 88/I+Z22Zk8JeKUbHhD8UpytNmtqiPBomI62KYWZJU0sCt2XbWuGRXI33H2HDREBl4hWS
	 1Kl8VUIszhvrT34F5X+f4VmBJDOFT4Z3RV6xOCNKobMNYv6Hdkp2XfUC7aZBXsiUJsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M76WzVlP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61386606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M76WzVlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F351F000C2
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792655910;
	bh=DOGsbHPV9Q6LEJI4bp7YU9lC5DA9e4STqXoDKb5ejb0=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=M76WzVlPBD5y4IqVS2atl7PqIsbChiueyPRFZxYypwtus+8TtzwLM94gtwqzkzIi7
	 Uynjkei/JU0SDmBsWe1Nk8I3NJSux6STZOQjVQ1eQfOQZz6HffJeHfd/TzpY15o8kc
	 8WhqCoOFQ0jxu+kkVBQNE/Yx7na5wbewb9gOJL1F8njrh6otFV4Qkg5psTGcxAq8/C
	 +zth5lBobhZL4ML2CkEKJIHNRBU6e0m6mO5QdVaQxiZpgQzE1zsViAQ+u4M5ONY3Mo
	 Uzi2d8bmao4mA3WvpxO2Ei34QzcdEAV4CGMARW/VfVP8A622QmeMYJgRcAo4DAgXmF
	 o7l9TiqPsA39A==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3a65ed9c7cfso14019321fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 00:58:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwLuCWWKLv2DphKAWJK9EsD3eV/keG7koPlOJ2l2dI9e6WFS+UVO5uNwXtcmGLvnXiGIiif4Mc6ErxnkJI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKHzQej+p8Q4pwdb1Hp988W9dFgZqBibj2Jvo7Rc1ob/okJ+KvY
	QMzNgDlteU6WuWkqGtyCS2OHC0AgYfUk1efsh4mzQoxgZFdzrWDBRlhz7J2MQKtmLyb6Krz4il4
	Yhf92SoPc7s8OqKhT4JYGrJ2hF7KkXWAL8zLdPU2MEg==
X-Received: by 2002:a2e:a9a5:0:b0:3ab:48e6:6789 with SMTP id
 38308e7fff4ca-3ac4414620dmr13295841fa.8.1792655908769; Thu, 22 Oct 2026
 00:58:28 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Oct 2026 00:58:26 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Oct 2026 00:58:26 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <179261435862.92690.4559755086697722828@pm.me>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
 <20261013-qce-fix-self-tests-v10-10-57162a38a554@oss.qualcomm.com> <179261435862.92690.4559755086697722828@pm.me>
Date: Thu, 22 Oct 2026 00:58:26 -0700
X-Gmail-Original-Message-ID: <CAMRc=Mc1O-xSOt9RNTTF-ue_3skkNoQ4a0h7RovbCbQtexKkdA@mail.gmail.com>
X-Gm-Features: AclHuK-ddH3eyHdZmxCdnhGchR5nIcmlb3fM-yPWg22T-Acg-ykEAHgaJMn9PAk
Message-ID: <CAMRc=Mc1O-xSOt9RNTTF-ue_3skkNoQ4a0h7RovbCbQtexKkdA@mail.gmail.com>
Subject: Re: [PATCH v10 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
To: Birk Skyum <birk.skyum@pm.me>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 22:26:23 +0200, Birk Skyum <birk.skyum@pm.me> said:
> On Tue, 13 Oct 2026 11:57:39 +0200, Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com> wrote:
>> The self-tests for this driver have been fixed. The crypto algorithms
>> are only registered if the user explicitly requests it with the provided
>> module parameter defaulting to false. There's no reason to further keep
>> it unbuildable with the BROKEN label.
>
> On X1E80100 the BROKEN label also costs deep sleep in suspend. With
> nothing bound to the crypto node, aggre2_noc and mc_virt never reach
> sync_state() ("sync_state() pending due to 1dfa000.crypto"), and on a
> Lenovo Yoga Slim 7x a deep suspend on 7.3 never counts aosd, cxsd or
> ddr in qcom_stats.
>
> I built qcrypto out of tree from 7.3 with 09 applied, which is what
> this patch makes possible in tree, and loaded it on 7.3 (with distro
> patches, none in QCE, the interconnect drivers or the driver core) and
> the crypto node as in mainline, with ALWAYS tags on its paths. It bound
> without registering any algorithms, went to runtime suspend with both
> crypto paths at 0, and both providers synced. The next deep suspend
> counted aosd, cxsd and ddr, with about 13.7 s in them during an 18 s
> suspend.
>

Thanks for testing!

> Herbert asked for the series to be split, and the resends since then
> don't carry 09 and this one. Both should come back as fixes, for 7.3.y
> as well.
>

Yes, I'm waiting for the fixes to be picked up before re-sending the remaining
two patches that depend on them.

Bart
