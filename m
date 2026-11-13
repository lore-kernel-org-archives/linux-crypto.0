Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794610714;
	b=zwhlFxkfcGfxon7lUuOR9z3t8mSP/ecf9wZir2SyBkCNmGizQuXuT5Bp+lu1DJuTQr10
	 k6UvQYEPZCf7FwHc4rXlZ1NJozFh5K/z2NvzH6VPNqGBOv2Dtkw8+5mtArPLK1dA/Bowc
	 BxSkmFi48xQKqrWIkkcvtRvBzl8VBaJGA567Nf3F3FsdzfFtsfiKOWy8ArlPXvkxk8Sx1
	 UqzHs+6wzIw2opE5iRTDoAIW6Xk+WwmKcnSv2ggPY6mm90bTm2LvYFyVE3fDMIDCqt4tG
	 z5dwxw78SLWbHl3js2sOvTQun2nGkHtrOPLap0Z3EiTGBQzdkGQ+bhsg8BJA0upbdqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794610714;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p9AJLkeNoge+nOrroi09CUXkurgmO09wLDwnTiHFkBg=;
	b=Q0Tvsk+mwZJUX26Ss805OsIkQZN5DwVtK5PdZX1iHS7nsGSsM8XdixB0RHwjPevOUC17
	 LuGQ7TSrA1iR11fIYZ9AIYQpzO3EEghW2W535s8D2G4FLB0G2sn8anQY859EbVyDC3fH4
	 NptBvFGIyE43ZxHWJN3e7e512VxKhp4/p2WbWW+LY4Q8UUjMDEvF9nZjmMWCLjcAKV1k/
	 UbedmyMShGrpjdba9YuyR2bW/vFB8/YoFzEi3MAIAwQfWhj/EoKQMO3njLXF8/QHaElUk
	 tDhptwPLPjMFCV0rfjCUzb821sSq1T5Oy+P7r8/L4gVVOKOTMhwfzgQH8S8msSVRG5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Kqzf5xvz;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CACA606A330
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 22:58:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CACA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Kqzf5xvz
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B07D94013A
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794610711;
	bh=p9AJLkeNoge+nOrroi09CUXkurgmO09wLDwnTiHFkBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=Kqzf5xvzNkM/dH4jvATDApWLHO5MIrZVsyj5UIkwqe5375lGO7wD4igKnmQ+eNM6f
	 9BtvprVM1vxNUSx/otdnYbd7wdMSS6CamUM/XAfQCqvTyMu24ymdnLsdkrIC9gQxDe
	 EUMgzzr4ulUsIP9MMTVMT7gTMaKojrIz4MHirgNYBTnYAEo6J/uygHDY2WYCZDutAW
	 jAxQK0tMRuaV4GqFxpP0XZyU6FjsoupZXqSINx+3PHW8o2Y4Di9n7ViDYprz06DeM+
	 vVRHnrPYr8BY/5cqTRd/INBFiEG1bxb4q9R2e6G+EtE+iiSQRVJ0HhAFKG6Lro3G8x
	 EGXMG+qUDkyXAFEW6RokKM61eDx3t/4R3Sz+fcZRqoo0+cfrylp+T7km1L81XH3UfS
	 Yk03FMSAFzi16Cj+H0Y5S8eEGqhzsFBYBvwHqRq3iWcUa7zYjRb98WjDg3p37nDCkB
	 O14O3eO4U0rnNsL4jQ9xTRqqmouYpuALi/e5awWjJHbv8FxEaah2qQ2W17wNntBqF4
	 R8ME7R/m36I1WtP5IOQ6nm1GXB8RCOzVMgjr+jyXDoPlB2+A0UxKuSa8iEZv/S4WKB
	 ewB/4yCafTUxH/we0ywRO62fK7PSkPBgb9vY003jNEZPUSAT5305mlrWOX68mqrrs5
	 QgK9xUM713WgXAqH1Lc++mNI=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so2004244eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 14:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794610708; x=1795215508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p9AJLkeNoge+nOrroi09CUXkurgmO09wLDwnTiHFkBg=;
        b=uojiQ29LtFTNgO5HV9zrCWoXWG4m4HPS+MQpZq9TJWPB95PzPkR31vJC0PDnWonPsG
         yunsVCBz4cNYEx4Xup9PV9dw+YCejmOk3+Gc9Hqqk5EICLvwu4oVKRdHBIsQqGuTsdlw
         mrrqsQUlBysP6L7qQcVDRF1QIWV9S1GwWKuPAWWJNqcityj16ZzQNS37QRPSg7qz0a/L
         mjnr0xrhkm76/8X23fdpJWICMu007XPfJxxzD/33wIyRh5smkrvQ6sL7C32K1XKrDBCy
         9uuENXblR+qPpm0hvXoTNyzjUPM9iqInW+NuAzp60IMjwznSTGr1//cM4xYEn1HTzv6x
         Bh6w==
