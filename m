Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB50481FD3
	for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768999474; cv=none; b=iF5BlRr2t6bz2eF9naqEC3m+14uyHxyzGAmXrtOV/S+jBPyUtZwcgz4gQFtdc28pHibVdMB4aZ5YQBdKWC6ry9WWeVLUhcR7bjgJa2QINxNl4/rdON4ok26mwtBLX7f9QetWvjTEGHVmu3GPyQokoF/N4uErW6qQMoDAqkIKTsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768999474; c=relaxed/simple;
	bh=jxOrB8wfEeC2m9GMBQa+QZHxO/B1NDwQHQf6JSIEBVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BqCNs+1qrlVL+HC6JWA69YFThcec7HGQOEXplKF65O9mDZpt/B9ljcYtzbO/h8TC3tE5RveYuXk/m/XjNa8dKqyyQIy5VZVm6YB3cTMWCRQryR9KoHt8SolBn4GlfD6LtapvC6yu2ei1D23DwaYkaTXfkJXJjFotIAd0rqlXExE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSkBcFaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSkBcFaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5814FC2BCB3
	for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 12:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768999473;
	bh=jxOrB8wfEeC2m9GMBQa+QZHxO/B1NDwQHQf6JSIEBVs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tSkBcFaBbZKibs5kVPOyBS2H8PmTauBESCSL+Uwgla7l1IPLG7ugTJqOT/c7/WJED
	 z2PgR6Cqiho3fzbKqjLPG1QL7BK6p+Em96KUWf6DOiI+5VC+oQZNvgo9ScF/NeYq0W
	 nmQPcl97qd3txxyvjCF1Oua5hmkG+gruuC2O20O4qrxV5vncGLiCz4IRK0hgyuetg5
	 OSPC1T1fxTDD9PtM5sVB2uXqjQ5k8EocivxTTjqh1fCSj0veoZmjnKP+ieppSU/y3u
	 YdnmilYNvb2Z5M+1ZdUUCqK+VWzaIC5vcamTTMZm2OsGLrtbUSdHp4GS0MrSx93bSV
	 GG4dHr5OW5+4g==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6446c1a7a1cso5244815d50.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jan 2026 04:44:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVap2qp8Ef9JqC1KId8SP6TqQUUOhKhibTh+MfX4puLmaUA3D8l2g/YYbu3UcPIeXNYduzr/oOnaGCfqJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxikSCZZmgn0Psz6rqobY6XoyYh19IDVDhLYdSHczTFrVKd29s
	v/e7zbCys5CXzml38SWkdGLDSbOeVBLD5//qkXAfnxUniEoSB++HPvldMu4x/TZV+JIMOh2oJuN
	ku0CmMlAY6d0skh+oQOhbp2YHtsXCbbo=
X-Received: by 2002:a05:690e:12cc:b0:649:40f7:f20e with SMTP id
 956f58d0204a3-64940f7fb03mr3287094d50.46.1768999472553; Wed, 21 Jan 2026
 04:44:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115114021.111324-1-robert.marko@sartura.hr> <20260115114021.111324-7-robert.marko@sartura.hr>
In-Reply-To: <20260115114021.111324-7-robert.marko@sartura.hr>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 21 Jan 2026 13:44:21 +0100
X-Gmail-Original-Message-ID: <CAD++jLmitNVhWmUf9BBqLR2_WsAR7V-+ykVJsLK3MuOSUKQF0A@mail.gmail.com>
X-Gm-Features: AZwV_Qgthmlr5E7M3bcNO1COpCtqKG_0WAWJfZBTcClME9lzo2DlyQIrR9yT_Bs
Message-ID: <CAD++jLmitNVhWmUf9BBqLR2_WsAR7V-+ykVJsLK3MuOSUKQF0A@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] dt-bindings: pinctrl: pinctrl-microchip-sgpio:
 add LAN969x
To: Robert Marko <robert.marko@sartura.hr>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, herbert@gondor.apana.org.au, davem@davemloft.net, 
	lee@kernel.org, andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, Steen.Hegelund@microchip.com, daniel.machon@microchip.com, 
	UNGLinuxDriver@microchip.com, olivia@selenic.com, richard.genoud@bootlin.com, 
	radu_nicolae.pirea@upb.ro, gregkh@linuxfoundation.org, 
	richardcochran@gmail.com, horatiu.vultur@microchip.com, 
	Ryan.Wanner@microchip.com, tudor.ambarus@linaro.org, 
	kavyasree.kotagiri@microchip.com, lars.povlsen@microchip.com, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, luka.perkov@sartura.hr, 
	Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Robert,

On Thu, Jan 15, 2026 at 12:41=E2=80=AFPM Robert Marko <robert.marko@sartura=
.hr> wrote:

> Document LAN969x compatibles for SGPIO.
>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

Should I just merge this one patch to the pinctrl tree?
Looks good to me.

Yours,
Linus Walleij
