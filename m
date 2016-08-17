From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: Re: [PATCH v2] crypto: XTS - remove test that will fail in FIPS mode
Date: Wed, 17 Aug 2016 14:52:32 +0000
Message-ID: <D3D9E3A3.30E6%tsarangi@trustwave.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
 <D3CFBBE7.2B1D%tsarangi@trustwave.com>
 <3590892.3HIz2aNZPY@positron.chronox.de>
 <16370043.OYgDIDmMpM@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-elk-02.trustwave.com ([204.13.202.189]:14061 "EHLO
	seg-node-elk-02.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbcHQOwi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2016 10:52:38 -0400
In-Reply-To: <16370043.OYgDIDmMpM@tauon.atsec.com>
Content-Language: en-US
Content-ID: <6A7C0516BE1D0C4FAFC326B4970E8308@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Yes, can you give me some more detail about your findings on dracut-fips
!? This seems to be the major difference between our test environments
where a bunch of algorithms are failing self-test during boot with fips=1.

Thanks
-Tapas


On 8/16/16, 4:38 AM, "Stephan Mueller" <smueller@chronox.de> wrote:

>Hi Tapas,
>
>I was able to reproduce the issue now.
>
>I tested the patch below and it works for me now. Yet, I see that
>dracut-fips seems to need some fixes too as it cannot find cmac when
>compiled as module and has some issues with the authenc() ciphers too.
>
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
>Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>
>---
> crypto/testmgr.h | 44 ++++----------------------------------------
> 1 file changed, 4 insertions(+), 40 deletions(-)
>
>diff --git a/crypto/testmgr.h b/crypto/testmgr.h
>index acb6bbf..893b321 100644
>--- a/crypto/testmgr.h
>+++ b/crypto/testmgr.h
>@@ -15179,8 +15179,8 @@ static struct cipher_testvec
>cast6_xts_dec_tv_template[] = {
> #define HMAC_SHA512_AES_CBC_ENC_TEST_VEC 7
> #define AES_LRW_ENC_TEST_VECTORS 8
> #define AES_LRW_DEC_TEST_VECTORS 8
>-#define AES_XTS_ENC_TEST_VECTORS 5
>-#define AES_XTS_DEC_TEST_VECTORS 5
>+#define AES_XTS_ENC_TEST_VECTORS 4
>+#define AES_XTS_DEC_TEST_VECTORS 4
> #define AES_CTR_ENC_TEST_VECTORS 5
> #define AES_CTR_DEC_TEST_VECTORS 5
> #define AES_OFB_ENC_TEST_VECTORS 1
>@@ -18218,25 +18218,7 @@ static struct cipher_testvec
>aes_lrw_dec_tv_template[] = {
>
> static struct cipher_testvec aes_xts_enc_tv_template[] = {
>       /*
>http://scanmail.trustwave.com/?c=4062&d=-96y1wXsB1ZUProHtkc64VYvnNekxXtLFt
>hU_sfSVw&s=5&u=http%3a%2f%2fgrouper%2eieee%2eorg%2fgroups%2f1619%2femail%2
>fpdf00086%2epdf */
>-      { /* XTS-AES 1 */
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
>-              .result = "\x91\x7c\xf6\x9e\xbd\x68\xb2\xec"
>-                        "\x9b\x9f\xe9\xa3\xea\xdd\xa6\x92"
>-                        "\xcd\x43\xd2\xf5\x95\x98\xed\x85"
>-                        "\x8c\x02\xc2\x65\x2f\xbf\x92\x2e",
>-              .rlen   = 32,
>-      }, { /* XTS-AES 2 */
>+      { /* XTS-AES 2 */
>               .key    = "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x22\x22\x22\x22\x22\x22\x22\x22"
>@@ -18560,25 +18542,7 @@ static struct cipher_testvec
>aes_xts_enc_tv_template[] = {
>
> static struct cipher_testvec aes_xts_dec_tv_template[] = {
>       /*
>http://scanmail.trustwave.com/?c=4062&d=-96y1wXsB1ZUProHtkc64VYvnNekxXtLFt
>hU_sfSVw&s=5&u=http%3a%2f%2fgrouper%2eieee%2eorg%2fgroups%2f1619%2femail%2
>fpdf00086%2epdf */
>-      { /* XTS-AES 1 */
>-              .key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .klen   = 32,
>-              .iv     = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                        "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .input = "\x91\x7c\xf6\x9e\xbd\x68\xb2\xec"
>-                       "\x9b\x9f\xe9\xa3\xea\xdd\xa6\x92"
>-                       "\xcd\x43\xd2\xf5\x95\x98\xed\x85"
>-                       "\x8c\x02\xc2\x65\x2f\xbf\x92\x2e",
>-              .ilen   = 32,
>-              .result  = "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                         "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                         "\x00\x00\x00\x00\x00\x00\x00\x00"
>-                         "\x00\x00\x00\x00\x00\x00\x00\x00",
>-              .rlen   = 32,
>-      }, { /* XTS-AES 2 */
>+      { /* XTS-AES 2 */
>               .key    = "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x11\x11\x11\x11\x11\x11\x11\x11"
>                         "\x22\x22\x22\x22\x22\x22\x22\x22"
>--
>2.7.4
>
>


________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
