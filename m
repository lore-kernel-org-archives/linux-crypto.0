Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1E9C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6226B64F80
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhCLQX5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhCLQXu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:23:50 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBD9C061574;
        Fri, 12 Mar 2021 08:23:50 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id f10so3083426ilq.5;
        Fri, 12 Mar 2021 08:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYesqiGyIIUD4KBvaBrEhPp/WOGV8hwVbX1ai7P5t1g=;
        b=XmGzqR2/jPy2ePXHl4//PXvAWK9Abct0MC6ys/pInnn4ds7vivKQFYjR3+wlCrwQ1I
         zNL1EnKuCHpNlkM0r916ZsdW2N8rUaDzC2ZFZuygw+wzFdEhLNBBTqogqF9EhFfcqXdS
         uPpCJlD0aZoX++PiDZTMJwKxxfUzsKXCxmQxJmeMrvxM8r731HGZcY1hyy4jc4hGbXIl
         Zm4RgjuRmxVnNiDu4AZ7sQBLgx/x1wqa+b8Ahy34BEwhfUEMYnKRQwFL1eZzkVjIqwgz
         S3Hi3jRBIm1+jykXfVfsRm7ypv6FCmsQLQ/aB2qTOCE8MKOLEexuLRvziVlca1SITSIv
         gytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYesqiGyIIUD4KBvaBrEhPp/WOGV8hwVbX1ai7P5t1g=;
        b=K49IdHVGbE75dMSmBGW6iSTVZFZ7MPeYKhwJsG4k6oxrhfd7tiCyI+EwDbrfBdOJaw
         7kTIc5vZOS7uPZOjy1quUef4ssJymoeLk8lMVEQxXMnYFys1jgtItXoI+qId2CxjJ0h4
         LXMXggrlCsPsBvUICiDIk9tyNp4edqDjA3TKg/AQzoyTOzHbTwWX5vUXDagh2IKCXAiF
         9tig0FM7VKYP4xDws2sjEdrALrbgc0L5sF+JmG+FWgOV2VvZ4Sf0m2lf4EGUwNEie8VF
         DDPT+8GB0hkJg5rGaJiHHKUqBIzLmayCZykruJcY+QDBzpyNSLumFfoh/uTKXyMzmgK+
         rUIQ==
X-Gm-Message-State: AOAM532BH5USERbYq6RiPOqR85QDfCttCx5ukeTsrFkhBN++pOUKU+DS
        h7MNhzqyYrTiRUhaTxKqzoABw9Yue/KcjtiX3LWLaAJLhvk=
X-Google-Smtp-Source: ABdhPJzXqnn7wdnfY/jsvg3pLLVdp7eYeMQqWf6v4R7q36bMh/68kTfo3KCfidu6OziGbyqhUGwFTX6gkXGO2t/brpI=
X-Received: by 2002:a92:740c:: with SMTP id p12mr3491479ilc.9.1615566229640;
 Fri, 12 Mar 2021 08:23:49 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
 <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
 <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com>
 <CAHp75VcFDXTXcaFqOyRCdArx1bGED_jsEeK1yRQhxUvHp0goTg@mail.gmail.com>
 <CAA5qM4DPqtPWMydx41Ovx6DCQoEESewkZbQrbhdwfVhkcy0nCA@mail.gmail.com> <CAHp75Ven=Sfmy0YE_Q60fiF-pyXg2tO8iq7_vN+aUzaxYTtZmA@mail.gmail.com>
In-Reply-To: <CAHp75Ven=Sfmy0YE_Q60fiF-pyXg2tO8iq7_vN+aUzaxYTtZmA@mail.gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 12 Mar 2021 11:23:38 -0500
Message-ID: <CAA5qM4B_xhSanwEMjAcCHVAaVkSK-rVv+Km79WbQGauWXSs6oA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks Andy,
I have sent v3 with the suggested tag fix.
- Tong
