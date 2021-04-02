Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D02C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 11:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF7C610D2
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 11:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBLSb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBLSa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 07:18:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5183C0613E6;
        Fri,  2 Apr 2021 04:18:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x7so4452156wrw.10;
        Fri, 02 Apr 2021 04:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8E3SEQHWtD9oyxpVQil1WLhWIN1NJ4aU8PFyBCEE/9I=;
        b=aqP3pMYBFohRF0lJwLR9OejAloqY6YrXbLNGYs9zFLgCv1MCuHZgj+iSPTeNoGQ12w
         EyDaCkMvX460y0dvE3hkVfUSuIwTGfroRpBN9oog6OWB4hEKvepYFFPE+VeWXB49iqN5
         dLgN+ei3rW27jDeJ26Zb4HM1zjaSGDUIkBjN6VeHlwK42H0NEhOg/oAPO2e8+hbrglCe
         wFD0sJQ9wmT9rP2wWgsZ7iIi1RZNQMheo6Y9xqlezW7Mq2rwjKQKT6byD+VWJGctCxw6
         xZcVGeNNDgjZ3a7OBtjjVcklPFudhVTg2Az6gV3ThEHsOoJQhKaV9EFaq/PKuz/32oWj
         9MzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8E3SEQHWtD9oyxpVQil1WLhWIN1NJ4aU8PFyBCEE/9I=;
        b=hcnk2r0+WhYsR2/SqmOJhB7UC71jcrNlKLRSblqfsrrdNW9GWG6WpZEEPWMm0JrnVN
         tczIh4eb/uH21tTpzwyjRqEccwb6X/jUEB6cHT+JaDgCIOtuzA/CPT3RrM2WNh8NDa1A
         f4N4xMHmssccsFk9AcMaC15uuquhpef/FxRNkPZblWyPHNdDOvEV9q/M+WQKVjwx1ZyU
         oODnpVt1EUQc2kzo5pLV0pTZIEyL6eJPBPXcaypXxrbsnIJ4FW7Jkej8njOe2ZqW0z94
         BB/YxwFgtK92CJdeKo+fGPwZ8QWdpuxCpLeqahxhe0NDLWVAyF/igVoUeNDVuvDD3t1A
         FqIw==
X-Gm-Message-State: AOAM532nOyTMTpp+ZxaNkHID8Hbo4bVM8UrO40P67EWTD+tRCEacUh1h
        mlX/AsPQ7l2MX+/t2Yu86QgOE16PXyo=
X-Google-Smtp-Source: ABdhPJy/iKJNXmT3yHCYQCxdWaBoVuhIXj+nmkcu/NqP7UPz3sLXzXCR2emtqZGn7Kl5Og+YTtZr2g==
X-Received: by 2002:adf:b345:: with SMTP id k5mr15205746wrd.14.1617362308620;
        Fri, 02 Apr 2021 04:18:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id r10sm14279138wmh.45.2021.04.02.04.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 04:18:28 -0700 (PDT)
Date:   Fri, 2 Apr 2021 13:18:25 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: sun8i-ss: Fix memory leak of pad
Message-ID: <YGb9gYv1+2aqFUNa@Red>
References: <20210401151827.2015960-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210401151827.2015960-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Apr 01, 2021 at 04:18:27PM +0100, Colin King a écrit :
> From: Colin Ian King <colin.king@canonical.com>
> 
> It appears there are several failure return paths that don't seem
> to be free'ing pad. Fix these.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun8i-a83t-bananapi-m3

Thanks
