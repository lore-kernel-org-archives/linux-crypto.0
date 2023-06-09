Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76692C7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 11:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbjFIL6L (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 07:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbjFIL6D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 07:58:03 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6CD35BC
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 04:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686311849; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FsJQR3Tc07NiM/n6LQksnp678Qin0+agygLE7aq4Qcir9ttR4aXpR+GjfKXVopr8l2
    EFSgtATlBTQ/2geFw2Z/g41b122bSGKqpdxi2qyWxBjj0k+jLH4iuIEYZZn92AfjS5Wz
    t5O/VhUkW1UFA380MiKf9w66u3URQDkUE6TU6s3ntPs92yceaIf4M379xYCk9bD+p0e7
    U++Ad9jpqXBD9i1hAJoyjiOsutn2utErOwS/Nz9DaH6kOYOZGaVSKqVnpGk+ufEl5xG5
    GmEeHoXBqcZ+m3rXFFrzDb9x9qNpXbdUvUHpp8ZhvVAAsw0fwLEYCsxNXD0ikow8EI09
    sFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1686311849;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=vRq8ae7jWYtehtlg04q7apnyU2ut1Gx4bpA4PsnAFFU=;
    b=XfVz+A89j7JHJz9Sf4bUxyQFOWb3gLzVGknOerkUSYyKR1tVWRtNoUcm/dNYkJnYSP
    1e0mWzjWIhW5zzwXlITE5DldpZ1LfIXZU7b8Cx/omx3kmVymmSxfdC0WAJu5ypmKluYo
    I3jkbC+5ygEhYJNxkUqpqFidhAv/+wGYCO2MWt6uSoVmJUwyJLPaf1LB/FhVRBOm2fCz
    vIypOrPSC2CLJhu56Ha4nuPXm5W3jBUaoLb46hxTI5ru5Mkpkb1gZo1g/Yteo+IN/Gfl
    mhP3GpYS32uoPE95tC8s6KR1Ng56l7JXgvrU2zjCEofvxMlM7tM8vtfVs8J0N2d7hp+x
    n8GQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1686311849;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=vRq8ae7jWYtehtlg04q7apnyU2ut1Gx4bpA4PsnAFFU=;
    b=FYQQyAcf359sE/nAIOrGFpOgjT/xMFcUjwB5562M4xnQ1fhQ1In9Rp1LFaWReYvrnq
    3iOLpMg3gHNvYErLSYB/1KeA3jbK3sKc5ByJ/jgyJmoN0PbM/EyKz62l+e/bhHWIV+Rr
    WIkW/6Yxlfy6XXEoWtnjUyMhK4SgHgVFiC1+m2tug6WFxUEjgD4astWpUIVGWWBr5MpV
    pv4kIP8axBrynoZ/Xc0Q9y6FP9lY17hbQT/AMj9l2uZCObd8VEbD9tHByeAtD5UBBVA3
    9rnuvssJI9jd4qOPd56ISUCPQXH4CGALqNocoGA8lmgkU7vXh3jDIQjvihCZOewkeUQ9
    akWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1686311849;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=vRq8ae7jWYtehtlg04q7apnyU2ut1Gx4bpA4PsnAFFU=;
    b=zZatpjSOYGHysDNPj6vB3K0NFdKiQE8emo1fEE6k4ZjWAqkGmVwo7DZIPdKl4U7Ws7
    gA4fjAslI/a3MHJVrRBA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz0d0iwLwE="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.5.3 AUTH)
    with ESMTPSA id qe6984z59BvRgyL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 9 Jun 2023 13:57:27 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com,
        Linux Memory Management List <linux-mm@kvack.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, ying.huang@intel.com,
        feng.tang@intel.com, fengwei.yin@intel.com, oliver.sang@intel.com
Subject: Re: [linux-next:master] [crypto]  bb897c5504: stress-ng.af-alg.ops_per_sec
 -8.0% regression
Date:   Fri, 09 Jun 2023 13:57:27 +0200
Message-ID: <1697789.S9sCK8dtJg@tauon.chronox.de>
In-Reply-To: <202306081658.d5c86ae9-oliver.sang@intel.com>
References: <202306081658.d5c86ae9-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 9. Juni 2023, 10:02:32 CEST schrieb kernel test robot:

Hi,

> Hello,
> 
> kernel test robot noticed a -8.0% regression of stress-ng.af-alg.ops_per_sec
> on:
> 
> 
> commit: bb897c55042e9330bcf88b4b13cbdd6f9fabdd5e ("crypto: jitter - replace
> LFSR with SHA3-256")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> testcase: stress-ng
> test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @
> 3.00GHz (Cascade Lake) with 128G memory parameters:

Thank you for the report, but this change in performance is expected to ensure 
proper entropy collection. I assume that the jitterentropy_rng is queried via 
AF_ALG. Considering that the amount of data to be generated (and thus the 
effect of the performance degradation) is small, there should be no noticeable 
impact on users.

Ciao
Stephan


