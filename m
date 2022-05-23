Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592C1C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 23 May 2022 01:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349248AbiEWBY6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 May 2022 21:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349410AbiEWBYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 May 2022 21:24:52 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FF2387B9
        for <linux-crypto@vger.kernel.org>; Sun, 22 May 2022 18:24:49 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y199so12341070pfb.9
        for <linux-crypto@vger.kernel.org>; Sun, 22 May 2022 18:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=L4SbZUHV57IOdhtxt7xLH6bNMt6ZWWMzVkJzxIHiEH0=;
        b=mKhLX5Tl0/hJE/WYln3le1t/gPQuRKOiDHXpUCFFlMUfiqaQJhiCx5ESuSoqzPiwxY
         FXa/cYM1iJaf72An99no6KGCCFyWV/Y2vRmv9AyIf1bZRVEt0Io5RGmKrwslo9UMVfbn
         V3ZRIolNVAS+vrRVoHgUVKsfwMQfVoH8KJlOmRHHVgYUnelmfQuTSvoSoYfQgPYexLSb
         47m/RqFJLuZB/TU+1yL9seNjlqVFWx72k1DMQFHQm/IGAOMlqlsM6TwMN6E4Wcxdc2LN
         MZVGrcLrcF06ZuDyy5Ed6nFp/U+N3coelcUamn32psMV6ZgaQg6mqhYx6vEjvMjCWMeE
         E8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=L4SbZUHV57IOdhtxt7xLH6bNMt6ZWWMzVkJzxIHiEH0=;
        b=mwLZAizFflqiCFJvU8tW6tZuDLcmOlSIeHWi6Kb/fbpvVs+bC7Vmlxbf0MKj7B6Tdc
         s0091FIozoPuIqN84ns6RsRfj0HhOR1Ng17pE7OTcUPtXic30KTmVfqxCXhQbxJe6eCh
         bTNfaRPyyeIuEoR5xqgzd/KIRSWtLmzUMKjo3H/TF3K4vNwSuV/MtcuozX1nZ/Q0ksHQ
         TJsfzGx5JS5QxpQauyBQj0dQvIsIRJ8NzYz6nhoL5uOQJv9ev27AiFNriEEGirOUuWU+
         8a9S4sPZ8KCyLNhEhP97h02fbpUAPOz4ui9gAzBoP7PDt/hhvzkQCq0YCBydRgdh8VV4
         g9MA==
X-Gm-Message-State: AOAM531KmarNV0WStHTCnNqVJHGZZfZZS1i3Dd+t1upOz9GzGO/2Nvif
        co8eVr1zEWva9dcu6M/z/RgyfA==
X-Google-Smtp-Source: ABdhPJx0C/kAHO9Og4a8sFT18y/We0Q5yc2XHHJxoU1ByVr+bvY/kxzcZ7clBGdH5p/Z1lU+2tLtsg==
X-Received: by 2002:a05:6a00:24c6:b0:518:7e6e:ee3c with SMTP id d6-20020a056a0024c600b005187e6eee3cmr10143984pfv.15.1653269088360;
        Sun, 22 May 2022 18:24:48 -0700 (PDT)
Received: from [2620:15c:29:204:fa22:6f61:557f:9cd2] ([2620:15c:29:204:fa22:6f61:557f:9cd2])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090a1b0600b001df7612950dsm5900242pjq.7.2022.05.22.18.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 18:24:47 -0700 (PDT)
Date:   Sun, 22 May 2022 18:24:47 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     John Allen <john.allen@amd.com>
cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        seanjc@google.com, Thomas.Lendacky@amd.com, Ashish.Kalra@amd.com,
        linux-kernel@vger.kernel.org, theflow@google.com,
        pgonda@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] crypto: ccp - Use kzalloc for sev ioctl interfaces
 to prevent kernel memory leak
In-Reply-To: <20220518153126.265074-1-john.allen@amd.com>
Message-ID: <81d016a4-891c-47e6-8a85-7cd9e5661729@google.com>
References: <20220518153126.265074-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 18 May 2022, John Allen wrote:

> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
> 
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc and memset the data buffer to zero
> in sev_ioctl_do_platform_status.
> 
> Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks John!
