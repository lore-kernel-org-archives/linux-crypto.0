Return-Path: <SRS0=o6su=76=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952DBC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 09:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71DDB20882
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 09:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UbutnNHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgFQJcg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jun 2020 05:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFQJcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jun 2020 05:32:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7375C06174E
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2020 02:32:29 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so1581792ejb.4
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2020 02:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cTmd5tX6YVYoIxY4tpUy+apEsuQqZLQPN2tP1qBmaWs=;
        b=UbutnNHTQwhmHowciBnS6G2F8ot4diXcsL2QMDte9vC4ANIEyGGtivu1J6xAobtx0l
         LG6+/q0CKuQhAUeehhOYn/ssnfAkMft+pGrNKiUyMcadMPsNf6SHPWMIqtqEReKqauwA
         DBH5tL6/XGPuA+RqoWP6waLtpNQrn0YKnyJ5kAnkLAcT2G+540YKljKU7joTcoy6Zzds
         K8p1U8PR88QXqO67erDw6E11SM42uV1S9b2OIwPyXK8ILyYP81IIrXi3mBJOoiVX7ksp
         NoOewQ7GoqzZ40VrhkW9eU4r07QVk2amn6UFFZ6v07P2n9uwqktaBwI0sEkgCDEyfuPE
         XtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cTmd5tX6YVYoIxY4tpUy+apEsuQqZLQPN2tP1qBmaWs=;
        b=Y4MMsFAhQ6OAlrKLjdtZLbi3R97iRYiiEuoEOQiIJpg2cRtjYB49ORZdC2rlHv3W+w
         SwJD8/7OWqjanws4q1NCRKmfL/BQW06gEjbPk9ufQowUmWSicF0JaN4CqRHRXPaFRCDP
         qRDrnxpt7sfyFJxzVuAV+0rUXh6oe0ZQQ5h9GmzRUBTwr9PgnvxC1vrzn7wezRkZkWAR
         jvtZp0BWtmeNVE8YXqln/jiFpxBL4nIjJpBIcDyO1MfVORoB1DX+K49m1cpn71zvLHZc
         X8tmqgoEyDxEhDNx1SMWjL2tMr+5Jtzn/B1smYPoYLZ0PDPfI4t/m33zCwAZE0i8cKXm
         S5ew==
X-Gm-Message-State: AOAM531IQFdoi3tpSP7X2b8On0fMY8mTvTpdKQgrjz30o3vOKN4wre37
        PQeORNfvtn69i7CkPvTRwZ72FA==
X-Google-Smtp-Source: ABdhPJyklQPyHL2n4G1KEjImmjswHON24/eVFkuz53itdZaig2qjcx7EF/rtovwtXuJ6CEqXcbsiLg==
X-Received: by 2002:a17:906:7693:: with SMTP id o19mr6318850ejm.295.1592386348039;
        Wed, 17 Jun 2020 02:32:28 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id y12sm9380552edj.37.2020.06.17.02.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 02:32:27 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:32:17 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] uacce: remove uacce_vma_fault
Message-ID: <20200617093217.GD871763@myrica>
References: <1592229357-1904-1-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592229357-1904-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 15, 2020 at 09:55:57PM +0800, Zhangfei Gao wrote:
> Fix NULL pointer error if removing uacce's parent module during app's
> running. SIGBUS is already reported by do_page_fault, so uacce_vma_fault
> is not needed. If providing vma_fault, vmf->page has to be filled as well,
> required by __do_fault.
> 
> Reported-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  drivers/misc/uacce/uacce.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 107028e..aa91f69 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -179,14 +179,6 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
>  	return 0;
>  }
>  
> -static vm_fault_t uacce_vma_fault(struct vm_fault *vmf)
> -{
> -	if (vmf->flags & (FAULT_FLAG_MKWRITE | FAULT_FLAG_WRITE))
> -		return VM_FAULT_SIGBUS;
> -
> -	return 0;
> -}
> -
>  static void uacce_vma_close(struct vm_area_struct *vma)
>  {
>  	struct uacce_queue *q = vma->vm_private_data;
> @@ -199,7 +191,6 @@ static void uacce_vma_close(struct vm_area_struct *vma)
>  }
>  
>  static const struct vm_operations_struct uacce_vm_ops = {
> -	.fault = uacce_vma_fault,
>  	.close = uacce_vma_close,
>  };
>  
> -- 
> 2.7.4
> 
