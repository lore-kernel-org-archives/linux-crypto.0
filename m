Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5531637DE99;
	Fri,  7 Aug 2026 12:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105642; cv=none; b=k2YyWUK8IR0226Yr/hhu7rbPcEI1HYOXnfC/b+OMyEUmU3dt35pDRvk8QLc7hyfVRxzDngUVuovOIYLC6VblZZi+KEP/5Q4+UAr3sosLc9lQ8+fmLDgIYc4FtmcTM4zaDEQ/O9T1fQCaMe8GufUqr3yknNadrv5rDp7I1x5Dmww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105642; c=relaxed/simple;
	bh=WIxC+vKmjg76C+aQcMKORHky3ujecAQvgIOy1IMPz4s=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=X2J2ZwtKL6nlbFxYSNhftiVKfEa7b915R+KrAMy7uGgnySSg5pKlE5Fd1xZslLJLBvcEhEgRQOr50irYMDwhuWIqpGyWhCE/sVuOktz8sO0QpkxMazKp+2a/g1Tbs88g9tAyy+wZKVY+N7eSC4beMcrDAWsnSb1AOdSFv7YYUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=S7itvOPy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=INtMIaV3; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="S7itvOPy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="INtMIaV3"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AED2614000BD;
	Fri,  7 Aug 2026 08:27:03 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 07 Aug 2026 08:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1786105622;
	 x=1786192022; bh=uhAGSaYFzl9r/Gnf/PXrh2wfAeFzZ54cEK24IBjNT2c=; b=
	S7itvOPyFIvGmazaOG6snqDU+7RUee6mCaapufL6wDWryvtf/FrBpM0hdFQjF2qQ
	7jOHjiG/k2NW/rwG9Psukp9DhbDS64v642uBxnd7X4BZqBC2kgYO9NPcFisnjWQm
	rlgQoMjGjm42CyLcgHIDyT6sMG0z4j96zFzrMj4lMZs9b/TI9/YGd0MAR/cyv4Ro
	o2WQ99565xKXI+v7u6Tew2svWNXJYqO7nGOE4Xz8X51Q4lraLfeIlYOKsim9lLLr
	iygQdZ9kl66YIy7pPPnCEdv4GGlIRLQEEucD0J+zPB3TMIypWZieV7Y/TShdkVmz
	6V80/I47rR5jleNDc3syMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786105622; x=
	1786192022; bh=uhAGSaYFzl9r/Gnf/PXrh2wfAeFzZ54cEK24IBjNT2c=; b=I
	NtMIaV3v60CwfCwbqx5JKjW20WF89d3IncWztGHKDcFmhXgz943ML8ceIyeb6+DF
	tNUyt/Lpon7DRT5X6p+bJAcCkqIzt0f/HELM+MGglMIjw3vYl/2qWJeRC/8lTJVF
	6yyN2BV38z4qTkPBzoYzqrwcuU8ynHKFknBfYRq6FRv1YU7TvMhJcszTvP2NDCMn
	BnWjyaWvX61DZur1hBE6SlALFc9jTK5Pw5SgyHsFs8Fusl9uvHoF9y/CQjMRR7FJ
	ToJrVuZtwHTJ4msc3KCsdYCQWveO3aH5ZUwlpzjUF4Pkz/9ZLvn05d0DBc+6NKSD
	YUporlz0HTuQP77C0tQHw==
X-ME-Sender: <xms:Dc91as1-cbd-2reN2yk59eCxu_RMCuvBEkVsjqjEltZavbekihUAwA>
    <xme:Dc91ah7_yZk8eVmMNT42VKe9veRDTceUWOdikg3s6awBIsZqpYoQdwhUpetVJVg-j
    Up6Cqsvl_Lk_WRo5tWExDE6Wy03955LvrcAsuMRMK7maD1c9TS4D20>
