Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EC738E8B8
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778876991; cv=pass; b=qdSrNH4HE6w3UMrV7gMWwN7mpcty7pQ2mDZnOvK/YCgLhyN5kva+5G5iLprvHtJ+uICshZzt/IilN+xPLQ80DCkwAJD5LxjOe1QXVBWybdowVk9yuvtRJXyQNQFNZhZ/B/v5rfGnoYw1QSG9zxYh75ZyT/Fs/UEfzVopeTlRoH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778876991; c=relaxed/simple;
	bh=P/l2hJG2Rv5bgzx6vzN834k/9UYQvfE3Xh+Po0w1KWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVHENCyEIPejuOX/7IxTq2U5JnO9ekCq+vbnHm4l/trCi0v6nF9/slA8xJ7HNveUcs+NDc/j+rHq79K+kHM/Ws91QC7NX/oNSNh3V1Nqs4SIFPzcDTgwNNw6ylNnxVKgYuZumy2zDz2ddbS5+1SDfNzDPoas3uLsmx5yXw5mdRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0IM49H3; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0IM49H3"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-65dd1e59e08so45737d50.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 13:29:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778876989; cv=none;
        d=google.com; s=arc-20240605;
        b=E8+C0Zblg44KRcXCNDG+CBkPbb8g13hewrXZrGrTZNATtbB3Y5ye8o6Z34pQOJGWEe
         9hfEBlnguzvY71zZgBHjigse5oh554ZkigSOSjSluC+6uEKhOUaiVFZPYIQLVbZBLfLb
         w1T1by8Gfe9IXak0AMioHSNnEZXqsepUEaMERg4m8Kl5dIsBSRtrMpLC5bk8dcc56zPL
         N407eb7Z3hGphW1NXJAaZ0lpV9XapGsZxbeGcgaYHCYFOJxfCqENl9VKWFn/mgQyLvXq
         c/AIXvtPViKpNqoQcIjVGY2V/LoPoXYt1g1xt/VbaNiQWkeETfFePFqgAR33JcZL/UQ9
         Hquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=egE2NTKgLKIitli4MrCbLK+ZNkKRWg13iBLZzoYlN3s=;
        fh=IK52nq9LYZwQnxp7jKcY1wcZ+zcpOy4Hf5wXelBKHx0=;
        b=WYCuG9p4zdZ1n4Gx+4iXDx1r9Bfqtj+r49vO5OSvW2jn/vVUoNohBfk4W2pLOcOlRU
         ICp+452Nq1sWsHMX0lzFZ7O/+EUIvlYk8uTKSbX9Cx2WmYAc4pV5YaByroRREcEqH2y+
         PaiLLYwAhay+Plm/1b3A293VWSo7DnSLMx+4cHv6leILaELa3cXUATrkM794JHN14Gyj
         GgkHVju7lc9UyzVGa8lY95OJgWjNEiULzxaxAR2E8bCtimo71eFZJn7tr+xbH9DPfoBH
         6NwrOwzB3Nv8eOSVOA13c3hMp1o2AMUWqXNXfMUv4dFYMHJMIhFfTfydyg0fhH2mLZ+p
         jebQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778876989; x=1779481789; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egE2NTKgLKIitli4MrCbLK+ZNkKRWg13iBLZzoYlN3s=;
        b=l0IM49H3hE6qxiRv1SnLLj5hkn8PMq5ujShoIV2OdiUti4Hd27tvRctn8j1BTdzAVx
         pd7D4GjB2hqaSDUdoG6bpojBtDd6wkGVrFsZFs9b8eB370R+hE13PeHqdFqPIwKl4dVu
         t9LtzajzbLpDqCt7p3ngRLMcbbwMk4r6D7x8oxj8o9N7mSD2exm1oWOVj59MsQLuyJ9N
         89qNhs/VUJcUtr43/TVBReVUmRwaWIX/H+wyZe8vsZghkB5cccQFhw+Xb0y2UwliqYkM
         Zhc7VGdtC4fcr6YW0rYGpwUeow0+UzL6lBoa4E49htLsJqSU4FULsbmADjSNqCZT+He+
         NqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778876989; x=1779481789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=egE2NTKgLKIitli4MrCbLK+ZNkKRWg13iBLZzoYlN3s=;
        b=Cf61V0W+0dx/aBAx5MfRCuNVz5/Mb9e9enHgO1wqLFTzgD2SxNS+8bu/1zUvAaaDj9
         YsSEh9Tbg56qkSJYaGbVFfgat5S9NbxQP4es5Zj24wLC0Eqbtgok22q2HTIksOoyR84M
         f0gDa5Zy2u589HJQWKZTMFhKNc//qZt21QG3jW5YdcS3K/9Af/714ixCrg0VU09yTM2S
         nHgNlwtVXsxjchpYXBoVqCLSCW1oIAJUcO+7+L0yeZpXRUg3WIW1xz4ETle8VpHSlDsp
         J+Eox/0Y17E666bOnQ4o5175eDvpORMQ2nEWAIrtXEjzeDmngRiIqmG2uMRGyxcMCMr6
         /z0A==
