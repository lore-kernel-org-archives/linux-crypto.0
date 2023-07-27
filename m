Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72712C0015E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jul 2023 12:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjG0M70 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jul 2023 08:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjG0M70 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2023 08:59:26 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Jul 2023 05:59:24 PDT
Received: from out-72.mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7551FF3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jul 2023 05:59:24 -0700 (PDT)
Message-ID: <fd31dc60-67b2-8ed8-c941-2b5be777070a@metacode.biz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=metacode.biz;
        s=key1; t=1690462310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5Ea2gmz0MdCBxa+HEcK95BhQfrehkp+yw528Jq3QupU=;
        b=nheMZ5tz/yEszU0lRdFelm6Pn+g+fAZMbxqRgri0XCOYaQj1oiVTOQi8Ib7Jf7UESnqMKC
        HmCqfO44uNTsWAbVbKdscrJ+98B917aycd7wDyJQXp+MtAl5Mfqa8t+I2VAmfS/BhfwdrN
        I2+YInB1JIPdtXGpVPY61VjOP/BNaCI=
Date:   Thu, 27 Jul 2023 14:51:47 +0200
MIME-Version: 1.0
Content-Language: en-US, pl-PL
To:     linux-crypto@vger.kernel.org
Cc:     Puru Kulkarni <puruk@protonmail.com>,
        Puru Kulkarni <puruk@juniper.net>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Stephan Mueller <smueller@chronox.de>,
        devel@lists.sequoia-pgp.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Wiktor Kwapisiewicz <wiktor@metacode.biz>
Subject: Kernel Crypto exposing asymmetric operations to userland via libkcapi
Organization: Metacode
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Kernel Crypto folks,

I've got a question about the Kernel Crypto API.

I'm working on adding a cryptographic backend based on the Kernel Crypto 
API to Sequoia PGP [0][1]. Sequoia supports several cryptographical 
backends already but using Kernel Crypto would allow us to significantly 
reduce dependencies when running on Linux.

After implementing hashes, AEAD encryption and symmetric ciphers, I 
noticed that the libkcapi API for asymmetric ciphers (and ECDH) is not 
working. The libkcapi maintainer kindly explained [2] that the patches 
that they proposed for inclusion in the kernel [3] were not merged.

I looked up the relevant thread [4], read it thoroughly and from what I 
can see most of the arguments are about private keys not being 
sufficiently protected and extensibility concerns with regards to keys 
stored in hardware security modules (TPMs etc.).

However, these are mostly irrelevant to the Sequoia PGP use case, since 
private keys in software that we read do not need additional protection 
(as they are available for software anyway). We'd still like to use them 
for signing, decryption, verification and encryption. As for keys stored 
in HSMs we handle access to them in userland via our keystore module [5].

My question is: Would it be possible to revisit the decision to expose 
operations with asymmetric keys (including ECDH) in Linux Crypto thus 
allowing libkcapi to work with non-patched kernels?

I'd like to help make this happen and I think there are other projects 
that are interested in a complete cryptographic suite of Kernel Crypto 
functions available in user-land.

Thank you for your time!

Kind regards,
Wiktor

[0]: https://gitlab.com/sequoia-pgp/sequoia/-/issues/1030
[1]: 
https://lists.sequoia-pgp.org/hyperkitty/list/devel@lists.sequoia-pgp.org/thread/ZU64CWYZ26OH5TH6PR3BBLDYDDZ6COLH/
[2]: https://github.com/smuellerDD/libkcapi/issues/164
[3]: 
https://github.com/smuellerDD/libkcapi/blob/master/kernel-patches/4.15-rc3/asym/v10-0000-cover-letter.patch
[4]: 
https://lkml.kernel.org/lkml/9859277.cZClo5B21s@tauon.atsec.com/T/#m0dfdbd363d4419c7a2470ef884a33dbb250b6df1
[5]: https://gitlab.com/sequoia-pgp/sequoia-keystore
