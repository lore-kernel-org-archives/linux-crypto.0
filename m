From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch V4] crypto: x86/sha1 : Fix reads beyond the number of
 blocks passed
Date: Wed, 9 Aug 2017 21:57:46 +0800
Message-ID: <20170809135746.GH743@gondor.apana.org.au>
References: <1501706949-24322-1-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, ilya.albrekht@intel.com, megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36844 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752652AbdHIN6B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:58:01 -0400
Content-Disposition: inline
In-Reply-To: <1501706949-24322-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 02, 2017 at 01:49:09PM -0700, Megha Dey wrote:
> It was reported that the sha1 AVX2 function(sha1_transform_avx2) is
> reading ahead beyond its intended data, and causing a crash if the next
> block is beyond page boundary:
> http://marc.info/?l=linux-crypto-vger&m=149373371023377
> 
> This patch makes sure that there is no overflow for any buffer length.
> 
> It passes the tests written by Jan Stancek that revealed this problem:
> https://github.com/jstancek/sha1-avx2-crash
> 
> I have re-enabled sha1-avx2 by reverting commit
> b82ce24426a4071da9529d726057e4e642948667
> 
> Originally-by: Ilya Albrekht <ilya.albrekht@intel.com>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> Reported-by: Jan Stancek <jstancek@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
