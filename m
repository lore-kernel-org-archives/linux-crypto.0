Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794484093;
	b=MflWlY4C5CIME78+k7q/3bACgelVqR+zpaXzNWHAbZAwuF981kecTX2f3lRJT8JnaS1x
	 wN3Rfb5562PmygZDGPHkSzHUio/GbAnyu5rxFEqztmuIvVraLsuxKx5rFBep+WRXaCkzi
	 DOjlqGC8tsZHednWEk7WfZ9P76nk9X1P1Rr1aK9EpPDHo9ia/prsrta8IyzN/e07/Q44m
	 1AfjXOMA8Kd8MIruiIZG+55UtstBoRelsJaVVdzdFvmlYJnwiHmOPSdNA/Q8URgyd3YRl
	 KrfQfxi3kQcdIRb7Ek/OKbKIHkP0Au2DQT4CpCCSQpc7gUsk3nCrY2q/97dpTmjlGvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2G7w3a5fSFO72sjeDlpSXv/kZonU1Ep492RRrSQfwCA=;
	b=uW1gKoUv1pdOLnOjcsBCZjBBY78UQTr+6TihVenrNr81sPbRqWEq3SgMyFhblaCnEGtb
	 oceIc4YDsr8ZT4qYrKLk8wGHilDSI2RYwS+s1BACjiZTw0lluATh4vGgnuPGHV8zkdGLL
	 KnHh5z0DqnIlShDx3NlpyffwHb7/ht3+EUYIpO0Hg2SwPvV+2NSjiBoQ/ttATS/EXxrUg
	 4mokLpxSTqAyaCOPKVilv9Znl6xOEKr7QXzgTJYrxNFBw8P8jT1VQAnjsA7LiMdOjhwgX
	 FuvVdhM5KSh05rHKMHPfet/Yp8YLVy+I9cGhjDPXVa09g1riNuQeH9i3XrFUHaY6KjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nV3J6Zdr;
	arc=fail smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319C606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8319C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nV3J6Zdr
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5c08539c827so3016263e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794484092; cv=none;
        d=google.com; s=arc-20260327;
        b=fCN0DJiGklzAlAlDss3uf76oqC5olE5kkq4NDc6hupyzOce3oa1EiXajAQnCgjmWf0
         amI3TMkWrcM+T80Ef2W27pkaXqx6P2U+Wm9VP+rv9DXphs1nzu+3v1deaXULjeayUe/T
         nu0Okb/EKEZVLlCr+rE8IVlA6T4k5EfyJ/L5Pb9/GK298FOrN2rRomxHNENCz4kx71Bo
         6HiT0b+lT2WiileGIkIJM3Uu7l8XPUFGMNFs8yEujMC6zqBB8tO0fd5MOQk6CgNWT92/
         9Ad0Pn+ApXGI0pKZTlHFe1xmXMLXal0AEWrxe3x0P0OX4SJ/kPtRJIKT1V/dVspd3gc6
         +CfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2G7w3a5fSFO72sjeDlpSXv/kZonU1Ep492RRrSQfwCA=;
        fh=yCFx/3QZSbRL6gg2LE+4cv70bp6P8A5nc7bJtzH26Gw=;
        b=Oe9fXrn3x2d0GV20FmWOBS3vD64i5LU6qRi9By5Eq9ZOT96ZfwxT9jadEQUG4+q2fP
         xQdoKWjF1A4JT7eu387AfqXa2HayXWa2THY14sIjupegLms2TpIGKxyOSEATO6liahXt
         759cakPBb1s1jhdavaiFhA6K5+rxKu0r9k+O+vB+655UmPYm30dCA2RRHWgpyliTsvRp
         3K9SHy5YeKVIu1uq1+UxgzW81GEBeljt6XmPt2KvaoQKg6Vh39yblji0l7RwsoV6Ond8
         0FNxpTylzgg1UXh6D3KzKsqFTuflhIxTqL9IEsGF9LcfCm/cHaGqHShw82LnXGBkrCrb
         CfDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484092; x=1795088892; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2G7w3a5fSFO72sjeDlpSXv/kZonU1Ep492RRrSQfwCA=;
        b=nV3J6ZdryFVbPzy80vruIcDLwXvsDLos4LsRVp7+6RXO1aO9PFbsobQ9dhE7qi1MEQ
         9LDpAbYYdBq5qVvcm2xM1Mzw2ueqqjhnwlB/p3lI9G4C9E/LcRmGxWbHfMTiGjJl+wiB
         2HhESkFrG0hkmqt3hrLd0Q1JZmZbBIVhLaIgVMibt961ShIH4tMYglJCvwRUd47wvJ3P
         dQRdgGe4vk7dz9YgnPsyUA+Wv9C77PJ+LwVwMhqktWGR4DMdyIA5iLtQ2POpQDLfKPWT
         +frDGxzM5cQ63KIGkzMVkqHbokDBYvxYQIU1+ysq9aIC2u7b+Z9xOm73dCoeLU8Yg7YZ
         gMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484092; x=1795088892;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2G7w3a5fSFO72sjeDlpSXv/kZonU1Ep492RRrSQfwCA=;
        b=ZoSWQCnyMLSNGUIvaYbIacRz1GzIOaDfEZDq/5gNjnpocDetIjxgrtxiNWMxBuvb/I
         RE62bFu6W1KufMoN4l2d8eop4KuIlt6n60pORkT1YN12rvMDs2F2/39ZL1tMd05zEg96
         ept2i41mgz8iEviGEAahgzWFw1AmJ8sg8B0CCUgfjPgBJ06e7QxEs8K4oOBor0hV2NLh
         WSaxt94AQ3Yp3Xp7omuaKp/ufvDDE3lxspXFX+EBFz6RaOsLOR1+6i99QxOwHPSgzDVF
         s0s+bWKwrPRbD/kxF8UFENTRv6+pWJtGRcL7nKB2EH0P8XqTaQFPXKdOQJk/w2y5j+aT
         Jjlw==
