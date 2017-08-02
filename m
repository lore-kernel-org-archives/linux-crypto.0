From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch V2] crypto: x86/sha1 : Fix reads beyond the number of
 blocks passed
Date: Wed, 2 Aug 2017 10:29:45 +0800
Message-ID: <20170802022944.GA4237@gondor.apana.org.au>
References: <1501634312-22788-1-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, ilya.albrekht@intel.com, megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501634312-22788-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 01, 2017 at 05:38:32PM -0700, Megha Dey wrote:
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
> Jan, can you verify this fix?
> Herbert, can you re-enable sha1-avx2 once Jan has checked it out and
> revert commit b82ce24426a4071da9529d726057e4e642948667 ?

Can you please include the hunk to actually reenable sha1-avx2
in your patch? Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
