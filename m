Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBB9C7EE23
	for <linux-crypto@archiver.kernel.org>; Wed, 31 May 2023 16:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjEaQb3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 May 2023 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjEaQb3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2023 12:31:29 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FA6129
        for <linux-crypto@vger.kernel.org>; Wed, 31 May 2023 09:31:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b04782fe07so22504215ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 31 May 2023 09:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685550680; x=1688142680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ByzmIR8bdGAXP2o41OwIixgXQi8QYuh3izNby61Iy4=;
        b=hbrIeOvaeAKyyvxHsoe7u4SWuGGCrkUeYy9BIzH3pyZFfF87fzRN4hsBFOI/2I8AAX
         c/uIbxHraDc7ffkJ/UgVcHCW2LDjOCDYPpUcVZ5sVfalNIU3me49YUi6YEKMRIT6CAB8
         ZHYplMOe/l48NyiEudrdmRuN8OuSuhtSJp/1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685550680; x=1688142680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ByzmIR8bdGAXP2o41OwIixgXQi8QYuh3izNby61Iy4=;
        b=Wqr8/nhA0KwX9E/gxyQGxEBT38Q7AbW02yNPCbFIfZObgfEBzJmC/qEWzz+RAiJ0IM
         cGgNMnqZWKEU4NjMpakDnPbwzMC7MAZkNCbe0mC7FTjZ9RMXhXOnZDdp+/fq2Hk7p6bf
         XBHv3cW1T5djm4Dadv5LyXq8YLNywgNiCE+nZ2EV7+7gYKj1UosGgXVrdyu7JZhBxDJ/
         TXlxTJMwB0M34uCCpK9Tn4on5ttXKlEIpV13sYuhHyyDm2oJfoUACmrMWWY3fU1zVdtO
         u+fWSNI6sS2F6zlaw56k9Hz8gcx9ajTYTyC2o4hRL25fZeefRmBJ3qNWS+bSqlldL6dS
         1g+w==
X-Gm-Message-State: AC+VfDzNKE3l2MKcWLEUQYmCvGgb4N1hORebrRERgaoeYKsXfee6Q3bt
        e5x+Y4hviJAzoQEOOU8uiqBGKte7qjLGc6KIc2s=
X-Google-Smtp-Source: ACHHUZ7+YRicU2hUq7DYy5WQBOqTFZW3O0RNpTvYGxbuQd/k91gpcaBhaOTyIxRwClClVq5v5gXBbw==
X-Received: by 2002:a17:902:c94e:b0:1b1:8aa1:3a2f with SMTP id i14-20020a170902c94e00b001b18aa13a2fmr930782pla.27.1685550680219;
        Wed, 31 May 2023 09:31:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z3-20020a170903018300b001aface7bdd8sm1608614plg.31.2023.05.31.09.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:31:19 -0700 (PDT)
Date:   Wed, 31 May 2023 09:31:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     arno@natisbad.org, arnd@kernel.org, schalla@marvell.com,
        bbrezillon@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - Fix type mismatch warning
Message-ID: <202305310930.844EBEA21C@keescook>
References: <20230523083313.899332-1-arnd@kernel.org>
 <168548692863.1302890.6789778742527600870.b4-ty@chromium.org>
 <ZHcoQvWnzO0c1Cp9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHcoQvWnzO0c1Cp9@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 31, 2023 at 06:58:10PM +0800, Herbert Xu wrote:
> On Tue, May 30, 2023 at 03:48:49PM -0700, Kees Cook wrote:
> > On Tue, 23 May 2023 10:33:04 +0200, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > > 
> > > Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") uncovered
> > > a type mismatch in cesa 3des support that leads to a memcpy beyond the
> > > end of a structure:
> > > 
> > > In function 'fortify_memcpy_chk',
> > >     inlined from 'mv_cesa_des3_ede_setkey' at drivers/crypto/marvell/cesa/cipher.c:307:2:
> > > include/linux/fortify-string.h:583:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
> > >   583 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > [...]
> > 
> > Applied to for-next/hardening, thanks!
> > 
> > [1/1] crypto: marvell/cesa - Fix type mismatch warning
> >       https://git.kernel.org/kees/c/37f3abddda8d
> 
> Why did you apply it to your tree? This patch makes sense on its
> own regardless of the fortify changes.

I snagged it since a week had gone by with no additional discussion and
it fixed an issue exposed by work in the hardening tree. Let me know if
you'd prefer I drop it for you to carry instead.

-Kees

-- 
Kees Cook
