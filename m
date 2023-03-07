Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17E0C6FD1E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Mar 2023 23:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCGXmj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCGXmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2023 18:42:38 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0500A95459
        for <linux-crypto@vger.kernel.org>; Tue,  7 Mar 2023 15:42:36 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id ip3-20020a17090b314300b00237c16adf30so142871pjb.5
        for <linux-crypto@vger.kernel.org>; Tue, 07 Mar 2023 15:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678232555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqzrjtunBCbTiG/9hLGZPz4HpJ6gvwCBlEocXHjYpgc=;
        b=BVf//gG8V71fiiDyfQ8szqCJ4bPgO7DaUm8HJJeelmc7d3Ds9PorlXTBXqfj5tMMNV
         z09vFhbJ4QjN/CU2ZSUhTRHikpPlTSK+EaJVWLb3roygPLeCUV0KXD/Diuh8QkiCadOt
         bH2E45Az1vag7vGPFljLbj5mRe6VAtWdo0Dy+y6ViSvhY8QS7RVt/eV9eyoZMY5sVC1Z
         FlOUGwA08Lc9OOiAuWHNDEcrzin4G8yyIWTF2CWSPuk8EMq7eF01Op8VG46MFFDus/n/
         4wotVknXaiPlF0jq7ZXvMcMpVGXqCNY2+xTzv79y6iXlcNUygElR1376y7sqwAxhwd2j
         ELzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678232555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqzrjtunBCbTiG/9hLGZPz4HpJ6gvwCBlEocXHjYpgc=;
        b=Kdn4SUUzVc1yMgYjICD6BnyMeD/RH2/Z94aSTdoUwT779ejUmPa9VHYHo1fyN5F5rC
         ZHohmfusBVUZzKV9o3edzWMCzI6WK6wbxPv9Be3G/vny4ztp0pHssVYuT2l+BUxYUnQ3
         OY2LQhwvMdxpyuvgwO0Xy5O9jOPHQ7y8n4GbVi+vClPM3FWTSdQ6odM06+wM3B7sGsFd
         pjv81Dc9ppLwsexEe9TN76ctcRGz9v6mSB/AemXiUcX/VkWg35SOivRYtXZx6BVEtoLU
         Ut5O9PwCpVBOPCTny/Csn2rBb7UQwj+FnyXc5Xry8K3fg//joFZK6WlMoqoZidpl/N5Z
         Pw1g==
X-Gm-Message-State: AO0yUKVQaJDqB6HwEt1fSfmPaK9A9DeZ/e95E6fWsbZjo9eis0opc5Dc
        ym6X0+gaKHQ6iYxCRPjUHuFNx2w8YFI=
X-Google-Smtp-Source: AK7set8Z3jueSenBo8cEWwdWq3U4Z/X1tE6ANTZZWfxuL+FcDB0ZeH55jX9W6vlqIO+zJdj0BIGfAjJfTe4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:e40e:0:b0:5a8:a56f:1c3a with SMTP id
 r14-20020a62e40e000000b005a8a56f1c3amr9036088pfh.0.1678232555455; Tue, 07 Mar
 2023 15:42:35 -0800 (PST)
Date:   Tue, 7 Mar 2023 15:42:33 -0800
In-Reply-To: <20230303165050.2918-3-mario.limonciello@amd.com>
Mime-Version: 1.0
References: <20230303165050.2918-1-mario.limonciello@amd.com> <20230303165050.2918-3-mario.limonciello@amd.com>
Message-ID: <ZAfL6SK0jMtsAhGv@google.com>
Subject: Re: [PATCH v3 2/9] crypto: ccp: Add a header for multiple drivers to
 use `__psp_pa`
From:   Sean Christopherson <seanjc@google.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "Jan =?utf-8?B?RMSFYnJvxZs=?=" <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, Rijo-john.Thomas@amd.com,
        Thomas.Lendacky@amd.com, herbert@gondor.apana.org.au,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 03, 2023, Mario Limonciello wrote:
> The TEE subdriver for CCP, the amdtee driver and the i2c-designware-amdpsp
> drivers all include `psp-sev.h` even though they don't use SEV
> functionality.
> 
> Move the definition of `__psp_pa` into a common header to be included
> by all of these drivers.
> 
> Reviewed-by: Jan Dabros <jsd@semihalf.com>
> Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com> # For the drivers/i2c/busses/i2c-designware-amdpsp.c
> Acked-by: Sumit Garg <sumit.garg@linaro.org> # For TEE subsystem bits
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com> # KVM
