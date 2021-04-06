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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6619C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFBC613D4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344268AbhDFWuZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbhDFWuT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:19 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449D4C061761
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:10 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v136so13604431qkb.9
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rbJKuZiYmoPztANxesWQ34dxBaTXzqRp8iyZHN+wEGM=;
        b=nAKAuPL8B+BdMLeg3F3EAJJ5PNzAtP7SbEN0VteWmXGIHeiK0Vq4YArK0VahJJo7I8
         6X0PqiNu5YzhkVeNZ7T8gQofgQAJuimJ26X2/4FdbkEwRVIG14txaPcJxGJ5UF+dOF6+
         I1toJgcJaO5y/dhvYCJ0a3na0F8JLZkmOQ6XDdSfALJ8/G0QGWoHGOsQO3zxCfgrM9Te
         vBsPm6RoAlnd52uD0yGE36Kwhp0AHyEYg1+zBcdYGygwmlncS48emDP3tDbxVKjs6bDe
         /svO2xmQG8rYo++QHEBBNz+CXAP3ZfRc7fiTR8Vcd2hWPKz0O2fSDtMcj2Wxa6NuEIr8
         ZraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rbJKuZiYmoPztANxesWQ34dxBaTXzqRp8iyZHN+wEGM=;
        b=HyNc7NCeghqCJb4RAKkGpjVpwPZmOgQKOX2ddAA2kRG3pXlDcrngv6uKx696XC252C
         kEgt2BhVtaJasbteZpW7GsHs/r2tPfcmKlX/XQoOHdEr+CI4Ag+l0d7DS/gsGG4p0Kju
         fphRR0wLx+bdRKajRvWvelTtaWhDZt86ssYijkRB0rJj+sy0a0O8IMVmvwBS66J3CKg+
         9FhUSzFO8JxZwjfETH5hxwf84k/atGgTGEXweTnbcwoV68VDq71dxOLAWDqDbQuZxRE5
         MK9Ujdq3UvaaDKv/olJyGMNa50Mb98nr0ekpZoRnSIZU5Hs/VCe8Uub19vcRNKPLLNFI
         2vzQ==
X-Gm-Message-State: AOAM530vsTj8du+nzBU8fQiqqoHMVAfzOqmz1HKRMNlc1ZVuZxNM1imV
        m2XcT2ei2/Aoz24O1QJNyTaSxor72B8=
X-Google-Smtp-Source: ABdhPJwm7pfZujrg/BIGog4XctMHpyiLl3E+kj+Fx4XTnJuxbhBHJLrsXv4TuEif/H0+XTkkCPk9cb900q8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a0c:f30a:: with SMTP id j10mr528109qvl.20.1617749409335;
 Tue, 06 Apr 2021 15:50:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:46 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 2/8] crypto: ccp: Detect and reject "invalid" addresses
 destined for PSP
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

Explicitly reject using pointers that are not virt_to_phys() friendly
as the source for SEV commands that are sent to the PSP.  The PSP works
with physical addresses, and __pa()/virt_to_phys() will not return the
correct address in these cases, e.g. for a vmalloc'd pointer.  At best,
the bogus address will cause the command to fail, and at worst lead to
system instability.

While it's unlikely that callers will deliberately use a bad pointer for
SEV buffers, a caller can easily use a vmalloc'd pointer unknowingly when
running with CONFIG_VMAP_STACK=y as it's not obvious that putting the
command buffers on the stack would be bad.  The command buffers are
relative  small and easily fit on the stack, and the APIs to do not
document that the incoming pointer must be a physically contiguous,
__pa() friendly pointer.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ba240d33d26e..3e0d1d6922ba 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -150,6 +150,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
+	if (data && WARN_ON_ONCE(!virt_addr_valid(data)))
+		return -EINVAL;
+
 	/* Get the physical address of the command buffer */
 	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
 	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
-- 
2.31.0.208.g409f899ff0-goog