X-ME-Proxy-Cause: dmFkZTGhGRORpDZ+OoWKb2tCiz2+79gJ4hQAdOsSkwXvfq2eg39t6mgGGGFqIk0XyzvUPT
    ytaigb/isA+XLiIspmRjlKglQ/mcENWXHRuf4bnwNa4JaTZQQSE//bAesZEcGmM+3Bdkoy
    C45nJnTbBTee7sNFJdwtd8aH4AkK5wQ/dGsKjqHXHsFnRwvorExjzNjU/7yGIj9oVRL54i
    XxwU+BQZUx64GSA7p71+hO02pGCcih57FMktMxvYm/4zO6Lfv+sHgNxEw4qQmFsa0cYFUn
    ZpBZW/27ZP1Tw0mBxGrYcuCOjD/WESKCdS4y1ONnyoqikUxQycz9mwOZmRVdFoOB3RI6e8
    WPmwnDITPmBygaoyAs0YuwinKgHQJSE3t37kcbV8OB3uTguYICCiRzuxR/fHGQL+jfggfz
    5JJqD4uIAf2WHyRbIpyQC6P1iDk2gm87F4JdRdAzRWQx21bJIWlnucdMJzn/q81gewe2L2
    qgafy8K7fEm6S+5SjIa7rAM4BNBdEttyPBOzmn6E+NDp6RjEcnn5LkbGG4j4EoGnWmIX8N
    8QGajDu67JDftWWXs4yf5yhtCmy6+SatK5LnY2TaH6gpPuwp03NiaBEIhoLhEvAGjZ33md
    uzSFZLYmkKLX0kH8iSS0dvAuW04qaAM0yF1rGxUmSRydB1DzXYY0Tu31D+jA
X-ME-Proxy: <xmx:EM91auvru_YTtzn-X7ypRBtovRsyleX9rWO3edqJuTAsmfxoF4Hw-Q>
    <xmx:EM91auJtQk06CykE2S-l1DttvCNNDN7BPeWA0sfw6ihwENh72xzKng>
    <xmx:EM91agaIGekyB6dp1fM2RQ4HWkpjtgeHz8UTLs7641_t8w27wwj5rQ>
    <xmx:EM91akLqxGYg2vbUAbRLZrAp86261NgEpPWt3uA61y2jdhcfKdhWSQ>
    <xmx:Fs91api7BVM2zRQYSVTbqnW1nXpPNEAJQR6u11fss_1m4jE1MZoIZVO2>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 39FA332A0066; Fri,  7 Aug 2026 08:26:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALxQobv4MiGF
Date: Fri, 07 Aug 2026 14:26:12 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: pzalewski@thegoodpenguin.co.uk, "Clemens Ladisch" <clemens@ladisch.de>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Mattia Dongili" <malattia@linux.it>, "Weili Qian" <qianweili@huawei.com>,
 "Olivia Mackall" <olivia@selenic.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Corey Minyard" <corey@minyard.net>, "Peter Huewe" <peterhuewe@gmx.de>,
 "Jarkko Sakkinen" <jarkko@kernel.org>, "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
 linux-integrity@vger.kernel.org
Message-Id: <60e25773-b3c6-4aae-a687-92e1ab3b141e@app.fastmail.com>
In-Reply-To: <20260807-acpi-char-v1-1-742c450254dd@thegoodpenguin.co.uk>
References: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
 <20260807-acpi-char-v1-1-742c450254dd@thegoodpenguin.co.uk>
Subject: Re: [PATCH 1/4] char: use named initializers for acpi_device_id
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Aug 7, 2026, at 13:26, Pawel Zalewski via B4 Relay wrote:
> From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
>
> Use a named initializer for the acpi_device_id fields which
> makes the code more readable and consistent with how lists
> are initialized in the rest of the kernel code base. Also
> drop explicitly setting fields to 0 where it is redundant.
>
> While we are at it - unify the list terminator to have
> a single space between the brackets and no trailing
> comma.
>
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>

I don't think this is the right approach: I see around 1500 instances
of acpi_device_id data with plain initializers and only about 50
with named ones.  Converting all of them seems like a lot of
extra work, and I'm fairly sure you can just change the 
driver_data to an anonymous union without this.

    Arnd
