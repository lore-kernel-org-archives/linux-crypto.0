Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF4EFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 07:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127E121848
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 07:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OfXQxD87"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfKHHso (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:48:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39297 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfKHHsn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 02:48:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id a11so5875322wra.6
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2019 23:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ikAnX1n97pHrRs+oFI52Nu6jtvmhINRGHyMas+0u+t8=;
        b=OfXQxD87fQ+CgLxFluj4dT5ELRfN4nI2r7b0b1MNUlEINLFKTDLC957GOrknJYpkZF
         focCV4ugZH/9OhrBJZxmu8gQDqhUINoSlu3If/0kc6AyUQLKdRc/fluaWq0MlDTX1YR4
         Hme5Q9MTXY2h7mT4EU2SCk2cP2SfHu74v56w1SrFYQzoW22HKcI9CUYza/GpDmmh35D3
         Ver6+fPCj1oRvdPMiyhn9cPPWrUd/MWLTZpFfIVbs0gVM8K9SYuG7kpD5CZwxOdo2L/n
         yh/1RM2LgLu1IwV8JNAjaZ6ZCEvOmz381KFeihnHJ5UsRJXVNr+gazfLqrOzsnNyuXEG
         cAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ikAnX1n97pHrRs+oFI52Nu6jtvmhINRGHyMas+0u+t8=;
        b=R94AuGH/TD7cvl+qAqu4ykbz/OZrzZAg+7HrIFT+Baz8evG21/DaQkbhNT4LXVIXVK
         gDvWunysRCR6kv+EqZz7J6n9PL/kqjPYUYRSYr7RhZawvwHRL9+BMTSEvR10G78SGeiJ
         nIFJ/aRP3UBgaP6i0O7bN+67MKAuUO3Y2ddgeQnmSDeUcJpYmLIJviTIPfMFLJ29isi/
         hP7YnhA3LVfgb5gKmWXHlf6dEjH2/SFT2Umcltp++bhZ0bWHl43VQqJPd1e04Vf+AAlS
         gXFVvua3P0n3i+GVFgVW4xlneNNwXmey15rSGiGIb9/NaOI+Fs3ySX3cVisVTaGRg+A8
         tWWw==
X-Gm-Message-State: APjAAAW2ICxYxWml4YEXeIx1po8iEQ9EN3nEaqe2KR3iM7wr01wi2H3Z
        x3QjUQFknD6guABBP/awRJvNzmADB8NZjA==
X-Google-Smtp-Source: APXvYqxo1T1YPUTzDNQ5bmIDkM48J8zFmYvTc8T96I3x8hptmRVD7jgMpYKmbuBIqHL6DaZ1BKcDDg==
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr4814087wrj.185.1573199319375;
        Thu, 07 Nov 2019 23:48:39 -0800 (PST)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id b1sm5302726wrw.77.2019.11.07.23.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 23:48:38 -0800 (PST)
Date:   Fri, 8 Nov 2019 08:48:35 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     zhangfei <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v7 2/3] uacce: add uacce driver
Message-ID: <20191108074835.GA3764149@lophozonia>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
 <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
 <20191105114844.GA3648434@lophozonia>
 <24cbcd55-56d0-83b9-6284-04c29da11306@linaro.org>
 <20191106153246.GA3695715@lophozonia>
 <0cad8084-8ba8-03bd-7d29-cc7ba22c29ab@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cad8084-8ba8-03bd-7d29-cc7ba22c29ab@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 07, 2019 at 09:23:50PM +0800, zhangfei wrote:
> > What I had in mind is keep one uacce_mm per mm and per device, and we can
> > pass that to iommu_sva_bind_device(). It requires some structure changes,
> > see the attached patch.
> Cool, thanks Jean
> How about merge them together.

No problem, you can squash it into this patch

Thanks,
Jean
