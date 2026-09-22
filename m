Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B593838BF97
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054134; cv=none; b=iIO33OGkTDUw6ASZc8/5qJpR6Itgtx5WO/01Q/lunRIArHpnj1jPbKhVYuQupTdEZs0c/VwGB60X/b0GBi52DzlJVNPzn28t+IhjELIGK/NCoSiOYfZE9i84Mtr3Eynuc66YnQupTKqHAcOV8in5dI6mVw2u6EWh38y4mFhAZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054134; c=relaxed/simple;
	bh=ubfpb2m5HU3YtEzZMpoa32QD7iyghjLtFLw7dcH/EXU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=I4YtcysCLEyBzq24v78MmTfh/FgmjqQgkx+H8Yg0OxfTfFaaWPPXTzWRlG0Fz1s4pnLq0KStJZFT3Z67aJ3vSVS7fEKu/wFgFQCwUfHx898InCt2FCjh2vBjEH+r9gpDLYZPJZy/6yjHvWll/7WqiNdLaRxHUnzrNjqcI1fmGi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHtMia+D; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHtMia+D"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso3377174a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 22:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790054132; x=1790658932; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+v2SnJ+erN2CVEopX6PENJdGxiYPbzH9Iy+gl6b1SBE=;
        b=CHtMia+DDWplNTiQULOsmitkeXcYRblV4YzkBWX7YCvTM8qckq35pt/n1tH8QByRHF
         jSulh6q6RE+mdyWZhQoiPFOquNhhniMC7Skpul8k017PtsIzNF42U2txuNIZUDv/xWsu
         lAthq2Wv0iyaWX/5l1a+p5of1njPQ/g/Kokyyxy/c+4ayiy4VNSJv8dye9zJUsR5Np9d
         4Eg8lQbFsIt7cYUIshwBCkgCZKMuCsTGhpiMbiL6EWom72JFJxB++U6bILv+Gunl+Urx
         y0aHPhGi3UQp+l5D/Pj1u7sInr+g2Yq0Tfiyo+tZV4LFT2ICSz9wI2EUIpLPEtl1umne
         XNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790054132; x=1790658932;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+v2SnJ+erN2CVEopX6PENJdGxiYPbzH9Iy+gl6b1SBE=;
        b=k4a1C58AM8UCaJW9bCawVgPtMhB3YQ19X6XSC0N2gnzwDy0jYl5MPMK8c26xX4iftQ
         0n9paKxxp9iCXZmFdp7SfNMsyGiSzOZ1FEklfqGZGcxeASEFEX5pHfEr4kOxf8gpY7FI
         SoE7egdH7U/BR8x9Hf8lk4o6w0Jc9NGP1T3iVoMqckXd1tokRvqgnJGVq3HlGL/28Z4R
         dSpCAIfwC9C8ciiu/ZrpJW/GAH+zpUwVUDj9vnZreAgBntr930jVhKVhA4mU4P2n2MXx
         8lTv7DeUMQ46EUPGPL+62XJYUQUH1UZPTmgioOzpHfAfc95v2saZyGs+gAEYp9Ewwtg/
         c5IQ==
X-Forwarded-Encrypted: i=1; AKwUvBwediH/lWqJxPb3/Vp5O4rMjPRtRX6XbyJXkzI8OnEIlN7EusIsbWzWS/7D9WCGnHaGIEsM918PB0AHaOM=@vger.kernel.org
X-Gm-Message-State: AFuF++lcRpXMbctUCIaf/GslGSxhSkKHaOt+d1U4A+/G1BmpUtRJzI0k
	AZtxu3du9EkWElMvNIOQWhw7HW3OjiMKXjwZcm6jMZviNRuOS2VndmIL
