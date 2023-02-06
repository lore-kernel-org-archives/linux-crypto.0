Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3554C64EC4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 17:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjBFRa0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Feb 2023 12:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjBFRaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2023 12:30:13 -0500
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E22887A
        for <linux-crypto@vger.kernel.org>; Mon,  6 Feb 2023 09:29:09 -0800 (PST)
Received: by mail-qt1-f174.google.com with SMTP id c2so13660895qtw.5
        for <linux-crypto@vger.kernel.org>; Mon, 06 Feb 2023 09:29:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FrP9fMYR82jRAmAW0QmGxlvWeMEFDYdTqEQD3Ix7oU=;
        b=x1RB3YSiShSN2O4F0U0D7azzYfLZDl7lwsxEJQutW8Gmnjsym/nYmMfR1vIBz5MMI2
         c/ayIgsa3p87Cpgw40pvhJ38ltWqqqFxon/NrCo2EQ9OhvT/K9ad0mCe/frUQoUbQoIV
         kiabTC0BjLHbK9yyTuXoGc2cffwddAGMW0PG2Kq1IvtI6oXXTI6H+YZ9Yx2zmluhPNMJ
         ZBy3vP2t8gme7vYo9KZw+oYTC6BCqhWi+UYrn0YjWXlzurFml6wKEDUXWhNSelkEl5lF
         v4FK1CnvVuJ+d/OWGH2mF8WAXCdWkxMApOgWod7vTCWGnwu4Yfuyg5RaVo/zgFh79Pw8
         8fgw==
X-Gm-Message-State: AO0yUKUxT583TgsyajEFagNfNEloYwDcvSfc/iLs9OoJ2S/PeLG/Iq0C
        6lxIoTdZCeipFpkUXlJcAMZy
X-Google-Smtp-Source: AK7set88PegyfxPSUhpDYL1wKeHEutu8R092IP6zZRvoiYjEuTLO6pmSpIUQElcD/sBIBkgW1V2HAg==
X-Received: by 2002:ac8:5f95:0:b0:3ba:266f:103b with SMTP id j21-20020ac85f95000000b003ba266f103bmr38942qta.47.1675704548352;
        Mon, 06 Feb 2023 09:29:08 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id b5-20020a37b205000000b00719165e9e72sm7647589qkf.91.2023.02.06.09.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 09:29:07 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:29:06 -0500
From:   Mike Snitzer <snitzer@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 1/17] dm: Add scaffolding to change completion function
 signature
Message-ID: <Y+E44kb3bJViytuh@redhat.com>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydY-007zgU-U2@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOydY-007zgU-U2@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 06 2023 at  5:22P -0500,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch adds temporary scaffolding so that the Crypto API
> completion function can take a void * instead of crypto_async_request.
> Once affected users have been converted this can be removed.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Mike Snitzer <snitzer@kernel.org>
