Return-Path: <SRS0=Kj53=OL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:47538 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbeLBKrr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Dec 2018 05:47:47 -0500
Message-ID: <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
Subject: Re: [PATCH v2 3/6] crypto: x86/chacha20 - limit the
 preemption-disabled section
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Dec 2018 11:47:42 +0100
In-Reply-To: <20181129230217.158038-4-ebiggers@kernel.org>
References: <20181129230217.158038-1-ebiggers@kernel.org>
         <20181129230217.158038-4-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> To improve responsiveness, disable preemption for each step of the
> walk (which is at most PAGE_SIZE) rather than for the entire
> encryption/decryption operation.

It seems that it is not that uncommon for IPsec to get small inputs
scattered over multiple blocks. Doing FPU context saving for each walk
step then can slow down things.

An alternative approach could be to re-enable preemption not based on
the walk steps, but on the amount of bytes processed. This would
satisfy both users, I guess.

In the long run we probably need a better approach for FPU context
saving, as this really hurts performance-wise. For IPsec we should find
a way to avoid the (multiple) per-packet FPU save/restores in softirq
context, but I guess this requires support from process context
switching.

Best regards
Martin
