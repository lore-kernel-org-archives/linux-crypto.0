From: Turbo Fredriksson <turbo@bayour.com>
Subject: Error inserting sha256_ssse3: No such device
Date: Wed, 13 Nov 2013 04:08:37 +0100
Message-ID: <0125C288-B77D-42DA-B018-FAD56CA0FAAC@bayour.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vsp-authed02.binero.net ([195.74.38.226]:62753 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589Ab3KMDIs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Nov 2013 22:08:48 -0500
Received: from smtp01.binero.se (unknown [195.74.38.28])
	by vsp-authed-01-02.binero.net (Halon Mail Gateway) with ESMTPS
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2013 04:08:38 +0100 (CET)
Received: from [192.168.69.226] (c83-252-98-74.bredband.comhem.se [83.252.98.74])
	(Authenticated sender: turbo@bayour.com)
	by smtp-05-01.atm.binero.net (Postfix) with ESMTPSA id 7C40D3A165
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2013 04:08:38 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've just upgraded from 3.9.0-rc6 because I needed new versions
of ZFS On Linux (because of a unknown problem with the previous
version which lead to it refusing to load).

I also have zfs-crypto by zfsrogue and when trying to mount a
crypted filesystem, I get:

	filesystem 'share/home/turbo/Crypted' can not be mounted due to error 52
	cannot mount 'share/home/turbo/Crypted': Invalid argument

This leads to the following in the logs:

	Nov 13 03:24:53 Celia modprobe: WARNING: Error inserting ghash_clmulni_intel (/lib/modules/3.12.0+scst+tf.1/kernel/arch/x86/crypto/ghash-clmulni-intel.ko): No such device
	Nov 13 03:24:54 Celia kernel: [ 2053.440315] spl-crypto: Cipher test 'CKM_AES_GCM' -> 'sun-gcm(aes)' successful.
	Nov 13 03:25:01 Celia kernel: [ 2061.223198] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
	Nov 13 03:25:01 Celia modprobe: WARNING: Error inserting sha256_ssse3 (/lib/modules/3.12.0+scst+tf.1/kernel/arch/x86/crypto/sha256-ssse3.ko): No such device
	Nov 13 03:25:01 Celia modprobe: FATAL: Error inserting padlock_sha (/lib/modules/3.12.0+scst+tf.1/kernel/drivers/crypto/padlock-sha.ko): No such device

Trying to load the module sha256_ssse3 manually, I get:

	celia:/lib/modules/3.12.0+scst+tf.1/kernel# modprobe sha256_ssse3
	FATAL: Error inserting sha256_ssse3 (/lib/modules/3.12.0+scst+tf.1/kernel/arch/x86/crypto/sha256-ssse3.ko): No such device

with the following in the logs:

	Nov 13 03:30:15 Celia kernel: [ 2375.004027] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.


First time (in early spring) I tested this, when loading the sun-gcm module, I
got all kinds of problems (https://github.com/zfsrogue/zfs-crypto/issues/28).
Turned out I needed to load the gf128mul and ghash-generic kernel modules.

So I'm assuming it's the same thing again, a module doesn't get autoloader
by mod probe...


Any ideas?
--
Imagine you're an idiot and then imagine you're in
the government. Oh, sorry. Now I'm repeating myself
- Mark Twain
