From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto-2.6] crypto: ccp: add timeout support in the SEV
 command
Date: Thu, 13 Sep 2018 13:02:52 +0800
Message-ID: <20180913050252.wvcjy7gxjzokoca4@gondor.apana.org.au>
References: <1534367485-4386-1-git-send-email-brijesh.singh@amd.com>
 <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
 <20180904051930.5kvyyu75ym5mubuz@gondor.apana.org.au>
 <ec8245a3-1620-4501-0ebd-f04dfe973bc8@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        Gary Hook <Gary.Hook@amd.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ec8245a3-1620-4501-0ebd-f04dfe973bc8@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 07:11:05PM -0500, Brijesh Singh wrote:
>
> Can you please include this patch in your next 4.19-rcX pull request?
> Multiple folks are encountering this firmware bug on Ryzen systems. I
> will submit the modified version of this patch for stable release (s) so
> that we fix issues in 4.18,.17 and .16. thank you.

OK, I will add it to the crypto tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
