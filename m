Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD003C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 10:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359736AbiDLKtZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358089AbiDLKqR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 06:46:17 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7FC6660D
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 02:47:20 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g18so10616966wrb.10
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 02:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jEYu5Dc4DrM1CeiFx20rntUZKHdIKyhqBQGEbRb+QEo=;
        b=MSfYzpmK8tn+uXXhR01V+fNirOZU31wliDT7ahVZuBpemgDi/9lLDSAJVDYSpZeTbK
         YQQZ3Vi4EWOxx+dFtFXwenHouaTwLx4s++6Ihuj5g+cZwyxYaYqJwNHwBcWqwNDIABXV
         sOF6eSR1FEjx2RARMY/b+sgg4jvWhwV/ntSyVIY5zJ2sMknGhHuIz38NMCHOzaW5vnug
         tbygB8NQlSK7osT568Zcj0/Y6GhTiRlqhnYZ+hfp3EWdCoS5NmUwBSzyEUxCiZImo9KD
         EVx0gknoyTlaDOb2phm0TpbMkQbbRVWfP0oorSNsd7q3GbydRyQvu3Mn6URcFylPvZH2
         Enaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jEYu5Dc4DrM1CeiFx20rntUZKHdIKyhqBQGEbRb+QEo=;
        b=6lN96g+mVsbNxbXEPZzt5fsW3GtaNTi2G/0wdaGImY2lhIc/Muq2CTrCUkVLmRMRkT
         hKjRakLAJxVfNvN1nv+fDCefBW96jiVF2uSmRK+2ht6UrzyovLqLvteYmkTXW9cXvgAU
         cGeJvVnuR2ktKDXwQri6udlJsMjHirnXMmQD+6Q1Ix0kUFLTYcKYMLRdbjRxs7TD9pde
         oS15BIe2OCCxNvaFnHPVGtWyTts0J8Ijss7cYXCkpReiAVD5gaE3XayoDQvSXmbGWWtv
         KG8RbcLvATaUWnwP5PGAKqx0hWPhvK0rw3Ak9fUbsCjLnLzOHbiHimZx3cOfe3Uu8JaI
         GHog==
X-Gm-Message-State: AOAM532xvpfwgS/TM+lKiblccNheFyPxUOZWOTcxFcvDrIrhdHP//WWp
        nPQ8Qo8I1o8ij6mRkafE9v4=
X-Google-Smtp-Source: ABdhPJxCyWsrTSnfaBIu38O7iMTAsodQWY+yafnQ23aeJwg2qr3DNeFG5SxlCZ0qf1FD8HUV3c+OzA==
X-Received: by 2002:a5d:598a:0:b0:204:6fb:6461 with SMTP id n10-20020a5d598a000000b0020406fb6461mr28331617wri.132.1649756839021;
        Tue, 12 Apr 2022 02:47:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o6-20020a05600002c600b00207a389117csm7316817wry.53.2022.04.12.02.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 02:47:18 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <df758c80-ea85-d324-ad05-9bf07bb569e3@redhat.com>
Date:   Tue, 12 Apr 2022 11:47:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 0/8] Introduce akcipher service for virtio-crypto
Content-Language: en-US
To:     zhenwei pi <pizhenwei@bytedance.com>, mst@redhat.com,
        berrange@redhat.com, arei.gonglei@huawei.com,
        Simo Sorce <simo@redhat.com>
Cc:     helei.sig11@bytedance.com, jasowang@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220411104327.197048-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> In our plan, the feature is designed for HTTPS offloading case and
> other applications which use kernel RSA/ecdsa by keyctl syscall.

Hi Zhenwei,

what is the % of time spent doing asymmetric key operations in your
benchmark?  I am not very familiar with crypto acceleration but my
understanding has always been that most time is spent doing either
hashing (for signing) or symmetric key operations (for encryption).

If I understand correctly, without support for acceleration these 
patches are more of a demonstration of virtio-crypto, or usable for 
testing purposes.

Would it be possible to extend virtio-crypto to use keys already in the
host keyctl, or in a PKCS#11 smartcard, so that virtio-crypto could also
provide the functionality of an HSM?  Or does the standard require that
the keys are provided by the guest?

Paolo
