From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] crypto: move CCP device driver to misc
Date: Thu, 19 Jan 2017 19:18:11 +0100
Message-ID: <20170119181811.GA30851@kroah.com>
References: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
 <148484928147.30852.7911360215597694759.stgit@brijesh-build-machine>
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
In-Reply-To: <148484928147.30852.7911360215597694759.stgit@brijesh-build-machine>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 19, 2017 at 01:08:01PM -0500, Brijesh Singh wrote:
> The CCP device is part of the AMD Secure Processor, which is not dedicated
> solely to crypto. Move the CCP device driver to the misc directory in
> prepration for expanding the usage of the AMD Secure Processor. Leaving the
> CCP cryptographic layer (the ccp-crypto* files) in their current directory.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/Kconfig              |   11 
>  drivers/crypto/Makefile             |    2 
>  drivers/crypto/ccp/Kconfig          |   21 
>  drivers/crypto/ccp/Makefile         |    9 
>  drivers/crypto/ccp/ccp-dev-v3.c     |  574 -----------
>  drivers/crypto/ccp/ccp-dev-v5.c     | 1021 -------------------
>  drivers/crypto/ccp/ccp-dev.c        |  588 -----------
>  drivers/crypto/ccp/ccp-dev.h        |  647 ------------
>  drivers/crypto/ccp/ccp-dmaengine.c  |  728 --------------
>  drivers/crypto/ccp/ccp-ops.c        | 1876 -----------------------------------
>  drivers/crypto/ccp/ccp-pci.c        |  354 -------
>  drivers/crypto/ccp/ccp-platform.c   |  293 -----
>  drivers/misc/Kconfig                |    1 
>  drivers/misc/Makefile               |    1 
>  drivers/misc/amd-sp/Kconfig         |   14 
>  drivers/misc/amd-sp/Makefile        |    8 
>  drivers/misc/amd-sp/ccp-dev-v3.c    |  574 +++++++++++
>  drivers/misc/amd-sp/ccp-dev-v5.c    | 1021 +++++++++++++++++++
>  drivers/misc/amd-sp/ccp-dev.c       |  588 +++++++++++
>  drivers/misc/amd-sp/ccp-dev.h       |  647 ++++++++++++
>  drivers/misc/amd-sp/ccp-dmaengine.c |  728 ++++++++++++++
>  drivers/misc/amd-sp/ccp-ops.c       | 1876 +++++++++++++++++++++++++++++++++++
>  drivers/misc/amd-sp/ccp-pci.c       |  354 +++++++
>  drivers/misc/amd-sp/ccp-platform.c  |  293 +++++
>  include/linux/ccp.h                 |    3 
>  25 files changed, 6111 insertions(+), 6121 deletions(-)
>  delete mode 100644 drivers/crypto/ccp/ccp-dev-v3.c
>  delete mode 100644 drivers/crypto/ccp/ccp-dev-v5.c
>  delete mode 100644 drivers/crypto/ccp/ccp-dev.c
>  delete mode 100644 drivers/crypto/ccp/ccp-dev.h
>  delete mode 100644 drivers/crypto/ccp/ccp-dmaengine.c
>  delete mode 100644 drivers/crypto/ccp/ccp-ops.c
>  delete mode 100644 drivers/crypto/ccp/ccp-pci.c
>  delete mode 100644 drivers/crypto/ccp/ccp-platform.c
>  create mode 100644 drivers/misc/amd-sp/Kconfig
>  create mode 100644 drivers/misc/amd-sp/Makefile
>  create mode 100644 drivers/misc/amd-sp/ccp-dev-v3.c
>  create mode 100644 drivers/misc/amd-sp/ccp-dev-v5.c
>  create mode 100644 drivers/misc/amd-sp/ccp-dev.c
>  create mode 100644 drivers/misc/amd-sp/ccp-dev.h
>  create mode 100644 drivers/misc/amd-sp/ccp-dmaengine.c
>  create mode 100644 drivers/misc/amd-sp/ccp-ops.c
>  create mode 100644 drivers/misc/amd-sp/ccp-pci.c
>  create mode 100644 drivers/misc/amd-sp/ccp-platform.c

Please create your patch with -M, to show this is a rename, or a change
with a rename.  Otherwise this is an impossible patch to review, would
you want to try to do it?

thanks,

greg k-h
