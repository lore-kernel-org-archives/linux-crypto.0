Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3030E1C07DF;
	Tue, 15 Oct 2024 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997889; cv=none; b=YfCrEJacrOrIHQQ6WkhcG3RwfftYGQJaeJOnmwmlAoBjFIsOOVyxLf5vBPKc1ncUywwboSbAZbp8gGvIYonUX015rdh3yL0erqs75ZOzlIAAhAn32vLKyvQ9z0HYgm64hhNAcnp7HrXEetRpbc7ciKa56WJAueOKoNdJfju8c8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997889; c=relaxed/simple;
	bh=6DubvOfcNitNNbFc4/CgkMkTSuW14iGdJHkB/Kq4p0U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OcuI1LW+oSEGT33Iu1QKFthYWlHI4moyMn0nguqob2JG0YnOLhTBYhk7CAmCU4WDtqlIVQ9k4Mx/3Pa0vo69gsrm/gjTm401Hogi4bRX4/OR5/Jga3cFK9MmJd7vIfNRtFMLK3EUcviIJyRw0Qu2eQ1Ccbuo+eSh7q43cDzdClc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BzdAt1J7; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BzdAt1J7"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-37d447de11dso3883302f8f.1;
        Tue, 15 Oct 2024 06:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728997884; x=1729602684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+1IE6vo5EI0G+9qqkm/qKlmdaFnB9SlCUS7LfmzYM5M=;
        b=BzdAt1J7iEF2fUEizcyFJt+udH8eMoxVwTpVXColip1YsoYF3gWKGQ3MK6o5189JGi
         /HmqLjUqmLHxyXr8yHfg4maBHXQx4b/qywTwKF+RfDgzeCbMOAZxKRB6Or9SSZioJOPy
         PB4MsZ1UdQIBeGn5EKZnnN82XRkt1O+uvjuGF2Lu0XUykNVbkp74qC5MM2QoE4ft4sdD
         oKIo8Ak87U+SrWJRGh8A+P4pjpFAB9t/WjytC97hER9La4xiNxHzpKv5HWyvISkOBxaI
         CVg6jXhCX+0T+gaBQJZaambhJ0JqXDxE4nkA4LyubkKFWrcJvFi9XUxitfgZ+k9zWtYW
         EaKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728997884; x=1729602684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+1IE6vo5EI0G+9qqkm/qKlmdaFnB9SlCUS7LfmzYM5M=;
        b=R1EHm4UATOdj0qz0NkniWjTWH/mEhu+X32C9B9AyhXtE3A6y4PAzO8+JGZYv4IseGD
         Y23vnAGi7ykn/jcEigAnuotDr5+elVy+g6YBrAXS1WObT64uCtLkjvGBItrrdD1A1+YD
         Ahw2CmbPLWH/nGKyX7gnMcMf+iKLr6uMDlERKP3QzvdlFnKPXW7/4q2EpUBjYcNQdUtl
         lVDLmiHalbv6Ki2mu2OTIAZVbuYc49/x0x1mSlbGJffF6J9nKoMqO0f3Xr2HyxkZPqU3
         nPwONLI1IlM9NSI7J5uBkcK8wd+bpxMmqR1T/qvnUL+6VdZC0n7jXMvimnCxONAIQFBX
         acQg==
X-Forwarded-Encrypted: i=1; AJvYcCVB+6p08wnYFw7tLZOCzTuqSWOuB5BlKS/KwLwTNMxHnQTkM/RhdrAsyU4sbIpQz4RrwiHXD7JbNHUZRXc=@vger.kernel.org, AJvYcCWJInoTamc16vKuZtgWFYHZjnDwt6YT3LDanHb4nflRSzQ2q8T90pnSA7+gPxDkNvV2rwe5yEWFW3nulUd2@vger.kernel.org, AJvYcCXcgTaaEV6CI66e/7qpSSU6TcMHDwYLT+au9uA0vDSs0RZjGjOhSs+PzjyC9oASAAhFz530qNvYZCB9bSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYmyPp1b2Tjacp/gBpKS4DWx8lWOnNn5j7qSV/59mge9o4jibR
	OfGeczRQ0kHw0e6ttNR08rPEkbvxJStiwyfxZkg+IubHeLIDjwG9
X-Google-Smtp-Source: AGHT+IGQFWTBXvU5wXNEk0QGqxDOUX4gnEXP4PmUa1kS6aTrW558NclQ2ZVgyZ8GZr0QFArTBlc2Kg==
X-Received: by 2002:a5d:4244:0:b0:37d:30e7:3865 with SMTP id ffacd0b85a97d-37d5521ac3fmr10146183f8f.34.1728997884177;
        Tue, 15 Oct 2024 06:11:24 -0700 (PDT)
Received: from localhost ([194.120.133.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fbf857fsm1552386f8f.74.2024.10.15.06.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 06:11:23 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: tegra: remove redundant error check on ret
Date: Tue, 15 Oct 2024 14:11:22 +0100
Message-Id: <20241015131122.152046-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Currently there is an unnecessary error check on ret without a proceeding
assignment to ret that needs checking. The check is redundant and can be
removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index ae7a0f8435fc..9d130592cc0a 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1180,8 +1180,6 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 			goto out;
 	} else {
 		rctx->cryptlen = req->cryptlen - ctx->authsize;
-		if (ret)
-			goto out;
 
 		/* CTR operation */
 		ret = tegra_ccm_do_ctr(ctx, rctx);
-- 
2.39.5

