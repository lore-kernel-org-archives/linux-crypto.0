Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A8BC3B189
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C222173E
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PZPAygbX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgBMJnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:43:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43446 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgBMJnE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:43:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id u12so2437721pgb.10
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 01:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NoGUqRpq1F77wcdshkLX1E0mBsPP95pWUoHQOnOvrik=;
        b=PZPAygbXf35pGVvey68bGizPw7g3pQJ2BxVMk8RCqukzpbiRkFrrEVDHzhPxDT1v8O
         BmdBCCzhGg1mqmMXi233FUZVYwx7iFvzRSfs3KvjJkoS7U1SBzHT7vIBlPC3i5J5+ne+
         JiexY8XFovWpYjZ1D8yF82T6x6H31LpdWePek5DStlFYOG7dtaXmaDYn+oti8Z75dzVo
         tP/y8TNe4vsT1EN5KQFVqs27BVb2oz/8eX22GDnEDLKbVkNRZL6/iYRMKvPKK0afSH1O
         rZnTueO7A+YCp2knuxwjglDR342/ujy4FQgTDLNvyio/xY+hKV7giUM+IjTnEb9z+h0z
         ozXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NoGUqRpq1F77wcdshkLX1E0mBsPP95pWUoHQOnOvrik=;
        b=nzpPeq7n4dYLyTv9BhxzFor0T0E+rhyDEMkP1OtsIMzfUyNkBf+DYK7wbAWurt2Chn
         teq2vbxNLD+Dxg5S+6Wqy+7NZAYNlUwqg93+/eNWB+82rYs5CNbqgZ+SMukkc+E+c9al
         g96bNToAWPcSv9Ah7h0LZGCuH6BqzGC6+LMTQedOGlHOa7FGjr1lnsR9oL8H6oJofKhR
         8jjYjxiYl/HiYe42uaM8F4fDl9UA5GnHf96OgaO6FJUq/dwNLyH4ZDxAwN6z0j/pfHSp
         96W5g6J0BV1K+xi5u0H5BzID5HCGpJHp2smUALb3O7ark8yvmDccYiCtzj6KzLTF8pS6
         kbag==
X-Gm-Message-State: APjAAAW3qPiN1/f3I/eVzdheCs47xpqvvV9+6OQxzRLaA4IO+Bu4RQ/f
        JW/fzS+SFZQUzCZXat+oVR8gJA==
X-Google-Smtp-Source: APXvYqyb/1C2ZIIlDPuaXok56IVD4v4T9EnKvkkqKbl8eWGafz0TN3Sk1x1XXOZucUcEJGpMrGaO5A==
X-Received: by 2002:a62:52d0:: with SMTP id g199mr12680304pfb.241.1581586983496;
        Thu, 13 Feb 2020 01:43:03 -0800 (PST)
Received: from [10.149.0.118] ([45.135.186.75])
        by smtp.gmail.com with ESMTPSA id w26sm2421887pfj.119.2020.02.13.01.42.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 01:43:02 -0800 (PST)
Subject: Re: [PATCH v12 2/4] uacce: add uacce driver
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, jonathan.cameron@huawei.com,
        dave.jiang@intel.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
 <20200210233711.GA1787983@kroah.com>
 <20200213091509.v7ebvtot6rvlpfjt@gondor.apana.org.au>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <19f2e7b7-d3fc-681e-270c-2e8650df1ac8@linaro.org>
Date:   Thu, 13 Feb 2020 17:42:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200213091509.v7ebvtot6rvlpfjt@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/2/13 下午5:15, Herbert Xu wrote:
> On Mon, Feb 10, 2020 at 03:37:11PM -0800, Greg Kroah-Hartman wrote:
>> Looks much saner now, thanks for all of the work on this:
>>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> Or am I supposed to take this in my tree?  If so, I can, but I need an
>> ack for the crypto parts.
> I can take this series through the crypto tree if that's fine with
> you.

Thanks Herbert
That's a good idea, otherwise there may be build issue if taken separately.

By the way, the latest v13 is on v5.6-rc1
https://lkml.org/lkml/2020/2/11/54

Thanks
