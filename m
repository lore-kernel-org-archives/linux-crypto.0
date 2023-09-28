Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE2EE82CBC
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Sep 2023 01:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjI1B2r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Sep 2023 21:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjI1B2q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2023 21:28:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDBAC
        for <linux-crypto@vger.kernel.org>; Wed, 27 Sep 2023 18:28:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-584a761b301so4231966a12.3
        for <linux-crypto@vger.kernel.org>; Wed, 27 Sep 2023 18:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1695864524; x=1696469324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQKk85Afi4z+yWQXqNio3WhLlSbvtWaq2r8uxo++06Q=;
        b=U4El6lVWUu2AeTz6mjX5N07iDhZeN9yKkwvLy8st/ocScdELsaGBzA6YU2dV4N3HH9
         MIcQckOu1odgx+ZJgHuQzsF+PD2tF0Ppy3Y7kR6iCCdRFmzwbf1hGZ/5Vw1sQIgZWQMO
         dg2fyLrIpJsM1sBIWL4HcTlavxafuVB8Y98Ar5iiuK8Yvt6n27WpDGC63XdltA0XnNOM
         McQNb2q5sMcEm9wD0XBtIY9VMoTlC0oMVGQsV0OgHHONF71h9r/5rH3a3WoEQZcVCx8G
         ym8GelJPmK6BBU4VEuQVd/HdBEsxqD8bcI9vS2L50LMU0zQefLGMJgnK9tH2Tl++uCOW
         QiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695864524; x=1696469324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQKk85Afi4z+yWQXqNio3WhLlSbvtWaq2r8uxo++06Q=;
        b=bdY9jNYtsQuY2XyWraSAQVfQW5uK5vvD3fQyeI1aeVUH3qOtFPf8mqLW5SNyGb9wzd
         kGVJ9zeF+Fgr+3CM66vyotfjNVZRjBD+tS6fUCTPCkid2RPk0ekvvIBzi7UtBhvdZC8/
         mPfg7H6Gfz+laMKouG3HCini3Kue6E73cMhfKIQgy7G7pknPHRYpG/Dap4p+4rw3brXT
         b6gx/+Bmjfs33lN1DJsFkuPhiiofMFDj6KoCT31RbAMMxqwFj4CQM/HIghN7bTd1AB/0
         gFapPlA/DtPJ3LrhASUjmgpYmqr6c8ZuWFAP5i9d7JiwrBxuHcxMj0cMUkZ/4u37bivQ
         Skwg==
X-Gm-Message-State: AOJu0YyqarJB+EWT9/5ujCcpINk03X7dhJ1PNd58CWYuYmSuAciGBE3L
        qEpXGUJoZvFIxb/iVqlY5k12lQ==
X-Google-Smtp-Source: AGHT+IEb77pxF1A4zuog0Pubtnz/Y+v7YIq8Yjvf89gpA0u8AEh8k4dTpPQZEdA3uoZ+glEhfmQuZA==
X-Received: by 2002:a05:6a21:7988:b0:14c:7e3:149b with SMTP id bh8-20020a056a21798800b0014c07e3149bmr2971085pzc.62.1695864524647;
        Wed, 27 Sep 2023 18:28:44 -0700 (PDT)
Received: from [10.3.43.196] ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b001c61073b064sm7916471plz.69.2023.09.27.18.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 18:28:44 -0700 (PDT)
Message-ID: <829bc434-89e6-b17e-b832-d0d83480c80f@bytedance.com>
Date:   Thu, 28 Sep 2023 09:24:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Re: [PATCH] crypto: virtio-crypto: call finalize with bh disabled
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
References: <1914739e2de14ed396e5674aa2d4766c@huawei.com>
 <20230926184158.4ca2c0c3.pasic@linux.ibm.com>
 <20230926130521-mutt-send-email-mst@kernel.org>
 <9564c220c8344939880bb805c5b3cac9@huawei.com>
 <20230927152531.061600f0.pasic@linux.ibm.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20230927152531.061600f0.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Michael & Lei,

I volunteer to fix this by workqueue.

I also notice that device drivers use workqueue to handle config-changed 
again and again, what about re-implement __virtio_config_changed() by 
kicking workqueue instead?

By the way, balloon dirvers uses 
spin_lock_irqsave/spin_unlock_irqrestore in config-changed callback, do 
it handle correctly?

On 9/27/23 21:25, Halil Pasic wrote:
> On Wed, 27 Sep 2023 09:24:09 +0000
> "Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:
> 
>>> On a related note, config change callback is also handled incorrectly in this
>>> driver, it takes a mutex from interrupt context.
>>
>> Good catch. Will fix it.
> 
> Thanks Gonglei! Sorry I first misunderstood this as a problem within the
> virtio-ccw driver, but it is actually about virtio-crypto. Thanks for
> fixing this!
> 
> Regards,
> Halil

-- 
zhenwei pi
