Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B3C19F29
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Aug 2022 18:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiHBS4A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiHBSzx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Aug 2022 14:55:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C314D1C
        for <linux-crypto@vger.kernel.org>; Tue,  2 Aug 2022 11:55:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q5-20020a17090a7a8500b001f0253f5aa3so7767588pjf.4
        for <linux-crypto@vger.kernel.org>; Tue, 02 Aug 2022 11:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=DaRQ2izucvqnfyvR2TmA8t9g6dOpwwmSS0DB8AAt990=;
        b=Ly/T2amXaGhpFs2B6F33kLC4xhEqMWV/njDT98eEk+lNKHotckSXgbK21dcXaRSkEJ
         xC4TY/pNLC0vKpjDH+hWyM/8Z5B509hJThDN0jNXjV1sIfFO1tIamw71iNskhvacGwXV
         dNKqw6o07cOIHW3GzxTWOIPg3BuCP9Mqu7z7XruKYJrZ6z0gc5FVfJKTGkVGLORTfSfo
         6hIaTTFDAMJtB/Upablei5j9czw7XRYowNd3SzztxYpfPdBQw5IDAM2Hb90NJx2QANVi
         WAW5/rZm+PxZmTV2nYO6O88EaUfncGhGnRn55ABJKqvwFrgAmkS+14oZlQLEuNedYMbf
         JCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=DaRQ2izucvqnfyvR2TmA8t9g6dOpwwmSS0DB8AAt990=;
        b=wZysq1K0CKWbL73+f3Y3B8IGFDNPwTg1xMxK8ec7NFYYVCZfItgdWr3XKVIf3HSK1K
         w4NUeLy1g1gf2qfeNh3pmCNY5TRnRLMO1UK3GSkXUWiFiBJrzrqLd8SP6PD5+fWdCsiY
         gJDIrVl28MuTZipZPNLqY7Ys4jO6UHNLEKsHvfyjcHLDyJhtfP/pTm/Y/+Fy3iZvJSMf
         F20GmEOj8AM9PsGGLp1PdUajMmUBWQNF0W51c29RMBSyyufXyL7obOCDMxWxSNA22W2F
         tSEmoYH7Z8os8IHCcZOzYEWVEOXdQknmoT7gxtIT72PzyAf7RQsDhKoPRBobssZlq+QI
         ImdA==
X-Gm-Message-State: AJIora8WxJG8Zt2ZN+3UrpsC2SzTNaNKU5lv+Xxsv5thN0dzMM1vqlhA
        yfJ7fhMWpgZ0H7Z3vU4ob7wjHc9BrJc=
X-Google-Smtp-Source: AGRyM1sWB3iGMjsNkKLdcbRYMAQl1qXz8lJEvDNwsSlg1g42TIIMXnJD1yEZwFLFr4gUcVdMpKbsvK5T7XDO
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a63:43c2:0:b0:41a:9dea:5dac with SMTP id
 q185-20020a6343c2000000b0041a9dea5dacmr17694202pga.585.1659466552250; Tue, 02
 Aug 2022 11:55:52 -0700 (PDT)
Date:   Tue,  2 Aug 2022 18:55:34 +0000
In-Reply-To: <20220802185534.735338-1-jackyli@google.com>
Message-Id: <20220802185534.735338-3-jackyli@google.com>
Mime-Version: 1.0
References: <20220802185534.735338-1-jackyli@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 2/2] crypto: ccp - Fail the PSP initialization when writing
 psp data file failed
From:   Jacky Li <jackyli@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the OS continues the PSP initialization when there is a write
failure to the init_ex_file. Therefore, the userspace would be told that
SEV is properly INIT'd even though the psp data file is not updated.
This is problematic because later when asked for the SEV data, the OS
won't be able to provide it.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Reported-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Jacky Li <jackyli@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5bb2ae250d38..fd6bb01eb198 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,7 +233,7 @@ static int sev_read_init_ex_file(void)
 	return 0;
 }
 
-static void sev_write_init_ex_file(void)
+static int sev_write_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct file *fp;
@@ -243,14 +243,15 @@ static void sev_write_init_ex_file(void)
 	lockdep_assert_held(&sev_cmd_mutex);
 
 	if (!sev_init_ex_buffer)
-		return;
+		return 0;
 
 	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
 	if (IS_ERR(fp)) {
+		int ret = PTR_ERR(fp);
 		dev_err(sev->dev,
 			"SEV: could not open file for write, error %ld\n",
-			PTR_ERR(fp));
-		return;
+			ret);
+		return ret;
 	}
 
 	nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
@@ -261,18 +262,20 @@ static void sev_write_init_ex_file(void)
 		dev_err(sev->dev,
 			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
 			NV_LENGTH, nwrite);
-		return;
+		return -EIO;
 	}
 
 	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
+
+	return 0;
 }
 
-static void sev_write_init_ex_file_if_required(int cmd_id)
+static int sev_write_init_ex_file_if_required(int cmd_id)
 {
 	lockdep_assert_held(&sev_cmd_mutex);
 
 	if (!sev_init_ex_buffer)
-		return;
+		return 0;
 
 	/*
 	 * Only a few platform commands modify the SPI/NV area, but none of the
@@ -287,10 +290,10 @@ static void sev_write_init_ex_file_if_required(int cmd_id)
 	case SEV_CMD_PEK_GEN:
 		break;
 	default:
-		return;
+		return 0;
 	}
 
-	sev_write_init_ex_file();
+	return sev_write_init_ex_file();
 }
 
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
@@ -363,7 +366,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret = -EIO;
 	} else {
-		sev_write_init_ex_file_if_required(cmd);
+		ret = sev_write_init_ex_file_if_required(cmd);
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-- 
2.37.1.455.g008518b4e5-goog

