From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum algorithm
Date: Thu, 16 Mar 2017 23:54:41 +1100
Message-ID: <87tw6ttm9a.fsf@possimpible.ozlabs.ibm.com>
References: <20170315123737.20234-1-dja@axtens.net> <87y3w5jy8y.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: anton@samba.org
To: Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36695 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdCPMys (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 08:54:48 -0400
Received: by mail-pf0-f193.google.com with SMTP id r137so1911084pfr.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Mar 2017 05:54:47 -0700 (PDT)
In-Reply-To: <87y3w5jy8y.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> So although this sits in arch/powerpc, it's heavy on the crypto which is
> not my area of expertise (to say the least!), so I think it should
> probably go via Herbert and the crypto tree?

That was my thought as well. Sorry - probably should have put that in
the comments somewhere.

Regards,
Daniel
