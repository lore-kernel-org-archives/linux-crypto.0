From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] misc: amd-sp: introduce the AMD Secure Processor
 device
Date: Thu, 19 Jan 2017 19:22:34 +0100
Message-ID: <20170119182234.GC30851@kroah.com>
References: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
 <148484929157.30852.14374439914599162367.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, lambert.quentin@gmail.com, gary.hook@amd.com,
        linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        umgwanakikbuti@gmail.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbdASSak (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2017 13:30:40 -0500
Content-Disposition: inline
In-Reply-To: <148484929157.30852.14374439914599162367.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2017 at 01:08:11PM -0500, Brijesh Singh wrote:
> The CCP device is part of the AMD Secure Processor. In order to expand the
> usage of the AMD Secure Processor, create a framework that allows functional
> components of the AMD Secure Processor to be initialized and handled
> appropriately.

What do you mean by "framework"?  What is this for?  Who is going to use
it?  Don't add framework that is not ever used, otherwise we will just
delete it.

> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/Kconfig        |    1 
>  drivers/misc/amd-sp/Kconfig       |   16 +-
>  drivers/misc/amd-sp/Makefile      |   11 +
>  drivers/misc/amd-sp/ccp-dev-v3.c  |   86 +++++-----
>  drivers/misc/amd-sp/ccp-dev-v5.c  |   72 ++++----
>  drivers/misc/amd-sp/ccp-dev.c     |  137 +++++++++-------
>  drivers/misc/amd-sp/ccp-dev.h     |   35 ----
>  drivers/misc/amd-sp/sp-dev.c      |  309 +++++++++++++++++++++++++++++++++++
>  drivers/misc/amd-sp/sp-dev.h      |  141 ++++++++++++++++
>  drivers/misc/amd-sp/sp-pci.c      |  325 +++++++++++++++++++++++++++++++++++++
>  drivers/misc/amd-sp/sp-platform.c |  269 +++++++++++++++++++++++++++++++
>  11 files changed, 1225 insertions(+), 177 deletions(-)
>  create mode 100644 drivers/misc/amd-sp/sp-dev.c
>  create mode 100644 drivers/misc/amd-sp/sp-dev.h
>  create mode 100644 drivers/misc/amd-sp/sp-pci.c
>  create mode 100644 drivers/misc/amd-sp/sp-platform.c

This patch makes no sense, you need to break it up into "do one logical
thing", as that is NOT what is happening here.  It's impossible to
review as-is, sorry.

greg k-h
