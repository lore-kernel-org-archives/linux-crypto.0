Return-Path: <SRS0=uNl7=QC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E582C282C7
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Jan 2019 21:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6638C21908
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Jan 2019 21:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548536734;
	bh=dze1c/nJAOYElM5MO/ypgaDltVZeT9nHmTLC12GtiVk=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=R+jR05nilS1hQMZeIrH991tfod6MOT6Wm4PjWx7YQOmgJBcM1zkJaY+eg+xhKrarr
	 m0AxB8i+6154IQ7Sef7y5AQfKSvhnlFylDmzF1Nxi2BW/kFZq8NOxZJTUnB9y44R5J
	 PIRmWu6SRLKETRW2DJuFAyVyfN5jpAscc3ek6C/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfAZVFd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Jan 2019 16:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfAZVFd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Jan 2019 16:05:33 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1386820989;
        Sat, 26 Jan 2019 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548536733;
        bh=dze1c/nJAOYElM5MO/ypgaDltVZeT9nHmTLC12GtiVk=;
        h=Date:From:To:Cc:Subject:From;
        b=pEnwis041dzlH4LN+677sseRrtkBNMNllyY4nB77kPicgNpCUPKGOGi2nEIo8Ta33
         li5tO58xJTQp92fiUTkREB1iFV+SKEU/ahqGZwGl55wegi0UbgJOMz/2uv3yYR3l7W
         JhqJQW3ETNqRjRgrGmaD/00SOWT7Xe6oFs4CkwMg=
Date:   Sat, 26 Jan 2019 13:05:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zain Wang <wzz@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Message-ID: <20190126210530.GB709@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

I don't know whether anyone is actually maintaining the Rockchip crypto driver
in drivers/crypto/rockchip/, but it's failing the improved crypto tests
that I currently have out for review: https://patchwork.kernel.org/cover/10778089/

See the boot logs for RK3288 from the KernelCI job here:

https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-rock2-square.txt
https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-veyron-jaq.txt

alg: skcipher: ecb-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: use_digest src_divs=[15.64%@+3258, 84.36%@+4059] dst_divs=[69.11%@+1796, 8.49%@+4027, 6.34%@+1, 16.6%@+4058] iv_offset=21\"
alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@alignmask+3993] dst_divs=[65.31%@alignmask+1435, 34.69%@+14]\"
alg: skcipher: ecb-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_final src_divs=[<flush> 66.52%@+11, 33.48%@+1519] dst_divs=[58.82%@+1, 19.43%@+4082, 21.75%@+8]\"
alg: skcipher: cbc-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_finup src_divs=[100.0%@+3980] dst_divs=[60.4%@+3763, 23.9%@+4011, 16.87%@+4046]\"
alg: skcipher: ecb-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+4] dst_divs=[47.25%@+19, 14.83%@+22, 37.92%@+31]\"
alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"two even aligned splits\"

In other words: the ecb-aes-rk, cbc-aes-rk, ecb-des-rk, cbc-des-rk,
ecb-des3-ede-rk, and cbc-des3-ede-rk algorithms are failing because they produce
the wrong ciphertext on some scatterlist layouts.

You can reproduce by pulling from
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
branch "testmgr-improvements", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.

Note that I don't have this hardware myself, so if it turns out that no one is
interested in fixing this anytime soon I'll instead have to propose disabling
these algorithms until they can be fixed.

Thanks,

- Eric
