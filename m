Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA243BDC3
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325176; cv=none; b=hwRHUemBpySmSabtFGWAv6WQzUQpu7MUAr+zMcFscBKUMmrc149FaztEVWZIKnNqFfAiE4X7n+5y20sTXWXe7aIjghQe1QCS/iaSCMBAcAYFRubXyMvgd5RfTsP6l+JLGfDCgSJeDFLdy6s9IDobxKh2qfHpCqGPiYyvWrgtzBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325176; c=relaxed/simple;
	bh=fSnUC/Uevm5Vbrih7n+FM4vcyD9bqX8J6oiWP1kp/DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bmVrqKIlLZp4kysnoWP+J7q/2gh5Aq8NtTeEV9b8KDjzJGbhGiaDP4k7NRlbwBN2gqWcZr9l3YC/IVaGiWoZs6Yd4K73fMeOZ5lCHFwzwYu8JoVI3l4xl0Q2f/S92CsAOGG1xpPsFhg186EBDIloMfBiabtI0iJ35IPlE4Pyk2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IiODAYOF; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiODAYOF"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-382ef647e20so1073949a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787325174; x=1787929974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1HavqBuvOK9+7hkcuCpVB9Cv/dvjoerCr3RPaWhvFOI=;
        b=IiODAYOFsOAuQ+eSZReAYZUaTNXQWZALnaBvKwIDVH30t38bppy74aLAeoNNTKF06n
         DdLU5XcpDM9/YPfN3/Ke1KZNauX3HVCdE1fuiIwbeTQoEtrMz3oTh1u+aGx/R/zSq5RB
         7UgwcXkIQDO+T8cnyOMb6GknloyxQVu9oYsZAWjiqioTlo1lM5QLVdKS9ci+CNNXEeHk
         Ncqex42KIVoilAmso27QhYTStVCgoFvfpGoFY34bRPrmgnq3YZCZzy/1+Je3ajyCkoD2
         6aAAqsKb1d1LOa82TEdidgT4t7vaP0NiDEuFWQTl/y7jN0OgfiLkMxPsPw4yasPpXd1F
         0sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787325174; x=1787929974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1HavqBuvOK9+7hkcuCpVB9Cv/dvjoerCr3RPaWhvFOI=;
        b=R9v/Xf9V6DtIHha1fagw6ehoQNMv3LaaqcovQ1wOyRwX2t5Ov+jYBT7RhhgUk4KAcX
         SxDzoX/I0Cq4a99VTqak0UZga7lbnGOatqTwgJR0cryOPntwfFQ90fEo0c9rH2QbZfgd
         0PczHUck7u+mzOTlzehNYNJ+IFfN2WfPa9KvGDMIgF0SbqbhdWd/5Wq5tr6i7jYaUCoB
         wQAN3f8x3Jtbzx3z3aV2k35KgfovWnOH2CcypLYMM949nrtVQJQlK+FcMDuD4MhaZ7A4
         hCIlBVaeXFj5qYoNzqyvAnDKjJLSlNqQXKkQEp9+kqRoZ6Aq0+GMhbN2l5fF4IH6oa8Y
         bI7A==
X-Forwarded-Encrypted: i=1; AHgh+Roj7xA8kYjDeIdZR1O0aS8FiXUJrATvnIQPy5mdjfrthdOJRavYlNekbAHAlHkHJ20proDFYyHIRVhsidI=@vger.kernel.org
X-Gm-Message-State: AFuF++m2k4PaXprWq7e0owQ0h7mf5OhLV8jdKQ232H5C80OHgOoqpZ/S
	2mGEZ/+nBgzK2V4m8jCntEnkRpBN/SgRxyol2/L4tms4cVWiy25G53hM
X-Gm-Gg: AR+sD13eW1UdkzPnL1u0G6afpDFm+6fpBFyW/FFvRy25FSYSzYsLkFLQL/18MQn2pQg
	zQ9TNWBXcP9yo7ydvmAHVyBEbRe02dGjm49/NQVxOTuXv4G00VcjvV+KkdZ8MQpfoVfkzb8wAty
	+zDDYEgsV+Eww2/dVw6IhE61stALPHOpYi4QBKo6FKZH0ZwQI5T5f8PKBwHMkHpZNLbxDBbv0OB
	lAAngv6xirR4TY45upf1doUACEYu81Ms53kDOWgK9eOso3ON8X8WEzrqF5+3N/mZcYtmXgeO9bh
	0c1UQQmok3ZYG4LoXp/QMho04BB5vN6VFdjWWYSIel7n6jWXEP9sLnUyhZ6HDkHtL3SE5n7PPEu
	5caaJBptm26EdytEJuDGZMLS4c+4rL9abX2IOPJoBuCFvTvR3gYpcWcA6/TIQ3dk1H33LQL8J6I
	GI7I6mjDF8wD9LkEm66WZQY8nvY014348YpoYEla9LT9lUeSd1efa0J1Wc2HAqUnOjOfgem8XPF
	XcMlKQP
X-Received: by 2002:a17:90b:4c0a:b0:38f:de97:b06 with SMTP id 98e67ed59e1d1-395c351386amr12380816a91.5.1787325174270;
        Fri, 21 Aug 2026 08:12:54 -0700 (PDT)
Received: from kernel ([103.219.206.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4be666bsm3779132a91.11.2026.08.21.08.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:12:53 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: amlogic: Fix IRQ handler return value and fallthrough logic
Date: Fri, 21 Aug 2026 20:42:43 +0530
Message-ID: <20260821151243.8125-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In irqreturn_t_meson_irq_handler(), when an interrupt matches a flow
but the status register is empty, the driver prints an error but
doesn't return. It falls through the loop and incorrectly prints an
`unknown irq` message.

Fix this by returning IRQ_HANDLED immediately after the error print.

Additionally, the handler returns IRQ_HANDLED for genuinely unknown
interrupts. This masks false interrupts and prevents the kernel from
detecting interrupts. Return IRQ_NONE instead for unhandled
interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6cb33949915f..302b398405e2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -38,11 +38,12 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				return IRQ_HANDLED;
 			}
 			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_HANDLED; 
 		}
 	}
 
 	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
-- 
2.53.0

