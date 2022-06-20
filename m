Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE9ECCA479
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 14:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348727AbiFTOBn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354999AbiFTOAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jun 2022 10:00:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AA23B3FD
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 06:26:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v1so21062567ejg.13
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 06:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bpkWVggJ3SSUB8ub063CuI93Ce8O0+lE1lmNavRnw/U=;
        b=vf/iYq9DpWz4A9mtQbIq4dg+t8LKJf93XXM3RhHu/GHf8CYhssYFp7miEDq8W3c0Fl
         ao9NKWI8A9jq+Wqb9JkOCjf8/oHc586a8exo/yPyJOIAJYRswYbEIVrewpvjuMlRtcvv
         CR2QfMue63UCqJArO6q+SMYpJU29d83H0Y4S3k4lRaNiJfkVVV+UQKz+CexOvxuCeTG4
         J2cmK7WlOvb3TKiyEKJPwCvZfsJf16/vT1Q/NVQxUA/mGWCtzshY4I4coUYNN45IWdZB
         txhWZkWbpQZVWpTXCWROu1N2Z/L2MPY552xGOi2ehwrJs2e5+4AwlYX3UwATMOxwmph/
         PQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bpkWVggJ3SSUB8ub063CuI93Ce8O0+lE1lmNavRnw/U=;
        b=1TSJH7vC9EmpjKbU4KEx4Fnnmqs+oW4jzcd99qETIYnFF5ClGvO4FS06HKCmG6T/cg
         BtYZRFjEJf+2EYI2b950li+D69oieaQ0YSRaBdgzKKTErwDW8m1hSYoBk2bASMQzuDxy
         UKP8rPk0ubtd24gdmN5cAO7ECa16eIMc3QT0Pj2aIWrMTJyocXpcDzfwsiXRM97aNeOP
         XPtO8y4A9VMLd2UQMK8LQpIM/Y/VD1Y/VRLpqXOLCbH5Y/O2vHoeFI8hSjsQz241wvzl
         NN7TByhL/+vrV9Vn9omGldapPx6B4y3hpAQkHv1Gs3JG+hAcXTKT6l8nJX/qC8AjeHWP
         emPA==
X-Gm-Message-State: AJIora9iubRMpRbd2Kq9UH7n4T78VUKhvwemhywnoKxLVaTQ2JPqOokn
        /n02B6CZUrOKBVuDyD+cZnWcnA==
X-Google-Smtp-Source: AGRyM1tYluEdJ+vnziL1SXQxMswnUz9oRFxNhv0bgVtToC+Hn6byz6Ji9EoyHK15pGGwLp0yY3CCvA==
X-Received: by 2002:a17:907:97c9:b0:71d:67ea:42ca with SMTP id js9-20020a17090797c900b0071d67ea42camr13845804ejc.7.1655731563861;
        Mon, 20 Jun 2022 06:26:03 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090634c700b006febce7081esm6063456ejb.177.2022.06.20.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 06:26:03 -0700 (PDT)
Date:   Mon, 20 Jun 2022 14:25:39 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Yang Shen <shenyang39@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH] uacce: fix concurrency of fops_open and uacce_remove
Message-ID: <YrB1U29QVHcKV3g8@myrica>
References: <20220610123423.27496-1-zhangfei.gao@linaro.org>
 <Yqn3spLZHpAkQ9Us@myrica>
 <fdc8d8b0-4e04-78f5-1e8a-4cf44c89a37f@linaro.org>
 <YqrmdKNrYTCiS/MC@myrica>
 <d90e8ea5-2f18-2eda-b4b2-711083aa7ecd@linaro.org>
 <53b9acef-ad32-d0aa-fa1b-a7cb77a0d088@linaro.org>
 <1fab1f9a-5c6c-8190-829b-4bacf15eb306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fab1f9a-5c6c-8190-829b-4bacf15eb306@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 17, 2022 at 10:23:13PM +0800, Zhangfei Gao wrote:
> @@ -312,12 +345,20 @@ static ssize_t available_instances_show(struct device
> *dev,
>                      char *buf)
>  {
>      struct uacce_device *uacce = to_uacce_device(dev);
> +    ssize_t ret;
> 
> -    if (!uacce->ops->get_available_instances)
> -        return -ENODEV;
> +    mutex_lock(&uacce_mutex);
> +    if (!uacce->ops || !uacce->ops->get_available_instances) {

Doesn't the sysfs group go away with uacce_remove()?  We shouldn't need
this check

Thanks,
Jean
