Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46941A2872;
	Sat,  3 May 2025 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746303705; cv=none; b=W5qV8fS868QMZTyBwvvqw/jDhyWyMtvoI4ByfUtfW4jCkEGVKTk55oMhNMuEmVsgwbWbE+v9k7i4cOLKyqxrhPn0nwfkiRiYvu80KFADoa0V3N5T3meGnEKhips8iPp3VQl3GjuDa0DySQwc301IAS3NChQuxtZYJrGbxE9wxzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746303705; c=relaxed/simple;
	bh=HuMMM7E6HNmGShKJs84B+1ZDHQP+L+5fAfMDRF4u5rw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZYl/RtdVw/gF9TAR/1zNRpix5AgRsosCXhqPQgHkGoqZFUIgKXHEM1SV6XNOC/lPPHFZYFL+RWqFk09jr9JPh+0JtJ7ykqrBsCoEeBKcCG2dzOoJ+pCQRzEHVlvEu5st32vRHZespuIjyII7OF/IpcsF0TPBTrS15a49dZgCn0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=p1VAJrTW; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="p1VAJrTW"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4ZqfMJ13LFz9sDw;
	Sat,  3 May 2025 22:21:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1746303692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T8aqv4H8iw3wq2lI9QxGOigEUEs/ugIKqLo3dwZztJI=;
	b=p1VAJrTW2H+ZkOOaw2Kh/flAfvuB5mV89mJIADH5zyR8kByZY2xnn89pihmUFvLfmo0X0f
	Aa0CS+SNT+8FA6YS6t+XJv2qee/QY6NUR1I4lgvOsopJhY4B8vzTb767ZueJHWb6Kr9I9p
	2Co6AjcQn448K3nE5k0nP5+7S3mXXpDxIzlo8gSjKLAFuQvR+3QOVmeitOIl87x8yAENrK
	zwl9S6/f4JYXl+naAzUd94ZRMZw/AaY9KYlx3qGZ5n7rL3PTje5yfk0vx7fKJaTpdtyiI1
	WE2r15E2ZdA/Kl2tIV7atPBQyEC7tIB9NNp3H5fBVy4twUfOt8PQWLPuPbiWWg==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Subject: [PATCH 0/2] crypto: hisilicon/qm - memory allocation cleanups
Date: Sat, 03 May 2025 16:21:26 -0400
Message-Id: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMZ6FmgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDUwNj3QygkpzM5Py8+MJcXfMkUwvDRMskY3NLSyWgloKi1LTMCrBx0bG
 1tQD/3Jn1XgAAAA==
X-Change-ID: 20250503-hisilicon_qm-7b581a9b3799
To: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, 
 Ethan Carter Edwards <ethan@ethancedwards.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=702;
 i=ethan@ethancedwards.com; h=from:subject:message-id;
 bh=HuMMM7E6HNmGShKJs84B+1ZDHQP+L+5fAfMDRF4u5rw=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0o0bkp2QXk4ekFKWGJEOXFoNThlVGp6e
 GhQcXlVeFpJaFZIZGRkUDhQbjR3TGw0Ti9XdHhJa1ZzM28rN3k4ClBQTG1tMmQzL0crdmovNDYr
 ZEtIamxJV0JqRXVCbGt4UlpiL09jcHBEelZuS096ODY5SUVNNGVWQ1dRSUF4ZW4KQUV4a2lSMGp
 ReGViVVZ2TVkrOW56QjhaM0pxNmVENVhpYzV0eXM3Nll5d1Y3Yk4xM3p2ajU0d01zdzMzU2UrLw
 prZFUxeWZYUkh0ZnlKajh2dnpQRzdqOWF0RitvaWI0ejJ5VEVEQUN4TlUzVgo9WjRXVgotLS0tL
 UVORCBQR1AgTUVTU0FHRS0tLS0tCg==
X-Developer-Key: i=ethan@ethancedwards.com; a=openpgp;
 fpr=2E51F61839D1FA947A7300C234C04305D581DBFE
X-Rspamd-Queue-Id: 4ZqfMJ13LFz9sDw

This series contains two small cleanups to improve code quality and
readability. One removes a sizeof(char) piece of code (because it
evaluates to 1 anyways) and one switches to the helper function
devm_kcalloc.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
Ethan Carter Edwards (2):
      crypto: hisilicon/qm - remove sizeof(char)
      crypto: hisilicon/qm - replace devm_kzalloc with devm_kcalloc

 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---
base-commit: 37ff6e9a2ce321b7932d3987701757fb4d87b0e6
change-id: 20250503-hisilicon_qm-7b581a9b3799

Best regards,
-- 
Ethan Carter Edwards <ethan@ethancedwards.com>

