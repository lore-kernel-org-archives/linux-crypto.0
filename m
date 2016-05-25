From: Stephan Mueller <smueller@chronox.de>
Subject: Re: tcrypt failing on hmac(crc32)
Date: Wed, 25 May 2016 09:10:31 +0200
Message-ID: <15120183.LV0UqqT84Y@positron.chronox.de>
References: <20160525070752.GB6559@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34768 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbcEYHKe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 03:10:34 -0400
In-Reply-To: <20160525070752.GB6559@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 25. Mai 2016, 09:07:52 schrieb Marcus Meissner:

Hi Marcus,

> Hi,
> 
> when enabling the testmgr framework and FIPS in 4.6 and 4.4 and running
> "modprobe tcrypt"

        }, {
                .alg = "hmac(crc32)",
                .test = alg_test_hash,
...

fips_allowed = 1 missing?
> 
> [ 1153.298266] alg: hash: Failed to load transform for hmac(crc32): -2
> [ 1153.340636] tcrypt: one or more tests failed!
> 
> I spent some hours making sense of what is missing, but I got lost in the
> maze of the crypto apis between sync and async hashes somewhere.
> 
> Does anyone know the solution for this, otherwise I will need to continue
> looking.
> 
> Ciao, Marcus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