X-Gm-Gg: AYBFou0uEhRe74eYg+1m/jKP6C+hGyxLlRrzFdyX9UkXc3vsZjfhh6Gvo5bVFX5C8Wh
	FlsBr3eupgmsbx6haHuWkEXjyq68n/ZHygJk8LyOSnLqeL4LeZdsQWKx0Ft8R2uy3650JIMqi7l
	42kQ85Rl3kgvLnDt5o4oXbp8hP+AhJ8J56ZtITGNxQXrb83XJfXRZAPlHCIGr/wccqAeFVEUH/3
	QcBPoC6GuzE+jFFxCNbicMXlb4nES49c6UHnFpr6aNJW4l94X+hxgccZJ9id2JxS0HQSIwnx/Qd
	QlG+aFg7zNHaToAa2yBy20fprmCy1JcBltRc/uWvZDCekvenezdJjplBIIU6JplqrDogq6QhP+2
	qh/l6vfcK2wJ96OjYPaqDIlVJNbKLA4/klKW9E5dnZxRmB2cl55TqEH0LnwfemFiXjJxioaVib7
	TQE2oA00CEmJZ1qZ36LCi8SNpMapko1p93twHBUPDiCwgqH/biHeWTMVZgCoYg0wSJPO3uw8QfC
	13hkJwhMrzPCT65bQlIfeGmkcQ7AAOi8bLJupWEoX01onK9+UFxjjB32SuYvFmas/LoNkLZHSiV
	Yww=
X-Received: by 2002:a17:90b:37cc:b0:39e:6c6a:6579 with SMTP id 98e67ed59e1d1-3a07325025cmr4175a91.60.1790054132035;
        Mon, 21 Sep 2026 22:15:32 -0700 (PDT)
Received: from localhost ([153.61.198.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06cc3600bsm399617a91.4.2026.09.21.22.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 22:15:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 05:15:30 +0000
Message-Id: <DLLL8B7OSHQ7.1BTJDA25ZCGF4@gmail.com>
Cc: <bpf@vger.kernel.org>, "Vadim Fedorenko" <vadim.fedorenko@linux.dev>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Song Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Jiri Olsa" <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "John Fastabend"
 <john.fastabend@gmail.com>, "Karl Mehltretter" <kmehltretter@gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: crypto: Use AES-CBC and AES-ECB
 libraries
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Eric Biggers" <ebiggers@kernel.org>
X-Mailer: aerc 0.20.1-349-gb940a4174a3e-dirty
References: <20260922040413.28885-1-ebiggers@kernel.org>
 <DLLKN9WTMVHD.1601DUU5LBVAB@gmail.com> <20260922050723.GA14616@sol>
In-Reply-To: <20260922050723.GA14616@sol>

On Tue Sep 22, 2026 at 5:07 AM UTC, Eric Biggers wrote:
> On Tue, Sep 22, 2026 at 04:48:02AM +0000, Alexei Starovoitov wrote:
>> On Mon, Sep 21, 2026 at 09:04 PM Eric Biggers <ebiggers@kernel.org> wrot=
e:
>> > +config BPF_CRYPTO
>> > +	def_bool y
>> > +	depends on BPF_SYSCALL
>> > +	depends on CRYPTO_LIB_AES_CBC
>> > +	depends on CRYPTO_LIB_AES_ECB
>>=20
>> This will break the build with CRYPTO_AES=3Dm.
>
> No, the new implementation only calls library code.  And if that library
> code isn't built-in, then this just doesn't get built at all, as per the
> 'depends on' lines.
>
> I'm not sure what you expected.  This could be a tristate, but that
> would mean it would be its own module, which doesn't seem conventional
> for kfuncs.

I see. peddle back. tristate is indeed overkill.

>> >  struct bpf_crypto_ctx {
>> > -	const struct bpf_crypto_type *type;
>> > -	void *tfm;
>> > -	u32 siv_len;
>> > +	enum bpf_crypto_algo_id algo;
>> > +	void *key;
>>=20
>> No need for this. The bot was wrong.
>> Reading any field of struct bpf_crypto_ctx requires CAP_PERFMON.
>
> Okay, it sounded like a weird BPF quirk where the type system was being
> used to enforce a security boundary.  But if it's not needed, then
> that's helpful.  I'll go back to the original struct embedding.

+1

