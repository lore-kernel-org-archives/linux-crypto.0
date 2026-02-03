Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A704331B83B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770144260; cv=pass; b=VEUv9Ykh+0YWcHVYHZKscia0XttuMoBO4++AwhsKu841lqG6785XHt1RT20viLnnJz3JZZMp+j/HCKk+Vzzz3f2g07gGOV8tZsCjVmdTr9F7qUNjB/XkegOpfAl5+ntjjZ0TvP/gaJCIPfUEBK76kUJN2ItUtBefgTUYnwK7Z6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770144260; c=relaxed/simple;
	bh=Im4rgwf3E6ZwNtN9dEhHYqmY2ELHiRifIkUXHstQmAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJI5o1y1+RqZsxKmS7H8TXEuDpDpoSL451RU7DdysaPh6Ft+UhLSeF3td6nQVr0VbUm7nZ4ISYQU/Bf/K43ZRhetoMGv+4eyEBTIXO2qdxev6AAKrsUtfqKPpfHbGiqrah6+9EYwNqh0IhhNVwkDgeII7aeh4si75xcU1m3JrQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQvnCaJC; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQvnCaJC"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso4668036f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 10:44:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770144257; cv=none;
        d=google.com; s=arc-20240605;
        b=fxWSQ8i5m1/pa2gwdOSB3ryAnvT8ztyU5on54yT/nMtREoovnH+1fXhwsKxuqL6Utk
         qirlIfaqvvCz27zgoJl6EhsuJdShcDCnHVMHGHuxcSBKGnsd1CRUzgCM3vBaLGEJu4Ac
         F+bl2LtVjo1GKTWLAaacAagapf8ezQ0y5v3Fq+CIPma0/zsgdI4ZUMXJdo1kospfza8G
         KgURfZ/rIaDH+GWgxRpgonykQkvPmaLRKpi3xGnhcvDdjSIfiA9Ym3OOIOmVpl5zYktj
         +brx11CDS/0LKE2AOYeRA1yOFf8jS6SKNm46cA+Lb4+OE9HuNs8arm30eLUPF3W+AYsW
         jaiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/eSjMPi8545w/2b1wcpinwGLR1TY3uQV5L/lXYN5do=;
        fh=IySAr2kmCxcgF6vdy5GJNhmGD6i1ESTiwI9lSxeXrtU=;
        b=T6Y+FzE9xPTVqZrEahX3KPOz/93xGGpJk8ToNyZdGltkhBVpbbL1YEdppq5GDDKFu0
         osiFc9PmB7ECoeHlb8VtdN+42dsvbLQaPyC0h0B7C7VkQtrt+x8B6pQa8cfbMF/PyiLB
         lq6+o9nlBG4iRjJwdjbpw7lhb2XDrw6qez9suNJ2AbkU/TkwPWo8hBSJzu//6i18sLPh
         MVEOEM+Ljgq2zaH27WrEdMmZ+jFM8dZStKpBtzGA8gpR+jgLtIwHHrpXHVqYybzgppN9
         3jXHAXkpAj8lrZYFxhv3NOLlDwD6e7DqswC0Ajr1zymj49d+yxMoVXCfVbw9WJMiM4Dl
         ch2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770144257; x=1770749057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/eSjMPi8545w/2b1wcpinwGLR1TY3uQV5L/lXYN5do=;
        b=iQvnCaJCty2JIWhQas86REZ9bYZlxyM45VOMQ6RnhCNLXlwVCSDYNvll931NLtifbR
         hkAryy+iivUzgKsYedtYuHtmaxe8G5f3R8gc2qYAuxCgSlZsIqkfuSNg9vKqMKQ4flX6
         A+0ZV3bocn46aKIp5knSSv1sW1k2DyLEPiUOuG2tOAOb4fjzFpC5PaLa0WBluIKQa14+
         +GfqN2SFNcHT1hgLr0RQD8prLprdnem9PGEpADRaR6mKEXRz2ksjz2R9g3GDISWVR9x4
         VVzqdY9fPgA6qrFBvFpVG6S5Txmqh640NKw+wswhOkQkr2IrNQqLll0UR0AKV7wBGE15
         +oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770144257; x=1770749057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y/eSjMPi8545w/2b1wcpinwGLR1TY3uQV5L/lXYN5do=;
        b=wVFynSvYAmxu2qlFrGzhNezxhR3lTH4D8879g0obkbeCxXejZFqfxA5OCZoTh6iB5e
         zozPxqwHv9vGyibBjZ0qqBdrIpf1PGPmBP20L3VQ7DUOMPDA3y0nrs5nlg+EtC1Vcw2c
         easbBPseW8yLoDYkLtF9rDHV0mnKDxIY2yEB14S5nWM7SU7Z2Jc0jL06P6ClbT57jERq
         D8cI/rYp8v0mX3uZl00KZGgTdq9Rl/qFKeOO3rXlWE09TOs2UEAC2CwC16cTMWOAWNJ5
         IcwZ1adwejjfmKv14NxHPzrhW2ro2gx15SxxreUcOk+1kkr81bVRD+AXDUU8mBg4+1wc
         lwqA==
