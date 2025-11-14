Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FA613AF2
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115926; cv=none; b=pz1oPgkwBnNvcRUJ7KZlxyAOMGN5W9CWdvUC7and7+nK2ra0lhMTBT74l1W9d8MQgSbUzv7zA7/I5/deTdBkTK/A2IYWLhx+Xguq3Dmtmoo46yXWkNXryQ02Xj3hGOiswmCU7P083ZT7u4zLGC/QyVAIx8FytqpJmWfQwb0Tu9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115926; c=relaxed/simple;
	bh=UiH2tCm/S1ju7VYoiRzTX9VBIrhUDUXi+G3xtTSoguI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxnujVpcB/VXoRnllq+YJi5d5c4EAX0/xe0pPWeFkWGiJvsjvtTM2PIN+U/gX1pLSwi4d2YRICwaJDSfjvA8bf2pY9ZW2VIDXBUFBK3MzEB/8+YhNq0i3tLVqvZMs1N3jTi/y1srkAjOMPaCgddU7nK+HscUi+15HtBW8J5YwlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d9VrcDl4; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d9VrcDl4"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-592ff1d80feso2094999e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 02:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763115923; x=1763720723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLugjK/2aOcd1kANbuWrprVoDL7qwO58M/oqiXvPZ6s=;
        b=d9VrcDl44qW8JH6S080ey+enZ6YcwN1LWkJQ5vbymvCObF3mLdVJ5P5sLWjZvHTJlv
         TFa5HDGY9EmI/rb75u6Qhlo4v8bE34CiXziIWiGKIP8gY1faTr1OQmFXs6EPfCxRnU3m
         Wg14976qAUWwmKq2TGXNXFXc7x24HNpycIh9PbcinT370W52DxKFrOZQ4Iav8h2W9WVE
         VqgVX1NKyPh3LlVyv1unUu1J59aDvnsM64JPpOQGp/WYiMycxMDGrNwtbxc3BcZQ3+jZ
         2dSL4SuBJaYijhYVeeT+xdNn3de65sZiOVPmdwRCdyBrhwmAH3clivuTGrD33tVIw4qA
         zhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763115923; x=1763720723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MLugjK/2aOcd1kANbuWrprVoDL7qwO58M/oqiXvPZ6s=;
        b=wTf5bz8PJCpYtuCYeHMZPunnjkSPYrL9n5rfzQpWvrU7DgpaEZCZ1RsLtyFWdzxuqv
         FxgC0Ru1i9BqDpXDH5htJWB9dm0M/9orlB9hZNu8PjJaDy9U+SOLNNwDrCzfHnngFN4r
         27yjtzfbWgB5XfdqXOfB0OgryN+k0IIalbjH6OBMUkFj2Y2QHIdehcMbHEY5RAXQDqwY
         711q2B4gOfp8r0PBFF7Oth4duAOltB7liNS60O64iluh+tUJmXAVy6ZYjfaaYWW1+hpt
         GaETglu6A9PUoA25Hp8EEc+WPCSy1PVV1tZx5L91dLxy3aoILkQKNlI7RAKUtRcsurzY
         x/ng==
X-Forwarded-Encrypted: i=1; AJvYcCWSbyoZctlDUi3ItzDfBzT3ze4iyI3GH5bajebq+wzdrOayu+iN1mHLuGq/zxP/hWP6SLayOY+pdrvFfI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbncwH2p2dDvIFhcB7nvreAZv4YXBhdz9yA5uch+BD2yAokEH4
	39jUXa132b68ixJjY94x/8cR+Ni1X9sK/JPqWeouG/MaBM+gDrOSS/vSm9SqVjdmFsRKGLPaqCm
	vNYFduFnD54YtJyHFBHH7w6cVz4eK15y4eo9F41zmsQ==
X-Gm-Gg: ASbGnctY5R+IXNClxMpGqJdTXcaniRurCMk6vgQeDK48H4a04ZIH7v9cNsYde1nXbzf
	VBmLFJhwXvzvKLdmJ/Pzg/TViXGGP+ESQEswO4N2sYGyNPp5hZqnnaMg8oPl+oug573hrnEzvMl
	A/uFnlsZhw/F7wsdAT4JA/8C8jogvsg+zz53fOwMdPwZYDb2dYnnQTPgXQFC73GawlSwZIg9Bk6
	0S/ggdhZYXUqhSW1JFCVwftInq8UP81vaJy5K87XfnUWUUgVqT0M254ubLoawVLPrtoT54HgZXH
	rBYcsJ85DyVm409geQ==
X-Google-Smtp-Source: AGHT+IG+vHnX/GfGDbOGf0qwI/P2NyNv9/lpky/1SJrhvTbXCs4bIpOoG9/nKcapAHhdcVGWWGxHXbG83qZQSmMMZIc=
X-Received: by 2002:a05:6512:10c8:b0:593:f74:90c8 with SMTP id
 2adb3069b0e04-595841feb2amr831443e87.35.1763115922730; Fri, 14 Nov 2025
 02:25:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106163758.340886-1-marco.crivellari@suse.com> <aRcCzMZTcO_GXvfg@gondor.apana.org.au>
In-Reply-To: <aRcCzMZTcO_GXvfg@gondor.apana.org.au>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Fri, 14 Nov 2025 11:25:11 +0100
X-Gm-Features: AWmQ_bmo8lguOmNNoBm-dyARH6Q5UwSpuUqVJKaH5K0WfT987DZTdzJ2ZM7ZMaI
Message-ID: <CAAofZF4MqHDRRoLScMukxx8QefdSx1oeHyGiSB_ScL09XRqoLg@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-i2c - add WQ_PERCPU to alloc_workqueue users
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Michal Hocko <mhocko@suse.com>, 
	"David S . Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 11:22=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
> [...]
> Patch applied.  Thanks.

Many thanks, also for cavium/nitrox and crypto qat.


--

Marco Crivellari

L3 Support Engineer, Technology & Product
