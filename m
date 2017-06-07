From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Can someone check linux kernel 4.4, and 4.9 rfc4309 test vectors?
Date: Wed, 07 Jun 2017 16:35:48 +0200
Message-ID: <2615074.cOq47vP5jM@tauon.chronox.de>
References: <cd81c137faef49999fbd6da538132b03@NALASEXR01F.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Zhen Kong <zkong@quicinc.com>,
        Dan Bronstein <dbronste@qti.qualcomm.com>
To: Che-Min Hsieh <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60090 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750831AbdFGOfu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 10:35:50 -0400
In-Reply-To: <cd81c137faef49999fbd6da538132b03@NALASEXR01F.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Juni 2017, 15:57:31 CEST schrieb Che-Min Hsieh:

Hi Che,

> Rfc4309 test vectors in testmgr.h have gone through major changes from
> linux3  to linux4. In linux 4.4, linux4.9, there are vectors as such

I think you and the kernel implement crypto properly. It is just the 
formatting that you do not get right.

See crypto/ccm.c:

static struct aead_request *crypto_rfc4309_crypt(struct aead_request *req)
{
...
        scatterwalk_map_and_copy(iv + 16, req->src, 0, req->assoclen - 8, 0);
...

The key is how to understand the input data format. RFC4309 CCM is no cipher 
implementation, but rather a special formatting of the CCM input data.

In your code, change the following line

>    // Add the AAD
>     EVP_EncryptUpdate(cryptCtx, 0, &outl, A, sizeof(A));

to

EVP_EncryptUpdate(cryptCtx, 0, &outl, A, sizeof(A) - 8);

and you will see consistent results.

Ciao
Stephan
