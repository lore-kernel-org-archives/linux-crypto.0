From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH 11/11] crypto: add crypto compression sefltest
Date: Wed, 8 Apr 2015 10:48:03 -0400
Message-ID: <CALZtONB371ODDyhAVxgaGtxMWRSgshaXsYB8P_5AwSmdiJaAQg@mail.gmail.com>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-12-git-send-email-ddstreet@ieee.org> <20150408141631.GB30338@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:32928 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbDHOs2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:48:28 -0400
In-Reply-To: <20150408141631.GB30338@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 8, 2015 at 10:16 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Apr 07, 2015 at 01:34:30PM -0400, Dan Streetman wrote:
>> Add configurable module to perform self-tests on any crypto compression
>> driver.
>>
>> This allows testing any crypto compression driver with any input buffer,
>> at varying alignments and lengths.  It calculates the average bytes per
>> second compression and decompression rates.  Any errors reported by the
>> compressor during compression or decompression will end the test and
>> be logged.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>
> Please use the existing infrastructure in testmgr/tcrypt.

I think I looked at that and it didn't seem like it would be able to
include all the user controls, but I'll look again.  In any case this
test doesn't have to be included in this 842 patch set, so I'll drop
it from the next version and re-send it by itself if/when I can update
it to use testmgr.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
