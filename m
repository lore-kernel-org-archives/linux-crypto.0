Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2CD17BA3;
	Mon, 18 Nov 2024 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893724; cv=none; b=RP7f8yHcotxHoqckv5I95dZ0gVVgH/7K7PZdjW0HffXjr7+Dd8sZu0REXv+N+mD7QM+g0yhY+p099qYdKy2po/5ZZglnf2pO2Bc1oLWwqJuLghrOQAoBFlyxV2XMJDCmI9BvmQZJbgiy4dO+SlXc+e6UgZb/NI/88eAE2Hj7iz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893724; c=relaxed/simple;
	bh=h450FS+N4JQKnGl6Cjq5GAKaXyzhyQUvhLoUGtWhzaA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Wz03PeKNe5uuQ07BFK6QteZRTxny/xqXkkM89QSVIRFfuWycCyAcbmgkCEnuMCFjgaq3xCsA46Zocf0DHfPO+JtuI0q9lZ121mvAaYIHxyLHmbVfXE6ws+bTSceO7zcqbRCVVZ5PTAt/IPviqqKQH2Q7z/pA7LAsF0FsRsVSFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=a03Dkdfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a03Dkdfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBA7C4CED8;
	Mon, 18 Nov 2024 01:35:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="a03Dkdfl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1731893721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=h450FS+N4JQKnGl6Cjq5GAKaXyzhyQUvhLoUGtWhzaA=;
	b=a03DkdflbmPZWuEwvO18XrKnATy+LlD7itvHB17nH4cSRJBwaGhKeENUIszf8TIOUfii57
	twQ7JtvfsC6fI6njc1Ysr8EyzAbbFfCFg0jT18DMUGai7R/NqiQLWDWFGaPcc9F+gIiAOb
	mp8sOiy1RimWDF3C+nl0oY6cu5xVPSs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2ea50c24 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 18 Nov 2024 01:35:21 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-2967c76318fso300387fac.2;
        Sun, 17 Nov 2024 17:35:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWU85TsKs3mi26dzwhslvbGrnmZLaznpjW9VZXP5jnA6NygL1TZ8KVcN/lwcRgzNJzLoIEdgakPVqA+oYY=@vger.kernel.org, AJvYcCX1QoylgCrXk0DnDHOqYc64m5bZFul0dsfNdJGSv8n7J5b0u2OWCDqXFGpKReZBejZtHjg9ll7H@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs+yIErPOyHwZIDPLONkse1u3Jed+MJbY9Mncad6dwu8WmEt+z
	bbKFDhH/rn5Zb1q1Ul/bvuJLcdP6xf2uqIq7LYs6K4y6wQBwfdKBmFwg2SyvonJKfIF2ODvAl91
	Xy/xEp3Y4h+W9TQo16gJYxCidGIc=
X-Google-Smtp-Source: AGHT+IHve+FfLk0qGd3A+fSIrQMtA+DGCD0QPeBGZ5t0GxkKmEBP1pNmF4QCtUQzBVHsIV31XTsMwLw8+B8F8/wH7CQ=
X-Received: by 2002:a05:6870:1e8b:b0:288:57fa:961d with SMTP id
 586e51a60fabf-2962e2a2d1emr7370424fac.38.1731893720457; Sun, 17 Nov 2024
 17:35:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 18 Nov 2024 02:35:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9oMT7+VnYrrj7JSdmPCOn6WOdHWMnbPV6tUJicT8i4dKA@mail.gmail.com>
Message-ID: <CAHmME9oMT7+VnYrrj7JSdmPCOn6WOdHWMnbPV6tUJicT8i4dKA@mail.gmail.com>
Subject: WireGuard & Linux kernel RNG @ FOSDEM 2025
To: WireGuard mailing list <wireguard@lists.zx2c4.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hey folks,

On February 1 & 2, 2025 in Brussels, the FOSDEM [0] conference will
take place. This year, there's going to be a stand during those two
days dedicated to answering questions and interacting with the
community regarding WireGuard and the Linux kernel RNG [1], and
perhaps other cryptography or networking adjacent topics, in addition
to the bonanza of stickers and such of course. I'll be running the
stand and will be hanging out there most of the two days.

If anybody would like to help run the stand with me or organize
anything around it, please don't hesitate to drop me an email. I think
this presents a nice moment for the community, both to pull together
developers and other interested parties into a common place to talk
and discuss, and moreover to help with education and awareness in ways
that "read the docs" or "ask on IRC" don't.

Looking forward to seeing some of you there.

Regards,
Jason

[0] https://fosdem.org/2025/
[1] https://fosdem.org/2025/news/2024-11-16-stands-announced/
