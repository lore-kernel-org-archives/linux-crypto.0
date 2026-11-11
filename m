Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794397862;
	b=EtDCs+P0Hfl9TebwFD8yqxeXNvs7QO2RMYrlSpghKOEh+bHlr8S0CByOwpPqIhqh9dyT
	 mO/UVERjM7RZ3xLNJaCKLbHF7RaSG5DrsK7cEuRfMke8OtQsODlQ02GVpXlC857+v3shO
	 clAKycPehQkdtdYd5ZWEpuJbhUYuH/IDbBmlACGt9UjF4ioPjBHnEXM/EXh2gs0ch4oXu
	 bbB7gCLx+qxtyf6PM2gTiojvih+QsiH14shhKftk/x++8WtgosV/rhkJSuelULu2guhE6
	 8jAfN8KoQQqZA/mHBm434hkg3wa5kTt9CbfCLqVdDJC/flDLZZ2Z0BhCHZLbbL05f4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794397862;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=SvJ/yakFDduNn4r/1BAeP9p8qTqGeWwQTRNwHFqESl4=;
	b=Bruo0j7lIrbXOVBSZT743jfhE6Z9f2X4+waPW5K25GZHKNAttAKqvaVNaU0EX5bI/W6g
	 qGf5qDYF9qsR3zl8Xm9kS2aJoSnbV38QINl4uZG2AXnRvwaNpHxkvYKA+uUXCmc4bMJZD
	 0cZFKlTV8TrjlO+c6YmYPmSjnxr+GgCvPymap8Vb8geQM+PfpYdmHcpOpNeq5qPVtxlUT
	 Tv7C/OGV4VqQJAAwTsX0+51zOxRVTGhABMIPrtaEH9WkRzkui3s8PKn4NCq8FdfwiZkhB
	 4YRqkGpNdlv9ATKkRMMvxtAgWLwLgTnMKM/R81bCGzN9gDVeQ9AA5COL20CnTIYjGJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=thegoodpenguin.co.uk;
	spf=pass smtp.mailfrom=thegoodpenguin.co.uk;
	dkim=pass header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=V5b2CttP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC10C606A33B
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 11:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC10C606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=V5b2CttP
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93efc0452b5so203816685a.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 03:51:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794397861; cv=none;
        d=google.com; s=arc-20260327;
        b=GTWFAzA9FPArpOXO00kVw8q/0J53HKbiqTWuwLbBLlPwGRayeVX2nxaPDqqJz9qVcT
         O8RxtsJOA1da31Vk/Ajxx1PRhddId9vaCCTFbFPXvm+EXUI+PVapolVelUx4er8ZgC1H
         Q/Hc4xOQy1dhtEMtMEQFxKSPcjTYYIjLNuC5/+FcUK+kSm1mIAdhVXJToekKTiUSSjnn
         Ii5O0J13zV1Hb4vbwI3TDWqDPAUblYlzygJDDdVDnTSuUbTjnB7qaACxLbfowkBN3O/s
         uViGE4x6cTZZDLXZSTK8YuCQyVl+ocGNCVYWfCZxDMJWe91tm3XDLuHtFVi+DpBHYrNg
         28kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SvJ/yakFDduNn4r/1BAeP9p8qTqGeWwQTRNwHFqESl4=;
        fh=BPw6W1nolRx/nWux81Ss3k3gVgPb2HnaimOz9ZR4DVI=;
        b=WaP0EfvZ8u3CyP4KLYPDbBpAY91DQUwALDTyDF4A398zvDnFR0FfWM/h9wGz1TGpFy
         UWFmmYOE4GqbYvNX3saMk7UIzaXNajNlm9/rZBv2IoNTBwNvh7/rjoTNL7CMkSxd+Ph+
         pGAczZLHyWp/0Duo1HZUZZc34CEYwIwv7rGm5QWjVnFfsAUpMYWsjdFb2SAHqJsiDBsc
         3902iuUTslPJwpQHnkPyfi1IoOxcZGbJaAAGPDo/LBIwaXTTgExcKIRjs8g05Gi/OE23
         vqSZqmeJXZo3zs6VSxj0D7UPHA/kXtlIvgDPKZ0cZ7FtyB1LVFgQx50sqsSyIbRYpHeQ
         TboA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20260707.gappssmtp.com; s=20260707; t=1794397861; x=1795002661; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SvJ/yakFDduNn4r/1BAeP9p8qTqGeWwQTRNwHFqESl4=;
        b=V5b2CttPgbaVLOVj6ShAbHXi4p9RJT87mHYSQ2huFLF0TIid3B0OYYsH+S43C8BZV9
         9D+7K5VTtq4qrX6bb+aRmpJWX4OF3zJh324PqWGT1mn5sCmaEY/mlYE8QO/HSeLnzz+S
         Lp5LcjvplpXXuqRUqb9o/5LhjixxkPgMhPUxWDdl19PZhejlNgF6B0vLWL7IRsNblZRL
         BQF+ayRBoIUIE0r+npXYv2+V5xhmi6ou+bwi8JU7E72bKUJFC8OLdfnbRUYt/bpm8v/P
         EDD6hi9UaGnRnghqrhZhKUn1jl9/ZIH1mZCsmv3gyaT7BSi3sRQsQ+sbLT+M9LY+qzqb
         qpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794397861; x=1795002661;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SvJ/yakFDduNn4r/1BAeP9p8qTqGeWwQTRNwHFqESl4=;
        b=IvLIAZLuxkTKZl5zmmKS/C3vt+28sYRyHgxZPPmi0dPKnzwG95czJeRyJ62xSi4Aq5
         HSFlZpcgaj2+Y7MOguhOvhR4RYGcQycPyFhmWsUzRT6M/60X9srRRVvJnVsQvWqq8YuJ
         5JDxkawB/KvGKtBSWYW/qS9mWMqeUIOFPyBu9gdxdqLgI0n9pSsKH0BskZI/Y57zBGpL
         ahlkOkrTk0wNbNeHezt9lXsodkYSTcKyht3LhzU2bwSKjNv9nS9KExrIvqIjMhaWbTTb
         dy3Zu9aKW/RTupyVVuZ1RxjnhrixQcwopyNcsP5frQGAlarYsgXpwyR/gLJkJZCGB+aw
         4flw==
