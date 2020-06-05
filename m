Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5DAC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D835C20772
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tncq0J7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgFEJeo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgFEJen (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 05:34:43 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA77C08C5C2
        for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2020 02:34:43 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t7so3426609plr.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jun 2020 02:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mFjpcHRNvW7jr5yAUPBmHqqZtDxdLZ2YVWSiOFI3u8k=;
        b=tncq0J7af5auIOZilp/gB2dX3myfDONuE4xiyxtAkUZfzWxzWE+sbyTZDC5D7d7q1s
         TkuwIFyUml77QCNoYqfDaFlrLk4gm0MIkSzkxvKksshrFIGhPlZcK+uGgVjf3YNrNvBs
         /IdlmAr/bS9iHgPDFNQlITywQ92gob/YoVUdOMQlJvcnyH11gGeAMOvNXa0qTEO/CaSx
         OQtFtESL2j/vqrX/mjW//eGGEEP3N8chrtrzWPlI5nbjHRbkIdx0dsxMvFWpYiBdr1VF
         zPkTDDMmdYCw+TV8jrKyb/phZbJP1e9hp00ouOrbi+pEhIj2oQHt22pf818Fbj+1nKPt
         b+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mFjpcHRNvW7jr5yAUPBmHqqZtDxdLZ2YVWSiOFI3u8k=;
        b=Flwq7qq5yybh9FQ21P38kQEasbq4/zu4lkCYQr3sIO99jO/UkOjE1WdCUsPFumwQsK
         +B3J7WnG3q3oyx95k7bdetj4iQoI/MY7kh0bupYYaz4bA3izTIg0o1sGuS5faMS8kfE5
         nK76kCl5KwDIYcXQn16iEO01J5bVS+dXsboZ5/M8TF4NQ6JJ3Jhq9qL2ruamOc8Olqx1
         nxXe+kDT0IfTwBXRbxtAgKa5aUK98PB4iSbOhqKyxPsQvVxn+pAFcvsC3lqOtdieBMiE
         8VT1g3aucZdryvpXQwlQi79vq9A1y9Dw9TFbMhb6KBSEazwrR0ik8HOhblH7Y8jBx6oz
         NDVw==
X-Gm-Message-State: AOAM533HqxEYpgrH4G3gqJmpNUjsWp9EkLkMPQpNjwMjqvLu7hqKlSNy
        tpcUDxvOsFhi2lYMGAb/hA2Nzg==
X-Google-Smtp-Source: ABdhPJz8GwlVCdFrI51lZNlGaMBY6pEeiVPhUYmfkc4rG2hWpbWaKWSGzMrmCUboCFdUXzYyYX6W0Q==
X-Received: by 2002:a17:902:bd09:: with SMTP id p9mr9263783pls.214.1591349683331;
        Fri, 05 Jun 2020 02:34:43 -0700 (PDT)
Received: from [10.110.1.98] ([45.135.186.59])
        by smtp.gmail.com with ESMTPSA id j8sm7453067pjw.11.2020.06.05.02.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 02:34:42 -0700 (PDT)
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
 <20200604065009.GA29822@gondor.apana.org.au>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <f8dceec5-6835-c064-bb43-fd12668c2dbb@linaro.org>
Date:   Fri, 5 Jun 2020 17:34:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200604065009.GA29822@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/6/4 下午2:50, Herbert Xu wrote:
> On Thu, Jun 04, 2020 at 02:44:16PM +0800, Zhangfei Gao wrote:
>> I think it is fine.
>> 1. Currently the name size is 64, bigger enough.
>> Simply grep in driver name, 64 should be enough.
>> We can make it larger when there is a request.
>> 2. it does not matter what the name is, since it is just an interface.
>> cat /sys/class/uacce/hisi_zip-0/flags
>> cat /sys/class/uacce/his-0/flags
>> should be both fine to app only they can be distinguished.
>> 3. It maybe a hard restriction to fail just because of a long name.
> I think we should err on the side of caution.  IOW, unless you
> know that you need it to succeed when it exceeds the limit, then
> you should just make it fail.
Thanks Herbert
Will add a check after the copy.

         strlcpy(interface.name, pdev->driver->name, 
sizeof(interface.name));
         if (strlen(pdev->driver->name) != strlen(interface.name))
                 return -EINVAL;

Will resend the fix after rc1 is open.

Thanks

