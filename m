Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E157C77B73
	for <linux-crypto@archiver.kernel.org>; Tue, 30 May 2023 22:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjE3Ws4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 May 2023 18:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbjE3Wsy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2023 18:48:54 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A913CEC
        for <linux-crypto@vger.kernel.org>; Tue, 30 May 2023 15:48:52 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-53f70f5ef60so234175a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 30 May 2023 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685486932; x=1688078932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99ubBmKAtal9ov3803GoR+21e+FgeWOsucCxQBKs674=;
        b=YT2bb4MCyOTr91hgg+9DRVqf/odg8pMgOXdB7UU7tyowTWkoE3uz6xFCP4z+UsH4pw
         5DK0+XWBXYXUDipIdD/maEgVXjP4Q8mKZ8Ky+2t5z7hiTslUYv3QBOcQeJ355wwkRm1f
         TPqVLeuKvAuqkqEOip+4FvIqxMgIaBIVPoVfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685486932; x=1688078932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99ubBmKAtal9ov3803GoR+21e+FgeWOsucCxQBKs674=;
        b=HuHBmJE5C2pmG3djUTgnCZ57PgmiRGg2gTTqxgOZTkVwfd20VK6I2AD6K5ssdo4/NH
         E2a7NGiha/dOHzrkb7anbfoSM8aLkzn+QCVPvK5dvZAQpSFfYEFyoq8C1eFA1ozXtbRU
         tEp6bhXnt7Tyca4BBBr1WkZ584eoYsZxK0ge293vQ58lwRpbVx2a0g3sV/GWHLmyTWqt
         VzVlFklVIIsuGrjTnoPRTPzT00e9Vz7hv4G3xEGaKP6SaO/O6QVr1Rv913b0w34K4nhM
         h64tbmvphekyLA+e2VM4Hlp32PefHK74DN0GL0K4fLzcw0u/l3nbLsjEBzE5eSUYTtkJ
         FIng==
X-Gm-Message-State: AC+VfDzqbXnu5dppZddKNU5UzpZkc9U+7xe/6RsDVX3SEKKslennfK5H
        iF5d4ZVBaeNuXKyVvYE/k+3DKw==
X-Google-Smtp-Source: ACHHUZ4ZfX0kxGPUegN/GzRK8B0dJT+aiebhYPAYaCZ+ZPMwmlkqk68mb6hZFGglN/bPxdauoAi4kw==
X-Received: by 2002:a17:90a:bc88:b0:23f:9445:318e with SMTP id x8-20020a17090abc8800b0023f9445318emr3957040pjr.3.1685486931842;
        Tue, 30 May 2023 15:48:51 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n20-20020a17090ade9400b002508d73f4e8sm58034pjv.57.2023.05.30.15.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 15:48:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     arno@natisbad.org, arnd@kernel.org, schalla@marvell.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        bbrezillon@kernel.org, davem@davemloft.net
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - Fix type mismatch warning
Date:   Tue, 30 May 2023 15:48:49 -0700
Message-Id: <168548692863.1302890.6789778742527600870.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230523083313.899332-1-arnd@kernel.org>
References: <20230523083313.899332-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 23 May 2023 10:33:04 +0200, Arnd Bergmann wrote:
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
> [...]

Applied to for-next/hardening, thanks!

[1/1] crypto: marvell/cesa - Fix type mismatch warning
      https://git.kernel.org/kees/c/37f3abddda8d

-- 
Kees Cook

