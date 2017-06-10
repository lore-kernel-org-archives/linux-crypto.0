From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] Add support for Cavium CNN55XX crypto adapters.
Date: Sat, 10 Jun 2017 12:18:36 +0800
Message-ID: <20170610041836.GI14719@gondor.apana.org.au>
References: <3575749.J6klBtBYWh@tauon.chronox.de>
 <20170530115803.8965-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Sreerama.Gadam@cavium.com,
        Ram.Kumar@cavium.com, Nidadavolu.Murthy@cavium.com,
        George.Cherian@cavium.com
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170530115803.8965-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 30, 2017 at 05:28:00PM +0530, Srikanth Jampala wrote:
> This series adds support for Cavium CNN55XX crypto adapters.
>   
>  CNN55XX crypto adapters belongs to Cavium NITROX family series,
>  able to accelerates both Symmetric and Asymmetric crypto workloads.
>  These adapters have crypto cores for Symmetric and Asymmetric
>  crypto operations, and needs to load firmware to become operational.
>  
>  Patches are generated on top of kernel/git/herbert/crypto-2.6
> 
>  The series was tested with dm-crypt for in kernel
>  cryptographic offload operations.
> 
> Changes from v1 to v2:

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
