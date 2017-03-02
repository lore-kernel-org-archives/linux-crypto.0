From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Problem with RSA test from testmgr
Date: Thu, 02 Mar 2017 07:08:49 +0100
Message-ID: <3589679.E0B746otbi@tauon.atsec.com>
References: <20170228155953.GA1732@Red> <20170301120414.GA18217@Red> <122aa2a3-e478-1a68-083a-273ceabaf2fb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35542 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdCBGd1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 01:33:27 -0500
In-Reply-To: <122aa2a3-e478-1a68-083a-273ceabaf2fb@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. März 2017, 03:15:13 CET schrieb Tadeusz Struk:

Hi Tadeusz,

> 
> 	memset(ptextp, 0, 256);
> 	memcpy(ptextp + 64 - 8, ptext_ex, plen);

I actually have tested that and it did not return the data the kernel 
implementation would return

Ciao
Stephan