X-Forwarded-Encrypted: i=1; AFNElJ9GEovDHXyhKQbL/0Nt31i8ON6bbfbqXu6d/54xXltduDRlE66E0TlUcl+CQ3PeKb9qkmyXS/FHBVQcNpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKcadYn6kqILZ7xwWBkeEFAL095CDFR4zDWYkia0xQeCMDiFwQ
	+rV+alw0p5KosBia3DiFyOQHJFc1L3Z/XWsqYdaUIrzkjHEX1h51ocPknwS72+4TZZe1LXbwrUr
	Bb2cjzZDw1g7tO78AEWfsogUcHXXr/Ls=
X-Gm-Gg: Acq92OFs3IKHvuS9kHFSG5ooqc3zXScKcrJ/Z7KiotfM8hNvmWEwHTQAkaxHhr8kHGr
	KCgyevhQVLtncHPY3gdOQ68tQSJFXKv6Jeud8estLDO8ztSQKBOMVTUH47pFrpZ2UcSIXUyx4su
	gj7/hPuhk8iPTrm1quBOOri1ae4SokeNsRCZiXYbjYscFQaMhJsMvgDB99vJajsehW1dHRPObvj
	2WYEftMNyGr6XMLAihiYsWrgn+7pdP3bRm1aZPIMKVmmNUcAY3eNPbjG5DFGCFRW3dobGEXSPUL
	/HtXPy9jmlHMDjQ=
X-Received: by 2002:a05:690e:169e:b0:65d:6f14:9070 with SMTP id
 956f58d0204a3-65e227c1fb3mr3415800d50.4.1778876989346; Fri, 15 May 2026
 13:29:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512224349.64621-1-l.rubusch@gmail.com> <agYnpsiG8bNeVw57@linux.dev>
In-Reply-To: <agYnpsiG8bNeVw57@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Fri, 15 May 2026 22:29:12 +0200
X-Gm-Features: AVHnY4JtJvfX0GC5g_thFwXYu4s0HXSv63d-POdX9Cb0Rjc-P8Q9xf2xc-Xql00
Message-ID: <CAFXKEHY+fZFphEyH=rux80GLHdZhq4fw5hVV2uNRjqTsafmrGA@mail.gmail.com>
Subject: Re: [PATCH 00/12] crypto: atmel - refactor common i2c support and add
 SHA256 ahash support
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten & ML,

