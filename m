Received: from cvsmtppost106.wmail.worksmobile.com (cvsmtppost106.wmail.worksmobile.com [125.209.209.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EF839C659
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 15:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.209.209.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406341; cv=none; b=BrAxaKnbJsIa4uiw0RHcdLEWNRuXfxP5GziTdmQVWwEBM1M2c/YOsdZAlzBPBYH4iEODdfZcQOQrNI54No1yHsvcbrPyHha/G3fFyYQkEVuvoZj8r2S0C+Ksnbtr/4fpg9L/kohndywC6y4oj6D7vN7jn6FeY7kSHm2892gBkFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406341; c=relaxed/simple;
	bh=cRB+YP21zLERgxw3gZcoe17vzwJmYED9VXTbMsBcgUM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K6NvPIDxZ/WKG8wENahBPlPu0fY6SZSjVv5VLDoEFK0fjYnXRWl47YJ/LkgB2polwmY/29bkhkWkuF62Jq3xZJjO4EzKy8yFWZ+zBLwt9sxQv69CK6aYEuols50z1P1XNfXlP+xSA0E+nfNVzepcz33wHs9gnoC2xdOSuxxLZq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=korea.ac.kr; spf=pass smtp.mailfrom=korea.ac.kr; dkim=pass (2048-bit key) header.d=worksmobile.com header.i=@worksmobile.com header.b=XOrTWlLH; dkim=pass (1024-bit key) header.d=korea.ac.kr header.i=@korea.ac.kr header.b=U9NGH/t9; arc=none smtp.client-ip=125.209.209.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=worksmobile.com header.i=@worksmobile.com header.b="XOrTWlLH";
	dkim=pass (1024-bit key) header.d=korea.ac.kr header.i=@korea.ac.kr header.b="U9NGH/t9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=worksmobile.com;
	s=s20171120; t=1768405122;
	bh=cRB+YP21zLERgxw3gZcoe17vzwJmYED9VXTbMsBcgUM=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=XOrTWlLHX8Kp0L+2UFdY1hob9FQrI2rjB10clNmjxb7VM+HK/+LzINPxgPeKcP6f1
	 d9kwLB/v1kUm9GBgv814K/cF7USr4TIYYRH7P3AmNU5PhTLwqIQxPV4IQrM7UZ54id
	 uA+LZNgvB6/NIfM6VxJ6JGHcgpDEw2VO/msjW1JsXftufGIy7sXD8qhn9hK7dtpjQ4
	 ETkEvtei6XkjSktdPT1eCNmMI9NGPYx4vHlihu+MkWGTvc0aHY6IEEBViOTMgiiPJd
	 gJ8xt0Xec+c+7V8HnYv7uyH4BpBFoLeVzN24d+FJ55yyX0QnnljP6dOxpD5nqCuNZw
	 TYl52kgI/ifLQ==
Received: from cvsendbo006.wmail ([10.112.11.111])
  by cvsmtppost106.wmail.worksmobile.com with ESMTP id QX5-BtuSQiS8tMpQdB0n9g
  for <linux-crypto@vger.kernel.org>;
  Wed, 14 Jan 2026 15:38:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=korea.ac.kr;
	s=naverworks; t=1768405122;
	bh=cRB+YP21zLERgxw3gZcoe17vzwJmYED9VXTbMsBcgUM=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=U9NGH/t9L0jUmYpeBYXKdY1RVwhXTd7pEPl7dRNT6JwBuymlY2zwKJe1hK1kfqfg2
	 0Q70LmNtAPr4vb1lu10NT8P8sNSPGaKzN1tVaQy6dTnN29wJC6k/ng6XKvjl64b636
	 Skpo7nC8gjXjLopIr2xkxBEAi7yolItXKCxJxbBA=
X-Session-ID: AMaK6SBuTvm98wit4hQMlg
X-Works-Send-Opt: LlnwjAJYjHmXFoEXKBmmaAErKqpYjHmm
X-Works-Smtp-Source: gZKXKq2rFqJZ+HmwKobZ+6E=
Received: from s2lab05.. ([163.152.163.130])
  by jvnsmtp402.gwmail.worksmobile.com with ESMTP id AMaK6SBuTvm98wit4hQMlg
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 14 Jan 2026 15:38:41 -0000
From: Jang Ingyu <ingyujang25@korea.ac.kr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ingyu Jang <ingyujang25@korea.ac.kr>
Subject: [Question] Redundant ternary operators in nhpoly1305/sha256 digest functions?
Date: Thu, 15 Jan 2026 00:38:39 +0900
Message-Id: <20260114153839.3649359-1-ingyujang25@korea.ac.kr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ingyu Jang <ingyujang25@korea.ac.kr>

Hi,

I noticed that in arch/x86/crypto/, several digest functions use
the ternary operator (?:) to chain function calls:

In nhpoly1305-avx2-glue.c and nhpoly1305-sse2-glue.c:

  return crypto_nhpoly1305_init(desc) ?:
         nhpoly1305_xxx_update(desc, src, srclen) ?:
         crypto_nhpoly1305_final(desc, out);

In sha256_ssse3_glue.c (sha256_ssse3_digest, sha256_avx_digest,
sha256_avx2_digest, sha256_ni_digest):

  return sha256_base_init(desc) ?:
         sha256_xxx_finup(desc, data, len, out);

However, all the functions being checked always return 0:
  - crypto_nhpoly1305_init() always returns 0
  - nhpoly1305_xxx_update() always returns 0
  - crypto_nhpoly1305_final() always returns 0
  - sha256_base_init() always returns 0

This makes the short-circuit evaluation of ?: unnecessary.

Is this intentional defensive coding for potential future changes,
or could this be cleaned up?

Thanks,
Ingyu Jang
