From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: Re: [PATCH] crypto: XTS - remove test that will fail in FIPS mode
Date: Wed, 10 Aug 2016 22:08:30 +0000
Message-ID: <D3D10E85.2F74%tsarangi@trustwave.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
 <6079382.fWeFLzBGfE@positron.chronox.de>
 <D3CFBBE7.2B1D%tsarangi@trustwave.com>
 <3590892.3HIz2aNZPY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-elk-03.trustwave.com ([204.13.202.190]:15075 "EHLO
	seg-node-elk-03.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbcHJWIf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 18:08:35 -0400
In-Reply-To: <3590892.3HIz2aNZPY@positron.chronox.de>
Content-Language: en-US
Content-ID: <CC4502F8329A4C4286C88314852AB1D5@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Thanks. Sorry for a late reply to this.

I did test your patch for testmgr.h with the vanilla kernel 4.7 source.
This doesn¹t solve the xts(aes) self-test failure in FIPS mode. I get the
exact same error as before.

Thanks
-Tapas







On 8/10/16, 12:49 AM, "Stephan Mueller" <smueller@chronox.de> wrote:

>Hi Tapas, Herbert,
>
>Tapas: this patch should fix it. Can you please test?
>
>Herbert: The reason why I have to caught this issue in my tests is the
>following: I compile xts-aes-aesni statically as you can see below. The
>self test is marked as passed, although there is no XTS test performed.
>When you boot in FIPS mode, the testmgr prints out all tests. But XTS is
>not among them. Do you have an idea why that happens?
>
>name         : xts(aes)
>driver       : xts-aes-aesni
>module       : kernel
>priority     : 400
>refcnt       : 1
>selftest     : passed
>internal     : no
>type         : ablkcipher
>async        : yes
>blocksize    : 16
>min keysize  : 32
>max keysize  : 64
>ivsize       : 16
>geniv        : <default>
>
>---8<---
>
>In FIPS mode, setting XTS keys where the AES key is identical to the
>tweak key is forbidden. Thus, the self test with such property will fail
>in FIPS mode.
>
>As we have other tests available for XTS, this patch simply removes the
>offending test vectors.
>
>Reported-by: Tapas Sarangi <TSarangi@trustwave.com>
>Signed-off-by: Stephan Mueller <smueller@chronox.de>
>---
> crypto/testmgr.h | 36 ------------------------------------
> 1 file changed, 36 deletions(-)
>
>diff --git a/crypto/testmgr.h b/crypto/testmgr.h
>index acb6bbf..e4b58f5 100644
>--- a/crypto/testmgr.h
>+++ b/crypto/testmgr.h
>@@ -10179,24 +10179,6 @@ static struct cipher_testvec
>tf_lrw_dec_tv_template[] = {
> static struct cipher_testvec tf_xts_enc_tv_template[] = {
>       /* Generated from AES-XTS test vectors */
> {
>-              .key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .klen   = 32,
>-              .iv     = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .input  = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .ilen   = 32,
>-              .result = "\x4b\xc9\x44\x4a\x11\xa3\xef\xac"
>-                        "\x30\x74\xe4\x44\x52\x77\x97\x43"
>-                        "\xa7\x60\xb2\x45\x2e\xf9\x00\x90"
>-                        "\x9f\xaa\xfd\x89\x6e\x9d\x4a\xe0",
>-              .rlen   = 32,
>-      }, {
>               .key    = "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x22\x22\x22\x22\x22\x22\x22\x22"
>@@ -10522,24 +10504,6 @@ static struct cipher_testvec
>tf_xts_dec_tv_template[] = {
>       /* Generated from AES-XTS test vectors */
>       /* same as enc vectors with input and result reversed */
>       {
>-              .key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .klen   = 32,
>-              .iv     = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .input  = "\x4b\xc9\x44\x4a\x11\xa3\xef\xac"
>-                        "\x30\x74\xe4\x44\x52\x77\x97\x43"
>-                        "\xa7\x60\xb2\x45\x2e\xf9\x00\x90"
>-                        "\x9f\xaa\xfd\x89\x6e\x9d\x4a\xe0",
>-              .ilen   = 32,
>-              .result = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .rlen   = 32,
>-      }, {
>               .key    = "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x22\x22\x22\x22\x22\x22\x22\x22"
>--
>2.7.4
>
>


________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
