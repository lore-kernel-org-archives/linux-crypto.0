Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B16EC35666
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 19:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D023B20722
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 19:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="x5u940o4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgBUTzy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 14:55:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36934 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBUTzy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 14:55:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so3362113wru.4
        for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2020 11:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/RkItNieDgV0spCBrAvgEKW6jVdvnCXvHYuZAXnr8OA=;
        b=x5u940o4PeMZz2zVQ/GgLDPvzLJ6lEY39zGpB6qUtCALbWWKmQaVV3Y3/YnyXXOW4q
         wz98PZAHt6fk9wghSdnefuCgGUaxGVKrVYqf2hxKyBzO77vsiPIlqBDmrDh7XNgoFFok
         W8k1IeN+CgHIlCXZMyBtbWARspburRc0CAe3AtIO78A3BNELLFeh/r22R9UZja2npkHR
         KLCC0KryrADvmUm8J5b7HXXWJpeWRK+jMDJn7C1cE+TxpqUfpevGO5EKtWObGYp+97Si
         daBjhDePFtR5sLz4BDDshyr+KTaS+pqcYssnMGixj3kj/VhFvMLeFfKHBvbLqcCSlsbW
         UOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/RkItNieDgV0spCBrAvgEKW6jVdvnCXvHYuZAXnr8OA=;
        b=mzLoP0c06dM/L3gW1+/Qw3+K6h4lc1X35NOxnjFyi7n567N55/FXHSBJa1MVCHqOhR
         hL4Kevw14Ol7GAmXifVrdPlCrAmNmWAnNfWmzjo46O5lEz4CHvH3HMsqS8Zzk7o9yGiN
         KxzhlIot+kF/cfOe0QVo8G6QSdHQ67T+GTa28m2emAFPOwfmMv1Xab2q/UQXaCwlV6ce
         4hXvRmZsIt/+9jNo13+zTyOh7EdVUic+hkKooJl8zGyqgS7nsfBhm7GkAbMMxzAJxlur
         a1nFMounHAfG0nYFzSW9HCP9rQfpeshhSKX5hFwbFooqU+U4LJKsx8mwEC+Z9Sp0whsw
         l4sA==
X-Gm-Message-State: APjAAAXno6EGCjqG2qttWI2n6Hx3ejbEMmdA2L6PeZYr/YRPONIkpplA
        Rul7ZAZBbcm43mtmEtdWmVzK/g==
X-Google-Smtp-Source: APXvYqzuKtU50Hh3qFOFhMh2kC8UV6DBRqImeOmDnHM6EvrvnQ2IZngIOzQKoWMqRuLAwslEHRLoXA==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr21913792wrs.111.1582314952493;
        Fri, 21 Feb 2020 11:55:52 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y12sm5130730wmj.6.2020.02.21.11.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 11:55:51 -0800 (PST)
Date:   Fri, 21 Feb 2020 20:55:49 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH] crypto: arm64: CE: implement export/import
Message-ID: <20200221195549.GA29499@Red>
References: <1582128037-18644-1-git-send-email-clabbe@baylibre.com>
 <20200219181654.GB2312@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219181654.GB2312@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 19, 2020 at 10:16:54AM -0800, Eric Biggers wrote:
> On Wed, Feb 19, 2020 at 04:00:37PM +0000, Corentin Labbe wrote:
> > When an ahash algorithm fallback to another ahash and that fallback is
> > shaXXX-CE, doing export/import lead to error like this:
> > alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\"
> > 
> > This is due to the descsize of shaxxx-ce larger than struct shaxxx_state off by an u32.
> > For fixing this, let's implement export/import which rip the finalize
> > variant instead of using generic export/import.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  arch/arm64/crypto/sha1-ce-glue.c | 20 ++++++++++++++++++++
> >  arch/arm64/crypto/sha2-ce-glue.c | 23 +++++++++++++++++++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> > index 63c875d3314b..dc44d48415cd 100644
> > --- a/arch/arm64/crypto/sha1-ce-glue.c
> > +++ b/arch/arm64/crypto/sha1-ce-glue.c
> > @@ -91,12 +91,32 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
> >  	return sha1_base_finish(desc, out);
> >  }
> >  
> > +static int sha1_ce_export(struct shash_desc *desc, void *out)
> > +{
> > +	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
> > +
> > +	memcpy(out, sctx, sizeof(struct sha1_state));
> > +	return 0;
> > +}
> > +
> > +static int sha1_ce_import(struct shash_desc *desc, const void *in)
> > +{
> > +	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
> > +
> > +	memcpy(sctx, in, sizeof(struct sha1_state));
> > +	sctx->finalize = 0;
> > +	return 0;
> > +}
> 
> Can you use '&sctx->sst' instead of 'sctx' so that we aren't relying on the
> 'struct sha1_state' being located at the beginning of the struct?
> 
> Likewise for SHA-2.

Yes, I will do that, it is better.
thanks

Regards