On Thu, May 14, 2026 at 9:51=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Hi Lothar,
>
> On Tue, May 12, 2026 at 10:43:37PM +0000, Lothar Rubusch wrote:
> > This series restructures the Atmel secure element drivers around a
> > shared atmel-i2c core and adds SHA256 ahash support for ATSHA204A and
> > ECC based devices.
> >
> > The existing drivers duplicated substantial parts of the transport,
> > RNG, EEPROM and device management logic. This series consolidates the
> > common functionality into the shared i2c core and converts the client
> > drivers to capability based allocation.
> >
> > The series also introduces per-device timing configuration through
> > match data, moves sanity checks and RNG handling into the core driver,
> > updates workqueue handling and cleans up internal constants and helper
> > definitions.
> >
> > The final patch adds SHA256 ahash support using the hardware SHA engine
> > provided by the devices.
> >
> > ATSHA204A devices require software-side SHA256 padding according to
> > FIPS 180-4, while newer ECC devices provide a dedicated SHA final
> > command and perform padding internally in hardware.
> >
> > Supporting the SHA engine also requires changes to the command
> > transport path. SHA operations must execute as a strict uninterrupted
> > sequence consisting of SHA INIT, one or more SHA COMPUTE commands and,
> > for ECC devices, a terminating SHA FINAL command. The device loses its
> > internal SHA state if it enters sleep mode or if unrelated commands
> > are interleaved during the transaction.
> >
> > To satisfy these hardware requirements, the send/receive path is split
> > into a low-level transfer helper and a higher-level wrapper managing
> > wakeup, sleep and locking. SHA operations keep the device awake and
> > hold the i2c lock for the full duration of the hashing transaction.
> >
> > The series has been tested on ATSHA204A and ATECC508A devices.
> > Tests are ongoing/pending on ATECC608A and ATECC608B.
> > ---
> > Lothar Rubusch (12):
> >   crypto: atmel - introduce shared I2C client management
> >   crypto: atmel - move capability-based client allocation into i2c core
> >   crypto: atmel - remove obsolete CONFIG_OF guard
> >   crypto: atmel - add per-device timing and match-data driven
> >     configuration
> >   crypto: atmel - move RNG support into common i2c core
> >   crypto: atmel - move EEPROM access support into common i2c core
> >   crypto: atmel - expose CONFIG zone through sysfs
> >   crypto: atmel - move device sanity check to core driver
> >   crypto: atmel - check client data in remove callbacks
> >   crypto: atmel - update workqueue flags and add flush on exit
> >   crypto: atmel - refactor and localize driver constants
> >   crypto: atmel - add SHA256 ahash support
> >
> >  drivers/crypto/atmel-ecc.c     | 252 +++++++-----
> >  drivers/crypto/atmel-i2c.c     | 679 +++++++++++++++++++++++++++++----
> >  drivers/crypto/atmel-i2c.h     | 180 +++++----
> >  drivers/crypto/atmel-sha204a.c | 284 +++++++-------
> >  4 files changed, 1010 insertions(+), 385 deletions(-)
> >
> > Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
>
> Thanks, but I'm not sure reviewing such a large series is sustainable.
> I've only skimmed it, but it also mixes several different things that
> should probably be submitted separately (e.g., refactorings and new
> features).
>

No problem at all. Pls, understand my series as a proposal.

Usually I'm testing the features and use checkers. So, the series is
supposed to be functional. Anyway, there are quite some changes, which
individually need to be analyzed and well understood to get this into
"maintainable" quality, which is definitely not the case yet. I agree.

Having said that, I'd propose to separate out the first, say, 3 patches.
(AFAIK patch #3 is +/- something, you already presented, too, so I assume
it disappears by rebasing soon). I'll split up these initial patches,
do smaller steps, and come up with this series the next days.

Pls, let me know what you think. Would this be better for a review?


> Sashiko [1] also reviewed the series and found potential regressions
> that might be helpful to consider.
>
> Thanks,
> Thorsten
>
> [1] https://sashiko.dev/#/patchset/20260512224349.64621-1-l.rubusch%40gma=
il.com

Fascinating! Thank you so much for pointing this out!
I'll try to take sashiko comments into account. Sashiko was new to me.
I'll definitely
have a look into it, either reviews or if there is a chance to set it
up locally.

Best,
L
