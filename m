Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57447C432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 20:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F3A60F35
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 20:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhHPUZY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbhHPUZX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 16:25:23 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5407C061764
        for <linux-crypto@vger.kernel.org>; Mon, 16 Aug 2021 13:24:51 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id a3-20020a0cb3430000b02903432d100232so13681856qvf.16
        for <linux-crypto@vger.kernel.org>; Mon, 16 Aug 2021 13:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=g9/o/9z4zsHt0A4xliRLw6qm1WgAQq/NIv8diVlT8V8=;
        b=Na3X8WB7HU4+Q6rnHbcbEUye2yyaMseyJnz+LAjXQqSHQ88sIut7dcBkUtIvj5yhwc
         Qh9OamjchJgGSoPW1u+0tow9mQJgUyZa+mm9ZTwwnTkOCfgvVpqx/U0Nchu8VA+SpdBq
         nH1pUu/wDwfzNKECulGVxKPyIpva3VxJ97CmiP7zHpT0fsO6DeRWlR1BPb9LusFYUGKF
         zemhX6whtx4nl7UcGBgmYqbxxfadoJFdSBrHA3Hn+PjKHP3Vw4zPyURNaT5XDwpIZl1K
         fWJZtzTAb3p/oAriDfOGX8Qv7HEV0vRtryfhpjq7LEVn0iDeCXMebHWwDq1D2ozwKtwc
         I7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=g9/o/9z4zsHt0A4xliRLw6qm1WgAQq/NIv8diVlT8V8=;
        b=udfqYp49c1VR76U2uPkJI7sywDiaUhUxhgWDw3KYFnxkMHP/Wv1npctfxtjiGZcRvo
         QC/l+mNNynL8Zm1S7J7QJndw4+HH1RHWChxICBHB4m1KJPnfVrzgSzcw8o6OZL5LxLjb
         KjtATbNojIrWRHsGiM2AJqw7FP6XGVSqJztljp3n+MMtJChYHUHigzruBgrCLFwXIqwC
         Wew56UG6NWZyTy+VMGDwH2xV5ykO+tAYzkLvUpEL9WCAUuX5a3V9R1+IfX9L9/E6SiAI
         15w5E2+/7vRTZniD8lPN+PbueBws0ZDGL4nVx6PIbMoE2UQCyPovjqA3fu+94IUqsRWw
         3L5Q==
X-Gm-Message-State: AOAM531akHpxOtyO9+bkimnZVFPgJCgy+xoEoiEpj+fhMDOzy/dodXOn
        hSXuyLdATvCsV4ZDtLWHfQMtubEVRw1v
X-Google-Smtp-Source: ABdhPJwyQSwjPkR0qaUuTjnATtBd/G0GgK4bzkRXvZ/+QgTGS2i6L2iov1MK4VgKXMwVdCMhqbzs5CiyzQUN
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:ad4:5dcf:: with SMTP id
 m15mr560462qvh.35.1629145490981; Mon, 16 Aug 2021 13:24:50 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 16 Aug 2021 20:24:38 +0000
Message-Id: <20210816202441.4098523-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/3] clean up interface between KVM and psp
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

This patch set is trying to help make the interface between KVM and psp
cleaner and simpler. In particular, the patches do the following
improvements:
 - avoid the requirement of psp data structures for some psp APIs.
 - hide error handling within psp API, eg., using sev_decommission.
 - hide the serialization requirement between DF_FLUSH and DEACTIVATE.

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

