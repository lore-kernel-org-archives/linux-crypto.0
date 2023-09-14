Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD484EDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjINJeV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbjINJeU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:34:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557C0CF3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:34:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bf6ea270b2so5426915ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694684056; x=1695288856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLKvLEyNkkEtyLZ8aisjGHX9nZ+6v7eA7orNE/bu7hg=;
        b=VpFPq4xtJ4sM7mdJgS2OmpNFu8yX2unBgrxmMshPIenJx2LKDdZIRp+VLnRLzcEBaz
         OZkDn8L+Dnxsh0xPX9q4+XjhUikuvscMEK7/f0RVYeR4hWgoO9SUmBoNgk5EQB3VAHXm
         XzijCUMvJoLdFrGQd+EbxsgL8x7Xr5jRzdr0SwdsIllPnm0eALu+Cq/8GMKUb05AyC0J
         mxZa+DpUF1rNomAC1T404IazqWTokbk+iW2vWO3bVx/n0K52HgrKKYwblESRd1qLssmR
         ZPS/2ybfZyYA3cw+/z+Sni0ZRC3IlfZx5u9lZSWnsthxb3L5M1X2MEaaQu4426X3QVit
         fjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694684056; x=1695288856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLKvLEyNkkEtyLZ8aisjGHX9nZ+6v7eA7orNE/bu7hg=;
        b=cMshnGyXWqKRfzhogrhXZ8ffz70LE69ukfWKYkXgA2Vs6NwZP/WgjICUUssswlw/J3
         XyHJqh646QB8dF/FP/wLtmlmzEpTtNpRokz7VcnrG9oBABaFaMlMHKXbLXAIJjpgWPOU
         YxJn7RwnB3aIyw8QALQ8Dc1BbP2vF9ubI0xBxamftj6cwzmqtdlam1F0HYftD2lpM/wZ
         4zDtIYMja1W+rpt0qCswKa74BEismg4uWysxadaXCT0ulVGKEKZ90rrJwU0h/FL0d/ME
         iKf6jdCtuMFDuqi2Wxl91W0LHdqnGUTh03UTYhb0hFpb83I+nLA8dS7rBPpddlGKdlh3
         eJiQ==
X-Gm-Message-State: AOJu0YyC6XWh4cfNiCyoeiuB+ZfEphnLPmFGridjUL2Ujh3+9kriuwqn
        jlydrNEYvWEyJMjibOZzQVDNf5K3kYZE/w==
X-Google-Smtp-Source: AGHT+IG+VXX4EmMzxggcuaLsljMIYiES4z21ssxQs+hE6Zz5AE1IuLdEcXSbaKz8Xp4qsUGtsn5Lwg==
X-Received: by 2002:a17:902:f54b:b0:1bf:6cbc:6ead with SMTP id h11-20020a170902f54b00b001bf6cbc6eadmr6230529plf.22.1694684055691;
        Thu, 14 Sep 2023 02:34:15 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709028bcb00b001bb97e51ab4sm1122844plo.98.2023.09.14.02.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:34:15 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Thu, 14 Sep 2023 17:34:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
Message-ID: <ZQLTl26H8TLFEP7r@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
 <ZQLK0injXi7K3X1b@gondor.apana.org.au>
 <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
 <ZQLSlqJs///qoGCY@gondor.apana.org.au>
 <CAMj1kXE6mo2F7KgGmpygEs5cHf=mvUs2k3TT-xJ1wKP_YNGzFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE6mo2F7KgGmpygEs5cHf=mvUs2k3TT-xJ1wKP_YNGzFg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 11:31:14AM +0200, Ard Biesheuvel wrote:
>
> ecb(aes)

This is unnecessary as the generic template will construct an
algorithm that's almost exactly the same as the underlying
algorithm.  But you could register it if you want to.  The
template instantiation is a one-off event.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
