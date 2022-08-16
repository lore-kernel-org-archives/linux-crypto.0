Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC079C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 19:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiHPTco (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 15:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbiHPTcm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 15:32:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC2F883CC
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id x3-20020a17090ab00300b001f731f28b82so10204375pjq.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=zO5It9jW5Ab8pMtnbQERYyQvcLS9G329Zpg9klZy+fY=;
        b=T+3wMLEHCjZORIJaiQyb/vbWxoih9ExTmT/iYy0VeOAbdfsRLuvrYSTToE4xC395Hb
         8rtiLr/+bk6o8eQJWJqlWeDY5kax4JvF31lxyhd8HZB+xu8X6tANByp/V74LKpJ0REPD
         6pLIMWC6xQGG71NDBv5ZWed7vN5606apgAYXZgIMfucBRHWmDlTKIux54nivTe7/R14K
         zicKMMKXy34dlA/oMRiGtPBB/1rwKdXe2THDcBjz9UaLiUjPVULA/h5gQ/EEZbaHca+z
         3+RK9IaXnsXtmt5VnfhFKdq61kcj1ZTSSuzevnFV5FV1qj1ZmkDSVgWCvmUol77mWgog
         2raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=zO5It9jW5Ab8pMtnbQERYyQvcLS9G329Zpg9klZy+fY=;
        b=Nmm4cMbTNh4KdvDyZ/uirwlkKCyVqAZ+cjgmGDkpFClUIORCkvuA96BbD9KaJv+LB/
         Ln/5x5shrH0pztStVxWD503QrD+Of6+DvRgwqFklkdU7uxhfkg5tC840v1WEq0YmlENj
         up90e15RGu2ybFwlJbIpr+nCv6Ei//hDnytczk48ZXAoV/PdUp1gyy7wxKmeYX48tW7c
         d8taznZIhh2RQDtHxOPTdbYn0psUeAe8tVUaNs1bYhOC14cWQYSZC4s0rM189msDxzwA
         t5J/supN+XHP3NHHf9nN4Jlobav15jKNsvvoSo3fHJ4MpIARRq0VNp2Ime4HbzUI3p3J
         +QjA==
X-Gm-Message-State: ACgBeo08eVsUUl9Cc2VSa4UMUliRc09CVx+IEXZ9qBD1yJ0O/GqV+/UQ
        1Wj3kyQYGYKsRLMSFrmsN64+AUnLMos=
X-Google-Smtp-Source: AA6agR7ycAIiMu1up33hj1Do+MnhhxCC9G7VF8Bgz2C0/MM+g+7+nG81BtOwC2Vzz+Xgbz2jLrFMQzBB+fc/
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a17:902:710e:b0:170:8d34:9447 with SMTP id
 a14-20020a170902710e00b001708d349447mr23167541pll.126.1660678361168; Tue, 16
 Aug 2022 12:32:41 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:32:09 +0000
In-Reply-To: <20220816193209.4057566-1-jackyli@google.com>
Message-Id: <20220816193209.4057566-3-jackyli@google.com>
Mime-Version: 1.0
References: <20220816193209.4057566-1-jackyli@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 2/2] crypto: ccp - Fail the PSP initialization when writing
 psp data file failed
From:   Jacky Li <jackyli@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacky Li <jackyli@google.com>,
        kernel test robot <lkp@intel.com>
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
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jacky Li <jackyli@google.com>
---
Changelog since v1:
- Add a blank line after the variable declaration.
- Fix the string format of the error code.

 drivers/crypto/ccp/sev-dev.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fb7ca45a2f0d..ab1f76549ef8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -237,7 +237,7 @@ static int sev_read_init_ex_file(void)
 	return 0;
 }
 
-static void sev_write_init_ex_file(void)
+static int sev_write_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct file *fp;
@@ -247,14 +247,16 @@ static void sev_write_init_ex_file(void)
 	lockdep_assert_held(&sev_cmd_mutex);
 
 	if (!sev_init_ex_buffer)
-		return;
+		return 0;
 
 	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
 	if (IS_ERR(fp)) {
+		int ret = PTR_ERR(fp);
+
 		dev_err(sev->dev,
-			"SEV: could not open file for write, error %ld\n",
-			PTR_ERR(fp));
-		return;
+			"SEV: could not open file for write, error %d\n",
+			ret);
+		return ret;
 	}
 
 	nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
@@ -265,18 +267,20 @@ static void sev_write_init_ex_file(void)
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
@@ -291,10 +295,10 @@ static void sev_write_init_ex_file_if_required(int cmd_id)
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
@@ -367,7 +371,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret = -EIO;
 	} else {
-		sev_write_init_ex_file_if_required(cmd);
+		ret = sev_write_init_ex_file_if_required(cmd);
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-- 
2.37.1.595.g718a3a8f04-goog

