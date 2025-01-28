Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803051E008B;
	Tue, 28 Jan 2025 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082826; cv=none; b=ewYSVi3tyjI5R9qU+PHLE09r3wFyl6xONZRBo18FTU4HbF3AI3OWhQAu9smcSGCzcp1UGt7earrqISNOSm29I+Bb8X/OZwOgUglg6sl+x5SB7FtZd4fhXf4x2wbqJ+V3Pf94GgN1sQDLyyTncQ98Z5iHZYFuYqVTGquT38mTG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082826; c=relaxed/simple;
	bh=BCsADS8qCwD1e69gNU1Cm5Bxoj8mKAeAXvBEhAbM3Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7GAKjXMS9Ca++620SZpQO/zrgzoxpaUQ2KQVMi+5xU8Bm3cLm89XrhBif98fI36J+6WDYQj5TxYN9shwlZUo35YlibGxfE9EwxIoVgluuPWlwxOVl5PFWQhlMrcIsD2+QDoUH1pb5lotm857xUOn/YW9fKPFinFNVQhgZWHlik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ta67J9X9; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ta67J9X9"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e549dd7201cso10651292276.0;
        Tue, 28 Jan 2025 08:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738082823; x=1738687623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdH2vZp/C+nxP+CvfAKEGQR90YrCTz3RbUsQ2r80bM0=;
        b=Ta67J9X9qB/JA0KzlGAC/dzOTx2cPL1kfNBHDrgKbgCf0TlzaPTbQtOZnuz2Y1QkcC
         sLSyD/w3GfO9EyFt9GDe1DPanlyJlR8enuHwri0Dtxfa1j6/70lvRw1UMaf3f5isMmlc
         8hBFZAbWHJAeLJU/QctImTIi8DZYJtf/2OzkWQO3fd1Ky4xYcoFoL070jRKKqmaJmMdF
         A53DrQ+wMheXrOgDm4sXcEnQB+3uKoQAF0r53HYnSFI88TV01FVyySVjDO3F9eMjcGti
         wZ6pyd4WlpkhfVK856+aeQlogXiRbedHcOmY/bzD2BPzy2RXRn3sM4tJW8XU5X6SGzXJ
         ZWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738082823; x=1738687623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdH2vZp/C+nxP+CvfAKEGQR90YrCTz3RbUsQ2r80bM0=;
        b=pK3xFunYJzlqSI4wCXnTNdtkoQS3aQM5b1B5ktIuoA8u5uC394rxKTB1aHBvdauA/T
         1PnVQQpQ/FgED9A823ZokzZjGuMWJGUGLhWHIc13mPw4uCVozttBDebYnw/ztm5QST+o
         P2rbyl7DOSXJuC7I3jsT7I1CaKMK58sqm8k3SOdJ3QQkibREazsNYAkjI3qyzs5RQb9B
         ZY11/Lh7G2Vs1WcelybOqlh5gPVBmSlet7VLK6QwjNG1g+loLO+9ZuUgMwMKzSGfnRmn
         EpDXWu7gxGBnAMphrmfY2GUPtsW6U9aqjFtLbk2DuAbEWzFQ8PntmMACD9rU6diq5irR
         ZOSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdav4SG9H9Od4ZlsSXR9/C//plfdjBlJtZwHYfI0408WB8LhMbVMuZaVLDJFW461s+NfuAxM/eOEoGrTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzetT0BzmFHl7sHpkk2NOc7sE5WD0w4iRUwELcUnOpP0KM5tQWL
	ujXwWRQoo1V3fRIa4U0cGjblrBQc0FkQIem3x4pTqpKLU7XFGyvxCeK4Fs3c
X-Gm-Gg: ASbGncuMSo934syeflQc1cL5Rd+Zi/He3I/gUCQROnkTWbNSsjOphwf/xF5FZ8VpZvu
	qn9On3K4sj44GKt9RRNIaxquu/42bZR0K3gkAl8EhPp4o9SgBkL4pA7nglUnqVthieKXqiYt1Hb
	vL1JfxFgrdq8U6dAlf/ntp+67JDSL7kdcfcGj11Ym4V2BkUTMWmp5pRUU/20MtL9JahEgZsn5Ri
	KeH4GJj9+wh/E9Kbwu95I2JjIrfnNeahmjmGnw9IayiJnk9Iis/0xfrqHn40Lhesqt9xp/p6/Cr
	RzxYGfdl9ctwmqM39eOgxBhcUrXOzXPoymjt3wruEK2M1oEF1L5GJvNuMseZhw==
X-Google-Smtp-Source: AGHT+IER7af5NTXpzAcsH7qvdwpTc9wpcM0WTGROlljOkTO/V2PrJ6AJSql0+EdF7q0KvaZDP1xG2Q==
X-Received: by 2002:a05:690c:7247:b0:6f6:c875:df2d with SMTP id 00721157ae682-6f6eb677d14mr353519417b3.15.1738082823287;
        Tue, 28 Jan 2025 08:47:03 -0800 (PST)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f7578778dbsm19590947b3.20.2025.01.28.08.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 08:47:02 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 08/13] padata: switch padata_find_next() to using cpumask_next_wrap()
Date: Tue, 28 Jan 2025 11:46:37 -0500
Message-ID: <20250128164646.4009-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250128164646.4009-1-yury.norov@gmail.com>
References: <20250128164646.4009-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling cpumask_next_wrap_old() with starting CPU == -1 effectively means
the request to find next CPU, wrapping around if needed.

cpumask_next_wrap() is the proper replacement for that.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 78e202fabf90..b3d4eacc4f5d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -290,7 +290,7 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 	if (remove_object) {
 		list_del_init(&padata->list);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap_old(cpu, pd->cpumask.pcpu, -1, false);
+		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 	}
 
 	spin_unlock(&reorder->lock);
-- 
2.43.0

