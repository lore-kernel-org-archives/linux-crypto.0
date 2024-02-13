Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372A605AC
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707847788; cv=none; b=Ucn0MBIWxADNIltZtYOPK6YEiQJWbxRVEM48c6SDyPCw7vT7WIqg2u3NmYq8iMUv8v1Z3+NhZEyuvAqk9Hpkclx80sfN2HbT1B8gbl3/bQ3uXvHdjF0t2ZJHuyUYsyqGAAH9JRi/7l39XFz7euRKLtfLqLVJvybiWIR1wugf7LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707847788; c=relaxed/simple;
	bh=4ul5Tw3COSLN/gf7enKgp1nS0J788ARuuwxLOzxXNKg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mTKGc6Ax8Xi8xfgUwEPcjTb5HsUtTOH4Uj9qDVZ+INEUwjVaSLr9QvyeBQNkI8kXFNBY/aqKVZ/uFZLnbktWJVVN9Cf3pf+uyw0LqYqFPg6oJJM6JaBMyjCLcE6daCtyU5tTPyyl3KAUuaq5YM/qJpZRD3TgbsyoWrY+ddvi2V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jEr8eJOH; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jEr8eJOH"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a3c1a6c10bbso397446266b.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 10:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707847785; x=1708452585; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=33nfQ6E2IZzcs7Pxb0qMF/g8B61uICxiGHNN3IFmu48=;
        b=jEr8eJOHGPuv9ePsH2/x1K6QMulDrlHaVaqW+3OEwXzZncth6plYvGdNfQktzOiqgQ
         5rdJGqQBl6WOuvnA130CWQAafxRvJdo4DrtZAcwe5o0gMHvcHqK/5YzvtEuCEXkT3f4W
         bUWQnAdVsZ0ew/psMP38XxJkyHSMrM5YZ1K0kjhPSkPGi4jxAfqfIBaFwMAGQf8UQCNz
         585gcgJMByrkRh5NfIchzhle9vvwS7UNzchOsnznUALV/7D2YSHPvadLg4ApXoGC8LgE
         I4e/4i2DQbQ2AVvPjvP9wgwOhMnQET7/Nsl33EGZpIigD8Zw1vcKhD975S9UqhgqyJxe
         tRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707847785; x=1708452585;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33nfQ6E2IZzcs7Pxb0qMF/g8B61uICxiGHNN3IFmu48=;
        b=K0ejHdo5V58hoD/d2F9okopVjj8N9Nd+9ypu06+G5xBWmaw7uhr36DksIMG1VHfyWK
         N9PhfLVU6WKAekU81smvluo7WVx3lTNlHW6k/a271t2TysgCNVtEICfsMTOElPMvpv68
         dyL8A17BFsiYSqgQPwk84H3fNduPenuX46KRkutZKYqs0A7UoP1ajK+2mBZh0ulAwRti
         9aAgFI5zs1KhsxvqgM7XC++B1GZTMiI6rGZWT50xnlWVy/SlxipXvegAv2OCzCeBvlYu
         MpO5XHEnUKGUp7/UwZPNUXdOR2Rde4U9OBzPF5VXriOU5SM+6o6/6TqS+vZ7XI8fMO48
         UTGA==
X-Forwarded-Encrypted: i=1; AJvYcCVAPukZZ84tfaoYLb1NOwfN+XYOafW+pL4G1ak5G/3wy538iwYRBiVNVU5b2jSxcbpdTdJph0mEBhYY62vr4YDhUpldGrYvFj02hcfP
X-Gm-Message-State: AOJu0YyZkPykx9hjI3C5xzQPvuBnwO6jBX4UoPtoBgbFCrLX5w+kx2+E
	VBsgBn7qM4jqNHinhd96CAltDiM8nYnPUGKaZttg+tQV2cd9xSs1rS/T9CsxaDE=
X-Google-Smtp-Source: AGHT+IEOc9jIZditY5gokNfJ5nlqPtrusPC9dfFz5hgOhFOTkyw8kuxlKUxjhYhVekorWlipgivMsg==
X-Received: by 2002:a17:906:f9c9:b0:a3c:f71e:215c with SMTP id lj9-20020a170906f9c900b00a3cf71e215cmr94770ejb.19.1707847785142;
        Tue, 13 Feb 2024 10:09:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXtvq2ePchqRVLeWfWRgjTIk0XHuXOVDZfnCNszJq0nbh4i9MvodQpq3+8ABQI2MxEcHkYz5Scv6UcH/V3N+y/xplTvs75cSdcIXhTHTMTtw27UVIi0YBCIkkYkaWgKQ0GQCgemeQCjQr6wOD/pUUBCfyJTh45toXbSxkECFAdQoj/zayjtgIqsV+LiOukPpn43nbhAMz1p4mHYHrOyvcVydnqgRcM3NhvOpgxMvbvgxaK/ecksL/FqjmsT3v3EBsUd8jZDUcKZ5xd+PgL4Q7eJZcgFRfWJCd7I1AWjL3UQ2luNhrHp9QO5YoQhez+mhpPq94YvzCM30QWAnTzOsoioMInxZMNSMNxeKuHbzNkMgBR2pk7mjDJ9nTxHYlWlsE5b0ZX9Atdv/XGAZT/TOt6C1QYan6Mg/+1/bo8pgXhb+ZTcjVk6LfK3qQ==
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id gl15-20020a170906e0cf00b00a367bdce1fcsm1520638ejb.64.2024.02.13.10.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 10:09:44 -0800 (PST)
Date: Tue, 13 Feb 2024 21:09:41 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: qat - uninitialized variable in
 adf_hb_error_inject_write()
Message-ID: <193d36b0-961a-4b66-b945-37988f157ebe@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

There are a few issues in this code.  If *ppos is non-zero then the
first part of the buffer is not initialized.  We never initialize the
last character of the buffer.  The return is not checked so it's
possible that none of the buffer is initialized.

This is debugfs code which is root only and the impact of these bugs is
very small.  However, it's still worth fixing.  To fix this:
1) Check that *ppos is zero.
2) Use copy_from_user() instead of simple_write_to_buffer().
3) Explicitly add a NUL terminator.

Fixes: e2b67859ab6e ("crypto: qat - add heartbeat error simulator")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 .../crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
index 5cd6c2d6f90a..cccdff24b48d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
@@ -160,16 +160,17 @@ static ssize_t adf_hb_error_inject_write(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct adf_accel_dev *accel_dev = file->private_data;
-	size_t written_chars;
 	char buf[3];
 	int ret;
 
 	/* last byte left as string termination */
-	if (count != 2)
+	if (*ppos != 0 || count != 2)
 		return -EINVAL;
 
-	written_chars = simple_write_to_buffer(buf, sizeof(buf) - 1,
-					       ppos, user_buf, count);
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+	buf[count] = '\0';
+
 	if (buf[0] != '1')
 		return -EINVAL;
 
@@ -183,7 +184,7 @@ static ssize_t adf_hb_error_inject_write(struct file *file,
 
 	dev_info(&GET_DEV(accel_dev), "Heartbeat error injection enabled\n");
 
-	return written_chars;
+	return count;
 }
 
 static const struct file_operations adf_hb_error_inject_fops = {
-- 
2.43.0

