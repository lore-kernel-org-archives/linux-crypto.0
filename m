Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341014D71A
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722894144; cv=none; b=H+Ycf3bKdp5QBaqmrHuR/v5zEKGjAUIP1DY6K2zUQlizbYGbXyYi0F/MysHMUgYZ33YtdczX/tkf7XWvrqLB5paBg3gH67TSr7RXTbgeDqyskzbHwb2eW3EZGAOh9A4NtF82rs0Zi0IRYyOxYNr6onKRgEqz5pi7g3+0Lfp8ulY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722894144; c=relaxed/simple;
	bh=kiSfEcVAX4eVpqdRCNhjsM2hP+C40SAaU3OznN4D/ys=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=E7is1YWuUtIPpXpUzX+vV57iQvbXEUJAI7s1XBucVRu3aiv/6vAqmEc2PP5T3LnYGvwM0dL3ZqS/5+7kNBud29eQBgJguLRRbIJXAN8bG5MRqk+dciBNXnA3pN885O/HN1llAIsAQW8baWmA9eQRnx8s+QuEowYWGK6+5QmWWVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=YR0YULfJ; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="YR0YULfJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Y0OpvAoVMQ+r6f9UOTzK7s7VDOgk2mTq8phrk6aWfOM=; b=YR0YULfJ5tTwxMQ/NDb/lJKjyj
	P0oqEkWv5uu6hK48Na3kAWQqcP4JOQKL9rHj8CI3Ec46CB/5nSBLDT3Hr1RS/NEUSoHF4IQA0mbwL
	XrOG/zTxGtpiOj/R86OvYgKry7mzdN7vCNpgGC3BjbD/gDUtYhV2GF9YEOwMteHwpKvzAVwRjWXmP
	eTkLF0D0LIb4KDPTyiu+w7FiWKPFnLpF2LiJwotO3XpiaBvWQ3bFvpzdUFgSeGEcGb5NoZMA6mE9+
	PklzclhvmcPeeTTJEztzLXQYMu/j4Xl59uECUMBKMJzyeq25c4GE1iCT/qfspmJFu9kpdq+hE+cNK
	e1WM0vmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45072)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1sb5Sv-0003eP-2M;
	Mon, 05 Aug 2024 22:42:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1sb5Sw-0002j5-U8; Mon, 05 Aug 2024 22:42:07 +0100
Date: Mon, 5 Aug 2024 22:42:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [BUG] More issues with arm/aes-neonbs
Message-ID: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

Hi,

I see there have been multiple attempts to fix this module, but sadly
it seems that the problems persist and are not fixed.

On my i.MX6 platforms, since 6.9, I enabled aes-arm-bs support, and
I've since been getting a load of hung tasks at boot. I've started to
try to debug this evening under 6.10 - involving hacking the kernel
code to try and get useful information out of the kernel. I've ended
up dumping the entire state of all threads when the hung task fires.

What I find is this - the aes-arm-neonbs module is being probed, and
this is its trace:

[   74.803096] task:modprobe        state:D stack:0     pid:613   tgid:613   ppid:37     flags:0x00000000
[   74.812620] Call trace:
[   74.812636] [<c0b784cc>] (__schedule) from [<c0b78bbc>] (schedule+0x50/0x128)
[   74.822586] [<c0b78bbc>] (schedule) from [<c0b82fac>] (schedule_timeout+0xb0/0x1b8)
[   74.830444] [<c0b82fac>] (schedule_timeout) from [<c0b79420>] (__wait_for_common+0x74/0x170)
[   74.839110] [<c0b79420>] (__wait_for_common) from [<c0488b8c>] (crypto_larval_wait+0x14/0x98)
[   74.847852] [<c0488b8c>] (crypto_larval_wait) from [<c0488e14>] (crypto_alg_mod_lookup+0x204/0x20c)
[   74.857118] [<c0488e14>] (crypto_alg_mod_lookup) from [<c0488f5c>] (crypto_alloc_tfm_node+0x48/0xb4)
[   74.866468] [<c0488f5c>] (crypto_alloc_tfm_node) from [<c048c478>] (crypto_alloc_skcipher+0x28/0x30)
[   74.875857] [<c048c478>] (crypto_alloc_skcipher) from [<bf3e88b8>] (cbc_init+0x1c/0x38 [aes_arm_bs])
[   74.885264] [<bf3e88b8>] (cbc_init [aes_arm_bs]) from [<c04889c0>] (crypto_create_tfm_node+0x34/0xd4)
[   74.894736] [<c04889c0>] (crypto_create_tfm_node) from [<c0488f74>] (crypto_alloc_tfm_node+0x60/0xb4)
[   74.894770] [<c0488f74>] (crypto_alloc_tfm_node) from [<c048c478>] (crypto_alloc_skcipher+0x28/0x30)
[   74.894800] [<c048c478>] (crypto_alloc_skcipher) from [<bf3de61c>] (simd_skcipher_create_compat+0x20/0x17c [crypto_simd])
[   74.894849] [<bf3de61c>] (simd_skcipher_create_compat [crypto_simd]) from [<bf3ef06c>] (aes_init+0x6c/0x1000 [aes_arm_bs])
[   74.894896] [<bf3ef06c>] (aes_init [aes_arm_bs]) from [<c0009ffc>] (do_one_initcall+0x60/0x2c0)
[   74.894933] [<c0009ffc>] (do_one_initcall) from [<c00e6640>] (do_init_module+0x54/0x1fc)
[   74.894962] [<c00e6640>] (do_init_module) from [<c00e8644>] (init_module_from_file+0x84/0xa4)
[   74.961860] [<c00e8644>] (init_module_from_file) from [<c00e892c>] (sys_finit_module+0x170/0x21c)
[   74.961897] [<c00e892c>] (sys_finit_module) from [<c0008320>] (ret_fast_syscall+0x0/0x1c)

