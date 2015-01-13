From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto: Add support for 192 & 256 bit keys to AESNI RFC4106 -
 resubmission
Date: Tue, 13 Jan 2015 22:27:10 +1100
Message-ID: <20150113112710.GA6129@gondor.apana.org.au>
References: <Pine.WNT.4.64.1501112342160.7768@Fly3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
	Timothy.McCaffrey@Unisys.com
To: Timothy McCaffrey <timcaffrey420@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56577 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbAML1Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 06:27:16 -0500
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.64.1501112342160.7768@Fly3>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 11, 2015 at 11:48:08PM -0500, Timothy McCaffrey wrote:
>
> I created this diff from a git clone of crypto-2.6.git.

Sorry, but your patch doesn't apply against either crypto or
cryptodev.  I get

$ git apply ~/p
/home/gondolin/herbert/p:48: trailing whitespace.
* movaps (move aligned packed single) or integer use movdqa (move double quad 
/home/gondolin/herbert/p:194: trailing whitespace.
        PSHUFB_XMM         %xmm14, %xmm\index 
/home/gondolin/herbert/p:210: space before tab in indent.
        PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
/home/gondolin/herbert/p:277: space before tab in indent.
        PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
/home/gondolin/herbert/p:419: space before tab in indent.
        PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
fatal: corrupt patch at line 704
$

Please check the patch and resubmit.  You can see exactly what
I tried to apply at

	https://patchwork.kernel.org/patch/5608031/

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