X-Forwarded-Encrypted: i=1; AL+hErEu5rU7efRQKY36t/AWpQtJM9R0dpOLDdmLEa4YituPC+c2Iyzhqos9tMeQU/apjtAF2wgoxiGqMNWXlNE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+He6fAG0wi5lpC0A7xVNfnZXOOykb8uKWirsoSIYkaHYZsGq49
	P0XLpeeHNhLhAdxPgMBfCpco3Lr1vPSfsCpRYuk2X2ZFOQonfAz8eFRNuyAACSwZWeWx2V+3uV1
	YB31kXrdyb0eFp7YYY0X0wtrEh3deofM=
X-Gm-Gg: AYBFou39qee8l+f7Rz6YunUXR5pyao7fnXLeKKOeR9082ow0v+45jtjz722gDP4ay+/
	uCQ5LctaiujfXO10Oq4VsUmIM0/hYRAy1aBUmfMWrSGFFivIFydvW9c8BG8ft3LQBhisWhkbDuG
	ebGYJ6spFOwmDKAbS/Bjx782tCdggTJb5bY0Hg+v5k4QEQUytUVrYO6ix0sZm1g8+WaHCu5VFDQ
	Uukkx9kaR8wNf1sel41pvXBecDP74Kl2MijgDDs48rbK2sWbOm3uInfZuU4/An8qR5N5+QGd85B
	7urh3rYKYg4wdXc2KYbTT3tWk/Vm6lpwbBo37w+Q0BqFRbglgm12awBaSqzCHaYJ73w5qkVis3I
	bmJYoE0B1mBaDdCBGPSqxXtBpykHxNgU4Fx5ucziE345oN8hl/OZ0xhk3U8Kraf4Rhe7i2vwkhy
	4XSDiSk8Cl2QJypcjfrgNPRkJtaw==
X-Received: by 2002:a05:6512:3191:b0:5bf:d54c:1fb1 with SMTP id
 2adb3069b0e04-5c15d54b357mr1552506e87.2.1794484091504; Thu, 12 Nov 2026
 03:48:11 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028132825.657546-1-festevam@gmail.com> <20261112104151.713649-1-sahil.malhotra@oss.nxp.com>
In-Reply-To: <20261112104151.713649-1-sahil.malhotra@oss.nxp.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 12 Nov 2026 08:48:00 -0300
X-Gm-Features: AclHuK93YbB4VWMKEzFyF2uYg_cLba_j6jbM7pY7iyTKLjV65FIWhlOBoNvuhlk
Message-ID: <CAOMZO5DOBhSY874fAyZZRdyGW8=Qcmf8TT91gnE+++xRAEwizw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam: jr: Use dedicated shutdown callback
To: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
Cc: Fabio Estevam <festevam@nabladev.com>, herbert@gondor.apana.org.au, 
	horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sahil,

On Thu, Nov 12, 2026 at 7:41=E2=80=AFAM Sahil Malhotra
<sahil.malhotra@oss.nxp.com> wrote:

> Hi Fabio,
>
> Thanks for the patch.
> Can you please tell me how to reproduce this issue ?

I observed the warning during a normal reboot on an i.MX8MP-based
system with CAAM enabled and an encrypted volume:

caam_jr 30903000.jr: Device is busy; consumers might start to crash

It happened in all 'reboot' cycles, so it's 100% deterministic.

The warning occurs when crypto consumers still hold references to the
job ring during shutdown.

The patch allows the shutdown callback to quiesce the hardware without
requiring consumers to release their references first.

Regards,

Fabio Estevam
