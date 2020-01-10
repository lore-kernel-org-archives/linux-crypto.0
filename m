Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851F3C33C99
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F9A32072E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AmGIEKHX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgAJHHV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 02:07:21 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53639 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgAJHHV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 02:07:21 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so576626pjc.3
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jan 2020 23:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=M/y3Ml3cM/VSoJud1Dw7FXrO1acMY+sKEerO9outbBk=;
        b=AmGIEKHX7/ltZPW8KBppPh4dfNgAw9BawReONfu20SdOsEMncM7QmHQ/DgfwDnmv8T
         21IGIPGILhSA7JnW3FoEIgT4DYGLgTZWZ1IgT0UNnkSecFHfuf+XkuOKLuTKXUIZpMSW
         oZ/qPcKd9Hnl6huv7035dakRp5WDhXPAbrr8JERWj/eZFYO7UQslkIXRFmZpVlEJcFyg
         lekKzu3LWCNQl4rxLeOawb8CmQTU0MELvaG1Nz7V9uX9L7UXTTXz/37cCAfTZ/CdjQV3
         SoubjbvyPfUl5rmF5IblznHxKkK3UgeseKeDecNWC44R+Qu6A//67AV1VnVdSbZI1CrM
         woAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=M/y3Ml3cM/VSoJud1Dw7FXrO1acMY+sKEerO9outbBk=;
        b=jw7JXZXY0/dQ6WEy91+c2EAZ584TLbdfkJN8bciWRn/lu19V+CmixRsIiXvPmyBAVI
         GDGatWiKYx/fVAa+SIaMG1zBMqXHCNI0suYsQW1WY1I/IS0WUnwb1lwo0z5e8PSgDpAU
         jj/yvFBDsZp1qLHVuCXWqw4vzgFBThEZYlEhbCGtJL1O0Lzp1ysblAt866UBc4apm3dG
         hr9CHb7UA8/M7PEqX11wsUeFWiYlWBbR3t3MDE0KO4l1pyYcurc/L3hWulHTUcgQVbzl
         h2S0CPJ55pxrXoym7wlQrnumscBZLJi+RfSXeQwnrFAbDtrUSGgYHOY52FwrkHuKffD1
         lyxw==
X-Gm-Message-State: APjAAAWK6aBpnrm7FLo6Tb5ybxKZ6uFsbXFXai4HUIblaeGhID07mgkZ
        ABDd74k0O812FcC3iBd3G+599w==
X-Google-Smtp-Source: APXvYqyQSw6X8cyO2gBQIiXxpRCvLX2QZNn/mPymYICp5ZQha+ZzrZ0O7cBocngIOaOdKKOTZmMvxw==
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr2473221plo.289.1578640040800;
        Thu, 09 Jan 2020 23:07:20 -0800 (PST)
Received: from [10.151.2.174] ([45.135.186.75])
        by smtp.gmail.com with ESMTPSA id l14sm1147746pgt.42.2020.01.09.23.07.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 23:07:20 -0800 (PST)
Subject: Re: [PATCH v10 4/4] crypto: hisilicon - register zip engine to uacce
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
 <1576465697-27946-5-git-send-email-zhangfei.gao@linaro.org>
 <20200109174859.00004b7b@Huawei.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <8d35168e-ff68-1bb9-20e1-6bbac5afde00@linaro.org>
Date:   Fri, 10 Jan 2020 15:07:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200109174859.00004b7b@Huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/1/10 上午1:48, Jonathan Cameron wrote:
> On Mon, 16 Dec 2019 11:08:17 +0800
> Zhangfei Gao <zhangfei.gao@linaro.org> wrote:
>
>> Register qm to uacce framework for user crypto driver
>>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Very nice to see how minimal the changes are.
>
> Whilst uacce in general isn't crypto specific, as we are looking
> at changes in a crypto driver, this will need a crypto Ack.
>
> Herbert, this is about as non invasive as things can get and
> provide a user space shared virtual addressing based interface.
> What do you think?
>
>  From my side, for what it's worth...
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks Jonathan
