From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: cavium/nitrox - fix for command corruption
 in queue full case with backlog submissions.
Date: Sat, 25 Aug 2018 21:29:09 +0800
Message-ID: <20180825132909.koxcal2ke2eggv5i@gondor.apana.org.au>
References: <1534921852-20954-1-git-send-email-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgadam@cavium.com
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534921852-20954-1-git-send-email-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 22, 2018 at 12:40:52PM +0530, Srikanth Jampala wrote:
>      Earlier used to post the current command without checking queue full
>      after backlog submissions. So, post the current command only after
>      confirming the space in queue after backlog submissions.
> 
>      Maintain host write index instead of reading device registers
>      to get the next free slot to post the command.
> 
>      Return -ENOSPC in queue full case.
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
> Tested-by: Jha, Chandan <Chandan.Jha@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
