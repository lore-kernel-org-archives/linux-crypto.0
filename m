Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F93ECDB465
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 23:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjJPXMD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 19:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjJPXMC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 19:12:02 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C129B
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 16:12:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so3107a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 16:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697497919; x=1698102719; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=INYfmMsWN7edn0Gii+wE0NftUpFkex0ev6KVgsT42SE=;
        b=jUVK6HZ4l5ETNvgBmZtncQIr8LuHKjwqSKgMa9/VDcnM60uur03jGYWIfs0ZA9mjCt
         eKjJB0pVgfgnFff5SadMLCLM5GblCOYHe+JY75lUot8BKoA+XckpOtFakAvYxPsbe24u
         Wo+hEV0ZbsgxxhQMSRrGQ+GgJ+eGvNhNXsyjOLbviy5VWQMtX3+DFxwnYBZ0QY18Pfkt
         0TZPmTu2BxQQ6r7trBOZRLv+ECookiqqp6GFIX/o2niiTGEzY5BtdAru0YQgRXgzBvNo
         vzLvuNIjkrnixjwRc8E4TdUFnGL/0Fr1k8+JdiGm2PoGTdtouoT9z8QwOwoPIzDU5giE
         jMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697497919; x=1698102719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INYfmMsWN7edn0Gii+wE0NftUpFkex0ev6KVgsT42SE=;
        b=Nt2Tm9hnMpjMvqKaEw3OT/dfj5qLa9g9Nq/qi9GbzSUc9bMVoK73e8hkcS9MBHXa/e
         TN1ErVScx5+SPpwxImv1BehZqhLwYYJQR8G0mI5FPLiZGjSTWVcXH6keTKds5yqpxLQL
         jWijQVEl4tWSryLFGn9Q6KLnSAt6DbsdUUY/35jmadtaRk6AaAM7s3hy0mbQL5PwP5tX
         qL1uhfuISI0PU/yEKeMbcv/6R9xaVO3xGDG18wNpqCYwXQMZgNfBHP8Tscg9Xxylwxj0
         ekqFeP1vOv07MPtYK4k7g6kN2b/lWH2ShexFsdWrqhsK9SAWVsve0qiQXp7vLFyYxpxs
         abXA==
X-Gm-Message-State: AOJu0YyY13X7gemWWzI5Vm6imDyycgE4qn5Smq6+z/KGZN1yDUIlsNb+
        hAf+lPgDCdGKDL5hx56DpkC8/m0+deHMfGjY+D3R1w==
X-Google-Smtp-Source: AGHT+IG1cYwz5bu/5ZgBzdw9ECTZUbCA2/P7RKfZVDqe7dVEa7NHVFBLtd0yrRKFg2ZVXhodz1Qj9XcCQ0fTbqf323w=
X-Received: by 2002:a50:c31b:0:b0:538:5f9e:f0fc with SMTP id
 a27-20020a50c31b000000b005385f9ef0fcmr56602edb.0.1697497919196; Mon, 16 Oct
 2023 16:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com> <20231016132819.1002933-47-michael.roth@amd.com>
In-Reply-To: <20231016132819.1002933-47-michael.roth@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Mon, 16 Oct 2023 16:11:45 -0700
Message-ID: <CAAH4kHYiV5M+LK1Za02pC3u8hG8e2utybadxZPG94q12YsnSBw@mail.gmail.com>
Subject: Re: [PATCH v10 46/50] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> +/**
> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
> + *
> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
> + *             reported_tcb does not need to be updated.
> + * @certs_address: address of extended guest request certificate chain or
> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
> + * @certs_len: length of the certs
> + */
> +struct sev_user_data_ext_snp_config {
> +       __u64 config_address;           /* In */
> +       __u64 certs_address;            /* In */
> +       __u32 certs_len;                /* In */
> +} __packed;
> +

Can we add a generation number to this? Whenever user space sets the
certs blob it will invalidate the instance-specific certificates that
are settable in KVM.
The VMM will need to weave the instance-specific data with the new
certs installed at the machine level since we're not adding
interpretation of the cert blob to KVM.


-- 
-Dionna Glaze, PhD (she/her)
