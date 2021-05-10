Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F46AC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C1461424
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEJG3Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhEJG3Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:29:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C0C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:28:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h20so8626513plr.4
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=8aR7WY5CZTqAiWESNPXFHkeKW1KzCf5tU1hXn+HW1Kw=;
        b=s9HXI1C3iGShy3MBh/f3z23PGT7oo5fSNATzZC5wVH3AyhfCxO3IHtSzJqwfJzLkr8
         Sa94IYs01uF3tVT5jCOiTBQEMn/XoCyaQHBKgUAzdE3dBndEIbFJwrVf/l99vo8602z9
         Tkhrh01vYkzv7Mdv2lLXElxNxjJLQfYBN7RetbJMrWZsFCTCsmKEj/YySnC5QIJoVXH/
         dJlR8y/FZhpvfW2Gal5NjKzmAdxFgMeJluGzGy8uLVEuNTmMvvmPckmmPCHDD18dHnKj
         4R/wJtCq/sQ6zh7aRVXYZyrEEkHXhZirPAOS3BtK0EfRGtwNsN9wEzj2w/OT30aaNivM
         YoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=8aR7WY5CZTqAiWESNPXFHkeKW1KzCf5tU1hXn+HW1Kw=;
        b=nX7OKDuIltjNysgtPhUAkPhktAA8hbYBwr4fRAqMvmSBxBSIznh0IHjGHqwSZ5DcMm
         aFkghDR1aonWO8ew0NIE4mNWyZhWWHOy38wxf8/KLdBLBcABIwY0j8ocVdV48h5wAB3t
         aQlU8X9JklpPUg3neOIfb0+VaDv+iI7m/jrHP+vPxQ378GdR8T9UAKNV8Xx4yo/m+E8X
         6Mvcp9kz0Imp4xnUoLXKRgiYRBEu/fMC1rUxZUmMR3CXlzBdR47vOhf7N/FtYa9qWzDm
         6rhFVxuAfxd9XVIt1AIz5mWQpjx/GRPKY9iVQQfYCyP40COKFiDzVWCF/VwCYtk2/iDu
         EHwA==
X-Gm-Message-State: AOAM5322IyQdYsr+FKkVVS2lNixThqPYgghprbgzS3zPaHeHVRj8aFmq
        orG8TGqzJ6GqpC4pc/fwwHY=
X-Google-Smtp-Source: ABdhPJx8PUcyQWV5bJ29htOosYznRoAQ6XJNYhgJTv4qLNWMdTyMXBo1DbKc9tZ7rV5saYG+CXONcA==
X-Received: by 2002:a17:90a:20b:: with SMTP id c11mr25164418pjc.44.1620628099647;
        Sun, 09 May 2021 23:28:19 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id d129sm3575475pfa.6.2021.05.09.23.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:28:19 -0700 (PDT)
Date:   Mon, 10 May 2021 16:28:14 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 10/16] powerpc/pseries/vas: Integrate API with
 open/close windows
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <4b66c4eea2c0213be658180c987d81f3bb82293d.camel@linux.ibm.com>
In-Reply-To: <4b66c4eea2c0213be658180c987d81f3bb82293d.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620628043.agzu72dwu1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:08 am:
> +static int deallocate_free_window(struct vas_window *win)
> +{
> +	int rc =3D 0;
> +
> +	rc =3D plpar_vas_deallocate_window(win->winid);
> +	if (!rc)
> +		kfree(win->lpar.name);

Oh, did this kfree sneak in here? The allocation appears in patch 11
I think.

Thanks,
Nick

