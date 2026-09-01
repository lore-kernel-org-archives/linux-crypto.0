Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2243CE45
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788291953; cv=none; b=ZueRkesoHVnXZlykAZA+DvJ9eApIx0pyaCRaEfCyxzyMoqQCeprV3wzkYLnUrJNA4bEJdD/Vq5tSQM34kvqYA9WaCiSepWdo75LPT8BhCjZwfTRn5TJC/0XQmoGjDBZBKL9GI2vfTdxKTV0X4P1/icSE87pvZtrXhwYDiqwMFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788291953; c=relaxed/simple;
	bh=noIwLroC3QxdO9H9YOTtZZGb08Agpt6CN69Saip6HSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTNa5oyfLg0PFqmtj6wMVKVzrpiYNn2/2fZWSaTlMcgFzYFUH1Xz8MoUyEmCSnp47Jb6g55gtK2Ct/4JKTog1kM/FWVmF5dMev+lTxJdbOv/l6zLkdun2GLfe8qwvU5WrRqgqrfNpEaZpCzM2htg7Gz8OUyW7fabaYVWQHLrsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYEuRlny; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYEuRlny"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so1813185e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 12:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788291950; x=1788896750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=egjLnBNnYVR/hTviRogWVrzKsRnzbjObGE015hZhVf8=;
        b=nYEuRlnyvYuUTVHVEGw1CFg38PvUZLtZhR8ugfQHHMlriqJXVOcmkfK7xvh1lWRyfj
         bkvQCYzIzj1BMlfO9c/rKChnHICHE84sl7b7+BxTvd24dSPaoIThSiZslUykDhAXT5j0
         VOzjijFudsIGXMmV70gpsgX/jCcA4Nhp9RCtoAK+BT1HcMy4ZqtDGCql8yR0j/Fmx95x
         9O26rIy4XgicGpLBVm38Ce7vV6Woc/ZXL6yvvRx/IqSVbCc4VhC3aYsEPxIqeVNUAHSU
         +ZeV8NdK5Ytsu1GkotdlEHYpJzuJAnPPU0ah0TT3/Bu1T2a32Sjl/91F5JRK5mxTluL9
         163w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291950; x=1788896750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=egjLnBNnYVR/hTviRogWVrzKsRnzbjObGE015hZhVf8=;
        b=Mem6HCYmzYvmWAMEHyI57WjrcFeAv3cXHFE4F3FAExnsP25QYEDxBIG5WrOk8dgaVd
         ZNsZtQuyOxGGb6a9j/d8T3lMYlviIg7JNTk3UYiauq9si8Nr293oZWBeVex3TeBuWuZU
         YamBIPNJNfKXZm2pVPuePe4Dqa6jpo/xEr11pREKPc6WoxbkyYPlZ71FP5xyr21qSlqa
         zctCNM2jqu4lJ2zBzysoomhUWXgNuvk+WEG8Bn4iQ++pw6nfY10meAQemoz0wZMvnQo+
         yLlrnV+ZfhMup4O+mC/d/jaUp+4heW8Wd3C3lJM81s8PpGJqXWpq3aj1kB/kcYRylS4K
         tSFg==
X-Forwarded-Encrypted: i=1; AHgh+RrqXFRQyqDI4N31MeS8lK6KsqEf/FiU+GDuRd+CHO6bM59GyX2wdq2Mk2waP5Sfdt4poDI9pe5LpNtNUNc=@vger.kernel.org
X-Gm-Message-State: AFuF++na0j5yq9wahcnIZxP9gVvQ2149nGsVYjB9n+Lu/CZY39iqcB9S
	1A5i/u9zAnJW+cIOw0r/Vod1IEVfhjMpahMzq0uLDi3F9C51on78QSMn
X-Gm-Gg: AR+sD1218WMvWTZFoN58/qXysIcMRvO2u6Xs81UUwuMAf/ED/nVB3GPBklJjWZrqGuz
	sGJyoDWhs2Qu9mlXkQS1/RkCG4c5+zqacwpp7hUTeya95rYEJbyfME0OMsibudkTIQT1P6GCud7
	Q26jxE76dMjjdKB6ezjC7EanooHivQk4XDgcKLyZHAy6b7lHMK5N+QvvubRxN+J1t+ToWqlmoyf
	SvC2ZxjdfWD5xtdttpHS5g91T3vrHcWJnp29Xae5uCIWrjX0h9qtE4JjdVlOJcYEAyuKsXenIjH
	SfuNwcGV/kTXgzqitkc27ycdWWTl0O1a8W5Q6v+iC8/CGABpqKptXyJaLitNYzjt8kH8966flNk
	uRMY8133yOugBlI2K9Iy5vnLRNB9aDHEG6fV4d91amzO7CPJdo1bfw0IHTVEj3Uw5L6s0xZyZ3z
	ayBhyy5josU9BFhI+b4vnkx7z4MZmcaTx395sxsubkxP/aSjn8gZ/WzyHJLekQn12I1fOE/uyTe
	K1mSjW6IGvlDllBpdoIaf4InJepHWoe0WZmTEpnXsoTbIQQj6h4DM2PQr8lonWvfgjRe6j2eI2c
	dLey
X-Received: by 2002:a05:600c:a55:b0:499:60bf:c6f7 with SMTP id 5b1f17b1804b1-49b91c4cc2cmr646542415e9.13.1788291949789;
        Tue, 01 Sep 2026 12:45:49 -0700 (PDT)
Received: from emanueleg-nb.corp.toradex.com (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch. [83.173.201.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce4a804sm103691665e9.15.2026.09.01.12.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:45:49 -0700 (PDT)
From: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
To: Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Subject: Re: [PATCH] crypto: caam: simplify probe resource and IRQ handling
Date: Tue,  1 Sep 2026 21:45:19 +0200
Message-ID: <20260901194524.908240-1-ghidoliemanuele@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730204722.1101805-1-rosenp@gmail.com>
References: <20260730204722.1101805-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 30, 2026 at 01:47:22PM -0700, Rosen Penev wrote:
> Replace the open-coded platform_get_resource() plus devm_ioremap()
> sequence with devm_platform_ioremap_resource(), which fetches the
> resource, requests the region and maps it in one call.
>
> Each fsl,sec-*-job-ring node has a distinct 0x10000 reg region and
> interrupts property, so the region reservation added by
> devm_ioremap_resource() is exclusive and does not introduce overlap
> failures.

This patch, now commit 9a955c0a7d11 in v7.3-rc1, breaks CAAM on most i.MX
SoCs (i.MX6, i.MX7, i.MX8). All job rings fail to probe and the machine
loses its hardware RNG:

  caam_jr 30902000.jr: error -EBUSY: can't request region for resource [mem 0x30902000-0x30902fff]
  caam_jr 30902000.jr: probe with driver caam_jr failed with error -16
  caam_jr 30903000.jr: error -EBUSY: can't request region for resource [mem 0x30903000-0x30903fff]
  caam_jr 30903000.jr: probe with driver caam_jr failed with error -16

The job rings do not overlap each other, but they all sit inside the reg
window of their parent fsl,sec-v4.0 node, which caam_probe() already
reserves exclusively via devm_of_iomap() before it populates the children.
So each job ring now collides with its own parent.

Seen on these boards (CI/CD):
 - apalis-imx6
 - apalis-imx8
 - colibri-imx6
 - colibri-imx7
 - colibri-imx8
 - verdin-imx8mm
 - verdin-imx8mp

Reverting 9a955c0a7d11 on colibri-imx7 makes the errors disappear.

#regzbot introduced: 9a955c0a7d11

Thanks,
Emanuele
