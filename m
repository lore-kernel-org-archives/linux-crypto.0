Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420830F7E9;
	Mon,  8 Sep 2025 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757349320; cv=none; b=I1X81ad7OBGv0VRpXG8rhc2PD51tV6b2hJAV68ke++gr+CIbTZaMMqU6IyupQCcWOGwtuRQEpYqw8VK5snm9XVQdY6B+2SrNxmWVLBLls5pYq8sqV7kQbb/zD9M9yodKzwzvqiq9uEC0M0drFClrI+JGlWcbHDuSd+rq3t72gZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757349320; c=relaxed/simple;
	bh=G9vgkd0DO9ld4CriXjJK1r7oGUIIiZc0S6wFO0Z8nf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LvtcG7HoFV/8hyl4WQo0l3n5m1L8D57Y8ZZHS25u3tZJi4EBBJrIxTjAOR1wDnEZ5eVtZmMKP/rG5sgBXrTndkDVc5poHaUwfVr+i4GH8luAqRtAv0ZGyRVsyE8RhLLDwxi17jL39s2G5sCOiXfgVVjsG4gis5K/kG8Ke0HN4bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=QUfi6Qg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QUfi6Qg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1986BC4CEF1;
	Mon,  8 Sep 2025 16:35:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QUfi6Qg2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757349317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vgkd0DO9ld4CriXjJK1r7oGUIIiZc0S6wFO0Z8nf8=;
	b=QUfi6Qg2IxLpxxdufJ8nhrwlM+UciMtybS+upuJV4RnioYi3nUU/LbBcdRHTFkl4cD/Cm5
	FI+6Sp1I1MjmV13sQv9vUvmnGfdewY58Nple6Ewof9hEZKqH/cwKU6ZZf1YaCXQ1WOit46
	gttqiuepPPNnRr0QC3AXp2XgwqsLSSA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 290aade9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 8 Sep 2025 16:35:17 +0000 (UTC)
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-61e783a1e00so3085241eaf.1;
        Mon, 08 Sep 2025 09:35:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUMMxKOboZ8MEGA928ocW8lvcTheif0z9FVDG0wXMsuJpvFgoSVtcXqY0DIAUpBK/vhVE3mZyAP7bJnemo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUmsXXZXd3Xl+3SA1A9VG2z1WV7UzeJMUZb45MkN/Zw0QY0U00
	hUUdE3st/ZP5miUOXfklK+trpQaHNq8R/c/abaPqziZu9W2zyd3mW8wANHjUkqwLYOXi7cIRDcC
	3ADX/Oz659iGuhlHS3seTkZYnATCVoso=
X-Google-Smtp-Source: AGHT+IE7fQgFT2M5TfL6hfVQrredcaZ/GbV/THM8Yume1F79jQqGz4wG7cG1y5QelnlSxkfYukb++fwfMciaqG7ZTM8=
X-Received: by 2002:a05:6808:1991:b0:437:d800:3c1e with SMTP id
 5614622812f47-43b29ad403amr4222584b6e.23.1757349316183; Mon, 08 Sep 2025
 09:35:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250906213523.84915-1-ebiggers@kernel.org> <20250906213523.84915-13-ebiggers@kernel.org>
In-Reply-To: <20250906213523.84915-13-ebiggers@kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:35:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9qyfbn539Um9xoFJu2Mm9mM0zuOxyLgeOjF-R5nktbz4w@mail.gmail.com>
X-Gm-Features: AS18NWC3VPTUIVFps2V911IsRcGv2esz89Ld1bpphWm6ntSx0SQwkxhIkBDwZbk
Message-ID: <CAHmME9qyfbn539Um9xoFJu2Mm9mM0zuOxyLgeOjF-R5nktbz4w@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] wireguard: kconfig: Simplify crypto kconfig selections
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Zhiqi Song <songzhiqi1@huawei.com>, 
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

Just a small nit -- would you commit this with the subject line all
lower case, like the other wireguard commits?

By the way, I have been reading every single one of your patches. It
didn't seem like it'd be useful for me to respond endlessly with
Acked-by/Reviewed-by, so I haven't. But I have quite actively been
looking through these series. Thanks for doing these cleanups and
reorganizations. This patch here especially is quite the relief...

Jason
