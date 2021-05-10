Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD7EC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB9A61104
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhEJGfj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGfi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:35:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9E8C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:34:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i190so12865427pfc.12
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=HGBIj8xUCvLd4pR92wcGs7mrQ/wDR/glW14gv4YWYBo=;
        b=FSkP6wfYfoiAqoFvwcrgIlb23ul8X3ysCcFJFTMF5SkPwiSpWGAwpDdGazSHkyjpry
         3HWhIJt8eE2wzfExp8DekB/vPL/66FIDevxZbocnKC7eVumawLEMNhdb+QQvmOqPDQDn
         RAIq9BKjJeLsY25YtIDLKef7run85JCrFhgwBZoc6PpIDcNY2XbD1Ldt3QUVcy7xA1OY
         oNLES/7XtUXULfoZuH5m3wUM/qYFz6bzhl3B5K4FEd/uGoGCMJBh5zwMXFtpWxnwCn6L
         0FgB3nzDfwdrA2/yLbyI/CkND0sQhV+RXehT5qYgpiij4KQCo//LNsbzcQ9LiBBUimcr
         0kAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=HGBIj8xUCvLd4pR92wcGs7mrQ/wDR/glW14gv4YWYBo=;
        b=HVIFX6hL+kCmvRYbTXjiqRMBNd3qXduWjvWt7Hu4o0/O8dC3gjsHq1Odk6QsSdVK7R
         OoCCH9a0Q1TkaTCqKDVoiYMUxw4ULCN+yh99J6Un59u0Pge3R6rw3+Hvj+IoZq23WKYx
         08KoxtRwPjTYvblErOdGt2ZITL2+UG0MfYwsVSmqueYUFM7DeibXXrnCAM8mV0p0Ch7E
         oljgxWaf6OsZKjkDIpSAE58zLUD7geMeDaETMYUANYytA5pisejj7UAi4/0NAcX42JRE
         h04keCWUAdstn5WKhvg/g+cqEMsXMIRvS99E769wB7FhyEBS3vv4tJONyYBdpKPCSzhn
         F6Lg==
X-Gm-Message-State: AOAM531eUfSWLYyFLogu1So7E3GFG3M0VCVKPvGwSE66vbe3SsFpjeL8
        Ei41dKX9mpnxaTIbIH3tJl4=
X-Google-Smtp-Source: ABdhPJzKjkEWER95RQjk6gSGm+pfadu3RCzIx7RnZbs6Tbke3SB1wLEpbFBChpx80zNtTXx1WGBJnw==
X-Received: by 2002:a62:1b88:0:b029:1fb:d3d0:343a with SMTP id b130-20020a621b880000b02901fbd3d0343amr23667445pfb.76.1620628472772;
        Sun, 09 May 2021 23:34:32 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id y23sm9999389pfb.83.2021.05.09.23.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:34:32 -0700 (PDT)
Date:   Mon, 10 May 2021 16:34:27 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 12/16] powerpc/pseries/vas: sysfs interface to export
 capabilities
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <60176ad795219afbeaf51ad596af4bae710617b7.camel@linux.ibm.com>
In-Reply-To: <60176ad795219afbeaf51ad596af4bae710617b7.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620628126.jezp40t2h6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:10 am:
>=20
> pHyp provides GZIP default and GZIP QoS capabilities which gives
> the total number of credits are available in LPAR. This patch
> creates sysfs entries and exports LPAR credits, the currently used
> and the available credits for each feature.
>=20
> /sys/kernel/vas/VasCaps/VDefGzip: (default GZIP capabilities)
> 	avail_lpar_creds /* Available credits to use */
> 	target_lpar_creds /* Total credits available which can be
> 			 /* changed with DLPAR operation */
> 	used_lpar_creds  /* Used credits */

/sys/kernel/ is not an appropriate directory to put it in. Also camel=20
case is not thought very highly of these days.

And s/capabs/caps/g applies here (and all other patches).

Thanks,
Nick
