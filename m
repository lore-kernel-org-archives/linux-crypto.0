Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8D6C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F79613D8
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344301AbhDFWu2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344248AbhDFWuZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:25 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB99C0613D8
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:14 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m11so10982824qtx.19
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qeSDdPOEtLNZrGRyxSYQgQknQgwqkWb9I9sk4ziJ/OY=;
        b=Ga8o+6478WTe8xCs6ZDLhRgmVbg0E75BCEhnCWjj7i5U/bRBxcG3TKKGDrnjWjQPhP
         YlUD2J8mbYE0aHwukhb+JIRrQr4uORpXru4RoYbEdu8NU62S1heGZuqTiaCjr7UohHYk
         ToF1rDvEQtdYCR8p6CzPjPKYPK3XwRtg1SUO0aa5WuygwCg5uXS0CeGeNj8BX1NgQTaT
         nwiBrJWUHnUjmQPWv08jlxXLAjdyEq6b/iVLt/lXQlPp9QZrBxI/eVPurY+5wDiKXfDh
         HpZLNqRSD+BcRELE6rYzPq2k9kteRJIKsqYuvn3KraV1ETtRIj6pZaTW0hOHG4v66E17
         jObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qeSDdPOEtLNZrGRyxSYQgQknQgwqkWb9I9sk4ziJ/OY=;
        b=o/2tvF2bOz5LNDLIlTVPQDe2sL1lk1UbZ+0N26e2aAvX9kASG68Y96p+jXfFlSGzeM
         Putz/mClDwgtidJjLGsF/fwK6UmjxCZoSbOkf9XUK3vq1dsr5HWJIAyNCwJvmigKpoC2
         456Jih1nK0od3yIc7miy6U4wWSeBd5TD6BKU4oHI4YFPs5af1xB3ZAc36PuvZObGWXmO
         d0yzK75eYRKaP6cMW3LAmrhnk3Uo2WNOUBDuujMqnf9uOkXEjOuZJ4yYTEQwQ9yvVw8l
         UApj9i8Y4folHRj/5aH1ZOYutcGk0vsFvpunpcvn9pWKOBrKTyzzpsmSOTMra0iz4/C/
         zQ6A==
X-Gm-Message-State: AOAM533QvgErMlETg7ZG0CyWSZytftyQnGg/taLz1Dres4o5VkgMWmgz
        tjjOipjQRnEAE8J6ru5EO+TwRYwpcfw=
X-Google-Smtp-Source: ABdhPJyIcg9FGDhdO9rpoL2pPltZjsRaVybBMXUirh1bVIlL7/QgG8RFL7dOmXOb+OkSJdLe0/L4GoYHs3A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:7e4:: with SMTP id
 bp4mr279190qvb.5.1617749413669; Tue, 06 Apr 2021 15:50:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:48 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 4/8] crypto: ccp: Play nice with vmalloc'd memory for SEV
 command structs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Copy the incoming @data comman to an internal buffer so that callers can
put SEV command buffers on the stack without running afoul of
CONFIG_VMAP_STACK=y, i.e. without bombing on vmalloc'd pointers.  As of
today, the largest supported command takes a 68 byte buffer, i.e. pretty
much every command can be put on the stack.  Because sev_cmd_mutex is
held for the entirety of a transaction, only a single bounce buffer is
required.

Use the internal buffer unconditionally, as the majority of in-kernel
users will soon switch to using the stack.  At that point, checking
virt_addr_valid() becomes (negligible) overhead in most cases, and
supporting both paths slightly increases complexity.  Since the commands
are all quite small, the cost of the copies is insignificant compared to
the latency of communicating with the PSP.

Allocate a full page for the buffer as opportunistic preparation for
SEV-SNP, which requires the command buffer to be in firmware state for
commands that trigger memory writes from the PSP firmware.  Using a full
page now will allow SEV-SNP support to simply transition the page as
needed.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 28 +++++++++++++++++++++++-----
 drivers/crypto/ccp/sev-dev.h |  2 ++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 47a372e07223..4aedbdaffe90 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -155,12 +155,17 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	if (WARN_ON_ONCE(!data != !buf_len))
 		return -EINVAL;
 
-	if (data && WARN_ON_ONCE(!virt_addr_valid(data)))
-		return -EINVAL;
+	/*
+	 * Copy the incoming data to driver's scratch buffer as __pa() will not
+	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
+	 * physically contiguous.
+	 */
+	if (data)
+		memcpy(sev->cmd_buf, data, buf_len);
 
 	/* Get the physical address of the command buffer */
-	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
-	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
+	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
 
 	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
 		cmd, phys_msb, phys_lsb, psp_timeout);
@@ -204,6 +209,13 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     buf_len, false);
 
+	/*
+	 * Copy potential output from the PSP back to data.  Do this even on
+	 * failure in case the caller wants to glean something from the error.
+	 */
+	if (data)
+		memcpy(data, sev->cmd_buf, buf_len);
+
 	return ret;
 }
 
@@ -984,6 +996,10 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev)
 		goto e_err;
 
+	sev->cmd_buf = (void *)devm_get_free_pages(dev, GFP_KERNEL, 0);
+	if (!sev->cmd_buf)
+		goto e_sev;
+
 	psp->sev_data = sev;
 
 	sev->dev = dev;
@@ -995,7 +1011,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_sev;
+		goto e_buf;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1010,6 +1026,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_buf:
+	devm_free_pages(dev, (unsigned long)sev->cmd_buf);
 e_sev:
 	devm_kfree(dev, sev);
 e_err:
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index dd5c4fe82914..e1572f408577 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -52,6 +52,8 @@ struct sev_device {
 	u8 api_major;
 	u8 api_minor;
 	u8 build;
+
+	void *cmd_buf;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.31.0.208.g409f899ff0-goog

