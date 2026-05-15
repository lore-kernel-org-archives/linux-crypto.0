Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26623F39E5
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 23:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778887277; cv=none; b=ab8dhmhHPbGL3J0O2PRCnXHJg7nhZc/kepKe175c9xajojk4lQ9CAI9FU5vk1tqIx/YN8f5LrtjpRBvEygF/AslDYkMW/aIdpS/1zU7lWSFQ2OKbP+eqewcw/IGIaIwOS5kYccUMhVdwN7siJ0GRE37Tclop5x6ShlrGZUhVG9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778887277; c=relaxed/simple;
	bh=+uqf/3YwdSM4ZxXaalnSGX+zhM7wOChr/cm+oiy3yfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qSOmeTTHCNRY5nM94qEmBkk4iVIcbtiBZR0BuRJ+zKebsFNn/kCtX9wYFJgJGoRw91QJhT+fht0XQfHhNEup92dPlUSqgXASttbHzvs5Bf/JAH1EPSBWPjWdprmpgOzxZrPbNIC1CUISmr/VYukIoOx16w9k0xiI94xPb6HB8hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+2PDrct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+2PDrct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69887C2BCC9
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778887277;
	bh=+uqf/3YwdSM4ZxXaalnSGX+zhM7wOChr/cm+oiy3yfo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N+2PDrct+u99SOAVf3Zf75f2xv0VOBaVGUI3+nuYq9lWaOAuy9bXerbemDg1WW5Aa
	 q4gsEsNC4VNWvMO+snRGPIYhSBvGJ/ucVrBqLQyWSIPnmRfKn3WMG6XPUgzKzkGmts
	 YRfX0MyiYOy34hit1JXt01uOZ4wMxPyGecipvaRiDug1V5Zw1nMMVTMWbnBqVgLC1r
	 RZ/0ds9R7OTCsbdLwhJE8MqcY9bB2HkfioYnIVmsITF20ZcpkkQBxA8DawDHndH5Z4
	 uBTPZ4FS1xo+c7fwstNjWVI+LB2j+eQekzrsU9VRjxSBGmEA8MRMtkf3fp+vIIwt6f
	 dTiyaF97fRhlg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a8891febd2so503280e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 16:21:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9PM+vW9dybV/AfanSwNzVynJkuqE5kfDvJfvKbc5b3qMTNbkusgazz8uonCf1Xfp2B92p8JnPBNzX4+YI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0xyyfx/1EJhElN8bvu31h/3aNELF4BbY8EPyZ9luv7a0fNfcu
	JVm5ztPAXHT8JR4mle1EsO6J0XTuysH8VPDOuCHnxXZJafaLQuDdoxrLVD3SGRfnw0ctlbwpXvr
	9I3bWDn7tMVAbEEWVYXVcP1clLIjjRMU=
X-Received: by 2002:a19:f615:0:b0:5aa:106f:87bb with SMTP id
 2adb3069b0e04-5aa106f87e6mr1162612e87.3.1778887276165; Fri, 15 May 2026
 16:21:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515190220.1534187-1-costa.shul@redhat.com>
In-Reply-To: <20260515190220.1534187-1-costa.shul@redhat.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 16 May 2026 01:21:03 +0200
X-Gmail-Original-Message-ID: <CAD++jL=rbUOH2d_C=O9gYnHti54uj_HpGBS6Wj_kLA1YGA+nuA@mail.gmail.com>
X-Gm-Features: AVHnY4Ipv3t6HtO9uaUNGKsRNbcX3ieM_vTfyHhwdIPkqWoSoRKXcuTNOFnRfuk
Message-ID: <CAD++jL=rbUOH2d_C=O9gYnHti54uj_HpGBS6Wj_kLA1YGA+nuA@mail.gmail.com>
Subject: Re: [PATCH v1] include: Remove unused crypto-ux500.h
To: Costa Shulyupin <costa.shul@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 9:02=E2=80=AFPM Costa Shulyupin <costa.shul@redhat.=
com> wrote:

> The UX500 crypto drivers were removed in commit 453de3eb08c4
> ("crypto: ux500/cryp - delete driver") and commit dd7b7972cb89
> ("crypto: ux500/hash - delete driver"). No file includes
> this header.
>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>

Good catch!
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
