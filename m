Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA07CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Dec 2021 05:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhLHF2A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Dec 2021 00:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhLHF14 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Dec 2021 00:27:56 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E5EC061574
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 21:24:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id x7so1161039pjn.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 21:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3LWpn27xpBvngeaGA+vOksGc0Why3OU0y9bZknS30xY=;
        b=M3HJ4FCR8wWK0d84r93J2nDa4lCm1c5zm1NoLHg5U9JpTIqEWmrj5XLpDFuFhBW1cy
         7PZwxRg+A4t5xGsPeAVZ3rA3sTbQTJuk6KGYiaFrgIpK7U0cCM2waeIjsjvVPMq9plwA
         FQCFWQkSiqiQXMZtTCCFh5ESNIlrSp1NZ25ek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3LWpn27xpBvngeaGA+vOksGc0Why3OU0y9bZknS30xY=;
        b=vOTrl7s7Jz9mOCVoMxWGaN1TM3jiIFju8aztxBdw/oqVZ2boT4dIc6qb8xI/45upJk
         WJFqXs4bacyFT96ED8ZiaZNECcfSrFqgAAoinBXBGhrkTT1YODLq6kPvuguQrAmlMkPy
         Am/ymjevqApUf7ou8eIen8MPH/mrltAfDZjCCEsyCNB8aP3T/9gDfOvFik2VgBcpc3JA
         2nQxkZ43Mco9+8RTAuJAXsgfHnpBGe5sN3dxw7XXDsAyoaxDvPrLf8h7KVtP062PZuEk
         nt8cFGOW7Vwl/iAF2R9yvW+mwcnUl6H7n3iSgiu/NnpvsrPZig3iI47qdeBr5D4lJ1tE
         qRww==
X-Gm-Message-State: AOAM533Nt2YDKyb5Tk6bkFbDuRp+LdcrchbVuDYgaGyVyouMgryG2gwg
        Klag/Fj5n7l+C/fpI5LpPxsKNQ==
X-Google-Smtp-Source: ABdhPJyxArWbqyNOBKeJzP4ix4N263bd5ndDZkW6Qg7gzPdWajoqDpQ0Jb17t5yCQuGAHGQfNHPupg==
X-Received: by 2002:a17:90a:657:: with SMTP id q23mr4510814pje.21.1638941064876;
        Tue, 07 Dec 2021 21:24:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j1sm1634961pfu.47.2021.12.07.21.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 21:24:24 -0800 (PST)
Date:   Tue, 7 Dec 2021 21:24:23 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: marvell/octeontx - Use kcalloc() instead
 of kzalloc()
Message-ID: <202112072124.B4642C7@keescook>
References: <20211208041721.GA171099@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208041721.GA171099@embeddedor>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 07, 2021 at 10:17:21PM -0600, Gustavo A. R. Silva wrote:
> Use 2-factor multiplication argument form kcalloc() instead
> of kzalloc().
> 
> Link: https://github.com/KSPP/linux/issues/162
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
