Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C625CC433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35C060FEF
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 12:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhDQMlL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 08:41:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236254AbhDQMlK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 08:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqrvZ1Dkru+/UoYpNG8zNQQVDXUCtyWvIhM6uMe/QYE=;
        b=i2d2Tdbk/uZ3Dym2Qx5IoP4KgxN2FcbOBEaPtHkDlKx/LGeao5LKf+N2LkB51nihd72sW5
        FT8BxwiHOlX6TNJaw6z2H+DZ3P+OokfIPArQ/KuA4zzeStiVfyK5q/QJnGqFpIDSXmmgsv
        tp478FhmNsQeMhX3UacWyAnCod1yBP8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-7pWrw2K0PrecuuwJbtMY8g-1; Sat, 17 Apr 2021 08:40:42 -0400
X-MC-Unique: 7pWrw2K0PrecuuwJbtMY8g-1
Received: by mail-ed1-f72.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso8574484edb.4
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 05:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TqrvZ1Dkru+/UoYpNG8zNQQVDXUCtyWvIhM6uMe/QYE=;
        b=Wv60rTscZDTBsydjw6XHdMtQE729sGLi4uwgl3IyVyf4vb9zGn1HlL7owyV/BAYM1r
         quaZs4rQDCyssc7C6wzbH5kEIWA1ba8JSeMAR3xmgX/gKRgMej6aFKhMhyK65GIwtLlR
         ObvKIq+Weec7ANYY0l6JWRU5QL2j37/EJNrQyL+D0GccDUahjyy1SLi5t/d/1f48mHa0
         B94KGx7hRFeNV1/kRt19YUZUo//mYfkItd20slI8ZIS3VCDvNFyD2A+7Ibp5p/xxd1ad
         UgJiN8iIISQnEGPv1vo3RNJk5/BSOGbI4SXkYclfTCaoZ0Zs16L6ds1Seo3Nkt/7ehck
         qPZA==
X-Gm-Message-State: AOAM5315pFum0n0FE+1rvxC7B6DIvzzh0Rwclt2m3lHheJV0yEbAs76Q
        Yl6uXi4y1NCE2nqvZ3bq80HMR21IBVYGTTBMWuyHHuYjILUlI4K2zqQ9hIwM9jXcIQ1Ei3hQKGh
        OAHU9HB2yU6MYXbkQeL6nYW2v
X-Received: by 2002:a05:6402:274d:: with SMTP id z13mr15616283edd.344.1618663241198;
        Sat, 17 Apr 2021 05:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzuVNotS7UuM5iC6y6t+d4QVfhpv2hpnGhQ/F7RgY/qBafN2qn+UanZL80GrJJH3CQjgbNfA==
X-Received: by 2002:a05:6402:274d:: with SMTP id z13mr15616277edd.344.1618663241058;
        Sat, 17 Apr 2021 05:40:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p4sm7982027edr.43.2021.04.17.05.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:40:40 -0700 (PDT)
Subject: Re: [PATCH v2 5/8] crypto: ccp: Use the stack for small SEV command
 buffers
To:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <587677cf-2db1-1bed-18fc-dbbc1c1dffed@redhat.com>
Date:   Sat, 17 Apr 2021 14:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/04/21 00:49, Sean Christopherson wrote:
> For commands with small input/output buffers, use the local stack to
> "allocate" the structures used to communicate with the PSP.   Now that
> __sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
> reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Squashing this in (inspired by Christophe's review, though not quite
matching his suggestion).

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0f5644a3b138..246b281b6376 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -408,12 +408,11 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
  		return -EFAULT;
  
+	memset(&data, 0, sizeof(data));
+
  	/* userspace wants to query CSR length */
-	if (!input.address || !input.length) {
-		data.address = 0;
-		data.len = 0;
+	if (!input.address || !input.length)
  		goto cmd;
-	}
  
  	/* allocate a physically contiguous buffer to store the CSR blob */
  	input_address = (void __user *)input.address;


