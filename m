Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3134F9EC
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 23:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744067809; cv=none; b=E8PSnZziK5oxgVvQjOKQAeGOxe2k0D9vAB0XZXmNuYaeHArcai2Em0fu0Dky05LyTpDjTyTv0AOLEmfjOMK6plEKpCinmBMHJm4o8v08bVrkJxV1pjw3jgJETPP0nODo4VOhSEDi5Vodyw2fY7J+f5v0mUIftBilGmlwUOO1Gv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744067809; c=relaxed/simple;
	bh=maQ8bTDxn12c3Z1osDGoBxcBxn9z/J+J0b8HhUv35Qc=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=FKXlLgZ8et6MiUevYbA+g8dYO+mYHsOFjIS4+Mdfc/BkCgNDn8gJBnhaArwsC0sj3GJPnm/Qy0sN4m3K5YrQaTXv9T8f87EhgxfOzFwlHZntM1p3AoEr4pFB+cBo1KTDbBrU3lPaEyi0nVqxL3voV04caDUEv38RWh4GpU8Fczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xGa2JtdU; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xGa2JtdU"
Message-ID: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744067802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Hb1bGM49XECEPiFzn5oRQ3841nrVpHrnX1Knl+1oj2A=;
	b=xGa2JtdUz5kuke2hEYsv7CRtAa/fPFUCakXUaXwfW46nx9TAgjG5/fCiXCYLHDKojtl/Ld
	e1D0d7i6WJSxhrDWvlpuYYQ6T0moHhg5sY6CH+0CN00946LC/ENs6cj1uxcwGBSGJo0Oe8
	EL0h/OD80PSvYJTmGPYERrewr6U/VEU=
Date: Mon, 7 Apr 2025 19:16:38 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Sean Anderson <sean.anderson@linux.dev>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
 linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [BUG] CAAM refcount warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi all,

I see the following warnings when booting net-next/main with U-Boot
2022.07 on a LS1046ARDB:

