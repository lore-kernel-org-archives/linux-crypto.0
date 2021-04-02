Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B48C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 23:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F7161178
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 23:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhDBXhT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 19:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDBXhS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 19:37:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B8CC061788
        for <linux-crypto@vger.kernel.org>; Fri,  2 Apr 2021 16:37:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t5so10742439ybc.18
        for <linux-crypto@vger.kernel.org>; Fri, 02 Apr 2021 16:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=xjVYK5mNQJ2/NN13VjJsOwPYAqepZgVgkk4SOaWm23E=;
        b=mqHeXZZ1B+Tm9h5UK2oztRPPQmzo7n1Fqx3Nx3sIENEHEfue7qDlNvha1zfD0T65nu
         HXzHhU0ZxJvDaW1xqMfkX/tGpIxCr2CSoJDpCwRuUKESNfkcQfmAyWo+hvaYv4iGr3B+
         97ZpXzK2pBA03CZznn+Bo4jT+UpvRhaNiazlvGqxIniysJqiHcIDGeXJPSphv8jIShyU
         v4izN/skFvnVuOrOMOt0M2+LjEtP4qk/fmqFs+vXL1eWVRPa0wmn+X0cJthKKzFq5+ig
         0RutQwQNeWIHMrOJbhBATnbC7IHrez2K0rySEQlQh5+EVLc7KdYxzBSrTCuw3REPfhbD
         RZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=xjVYK5mNQJ2/NN13VjJsOwPYAqepZgVgkk4SOaWm23E=;
        b=SAAnHlVb0MxyWv+6xxfa+BH69AifJK4L/ncSGSfaUsxm/Irto8MA7iROzA9rPL5r3j
         04YgxtxU5JW9DAtN1s9NXPG21Ikjv9y4qcQ/xCMew37whrsPO6SutSnYDKP/+RVEEOKp
         h1lkjDl2wFoAagYMo5F4TusmU6mmevZRYyy2Xp6xPp38cv6RPG722pbhlypbmCVD5WSw
         9CRrhBi57tJW6DlEjnH2w0eWapyIsPmUMKjPYPPFSYnIEr+HdPbUFiVKfQkZiPI8dT58
         9LuT5u2l1eto3dyMoS/xp8zPuxolOTPEkXm28YdOiopHRyze+WsBRroEkHeFVQ8ad/Wr
         wI8g==
X-Gm-Message-State: AOAM531D0DHwU7XAZhp9kUa59eqiMAPlYqPzso+Z5s5e1+A7CmbPaGrv
        xJpOKqNgTr8n3iQCexFyNsikTifepzY=
X-Google-Smtp-Source: ABdhPJwpzJvoUPM2VsTADsMCMUhBkIOf35+jqXhTBG7gS47Dz9zpQwjAxOQohrn+9EEBxcYlKKuTgGAKjwA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a7:3342:da61:f6aa])
 (user=seanjc job=sendgmr) by 2002:a25:e085:: with SMTP id x127mr14625429ybg.343.1617406634068;
 Fri, 02 Apr 2021 16:37:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Apr 2021 16:36:57 -0700
Message-Id: <20210402233702.3291792-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 0/5] ccp: KVM: SVM: Use stack for SEV command buffers
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
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While doing minor KVM cleanup to account various kernel allocations, I
noticed that all of the SEV command buffers are allocated via kmalloc(),
even for commands whose payloads is smaller than a pointer.  After much
head scratching, the only reason I could come up with for dynamically
allocating the command data is CONFIG_VMAP_STACK=y.

This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
command buffers by copying such buffers an internal buffer before sending
the command to the PSP.  The SEV driver and KVM are then converted to use
the stack for all command buffers.

The first patch is optional, I included it in case someone wants to
backport it to stable kernels.  It wouldn't actually fix bugs, but it
would make debugging issues a lot easier if they did pop up.

Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
near enough about the PSP to give it the right input.

Based on kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
sharing SEV context") to avoid a minor conflict.

Sean Christopherson (5):
  crypto: ccp: Detect and reject vmalloc addresses destined for PSP
  crypto: ccp: Reject SEV commands with mismatching command buffer
  crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
  crypto: ccp: Use the stack for small SEV command buffers
  KVM: SVM: Allocate SEV command structures on local stack

 arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
 drivers/crypto/ccp/sev-dev.c | 161 ++++++++++-----------
 drivers/crypto/ccp/sev-dev.h |   7 +
 3 files changed, 184 insertions(+), 246 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

