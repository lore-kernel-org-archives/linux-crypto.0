Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F23E557F
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 12:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781525609; cv=pass; b=cnUCP8uYISJIlGJyxvzEpfMR0REZ5DKaeMTk0UvlD+rbz99bTL87bXfyy+17RcAvgV/16ym3XGkWGpLqVBz08DhAzMNOPjqpnrB9KFRj/9cqno+/AOY1un5wWpkF00V+eCXajlvq7h4WDHy8GsipN6S4VfGI2USLttaSa4li1Pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781525609; c=relaxed/simple;
	bh=7UKwny4OCS6po6kCIfAEvgf8DBaHp7r7k6YYOJQPkEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uFTjfufarpmKPzm1bt5eP2+/6b4o0LyZPfvfWwrNF3lHR1veQ+/0UxTmxSiVI4mVP+e1IIhPnYQNtwwGeFdh9XoO4bZfQr39UyfvmDAn/0fp/L4vobSMtpMMcf3kx3a30R9Hdo6GaxeOvermB/ZPXXAW6YgygDbCfEh1YFnXyiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=erKSk+/j; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erKSk+/j"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aa63daf2a5so2224956e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 05:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781525606; cv=none;
        d=google.com; s=arc-20240605;
        b=Nvh71KoLIIol03QoSlIYCrNCSvRlekE3ALohMGDKNUb/wUz8md4ETiFII/rkWOVj18
         AJcUKA6flT0vAvDgw23PMc6ljPKjiXMjNerRV+sbm6n3BD27Ncj1Ebcg0uBWBSAohAL8
         kG3DLl3O718hZ2EnxOaDUOE7Ra6OKd2sZAIYMxc7Sh6UaOm+U0ueqEzwpkzNMK4kVNAO
         oFEs/wo9wkLk4VRuWyyMIjCV+EC2hQ/TTXNHHnOYTOpZinP7+RV47Eseis/1TsR6vUmM
         f6rrC9FvBBw4WKtbA4r0w1S89inFOlMG9il64R5h0FxvPFf0+y0/iaBXWGbXMQp2z7Lu
         BoWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7UKwny4OCS6po6kCIfAEvgf8DBaHp7r7k6YYOJQPkEo=;
        fh=yBt6+1RH1riwqTDLfTVKnM2XRA7opZNu7Xv8hoH1ws0=;
        b=f/eLAFtHGbsrqR8L2eZyfAo+HXLFHwOqQ4Z+g2zY76419eXMe2WmPrfKaFMhQNKnlm
         dsmqR83abZoF+dwgPgRVfRbKr/hNDo8fulGxh0GZDJZDtPQ/ETKxUpdVmQY3qk3ulUgz
         4O+abq7ooxGwerg4z6A/RF3gsA1V60ccCb2p8/POgOf/GN+xj1y1RzqEosNFHDt8L9LE
         NFG7XiNNTamso2KwJHWWDInqNuI66LwtPPLdsLGTfdBBvsHW7kPsHMHb3LJ+KvxpgTrT
         RprNEToOky/ctetQnrEdyhsT6v2awJ2rk9PxxWlcdIfOVd0H6VfqifvNxsJ1jKlzpRyi
         OuIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781525606; x=1782130406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UKwny4OCS6po6kCIfAEvgf8DBaHp7r7k6YYOJQPkEo=;
        b=erKSk+/jeDXFFLBBkPlry4Lu4dN1/Lyo7JqGWe1FzwmKlDX5SH+EtOVwqJiJ5wnrG3
         vBswk2ym+myrRuk9IUBaAwLwX8FIRZVCRybkgj6cWiMMTCDhZrjtEcudipHMDnyO0zDk
         1XsfFzVoLA4fStNY3BdJDFMhSIv6NaCt20UYBxy6APpO5bLfkaOo4ZYAz0MQWGGVJA9B
         6ib4kSa8PjrzJ8cw6pv5AgvaRP19woTY6NTUJ6gS+MPEciy3Wy6C7hTpwC269UA1wk2T
         /NkfdywGhirdDSO9o0VXcs69oX2TE8oVfRvoIrK+EDvpqL5mrHpPop5+tHwRG58zVGGg
         O2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781525606; x=1782130406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7UKwny4OCS6po6kCIfAEvgf8DBaHp7r7k6YYOJQPkEo=;
        b=muCrZwK0C0KeZK7cLakk7TUxATPdcK7Ivq3D6pBsfZ4j7YY2aFcqvcHU9PHQgLtT53
         jtaNLHnZGahrc8ZMDMiYbHEgzUt/Z3fCbjHz77CxY6t9o5im9P1z90d3ZjJB9VgPh0ES
         /T9tUcQacChgvNPmwRmSS5yRojq5xIrL+ttB9cE9W/ltFwteTb3y+3+FVMXyV3xHXhe7
         CBZeyZ0VANaNJ8LnoBMHjmZQ6CE8N7Z2BbcE8QRbKlVvamNxiKy+6++bdKX7Qctf+ChU
         K0dRtjD4e62AmCnURXUt/hl2x0R/3if9XngD3mOzCZYir52ZFGfjBRUXTnM0AOIDOM+5
         zLwA==
