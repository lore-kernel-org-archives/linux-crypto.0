From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/3] crypto: keywrap - add testmgr support
Date: Wed, 14 Oct 2015 20:44:53 +0200
Message-ID: <2368869.z13cidVPPU@tauon.atsec.com>
References: <3564891.reL3VOPkWo@tachyon.chronox.de> <2239265.sodxccK8do@tachyon.chronox.de> <20151014142623.GA17455@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34333 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbbJNSoz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 14:44:55 -0400
In-Reply-To: <20151014142623.GA17455@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 14. Oktober 2015, 22:26:24 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Sep 21, 2015 at 08:59:56PM +0200, Stephan Mueller wrote:
>> +		.iv_out	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
>> +	},
>> +};
>
>This doesn't build.  Please fix and resubmit.

Did you apply the depending patch referenced in the beginning?

https://lkml.org/lkml/2015/6/16/342

I thought I understood you wanted to pull it. If not, I will add the necessary 
code and resubmit.

Ciao
Stephan
