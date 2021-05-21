Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47522C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E453613CA
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhEUJiM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 05:38:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:21258 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhEUJiL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 05:38:11 -0400
X-Greylist: delayed 50552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 05:38:11 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1621589799; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=BaUO0T48o2BBSBIUlpg6MAtCbQmFLghTYhZG5sh3iFYk9Kb3XH8186hhCv+QSYneLt
    WfAAVNc8bkcCq2wJ4IWzCDz44CSPkZVC+RzXGMkXoNkps4va627N8up74Za7rnntS3fK
    SdSuNmpTVe5pmvSeo1OJXXtyyMdcNUHRuzyVe+lBGA4pn9u0rDx+7Jpyi7j6rEkY0Qa8
    TGdh8UC8tN8Zayk8BOrxdRV/hkCI8npWzEL1k9Tdn0hNOBfnpDguhAnaGtltkcd8SzXv
    bAXx6dNShL7TiV7qUmiOn7b7HYX8whc77PgrJGoKGiKj96cd3hO4tGJ4zgyWl1ziY5vp
    m7jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621589799;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=YlKEEZGvqj2UMPUU2zRqh3Rd+Verps4P/6rJsZNP/To=;
    b=b/ACE0RN82kXLCnK7XYuc8mZQM6pwbIO5iFxregEg59rvhIEui9MJy+9YAUkVZqW9O
    i2LdYnMeSa+S/G1eV6CgNcCx9wgj6dj+PFLyf+b0qnvRodJUDl7JucnnpfWxG55ghBqQ
    G8pUQzhAEx9yVmCndQoKVe3iwn7rfbgki288Co+Lg+LrIKgsZAh24OOj1zIf9V1HRatu
    yOj8G3J+/BGC1q6yDOio1wXe3sPpe/WViUaxtMmpj/FpT5FxzuS9bmJNRmSf13Gsa+NW
    hHJIZR1MWXZC92hmK1a7OmH9L2Nzkt708YVj7i0eCAV5b7F1m09F9UEoeyXEXBXQZ2yF
    Aayw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621589799;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=YlKEEZGvqj2UMPUU2zRqh3Rd+Verps4P/6rJsZNP/To=;
    b=pUEeVOB9VJmVeO7BWmK0nXrki8h3pdXCVGsdhM1HTI8+eLjIcHEb0gMTfHHQ3+n7tg
    LJowg/Cp5y+zqxSAgz6UZxq0EuewcOWCPhAFlnDrOq/ixSrT64xRBCvomIGs9wGzuz9G
    6LNxRBQkgj5kWVSdDZ1Xp8acuk6DkxTDk2+5LBfcXZBl/Pb7QbNu5x/dS7dfQAMD4CQL
    yRLfHnoN2wigsJKOPpbs0Zs0oGoLPiTWM5y7xiBeGPeEBXusN/Z0yC7/wx9lOeAwDB4y
    IVfXUfRapNAPO8fRD2JDnPbH9OYorV04DqiMxfKpM/UXGeUBudUWmNc5dtuTPotHzx1W
    UvjA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlFkMRYOkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id V06bffx4L9ab15j
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 21 May 2021 11:36:37 +0200 (CEST)
Message-ID: <878011e1735e84d4e16ab68d9f03e2f62b531314.camel@chronox.de>
Subject: Re: [PATCH 1/3] crypto: ecdh - fix 'ecdh_init'
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Date:   Fri, 21 May 2021 11:36:37 +0200
In-Reply-To: <20210521081356.3bnytzdxhjkgzb7g@gondor.apana.org.au>
References: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
         <1620801602-49287-2-git-send-email-tanghui20@huawei.com>
         <20210521074553.w6qtqv5nnbdbqycx@gondor.apana.org.au>
         <2a5bcd22-455d-6348-9a72-dc5a7ab49ca6@huawei.com>
         <20210521081356.3bnytzdxhjkgzb7g@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 21.05.2021 um 16:13 +0800 schrieb Herbert Xu:
> On Fri, May 21, 2021 at 04:08:10PM +0800, Hui Tang wrote:
> 
> 
> Stephan, can you confirm that both ecdh-nist-p192 and ecdsa-nist-p192
> should be disabled in FIPS mode?

Confirmed with the following caveat: sigver is allowed due to legacy
considerations. Siggen / ECDH is only allowed for curves P-224 and higher.

As we introduce ECDSA today, I would not consider a legacy mode and thus
disable P-192.

Ciao
Stephan


