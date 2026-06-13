Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2A136351
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781359131; cv=pass; b=OxpZlvjkuPR2D8S3L75IWIy0bt4G6qGas2AK0Ug6Pu3jz9aU7H3QISyhiR7CFmFGkhFHIjHYpiXxV4/rjusPnAoynDWJ5mqpJFfp9dfBluUqGG8bjBwd5H3oBXPUOo4to3+58fO1N4qDnqNKbTeK5BkYUK88h9wr88Pm0QwTkm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781359131; c=relaxed/simple;
	bh=dHPPdGK1dXtt9f7hQ69cCKPbBtNi3yHfXrWZHFelknw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=r8m9FaoMp9xfPxowdzWLZd+6rRoTgUrohrrfL0e9KVKJyZIgPeVsyZ2qbWENbaCSVssIYcxjEH3CvT82TWj2PlfiLBgL0mBxT2GmmnvHlxOP6sn+BArtMti3tvzJyCGFK4zYp+t6+szaeSwyOru5Xncjj2xYWL6MpGgwNQvvJ00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mGa9uFFl; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mGa9uFFl"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aa619653e4so2566477e87.1
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 06:58:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781359128; cv=none;
        d=google.com; s=arc-20240605;
        b=bmgITdUnW+WgCME7YuFONUR0MiA4AVJeHm8r8NYvTQYouHgENOtEW41Dxw4NwRnMG5
         A20hVGTjI2I2r+/Hf/nMHkXde8lnbzT/g2aXevKqPo5cENsCBt33gzX6TtWDzjHiy8tK
         jdjw9vZ0o0oa49S9ksVs0PNQDYvPB1dyiyFbFPeyn6TWFQ8RAMm5dCVeXeAw6+vpRivv
         GdEdvqCgCZWYBd7Ad6jKAqvHOToeFTVyP1M13USVsoFFf1wgNMmtl8oqG0Nz2duaYCaU
         +4wfK4axhxFjLL+peb8tkEqWoIoJeMbzCEsgrYli0YcrlGPHU+dWIeMQjt6M1AudGoA9
         vHOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dHPPdGK1dXtt9f7hQ69cCKPbBtNi3yHfXrWZHFelknw=;
        fh=8GrwbLi5Tr48p1q8oUN+C5zBCxCsl8Z/F26HR9zoxMk=;
        b=iozRIdyOOEnu3ndXAtKENirDeLkol5d11eq0JvHga8PEu6bDn2ZfrvJ9sOeGmvivrM
         K+h/9IsoWBgfaH4WS39jyrVYc+JujXk4Geotf3M6F65YXdWa1+BecpOYgD18QAZokujh
         cm1W9TOAVtq2lGzDIk9YvIE1gywFwzSPPwiIZKwCp5EAh/5I5SdsjhtOCLOkuT0Jko2k
         FX2AU2n4KLG0ZB80YJeHj+t29L/x1LdF6wFevFOY0j28J2/zQ8oRmyopZkZBka4DetZy
         GSFkHL3klEi5RLKMplueFiUmOOS6QsqmJmPxm8dt1xmWzxll2U7dKiOgRHPi2ci2ED6j
         mZuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781359128; x=1781963928; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dHPPdGK1dXtt9f7hQ69cCKPbBtNi3yHfXrWZHFelknw=;
        b=mGa9uFFlMmyYxdSWyjBmh3vNCK3Leq10evoErk4y8Z2uw41R1YroAbgEs95qB34RQr
         sp53h/pudOcs8BxzalIhrMa4IKI9pOljKCJ+pN/tuKu4cSTPavFodyddyynzJiQdAe/G
         OW93yjIdIBgzeY68yoEzw7wtZLb8Bu5pDFc9YdxUv4Nmd5EWvFSDgBc8oCZ6wyP+b3Y+
         HfDtHzQJdKBqD0dHG2IgaXPJ+lYxWbDCdcguCrR6xKTswJ+5UT9drcK10+BhCr+LmJsE
         55FZDDHNUYM6A34JLwOhB3/Jw/5kPXeBreYPdQoDuYOx72s1Rojp3tTfsyhw/B89AGg6
         M/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781359128; x=1781963928;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHPPdGK1dXtt9f7hQ69cCKPbBtNi3yHfXrWZHFelknw=;
        b=OY8nDXkf0nc3HAGGORcNHeEk2WpKovBkaSZEY5+TMOnQOOMLvJL1EFsetytVv4Mrih
         lZcMxguzHf5c4JjzBUQT1d2wAk3Vk9B1i1/LpMQWs8y4aD744LmIqALtiRyjdrFrgY7K
         PoRlGD5yJTHdKxpwd2Hiq3rdrkYipvTE+ZyrM/y+a4OmsU9hiJoHdFvpD4MUbegHbTpN
         3rlR6BaIkus+5vzSjvbEO0lDR3i3GQkZeiV7feTLs+JXGzpeKi6oIm+SNGUPKQbgX4lp
         CdXSF60LyCAXFk8dnqsKSdgU5DuAUb+xhG3X4uGNc7NkcgkYWiRcHjoxyZPUaTyddZRv
         dc8Q==
