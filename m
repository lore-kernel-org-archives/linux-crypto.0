From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/3] Introduce AMD Secure Processor device
Date: Thu, 22 Jun 2017 15:25:40 +0200
Message-ID: <20170622132539.GA14239@localhost>
References: <20170622114204.4361-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        gary.hook@amd.com, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622114204.4361-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2017-06-22 06:42:01, Brijesh Singh wrote:
> CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
> which is not dedicated solely to crypto. The AMD Secure Processor includes
> CCP and PSP (Platform Secure Processor) devices.
> 
> This patch series adds a framework that allows functional component of the
> AMD Secure Processor to be initialized and handled appropriately. The series
> does not makes any logic modification into CCP - it refactors the code to
> integerate CCP into AMD secure processor framework.

Ok, so this is just preparation. When finished, what services will it provide
to Linux userland?
