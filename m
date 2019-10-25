Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB18CA9EBC
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2678221D71
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:04:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DVFJVAku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406105AbfJYHEj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:04:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35709 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406111AbfJYHEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 03:04:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id v6so839284wmj.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 00:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=O+tNoeo7hAfUizkaPOI8/abyUdx+v+Co+syiVJFepPg=;
        b=DVFJVAkuo3g9Yp1Ux+WgPsK3AU0Pq9woqz1WO0SkMX8gt75R3QrFY4h7fCaNyWPoRU
         z5T52wXXCAtDGVgapk2+aXOcugz7s095+94YJpLDb4vLocY3wjuT9xcgKzokPsyvvgHh
         5hwemuw8dQ3UMtVnfTsVX0F9mBCcln8jWWAHxJgaGpPq5Cp3UvWVHm0LzqcmxkmK5AxL
         2DznUlT/ENdMS+uGHLVNaTPx/6TTcljhulAgDcJ5neS5mgP/aK2iC3sfj6+lN8GWugWq
         eiVjcmKos44OEZM2NUVQ6DQOT704X4U4KnLFRuPaBLzxf8YLchhzFJwbAfKuhhbz21aR
         bvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=O+tNoeo7hAfUizkaPOI8/abyUdx+v+Co+syiVJFepPg=;
        b=MkV7oUK/yOidiu0l8JdHyBwPCQkM4dkU3bzqRNxqN25nXbhvCiQ3Z5wb+cqqMYmfgb
         AKMwYxpjO9Ci2txMmgVTjFV1ieN71AflFZyV+7Ge6hAVV11TZvo72jxBZ2PoC/GQq9Jt
         fJVN6IKUgI+qMKbEmAqyCV33DGji2H57fb65kMfjoZyJGwm/JDiKzJIhsLc5KHIdrm1F
         NuSFsUHAxN3e/kPAucif234Yay/GGLxYABCz56HdJDgAGAAUuaG3n9H2LWJo02TLX69T
         c3xge7+R2LiccavNBhdDqbzCetmB7uKJuIwrrnZphiEfA9WUknzWiCw0AkZaYpaUg5rj
         Qqmw==
X-Gm-Message-State: APjAAAV6Ye1jOCBqhdN+HPwVU1dFmBny2uWSTy97VPA1nSJzHrzQYrn5
        rNghDziKvY1zHLm1HCT7UbCNwQ==
X-Google-Smtp-Source: APXvYqwkzL8PE5dfm2PzD00/6vEusOccrt4kNHVfvd7dli/2l9XdzOExgarmzdmLnGldIgOH7alTnw==
X-Received: by 2002:a1c:9dd3:: with SMTP id g202mr2026082wme.43.1571987076112;
        Fri, 25 Oct 2019 00:04:36 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id b5sm1121600wmj.18.2019.10.25.00.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 00:04:35 -0700 (PDT)
Date:   Fri, 25 Oct 2019 09:04:33 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        francois.ozog@linaro.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Wangzhou <wangzhou1@hisilicon.com>, grant.likely@arm.com,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org, kenneth-lee-2012@foxmail.com
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191025070433.GB503659@lophozonia>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191016172802.GA1533448@lophozonia>
 <20191023165814.GB4163@redhat.com>
 <5db257c6.1c69fb81.bfe34.a4afSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db257c6.1c69fb81.bfe34.a4afSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 25, 2019 at 10:02:36AM +0800, zhangfei.gao@foxmail.com wrote:
> > It already exist it is call mmu notifier, you can register an mmu notifier
> > and get callback once the mm exit.
> Currently we register mm_exit for sva path, as suggested by Jean.

Yes that's called from a release() mmu_notifier callback. 

> static struct iommu_sva_ops uacce_sva_ops = {
>         .mm_exit = uacce_sva_exit,
> };
> iommu_sva_set_ops(handle, &uacce_sva_ops);
> 
> Still not certain do we have to register mm_exit for both case,
> sva and !sva, since it is a common situation.

I was wondering about that. For !SVA, since all DMA memory is mapped
through mmap, you'll be notified by the vma->vm_ops->close() callback when
the mm disappears, so I don't think you need a mm release notifier.

However that callback will just remove the IOMMU mappings and invalidate
TLBs, but the queue might still be running and since no fault handler is
registered, the IOMMU driver will flood the kernel logs with translation
faults. Similarly, the user can simply start the queue and call munmap()
for the same result, or even just program the queue with invalid DMA
addresses.

What we could do is when !SVA, register an IOMMU fault handler (the shiny
new iommu_register_device_fault_handler()) and consume all faults
ourselves. That will at least prevent userspace from flooding the kernel
logs. Even better, as soon as we get a fault notification, we could stop
the queue associated to that DMA address to prevent further faults, though
we'll still receive those that are already pending in the fault queue.

Thanks,
Jean
