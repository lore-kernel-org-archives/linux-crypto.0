Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DF6C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC73613D5
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344152AbhDFWuP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344128AbhDFWuO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D38C061756
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k15so15465529ybh.6
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=29qkvQNMyHwLCHP8pXWRgWswaf/k2g0dTyIZhsX4Pvk=;
        b=mUCDW8goB/BkfT+GMgye4Lbl4vbr0CWjFY7SeZiXn3jP2soqTvTb9NToTJe9mZv29V
         697bWQTz0SxGedUF1HwLD0JFxJvs20ZajAvN5qgCNhk+5Wkyc1TqJZjxJ4O+0Y2u+937
         wy4sxbq50hDa62jBWPsHBBDxUDYKJapcfE2lO37hms0Sm0NsKUBuf+St+Gb5/f42Ezml
         eAe2CumEX7m0PTiQSq7OEXrbZ0w8TP2hSA9KfCv+DP0hI4IDeeFuVplbD7HFe4QuL2Y9
         7l5yJmN9dl/lx9CQDk5TGNWLKUv3ZvNrHWqkDon/XSBNVfX4Lz4zdf5HoQgI2n3ZLhVr
         /9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=29qkvQNMyHwLCHP8pXWRgWswaf/k2g0dTyIZhsX4Pvk=;
        b=YrEDxYzI7USIyefDMrJItRkD9ioEpYsRUXSjzdBxVhbramCS6JJ617zf+/axyNrUGt
         H/3dWLFG2H/yhA0eVhlPcefoh7V46xBB3PFBTt3dXGAuqhgOyEQh/FVYOVPJqSMt6vs1
         femyhkQqHuzRIq1rH9BgX6X5ZLQ4SSmfyyF0K8mydBxF5TYb5VkOsLT0r1MTMyeIrxh7
         nJ06fiI7PYF7AYC/miTeXt97k+7Tb8Pv+Af3vfiAna/CxA57MMH/XUoF9koOF+zvQSFF
         X5WlXzbfkXxzV+g73Lzwqb7hKxLbRp1fzH5ecObQntBgmIGifV3eiwWDGMDIWVZln8vu
         OZpA==
X-Gm-Message-State: AOAM532OB4QsJ0jWTaCsbW+LnNNtgQNZQmLaSfwFREcHEyZ1xMzqGm30
        LXDrrZlIHm+mg3JlgLBhw7Qb8j05Ozc=
X-Google-Smtp-Source: ABdhPJzRouXKIhQs8EfMqHUio8a2b3cN1QJZ0wcW2fPXd72cKuXtNJvbuk4wCZqugfRujJJGfODyK2fcLA0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:2351:: with SMTP id j78mr536179ybj.102.1617749405370;
 Tue, 06 Apr 2021 15:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:44 -0700
Message-Id: <20210406224952.4177376-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
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

This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
command buffers by copying _all_ incoming data pointers to an internal
buffer before sending the command to the PSP.  The SEV driver and KVM are
then converted to use the stack for all command buffers.

Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
near enough about the PSP to give it the right input.

v2:
  - Rebase to kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
    sharing SEV context").
  - Unconditionally copy @data to the internal buffer. [Christophe, Brijesh]
  - Allocate a full page for the buffer. [Brijesh]
  - Drop one set of the "!"s. [Christophe]
  - Use virt_addr_valid() instead of is_vmalloc_addr() for the temporary
    patch (definitely feel free to drop the patch if it's not worth
    backporting). [Christophe]
  - s/intput/input/. [Tom]
  - Add a patch to free "sev" if init fails.  This is not strictly
    necessary (I think; I suck horribly when it comes to the driver
    framework).   But it felt wrong to not free cmd_buf on failure, and
    even more wrong to free cmd_buf but not sev.

v1:
  - https://lkml.kernel.org/r/20210402233702.3291792-1-seanjc@google.com

Sean Christopherson (8):
  crypto: ccp: Free SEV device if SEV init fails
  crypto: ccp: Detect and reject "invalid" addresses destined for PSP
  crypto: ccp: Reject SEV commands with mismatching command buffer
  crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
  crypto: ccp: Use the stack for small SEV command buffers
  crypto: ccp: Use the stack and common buffer for status commands
  crypto: ccp: Use the stack and common buffer for INIT command
  KVM: SVM: Allocate SEV command structures on local stack

 arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
 drivers/crypto/ccp/sev-dev.c | 197 +++++++++++++-------------
 drivers/crypto/ccp/sev-dev.h |   4 +-
 3 files changed, 196 insertions(+), 267 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

