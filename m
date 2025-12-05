Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C17432C92E
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764934753; cv=none; b=CeosxKpTCBCb4M5QkmpXlcYX4WOxPIs5TZvu8EhdRqdnkF4rvmbOHEAmCcQLvaubVYo//qIBCxBPc4v+Gali6QWNH6pM8mgAT+YfL65DyJZqf5k0itjQrtysgzYYnMiWhbptDCcwncHFNJEyrbFDIbcYK3XhYiHEpC+rTmNdG5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764934753; c=relaxed/simple;
	bh=TVVtGnBO/kgt+MW43a4WOfzk9YnJRjsgyZDeLmIwQUY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Puku15TjVNjPotLSEIFcNTlo/PYFBIgyzlhOk9l7/96lxAfXoX4QQP82EizkzIRzZG9jFXHXtiOnSDE8dtlwzU9SgcX0yjpJf4cR8C9ZRXBD7PwmUl1/UvGpLCEA+F1GTdR4Vd6Z2jTrLAyFKeB5KbxSOOvd7TWCSQBvoVPoS3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d3QBIYmS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d3QBIYmS"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so16293665e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 03:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764934747; x=1765539547; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8aX+EX0NpaccXweXp78xCHa7QYL2+QD6+NVQreKl8cY=;
        b=d3QBIYmSN37tc31xE3YCK4tMVilfQQUiOPnkcvanqKSw4mCnNTIuNxQgQRf+jEBOHM
         LqZU98xvdWE7V4Y5SgNB0zbMxk3UK8L4KplJbZkBpFpDXXumMZTWu/u8avM/UpIdiTJJ
         GKaiRiB74Odu7iWWB0RW06Ix7evS6B9RNi8QvG8lTNuKmGU5yxb1Ur4rPT5cTEP3bahj
         1fu5UxotxPwZ992HGoZNE2N9Juo8ZD9xzvnCys1hiVxivBojeVo6S2aVj8uo6h3xa1T1
         P8lefDST7YfAJcj1QdIaOwXOaMgs5ocIncYq9HVIm6afIhWJb+/agHFX94WmBx7l/7sr
         a9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764934747; x=1765539547;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8aX+EX0NpaccXweXp78xCHa7QYL2+QD6+NVQreKl8cY=;
        b=LOJWrhtkykEMTvHQRZZDYrCEM1/YxjZKpUx2lwBHvVQEvIe3LKJEmlFytDTRHXw5fN
         L+ko+yJcQcDWTO/HpomsULcoUDZeUE9gMiH+VMoyrX29/lYCDaC2GIHSA3mgh/42P9PW
         9cg8m32uA0Hob/IGnwkuRuYRTom6gACPMjrHUimb8cvP9jmxnoGc32tcoSiJCjO8j5/y
         yiccXGfJhuIBiavQ8xda12PLrCkC1jXXLMZ9Ywli6Tk4QwwthTSye00KIjKniBEtIG5d
         7OhP4MtlwuFCK0xRURMeA77rETLJhDzct/HLb8q41gePrODb4pKJWx6gdTGR6ysfjFOg
         Ca/A==
X-Forwarded-Encrypted: i=1; AJvYcCV/F5nwRC52BmEc2WNLjBkJqD7VZAwbpN/2oLnRbnuIqVbNCcKLEQiaaNCPhhb6QyGKNPRnB3Q9cIsQ7Co=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxH/jK8nBgX9IxcxzbJXQQsi8tvUIvL+cwXIusBRva5WreYK9d
	/QYpbq7ia7bhbCcM0v3KwI0WmFdbH+72hpvunmHzfnR2q+V/JV7Aj1ehYZzNVUUv4hBNoe76ZOS
	UFibV
X-Gm-Gg: ASbGncuDSUdJ89cLaonM218uabcn5L5FYAs96c5mttExYHwf0SE+2c9BGeC0o741JAg
	9l5LBqIM53j0zm3vvFc7FHWxWJLUvwHGhrMGQyaEq4RxrbvKf0FqYnbm3dHqtJwLtqhg06RCV68
	ELPJOSYtXhxdzR4Teczmh7mPtsuUhMa+9yb/xC1x8qi0Okuaxfn1hMrYSAbJxSSrVBZaufn0kch
	wNrINzQQy1nJlLUyYuymNnFeKu+ORb58I7rO0ertB4pHep8/5x5u0E+I8kXjxFBuKNBGYl85dCD
	+txQjuvchasxaJHk8mJ9T5Ol/doTH8qI+iinRUUXkX9qkUMsTuaHQJLooMGfCJabUfE+njbW5ac
	XCK77h45jbE/fUdoUgPKlNnD3+htqYaKvBeoyEvydAG05TdggwRO3p4JIaaesNWxkgaqYrX0N+I
	j6ewHllz99sTBkIJ3R
X-Google-Smtp-Source: AGHT+IETbivJfBcDFqX/qYauRBKsQ++55ebaSqc3KEhL3Ernui7SaVmRbHIyHQmMXTPmCfMZXsNxvw==
X-Received: by 2002:a05:600c:4584:b0:475:dd89:abc with SMTP id 5b1f17b1804b1-4792f25b843mr62826545e9.11.1764934746896;
        Fri, 05 Dec 2025 03:39:06 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47935fce542sm23520885e9.0.2025.12.05.03.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 03:39:05 -0800 (PST)
Date: Fri, 5 Dec 2025 14:39:02 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] crypto/ccp: sev-dev-tsm: fix use after free in
 sev_tsm_init_locked()
Message-ID: <aTLEVmFVGWn-Czkc@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This code frees "t" and then dereferences it on the next line to
print the error code.  Re-order the code to avoid the use after
free.

Fixes: 3532f6154971 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index ea29cd5d0ff9..06e9f0bc153e 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -391,9 +391,9 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
 	return;
 
 error_exit:
-	kfree(t);
 	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
 	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
+	kfree(t);
 }
 
 void sev_tsm_uninit(struct sev_device *sev)
-- 
2.51.0

