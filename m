Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173659;
	b=fmrHz4CdlIv6szWOvC3m0HkZMQz6hjBn4wVnTIzsOi6QeLX46H3ojLSOquLwUSKQDapZ
	 kBR+2PYCVBxUcCYAUGow6v9zj66uwFzmRrRoK5UG0ee8hZ+w1X3EVQG866RLU+Ep7S6v3
	 EXn1JDSkjehgabBoANAz7JQD/dmTj+7vOTnN8zTKlzwuXhsxkFFNleNPX6Z0xlcMcXuIZ
	 1YIYcqm++htqjMgMYG0+I3KsELpb1U5AAy7QCm30/i9vRuisc3DzH+iHv+uLrxb61lmC0
	 KkGFrGHyy/oEZQADpjT+aCy5vd+9LkCgyKnP2L9sDTnyQZ6xSR51yiY3i7ZV8Ssms+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173659;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=t3IK+6RZWNtPak6+wEGWEUH2Q0VnpjhDdVRL8yHWQZQ=;
	b=kU4YodDp8X1RN1uwGm+yanS/YJpIiWwFiCPQbI0HF3raUD1DWKbylEWA2i2JFrOo91dY
	 lzRuF/Qzir/GXf5vdyRdm+O9rRrwDmAL64uabc3RC7Agq8cLXWwbY0Zek5OUx7E3ImW2n
	 4MD8fnXjaT/gFQFwQ5+1J8yA6ZQdohg7f0TZHPmHwrCW/sOtvG/ZJbvxT44cUh1hOaGU7
	 BKMgwBpAmD2SWK5tfpKodPRQEh6N6h+BLAI4GTq2/J0ifZrT5BV2QHFlS+3ji6NRSzgFV
	 J7ZC5UJYNnVCVEy2MqDrKSqwpwA6m55AM4qspF52o2GqEUw2ZiGexM+JKRbJYGKDjIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b="T9fn/AeZ";
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B34606A339
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:20:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34B34606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=T9fn/AeZ
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B6E073F994
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795173656;
	bh=t3IK+6RZWNtPak6+wEGWEUH2Q0VnpjhDdVRL8yHWQZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=T9fn/AeZtTue6NcjDE7lHbAtWL5yyP6flbvBTqTK/SbUyHmn5x4YEkIsdeS0wIA6G
	 lom9eaOUPfwj8hU4w0KLXwBX2+t4aAgqboOKn3af9RJUsG0YsGrVbYN/9A3vIA8bOe
	 LD1+/ULYNbvVE3Wi8af6M24AdG4b919tYiF5B5uP73doHW/Qdmy/3mp78MVJiZ2dLb
	 Qsj9Ws8dUod3rb8/4OXFedhQhwm8Kh3GLEbxHzc0mJHIISUUKkkpUsfHVgptMy3Z+r
	 cwJOfnp417ueFyeUE25hQMVMReOerwuuIqv2Ec6Sfsj8tybhc3ElIXiYC9fxnePhcB
	 UMlrUrVp8gQxS7b/nYexZDCRiLCzzJ43/wiyWayV4V4MPgbwHEbGPbC3kgf7MSKfG4
	 RYenR9GbWS/hqEFWWXdCSCMp5czw5Su6lBoJxOVB/n/b7MRB5jpz9pvTGxeEyLjjr1
	 JXqcDgpejO6xLU1qr/dUdsCh0D3tpQHg5QAjLpylLMUIHki+l/D5BGK0tgLmrOlmlX
	 CCo80dsZNJr+Upxk7ur3bGz2elxYc3/SKH3HcvU6bzMXhthWnU4tRbD20JPrYV2HkK
	 5VFJnPjWdpAX7bIpVyJToWy+votpdqirKWZ9OaMjHKI1jDxXLBlav+4aJkirSWJEcq
	 ozYv86hlrO6IyNk0/XdXuY44=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b18165dc53so1254832a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 03:20:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173655; x=1795778455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t3IK+6RZWNtPak6+wEGWEUH2Q0VnpjhDdVRL8yHWQZQ=;
        b=iYP5eIHCT67hQNuwoTyxRb/by1t/MpXlDcKmxvzZeByojXfLpsF2HB0gJM4qcOXSN2
         olvyviqHdd7CzhWe7Ynyl1nLDmhqsZ+YES2u0teodOvrCba0Ao7apozgwYvRKDTyt4S1
         yaDiQ0sRVxzvTljQHmgDDGSdBtD6rfXvllzR0MBK9tgUOsONOSoh7ZEYtJeTKvJTyfsk
         KL5ujFa3U/gJ7LXKf44+WcNpDUnElysYNL0rPefM7BNHMXoQtymzF7hmfZzCyFeWY/jl
         XdaGoOA3OZTCuLtK62L2PSKUPLnI3TPsHsbbuaMa5V++MzJr43xyNzW2W33SX8z8jb57
         uEeQ==
