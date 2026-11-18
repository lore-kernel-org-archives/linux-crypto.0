Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043613;
	b=XIHSWvTsNoRR2MDzJ10O+HHHYeCNr3XCj9lUTFEyPushqV/gEXgtJb5GlR0xicMMw8fB
	 3RqbgAZI1TlEzs2V5ogl2N5aPQx12Ki2umWReefshyh0Ssot/nhbhnXub6hd5mDPeZUuz
	 NLwSOTr6xCS7lWyq7DdjlhCXSipOy7hyTgGb4Zm8TOq0eKKZtLgg2dx7wtR3ctmYj/reE
	 Qc+WXljZqI7TnHfZJYjXJHIY02YFQYuwWquN6skO1BEsBXBp+lHvbFN0k+nj32JIpV2qP
	 TQcXtVgiDrrVEyVVbp6Q+8VlNSiX/zDvEig5BE+X7hIR2H3qROTBMNOilHXb2oCJvqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043613;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R4+mI6X91/rKykGDKfm0UwGbzYsTbGQ4Xd+QbJLz3Hs=;
	b=zcHEsatHple4BKxsSe3LBJcBbX6OG5qtxqhjDpJyHhgayy1nO16UGf3L5JBhIUZfgeg1
	 aoMdipSSw85s45d8FqvWrU3raUjjcjKlcgn6t8ekMOsuWbAOF80bcxYoqOyRyduPzA94L
	 SuWGhAe9YlpT9O3dmOJw7hxKtDmjxpZxbUY47hn2NDgCiIjHnGCMTNCnClUGxgJEcrmzK
	 h+4F2gjy+OBRl+I8gAW0/wUgB/7yTMMBCOrQ+CALdB1WrJWmt37Ytp2xiOZ9owi6SGEJN
	 xiZLKcYCubPgUSX4rgjtU+mmPlmVHCoS9wagp+nsQKlCi6uluBTWpdZKRE9VNaEEs5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Yb3RZ5Cs;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6344B606A325
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 23:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6344B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Yb3RZ5Cs
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 994AA3F32F
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 23:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795043610;
	bh=R4+mI6X91/rKykGDKfm0UwGbzYsTbGQ4Xd+QbJLz3Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=Yb3RZ5CsNeLDJz0BkBwPzCikh1e0L6kfO7BsHG397yxdfFc7KHkEVHo/E8TbzE+TW
	 Dsfiede9xsja5IMh1ph3rIShKBULdIaNgJ0WJcvQU+Mu+Dl4DEBxhdcOP1GnxQF8aV
	 WNyqVlrz5tUtAKWTlrKydMEcjbO4704JbZTOIZC0vGOGGceZrUSGIAOxoUF3ULT+IP
	 MH4ycoPKyfhObWPcMbIIqeRcykYHaJjEes0p7xLwFaSZH1cnziaswcQtkycjbL/AM5
	 Rm+HFSDa1UJghEEGAr2uvn9LKfTknt4AF1e31U7TVpwK/xpumM/C2eqfIJtYbKrldj
	 2pZqgPiKhZ8vuIjzUyyStnah8VoAVRItRVacWRuAiQudxggJXycVpm0ZYK/0POH6nQ
	 tb8NDVC78HQX7MUv4YbIy4iIhrod6akVF9SdrwM171diH+s+1oYtMcBIIem83DNEg4
	 DT1Kr/IU6I0kFRT/ydrh/jXbzqM+CvT2EthGWlDIXbCJiAoxcxRrioR7UgTGm4IHRq
	 G1Qu9nx4Gr0aVDZk5dApexdHUX2Yl49vzLVLVeZ1rhMHwaYd9gXAV2cT0adsix+iRR
	 o3zerlx/8sgrJLuPSMEwgPpM0iQJELieubHpDEPAjwzrhD0TAFHd6cza5aXjqdCHCW
	 FupR6VQtOuLNNqCsF0UBkTOA=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-381dc4b8f40so1820563eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 15:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795043609; x=1795648409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R4+mI6X91/rKykGDKfm0UwGbzYsTbGQ4Xd+QbJLz3Hs=;
        b=GnSMY6G5EulNvBoJrbzTkiixfYJ9I6cu8Amdl5ETC9nBRNwUXXBa2OwVV6GhaQ/5z0
         qxTZcW8RBFrWwezA5vx4ft7xiwIx+FD6+7X/TdiXp2MkGzy+lKrad8B6yf3+2g7eJfpm
         welzqYikgddKe0mC8RQTcT9X2Xrc5X+eIcZB1DOL2CgpHLxCCOy27/9EwtqRHAgXzoV1
         fT2arUK4qZD2JPDcJ0ucxzTKwu5gFd/K20ihNsB45+M6LI6sQl/bC/az4nZLnazN4Urq
         ULWAx8HaM3vj3tyrZ1ytSmF2oz+eyqMt5LNNUPalP3u92JdrIxfO6dGFSc8sHLvpxrD0
         FsDg==
