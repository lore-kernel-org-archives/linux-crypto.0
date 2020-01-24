Return-Path: <SRS0=iQPq=3N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAE2C35242
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 04:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D4092072C
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 04:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sjKprFmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgAXE0V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:26:21 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40654 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbgAXE0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 23:26:21 -0500
Received: by mail-pj1-f66.google.com with SMTP id bg7so485139pjb.5;
        Thu, 23 Jan 2020 20:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ESSVHC6qV85e8H5wIqp30FQ6rrj3HanCaflPIZpS5p4=;
        b=sjKprFmI5+PynbYnEaH+yspbuyLdAbql3dsNyfASc9i/V4WnLGJNLX8PkReWZWxmSX
         UJpDaa95WQ6TOfGT8pV0i4/xfWk/enTJmSL+nxzS9NsUXqpPT0Ase/1tMHhjV9AQeHJS
         tZ3eVS/rVqnHyRlK17Ck4b9IpC6Gx4xd+RYSF2lrbubZ42ydLyFnim0XwgU+hS0F/CyA
         Rj1WahUr0qft/ln24gUFecseWvdTj8nABLi7TZMdJGA4Zy9vztUyB1rcGM1Ec3FV2d9G
         t+8W/4Z1dzG2o3aAPLkVI4LPMvMj2WRMnPu5jY17GEy31k9RhMkfnyuy+uVTB61E5gtv
         h37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ESSVHC6qV85e8H5wIqp30FQ6rrj3HanCaflPIZpS5p4=;
        b=pHrVCMsybA/4/X/j11Ry8S/VkPzEVb+8umiSU54Zvj+FHlqC26lH6xpCfeASxMKo8F
         1lqZNSv7unjva0nNxUnWe6y6L1xmhGGO3/ynZl8kmXGdSnKxvW7Bb5L9i3N7hovHY1Mz
         O1LbafhsdGwmuAL6vUbBXr19xbQVqOq8xiSYsdjorRBC9YfbQRbtyoY6fYE+OjVnGh6d
         rs87tqGL9g+l/LsoL+jjC+vVoSsgxummi0gt/4YZHEMIT4s5Ih5y5R7bKiGGpAlF1te6
         U4YOj09hspkGUicCL1rflNgF8xkoL81XllDgJuVCmoOcA4lgUtOamrVk90MXTaOvNPXd
         uI/w==
X-Gm-Message-State: APjAAAU6WPceQCUX78VmeEdXbmK0fOd2zfjgPjrvgH+AR8ADxuQuRluj
        0x1Z4q2k5tG0FkJlt1G8/RsSRYs=
X-Google-Smtp-Source: APXvYqxprB70a0uP/R+rGUDMKzsz+0tnKdqYZd8ZDy2t+H61CeoOvFKKrX7ufnu84cM9HGFooDRwhQ==
X-Received: by 2002:a17:90a:6545:: with SMTP id f5mr1243695pjs.42.1579839980685;
        Thu, 23 Jan 2020 20:26:20 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:1ee5:e37b:72:f3a9:f673:9aea])
        by smtp.gmail.com with ESMTPSA id g9sm4381184pfm.150.2020.01.23.20.26.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 20:26:20 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 24 Jan 2020 09:56:12 +0530
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     madhuparnabhowmik10@gmail.com, steffen.klassert@secunet.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com, rcu@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata.h: Annotate parallel_data with __rcu
Message-ID: <20200124042612.GB23699@madhuparna-HP-Notebook>
References: <20200122170246.20177-1-madhuparnabhowmik10@gmail.com>
 <20200123160850.gcwoydrdpw6saotk@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123160850.gcwoydrdpw6saotk@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 23, 2020 at 11:08:50AM -0500, Daniel Jordan wrote:
> [add Herbert]
> 
> Hi Madhuparna,
> 
> On Wed, Jan 22, 2020 at 10:32:46PM +0530, madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > This patch fixes the following sparse errors:
> > kernel/padata.c:110:14: error: incompatible types in comparison expression
> > kernel/padata.c:520:9: error: incompatible types in comparison expression
> > kernel/padata.c:1000:9: error: incompatible types in comparison expression
> 
> This recent patch to padata in the cryptodev tree has fixed these sparse errors
> and is heading for mainline soon:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=bbefa1dd6a6d53537c11624752219e39959d04fb
>
Thank you for letting me know about this.

Regards,
Madhuparna

> Thanks,
> Daniel