What seems to be happening here is that we have registered all the
main ciphers using crypto_register_skciphers(), and then we walk the
array of algos, calling simd_skcipher_create_compat() on each.

We get to the __cbc(aes) entry, and this one seems to trigger the
larval_wait thing. With debug in crypto_alg_mod_lookup(), I find
this:

[   25.131852] modprobe:613: crypto_alg_mod_lookup: name=cbc(aes) type=0x5 mask=0x218e ok=32769
...
[   87.015070]   name=cbc(aes) alg=0xffffff92

and 0xffffff92 is an error-pointer for ETIMEDOUT.

i.MX6 does have the CAAM hardware that can do cbc(aes), so thinking
that may be the issue, I decided to try blacklisting the CAAM modules.
This made no difference.

It seems that the issue is centred around the aes-arm-bs module. Even
after boot, and having removed the module, manually reloading it also
causes the same problem:

# time modprobe aes-arm-bs
modprobe: ERROR: could not insert 'aes_arm_bs': Connection timed out

real    1m1.731s
user    0m0.004s
sys     0m0.052s

The interesting thing is... if I blacklist the aes-arm module, then
aes-arm-bs doesn't behave this way and loads successfully. If I pre-
load the aes-arm module, then the hanging behaviour returns.

So... with my debug in place, loading aes-arm-bs with aes-arm
blacklisted gives me:

[ 4289.026431] modprobe:1786: crypto_alg_mod_lookup: name=cbc(aes) type=0x5 mask=0x218e ok=32769
[ 4289.084516] cryptomgr_probe:1788: crypto_alg_mod_lookup: name=aes type=0x20004 mask=0x218f ok=0
[ 4289.084556]   name=aes alg=0xfffffffe
[ 4289.114602] cryptomgr_probe:1788: crypto_alg_mod_lookup: name=ecb(aes) type=0x20004 mask=0x218f ok=32769
[ 4289.163489] cryptomgr_probe:1793: crypto_alg_mod_lookup: name=aes type=0x20004 mask=0x218f ok=0
[ 4289.163530]   name=aes alg=0xfffffffe
[ 4289.165187]   name=ecb(aes) alg=0xc4b318c0
[ 4289.165367]   name=cbc(aes) alg=0xc4b31cc0

Hence, looking up "aes" returns an immediate -ENOENT (and this is the
only "name" that aes-arm provides.) With aes-arm loaded:

[ 3926.164204] modprobe:1691: crypto_alg_mod_lookup: name=cbc(aes) type=0x5 mask
=0x218e ok=32769
[ 3926.212563] cryptomgr_probe:1693: crypto_alg_mod_lookup: name=aes type=0x2000
4 mask=0x218f ok=0
[ 3926.212605]   name=aes alg=0xfffffffe
[ 3988.209746]   name=cbc(aes) alg=0xffffff92
[ 3988.412691] cryptomgr_probe:1693: crypto_alg_mod_lookup: name=ecb(aes) type=0x20004 mask=0x218f ok=32769
[ 3988.462116] cryptomgr_probe:1708: crypto_alg_mod_lookup: name=aes type=0x20004 mask=0x218f ok=0
[ 3988.462159]   name=aes alg=0xfffffffe
[ 3988.462292]   name=ecb(aes) alg=0xc4b320c0

It's interesting in the case where aes-arm is not loaded that the
cbc(aes) lookup only succeeds _after_ ecb(aes) has, but in the
failing case, we're clearly waiting for cbc(aes) before proceeding
to ecb(aes).

This is about as far as I've managed to get debugging this, and I'm
starting to hit the maze that is crypto probing/manager code that
isn't easy to understand... at least not on a late Monday evening.
Any suggestions?

Right now, though, from what I can see the aes-arm-bs module is
entirely unusable, and the only way I can get a reasonably bootable
system is to avoid loading this module (either by disabling it in
the kernel build or blacklisting it in modprobe - the latter being
my current solutions to this bug.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
