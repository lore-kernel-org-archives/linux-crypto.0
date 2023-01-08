Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C219AC54EBC
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Jan 2023 22:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjAHWt3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Jan 2023 17:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAHWt1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Jan 2023 17:49:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6532B637C
        for <linux-crypto@vger.kernel.org>; Sun,  8 Jan 2023 14:49:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso7497465pjo.3
        for <linux-crypto@vger.kernel.org>; Sun, 08 Jan 2023 14:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2EwBkT4ghB1jNt4S3UOpy3yeEZLhAzU9lSbZIAM7I4=;
        b=IjbxJtzUDxQwTlGXvZfUXOkwvqxSafaHnYeSIIG1WzG669+JyAc4qXN/gkvArxh5SD
         KsO/Gv3wxOSLuyRYLl7m++Sq+g2drIqTdrxHsBlUpfTotBCSHg6+bVEfSVH1azliE2T6
         kMuxAfKCDqnPkj6ErNSZQcpYqqgzNbw1dL0XfJp7+zFUEPB+EvTlPWcm9HtX7LUVmzhd
         ByL2BLxvkd6E8hMF+wBGoDQ8BbnAEINIRyGfhoWVJejIo8RthJBu2RF2L6c+QtHw++DZ
         CTAC17nlepfakuYDSfZnfsWM8iXclE/CuFhCDYSVdCMCN+ZnCAMp5X+ACqqFzjacfUKi
         t5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2EwBkT4ghB1jNt4S3UOpy3yeEZLhAzU9lSbZIAM7I4=;
        b=wZUhfmpr+W6T2l0bnHA0YIkgcUulJKHsXjEQJM+hq8AYGWXq7m9hwlMoDpHexUNn7f
         AmlXiDdLwPzdvk6ravlCWDZVkuTxWg+/jpp9F2fuwbAE4i5Gckaw2hJJCdaWdZo2YNlM
         I38rvfP5MFmXt6/PdUS6/y6b+K5P/TVTOxc0xWNOFxhy0CCYsQhtzRGM5qdUH/xL3kpo
         9fpYf7v3H2y3aWrahEyInp96u5Ec9XN1Tztv1hl1flG3c3lLfRj/zsSZ/OvWs0meZFZN
         abCSHzTfSUrDNS3MIE08U4hk9yYN58kdU8/YdfKspbIPkX2jo9ujySkQmskqI8cpHT5C
         Vb5A==
X-Gm-Message-State: AFqh2kp6RYUZzrJoCrBhm6iMCpHj1UniD5SrFD7aIBd0WCZmfgNcic2A
        N5YmqnLplyW0CiEIBQFMEogjrQ==
X-Google-Smtp-Source: AMrXdXvFomA3pBImLcMEFvQje52p88TQ7bSKJjQem9k+a9RDK9TT4WhVZ39yoEM1TO2IIQGIx51y+w==
X-Received: by 2002:a17:90b:3d03:b0:226:59d6:8219 with SMTP id pt3-20020a17090b3d0300b0022659d68219mr393178pjb.0.1673218165776;
        Sun, 08 Jan 2023 14:49:25 -0800 (PST)
Received: from [2620:15c:29:203:dfeb:5ed2:4968:d28b] ([2620:15c:29:203:dfeb:5ed2:4968:d28b])
        by smtp.gmail.com with ESMTPSA id r23-20020a17090b051700b002271f55157bsm22569pjz.9.2023.01.08.14.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 14:49:25 -0800 (PST)
Date:   Sun, 8 Jan 2023 14:49:24 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Jarkko Sakkinen <jarkko@profian.com>
cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp: Sanitize sev_platform_init() error
 messages
In-Reply-To: <20230108202407.104963-1-jarkko@profian.com>
Message-ID: <30d6aa4c-3af9-9e4c-748e-c7378b519504@google.com>
References: <20230108202407.104963-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 8 Jan 2023, Jarkko Sakkinen wrote:

> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> However, only sev_pci_init() prints out the failed command error code, and
> even there the error message does not specify, SEV which command failed.
> 
> Address this by printing out the SEV command errors inside
> __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> INIT_EX commands.  As a side-effect, @error can be removed from the
> parameter list.
> 
> This extra information is particularly useful if firmware loading and/or
> initialization is going to be made more robust, e.g. by allowing firmware
> loading to be postponed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>

Acked-by: David Rientjes <rientjes@google.com>