X-Forwarded-Encrypted: i=1; AL+hErFXasuMB7/IbgKIw/IZKdnjPMIWtoS6/4hZpjDFIURl8la70uUB/nlakgxeEEApSzprgfIW4RmkpVOQqcs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+gcyJ5xBC/rRC/7VDtPQiYUG3zQj0VmOiZkBYNcUcZL9sLEEgp
	Jv2uhkaOdj8CczV4wbc/x/6rWTojDymALHQD5k1tdFH0So/IoTOvVeDa754CKhhNlsDLeg45M4s
	M3flyXnE1OBqtl9jVgdj/aKXXZoZdMImz0EKhLtLxNE362qqimdyOhOGk12OfT0ZCSKdYj7mtJf
	pHjmIjmw==
X-Gm-Gg: AZFdTZcS0puP2jrYSAHfI9xZCgrwWE7r5W4wiZaXXhD5x8LHwAMUUeE09Ptf07ZQROq
	suGD++k3EuFdZm0uR7QmeRJxYasGCmZtm1QbVs1i095CspUEQGCXkeVm3lXIAf5ISPQGEgj15n0
	1LzH9k3s/ViodASglODEIjEPIKepBGe3C3eAol+1BIALou+bx+dF5QRtUw3qtWfHgVeSFsrEvq+
	fjCBGG34Wa9+eisILt6qtHL9SYrPf/JVdQXuEt7WOF4EqV7jJDvL7eJm62ZSWgX8rKC13NQUrFi
	/mshq0nwzNh0I5MS1OIIIIpzYWwtI2ZHFPOZ6Rx9IIGpeeqqyfM1C2JwbgeJskBpT2w06f0UiN4
	SEWY6+tBlQR40SkyyTwWwt/QE1wmzjaWBYDWr7zdHotboTpWO5S1KWbz2+s8=
X-Received: by 2002:a05:693c:26c7:b0:36a:1452:8dad with SMTP id 5a478bee46e88-38280c2fde1mr3891057eec.20.1795043608438;
        Wed, 18 Nov 2026 15:13:28 -0800 (PST)
X-Received: by 2002:a05:693c:26c7:b0:36a:1452:8dad with SMTP id 5a478bee46e88-38280c2fde1mr3891022eec.20.1795043607843;
        Wed, 18 Nov 2026 15:13:27 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a6fe75b5sm10429718eec.15.2026.11.18.15.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 15:13:27 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: sahil.malhotra@oss.nxp.com
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	stephane.debusne@cynove.com
Subject: [PATCH v6 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Thu, 19 Nov 2026 10:13:17 +1100
Message-ID: <20261118231317.58876-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116180523.863575-1-sahil.malhotra@oss.nxp.com>
References: <20261116180523.863575-1-sahil.malhotra@oss.nxp.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sahil,

Thank you very much for reviewing the series across all the revisions,
and for re-confirming your Reviewed-by on both patches for v6.

I will not send a new revision just to add the tags; they can be picked
up when the series is applied. If a v7 becomes necessary for any other
reason, I will carry your Reviewed-by on both patches.

Kind regards,
Changwei
