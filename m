From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/5] crypto/nx: Create nx842_cfg_crb function
Date: Tue, 04 Apr 2017 21:12:27 +1000
Message-ID: <87fuhov338.fsf@concordia.ellerman.id.au>
References: <1491066000.29552.27.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:40953 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753679AbdDDLMe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 07:12:34 -0400
In-Reply-To: <1491066000.29552.27.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Haren Myneni <haren@linux.vnet.ibm.com> writes:

> [PATCH 2/5] crypto/nx: Create nx842_cfg_crb function
>
> Configure CRB is moved to nx842_cfg_crb() so that it can be
> used for icswx function and VAS function which will be added
> later.

Buy a vowel! :)

nx842_configure_crb() is fine.

cheers