X-Forwarded-Encrypted: i=1; AL+hErHiThQrVEn7TWaH5hzkCT42jGsU2dTClITPthKUXSD+tzWq4+Up+H5zGqSDAgWgh4zzqSLWZcNgXvhkMKA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+rUgCMg1nCzvxC63KiUCt/r0IDYtv0iLedRXLlSQ0TsAvQR2+d
	of3EpLdO9skW+9RE94dWjHnI7t8iH8hLrj39MjjFakmpOlk07TfUiE9A4bkmKwkCeuzdL7lGtb5
	6Btlo6h1t06lE+kr6T84oLlo4hYHHVHSPY10+a8LFkyAKE4S80fLUgBXS4GUEXlRQt16fihLAb9
	qYJoP0fQ==
X-Gm-Gg: AYBFou3Le0R/5X6lcZuYJmaJDPjHbTi138spX/q63IaxkAMW5rC4HFByiCi6TfcnUjv
	7j9Yn9rwGTTWtqbokWkAcHJYXjvqdKIZHosy6CZcZJFCabU48ENzNjJB8kBGUkKQleTdkgErxsk
	QOFJXaDmzlwO6Uz07jBoq7qJeSaWP55+9KZnwt/AbjqIbKr+zV4OdvZO7tf5WjpvH1P2YZduQ7R
	EpyEoi8Ldq9eeaCWlSAKX4ceQMqxobmYPejDMM1tJLssYInadd+IQ1D90D74DvLz67K3w8bmNFf
	eCpU7+Wusfp80gTHHwvQNcZkCl5pBEDKIesBSctlTiFtrP3MQ4s8aUC3xBre6mpoWxkPItS7kn6
	r9EEnk+/EuiKAp0qPaku1W/8VkQKYL3ULhtH9etOqBs3Di2Cix/RzuWJN/0c=
X-Received: by 2002:a05:693c:8110:b0:377:e99a:22a5 with SMTP id 5a478bee46e88-37966a5ceefmr3173288eec.6.1794610708515;
        Fri, 13 Nov 2026 14:58:28 -0800 (PST)
X-Received: by 2002:a05:693c:8110:b0:377:e99a:22a5 with SMTP id 5a478bee46e88-37966a5ceefmr3173271eec.6.1794610707907;
        Fri, 13 Nov 2026 14:58:27 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955ffcbc9sm15721423eec.18.2026.11.13.14.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:58:27 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: jeffbarnes@linux.microsoft.com
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	horia.geanta@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com
Subject: Re: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Sat, 14 Nov 2026 09:58:21 +1100
Message-ID: <20261113225821.32339-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4155D08C-95D5-4636-85A0-709911E2CB2F@getmailspring.com>
References: <4155D08C-95D5-4636-85A0-709911E2CB2F@getmailspring.com>
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

Hi Jeff,

Yes. I agree with that.
Thank you very much.

Kind regards,
Changwei
