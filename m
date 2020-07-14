Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3D2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 05:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B432A221E8
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 05:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="XhAH/lbZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgGNFRa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 01:17:30 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:11019 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNFR2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 01:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594703846;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=HZATrvvag4q6gQHDw4QCFWHtrPGHPPXwIKMxcmxUGEs=;
        b=XhAH/lbZXYZM0bVRHN7jIia1JKUO3hOS9RZJaZXEj9pGfVSKERKlkh9Zyv/YSayxnE
        SiZ/mmCdvvkx1KOqv3VNldKHHzulLgt0tyEFz7JElr6CqWDaLvfzDTdwW54FxmgFE6dz
        A9nkGuBjmIDRzIzwPw1MIzlBpO8mB+SD9RHsnP9vIsijXKRGUCfJV7q+81yzwwFI5zxz
        Vr9RMkKNQGZEsnEVAxTCiH5PEQeTzTxsctFzj+WCUV96PcUGPyop2dvvkizkbk9NgN2N
        vjIvsnIta8zY58Hq2ylb2CcjgP6nLfPawwIu2YPtWfrauiZL/92dDebVQ1+E5DMo6Cw4
        4ptA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaI/SfxmJ+"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6E5HLpia
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 14 Jul 2020 07:17:21 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, Elena Petrova <lenaptr@google.com>
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/1] crypto: af_alg - add extra parameters for DRBG interface
Date:   Tue, 14 Jul 2020 07:17:20 +0200
Message-ID: <2941213.7s5MMGUR32@tauon.chronox.de>
In-Reply-To: <20200713164857.1031117-1-lenaptr@google.com>
References: <20200713164857.1031117-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 13. Juli 2020, 18:48:56 CEST schrieb Elena Petrova:

Hi Elena,

> This patch extends the userspace RNG interface to make it usable for
> CAVS testing. This is achieved by adding ALG_SET_DRBG_ENTROPY
> option to the setsockopt interface for specifying the entropy, and using
> sendmsg syscall for specifying the additional data.
> 
> See libkcapi patch [1] to test the added functionality. The libkcapi
> patch is not intended for merging into libkcapi as is: it is only a
> quick plug to manually verify that the extended AF_ALG RNG interface
> generates the expected output on DRBG800-90A CAVS inputs.

As I am responsible for developing such CAVS/ACVP harness as well, I played 
with the idea of going through AF_ALG. I discarded it because I do not see the 
benefit why we should add an interface solely for the purpose of testing. 
Further, it is a potentially dangerous one because the created instance of the 
DRBG is "seeded" from data provided by the caller.

Thus, I do not see the benefit from adding that extension, widening a user 
space interface solely for the purpose of CAVS testing. I would not see any 
other benefit we have with this extension. In particular, this interface would 
then be always there. What I could live with is an interface that can be 
enabled at compile time for those who want it.

Besides, when you want to do CAVS testing, the following ciphers are still not 
testable and thus this patch would only be a partial solution to get the 
testing covered:

- AES KW (you cannot get the final IV out of the kernel - I played with the 
idea to return the IV through AF_ALG, but discarded it because of the concern 
above)

- OFB/CFB MCT testing (you need the IV from the last round - same issue as for 
AES KW)

- RSA

- DH

- ECDH

With these issues, I would assume you are better off creating your own kernel 
module just like I did that externalizes the crypto API to user space but is 
only available on your test kernel and will not affect all other users.

Ciao
Stephan


