Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D732FC43214
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF83861076
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhHRFjv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237588AbhHRFju (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 01:39:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F2C061764
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso1687694ybh.12
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=EL7jI42wrcLkhbmMyq077rvusMQzj734dq/iBhF+pY4=;
        b=t1Oy7svnangJBn7uKTFsIDqALT7f36cJQs9eDhJj6+ACeFlU4o7xJas9Oxg0nOtfkM
         lz1fthLqySQlUaikmUMmxpqvlukB5gBWU7X+yxuTnAT2HcUXrjz/AWk00fd85QErNqh+
         MXo71I6MNGnf7HcEosKmjcyerhvgTaWpc3T0yaB1wb6jsY0ICBjQLuFYf4L2mvsfst3O
         EBsNWe+mHZQw+NGaNNTmq5h77lp77JUQWTp84Wovhl+4KOcIq/ozHtldBfmoeBuYza0+
         dtOSc40y6JczuK/cNtmgRZIfCv5wyTlIN5d4KrMW7b7SJ9wXNq2771EmSJdKXClwZozq
         WG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=EL7jI42wrcLkhbmMyq077rvusMQzj734dq/iBhF+pY4=;
        b=R5fJcN0TlWsWSwaoHdaJwNpXduOOanh1sBhjYShKEZMHZQkdWCKM6TmqQJ6kiBx4Lc
         TamaslGWdevYkChyCsUN1DT60OodN4QmW5IGfbbSA5jH2drwW/VaBWeqoFO28R6BwrTk
         FpDeiD6tV3OGN8fYbSjIBuccovZ7Ovi4mTMAUeFAqVmdCnzEWn+ZluZ7iOGLMPcjK+zd
         vc5SNGHZED3QTpVKbRp5XNKT7n2J3o7UgKUDcipI5RAxd/ELqrU3G7nKJ07H6a2t0gAu
         kl+W1IBm2VdusVpAMjn6lJSThdg8L81fU4u7Szss5qXPuJnuLVakwmpNrKka1onzYzR1
         l9Yg==
X-Gm-Message-State: AOAM532/6H5oy2SIBeu9H5zE3Cly+O/i3ykPVMI9ff51u5wWwdmHq7z7
        YBiycpXg1hpS9P+muVWjT/PiAxQJ3pY9
X-Google-Smtp-Source: ABdhPJzGOI7bhhcVw1EL0ejePMf38jIvDPpMHXEsV6CYhN1qr08tJkuKcbW4oDjkqO5s6KHVj+u+uxOoKWKq
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:a109:: with SMTP id
 z9mr9030673ybh.279.1629265155304; Tue, 17 Aug 2021 22:39:15 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 18 Aug 2021 05:39:04 +0000
Message-Id: <20210818053908.1907051-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 0/4] clean up interface between KVM and psp
From:   Mingwei Zhang <mizhang@google.com>
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
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set starts from a minor fix patch by adding sev decommission;
the rest 3 patches are trying to help make the interface between KVM and
psp cleaner and simpler. In particular, these patches do the following
improvements:
 - avoid the requirement of psp data structures for some psp APIs.
 - hide error handling within psp API, eg., using sev_guest_decommission.
 - hide the serialization requirement between DF_FLUSH and DEACTIVATE.

v1 -> v2:
 - split the bug fixing patch as the 1st one.
 - fix the build error. [paolo]

Mingwei Zhang (3):
  KVM: SVM: move sev_decommission to psp driver
  KVM: SVM: move sev_bind_asid to psp
  KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp

 arch/x86/kvm/svm/sev.c       | 69 ++++--------------------------------
 drivers/crypto/ccp/sev-dev.c | 57 +++++++++++++++++++++++++++--
 include/linux/psp-sev.h      | 44 ++++++++++++++++++++---
 3 files changed, 102 insertions(+), 68 deletions(-)

--
2.33.0.rc1.237.g0d66db33f3-goog

