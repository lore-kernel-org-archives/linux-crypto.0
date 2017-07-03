From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Mon, 3 Jul 2017 20:33:44 +0800
Message-ID: <20170703123344.GB30067@gondor.apana.org.au>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
 <20170623084330.GA30353@gondor.apana.org.au>
 <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
 <ea4d8991-7452-053e-8e53-8dcb6d28f69d@linux.intel.com>
 <E31A9F2A86F5F543BC6B7554E63385C5504A413B@fmsmsx115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Jan Stancek <jstancek@redhat.com>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Locktyukhin, Maxim" <maxim.locktyukhin@intel.com>,
        "Zohar, Ronen" <ronen.zohar@intel.com>,
        "mouli@linux.intel.com" <mouli@linux.intel.com>,
        "minipli@googlemail.com" <minipli@googlemail.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "marex@denx.de" <marex@denx.de>
To: "Albrekht, Ilya" <ilya.albrekht@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45476 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbdGCMe1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 08:34:27 -0400
Content-Disposition: inline
In-Reply-To: <E31A9F2A86F5F543BC6B7554E63385C5504A413B@fmsmsx115.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 24, 2017 at 12:56:52AM +0000, Albrekht, Ilya wrote:
> Hello all,
> 
> I'm sorry for late reply (I was out of office for a month).
> 
> It's been a while since we touched this code. We are going to do our best to support it. I'll be back to the office earlier next week and will figure out the fix ASAP.

Any update on this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
