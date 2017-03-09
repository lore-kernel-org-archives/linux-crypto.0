From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 09 Mar 2017 11:27:12 +0100
Message-ID: <3772456.LI6mNYYc0j@tauon.atsec.com>
References: <13406914.zeok8basum@positron.chronox.de> <9194388.iDFJIB4SCo@tauon.atsec.com> <20170309102316.GA7027@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57954 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752926AbdCIK1g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:27:36 -0500
In-Reply-To: <20170309102316.GA7027@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. März 2017, 11:23:16 CET schrieb Herbert Xu:

Hi Herbert,

> I see.  Yes that looks good.

Thank you. I will provide an official patch after the discussion about the 
memory handling is completed.

As the memory handling patch should be considered for stable whereas the AAD 
copy patch should not, I would therefore recommend completing the memory 
handling discussion first.

Ciao
Stephan
