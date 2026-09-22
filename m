Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EFB3C6600
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078308; cv=none; b=p9mLnkRW4bq4TmV/rSD2DZCHAdvHBbkvHa0FcEAgZeI5KjjP58OmRwktkR5ohQw+GX6eqaOXWJpDM9+0vILyQU98mLIeK8MuVe2gtZdzszMKf8tOU1p566lnFmmPpQ+j7R2xGaJljkufxzfmfer5B38ozlFd/rKMg3G7ZkKRFwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078308; c=relaxed/simple;
	bh=Ytoz1t3GOPePZxdswPtmAggikq/qSPABFOEolp1XJF4=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XHXjMfl0Gi8Jzop65UI+XdiMvXiFuaYm9rutiJekricGmXn0x/y5dBxnIBcRezIm86Xh7RuyuEfpcQ7LkT6CtMfodkOebZ0igRKHiFFZ3Evt3AreuehsPDSH6oq6sGfD3U5ge8ajq9Ua420UaHQdxSYZKI06okUJt3yB2LMy8Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLBxZcOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLBxZcOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0641F000FF
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078307;
	bh=Ytoz1t3GOPePZxdswPtmAggikq/qSPABFOEolp1XJF4=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=CLBxZcOAWnWJ/4kXmnjH0R0nj/16Tl9bqHp/mJBAg18XTsfnPgexZBB9i/vUJ0YZA
	 mVPnyzkwFEjuST1M7YGee3O+O+kHE5wKqcw+sX2/JYDTw7ep5ZrNTEKUWyvqwm8JWG
	 k72QbOKpotuSM95yiR3hHwMUtRD6zjokPgdoDlKSlOj8tr140Pzj+4lJMVgaUyD8jW
	 cseHeKvd98sSRBy4AVEKbBIwPvOBjTZfQ19A5aN8TohopWWDkt+1hI6tfhutS11qrs
	 nLDtm5rJaX2Lpy+s3yjNyzJZH0GXvuUagurG9ULd50Nlss2GyA02DdSVaQXPPmd0F5
	 DFNmbvlhiQ80Q==
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1744fso6363806e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 04:58:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5MQ8R7q0lEMakO+0TBVaRbXlAfhCcxWxxRaYjFLRx4iCRk0EkwQwjQR70yE/Qz4fbN+bZeZwqaJJCkRU=@vger.kernel.org
X-Gm-Message-State: AFuF++l8I3K2CZ8kAuXUSVdqVi05uZn4JpLo09yfblPtToPoVjWEfRaA
	32kPwH5+eFAcSUa0FeAgzP+m2ljBmgrtw3ur7ng3vSD2g03B9IqrA25oprTIRlW2zroFyPiD2a/
	QEr+mhAL4feeTY6CHrjkxLsUdWO1afyG9t+Nvm/M5vg==
X-Received: by 2002:a05:6512:3d22:b0:5b8:112b:c4a2 with SMTP id
 2adb3069b0e04-5b8c181ad50mr4861932e87.27.1790078305682; Tue, 22 Sep 2026
 04:58:25 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 04:58:24 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 04:58:24 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com> <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Date: Tue, 22 Sep 2026 04:58:24 -0700
X-Gmail-Original-Message-ID: <CAMRc=MfKMKSRGvb-f5Vc-qK_HchWTnaviDPkg7hEeDbZCfw8jg@mail.gmail.com>
X-Gm-Features: AcwNN1VahnVb5QlWjD-pcY3vH2FZLS8CiKh2yK16lStuAeGTC4idhVFKnxxeMHU
Message-ID: <CAMRc=MfKMKSRGvb-f5Vc-qK_HchWTnaviDPkg7hEeDbZCfw8jg@mail.gmail.com>
Subject: Re: [PATCH v8 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sep 2026 07:42:28 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
>
> Also, if I understand your previous messages correctly, Linux currently
> doesn't use any of the features that would cause the races with the
> secure world.
>

Not yet but there's an upcoming driver for OP-TEE[1] that will have the
potential for conflict. And yes: I get that there would be no problem if
we just removed the driver but the long-term plan is to use the IP for secure
media playback and I want to get the BAM pipe locking done before we get there
to get one thing off the TODO list at least. To that end: we'll be testing the
synchronization with the existing crypto algos.

Bart

[1] https://github.com/qualcomm-linux/optee_os/pull/71