X-Forwarded-Encrypted: i=1; AFNElJ9o1GjrVHs/PscUWSCz2QAsg90WZ0F0JXIn/tzeYEsf8yDbz+f/nYgrDsqmebI7wXaGHReOJtCUQScU/CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGxANXkk872F18KlLwNk/DYjAyGudBMaNJ6kFv7TihI2ZZOaAh
	fCbgf1SGxxuGB3/QcCItyWKiTFNKLBGfqGWXYJGvDvA6hT2n6vQ6QVHJglIMmBgConu8bBhkzlZ
	SbDWVDsojqHj+fiVi9hjcF/JmyV+rUd8=
X-Gm-Gg: Acq92OGT0hO9byNX7nHqX3wXcEuZadHR1Kykf3anPkezxwxvBkHUX3I80t6Gl6msW3X
	mFCGVE1YKtmUV+uRPdVjvFMvgOibj/NkHulFNCqJ/HQWvsY49Oz4ULxBxX8tfe5QQwRNsPvJ9ib
	wrWuC1Xq9UNMIGmf9nmngGQrLm/4PaP8i1dsciCnOWIkYXE4+AwWfSqrc+EE77pETSniJpT8pzl
	Lr91ANR7gKrI1CVoTKrtDUBbzZ5/qPZL1Rrp5DZfdlx1Iqkqx4dsFlCoVkELsKAe3VHzrSb6jKg
	Kv1769GSV8lNOtGbb6RY13Hx8htrqIa4rJpAly6XhKb73iLFLNgC5hUku7jtVpuPYjUeg1o+
X-Received: by 2002:a05:6512:3a89:b0:5aa:7397:73a8 with SMTP id
 2adb3069b0e04-5ad2d6b1f51mr1543146e87.15.1781359128179; Sat, 13 Jun 2026
 06:58:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 13 Jun 2026 10:58:36 -0300
X-Gm-Features: AVVi8CeLiOVPoCKk7Cmem5uIarxsFiGWJssOt2XYfd-cjw1UyE7apA07XsAIA0M
Message-ID: <CAOMZO5DgENq8RU6s2CPnKsf53i=7zoBeO38m_BtV=w54hr2hgQ@mail.gmail.com>
Subject: i.MX95: EdgeLock Enclave secure storage
To: Pankaj Gupta <pankaj.gupta@nxp.com>
Cc: Schrempf Frieder <frieder.schrempf@kontron.de>, 
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Peng Fan <peng.fan@nxp.com>, 
	Stefano Babic <sbabic@nabladev.com>, Frank Li <frank.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"

Hi Pankaj,

First of all, thank you for your work on upstreaming the
EdgeLock Enclave (ELE) support. It is great to finally see the
ELE framework landing upstream after a long development effort.

I am currently evaluating the state of i.MX95 secure-boot and
storage-security support based on current linux-next, with the
goal of understanding what can already be achieved using
upstream software and what pieces are still under development.

From my review, it appears that the following infrastructure is
already available upstream:

- ELE/V2X mailbox support for i.MX95.
- OCOTP/ELE nvmem support for fuse access.
- Secure-enclave bindings documenting the i.MX95 ELE HSM.

However, I could not find upstream support for several
capabilities that would be useful for secure storage
deployments on i.MX95, including:

- An ELE-backed trusted-key provider for the Linux trusted key
framework.
- Integration allowing Linux to use ELE as a key-sealing/
unsealing backend.
- i.MX95-specific crypto acceleration exposed through the Linux
crypto API for dm-crypt use cases.

Are you aware of any ongoing upstream or planned development
activities in these areas, particularly for i.MX95?

Any information about the upstream roadmap, ongoing
development, or expected direction for these features would be
greatly appreciated.

Thanks again for your work and for any insights you can share.

Regards,

Fabio Estevam
