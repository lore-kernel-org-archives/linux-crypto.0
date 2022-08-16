Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD735C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 21:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiHPVZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 17:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbiHPVZF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 17:25:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D24C8C031
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 14:25:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u133so10408313pfc.10
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 14:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc;
        bh=8Amng6YoiqozAIVij2nRbBRsRD4os4wIizhXtq1ZhIM=;
        b=JU5YKOF8ST+7lmXSaIGl2xmKFlMp4aIjqYnjhq/pm1YVkGHRnofmnfMs6jRIjV91Sg
         pcA2s1mBlmC6ZnUNIo1HvahT2eZCT3sLTZBEAuRkKpOAeVXQp/a9PgwCB45Ij6cqPlqZ
         lJvyiZlKJsunotsNYkxpbeBgRcCjvkicAJ2JNwgnjSzso9tH8+TN9qjE/hg24N7i0VlJ
         TKCoY/Fc4tR+dps8a8jgtxQXk7ps8n0pc/eeOChy94oNJ3XPS2HCnzGw63D/+g32wC4/
         0cOeH7275Eqjvy7LNQ/KDy14DuahLDkjDO30efP0dPl5ftYuzXq33/BQNLSn6rjmyQQf
         LhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc;
        bh=8Amng6YoiqozAIVij2nRbBRsRD4os4wIizhXtq1ZhIM=;
        b=HYHf7WU4CfrblIjHrQUGTvixv++StQqqzjaKXQ2/wvQ5JUCexrXDWjTijpGsPCTe5a
         1fDvfgoLBmmjAWaKBqGUrDZxOGGxLdKyAKMLZkStozyBMbd0zdjufFydV88yos2EeqV+
         D+CeexhaFZ62MgZGaPGUh242a51Vymctm0v9gxzr7fx3e7y80qwsaEH8R9YqiGWD+iUr
         Nd/9VMDwpqt4Gr0u6fc9c4r7r+gR5NxxDnKhztcRuGc6COguGU9LkbtmIZ+WXZYR1uqM
         xAufCxJA8GmrwJhdi/eLd8u1UvVpvnHswe73EeAbbPBP1Y6mkW78oolmlAWF/Et8Yl1h
         Q5sw==
X-Gm-Message-State: ACgBeo25U9gUF1puvFaCCOEBDn1NZLnwChnfHbr66E0W97vO4xLURgA5
        1V0gkeKBMQyOI3r7I9M9u3H2/w==
X-Google-Smtp-Source: AA6agR5R5Kj3uVfXAFoRFlCQgud1WTbEFfP3qJ63IkGvDH4uKnWa2djCyKmFA5pUUw+fuOaC6bQy3Q==
X-Received: by 2002:a05:6a00:ac6:b0:530:3197:48b6 with SMTP id c6-20020a056a000ac600b00530319748b6mr22661088pfl.80.1660685103947;
        Tue, 16 Aug 2022 14:25:03 -0700 (PDT)
Received: from [2620:15c:29:203:9a1b:5709:54ba:ae28] ([2620:15c:29:203:9a1b:5709:54ba:ae28])
        by smtp.gmail.com with ESMTPSA id f7-20020a623807000000b0052acb753b8bsm8826938pfa.158.2022.08.16.14.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:25:03 -0700 (PDT)
Date:   Tue, 16 Aug 2022 14:25:02 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Jacky Li <jackyli@google.com>
cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: ccp - Initialize PSP when reading psp
 data file failed
In-Reply-To: <20220816193209.4057566-2-jackyli@google.com>
Message-ID: <8feee515-8d60-dc84-4c9f-6723481e8dac@google.com>
References: <20220816193209.4057566-1-jackyli@google.com> <20220816193209.4057566-2-jackyli@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 16 Aug 2022, Jacky Li wrote:

> Currently the OS fails the PSP initialization when the file specified at
> 'init_ex_path' does not exist or has invalid content. However the SEV
> spec just requires users to allocate 32KB of 0xFF in the file, which can
> be taken care of by the OS easily.
> 
> To improve the robustness during the PSP init, leverage the retry
> mechanism and continue the init process:
> 
> Before the first INIT_EX call, if the content is invalid or missing,
> continue the process by feeding those contents into PSP instead of
> aborting. PSP will then override it with 32KB 0xFF and return
> SEV_RET_SECURE_DATA_INVALID status code. In the second INIT_EX call,
> this 32KB 0xFF content will then be fed and PSP will write the valid
> data to the file.
> 
> In order to do this, sev_read_init_ex_file should only be called once
> for the first INIT_EX call. Calling it again for the second INIT_EX call
> will cause the invalid file content overwriting the valid 32KB 0xFF data
> provided by PSP in the first INIT_EX call.
> 
> Co-developed-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Jacky Li <jackyli@google.com>
> Reported-by: Alper Gun <alpergun@google.com>

Acked-by: David Rientjes <rientjes@google.com>
