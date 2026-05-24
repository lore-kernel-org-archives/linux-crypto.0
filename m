Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281E3212566
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651951; cv=none; b=MHNlXGN6MfRCiKrQPriKrSf7c2EJR6owFtk44gNZGl/4TjFxYHoi85lGweQI/KL+xcm02F8gEU1anCX+jKsCdOb/j/KcB3t4sFRLiDGx/pKpuAIinDbbhGE5YxZbrFfF3pC4HBy1/Kskc33E1HAXi4/cuA3ZhkqSTgNyd60GihE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651951; c=relaxed/simple;
	bh=QOH23cOE5ksNBRXS1I4/u4f1LkCMC6S9hdVW59i/FDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMRzpkwj6BBIal0Abh/DTGww7niJDeob2JCi0qlgnq4/WgVML9j+fj/Mizj0rWLhblirLOvUwFN8OrMcf4heuWJoZ4kl847ykQg79s41ojFDSqX9O3Hh+B1Xfz6aC9BNt3RB47IvrntZm7kWD2BWOG1+yIwYKtyMOjaYWFmmYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ho+vWIYv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ho+vWIYv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ba4a1a0325so59879335ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651948; x=1780256748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ii2qt5Ov08fmFNNaHs2Sw1nWb5YUcmi/e2JrpHiw+2Q=;
        b=ho+vWIYvwtPXd1i3wOCAo8EwTN4pkJ0Q8SkLWMyr+yFTABtLhq1Mt+3le0hc+XxZwr
         WPnlWCH/BgajciC9GU97iAuKH5gURVn1KZfYuzsiJRI0NMDeWjW4oN02QnP5f84IaG4o
         AJ1XkM0DUhWWehyXjacgGarOiOuKDRbdapnLJBMmp0/mrwzj8eFVJNEsw7e/uUHDZuf/
         htdPVG+lxbdW8gBddqP8I2K9+Mpfv7lHxtmXZsrQ7RLQutDKuA6eKT3pCuxjMt1uYiOn
         8wzk1eOMwijU5U7r8laKIsTn0rBGauER8faMpLS8myZxGYsXgs2lyMOcLUkrxuMjFyR5
         b8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651948; x=1780256748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ii2qt5Ov08fmFNNaHs2Sw1nWb5YUcmi/e2JrpHiw+2Q=;
        b=GiILjy8GcOYZGgRkSMA1OcHnUVxX/yhtTA98/IwD8ZQRIACQ92WQnOVQxAYUUuYNfI
         5/O8d5Tmrh0eG7sx8I0SGXB3LrpLEOb8CSzc3VmrXlkKGSSVEpRQHo+BkTfnw7rptJDM
         l09m6IJDOZaAiCEuQyTn4GUDcbHOK1ArLEMgiwy0vQxwrUR1irgH0Qk6wvVoFztEgYN5
         wtHiZ4SXn8FQYpdSy1o0RIBTT6YdV7sgKSUxB4ooHth/8neOm5PU7A1lbC/XLGHAQ/8C
         8yrYGaCGEOLMEf6ZXHU2ETp+z0Yq0ljovk6V2SspcZ7U8CDENOdQJ5cQqNQXEnYce0JK
         q8Hg==
X-Forwarded-Encrypted: i=1; AFNElJ/CohVtelaQuyl0n6MbFL7V5LnI6zO9jq3ni1Ztmk8e2VoqJuWc5eG1ABi7eKuTyt6wYZgeN2u18P3ySmw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf8wGxxYfXvz8rTehllJhvL6zevGsXmaLb/8hV+z2VDX0akZXM
	RoLv3uhNI4kx75P2CreWR0VNPDQSqkMiiiUQb5xrQEy2hzuj6dg0MPta
X-Gm-Gg: Acq92OEgbuXJPNms+2byDqCm1BCTEJkftt87kEm/y9Mh6KbD9yGLH8XcFoOk//uxE9q
	QULBKAu9gxlRYaaqbiNwvhufMak9CvqjiOhIAvZ2fyJQMb/H5SgE4dJpnaHaQOs3Q9izEZxsRin
	bcqKw5BQoeTo4qktq5E+3+I1QdPxRJuj+lzfQW9lO9etwsLNW2bdLQ9QQRcMb8yBSEFsnmjhubh
	fq8fUmGlhFwY5xBI/AvNw6uDfbfE2IXuTsCq6/HydELSiN0oDX4gtetsUREvjJ6GN8gGjKQDsAi
	32ooP6E/Z7olyazTVz/ni8zTOpAnbOjnU5/w9YAdDjMdNtwFg2tjNDuh6O8wR+++wlrsRgPZiDt
	ITefpKfDRgYTx+n45IcMtTO5VneMCzM39xwTsufitoLUOCs7/zbzxKM+9Vo8o3ED/RbxNfqA4kh
	M5dfY4J/FNQnMx3TiXN5LDm42C
X-Received: by 2002:a17:903:2bcc:b0:2bd:e5d4:dc63 with SMTP id d9443c01a7336-2beb070343emr131259625ad.26.1779651947922;
        Sun, 24 May 2026 12:45:47 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:45:47 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 1/6] crypto: eip93: return IRQ request errors from probe
Date: Mon, 25 May 2026 04:45:23 +0900
Message-ID: <20260524194528.3666383-2-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260524194528.3666383-1-hurryman2212@gmail.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

devm_request_threaded_irq() can fail, but eip93_crypto_probe()
continues as if the interrupt handler was installed. Return the error
immediately so the driver does not register algorithms for a device that
cannot signal completions.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Originally-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 7dccfdeb7b11..276839e1a515 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -433,6 +433,8 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
 					NULL, IRQF_ONESHOT,
 					dev_name(eip93->dev), eip93);
+	if (ret)
+		return ret;
 
 	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
 	if (!eip93->ring)
-- 
2.53.0

