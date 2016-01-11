From: Thomas Egerer <hakke_007@gmx.de>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 11 Jan 2016 11:36:18 +0100
Message-ID: <6AC38649-C3F5-4D2D-8ED3-395C163D5695@gmx.de>
References: <568AC07B.8020605@gmx.de> <4445865.9O5pIU29W2@myon.chronox.de> <568AD989.8060802@gmx.de> <20160108094855.GA3472@gondor.apana.org.au> <5692BC22.4010903@gmx.de> <20160111033349.GA21571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53621 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383AbcAKKgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 05:36:37 -0500
In-Reply-To: <20160111033349.GA21571@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On January 11, 2016 4:33:49 AM GMT+01:00, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>On Sun, Jan 10, 2016 at 09:16:34PM +0100, Thomas Egerer wrote:
>> On 01/08/2016 10:48 AM, Herbert Xu wrote:
>>
>> > Please patch net/ipvX/Kconfig instead as ECHAINIV is only used
>> > by IPsec.
>> This does not seem right to me. By depending on CRYPTO_CBC in a
>particular
>> Kconfig, I would expect the 'default algorithm for CBC' to be
>transitively
>> selected with it. It's what CRYPTO_CTR does. There are a couple of
>places
>> that use select CRYPTO_CBC but not CRYPTO_ECHAINIV  (ext4, wusbcore,
>md
>> to mention a few). Wouldn't these end up unusable too, if CBC-mode
>doesn't
>> activate echainiv?
>
>All of those other users should work without echainiv so why would
>they need to select it?
I was under the impression that ECHAINIV was the default IV generator for CBC. At least that's what the help text said. Upon further investigation I found that the default is either chainiv or eseqiv (according to crypto_default_geniv). In this case it's true, net/ipvx/Kconfig files need to be patched.
>Cheers,


- --
Sent from a mobile device. Please excuse my brevity.
-----BEGIN PGP SIGNATURE-----
Version: APG v1.1.1

iQI+BAEBCgAoBQJWk4WiIRxUaG9tYXMgRWdlcmVyIDxoYWtrZV8wMDdAZ214LmRl
PgAKCRBit9TjYqwUxr2pD/0U0wcx2oOSpQNNfUKAI1hPmFx1PNI5m9HkozKS0rms
rpg56qdI+zBUBu9Xka0wZI4/UUBDA7DXzI+6kfqDZ+viBJFpCErRK9Be7hRZ7MGi
tq3BMg3xT6j6twxcDbpJV4qQPIjE/Y9/Mfgo1EuXVIctsLOAnSfRWXMp5X0zgwy8
1orhxFGyMCE2PRNQGgBSolJPHplVvioEGp9BcRMI+y4o5rBrjyWUG6AlwzMJTc89
QZ1XF8dKRymnpUiau84WcQsL6MG8y8ofZhLkbaoFFaa1jE1eu6DH2wSk3eiYX84o
ky3OJHcWbo4VWfTx6MM7eZ1DVeTs3iQ8bF/OIpsR1fR+jI336xK8cM4f+TaMXKlJ
pqe3oOv/tE4q6IUCnRsah1x1ipIjcReesr0vCyiMw03E2JP+duOp/RtGp3TX1/49
avJDHKC6Sgg3r8+MDUsyBnYxglYAvwaNmOnE09KLzqzfKapdqv3FGDC8titI3edZ
6RJPxBnbYBFnkqhUDZ0u6tE7SJSDUe6zd+0Ruod7dgilhr8XlI+bWawh5b/SmHjp
i8pVDnEn30iTG/ogCduLsP4J0K3Oimb42fsXf3/vIoA/mZC7+uuIQJk6BxahW5Wq
k3bhDSk/HGYGeTQ76vsqv+O9b33FiOgmcHrCrxjp1CtT3bQNHX6Od6glcFjOnugr
fg==
=+i8R
-----END PGP SIGNATURE-----
