From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Wed, 6 Sep 2017 19:00:29 +0200
Message-ID: <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724200303.12197-3-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 24, 2017 at 03:02:39PM -0500, Brijesh Singh wrote:
> Platform Security Processor (PSP) is part of AMD Secure Processor (AMD-SP),
> PSP is a dedicated processor that provides the support for key management
> commands in a Secure Encrypted Virtualiztion (SEV) mode, along with
> software-based Tursted Executation Environment (TEE) to enable the
> third-party tursted applications.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/Kconfig   |   9 ++
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/psp-dev.c | 226 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  82 ++++++++++++++++
>  drivers/crypto/ccp/sp-dev.c  |  43 ++++++++
>  drivers/crypto/ccp/sp-dev.h  |  41 +++++++-
>  drivers/crypto/ccp/sp-pci.c  |  46 +++++++++
>  7 files changed, 447 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/psp-dev.c
>  create mode 100644 drivers/crypto/ccp/psp-dev.h

...

> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index a017233..d263ba4 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c

Hunk #1 succeeded at 24 (offset -7 lines).
checking file drivers/crypto/ccp/Makefile
Hunk #1 FAILED at 7.
1 out of 1 hunk FAILED
checking file drivers/crypto/ccp/psp-dev.c
checking file drivers/crypto/ccp/psp-dev.h
can't find file to patch at input line 414
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
|index a017233..d263ba4 100644
|--- a/drivers/crypto/ccp/sp-dev.c
|+++ b/drivers/crypto/ccp/sp-dev.c
--------------------------

What tree is that against? In any case, it doesn't apply here.

> This RFC is based on tip/master commit : 22db3de (Merge branch 'x86/mm').

$ git show 22db3de
fatal: ambiguous argument '22db3de': unknown revision or path not in the working tree.

Do you have updated version of the series which you can send out?

> @@ -67,6 +74,10 @@ struct sp_device {
>  	/* DMA caching attribute support */
>  	unsigned int axcache;
>  
> +	/* get and set master device */
> +	struct sp_device*(*get_psp_master_device)(void);
> +	void(*set_psp_master_device)(struct sp_device *);

WARNING: missing space after return type
#502: FILE: drivers/crypto/ccp/sp-dev.h:79:
+       void(*set_psp_master_device)(struct sp_device *);

Don't forget to run all patches through checkpatch. Some of the warnings
make sense.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