X-Forwarded-Encrypted: i=1; AL+hErG7tVnDIem8URPkBO1OioUs3YAyhOv0VgmbVvIlQco95bX7d3wSBB0QPCrIZ6rTpKKxD+BPAJFN2cTTR7U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+D3+U4+CuoCtMoqClD10AGqrJaG36EDWZ1bHGzDCmLkQiJMIRD
	kU5yB5IwZOJFXrZwOked2irqqLbH0+G4kFL5rftrBBtnJ61usSN4OXwFihjHBVipaDHiKRVZUsy
	lsNgwkkMGILmT91YKsB+HTrSx69sqG4beets81CTPRw==
X-Gm-Gg: AYBFou1xwYbeC0hfwLR33jGmjOgIt4AW27o1mPcwx8uZkoVN2SBBq2cyJ5SkHaR+pDw
	QfyzuksewvQRT5/UhzcR+IpdgyPNjrRPetlAmFjxune89IpufzJruZHnWHpKI5FE9p73QfxPWAF
	O5Gxhoi1uUZSa0yNB/38t3inzoYukEIxNoKh4va1s14ZiibshsH+uK0XbF5hOrfIbGVBM07c9Xh
	XjENp/JvCA+nJYgKu41CAMrf1lYSzP6601triJDsdblUD1iFL72KAYgYFKnn68yZWwsc1eem6Lx
	UKyf+gjAgsLSPX6mwWs7UtL2VREaRQqjCnD0pl8f/PVmctXw/487aa2c1AQgFetu4vLCN7CCie4
	KsS1+BVDUMLriEcy2LluJidaKmFi8sIQ0dFe+9L6g7wXAxQ8g56afSzcQkS5wRXpimILE2RU5Gf
	Zxi1ayiOkPJQlNXbbl
X-Received: by 2002:a05:620a:8908:b0:93f:34c9:9259 with SMTP id
 af79cd13be357-947affef9aamr308328285a.50.1794397860820; Wed, 11 Nov 2026
 03:51:00 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794347059.git.u.kleine-koenig@baylibre.com>
 <39fc883cf1c7077bce8f16719cca59060a395b02.1794347059.git.u.kleine-koenig@baylibre.com>
 <avQrO4etMgpOhvwF@ashevche-desk.local> <avQ19KBnQ2mnhZa-@monoceros>
In-Reply-To: <avQ19KBnQ2mnhZa-@monoceros>
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Date: Wed, 11 Nov 2026 11:50:48 +0000
X-Gm-Features: AclHuK9yXImPSOD4H34XxYmcqqFrOLj5GBNrtIWsMZD69B4vZ4xDk3_xNWS8s7s
Message-ID: <CAA6zWZJd7Leaytnf-BfHu5ujAnEhTwSB2007KXnV=eE=pvpz4g@mail.gmail.com>
Subject: Re: [PATCH v4 10/20] mfd: Use named initializers for acpi_device_id arrays
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Lee Jones <lee@kernel.org>, 
	David Rhodes <david.rhodes@cirrus.com>, Richard Fitzgerald <rf@opensource.cirrus.com>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, Zha Qipeng <qipeng.zha@intel.com>, 
	Qunqin Zhao <zhaoqunqin@loongson.cn>, Thomas Richard <thomas.richard@bootlin.com>, 
	linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
	mfd@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, Charles Keepax <ckeepax@opensource.cirrus.com>, 
	Linus Walleij <linusw@kernel.org>
Content-Type: text/plain; charset="UTF-8"

> Oh, I wasn't aware that Pawel is still on that. Initially we had a list
> where Pawel indeed was assigned for acpi_device_id. Since then I went on
> to do these changes per subsystem for several *_device_id at once
> (instead of per *_device_id and subsystem) and stopped looking after the
> initial list. I might have mentioned that in our internal chat, but I
> take the blame on the lack of coordination.

Hi Uwe! My bad as well! We just had a chat and now agreed to proceed
in a coordinated way and do all *device_id changes per subsystem in
one sweep to reduce the amount of churn.
