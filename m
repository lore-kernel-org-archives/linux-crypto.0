Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CA3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 18:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8362A64F91
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 18:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhBCSFI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhBCSEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 13:04:38 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC7BC06178A;
        Wed,  3 Feb 2021 10:03:57 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id r77so546328qka.12;
        Wed, 03 Feb 2021 10:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=knMdGUFjPlqzdqo8ypH5SjTLmJUoCilLmnzQ+eFrD0o=;
        b=NqCGmkeTWcwfTzFskaXWbj5/C0xb4O1mToheHFs34Oygwql4/4o9QL1ugZ6jlloy9z
         R9BnAvsK4r1kjVQmeEYG37abBdpW8elhTtLyDsy42d8qcX+CDun8iZYdjnv3nzOnI30q
         7OOfZLQ3lLRE09I29t8umnOkkOIw5o/pj1dm8jbE4gMsbpWHpS8Qnu0Wo3CjqvibwgdT
         N9jGiK+Z5tMf8fbKfbqA2Y7ENCJxXViKF83xVfv8Vn/APkxWNvOHj4Bmbm2K2pTEWYKa
         GbRWMhXG5qAyEav1KuPoKgpmYmlaTd5QSZl6/qsshxvRJPXz2PiQJWyQPGhLStyURkkn
         Wy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=knMdGUFjPlqzdqo8ypH5SjTLmJUoCilLmnzQ+eFrD0o=;
        b=eMVOYxAVkCskUnUYSoPhjLxTwGAqrywhV/MMJtnPVipVURLP13DKgY0ndK6Mz9Hvvw
         OzwOwUIUJ839IFXRhcabnSxp5jqOE5Vc2HiNvd0AnKONWgEE2KUZxpiJavKSiyb2jE1S
         4qcs5Y33hHxQbxc0VLTCVSlawLzWoHyy3XYR1auiMUM84mDxSf79kUj15VHzwOtuTEzj
         96bMjpJkU4Xs3H9OUdBdGU5KdifqZSUoDwB9sn/hkif94TPpGtBzHAD81VuwZQxSp69d
         4sMC+Tx/VwgGX9hAStY+g6a1B70PiHRmo0w8kPD14RLQ2wtOLKZrmCYPVMtz4bHivol5
         5lbw==
X-Gm-Message-State: AOAM530KHfDxm0QptWuMgSYfvoNtuxox7wBie/qwDQVDlogHEfRDL/WA
        VI+u+xthZlcth8Hyk1tkcJw=
X-Google-Smtp-Source: ABdhPJyBlBUclK7+Yb06W3HeoE6EV16dCjPfoS1qHqIzoWqYlLdeTJeD0z+Ne3mn+2ZRrkk6LFOy3g==
X-Received: by 2002:a37:8d85:: with SMTP id p127mr3641276qkd.393.1612375436862;
        Wed, 03 Feb 2021 10:03:56 -0800 (PST)
Received: from localhost.localdomain ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id m10sm1933785qtp.72.2021.02.03.10.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 10:03:56 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     ardb@kernel.org, daniele.alessandrelli@linux.intel.com,
        davem@davemloft.net, elena.reshetova@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgross@linux.intel.com, prabhjot.khurana@intel.com,
        wangzhou1@hisilicon.com, xuzaibo@huawei.com, yumeng18@huawei.com,
        saulo.alessandre@gmail.com
Subject: [PATCH v7 4/7] crypto: add ecc curve and expose them
Date:   Wed,  3 Feb 2021 15:03:44 -0300
Message-Id: <20210203180344.2418055-1-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128050354.GA30874@gondor.apana.org.au>
References: <20210128050354.GA30874@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/01/2021 02:03, Herbert Xu wrote:
> On Fri, Jan 22, 2021 at 03:09:52PM +0800, Meng Yu wrote:
>> 1. Add ecc curves(P224, P384, P521) for ECDH;
>
> OK I think this is getting unwieldy.
>
> In light of the fact that we already have hardware that supports
> a specific subset of curves, I think perhaps it would be better
> to move the curve ID from the key into the algorithm name instead.
>
I think I understand you, I'm not using ECDH at the moment, but IMHO maybe
we could use enum OID of oid_registry.h as curve ID and eliminate the 
duplicate ECC_CURVE_NIST_{...} from ecdh.h. Or perhaps put another param
in struct ecc_curve with OID, because the name already exists.

> IOW, instead of allocating ecdh, you would allocate ecdh-nist-pXXX.
>
> Any comments?

I recently sent a patch for the ECDSA signature verification, that use
the NIST-P curves to check elf32 binary modules and signatures in
about 450k T-DRE voting machines, in the Brazilian Elections across
the country. I put the other curves because we started testing them
(P256, P384) for speed measurement, but we ended up using P521 in our
production version since 2017 in the 4.9.xxx kernel, and now in 5.4.xxx.

In this patch I'm using akcipher allocate like ecdsa(sha1,sha256,...), 
because the ecdsa algo is generic, and using the curve name and ndigits
inside vli_mmod_fast to discover the curve, but I agree the correct way
would be allocate ecdsa-nist-p521(sha1,...) and have all params for the
curve inside strut ecc_curve, remembering that we have anothers curves 
incoming, like Edwards.

regards,
--
Email: Saulo Alessandre <saulo.alessandre@gmail.com>

