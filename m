Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DE7C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 15:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A651C20835
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 15:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+AP021v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFLPwF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLPwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 11:52:04 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A597DC03E96F
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2020 08:52:04 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id d67so9078683oig.6
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2020 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9kz8AERaPiTJbAZG6MShvL8NjfCcS5uVMTJomAkemfY=;
        b=Z+AP021vDFwAnBd3I5STvHHSLsysFOzVw2FeNWsGR267xTpxswMSjufZhKkBZnpsmB
         bnql0K0n2rh0io6c+Ag1OcCjkxb9P/4rVJ0lvLmymWjcSbfmPejWZusGoavHa/G0u/90
         NLEQgzWIJx88M1bS5iFi+JjG6llV8rB+XYFh1dnELv9OBanzUvBGozjv//EOv83mHuvO
         HukLZ5qgDkQlmpgoyd0VfhPkXiN5SOOfguyEY9eho7mAk6m1pQduhfM7yxcwgOmYzhMS
         M2+FVA6RlW5Q3QuQQA8NpkFRqh9BQIkk5ul/aEeu6RN4PnwrGd69eNMSpdYukjoGwOyA
         yJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9kz8AERaPiTJbAZG6MShvL8NjfCcS5uVMTJomAkemfY=;
        b=UxL4ADanEKMgQSH6LSC62BwRptAv+A/DFZxTiEfa+z9BFlDxGTk+zNEhOQYZKNr0Ux
         bao6DCx9B6YxJx7Z3UYpOHIZL5XR/7K5wbanE4IfeYEzmt83MNxK2TbFQ576aUjdn6MS
         Y2+29QvtxC/Uc06f8PnR312hObxYH83iiziouYQDzM6xBblgQXoZT1ojpFfZKkGWDj77
         hGrEnc/IWwnqh8kh1mD6VskeYkHtepJFFjo7BeSllWY4KwIBz82d5HtASqz2VYvfCPd2
         v27Ydy2kxDZzzRCXQCH3yCNOKNXsCaKZONfSLgS31QXyyRmHXSPt0vYdb6eHJO1ZKaqz
         iCuQ==
X-Gm-Message-State: AOAM532nouCcisMtYoC9bbEB8JGUaWOfq6pjMvWlnwFWARhbU0XbjdjI
        XhxJ2RRS/++eci4mjPBF6NxjwaDxIP7lIWX1IquqLg==
X-Google-Smtp-Source: ABdhPJxmYyqfNuTTIt1ZdONPVO7IqRSVtEQbLUt3x/fCVN1t/A+vLd0ZINfs6f1lfs97FLWUyX3xJZnEOsEpZ4t7oAA=
X-Received: by 2002:a54:4102:: with SMTP id l2mr2723497oic.29.1591977123637;
 Fri, 12 Jun 2020 08:52:03 -0700 (PDT)
MIME-Version: 1.0
From:   "Peter P." <p.pan48711@gmail.com>
Date:   Fri, 12 Jun 2020 11:51:52 -0400
Message-ID: <CAPVaeBk1S44EzHgXh=g_1LaM+rMDd=zLPB7M=1GLoG78MvYz5g@mail.gmail.com>
Subject: HMAC Selftests keylen in FIPS mode
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

According to NIST SP800-131A Table 9, HMAC generation in FIPS must
have a keylen of 14 bytes minimum. I've noticed that in the crypto
algorithm testing framework, the HMAC test vectors from RFC 4231 all
have a test case that utilizes a 4 byte key.
Is this permissible when operating the kernel in FIPS mode and if so
how is the 14 byte minimum keysize enforced?

Thanks,

Peter
