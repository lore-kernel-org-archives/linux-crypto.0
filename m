Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC713A168D
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 23:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381821; cv=none; b=EXMm3mFZugiko/ZPyAoQENb7WuONvF1d3kHaubY0/NJNILlLVsklXYBPkYYBJJnrL8ZfN2+KySrKrmx6zQK1zYsGCUgma8it8Io7/UiBNfz4qwoF8rAlllhtMQJdDEGQNU2nbCd1raEjsLnNSwIulhDvfeEE5aHdLPyOUG3faiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381821; c=relaxed/simple;
	bh=F9hu7bNzeCBOlvwlFHXUfWgAmqd09v8gpi7nWJIWB7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I7mEZ7vfxmdpSFfU15DhI+XAZNOJPs+UhtxjLcTJSnFg6SxU+8vMKvxTiEe19tLhRfLHHNoM2yJH8Ptxb2d0En0BEo5AdSY0CBAz5E4/WOLV/rFaKn9MKAr0KIMTFMXRhnPWEMR86iW7lyogsDvqPxu+ZcaDKZKR5U8clTeWDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ox3Eeemb; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ox3Eeemb"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7962325ba0so176121a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 16:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776381820; x=1776986620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dmXOa8CgzaXjhBu8qlmeOtW0FfPQWyidUD9n4wlGJ1o=;
        b=Ox3Eeembh3AWL6N/FtayZCxSNuQO35OIwSZKYu7fB35TIgU7JtHCHfDNgoDTT+EHbX
         nRHe1JyCX4KMqvzT4wnK6IhetYPFQAGYNkfRwiUwzFFQmZfGno3HGl5Ak3ti6WR9wbVe
         HSOK15XLPp3x3BJQ4nN+PLeU/M0cWSL4njY0vEWAZkjTIo0gNRzLndNM6fvT+fyuMh5R
         9OQ2osAuD92lDpsmezO0pq5CR45qDykzRZLbtXPM0JZ2RLtYSaaZE7gZ9EaqdKVHnlZU
         eBzJ+IDOyTVhEOtvjzMCbG/U8Hag8EmpwXUbNiPco0LfHQLY3NrXh4VqSP+wA107zOJw
         SYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381820; x=1776986620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dmXOa8CgzaXjhBu8qlmeOtW0FfPQWyidUD9n4wlGJ1o=;
        b=EiK5Whuq9p6aAyN7gnHFHy9DnePkx+Y2OmZKxkS2FGgL1L+dsZB7f+MQKxGGxffBDn
         RAsRgqd1nJawQqWuuPLCkaAoHLLQ5JWAIx4SpXtvrlJCuaGc1TwiiyrRE0/Fvzin5K4o
         pNdmF6/HL14tuq0YWpwe2mnyabzvpnTSA2p/sn+2tqVtQxp6+nt8iQXVUAeK/zrPkics
         4o/U7w9HqUKFdFJ3+jxpUJyf3qfEaduBM/ovOPzwAo2WOjRVPQJaB6aP0Z3j7XB8F+rG
         5fJZS55rhS7maYefhWQis+/v3MzjwOAtfRuURo7sS6QKebkSgx+IewwALD0msCIAFNMI
         nrbw==
X-Forwarded-Encrypted: i=1; AFNElJ8axlb/NhW8Y09qyT+E6PyCUYoJeinL7tneu3eoJfDOnIUL1ARYwL36MxmkLY5s0efESfX6bPcDSS4WzeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXgKf7cF7Rf7JILLd89goYHYPZdfE3+SezVT/PdY/JoTa2sKGS
	x2d5ZwEvKEl3Mvw7AE/9ih/AKsg+N+I0cAtxcwxhnJuDH6I/zE0PhL6ObUgLgmontWYu7W+84GV
	TVseyPw==
X-Received: from pfwp27.prod.google.com ([2002:a05:6a00:26db:b0:82f:5a4:a02c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:391c:b0:82f:250b:9f1b
 with SMTP id d2e1a72fcca58-82f8c8c299dmr257458b3a.23.1776381819591; Thu, 16
 Apr 2026 16:23:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Apr 2026 16:23:23 -0700
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416232329.3408497-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416232329.3408497-2-seanjc@google.com>
Subject: [PATCH v3 1/7] crypto/ccp: hoist kernel part of SNP_PLATFORM_STATUS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Tycho Andersen <tycho@kernel.org>

...to its own function. This way it can be used when the kernel needs
access to the platform status regardless of the INIT state of the firmware.

No functional change intended.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index aebf4dad545e..64fc402f58df 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2367,7 +2367,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
-static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_addr buf;
@@ -2375,9 +2376,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	void *data;
 	int ret;
 
-	if (!argp->data)
-		return -EINVAL;
-
 	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!status_page)
 		return -ENOMEM;
@@ -2400,7 +2398,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	}
 
 	buf.address = __psp_pa(data);
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
 
 	if (sev->snp_initialized) {
 		/*
@@ -2415,15 +2413,32 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (ret)
 		goto cleanup;
 
-	if (copy_to_user((void __user *)argp->data, data,
-			 sizeof(struct sev_user_data_snp_status)))
-		ret = -EFAULT;
+	memcpy(status, data, sizeof(*status));
 
 cleanup:
 	__free_pages(status_page, 0);
 	return ret;
 }
 
+static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_snp_status status;
+	int ret;
+
+	if (!argp->data)
+		return -EINVAL;
+
+	ret = __sev_do_snp_platform_status(&status, &argp->error);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, &status,
+			 sizeof(struct sev_user_data_snp_status)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