[    2.724435] alg: No test for echainiv(authenc(hmac(sha512),cbc(des))) (echainiv-authenc-hmac-sha512-cbc-des-caam-qi)
[    2.724507] alg: No test for echainiv(authenc(hmac(sha384),cbc(des))) (echainiv-authenc-hmac-sha384-cbc-des-caam-qi)
[    2.730102] alg: No test for echainiv(authenc(hmac(sha256),cbc(des))) (echainiv-authenc-hmac-sha256-cbc-des-caam-qi)
[    2.730189] alg: No test for echainiv(authenc(hmac(sha224),cbc(des))) (echainiv-authenc-hmac-sha224-cbc-des-caam-qi)
[    2.730314] alg: No test for echainiv(authenc(hmac(sha1),cbc(des))) (echainiv-authenc-hmac-sha1-cbc-des-caam-qi)
[    2.730369] alg: No test for echainiv(authenc(hmac(md5),cbc(des))) (echainiv-authenc-hmac-md5-cbc-des-caam-qi)
[    2.730456] alg: No test for authenc(hmac(md5),cbc(des)) (authenc-hmac-md5-cbc-des-caam-qi)
[    2.730475] alg: No test for echainiv(authenc(hmac(sha512),cbc(des3_ede))) (echainiv-authenc-hmac-sha512-cbc-des3_ede-caam-qi)
[    2.730589] alg: No test for echainiv(authenc(hmac(sha384),cbc(des3_ede))) (echainiv-authenc-hmac-sha384-cbc-des3_ede-caam-qi)
[    2.730731] alg: No test for echainiv(authenc(hmac(sha256),cbc(des3_ede))) (echainiv-authenc-hmac-sha256-cbc-des3_ede-caam-qi)
[    2.731078] alg: No test for echainiv(authenc(hmac(sha224),cbc(des3_ede))) (echainiv-authenc-hmac-sha224-cbc-des3_ede-caam-qi)
[    2.731342] ------------[ cut here ]------------
[    2.731344] refcount_t: decrement hit 0; leaking memory.
[    2.731378] WARNING: CPU: 1 PID: 127 at lib/refcount.c:31 refcount_warn_saturate (lib/refcount.c:31 (discriminator 1)) 
[    2.731394] Modules linked in:
[    2.731400] CPU: 1 UID: 0 PID: 127 Comm: cryptomgr_test Not tainted 6.14.0-seco+ #162 NONE
[    2.731405] Hardware name: LS1046A RDB Board (DT)
[    2.731407] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.731411] pc : refcount_warn_saturate (lib/refcount.c:31 (discriminator 1)) 
[    2.731417] lr : refcount_warn_saturate (lib/refcount.c:31 (discriminator 1)) 
[    2.731421] sp : ffffffc08000bd10
[    2.731423] x29: ffffffc08000bd10 x28: ffffff8b7a7a5380 x27: ffffffc08000beb8
[    2.731430] x26: 0000000000000005 x25: ffffff8b7a7a4240 x24: 0000000000000000
[    2.731438] x23: 00000000000031c0 x22: ffffffc08207e208 x21: ffffff8800ef3530
[    2.731444] x20: ffffffc082ea53c0 x19: ffffff88017fc680 x18: 0000000000000000
[    2.731450] x17: ffffffcaf8e84000 x16: ffffffc080008000 x15: 04040b1e4d004284
[    2.731456] x14: ffffff880213c280 x13: 0a2e79726f6d656d x12: 20676e696b61656c
[    2.731462] x11: 203b302074696820 x10: ffffffc081dbdef8 x9 : ffffffc081d91ef8
[    2.731469] x8 : ffffffc08000ba08 x7 : ffffffc081d91ef8 x6 : 00000000fffff7ff
[    2.731475] x5 : 000000000000015f x4 : 0000000000000000 x3 : 0000000000000000
[    2.731481] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffff8802143180
[    2.731487] Call trace:
[    2.731489] refcount_warn_saturate (lib/refcount.c:31 (discriminator 1)) (P)
[    2.731496] caam_rsp_fq_dqrr_cb (include/linux/refcount.h:336 include/linux/refcount.h:351 drivers/crypto/caam/qi.c:593) 
[    2.731502] qman_p_poll_dqrr (drivers/soc/fsl/qbman/qman.c:1652 drivers/soc/fsl/qbman/qman.c:1759) 
[    2.731510] caam_qi_poll (drivers/crypto/caam/qi.c:491) 
[    2.731514] __napi_poll (net/core/dev.c:7328) 
[    2.731520] net_rx_action (net/core/dev.c:7394 net/core/dev.c:7514) 
[    2.731524] handle_softirqs (arch/arm64/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:562) 
[    2.731530] __do_softirq (kernel/softirq.c:596) 
[    2.731533] ____do_softirq (arch/arm64/kernel/irq.c:82) 
[    2.731538] call_on_irq_stack (arch/arm64/kernel/entry.S:897) 
[    2.731542] do_softirq_own_stack (arch/arm64/kernel/irq.c:87) 
[    2.731547] __irq_exit_rcu (kernel/softirq.c:442 kernel/softirq.c:662) 
[    2.731550] irq_exit_rcu (kernel/softirq.c:681) 
[    2.731554] el1_interrupt (arch/arm64/kernel/entry-common.c:565 arch/arm64/kernel/entry-common.c:575) 
[    2.731561] el1h_64_irq_handler (arch/arm64/kernel/entry-common.c:581) 
[    2.731567] el1h_64_irq (arch/arm64/kernel/entry.S:596) 
[    2.731570] qman_enqueue (drivers/soc/fsl/qbman/qman.c:2354) (P)
[    2.731576] caam_qi_enqueue (drivers/crypto/caam/qi.c:125) 
[    2.731580] aead_encrypt (drivers/crypto/caam/caamalg.c:1515 drivers/crypto/caam/caamalg.c:1532) 
[    2.731586] crypto_aead_encrypt (crypto/aead.c:91) 
[    2.731593] test_aead_vec_cfg (crypto/testmgr.c:2151 (discriminator 1)) 
[    2.731600] test_aead (crypto/testmgr.c:2262 crypto/testmgr.c:2691) 
[    2.731604] alg_test_aead (crypto/testmgr.c:2739) 
[    2.731610] alg_test (crypto/testmgr.c:5996) 
[    2.731615] cryptomgr_test (crypto/algboss.c:181) 
[    2.731620] kthread (kernel/kthread.c:464) 
[    2.731626] ret_from_fork (arch/arm64/kernel/entry.S:863) 
[    2.731630] ---[ end trace 0000000000000000 ]---
[    2.731638] ------------[ cut here ]------------
[    2.731639] refcount_t: saturated; leaking memory.
[    2.731649] WARNING: CPU: 1 PID: 127 at lib/refcount.c:22 refcount_warn_saturate (lib/refcount.c:22 (discriminator 1)) 
[    2.731656] Modules linked in:
[    2.731660] CPU: 1 UID: 0 PID: 127 Comm: cryptomgr_test Tainted: G        W          6.14.0-seco+ #162 NONE
[    2.731665] Tainted: [W]=WARN
[    2.731667] Hardware name: LS1046A RDB Board (DT)
[    2.731669] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.731672] pc : refcount_warn_saturate (lib/refcount.c:22 (discriminator 1)) 
[    2.731677] lr : refcount_warn_saturate (lib/refcount.c:22 (discriminator 1)) 
[    2.731682] sp : ffffffc08607b900
[    2.731684] x29: ffffffc08607b900 x28: 0000000000000400 x27: ffffffc08607bb00
[    2.731690] x26: ffffffc08068dc70 x25: ffffffc0812b20e0 x24: ffffffc08607ba50
[    2.731696] x23: 0000000000000001 x22: 0000000000002710 x21: 0000000000000000
[    2.731702] x20: ffffff8800e99410 x19: ffffff88017fc680 x18: 0000000000000000
[    2.731708] x17: 637253657920616e x16: 204d6f6f20547473 x15: 04040b1e4d004284
[    2.731714] x14: e8db9514e884c2ea x13: 0a2e79726f6d656d x12: 20676e696b61656c
[    2.731720] x11: 203b646574617275 x10: ffffffc081dbdef8 x9 : ffffffc081d91ef8
[    2.731726] x8 : ffffffc08607b5f8 x7 : ffffffc081d91ef8 x6 : 00000000fffff7ff
[    2.731732] x5 : 0000000000000190 x4 : 0000000000000000 x3 : 0000000000000000
[    2.731738] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffff8802143180
[    2.731744] Call trace:
[    2.731745] refcount_warn_saturate (lib/refcount.c:22 (discriminator 1)) (P)
[    2.731751] caam_qi_enqueue (include/linux/refcount.h:192 include/linux/refcount.h:241 include/linux/refcount.h:258 drivers/crypto/caam/qi.c:127) 
[    2.731755] aead_encrypt (drivers/crypto/caam/caamalg.c:1515 drivers/crypto/caam/caamalg.c:1532) 
[    2.731761] crypto_aead_encrypt (crypto/aead.c:91) 
[    2.731766] test_aead_vec_cfg (crypto/testmgr.c:2151 (discriminator 1)) 
[    2.731771] test_aead (crypto/testmgr.c:2262 crypto/testmgr.c:2691) 
[    2.731776] alg_test_aead (crypto/testmgr.c:2739) 
[    2.731781] alg_test (crypto/testmgr.c:5996) 
[    2.731786] cryptomgr_test (crypto/algboss.c:181) 
[    2.731791] kthread (kernel/kthread.c:464) 
[    2.731796] ret_from_fork (arch/arm64/kernel/entry.S:863) 
[    2.731801] ---[ end trace 0000000000000000 ]---
[    2.731913] alg: No test for echainiv(authenc(hmac(sha1),cbc(des3_ede))) (echainiv-authenc-hmac-sha1-cbc-des3_ede-caam-qi)
[    2.732339] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-des3_ede-caam-qi)
[    2.732389] alg: No test for echainiv(authenc(hmac(md5),cbc(des3_ede))) (echainiv-authenc-hmac-md5-cbc-des3_ede-caam-qi)
[    2.732491] alg: No test for echainiv(authenc(hmac(sha512),cbc(aes))) (echainiv-authenc-hmac-sha512-cbc-aes-caam-qi)
[    2.732768] alg: No test for echainiv(authenc(hmac(sha384),cbc(aes))) (echainiv-authenc-hmac-sha384-cbc-aes-caam-qi)
[    2.732977] alg: No test for authenc(hmac(sha384),cbc(aes)) (authenc-hmac-sha384-cbc-aes-caam-qi)
[    2.732999] alg: No test for echainiv(authenc(hmac(sha256),cbc(aes))) (echainiv-authenc-hmac-sha256-cbc-aes-caam-qi)
[    2.733141] alg: No test for echainiv(authenc(hmac(sha224),cbc(aes))) (echainiv-authenc-hmac-sha224-cbc-aes-caam-qi)
[    2.733261] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-caam-qi)
[    2.733316] alg: No test for echainiv(authenc(hmac(sha1),cbc(aes))) (echainiv-authenc-hmac-sha1-cbc-aes-caam-qi)
[    2.733448] alg: No test for echainiv(authenc(hmac(md5),cbc(aes))) (echainiv-authenc-hmac-md5-cbc-aes-caam-qi)
[    2.733550] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-caam-qi)
[    2.735042] alg: No test for stdrng (prng-caam)
[    2.747764] alg: No test for seqiv(authenc(hmac(sha512),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha512-rfc3686-ctr-aes-caam)
[    2.770224] alg: No test for seqiv(authenc(hmac(sha384),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha384-rfc3686-ctr-aes-caam)
[    2.770777] alg: No test for seqiv(authenc(hmac(sha256),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha256-rfc3686-ctr-aes-caam)
[    2.770948] alg: No test for seqiv(authenc(hmac(sha224),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha224-rfc3686-ctr-aes-caam)
[    2.771083] alg: No test for authenc(hmac(sha224),rfc3686(ctr(aes))) (authenc-hmac-sha224-rfc3686-ctr-aes-caam)
[    2.771148] alg: No test for seqiv(authenc(hmac(sha1),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha1-rfc3686-ctr-aes-caam)
[    2.771282] alg: No test for seqiv(authenc(hmac(md5),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-md5-rfc3686-ctr-aes-caam)
[    2.771380] alg: No test for authenc(hmac(md5),rfc3686(ctr(aes))) (authenc-hmac-md5-rfc3686-ctr-aes-caam)
[    2.771422] alg: No test for echainiv(authenc(hmac(sha512),cbc(des))) (echainiv-authenc-hmac-sha512-cbc-des-caam)
[    2.771587] alg: No test for echainiv(authenc(hmac(sha384),cbc(des))) (echainiv-authenc-hmac-sha384-cbc-des-caam)
[    2.776945] alg: No test for echainiv(authenc(hmac(sha256),cbc(des))) (echainiv-authenc-hmac-sha256-cbc-des-caam)
[    2.777103] alg: No test for echainiv(authenc(hmac(sha224),cbc(des))) (echainiv-authenc-hmac-sha224-cbc-des-caam)
[    2.777217] alg: No test for echainiv(authenc(hmac(sha1),cbc(des))) (echainiv-authenc-hmac-sha1-cbc-des-caam)
[    2.777382] alg: No test for echainiv(authenc(hmac(md5),cbc(des))) (echainiv-authenc-hmac-md5-cbc-des-caam)
[    2.777447] alg: No test for authenc(hmac(md5),cbc(des)) (authenc-hmac-md5-cbc-des-caam)
[    2.777498] alg: No test for echainiv(authenc(hmac(sha512),cbc(des3_ede))) (echainiv-authenc-hmac-sha512-cbc-des3_ede-caam)
[    2.777685] alg: No test for echainiv(authenc(hmac(sha384),cbc(des3_ede))) (echainiv-authenc-hmac-sha384-cbc-des3_ede-caam)
[    2.777933] alg: No test for echainiv(authenc(hmac(sha256),cbc(des3_ede))) (echainiv-authenc-hmac-sha256-cbc-des3_ede-caam)
[    2.778148] alg: No test for echainiv(authenc(hmac(sha224),cbc(des3_ede))) (echainiv-authenc-hmac-sha224-cbc-des3_ede-caam)
[    2.778281] alg: No test for echainiv(authenc(hmac(sha1),cbc(des3_ede))) (echainiv-authenc-hmac-sha1-cbc-des3_ede-caam)
[    2.778422] alg: No test for echainiv(authenc(hmac(md5),cbc(des3_ede))) (echainiv-authenc-hmac-md5-cbc-des3_ede-caam)
[    2.778502] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-des3_ede-caam)
[    2.778580] alg: No test for echainiv(authenc(hmac(sha512),cbc(aes))) (echainiv-authenc-hmac-sha512-cbc-aes-caam)
[    2.778717] alg: No test for echainiv(authenc(hmac(sha384),cbc(aes))) (echainiv-authenc-hmac-sha384-cbc-aes-caam)
[    2.778812] alg: No test for authenc(hmac(sha384),cbc(aes)) (authenc-hmac-sha384-cbc-aes-caam)
[    2.778887] alg: No test for echainiv(authenc(hmac(sha256),cbc(aes))) (echainiv-authenc-hmac-sha256-cbc-aes-caam)
[    2.779038] alg: No test for echainiv(authenc(hmac(sha224),cbc(aes))) (echainiv-authenc-hmac-sha224-cbc-aes-caam)
[    2.779135] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-caam)
[    2.779244] alg: No test for echainiv(authenc(hmac(sha1),cbc(aes))) (echainiv-authenc-hmac-sha1-cbc-aes-caam)
[    2.779314] alg: No test for echainiv(authenc(hmac(md5),cbc(aes))) (echainiv-authenc-hmac-md5-cbc-aes-caam)
[    2.779404] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-caam)
[    2.779474] alg: No test for authenc(hmac(sha512),ecb(cipher_null)) (authenc-hmac-sha512-ecb-cipher_null-caam)
[    2.779519] alg: No test for authenc(hmac(sha384),ecb(cipher_null)) (authenc-hmac-sha384-ecb-cipher_null-caam)
[    2.779555] alg: No test for authenc(hmac(sha256),ecb(cipher_null)) (authenc-hmac-sha256-ecb-cipher_null-caam)
[    2.779625] alg: No test for authenc(hmac(sha224),ecb(cipher_null)) (authenc-hmac-sha224-ecb-cipher_null-caam)
[    2.807182] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    3.002053] caam 1700000.crypto: -1073741824 frames from FQID 15 still pending in CAAM
[    3.020733] alg: sig: sign test failed: invalid output
[    3.753748] 00000000: 68 e4 b7 d5 2e 12 d4 9b ca a5 a7 fc 50 2f d2 f6
[    3.760192] 00000010: 6b 01 58 1e b7 72 2c 0f 66 a4 c9 1e b9 49 21 a7
[    3.766636] 00000020: 53 62 26 6d bb 69 62 a2 7e 3b 8d 80 6f 2d 21 9d
[    3.773079] 00000030: cd 6f 92 e5 a9 03 e4 b3 b0 fc e7 4f ec a7 23 5c
[    3.779522] 00000040: 1d dc 08 13 c3 2e 8b d9 fa ab e0 6f 2b a0 9d 2b
[    3.785965] 00000050: 32 47 d5 ad ec 65 5a ce b3 13 35 95 37 0e f1 b0
[    3.792407] 00000060: c3 8e 22 0d c9 a2 b3 31 58 ea 74 18 18 d2 9f 7e
[    3.798848] 00000070: 04 fe 3b f1 5e 40 6c 39 3f 38 a2 71 58 fa da 1a
[    3.805291] 00000080: ed 02 70 7c 9e 72 93 a3 66 25 f2 35 e9 82 00 49
[    3.811734] 00000090: 8e 09 b9 f0 52 76 b2 9e b4 06 b0 60 f2 15 a1 78
[    3.818176] 000000a0: 74 3c 9b 87 17 f6 e8 ff ca fe 41 ed 73 c8 28 70
[    3.824619] 000000b0: 33 cc a2 de d6 04 7a b5 85 81 a3 46 16 46 66 af
[    3.831060] 000000c0: 26 84 bc 9e 70 68 7c b3 68 44 73 4c c2 a4 70 45
[    3.837503] 000000d0: a5 af a3 b3 9c cb b5 c8 bf 7d 8a 17 97 f6 33 0c
[    3.843944] 000000e0: 94 cc d3 fd ee e7 ba 8b dc 6f c7 3b 3b 67 14 ae
[    3.850387] 000000f0: 6a 00 33 90 df c5 f9 a2 6c b8 93 f7 cf 6b 0d 0d
[    3.856828] alg: sig: test 1 failed for pkcs1(rsa-caam,sha256): err -22
[    3.863447] alg: self-tests for pkcs1(rsa,sha256) using pkcs1(rsa-caam,sha256) failed (rc=-22)
[    3.863451] ------------[ cut here ]------------
[    3.876680] alg: self-tests for pkcs1(rsa,sha256) using pkcs1(rsa-caam,sha256) failed (rc=-22)
[    3.876705] WARNING: CPU: 3 PID: 319 at crypto/testmgr.c:6012 alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.892894] Modules linked in:
[    3.895946] CPU: 3 UID: 0 PID: 319 Comm: cryptomgr_test Tainted: G        W          6.14.0-seco+ #162 NONE
[    3.905778] Tainted: [W]=WARN
[    3.908739] Hardware name: LS1046A RDB Board (DT)
[    3.913439] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.920401] pc : alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.924060] lr : alg_test (crypto/testmgr.c:6012 (discriminator 1)) 
[    3.927720] sp : ffffffc086e2bd40
[    3.931028] x29: ffffffc086e2bd40 x28: 0000000000000000 x27: 0000000000000000
[    3.938168] x26: 00000000ffffffea x25: 00000000ffffffff x24: ffffffc082066470
[    3.945307] x23: 0000000000000159 x22: 0000000000000807 x21: ffffff88010fe280
[    3.952446] x20: ffffff88010fe200 x19: ffffffc081290df0 x18: 0000000000000000
[    3.959584] x17: 35326168732c6d61 x16: 61632d6173722831 x15: 000000000000002d
[    3.966723] x14: 0000000000000000 x13: 00000000fffffffe x12: 65742d666c657320
[    3.973862] x11: 656820747563205b x10: ffffffc081dc0df0 x9 : ffffffc081d91ef8
[    3.981000] x8 : ffffffc086e2bb28 x7 : ffffffc081d91ef8 x6 : 00000000fffff7ff
[    3.988138] x5 : 00000000000001f6 x4 : 0000000000000000 x3 : 0000000000000000
[    3.995276] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffff8800f6e300
[    4.002414] Call trace:
[    4.004853] alg_test (crypto/testmgr.c:6012 (discriminator 1)) (P)
[    4.008513] cryptomgr_test (crypto/algboss.c:181) 
[    4.012172] kthread (kernel/kthread.c:464) 
[    4.015311] ret_from_fork (arch/arm64/kernel/entry.S:863) 
[    4.018884] ---[ end trace 0000000000000000 ]---

I can retry with a newer U-Boot if you think it may affect things.

--Sean
