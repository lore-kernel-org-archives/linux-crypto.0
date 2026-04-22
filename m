Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DE437F75E
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881974; cv=none; b=bKUfCsitSotXED3UErq+oCtYJ3ssLvtMGOOiyr28bIxM6EYPE5pZpYteNdtEqU1tqwaR0JO8D+1BYphUI7jr4EeYtqjRi82Oy6t1bkgZvKUn44SKqjfKMn1OsakS4L5PcBwn9jasbYy4ZtX9a8ng8DNGmexLzkC4BQnjQwzBtAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881974; c=relaxed/simple;
	bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=uoLV2BeIqmwkQOh/IhytiH4IKYwgTX0H8iVaFSMU8JAvYlVlfmmfNzDoiPUDX4I2AstvM+87lnVZthPbb5MUmUtjLWH7Dcvh2IIjsroDfrdtHTtgmts+vJs410dQ4+/DRhHaA94wTUjUCECepKJISn5oqDw2TTO/TIHDjwf6wNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rZxMsqNE; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZxMsqNE"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ba67b332bbaso611564766b.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881972; x=1777486772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
        b=rZxMsqNE6z1OgRiHD6JzksZcZDkCZ/k1u4V95DhMKLdiTrPDUi5j0IPFaT74pd2k3Y
         DpxermbznGGG8wLa6cNTdRaAJ1Ta3/RuUySb+rJyxgeuthJvFMU72BIL1JWS2Ukfu6PD
         tKaGLv436MUhKcNz46OTlZMBuGWUXIzZuMEoQ4/ERBR53ATsFMb6cJP8TjKI4+7HGVOh
         LX8fVsVJdkAicjvkovCgzCDuo1efevWfHdJXas5zKVhcCBfg3ogaZcW0EwtoLHgP0U6K
         lWA5AbKTtOJf6u+0vWOPkJemOIgga+ups25TkUdgnOzSwMWIe74q9X+L65Ub3NSiTiTp
         ijOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881972; x=1777486772;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
        b=QwsFV39eIQJop0vknsZv+fFUg0PFrWlvqmSUDiKLl48ofPcHEmVz/GJG3fOFDjfXz6
         j8eKOvZ/cxn9uujDd08WBROlGfRIOXy2vAYGjLtVoFFGNMKHgibiP6V4W8bQ+TDn+Tn2
         PuVbi9HN2AizhA4FbCyAmFlRp1RnTmZUAfVBgQ+B3Hxm4U9SaeazYQKl6CIoqEQiw2Og
         Q4rX7+UR97LwlPLtyLk0B22x6UmGe6hQOs3PhsCG4AZYGCwWn9p2CX7ztsW5xpoF2fbf
         O09EpOPmK6N9KNg8VAzadabH7x/ne02uVakUU6u3us4DSFyT4kbWnXGmwTXJuyY+BwGv
         P7Yg==
X-Forwarded-Encrypted: i=1; AFNElJ/S1s33EO8W0OmmkncgmAA2d7oWOiH0hJgwLPPlpXCIl9eS+NqA0Jlyn613fQMrDWha4IvPFu76IzeQ6Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBseKIQMjjedT94Cotljtw6fJM+39n0e5wqCbYOKridybkv0Rk
	KeeTUYRTKPibNrtrZhMfqKilD39AfA6hAg/nqoKS5DKWA2eFoBQaJ/z1
X-Gm-Gg: AeBDiesKuXS/jmivtnp6R9su7dR+J1xV225QlgHaJ7g7gZh1qQq38bGleeBrXWO0lwz
	BzN0LktxwIV2GlfkvvkfaJeCc+32RZTeAzGm7DOtz1y3cnTxHwyweLacQXL9sf74lTalUFOVl8P
	H94QwBb8kCUB+Z+Llgz9dlMnWIiAnf/7SWb4iVA3rs5qvKH5Q6i0r/vRbAPee1cyPLyJ2y29Xtq
	c6VbsFPYGhJ96Ncbpf0Hu6SFQEw0k7f2jYOtsZz+Dz07cUmjB+S2Z/vmgzjxG9eT67gmpnjz96W
	SjzQefj/1NOSt95bFvGZfmONZ/rdovpLRO/wP2xPYeo/4IL6bK5SI67PeUnVu5kxVwww+NNvg4x
	WdVUosOFrgTbAjQlO94eM7EweO8x3XNhqbbojwodfdYIpjhYqXT4sMMrOUdlRyS4Bmjs142TYIj
	vWTaA8LBw6bn+KUrmTlZnl3Smh8S9I7kpRqqSY
X-Received: by 2002:a17:907:9308:b0:ba7:34cb:388b with SMTP id a640c23a62f3a-ba734cb3cd2mr794916766b.42.1776881971338;
        Wed, 22 Apr 2026 11:19:31 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba45553980csm575137766b.58.2026.04.22.11.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:19:31 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:19:31 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH 6/8] crypto: aegis128 - Use neon-intrinsics.h on ARM too
In-Reply-To: <20260422171655.3437334-16-ardb+git@google.com>
Message-ID: <C4E4FF7A-8CCD-44CA-8AD9-5BA8D177E1DF@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard, this is a good cleanup!

Being able to drop <arm_neon.h> and just using
<asm/neon-intrinsics.h> across both architectures makes the C code much
cleaner.

-# Enable <arm_neon.h>
-CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)

Getting rid of the isystem is good. iirc that was a hack anyway, feel free
to correct me on that

Reviewed-by: Josh Law <joshlaw48@gmail.com>