X-Forwarded-Encrypted: i=1; AL+hErEloIbhAbW3zWKyEDEn6DeHZ+4FfaUPklxPAL5skdvGNHrD7ly3ZsEd1L1JDnBY+qYgdCBSEdAo0lpEnPY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8vbfO5TzLRUECuLPPjpgMfsDZ6Npfmj1cqRoAs7fs9QDMRJKti
	9gMjRWB3wG2TrL9cKVl0iPnM43ar+in+8hkc+4bJLj3IMP5Xdq8eQ/vo9k5ioTK5esdLPxYXFpD
	6o8+WRuPnQ7Hlb6dZU0N/PP9zvT9G6ES8zyhk1dCP3Xc3PWAtKv0NkkhKjlFIbrIX6sCiBbbhAS
	IcPkkIaQ==
X-Gm-Gg: AZFdTZfEutXx8i6nDBX/x1yYjTJ8waq3dxpvqb0d8U6Q92JvqbJK5SYlEKBe3nVRVJG
	u1LJqKjIM5TSwk/CIDdVCZxzk3VCe54hH1o7w45zcrMEenaNriK1hS4s8T/c3tV5FrC4Oj0xJUd
	JO6+b7O/GhZ29TW0i/DbUfpgWixT00Sh/4OU3IHjBLwLwmGU6HJ8Jgs2FQTRJ7LlVji0oU/m+iW
	GE1VeOJT8Udi3vXQGhIG7sCQ2FKZjy4BUAoBNYUfE8MOOOLzYPUi4F9X/g/9YvsssHEJiyzl0pr
	0eHViHCWrTlvnP8heJmslEHESMFHzVvtc4mJcGHLsM42QeGIkHc2t86Y3Hwt0PR7b3KjzyIAX7L
	jKF4Ym1XI62CYVDtDjTyBDlO+40ujcN+QW2uNaWDe0jXyqx7yVA/1YHR204k=
X-Received: by 2002:a17:90b:4d10:b0:3b3:c4dd:5437 with SMTP id 98e67ed59e1d1-3b41c852d1dmr2916571a91.5.1795173655165;
        Fri, 20 Nov 2026 03:20:55 -0800 (PST)
X-Received: by 2002:a17:90b:4d10:b0:3b3:c4dd:5437 with SMTP id 98e67ed59e1d1-3b41c852d1dmr2916533a91.5.1795173654661;
        Fri, 20 Nov 2026 03:20:54 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40285cf3fsm3994767a91.4.2026.11.20.03.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:20:54 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	stephane.debusne@cynove.com
Subject: [PATCH v6 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Fri, 20 Nov 2026 22:20:44 +1100
Message-ID: <20261120112044.1174236-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awAS_kKAVkL2uWKT@gondor.apana.org.au>
References: <awAS_kKAVkL2uWKT@gondor.apana.org.au>
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

Hi Herbert,

Thank you very much for your reviews across these versions, and for
pointing out the apply failure. v6 no longer applied after the upstream
caam_rsa_set_priv_key_form() changes (a91d9346a70b, 828c3b265b6d).

I have rebased the series onto the current tree and resubmitted as v7:

https://lore.kernel.org/linux-crypto/20261120110525.1170175-1-changwei.zou@canonical.com/

It is a rebase-only respin (no code changes); it also drops the
non-standard "Assisted-by:" trailer and carries Sahil Malhotra's
Reviewed-by on both patches.

Kind regards,
Changwei

