Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225A5C77B72
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 11:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjDTLN5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 07:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbjDTLNm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 07:13:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7AC167C3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2023 04:09:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681988729; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=fa2IOZkgZU20f4pvyEv55U/WjWe7EuubxiTBwqSGH+ETzbkx5OCXW06h5jQXKcRP2S
    4A7CJMU+0AxwxaKfOdkmbNlVwc80BepEGoXBehumWPCpFFCiVbaLbGFm2v5vpauWTtw/
    mJOQwtYwXBbbSY1+V5X0r3+/KhLNuIW/0sw3k6PgGhbkYNpfmU4OFuktFqQwVdPYpfKo
    kexdKCqVoAm9UWbU0VmQEsQ4T0X+Q73aHBFRD+BmX2t1WVrE4k/xch0sbCZdk/iNpPQq
    KRTsck5bXu9sqjVTz9u7TNmd29OMBH05WzIkVVd9F6Mbv/4pSUq8nWgmTqDd2rGfiaOk
    kRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681988729;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=SpPXeg6/w5ni9ozyHCM/qz2BSfusPOb+psA4ihAd4mU=;
    b=VaGo5rB7MeJBuT/YCD5oHwUpuZVOmfIDZ3IEVX6TF8HwMNJDGeAkOb3gWMG6cszd0h
    6bwUug9oxAleo9+X1fPKBFedRgm/CpBKeO2spZOsrm6wLFJK5vF0sn5i2HyQQ5g3wolj
    aFhmHc0T0Pf6XqRqrHnfwo9gGG8sGC2zbCiy1DwJijpIXoMC+Z2IN3LZtU9ZQ6kLO6bW
    rLSkwqBcn2xysXdMVcroFDxjOXsmr0DU173V3xmxBYPfV8crPQy0RFitQbon/id10QPO
    ZRicgzuLAcPdlUEK8uPVIW/JW2CvqDuv+SRXjP23LNNDX4ErFmtkvPVdnP4ADo2hyqoJ
    eqSQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681988729;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=SpPXeg6/w5ni9ozyHCM/qz2BSfusPOb+psA4ihAd4mU=;
    b=hTPDywEHARMYOPF3XYY/bVvPN+QKBFnCmQumWMNXyEjIVK6kE48X4yFuSA6weW6rco
    FZ9bUHs03rFEPlINrdyowMGQduS8aPclhr8OJvxohn23inAAOrUCGut034EQFIm01ANm
    zrC6iv8pznvTZ4fjGxxo9IWlRMCi+xKKDlm40w3b+p8i/3Qy4ZTsf4PdMBG9BsfeGuwB
    n5uYCl7ulOYN8xeE04Yk+6JxfQH1RocJfiqaenkgdLirwZ6xU7VBKTNUEcoF39SqSNvt
    lD/N6YLLFmi6I759/5zm3nsuwJgty85wdVF1yKowdKfvjloZW/Gl4Tipquo45sZs8sxp
    6H8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681988729;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=SpPXeg6/w5ni9ozyHCM/qz2BSfusPOb+psA4ihAd4mU=;
    b=6X5r0jpFj2AdAP/wFoykW5pqqCajWIG8NwFJGFkj4ild9oUIC2HmDF34eHKggVkSvI
    mHXkljEXhQemfon0H7AQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz1d0u3TRk="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id ta02b6z3KB5S8DX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 20 Apr 2023 13:05:28 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH v2 1/2] crypto: jitter - replace LFSR with SHA3-256
Date:   Thu, 20 Apr 2023 13:05:27 +0200
Message-ID: <15434794.O8ra6N0tA4@tauon.chronox.de>
In-Reply-To: <ZEEMK/zlZdz2t7CA@gondor.apana.org.au>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
 <2283439.ElGaqSPkdT@positron.chronox.de>
 <ZEEMK/zlZdz2t7CA@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 20. April 2023, 11:55:55 CEST schrieb Herbert Xu:

Hi Herbert,

> > +	rng->entropy_collector = jent_entropy_collector_alloc(1, 0, sdesc);
> > +	if (!rng->entropy_collector)
> > +		ret = -ENOMEM;
> 
> Is this supposed to fail or not?

Correct. Thanks a lot for the catch. I will update this.

Ciao
Stephan


