Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C201FC32771
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Sep 2022 04:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiIXE7X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Sep 2022 00:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiIXE7W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Sep 2022 00:59:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E760151020
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 21:59:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 9so1877603pfz.12
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 21:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=dRtKEJsROLYDM0ai30/aDS7BiCQYcoHjmOi4Z2q3irc=;
        b=Cy+/NTZVkooL+DcEtr3BQFdm2WFzRQb0Q6k9A1FT/tze6Z8ELxxWtK4k9Vt5aCLLHI
         G5GfpD7+zydKxynimvkrn6mvFiIbxZA+FEAYXRyy235O5bt/Nmp4J//w6hdQztOWwn0c
         q3T7G+8LSpoeeogTIurjnWfChd0R3NYJgtacY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dRtKEJsROLYDM0ai30/aDS7BiCQYcoHjmOi4Z2q3irc=;
        b=BF6i3KT2rFKpUXVpXxM6Wn0t/p2Zqk4jxAK9bkj4D5BarKRERoKYDkfNPK6+PMdSA1
         /bXoqJxHO1Ze3ZGSUlkc5DRx0fzp5HNdsSkZgpCFwMBJ4IBGnPBGOWay5vcx7p4ottA3
         GNg76scxuK0IAAS7vBXCh2TJm4LN/VblTAJBVR4+osYfgwYm8LaVArXXZq2GKgpZOK4Z
         zlwp0oM7eRl5JsiUhRCNATSBnKdhgPHsM00TJFxuJjg+GwIFKXBJaESHMzgIPlmgt+Oi
         q4pERNGEY02mtQg6xQdOj0EJrqQ4QEkloHBlvdA2H2+fmNMy/lYGNy3tVNOedoaDy44Y
         8peQ==
X-Gm-Message-State: ACrzQf1LZZmsxPWUDPi7SOKXVyq1RW1VmLclzlUmGIoY8fdM6Gd87cL6
        pVuCVbQunBd1VfR6BK86F3TyyA==
X-Google-Smtp-Source: AMsMyM62BZwEq+cDnFHoakCXh9XB9TybVKc5Dq0tldhGOoH1AK+Vi8gTajzooKthyj2A8ZL4TGP4fQ==
X-Received: by 2002:a63:90c4:0:b0:438:a962:61e7 with SMTP id a187-20020a6390c4000000b00438a96261e7mr10288335pge.426.1663995560635;
        Fri, 23 Sep 2022 21:59:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b0016a7b9558f7sm6924724plg.136.2022.09.23.21.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 21:59:19 -0700 (PDT)
Date:   Fri, 23 Sep 2022 21:59:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     cgel.zte@gmail.com
Cc:     herbert@gondor.apana.org.au, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, davem@davemloft.net,
        gustavoars@kernel.org, colin.i.king@gmail.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: Re: [PATCH linux-next] crypto: marvell/octeontx - use sysfs_emit()
 to instead of scnprintf()
Message-ID: <202209232158.65A31224@keescook>
References: <20220923012952.238269-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923012952.238269-1-ye.xingchen@zte.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 23, 2022 at 01:29:52AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Replace the open-code with sysfs_emit() to simplify the code.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>

Thanks for the clean-up!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
