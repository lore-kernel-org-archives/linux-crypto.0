Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE21227EA1
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740650120; cv=none; b=otMjHebdH/TadjtNIG8YGgD9pxnBAK2ShT01gkTrqz6i+LpGsJVc3Iun1HA3o2wkSPT9GcxWpO6JljA38LhooNMAKpoA0PsId8zOqStovR5CYCjwwnPHrJmsvRa7naZYE8O/tRBfiZk/YtdFaWfZpsK/z/+lsMVkSjbdwJzv2vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740650120; c=relaxed/simple;
	bh=GMrGy7GjtinHRAXaN38+OyPyk50EHCIL434a80PJ6qI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tT6EnV9/GLN0FxXLZGRGuoGhvzOOqNBhM1PZ0Np69Ptd5rZkaeuKx1C8tCm+hAuH3Gye988XfoWUbms9t0pQ6D2ySVsXn0DsdKNJtIY8n2+OZCeW4+1kDswwoc2XSovdrsS3dB6NTe+w6p36toNAmJ3GNasv/hXCHsmcJMyRFCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=gBGVUyIr; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="gBGVUyIr"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5ded1395213so1046983a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 01:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1740650116; x=1741254916; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMrGy7GjtinHRAXaN38+OyPyk50EHCIL434a80PJ6qI=;
        b=gBGVUyIrEJQUG92LrWo3gAnrRoFk9CP4jLzvrQs3HuU2amShWpsRlug0qScWL6vDzP
         EDLqL9MY7b1uwNBx3qxYBTUAm38EE7EanZynh5r+UpPCg/NUfLUMNCTU6Mn4nY6p1rEr
         7oN7qMSKA3CBr9yOLhq3vZy0875IejitudxOMQKJUE74LrWgwjA3gsf4AlNNtgHbIGok
         4kXiPRjv9bQldsjUYBkw4n7Q0QIUmtTJnwGWNonQ+fCwF4iTh2UNEl+3g6U66iQOXBLJ
         q9tAhVjt1qWDnO0ZMxCa5fMznhFfxaLfB+3+pFTVgLYbNJ7aI3pw7uokWD1KeM0InZ/s
         b7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740650116; x=1741254916;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMrGy7GjtinHRAXaN38+OyPyk50EHCIL434a80PJ6qI=;
        b=EXMJC99sWc2+TRINASgLkDRvknJWHNtlJiBkSLmKmvejH0fXBvklFTGsbS9o/RUBXS
         ZkrjzzolZydLx8/u66TkO2JTIbziLwfC09MQKsZU1V9kdmceNh1o08xGRMupDts6t7XR
         7VfyYDO82yUzvo1Nrs9PBHx4TSVTKQBG7XQWfuLIfVjv2tItDOmAEEs11JUq3Ket9UZd
         Yl50XSDgycYl3ASZAwY+YraEZiHkB657CXu2LiaaO5cfD4OiG5D7k1q3q6N2yPhYrPRx
         btsEZY3SMGSydP6T3soJCSGqNtZl9nMV6U9F3cQowHxUJ/uysbHOEK9OffwsRR97s/gZ
         GWXw==
X-Gm-Message-State: AOJu0Yz5s9xotpIkoNuBv08HMxBThawF84nlMX7xXtwi5hYEqyVtNjjL
	4NmH7Bb3ztyt3cTDISjA40/st/vyGlW/znyiwGoCzoWMs+7x/6UOlJKb9DJ0t/o=
X-Gm-Gg: ASbGnctnuuXelc7ihNkK8Ro8DIgZV2LrSVgBR+NVJxTMB9yLTVdSMWw89uIC/WSmXN0
	4ac8KP4mCwh+qPH1wCk42l7yg+wJzm/1tPNaPwwBz/MWkCxNDWgdTvb40eAHUq5xndsmWRGcyjh
	knkXlmoctq7oU4KMdHfoxKT/GsQQxEoFpb8Xrd8zOBoJMvTjT+wpCHiKM2fjcXjTZuR64PMXfjn
	qHyp0B+LM61tcmNlrG2tAz8HnZj3c8oktmBLTfu1/GNYliZ/11EoOhvcoLfueMtAYu3lloo6sxh
	quSd4xtPOrFeD8pYU2SfmCvfCR1XAU2W0nQBErNCk8n93Eba/gykwkEHgq3ZBr6SVD+7
X-Google-Smtp-Source: AGHT+IHOqWs5W1zWbVsdCamypIUuEl5FiXdceoWzVMCg4QEAxi577mmYKT0uI3sYwCAsXCSxh6AwRg==
X-Received: by 2002:a05:6402:4413:b0:5db:e7eb:1b4a with SMTP id 4fb4d7f45d1cf-5e4457abb1amr13186045a12.10.1740650116291;
        Thu, 27 Feb 2025 01:55:16 -0800 (PST)
Received: from smtpclient.apple (17-14-180.cgnat.fonira.net. [185.17.14.180])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3fb51aasm851700a12.60.2025.02.27.01.55.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Feb 2025 01:55:15 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH 0/1] mxs-dcp: Fix support for UNIQUE_KEY?
From: David Gstir <david@sigma-star.at>
In-Reply-To: <20250224074230.539809-1-sven@svenschwermer.de>
Date: Thu, 27 Feb 2025 10:55:04 +0100
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 shawnguo@kernel.org,
 s.hauer@pengutronix.de,
 "kernel@pengutronix.de" <kernel@pengutronix.de>,
 festevam@gmail.com,
 imx@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDAF33B1-DE06-4A1F-BE9A-4E3E5EDE03D5@sigma-star.at>
References: <20250224074230.539809-1-sven@svenschwermer.de>
To: Sven Schwermer <sven@svenschwermer.de>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

Hi Sven,

> On 24.02.2025, at 08:42, Sven Schwermer <sven@svenschwermer.de> wrote:
>=20
> Hi there,
>=20
> I'm not 100% certain about this patch but trial and error seems to
> confirm that this patch makes it indeed possible to use UNIQUE_KEY =
which
> I was not able to do with the current implementation.
>=20
> I would appreciate if somebody with access to this hardware could test
> this independently, e.g. the folks at sigma star who authored the
> original patch (3d16af0b4cfac).

thanks for the patch! I=E2=80=99ll test this on my end and will report =
back ASAP.

- David


