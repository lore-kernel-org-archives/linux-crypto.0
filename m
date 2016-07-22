From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [V2,1/2] powerpc: Add module autoloading based on CPU features
Date: Fri, 22 Jul 2016 15:50:42 +1000 (AEST)
Message-ID: <3rwfrf1wwxz9t0F@ozlabs.org>
References: <1468901033-28996-2-git-send-email-alastair@au1.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	paulus@samba.org, linux-crypto@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>,
	linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: Alastair D'Silva <alastair@au1.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468901033-28996-2-git-send-email-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2016-19-07 at 04:03:52 UTC, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> This patch provides the necessary infrastructure to allow drivers
> to be automatically loaded via UDEV. It implements the minimum
> required to be able to use module_cpu_feature_match to trigger
> the GENERIC_CPU_AUTOPROBE mechanisms.
> 
> The features exposed are a mirror of the cpu_user_features
> (converted to an offset from a mask). This decision was made to
> ensure that the behavior between features for module loading and
> userspace are consistent.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/4a1202765ddf4e5bb3143c0a85

cheers