X-Forwarded-Encrypted: i=1; AJvYcCVMyqnGbGsDma/TnTg+jeZSYWL2cGdzCXDbFhALlQ9KLm+sTItTd4P4M3Lc6ld0DErdG3epa3pVGKcUcC8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8sZZTlXhtyW25cRCFqFMOnavaaw3j+Bl/kVmB5mqo5dQJZGpW
	qnL4pRSmbUG2bmI2Z9CyQhiEe1Pyh5eBRGwKJc7s2+qO+iboKuY1GorPsOfeyEqGfOo752Qvkcq
	/RuoaD5XRLARuU62gX0jp5zblkpztXOo=
X-Gm-Gg: AZuq6aIIUWjHwBdXZd9XkV5OMrr0cqcmkMSonytIg4TQjVbKSKIMGHL8u3B2TvSuyuC
	MZ2HFDMWaWR3cQSRKYGYSnSPCT8yXY4sPOw+Hl+ER/Evte0gwvGpxxUpov7lIYqzk2iGjAR8ZBh
	usblfw9EBiSPj1NEQo8HT1ghXPNgERM2Zdw6jo/SjzGYp7Yt0PwlgN4a6wf8DrgzFi2Z3jqKJrZ
	yuhxr++jgWiSOFYBreLI28VQpgeDGjM5g2sooDRAMRShpTVkziUW84zDH5MP4GnViO0slm56OiI
	YJRe8X18zuHFktxYEI2k930qooaUMWQH8P0cstsC3sYDO9a6BZfEf0XISOcP6obOzE0UuA==
X-Received: by 2002:a5d:584d:0:b0:435:8f18:9539 with SMTP id
 ffacd0b85a97d-43617e3970bmr476836f8f.9.1770144256833; Tue, 03 Feb 2026
 10:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202144749.22932-1-git@danielhodges.dev> <20260202144749.22932-4-git@danielhodges.dev>
In-Reply-To: <20260202144749.22932-4-git@danielhodges.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 3 Feb 2026 10:44:05 -0800
X-Gm-Features: AZwV_Qjuc4yRZMN8e0jw82q4VJIVoJ4ryoLzyogKn1pKbtGVyVXGQl-iYAU8hyk
Message-ID: <CAADnVQJKjv5fZ0suJkOKtybMNsrDr9d+Au8T08AvHCPzP3z8sw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 3/4] bpf: Add signature verification kfuncs
To: Daniel Hodges <git@danielhodges.dev>
Cc: bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, Song Liu <song@kernel.org>, 
	Mykyta Yatsenko <yatsenko@meta.com>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yonghong.song@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 2, 2026 at 6:48=E2=80=AFAM Daniel Hodges <git@danielhodges.dev>=
 wrote:
>
> Add a bpf_crypto_sig module that registers signature verification
> algorithms with the BPF crypto type system. This enables signature
> operations (like ECDSA) to use the unified bpf_crypto_ctx structure.
>
> The module provides:
>    - alloc_tfm/free_tfm for crypto_sig transform lifecycle
>    - has_algo to check algorithm availability
>    - setkey for public key configuration
>    - verify for signature verification
>    - get_flags for crypto API flags
>
> Introduce bpf_sig_verify, bpf_sig_keysize, bpf_sig_digestsize,
> and bpf_sig_maxsize kfuncs enabling BPF programs to verify digital
> signatures using the kernel's crypto infrastructure.
>
> Add enum bpf_crypto_type_id for runtime type checking to ensure
> operations are performed on the correct crypto context type. The enum
> values are assigned to all crypto type modules (skcipher, hash, sig).
>
> The verify kfunc takes a crypto context (initialized with the sig
> type and appropriate algorithm like "ecdsa-nist-p256"), a message
> digest, and a signature. These kfuncs support any signature algorithm
> registered with the crypto subsystem (e.g., ECDSA, RSA).
>
> Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> ---
>  MAINTAINERS                |   1 +
>  crypto/Makefile            |   3 +
>  crypto/bpf_crypto_sig.c    |  89 ++++++++++++++++++++++++++++
>  include/linux/bpf_crypto.h |   4 ++
>  kernel/bpf/crypto.c        | 117 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 214 insertions(+)
>  create mode 100644 crypto/bpf_crypto_sig.c

Other than the issue spotted by AI the patches look fine,
but we need Ack from crypto maintainers.

pw-bot: cr
