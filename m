Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69A13750D5
	for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785064361; cv=none; b=QPl3D9QhTW3//GrrVeOTS/RsfoJAPzgZerT2LvAFBDxodHf9iefoSdHTku8itQwByc/jScK+HDO/lfQbu/blIUfXhuDtFVKATxEuM+iVUlqZK5zjZHdT5tBaIYXjTl233s2UVwP8ZdR2QMwQwQcTamayq3/hzM7EnCoetPnRkA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785064361; c=relaxed/simple;
	bh=XzQobWmT2uLdetHlTB4zijkUllZNjW0ZntXhW1a6Xo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bs/k/jsrIEjt5kmzthV4QVPEQyaZEKisjFtQgyjdg5CoW3lYFayi0YLvcqkZ3+es7pBCvxZDcH3Yy5NkmA5Z4sRh5/hzWFo+o+6ndb7KIMwO3CLueJiVTKWMv2QPWqXq6YcG2WPK5wJYioZM31hEOeCOqP+GAVDahyUhPGvX9SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=pN/aEfuz; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="pN/aEfuz"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47362928f65so1677002f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 04:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1785064355; x=1785669155; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N4TllNOSfiRDrdoI3q6LmQWb/e4SG8bRRKJlhRG5rrI=;
        b=pN/aEfuzChd8lDdFwO5qfihEcPCOgTZ7ze8/RuKzfXUent+uRrB2vq+Qn3HNpw8dTc
         w1DSUdmg1Isz5JMQjU8eyw2k3cuuHVTcRw4QU3/k7kut45HAsRHGuOvth7wGKIkVcmEB
         ymQx6U3CrJrsIJVdu5e27F8/KAouklj/COd463yreiW6xpOltQpnnlD9DMLmI6f3dqST
         2D/1pqrqjzpQRN+EpHOPEbPi5y/wVvq0L3RTNCx9JMx1idsNAkCJYQM039ZqZs9YnO6N
         k6eiOsvk/LfmKQ++klzxG+bjuU7pfotOkdYofTHZLw93bh29m5IKh+mztzby+VfICAw+
         F3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785064355; x=1785669155;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N4TllNOSfiRDrdoI3q6LmQWb/e4SG8bRRKJlhRG5rrI=;
        b=mbT4+TElHH1p1XkBdCI86KN0AgStpf7W3MdM0idRFt7t1XNvR7hpFECXgQ+QhOqDYT
         lrVV4iaDrrgS27UqhKAq6V59U/bA735KJYseTtk3Wq5BfuGWTJLtzHo6cNU7wTcauCAN
         Tllzru59rdfPPi/DEddFsqnDHCXbRe/yrQx2nvFLfGEWffFBqqkRdWDUB9k+Tv7BmJwo
         ABjpkOQZXuvVEOR7Yko9+dFadigla8NHpUM+PhDKTjfKyMdCdMKyh50LZjGBQM07VIGf
         CaLfuvtPPZO8v7tmgoB6xu28QIek7OMzKRFPBZ3PDh0FfrqBataUcizQa8hUNWXmoBD2
         P8Xw==
X-Gm-Message-State: AOJu0YxsTnmDiyBz0PVovyWUkwXNmApdar7V3wQHFueKkFxRwaYSoME5
	YgPwuD14KcTztx16+jdMOAIb4WskY7AP7CVWKGhyMgNp7jgIZ+VXwvlLKxHwlrT8LCg=
X-Gm-Gg: AR+sD10ytvACvt0/Ka7rxADfZXB4E2oL/V7HAInjvP3dUlSeHyMR8ghk6xwX0Gq4LJJ
	yNyK8ledCnMhDzjDUai3FfBW5nKpLF/iJpatcei7TfnJW9D2P3p2mbgb1Z2fFI7qp0ngLb2RuDq
	n7dfrO46nvgsZ1MqpsBFMl2q6fC+lZsaGRGZR1HtNzyy7Qc3Z1VPIyWVOZ4HpEb9AdquQyBs7xU
	DJBkZuP5MIkZbUpQKhoTvFWAE4YKSxjDgRXBAjvTfVEnHRnNiZ72pef47jUU+2WVZ5uQi5q15um
	YqGDTqfC/ag5/oKvmeg82g2nFYk7pXZudJckJHwQFy/RSJdXmEfd3RFaIZzDk7IS6wkQMGJcf/G
	dRM6MiTeM3JML1vfE4coPzKMHqCyslHwA3hrC6xz5auoWi3GF4CHI6O5rj4kt4wWICtJ4onb/gI
	YgoX3MClFZixnRzIijpd+yhOLe9wFkZPMebvl8DhZYq6s=
X-Received: by 2002:a05:6000:290b:b0:47f:4d7d:4fb8 with SMTP id ffacd0b85a97d-47f9fea4274mr5143845f8f.30.1785064354413;
        Sun, 26 Jul 2026 04:12:34 -0700 (PDT)
Received: from somecomputer (85-127-105-26.dsl.dynamic.surfer.at. [85.127.105.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6ef25sm36581256f8f.36.2026.07.26.04.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:12:34 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Christoph Anton Mitterer <calestyo@scientia.org>,
 Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Milan Broz <gmazyland@gmail.com>
Subject: Re: AF_ALG deprecation fallout
Date: Sun, 26 Jul 2026 13:12:32 +0200
Message-ID: <4065668.hXSD6JRtRq@nailgun>
In-Reply-To: <20260708011112.GA3890@sol>
References:
 <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Mittwoch, 8. Juli 2026 03:11 Eric Biggers wrote:
> Note that cryptsetup 2.8.7 will further reduce the cases in which it
> even needs AF_ALG at all.  So just because you are using a particular
> algorithm doesn't necessarily mean you need it in AF_ALG.
> 
> No algorithms have been proposed to be dropped from dm-crypt (which is
> *not* the same thing as AF_ALG), by the way.  Given that dm-crypt allows
> some "interesting" algorithms like RC4, DES-ECB, and even the null
> cipher, I do think we can expect an allowlist for it at some point as
> well.  But that would be separate.
> 
> I'd indeed like to remove AF_ALG entirely eventually.  But that's a long
> term thing that would be many years from now and would occur only after
> iwd, bluez, cryptsetup etc. have all fully migrated to userspace crypto.

Since I got already mails from alerted clients, I'd like to highlight
one particular use case on (deeply) embedded systems and make sure
this use case is known.

On systems with very little space, like a few megabytes of flash,
utilizing dm-crypt with LUKS can be a challenge. Adding a crypto
library to userspace (e.g. initramfs) is a huge burden.

cryptsetup's --with-crypto_backend=kernel helps a lot here.
So, by completely removing AF_ALG these systems would unnecessarily
suffer. Please keep both AF_ALG and --with-crypto_backend=kernel around.

Thanks,
//richard 


