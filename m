Received: from mega.nu (mega.nu [108.65.49.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A803D9DB8
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=108.65.49.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775835249; cv=none; b=mSJAdyBDWDBgs4wtZ7PlkFTTNcfWJ+4vRfIRmeXxVMqvTGhMpnXO9dH7MuTopCnVD7bWiyWj+ddtIpk97jVx0Mcl/nG+HzKLxPMbd+I1u460bvQ1lYxdF4LZusL9r02Dd4WSPi4c5qznwCdCD0lIWvETK60C/gIwh04jGkjNq3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775835249; c=relaxed/simple;
	bh=Orci6oOMhHLWvSqQ+pL/ybY7L7xeeuOjpBePwpavgn8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ES/8btK7Ocf6IRVk/wrv6HWe5m4aZR4ZrJv6EBcj91lq6v0KaeoEpzueVpxpMMO/bvXdfOGqTS1bFbuNbCcdGUJeolTWqRcg7UV5xXs++2CRMpEny5g1qL4AiUVm9BTaiJXGz4T/4h52AjOONut11YN+ymc+SezMBJ7lNnUSFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mega.nu; spf=pass smtp.mailfrom=mega.nu; dkim=pass (1024-bit key) header.d=mega.nu header.i=@mega.nu header.b=j/msZkNU; arc=none smtp.client-ip=108.65.49.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mega.nu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mega.nu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mega.nu header.i=@mega.nu header.b="j/msZkNU"
Received-SPF: pass (mega.nu: authenticated connection)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mega.nu; s=20180922;
	t=1775835219; bh=mPVBLwtOC+jo8k2ZiKBaBtmKJODVdXH5hiX0jEmEaIU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:Cc:
	 Subject:Reply-To:In-reply-to:References:Content-type;
	b=j/msZkNUzApLexKjb37CilvlfxdGNdGBx6jXCcJEIFzb4aAA+G2Cdl0OvpEE8Lq8B
	 KvMVFYkfnHKJzjvECk1qUx5p2TIvGKTPbwfKjttR+qjuwejepLtCyIrzibHikwkVKB
	 ZjCZpuGIVqOziBvUZX2g7Pe9mpodVZLx7pmeMCIw=
X-Authenticated-User: douzzer.mobile to mega.nu using PLAIN
Received: from douzzer.mobile (localhost [127.0.0.1])
	by mega.nu:587 (8.18.2/8.16.0.41) with ESMTPSA id 63AFXdiL017947
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 10 Apr 2026 15:33:39 GMT
	(envelope-from douzzer@mega.nu)
Message-ID: <ac3f34e743737c128c289576c1f134d1991d4552.camel@mega.nu>
Subject: Re: [PATCH] crypto: algif_aead - Revert to operating out-of-place
From: Daniel Pouzzner <douzzer@mega.nu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
        Taeyang Lee
 <0wn@theori.io>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Linus Torvalds	
 <torvalds@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni	 <pabeni@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
        Jungwon Lim <setuid0@theori.io>,
        Linux kernel regressions list
 <regressions@lists.linux.dev>
Date: Fri, 10 Apr 2026 10:33:39 -0500
In-Reply-To: <adkOsK-uPRsv49Yz@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
	 <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
	 <acTSfLPWDGTaGIf7@gondor.apana.org.au>
	 <73ab5267-57b8-4394-9c10-4ee3bf92e444@leemhuis.info>
	 <adkOsK-uPRsv49Yz@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

With your patches, no oopses in 20 iterations atop next-20260409.

However, wrong results under libkcapi test.sh on several AES-CCM scenarios.

7.0-rc7 with a664bf3d603 reverted produces correct results for these:

[PASSED: 64-bit - 7.0.0-rc7-bug221332] AEAD ccm(aes) asynchronous one shot =
multiple test
[PASSED: 64-bit - 7.0.0-rc7-bug221332] AEAD ccm(aes) asynchronous stream mu=
ltiple test
[PASSED: 64-bit - 7.0.0-rc7-bug221332] AEAD ccm(aes) asynchronous vmsplice =
multiple test

Without the reversion, it produce Oopses on these:

[PASSED: 64-bit - 7.0.0-rc7] AEAD ccm(aes) asynchronous one shot multiple t=
est
[PASSED: 64-bit - 7.0.0-rc7] AEAD ccm(aes) asynchronous stream multiple tes=
t
[   22.558016] BUG: kernel NULL pointer dereference, address: 0000000000000=
9fc
[   22.559018] #PF: supervisor read access in kernel mode
[   22.559741] #PF: error_code(0x0000) - not-present page
[   22.560470] PGD 108ff0067 P4D 0=20
[   22.560942] Oops: Oops: 0000 [#1] SMP NOPTI
[...]

Meanwhile, next-20260409 with your point patches to
crypto/algif_aead.c:_aead_recvmsg() and crypto/af_alg.c:af_alg_pull_tsgl()
deterministically produces wrong results on these:

[FAILED: 64-bit - 7.1.0-rc7-next-next-20260409-dirty] AEAD ccm(aes) asynchr=
onous one shot multiple test
(/usr/local/libexec/libkcapi/kcapi  -d 4 -x 10   -c ccm(aes) -q 4edb58e8d5e=
b6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d -t a7877c99 -n 674742=
abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4 -a fb7bc304a3909e66e2e0c5ef952=
712dd884ce3e7324171369f2c5db1adc48c7d)
Exp 8dd351509dcf1df9[...]
Got EBADMSG
[FAILED: 64-bit - 7.1.0-rc7-next-next-20260409-dirty] AEAD ccm(aes) asynchr=
onous stream multiple test
(/usr/local/libexec/libkcapi/kcapi -s -d 4 -x 10   -c ccm(aes) -q 4edb58e8d=
5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d -t a7877c99 -n 6747=
42abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4 -a fb7bc304a3909e66e2e0c5ef9=
52712dd884ce3e7324171369f2c5db1adc48c7d)
Exp 8dd351509dcf1df9[...]
Got EBADMSG
[FAILED: 64-bit - 7.1.0-rc7-next-next-20260409-dirty] AEAD ccm(aes) asynchr=
onous vmsplice multiple test
(/usr/local/libexec/libkcapi/kcapi -v -d 4 -x 10   -c ccm(aes) -q 4edb58e8d=
5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d -t a7877c99 -n 6747=
42abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4 -a fb7bc304a3909e66e2e0c5ef9=
52712dd884ce3e7324171369f2c5db1adc48c7d)
Exp 8dd351509dcf1df9[...]
Got EBADMSG


On Fri, 2026-04-10 at 22:52 +0800, Herbert Xu wrote:
> On Thu, Apr 09, 2026 at 05:24:49PM +0200, Thorsten Leemhuis wrote:
> >=20
> > This meanwhile became a664bf3d603dc3 ("crypto: algif_aead - Revert to
> > operating out-of-place") [v7.0-rc7] and according to Daniel Pouzzner
> > causes a regression reported here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D221332
> >=20
> > To quote: """Seeing Oopses and some kernel panics in 7.0_rc7 under
> > modest load, roughly 10% of test runs.  Discovered by serendipity
> > running libkcapi test.sh to test our own crypto module (libwolfssl.ko),
> > then reproduced on native crypto to exclude us as the cause.
>=20
> Please try these patches which are in the queue:
>=20
> https://patchwork.kernel.org/project/linux-crypto/patch/adCAFOgQ0y_I7SC7@=
gondor.apana.org.au/
> https://patchwork.kernel.org/project/linux-crypto/patch/adBbht8ERe0z-z3B@=
gondor.apana.org.au/
>=20
> Both fix pre-existing bugs that were uncovered by the aformentioned
> change and syzbot.
>=20
> Thanks,
