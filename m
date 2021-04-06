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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5FEC433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E96613D4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbhDFWuz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344323AbhDFWua (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56DC0613D8
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x22so21770895ybi.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=csTFUpsRawa07wcmPlEmUE8R3c/8ED1fSyaPMVbY1/I=;
        b=ff3Qi8XlXaAP8Ho2RSWqRgeiGlfya7kplhOvaksEp9BmY37Y78knjcMBQPMdr0bkdj
         i6mofTDVD21bxrCn2qrsF6/ZM5F6AG/PtOnjbNgjZjDFFTzA+pp5DQUFL91v9mwNdKrg
         9KlR5eJb1m25NsJhf18rWWy1y5RCmIEiN0Q3nokwOo0bcVMPIQFOdbEgypQ3VGVC4A88
         Y20jYwiqSnMhAoyDCjMaSoxIHssFJ/hRvxuS93qqIMdYAUmgnLvhW5iGZWzGlmi1zT5q
         iYu8Q/4JfbkQ414gV4CUnQpHfmJERzjFRjHGL+lAH0/nBivSMrJvmW6JoTItq6Du7w4E
         IYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=csTFUpsRawa07wcmPlEmUE8R3c/8ED1fSyaPMVbY1/I=;
        b=lGhNrs5OAZffNfP0F7XT7+iSKqaCBKNUBKynZa9bNgf/cc4vdJU3rELXZlubmNs82h
         iEFbSlbxAvS5kMTFpNVJ8+llD37B2vlEs4Kpa3Y7qOOiNL0vPayK2shOsO0s9ev7MahV
         8CKZA2Qnf3YDY2KrSx5HY/mJfQLz/TD1dHphdRlgvL2081O+rLbYp2QMmaprFUm8uusm
         iUj1e2vajZ1UGzaq/qkICl/iwc4fSbNJpi0fu13YBVf2guTACYBh1DA7ja8A81Ndh+Av
         NIYl/l2QD0B+y68zHGcRWuHhnTt5BmK6toEaqpbbDAb9bpCoF6+31aa7Kdgkg9TWDedR
         zsGQ==
X-Gm-Message-State: AOAM532ZN61aZVLwwS3UHvhxi3a0edbP0v66itN0SyeGcNd3XEi0hbmG
        GqqQoEJOuX3RzsRHkro+aFvxstO59FE=
X-Google-Smtp-Source: ABdhPJzA/KxCkl9GQmyOLhOkCUX3BBpDSU1ecrOweyAwp+jRB/OA9VvOLBWyuq9yZ7lYhKOxmUTIcFoJpfQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:4cc6:: with SMTP id z189mr475227yba.453.1617749420597;
 Tue, 06 Apr 2021 15:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:51 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 7/8] crypto: ccp: Use the stack and common buffer for INIT command
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

Drop the dedicated init_cmd_buf and instead use a local variable.  Now
that the low level helper uses an internal buffer for all commands,
using the stack for the upper layers is safe even when running with
CONFIG_VMAP_STACK=y.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++----
 drivers/crypto/ccp/sev-dev.h |  1 -
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e54774b0d637..9ff28df03030 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,6 +233,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
+	struct sev_data_init data;
 	struct sev_device *sev;
 	int rc = 0;
 
@@ -244,6 +245,7 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	memset(&data, 0, sizeof(data));
 	if (sev_es_tmr) {
 		u64 tmr_pa;
 
@@ -253,12 +255,12 @@ static int __sev_platform_init_locked(int *error)
 		 */
 		tmr_pa = __pa(sev_es_tmr);
 
-		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
-		sev->init_cmd_buf.tmr_address = tmr_pa;
-		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
+		data.flags |= SEV_INIT_FLAGS_SEV_ES;
+		data.tmr_address = tmr_pa;
+		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
 	if (rc)
 		return rc;
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 0fd21433f627..666c21eb81ab 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -46,7 +46,6 @@ struct sev_device {
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
-	struct sev_data_init init_cmd_buf;
 
 	u8 api_major;
 	u8 api_minor;
-- 
2.31.0.208.g409f899ff0-goog

