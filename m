Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B56DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 14:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D4FB64E01
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 14:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCRORG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 10:17:06 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:30591 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhCROQj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 10:16:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616076997; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GghroYpVEwH7LdcJxtFF7PvJ3ez/CG7o6n3DKcjzr0JNvNbKuyYd1YtQpAHgpUFTHB
    N8wX4ciZmPlR6lV6MZlfqYW29rveQH2rp/7LkXHe7huEtpRohf9F/rR+L9bGhazQBS7V
    QRpeesiievz1eYDFrutYcfdhMM6AG/D9vr9PTbKgjz6KJVVWU8Mw5vzOhhByERNYXDht
    qIvGobh8Ia9Epjn2NE5X0z4z147nVBmKor5e6/5gwWaaCh0xrwMydM/7EuEMdX8ymPjj
    BurTuHfZ23wY0nyC+EC0M4w4vaT3PSfer4XzNB65JpKtQH0MKppYZl51HquO8xs2psll
    oL5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1616076997;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ah5MiRuEKqCOmCg+F4sxbaF3TYwHXQheOtW54ZsXpCw=;
    b=gqxLjQWMoFNcQ/TqGAgtNajMD87pH7eh2tB9hNMBX6zYZ/I3EEW5jxMbLWaACeewig
    q4rw+1QOhURE0kg7CyvDzGWPL8iYgYkwD7+QQxPKHe1+ZQTEtEgKmyn34mHeijWuNhef
    ga10HtCLQ012Usx0/Dsq86vH079bouQAJCxMVLLwg3DUPxP8L3YdrTdvPpdTvxhrN8D8
    5gpSUPk90InXASMUtABIqampKHfL0ndmn/BzxtRfcYe0AB1VUAWN6yjKmpJ6YC5cBSsg
    GmXSqjgOmogyY8S8/lDq56s3fRgNGix8hIAlsoNhWRIBKGLKkuv8HKuXeYyiutkOu9lz
    07Ag==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1616076997;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ah5MiRuEKqCOmCg+F4sxbaF3TYwHXQheOtW54ZsXpCw=;
    b=XfUY8ChCaHodpxekYaLw8gGamtbgutUsZ42Il7pvu6ZrAUX/DXPzXrTcga++bPHSsv
    FIg/TOj3ErTFONOBjjntbw5YK3UN7dmQV78As2tGqbbB7lrQz7rArLBGKANIyI/1wmVk
    U+W2bIK5XAg8opHXXpANC8S1NBMxJOmltenVVYmy7sEsB64T4V0+UutioclH2+OupBrn
    dmLa9bbA+/W4odEtlUoKa+dW8AA6RVZgP336+wRRDekGajKyIsdnCBDlXY7eghZV3XFG
    fCRO+AjI4Aw5VWi7cBQbDOAB/3OgN76B55ZXYwjy4OmGT/zALBatxrjou7ey5GeFfEOi
    C6bQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSpEkMRSXg=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.21.0 DYNA|AUTH)
    with ESMTPSA id Y004c8x2IEGa4nE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 18 Mar 2021 15:16:36 +0100 (CET)
Message-ID: <475252d78d154bdbbb353b7b3c17c8b35405c914.camel@chronox.de>
Subject: Re: [PATCH] crypto: jitterentropy: Put constants on the right side
 of the expression
From:   Stephan Mueller <smueller@chronox.de>
To:     Milan Djurovic <mdjurovic@zohomail.com>,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Date:   Thu, 18 Mar 2021 15:16:35 +0100
In-Reply-To: <20210317014403.12742-1-mdjurovic@zohomail.com>
References: <20210317014403.12742-1-mdjurovic@zohomail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, dem 16.03.2021 um 18:44 -0700 schrieb Milan Djurovic:
> This patch fixes the following checkpatch.pl warnings:
> 
> crypto/jitterentropy.c:600: WARNING: Comparisons should place the constant
> on the right side of the test
> crypto/jitterentropy.c:681: WARNING: Comparisons should place the constant
> on the right side of the test
> crypto/jitterentropy.c:772: WARNING: Comparisons should place the constant
> on the right side of the test
> crypto/jitterentropy.c:829: WARNING: Comparisons should place the constant
> on the right side of the test
> 
> Signed-off-by: Milan Djurovic <mdjurovic@zohomail.com>

Thank you

Reviewed-by: Stephan Mueller <smueller@chronox.de>



