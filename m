Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21A9C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 18:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DDE222A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550256663;
	bh=+YxRzfzrCQoMevPQS4cQv+rsVsfhKacc9NzC6i1mdXE=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Q4pHaRK3ABoAJpvJzazfBLwmh/rpH0UjOV2VTyUT+fnupACRY+0n0rw5yK2XJXGz0
	 eHmR3WWxWDfkcfxXl3ykOMAGa+838UPUei02qVmNQNxz94JVuL/GoGqgjOoRCMjMwv
	 858Hed67TQCXLbpTgQhIklXMQ/IMR1u0LQYwG+q0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbfBOSvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 13:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387731AbfBOSvC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 13:51:02 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7173D21929;
        Fri, 15 Feb 2019 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550256661;
        bh=+YxRzfzrCQoMevPQS4cQv+rsVsfhKacc9NzC6i1mdXE=;
        h=Date:From:To:Cc:Subject:From;
        b=cnk10aIs6JDXgWgqUg4fnO6xhdpXL8cNG6E5CFDgCrHA5SVog+gU9KvZqfClOM1nH
         ZWIjnHeSY2mSIsvi8iD4dfrKuWoKrbb2CVGOD3QsyJW+4Vl1p08pRa5GnJwoElHvlX
         r/e1VuRH8xmomh5ZyEQ0gi+CcO/6caEOnZ21QYLw=
Date:   Fri, 15 Feb 2019 10:51:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: [Bug] s5p-sss crypto driver doesn't set next AES-CBC IV
Message-ID: <20190215185058.GB12909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

The AES-CBC implementation in the s5p-sss crypto driver is failing the improved
crypto self-tests I currently have out for review.  The improved tests check
that all CBC implementations update the IV buffer to be the last ciphertext
block.  This has always been required so that requests can be chained, but
unfortunately it wasn't tested for by the self-tests until now.

See the boot logs for Exynos platforms from the KernelCI job here:
https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-rc1-149-g64c945c018af/

alg: skcipher: cbc-aes-s5p encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41

You can reproduce by pulling from
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
branch "iv-out-testing", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.

(CRYPTO_MANAGER_EXTRA_TESTS is probably unneeded for this, but you might as well
use it.  Also you can optionally revert the last patch, which makes crypto
self-test failures cause a kernel panic for testing purposes.  It's possible
that ctr-aes-s5p is failing too but it was just never gotten to...)

The patch series is also available on the linux-crypto mailing list:
https://patchwork.kernel.org/cover/10811951/

Note that I don't have this hardware myself, so if it turns out that no one is
interested in fixing this anytime soon I'll instead have to propose disabling
these algorithm(s) until they can be fixed.

Thanks,

- Eric
