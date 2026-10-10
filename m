Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E91333439;
	Sat, 10 Oct 2026 08:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620154; cv=none; b=Lo4uimUHwAZnhl9WYuTX+MczU1tAGdMU0LSzjKY0uzK6x9maDtv1Tev7Dmzi8XuEv/ITsRbDNjD73rUc4g5NMgVfeykX+wZTqckfMdGDDDgaG/yYgTo5yWHDMuA9ag3iLdr6+f3lJn2SD6KGKatguAiFhbOxqqX9cbJo5jmeZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620154; c=relaxed/simple;
	bh=acDxKuhOLGGK2oW0DYlbt1lxqD6yQrEiPWUyi1jPvy0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zv5D+YJ6+rdB6IZgnfInIo247/P0Xa78a0iPf+/ArwVN9KVN25tVYpZ4jP6jGT+C0XQAcuFzIaTLLg0rcqYlkst1FsLrV6uL/Xc7dVVW/Zm/Jza1EubIA+BW2GG1iSHeDyUvligV36FhWJvM34cEBPV5YCLRKsdXDQ3XdDRZTXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=pxTD+Ef7; arc=none smtp.client-ip=217.70.183.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="pxTD+Ef7"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1DAF31F4F6;
	Sat, 10 Oct 2026 08:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1791620144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acDxKuhOLGGK2oW0DYlbt1lxqD6yQrEiPWUyi1jPvy0=;
	b=pxTD+Ef7LnIgux8lbFifhuueGT6s5ZGqEbs6PTnqG6KVeZEgb8gZdGLqNVqp8f82FM/sD7
	SdaPfraXf/HHd+OLq1H1U2Q/5SmqmyAqwLx6hFFYB7SOwfTFBOnUOvnqCaJ/Me5kIZ5lfw
	+9qqy06GztKKzXEnIU/AHAJMgiN4irwTrEoVsgWB5Pv1iDJfQ4Ru7El5Cmw1O1ILqSJxeJ
	nJAc19qo0kPfviey4PJHYBppOG92hpJr4fSrcJvZalJ/k7ILd9WK3tCUAq2aDWidbA3Abw
	XyHMAylUywUve7YTqwjyCbF5UjYgXCAdDxjcig+nF1hdlj77Nh7QHewQx8y8zA==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Ungerer <gerg@linux-m68k.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Martin Kaiser <martin@kaiser.cx>,
	Frank Li <Frank.Li@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
Date: Sat, 10 Oct 2026 10:15:40 +0200
Message-Id: <20261010081540.1572638-1-jeanmichel.hautbois@yoseli.org>
In-Reply-To: <9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org> <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org> <bd25e903-30fc-4905-986c-96d1b42e9f02@linux-m68k.org> <ddf0ab32-5b66-453e-b7aa-1722aeaf2aa0@yoseli.org> <9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: jeanmichel.hautbois@yoseli.org
X-GND-Score: -100
X-GND-Cause: dmFkZTFFgjXmLX45G3dprB7mBNjC39R3ZFdOmBlaHPfi/DKTpY93XscaCHp5tMBkCqA9LArRLUDoM01EVChTeeFfzAOttynoyn4me75u/AMeur57qlYoUt28xbQr2VCzXrUKal88bFbOX/hmdfoSkia+g6mFtqi4z6GrYMEXCOiDsV3FUVX8TYm7BBKI/RXSmTai2gy+ulBqwsEFBEddLFN4/92EvJILYI+Zo4Eyak/G5G4UazEN1k348y7oO3yYpRtX24mnqQSPJqenYmzqhSuK6YbTKJP0uTTlUkB2cDn9iFz/54twkKrzfLJ0FxYsvYGvnEunmDA/jK01KhIV1AWtZhBZI2V/e07WWs0y8f1WYwTAIXk1hDV6N+tWvITXJisqU2nGU02SemrmJIISIfL/Q9FDLSUbejgzG55Eq9flnptsFLvIuwTw8tWjZQFRnwOA0U4YbBPI/rWwDnGep2IFlESqwbUbxWtfEGjHpyhTUGlPjUD15YBeHwGKMd0jMVcAH0WY+awSWtAHaWILtKaOmNM58L2/SPAbPeai+41h5yR8j91BdARmLl6HC7gu4Ohx8UPgqVzajKmhN1ZqnuYYQIkDRaIofR/OtxMculnKPsx4r2bWYWh8o49LqT3ya7KV4NQq/WZ/wKI8jHZHMiWoyHEHTm0DRYbay1kKk5poGWHjHg
X-GND-State: clean

Herbert, Greg,

Gentle ping, and the delay is mostly mine: this sat on my own list for
months. The series has had all the acks it needs since December 2025,
but Greg would like your word before taking the arch half[1].

The two patches are independent at build time, so the simplest path is
the one Greg suggested himself[2]: 1/2 through crypto, 2/2 through
m68knommu. 2/2 is mostly arch code, but it also adds COLDFIRE to the
HW_RANDOM_IMX_RNGC dependency and a platform id_table to imx-rngc.c[3],
so it needs your ack for Greg to take it.

Both still apply with git am -3 on current mainline and on
m68knommu/for-next. Happy to send a rebased v5 instead, no rush.

[1] https://lore.kernel.org/all/9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com
[2] https://lore.kernel.org/all/bd25e903-30fc-4905-986c-96d1b42e9f02@linux-m68k.org
[3] https://lore.kernel.org/all/20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org

Thanks,
JM
