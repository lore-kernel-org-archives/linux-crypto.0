Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09006346E54
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 23:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774914278; cv=none; b=m1SgMPLm0L4HKTmgD1KV2w0SmcsdCJ8RzJ0RLrQFnir3WASNhbbpcYpOeW4Owm7/rACwHvXC6cz9tewcBb7ISWQa+IcI/mBLL1vFQb+nMhtj3QMnc1fTFGxwDhzaSlTC0iaRco0aSnQKO4Mztkcrw8JoqjUyfibqYQOWTyNW4uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774914278; c=relaxed/simple;
	bh=rFPnKKeRu/ZRYlgv+EHmX2Yx2rS5K1i5o/cY9KugaRo=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To; b=TWq92HeBYGXDsgOza6O9dGcThOyUGZSnPEspvHvBOTgQ9wz8C5ZgQgFNNc/BIrxImaPPpV5KUkxprxgsYLLKd8Xbe1EsZy3KhsdQCLDK5YfTMBwIQvDxPXOybdyTlDrIrHeQL1ttyvRuAE2fR5h7q7EA7Z+09EdtYiwWfOi5H8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1oEmP5Y; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1oEmP5Y"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-67e0ac36d87so1886450eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 16:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774914275; x=1775519075; darn=vger.kernel.org;
        h=to:message-id:subject:date:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BgqJ359FqbPO5HXcYUOeliz4KNjCDupb8Zml7ezG6b8=;
        b=N1oEmP5Y+cgs1XdC2ndkE2jzXHNfTklLICqiMSkbnSHDTT+4xavZRkmfvQCIdMHsbx
         UkoZGZ8jP8BFrrM/pEyK4HVugSCRmXac7t8KFAlpdi4TCQA1KRWSlLIUOPHO/DExT1CG
         WQqAEDDcVAwYWFC+ixrVf9Se7T6QLBk36GnYo/E2n4O031QIt7jTppAPDNHcjZZUZI9S
         6vszFGqFF+lecVFLqwRyU14XVnvPb/EWBNevegiVOUOgOGT2F8D/gq30YFW/2F9Mmg1a
         c6K3PUlh5h5u6dLyOjtJE/eKDkPBndPs90aRkf7uq1QpW2/D8q47G4ONqgjm/g9pi3B4
         M/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774914275; x=1775519075;
        h=to:message-id:subject:date:mime-version:from
         :content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgqJ359FqbPO5HXcYUOeliz4KNjCDupb8Zml7ezG6b8=;
        b=UvdRHawGYKmv66cjex/UBu3xV1q3RcLpAor7Bt1GsXR256ZAj/FXWKRxlecBri0A8l
         77OazCXYk/K7f1E14SMGpd4oiQ2nb3GgiJpqY1quzGID2glUkrBgl5lpnI8AeJrihNRP
         WhwwIl5HF8wJd1LaWmaxGfmHzpa8Ed4Kp2DDgqbSUJZjge9wIXa2H04eu8dvONRM3+hm
         pU4yDnOI3ApGrIK+lD/ckvkl7/sq99xYc9/CSkZzNTf5TdYyoxtdx51+9Oc9m4CnBzAh
         H6HM9+o+iFOVBrYIIm14ms/xlwqdzBbIu/QF1DKZWm6mnSrenn9x7AXTwRe6CsC2koUM
         41JA==
X-Gm-Message-State: AOJu0Yx8ZHz/FNBk1blJjp4qBPatKtBxY/Czmb6XL+61X1zwl67nQ3Jb
	Oe272CocB7JDi8mJFNrcmT2gcyT8Rl2K6uMLa+mY5KnCe2ql2v7CrqbL2Sx7nvhC
X-Gm-Gg: ATEYQzyHoLYPcymjosVSl1FfS6SfzgCTQvqXD4g7VjnMZAliEYwsLIvbApDAmIiO8v8
	GrylbzAKv8ztj0qdh4GxGCxNbtjYgEOC6F55lI4svSxms/a+26wcenFTWhamLTw4cgmNG6hZOIy
	5stJp/ybgXxhBKhMJjxDulbtI/SU0FYzQD7eY5x8VS4MkjWOMj1vr35sFRdzUBKPwJawsEU7j6F
	dF9HJ0iRcL7OuwGzudPr+HJi9paiYaXEnlluc+GoUJeRBi4HKP1ynkputndIMx5cqX1U5N9wnkU
	Jlek61LftCxsu9j+pFi0HD9puauMQNHs7bd09//S9051YwCkfXD4SNkgGrN0sQiPLyoWrG0k4hT
	CNPaQEY3Tg9lz5U08OP30F211RfTjCM4SUOnKj8sZ9lSZGThdrxug7IJGBA+78tYrLNZRGA+0GV
	qqy2tHiG5N6Pteq0Xn9PkUf8Yor21sIC+70T6XWp6/RaJNkh25QQU3o3tt1BJ9AOglLA0Ss2A40
	uafJg==
X-Received: by 2002:a05:6820:810a:b0:67d:f53c:9ed9 with SMTP id 006d021491bc7-67e18642995mr7919308eaf.25.1774914275535;
        Mon, 30 Mar 2026 16:44:35 -0700 (PDT)
Received: from smtpclient.apple ([2600:381:6705:e5f:ad55:112f:ba58:2819])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e231e1329sm5916529eaf.13.2026.03.30.16.44.34
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 16:44:35 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From: Ryan Appel <ryan.appel.333@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Mon, 30 Mar 2026 18:41:46 -0500
Subject: Kernel ML-KEM implementation plans
Message-Id: <5F9ACD7A-F3B8-463A-A00E-28F68819A66C@gmail.com>
To: linux-crypto@vger.kernel.org
X-Mailer: iPhone Mail (23D8133)

Hello all,=20

Looking through the mail archives I see no information on an implementation o=
f ML-KEM that has been planned, except for leancrypto attempting to make a K=
ey-Agreement Scheme a Key-Encapsulation Mechanism.

Is there a plan to implement a KEM interface at this point? Is this somethin=
g that needs support?
How could someone contribute to this? Just fork and code and pull request / r=
eview code?


Thank you,
    Ryan Appel=
