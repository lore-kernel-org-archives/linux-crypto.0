Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF72736215F
	for <linux-crypto@vger.kernel.org>; Sat,  1 Aug 2026 08:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785573883; cv=none; b=X7Bw7gTnuEP9aOeYNNgeUL1p57iUux/UPxHNf6bX8/uCtd58gpW8P79unyGawAVe5q8sSsxzxDJqj7d0sZ/WNNm00VCX4+TqI4ShHTnM8sz9MnV5f3bFtaK04EkYp3xDrlvo7zVeT9pghVpQNA1oNUds8b06q7bO9hX2Ss3HHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785573883; c=relaxed/simple;
	bh=niUIx/UFHwrX4oD4miH2nO6hyJUo39LBaahdeKa4TwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnMxnPQ12oEgzfT/+f2UWVFSVBSFCuz60j8jszCUyoTk4zstHzTSZ6ln7CHeyeIBKn3inYhzszyI7dWBvuGxtRtcPDmsmZ4nTxRJRSRlMn7uQF1fVAoWhxckuoVpOjyAPME1t/PXTeDRPXvpay4fa7kMIrcZYhC9Pa/Nz3rMLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=fNOWo+Kj; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="fNOWo+Kj"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 623293FC06
	for <linux-crypto@vger.kernel.org>; Sat,  1 Aug 2026 08:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785573873;
	bh=T5Xrw7hWprPHD+K8Ys/wZmplEop9g7+IGzu4/Ejaun8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=fNOWo+KjW8W2tz6++VaLy1HrUXPRP5ztf+AH8Gx7rc6yD9f2e9YsJOE3sd8q06QhG
	 fAfnl1+sGCqT5LCQbyyVWCO4yy8f9ioxcATM7PL0tl8bE8bteMM8ExQnuTRr8PF/4L
	 3iKJcaHrL2SyOLOHi/vVikQZPo/UKy1ILkEoGJMA9hmpmfzKv64RhnK8myG9VZUQ0s
	 DGAfV850VrxVEdt30RY4yoGhvc4Ny7n1ogQ+X4rR3g4evX4qmMX4xKF4dtmaIW5p9A
	 lh4/1AT7/zbJijmzfw5tT2RMPA3pIw6XLrllH4b3QOCVZSEgLnhSLXgqpcMqeuwdf3
	 7P4lZU1RAbXe2nvbxV2yCTInckaQ17cVei/teKKsUg+U774HVbJznP0uqGSc/7rV2A
	 It+6Y3Pep4Jkn5bJ76hwOBJL+FWRb/D/B8BsowVyZLJIG6BrWf7b7TVAMr3N1ERTMg
	 MsXSfSy9nLFmBjeGaLbIhp7O9mEt7RVNARUA9PhXR1gQKRrbjo1FgUCXws9FWzfKdA
	 imhx9IlaENUl2Ew4QuRYDflH1yIA3E8hOePlG/MOHDkmaTy+89E3gOQujayeZNqQ08
	 NzZqkuVuDQ1rnvI32HnC8/+Wgi56/qxuhmcLRASvZhctOohG7Qd8EAY5ZAzb/+43Z8
	 Gfqk0Ei5N5KY3J2cOXCQMh+s=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cce14a21faso22394025ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 01 Aug 2026 01:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785573871; x=1786178671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T5Xrw7hWprPHD+K8Ys/wZmplEop9g7+IGzu4/Ejaun8=;
        b=NhUAPmGLO5Hi6ucard2e/Yq9ZzXVOoTJFLEJOrdINTnvmVgSwhx5H9B8Y80VAq7K7S
         Pw8fRx7cf6JrSrjduRkHCQI17HPnz0tTtnRFoqXioFpHFIq0GwzGXLeppPcZdK4U/3SF
         kT5Xunbck11EbgkY3CIBC7NpKLtsCh1wUodBB1jfvi0HIqT4JLZPP6r9hmYlkBTiT9md
         nLNkJjD4n66GN+bjXg9s3AHL/7aSEUDt6Xv7ndnyvyoP2yyfaM7IoA1Efyg9+rxQIbsZ
         PWMxVKBXfC0HnfFEdLE7KSRPbZuSGgfprR78sxFDxC6UfNxuIK80ijKsWGZsEwQvd74Z
         igHQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsIEENuuUlj1Hvr1aToCei3hOjG0UFlC/oz1ItEm4uPDy1vdeL6u0oGv5FvSTKFdTtTdabO8Eg1SouI8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ4UZBmnpyJXiZs7CySR09POKSCKodrhoQ94/b9iISIyKQ2Ih4
	7W/07Y3spbQUJJchvEkr+fRQmvuZ4MQticDOm3k7FPDWgwS/NupEQnqEJDABGLvTWagYvrXIsmU
	OPacY7gFGSzfvCkyKHriG+9D83eBMB8j4eBAT75ZEE7QZ4vVNlMK0wJ9JpFhfjdarKaOh0eRzXl
	ctm1CrTQ==
X-Gm-Gg: AR+sD11BkKJzb9onL1WE5EG2qHSjl5+pslm4VMc5NfseiN+V4Hk6wbFnOuE9P938BUh
	tYqHGNXjwVJkclAhbJPGmE1LBcz0J131BQDqV7RD9idlFGhorjdIiEx9HmGn3kuX5/AwWeeCaGT
	xMJVkSpzDH00t8unUYmhB2NO4kNZcMUm7tC8e6cWWvjtWTAC/Ea5O2OigCZ/CN8RzBRtOgPsbEO
	Q5J6BZm8OMyRamAxAdLcektQ8JmGfLO3HuvjXdrDJ85GLFgFaegYZygNjRw0+8DyvQR52gTjWy2
	5VbYEldM0PaYqs7BR/3/TH8ai/y8drNK5mVRpXDRK5R8XOvryHS8Fao4BG30qwtxe6InT0hRJLm
	jm5IKWCSzT1M=
X-Received: by 2002:a17:902:e551:b0:2cc:92ae:b36 with SMTP id d9443c01a7336-2d047e88baemr43813785ad.24.1785573871525;
        Sat, 01 Aug 2026 01:44:31 -0700 (PDT)
X-Received: by 2002:a17:902:e551:b0:2cc:92ae:b36 with SMTP id d9443c01a7336-2d047e88baemr43813655ad.24.1785573871108;
        Sat, 01 Aug 2026 01:44:31 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c1casm14633037eec.10.2026.08.01.01.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 01:44:30 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martink@posteo.de
Subject: Re: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Sat,  1 Aug 2026 18:44:23 +1000
Message-ID: <20260801084423.10948-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <am2UMhd5CAhDiKBF@gondor.apana.org.au>
References: <am2UMhd5CAhDiKBF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

Please see the CAAM driver shown below.
Thank you very much for your guidance and support.

	(gdb) bt
	#0  rsa_edesc_alloc () at drivers/crypto/caam/caampkc.c:294
	#1  caam_rsa_enc () at drivers/crypto/caam/caampkc.c:733
	#2  crypto_akcipher_encrypt () at include/crypto/akcipher.h:279
	#3  rsassa_pkcs1_verify () at crypto/rsassa-pkcs1.c:266

Kind regards,
Changwei

