From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH 0/5] crypto: atmel-sha: fix registration issue and other
 bugs
Date: Mon, 25 Jan 2016 15:56:24 +0100
Message-ID: <56A63798.5050208@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
 <20160125144849.GH8840@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <davem@davemloft.net>, <nicolas.ferre@atmel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:54248 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbcAYO42 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:56:28 -0500
In-Reply-To: <20160125144849.GH8840@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Le 25/01/2016 15:48, Herbert Xu a =E9crit :
> On Fri, Jan 15, 2016 at 03:49:30PM +0100, Cyrille Pitchen wrote:
>> Hi all,
>>
>> This series of patches fixes many issues such as the algo registrati=
on failure
>> or the broken support of context switches.
>>
>> This series was applied to linux-next and tested on a sama5d2 xplain=
ed
>> ultra board. We now pass the tcrypt tests in the following modes:
>> -  2: sha1
>> -  6: sha256
>> - 11: sha384
>> - 12: sha512
>> - 33: sha224
>>
>> The context switch fix was tested with a userspace program using the=
 cryptodev
>> module. This single thread program computes the SHA256 hashes of man=
y files
>> by splitting then into fixed size chunks. The chunks of each file ar=
e
>> processed by calling 'update' operations using a round robin algorit=
hm.
>>
>> However, the .import() / .export() implementation was NOT tested!
>> Nonetheless the last patch is needed to fix the registration issue, =
otherwise
>> atmel_sha_probe() would still fail.
>=20
> Patch 1-4 applied.  Please fix the alignment issue with patch 5.
>=20

OK, I will fix it soon!


Best regards,

Cyrille
