Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768EBC61DB3
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Jan 2023 22:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjALWXi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbjALWW6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2023 17:22:58 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D2B1DF0D
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2023 14:17:38 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d3so21586051plr.10
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2023 14:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=duA6Un7MMHsWwDUG6Y+g/Vg750sAKeltAfxhDAJWOzI=;
        b=esi4sIDLgCeEJk+u0yjNbzcOwnXIyrdFqNgIf/C/hPkZydzpXkwVQAN68jczLwo5Vy
         DjaWv1FKrmoOVsI/0IYwX7hEP8bcbjLX9gMOv2qJZ01Sb6xTbGwFMOr7weCr1vnx3hO8
         JxqhFjo+y4XHo7VkWAHe0Pp4x16s1XVBDAvHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duA6Un7MMHsWwDUG6Y+g/Vg750sAKeltAfxhDAJWOzI=;
        b=uXxU/Z7z4i2l7DeADMNW1yqEMhZ8cH4lYtr4P12yS4Du797n/Ao1QYVTqMttdqW49o
         tGzBuFBuCBVh5Ez7s4pQFI8R9HLbUB+2e5bBaYS3Iu5pFei/jiH03s+9k1sPR+Shm8Kq
         r+ytQELGg9G7yxZO7umrTPJNgB/H1oTsaOMhzQVj9ubLXkVQYA0YBgEsbGQ4Yp8plfIg
         iUEqeH6lb+QcQrsQkw8K2W6FP8c0lKu41yjRAQnyNtXTNDA+3PYZU13fBej+peYH1306
         oOFAJ+j0CKZUiAuOgToqlyMFjWoLz/d7vhSuljWRi+G5xjU9wBtzYPETAI9lqv++25Ms
         UjHA==
X-Gm-Message-State: AFqh2kqENtmbUTuVzMCGv15RuyvHuD7i/9KKc8Ne3sQRQqAxQ4kYXqV5
        FI+jWTXzcN6lGgjMLZSckgRiQg==
X-Google-Smtp-Source: AMrXdXu4y1USXbmB33jWp7T1TGYvEnF6MOtrQLu8xzf4Ek5Cp8Os7yBkCc4yDy30ibdWeK8h+3oGNQ==
X-Received: by 2002:a17:902:9685:b0:192:f5a8:3099 with SMTP id n5-20020a170902968500b00192f5a83099mr26592237plp.5.1673561857844;
        Thu, 12 Jan 2023 14:17:37 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00189db296776sm12808100plg.17.2023.01.12.14.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:17:37 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:17:36 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: aspeed - Replace zero-length array with
 flexible-array member
Message-ID: <202301121417.EE86BDD5C@keescook>
References: <Y7zBxbEAvcEEJRie@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7zBxbEAvcEEJRie@work>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 09, 2023 at 07:39:17PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated[1] and we are moving towards
> adopting C99 flexible-array members instead. So, replace zero-length
> array declaration in struct aspeed_sham_ctx with flex-array
> member.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [2].
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
