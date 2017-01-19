From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] Introduce AMD Secure Processor device
Date: Thu, 19 Jan 2017 19:21:01 +0100
Message-ID: <20170119182101.GB30851@kroah.com>
References: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, lambert.quentin@gmail.com, gary.hook@amd.com,
        linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        umgwanakikbuti@gmail.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 19, 2017 at 01:07:50PM -0500, Brijesh Singh wrote:
> The CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
> which is not dedicated solely to crypto. The AMD Secure Processor includes
> CCP and PSP (Platform Secure Processor) devices.
> 
> This patch series moves the CCP device driver to the misc directory and
> creates a framework that allows functional component of the AMD Secure
> Processor to be initialized and handled appropriately.

Why the misc directory?  I don't see the justification here...

thanks,

greg k-h
