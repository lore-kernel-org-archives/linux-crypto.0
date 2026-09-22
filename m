Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154F535FB9
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 11:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077962; cv=none; b=cAT25+50KKsTlaTLQj74i57h1ldLS9KsRSqTB6+uAojuvncNcElMMZUlRttoDikXeZ9mcTcAt9x7Ho5BZcLF1v6fsJqqPhywjHp6GQySu/Fo8G06P3NpZ8TzMkXjUxuTqH59tAkAxLqHDf4H+w/kezRj3p4v5K58jeqM4z3lyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077962; c=relaxed/simple;
	bh=V8+MeDra6cSjzL6gWqbC2+T0T4Zis89/lQ6OEUfYBGk=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gOsTgVZU4JK4uubwz1TFcx7f5VODHafuNeiSKwLq6mDN3PgnOfQokv9QjoPSBdCb2R4Tycsg0gIWhPJYVjcPWnPs1uQBY+6l9A9ZIG7EtgOQOf8z5ygwiJpVl2uDt8DFXbqy3OQOi6Uk1GfETqwwRQVcdX9SO9zfy6A+YNmczH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivnD1FpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivnD1FpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C7C1F008A3
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790077960;
	bh=eP5mxCA22PcDYQqT6PJN84Q1ZYL8VkL3j8RWyf4Xjt0=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=ivnD1FpGeR92WYrsVhCHMkbo3bcYdeer6lZwM+4QriN1gfgXmSgnvOMY7t+uMRwPX
	 gbQQ3ZwJjllFNhMuZh0Ul2OYtIB/QzaSi0R5k8O4jrWL4CxjNjZWJWzg1dMdX8PNAG
	 o68dwnh1wWEs9UcInz+x3YwXkeMC4Ic+yBcyMFZ+e4poFSDb36xwnpr1s/QwiODdoO
	 rGtBEb26r6FZIJCv+/Dmm3mFIqvrICbut5Df0a/8T3EdWZJoFarku6fsLkRE3CBb6Z
	 cr7/uexby8cmOKLLVOee6YnoRtOkYvCepqxpiyoX9bk04pLejp1Eog3ANo3CzTBruZ
	 wxLnK32OarWBQ==
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f16cd1so3670166e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 04:52:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBybexk7bjZ3imhNJMtW90vaZh5IHsQovVHUtytOj6vw9Itwf4W8Gz5y3eJZHXO/8Go1g76rvx4iOAA2o7w=@vger.kernel.org
X-Gm-Message-State: AFuF++lv8QTVmObVJcb8iSz6PYaHtz7v85SJ2RBwhMS93wHvTxbRh5E8
	bFe0hKAtrCH7eqPDhN0TTrWVVI2p6xV/9Q29kWD4YGpOzVwkwqPgB5cG3g8rNpRiRmyGHTAEHPb
	Q+VTNDUvOBTNKPUsFFnuCX7jG1GCsz8OwoJbz9HImHA==
X-Received: by 2002:a05:6512:1394:b0:5b6:4ae:a3f6 with SMTP id
 2adb3069b0e04-5b8c1833f9emr4493348e87.30.1790077958932; Tue, 22 Sep 2026
 04:52:38 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 04:52:36 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 04:52:36 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <arJGAjRRC-5EPjH6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com> <arJGAjRRC-5EPjH6@gondor.apana.org.au>
Date: Tue, 22 Sep 2026 04:52:36 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdMbAw5pfOOnV0ppdZyKqFe8c+ypt0e92vZqxhO4dSmGg@mail.gmail.com>
X-Gm-Features: AcwNN1VABbac5dFrDJiTxQAG7Ey-cY0fj19Y-QeBI1gWJEBtWlgt5w23NbxPNkM
Message-ID: <CAMRc=MdMbAw5pfOOnV0ppdZyKqFe8c+ypt0e92vZqxhO4dSmGg@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] crypto: qce - Fix crypto self-test failures
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Thara Gopinath <thara.gopinath@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sep 2026 11:10:26 +0200, Herbert Xu
<herbert@gondor.apana.org.au> said:
> On Tue, Sep 22, 2026 at 01:22:31AM -0700, Bartosz Golaszewski wrote:
>>
>> Herbert: Sashiko still says it fails to apply. I have no idea why, it applies
>> fine on top of current linux-next.
>
> The first patch doesn't apply for me either using git apply.  Please
> download the latest cryptodev-2.6 (a9a2152d292fd0bc73814eb4a127278ee7dd3f6a)
> and rebase.
>

Yes, this does help but does it mean changes from cryptodev/master are not fed
into linux-next?

Bartosz
