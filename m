From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Test tools for crypt accelerators?
Date: Wed, 5 May 2010 14:31:45 +0200
Message-ID: <20100505123145.GA6878@Chamillionaire.breakpoint.cc>
References: <q2uf861ec6f1005050502hf443a7d6mf58f68d97ce38875@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Manuel Lauss <manuel.lauss@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33415 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab0EEMbr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 May 2010 08:31:47 -0400
Content-Disposition: inline
In-Reply-To: <q2uf861ec6f1005050502hf443a7d6mf58f68d97ce38875@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Manuel Lauss | 2010-05-05 14:02:15 [+0200]:

>I've written a prototype driver for an AES accelerator; I'd like to test it
>now.  Are there any userspace tools available for this?
modprobe tcrypt mode=10

will test varios blockmodes. There is no userland interface for hw
driver atm.

>
>Thanks!
>      Manuel Lauss

Sebastian
