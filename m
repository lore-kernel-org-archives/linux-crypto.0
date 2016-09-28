From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Thu, 29 Sep 2016 06:59:08 +1000
Message-ID: <20160929065908.653ec5c2@kryten>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        George Wilson <gcwilson@us.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hr2.samba.org ([144.76.82.148]:47799 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752523AbcI1U7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 16:59:25 -0400
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcelo

> This series fixes the memory corruption found by Jan Stancek in
> 4.8-rc7. The problem however also affects previous versions of the
> driver.

If it affects previous versions, please add the lines in the sign off to
get it into the stable kernels.

Anton
