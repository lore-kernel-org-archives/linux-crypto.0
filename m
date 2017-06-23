From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Fri, 23 Jun 2017 16:52:23 +0800
Message-ID: <20170623085223.GA30575@gondor.apana.org.au>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
 <20170623084330.GA30353@gondor.apana.org.au>
 <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-crypto@vger.kernel.org,
        ilya albrekht <ilya.albrekht@intel.com>,
        maxim locktyukhin <maxim.locktyukhin@intel.com>,
        ronen zohar <ronen.zohar@intel.com>, mouli@linux.intel.com,
        minipli@googlemail.com, hpa@linux.intel.com, marex@denx.de
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36040 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753734AbdFWIwp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 04:52:45 -0400
Content-Disposition: inline
In-Reply-To: <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:48:51AM -0400, Jan Stancek wrote:
>
> So I take it my workaround patch [1] is not acceptable in
> short-term as well?
> 
> [1] http://marc.info/?l=linux-crypto-vger&m=149373371023377

As we don't have a proper fix we may not be aware of the complete
scope of the problem (e.g., the overrun may go beyond 3 blocks).
As this is code that is exposed to remote entities, it would be
safest to disable it until we get a proper fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