X-Forwarded-Encrypted: i=1; AFNElJ9j/tsc4cPCoGwVsiYFBknukoZVMLEKERSZ43mapj778Z4Y9ng+j0wOdbO0fN1sEzLH9SNlK9mou8ltljM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBB7GVIjcPCvV+v4mMETJMK5XXVlD6mh1w8LixjN6bA06QhOX4
	fCxiviG4af/W9NQyDhrVObA7nq6jcPtH/qxgynjdTxoA4FnJwsvh0KDCKr7Kjxa6HoZuekT8gkg
	b/SkSLXK14gGYrmsQUJVyQtFGDo2joJA=
X-Gm-Gg: Acq92OEFS0ejgTw3J/7qpqJ0//0IeQWtjzEJ4g1q2U9IjtDksr6dlVa70D1JCuCqw4P
	B1V967u13ig/M3hQjVE8kz8wQR5E2tOpPZl/Eq/7FA+MbYhBBwIvGNjBkRF6019JpalafhZJMq+
	vADjTeLuFyPvT4jjy1r0cLVsTeYPAr7zdMeTcMUxsY8TruebOnkjxUIYQqAbw+hyJu4A23o0AcI
	WgSxNGh9q2Swy1m6Uzu+les1+1tR8G/VchdIJiQ1Hgjvfa6m+fF7u8HRrfbRCBGW/VqpOGj3lN2
	Y1jo26/xXe7GzKA20P2gQGSwglMJKrrLu8i4cXSya0AoCUJZYmrEkmRXYus+JCUsxMLufas3C5P
	k/LBWs0I=
X-Received: by 2002:ac2:546d:0:b0:5aa:6155:d645 with SMTP id
 2adb3069b0e04-5ad2db842d5mr2873491e87.44.1781525605862; Mon, 15 Jun 2026
 05:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5DgENq8RU6s2CPnKsf53i=7zoBeO38m_BtV=w54hr2hgQ@mail.gmail.com>
 <b7c92302-d675-4610-a815-b353ff365e36@kontron.de>
In-Reply-To: <b7c92302-d675-4610-a815-b353ff365e36@kontron.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 15 Jun 2026 09:13:13 -0300
X-Gm-Features: AVVi8Cey7mHTp1zCpZEvEwDbCezZO7jucn_FYBT_wDOzuts6YZNGLsTJyi281u4
Message-ID: <CAOMZO5CQ-qfqFMBtUbew1xmvnV=csdC1PGWz4AYb1cB_Y=xMag@mail.gmail.com>
Subject: Re: i.MX95: EdgeLock Enclave secure storage
To: Frieder Schrempf <frieder.schrempf@kontron.de>
Cc: Pankaj Gupta <pankaj.gupta@nxp.com>, 
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Peng Fan <peng.fan@nxp.com>, 
	Stefano Babic <sbabic@nabladev.com>, Frank Li <frank.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Frieder,

On Mon, Jun 15, 2026 at 4:18=E2=80=AFAM Frieder Schrempf
<frieder.schrempf@kontron.de> wrote:

> There is no upstream support for OCOTP access via ELE. The
> imx-ocotp-ele.c driver (despite its name) does not currently use the ELE
> but the FSB to access the fuses (and is therefore limited to read-only
> access).
>
> I have some local WIP to add ELE support for the OCOTP driver. I think I
> can post it soonish.

Thanks for the clarification, appreciate it.
