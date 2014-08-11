From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH 2/3] crypto: testmgr.c: white space removal on __test_skcipher
Date: Mon, 11 Aug 2014 09:33:50 +0300
Message-ID: <53E863CE.3060509@freescale.com>
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
 <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
 <53E733EF.80003@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:43002
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbaHKGeE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 02:34:04 -0400
In-Reply-To: <53E733EF.80003@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Horia,

On 10.08.2014 11:57, Horia Geant=C4=83 wrote:
> On 8/8/2014 2:27 PM, Cristian Stoica wrote:
> Don't add more checkpatch warnings on top of existing ones.

I've weighted all the checkpatch warnings and errors introduced by thes=
e
patches and I've found them fair versus Linux coding style guide.

If these are the only barriers to acceptance then I'll consider an
update if Herbert agrees with the patches:

> WARNING: line over 80 characters
> #58: FILE: crypto/testmgr.c:992:
>=20
>> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

This line is 82 chars long. I find it slightly more readable than the
alternative[s].

"The limit on the length of lines is 80 columns and this is a strongly
preferred limit [...] unless exceeding 80 columns significantly
increases readability and does not hide information"

Now this is a debate about "slightly" vs "significantly". Have fun.

Cristian S.
