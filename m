Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47B7C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 11:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0F79208B3
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 11:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jamieiles-com.20150623.gappssmtp.com header.i=@jamieiles-com.20150623.gappssmtp.com header.b="dFoQvBVB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHMLdI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 07:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgHMLdH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 07:33:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F05AC061383
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 04:33:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c80so4400209wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 04:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jamieiles-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kYtJ68n3b3uzgea01Es3VzWZKZP+bhIPZUv6EeRuPDE=;
        b=dFoQvBVBesIbzR9acmuD3xtoORam4n0QxmYSqnUFM+wYNG0jV9vTDbK+dio2E50xyY
         R1QNizSL+2X5Ci8q0MMbG7I8P2UUEnySxBgkF5qGQyJaUrZIGbcOAOdB6vu6RCSklLaF
         30F7RYu/MpGdg2FKa+4TlBOH/VBMkjFg4DRkWzQnLcA57y/Ju78fMN3x5dK2BYsWnIVC
         8RH8Mu32QEcxVp5T5Rnl9ClVQ6VQ8MOXYDphvwjtqtVFwZp6AABDs8L1+mr+fkWQzVLv
         UVj2o6urI4DVDZn5LtkmVsLwcCA7qoW6k4twHiK10GvZ97CsEZOhW3plV26zYVu8dt7+
         uRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kYtJ68n3b3uzgea01Es3VzWZKZP+bhIPZUv6EeRuPDE=;
        b=dk9uJQxMiCVqkCzwh6amxFlpX5vSwU1BIqx4afqgQ9AHYeS9RCWKmAxKj5s3AS1UGi
         BfTZlOMuTQaa3n8yptm8FMwKUCcOPv2zVo6HEPFzKnch91j2sstkobkASzwGnOU7jmD3
         vA4SsPfZCqqapFq4qy90PPkPUz87sDs4zZn4K/Vwgrx/IFx5NTWkpsbydTyWnof+MWDM
         0N9453VPmNq/tXo88qkniw/cXD528r2FOWfupIv3D0QbxjYk7TSIecmsINdt5fYUrtM+
         9fyqZJ4ThCk+KRv3RxvQshOmxCwiEH1YqOogp8UjNI/Xt7WQxdz2n/ZPUJvJjHz7lVgX
         +36g==
X-Gm-Message-State: AOAM533A4pREtzWRQsyERWHeXU62nauPgn00P8qdozmg8xdOErVpZAHN
        tsIJkD4JfIA6zrQJSVEMOIPZ4EY/1DM=
X-Google-Smtp-Source: ABdhPJx3qlmoLdH7xdp1UXdN/PdrDuewfq/0p0PmA8z5X19IgLTNysAqKOY0MTSHPags08cR35erxA==
X-Received: by 2002:a1c:818e:: with SMTP id c136mr4170502wmd.170.1597318386169;
        Thu, 13 Aug 2020 04:33:06 -0700 (PDT)
Received: from localhost ([82.38.213.95])
        by smtp.gmail.com with ESMTPSA id o3sm9301662wru.64.2020.08.13.04.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 04:33:05 -0700 (PDT)
Date:   Thu, 13 Aug 2020 12:33:04 +0100
From:   Jamie Iles <jamie@jamieiles.com>
To:     madhuparnabhowmik10@gmail.com
Cc:     jamie@jamieiles.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrianov@ispras.ru, ldv-project@linuxtesting.org
Subject: Re: [PATCH] drivers: crypto: picoxcell_crypto: Fix potential race
 condition bug
Message-ID: <20200813113304.GA11888@willow>
References: <20200811123024.14501-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811123024.14501-1-madhuparnabhowmik10@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 11, 2020 at 06:00:24PM +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> engine->stat_irq_thresh was initialized after device_create_file() in
> the probe function, the initialization may race with call to
> spacc_stat_irq_thresh_store() which updates engine->stat_irq_thresh,
> therefore initialize it before creating the file in probe function.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks!
