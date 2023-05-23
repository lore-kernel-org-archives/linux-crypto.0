Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A39C77B75
	for <linux-crypto@archiver.kernel.org>; Tue, 23 May 2023 17:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbjEWRFQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 May 2023 13:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbjEWRFA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2023 13:05:00 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A97BF
        for <linux-crypto@vger.kernel.org>; Tue, 23 May 2023 10:04:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d5b4c3ffeso2337450b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 May 2023 10:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684861498; x=1687453498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhFkuNdU3RaSjvEtwO+y/7ecKvyCxdBlxw2Du+ZEjV0=;
        b=MqpM42aQRI8ph68RBJUNu9y7y5/zbk0lexhnWzEHDaVozMUf2QZJiRhNvzjbOMZyar
         KcyfpLCKEttgYvBwNGF1lrT2UM+BIE/9QpJGfR8c/up0eGl2p8gaM4Mp28AKbtzjb7AF
         5DaO3affYplmoINg1LOMGrb3Dm+GDL/dKas3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861498; x=1687453498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhFkuNdU3RaSjvEtwO+y/7ecKvyCxdBlxw2Du+ZEjV0=;
        b=Z9OV91P/ql1HjQc4MrIGXPWgV60QkmneRiFtieNpGdirgzL56NBAtrzTVrGapX+dfV
         byjmqr5h9qI08a8otHjoHb36H4OJmuA6UhLt/Msn7eZQm9p0qmW5h3cvP3C+XWYFi9E+
         XXRV9D18vIoVE411ESpAZH+DVfNgtjt2j0yvu+/oopkjfkAUzxPeG9OZiLiuoe3rsyqb
         nkxe9BdcdxLu27IzUAiKdIbKOBUbY2XQAk0K3/1S/1qbSWlYeGQLhRHV/t6bJiiSzAcM
         LwxUmaAXbpSnM89m9+XMQ8JxDa/DIn6FUMo3N8zJAjECIzLqtVVlFuhXNBEPuGv1P+Ui
         4xsQ==
X-Gm-Message-State: AC+VfDzUzF8MbRYdD8bQCM7W5R5r0wIakG1fIYTHntPApyZlZJSsfq7g
        xc+2jt7W17bh1cCeylKJf0k7xg==
X-Google-Smtp-Source: ACHHUZ4C5ACZqIuLvNOviGcFe5FNlvLcov5GqImR93+0T2n48F8wmgporLkFQ2YeewVG5bRNiRQXSA==
X-Received: by 2002:a05:6a20:258b:b0:10c:5745:3f44 with SMTP id k11-20020a056a20258b00b0010c57453f44mr3697979pzd.61.1684861498587;
        Tue, 23 May 2023 10:04:58 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h37-20020a631225000000b00520f316ebe3sm6181002pgl.62.2023.05.23.10.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 10:04:58 -0700 (PDT)
Date:   Tue, 23 May 2023 10:04:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - Fix type mismatch warning
Message-ID: <202305231004.DC22DCDC@keescook>
References: <20230523083313.899332-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523083313.899332-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 23, 2023 at 10:33:04AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") uncovered
> a type mismatch in cesa 3des support that leads to a memcpy beyond the
> end of a structure:
> 
> In function 'fortify_memcpy_chk',
>     inlined from 'mv_cesa_des3_ede_setkey' at drivers/crypto/marvell/cesa/cipher.c:307:2:
> include/linux/fortify-string.h:583:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   583 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This is probably harmless as the actual data that is copied has the correct
> type, but clearly worth fixing nonetheless.
> 
> Fixes: 4ada48397823 ("crypto: marvell/cesa - add Triple-DES support")
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Gustavo A. R. Silva" <gustavoars@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
