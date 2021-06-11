Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166D7C4743D
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 05:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4347610A5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 05:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFKGBi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 02:01:38 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:28774 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhFKGBi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 02:01:38 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623391169; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=N1AiXf8Fx5llCyDXu2rfGjiSfjTSWaIgZD8yH8kML8GhI+KwzLCBdS3GiJZ5Wd4tVG
    8yaVdsNgOv8RYy5HRpZE8CKlvswel5gOh5bu8hPKc2BEY7Ctzrl3JsIveehd0fWZjyn3
    2wyaqL4tBm0/muxtPdv+1XBUjflX6MNUpjcBw4j+6xO4x6TW1+oO5NvZAMjHBmQHfBs4
    CuJD35Ne1o5qNbWfcmSz9yMQYGQ8k3q/AAfGo01v3WT5/LimeCPiJD445GN/X8MK5Ro2
    EKxYv6dYZ7ipkBXxPkPpNSfEVxK0TPMRf7nrodiOJ+oww33RwkW5u+lkvO6HYqg5b5la
    1w8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623391169;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:Date:From:
    Subject:Sender;
    bh=fIKsnK+xZuOszOrRtF3oj3jRT0IzrLUDxkQFqG3D+rM=;
    b=FpAgbkNaSzxDH78oqyX0GTVQMWeOqD4sxCNpqfm4iCBnuadHpllDrInEoIFF9srJBJ
    aWgC989e6qY2uB42ahOTYr0EtfEV3TNJzjJ6hs9U+xmrGBYlePj/0EoZHS0WjapdAjP6
    T8NE/x85i79R+GPAUlRNftEvJe8RfsRHc64iESQMz81MPNc47cHo9PVlDhDoNQfAVqTx
    S0ZtyBUGNU0uN69qwHw18zLe3nVjNgGF8RH4iuzC2jYTBkiH/QxLhkespLNx6+bjs4Mi
    xk++f4l+mQh2rHjb7UFmp3RgYYwLAGp9snX57iWGzYj++oSGA2Ev4cBOHjJGg6Hh50BH
    xGMw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623391169;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:Date:From:
    Subject:Sender;
    bh=fIKsnK+xZuOszOrRtF3oj3jRT0IzrLUDxkQFqG3D+rM=;
    b=spGe6zygaF8jGxxMS0dgxWTzvW9C15+GJtrxvh6xhZwOZxSXnIZAWDZCvsrj9b38gH
    JkWGXhhdklUPeBxnpcOjcXiALIn8N4IItr2bh3WtY4tABWOVbQKwvPKT63J+lhoiHVR/
    FddfAY3ElEUdA+BSzU1Ew70XGXEcLrAED4w7tmGobIIrR9Yn6MvGlvRbgOwQSSyTV9Al
    wudTeSnU6/tRjh6rLZLMaOlp3QLmOjCyK3i8tlQYO+NzvJDpsLuEEw2heOzCmd0kw0mm
    Fgt/eLyVXEacg1Q0rB35HUJ9NTMjSTcQjIWGuXUDEU3nVgyeEw9zyiPw8wgkD7s0dn/1
    eQ6g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvScXspJ"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id z03662x5B5xScre
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 11 Jun 2021 07:59:28 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>, John Denker <jsd@av8n.com>,
        Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
Date:   Fri, 11 Jun 2021 07:59:28 +0200
Message-ID: <1744453.HlSabMDqgd@positron.chronox.de>
In-Reply-To: <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com> <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 11. Juni 2021, 05:59:52 CEST schrieb Sandy Harris:

Hi Sandy,

> The basic ideas here look good to me; I will look at details later.
> Meanwhile I wonder what others might think, so I've added some to cc
> list.
> 
> One thing disturbs me, wanting to give more control to
> "the user who should be free to choose their own security/performance
> tradeoff"
> 
> I doubt most users, or even sys admins, know enough to make such
> choices. Yes, some options like the /dev/random vs /dev/urandom choice
> can be given, but I'm not convinced even that is necessary. Our
> objective should be to make the thing foolproof, incapable of being
> messed up by user actions.

Thank you for your considerations.

I would think you are referring to the boottime/runtime configuration of the 
entropy sources.

I think you are right that normal admins should not have the capability to 
influence the entropy source configuration. Normal users would not be able to 
do that anyway even today.

Yet, I am involved with many different system integrators which must make 
quite an effort to adjust the operation to their needs these days. This 
includes adding proprietary patches. System integrators normally would compile 
their own kernel, I would see no problems in changing the LRNG such that:

- the entropy source configuration is a compile time-only setting with the 
current default values

- the runtime configuration is only enabled with a compile time option that is 
clearly marked as a development / test option and not to be used for runtime 
(like the other test interfaces). It would be disabled by default. Note, I 
have developed a regression test suite to test the LRNG operation and 
behavior. For this, such boottime/runtime settings come in very handy.

Regular administrators would not recompile their kernel. Thus Linux distros 
would simply go with the default by not enabling the test interface and have 
safe defaults. This implies that normal admins do not have the freedom to make 
adjustments. Therefore, I think we would have what you propose: a foolproof 
operation. Yet, people who really need the freedom (as otherwise they will 
make some other problematic changes) have the ability to alter the kernel 
compile time configuration to suit their needs. 

Besides, the LRNG contains the logic to verify the settings and guarantee that 
wrong configurations cannot be applied even at compile time. The term wrong 
configuration refers to configurations which would violate mathematical 
constraints. Therefore, the offered flexibility is still ensuring that such 
integrators cannot mess things up to the extent that mathematically something 
goes wrong.


On the other hand, when you refer to the changing of the used cryptographic 
algorithms, I think all offered options are per definition safe: all offer the 
same security strength. A configuration of the cryptographic algorithms is 
what I would suggest to allow to administrators. This is similar to changing 
the cryptographic algorithms for, say, network communication where the 
administrator is in charge of configuring the allowed / used cipher suites.

Ciao
Stephan


