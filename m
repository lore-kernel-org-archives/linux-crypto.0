Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99660537F1
	for <linux-crypto@vger.kernel.org>; Mon, 20 May 2024 11:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203091; cv=none; b=qGrQkQ4Br8YZbfi8zbeo55lm1r9uUFLdcrFPYWxHX2a4MOM7o8tP3sThCMYhqPD/dqGnja/McEzyxeTMZ8mvnHAJtrSHms0sC2MmseX8/PG58ZiNOmFE19twMKA2rbNXXr0F1LOlugIR7ey/09NtfpPLjJqtiGgfuFHcmqwcQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203091; c=relaxed/simple;
	bh=OjkUpQlvnyBrQckstyE4kO7SMSQQRFHRTdBIHLwX3kY=;
	h=Date:Message-Id:From:Subject:To; b=a64fG/UUM2QZWJQmgtoUJ6O2YTN8U1Tus+JRXgW0Hmd8H/hrK2UAmZKyOhw2fgYplvZZPEdJPrsI93YkjvhOzNjGcIoP1xadx9xOOEUjcRrVuPSDMlMKkKO9QglfHMDcyRmZMBNZhtCYCrrVUg0dHpqPoPhpvHjwu/wewcTTXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s90os-0000vU-18;
	Mon, 20 May 2024 19:04:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 May 2024 19:04:43 +0800
Date: Mon, 20 May 2024 19:04:43 +0800
Message-Id: <cover.1716202860.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: acomp - Add interface to set parameters
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series adds an interface to set compression algorithm
parameters.  The third patch is only an example.  Each algorithm
could come up with its own distinct set of parameters and format
if necessary.

Herbert Xu (3):
  crypto: scomp - Add setparam interface
  crypto: acomp - Add setparam interface
  crypto: acomp - Add comp_params helpers

 crypto/acompress.c                  |  70 +++++++++++++++++--
 crypto/compress.h                   |   9 ++-
 crypto/scompress.c                  | 103 +++++++++++++++++++++++++++-
 include/crypto/acompress.h          |  41 ++++++++++-
 include/crypto/internal/acompress.h |   3 +
 include/crypto/internal/scompress.h |  37 ++++++++++
 6 files changed, 252 insertions(+), 11 deletions(-)

-- 
2.39.2

