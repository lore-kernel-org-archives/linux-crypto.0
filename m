From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: Crash in crypto mcryptd
Date: Fri, 02 Dec 2016 16:16:28 -0800
Message-ID: <1480724188.3064.62.camel@linux.intel.com>
References: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:55229 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751772AbcLCAR7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 19:17:59 -0500
In-Reply-To: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-12-01 at 19:00 -0500, Mikulas Patocka wrote:
> Hi
> 
> There is a bug in mcryptd initialization.
> 
> This is a test module that tries various hash algorithms. When you load 
> the module with "insmod test.ko 'alg=mcryptd(md5)'", the machine crashes.
> 
> Mikulas
> 
> 

Mikulas,

Can you try out the patch that I've sent out in a separate mail?

Thanks.

Tim
