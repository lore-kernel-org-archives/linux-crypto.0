From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: What should be the algo priority
Date: Tue, 04 Apr 2017 14:37:02 +0200
Message-ID: <42612664.V5g4013kpk@tauon.chronox.de>
References: <CAFXBA=kTywuuZOKw6a7mj+aXtn0YcOYF=jmesuBE2L3zZmojMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58818 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdDDMhH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 08:37:07 -0400
In-Reply-To: <CAFXBA=kTywuuZOKw6a7mj+aXtn0YcOYF=jmesuBE2L3zZmojMw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 4. April 2017, 09:53:17 CEST schrieb Harsh Jain:

Hi Harsh,

> Hi,
> 
> Do we have any guidelines documented to decide what should be the
> algorithm priority. Specially for authenc implementation.Most of the
> drivers have fixed priority for all algos. Problem comes in when we
> have cbc(aes), hmac(sha1) and authenc(cbc(aes),hmac(sha1))
> implementation in driver. Base authenc driver gets more precedence
> because of higher priority(enc->base.cra_priority * 10 +
> auth_base->cra_priority;)
> 
> What should be the priority of
> cbc(aes),
> hmac(sha1)
> authenc(cbc(aes),hmac(sha1))

There is no general rule about the actual numbers. But commonly, the prios are 
set such that the prios of C implementations < ASM implementations < hardware 
accelerators. The idea is to give users the fastest implementation there is 
for his particular system.

Ciao
Stephan
